//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Myat Thu Ko on 5/8/20.
//  Copyright © 2020 Myat Thu Ko. All rights reserved.
//

import SwiftUI

struct TextStyle: View {
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.black)
    }
}

struct FlagButton: View {
    
    var position: Int
    var countries: Array<String>
    
    var body: some View {
        Image(self.countries[position])
        .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 2))
        .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var scores = 0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    TextStyle(text: "Tap the Flag of")
                        .font(.largeTitle)
                    TextStyle(text: "\"\(countries[correctAnswer])\"")
                        .font(.title)
                    TextStyle(text: "Your current score is \(scores).")
                        .font(.headline)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagButton(position: number, countries: self.countries)
                    }
                    Spacer()
                }
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(scores)."), dismissButton: .default(Text("Continue")){
                self.askQuestion()
                })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct, that is \(countries[number]) 🎉"
            scores += 1
        } else {
            scoreTitle = "Incorrect, that is \(countries[number]) 😟"
            //Condition not to allow scores below zero
            if scores == 0 {
                scores = 0
            } else {
                scores -= 1
            }
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
