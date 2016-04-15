//
//  WFDayViewController.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/15/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import UIKit

class WFDayViewController: UIViewController {
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    @IBAction func dontButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func forcastioButtonTapped(sender: AnyObject) {
        let url = "http://forecast.io/"
        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
    }
    var dayForcast: WFDay?
    override func viewDidLoad() {
        super.viewDidLoad()
        dayOfTheWeekLabel.text = dayForcast?.dayOfTheWeek
        iconImageView.image = UIImage(named:(dayForcast!.icon))
        sunRiseLabel.text = "Sun Rise at \(dayForcast!.sunriseTime)"
        sunSetLabel.text = "Sun Set at \(dayForcast!.sunsetTime)"
        tempMaxLabel.text = "Hi. Temp is \(dayForcast!.temperatureMax)"
        tempMinLabel.text = "Lo. Tempe is \(dayForcast!.temperatureMin)"
        humidityLabel.text = "Humidity: \(dayForcast!.humidity)"
        windSpeedLabel.text = "Wind Speed: \(dayForcast!.windSpeed)mph"
        cloudCoverLabel.text = "Cloud Cover: \(dayForcast!.windSpeed)"
        pressureLabel.text = "Pressure: \(dayForcast!.windSpeed)"
        summaryLabel.text = dayForcast?.summary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
