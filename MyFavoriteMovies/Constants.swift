//
//  Constants.swift
//  MyFavoriteMovies
//
//  Created by Abdulrahman on 11/12/2018.
//  Copyright © 2018 Abdulrahman. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct TMDB: Codable {
        static let Scheme = "https"
        static let Host = "api.themoviedb.org"
        static let Path = "/3"
    }
    
    struct TMDBParametersKeys: Codable {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Username = "username"
        static let Password = "password"
    }
    
    struct TMDBParametersValues: Codable {
        static let ApiKey = "48872b484d03e52a8d747f1acc142502"
    }
    
    struct TMDBResponseKeys: Codable {
        static let Title = "title"
        static let ID = "id"
        static let PosterPath = "poster_path"
        static let StatusCode = "status_code"
        static let StatusMessage = "status_message"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Success = "success"
        static let UserID = "id"
        static let Results = "results"
    }
    
    struct UI: Codable {
        static let LoginColorTop = UIColor(red: 0.345, green: 0.839, blue: 0.988, alpha: 1.0).cgColor
        static let LoginColorBottom = UIColor(red: 0.023, green: 0.569, blue: 0.910, alpha: 1.0).cgColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    
}
