import SwiftUI

protocol InputViewDelegate {
    func addTodo(text: String)
}

struct InputView: View {
    @Environment(\.presentationMode) var presentation
    let delegate: InputViewDelegate?
    @State var text: String
    var body: some View {
        VStack(spacing: 16) {
            TextField("Input Your TODO", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Add") {
                delegate?.addTodo(text: text)
                presentation.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(delegate: nil, text: "text")
    }
}
