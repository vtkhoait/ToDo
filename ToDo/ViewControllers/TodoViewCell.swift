//
//  TodoViewCell.swift
//  ToDo
//
//  Created by Khoa Vu on 8/10/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit
import RxSwift

let doneColor = UIColor(displayP3Red: 66.0/255.0, green: 181.0/255.0, blue: 255.0/255.0, alpha: 1.0)
let grayColor = UIColor(displayP3Red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)

class TodoViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkDotView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var bag = DisposeBag()
    
    var todoItem: TodoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5.0
        
        checkDotView.layer.cornerRadius = checkDotView.frame.size.height/2
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ item: TodoModel) {
        todoItem = item
        nameLabel.text = item.name
        if item.doneStatus {
            checkDotView.backgroundColor = doneColor
        } else {
            checkDotView.backgroundColor = UIColor.gray
        }
        
    }

}
