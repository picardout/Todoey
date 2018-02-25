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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var capt: UINavigationItem!
    
    let cntxt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray : [Item] = []
    var selectedCategory : Category? {
        didSet{
            capt.title = selectedCategory?.name
            loadDataItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            //set the filter (relation with the Category entity
            newItem.parentCategory = self.selectedCategory
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

    func loadDataItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), withFilter filter: String = "") {
        
        let predicate1 = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", (selectedCategory?.name)!)
        let predicate2 = NSPredicate(format: "title CONTAINS[cd] %@", filter)
        var predicate : NSPredicate = predicate1
        if filter.isEmpty == false {
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1, predicate2])
        }
        request.predicate = predicate
        if filter.isEmpty == false {
            let sortDescript = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors = [sortDescript]
        }
        //filter fReq : NSFetchRequest<Item>
        do {
            itemArray = try cntxt.fetch(request)
        } catch {
            print("Error fetching context:  + \(error)")
        }
        tableView.reloadData()
    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        if searchText.count == 0 {
            //run a functionality on the main thread:
            DispatchQueue.main.async {
                //hide the keyboard and the focus from the searchBar
                searchBar.resignFirstResponder()
            }
        }
        loadDataItems(with: request, withFilter: searchText)
    }
}


