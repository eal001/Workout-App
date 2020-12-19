//
//  SingleSetCell.swift
//  Workout App
//
//  Created by Elliot Lee on 12/16/20.
//

import UIKit

class SingleSetCell: UITableViewCell, UITextViewDelegate {

    
    @IBOutlet weak var rep_field: UITextField!
    @IBOutlet weak var weight_field: UITextField!
    @IBOutlet weak var set_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}