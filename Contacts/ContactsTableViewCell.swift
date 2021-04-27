//
//  ContactsTableViewCell.swift
//  Contacts
//
//  Created by Vamsi Kallepalli on 4/21/21.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class ContactsTableViewCell: UITableViewCell {
    
    var contact:Contact? {
        didSet {
            guard let contactItem = contact else {return}
            if let name = contactItem.name {
                contactNameLabel.text = name
            }
            if let contactImageUrl = contactItem.smallImageURL {
                let url :URL = NSURL(string: contactImageUrl)! as URL
                ImageService.getImage(withURL: url, completion: {image in
                    if image != nil {
                        self.contactImageView.image = image
                    }else {
                        self.contactImageView.image = UIImage(named: "UserSmall")
                    }
                })
            }else {
                self.contactImageView.image = UIImage(named: "UserSmall")
            }
            if let companyName = contactItem.companyName {
                companyNameLabel.text = companyName
            } else {
                companyNameLabel.text = ""
            }
            if let isfav = contactItem.isFavorite {
                if(isfav){
                    favoriteImageView.image = UIImage(named: "FavoriteStarFilled")
                }else {
                    favoriteImageView.image = nil
                }
            }
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let contactImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 3
        img.clipsToBounds = true
        return img
    }()
    
    let favoriteImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let contactNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyNameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor =  .gray
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(contactImageView)
        containerView.addSubview(contactNameLabel)
        containerView.addSubview(companyNameLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(favoriteImageView)
        
        contactImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        contactImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:15).isActive = true
        contactImageView.widthAnchor.constraint(equalToConstant:50).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        
        favoriteImageView.centerYAnchor.constraint(equalTo:self.contactNameLabel.centerYAnchor).isActive = true
        favoriteImageView.widthAnchor.constraint(equalToConstant:15).isActive = true
        favoriteImageView.heightAnchor.constraint(equalToConstant:15).isActive = true
        favoriteImageView.trailingAnchor.constraint(equalTo:self.contactNameLabel.leadingAnchor, constant:-5).isActive = true
        
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.contactImageView.trailingAnchor, constant:40).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-15).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        
        contactNameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        contactNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        contactNameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        
        companyNameLabel.topAnchor.constraint(equalTo:self.contactNameLabel.bottomAnchor).isActive = true
        companyNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        companyNameLabel.topAnchor.constraint(equalTo:self.contactNameLabel.bottomAnchor).isActive = true
        companyNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }

}
