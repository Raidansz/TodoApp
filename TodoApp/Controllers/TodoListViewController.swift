//
//  ViewController.swift
//  TodoApp
//
//  Created by Raidan Shugaa Addin on 2022. 10. 27..
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        
        let newItem = Item()
        let newItem1 = Item()
        let newItem2 = Item()
        let newItem3 = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        
        newItem1.title = "B"
        itemArray.append(newItem1)
        newItem2.title = " C"
        itemArray.append(newItem2)
        
        newItem3.title = "D "
        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//           itemArray = items
//        }
        loadItems()
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
       
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
      
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            print("Success!")
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
        
            
          
            self.saveItems()
            
            
            
            
        }
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        
         do{
             let data = try encoder.encode(itemArray)
             try data.write(to: dataFilePath!)
         }catch{
             print("Error while encoding the data")
         }
        
        tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("An error has occured while decoding the data")
            }
           
            
        }
            
           
            
        
    }
}

