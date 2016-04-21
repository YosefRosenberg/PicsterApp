//
//  ViewController.swift
//  Picster
//
//  Created by Yosef Rosenberg on 4/19/16.
//  Copyright © 2016 Yosef Rosenberg. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signUpActive = true
    
    @IBOutlet var logInButton: UIButton!
    
    @IBOutlet var signUpButton: UIButton!

    @IBOutlet var registeredText: UILabel!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func signUp(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error in Form", message: "Please enter a username and password")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var errorMessage = "Please try again later"
            
            if signUpActive == true {
                
            let user = PFUser()
            user.username = username.text
            user.password = password.text
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                    
                    // Sign up successful
                    self.performSegueWithIdentifier("login", sender: self)
                    
                } else {
                    
                    if let errorString = error!.userInfo["error"] as? String {
                        
                        errorMessage = errorString
                        
                    }
                    
                    self.displayAlert("Failed Log in", message: errorMessage)
                    
                    }
                })
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { (user, error) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if user != nil {
                        
                        //Logged in!
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                            
                            errorMessage = errorString
                            
                        }
                        
                    }
                    
                })
            }
        }
    }
    
    @IBAction func logIn(sender: AnyObject) {
        
        if signUpActive == true {
            
            signUpButton.setTitle("Log in", forState: UIControlState.Normal)
            
            registeredText.text = "Registered?"
            
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpActive = false
            
        } else {
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            registeredText.text = "Registered?"
            
            logInButton.setTitle("Log in", forState: UIControlState.Normal)
            
            signUpActive = true
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib

    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("login", sender: self)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

