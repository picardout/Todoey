//
//  ViewController.swift
//  Todoey
//
//  Created by Marius Pirvulescu on 2/19/18.
//  Copyright © 2018 Trinketronics. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

   // var defaults = UserDefaults.standard

    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    let cntxt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadDataItems()
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
            let newItem = Item(context: self.cntxt)
            newItem.title = theTextField.text!
            newItem.done = false

            self.itemArray.append( newItem )
            
            self.saveDataItems()

        }
        alert.addAction(action)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new item"
            theTextField = textField
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveDataItems() {
        do {
            try cntxt.save()
        } catch {
            print("Error saving context:  + \(error)")
        }
        tableView.reloadData()
    }

    func loadDataItems() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try cntxt.fetch(request)
        } catch {
            print("Error fetching context:  + \(error)")
        }
    }
}




