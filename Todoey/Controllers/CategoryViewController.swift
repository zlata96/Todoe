//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Zlata Guseva on 23/09/ 2022.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoriesArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //loadCategoties()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category()
            newCategory.name = textField.text ?? "New Category"
            self.categoriesArray.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoriesArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    // MARK: TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //            categoriesArray[indexPath.row].done = !categoriesArray[indexPath.row].done
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
       // save(category: <#T##Category#>)
        //            tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    // MARK: Data Manipulation Method
    
    func save(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
//    func loadCategoties(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            categoriesArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }
}
