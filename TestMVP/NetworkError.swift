//
//  NetworkError.swift
//  TestMVP
//
//  Created by Sylvan Ash on 07/08/2018.
//  Copyright © 2018 is24. All rights reserved.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case Unknown
    case IncorrectDataReturned
    case ConnectionLost
    
    var description: String {
        let text: String
        switch self {
        case .Unknown:
            text = "Unknown error occured"
        case .IncorrectDataReturned:
            text = "Incorrect data returned"
        case .ConnectionLost:
            text = "Connection to server was lost"
        }
        
        return text
    }
}
