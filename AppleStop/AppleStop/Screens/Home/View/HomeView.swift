//
//  HomeView.swift
//  AppleStop
//
//  Created by SHIN YOON AH on 2022/04/07.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - properties
    
    @State var backDegree = 90.0
    @State var frontDegree = 0.0
    @State var isFlipped = false
    @State var pushActive = false
    @AppStorage("hideTabbar") var hideTabbar : Bool = false
    @AppStorage("nickname") var nickname : String = ""
    
    let durationAndDelay : CGFloat = 0.2
    
    // MARK: Flip Card Function
    
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
    func pushCharacterView() {
        self.pushActive = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundGrey
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                        .frame(height: 22)
                    
                    LocationInformationView()
                        .padding(.horizontal, 24)
                    
                    Spacer()
                        .frame(height: 22)
                    
                    ZStack(alignment: .top) {
                        CharacterCardFrontView(degree: $frontDegree)
                            .padding(.horizontal, 24)
                        CharacterCardBackView(degree: $backDegree)
                            .padding(.horizontal, 24)
                        HStack {
                            Rectangle().opacity(0)
                                .frame(width: 80, height: 60)
                                .contentShape(Rectangle()).onTapGesture {
                                    pushCharacterView()
                                }
                            Spacer().frame(width: 180)
                            Rectangle().opacity(0)
                                .frame(width: 80, height: 60)
                                .contentShape(Rectangle()).onTapGesture {
                                    flipCard ()
                                }
                        }.frame(width: 342)
                    }
                    
                    Spacer()
                        .frame(height: 22)
                    
                    HStack(spacing: 0.0) {
                        WasteInformationView()
                            .padding(.leading, 24)
                            .padding(.trailing, 12)
                        
                        LevelInformationView(nickname: nickname, userLevel: 10)
                            .padding(.trailing, 24)
                            .padding(.leading, 12)
                    }
                    
                    Spacer()
                }
                
                NavigationLink(destination: CharacterView(),
                   isActive: self.$pushActive) {
                     EmptyView()
                }.hidden()
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                hideTabbar = false
            }
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
