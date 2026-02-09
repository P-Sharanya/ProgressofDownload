//
//  DownloadListView.swift
//  ProgressOfDownload
//
//  Created by next on 06/02/26.
//

import Foundation
import SwiftUI

struct DownloadListView: View {

    let items: [DownloadItem] = [
        DownloadItem(
            title: "Strategy for New India",
            url: "https://niti.gov.in/sites/default/files/2019-01/Strategy_for_New_India_0.pdf"
        ),
        DownloadItem(
            title: "Economic Survey",
            url: "https://ncert.nic.in/textbook/pdf/kebo104.pdf"
        ),
        DownloadItem(
            title: "birds image",
            url: "https://upload.wikimedia.org/wikipedia/commons/3/3f/Fronalpstock_big.jpg"),
        DownloadItem(
                title: "video",
                url: "https://pixabay.com/videos/download/video-217714_medium.mp4")
    ]

    @State private var downloadedTitles: [String] = DownloadStorage.getAll()

    var body: some View {
        NavigationStack {
            List(items) { item in
                NavigationLink {
                    DownloadProgressView(item: item)
                } label: {
                    HStack {
                        Text(item.title)
                        Spacer()
                        if downloadedTitles.contains(item.title) {
                            Text("Downloaded")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Downloads")
            .onAppear {
                downloadedTitles = DownloadStorage.getAll()
            }
        }
    }
}
