//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Marius Pirvulescu on 2/23/18.
//  Copyright © 2018 Trinketronics. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var arrCategories : [Category] = []
    let cntxt = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCategory", for: indexPath)
        cell.textLabel?.text = arrCategories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = arrCategories[indexPath.row]
        }
        
    }

    //MARK: - Data Manipulation Methods
    func saveData() {
        do {
            try (cntxt.save())
        } catch {
            print ("Error when saving data")
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            arrCategories = try (cntxt.fetch(request))
        } catch {
            print ("Error when saving data")
        }
        tableView.reloadData()
    }
    
    //MARK: - Add new Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Provide a new Item", message: "", preferredStyle: .alert)
        //method-level variable used to extract info from the closure
        var theTextField = UITextField();
        let newAlert = UIAlertAction(title: "Provide a new Category name", style: UIAlertActionStyle.default) { (action) in
            let newCategory = Category(context: self.cntxt)
            newCategory.name = theTextField.text
            self.arrCategories.append(newCategory)
            self.saveData()
        }
        alert.addAction(newAlert)
        alert.addTextField { (textField) in
            textField.placeholder = "Create new category"
            theTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }

}
