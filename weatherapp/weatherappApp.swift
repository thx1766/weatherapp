//
//  weatherappApp.swift
//  weatherapp
//
//  Created by Nate M1 on 11/15/22.
//

import SwiftUI

@main
struct weatherappApp: App {
    var network = Network()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(network)
        }
    }
}
