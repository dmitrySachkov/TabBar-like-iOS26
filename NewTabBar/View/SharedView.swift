//
//  SharedView.swift
//  NewTabBar
//
//  Created by Dmitry Sachkov on 18.07.2025.
//

import SwiftUI

struct SharedView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.green)
                .ignoresSafeArea()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    SharedView()
}
