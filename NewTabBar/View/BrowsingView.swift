//
//  BrowsingView.swift
//  NewTabBar
//
//  Created by Dmitry Sachkov on 18.07.2025.
//

import SwiftUI

struct BrowsingView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.blue)
                .ignoresSafeArea()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    BrowsingView()
}
