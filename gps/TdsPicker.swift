//
//  TdsPicker.swift
//  gps
//
//  Created by Serdar Senol on 11/06/2024.
//

import Foundation
import SwiftUI

//struct TdsPicker<Label, SelectionValue, Content> : View where Label : View, SelectionValue : Hashable & Identifiable & Equatable, Content : View {
//    @Binding var selection: SelectionValue
//    
//    init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder label: () -> Label) {
//        _selection = selection
//    }
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(items) { source in
//                Button {
//                    selection = source
//                } label: {
//                    itemBuilder(source)
//                        .padding(2)
//                        //.background(selection == source ? Color.white : Color.clear)
//                        .cornerRadius(6)
//                        .foregroundColor(Color.black)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .animation(.default, value: selection)
//            }
//        }
//        .animation(.default, value: selection)
//        //.padding(8)
//        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
//        .cornerRadius(7)
//    }
//}
