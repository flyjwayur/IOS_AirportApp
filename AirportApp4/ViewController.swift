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
    
    let dateFormatter = NSDateFormatter()
    var currentDate : NSDate = NSDate()
    var realtime : NSDate = NSDate()
    var remainingTime : NSTimeInterval = NSTimeInterval()
    
    //Mark: Timer
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    let userCalender = NSCalendar.currentCalendar()
    
    let requestedComponent: NSCalendarUnit = [
        NSCalendarUnit.Month,
        NSCalendarUnit.Day,
        NSCalendarUnit.Hour,
        NSCalendarUnit.Minute,
        NSCalendarUnit.Second
    ]
    
    //Mark: CountDown
    @IBOutlet weak var countDownLabel: UILabel!
    
    
//    func hoursFrom(currentDate : NSDate, realtime:NSDate) -> Int
//    {
//        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: realtime, toDate: currentDate, options: nil).hour
//    }
    
    
    //Mark : Count Down the remaining time
    func updateTime(){
        
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed times
        let minutes = UInt8(elapsedTime / 60.0) //let minutes = UInt8(remainingTime / 60.0)s
                                                //remainingTime -= (NSTimeInterval(minutes)*60)
        elapsedTime -= (NSTimeInterval(minutes)*60)
        //calculate the secondes in elapsed times
        let seconds = UInt8(elapsedTime) //let seconds = UInt8(remainingTime)
                                         //remainingTime -= NSTimeInterval(seconds)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime*100) //  let fraction = UInt8(remainingTime*100)

        //add the leading zero for miutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
       //concatenate minuets, seconds and milliseconds as assign it to the UILabel
            theTimer.text =  ("\(strMinutes):\(strSeconds):\(strFraction)")
    }
    
    
    @IBAction func Start(sender: UIButton) {
        if !timer.valid{
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        }
    }
    
    
    @IBAction func Stop(sender: UIButton) {
        timer.invalidate()
        //timer == nil
    }
    
    
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
        
        if !timer.valid{
//            let aSelector : Selector = "printTime"
//            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: aSelector, userInfo: nil, repeats: true)
//            startTime = NSDate.timeIntervalSinceReferenceDate()
            
//        let countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
//        countDownTimer.fire()
        }
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
        
        //let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        //dateFormatter.timeZone = NSTimeZone(name: "GMT+03:00")
        
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        
        pasbTime!.text = dateFormatter.stringFromDate(sender.date)
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
    
    // MARK: count down functions
//    func printTime(){
//        dateFormatter.dateFormat = "HH:mm:ss"
//        remainingTime = realtime.timeIntervalSinceDate(currentDate)
//        print("remainingTime,\(remainingTime)")
//        let hours = floor(remainingTime/3600)
//        let minutes = floor(remainingTime/60-hours*60)
//        let seconds = round(remainingTime - hours*3600 - minutes*60)
//        print("Hours:\(hours) Minute: \(minutes) Second: \(seconds)")
//        
//        //add the leading zero for hours, minutes and seconds and store them as string constants
//        let strHour = String(format: "%02d", hours)
//        let strMin = String(format: "%02d", minutes)
//        let strSec = String(format: "%02d", seconds)
//        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
//        countDownLabel.text =  ("\(strHour):\(strMin):\(strSec)")
//    
//    }
    
    func printTime(){
        //dateFormatter.dateFormat = "MM/dd/yy hh:mm:ss a"
        let startingTime = NSDate()
        let endingTime = realtime
        
        let timeDifference = userCalender.components(requestedComponent, fromDate: startingTime, toDate: endingTime, options:[])
        
        countDownLabel.text = "\(timeDifference.hour): \(timeDifference.minute):\(timeDifference.second)"
    
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
        
        let countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(printTime), userInfo: nil, repeats: true)
        countDownTimer.fire()
        print("countDownTimer,\(countDownTimer)")
        
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
