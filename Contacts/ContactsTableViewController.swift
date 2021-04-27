//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Vamsi Kallepalli on 4/21/21.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    var favoriteContacts = [Contact]()
    var contacts = [Contact]()
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()
    let sectionTitles = ["FAVORITE CONTACTS","OTHER CONTACTS"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: "contactCell")
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        setLoadingScreen()
        setUpNavigation()
        getContacts()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == 0){
            return self.favoriteContacts.count
        }else {
            return self.contacts.count
        }
        
    }
    
    func setUpNavigation() {
        navigationItem.title = "Contacts"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
        if(indexPath.section == 0) {
            cell.contact = favoriteContacts[indexPath.row]
        }else {
            cell.contact = contacts[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return sectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 15, y: 5, width: 320, height: 20)
        myLabel.font = UIFont.boldSystemFont(ofSize: 12)
        myLabel.text = self.tableView(tableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.backgroundColor = UIColor.secondarySystemBackground
        headerView.addSubview(myLabel)

        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        //let row = indexPath.row
        let contactDetailVC = ContactDetailViewController(nibName: "ContactDetailViewController", bundle: nil)
        if(indexPath.section == 0){
            contactDetailVC.currentContact = favoriteContacts[indexPath.row]
        }else {
            contactDetailVC.currentContact = contacts[indexPath.row]
        }
        contactDetailVC.parentController = self
        navigationController?.pushViewController(contactDetailVC, animated: true)
    }
    
    // MARK: - API CALL
    
    func getContacts() {
        
        guard let url = URL(string: "https://s3.amazonaws.com/technical-challenge/v3/contacts.json") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print ("error: \(error!)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            do {
                let contactsData :[Contact] = try JSONDecoder().decode([Contact].self, from: data)
                
                for contact in contactsData {
                    if let fav = contact.isFavorite {
                        if(fav){
                            self.favoriteContacts.append(contact)
                        }else {
                            self.contacts.append(contact)
                        }
                    }else{
                        self.contacts.append(contact)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.removeLoadingScreen()
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func removeLoadingScreen() {

        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true

    }
    
    
    func setLoadingScreen() {

        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.view.frame.width / 2) - (width / 2)
        let y = (self.view.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading"
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()

        loadingView.addSubview(spinner)
        loadingView.addSubview(loadingLabel)

        tableView.addSubview(loadingView)
    }
    
    func updateContactsList(contact: Contact) {
     
        if let indexOfFirstSuchElement = contacts.firstIndex(where: { $0.id == contact.id }) {
            contacts.remove(at: indexOfFirstSuchElement)
            favoriteContacts.append(contact)
        }
        else if let indexOfFirstSuchElement = favoriteContacts.firstIndex(where: { $0.id == contact.id }) {
            favoriteContacts.remove(at: indexOfFirstSuchElement)
            contacts.append(contact)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
