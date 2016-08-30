//
//  PendingViewController.swift
//  ToDoList
//
//  Created by Goutham Devaraju on 30/08/16.
//  Copyright © 2016 gouthamdev. All rights reserved.
//

import UIKit
import ARSLineProgress

class PendingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableViewPendingList: UITableView!
    var viewUndo = UIView()
    var arrayList = NSMutableArray()
    var dictionaryList = NSMutableDictionary()
    
    var dictItemUndo = NSMutableDictionary()
    
    //MARK: - ViewController life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        getValuesFromCodeData()
    }
    
    //Undo Event
    func showUndoEvent() {
        
        
        self.viewUndo = UIView(frame: CGRectMake(25,self.view.frame.height-120,self.view.frame.width-50,50))
        self.viewUndo.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        self.viewUndo.layer.cornerRadius = 10.0
        self.view.addSubview(self.viewUndo)
        
        let lblTitle = UILabel(frame: CGRectMake(25,0,self.viewUndo.frame.size.width-50,self.viewUndo.frame.size.height/2))
        lblTitle.text = self.dictItemUndo.valueForKey("name") as? String
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.numberOfLines = 3
        lblTitle.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
        self.viewUndo.addSubview(lblTitle)
        
        let lblTitle_desc = UILabel(frame: CGRectMake(25,lblTitle.frame.size.height,self.viewUndo.frame.size.width-50,self.viewUndo.frame.size.height/2))
        lblTitle_desc.text = "Tap to undo last delete"
        lblTitle_desc.textColor = UIColor.whiteColor()
        lblTitle_desc.textAlignment = NSTextAlignment.Center
        lblTitle_desc.numberOfLines = 3
        lblTitle_desc.font = UIFont(name: "AvenirNext-Medium", size: 15.0)
        self.viewUndo.addSubview(lblTitle_desc)
        
        let btnUndoButton = UIButton(type: .Custom)
        btnUndoButton.frame = self.viewUndo.bounds
        btnUndoButton.backgroundColor = UIColor.clearColor()
        btnUndoButton.addTarget(self, action: #selector(self.undoEvent(_:)), forControlEvents: .TouchUpInside)
        self.viewUndo.addSubview(btnUndoButton)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.viewUndo.removeFromSuperview()
                }, completion: { finished in
                    
            })
        }
    }
    
    //MARK: - Undo Event
    func undoEvent(sender: UIButton) {
        print("viewUndo")
        
        viewUndo.removeFromSuperview()
        
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
        
        dictItem.setObject(dictItemUndo.valueForKey("id")!, forKey: "id")
        dictItem.setValue(dictItemUndo.valueForKey("name"), forKey: "name")
        dictItem.setObject(dictItemUndo.valueForKey("state")!, forKey: "state")
        
        appDelegate.setValuesToEntity("List", withDictionary: dictItem)
        
        arrayList.addObject(dictItemUndo)
        tableViewPendingList.reloadData()
        
    }
    
    //MARK: - Table View Delegate and DataSource Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "PendingTableViewCell"
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(identifier)
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.blackColor()
        cell.textLabel?.font = UIFont(name: "AvenirNext-Medium", size: 15.0)
        
        let dictItem = self.arrayList[indexPath.row]
        
        cell.textLabel?.text = "\(dictItem.valueForKey("name")!)"
        cell.textLabel?.numberOfLines = 3;
        cell.textLabel?.lineBreakMode = .ByWordWrapping;
        
        return cell!
    }
    
    
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dictItem = NSMutableDictionary(dictionary: self.arrayList[indexPath.row] as! NSDictionary)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        dictItem.setObject(1, forKey: "state")
        
        appDelegate.updateValues("List", dictionary: dictItem)
        
        self.arrayList.removeObjectAtIndex(indexPath.row)
        
        tableViewPendingList.reloadData()
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            // Handling delete by removing the data from array and updating the tableview
            
            let dictItem = NSMutableDictionary(dictionary: self.arrayList[indexPath.row] as! NSDictionary)
            
            dictItemUndo = dictItem
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.deleteValuesAtEntity("List", andDictionary:dictItem as NSDictionary)
            
            self.arrayList.removeObjectAtIndex(indexPath.row);
            
            tableViewPendingList.reloadData()
            showUndoEvent()
        }
    }
    
    
    //MARK: - Core data fetch
    func getValuesFromCodeData() {
        
        print("Getting values from core data")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let aryEntityValues:NSArray = appDelegate.getValues("List")
        
        if aryEntityValues.count > 0{
            
            let aryListCache = NSMutableArray()
            
            for dicti in aryEntityValues{
                
                let list_obj:List = dicti as! List
                
                let list_DictObj = NSMutableDictionary()
                list_DictObj.setValue(list_obj.id, forKey: "id")
                list_DictObj.setValue(list_obj.name, forKey: "name")
                list_DictObj.setValue(list_obj.state, forKey: "state")
                
                aryListCache.addObject(list_DictObj)
                
                self.arrayList.removeAllObjects()
            }
            
            
            
            for listRecevied in aryListCache{
                
                let strState = listRecevied.valueForKey("state") as? NSNumber
                if strState == 0{
                    self.arrayList.addObject(listRecevied)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                print("Made a list reload request: In side main thread. Fetching from coredata")
                self.tableViewPendingList.reloadData()
                
                //Not fetching update data for now
//                self.fetchList()
            })
        }
        else{
            
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.fetchList()
            }
        }
    }
    
    //MARK: - Server fetch
    func fetchList() {
        
        print("Fetching list from the server")
        
        //Adding activity view to self.view
        if ARSLineProgress.shown { return }
        ARSLineProgress.showWithPresentCompetionBlock { () -> Void in
            
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.userInteractionEnabled = false
        
        let url_ = NSURL(string: "https://dl.dropboxusercontent.com/u/6890301/tasks.json")
        let request = NSURLRequest(URL: url_!)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            // your code
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        // process "json" as a dictionary
                        
                        self.dictionaryList = NSMutableDictionary()
                        self.dictionaryList = json as! NSMutableDictionary
                        
                        
                        let aryListRecevied = self.dictionaryList.valueForKey("data") as! NSArray
                        
                        for listRecevied in aryListRecevied{
                            
                            let strState = listRecevied.valueForKey("state") as! NSNumber
                            
                            if strState == 0{
                                
                                self.arrayList.addObject(listRecevied)
                            }
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            appDelegate.deleteEntity("List")
                            
                            for list in aryListRecevied{
                                appDelegate.setValuesToEntity("List", withDictionary: list as! NSDictionary)
                            }
                            
                            self.tableViewPendingList.reloadData()
                        })
                        
                    } else if let json = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? NSArray {
                        // process "json" as an array
                        
                        if let json = json as? NSArray {
                            
                            self.arrayList.addObjectsFromArray(json as [AnyObject])
                        }
                        
                    } else {
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                        print("Error could not parse movies JSON string: \(jsonStr)")
                    }
                    
                } catch {
                    print("error serializing movies JSON: \(error)")
                }
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                appDelegate.window?.userInteractionEnabled = true
                //                self.view.userInteractionEnabled = true
                ARSLineProgress.hideWithCompletionBlock({ () -> Void in
                    print("Hidden with completion block")
                })
            })
            
        });
        
        // do whatever you need with the task e.g. run
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
