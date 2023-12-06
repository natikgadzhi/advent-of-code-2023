// Advent of Code 2023
// Day 3: Part Numbers
// https://adventofcode.com/2023/day/3
//

import Foundation

enum BoardError: Error {
  case invalidSize
}

struct Cell: Hashable {
  let row: Int
  let col: Int
}

struct Number: Hashable {
  let left: Cell
  let right: Cell
  let value: Int
}

/// Board holds the whole puzzle board.
/// We're lucky it's rectangular and we can just hold size.
struct Board {
  // The board is square, so size holds the length of one side
  let size: Int

  // We'll store characters on the board as an array.
  // A particular sell is [row * size + col] into this array.
  var data: [Character]

  public init(_ lines: [String]) throws {
    guard Board.isValidSize(lines) else {
      throw BoardError.invalidSize
    }

    self.size = lines.count
    self.data = Array(repeating: ".", count: size * size)

    for (row, line) in lines.enumerated() {
      for (col, char) in line.enumerated() {
        self.data[row * size + col] = char
      }
    }
  }

  // Helper for nice printing
  func toString() -> String {
    var result = ""
    for i in 0..<size {
      for j in 0..<size {
        result += String(self.data[i * size + j])
      }
      result += "\n"
    }
    return result
  }

  func getCell(_ cell: Cell) -> Character {
    return self.data[cell.row * size + cell.col]
  }

  func isPartCell(_ cell: Cell) -> Bool {
    return self.data[cell.row * size + cell.col] != "." &&
            (self.data[cell.row * size + cell.col].asciiValue! < 48 || self.data[cell.row * size + cell.col].asciiValue! > 57)
  }

  func isDigitCell(_ cell: Cell) -> Bool {
    return self.data[cell.row * size + cell.col].asciiValue! >= 48 && self.data[cell.row * size + cell.col].asciiValue! <= 57
  }
  
  /// Given a digit cell (a cell that contains a digit character) returns the full
  /// `Number`, containint the number itself, and it's left and right boundary.
  func getNumber(from cell: Cell) -> Number {
    var number = ""
    var left = cell
    var right = cell

    while left.col > 0 && self.isDigitCell(Cell(row: left.row, col: left.col-1)) {
      left = Cell(row: left.row, col: left.col-1)
    }

    while right.col < size-1 && self.isDigitCell(Cell(row: right.row, col: right.col+1)) {
      right = Cell(row: right.row, col: right.col+1)
    }

    for i in left.col...right.col {
      number += String(self.getCell(Cell(row: left.row, col: i)))
    }

    return Number(left: left, right: right, value: Int(number)!)
  }

  func isGearCell(_ cell: Cell) -> Bool {
    return self.data[cell.row * size + cell.col] == "*"
  }

  // I've added this code a couple days after I solved the original day 3 puzzle
  // so expect some unnecessary complications.
  func gearRatio() -> Int {
    var gearRatioSum = 0
    var gearCells = [Cell]()

    // get all gear cells
    // get their corresponding numbers
    // filter out those that have two numbers exactly
    // calculate their ratio

    // NOTE: Sure, this can be self.data.enumberated().filter { (index, char) in }
    // but honestly that's probably more complicated to read than a nested loop
    for i in 0..<size {
      for j in 0..<size {
        if self.isGearCell(Cell(row: i, col: j)) {
          gearCells.append(Cell(row: i, col: j))
        }
      }
    }

    for gearCell in gearCells {
      var numbers = Set<Number>()
      for cell in self.getSurroundingCells(gearCell) {
        if self.isDigitCell(cell) {
          numbers.insert(self.getNumber(from: cell))
        }
      }
      if numbers.count == 2 {
        gearRatioSum +=  numbers.reduce(1) {
          $0 * $1.value
        }
      }
    }

    return gearRatioSum
  }

  func partNumbersSum() -> Int {
    
    // We'll use partCells to temporarily store the list of cells that are parts,
    // use that as a queue.
    var cellsWithParts = [Cell]()
    
    // We'll process partCells and grab all their surrounding cells. That does not _have_ to be
    // a set. If we used an array, we could process the same neighbor cell twice, BUT since
    // we're using a set to calculate the actual numbers anyway, this would not change teh answer.
    var cellsWithDigits = Set<Cell>()

    // When we process part surrounding cells, if we find any digit cells, 
    var numbers = Set<Number>()

    // We'll walk the board, and load all symbols onto a queue.
    // Then for each digit and it's incides, we will go left until we hit an emp.col cell.
    for i in 0..<size {
      for j in 0..<size {
        if self.isPartCell(Cell(row: i, col: j)) {
          cellsWithParts.append(Cell(row: i, col: j))
        }
      }
    }

    // Then, we will walk the queue and find all digits around the parts
    for partCell in cellsWithParts {
      for cell in self.getSurroundingCells(partCell) {
        if self.isDigitCell(cell) {
          cellsWithDigits.insert(cell)
        }
      }
    }

    // Then we will go left and right until we hit an emp.col cell,
    // and thus we'll get the full number.
    // We should keep track of the numbers and their start coordinates to make sure we only count a number once.
    // Then we parse the number and add it to the sum.
    for digitCell in cellsWithDigits {
      numbers.insert(self.getNumber(from: digitCell))
    }
    
    return numbers.reduce(0, { $0 + $1.value })
  }

  // Grabs cells (indices) of all neighbors of the cell on the board
  func getSurroundingCells(_ p: Cell) -> [Cell] {
    var result = [Cell]()

    if p.row > 0 {
      result.append(Cell(row: p.row-1, col: p.col))
      if p.col > 0 {
        result.append(Cell(row: p.row-1, col: p.col-1))
      }
      if p.col < size-1 {
        result.append(Cell(row: p.row-1, col: p.col+1))
      }
    }

    if p.row < size-1 {
      result.append(Cell(row: p.row+1, col: p.col))
      if p.col > 0 {
        result.append(Cell(row: p.row+1, col: p.col-1))
      }
      if p.col < size-1 {
        result.append(Cell(row: p.row+1, col: p.col+1))
      }
    }

    if p.col > 0 {
      result.append(Cell(row: p.row, col: p.col-1))
    }

    if p.col < size-1 {
      result.append(Cell(row: p.row, col: p.col+1))
    }

    return result
  }

  // Validates that the board is square
  private static func isValidSize(_ lines: [String]) -> Bool {
    let height = lines.count
    return lines.allSatisfy { $0.count == height }
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


// First validate the solution works based on the test inputs

let testInput = readLines(fromFilePath: "./test-input.txt")
guard let testInput = testInput else {
  print("Error reading input file")
  exit(1)
}
// read the inputs into a board
let testBoard = try! Board(testInput)

// validate the size 10 and the sum 4361
assert(testBoard.size == 10, "testBoard should be 10x10")
assert(testBoard.partNumbersSum() == 4361, "testBoard should have a sum of 4361")

// Now that the test passed, let's do the input board

let input = readLines(fromFilePath: "./input.txt")
guard let input = input else {
  print("Error reading input file")
  exit(1)
}

let board = try! Board(input)

print("Read the board of size: \(board.size)")
print("The sum of all part numbers is \(board.partNumbersSum())")
print("The sum gear ration is: \(board.gearRatio())")
