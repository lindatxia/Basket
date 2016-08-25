//
//  SettingsViewController.swift
//  Basket
//
//  Created by Linda Xia on 8/17/16.
//  Copyright © 2016 Linda Xia. All rights reserved.
//

import UIKit
import MessageUI


class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate
{

    
   
    @IBAction func SyncButton(sender: AnyObject) {
        nums = 0
        setupOnlineLogs()
    }
  
//    @IBAction func ClearList(sender: AnyObject) {
//        items.removeAll()
//        prices.removeAll()
//        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
//    }
    
    var element = 0
    var newString = [String]() // This takes our new string into an array
    var newData = "" //This creates our new string
    
    func writeToText() //Reformats our data into strings that're easily txt file compatible!
    {
        while element < items.count
        {
            
            let tempPrices = Double(prices[element]) //Preserve the two decimals after
            newData = items[element] + " , " + String(format: "$ %.2f",tempPrices!)
            newString.append(newData)
            
            element = element + 1 //Keep forgetting this...
        }
    }

    @IBAction func EmailFile(sender: AnyObject) {
        
        //Check to see the device can send email.
        if( MFMailComposeViewController.canSendMail() ) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            //Set the subject and message of the email
            mailComposer.setSubject("What's in your Basket")
            mailComposer.setMessageBody("Here's a summary of what you've added to your Basket app. Happy shopping!", isHTML: false)
            
//            writeToText()
            newString = ["a 27", "b 18"]
            let joinedString = newString.joinWithSeparator("\n") //Fix this
            print(joinedString)
            if let data = (joinedString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            {
                // Attach File 
                mailComposer.addAttachmentData(data, mimeType: "text/plain", fileName: "test")
                self.presentViewController(mailComposer, animated: true, completion: nil)
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupOnlineLogs() {
        LindaOnlineLogs.setupOnlineLogs(formLink: "https://docs.google.com/forms/d/e/1FAIpQLSfXeEKZbY5zfS_UU78KH-IpQDnxKxN-QqecIK5LxABhHOx2Vg/formResponse", itemField: "entry_729870456", expenseField: "entry_1311737620")
        LindaOnlineLogs.enabled = true
        LindaOnlineLogs.callThis()
        
    }

}

