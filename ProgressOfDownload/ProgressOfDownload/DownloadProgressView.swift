//
//  ContentView.swift
//  ProgressOfDownload
//
//  Created by next on 04/02/26.
//

import SwiftUI

struct DownloadProgressView: View {

    let item: DownloadItem
    @StateObject private var viewModel = DownloadViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text(item.title)
                .font(.title3)
                .fontWeight(.semibold)
            
            ProgressView(value: viewModel.progress)
                .progressViewStyle(.linear)
                .scaleEffect(x: 1, y: 2)
            
            Text("\(Int(viewModel.progress * 100))%")
                .font(.headline)
            
            Text(viewModel.sizeText)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(viewModel.statusText)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                
                if !viewModel.isDownloading && viewModel.progress == 0 {
                    actionButton("Start", .blue) {
                        viewModel.startDownload(url: item.url)
                    }
                }
                
                if viewModel.isDownloading {
                    actionButton("Pause", .orange) {
                        viewModel.pauseDownload()
                    }
                }
                
                if !viewModel.isDownloading && viewModel.resumeData != nil {
                    actionButton("Resume", .green) {
                        viewModel.resumeDownload()
                    }
                }
                
                if viewModel.isDownloading || viewModel.resumeData != nil {
                    actionButton("Cancel", .red) {
                        viewModel.cancelDownload()
                    }
                }
                if viewModel.progress == 1 {
                    actionButton("Restart", .purple) {
                        viewModel.startDownload(url: item.url)
                    }
                }

            }
        }
        .padding()
        .onChange(of: viewModel.progress) { value in
            if value == 1 {
                DownloadStorage.save(title: item.title)
            }
        }
    }

    private func actionButton(
        _ title: String,
        _ color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(color)
                .cornerRadius(10)
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadListView()
    }
}
