//
//  DataViewModel.swift
//  ChartsSamples
//
//  Created by Tony Chen on 14/2/2024.
//

import Foundation

class DataViewModel: ObservableObject {
    @Published var itemData: [ReviewData] = []
    
    init() {
        getReviewData()
    }

    func getReviewData() {
        let newData = [
            ReviewData(hour: updateHour(value: 8), views: 1500),
            ReviewData(hour: updateHour(value: 9), views: 2625),
            ReviewData(hour: updateHour(value: 10), views: 7500),
            ReviewData(hour: updateHour(value: 11), views: 3688),
            ReviewData(hour: updateHour(value: 12), views: 2988),
            ReviewData(hour: updateHour(value: 13), views: 3289),
            ReviewData(hour: updateHour(value: 14), views: 4500),
            ReviewData(hour: updateHour(value: 15), views: 9852),
            ReviewData(hour: updateHour(value: 16), views: 4560),
            ReviewData(hour: updateHour(value: 17), views: 6523),
            ReviewData(hour: updateHour(value: 18), views: 8541),
            ReviewData(hour: updateHour(value: 19), views: 12000),
            ReviewData(hour: updateHour(value: 20), views: 6900),
            ReviewData(hour: updateHour(value: 21), views: 8000)
        ]
        itemData.append(contentsOf: newData)
    }
    
    func updateHour(value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(bySettingHour: value, minute: 0, second: 0, of: Date()) ?? .now
    }
}
