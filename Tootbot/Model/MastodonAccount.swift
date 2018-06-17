//
//  MastodonAccount.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 6/8/18.
//  Copyright © 2018 JO. All rights reserved.
//

import Foundation
import RealmSwift

class MastodonAccount: Object {
    @objc dynamic var id = 0
    @objc dynamic var display_name: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var url: String = ""
}
