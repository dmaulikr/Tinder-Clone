//
//  UserDetailsViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Tyler McGee on 6/26/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBAction func updateProfileImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            userImage.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var genderSwitch: UISwitch!
    
    @IBOutlet weak var interestedInSwitch: UISwitch!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func update(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        
        PFUser.current()?["isInterestedInWomen"] = interestedInSwitch.isOn
        
        let imageData = UIImagePNGRepresentation(userImage.image!)
        
        PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData!)
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            
            if error != nil {
                
                var errorMessage = "Update failed - please try again"
                
                let error = error as NSError?
                
                if let parseError = error?.userInfo["error"] as? String {
                    
                    errorMessage = parseError
                }
                
                self.errorLabel.text = errorMessage
                
            } else {
                
                print("Updated")
                
                self.performSegue(withIdentifier: "showSwipingViewController", sender: self)
            }
            
        })
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            
            genderSwitch.setOn(isFemale, animated: false)
            
        }
        
        if let isInterestedInWomen = PFUser.current()?["isInteresedInWomen"] as? Bool {
            
            genderSwitch.setOn(isInterestedInWomen, animated: false)
            
        }
        
        if let photo = PFUser.current()?["photo"] as? PFFile {
            
            photo.getDataInBackground( block: { (data, error) in
                
                if let imageData = data {
                    
                    if let downloadedImage = UIImage(data: imageData) {
                        
                        self.userImage.image = downloadedImage
                        
                    }
                    
                }
                
            })
            
        }
        
        let urlArray = ["https://www.planetclaire.tv/wp-content/uploads/2010/07/sherlock-john-watson-season-1.jpg", "http://i.dailymail.co.uk/i/pix/2014/01/16/article-2540924-1A934D9300000578-761_634x498.jpg", "http://cdn.images.express.co.uk/img/dynamic/20/590x/secondary/Sherlock-612982.jpg", "https://tribzap2it.files.wordpress.com/2014/07/sherlock-mary-watson-death-amanda-abbington-bbc.jpg", "https://www.axn-asia.com/sites/asia.axn/files/ct_character_f_primary_image/lestrade_640.jpg", "https://ichef.bbci.co.uk/images/ic/480xn/p01pc477.jpg"]
        
        var counter = 0
        
        for urlString in urlArray {
            
            counter += 1
            
            let url = URL(string: urlString)!
            
            do {
            
            let data = try Data(contentsOf: url)
                
                let imageFile = PFFile(name: "photo.png", data: data)
                
                let user = PFUser()
                
                user["photo"] = imageFile
                
                user.username = String(counter)
                
                user.password = "password"
                
                user["isInterestedInWomen"] = false
                
                user["isFemale"] = true
                
                let acl = PFACL()
                
                acl.getPublicWriteAccess = true
                
                user.acl = acl
                
                user.signUpInBackground(block: { (success, error) in
                    
                    if success {
                        
                        print("User signed up")
                        
                    }
                    
                })
                
            } catch {
                
                print("Could not get data")
                
            }
            
        }
        
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
