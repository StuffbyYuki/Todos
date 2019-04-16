//
//  CategoryTableViewController.swift
//  ToDoApp
//
//  Created by 掛川優希 on 1/16/19.
//  Copyright © 2019 Yuki Kakegawa. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?

    private var roundButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        createFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        roundButton.isHidden = true
    }
    
    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let categoryCell = categories?[indexPath.row]{
        
            cell.textLabel?.text = categoryCell.name
            
            
    
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
  
    func createFloatingButton() {
        
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        roundButton.setImage(UIImage(named: "addIcon3"), for: .normal)
        roundButton.imageView?.contentMode = .scaleAspectFit
        
        UIImageView().image = UIImageView().image?.withRenderingMode(.alwaysTemplate)
        //UIImageView().tintColor = UIColor.blue
        
        roundButton.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 20),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 20),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 60),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 60)])
            }
            // Make the button round:
            self.roundButton.layer.cornerRadius = 30
            // Add a black shadow:
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            
            // Add a pulsing animation to draw attention to button:
            
            //            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            //                scaleAnimation.duration = 0.5
            //                scaleAnimation.repeatCount = .greatestFiniteMagnitude
            //                scaleAnimation.autoreverses = true
            //                scaleAnimation.fromValue = 1.0;
            //                scaleAnimation.toValue = 1.05;
            //                self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
    
  
    
    
    @objc func buttonPressed(){
        print("Floating button pressed!")
        addFeedBackGenerator()
        
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
    
    
    func addFeedBackGenerator(){
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
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
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexpath: IndexPath){
        if let categoryToDelete = self.categories?[indexpath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            }catch{
                print("Error..when updating model.\(error)")
            }
            }
        
        
    }
   

    

}
