//
//  ContentView.swift
//  NewTabBar
//
//  Created by Dmitry Sachkov on 18.07.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var activeTab: TabBarItem = .browsing
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundStyle(.clear)
            
            activeTab.associatedView
            
            CustomTabBarView(activeTab: $activeTab, showSearchBar: true) { isExpanded in
                
            } onSearchTextChanged: { searchText in
                
            }
        }
    }
}

#Preview {
    ContentView()
}
