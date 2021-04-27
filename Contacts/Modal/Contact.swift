//
//  Contact.swift
//  Contacts
//
//  Created by Vamsi Kallepalli on 4/21/21.
//

struct Contact: Codable {
    let name : String?
    let id : String?
    let companyName : String?
    var isFavorite : Bool?
    let smallImageURL : String?
    let largeImageURL : String?
    let emailAddress : String?
    let birthdate : String?
    let phone : Phone?
    let address : Address?
    let url : String?
}

struct Phone : Codable {
    let work : String?
    let home : String?
    let mobile : String?
}

struct Address : Codable {
    let street : String?
    let city : String?
    let state : String?
    let country : String?
    let zipCode : String?
}
