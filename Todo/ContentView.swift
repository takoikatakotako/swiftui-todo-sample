import SwiftUI
import CoreData

struct ContentView: View, InputViewDelegate {
    @State var todos: [Todo] = []
    let coredataHandler = CoredataHandler()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(todos) { todo in
                        Text(todo.text)
                    }
                    .onDelete(perform: delete)
                }
                
                NavigationLink(destination: InputView(delegate: self, text: "")) {
                    Text("Add")
                        .foregroundColor(Color.white)
                        .font(Font.system(size: 20))
                }
                .frame(width: 60, height: 60)
                .background(Color.orange)
                .cornerRadius(30)
                .padding()
                
            }
            .onAppear {
                if let todos = try? coredataHandler.fetchTodoManagedObject().map({Todo(id: $0.id, text: $0.text)})  {
                    self.todos = todos
                }
            }
            .navigationTitle("TODO")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func delete(at offsets: IndexSet) {
        let deleteTodos = offsets.map{ todos[$0] }
        for deleteTodo in deleteTodos {
            try? coredataHandler.deleteNoteManagedObject(note: deleteTodo)
        }
        todos.remove(atOffsets: offsets)
    }
    
    func addTodo(text: String) {
        let todo = Todo(id: UUID(), text: text)
        try? coredataHandler.newTodoManagedObject(todo: todo)
        todos.append(todo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
