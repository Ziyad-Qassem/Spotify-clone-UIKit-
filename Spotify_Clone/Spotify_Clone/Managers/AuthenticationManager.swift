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
        return nil
    }
    private var refreshToken: String? {
        return nil
    }
   
    var  isSignedIn : Bool{
        return false
    }
    
    private var tokenExpiratioDate : Date? {
        return nil
    }
    
    private var shouldRefreshToken : Bool  {
         return false
    }
 
    
    public var signInURl : URL? {
     

        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.spotify.com"
        components.path = "/authorize"
        let scope = "user-read-private"
        let redirectURI = "https://accounts.google.com/InteractiveLogin/signinchooser?continue=https%3A%2F%2Fmail.google.com%2Fmail%2Fu%2F0%2F&emr=1&followup=https%3A%2F%2Fmail.google.com%2Fmail%2Fu%2F0%2F&osid=1&passive=1209600&service=mail&ifkv=ARpgrqf1eCoDM_qucAs7y7r1hQgU5dtGodmWrdkkPGgHeQgM8-c4HF2ku1nVP6M3v1sOqMq-zTVTGw&ddm=0&flowName=GlifWebSignIn&flowEntry=ServiceLogin"
        let state = UUID().uuidString
        components.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "scope", value: scope),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "show_dialog", value: "TRUE")
        ]
        
        return components.url

    }
    public func exchangeCodeForToken(code : String , completion: @escaping ((Bool) -> Void) ) {
        
    }
//    private func refreshToken() {
//        
//    }
    
    private  func cacheToken() {
        
    }
}
