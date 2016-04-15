//
//  ForecastIOAPI.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForecastIOAPI: NSObject {
    
    class func getForecastRequestBaseOnLocation(lat: Double, lng: Double, onCompletion: (weekForcast: WFWeek?, error: NSError?) -> Void) {
        if let url = NSURL(string: "https://api.forecast.io/forecast/90bbd81206d468a90bc3a0cf890f0a85/\(lat),\(lng)") {
            print("\(url)")
            Alamofire.request(.GET, url).response(completionHandler: { (request, response, data, error) in
                if error == nil {
                    if let responseData = data {
                        let jsonData = JSON(data: responseData)
                        print("jsonData location ==> \(jsonData)")
                        let parsedResponse = WFWeek.parseDailyForcastDataFromJSONObject(jsonData)
                        onCompletion(weekForcast: parsedResponse, error: nil)
                        
                    }
                } else {
                    onCompletion(weekForcast: nil, error: error)
                }
            })
        }
        
    }
}
