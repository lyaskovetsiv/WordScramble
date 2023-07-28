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
				}
				
				Section {
					ForEach(usedWords, id: \.self) { word in
						Text(word)
					}
				}
			}
			.navigationTitle(rootWord)
			.onSubmit(addNewWord)
		}
    }
	
	private func addNewWord() {
		let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
		guard answer.count > 0 else {
			return
		}
		usedWords.insert(answer, at: 0)
		newWord = ""
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
