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
    
    private var roundButton = UIButton()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.setEditing(true, animated: false)
    
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
        return listItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = listItems?[indexPath.row]{
            
            cell.textLabel?.text = item.subName
            cell.selectionStyle = .none
            
            if item.done == false {
                addSelectionFeedbackGenerator()
                cell.accessoryType = .none
            } else {
                addSelectionFeedbackGenerator()
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
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.none
//    }

    //------------------------------------------------
    
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//
//        try! realm.write {
//            let sourceObject = listItems?[sourceIndexPath.row]
//            let destinationObject = listItems?[destinationIndexPath.row]
//
//            let destinationObjectOrder = destinationObject?.order
//
//            if sourceIndexPath.row < destinationIndexPath.row {
//                // 上から下に移動した場合、間の項目を上にシフト
//                for index in sourceIndexPath.row...destinationIndexPath.row {
//                    let object = listItems?[index]
//                    object?.order -= 1
//                }
//            } else {
//                // 下から上に移動した場合、間の項目を下にシフト
//                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
//                    let object = listItems?[index]
//                    object?.order += 1
//                }
//            }
//            // 移動したセルの並びを移動先に更新
//            sourceObject?.order = destinationObjectOrder!
//        }
//
//    }
    
    
    //--------------------------------------------------------
    
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
        print("Add button pressed!")
        addFeedBackGenerator()
        
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
    
    
    
    func addFeedBackGenerator(){
        let generator = UIImpactFeedbackGenerator()
        generator.impactOccurred()
    }
    
    func addSelectionFeedbackGenerator(){
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
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
