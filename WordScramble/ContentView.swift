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
	
	// MARK: - UI
	
    var body: some View {
		NavigationView {
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
			.navigationTitle(rootWord)
			.onSubmit(addNewWord)
			.onAppear(perform: startGame)
		}
    }
	
	private func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		guard answer.count > 0 else {
			return
		}
		withAnimation {
			usedWords.insert(answer, at: 0)
		}
		newWord = ""
	}
	
	private func startGame() {
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "text") {
			if let startWordsString = try? String(contentsOf: startWordsURL) {
				let words = startWordsString.components(separatedBy: "\n")
				rootWord = words.randomElement() ?? "silkworm"
				return
			}
		}
		fatalError("Could not load start.txt from Bundle.")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
