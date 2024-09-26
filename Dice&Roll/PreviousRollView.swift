//
//  PreviousRollView.swift
//  Dice&Roll
//
//  Created by Mehmet Alp Sönmez on 26/09/2024.
//

import SwiftUI

struct PreviousRollView: View {
    var previousRolls = [Int]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(previousRolls.indices, id: \.self) { index in
                    Text("\(index + 1). Previously rolled: \(previousRolls[index])")
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
        }
        .ignoresSafeArea()
        .navigationTitle("Previous Rolls")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PreviousRollView()
}
