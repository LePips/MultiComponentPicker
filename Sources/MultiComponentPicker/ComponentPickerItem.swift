import SwiftUI

// TODO: allow full label/value view adjustment

/// An item for a `MultiComponentPicker`.
///
/// Make sure to initialize within a `View` context.
public struct ComponentPickerItem {
    
    let wrapped: any _ComponentPickerItem
    
    public init<Value: Hashable>(
        selection: Binding<Value>,
        values: [Value],
        @ViewBuilder label: @escaping (Value) -> any View = { Text("\($0)")}
    ) {
        
        self.wrapped = _AnyComponentPickerItem(
            selection: selection,
            values: values,
            label: label
        )
    }
}
