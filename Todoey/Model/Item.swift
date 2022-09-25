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
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
