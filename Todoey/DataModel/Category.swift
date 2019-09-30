//
//  Category.swift
//  Todoey
//
//  Created by Andrei Giuglea on 28/09/2019.
//  Copyright © 2019 Andrei Giuglea. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    
   @objc dynamic var name : String = ""
    let items  =  List<Item>()
}
