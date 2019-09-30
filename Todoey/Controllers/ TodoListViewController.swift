//
//  ViewController.swift
//  Todoey
//
//  Created by Andrei Giuglea on 30/03/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController  {

    
    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //print(FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask))
        loadItems()
        searchBar.delegate = self
        
    }
    
    
    //MARK: Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
        
            cell.textLabel?.text = item.title
        
        //ternary value = condition valueIfTrue: valueIfFalse
            cell.accessoryType = item.done == true ? .checkmark : .none
        }
        else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
        
    }
    
    
    
    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let item = toDoItems?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
                }
            }catch{
                print("Error saving done  status \(error)")
            }
        }
        
        
         tableView.deselectRow(at: indexPath, animated: true)
         tableView.reloadData()
        
    }
    
    
    
    
    //MARK: Add new items
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Item", style: .default) { (action) in
           
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                    let newItem = Item()
                    newItem.title = textField.text!
                    currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving new Items \(error)" )
                }
            }
            
           self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: loadItems
    func loadItems(){

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
       
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
}
extension TodoListViewController : UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//
//        loadItems(with : request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
             loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        else{
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//            
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            
//            
//            loadItems(with : request,predicate: predicate)
        }
    }
    
    
    
}

