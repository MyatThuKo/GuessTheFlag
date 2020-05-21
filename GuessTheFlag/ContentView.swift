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

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX:
            amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)),
            y: 0))
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    
    @State private var scores = 0

    @State private var dimImage = false
    @State private var wrongAnswer = false
    @State private var wrongAttempt = 0.0
    @State private var animationAmount = 0.0
    
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
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(self.showingScore && number != self.correctAnswer && self.dimImage ? 0.25 : 1.0)
                    .modifier(Shake(animatableData: CGFloat(self.wrongAttempt)))
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
            dimImage = true
            scoreTitle = "Correct, that is \(countries[number]) 🎉"
            scores += 1
            withAnimation {
                self.animationAmount += 360
            }
        } else {
            dimImage = false
            wrongAnswer = true
            scoreTitle = "Incorrect, that is \(countries[number]) 😟"
            
            //Condition not to allow scores below zero
            if scores == 0 {
                scores = 0
            } else {
                scores -= 1
            }
            withAnimation(.default) {
                self.wrongAttempt += 1
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
