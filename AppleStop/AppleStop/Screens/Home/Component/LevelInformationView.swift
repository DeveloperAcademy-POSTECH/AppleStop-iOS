//
//  MiniInformationView.swift
//  AppleStop
//
//  Created by Mijoo Kim on 2022/04/10.
//

import SwiftUI

struct LevelInformationView: View {
    
    // MARK: - properties
    
    var nickname: String
    var userLevel: Int
    var userExp: Double = 0.6
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 150)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
                .shadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                .shadow(color: .black.opacity(0.18), radius: 2, x: 0, y: 1)
            
            VStack{
                Text(nickname).fontWeight(.medium).font(.system(size: 14))
                
                HStack(spacing: 10){
                    ProgressBarView(progress: userExp, level: userLevel)
                }.padding(.vertical, 8).frame(height: 86)
                Spacer().frame(height: 8)
            }
        }
    }
}

struct ProgressBarView: View {
    var progress: CGFloat
    var level: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10.0)
                .opacity(0.3)
                .foregroundColor(.chartGrey)
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 6.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.mainGreen)
                .rotationEffect(.degrees(-90))
            Text("LV.\(level)").font(.system(size: 14))
        }
    }
}

struct MiniInformationView_Previews: PreviewProvider {
    static var previews: some View {
        LevelInformationView(nickname: "연일읍분리수거왕", userLevel: 10)
    }
}
