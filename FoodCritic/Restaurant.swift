//
//  Restaurant.swift
//  FoodCritic
//
//  Created by Suvojit Dutta on 5/21/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit

class Restaurant: NSObject, NSCoding {
    // MARK: Properties
    
    var rID: Int?
    var rAddress: String?
    var rCity: String?
    var rState: String?
    var rZip: String?
    
    struct PropertyKey {
        static let rIDKey = "ID"
        static let rAddressKey = "ADDRESS"
        static let rCityKey = "CITY"
        static let rStateKey = "STATE"
        static let rZipKey = "ZIP"
        
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("restaurants")
    
    //Mark NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(rID, forKey: PropertyKey.rIDKey)
        aCoder.encodeObject(rAddress, forKey: PropertyKey.rAddressKey)
        aCoder.encodeObject(rCity, forKey: PropertyKey.rCityKey)
        aCoder.encodeObject(rState, forKey: PropertyKey.rStateKey)
        aCoder.encodeObject(rZip, forKey: PropertyKey.rZipKey)
    }
    
    
    //Mark Convenience Init
    required convenience init?(coder aDecoder: NSCoder) {
        
        let rID = aDecoder.decodeObjectForKey(PropertyKey.rIDKey) as! Int
        
        let rAddress = aDecoder.decodeObjectForKey(PropertyKey.rAddressKey) as! String
        
        let rCity = aDecoder.decodeObjectForKey(PropertyKey.rCityKey) as! String
        
        let rState = aDecoder.decodeObjectForKey(PropertyKey.rStateKey) as! String
        
        let rZip = aDecoder.decodeObjectForKey(PropertyKey.rZipKey) as! String
        
        // Must call designated initializer.
        self.init(rID: rID, rAddress: rAddress, rCity: rCity, rState: rState, rZip: rZip)
    }
    
    
    // MARK: Initialization
    
    init?(rID: Int, rAddress: String?, rCity: String?, rState: String?, rZip: String?) {
        // Initialize stored properties.
        self.rID = rID
        self.rAddress = rAddress
        self.rCity = rCity
        self.rState = rState
        self.rZip = rZip
        
        super.init()
        
        // Initialization should fail if any of the below is negative.
        if rAddress!.isEmpty || (rCity?.isEmpty)! || (rState?.isEmpty)! || (rZip?.isEmpty)! {
            return nil
        }
}
}

