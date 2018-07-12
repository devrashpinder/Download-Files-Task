//
//  Download.swift
//  Download
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//

import Foundation

// Download service creates Download objects
class Download {

  var track: Track
  init(track: Track) {
    self.track = track
  }

  // Download service sets these values:
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var resumeData: Data?

  // Download delegate sets this value:
  var progress: Float = 0

}
