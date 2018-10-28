//
//  SearchResultViewController.swift
//  EDeclaration
//
//  Created by User on 10/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SafariServices

class SearchResultViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var nameForSearch: String = ""
    var currentPage: PageModel?
    var isLoadingNow = false
    var foundAccount: [AccountModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self as? UITableViewDelegate
        
        tableView.register(UINib(nibName: "AccountTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountTableViewCell")
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: "ActivityTableViewCell")
        
        
        makeNetworkRequest {
            let alert = UIAlertController(title: "Помилка", message: "По вашому запиту нічого не знайдено", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Зрозуміло", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func makeNetworkRequest(errorHandler: (() -> Void)?) {
        if !isLoadingNow {
            isLoadingNow = true
            
            NetworkLayer.searchDeclarations(name: nameForSearch) { (accounts, page) in
                self.isLoadingNow = false
                if let accounts = accounts,
                    let page = page {
                    self.currentPage = page
                    self.title = "Знайдено \(page.totalItems)"
                    self.foundAccount += accounts
                } else {
                    errorHandler?()
                }
                
            }
        }
    }
}

extension SearchResultViewController: UITableViewDataSource, UITextFieldDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if currentPage == nil {
            return 2
        }
        
        if let currentPage = currentPage {
            if let totalItems = Double(currentPage.totalItems) {
                let maxPage = (totalItems / Double(currentPage.batchSize)).rounded(.up)
                return maxPage > Double(currentPage.currentPage) ? 2 : 1
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? foundAccount.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell") as? ActivityTableViewCell
            cell?.activityIndicator.startAnimating()
            return cell!
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTableViewCell") as? AccountTableViewCell
        cell?.setup(with: foundAccount[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            makeNetworkRequest(errorHandler: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let account = foundAccount[indexPath.row]
        
        if let pdfLink = account.linkPDF  {
            
            let actionSheet = UIAlertController(title: "\(account.firstname) \(account.lastname)", message: "Відкрити детальну інформацію", preferredStyle: .actionSheet)
            
            actionSheet.addAction(UIAlertAction(title: "Інтернет сторінка", style: .default, handler: { _ in
                if let safariVC = NetworkLayer.getSafariViewController(urlString: NetworkLayer.publicString + account.id) {
                    self.present(safariVC, animated: true, completion: nil)
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "PDF", style: .default, handler: { _ in
                if let safariVC = NetworkLayer.getSafariViewController(urlString: pdfLink) {
                    self.present(safariVC, animated: true, completion: nil)
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Відміна", style: .cancel, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
            
        } else {
            if let safariVC = NetworkLayer.getSafariViewController(urlString: NetworkLayer.publicString + account.id) {
                self.present(safariVC, animated: true, completion: nil)
            }
        }
        
    }
}
