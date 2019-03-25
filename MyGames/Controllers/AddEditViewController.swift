//
//  AddEditViewController.swift
//  MyGames
//
//  Created by Gabriel Carvalho Guerrero on 21/03/19.
//  Copyright © 2019 Gabriel Carvalho Guerrero. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - @IBOutlet's
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldConsole: UITextField!
    @IBOutlet weak var datePickerReleaseDate: UIDatePicker!
    @IBOutlet weak var imageViewCover: UIImageView!
    @IBOutlet weak var buttonAddEdit: UIButton!
    @IBOutlet weak var buttonCover: UIButton!
    
    // MARK: - Var's
    var game: Game!
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    var consolesManager = ConsolesManager.shared
    
    // MARK: - @IBAction's
    @IBAction func addEditCover(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addEditGame(_ sender: UIButton) {
        if game == nil {
            game = Game(context: context)
        }
        
        game.title = textFieldTitle.text
        game.releaseDate = datePickerReleaseDate.date
        
        if !textFieldConsole.text!.isEmpty {
            game.console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
        }
        
        game.cover = imageViewCover.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - private Method's
    @objc func cancel() {
        textFieldConsole.resignFirstResponder()
    }
    
    @objc func done() {
        textFieldConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
    
    private func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "primary")
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func prepareConsoleTextField() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "primary")
        
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let buttonFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [buttonCancel, buttonFlexibleSpace, buttonDone]
        
        textFieldConsole.inputAccessoryView = toolbar
        textFieldConsole.inputView = pickerView
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareConsoleTextField()
        
        if game != nil {
            title = "Editar Jogo"
            buttonAddEdit.setTitle("ALTERAR", for: .normal)
            textFieldTitle.text = game.title
            
            if let console = game.console, let index = consolesManager.consoles.index(of: console) {
                textFieldConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            
            imageViewCover.image = game.cover as? UIImage
            
            if let releaseDate = game.releaseDate {
                datePickerReleaseDate.date = releaseDate
            }
            
            if game.cover != nil {
                buttonCover.setTitle(nil, for: .normal)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsole(with: context)
    }
    
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
    
}

extension AddEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageViewCover.image = image
        buttonCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
