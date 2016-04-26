//
//  Beacon+CoreDataProperties.swift
//  AirportApp4
//
//  Created by iosdev on 26.4.2016.
//  Copyright © 2016 W4happiness. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Beacon {

    @NSManaged var accuracy: NSNumber?
    @NSManaged var beaconID: NSNumber?
    @NSManaged var major: NSNumber?
    @NSManaged var minor: NSNumber?
    @NSManaged var proximity: NSNumber?
    @NSManaged var uuid: NSNumber?
    @NSManaged var beaconLoc: NSManagedObject?

}
