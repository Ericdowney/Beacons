//
//  ViewController.swift
//  GeoFencingTutorial
//
//  Created by Downey on 4/28/15.
//  Copyright (c) 2015 Downey. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GeofenceViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    
    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureNavigationBar()
        self.configureLocationManager()
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    
    func configureNavigationBar() {
        self.navigationItem.title = "Geofencing"
    }
    
    func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - Actions
    
    @IBAction func getLocation(sender: AnyObject) {
        let available = CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
    }
    
    @IBAction func regionMonitoring(sender: AnyObject) {
        self.locationManager?.requestAlwaysAuthorization()
        
        let currentCoordinates = self.locationManager?.location.coordinate
        let currRegion = CLCircularRegion(center: currentCoordinates!, radius: 50, identifier: "Home")
        self.locationManager?.startMonitoringForRegion(currRegion)
        
        let lat: CLLocationDegrees = 0.58
        let long: CLLocationDegrees = 0.58
        var coordRegion: MKCoordinateRegion? = MKCoordinateRegionMake(currentCoordinates!, MKCoordinateSpanMake(lat, long))
        self.mapView.setRegion(coordRegion!, animated: true)
        
        let alert = UIAlertController(title: "Region Monitoring Started", message: "Started monitoring region at \(currentCoordinates?.latitude) \(currentCoordinates?.longitude).", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Map View
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
            mapView.centerCoordinate = userLocation.location.coordinate
    }
    
    // MARK: - CLLocationManager Delegate
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        let alert = UIAlertController(title: "Region Monitoring", message: "Did Enter Region", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        let alert = UIAlertController(title: "Region Monitoring", message: "Did Exit Region", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        manager.stopUpdatingLocation()
        let location = locations[0] as! CLLocation
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) in
            let placeMarks = data as! [CLPlacemark]
            let loc: CLPlacemark = placeMarks[0]
            
            self.mapView.centerCoordinate = location.coordinate
            let addr = loc.locality
            self.address.text = addr
            let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
            self.mapView.setRegion(reg, animated: true)
            self.mapView.showsUserLocation = true
            
        })
    }
}

