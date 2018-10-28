//
//  SearchViewController.swift
//  EDeclaration
//
//  Created by User on 10/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit


class SearchViewController: UIViewController {

    @IBOutlet var nameField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       nameField.delegate = self
    }
    
    
    @IBAction func searchButtonAction() {
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
    
    
    @IBAction func reportButtonAction() {
        
        if let safariVC = NetworkLayer.getSafariViewController(urlString: NetworkLayer.reportString) {
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            let destination = segue.destination as? SearchResultViewController
            destination?.nameForSearch = nameField.text ?? ""
            
            let backButton = UIBarButtonItem()
            backButton.title = ""
            navigationItem.backBarButtonItem = backButton
        }
    }
}


    extension SearchViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchButtonAction()
            
            return true
        }
   
    

}
