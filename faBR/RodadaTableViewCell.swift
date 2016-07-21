//
//  RodadaTableViewCell.swift
//  faBR
//
//  Created by Guilherme Sousa Abreu on 13/07/16.
//  Copyright © 2016 gabreuCo. All rights reserved.
//

import UIKit

class RodadaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weekLabel: UILabel!
    //Mandante
    @IBOutlet weak var imageMandante: UIImageView!
    @IBOutlet weak var nomeMandante: UILabel!
    @IBOutlet weak var pontosMandante: UILabel!
    
    //Visitante
    
    @IBOutlet weak var imageVisitante: UIImageView!
    @IBOutlet weak var nomeVisitante: UILabel!
    @IBOutlet weak var pontosVisitante: UILabel!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
