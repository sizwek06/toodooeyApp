//
//  Category.swift
//  Toodooey
//
//  Created by Sizwe Khathi on 2022/04/26.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    //the prefixes make this a type Realm class
}
