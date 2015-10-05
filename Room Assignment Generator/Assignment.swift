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
}