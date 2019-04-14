//
//  ToDoListTableViewController.swift
//  ToDoApp
//
//  Created by 掛川優希 on 1/16/19.
//  Copyright © 2019 Yuki Kakegawa. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var listItems : Results<Item>?
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listItems?[indexPath.row]{
            
            cell.textLabel?.text = item.subName
            cell.selectionStyle = .none
            
            if item.done == false {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
                cell.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            }
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = listItems?[indexPath.row]{
            do {
                try realm.write {
                item.done = !item.done
                }}catch{
                    print("Error!...\(error)")
            }
            
            
            
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

 
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            print("Adding Canceled...")
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.subName = textField.text!
                        currentCategory.items.append(newItem)
                    }}catch{
                        print("Error!..\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create New Item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems(){
        
        listItems = selectedCategory?.items.sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath) {
        if let item = listItems?[indexpath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch{
                print("Error!...\(error)")
            }
        }
    }
    
   
}
