//
//  AuthenticationManager.swift
//  Spotify_Clone
//
//  Created by Ziyad Qassem on 15/09/2024.
//

import Foundation
final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init () {}
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
   
    var  isSignedIn : Bool{
        return accessToken != nil
    }
    
    private var tokenExpiratioDate : Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken : Bool  {
        guard let expirationDate = tokenExpiratioDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes : TimeInterval = 300
        
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
 
    
    public var signInURl : URL? {
     

        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/authorize"
                let redirectURI = "https://www.facebook.com"
        let state = UUID().uuidString
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "scope", value: Constants.scope),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "show_dialog", value: "TRUE")
        ]
        
        return components.url

    }
    public func exchangeCodeForToken(code : String , completion: @escaping ((Bool) -> Void) ) {
        guard let url = URL(string: Constants.tokenAPIURl) else {
            return
        }
        var components = URLComponents()
        
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code") ,
        
        URLQueryItem(name: "code", value: code),
        
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure in encoding the token to 64 base encoding")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task  = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data,
                      error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                self?.cacheToken(result : result)
               
                completion(true)
            }
            catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
    }
    
    public func refreshAccessToken(completion : @escaping ((Bool) -> Void)) {
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        
        // refresh the user's access token
        
        guard let url = URL(string: Constants.tokenAPIURl) else {
            return
        }
        var components = URLComponents()
        
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "refresh_token") ,
        
        URLQueryItem(name: "refresh_token", value: refreshToken),
        
        URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure in encoding the token to 64 base encoding")
            completion(false)
            return
        }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task  = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data,
                      error == nil else {
                completion(false)
                return
            }
            do {
                let result = try JSONDecoder().decode(AuthenticationResponse.self, from: data)
                print("*******************")
                print("successfully  refreshed")
                print("*******************")
                self?.cacheToken(result : result)
               
                completion(true)
            }
            catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
        
    }
    
    private  func cacheToken(result : AuthenticationResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
      
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
