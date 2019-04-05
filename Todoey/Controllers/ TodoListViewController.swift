//
//  ViewController.swift
//  Todoey
//
//  Created by Andrei Giuglea on 30/03/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController  {

    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//
        let newItem = Item()
        newItem.title = "Mikel"
        itemArray.append(newItem)
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
        
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary value = condition valueIfTrue: valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
       
        
        return cell
        
    }
    
    //MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
         tableView.deselectRow(at: indexPath, animated: true)
         tableView.reloadData()
    }
    
    
    
    
    //MARK: Add new items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Item", style: .default) { (action) in
           
            let newItem = Item()
            newItem.title = textField.text! ?? "New Item"
            self.itemArray.append(newItem )
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

