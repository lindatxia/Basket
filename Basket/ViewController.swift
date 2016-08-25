//
//  ViewController.swift
//  Basket
//
//  Created by Linda Xia on 8/15/16.
//  Copyright © 2016 Linda Xia. All rights reserved.
//

import UIKit

var items = [String]()
var prices = [String]()
var totalPrice: Double = 0.0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!

    @IBAction func addItem(sender: UIButton) {
        
        let newItem = textField.text
        textField.keyboardType = UIKeyboardType.Default
        if newItem != ""
        {
            items.append(newItem!)
            prices.append("") //Add a space for possible price
        }
        textField.resignFirstResponder()
        textField.text = "" // Reset
    
    
        tableView.reloadData()
    }
    
    @IBOutlet var tableView: UITableView!

    @IBOutlet var Price: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.keyboardType = UIKeyboardType.Default
        self.textField.delegate = self
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadList:",name:"load", object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadList(notification: NSNotification) {
        //load data here
        items.removeAll()
        prices.removeAll()
        self.tableView.reloadData()
    } // Ancillary function to help update the table view

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Labels stuff inside table
        cell.textLabel?.text = items[indexPath.row]
        
        // Add in price subtitle if there's stuff inside
        let isIndexValid = prices.indices.contains(indexPath.row)
        if isIndexValid
        {
            if prices[indexPath.row] != ""
            {
                let newPrice = Double(prices[indexPath.row])
                cell.detailTextLabel?.text = String(format: "$ %.2f", newPrice!)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    { // This does the checkmark stuff, when you click in the table cells
        
        let selectedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        if selectedRow.accessoryType == UITableViewCellAccessoryType.None {
            selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    // Does the swiping action for each cell
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        // DELETING STUFF
        let deletedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete")
        {
            action, index in
            
            // Only if there's an added price, then subtract the total price
            if prices[indexPath.row] != ""
            {
                let dubPrice = Double(prices[indexPath.row])
                totalPrice -= dubPrice!
                self.Price.text = String(format: "$ %.2f", totalPrice)
            }
            
            items.removeAtIndex(indexPath.row) // Take word out of the array
            prices.removeAtIndex(indexPath.row)
            deletedRow.detailTextLabel?.text = ""
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic) // Remove entire row
            deletedRow.accessoryType = UITableViewCellAccessoryType.None // Take out checkmark
            tableView.reloadData()

        }
        delete.backgroundColor = UIColorFromHex(0xff6347)
        
        
        // ADDING/BUYING STUFF
        let bought = UITableViewRowAction(style: .Normal, title: "Bought")
        {
            action, index in
            deletedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            
            let alert = UIAlertController(title: "Add Item Expense", message: "Enter the dollar amount.", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler
            {
                (newTextField) in
                newTextField.placeholder = "$"
                newTextField.keyboardType = UIKeyboardType.DecimalPad
            }
            
            let add = UIAlertAction(title: "Add", style: .Default)
            {
                (action) in
                let newTextField = alert.textFields![0]
             
                
                // ONLY NUMBERS & DECIMAL.
                
                
                prices[indexPath.row] = (newTextField.text!)
                // Convert to a double from a String
                let dubPrice = Double(prices[indexPath.row])
                totalPrice += dubPrice!
                
                self.Price.text = String(format: "$ %.2f",totalPrice)
                print(totalPrice, "this is how everything costs")
            
                
                self.tableView.reloadData()
            }
            
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel)
            {
                (alert) in
                deletedRow.accessoryType = UITableViewCellAccessoryType.None
            }
            alert.addAction(add)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
          
        }
        
        bought.backgroundColor = UIColorFromHex(0x43CD80)
        
        return [bought, delete]
    }
    
    func UIColorFromHex(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
   
    func alert() {
        let alert = UIAlertController(title: "Add Item Expense", message: "Enter the dollar amount.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler
            {
                (textField) in
                textField.placeholder = "$"
        }
        let add = UIAlertAction(title: "Add", style: .Default)
        {
            (action) in
            let textField = alert.textFields![0]
            
            // HERE IS THE PROBLEM.... You need to index this. 
            
            prices.append(textField.text!)
            print(prices)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel)
        {
            (alert) in
        }
        alert.addAction(add)
        alert.addAction(cancel)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    

    
}
