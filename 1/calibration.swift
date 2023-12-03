// Advent of Code 2023
// Day 1: Trebuchet!?
//

// Oh gawd string index manipulation in Swift is awkward. 
// Anyway, run this with `swift calibration.swift`

import Foundation

/// read the input file
/// and return the array of lines in the file
func readInputs(inputPath: String) -> [String]? {
  let input = try? String(contentsOfFile: inputPath)
  guard let input = input else {
    return nil
  }

  let lines = input.split(separator: "\n").map { String($0) }
  return lines
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


guard let lines = readInputs(inputPath: "input.txt") else {
  print("Could not read input file. Is `input.txt` in the right spot?")
  exit(1)
}

let calibrationValuesSum = lines.map {
  calibrationValue(from: $0)
}.reduce(0, { $0 + Int($1) })

print("The sum of all calibration values is \(calibrationValuesSum)")
