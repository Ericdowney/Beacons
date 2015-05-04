//
//  iBeaconsViewController.swift
//  GeoFencingTutorial
//
//  Created by Downey on 5/3/15.
//  Copyright (c) 2015 Downey. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class iBeaconsViewController: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    let uuid: String = "4234EE23-34A0-4BF7-993A-FE5574A70762"
    let treasureId: String = "com.eden.treasure"
    
    var beaconRegion: CLBeaconRegion?
    var peripheralManager: CBPeripheralManager?
    var peripheralData: NSDictionary?
    
    var locationManager: CLLocationManager?
    var previousPromixity: CLProximity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.configureNavigationBar()
        self.configureBeacon()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Configuration
    
    func configureNavigationBar() {
        self.navigationItem.title = "iBeacons"
    }
    
    func configureBeacon() {
        self.beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: self.uuid), identifier: self.treasureId)
        self.beaconRegion?.notifyEntryStateOnDisplay = true
        self.beaconRegion?.notifyOnEntry = true
        self.beaconRegion?.notifyOnExit = true
        
        self.configureTransmitter()
//        self.configureReceiver()
    }
    
    func configureTransmitter() {
        self.statusLabel.text = "Broadcasting Signal..."
        self.peripheralData = self.beaconRegion?.peripheralDataWithMeasuredPower(nil)
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: queue)
    }
    
    func configureReceiver() {
        self.statusLabel.text = "Looking for iBeacon..."
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestAlwaysAuthorization()
        self.locationManager?.startMonitoringForRegion(self.beaconRegion)
        self.locationManager?.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    // MARK: - CBPeripheral Manager Delegate
    
    // Transmitter
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if peripheral.state == .PoweredOn {
            self.peripheralManager?.startAdvertising(self.peripheralData as! [NSObject : AnyObject])
            println("Started Bluetooth Advertising")
        }
        else if peripheral.state == .PoweredOff {
            self.peripheralManager?.stopAdvertising()
            println("Stopped Bluetooth Advertising")
        }
    }
    
    // MARK: - CLLocation Manager Delegate
    
    // Receiver
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        if beacons.count == 0 {
            return;
        }
        var message = ""
        var bgColor = UIColor()
        let beacon = beacons.first as! CLBeacon
        switch (beacon.proximity) {
            case .Unknown:
                message = "No iBeacon in the vicinity."
                bgColor = UIColor.blueColor()
            case .Far:
                message = "There's an iBeacon close by."
                bgColor = UIColor.yellowColor()
            case .Near:
                message = "I'm very near to an iBeacon."
                bgColor = UIColor.orangeColor()
            case .Immediate:
                message = "I'm right next to an iBeacon."
                bgColor = UIColor.redColor()
        }
        if beacon.proximity != self.previousPromixity {
            self.statusLabel.text = message
            self.view.backgroundColor = bgColor
            self.previousPromixity = beacon.proximity
        }
    }

    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        if region.identifier == treasureId {
            self.statusLabel.text = "An iBeacon is nearby"
        }
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        if region.identifier == treasureId {
            self.statusLabel.text = "There's no iBeacon nearby."
        }
    }
}
