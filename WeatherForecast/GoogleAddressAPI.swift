//
//  GoogleAddressAPI.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class GoogleAddressAPI: NSObject {
    class func queryCoordinateWithZipCode(zipCode: String, onCompletion: (location: String?, coordinate: CLLocation?, error: NSError?)-> Void) {
        if let url = NSURL(string:"http://maps.googleapis.com/maps/api/geocode/json?address=\(zipCode)&sensor=false") {
            print("\(url)")
            Alamofire.request(.GET, url).response(completionHandler: { (request, response, data, error) in
                let responseJSON = JSON(data: data!).dictionary
                print("\(responseJSON)")
                if error == nil {
                    let coordlocation = responseJSON!["results"]![0]["geometry"]["location"].dictionary
                    if let lat = coordlocation?["lat"]?.double, lng = coordlocation?["lng"]?.double, nameLocation = responseJSON?["results"]![0]["formatted_address"].string {
                        let coordinate = CLLocation(latitude: lat, longitude: lng)
                        onCompletion(location: nameLocation, coordinate: coordinate, error: nil)
                    }
                    
                } else {
                    print("\(error?.localizedDescription)")
                    onCompletion(location: nil, coordinate: nil, error: error)
                }
                
                
            })
        }
    }
}
