//
//  ViewController.swift
//  FoodTracker
//
//  Created by Suvojit Dutta on 4/3/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Mark properties
    //   @IBOutlet weak var mealLabel: UILabel!
    
    @IBOutlet weak var mealID: UILabel!
    
    @IBOutlet weak var mealtextField: UITextField!
    
    //    @IBOutlet weak var defaultButton: UIButton!
    
    //    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var saveMeal: UIBarButtonItem!
    
    @IBOutlet weak var ratingClass: RatingClass!
    
    var meal :Meal?
    var restName: String?
    
    @IBOutlet weak var restaurantName: UITextField!
    
    @IBOutlet weak var restaurantAddress: UILabel!
    
    @IBOutlet weak var restaurantCity: UILabel!
    
    @IBOutlet weak var restaurantState: UILabel!
    
    @IBOutlet weak var restaurantZip: UILabel!
    
    @IBOutlet weak var eventDate: UILabel!

    
    /*
     @IBAction func buttonClicked(sender: AnyObject) { //Touch Up Inside action
     defaultButton.backgroundColor = UIColor.whiteColor()
     doneButton.backgroundColor = UIColor.whiteColor()
     }
     
     @IBAction func buttonReleased(sender: AnyObject) { //Touch Down action
     defaultButton.backgroundColor = UIColor.blueColor()
     doneButton.backgroundColor = UIColor.blueColor()
     }
     
     */
    
    /*    UIImage *normalImage = [UIImage imageNamed:@"blue site page button.png"];
     
     [self.button setBackgroundImage:normal forState:UIControlStateNormal];
     [self.button setBackgroundImage:highlighted forState:UIControlStateHighlighted];
     [self.button setBackgroundImage:selected forState:UIControlStateSelected];
     [self.button setBackgroundImage:selectedHighlighted forState:UIControlStateSelected | UIControlStateHighlighted];  */
    
    //Mark View controller callback method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //set up for delegate callbacks
        
        //      buttonShadow()
        
        
        // Change the navigation bar background color to blue.
        navigationController!.navigationBar.barTintColor = UIColor.cyanColor()
        
        // Change the color of the navigation bar button items to white.
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
   /*
        // Change the color of the navigation bar title text to yellow.
        navigationController!.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.yellowColor()]
       */
        mealtextField.delegate = self
        restaurantName.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            mealID.text = String(meal.mealID)
            navigationItem.title = meal.name
            mealtextField.text   = meal.name
            mealImage.image = meal.photo
            ratingClass.rating = meal.rating
            restaurantName.text = meal.restName
            
            
            let mdm: MealDataManager = MealDataManager()
            let mID = meal.mealID
            let mealDB = mdm.MealDatabaseSetUp()
            let restaurant: Restaurant = mdm.loadRestaurantData(mealDB, mID: mID)
            
            restaurantAddress.text = restaurant.rAddress
            restaurantCity.text = restaurant.rCity
            restaurantState.text = restaurant.rState
            restaurantZip.text = restaurant.rZip
            
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
 //           let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
            let components = calendar.components([.Hour, .Minute, .Month, .Year, .Day], fromDate: date)
            let hour = components.hour
            let minutes = components.minute
            let month = components.month
            let year = components.year
            let day = components.day
            
            eventDate.text = String(month) + "/" + String(day) + "/" + String(year) + ", " + String(hour) + ":" + String(minutes)
            
        }else{
        mealID.text = "1"
        }
        
        checkValidMealName()
        
        /*        if mealtextField.text!.isEmpty {
         doneButton.userInteractionEnabled = false
         } */
    }
    
        
    //Mark text field delegates
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
     doneButton.enabled = false
     return true
     } */
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //       doneButton.userInteractionEnabled = true
        // Disable the Save button while editing.
        if textField == mealtextField {
        saveMeal.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //        mealLabel.text = textField.text
        if textField == mealtextField {
        checkValidMealName()
        navigationItem.title = textField.text
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        /*     let updatedString = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)  */
        
        // do whatever you need with this updated string (your code)
        
        //       doneButton.userInteractionEnabled = true
        checkValidMealName()
        
        if textField == mealtextField {
        //      saveMeal.enabled = true
        navigationItem.title = textField.text! + string
        
        /*         if (string != "") {
         if let selectedRange = textField.selectedTextRange {
         
         let cursorPosition = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: selectedRange.start)
         if cursorPosition == 1 {
         saveMeal.enabled = true
         navigationItem.title = string
         
         else if cursorPosition > 1 {
         saveMeal.enabled = true
         navigationItem.title = string + textField.text!
         
         }
         }
         }  */
        
        if (string == "") {
            if let selectedRange = textField.selectedTextRange {
                
                let cursorPosition = textField.offsetFromPosition(textField.beginningOfDocument, toPosition: selectedRange.start)
                if cursorPosition == 1 {
                    saveMeal.enabled = false
                    navigationItem.title = "New Meal"
                    
                }
            }
        }
        }
        
        // always return true so that changes propagate
        return true
    }
    
    //Mark Action methods
    /*
     @IBAction func performShowDefault(sender: UIButton) {
     mealLabel.text = "Defaulted"
     }df
     */
    /*
     @IBAction func setLabel(sender: UIButton) {
     //     if (mealtextField.text != nil) {
     if (mealtextField.text != "") {
     mealLabel.text = mealtextField.text
     mealtextField.text = ""
     doneButton.userInteractionEnabled = false
     }else{
     doneButton.userInteractionEnabled = false
     }
     }
     */
    
    //Mark photo picker with gesture recognizer
    
    
    @IBAction func touchMealPhoto(sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        mealtextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    //Mark imagepicker delegates
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        mealImage.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Mark Button shadow method
    
    /*    func buttonShadow() {
     
     doneButton.imageView!.layer.cornerRadius = 7.0
     doneButton.layer.shadowRadius = 3.0
     doneButton.layer.shadowColor = [UIColor.blackColor].CGColor;
     doneButton.layer.shadowOffset = CGSizeMake(0.0, 1.0);
     doneButton.layer.shadowOpacity = 0.5
     doneButton.layer.masksToBounds = NO
     }
     */
    
    
    func checkValidMealName() {
        // Disable the Save button if the text field is empty.
        let text = mealtextField.text ?? ""
        saveMeal.enabled = !text.isEmpty
    }
    
    //mark navigation
    
    @IBAction func cancelChange(sender: AnyObject) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveMeal === sender {
            let mealItemId: Int = Int(mealID.text!)!
            let name = mealtextField.text ?? ""
            let photo = mealImage.image
            let rating = ratingClass.rating
            
            let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
            if restaurantName.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
               restName = "Not found"
            }else{
                restName = restaurantName.text
            }
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(mealID: mealItemId, name: name, photo: photo, rating: rating, restName: restName!)
 
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()
        if mealtextField.text!.stringByTrimmingCharactersInSet(whitespaceSet) == "" {
            
            let alertController = UIAlertController(title: "Alert!", message: "Enter valid meal name", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
            
            return false
        }
            
        else {
            return true
        }
        
        
        // by default, transition
        return true
    }
    

}