//
//  SearchVC+URLSessionDelegates.swift
//  SearchVC+URLSessionDelegates
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//
import Foundation
import UIKit

extension SearchViewController: URLSessionDownloadDelegate {

  // Stores downloaded file
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    // 1
    guard let sourceURL = downloadTask.originalRequest?.url else { return }
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    // 2
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    // 3
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.track.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    // 4
    if let index = download?.track.index {
      DispatchQueue.main.async {
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
  }

  // Updates progress info
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64) {
    // 1
    guard let url = downloadTask.originalRequest?.url,
      let download = downloadService.activeDownloads[url]  else { return }
    // 2
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    // 3
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite,
      countStyle: .file)
    // 4
    DispatchQueue.main.async {
      if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index,
        section: 0)) as? TrackCell {
        trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
      }
    }
  }

}

// MARK: - URLSessionDelegate

extension SearchViewController: URLSessionDelegate {

  // Standard background session handler
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let completionHandler = appDelegate.backgroundSessionCompletionHandler {
        appDelegate.backgroundSessionCompletionHandler = nil
        completionHandler()
      }
    }
  }

}
