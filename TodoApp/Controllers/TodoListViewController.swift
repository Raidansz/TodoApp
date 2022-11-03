//
//  ViewController.swift
//  TodoApp
//
//  Created by Raidan Shugaa Addin on 2022. 10. 27..
//

import UIKit
import CoreData

class TodoListViewController: SwipeTableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    
    var selectedCatagory:Catagory?{
        didSet{
            loadItems()
        }
    }
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        navigationItem.title = selectedCatagory?.name
        
    
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.backgroundColor = .random()
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .left)
        
        saveItems()
    }
    
    
    
    
    

    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) {(action) in
            print("Success!")
            
            let newItem = Item(  context: self.context)
            newItem.done = false
            newItem.parentCatagory = self.selectedCatagory
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
        
        
        
        do{
            try self.context.save()
        }catch{
            print("Error saving context")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
      
    
        let catagoryPredicate = NSPredicate(format: "parentCatagory.name MATCHES %@", selectedCatagory!.name!)
       
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,catagoryPredicate])
        }else{
            request.predicate = catagoryPredicate
        }
        
       
      
        
        do{
            itemArray =  try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        tableView.reloadData()
        
    }
    
    
}

extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()

      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

                    loadItems(with: request,predicate: predicate)
    }
    
    
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
    }
    
    
    
    
}
