//
//  ContentView.swift
//  Dice&Roll
//
//  Created by Mehmet Alp Sönmez on 24/09/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var rolldice = false
    @State private var rolledDice = 0
    @State private var rollingResults = [Int]()
    
    let savePath = URL.documentsDirectory.appending(path: "RolledDiceResults")
    
    init() {
        
    }
    var body: some View {
        VStack {
        ScrollView {
       
            Button(" Let's roll", systemImage: "dice.fill") {
                startRolling()
                rolldice = true
            }
            .font(.largeTitle)
            if rolldice {
                Text("You rolled \(rolledDice)")
                    .foregroundStyle(.red)
                ForEach(rollingResults.indices, id: \.self) { index in
                    Text("Previously rolled \(index + 1): \(rollingResults[index])")
                }
                
            }
        }
                
        }
        .onAppear(perform: loadData)
    }
    
    func startRolling() {
        rolledDice = Int.random(in: 1...6)
        rollingResults.append(rolledDice)
        saveData()
        
    }
    
    func saveData() {
        do {
            let data = try JSONEncoder().encode(rollingResults)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Save path: \(savePath)")
            print("Data saved successfully.")
        } catch {
            print("Unable to Save data")
        }
    }
    func loadData() {
        do {
            let data = try Data(contentsOf: savePath)
            rollingResults = try JSONDecoder().decode([Int].self, from: data)
            print("Data loaded successfully: \(rollingResults)")
        } catch {
            print("Unable to load data: \(error.localizedDescription)")
            rollingResults = []
        }
    }
}

#Preview {
    ContentView()
}
