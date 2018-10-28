//
//  PageModel.swift
//  EDeclaration
//
//  Created by User on 10/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation


struct PageModel: Codable { //page
    let currentPage: Int
    let batchSize: Int
    let totalItems: String
}
