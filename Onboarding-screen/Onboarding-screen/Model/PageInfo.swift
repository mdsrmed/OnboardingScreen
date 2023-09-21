//
//  PageInfo.swift
//  Onboarding-screen
//
//  Created by Md Shohidur Rahman on 9/20/23.
//

import Foundation


struct PageInfo: Identifiable, Hashable {
    var id: UUID = .init()
    var infoAssetImage: String
    var title: String
    var subTitle: String
    var displayAction: Bool = false
}


var pageInfos: [PageInfo] = [
    .init(infoAssetImage: "img1" , title: "Connect With\nCteators Easily", subTitle: "Thank you for choosing us."),
    .init(infoAssetImage: "img2", title: "Get Inspiration\nFrom Creators", subTitle: "Find your favorite creator."),
    .init(infoAssetImage: "img3", title: "Let's\nGet Started", subTitle: "To register,please enter your details", displayAction: true),

]
