//
//  ViewController.swift
//  Instragram-2017
//
//  Created by Nazar on 12.11.17.
//  Copyright © 2017 Nazar. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrievingDataFromServer()
    }

    
    
    fileprivate func sendTestData() {
        let object = PFObject(className: "TestObject12345")
        
        object["name"] = "Petro Pershiy"
        object["message"] = "Long long message for test"
        object["add"] = "tuturu tu"
        object.saveInBackground { (done, error) in
            if done {
                print("save in server")
            } else {
                print(error as Any)
            }
        }
    }
    
    fileprivate func saveDataWithPicture() {
        
        let data = UIImageJPEGRepresentation(picture.image!, 0.5)
        let file = PFFile(name: "MyTestImage.jpg", data: data!)
        
        // created a class / collection / table in heroku
        let table = PFObject(className: "Message")
        table["sender"] = "Nazar"
        table["receiver"] = "Yaroslav"
        table["picture"] = file
        table.saveInBackground { (isDone, error) in
            if isDone {
                print("Data is load")
            } else {
                print(error as Any)
            }
        }
    }
    
    private func retrievingDataFromServer() {
        let informatin = PFQuery(className: "Message")
        informatin.findObjectsInBackground { (objects, error) in
            if error == nil {
                for object in objects! {
                    self.senderLabel.text = "SENDER: " + (object["sender"] as! String)
                    self.receiverLabel.text = "RECEIVER: " + (object["receiver"] as! String)
                    self.createdLabel.text = "Createdc at: " + String(describing: object.createdAt!)
                    let image = object["picture"] as! PFFile
                    image.getDataInBackground(block: { (data, error) in
                        if error == nil {
                            self.picture.image = UIImage(data: data!)
                            self.view.backgroundColor = UIColor.cyan
                        } else {
                            print(error as Any)
                        }
                    })
                }
            } else {
                print(error as Any)
            }
        }
    }
}

