//
//  ActionResponse.swift
//  FoodCritic
//
//  Created by Suvojit Dutta on 5/7/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit

class ActionResponse  {
    
    let responseCode: String!
    let responseDesc: String?
    
    init?(responseCode: String!, responseDesc: String?) {
        self.responseCode = responseCode

        self.responseDesc = responseDesc
        
    }

    
}
