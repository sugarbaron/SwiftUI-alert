//
//  ContentView.swift
//  swiftui-alert
//
//  Created by sugarbaron on 02.02.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var alert: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            Toggle("alert", isOn: $alert).fixedSize(horizontal: true, vertical: true)
            Spacer()
        }
        .padding()
        .alert(if: $alert, title: "Title", text: textExample, buttons: buttons)
    }
    
    private let buttons: [Alert.Option] = [
        .init("some action 1") { print("executing action 1") },
        .init("some action 2") { print("executing action 2") },
        .init("delete", role: .destructive) { print("executing action delete") },
        .init("cancel", role: .cancel)
    ]
    
    private let textExample: String = """
                                      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
                                      """
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
