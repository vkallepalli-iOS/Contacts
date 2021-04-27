//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Vamsi Kallepalli on 4/23/21.
//

import UIKit

class ContactDetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var contactHeaderViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var contactImageView: UIImageView!
    
    var currentContact : Contact? {
        didSet {
            buildData()
        }
    }
    
    var parentController : ContactsTableViewController = ContactsTableViewController()
    
    let headerViewMaxHeight: CGFloat = 300
    let headerViewMinHeight: CGFloat = 150
    
    var screenBounds = UIScreen.main.bounds
    var screenWidth = 0.0
    var screenHeight = 0.0
    
    var titleLabels : [String] = []
    var typeLabels : [String] = []
    var contentArray : [String] = []
    var favImage = ""
    var favoriteButton = UIBarButtonItem()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        screenWidth = Double(screenBounds.size.width)
        
        if let contactImageUrl = currentContact?.largeImageURL {
            let url :URL = NSURL(string: contactImageUrl)! as URL
           
            ImageService.getImage(withURL: url, completion: {image in
                if image != nil {
                    self.contactImageView.image = image
                }else {
                    self.contactImageView.image = UIImage(named: "UserSmall")
                }
            })
            
        } else {
            self.contactImageView.image = UIImage(named: "UserSmall")
        }
        nameLabel.text = currentContact?.name
        companyNameLabel.text = currentContact?.companyName
        if((currentContact?.isFavorite) != nil){
            if(currentContact?.isFavorite == true){
                favImage = "FavoriteStarFilled"
            }else {
                favImage = "FavoriteStar"
            }
        }
        
        favoriteButton = UIBarButtonItem(
            image: UIImage(named: favImage)?.withRenderingMode(.alwaysOriginal),
            style: .plain, target: self, action: #selector(handleClick))
        self.navigationItem.rightBarButtonItems = [favoriteButton]
        addSubviewsToStackView()
    }
    
    func addSubviewsToStackView() {
        for (index,value) in titleLabels.enumerated() {
            let subView = UINib(nibName: "CustomView", bundle: nil).instantiate(withOwner: nil,
                                                                                options: nil)[0] as! CustomView
            if(value == "ADDRESS:"){
                subView.heightAnchor.constraint(equalToConstant: 98).isActive = true
            }else {
                subView.heightAnchor.constraint(equalToConstant: 78).isActive = true
            }
            subView.titleLabel.text = titleLabels[index]
            subView.itemTypeLabel.text = typeLabels[index]
            subView.contentLabel.text = contentArray[index]
            stackView.addArrangedSubview(subView)
        }
    }
    
    @objc func handleClick() {
        if(currentContact?.isFavorite == true){
            favImage = "FavoriteStar"
            currentContact?.isFavorite = false
        }else {
            favImage = "FavoriteStarFilled"
            currentContact?.isFavorite = true
        }
        favoriteButton.image = UIImage(named: favImage)?.withRenderingMode(.alwaysOriginal)
        parentController.updateContactsList(contact: currentContact!)
    }
    
    func buildData()  {
        
        if !(currentContact?.phone?.home ?? "").isEmpty {
            titleLabels.append("PHONE:")
            typeLabels.append("Home")
            contentArray.append(currentContact?.phone?.home ?? "")
        }
        if !(currentContact?.phone?.mobile ?? "").isEmpty {
            titleLabels.append("PHONE:")
            typeLabels.append("Mobile")
            contentArray.append(currentContact?.phone?.mobile ?? "")
        }
        if !(currentContact?.phone?.work ?? "").isEmpty {
            titleLabels.append("PHONE:")
            typeLabels.append("Work")
            contentArray.append(currentContact?.phone?.work ?? "")
        }
        if !(currentContact?.address?.street ?? "").isEmpty {
            titleLabels.append("ADDRESS:")
            typeLabels.append("")
            var address = ""
            if let street = currentContact?.address?.street {
                address += street + "\n"
            }
            if let city = currentContact?.address?.city {
                address += city
            }
            if let state = currentContact?.address?.state {
                address += "," + state
            }
            if let zipCode = currentContact?.address?.zipCode {
                address += " " + zipCode
            }
            if let country = currentContact?.address?.country {
                address += "," + country
            }
            contentArray.append(address)
        }
        if !(currentContact?.birthdate ?? "").isEmpty {
            titleLabels.append("BIRTHDATE:")
            typeLabels.append("")
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"

            let dateFormatterDisplay = DateFormatter()
            dateFormatterDisplay.dateStyle = .long

            let date: NSDate? = dateFormatterGet.date(from: currentContact?.birthdate ?? "") as NSDate?
            contentArray.append(dateFormatterDisplay.string(from: date! as Date))
            //contentArray.append(dateFormatter.string(from: date!))
        }
        if !(currentContact?.emailAddress ?? "").isEmpty {
            titleLabels.append("EMAIL:")
            typeLabels.append("")
            contentArray.append(currentContact?.emailAddress ?? "")
        }
    }
    
}
