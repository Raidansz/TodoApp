//
//  CatagoryViewController.swift
//  TodoApp
//
//  Created by Raidan Shugaa Addin on 2022. 10. 31..
//

import UIKit
import CoreData



class CatagoryViewController: SwipeTableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var catagoryArray = [Catagory]()
    
   
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 80.0
        
        loadCatagories()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catagoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let catagory = catagoryArray[indexPath.row]
        cell.textLabel?.text = catagory.name
        cell.backgroundColor = .random()
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        performSegue(withIdentifier: "goToItems", sender: self)
  
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCatagory = catagoryArray[indexPath.row]
        }
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
    
    override func updateModel(at indexPath: IndexPath) {
        self.context.delete(self.catagoryArray[indexPath.row])
                      self.catagoryArray.remove(at: indexPath.row)
       
                   tableView.deleteRows(at: [indexPath], with: .none)
       
                   self.saveCatagories()
    }

}
