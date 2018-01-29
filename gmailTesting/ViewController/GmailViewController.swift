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

class GmailViewController: UIViewController {
    
    var msgArr: [GTLRGmail_Message]?
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
        print(msgArr![0].payload?.headers)
        self.datasource.items = (msgArr![0].payload?.headers)!
        self.tableView.dataSource = self.datasource
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
    
    func getGmailSubject() {
        
    }
}
