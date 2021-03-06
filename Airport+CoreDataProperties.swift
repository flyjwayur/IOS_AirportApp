//
//  Airport+CoreDataProperties.swift
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

extension Airport {

    @NSManaged var airportID: NSNumber?
    @NSManaged var location: NSNumber?
    @NSManaged var name: String?
    @NSManaged var airportLoc: NSManagedObject?

}
