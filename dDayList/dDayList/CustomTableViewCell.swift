//
//  CustomTableViewCell.swift
//  dDayList
//
//  Created by 지현 on 2017. 12. 6..
//  Copyright © 2017년 지현. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var progressbar: UIProgressView!
    @IBOutlet var goal: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
