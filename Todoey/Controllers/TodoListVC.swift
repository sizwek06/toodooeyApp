//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    
    var itemArray = [Item]()
    let userDefaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //The line above creates an object via the singleton of the AppDelegate - then we access the
    //db in it to write onto it
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }//needs Google
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = userDefaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = item.title
        
        //MARK:- Ternary Operator
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        //The above is same as the following
        //        if item.done == true{
        //            cell.accessoryType = .checkmark
        //        }else{
        //            cell.accessoryType = .none
        //        }
        return cell
    }
    
    //MARK: - Table View Delegate and methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //MARK: - Update in CRUD
        //if we were to update a value to what we'd like
        //itemArray[indexPath.row].setValue("NewValue", forKey: "title")
        //since we only manipulating the done = true ? false, we can use the below
        
        //MARK: - Delete in CRUD
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        //        The lines above remove the item from CoreData & then the array which we use to hold the info
        //Deleting from array first will cause issues as the indices would disappear - then the coredata request would attempt to delete a non-existent item at index y
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //The above is same as the following
        //        if itemArray[indexPath.row].done == false {
        //            titemArray[indexPath.row].done == true
        //        } else {
        //            itemArray[indexPath.row].done == false
        //        }
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add Button - C in CRUD
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Toodooey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] (action) in
            //the action once the user clicks add item
            
            let addItem = Item(context: self.context)
            addItem.title = textField.text!
            addItem.done = false
            addItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(addItem)
            
            saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }//adding alert textfield & placeholder text
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Add New Items - Kind of C in CRUD but generally used to store context.
    //All the C_UD use the below to store the manipulations of each
    func saveItems() {
        
        do {
            //in this section we'll access the AppDelegate's saveContext method
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
        //reload tableView to show the data once more
    }
    
    //MARK: - Load Items - R in CRUD
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //The line above after equals is the default request value whenever it's not added.
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
        request.predicate = categoryPredicate
        }
        //the above two lines allow us to have two SQL statements so that when we search for an item we get items that match the word AND the relationship
        //if no relationship exists, still show us the items that match the search
        //since it's optional as well we have to optionally unwrap it
        
        do {
            //in this section we'll access the AppDelegate's saveContext method
            itemArray = try context.fetch(request)
        } catch {
            print("Error saving context: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Delegate
extension TodoListVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //title contains is like sql like query, see more at realm.io/posts/nspredicate-cheatsheet
        //the cd is for case & diaretic sensitivity i.e. to ignore it
        
        request.predicate = predicate
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptr]
        //the above expects an array of descriptors but we are using one hence the array of one descriptr
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
                //No longer have the cursor and/or keyboard displayed
            }
        }
    }
}
