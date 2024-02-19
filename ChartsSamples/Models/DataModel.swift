//
//  DataModel.swift
//  ChartsSamples
//
//  Created by Tony Chen on 14/2/2024.
//

import SwiftUI

struct ReviewData: Identifiable {
    var id = UUID().uuidString
    var hour: Date
    var views: Double
    var animate: Bool = false
}


