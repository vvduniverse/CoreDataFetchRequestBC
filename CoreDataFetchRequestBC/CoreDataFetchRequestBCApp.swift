//
//  CoreDataFetchRequestBCApp.swift
//  CoreDataFetchRequestBC
//
//  Created by Vahtee Boo on 27.03.2022.
//

import SwiftUI

@main
struct CoreDataFetchRequestBCApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
