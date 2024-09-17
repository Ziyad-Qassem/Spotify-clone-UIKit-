//
//  AuthenticationResponse.swift
//  Spotify_Clone
//
//  Created by Ziyad Qassem on 17/09/2024.
//

import Foundation
struct AuthenticationResponse  : Decodable{
    let access_token : String
    let expires_in : Int
    let refresh_token : String?
    let scope : String
    let token_type : String
}
