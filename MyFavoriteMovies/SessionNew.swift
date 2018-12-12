//
//  SessionNew.swift
//  MyFavoriteMovies
//
//  Created by Abdulrahman on 12/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation

struct SessionNewRequest: Encodable {
    let request_token: String
}

struct SessionNewResponse: Decodable {
    let success: Bool
    let session_id: String?
}

