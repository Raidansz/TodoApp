//
//  SwipeTableViewController.swift
//  TodoApp
//
//  Created by Raidan Shugaa Addin on 2022. 11. 03..
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    // TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
               
                
                
                cell.delegate = self
      
                return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               // handle action by updating model with deletion
            self.updateModel(at: indexPath)

           }


           return [deleteAction]
    }
    func updateModel(at indexPath:IndexPath){
       
        
    }
    
    
    
        
        
}

extension CGFloat {
      static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

    extension UIColor {
        static func random() -> UIColor {
            return UIColor(
               red:   .random(),
               green: .random(),
               blue:  .random(),
               alpha: 1.0
            )
        }
    }
