//
//  HomeView.swift
//  Bowfolios-trigeeks
//
//  Created by Tianhui Zhou on 9/7/20.
//  Copyright © 2020 trigeeks. All rights reserved.
//

import SwiftUI
import Pages


struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore
    @State var selected = 0
    @State var isExpand = false
    
    var body: some View {
        VStack {
            TopBar(selected: $selected, isExpand: $isExpand)
            MainView(selected: $selected)
            Button(action: {
                self.session.signOut()
            }) {
                Image(systemName: "clear.fill").resizable().frame(width: 25, height: 25).padding()
                
                Text("Quit").fontWeight(.regular)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: -Navigation Menu

struct TopBar: View {
    @Binding var selected: Int
    @Binding var isExpand: Bool
    var body: some View {
        VStack(spacing: 20) {
            HStack {
//                Image("logo").resizable()
//                .frame(width: 50, height: 50)
                Text("Bowfolios").font(.system(size: 30)).fontWeight(.semibold).foregroundColor(Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)))
                Spacer()
                

                // profile button
                VStack {
                    Button(action: {
                        self.isExpand.toggle()
                    }) {
                        DesignedButton(buttonText: "person").font(.system(size: 45)).foregroundColor(Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)))
                    }
                }
            }
            
            
            // Four navigation menu button
            HStack{
                Button(action: {
                    self.selected = 0
                }) {
                        Text("Profiles").fontWeight(.semibold).foregroundColor(
                        self.selected == 0 ? Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                }
                Spacer()
                Button(action: {
                    self.selected = 1
                }) {
                        Text("Projects").fontWeight(.semibold).foregroundColor(self.selected == 1 ? Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                }
                Spacer()
                Button(action: {
                    self.selected = 2
                }) {
                    Text("Interests").fontWeight(.semibold).foregroundColor(self.selected == 2 ? Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                }
                Spacer()
                Button(action: {
                    self.selected = 3
                }) {
                    Text("Filter").fontWeight(.semibold).foregroundColor(self.selected == 3 ? Color(#colorLiteral(red: 0.4268223047, green: 0.5645358562, blue: 0.9971285462, alpha: 1)) : Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                }
                
            }
           
        }.padding()
        .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)!)
        .background(
                ZStack {
                    Color(#colorLiteral(red: 0.786849916, green: 0.8632053137, blue: 1, alpha: 1))
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .foregroundColor(Color.white)
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)
                    RoundedRectangle(cornerRadius: 0, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.843988955, green: 0.9167951345, blue: 0.9955160022, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )

                        .blur(radius: 2)
                        .padding(2)
                }
        )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white, lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color(#colorLiteral(red: 0.7972047925, green: 0.8879345059, blue: 0.9982059598, alpha: 1)), radius: 20, x: 20, y: 20)
            .shadow(color: Color.white, radius: 20, x: -20, y: -20)
    }
}

// MARK: -Main Content View

struct MainView: View {
    @Binding var selected: Int
    var body: some View {
        
        Pages(currentPage: $selected, navigationOrientation: .horizontal, transitionStyle: .scroll, hasControl: false) { () -> [AnyView] in
            AuthView()
            TestView()
            
        }
    }
}
