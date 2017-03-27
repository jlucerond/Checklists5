//
//  ViewController.swift
//  Checklists5
//
//  Created by Joe Lucero on 3/9/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var items: [ChecklistItem]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    required init?(coder aDecoder: NSCoder) {
        items = [ChecklistItem]()
        
        let row0item = ChecklistItem()
        row0item.text = "work"
        row0item.checked = true
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "code"
        row1item.checked = false
        items.append(row1item)

        let row2item = ChecklistItem()
        row2item.text = "eat"
        row2item.checked = true
        items.append(row2item)

        let row3item = ChecklistItem()
        row3item.text = "read"
        row3item.checked = false
        items.append(row3item)

        let row4item = ChecklistItem()
        row4item.text = "workout"
        row4item.checked = false
        items.append(row4item)

        super.init(coder: aDecoder)
    }

}

// Data Source Methods
extension ChecklistViewController {
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// Delegate Methods
extension ChecklistViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            let item = items[indexPath.row]
            item.toggleCheckmark()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// Item Detail View Controller Delegate Methods
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        let newRow = items.count
        let newIndexPath = IndexPath(row: newRow, section: 0)
        items.append(item)
        
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(_controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

// Configure Labels
extension ChecklistViewController {
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let checkmarkLabel = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            checkmarkLabel.text = "√"
        } else {
            checkmarkLabel.text = ""
        }
    }
}

// Segue Methods
extension ChecklistViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: (sender as? UITableViewCell)!) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}
