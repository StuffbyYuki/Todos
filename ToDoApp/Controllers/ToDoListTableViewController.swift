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
        //tableView.allowsMultipleSelectionDuringEditing = true
     
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
    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell.EditingStyle {
//        return tableView.isEditing ? UITableViewCell.EditingStyle.none : UITableViewCell.EditingStyle.delete
//    }
//
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        

        let checkImageView1 = UIImageView(image: UIImage(named: "checked"))
        let checkImageView2 = UIImageView(image: UIImage(named: "unchecked"))
        
        checkImageView1.setImageColor(color: #colorLiteral(red: 0.09606388956, green: 0.7421667576, blue: 0.944612205, alpha: 1))
        checkImageView2.setImageColor(color: #colorLiteral(red: 0.09606388956, green: 0.7421667576, blue: 0.944612205, alpha: 1))
        
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.textLabel?.text ?? "No item")
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        
        if let item = listItems?[indexPath.row]{
            
            cell.textLabel?.textColor = #colorLiteral(red: 0.2, green: 0.1921568627, blue: 0.231372549, alpha: 1)
            cell.textLabel?.text = item.subName
            cell.selectionStyle = .none
            
            
            if item.done == false {
                addSelectionFeedbackGenerator()
                cell.accessoryView = checkImageView2
                //cell.accessoryType = .none
            
                
            } else {
                addFeedBackGenerator()
                cell.accessoryView = checkImageView1
               //cell.accessoryType = .checkmark
                
                
                //cell.textLabel?.attributedText = attributeString
                //cell.textLabel?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
    
  
      //------------------------------------------------
    
    
//    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
//
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.none
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
            field.autocorrectionType = .yes
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
    
    
    
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
       
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

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
