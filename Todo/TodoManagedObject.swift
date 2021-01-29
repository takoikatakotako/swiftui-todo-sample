import Foundation
import CoreData

@objc(TodoManagedObject)
public class TodoManagedObject: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoManagedObject> {
        return NSFetchRequest<TodoManagedObject>(entityName: "Todo")
    }

    @NSManaged public var id: UUID
    @NSManaged public var text: String

    convenience init(context: NSManagedObjectContext, todo: Todo) {
        self.init(context: context)
        self.id = todo.id
        self.text = todo.text
    }
}
