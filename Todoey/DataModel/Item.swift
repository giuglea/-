//
//  Item.swift
//  Todoey
//
//  Created by Andrei Giuglea on 28/09/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import Foundation
import RealmSwift

class Item :  Object{
    @objc dynamic var title : String = ""
    @objc dynamic  var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
