// Advent of Code 2023
// Day 4: Winning Cards
// https://adventofcode.com/2023/day/4
//

import Foundation

struct Game {
  let cards: [Card]

  var winningNumbersScore: Int {
    return cards.map(\.score).reduce(0, +)
  }

  // That's the part 2 of the puzzle, and it's messy.
  //
  // The idea is to build a list of cards that a card indices will copy in `copies`
  // Then, hold an array of scores that each card will generate.
  // To do that, we map out the copy indices first, and then we walk backwards
  // add the scores based on the number of copies of each card that we would generate.
  var countCardsScore: Int {
    var copies = [[Int]](repeating: [Int](), count: cards.count)
    var scores = [Int](repeating: 1, count: cards.count)

    for card in cards {
      let copiesRange = (card.cardNumber)..<(card.cardNumber+card.matchesCount)
      copies[card.cardNumber-1] = copiesRange.map { $0 }
    }

    for i in stride(from: cards.count-1, to: -1, by: -1) {
      for j in copies[i] {
        scores[i] += scores[j]
      }
    }

    return scores.reduce(0, +)
  }

  public init(_ lines: [String]) {
    self.cards = lines.map { Card($0) }
  }
}

struct Card {
  let cardNumber: Int

  let winningNumbers: [Int]
  let numbers: [Int]

  var score: Int {
    return ( max(pow(2, self.matchesCount - 1), 0) as NSDecimalNumber).intValue
  }

  var matchesCount: Int {
    self.numbers.filter({ self.winningNumbers.contains($0) }).count
  }

  // Unlike day-2 and day-3 code, this has a lot of force unwraps. 
  // Which is fine, honestly, we know the specific inputs, so if it runs, it runs.
  init(_ line: String) {
    let parts = line.components(separatedBy: ":")

    cardNumber = Int(parts.first!.components(separatedBy: .whitespaces).last! as String)!

    let numberGroups = parts.last!.components(separatedBy: "|")

    self.winningNumbers = numberGroups.first!
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespaces)
      .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

    self.numbers = numberGroups.last!
      .trimmingCharacters(in: .whitespaces)
      .components(separatedBy: .whitespaces)
      .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
  }

  func debugDescription() -> String {
    return "Card \(self.cardNumber): \(self.winningNumbers) | \(self.numbers). Score: \(self.score)"
  }
}

/// read the input file
/// and return the array of lines in the file
func readLines(fromFilePath: String) -> [String]? {
  let input = try? String(contentsOfFile: fromFilePath)
  guard let input = input else {
    return nil
  }

  // split returns an [StringProtocol], not [String], so we cast them.
  let lines = input.split(separator: "\n").map { String($0) }
  return lines
}

// Test data
//
let testData = readLines(fromFilePath: "./test-input.txt")!
print("Reading test data: read \(testData.count) items")

let testGame = Game(testData)
print("Test game score: \(testGame.winningNumbersScore) (should be 13)")
print("Game score in part 2: \(testGame.countCardsScore) (should be 30)")

// Part 1
//
let data = readLines(fromFilePath: "./input.txt")!
print("Reading data: read \(data.count) items")

let game = Game(data)
print("Game score: \(game.winningNumbersScore) (should be 24733)")

print("Game score in part 2: \(game.countCardsScore) (should be )")
