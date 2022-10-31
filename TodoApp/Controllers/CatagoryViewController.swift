//
//  CatagoryViewController.swift
//  TodoApp
//
//  Created by Raidan Shugaa Addin on 2022. 10. 31..
//

import UIKit
import CoreData

class CatagoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagoryArray = [Catagory]()
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        loadCatagories()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatagoryCell", for: indexPath)
        let catagory = catagoryArray[indexPath.row]
        cell.textLabel?.text = catagory.name
       // cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        context.delete(catagoryArray[indexPath.row])
        catagoryArray.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .left)
        // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveCatagories()
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo Catagory", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            print("Success!")
            
            let newCatagory = Catagory(  context: self.context)
           
            newCatagory.name = textField.text!
            self.catagoryArray.append(newCatagory)
            
            
            
            self.saveCatagories()
            
            
            
            
        }
        
        alert.addTextField{(alertTextField) in
            alertTextField.placeholder = "Add a new Catagory"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    func saveCatagories(){
        
        
        
        do{
            try self.context.save()
        }catch{
            print("Error saving context")
        }
        
        tableView.reloadData()
    }
    
    func loadCatagories(with request: NSFetchRequest<Catagory> = Catagory.fetchRequest()){
      
        do{
            catagoryArray =  try context.fetch(request)
        }catch{
            print(error.localizedDescription)
        }
        tableView.reloadData()
        
    }
    
    

}

