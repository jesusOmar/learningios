//
//  TootbotMessageCell.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 4/24/18.
//  Copyright © 2018 JO. All rights reserved.
//

import UIKit

class TootbotMessageCell: UITableViewCell {
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var html: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
