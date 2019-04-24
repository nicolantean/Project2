//
//  WeatherData.swift
//  Project2
//
//  Created by Nicolas Lantean on 4/22/19.
//  Copyright © 2019 Nicolas Lantean. All rights reserved.
//

import Foundation
import Alamofire

struct Description: Codable {
    var description: String
    var mainDescription: String
    
    enum CodingKeys: String, CodingKey {
        case mainDescription = "main"
        case description
    }
}

struct Temperatures: Codable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
    }
}

struct Informes: Codable {
    let dt: Date
    let main: Temperatures
    let weather: [Description]
}

struct WeatherData {
    
    static func getData(completion: @escaping ([Informes]?, Error?) -> Void) {
        AF.request("http://api.openweathermap.org/data/2.5/forecast?id=3441575\(UserDefaults.standard.object(forKey: "units") ?? "&units=metric")&APPID=e9a84d9a7b902b325163a0b1029457f1").responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let dict = value as? [String: Any], let list = dict["list"] {
                    if let data = try? JSONSerialization.data(withJSONObject: list) {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let user = try! decoder.decode([Informes].self, from: data)
                        let data = simplifyData(data: user)
                        completion(data, nil)
                    }
                }
            case .failure(let error): completion(nil, error)
            }
        }
    }
    
    static func simplifyData(data: [Informes]) -> [Informes] {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var res = data.filter{ myCalendar.components(.hour, from: $0.dt).hour == 18 }
        
        let today = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: today)
        if hour > 18 {
            res.insert(data[0], at: 0)
        }
        return res
    }
}
