//
//  ViewController.swift
//  ToDoList
//
//  Created by Kafkas Baranseli on 02/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import Cocoa
import CoreData

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var notesEntryTxtFld: NSTextField!
    @IBOutlet weak var checkBoxBtn: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteBtn: NSButton!
    
    
    
    var toDoItems : [ToDoItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getToDoItems()
    }

    // to get todoitems from CoreData
    func getToDoItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
           
            do {
                // set the to class property
           toDoItems = try context.fetch(ToDoItem.fetchRequest())
            
            } catch {}
        }
        
        // update the table
        tableView.reloadData()
    }
    
    
    
    @IBAction func addBtnClicked(_ sender: Any) {
        
        if notesEntryTxtFld.stringValue != "" {
            
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = notesEntryTxtFld.stringValue
                if checkBoxBtn.state.rawValue == 0 {
                    toDoItem.important = false
                } else {
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                
                notesEntryTxtFld.stringValue = ""
                checkBoxBtn.state = NSControl.StateValue(rawValue: 0)
                
                getToDoItems()
                
            }
            
        }
        
    }
    

    // MARK: - TableView Stuff
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
       
         let toDoItem = toDoItems[row]
        
        if tableColumn!.identifier.rawValue == "importanceColumn" {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {
               
                if toDoItem.important {
                    
                
                cell.textField?.stringValue = "❗️"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        } else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "whatToDo"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                
                return cell
            }
        }
      return nil
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        
        let toDoItem = toDoItems[tableView.selectedRow]
     if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
        context.delete(toDoItem)
         (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
        getToDoItems()
        
        deleteBtn.isHidden = true
        }
    }
    
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        deleteBtn.isHidden = false
    }
}
