import SwiftUI
import SwiftUIIntrospect

/// A builder for `ComponentPickerItem`s
@resultBuilder
public struct ComponentPickerItemBuilder {

    public static func buildBlock(_ components: [ComponentPickerItem]...) -> [ComponentPickerItem] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expression: ComponentPickerItem) -> [ComponentPickerItem] {
        [expression]
    }

    public static func buildOptional(_ component: [ComponentPickerItem]?) -> [ComponentPickerItem] {
        component ?? []
    }

    public static func buildEither(first component: [ComponentPickerItem]) -> [ComponentPickerItem] {
        component
    }

    public static func buildEither(second component: [ComponentPickerItem]) -> [ComponentPickerItem] {
        component
    }

    public static func buildArray(_ components: [[ComponentPickerItem]]) -> [ComponentPickerItem] {
        components.flatMap { $0 }
    }
}

protocol _ComponentPickerItem: Hashable {
    associatedtype Value: Hashable
    
    var selection: Binding<Value> { get }
    var values: [Value] { get }
    var label: (Value) -> any View { get }
}

struct _AnyComponentPickerItem<Value: Hashable>: _ComponentPickerItem {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(values.hashValue)
        hasher.combine(id)
    }
    
    static func == (lhs: _AnyComponentPickerItem<Value>, rhs: _AnyComponentPickerItem<Value>) -> Bool {
        false
    }
    
    let selection: Binding<Value>
    let values: [Value]
    let label: (Value) -> any View
    
    private let id: Int
    
    init(
        selection: Binding<Value>,
        values: [Value],
        label: @escaping (Value) -> any View
    ) {
        self.selection = selection
        self.values = values
        self.label = label
        
        self.id = UUID().hashValue
    }
}

struct _ComponentPickerView: View {
    
    @State
    private var updateSelection: AnyHashable!
    
    let item: any _ComponentPickerItem
    
    init(item: any _ComponentPickerItem) {
        
        func initialSelection<Value: _ComponentPickerItem>(item: Value) -> AnyHashable {
            AnyHashable(item.selection.wrappedValue)
        }
        
        self.item = item
        self._updateSelection = State(initialValue: initialSelection(item: item))
    }
    
    // unwrap existential
    @ViewBuilder
    private func actuallyMakePicker<Item: _ComponentPickerItem>(for item: Item) -> some View {
        Picker("", selection: $updateSelection) {
            ForEach(item.values, id: \.hashValue) { value in
                HStack(spacing: 0) {
                    Color.clear
                        .overlay(alignment: .trailing) {
                            Text("\(value)")
                                .monospacedDigit()
                        }
                    
                    Color.clear
                }
                .tag(Optional(AnyHashable(value)))
            }
        }
        .introspect(.picker(style: .wheel), on: .iOS(.v15), .iOS(.v16), .iOS(.v17)) { pickerView in
            pickerView.subviews.forEach { v in
                v.backgroundColor = nil
            }
        }
        .pickerStyle(.wheel)
        .overlay {
            HStack(spacing: 0) {
                Color.clear
                
                Color.clear
                    .overlay(alignment: .leading) {
                        AnyView(item.label(updateSelection as! Item.Value))
                    }
            }
        }
        .onChange(of: updateSelection) { newValue in
            item.selection.wrappedValue = newValue as! Item.Value
        }
    }
    
    private func makePicker(for item: any _ComponentPickerItem) -> some View {
        AnyView(actuallyMakePicker(for: item))
    }
    
    var body: some View {
        makePicker(for: item)
            .animation(.linear(duration: 0.1), value: updateSelection)
    }
}

