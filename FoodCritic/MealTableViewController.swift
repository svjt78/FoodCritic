//
//  MealTableViewController.swift
//  FoodTracker

//
//  Created by Suvojit Dutta on 4/10/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit
import CoreLocation


class MealTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    //Mark properties
    
    var meals = [Meal]()
    
    var mealDB: FMDatabase = FMDatabase()
    
    let photo1 = UIImage(named: "thumb_IMG_1356_1024")!
    var meal: Meal = Meal(mealID: 1, name: "Unknown", photo: (photo: UIImage(named: "thumb_IMG_1356_1024")!), rating: 3, restName: "Unknown")!

    var currentSelection: Int = 0
    
    var pm: CLPlacemark?
    
    var locManager: CLLocationManager?
    
    let locationManager = CLLocationManager()
    //   self.property (nonatomic) currentSelection;
    
        // MARK: Initialization
/*
    init?(meals: [Meal] ,mealDB: FMDatabase, currentSelection: Int) {
        self.meals = meals
        self.mealDB = mealDB
        self.currentSelection = currentSelection
        
        super.init(style: .Plain)
        
    }
    */
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
/*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   */ 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Change the navigation bar background color to blue.
        navigationController!.navigationBar.barTintColor = UIColor.cyanColor()
        
        // Change the color of the navigation bar button items to white.
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        /*
         // Change the color of the navigation bar title text to yellow.
         navigationController!.navigationBar.titleTextAttributes =
         [NSForegroundColorAttributeName: UIColor.yellowColor()]
         */

        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        // Load the sample data.
        
        self.tableView.estimatedRowHeight = 100.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        //sentinel
        self.currentSelection = -1;
        
        locationManager.delegate = self
        
        let mdm: MealDataManager =  MealDataManager()
         mealDB = mdm.MealDatabaseSetUp()
        meals = mdm.loadMealData(mealDB)
        
        /*
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            // Load the sample data.
            loadSampleMeals()
        } */
    }
    /*
    
    func loadSampleMeals() {
        
        let photo1 = UIImage(named: "thumb_IMG_1356_1024")!
        let meal1 = Meal(name: "Caprese Salad", photo: photo1, rating: 4)!
        
        let photo2 = UIImage(named: "thumb_IMG_1358_1024")!
        let meal2 = Meal(name: "Chicken and Potatoes", photo: photo2, rating: 5)!
        
        let photo3 = UIImage(named: "thumb_IMG_1311_1024")!
        let meal3 = Meal(name: "Pasta with Meatballs", photo: photo3, rating: 3)!
        
        let photo4 = UIImage(named: "thumb_IMG_1288_1024")!
        let meal4 = Meal(name: "Pasta with Meatballs", photo: photo4, rating: 4)!
        
        meals += [meal1, meal2, meal3, meal4]
        
    }
    */
    
    
    override func viewWillAppear(animated: Bool) {
    
        super.viewWillAppear(animated)
        
        tableView .reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "MealTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.blackColor().CGColor
        
        // Fetches the appropriate meal for the data source layout.
        let meal = meals[indexPath.row]
        
        cell.mealID.text = String(meal.mealID)
        cell.nameLabel.text = meal.name
        cell.foodImage.image = meal.photo
        cell.mealRating.rating = meal.rating
        
        return cell
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row: Int = indexPath.row
        currentSelection = row
        
        // animate
        [tableView .beginUpdates()]
        
        [tableView .endUpdates()]
        
        
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // do things with your cell here
        
        // sentinel
        currentSelection = -1;
        
        // animate
        [tableView .beginUpdates()]
        [tableView .endUpdates()]
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.row == currentSelection) {
            return  200;
        }
        else {
            return 100;
        }
        
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ViewController, meal1 = sourceViewController.meal {
            
            meal = meal1
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
           // Update an existing meal.
                let mdm: MealDataManager = MealDataManager()
                let response: ActionResponse = mdm.updateMealData(mealDB, meal: meal)
                
                if (response.responseCode) == "Y" {
                    
                    let alertController = UIAlertController(title: "Alert!", message: response.responseDesc, preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    alertWindow.makeKeyAndVisible()
                    
                    alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                    
                }else {
                    meals = mdm.loadMealData(mealDB)
                }
//                meals[selectedIndexPath.row] = meal
//                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                
                let mdm: MealDataManager = MealDataManager()
                let response: ActionResponse = mdm.SaveMealData(mealDB, meal: meal)
                
                if (response.responseCode) == "y" {
                    
                    let alertController = UIAlertController(title: "Alert!", message: "Meal is not added", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    alertWindow.makeKeyAndVisible()
                    
                    alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                    
                    
                }else {
                        //check for internet connection 
                    
                    if Reachability.isConnectedToNetwork() == true {
                            //start concurrent thread to derive location
                        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                        dispatch_async(queue) { () -> Void in
                            self.locationManager.delegate = self
                            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                            self.locationManager.requestWhenInUseAuthorization()
                            self.locationManager.distanceFilter=kCLDistanceFilterNone;
                            self.locationManager.startUpdatingLocation()
                        }
                    } else {
                        let alertController = UIAlertController(title: "Alert!", message: "Device is not connected to Internet", preferredStyle: .Alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                        alertWindow.rootViewController = UIViewController()
                        alertWindow.windowLevel = UIWindowLevelAlert + 1;
                        alertWindow.makeKeyAndVisible()
                        
                        alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)

                    }

                   meals = mdm.loadMealData(mealDB)
                    
                }
                
 //               let newIndexPath = NSIndexPath(forRow: meals.count, inSection: 0)
                
 //               meals.append(meal)
                
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the meals.
//            saveMeals()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            let mealDetailViewController = segue.destinationViewController as! ViewController
            
            // Get the cell that generated this segue.
            if let selectedMealCell = sender as? MealTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedMealCell)!
                let selectedMeal = meals[indexPath.row]
                mealDetailViewController.meal = selectedMeal
            }
        }
        else if segue.identifier == "AddItem" {
            print("Adding new meal.")
        }
    }
    
    //Delete operation
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let mdm: MealDataManager = MealDataManager()
            let mealItem = meals[indexPath.row]
            let response: ActionResponse = mdm.deleteMealData(mealDB, meal: mealItem)
            if (response.responseCode) == "y" {
                
                let alertController = UIAlertController(title: "Alert!", message: "Meal is not deleted", preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                
                alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
            
            }else {
                //delete location info for deleted meal
                let mdm: MealDataManager =  MealDataManager()
                let mealDB = mdm.MealDatabaseSetUp()
                let mID = mealItem.mealID
                let response: ActionResponse = mdm.deleteRestaurantData(mealDB, mID: mID)
                
                if (response.responseCode) == "y" {
                    
                    let alertController = UIAlertController(title: "Alert!", message: "Restaurant reference is not deleted", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    alertWindow.makeKeyAndVisible()
                    
                    alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                }else {
                
                //refresh table view
                meals.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                meals = mdm.loadMealData(mealDB)
                }
            }

 /*
            // Delete the row from the data source
            meals.removeAtIndex(indexPath.row)
            saveMeals()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
 */
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    //Mark NScoding
    
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meal.ArchiveURL.path!) as? [Meal]
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [CLLocation]) {
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()

        
        //--- CLGeocode to get address of current location ---//
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                let pm = placemarks![0] as CLPlacemark
                self.locManager = manager
                self.saveLocationInfo(pm, meal: self.meal)
                
            }
            else
            {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    func saveLocationInfo(placemark: CLPlacemark?, meal: Meal) {
        
        if let containsPlacemark = placemark
        {
            //get the mealID just saved
            let mdm: MealDataManager =  MealDataManager()
            let mealDB = mdm.MealDatabaseSetUp()
            let id: Int = mdm.justsavedMealID(mealDB)
            
            //get address compoents from geocoder
            let street = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare : "Not found"
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : "Not found"
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : "Not found"
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : "Not found"
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : "Not found"
            
            print(street)
            print(locality)
            print(postalCode)
            print(administrativeArea)
            //           print(country)
            
            //create restaurant object
            let rest = Restaurant(rID: 1, mID: id, rAddress: street, rCity: locality, rState: administrativeArea, rZip: postalCode)
            
//            let mdm: MealDataManager =  MealDataManager()
//            let mealDB = mdm.MealDatabaseSetUp()
            
            //save restaurant object and handle any error
            let response: ActionResponse = mdm.SaveRestaurantData(mealDB, rest: rest!)
            
            if (response.responseCode) == "Y" {
                
                let alertController = UIAlertController(title: "Alert!", message: response.responseDesc, preferredStyle: .Alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                
                let alertWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                
                alertWindow.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
                
                
            }
            
            
        }
        
    }
    
}
