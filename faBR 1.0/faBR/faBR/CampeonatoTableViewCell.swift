//
//  CampeonatoTableViewCell.swift
//  faBR
//
//  Created by Guilherme Sousa Abreu on 16/07/16.
//  Copyright © 2016 gabreuCo. All rights reserved.
//

import UIKit

class CampeonatoTableViewCell: UITableViewCell {
    @IBOutlet weak var campeonatoImage: UIImageView!
    @IBOutlet weak var campeonatoLabel: UILabel!

    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
