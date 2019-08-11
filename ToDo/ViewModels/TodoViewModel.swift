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

enum DataState {
    case all
    case done
    case active
}

class TodoViewModel: NSObject {
    let status = BehaviorRelay<DataState>(value: .all)
    var allData = [TodoItem]()
    let displayedData = BehaviorRelay<[TodoItem]>(value: [TodoItem]())
    let bag = DisposeBag()
    
    override init() {
        super.init()
        
        getData()
        status.subscribe(onNext: { [weak self] (state) in
            self?.getRender(state)
        }).disposed(by: bag)
        
    }
    
    func getData() {
        if let data = DataController.shared.getAllData() {
            allData = data
        }
    }
    
    func getRender(_ state: DataState) {
        var result = [TodoItem]()
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
    
    func addItem(_ name: String) {
        var id: Int32 = 1
        if let _item = allData.last {
            id = _item.id + 1
        }
        
        DataController.shared.addNewItem(id, name: name, doneStatus: false)
        getData()
        if status.value == .all || status.value == .active {
            getRender(status.value)
        }
    }
    
    func deleteItem(_ item: TodoItem) {
        DataController.shared.deleteData(item)
        getData()
        getRender(status.value)
    }
    
    func updateData() {
        DataController.shared.saveContext()
        getRender(status.value)
    }

}
