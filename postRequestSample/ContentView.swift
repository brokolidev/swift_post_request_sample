//
//  ContentView.swift
//  postRequestSample
//
//  Created by 플랜잇 on 2020/04/20.
//  Copyright © 2020 planit. All rights reserved.
//

import SwiftUI
import Combine

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}


struct User: Codable {
    
    let mbNo: Int
    let mbId, apiToken, mbName, mbEmail, mbHp, mb10: String
    
}

struct PaymentInfo: Codable {
    
    let RD, RI, RP1, LD, ALL: String
    
}


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
        request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in

            if let error = error {
                print("Error \(error)")
            }

            if let response = response as? HTTPURLResponse {
                if(response.statusCode == 422) {
                    print("로그인에 실패하였습니다.")
                } else {
                    
                    guard let data = data else { return }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let userInfo = try! decoder.decode(User.self, from: data)
                    
                    let paymentData = Data(userInfo.mb10.utf8)
                    let paymentInfo = try! decoder.decode(PaymentInfo.self, from: paymentData)
                    
                    print(paymentInfo)
                    
                }
            }
            
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
            
            Spacer()
            
        }.padding()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
