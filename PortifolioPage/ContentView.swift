//
//  ContentView.swift
//  PortifolioPage
//
//  Created by Asvin Thakur on 13/06/26.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFamilyMember: FamilyMember?
    @State private var selectedBioMember: FamilyMember?
    @State private var showBio = false
    
    private let familyMembers = [
        FamilyMember(imageName: "Dad1", name: "Pranesh Thakur", bio:"This is my Dad, Pranesh Thakur. He is a recovery Manager in SBI (State Bank of India)"),
        FamilyMember(imageName: "Mom", name: "Maneesha Thakur", bio: "This is my Mom, Maneesha Thakur. She is a homemaker and a good cook too."),
        FamilyMember(imageName: "Ashmit", name: "Ashmit Thakur", bio: "This is my younger sibling, Ashmit Thakur. We are always together with each other, fight each other but at the end stay together.")
    ]
    
    private let projects = [
        Project(name: "GitHub", urlString: "https://github.com/asvin887"),
        Project(name: "LinkedIn", urlString: "https://www.linkedin.com/in/asvin-thakur-ta128?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"),
        Project(name: "Call Me", urlString: "tel:+911234567890")
    ]
    
    var body: some View {
        TabView {
            ZStack {
                Image("Me")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                Button {
                    showBio = true
                } label: {
                    Text("Asvin Thakur")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .fontDesign(.default)
                        .bold()
                        .italic()
                        .foregroundStyle(.white)
                        .padding()
                        .glassEffect(.clear)
                        .padding()

                }
                .buttonStyle(.plain)
                .alert("About Me", isPresented: $showBio) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Hi, I’m Asvin Thakur. This is my personal portifolio app made with Swift UI on MacOS Tahoe for iPhone only. This project is uploaded on Github as of now. I am currently a BBA Student in Bharati Vidyapeeth College, Kharghar, Navi Mumbai. I am passionate for Tech and Coding . My main interest are Python, SwiftUI and BackEnd servers for the web.")
                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Me")
            }
            
            ZStack {
                LinearGradient(
                    colors: [
                        Color.pink.opacity(0.18),
                        Color.blue.opacity(0.14)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(familyMembers) { member in
                            familyCard(member: member)
                                .onLongPressGesture(minimumDuration: 0.35) {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.88, blendDuration: 0.15)) {
                                        selectedFamilyMember = member
                                    }
                                }
                        }
                    }
                    .padding()
                }
                .blur(radius: selectedFamilyMember == nil ? 0 : 10)
                
                if let selectedFamilyMember {
                    Color.black.opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            closeFamilyPreview()
                        }
                    
                    familyPreview(member: selectedFamilyMember)
                        .padding(24)
                        .transition(
                            .asymmetric(
                                insertion: .scale(scale: 0.92).combined(with: .opacity),
                                removal: .scale(scale: 0.96).combined(with: .opacity)
                            )
                        )
                        .zIndex(1)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: selectedFamilyMember)
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("My Family")
            }
            
            NavigationStack {
                ZStack {
                    RadialGradient(
                        colors: [
                            Color.green.opacity(0.35),
                            Color.orange.opacity(0.22),
                            Color.blue.opacity(0.16)
                        ],
                        center: .topLeading,
                        startRadius: 40,
                        endRadius: 520
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(projects) { project in
                                projectLink(project: project)
                            }
                        }
                        .padding()
                    }
                }
                .navigationTitle("Projects")
            }
            .tabItem {
                Image(systemName: "folder.fill")
                Text("Projects")
            }
        }
        .alert(item: $selectedBioMember) { member in
            Alert(
                title: Text(member.name),
                message: Text(member.bio),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func closeFamilyPreview() {
        withAnimation(.easeInOut(duration: 0.25)) {
            selectedFamilyMember = nil
        }
    }
    
    private func projectLink(project: Project) -> some View {
        Group {
            if let url = URL(string: project.urlString) {
                Link(destination: url) {
                    HStack(spacing: 12) {
                        Image(systemName: project.urlString.hasPrefix("tel:") ? "phone.fill" : "link")
                            .font(.headline)
                            .frame(width: 32, height: 32)
                            .glassEffect(.clear)
                        
                        Text(project.name)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .glassEffect()
                }
            }
        }
    }
    
    private func familyCard(member: FamilyMember) -> some View {
        ZStack(alignment: .bottom) {
            Image(member.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 280, alignment: .top)
                .clipped()
            
            Button {
                selectedBioMember = member
            } label: {
                Text(member.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .glassEffect(.clear)
                    .padding(12)
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private func familyPreview(member: FamilyMember) -> some View {
        ZStack(alignment: .bottom) {
            Image(member.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 460, alignment: .top)
                .clipped()
            
            Text(member.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .glassEffect()
                .padding(18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(radius: 24)
        .onTapGesture {
            closeFamilyPreview()
        }
    }
}

private struct Project: Identifiable {
    let id = UUID()
    let name: String
    let urlString: String
}

private struct FamilyMember: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let name: String
    let bio: String
}

#Preview {
    ContentView()
}
