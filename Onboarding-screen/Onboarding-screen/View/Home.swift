//
//  Home.swift
//  Onboarding-screen
//
//  Created by Md Shohidur Rahman on 9/20/23.
//

import SwiftUI

struct Home: View {
    @State private var activeInfo: PageInfo = pageInfos[0]
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var keyboardHeight: CGFloat = 0
   
    var body: some View {
        
        ZStack {
            Color.gray
                .opacity(0.1)
                .ignoresSafeArea()
            GeometryReader { proxy in
                
                let size = proxy.size
                InfoView(info: $activeInfo, size: size){
                    VStack(spacing: 10){
                        CustomTextField(text: $email, hint: "Email", leadingIcon: Image(systemName: "envelope"))
                        
                        CustomTextField(text: $password, hint: "Password", leadingIcon: Image(systemName: "lock"), isPassword: true)
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            
                        } label: {
                            Text("Continue")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical,15)
                                .frame(maxWidth: .infinity)
                                .background {
                                    Capsule()
                                        .fill(.blue)
                                }
                        }

                    }
                    .padding(.top,25)
                }
            }
            .ignoresSafeArea(.keyboard, edges: .all)
            .offset(y: -keyboardHeight)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)){ output in
                if let info = output.userInfo, let height =
                    (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)? .cgRectValue.height {
                    keyboardHeight = height
                }
                
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) {_ in
                keyboardHeight = 0
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0), value: keyboardHeight)
            
        }
       
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct InfoView<ActionView: View>: View {
    @Binding var info: PageInfo
    var size:CGSize
    var actionView: ActionView
    
    @State private var showView: Bool = false
    @State private var hideWholeView: Bool = false
    
    
    init(info: Binding<PageInfo>, size: CGSize,@ViewBuilder actionView: @escaping () -> ActionView) {
        self._info = info
        self.size = size
        self.actionView = actionView()
    }
    
    var body: some View {
        VStack{
            //image view
            GeometryReader { proxy in
                let size = proxy.size
                
                Image(info.infoAssetImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)
            }
            .offset(y: showView ? 0 : -size.height / 2)
            .opacity(showView ? 1 : 0)
            
            // Title & Action's
            
            VStack(alignment: .leading,spacing: 10){
                Spacer(minLength: 0)
                
                Text(info.title)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                
                Text(info.subTitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top,10)
                
                if !info.displayAction {
                    Group {
                        Spacer(minLength: 25)
                        
                        CustomIndicatorView(totalPages: filteredPages.count, currentPage: filteredPages.firstIndex(of: info) ?? 0)
                        
                        
                        Spacer(minLength: 10)
                        
                        Button {
                            changInfo()
                        } label: {
                            Text("Next")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: size.width * 0.4)
                                .padding(.vertical,10)
                                .background(Capsule().fill(.blue))
                        }
                        .frame(maxWidth: .infinity)
                        
                    }
                } else {
                    actionView
                        .offset(y: showView ? 0 : size.height / 2)
                        .opacity(showView ? 1 : 0)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .offset(y: showView ? 0 : size.height / 2)
            .opacity(showView ? 1 : 0)
            .padding(20)
        }
        .offset(y: hideWholeView ? size.height / 2 : 0)
        .opacity(hideWholeView ? 0 : 1)
        .overlay(alignment: .topLeading){
            if info != pageInfos.first {
                Button {
                    changInfo(true)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                        .contentShape(Rectangle())
                        .padding()
                }
                .offset(y: showView ? 0 : -200)
                .offset(y: hideWholeView ? -200 : 0)

            }
        
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8,blendDuration: 0).delay(0.1)){
                showView = true
            }
        }
        
    }
    
    //Updating page info
    
    func  changInfo(_ isPrevious: Bool = false){
        
        withAnimation(.spring(response: 0.8, dampingFraction: 0.8,blendDuration: 0).delay(0.1)){
            hideWholeView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if let index = pageInfos.firstIndex(of: info),(isPrevious ? (index != 0) : index
                                                           != pageInfos.count - 1) {
                info = isPrevious ? pageInfos[index - 1] : pageInfos[index + 1]
            } else {
                info = isPrevious ? pageInfos[0] : pageInfos[pageInfos.count - 1]
            }
            
            hideWholeView = false
            showView = false
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8,blendDuration: 0)){
                showView = true
            }
            
            
        }
        
    }
    
    var filteredPages: [PageInfo] {
        return pageInfos.filter{!$0.displayAction}
    }
}
