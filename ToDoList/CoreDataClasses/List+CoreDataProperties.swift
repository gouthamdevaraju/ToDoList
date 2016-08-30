//
//  List+CoreDataProperties.swift
//  
//
//  Created by Goutham Devaraju on 30/08/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension List {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var state: NSNumber?

}
