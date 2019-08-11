//
//  TodoModel.swift
//  ToDo
//
//  Created by Khoa Vu on 8/11/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit
import FirebaseDatabase

class TodoModel: NSObject {
    var id: Int = 0
    var name: String = ""
    var doneStatus: Bool = false

    init(_ id: Int, name: String, doneStatus: Bool) {
        self.id = id
        self.name = name
        self.doneStatus = doneStatus
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let name = value["name"] as? String,
            let id = value["id"] as? Int,
            let doneStatus = value["doneStatus"] as? Bool else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.doneStatus = doneStatus
    }
    
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "id": id,
            "doneStatus": doneStatus
        ]
    }
}
