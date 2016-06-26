//
//  MealDataManager.swift
//  FoodCritic
//
//  Created by Suvojit Dutta on 5/7/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit

class MealDataManager  {
    
 /*
    //Mark Properties
    
    var databasePath: NSURL!
    
    var mealDB: FMDatabase!
    
    var photopath: String!
    
    var actionResponse: ActionResponse
   
    
    // MARK: Initialization
    
    init?(databasePath: NSURL!, mealDB: FMDatabase, photopath: String!, actionResponse: ActionResponse) {
        self.databasePath = databasePath
        self.mealDB = mealDB
        self.photopath = photopath
        self.actionResponse = actionResponse
    
    }
    */
    
    func MealDatabaseSetUp () -> FMDatabase {
    
        var mealDB: FMDatabase?
        
    let filemgr = NSFileManager.defaultManager()
    let dirPaths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    
    let docsDir = dirPaths
    
     let databasePath = docsDir.URLByAppendingPathComponent("meals.db")
    
    if !filemgr.fileExistsAtPath(databasePath.path!) {
        
        mealDB = FMDatabase(path: databasePath.path!)
        
        if mealDB == nil {
            print("Error: \(mealDB!.lastErrorMessage())")
        }
        
        if mealDB!.open() {
            
            let sql_stmt = "CREATE TABLE IF NOT EXISTS MEALS (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, PHOTOPATH TEXT, RATING INT, RESTNAME TEXT)"
            if !mealDB!.executeStatements(sql_stmt) {
                print("Error: \(mealDB!.lastErrorMessage())")
            }
            
            let sql_stmt1 = "CREATE TABLE IF NOT EXISTS RESTAURANT (ID1 INTEGER PRIMARY KEY AUTOINCREMENT, MEALID INTEGER, STREET TEXT, CITY TEXT, STATE TEXT, ZIP TEXT, DATE TEXT)"
            if !mealDB!.executeStatements(sql_stmt1) {
                print("Error: \(mealDB!.lastErrorMessage())")
            }
            
            mealDB!.close()
        
        } else {
            print("Error: \(mealDB!.lastErrorMessage())")
        }
    }else{
        mealDB = FMDatabase(path: databasePath.path!)
        }
        return mealDB!
    
    }
    
    
    func SaveMealData(mealDB: FMDatabase, meal: Meal) -> ActionResponse {
        
//        let mealDB = FMDatabase(path: databasePath.path!)
        
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        
        if mealDB.open() {
            
            let imagename: String = meal.name!
            var image: UIImage
            if meal.photo == nil {
                image = UIImage(named: "noimage")!
            }else {
                image = meal.photo!
            }
            let imagePath = fileInDocumentsDirectory(imagename + ".png")
            if !saveImage(image, path: imagePath) {
                actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Photo not saved successfully")!
                print("Error: Photo not saved successfully")
                // identify photo not saved
            }else{
  //              let insertSQL = "INSERT INTO MEALS (name, photopath, rating) VALUES ('\(meal.name)', '\(imagePath)', '\(meal.rating)')"
                let insertSQL = "INSERT INTO MEALS (name, photopath, rating, restname) VALUES (?, ?, ?, ?)"
            
 //               let result = mealDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
                let result = mealDB.executeUpdate(insertSQL, withArgumentsInArray: [meal.name!, imagePath, meal.rating, meal.restName!])
            
                if !result {
                    actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Meal not saved successfully")!
                    print("Error: \(mealDB.lastErrorMessage())")
                } else {
                
                    actionResponse = ActionResponse(responseCode: "n", responseDesc: "Success")!
                
                }
            }
            
        } else {
            actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Issue with opening database")!
            print("Error: \(mealDB.lastErrorMessage())")
        }
        
        return actionResponse!
        
    }
    
    
        
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
        
    func fileInDocumentsDirectory(filename: String) -> String {
            
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
            
    }
        
