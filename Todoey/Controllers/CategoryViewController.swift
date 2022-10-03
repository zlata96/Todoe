//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Zlata Guseva on 23/09/2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoties()
        tableView.separatorStyle = .none
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
            newCategory.color = self.getRandomColor().toHexString()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    // MARK: TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added yet"
//        let color = UIColor(hexString: categories?[indexPath.row].color ?? "000000")
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].color ?? "000000")
        return cell
    }
    
    // MARK: TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
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
    
    func loadCategoties() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    func getRandomColor() -> UIColor {
        return UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1.0)
    }
}

extension UIColor {
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1) {
        let chars = Array(hexString.dropFirst())
        self.init(red:   .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue:  .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)
    }
}



