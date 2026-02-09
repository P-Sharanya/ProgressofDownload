//
//  DownloadStorage.swift
//  ProgressOfDownload
//
//  Created by next on 06/02/26.
//

import Foundation
final class DownloadStorage {

    private static let key = "downloaded_files"

    static func save(title: String) {
        var items = getAll()
        if !items.contains(title) {
            items.append(title)
        }
        UserDefaults.standard.set(items, forKey: key)
    }

    static func getAll() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }
}
