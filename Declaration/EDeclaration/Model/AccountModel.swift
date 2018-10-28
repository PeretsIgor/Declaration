//
//  AccountModel.swift
//  EDeclaration
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation


struct AccountModel: Codable { //items
    let id: String
    let firstname: String
    let lastname: String
    let placeOfWork: String?
    let position: String?
    let linkPDF: String?
}
