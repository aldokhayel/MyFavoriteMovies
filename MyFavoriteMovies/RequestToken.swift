//
//  RequestToken.swift
//  MyFavoriteMovies
//
//  Created by Abdulrahman on 11/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation

struct RequestToken: Decodable {
    let success: Bool
    let expires_at: String
    let request_token: String
}
