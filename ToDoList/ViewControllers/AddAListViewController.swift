//
//  AddAListViewController.swift
//  ToDoList
//
//  Created by Goutham Devaraju on 30/08/16.
//  Copyright © 2016 gouthamdev. All rights reserved.
//

import UIKit

class AddAListViewController: UIViewController {

    @IBOutlet var textFieldList: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveEvent(sender: AnyObject) {
        
        if textFieldList.text?.characters.count >= 1{
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let dictItem = NSMutableDictionary()
            
            let aryIDNumbers = NSMutableArray()
            
            let aryEntityValues:NSArray = appDelegate.getValues("List")
            
            for items in aryEntityValues{
                aryIDNumbers.addObject(items.valueForKey("id") as! NSNumber)
            }
            
            let maxVal: Int = (aryIDNumbers as AnyObject).valueForKeyPath("@max.self") as! Int
            
            print("max value: \(maxVal)")
            
            print("Id Incremented: \(aryEntityValues.count+1)")
            dictItem.setObject(maxVal+1, forKey: "id")
            dictItem.setValue(textFieldList.text, forKey: "name")
            dictItem.setObject(0, forKey: "state")
            
            appDelegate.setValuesToEntity("List", withDictionary: dictItem)
            
            discardEvent(nil)
        }
        
    }

    @IBAction func discardEvent(sender: AnyObject?) {
        
        print("Discard Event")
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textFieldList.resignFirstResponder()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
