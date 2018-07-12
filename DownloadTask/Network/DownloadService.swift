//
//  DownloadService.swift
//  DownloadService
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

  // SearchViewController creates downloadsSession
  var downloadsSession: URLSession!
  var activeDownloads: [URL: Download] = [:]

  // MARK: - Download methods called by TrackCell delegate methods

  func startDownload(_ track: Track) {
    // 1
    let download = Download(track: track)
    // 2
    download.task = downloadsSession.downloadTask(with: track.previewURL)
    // 3
    download.task!.resume()
    // 4
    download.isDownloading = true
    // 5
    activeDownloads[download.track.previewURL] = download
  }

  func pauseDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else { return }
    if download.isDownloading {
      download.task?.cancel(byProducingResumeData: { data in
        download.resumeData = data
      })
      download.isDownloading = false
    }
  }

  func cancelDownload(_ track: Track) {
    if let download = activeDownloads[track.previewURL] {
      download.task?.cancel()
      activeDownloads[track.previewURL] = nil
    }
  }

  func resumeDownload(_ track: Track) {
    guard let download = activeDownloads[track.previewURL] else { return }
    if let resumeData = download.resumeData {
      download.task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      download.task = downloadsSession.downloadTask(with: download.track.previewURL)
    }
    download.task!.resume()
    download.isDownloading = true
  }

}
