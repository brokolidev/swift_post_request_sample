//
//  ContentView.swift
//  postRequestSample
//
//  Created by 플랜잇 on 2020/04/20.
//  Copyright © 2020 planit. All rights reserved.
//

import SwiftUI
import Combine

class HttpAuth: ObservableObject {
    var didChange = PassthroughSubject<HttpAuth, Never>()
    
    var authenticated = false {
        didSet {
            didChange.send(self)
        }
    }
    
    func checkDetails(username: String, password: String) {
        guard let url = URL(string: "https://api.boadream.co.kr/api/login") else { return }
        
        let body: [String: String] = ["mb_id": username, "password": password]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(data)
        }.resume()
        
    }
}

struct ContentView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var manager = HttpAuth()
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 50) {
            
            TextField("Username", text: $username).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            TextField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            Button(action: {
                print("\(self.username) and \(self.password)")
                
                self.manager.checkDetails(username: self.username, password: self.password)
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
