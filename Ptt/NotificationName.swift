//
//  NotificationName.swift
//  Ptt
//
//  Created by denkeni on 2021/1/14.
//  Copyright © 2021 Ptt. All rights reserved.
//

import Foundation

struct NotificationName {

    static func value(of notificationType: NotificationType) -> Notification.Name {
        return Notification.Name(notificationType.rawValue)
    }
}

enum NotificationType : String {

    case didChangeAppearanceMode
}
