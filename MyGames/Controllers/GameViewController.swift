//
//  GameViewController.swift
//  MyGames
//
//  Created by Gabriel Carvalho Guerrero on 21/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelConsole: UILabel!
    @IBOutlet weak var labelRealeaseDate: UILabel!
    @IBOutlet weak var imageViewCover: UIImageView!
    
    // MARK: - Var's
    var game: Game!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelTitle.text = game.title
        labelConsole.text = game.console?.name
        if let releaseDate = game.releaseDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.locale = Locale(identifier: "pt-BR")
            labelRealeaseDate.text = "Lançamento: " + formatter.string(from: releaseDate)
        }
        if let image = game.cover as? UIImage {
            imageViewCover.image = image
        } else {
            imageViewCover.image = UIImage(named: "noConverFull")
        }
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.game = game
    }

}
