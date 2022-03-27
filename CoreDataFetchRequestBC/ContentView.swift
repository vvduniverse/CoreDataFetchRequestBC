//
//  ContentView.swift
//  CoreDataFetchRequestBC
//
//  Created by Vahtee Boo on 27.03.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: FruitEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    var fruits: FetchedResults<FruitEntity>
    
    @State private var textFieldText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                HStack {
                    TextField("Add fruit here...", text: $textFieldText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .shadow(color: .gray, radius: 5, x: 5, y: 5)
                    
                    Button {
                        addItem()
                    } label: {
                        Text("Submit")
                    }
                    .buttonStyle(.borderedProminent)
                    .shadow(color: .gray, radius: 5, x: 5, y: 5)
                }
                .padding(.horizontal)

                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "")
                            .onTapGesture {
                                updateItem(fruit: fruit)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
                
            }
            .navigationTitle("Fruits")
        }
    }
    
    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
            newFruit.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }
    
    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity = fruits[index]
            viewContext.delete(fruitEntity)
            
            //            offsets.map { items[$0] }.forEach(viewContext.delete)
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
