//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Khoa Vu on 8/10/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Firebase

enum DataState {
    case all
    case done
    case active
}

class TodoViewModel: NSObject {
    let status = BehaviorRelay<DataState>(value: .all)
    lazy var allData = [TodoModel]()
    let displayedData = BehaviorRelay<[TodoModel]>(value: [TodoModel]())
    let bag = DisposeBag()
    
    override init() {
        super.init()
        status.subscribe(onNext: { [weak self] (state) in
            self?.getRender(state)
        }).disposed(by: bag)
        
    }
    
    func getRender(_ state: DataState) {
        var result = [TodoModel]()
        switch state {
        case .all:
            result.append(contentsOf: allData)
        case .done:
            result.append(contentsOf: allData.filter { $0.doneStatus == true })
        case .active:
            result.append(contentsOf: allData.filter { $0.doneStatus == false })
        }
        displayedData.accept(result)
    }
    
    func deleteItem(_ item: TodoModel) {
        let ref = Database.database().reference(withPath: "todo_list")
        ref.child("\(item.id)").removeValue()
        getData()
        getRender(status.value)
    }
    
    func updateData(items: [TodoModel]) {
        let ref = Database.database().reference(withPath: "todo_list")
        for it in items {
            ref.child("\(it.id)").setValue(it.toAnyObject())
        }
    }
    
    func addItem(_ name: String) {
        var id: Int = 1
        if let _item = allData.last {
            id = Int(_item.id + 1)
        }
        let item = TodoModel.init(id, name: name, doneStatus: false)
        let ref = Database.database().reference(withPath: "todo_list")
        
        ref.child("\(id)").setValue(item.toAnyObject())
    }
    
    func getData() {
        
        let ref = Database.database().reference(withPath: "todo_list")
        ref.observe(.value) { [weak self] (snapshot) in
            if let _self = self {
                _self.allData.removeAll()
                for object in snapshot.children.allObjects {
                    if let ob = object as? DataSnapshot, let item = TodoModel.init(snapshot: ob) {
                        _self.allData.append(item)
                    }
                }
                _self.getRender(_self.status.value)
            }
        }
    }

}
