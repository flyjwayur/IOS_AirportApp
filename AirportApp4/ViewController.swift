//
//  AirportMapViewController.swift
//  AirportApp
//
//  Created by iosdev on 20.4.2016.
//  Copyright © 2016 W4happiness. All rights reserved.
//

//map

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate,EILIndoorLocationManagerDelegate {
    
    //Mark : Location variables
    @IBOutlet weak var locationView: EILIndoorLocationView!
    let locationManager = EILIndoorLocationManager()
    var location: EILLocation!
    var currentPosition: EILOrientedPoint!
  //  let imageGreenDot = UIImage(named:)
    
    //Mark : Data variables
    @IBOutlet weak var pasName: UITextField?
    @IBOutlet weak var pasbTime: UITextField?
    @IBOutlet weak var theTimer: UILabel!
    
    var currentDate : NSDate = NSDate()
    var realtime : NSDate = NSDate()
    var remainingTime : NSTimeInterval = NSTimeInterval()
 
//    
//    func hoursFrom(currentDate : NSDate, realtime:NSDate) -> Int
//    {
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: realtime, toDate: currentDate, options: nil).hour
//    }
    
    
    
    
    @IBAction func saveBtn(sender: UIButton) {
        
//        var chosenDate = pasbTime?.text
//        var dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "HH:mm:ss"
//        var datefromString = dateFormatter.dateFromString(chosenDate!)
        
        //let chosentDate = NSDateFormatter()
        //chosenDate.dateFormat = "HH:mm:ss"
        //let date = dateFormatter.dateFromString
        
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext
        
        var newPassanger = NSEntityDescription.insertNewObjectForEntityForName("Passenger", inManagedObjectContext: context) as! NSManagedObject
        newPassanger.setValue(pasName!.text, forKey: "name")
        print("realtime\(realtime)")
        newPassanger.setValue(realtime, forKey: "boardingTime")
        
        try! context.save()
        print(newPassanger)
    }
    

    @IBAction func loadBtn(sender: UIButton) {
        closeKB()
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        var context:NSManagedObjectContext = appDel.managedObjectContext
        var request = NSFetchRequest(entityName: "Passenger")
        request.returnsObjectsAsFaults = false;
        
        var results:NSArray
        
        do {
            results = try context.executeFetchRequest(request)
            
            if(results.count > 0){
                for res in results {
                    print(res)
                }
            } else {
                print("0 results returned")
            }
            
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    func refreshFld(){
        pasName!.text = ""
        pasbTime!.text = "" //??
    }

    // MARK : UIDatePicker
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func textFieldEditting(sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.timeZone = NSTimeZone.localTimeZone()
        
        sender.inputView = datePickerView
        
        print("inputView \(datePickerView)")
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)

    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "HH:mm:ss"
        
        dateFormatter.timeZone = NSTimeZone(name: "GMT+03:00")
        
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
     //   pasbTime!.text = dateFormatter.stringFromDate(sender.date)
        let dateString = dateFormatter.stringFromDate(sender.date)
        
        print( "sender dateString,\(dateString)")
        print( "sender date,\(sender.date)")
        
        realtime = sender.date
        remainingTime = realtime.timeIntervalSinceDate(currentDate)
        print("remainingTime,\(remainingTime)")
        let hours = floor(remainingTime/3600)
        let minutes = floor(remainingTime/60-hours*60)
    //  let seconds = round(remainingTime - hours*3600 - minutes*60)
        print("Hours:\(hours) Minute: \(minutes)")
        
    }
    
    // MARK: Helper functions
    
    func closeKB(){
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        closeKB()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Data delegate
        pasbTime?.delegate = self
        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target:Selector("update"), selector: Selector, userInfo: nil, repeats:true)
        
        //Mark : Location configuration
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
                
                let point1 = EILOrientedPoint(x: 0.5, y:0.5, orientation: 0)
                let point2 = EILOrientedPoint(x: 3, y:0.5, orientation: 0)
           //     self.locationView.drawObjectInBackground(<#T##object: UIView##UIView#>, withPosition: <#T##EILOrientedPoint#>, identifier: <#T##String#>)
                self.locationManager.startPositionUpdatesForLocation(self.location)
            } else {
                print("can't fetch location: \(error)")
            }
        }
    }
    
    func update() {
        if(remainingTime > 0) {
            theTimer.text = String(remainingTime--)
        }
    }
    
//    func timer(){
//        var seconds: NSTimeInterval = NSTimeInterval()
//        var minutes :NSTimeInterval = NSTimeInterval()
//        seconds = remainingTime % 60
//        minutes = (remainingTime - seconds)/60
//        theTimer.text =
//    
//    }
    
    func updateSmartRouting(){
        var route = UIBezierPath()
        let startPoint = locationView.calculatePicturePointFromRealPoint(currentPosition)
        route.moveToPoint(startPoint)
        
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
