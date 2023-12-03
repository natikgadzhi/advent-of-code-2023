// Advent of Code 2023
// Day 2: Games.
// https://adventofcode.com/2023/day/2
//

// NOTE: This I think came out to be way too overengineered,
// and only covers the part 1 of the puzzle.
// I've tried to write safe and idiomatic swift without force unwraps,
// and it becomes rather verbose.
//


import Foundation

/// Represents a color of a cube.
/// This is used to switch on colors based on keys rather than strings.
enum Color: String {
  case red = "red"
  case green = "green"
  case blue = "blue"
}

/// Errors for the game parser
enum GameError: Error {
  case errorParsingGameID
  case errorParsingGameContent
  case errorParsingColorNumbers
  case errorParsingColorName
}

/// The number of cubes of a sinble color in a single grab.
struct ColorNumber {
  let color: Color
  let number: Int

  /// Parses a String into a ColorNumber.
  /// Throws an error if the input string is malformed and can't be parsed.
  public init (_ string: String) throws {
    let components = string.components(separatedBy: " ")
    guard let numberString = components.first, let colorString = components.last else {
      throw GameError.errorParsingColorNumbers
    }

    guard let color = Color(rawValue: String(colorString)) else {
      throw GameError.errorParsingColorName
    }

    guard let number = Int(String(numberString)) else {
      throw GameError.errorParsingColorNumbers
    }

    self.color = color
    self.number = number
  }
}

/// Single Draw of cubes out of the bag in a game.
struct Draw {

  // These should never change, but since the compiler can't guarantee they won't
  // change in a switch statement, it's more readable to set them to vars instead
  // of dancing around.
  var red: Int
  var green: Int
  var blue: Int

  public init (_ string: String) throws {
    let colors = try string.components(separatedBy: ", ").map { colorNumberString in
      try ColorNumber(colorNumberString)
    }

    red = 0
    green = 0
    blue = 0

    for singleColor in colors {
      switch singleColor.color {
        case .red:
          self.red = singleColor.number
        case .green:
          self.green = singleColor.number
        case .blue:
          self.blue = singleColor.number
      }
    }
  }
}

/// A game of cubes:
/// Example: "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red"
struct Game {
  let ID: Int
  let red: Int
  let green: Int
  let blue: Int

  public init (_ string: String) throws {
    let components = string.components(separatedBy: ": ")

    // Safely split the game ID substring, extract the game ID and parse it into an integer.
    guard let idComponent = components.first,
      let idString = idComponent.components(separatedBy: " ").last,
      let id = Int(idString as String) else {
      throw GameError.errorParsingGameID
    }

    guard let drawStrings = components.last else {
      throw GameError.errorParsingGameContent
    }

    // Parsing draws might error out, and if it does, the error will propagate upstream.
    let draws = try drawStrings.components(separatedBy: "; ").map { drawString in
      try Draw(drawString)
    }

    guard let red = draws.map(\.red).max(),
          let green = draws.map(\.green).max(),
          let blue = draws.map(\.blue).max()
          else {
      throw GameError.errorParsingGameContent
    }

    self.ID = id
    self.red = red
    self.green = green
    self.blue = blue
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


//
// We'll filter the games based on the total available number of cubes
//

let maxRed = 12
let maxGreen = 13
let maxBlue = 14

guard let inputLines = readLines(fromFilePath: "./input.txt") else {
  print("Can't read input file.")
  exit(1)
}

print("Read \(inputLines.count) lines.")

var games = [Game]()
do {
  games = try inputLines.map { try Game($0) }
} catch {
  print("Error parsing input: \(error)")
  exit(1)
}

let validGames = games.filter { game in
  game.blue <= maxBlue &&
  game.green <= maxGreen &&
  game.red <= maxRed
}

let sumOfIDs = validGames.map(\.ID).reduce(0, +)

print("Number of valid games: \(validGames.count)")
print("Sum of valid game IDs: \(sumOfIDs)")

