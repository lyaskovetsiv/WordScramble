//
//  UserScoreView.swift
//  WordScramble
//
//  Created by Иван Лясковец on 28.07.2023.
//

import SwiftUI

struct UserScoreView: View {
	
	// MARK: - States
	
	@State var title: String
	@State var score: Int
	
	// MARK: - UI
	
    var body: some View {
		VStack {
			Text(title)
				.font(.title)
			Text("Score: \(score)")
		}
		.padding()
		.frame(width: 130, height: 120)
		.border(.gray, width: 1)
    }
}
