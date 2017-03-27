//
//  ChecklistItem.swift
//  Checklists5
//
//  Created by Joe Lucero on 3/10/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject {
    var text = ""
    var checked = false
    
    func toggleCheckmark() {
        checked = !checked
    }

}
