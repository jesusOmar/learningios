//
//  MastodonPost.swift
//  Tootbot
//
//  Created by Jesus Fernandez on 4/28/18.
//  Copyright © 2018 JO. All rights reserved.
//

import Foundation
import RealmSwift

class MastodonPost: Object {
    @objc dynamic var id = 0
    @objc dynamic var author_name: String = ""
    @objc dynamic var html: String = ""
}
