//
//  RoomAssignment.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 8/23/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class RoomAssignment {
    var femaleParticipants = [Participant]()
    var maleParticipants = [Participant]()
    var femaleGroupPCR = [[Int]]()
    var maleGroupPCR = [[Int]]()
    var roomAssignments = [Assignment]()
    let participantsPerRoom = 3
    
//    init(participants: [Participant]) {
//        self.femaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.female)
//        self.maleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.female)
//    }

    func assign(participants: [Participant]) -> [[Assignment]]{
        //split participants by gender
        femaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.female)
        maleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.male)
        
        var allRoomAssignments = [[Assignment]]()
        while allRoomAssignments.count < 8 {
            let secondHalfOfTrip: Bool = allRoomAssignments.count >= 4 ? true : false
            let roomAssignments = getRoomAssignment(secondHalfOfTrip)
            allRoomAssignments.append(roomAssignments)
        }
        return allRoomAssignments
    }
    
    func getRoomAssignment(secondHalfOfTrip: Bool) -> [Assignment] {
        var roomAssignments = getRoommatesForFemales(femaleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip)
        roomAssignments.extend(getRoommatesForMales(maleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip))
        return roomAssignments
    }
    
    func getParticipantsByGender(participants: [Participant], gender: Participant.Gender) -> [Participant] {
        var participantsOfGender = [Participant]()
        for par in participants {
            if par.gender == gender {
                participantsOfGender += [par]
            }
        }
        return participantsOfGender
    }
    
    func getRoommatesForFemales(participants: [Participant], maxOccupancy: Int, secondHalfOfTrip: Bool) -> [Assignment] {
        var roomAssignments = [Assignment]()
        var unassignedParticipants = participants
        var assignmentAttempt = 0
        femaleGroupPCR = getParticipantCompatabilityRating()
        var roomNumber = 1
        while (!unassignedParticipants.isEmpty) {
            let numParticipants = unassignedParticipants.count
            let par1 = unassignedParticipants.removeLast()
            var roommates = Array<Int>(count: maxOccupancy, repeatedValue: 0)
//            let roommateIndex: [Int]?
            if  numParticipants % maxOccupancy == 0 {
                for var i = 0; i <= maxOccupancy - 1; i++ {
                    var bestMatch = 0
                    for var index = 0; index < numParticipants; index++ {
                        let pcrForCurrentParticipant = femaleGroupPCR[numParticipants-1][index]
                        if pcrForCurrentParticipant > bestMatch {
                            bestMatch = pcrForCurrentParticipant
                            roommates[i] = index
                        }
                    }
                    femaleGroupPCR[roommates[i]][numParticipants-1] = 1
                    femaleGroupPCR[numParticipants-1][roommates[i]] = 1
//                    roommates.append(bestMatch)
                }
                let par2 = participants[roommates[0]]
                let par3 = participants[roommates[1]]
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: par1, participant2: par2, participant3: par3))
            } else {
                var bestMatch = 0
                for var index = 0; index < numParticipants; index++ {
                    let pcrForCurrentParticipant = femaleGroupPCR[numParticipants-1][index]
                    if pcrForCurrentParticipant > bestMatch {
                        bestMatch = pcrForCurrentParticipant
                    }
                }
                roommates.append(bestMatch)
            }
        }
        return roomAssignments
    }
    
    func getRoommatesForMales(participants: [Participant], maxOccupancy: Int, secondHalfOfTrip: Bool) -> [Assignment] {
        var roomAssignments = [Assignment]()
        var unassignedParticipants = participants
        var assignmentAttempt = 0
        maleGroupPCR = getParticipantCompatabilityRating()
        var roomNumber = 1
        while (!unassignedParticipants.isEmpty) {
            let numParticipants = unassignedParticipants.count
            let par1 = unassignedParticipants.removeLast()
            var roommates = Array<Int>(count: maxOccupancy, repeatedValue: 0)
            //            let roommateIndex: [Int]?
            if  numParticipants % maxOccupancy == 0 {
                for var i = 0; i <= maxOccupancy - 1; i++ {
                    var bestMatch = 0
                    for var index = 0; index < numParticipants; index++ {
                        let pcrForCurrentParticipant = maleGroupPCR[numParticipants-1][index]
                        if pcrForCurrentParticipant > bestMatch {
                            bestMatch = pcrForCurrentParticipant
                            roommates[i] = index
                        }
                    }
                    maleGroupPCR[roommates[i]][numParticipants-1] = 1
                    maleGroupPCR[numParticipants-1][roommates[i]] = 1
                    //                    roommates.append(bestMatch)
                }
                let par2 = participants[roommates[0]]
                let par3 = participants[roommates[1]]
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: par1, participant2: par2, participant3: par3))
            } else {
                var bestMatch = 0
                for var index = 0; index < numParticipants; index++ {
                    let pcrForCurrentParticipant = maleGroupPCR[numParticipants-1][index]
                    if pcrForCurrentParticipant > bestMatch {
                        bestMatch = pcrForCurrentParticipant
                    }
                }
                roommates.append(bestMatch)
            }
        }
        return roomAssignments
    }

    
    
    func getParticipantCompatabilityRating() -> [[Int]] {
        let parGroup = femaleParticipants
        var zeroArray = Array<Int>(count: parGroup.count, repeatedValue: 0)
        var pcr = Array<Array<Int>>(count: parGroup.count, repeatedValue: zeroArray)
        for var par1 = 0; par1 < parGroup.count; par1++ {
            for var par2 = 0; par2 < parGroup.count; par2++ {
                var currentPCR = (abs(parGroup[par1].age - parGroup[par2].age))*2
                if par1 == par2 {
                    currentPCR = 0
                }
                if let previouslyAcquainted = parGroup[par2].previouslyAcquainted {
                    for acquanted in previouslyAcquainted {
                        if parGroup[par1].number == acquanted {
                            currentPCR = 1
                        }
                    }
                    pcr[par1][par2] = currentPCR
                }
            }
        }
        return pcr
    }

    
}