    func saveImage (image: UIImage, path: String ) -> Bool {
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func loadMealData(mealDB: FMDatabase) -> [Meal] {
        
        var mealArray: [Meal] = [Meal]()
        
 /*       let filemgr = NSFileManager.defaultManager()
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
 //       let docsDir = dirPaths[0]
        
//        databasePath = docsDir.stringByAppendingPathComponent("vmd_db.db")
        
        let myDatabase = FMDatabase(path: databasePath.path)  */
        
        if mealDB.open() {
            
            let query_lab_test = "SELECT * FROM MEALS"
            
            let results_lab_test:FMResultSet? = mealDB.executeQuery(query_lab_test, withArgumentsInArray: nil)
            
            while results_lab_test?.next() == true {
                let mealID = results_lab_test?.longForColumn("ID")
                let name = results_lab_test?.stringForColumn("NAME")
                let imagepath = results_lab_test?.stringForColumn("PHOTOPATH")
                let rating = results_lab_test?.longForColumn("RATING")
                var restname = results_lab_test?.stringForColumn("RESTNAME")
                if restname == nil {
                    restname = " "
                }
                
                    let image: UIImage? = loadImage(imagepath!)!
                    let meal = Meal(mealID: mealID!, name :name!, photo: image, rating :rating!, restName: restname!)
                    mealArray.append(meal!)
                
                
                }
            if mealArray.count == 0 {
                let photo1 = UIImage(named: "noimage")!
                let meal = Meal(mealID: 1, name: "Add new meal", photo: photo1, rating: 0, restName: "Not found")!
                mealArray.append(meal)

            }
                
            }
        
            return mealArray
        }
        
        
        
        func loadImage(path: String) -> UIImage? {
            
            var image: UIImage? = UIImage(contentsOfFile: path)
            
            if image == nil {
                
                print("missing image at: \(path)")
                
                    image = UIImage(named: "noimage")

            }
            print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
            return image
        
    }
    
    
    func deleteMealData(mealDB: FMDatabase, meal: Meal) -> ActionResponse
    {
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        if mealDB.open() {
        
            mealDB.executeUpdate("DELETE FROM MEALS WHERE ID = ?", withArgumentsInArray: [meal.mealID])
        
            mealDB.close()
            
            let imagepath = fileInDocumentsDirectory(meal.name! + ".png")
            deleteImage(imagepath)
        
        } else {
            actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Meal is not deleted")!
        }
        return actionResponse!
    }
    
    func updateMealData(mealDB: FMDatabase, meal: Meal) -> ActionResponse {
        
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        
        if mealDB.open() {
            
            var filePath: String
            let photo: UIImage = meal.photo!
            
            let mealName = checkIfMealExists(mealDB, meal: meal)
            if (mealName == "name") {
                actionResponse = ActionResponse(responseCode: "Y", responseDesc: "This is default meal. Add new meal")!
            }else {
                
            if mealName == meal.name {
                
                //get path pointing to document directory
                filePath = fileInDocumentsDirectory(mealName + ".png")
                updateImage(filePath, photo: photo)
            }else{
                filePath = fileInDocumentsDirectory(meal.name! + ".png")
                saveImage(photo, path: filePath)
            }
            let result = mealDB.executeUpdate("UPDATE MEALS SET NAME = ?, PHOTOPATH = ?, RATING = ?, RESTNAME = ? WHERE ID = ?", withArgumentsInArray: [meal.name!, filePath, meal.rating, meal.restName!, meal.mealID])
            
            if !result {
                actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Meal not saved successfully")!
                print("Error: \(mealDB.lastErrorMessage())")
            } else {
                
                actionResponse = ActionResponse(responseCode: "n", responseDesc: "Success")!
                
            }

            
        }
        }
        
        return actionResponse!
    }

    
    func checkIfMealExists(mealDB: FMDatabase, meal: Meal) -> String {
    
        var name: String?
        
        if mealDB.open() {
    
          let results_lab_test:FMResultSet? = mealDB.executeQuery("SELECT * FROM MEALS WHERE ID = ?", withArgumentsInArray: [meal.mealID])
    
          while results_lab_test?.next() == true {
    
            name = results_lab_test?.stringForColumn("NAME")
        
            }
    
    
    }
        if (name == nil) {
            name = "name"
        }
        
        return name!
    
    }


func updateImage(filePath: String, photo: UIImage) {

        
        // We could try if there is file in this path (.fileExistsAtPath())
        // BUT we can also just call delete function, because it checks by itself
    let fileManager = NSFileManager.defaultManager()
    // Delete 'hello.swift' file
    
    do {
        let pngImageData1 = UIImagePNGRepresentation(photo)
        if pngImageData1 != nil {
        try fileManager.removeItemAtPath(filePath)
        }
    }
    catch let error as NSError {
        print("Ooops! Something went wrong: \(error)")
    }
				

//    NSFileManager.defaultManager().removeItemAtPath(filePath, error:NULL)
    
        // Resize image as you want
        let pngImageData = UIImagePNGRepresentation(photo)
        
        // Write new image
    if pngImageData != nil {
        pngImageData!.writeToFile(filePath, atomically: true)
    }
 /*
        // Save your stuff to
        NSUserDefaults.standardUserDefaults().setObject(stickerName, forKey: self.stickerUsed)
        NSUserDefaults.standardUserDefaults().synchronize()
 */
    }
    
    func deleteImage(imagepath: String) {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(imagepath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
    
    
    func SaveRestaurantData(mealDB: FMDatabase, rest: Restaurant) -> ActionResponse {
        
        //        let mealDB = FMDatabase(path: databasePath.path!)
        
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        
        if mealDB.open() {
            
            let rID = rest.rID
            let mID = rest.mID
            let rAddress = rest.rAddress!
            let rCity = rest.rCity!
            let rState = rest.rState!
            let rZip = rest.rZip!
            let rDate = rest.rDate!
            
            let insertSQL1 = "INSERT INTO RESTAURANT (mealid, street, city, state, zip, date ) VALUES (?, ?, ?, ?, ?, ?)"
            
            let result = mealDB.executeUpdate(insertSQL1, withArgumentsInArray: [rest.mID!, rest.rAddress!, rest.rCity!, rest.rState!, rest.rZip!, rest.rDate!])
                
                if !result {
                    actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Restaurant not saved successfully")!
                    print("Error: \(mealDB.lastErrorMessage())")
                } else {
                    
                    actionResponse = ActionResponse(responseCode: "n", responseDesc: "Success")!
                    
                }
            
        } else {
            actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Issue with opening database")!
            print("Error: \(mealDB.lastErrorMessage())")
        }
        
        return actionResponse!
        
    }


    func loadRestaurantData(mealDB: FMDatabase, mID: Int) -> Restaurant {
        
        var restaurant: Restaurant = Restaurant(rID: 1, mID: mID, rAddress: "Not found", rCity: "Not found", rState: "Not found", rZip: "Not found", rDate: "Not found")!
        
        if mealDB.open() {
            
            let results_lab_test:FMResultSet? = mealDB.executeQuery("SELECT * FROM RESTAURANT WHERE MEALID = ?", withArgumentsInArray: [mID])
            
            while results_lab_test?.next() == true {
                
                let id1 = results_lab_test?.longForColumn("ID1")
                let mid = results_lab_test?.longForColumn("MEALID")
                let address = results_lab_test?.stringForColumn("STREET")
                let city = results_lab_test?.stringForColumn("CITY")
                let state = results_lab_test?.stringForColumn("STATE")
                let zip = results_lab_test?.stringForColumn("ZIP")
                let date = results_lab_test?.stringForColumn("DATE")
                
                restaurant = Restaurant(rID: id1!, mID: mid!, rAddress: address!, rCity: city!, rState: state!, rZip: zip!, rDate: date!)!
            }
        }
        
        return restaurant
    
}

    func deleteRestaurantData(mealDB: FMDatabase, mID: Int) -> ActionResponse
    {
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        if mealDB.open() {
            
            mealDB.executeUpdate("DELETE FROM RESTAURANT WHERE MEALID = ?", withArgumentsInArray: [mID])
            
            mealDB.close()
            
        } else {
            actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Restaurant is not deleted")!
        }
        return actionResponse!
    }

    func updateRestaurantData(mealDB: FMDatabase, rest: Restaurant) -> ActionResponse {
        
        var actionResponse = ActionResponse(responseCode: "n", responseDesc: "")
        
        if mealDB.open() {
            
            let result = mealDB.executeUpdate("UPDATE RESTAURANT SET STREET = ?, CITY = ?, STATE = ?, ZIP = ? WHERE MEALID = ?", withArgumentsInArray: [rest.rAddress!, rest.rCity!, rest.rState!, rest.rZip!, rest.mID!])
                
                if !result {
                    actionResponse = ActionResponse(responseCode: "Y", responseDesc: "Location not saved successfully")!
                    print("Error: \(mealDB.lastErrorMessage())")
                } else {
                    
                    actionResponse = ActionResponse(responseCode: "n", responseDesc: "Success")!
                    
                }
                
                
            }
        
        return actionResponse!
    }
    
    func justsavedMealID(mealDB: FMDatabase) -> Int {
        
        var mlID: Int = 1
        
        if mealDB.open() {
            
            let results_lab_test:FMResultSet? = mealDB.executeQuery("SELECT * FROM MEALS ORDER BY ID DESC LIMIT 1", withArgumentsInArray: nil)
            
            while results_lab_test?.next() == true {
                
                mlID = (results_lab_test?.longForColumn("ID"))!
                
            }
        }

        
        return mlID
    }


}
