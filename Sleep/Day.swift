//
//  Day.swift
//  Sleep
//
//  Created by Andreas on 4/11/21.
//

import SwiftUI


struct Day: Identifiable, Codable, Hashable {
    
    var id = UUID()
    var up: Bool
    var date: Date
    

}
struct User: Identifiable, Codable, Hashable {
    
    var id = UUID()
    var name: String
    var points: Int
    

}
