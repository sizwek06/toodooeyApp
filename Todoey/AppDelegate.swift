//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        let data = Data()
        
        do {
            let realm = try Realm()
            }
        } catch {
            print("Error while creating Realm: \(error)")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

//MARK: - Core Data stack
    
var persistentContainer: NSPersistentContainer = {
        
    let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()//NSPersistentContainer is a type of db, this returns it if no errors occurred
    
//MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        //similar to the staging/commit stage - if comparing to git
        if context.hasChanges {
            do {
                try context.save()
                //then this is a 'push'
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

