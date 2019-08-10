//
//  TodoViewCell.swift
//  ToDo
//
//  Created by Khoa Vu on 8/10/19.
//  Copyright © 2019 Khoa Vu. All rights reserved.
//

import UIKit

class TodoViewCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkDotView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    var todoItem: TodoItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bgView.layer.cornerRadius = 5.0
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 2.0
        
        checkDotView.layer.cornerRadius = checkDotView.frame.size.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(_ item: TodoItem) {
        todoItem = item
        nameLabel.text = item.name
        if item.doneStatus {
            checkDotView.backgroundColor = UIColor.cyan
        } else {
            checkDotView.backgroundColor = UIColor.gray
        }
        
    }

}