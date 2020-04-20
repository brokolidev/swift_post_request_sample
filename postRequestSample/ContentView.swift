//
//  ContentView.swift
//  postRequestSample
//
//  Created by 플랜잇 on 2020/04/20.
//  Copyright © 2020 planit. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 50) {
            
            TextField("Username", text: $username).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button(action: {
//                print("clicked")
                print("\(self.username) and \(self.password)")
            }) {
                Text("Login")
            }
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
