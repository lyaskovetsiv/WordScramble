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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
