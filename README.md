CustomTabBar
A customizable tab bar component built with SwiftUI, featuring smooth animations, drag gestures, and an expandable search bar.
Features

Dynamic Tab Bar: Supports a variable number of tabs with customizable icons and labels.
Drag Gestures: Allows users to switch tabs by dragging, with smooth animations and bounds checking.
Expandable Search Bar: Includes an optional search bar that expands and collapses with animation.
Responsive Layout: Adapts to different screen sizes and orientations using GeometryReader.
Keyboard Integration: Handles keyboard focus states and triggers callbacks for search bar expansion and text changes.
Customizable Styling: Uses a capsule-style background with a frosted glass effect (ultraThinMaterial).
Cross-Version Compatibility: Includes extensions for backward compatibility with iOS versions before 17.

Requirements

iOS 16.0 or later
Xcode 14.0 or later
Swift 5.7 or later

Installation

Clone the repository:git clone https://github.com/your-username/CustomTabBar.git


Open the project in Xcode.
Integrate the CustomTabBarView.swift file into your SwiftUI project.

Usage
Basic Setup
To use the CustomTabBarView, include it in your SwiftUI view hierarchy and bind it to a TabBarItem state.
import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabBarItem = .recent
    
    var body: some View {
        VStack {
            // Your content here
            CustomTabBarView(
                activeTab: $activeTab,
                showSearchBar: true,
                onSearchBarExpanded: { isExpanded in
                    print("Search bar expanded: \(isExpanded)")
                },
                onSearchTextChanged: { text in
                    print("Search text: \(text)")
                }
            )
        }
    }
}

#Preview {
    ContentView()
}

TabBarItem Enum
The TabBarItem enum defines the tabs and their associated system icons.
enum TabBarItem: String, CaseIterable {
    case recent
    case shared
    case browsing
    
    var symbol: String {
        switch self {
        case .recent: return "clock.fill"
        case .shared: return "folder.fill.badge.person.crop"
        case .browsing: return "folder.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

Customization

Show/Hide Search Bar: Set the showSearchBar parameter to true or false.
Tab Width/Height: Adjusts dynamically based on screen size, with a minimum of 60 and maximum of 90 for tab width.
Animations: Uses .bouncy and .smooth animations for tab transitions and search bar expansion.
Accent Color: Customize the accentColor property in CustomTabBarView to change the active tab highlight color.

Callbacks

onSearchBarExpanded: Triggered when the search bar expands or collapses.
onSearchTextChanged: Triggered when the search text changes.

Example
CustomTabBarView(
    activeTab: $activeTab,
    showSearchBar: true,
    onSearchBarExpanded: { isExpanded in
        // Handle search bar expansion
    },
    onSearchTextChanged: { text in
        // Handle search text changes
    }
)

Preview
To preview the component in Xcode, use the provided #Preview block:
#Preview {
    ContentView()
}

Notes

The component uses GeometryReader for responsive sizing, which may require careful integration in complex layouts.
The drag gesture is constrained to prevent out-of-bounds tab selection.
The search bar is hidden when the keyboard is active to optimize space.
The optionalGeometryGroup and customOnChange extensions ensure compatibility with older iOS versions.

Contributing

Fork the repository.
Create a new branch (git checkout -b feature/your-feature).
Commit your changes (git commit -m 'Add your feature').
Push to the branch (git push origin feature/your-feature).
Open a Pull Request.

License
This project is licensed under the MIT License. See the LICENSE file for details.
