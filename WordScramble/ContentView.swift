//
//  ContentView.swift
//  WordScramble
//
//  Created by Иван Лясковец on 26.07.2023.
//

import SwiftUI

struct ContentView: View {
	
	// MARK: - States
	
	@State private var usedWords = [String]()
	@State private var rootWord = ""
	@State private var newWord = ""
	@State private var errorTitle = ""
	@State private var errorMessage = ""
	@State private var showingError = false
	@State private var playerOneScore = 0
	@State private var playerTwoScore = 0
	@State private var isFirstPlayer: Bool = true
	
	// MARK: - UI
	
    var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Spacer()
				HStack {
					VStack {
						Text("Player 1")
							.font(.title)
						Text("Score: \(playerOneScore)")
					}
					.padding()
					.frame(width: 130, height: 120)
					.border(.gray, width: 1)
					VStack {
						Text("Player 2")
							.font(.title)
						Text("Score: \(playerTwoScore)")
					}
					.padding()
					.frame(width: 130, height: 120)
					.border(.gray, width: 1)
				}

				List {
					Section {
						TextField("Enter your word", text: $newWord)
							.autocapitalization(.none)
					}
					Section {
						ForEach(usedWords, id: \.self) { word in
							HStack {
								Image(systemName: "\(word.count).circle")
								Text(word)
							}
							
						}
					}
				}
				.navigationTitle(rootWord.capitalized)
				.toolbar(content: {
					ToolbarItemGroup {
						Button("Restart game", action: startGame)
					}
				})
			}
			.onSubmit(addNewWord)
			.onAppear(perform: startGame)
			.alert(errorTitle, isPresented: $showingError) {
				Button("OK", role: .cancel) { }
			} message: {
				Text(errorMessage)
			}
		}
    }
}

// MARK: - Private methods

extension ContentView {
	private func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		guard answer.count > 0 else {
			return
		}
		
		guard isSameOriginWord(word: answer) else {
			wordError(title: "An original word",
					  message: "Be more creative")
			return
		}
		
		guard isMoreThanThreeLetters(word: answer) else {
			wordError(title: "Small word",
					  message: "Word can't be shoter than 3 letters")
			return
		}
		
		guard isOriginal(word: answer) else {
			wordError(title: "Word used already",
					  message: "Be more original")
			return
		}
		
		guard isPossibleWord(word: answer) else {
			wordError(title: "Word not possible",
					  message: "You can't spell this word from \(rootWord)")
			return
		}
		
		guard isCorrect(word: answer) else {
			wordError(title: "Word not recognized",
					  message: "You can't just make them up")
			return
		}
		
		withAnimation {
			usedWords.insert(answer, at: 0)
		}
		
		if isFirstPlayer {
			playerOneScore += answer.count
		} else {
			playerTwoScore += answer.count
		}
		
		isFirstPlayer.toggle()
		
		newWord = ""
	}
	
	private func startGame() {
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWordsString = try? String(contentsOf: startWordsURL) {
				let words = startWordsString.components(separatedBy: "\n")
				rootWord = words.randomElement() ?? "silkworm"
				playerOneScore = 0
				playerTwoScore = 0
				usedWords.removeAll()
				return
			}
		}
		fatalError("Could not load start.txt from Bundle.")
	}
	
	// Checks
	
	private func isSameOriginWord(word: String) -> Bool  {
		rootWord != word
	}
	
	private func isMoreThanThreeLetters(word: String) -> Bool {
		word.count > 2
	}
	
	private func isOriginal(word: String) -> Bool {
		!usedWords.contains(word)
	}
	
	private func isPossibleWord(word: String) -> Bool {
		var tempWord = rootWord
		for letter in word {
			if let pos = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: pos)
			} else {
				return false
			}
		}
		return true
	}
	
	private func isCorrect(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange =  checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		return misspelledRange.location == NSNotFound
	}
	
	private func wordError(title: String, message: String) {
		errorTitle = title
		errorMessage = message
		showingError = true
	}
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
