//
//  ViewController.swift
//  FoodTracker
//
//  Created by Suvojit Dutta on 4/3/16.
//  Copyright © 2016 Suvojit Dutta. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Mark properties
    //   @IBOutlet weak var mealLabel: UILabel!
    
    @IBOutlet weak var mealtextField: UITextField!
    
    //    @IBOutlet weak var defaultButton: UIButton!
    
    //    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    @IBOutlet weak var saveMeal: UIBarButtonItem!
    
    @IBOutlet weak var ratingClass: RatingClass!
    
    var meal :Meal?
    
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
        
        mealtextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            mealtextField.text   = meal.name
            mealImage.image = meal.photo
            ratingClass.rating = meal.rating
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
        saveMeal.enabled = false
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //        mealLabel.text = textField.text
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        // text hasn't changed yet, you have to compute the text AFTER the edit yourself
        /*     let updatedString = (textField.text as NSString?)?.stringByReplacingCharactersInRange(range, withString: string)  */
        
        // do whatever you need with this updated string (your code)
        
        //       doneButton.userInteractionEnabled = true
        checkValidMealName()
        
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
            let name = mealtextField.text ?? ""
            let photo = mealImage.image
            let rating = ratingClass.rating
            
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            meal = Meal(name: name, photo: photo, rating: rating)
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

