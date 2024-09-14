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
    
    
}
