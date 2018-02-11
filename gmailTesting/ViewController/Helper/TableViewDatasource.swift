//
//  TableViewDatasource.swift
//  gmailTesting
//
//  Created by Sky Xu on 1/28/18.
//  Copyright © 2018 Sky Xu. All rights reserved.
//

import Foundation
import UIKit

typealias tableCellCallback = (UITableView, IndexPath) -> UITableViewCell

class TableViewDataSource<Item>: NSObject, UITableViewDataSource {
    
    var configureCell: tableCellCallback?
    var items: [Item]
    init(items: [Item]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return items.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let configureCell = configureCell {
            print("okey, \(configureCell) success")
        } else {
            precondition(false, "you didn't pass the callback to configure cell")
        }
        
        return configureCell!(tableView, indexPath)
    }
    
    
}
