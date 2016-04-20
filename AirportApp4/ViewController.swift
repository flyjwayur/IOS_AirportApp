//
//  AirportMapViewController.swift
//  AirportApp
//
//  Created by iosdev on 20.4.2016.
//  Copyright © 2016 W4happiness. All rights reserved.
//

import UIKit


class ViewController: UIViewController , EILIndoorLocationManagerDelegate {
    
    @IBOutlet weak var locationView: EILIndoorLocationView!
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ESTConfig.setupAppID("airportapp4-0ty", andAppToken: "3e4dd8d8127a4d2a2b5a800036333218")
        
        self.locationManager.delegate = self
        
        let fetchLocationRequest = EILRequestFetchLocation(locationIdentifier: "classroom-b305-ver2-ajz")
        fetchLocationRequest.sendRequestWithCompletion { (location, error) in
            if let location = location {
                self.location = location
                self.locationView.backgroundColor = UIColor.clearColor()
                self.locationView.showTrace = false
                self.locationView.traceColor = UIColor.brownColor()
                self.locationView.rotateOnPositionUpdate = false
                //self.locationView.showBeacons = true
                self.locationView.locationBorderColor = UIColor.darkGrayColor()
                self.locationView.locationBorderThickness = 3
                self.locationView.drawLocation(location) //drawing where you are
                
                //locationView.drawObjectInBackground(UIView, withPosition: <#T##EILOrientedPoint#>, identifier: "map") //tells empty or not
                //locationView.drawObjectInForeground(<#T##object: UIView##UIView#>, withPosition: <#T##EILOrientedPoint#>, identifier: <#T##String#>)
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }
    
    func indoorLocationManager(manager: EILIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        print("failed to update position: \(error)")
    }
    
    func indoorLocationManager(manager:EILIndoorLocationManager!,didUpdatePosition position: EILOrientedPoint!,withAccuracy positionAccuracy: EILPositionAccuracy,
inLocation location: EILLocation!) {
        var accuracy: String!
        switch positionAccuracy {
        case .VeryHigh: accuracy = "+/- 1.00m"
        case .High:     accuracy = "+/- 1.62m"
        case .Medium:   accuracy = "+/- 2.62m"
        case .Low:      accuracy = "+/- 4.24m"
        case .VeryLow:  accuracy = "+/- ? :-("
        case .Unknown:  accuracy = "unknown"
        }
        print(String(format: "x: %5.2f, y: %5.2f, orientation: %3.0f, accuracy: %@",
            position.x, position.y, position.orientation, accuracy))
        self.locationView.updatePosition(position)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
