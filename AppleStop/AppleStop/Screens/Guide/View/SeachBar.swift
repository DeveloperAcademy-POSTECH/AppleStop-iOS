//
//  SeachBar.swift
//  AppleStop
//
//  Created by κΉλ³΄μ on 2022/04/10.
//

import SwiftUI

struct ContentView: View {
    
    @State var searchText = ""
    @State var searching = false
    
    let myFruits = [
        "Apple π", "Banana π", "Blueberry π«", "Strawberry π", "Avocado π₯", "Cherries π", "Mango π₯­", "Watermelon π", "Grapes π", "Lemon π"
    ]
    
    let guideCards = ["νλΌμ€ν±", "μ’μ΄", "λΉλ", "μ λ¦¬"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                SearchBar(searchText: $searchText, searching: $searching)
                
                List {
                    ForEach(myFruits.filter({ (fruit: String) -> Bool in
                        return fruit.hasPrefix(searchText) || searchText == ""
                    }), id: \.self) {
                        fruit in Text(fruit)
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle(searching ? "Searching" : "MyFruits")
                .toolbar {
                    if searching {
                        Button("Cancel") {
                            searchText = ""
                            withAnimation {
                                searching = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                    }
                }
                .gesture(DragGesture()
                            .onChanged({ _ in
                    UIApplication.shared.dismissKeyboard()
                })
                )
            }
        }
    }
}


struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var searching: Bool
    
    var body: some View {
        ZStack {
            Color.backgroundGrey
                .ignoresSafeArea()
            
            Rectangle()
                .foregroundColor(.white)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.black)
                TextField("λΆλ¦¬μκ±° λ°©λ²μ κ²μνμΈμ(ex. νλΌμ€ν±)", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
            }
            .padding(.leading, 12)
        }
        .frame(height: 40)
        .cornerRadius(8)
        .padding(.vertical)
        .customShadow()
    }
}

struct SeachBar_Previews: PreviewProvider {
    static var previews: some View {
        
        ContentView()
        
    }
}

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
