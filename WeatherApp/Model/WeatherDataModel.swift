//
//  WeatherDataModel.swift
//  WeatherApp
//
//  Created by Johnny Young on 7/23/18.
//  Copyright © 2018 Johnny Young. All rights reserved.
//

import Foundation

class WeatherDataModel {
    
    var temperture : Int = 0
    var condition : Int = 0
    var weatherConditionString: String = ""
    var city : String = ""
    var weatherBackgroundName : String = ""
    
    func updateWeatherBackground(condition: Int) -> String {
        
        switch condition {
            
        case 200...232:
            return "raining"
        case 300...321:
            return "raining"
        case 500...531:
            return "raining"
        case 600...622:
            return "snow"
        case 700...781:
            return "rodion-kutsaev-82627"
        case 800:
            return "blueskies"
        case 801...804:
            return "rodion-kutsaev-82627"
        default:
            return "It's raining cats"
        }
    }
}
