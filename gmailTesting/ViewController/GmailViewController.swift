//
//  GmailViewController.swift
//  gmailTesting
//
//  Created by Sky Xu on 1/28/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import UIKit
import GoogleSignIn
import Google
import GoogleAPIClientForREST
import Alamofire

class GmailViewController: UIViewController {
    
    var threadArr: NSArray?
    var msgArr = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var datasource = TableViewDataSource(items: []){
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        assignSnippet { (success) in
            if success {
                // MARK: assign datasource to be email snippet if call back success
                self.datasource.items = self.msgArr
                self.tableView.dataSource = self.datasource
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datasource.configureCell = { (tableView, indexPath) -> UITableViewCell in
            let mailTitleData = self.datasource.items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GmailCell
            cell.mailTitle.text = mailTitleData as! String
            
            return cell
        }
    }
    
    //    MARK: put email snippet into a list
    func assignSnippet(completion: @escaping (Bool) -> () ) {
        for item in threadArr!{
            let threadDict = item as! NSDictionary
            let snippet = threadDict["snippet"]!
            print(snippet)
            msgArr.append(snippet as! String)
        }
        completion(true)
    }
}
