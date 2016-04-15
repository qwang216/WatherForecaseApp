//
//  DataPoint.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import Foundation
import SwiftyJSON

class WFDay: NSObject {
    var summary: String
    var dayOfTheWeek: String
    var sunriseTime: String
    var sunsetTime: String
    var icon: String
    var moonPhase: Float
    var precipProbability: Float
    var temperatureMin: Float
    var temperatureMax: Float
    var humidity: Float
    var windSpeed: Float
    var cloudCover: Float
    var pressure: Float
    
    
    
    init(pmsummary: String?,
         pmdayOfTheWeek: String?,
         pmsunriseTime: String?,
         pmsunsetTime: String?,
         pmIcon: String?,
         pmmoonPhase: Float?,
         pmprecipProbability: Float?,
         pmtemperatureMin: Float?,
         pmtemperatureMax: Float?,
         pmhumidity: Float?,
         pmwindSpeed: Float?,
         pmcloudCover: Float?,
         pmpressure: Float?) {
        
        summary = pmsummary!
        dayOfTheWeek = pmdayOfTheWeek!
        sunriseTime = pmsunriseTime!
        sunsetTime = pmsunsetTime!
        icon = pmIcon!
        moonPhase = pmmoonPhase!
        precipProbability = pmprecipProbability!
        temperatureMin = pmtemperatureMin!
        temperatureMax = pmtemperatureMax!
        humidity = pmhumidity!
        windSpeed = pmwindSpeed!
        cloudCover = pmcloudCover!
        pressure = pmpressure!
        
    }
    
    class func parseDailyForcastDataFromJSONObject(fromJSON: JSON) -> WFDay {
        var jsonSumary: String = ""
        if let jsonSum = fromJSON["summary"].string {
            jsonSumary = jsonSum
        }
        
        var jsonDOTW: String = ""
        if let jsonTime = fromJSON["time"].double {
            jsonDOTW = NSDate().getDayOfWeek(jsonTime)!
        }
        
        var jsonsunrisetime: String = ""
        if let jsonSR = fromJSON["sunriseTime"].double {
            jsonsunrisetime = NSDate().timeStringFromUnixTime(jsonSR)
        }
        
        var jsonsunsettime: String = ""
        if let jsonSS = fromJSON["sunsetTime"].double {
            jsonsunsettime = NSDate().timeStringFromUnixTime(jsonSS)
        }
        
        var jsonMoonPhase: Float = 0
        if let moonPhase = fromJSON["moonPhase"].float {
            if moonPhase == 0 {
                jsonMoonPhase = 0
            } else if moonPhase < 0.26 || moonPhase > 0 {
                jsonMoonPhase = 0.25
            } else if moonPhase < 0.51 || moonPhase > 0.25 {
                jsonMoonPhase = 0.5
            } else if moonPhase < 0.76 || moonPhase > 0.50 {
                jsonMoonPhase = 0.75
            } else {
                jsonMoonPhase = 1
            }
        }
        var jsonIcon: String = ""
        if let jsonI = fromJSON["icon"].string {
            jsonIcon = jsonI
        }
        var jsonPrecipProbability: Float = 0
        if let jsonPrecipProb = fromJSON["precipProbability"].float {
            jsonPrecipProbability = jsonPrecipProb
        }
        
        var jsontemperatureMin: Float = 0
        if let jsontempMin = fromJSON["temperatureMin"].float {
            jsontemperatureMin = jsontempMin
        }
        
        var jsonTemperatureMax: Float = 0
        if let jsonTempMax = fromJSON["temperatureMax"].float {
           jsonTemperatureMax = jsonTempMax
        }
        
        var jsonHumidity: Float = 0
        if let jsonHum = fromJSON["humidity"].float {
            jsonHumidity = jsonHum
        }
        
        var jsonWindSpeed: Float = 0
        if let jsonWindSd = fromJSON["windSpeed"].float {
            jsonWindSpeed = jsonWindSd
        }
        
        var jsonCloudCover: Float = 0
        if let jsonCC = fromJSON["cloudCover"].float {
            jsonCloudCover = jsonCC
        }
        
        var jsonPressure: Float = 0
        if let jsonPress = fromJSON["pressure"].float {
            jsonPressure = jsonPress
        }
        
        let forcastDay = WFDay(pmsummary: jsonSumary, pmdayOfTheWeek: jsonDOTW, pmsunriseTime: jsonsunrisetime, pmsunsetTime: jsonsunsettime, pmIcon: jsonIcon, pmmoonPhase: jsonMoonPhase, pmprecipProbability: jsonPrecipProbability, pmtemperatureMin: jsontemperatureMin, pmtemperatureMax: jsonTemperatureMax, pmhumidity: jsonHumidity, pmwindSpeed: jsonWindSpeed, pmcloudCover: jsonCloudCover, pmpressure: jsonPressure)
        
        return forcastDay
    }
    
}

extension NSDate {
    func getDayOfWeek(unixTime: Double) -> String? {
        let dateOfTheWeek = NSDate(timeIntervalSince1970: unixTime)
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        if let myComponents = myCalendar?.components(.Weekday, fromDate: dateOfTheWeek) {
            let weekDay = myComponents.weekday
            switch weekDay {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednesday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                print("Error fetching days")
                return "N/A"
            }
        } else {
            return nil
        }
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
}