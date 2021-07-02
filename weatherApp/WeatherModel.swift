//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Damian on 01/07/2021.
//  Copyright © 2021 Damian. All rights reserved.
//

import Foundation

struct WeatherDay {
    let humidity: Int
    let date: String
    let minValue: Double
    let maxValue: Double
}

class WeatherModel {
    let cityName: String
    var weatherDays = [WeatherDay]()

    init(json: [String : Any]) {
        
        if let cityJson = json["city"] as? [String : Any],
        let cityName = cityJson["name"] as? String,
        let listJson = json["list"] as? [[String : Any]] {
            self.cityName = cityName
            for (index, list) in listJson.enumerated() {
                if index < 5,
                    let mainJson = list["main"] as? [String : Any],
                    let humidity = mainJson["humidity"] as? Int,
                    let minValue = mainJson["temp_min"] as? Double,
                    let maxValue = mainJson["temp_max"] as? Double,
                    let date = list["dt_txt"] as? String {

                    let weatherDay = WeatherDay(humidity: humidity, date: date, minValue: minValue, maxValue: maxValue)
                    self.weatherDays.append(weatherDay)
                }
            }
        } else {
            self.cityName = ""
        }
    }
}
