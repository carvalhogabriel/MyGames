//
//  GameTableViewCell.swift
//  MyGames
//
//  Created by Gabriel Carvalho Guerrero on 21/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelConsole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func prepare(with game: Game) {
        labelTitle.text = game.title ?? ""
        labelConsole.text = game.console?.name ?? ""
        if let image = game.cover as? UIImage {
            imageViewCover.image = image
        } else {
            imageViewCover.image = UIImage(named: "noCover")
        }
    }
}
