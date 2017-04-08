//
//  Checklist.swift
//  Checklists5
//
//  Created by Joe Lucero on 3/30/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var iconName: String
    var items = [ChecklistItem]()
    var numberOfUncheckedItems: Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
        super.init()
    }
}
