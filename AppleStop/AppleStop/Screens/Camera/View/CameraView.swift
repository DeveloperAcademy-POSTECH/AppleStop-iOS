//
//  CameraView.swift
//  AppleStop
//
//  Created by SHIN YOON AH on 2022/04/07.
//

import SwiftUI
import AVFoundation
import Vision
struct CameraView: View {
    
    // MARK: - Properties
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var camera = CameraModel()
    
    // Gestures Property
    @GestureState var gestureOffset : CGFloat = 0
    
    @State var naviHide = false
    
    // MARK: - CameraView
    var body: some View {
        ZStack{
            
            CameraPreview(camera: camera)
                .navigationBarHidden(naviHide)
                .animation(.linear(duration: 0.38))
            
            if !camera.isToggleOn{
            CodeGuideLineView()
                    .alert(isPresented: $camera.showAlert) {

                        Alert(title: Text("실패"), message: Text("바코드 인식에 실패하셨습니다."), dismissButton: .default(Text("확인")))

                    }
                
            }
            bottomView
                .toast(isShowing: $camera.isShowingToast)
                .alert(isPresented: $camera.noFoundInfo) {

                    Alert(title: Text("실패"), message: Text("제품 정보를 찾을 수 없습니다."), dismissButton: .default(Text("확인")))

                }
                
             
            
            bottomSheetView
                
          
            

            
        }    .navigationTitle("카메라")
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    if camera.isTaken {
                    Button {
                            camera.reTake()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera")
                            .foregroundColor(.black)
                    }
                        if camera.isToggleOn{
                    Button {
                        if !camera.isSaved{
                            camera.savePic()
                        }
                    } label: {
                        Image(systemName: "folder")
                            .foregroundColor(.black)
                    }
                        }
                    }
                }
            }
            .onAppear {
                camera.requestAndCheckPermissions()
            }
            .background(Color.backgroundGrey)
        
    }
}



//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}


// MARK: - CameraPreview for UIkit
// 카메라미리보기창
struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) ->  UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height*0.5)
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //
    }
}

// MARK: - Extension
extension CameraView {
    
    // 토글 및 버튼포함하는 뷰
    var bottomView : some View {
        VStack(){
            
            Spacer()
            
            Toggle(isOn: $camera.isToggleOn) {}
            .toggleStyle(MyToggle())
            
            Button {
                // 카메라 촬영
                if camera.isToggleOn {
                    camera.takePic()
                }
                // 바코드 촬영
                else{
                    
                    camera.takePic()
                    
//                //FIXME: - 3초딜레이 말고 오픈API 완료하면 실행되도록
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
//                        if camera.showBottomSheet {
//                        
//                            withAnimation(.easeInOut, {
//                                print("성공")
//                                // TODO: -  디바이스 의존도 제거하기
//                                camera.offset = -270 // 범위내 임의값
//                                camera.lastOffset = camera.offset
//                            })
//                        
//                        }
//                        else{print("fail")}
//                    }
                           
                           
                    
                 
                    
                }
            } label: {
                Image(camera.isToggleOn ? "logo_camera" : "logo_barcode")
                    .resizable()
                    .frame(width: 90, height: 90)
            }
            
            .padding(.bottom,100)
            .padding(.top,20)
            
        }
    }
    // 바텀시트뷰
    var bottomSheetView : some View {
        GeometryReader{ geometryProxy -> AnyView in
            let height = geometryProxy.frame(in: .global).height
            return AnyView(
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .clipShape(CustomCorner(corners: [.topLeft,.topRight], radius: 20))
                    
                    
                    VStack(){
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 60, height: 4)
                            .padding(.top)
                        
                        
                        if -camera.offset > height / 2 {
                            //FIXME: - 어느순간 가이드디테일뷰 부르면 뷰종료됨..
                             GuideDetailView(card: GuideCard.sampleData[3])
                        //     CardView(card: GuideCard.sampleData[3])


                         }else{
                             CardView(card: GuideCard.sampleData[3])
                         }
                        
                        
                    }
                    .frame(maxHeight : .infinity, alignment: .top)
                    
                }
                    .offset(y: height - 70)
                    .offset(y: -camera.offset > 0 ? (-camera.offset <= (height - 70) ? camera.offset : -(height - 70)) : 0)
                    .gesture(DragGesture().updating($gestureOffset, body: { value, out, _ in
                        out = value.translation.height
                        onChange()
                    })
                                .onEnded({ value in
                                    
                                    let maxHeight = height
                                    withAnimation {
                                        
                                        if -camera.offset > 70 && -camera.offset < maxHeight / 2 {
                                            camera.offset = -(maxHeight * 0.4)
                                            naviHide = false
                                        }
                                        else if -camera.offset > maxHeight / 2 {
                                            camera.offset = -maxHeight
                                            naviHide = true
                                        }
                                        else {
                                            camera.offset = 0
                                        }
                                        camera.lastOffset = camera.offset
                                    }
                                })
                            )
                
            )
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    // 바텀시트 변경함수
    func onChange(){
        DispatchQueue.main.async {
            camera.offset = gestureOffset + camera.lastOffset
        }
    }
    
    
    
}


