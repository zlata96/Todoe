//
//  Category.swift
//  Todoey
//
//  Created by Zlata Guseva on 25/09/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
    
}
