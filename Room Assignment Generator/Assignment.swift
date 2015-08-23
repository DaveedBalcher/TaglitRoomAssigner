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
//    {
//        let zeroArray = Array<Int>(count: allParticipants!.count , repeatedValue: 0)
//        var pcr = Array<Array<Int>>(count: allParticipants!.count , repeatedValue: zeroArray)
//        pcr = [[0],[0]]
//        if let ap = allParticipants {
//            for var par1 = 0; par1 < ap.count; par1++ {
//                for var par2 = 0; par2 < ap.count; par2++ {
//                    var currentPCR = (abs(ap[par1].age - ap[par2].age))*2
//                    if par1 == par2 {
//                        currentPCR = 0
//                    }
//                    if let previouslyAcquainted = ap[par2].previouslyAcquainted {
//                        for acquanted in previouslyAcquainted {
//                            if ap[par1].number == acquanted {
//                                currentPCR = 1
//                            }
//                        }
//                    }
//                    pcr[par1][par2] = currentPCR
//                }
//            }
//        }
//        return pcr
//    }
    
    static var allParticipants: [Participant]?
    
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
//        let isOddNumOfMales = checkIfOddNumberPerGender(participants, gender: Participant.Gender.male)
//        let isOddNumOfFemales = checkIfOddNumberPerGender(participants, gender: Participant.Gender.female)
//        var singleFemaleAssigned = false
//        var singleMaleAssigned = false
//        var room = 1
//        var assignmentAttempt = 0
//        var unassignedParticipants = participants
        var unassignedFemaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.female)
        var unassignedMaleParticipants = getParticipantsByGender(participants, gender: Participant.Gender.male)
        var roomAssignments = getRoommatesForGroup(unassignedFemaleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip)
        roomAssignments += getRoommatesForGroup(unassignedMaleParticipants, maxOccupancy: 3, secondHalfOfTrip: secondHalfOfTrip)
//        while (!unassignedParticipants.isEmpty) {
//            unassignedParticipants.shuffle()
//            let par1 = unassignedParticipants.removeLast()
        
//            // if odd number per gender assign one male or female to room
//            if isOddNumOfFemales && par1.gender == Participant.Gender.female && !singleFemaleAssigned {
//                roomAssignments.append(Assignment(roomNumber: room, participant1: par1))
//                room++
//                singleFemaleAssigned = true
//            } else if isOddNumOfMales && par1.gender == Participant.Gender.male && !singleMaleAssigned {
//                roomAssignments.append(Assignment(roomNumber: room, participant1: par1))
//                room++
//                singleMaleAssigned = true
//            } else {
//                // assigning two participants to a double
//                switch unassignedParticipants.count {
//                case 0:
//                    assignmentAttempt++
//                    if assignmentAttempt > 0 {
//                        repeatRoommateExecption = true
//                    }
//                    getRoomAssignment(participants, secondHalfOfTrip: secondHalfOfTrip)
//                    
//                case 1:
//                    let par2 = unassignedParticipants.removeLast()
//                    roomAssignments.append(Assignment(roomNumber: room, participant1: par1, participant2: par2))
//                    allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2)
//                    room++
//                    
//                default:
//                    if let roommateIndex = findRoommateOrRoommates(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip) {
//                        let par2 = unassignedParticipants.removeAtIndex(roommateIndex)
//                        roomAssignments.append(Assignment(roomNumber: room, participant1: par1, participant2: par2))
//                        allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2)
//                        room++
//                    }
//                }
//            }
//        }
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
        var assignmentAttempt = 0
        while (!unassignedParticipants.isEmpty) {
//            unassignedParticipants.shuffle()
            let numParticipants = unassignedParticipants.count
            let par1 = unassignedParticipants.removeLast()
            var roommates: [Int] = []
            let roommateIndex: [Int]?
            if  numParticipants % maxOccupancy == 0 {
                for var i = 0; i <= maxOccupancy - 1; i++ {
                    var pcr = participantCompatabilityRating!
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
                roomAssignments.append(Assignment(roomNumber: 1, participant1: par1, participant2: par2, participant3: par3))
            } else {
                var pcr = participantCompatabilityRating!
                var bestMatch = 0
                for var index = 0; index < numParticipants; index++ {
                    let pcrForCurrentParticipant = pcr[numParticipants][index]
                    if pcrForCurrentParticipant > bestMatch {
                        bestMatch = pcrForCurrentParticipant
                    }
                }
                roommates.append(bestMatch)
            }
            
//                
//                roommateIndex = findRoommateOrRoommates(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip, numRoommatesToAdd: maxOccupancy)
//            } else {
//                roommateIndex = findRoommateOrRoommates(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip, numRoommatesToAdd: 2)
            }
//
//            
//            
//            if let rmIndex = roommateIndex {
//                var par2 = unassignedParticipants.removeAtIndex(rmIndex[1])
//                var par3: Participant
//                if unassignedParticipants.count < 1 {
//                    par3 = unassignedParticipants.removeAtIndex(rmIndex[0])
//                } else {
//                    par3 = unassignedParticipants.removeAtIndex(0)
//                }
//                roomAssignments.append(Assignment(roomNumber: 1, participant1: par1, participant2: par2, participant3: par3))
////                allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2, par3: par3)
//
//            }
//        }
        return roomAssignments
    }

  
