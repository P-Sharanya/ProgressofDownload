//
//  DownloadItem.swift
//  ProgressOfDownload
//
//  Created by next on 06/02/26.
//

import Foundation
struct DownloadItem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let url: String
}
