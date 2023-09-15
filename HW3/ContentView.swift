//
//  ContentView.swift
//  HW3
//
//  Created by octopus on 9/14/23.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = "John"
    @State var showHello: Bool = false
    @State var backgroundColor: Color = Color.white
    
    var body: some View {
        TabView {
            HomeView(backgroundColor: $backgroundColor)
                .tabItem{
                    Label("Home", systemImage: "house")
            }
            Settings(backgroundColor: $backgroundColor)
                .tabItem{
                    Label("Settings",
                    systemImage: "gearshape")
                    }

        }
    }
}

struct Quote: Decodable {
    let q: String
    let a: String
    let h: String
}

// Make the function async and specify a return type
func getRandomQuote() async -> (String?, String?) {
    do {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://zenquotes.io/api/random")!)
        let decodedResponse = try JSONDecoder().decode([Quote].self, from: data)
        return (decodedResponse.first?.q, decodedResponse.first?.a)
    } catch {
        print("Error: \(error.localizedDescription)")
        return (nil, nil)
    }
}

struct HomeView: View {
    @Binding var backgroundColor: Color
    @State var quote: String = "I don't stop when I'm tired, I stop when I'm done"
    @State var author: String = "David Goggins"
    @State var showingAlert = false
    
    var body: some View {
        VStack {
            Text("\(quote) - \(author)")
            .padding(50)
            .multilineTextAlignment(.center)
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(7)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.black, lineWidth: 1)
                )
            
            Button("Refresh ↝"){
                // Call the function using an async task
                showingAlert = true
            }
            .alert("Reset Settings", isPresented: $showingAlert){
                Button("Confirm", role: .none){
                    Task {
                        let newQuote = await getRandomQuote()
                        quote = newQuote.0 ?? ""
                        author = newQuote.1 ?? ""
                    }
                }
                Button("Cancel", role: .none){
                }
            }
            .padding(20)
            .background(Color.indigo)
            .foregroundColor(Color.white)
            .cornerRadius(7)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.black, lineWidth: 1)
                )
            .offset(y:100)
            
        }
        .padding()
        .frame(width: 400, height: 700)
        .background(backgroundColor)
    }

}

struct DetailView: View {
    @Binding var backgroundColor: Color
    var body: some View {
        VStack{
            Button("Randomize the background color ↝"){
                backgroundColor = randomColor()
                // Call the function using an async task
            }
            .padding(20)
            .background(Color.indigo)
            .foregroundColor(Color.white)
            .cornerRadius(7)
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .stroke(Color.black, lineWidth: 1)
                )
            .offset(y:100)
        }
        .padding()
        .frame(width: 400, height: 700)
        .background(backgroundColor)
    }
}

struct Settings: View {
    @Binding var backgroundColor: Color
    @State var showingSheet = false
    
    var body: some View{
        NavigationStack{
            VStack{
                NavigationLink("Customize the App") {
                    DetailView(backgroundColor: $backgroundColor)
                }
                .frame(width: 400, height: 50)
                .background(Color.black)
                .foregroundColor(Color.white)
                
                Button("Reset all Settings"){
                    showingSheet = true
                }
                .frame(width: 400, height: 50)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .sheet (isPresented: $showingSheet) {
                    SheetView(backgroundColor: $backgroundColor)
                }
                
            }
            .position(x:180, y:100)
            .padding()
            .navigationTitle("Settings")
            .background(backgroundColor)
        }
    }
}

struct SheetView: View {
    @Environment (\.dismiss) var dismiss
    @Binding var backgroundColor: Color
    var body: some View {
        Button ("Press to Reset Color") {
            backgroundColor = Color.white
            dismiss()
        }
        .padding(20)
        .background(Color.indigo)
        .foregroundColor(Color.white)
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.black, lineWidth: 1)
            )
        .offset(y:100)
    }
}

func randomColor() -> Color {
    return Color(
        red: Double.random(in: 0.5...1),
        green: Double.random(in: 0.5...1),
        blue: Double.random(in: 0.5...1)
    )
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
