import SwiftUI

// TODO: when used inside a `List/Form/ScrollView` it can be difficult to get
//       the `Picker` scrolling instead of the parent scroll view.
//       Don't know if this is a bounding issue or just a quirk to
//       live with, but possibly find a solution for it.

/// A wheel picker for multiple components, like in the `Clock` app.
public struct MultiComponentPicker: View {
    
    let items: [any _ComponentPickerItem]
    
    public init(@ComponentPickerItemBuilder items: () -> [ComponentPickerItem]) {
        self.items = items().map(\.wrapped)
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated().map(\.offset)), id: \.self) { index in
                _ComponentPickerView(item: items[index])
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.secondary)
                .opacity(0.1)
                .frame(height: 30)
        }
    }
}
