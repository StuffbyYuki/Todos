//
//  Item.swift
//  ToDoApp
//
//  Created by 掛川優希 on 1/16/19.
//  Copyright © 2019 Yuki Kakegawa. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var subName : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    @objc dynamic var order = 0
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
 }
