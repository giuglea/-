//
//  ViewController.swift
//  Todoey
//
//  Created by Andrei Giuglea on 30/03/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController  {

    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //print(FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask))
        loadItems()
        searchBar.delegate = self
        
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        self.saveItems()
         tableView.deselectRow(at: indexPath, animated: true)
         tableView.reloadData()
        
    }
    
    
    
    
    //MARK: Add new items
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController.init(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Item", style: .default) { (action) in
           
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem )
            
           self.saveItems()
//         self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
           self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    //MARK : saveItems
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    //MARK: loadItems
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){

        let categoryPredicate  = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let _ = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate!,categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        

        do{
           itemArray =  try context.fetch(request)
        }catch{
            print("Fetch request error : \(error)")
        }
        tableView.reloadData()
       
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
}
extension TodoListViewController : UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        

        loadItems(with : request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
             loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        else{
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            
            loadItems(with : request,predicate: predicate)
        }
    }
    
    
    
}

