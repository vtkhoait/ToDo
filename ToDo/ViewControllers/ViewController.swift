//
//  ViewController.swift
//  ToDo
//
//  Created by Khoa Vu on 8/9/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var todoNameTf: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var activeButton: UIButton!
    
    private let bag = DisposeBag()
    private let todoViewModel = TodoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        todoNameTf.rx.controlEvent(UIControl.Event.editingDidEndOnExit)
            .map { self.todoNameTf.text }
            .filter { $0 != nil }
            .map { $0! }
            .subscribe(onNext: { (text) in
                // Code here...
                print("dsssdsd")
                if let text = self.todoNameTf.text, text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""  {
                    self.todoViewModel.addItem(text)
                }
                self.todoNameTf.text = ""
            }).disposed(by: self.bag)
        
        tableView
            .rx.setDelegate(self)
            .disposed(by: bag)
        
        todoViewModel.displayedData.bind(to: tableView.rx.items(cellIdentifier: "TodoViewCell")) { [weak self]
            row, model, cell in
            if let _cell = cell as? TodoViewCell, let _self = self {
                _cell.setData(model)
                _cell.deleteButton.rx.tap.bind {
                    print("delete")
                    _self.todoViewModel.deleteItem(model)
                    }
                    .disposed(by: _cell.bag)
                
                _cell.checkButton.rx.tap.bind {
                    if let _item = _cell.todoItem {
                        _item.doneStatus = !_item.doneStatus
                        if _item.doneStatus {
                            _cell.checkDotView.backgroundColor = doneColor
                        } else {
                            _cell.checkDotView.backgroundColor = UIColor.gray
                        }
                        _self.todoViewModel.updateData()
                    }
                }.disposed(by: _cell.bag)
            }
            }
            .disposed(by: bag)
        
        
        setupButtonAction()
        
    }

    func setupUI() {
        toggleButton.layer.cornerRadius = 5.0
        allButton.layer.cornerRadius = 5.0
        doneButton.layer.cornerRadius = 5.0
        activeButton.layer.cornerRadius = 5.0
    }
    
    func setupButtonAction() {
        toggleButton.rx.tap.bind {
            if !self.toggleButton.isSelected {
                self.toggleButton.isSelected = true
                self.todoViewModel.status.accept(.toggleAll)
            }
            }
            .disposed(by: bag)
        
        allButton.rx.tap.bind {
            if !self.allButton.isSelected {
                self.allButton.isSelected = true
                self.todoViewModel.status.accept(.all)
                self.doneButton.isSelected = false
                self.activeButton.isSelected = false
            }
            }
            .disposed(by: bag)
        
        doneButton.rx.tap.bind {
            if !self.doneButton.isSelected {
                self.doneButton.isSelected = true
                self.todoViewModel.status.accept(.done)
                self.allButton.isSelected = false
                self.activeButton.isSelected = false
            }
            }
            .disposed(by: bag)
        
        activeButton.rx.tap.bind {
            if !self.activeButton.isSelected {
                self.activeButton.isSelected = true
                self.todoViewModel.status.accept(.active)
                self.allButton.isSelected = false
                self.doneButton.isSelected = false
            }
            }
            .disposed(by: bag)
    }
    

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

