//
//  ViewController.swift
//  Todoey
//
//  Created by Marius Pirvulescu on 2/19/18.
//  Copyright © 2018 Trinketronics. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

   // var defaults = UserDefaults.standard

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")

    var itemArray : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
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
        self.saveDataItems()
        //remove the sect (grey colour)
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

            self.itemArray.append( newItem )
            
            self.saveDataItems()
            //save to UserDefaults:
 //           self.defaults.set(self.itemArray, forKey: "dictItems2")
        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            theTextField = textField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveDataItems() {
        //encode the array:
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding:  + \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error encoding:  + \(error)")
            }
        }
    }
    
}




