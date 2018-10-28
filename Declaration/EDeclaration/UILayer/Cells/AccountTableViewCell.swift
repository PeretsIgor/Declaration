//
//  AccountTableViewCell.swift
//  EDeclaration
//
//  Created by User on 10/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var placeOfWorkLabel: UILabel!
    @IBOutlet private var pdfIcon: UIImageView!
    
    func setup(with account: AccountModel) {
        nameLabel.text = "\(account.firstname) \(account.lastname)"
        placeOfWorkLabel.text = account.placeOfWork ?? "Невідомо"
        pdfIcon.isHidden = account.linkPDF == nil
    }
    
}
