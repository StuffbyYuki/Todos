//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by 掛川優希 on 1/16/19.
//  Copyright © 2019 Yuki Kakegawa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    let categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        let categoryYouWork = categories[indexPath.row]
        
        cell.textLabel?.text = categoryYouWork.name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New Category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            //Happinning nothing
            print("Adding Canceled...")
        }
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
        
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Create New Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category: Category){
        do {
        try realm.write {
            realm.add(category)
            }}catch{
                print("Error...\(error)")
        }
        
        tableView.reloadData()
    }
   

    

}
