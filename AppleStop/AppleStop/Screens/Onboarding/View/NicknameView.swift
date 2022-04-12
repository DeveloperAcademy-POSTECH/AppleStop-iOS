//
//  Nickname.swift
//  AppleStop
//
//  Created by Seik Oh on 2022/04/07.
//
import SwiftUI
import Combine

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

struct NicknameView: View {
    //@State var name: String = ""
    //@AppStorage("nickname") var nickname : String = UserDefaults.standard.string(forKey: "nickname")
    @AppStorage("nickname") var nickname : String = ""
    let textLimit = 8
    
    var body: some View {
        ZStack{
            VStack{
                VStack{
                    VStack{
                        HStack{
                            Text("닉네임 설정")
                                .font(.title)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, -3.0)
                            Spacer()
                        }
                        HStack{
                            Text("수거딱대에서 사용할 닉네임을 입력해주세요.")
                                .foregroundColor(Color.iconGrey)
                            Spacer()
                        }
                        
                        //Textfield
                        ZStack{
                            TextField("", text: $nickname)
                                .ignoresSafeArea(.keyboard) //키보드가 올라오면 알아서 설정하기 버튼이 올라갑니다
                                .onReceive(Just(nickname)) { _ in limitText(textLimit) }
                                .multilineTextAlignment(.center)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1).frame(width: UIScreen.screenWidth * 0.92, height: UIScreen.screenHeight * 0.06,  alignment: .center))
                            
                        }
                        .padding()
                    }
                    //글자수 나타내기
                    HStack{
                        Spacer()
                        Text("\(nickname.count)/8")
                            .foregroundColor(Color.charOrange)
                            .padding(.top,0.0)
                    }
                }
                
                //설정하기 버튼
                Spacer()
                NavigationLink(destination: HomeView()) {
                    Text("설정하기")
                        .font(.title3)
                        .fontWeight(.bold)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white)
                            .frame(width: UIScreen.screenWidth * 0.75, height: UIScreen.screenHeight * 0.06,  alignment: .center))
                        .foregroundColor(Color.charOrange)
                        .customShadow()
                }
            }
            .padding()
        }
    }
    
    //8글자로 제한
    func limitText(_ upper: Int) {
        if nickname.count > upper {
            nickname = String(nickname.prefix(upper))
        }
    }
}

struct NicknameView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameView()
    }
}
