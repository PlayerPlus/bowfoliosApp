//
//  EditProfileView.swift
//  Bowfolios-trigeeks
//
//  Created by Tianhui Zhou on 9/8/20.
//  Copyright © 2020 trigeeks. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

struct EditProfileView: View {
    @Binding var editView: Bool
    @Binding var showSheet: Bool
    @State var value: CGFloat = 0
    @State var showInterestsSelections = false
    @State var showProjectsSelections = false
    @Binding var forceReload: Bool
    
    @EnvironmentObject var session: SessionStore
    @ObservedObject var totalProjects = ProjectViewModel()
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var title = ""
    @State private var bio = "AA"
    @State private var interests: [String] = []
    @State private var projects: [String] = []
    @State private var picture = ""
    
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    @State var isUploaded = false
    
    @State var interestsArray: [String] = ["Software Engineering", "Climate Change", "HPC", "Distributed Computing", "Renewable Energy", "AI", "Visualization", "Scalable IP Networks", "Educational Technology", "Unity"]
    @State var projectsArray: [String] = []
    var body: some View {
        ZStack{
            VStack{
                
                HStack{
                    
                    Button(action: {
                        self.editView = false
                        self.showSheet = false
                        
                    }) {
                        Text("Cancel")
                            .multilineTextAlignment(.leading)
                    }.padding(.horizontal)
                    
                    Spacer()
                    
                    Text("Edit profile").font(.headline).multilineTextAlignment(.center).padding(.trailing, 12)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        self.editProfile()
                        self.editView = false
                        self.showSheet = false
                        self.forceReload.toggle()
                    }){
                        Text("Save")
                        
                        
                    }.padding(.horizontal)
                }.padding(.top, 20)
                
                Spacer()
                
                Button(action: {
                    self.showActionSheet = true
                }) {
                    if picture != "" {
                        ZStack{
                            WebImage(url: URL(string: self.picture)).renderingMode(.original).resizable().scaledToFit().frame(width:120, height: 120).clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 10)
                            
                            Image(systemName: "camera.on.rectangle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                                .shadow(radius: 10)
                        }
                    } else {
                        if image == nil {
                            ZStack{
                                
                                
                                Image("turtlerock").renderingMode(.original).resizable().scaledToFit().frame(width:120, height: 120).clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                                
                                Image(systemName: "camera.on.rectangle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                                    .shadow(radius: 10)
                            }
                        }else{
                            ZStack{
                                
                                Image(uiImage: image!).renderingMode(.original).resizable().scaledToFit().frame(width:120, height: 120).clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                                
                                Image(systemName: "camera.on.rectangle").font(.system(size: 30, weight: .regular)).foregroundColor(Color.white)
                                    .shadow(radius: 10)
                                
                            }
                        }
                    }
                }.padding(.vertical, 30).actionSheet(isPresented: $showActionSheet){
                    ActionSheet(title: Text("Add a picture"), message: nil, buttons: [
                        //button 1
                        .default(Text("Camera"), action: {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        }),
                        //button2
                        .default(Text("Photo library"), action: {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        }),
                        
                        //button3
                        .cancel()
                    ])
                }.sheet(isPresented: $showImagePicker){
                    imagePicker(image: self.$image, showImagePicker: self.$showImagePicker, sourceType: self.sourceType)
                }
                
                Spacer()
                Form{
                    HStack{
                        Text("First Name")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        
                        TextField("First Name", text: $firstName)
                            .font(.system(size: 16))
                    }
                    
                    HStack{
                        Text("Last Name")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        
                        TextField("Last Name", text: $lastName)
                            .font(.system(size: 16))
                        
                    }
                    
                    HStack{
                        Text("Title   ")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        
                        TextField("Aka?", text: $title)
                            .font(.system(size: 16))
                        
                    }
                    
                    HStack(alignment: .top){
                        Text("Bio     ")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        
                        //                    TextField("Add a Bio to your profile", text: $bio).font(.system(size: 14)).lineLimit(4)
                        //                        .multilineTextAlignment(.leading).frame(height: 100)
                        MutiLineTextField(text: self.$bio).frame(height: 100)
                    }
                    
                    HStack{
                        Text("Interests")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        Spacer()
                        Image(systemName: "chevron.down")
                        
                        
                    }.onTapGesture {
                        self.value = 0
                        UIApplication.shared.endEditing()
                        self.showInterestsSelections = true
                    }
                    
                    
                    if interests.count > 0 {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(self.interests, id: \.self) { interest in
                                    Text("  \(interest)  ")
                                        .fontWeight(.semibold)
                                        .background(Color(#colorLiteral(red: 0.4322651923, green: 0.5675497651, blue: 0.8860189915, alpha: 1)))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                }
                            }.padding()
                            
                        }
                        
                    }
                    
                    HStack{
                        Text("Projects")
                            .multilineTextAlignment(.leading).padding(.horizontal)
                        Spacer()
                        Image(systemName: "chevron.down")
                        
                        
                    }.onTapGesture {
                        self.getProjects()
                        self.value = 0
                        UIApplication.shared.endEditing()
                        self.showProjectsSelections = true
                    }
                    
                    if projects.count > 0 {
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack {
                                ForEach(self.projects, id: \.self) { interest in
                                    Text("  \(interest)  ")
                                        .fontWeight(.semibold)
                                        .background(Color(#colorLiteral(red: 0.4322651923, green: 0.5675497651, blue: 0.8860189915, alpha: 1)))
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                }
                            }.padding()
                        }
                    }
                    
                    //Spacer()
                }.offset(y: -self.value).animation(.spring()).onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
                        
                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        let height = value.height
                        
                        self.value = height - 100
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
                        self.value = 0
                    }
                }
                
            }.onAppear {
                self.getInfo()
                
            }//VStack
            Selections(showSelections: $showInterestsSelections, selectedArray: $interests, itemsArray: $interestsArray).offset(y: showInterestsSelections ? 0 : 900).animation(.linear)
            Selections(showSelections: $showProjectsSelections, selectedArray: $projects, itemsArray: $projectsArray).offset(y: showProjectsSelections ? 0 : 900).animation(.linear)
        }//ZStack
            .onAppear {
                self.totalProjects.fetchData()
                
        }
    }//body view
    
    
    // MARK: - functions
    func editProfile() {
        let db = Firestore.firestore()
        let userEmail : String = (Auth.auth().currentUser?.email)!
        print("Current user email is " + userEmail)
                
        db.collection("profiles").document(userEmail).setData(["bio": bio, "email": userEmail, "firstName": firstName, "interests": interests, "lastName": lastName, "picture": picture, "projects": projects, "title": title])
                
        //        case 1: users chose a image as their profile photo
        if let thisImage = self.image {
            uploadImage(image: thisImage, path: userEmail)
        } else {
            print("could't upload image - no image present!")
        }
    }
    
    func getInfo(){
        let db = Firestore.firestore()
        let userEmail : String = (Auth.auth().currentUser?.email)!
        
        let doc = db.collection("profiles").document(userEmail)
        doc.getDocument { (document, err) in
            if let document = document, document.exists {
                
                //document is found
                let profile = try! document.data(as: Profile.self)
                
                //fetching data and display into Textfields
                self.firstName = profile!.firstName
                self.lastName = profile!.lastName
                self.bio = profile!.bio
                self.title = profile!.title
                self.picture = profile!.picture
                self.interests = profile!.interests
                self.projects = profile!.projects
            } else {
                print("Document does not exist, it will create a new document for user")
            }
        }
    }
    
    func getProjects() {
        for each in totalProjects.projects {
            projectsArray.append(each.name)
        }
    }
    
}
// MARK: - helper functions
func uploadImage(image: UIImage, path: String){
    if let imageData = image.jpegData(compressionQuality: 0.2){
        let storage = Storage.storage()
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        storage.reference().child("profileImages/\(path)").putData(imageData, metadata: metadata){
            (_, err) in
            if let err = err{
                print("an error has happened -> \(err.localizedDescription)")
            } else {
                print("image uploaded successfully")
                let temp = storage.reference().child("profileImages/\(path)")
                temp.downloadURL { (url, err) in
                    if err == nil {
                        print(url!)
                        Firestore.firestore().collection("profiles").document(path).updateData(["picture": "\(url!)"])
                    } else {
                        print("Cannot download the url")
                        
                    }
                }
            }
        }
        
    } else {
        print("could't unwrap/case image to data")
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - helper views



struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(editView: .constant(true), showSheet: .constant(true), forceReload: .constant(false))
    }
}
