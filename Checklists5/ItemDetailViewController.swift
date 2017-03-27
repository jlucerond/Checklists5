//
//  ItemDetailViewController.swift
//  Checklists5
//
//  Created by Joe Lucero on 3/11/17.
//  Copyright © 2017 Joe Lucero. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    @IBAction func cancelButtonPressed() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonPressed() {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(_controller: self, didFinishEditing: item)
        } else {
            let newItem = ChecklistItem()
            newItem.checked = false
            newItem.text = textField.text!
            
            delegate?.itemDetailViewController(self, didFinishAdding: newItem)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}


extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let oldString = textField.text! as NSString
        let newString = oldString.replacingCharacters(in: range, with: string)
        doneBarButton.isEnabled = !newString.isEmpty
        
        return true
    }
}
