//
//  DataBlock.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import Foundation
import SwiftyJSON

class WFWeek : NSObject{
    var summary: String?
    var icon: String?
    var dayData: [WFDay]?
    
    init(pmSummary: String?, pmIcon: String?, pmDayData: [WFDay]?) {
        summary = pmSummary
        icon = pmIcon
        dayData = pmDayData
    }

    
    class func parseDailyForcastDataFromJSONObject(fromJSONObject: JSON) -> WFWeek? {
        let fromJSON = fromJSONObject["daily"]
        let jsonSummary = fromJSON["summary"].string
        let jsonIcon = fromJSON["icon"].string
        let jsonData = fromJSON["data"].arrayValue
        var dailyDataArray = [WFDay]()
        
        for dailyForcast in jsonData {
            let dayForcast = WFDay.parseDailyForcastDataFromJSONObject(dailyForcast)
            dailyDataArray.append(dayForcast)
        }
        
        let weekForcastData = WFWeek(pmSummary: jsonSummary, pmIcon: jsonIcon, pmDayData: dailyDataArray)
        
        return weekForcastData
    }
}