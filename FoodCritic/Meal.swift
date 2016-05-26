//
//  Meal.swift
//  FoodTracker
//
//  Created by Suvojit Dutta on 4/10/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit

class Meal: NSObject, NSCoding {
    // MARK: Properties
    
    var mealID: Int
    var name: String?
    var photo: UIImage?
    var rating: Int
    var restName: String?
    
    struct PropertyKey {
        static let IDKey = "ID"
        static let nameKey = "name"
        static let photoKey = "photo"
        static let ratingKey = "rating"
        static let restNameKey = "rname"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    //Mark NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(mealID, forKey: PropertyKey.IDKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeInteger(rating, forKey: PropertyKey.ratingKey)
        aCoder.encodeObject(restName, forKey: PropertyKey.restNameKey)
    }
    
    
    //Mark Convenience Init
    required convenience init?(coder aDecoder: NSCoder) {
        
        let mealID = aDecoder.decodeObjectForKey(PropertyKey.IDKey) as! Int
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        let rating = aDecoder.decodeIntegerForKey(PropertyKey.ratingKey)
        
        let restName = aDecoder.decodeObjectForKey(PropertyKey.restNameKey) as? String
        
        // Must call designated initializer.
        self.init(mealID: mealID, name: name, photo: photo, rating: rating, restName: restName!)
    }
    
    
    // MARK: Initialization
    
    init?(mealID: Int, name: String, photo: UIImage?, rating: Int, restName: String) {
        // Initialize stored properties.
        self.mealID = mealID
        self.name = name
        self.photo = photo
        self.rating = rating
        self.restName = restName
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
    }
}
