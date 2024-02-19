//
//  Home.swift
//  ChartsSamples
//
//  Created by Tony Chen on 14/2/2024.
//

import SwiftUI
import Charts

struct Home: View {
    // MARK: State chart data for animation change
    @EnvironmentObject var dataViewModel: DataViewModel
    @State var sampleData: [ReviewData] = DataViewModel().itemData
    // MARK: View properties
    @State var currentTap: String = "7 Days"
    // MARK: Gesture properties
    @State var currentActiveItem: ReviewData?
    @State var plotWidth: CGFloat = 0
    // MARK: Chart toggle properties
    @State var isLineChart: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: New chart API
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                            Text("Views")
                                .fontWeight(.semibold)
                        
                        Picker("DatePicker", selection: $currentTap) {
                            Text("7 Days").tag("7 Days")
                            Text("Week").tag("Week")
                            Text("Month").tag("Month")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.leading, 90)
                    }
                    // Display total value
                    let totalValue = dataViewModel.itemData.reduce(0, { $0 + $1.views })
                    Text(totalValue.stringFormat)
                        .font(.largeTitle.bold())
                    
                    animatedChart()
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white.shadow(.drop(radius: 2)))
                }
                // MARK: Line chart toggle
                Toggle("Line Chart", isOn: $isLineChart)
                    .padding(.top)
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
            .padding()
            .navigationTitle("Swift Charts")
            // MARK: Simple Updated Values for Segmented tabs
            .onChange(of: currentTap) {
                dataViewModel.itemData = sampleData
                
                if currentTap != "7 Days" {
                    for (index,_) in dataViewModel.itemData.enumerated() {
                        dataViewModel.itemData[index].views = .random(in: 1500...10000)
                    }
                }
                // Animated
                animatedGraph(fromChange: true)
            }
        }
    }
    
    @ViewBuilder
    func animatedChart() -> some View {
        // Find max number in array
        let max = dataViewModel.itemData.max { item1, item2 in
            return item2.views > item1.views
        }?.views ?? 0
        Chart {
            ForEach(dataViewModel.itemData) { item in
                // MARK: Bar Chart
                // MARK: Animating Graph
                if isLineChart {
                    LineMark(x: .value("Hour", item.hour, unit: .hour),
                            y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color(.blue).gradient)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(x: .value("Hour", item.hour, unit: .hour),
                            y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color(.blue).opacity(0.1).gradient)
                    .interpolationMethod(.catmullRom)
                    
                } else {
                    BarMark(x: .value("Hour", item.hour, unit: .hour),
                            y: .value("Views", item.animate ? item.views : 0)
                    )
                    .foregroundStyle(Color(.blue).gradient)
                }
                
                // MARK: Rule mark for current drag item
                if let currentActiveItem, currentActiveItem.id == item.id {
                    RuleMark(x: .value("Hour", currentActiveItem.hour))
                    // MARK: Use dash line
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                    // MARK: Setting in middle of each bar
                        .offset(x: (plotWidth / CGFloat(dataViewModel.itemData.count)) / 2)
                    // MARK: Add Annotation
                        .annotation(position: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Views")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                Text(currentActiveItem.views.stringFormat)
                                    .font(.title3.bold())
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            )
                        }
                }
            }
        }
        // MARK: Customizing Y-Axis Length
        .chartYScale(domain: 0...(max + 5000))
        .chartOverlay(content: { proxy in
            GeometryReader { innerProxy in
                Rectangle()
                    .fill(.clear).contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                // MARK: Get current location
                                let currentLocation = value.location
                                // Extract value from current location
                                if let date: Date = proxy.value(atX: currentLocation.x) {
                                    // Extract hour
                                    let calendar = Calendar.current
                                    let hour = calendar.component(.hour, from: date)
                                    // Extract Date from A-Axis, then with help on the date, extract current item.
                                    if let currentItem = dataViewModel.itemData.first(where: { item in
                                        calendar.component(.hour, from: item.hour) == hour
                                    }) {
                                        // Get currentItem and feed into active item for Rule Mark
                                        currentActiveItem = currentItem
                                        // Get bar plit width size to plotWidth State variable and used by Rule Mark
                                        plotWidth = proxy.plotSize.width
                                    }
                                }
                            })
                            .onEnded({ value in
                                currentActiveItem = nil
                            })
                    )
            }
        })
        
        .frame(height: 250)
        .onAppear {
            animatedGraph()
        }
    }
    
    // MARK: Animating Graph
    func animatedGraph(fromChange: Bool = false) {
        for(index,_) in dataViewModel.itemData.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.03 : 0.05)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.8) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)) {
                        dataViewModel.itemData[index].animate = true
                    }
            }
        }
    }
}

extension Double {
    var stringFormat: String {
        if self >= 10000 && self < 999999 {
            return String(format: "%.1fk", self / 10000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", self / 1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", self / 1000000)
    }
}

#Preview {
    Home()
        .environmentObject(DataViewModel())
}
