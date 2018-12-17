//
//  Account.swift
//  MyFavoriteMovies
//
//  Created by Abdulrahman on 12/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct Account: Decodable {
    let avatar: Avatar?
    let id: Int
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let include_adult: Bool
    let username: String
}

struct Avatar: Decodable {
    let gravatar: Gravatar?
}

struct Gravatar: Decodable {
    let hash: String
}
