//
//  AllListsViewViewController.swift
//  Checklists5
//
//  Created by Joe Lucero on 3/28/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class AllListsViewViewController: UITableViewController {
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
}

// Table View Data Source Methods
extension AllListsViewViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let list = dataModel.lists[indexPath.row]
        cell.textLabel?.text = list.name
        cell.accessoryType = .detailDisclosureButton
        
        let message = createDetailTextLabelMessage(for: list)
        cell.detailTextLabel?.text = message
        
        cell.imageView?.image = UIImage(named: list.iconName)
        
        return cell
    }
    
    func createDetailTextLabelMessage(for list: Checklist) -> String {
        let numberOfUncheckedItems = list.numberOfUncheckedItems
        if list.items.count == 0 {
            return "(No items)"
        } else if numberOfUncheckedItems == 0 {
            return "All done"
        } else if numberOfUncheckedItems == 1 {
            return "1 unchecked item"
        } else {
            return "\(numberOfUncheckedItems) unchecked items"
        }
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
}

// Table View Delegate Methods
extension AllListsViewViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
}

// Segue Methods
extension AllListsViewViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checklistToEdit = nil
        }
    }
}

// List Detail View Controller Delegate Methods
extension AllListsViewViewController: ListDetailViewControllerDelegate {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController,
                                  didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

// UI Navigation Controller Delegate Methods
// Needed to listen for when user taps back on Navigation Controller
extension AllListsViewViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}


/*
 // File Saving Methods
 extension ChecklistViewController {
 func documentsDirectory() -> URL {
 let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
 return paths[0]
 }
 
 func dataFilePath() -> URL {
 return documentsDirectory().appendingPathComponent("Checklists.plist")
 }
 
 func saveChecklistItems() {
 let data = NSMutableData()
 let archiver = NSKeyedArchiver(forWritingWith: data)
 archiver.encode(items, forKey: "ChecklistItems")
 archiver.finishEncoding()
 data.write(to: dataFilePath(), atomically: true)
 }
 
 func loadChecklistItems() {
 let path = dataFilePath()
 if let data = try? Data(contentsOf: path) {
 let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
 items = unarchiver.decodeObject(forKey: "ChecklistItems") as! [ChecklistItem]
 unarchiver.finishDecoding()
 }
 }
 }
 */
