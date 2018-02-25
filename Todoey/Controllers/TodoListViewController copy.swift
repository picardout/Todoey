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
    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Monster"]
    var itemArrayCheck = [false, false, false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let newItemArr = defaults.array(forKey: "dictItems") as? [String] {
            itemArray = newItemArr
        }
        if let newItemArrCheck = defaults.array(forKey: "dictItemsCheck") as? [Bool] {
            itemArrayCheck = newItemArrCheck
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) 
        
        cell.textLabel?.text = itemArray[indexPath.row]
        if(itemArrayCheck[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    //MARK: - tableview delegate methods:
    @objc func tableViewTapped() {
        var indexPath = tableView.indexPathsForSelectedRows![0] as IndexPath
        let iRow = indexPath.row
        print ("row: " + "\(iRow)")
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            itemArrayCheck[indexPath.row] = false
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArrayCheck[indexPath.row] = true
        }
        //remove the sect (grey colour)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Provide a new Item", message: "", preferredStyle: .alert)
        //method-level variable used to extract info from the closure
        var theTextField = UITextField();
        let action = UIAlertAction(title: "New Item", style: .default) { (action) in
            print ("Success")
            //adjust the array of items:
            self.itemArray.append(theTextField.text!)
            self.itemArrayCheck.append(false)
            //save to UserDefaults:
            self.defaults.set(self.itemArray, forKey: "dictItems")
            self.defaults.set(self.itemArrayCheck, forKey: "dictItemsCheck")
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

