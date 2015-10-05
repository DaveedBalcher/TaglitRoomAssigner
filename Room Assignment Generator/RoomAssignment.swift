//
//  RoomAssignment.swift
//  Room Assignment Generator
//
//  Created by David Balcher on 8/23/15.
//  Copyright (c) 2015 Xpressive. All rights reserved.
//

import UIKit

class RoomAssignment {
    var participantsPerRoom = 3

    func assign(participants: [Participant]) -> [[Assignment]]{
        var allRoomAssignments = [[Assignment]]()
        while allRoomAssignments.count < 8 {
            let isSecondHalf: Bool = allRoomAssignments.count >= 4 ? true : false
            let roomAssignments = getRoomAssignment(participants, halfOfTrip: isSecondHalf)
            allRoomAssignments.append(roomAssignments)
        }
        return allRoomAssignments
    }
    
    
    func getRoomAssignment(participants: [Participant], halfOfTrip: Bool) -> [Assignment] {
        
        var unassignedParticipants = participants
        var roomAssignments = [Assignment]()
        var roomNumber = 1
        while (!unassignedParticipants.isEmpty) {
            let keyHolderIndex = unassignedParticipants.randomIndex()
            let keyHolder = unassignedParticipants[keyHolderIndex]
            unassignedParticipants.removeAtIndex(keyHolderIndex)
            
            // Find the second roommate that is compatible with the KeyHolder
            var secondMateIndex = 0
            var previousCompatibility = 0
            for var roommateIndex = 0; roommateIndex < unassignedParticipants.count; roommateIndex++ {
                let potentialRoommate = unassignedParticipants[roommateIndex]
                let compatibility = getCompatibilityOf(keyHolder, secondRoommate: potentialRoommate)
                if  compatibility > previousCompatibility {
                    previousCompatibility = compatibility
                    secondMateIndex = roommateIndex
                }
            }
            var secondRoommate = unassignedParticipants[secondMateIndex]
            unassignedParticipants.removeAtIndex(secondMateIndex)
            
            // Check if there are enough participants left to fill a room
            var participantsLeftPerGender = 0
            for mate in unassignedParticipants {
                if mate.gender == keyHolder.gender {
                    participantsLeftPerGender++
                }
            }
            switch participantsLeftPerGender {
                case 0, 2:
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate))
                
                default:
                // Find the third roommate that is compatible with the KeyHolder
                var thirdMateIndex = 0
                previousCompatibility = 0
                for var roommateIndex = 0; roommateIndex < unassignedParticipants.count; roommateIndex++ {
                    let potentialRoommate = unassignedParticipants[roommateIndex]
                    let compatibility = getCompatibilityOf(keyHolder, secondRoommate: secondRoommate, thirdRoommate: potentialRoommate)
                    if  compatibility > previousCompatibility {
                        previousCompatibility = compatibility
                        thirdMateIndex = roommateIndex
                    }
                }
                var thirdRoommate = unassignedParticipants[thirdMateIndex]
                unassignedParticipants.removeAtIndex(thirdMateIndex)
                
                roomAssignments.append(Assignment(roomNumber: roomNumber++, participant1: keyHolder, participant2: secondRoommate, participant3: thirdRoommate))
            }
        }
        
        return roomAssignments
    }
    
    func getCompatibilityOf(keyHolder: Participant, secondRoommate: Participant) -> Int {
        
        // Check for same Participant and same gender
        if keyHolder.number == secondRoommate.number || keyHolder.gender != secondRoommate.gender {
            return 0
        }
        
        // Check for previouslyAcquainted
        if let previouslyAcquainted = secondRoommate.previouslyAcquainted {
            for acquanted in previouslyAcquainted {
                if keyHolder.number == acquanted {
                    return 1
                }
            }
        }
        
        // Age Rating
        return 16 / (abs(keyHolder.age - secondRoommate.age) + 1)
    }
    

    func getCompatibilityOf(keyHolder: Participant, secondRoommate: Participant, thirdRoommate: Participant) -> Int {
        
        // Check for same Participant and same gender
        if keyHolder.number == thirdRoommate.number || keyHolder.gender != thirdRoommate.gender {
            return 0
        }
        if secondRoommate.number == thirdRoommate.number || secondRoommate.gender != thirdRoommate.gender {
            return 0
        }
        
        // Check for previouslyAcquainted
        if let previouslyAcquainted = thirdRoommate.previouslyAcquainted {
            for acquanted in previouslyAcquainted {
                if keyHolder.number == acquanted {
                    return 1
                }
            }
        }
        if let previouslyAcquainted = thirdRoommate.previouslyAcquainted {
            for acquanted in previouslyAcquainted {
                if secondRoommate.number == acquanted {
                    return 1
                }
            }
        }
        
        // Age Rating
        return 32 / (abs(keyHolder.age - thirdRoommate.age) + 1) + (abs(secondRoommate.age - thirdRoommate.age) + 1)
    }
    
}


extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
    func randomIndex() -> Int {
        return Int(arc4random_uniform(UInt32(self.count)))
    }
}
