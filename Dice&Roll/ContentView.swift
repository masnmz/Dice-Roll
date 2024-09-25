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
    @State private var diceSides = [4,6,8,10,12,20,100]
    @State private var selectedDiceSide = 4
    @State private var triggerFeedback = false
    @State private var timerCounter = 0
    @State private var displayedRolledDiceForTimer = 1
    
    @State private var timer = Timer.publish(every: 0.08, on: .main, in: .common).autoconnect()
    
    let savePath = URL.documentsDirectory.appending(path: "RolledDiceResults")
    
    init() {
        
    }
    var body: some View {
        VStack(spacing: 10) {
            
            
            Button(" Let's roll", systemImage: "dice.fill") {
                timerCounter = 0
                flickerResult()
                startRolling()
                rolldice = true
                triggerFeedback.toggle()
            }
            .sensoryFeedback(.warning, trigger: triggerFeedback)
            .font(.largeTitle)
            .padding()
            
            
            Section("Select The Dice Side") {
                Picker("Dice Sides", selection: $selectedDiceSide) {
                    ForEach(diceSides, id: \.self) {
                        Text($0, format: .number)
                    }
                }
                .onChange(of: selectedDiceSide) { oldValue, newValue in
                    triggerFeedback.toggle()
                }
                .sensoryFeedback(.warning, trigger: triggerFeedback)
                .pickerStyle(.segmented)
            }
            
            
            Button("Delete Previous Rolling Results", systemImage: "xmark.bin.circle") {
                clearDiceResults()
                triggerFeedback.toggle()
            }
            .sensoryFeedback(.warning, trigger: triggerFeedback)
            .foregroundStyle(.red)
            
                List {
                    if rolldice {
                        if timerCounter < 30 {
                            Text("Rolling... \(displayedRolledDiceForTimer)")
                                
                        }
                        else {
                            Text("You rolled \(rolledDice)")
                                .foregroundStyle(.red)
                            ForEach(rollingResults.indices, id: \.self) { index in
                                Text("Previously rolled \(index + 1): \(rollingResults[index])")
                            }
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
                .listItemTint(.monochrome)
                .scrollContentBackground(.hidden)
            

            
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: loadData)
        .onReceive(timer) { _ in
            flickerResult()
            timerCounter += 1
        }
        
    }
    
    func startRolling() {
        timerCounter = 0
        rolledDice = Int.random(in: 1...selectedDiceSide)
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
    
    func flickerResult() {
        displayedRolledDiceForTimer = Int.random(in: 1...selectedDiceSide)
    }
    
    func clearDiceResults() {
        rollingResults.removeAll()
        saveData()
    }
}

#Preview {
    ContentView()
}
