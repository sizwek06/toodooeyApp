//
//  Data.swift
//  Toodooey
//
//  Created by Sizwe Khathi on 2022/04/25.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    //dynamic allows name to be monitored for changes during runtime
    //hence changes will be done dynamically
}
