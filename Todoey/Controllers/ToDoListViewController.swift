//
//  ViewController.swift
//  Todoey
//
//  Created by Zlata Guseva on 19/09/2022
//

import UIKit
import RealmSwift
import SwipeCellKit

class ToDoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var toDoItems: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    var constant = Constants()
    var baseAlpha: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name ?? "Item"
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller doesn't exist")
        }
        let categoryColor = UIColor(hexString: selectedCategory?.color ?? constant.mainColor)
        searchBar.barTintColor = categoryColor
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navBar.tintColor = UIColor.white
        let app = UINavigationBarAppearance()
        app.backgroundColor = categoryColor
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
        self.navigationController?.navigationBar.standardAppearance = app
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            baseAlpha -= CGFloat(1) / CGFloat(toDoItems?.count ?? 1)
            cell.backgroundColor = UIColor(hexString: item.color, alpha: baseAlpha)
            cell.accessoryType = item.isDone ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.isDone = !item.isDone
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text ?? "New item"
                        newItem.dateCreated = Date()
                        newItem.color = self.selectedCategory?.color ?? self.constant.mainColor
                        print(self.selectedCategory?.name ?? "error")
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
    
    func reloadData() {
        tableView.reloadData()
        baseAlpha = 1
    }
}

//MARK: - Search Bar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

