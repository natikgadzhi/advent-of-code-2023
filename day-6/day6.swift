// Advent of Code 2023
// Day 6
//

// A really dumb way to do it here. 
// We don't _really_ need to iterate over ALL options of possible time and distance
// We need to get to the first one that works (left to right) and then the first one that does not (right to left)
// Everything in between are valid ways to beat the record.
//

// Time:        47     98     66     98
// Distance:   400   1213   1011   1540

struct Race {
  // Max allowed race time in milliseconds
  let time: Int
  
  // Distance record in millimeters
  let distanceRecord: Int
}

let input = [
  Race(time: 47, distanceRecord: 400),
  Race(time: 98, distanceRecord: 1213),
  Race(time: 66, distanceRecord: 1011),
  Race(time: 98, distanceRecord: 1540)
]

let part2Input = [
  Race(time: 47986698, distanceRecord: 400121310111540)
]

//Time:      7  15   30
// Distance:  9  40  200
let testInputs = [
  Race(time: 7, distanceRecord: 9), 
  Race(time: 15, distanceRecord: 40),
  Race(time: 30, distanceRecord: 200)
]

let part2TestInput = [
  Race(time: 71530, distanceRecord: 940200)
]


func solve(for races: [Race]) -> Int {
  var result = 1

  // count the ways of charging + racing in a given race that result in a distance higher than the recorded one
  
  for race in races {
    var speedOptions = 0

    //print("Analyzing race \(race)")
    for i in 1..<race.time {
      let speed = i
      let raceTimeRemaining = race.time - i

      if speed * raceTimeRemaining > race.distanceRecord {
        // print("Speed \(speed) with remaining time \(raceTimeRemaining) is fast enough fast")
        speedOptions += 1
      }
    }

    result *= speedOptions
  }

  return result
}

print("Test races output: \(solve(for: part2Input))")
