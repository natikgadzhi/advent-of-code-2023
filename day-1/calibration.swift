// Advent of Code 2023
// Day 1: Trebuchet!?
//

// Oh gawd string index manipulation in Swift is awkward. 
// Anyway, run this with `swift calibration.swift`

// String(contentsOfFile:) is in foundation, so we need to require it.
// We could read the file with fopen and friends, though.
import Foundation

// Wasteful to make this every function call, so we'll use that in global space.
let digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

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

/// Replaces spelled digits in one String and returns it.
/// 195one should become 1951
/// eighthree should become 83
func replaceSpelledDigits(in input: String) -> String {
  var result = input

  var replacements = [Range<String.Index>: String]()

  for digit in digits {
    if let range = input.range(of: digit) {
      replacements[range] = digit
    }
  }

  return result
}

/// Replaces spelled digits, like 'one', 'two', etc with actual digits in the
/// array of strings.
/// 
/// That's a hightly inefficient way of doing the part 2 of day 1 puzzle ;)
func replaceSpelledDigits(in inputLines: [String]) -> [String] {
  return inputLines.map{ replaceSpelledDigits(in: $0) }
}

/// calibrationValue reads a string and
/// calculates a value comprised of the first and the last digit characters
/// in said string.
/// If the there are no digits, calibrationValue returns 0
/// If there's only one digit, calibrationValue returns that digit times 11
func calibrationValue(from input: String) -> UInt8 {

  var firstDigit, secondDigit: UInt8?
  var firstDigitIndex = 0

  for (index, character) in input.enumerated() {
    if character.asciiValue! >= 48 && character.asciiValue! <= 57 {
      firstDigit = character.asciiValue! - 48
      firstDigitIndex = index
      break
    }
  }

  for (_, character) in input[input.index(input.startIndex, offsetBy: firstDigitIndex + 1)...].reversed().enumerated() {
    if character.asciiValue! >= 48 && character.asciiValue! <= 57 {
      secondDigit = character.asciiValue! - 48
      break
    }
  }

  if firstDigit != nil {
    if secondDigit != nil {
      return firstDigit! * 10 + secondDigit!
    }

    return firstDigit! * 11
  }

  return 0
}


guard let lines = readLines(fromFilePath: "./input.txt") else {
  print("Could not read input file. Is `input.txt` in the right spot?")
  exit(1)
}

let inputLines = replaceSpelledDigits(in: lines)

print("Input lines: \(inputLines.count)")

let calibrationValuesSum = inputLines.map {
  calibrationValue(from: $0)
}.reduce(0) {
  $0 + Int($1)
}

print("The sum of all calibration values is \(calibrationValuesSum)")
