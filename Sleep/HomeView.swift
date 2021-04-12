//
//  HomeView.swift
//  Sleep
//
//  Created by Andreas on 4/11/21.
//

import SwiftUI

struct HomeView: View {
    @Binding var users: [User]
    @Binding var name: String
    @State var hour = UserDefaults.standard.integer(forKey: "hour")
    @State var minute = UserDefaults.standard.integer(forKey: "minute")
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: name, perform: { value in
                    let defaults = UserDefaults.standard
                    defaults.set(name, forKey: "name")
                })
            Stepper(value: $hour, in: 0...25) {
                Text("Hour " + String(hour))
            }  .padding()
            .onChange(of: hour, perform: { value in
                let defaults = UserDefaults.standard
                defaults.set(hour, forKey: "hour")
            })
            Stepper(value: $minute, in: 0...60) {
                Text("Minute " + String(minute))
            } .padding()
            .onChange(of: minute, perform: { value in
                let defaults = UserDefaults.standard
                defaults.set(minute, forKey: "minute")
            })
            Spacer()
        ForEach(users, id: \.self) { user in
            HStack {
            Text(user.name)
                .font(.headline)
                .padding()
                Spacer()
            Text(String(user.points))
                .font(.headline)
                .padding()
            }
        }
    }
    }
}

