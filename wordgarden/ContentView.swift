//
//  ContentView.swift
//  wordgarden
//
//  Created by HARO, EVAN on 1/12/26.
//

import SwiftUI

struct ContentView: View {

    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "how many guesses to uncover the hidden word?"
    @State private var currentwordindex = 0
    @State private var wordToGuess = ""
    @State private var revealedword = ""
    @State private var lettersguessed = ""
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textfieldisfocus: Bool
    private let wordsToGuess = ["SWIFT", "DOG", "CAT"]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("words Guessed: \(wordsGuessed)")
                    Text("words Missed: \(wordsMissed)")
                }
                Spacer()
                
                VStack(alignment: .trailing){
                    Text("words to Guessed: \(wordsToGuess.count - (wordsGuessed + wordsMissed))")
                    Text("words in game: \(wordsToGuess.count)")
                }
            }
            
            .padding(.horizontal)
            Spacer()
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //TODO: switch
            Text(revealedword)
                .font(.title)
            if playAgainHidden {
                HStack{
                    TextField("", text: $guessedLetter)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                            
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) {
                            guessedLetter =
                            guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastchar = guessedLetter.last else{
                                return
                            }
                            guessedLetter = String(lastchar).uppercased()
                        }
                        .focused($textfieldisfocus)
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessAletter()
                        }
                    Button("guess a letter:"){
                        guessAletter()
                    }
                    
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button("another word?"){
                    //TODO: Guess a letter button action here
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            
            Image(imageName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess[currentwordindex]
            revealedword = "_" + String(repeating: " _", count: wordToGuess.count-1)
        }
      }
    func guessAletter(){                        textfieldisfocus = false
        lettersguessed = lettersguessed + guessedLetter
        revealedword = wordToGuess.map{ letter in
            lettersguessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
        guessedLetter = """}
    }
    #Preview {
        ContentView()
    }

