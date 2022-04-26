//
//  Item.swift
//  Toodooey
//
//  Created by Sizwe Khathi on 2022/04/26.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    //the prefixes make this a type Realm class
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    //this is to create one-to-many relationship with the Category List of items
}
