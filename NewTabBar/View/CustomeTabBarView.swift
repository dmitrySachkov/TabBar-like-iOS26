//
//  CustomeTabBarView.swift
//  NewTabBar
//
//  Created by Dmitry Sachkov on 18.07.2025.
//

import SwiftUI

enum TabBarItem: String, CaseIterable {
    case recent
    case shared
    case browsing
    
    var symbol: String {
        switch self {
        case .recent:
            return "clock.fill"
        case .shared:
            return "folder.fill.badge.person.crop"
        case .browsing:
            return "folder.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
    
    @ViewBuilder
    var associatedView: some View {
        switch self {
        case .recent:
            RecentView()
        case .shared:
            SharedView()
        case .browsing:
            BrowsingView()
        }
    }
}

struct CustomTabBarView: View {
    
    @Binding var activeTab: TabBarItem
    var showSearchBar: Bool = false
    var onSearchBarExpanded: (Bool) -> Void
    var onSearchTextChanged: (String) -> Void
    @GestureState private var isActive: Bool = false
    @State private var isInitialStateSet: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat?
    @State private var isSearchExpanded: Bool = false
    @State private var searchText: String = ""
    @FocusState private var isKeyboardActive: Bool
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let tabs = TabBarItem.allCases.prefix(showSearchBar ? 4 : 5)
            let tabItemWidth = max(min(size.width / CGFloat(tabs.count + (showSearchBar ? 1 : 0)), 90), 60)
            let tabItemHeight: CGFloat = 56
            
            ZStack {
                if isInitialStateSet {
                    let minLayout = isKeyboardActive ? AnyLayout(ZStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(spacing: 12))
                    minLayout {
                        let tabLayout = isSearchExpanded ? AnyLayout(ZStackLayout()) : AnyLayout(HStackLayout(spacing: 0))
                        tabLayout {
                            ForEach(tabs, id: \.rawValue) { tab in
                                TabItemView(tab,
                                            width: isSearchExpanded ? 45 : tabItemWidth,
                                            height: isSearchExpanded ? 45 : tabItemHeight)
                                .opacity(isSearchExpanded ? (activeTab == tab ? 1 : 0) : 1)
                            }
                        }
                        .background(alignment: .leading) {
                            ZStack {
                                Capsule(style: .continuous)
                                    .stroke(.gray.opacity(0.3), lineWidth: 3)
                                    .opacity(isActive ? 1 : 0)
                                
                                Capsule(style: .continuous)
                                    .fill(.background)
                            }
                            .compositingGroup()
                            .frame(width: tabItemWidth,
                                   height: tabItemHeight)
                            .scaleEffect(isActive ? 1.3 : 1)
                            .offset(x: isSearchExpanded ? 0 : dragOffset)
                            .opacity(isSearchExpanded ? 0 : 1)
                        }
                        .padding(3)
                        .background(TabBarBackground())
                        .overlay {
                            if isSearchExpanded {
                                Capsule()
                                    .foregroundStyle(.clear)
                                    .contentShape(.capsule)
                                    .onTapGesture {
                                        withAnimation(.bouncy) {
                                            isSearchExpanded = false
                                        }
                                    }
                            }
                        }
                        .opacity(isKeyboardActive ? 0 : 1)
                        
                        if showSearchBar {
                            ExpandableSearchBar(isSearchExpanded ? 45 : tabItemHeight)
                        }
                    }
                    .optionalGeometryGroup()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .onAppear {
                guard !isInitialStateSet else { return }
                dragOffset = CGFloat(activeTab.index) * tabItemWidth
                isInitialStateSet = true
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 25)
        .padding(isKeyboardActive ? 10 : 0)
        .animation(.bouncy, value: dragOffset)
        .animation(.bouncy, value: isActive)
        .animation(.smooth, value: activeTab)
        .animation(.easeInOut(duration: 0.25), value: isKeyboardActive)
        .customOnChange(value: isKeyboardActive) {
            onSearchBarExpanded($0)
        }
        .customOnChange(value: searchText) {
            onSearchTextChanged($0)
        }
    }
    
    @ViewBuilder
    private func TabItemView(_ tab: TabBarItem,
                             width: CGFloat,
                             height: CGFloat) -> some View {
        let tabs = TabBarItem.allCases.prefix(showSearchBar ? 4 : 5)
        let count = tabs.count - 1
        VStack(spacing: 6) {
            Image(systemName: tab.symbol)
                .font(.title2)
                .symbolVariant(.fill)
            if !isSearchExpanded {
                Text(tab.rawValue)
                    .font(.caption2)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(activeTab == tab ? accentColor : Color.primary)
        .frame(width: width, height: height)
        .contentShape(.capsule)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isActive, body: { _, out, _ in
                    out = true
                })
                .onChanged { value in
                    let xOffset = value.translation.width
                    if let lastDragOffset {
                        let newDragOffset = lastDragOffset + xOffset
                        dragOffset = max(min(newDragOffset, CGFloat(count) * width), 0)
                    } else {
                        lastDragOffset = dragOffset
                    }
                }
                .onEnded { value in
                    lastDragOffset = nil
                    let landingIndex = Int((dragOffset / width).rounded())
                    
                    if tabs.indices.contains(landingIndex) {
                        dragOffset = CGFloat(landingIndex) * width
                        activeTab = tabs[landingIndex]
                    }
                }
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    dragOffset = CGFloat(tab.index) * width
                    activeTab = tab
                }
        )
        .optionalGeometryGroup()
    }
    
    @ViewBuilder
    private func TabBarBackground() -> some View {
        ZStack {
            Capsule(style: .continuous)
                .stroke(.gray.opacity(0.25), lineWidth: 1.5)
            
            Capsule(style: .continuous)
                .fill(.background.opacity(0.8))
            
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .compositingGroup()
    }
    
    @ViewBuilder
    private func ExpandableSearchBar(_ height: CGFloat) -> some View {
        let searchLayout = isKeyboardActive ? AnyLayout(HStackLayout(spacing: 12)) : AnyLayout(ZStackLayout(alignment: .trailing))
        
        searchLayout {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(isSearchExpanded ? .body : .title2)
                    .foregroundStyle(isSearchExpanded ? .gray : .primary)
                    .frame(width: isSearchExpanded ? nil : height, height: height)
                    .onTapGesture {
                        withAnimation(.bouncy) {
                            isSearchExpanded = true
                        }
                    }
                    .allowsHitTesting(!isSearchExpanded)
                
                if isSearchExpanded {
                    TextField("Search...", text: $searchText)
                        .focused($isKeyboardActive)
                    
                }
            }
            .padding(.horizontal, isSearchExpanded ? 15 : 0)
            .background(TabBarBackground())
            .optionalGeometryGroup()
            .zIndex(1)
            
            Button {
                isKeyboardActive = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: height, height: height)
                    .background(TabBarBackground())
            }
            .opacity(isKeyboardActive ? 1 : 0)
        }
    }
    
    var accentColor: Color {
        return .blue
    }
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func optionalGeometryGroup() -> some View {
        if #available(iOS 17, *) {
            self
                .geometryGroup()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func customOnChange<T: Equatable>(value: T, result: @escaping (T)->()) -> some View {
        if #available(iOS 17, *) {
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        }
    }
}
