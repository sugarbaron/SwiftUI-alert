//
//  Alert.swift
//  swiftui-alert
//
//  Created by sugarbaron on 02.02.2023.
//

import SwiftUI

public extension View {
    
    func alert(if condition: Binding<Bool>,
               title: String = "",
               text: String = "",
               buttons: [Alert.Option] = [.cancel("OK")]) -> some View {
        let alert: AlertView = .init(condition, title, text, buttons)
        return overlay(condition.wrappedValue ? alert : nil)
    }
    
}

private struct AlertView : View {
    
    @Binding var active: Bool
    private let title: String
    private let text: String
    private let buttons: [Alert.Option]
    private let cancel: Alert.Option?
    
    init(_ active: Binding<Bool>, _ title: String, _ text: String, _ buttons: [Alert.Option]) {
        self._active = active
        self.title = title
        self.text = text
        self.buttons = buttons.filter { $0.role != .cancel }
        self.cancel = buttons.first { $0.role == .cancel } ?? (buttons.isEmpty ? .cancel("OK") : nil)
    }
    
    var body: some View {
        VStack() {
            if title.count > 0 { Text(title).fontWeight(.semibold).padding([.top, .bottom], 5) }
            if text.count > 0 { Text(text).fixedSize(horizontal: false, vertical: true) }
            ForEach(buttons, id: \.label) { Divider(); button(for: $0) }
            if let cancel { Divider(); button(for: cancel) }
        }.padding()
         .frame(maxWidth: width)
         .background(Color(.secondarySystemBackground))
         .cornerRadius(20)
         .shadow(color: Color(.black), radius: 5)
         .screenCover()
         .onTapGesture { if cancellable { active = false } }
    }
    
    private func button(for option: Alert.Option) -> some View {
        HStack {
            Spacer()
            Text(option.label)
                .foregroundColor(option.role == .destructive ? Color(.red) : Color(.link))
                .fontWeight(option.role == .cancel ? .semibold : .regular)
                .padding([.top, .bottom], 5)
            Spacer()
        }.background(Color(.secondarySystemBackground))
         .onTapGesture { if option.role != .cancel { option.action() }; active = false }
    }
    
    private var width: CGFloat { min((UIScreen.main.bounds.width * 0.8), 500) }
    
    private var cancellable: Bool { cancel != nil }
    
}

extension Alert {
    
    public final class Option {
        
        public let label: String
        public let role: Role
        public let action: () -> Void
        
        public init(_ label: String, role: Role = .regular, action: @escaping () -> Void = { }) {
            self.label = label
            self.role = role
            self.action = action
        }
        
        public static func cancel(_ label: String) -> Option { .init(label, role: .cancel) }
        
    }
    
}

public extension SwiftUI.Alert.Option { enum Role { case regular; case cancel; case destructive } }

public extension View {
    
    func screenCover(_ color: Color = .init(UIColor.systemBackground), opacity: Double = 0.5) -> some View {
        color.opacity(opacity)
             .ignoresSafeArea()
             .overlay(self)
    }
    
}
