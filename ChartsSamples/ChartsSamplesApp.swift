//
//  ChartsSamplesApp.swift
//  ChartsSamples
//
//  Created by Tony Chen on 14/2/2024.
//

import SwiftUI

@main
struct ChartsSamplesApp: App {
    var body: some Scene {
        WindowGroup {
            Home().environmentObject(DataViewModel())
        }
    }
}
