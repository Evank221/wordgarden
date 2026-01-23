//
//  ContentView.swift
//  wordgarden
//
//  Created by HARO, EVAN on 1/12/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    
    private static let maximumGuesses = 8
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "how many guesses to uncover the hidden word?"
    @State private var currentwordindex = 0
    @State private var wordToGuess = ""
    @State private var revealedword = ""
    @State private var lettersguessed = ""
    @State private var guessesRemaining = maximumGuesses
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Another word?"
    @State private var audioplayer: AVAudioPlayer!
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
                .frame(height: 80)
                .minimumScaleFactor(0.5)
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
                            updateGamePlay()
                        }
                    Button("guess a letter:"){
                        guessAletter()
                        updateGamePlay()
                    }
                    
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button(playAgainButtonLabel){
                    if currentwordindex == wordsToGuess.count {
                        currentwordindex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another word?"
                    }
                    
                    wordToGuess = wordsToGuess [currentwordindex]
                    revealedword = "_" + String (repeating: " _", count: wordToGuess.count-1)
                    lettersguessed = ""
                    guessesRemaining = ContentView.maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    gameStatusMessage = "how many guesses to uncover the hidden word?"
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeIn(duration: 0.75), value: imageName)
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
    }
    func updateGamePlay(){
        gameStatusMessage = "you've made \(lettersguessed.count) guess\(lettersguessed.count == 1 ? "" : "es")"
        if  !wordToGuess.contains(guessedLetter){
            guessesRemaining -= 1
            imageName = "wilt\(guessesRemaining)"
            playSound(soundName: "incorrect")
            //delay change
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75){
                imageName = "flower\(guessesRemaining)"
            }
        } else {
            playSound(soundName: "correct")
        }
        
        
        if !revealedword.contains("_"){// guessed when no "_" in revealword
            gameStatusMessage = "you guessed it! it took you \(lettersguessed.count) guesses to guess the word."
            wordsGuessed += 1
            currentwordindex += 1
            playAgainHidden = false
            playSound(soundName: "words-guessed")
        }else if guessesRemaining == 0 {
            //wordsmissed
            gameStatusMessage = "so sorry, you're all out of guesses."
            wordsMissed += 1
            currentwordindex += 1
            playAgainHidden =  false
            playSound(soundName: "words-not-guessed")
        }
        if currentwordindex == wordsToGuess.count{
            playAgainButtonLabel = "Restart game?"
            gameStatusMessage = gameStatusMessage + "\nYou've tried all of the words. restart from the beginning?"
        }
        guessedLetter = ""
    }
    
    func playSound(soundName: String){
        if audioplayer != nil && audioplayer.isPlaying {
            audioplayer.stop()
        }
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 could not read file named \(soundName)")
            return
        }
        do {
            audioplayer = try AVAudioPlayer (data: soundFile.data)
            audioplayer.play()
        } catch {
            print("😡error: \(error.localizedDescription) creating audioPlayer")
        }
    }
}
    
    #Preview {
        ContentView()
    }