//    class func checkIfOddNumberPerGender(participants: [Participant], gender: Participant.Gender) -> Bool {
//        var numOfFemaleOrMale = 0
//        for par in participants {
//            if par.gender == gender {
//                numOfFemaleOrMale++
//            }
//        }
//        return numOfFemaleOrMale % 2 == 0 ? false : true
//    }

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
    
//    class func isSameSex(par1: Participant, par2: Participant) -> Bool {
//        return par1.gender == par2.gender ? true : false
//    }
    
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


//if unassignedParticipants.count == 0 {
//    if isOddNumOfFemales && par1.gender == Participant.Gender.female {
//        roomAssignments.append(Assignment(roomNumber: room, participant1: par1))
//    } else if isOddNumOfMales && par1.gender == Participant.Gender.male {
//        roomAssignments.append(Assignment(roomNumber: room, participant1: par1))
//    } else {
//        assignmentAttempt++
//        if assignmentAttempt > 0 {
//            repeatRoommateExecption = true
//        }
//        getRoomAssignment(participants, secondHalfOfTrip: secondHalfOfTrip)
//    }
//} else if unassignedParticipants.count == 1 || (secondHalfOfTrip && unassignedParticipants.count <= 3) {
//    let par2 = unassignedParticipants.removeLast()
//    roomAssignments.append(Assignment(roomNumber: room, participant1: par1, participant2: par2))
//    allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2)
//    room++
//} else {
//    if let roommateIndex = findRoommate(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip) {
//        let par2 = unassignedParticipants.removeAtIndex(roommateIndex)
//        roomAssignments.append(Assignment(roomNumber: room, participant1: par1, participant2: par2))
//        allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2)
//        room++
//}


//        var room = 1
//        var roomAssignments = [Assignment]()
//        var unassignedParticipants = participants
//        while (!unassignedParticipants.isEmpty) {
//            unassignedParticipants.shuffle()
//            let par1 = unassignedParticipants.removeLast()
//            var par2Index = findRoommate(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip)
//            while par2Index == nil && !isOddNumOfFemales && roomAssignments.count < participants.count/2 - 1{
//                unassignedParticipants.shuffle()
//                par2Index = findRoommate(par1, unassignedParticipants: unassignedParticipants, secondHalfOfTrip: secondHalfOfTrip)
//            }
//
//            var par2: Participant
//            if par2Index == nil {
//                par2 = unassignedParticipants.removeLast()
//            } else {
//                par2 = unassignedParticipants.removeAtIndex(par2Index!)
//            }
//
//            roomAssignments.append(Assignment(roomNumber: room, participant1: par1, participant2: par2))
//            allParticipants = rememberRoommates(allParticipants!, par1: par1, par2: par2)
//            room++
