//
//  StatsView.swift
//  Sleep
//
//  Created by Andreas on 4/11/21.
//

import SwiftUI

struct SleepResultsView: View {
    @Binding var days: [Day]
    @State private var date = Date()
    @State var day = Day(up: false, date: Date())
    var body: some View {
        ZStack {
            Color.clear
                .onAppear() {
                    for day in days {
                        let components = date.get(.day, .month, .year)
                        let components2 = day.date.get(.day, .month, .year)
                        if let today = components2.day, let month = components.month, let year = components.year {
                        if let today2 = components.day, let month2 = components.month, let year2 = components.year {
                            print("day: \(day), month: \(month), year: \(year)")
                        
                        if "\(today)" + "\(month)" + "\(year)" == "\(today2)" + "\(month2)" + "\(year2)" {
                            self.day = day
                        }
                        }
                        }
                    }
                }
            VStack {
        DatePicker("", selection: $date, displayedComponents: .date)
                             .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
                            // .frame(maxHeight: 600)
            .onChange(of: date, perform: { value in
                for day in days {
                    let components = date.get(.day, .month, .year)
                    let components2 = day.date.get(.day, .month, .year)
                    if let today = components2.day, let month = components.month, let year = components.year {
                    if let today2 = components.day, let month2 = components.month, let year2 = components.year {
                        print("day: \(day), month: \(month), year: \(year)")
                    
                    if "\(today)" + "\(month)" + "\(year)" == "\(today2)" + "\(month2)" + "\(year2)" {
                        self.day = day
                    }
                    }
                    }
                    if date == day.date {
                        self.day = day
                    }
                }
            })
       
        Text("Woke up on time: \(day.up ? "yes" : "no")")
            .font(.headline)
    }
        } .padding()
}
}


extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
