//
//  ViewController.swift
//  Todoey
//
//  Created by Marius Pirvulescu on 2/19/18.
//  Copyright © 2018 Trinketronics. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var defaults = UserDefaults.standard
    //var itemArray = ["Find Mike", "Buy Eggs", "Destroy Monster"]

    var itemArray : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newItemArr = defaults.array(forKey: "dictItems2") as? [Item] {
            itemArray = newItemArr
        } else {
            let item1 = Item()
            item1.title = "Find Mike"
            itemArray.append(item1)
            let item2 = Item()
            item2.title = "Buy Eggs"
            itemArray.append(item2)
            let item3 = Item()
            item3.title = "Destroy Monster"
            itemArray.append(item3)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) 
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - tableview delegate methods:

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        //remove the sect (grey colour)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Provide a new Item", message: "", preferredStyle: .alert)
        //method-level variable used to extract info from the closure
        var theTextField = UITextField();
        let action = UIAlertAction(title: "New Item", style: .default) { (action) in
            //adjust the array of items:
            let newItem = Item()
            newItem.title = theTextField.text!
            newItem.done = false
            self.itemArray.append( newItem )
            //save to UserDefaults:
            self.defaults.set(self.itemArray, forKey: "dictItems2")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            theTextField = textField
        }
        present(alert, animated: true, completion: nil)
        
    }
}

