// Advent of Code 2023
// Day 5: Why So Much Parsing!?
// https://adventofcode.com/2023/day/5
//

// Soooo part 2 can be solved eithe with clever range manipulation,
// or with a brute force direct approach, if you don't mind warming a core of
// your CPU for a bit and/or you miss a few brain cells, like myself.
// 
// This is a brute force implementation.
// Swift has excellent Ranges built into stdlib, but I struggled with a bug
// somewhere in an edge case that worked for the test dataset, but did not work
// for the actual task.

import Foundation

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


/// Mapping represents one pipeline mapping block and consists of it's name
/// and a list of zero or more rules.
/// A mapping can be applied to an array of numbers (part 1) 
struct Mapping {

  let rules: [Rule]
  let name: String

  public init(_ block: String) {
    let lines = block.components(separatedBy: "\n")
    self.name = lines.first!
    self.rules = lines[1..<lines.count].map { Rule($0) }
  }

  /// Apply the mapping to an array of numbers.
  func apply(to numbers: [Int]) -> [Int] {
    return numbers.map { number in
      let appliedRule = rules.first { $0.sourceRange.contains(number) }

      // If there is a rule that applies to the current number, apply it.
      // Otherwise, return the number unchanged.
      if let appliedRule {
        return appliedRule.destinationStart + (number - appliedRule.sourceStart)
      } else {
        return number
      }
    }
  }
}

/// Rule represents one rule line in a pipeline mapping block
/// and consists of three numbers:
/// - sourceStart: the start of the source range
/// - destinationStart: the start of the destination range
/// - length: the length of the range
struct Rule {
  let sourceStart: Int
  let destinationStart: Int
  let length: Int

  var sourceRange: ClosedRange<Int> {
    return sourceStart...(sourceStart + length - 1)
  }

  var destinationRange: ClosedRange<Int> {
    return destinationStart...(destinationStart + length - 1)
  }

  public init(_ string: String) {
    let parts = string.components(separatedBy: .whitespaces)

    destinationStart = Int(parts[0])!
    sourceStart = Int(parts[1])!
    length = Int(parts[2])!
  }
}

func solve(puzzleFile: String) {
  // Let's parse the seeds first
  let input = try! String(contentsOfFile: puzzleFile)
  let blocks = input.components(separatedBy: "\n\n")

  print("Read \(blocks.count) blocks!")

  // For part one, we will consider these numbers the seeds themselves. 
  let seeds = blocks.first!
    .components(separatedBy: ": ")
    .last!
    .components(separatedBy: .whitespaces)
    .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

  print("Read \(seeds.count) seeds!: \(seeds)")

  // read the mappings
  let mappings = blocks[1..<blocks.count].map {
    Mapping($0.trimmingCharacters(in: .whitespacesAndNewlines))
  }

  print("Initialized \(mappings.count) mappings!")

  // For part 1, start with the input seed numbers
  var output = seeds
  for mapping in mappings {
    output = mapping.apply(to: output)
  }

  print("Part 1 output: \(output.min()!)")

  var part2Seeds = [Int]()
  for i in stride(from: 0, through: seeds.count - 1, by: 2) {
    let part = Array(seeds[i]..<(seeds[i] + seeds[i+1]))
    print("Generated a part with \(part.count) seeds")
    part2Seeds.append(contentsOf: part)
  }

  print("Generated a total of \(part2Seeds.count) seeds")

  var part2Output = part2Seeds
  for mapping in mappings {
    print("Applying mapping \(mapping.name)")
    part2Output = mapping.apply(to: part2Output)
  }

  print("Part 2 output: \(part2Output.min()!)")

}

solve(puzzleFile: "./input.txt")
