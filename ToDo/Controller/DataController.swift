//
//  DataController.swift
//  ToDo
//
//  Created by Khoa Vu on 8/10/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit
import CoreData

class DataController: NSObject {
    
    static let shared: DataController = DataController()

    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Todo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func addNewItem(_ id: Int32, name: String, doneStatus: Bool) {
        
        let managedContext = persistentContainer.viewContext
        let item = TodoItem(context: managedContext)
        item.id = id
        item.name = name
        item.doneStatus = doneStatus
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllData() -> [TodoItem]? {
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoItem")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            return result as? [TodoItem]
        } catch {
            
        }
        
        return nil
    }
    
    func deleteData(_ item: TodoItem){
        
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(item)
        
        do{
            try managedContext.save()
        }
        catch
        {
            print(error)
        }
        
    }
}
