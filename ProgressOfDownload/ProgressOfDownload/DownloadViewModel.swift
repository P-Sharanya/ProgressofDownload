//
//  DownloadViewModel.swift
//  ProgressOfDownload
//
//  Created by next on 04/02/26.

import Foundation
import SwiftUI

class DownloadViewModel: NSObject, ObservableObject {
    
    // MARK: - UI State
    @Published var progress: Double = 0
    @Published var statusText: String = "Idle"
    @Published var sizeText: String = ""
    @Published var isDownloading: Bool = false
    @Published var downloadedBytes: Int64 = 0
    
    private var downloadTask: URLSessionDownloadTask?
    var resumeData: Data?
    
    // MARK: - URLSession
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: OperationQueue.main
        )
    }()
    
    // MARK: - Start
    func startDownload(url: String) {
        guard let url = URL(string: url) else { return }
        resetState()
        statusText = "Starting…"
        isDownloading = true
        
        downloadTask = session.downloadTask(with: url)
        downloadTask?.resume()
    }
    
    // MARK: - Pause
    func pauseDownload() {
        guard let task = downloadTask else { return }
        
        task.cancel(byProducingResumeData: { data in
            self.resumeData = data
            self.isDownloading = false
            self.statusText = "Paused ⏸"
        })
    }
    
    // MARK: - Resume
    func resumeDownload() {
        guard let resumeData else { return }
        
        statusText = "Resuming…"
        isDownloading = true
        
        downloadTask = session.downloadTask(withResumeData: resumeData)
        self.resumeData = nil
        downloadTask?.resume()
    }
    
    // MARK: - Cancel
    func cancelDownload() {
        downloadTask?.cancel()
        resetState()
        statusText = "Cancelled ❌"
    }
    
    // MARK: - Helpers
    func resetState() {
        progress = 0
        sizeText = ""
        resumeData = nil
        isDownloading = false
        downloadTask = nil
    }
    
    private func formatSize(_ bytes: Int64) -> String {
        let mb = Double(bytes) / (1024 * 1024)
        if mb >= 1 {
            return String(format: "%.1f MB", mb)
        } else {
            return String(format: "%.0f KB", Double(bytes) / 1024)
        }
    }
}
extension DownloadViewModel: URLSessionDownloadDelegate {
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        self.downloadedBytes = totalBytesWritten
        print("Expected:", totalBytesExpectedToWrite)
        print("Written:", totalBytesWritten)
        if totalBytesExpectedToWrite > 0 {
            progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            statusText = "\(Int(progress * 100)) % downloaded"
            sizeText =
            "\(formatSize(totalBytesWritten)) of \(formatSize(totalBytesExpectedToWrite))"
        } else {
            progress = 0
            statusText = "Downloading…"
            sizeText = "\(formatSize(totalBytesWritten)) downloaded"
        }
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: location.path)
            let fileSize = attributes[.size] as? Int64 ?? 0
            
            progress = 1
            isDownloading = false
            statusText = "Download completed ✅"
            sizeText = "\(formatSize(fileSize)) downloaded"
            
        } catch {
            statusText = "Download completed, size unknown"
        }
    }
}
