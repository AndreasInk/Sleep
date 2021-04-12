//
//  ContentView.swift
//  Sleep
//
//  Created by Andreas on 4/11/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
struct ContentView: View {
    @State var i = 0
    @State var days = [Day]()
    @State var hour = UserDefaults.standard.integer(forKey: "hour")
    @State var minute = UserDefaults.standard.integer(forKey: "minute")
    @State var points = UserDefaults.standard.integer(forKey: "points")
    @State var name = UserDefaults.standard.string(forKey: "name") ?? ""
    @State var id = UserDefaults.standard.string(forKey: "id") ?? UUID().uuidString
    @State var first = UserDefaults.standard.bool(forKey: "first")
    @State var users = [User]()
    @State var user = User(name: "", points: 0)
    @State var save = false
    @State var currentHeight: CGFloat = 0
    var body: some View {
       
        TabView(selection: $i) {
            HomeView(users: $users, name: $name).tabItem { Text("Home") }.tag(1)
                .onAppear() {
                    if !first {
                        let defaults = UserDefaults.standard
                        defaults.set(id, forKey: "id")
                    }
                    subscribeToKeyboardEvents()
                    self.loadUsers() { userData in
                        //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        users.removeAll()
                        self.users = userData ?? []
                    }
                
                    let components = Date().get(.hour, .minute)
                    
                    if let hour = components.hour, let minute = components.minute {
                     
                    
                        if hour == self.hour {
                            if minute == self.minute {
                                points += 10
                                let defaults = UserDefaults.standard
                                defaults.set(points, forKey: "points")
                                let db = Firestore.firestore()
                               
                                db.collection("users").document(id).setData([
                                    "points": points,
                                    "name" : name
                                    
                                ], merge: true) { err in
                                    if let err = err {
                                        print("Error updating document: \(err)")
                                    } else {
                                        print("Document successfully updated")
                                    }
                                }
                            }
                        }
                    }
                    
                  
//                    if Date().distance(to: datComp.date!) ==  {
//
//                    }
                   
                    let defaults = UserDefaults.standard
                    defaults.set(true, forKey: "first")
                }
               
            SleepResultsView(days: $days).tabItem { Text("Stats") }.tag(2)
                
        }  .onChange(of: currentHeight , perform: { value in
            if currentHeight == 0.0 {
            let db = Firestore.firestore()
           
            db.collection("users").document(id).setData([
                "points": points,
                "name" : name
                
            ], merge: true) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            }
        
        })
        
    }
    private func subscribeToKeyboardEvents() {
      NotificationCenter.Publisher(
        center: NotificationCenter.default,
        name: UIResponder.keyboardWillShowNotification
      ).compactMap { notification in
          notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
      }.map { rect in
        rect.height
      }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))

      NotificationCenter.Publisher(
        center: NotificationCenter.default,
        name: UIResponder.keyboardWillHideNotification
      ).compactMap { notification in
        CGFloat.zero
        
      }.subscribe(Subscribers.Assign(object: self, keyPath: \.currentHeight))
    }
    func loadUsers(performAction: @escaping ([User]?) -> Void) {
           let db = Firestore.firestore()
        let docRef = db.collection("users").order(by: "points", descending: true)
           var groupList:[User] = []
           //Get every single document under collection users
       
        docRef.getDocuments(){ (querySnapshot, error) in
               if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
               for document in querySnapshot.documents{
                   let result = Result {
                       try document.data(as: User.self)
                   }
                   switch result {
                       case .success(let group):
                           if var group = group {

                               groupList.append(group)
                               
                           } else {
                               
                               print("Document does not exist")
                           }
                       case .failure(let error):
                           print("Error decoding user: \(error)")
                       }
                   
                 
               }
               }
               else{
                   performAction(nil)
               }
                 performAction(groupList)
           }
           
           
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
final class KeyboardResponder: ObservableObject {
    
    @Published private(set) var currentHeight: CGFloat = 0
    
    @objc func keyBoardWillShow(notification: Notification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                currentHeight = keyboardSize.height
            }
        }
        @objc func keyBoardWillHide(notification: Notification) {
            currentHeight = 0
        }
}

