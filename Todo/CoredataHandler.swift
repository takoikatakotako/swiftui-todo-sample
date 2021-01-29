import CoreData

class CoredataHandler {
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }

    func fetchTodoManagedObject() throws -> [TodoManagedObject] {
        let context = viewContext
        let requestResult = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        let sortDescripter = NSSortDescriptor(key: "text", ascending: false)
        requestResult.sortDescriptors = [sortDescripter]
        guard let todoManagedObjects = try? context.fetch(requestResult) as? [TodoManagedObject] else {
            throw CoreDataHandlerError.fetch
        }
        return todoManagedObjects
    }
    
    func newTodoManagedObject(todo: Todo) throws {
        let context = viewContext
        _ = TodoManagedObject(context: context, todo: todo)
        try saveContext()
    }
    
    func updateNoteManagedObject (note: Todo) throws {
        let todoManagedObjects = try fetchTodoManagedObject()
        for todoManagedObject in todoManagedObjects where todoManagedObject.id == note.id {
            todoManagedObject.text = note.text
        }
        try saveContext()
    }

    func deleteNoteManagedObject(note: Todo) throws {
        let context = viewContext
        let todoManagedObjects = try fetchTodoManagedObject()
        for todoManagedObject in todoManagedObjects where todoManagedObject.id == note.id {
            context.delete(todoManagedObject)
        }
        try saveContext()
    }
}


enum CoreDataHandlerError: Error, LocalizedError {
    case fetch
    var errorDescription: String? {
        switch self {
        case .fetch: return "Fail to Fetch"
        }
    }
}
