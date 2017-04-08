//
//  DataModel.swift
//  Checklists5
//
//  Created by Joe Lucero on 4/5/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        } set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
        }
    }
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    func sortChecklists() {
        lists.sort(by: { checklist1, checklist2 in
            return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending })
    }
}

// Data Persistance Methods
extension DataModel {
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: "Checklists") as! [Checklist]
            unarchiver.finishDecoding()
            sortChecklists()
        }
    }
}

// User Defaults & First Time Running Methods
extension DataModel {
    func registerDefaults() {
        let userDefaultsForApp: [String : Any] = ["ChecklistIndex" : -1,
                                                     "FirstTime": true]
        UserDefaults.standard.register(defaults: userDefaultsForApp)
    }
    
    func handleFirstTime() {
        if UserDefaults.standard.bool(forKey: "FirstTime") {
            UserDefaults.standard.set(false, forKey: "FirstTime")
            
            let firstList = Checklist(name: "List")
            lists.append(firstList)
            indexOfSelectedChecklist = 0
            UserDefaults.standard.synchronize()
        }
    }
}










