//
//  Assignment.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 7/15/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class Assignment {
    let roomNumber: Int
    let participant1: String
    let participant2: String
    let participant3: String
    
    init(roomNumber: Int, participant1: Participant, participant2: Participant?, participant3: Participant?) {
        self.roomNumber = roomNumber
        self.participant1 = participant1.firstName + " " + participant1.lastName
        if let par2 = participant2 {
            self.participant2 = par2.firstName + " " + par2.lastName
        } else {
            self.participant2 = "none"
        }
        if let par3 = participant3 {
            self.participant3 = par3.firstName + " " + par3.lastName
        } else {
            self.participant3 = "none"
        }

    }
    
    convenience init(roomNumber: Int, participant1: Participant, participant2: Participant) {
        self.init(roomNumber: roomNumber, participant1: participant1, participant2: participant2, participant3: nil)
    }
    
    convenience init(roomNumber: Int, participant1: Participant) {
        self.init(roomNumber: roomNumber, participant1: participant1, participant2: nil, participant3: nil)
    }
    // MARK: Room Assignment Generator
    
    static var participantCompatabilityRating: [[Int]]?
    
    static var allParticipants: [Participant]?
    
    class func getPCR(allParticipants: [Participant]) -> [[Int]]? {
        var zeroArray = Array<Int>(count: allParticipants.count, repeatedValue: 0)
        var pcr = Array<Array<Int>>(count: allParticipants.count, repeatedValue: zeroArray)
        let ap = allParticipants
        for var par1 = 0; par1 < ap.count; par1++ {
            for var par2 = 0; par2 < ap.count; par2++ {
                var currentPCR = (abs(ap[par1].age - ap[par2].age))*2
                if par1 == par2 {
                    currentPCR = 0
                }
                if let previouslyAcquainted = ap[par2].previouslyAcquainted {
                    for acquanted in previouslyAcquainted {
                        if ap[par1].number == acquanted {
                            currentPCR = 1
                        }
                    }
                    pcr[par1][par2] = currentPCR
                }
            }
        }
        if pcr.count > 0 {
            return pcr
        } else {
            return nil
        }
    }
    
    class func assign(participants: [Participant]) -> [[Assignment]] {
        var allRoomAssignments = [[Assignment]]()
        allParticipants = participants
        while allRoomAssignments.count < 8 {
            let secondHalfOfTrip: Bool = allRoomAssignments.count >= 4 ? true : false
            let roomAssignments = getRoomAssignment(allParticipants!, secondHalfOfTrip: secondHalfOfTrip)
            if roomAssignments.count >= participants.count/2 {
                allRoomAssignments.append(roomAssignments)
            }
        }
        return allRoomAssignments
    }
    
    class func getRoomAssignment(participants: [Participant], secondHalfOfTrip: Bool) -> [Assignment] {
        var unassignedFemaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.female)
        var unassignedMaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.male)
        var roomAssignments = getRoommatesForGroup(unassignedFemaleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip)
        roomAssignments += getRoommatesForGroup(unassignedMaleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip)
        return roomAssignments
    }
    
    
    class func getParticipantsByGender(participants: [Participant], gender: Participant.Gender) -> [Participant] {
        var participantsOfGender = participants
        for var i = participantsOfGender.count; i < 0; i-- {
            if participantsOfGender[i].gender != gender {
                participantsOfGender.removeAtIndex(i)
            }
        }
        return participantsOfGender
    }
    

    class func getRoommatesForGroup(participants: [Participant], maxOccupancy: Int, secondHalfOfTrip: Bool) -> [Assignment] {
        var roomAssignments = [Assignment]()
        var unassignedParticipants = participants
        var pcr = getPCR(participants)!
        var assignmentAttempt = 0
        var roomNumber = 1
        while (!unassignedParticipants.isEmpty) {
            let numParticipants = unassignedParticipants.count
            let par1 = unassignedParticipants.removeLast()
            var roommates: [Int] = []
            let roommateIndex: [Int]?
            if  numParticipants % maxOccupancy == 0 {
                for var i = 0; i <= maxOccupancy - 1; i++ {
                    var bestMatch = 0
                    for var index = 0; index < numParticipants; index++ {
                        let pcrForCurrentParticipant = pcr[numParticipants][index]
                        if pcrForCurrentParticipant > bestMatch {
                            bestMatch = pcrForCurrentParticipant
                        }
                    }
                    roommates.append(bestMatch)
                }
                let par2 = participants[roommates[0]]
                let par3 = participants[roommates[1]]
                roomAssignments.append(Assignment(roomNumber: roomNumber++ , participant1: par1, participant2: par2, participant3: par3))
            } else {
                var bestMatch = 0
                for var index = 0; index < numParticipants; index++ {
                    let pcrForCurrentParticipant = pcr[numParticipants][index]
                    if pcrForCurrentParticipant > bestMatch {
                        bestMatch = pcrForCurrentParticipant
                    }
                }
                roommates.append(bestMatch)
            }
        }
        return roomAssignments
    }

    static var repeatRoommateExecption = true

    class func findRoommateOrRoommates(participant1: Participant, unassignedParticipants: [Participant], secondHalfOfTrip: Bool, numRoommatesToAdd: Int) -> [Int]? {
        var roommates = [Int]()
        var ageRange = 0
        var unassignedParts = unassignedParticipants
        while ageRange < 6 {
            for (index, par) in enumerate(unassignedParts) {
                var notAlreadySelected = true
                for selectedRoommates in roommates {
                    if selectedRoommates == index {
                        notAlreadySelected = false
                    }
                }
                if notAlreadySelected {
                    if isCloseInAge(participant1, par2: par, range: ageRange) {
                        if isNotPreviouslyAcquainted(participant1, par2: par) || secondHalfOfTrip {
                            if isNotPreviousRoommate(participant1, par2: par) || repeatRoommateExecption {
                                roommates.append(index)
                                if roommates.count >= numRoommatesToAdd {
                                    return roommates
                                }
                            }
                        }
                    }
                }
            }
            ageRange++
        }
        return nil
    }
    
    class func isCloseInAge(par1: Participant, par2: Participant, range: Int) -> Bool {
        return par1.age >= par2.age - range && par1.age <= par2.age + range ? true : false
    }
    
    class func isNotPreviouslyAcquainted(par1: Participant, par2: Participant) -> Bool {
        if par2.previouslyAcquainted != nil {
            for previouslyAcquainted in par2.previouslyAcquainted! {
                if par1.number == previouslyAcquainted {
                    return false
                }
            }
        }
        return true
    }
    
    class func isNotPreviousRoommate(par1: Participant, par2: Participant) -> Bool {
        for previousRoommate in par2.previousRoommate {
            if par1.number == previousRoommate {
                return false
            }
        }
        return true
    }
    
    class func rememberRoommates(participants: [Participant], par1: Participant, par2: Participant) -> [Participant] {
        var updatedParticipants = participants
        updatedParticipants[par1.number - 1].previousRoommate.append(par2.number)
        updatedParticipants[par2.number - 1].previousRoommate.append(par1.number)
        return updatedParticipants
    }
    
}


extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle()
    {
        for _ in 0..<10
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

