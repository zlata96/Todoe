//
//  Item.swift
//  Todoey
//
//  Created by Zlata Guseva on 25/09/2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var isDone = false
    @objc dynamic var color = ""
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
