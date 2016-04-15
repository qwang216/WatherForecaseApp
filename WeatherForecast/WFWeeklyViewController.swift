//
//  WTWeeklyViewController.swift
//  WeatherForecast
//
//  Created by Jason Wang on 4/14/16.
//  Copyright © 2016 Jason Wang. All rights reserved.
//

import UIKit
import CoreLocation
import SDWebImage

class WFWeeklyViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentDateSummary: UILabel!
    
    var weekForcastObj: WFWeek?
    var dailyForcast = [WFDay]()
    var locationManager: CLLocationManager?
    var deviceLocation: CLLocation?
    
    @IBAction func grabCurrentLocationButtonTapped(sender: UIButton) {
        alertViewForWeatherLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionViewConstrains()
        
        let location = CLLocation(latitude: 40.7128, longitude: -74.0059)
        queryForcastBaseCurrentLocation(location)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCoreLocationUpdate()
    }
    
    func alertViewForWeatherLocation() {
        let alertView = UIAlertController(title: "Request for Location", message: "You can either enter a zipcode or select curent device location", preferredStyle: .Alert)
        alertView.addTextFieldWithConfigurationHandler { (textField) in
            textField.keyboardType = UIKeyboardType.NumberPad
        }
        let ok = UIAlertAction(title: "Enter", style: .Default) { (alertAction) in
            if let zipCode = alertView.textFields![0].text {
                GoogleAddressAPI.queryCoordinateWithZipCode(zipCode, onCompletion: { (location, coordinate, error) in
                    ForecastIOAPI.getForecastRequestBaseOnLocation((coordinate?.coordinate.latitude)!, lng: (coordinate?.coordinate.longitude)!, onCompletion: { (weekForcast, error) in
                        if error == nil {
                            self.currentDateSummary.text = weekForcast?.summary
                            self.currentDateLabel.text = "Over View of This Week's forcast:"
                            self.dailyForcast = (weekForcast?.dayData)!
                            self.cityLabel.text = location
                            self.collectionView.reloadData()
                        } else {
                            print("query forcase base location error = \(error)")
                        }
                    })
                })
            }

        }
        let currentLocation = UIAlertAction(title: "Device Location", style: .Default) { (action) in
            if self.deviceLocation != nil {
                self.queryForcastBaseCurrentLocation(self.deviceLocation!)
            } else {
                print("device location is nill")
            }
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertView.addAction(ok)
        alertView.addAction(currentLocation)
        alertView.addAction(cancelButton)
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    
    func setCollectionViewConstrains() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.clipsToBounds = true
        let cellxib = UINib(nibName: "WFCollectionViewCell", bundle: nil)
        collectionView.registerNib(cellxib, forCellWithReuseIdentifier: "WTCollectionViewCellID")
        
        let collectionViewLayout = WFCollectionViewFlow()
        
        collectionViewLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width - 300, self.collectionView.frame.size.height - 100)
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)

    }
    
    func queryForcastBaseCurrentLocation (location: CLLocation) {
        ForecastIOAPI.getForecastRequestBaseOnLocation(location.coordinate.latitude, lng: location.coordinate.longitude) { (weekForcast, error) in
            if error == nil {
                self.currentDateSummary.text = weekForcast?.summary
                self.currentDateLabel.text = "Over View of This Week's forcast:"
                self.dailyForcast = (weekForcast?.dayData)!
                self.cityLabel.text = "New York"
                self.collectionView.reloadData()
            } else {
                print("query forcase base location error = \(error)")
            }

        }
    }
    
    // MARK: CLLocation delegate
    
    func setupCoreLocationUpdate() {
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        locationManager!.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
        } else {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        locationManager!.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\(locations.last)")
        let newLocation = locations.last! as CLLocation
        deviceLocation = newLocation
    }
    
    // MARK: Collection View Delegate/Data Source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dailyForcast.count
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("WTCollectionViewCellID", forIndexPath: indexPath) as! WFCollectionViewCell
        cell.dayOfTheWeekLabel.text = dailyForcast[indexPath.row].dayOfTheWeek
        let hiTemp = String(dailyForcast[indexPath.row].temperatureMax)
        let lowTemp = String(dailyForcast[indexPath.row].temperatureMin)
        cell.forcastIconImageView.image = UIImage(named: dailyForcast[indexPath.row].icon)
        cell.hilowTempLabel.text = "\(lowTemp)F Lo /\(hiTemp)F Hi"
        cell.summaryLabel.text = dailyForcast[indexPath.row].summary
        
        // Configure the cell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dayForecastData = dailyForcast[indexPath.row] as WFDay
        let destinationDetailVC = storyboard?.instantiateViewControllerWithIdentifier("WFDayViewControllerSBID") as! WFDayViewController
        destinationDetailVC.dayForcast = dayForecastData
        presentViewController(destinationDetailVC, animated: true, completion: nil)
    }
}
