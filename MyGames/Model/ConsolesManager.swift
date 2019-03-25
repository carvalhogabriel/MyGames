//
//  ConsolesManager.swift
//  MyGames
//
//  Created by Gabriel Carvalho Guerrero on 25/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import CoreData

class ConsolesManager {
    
    static let shared = ConsolesManager()
    
    var consoles: [Console] = []
    
    private init() {
        
    }
    
    func loadConsole(with context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Console> = Console.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            consoles = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteConsole(index: Int, context: NSManagedObjectContext) {
        let console = consoles[index]
        context.delete(console)
        do {
            try context.save()
            consoles.remove(at: index)
        } catch {
            print(error.localizedDescription)
        }
    }
}
