import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedResults(Person.self) var persons
    @State private var isAddPersonSheetPresented = false
    @State private var isEditPersonSheetPresented = false
    @State private var newPersonName = ""
    @State private var newPersonAge = ""
    @State private var selectedPerson: Person? = nil
    
    var body: some View {
        NavigationView {
            List {
                ForEach(persons) { person in
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.headline)
                        Text("Age: \(person.age)")
                            .font(.subheadline)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedPerson = person
                        newPersonName = person.name
                        newPersonAge = String(person.age)
                        isEditPersonSheetPresented.toggle()
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            $persons.remove(person)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                Button {
                    isAddPersonSheetPresented.toggle()
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $isAddPersonSheetPresented) {
                NavigationView {
                    Form {
                        TextField("Name", text: $newPersonName)
                        TextField("Age", text: $newPersonAge)
                    }
                    .navigationTitle("Add Person")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            isAddPersonSheetPresented = false
                        },
                        trailing: Button("Save") {
                            if let age = Int(newPersonAge) {
                                let person = Person(name: newPersonName, age: age)
                                $persons.append(person)
                            }
                            isAddPersonSheetPresented = false
                            newPersonName = ""
                            newPersonAge = ""
                        }
                    )
                }
            }
            .sheet(isPresented: $isEditPersonSheetPresented) {
                NavigationView {
                    Form {
                        TextField("Name", text: $newPersonName)
                        TextField("Age", text: $newPersonAge)
                    }
                    .navigationTitle("Edit Person")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            isEditPersonSheetPresented = false
                        },
                        trailing: Button("Update") {
                            if let person = selectedPerson,
                               let age = Int(newPersonAge) {
                                let thawedPerson = person.thaw()
                                try? thawedPerson?.realm?.write {
                                    thawedPerson?.name = newPersonName
                                    thawedPerson?.age = age
                                }
                            }
                            isEditPersonSheetPresented = false
                            newPersonName = ""
                            newPersonAge = ""
                            selectedPerson = nil
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
