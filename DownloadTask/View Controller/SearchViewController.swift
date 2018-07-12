//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class SearchViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  lazy var tapRecognizer: UITapGestureRecognizer = {
    var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
    return recognizer
  }()
  
  var searchResults: [Track] = []
  let queryService = QueryService()
  let downloadService = DownloadService()
  // Create downloadsSession here, to set self as delegate
  lazy var downloadsSession: URLSession = {
//    let configuration = URLSessionConfiguration.default
    let configuration = URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration")
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()

  // Get local file path: download task stores tune here; AV player plays it.
  let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
  func localFilePath(for url: URL) -> URL {
    return documentsPath.appendingPathComponent(url.lastPathComponent)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.tableFooterView = UIView()
    downloadService.downloadsSession = downloadsSession
  }

  func playDownload(_ track: Track) {
    let playerViewController = AVPlayerViewController()
    playerViewController.entersFullScreenWhenPlaybackBegins = true
    playerViewController.exitsFullScreenWhenPlaybackEnds = true
    present(playerViewController, animated: true, completion: nil)
    let url = localFilePath(for: track.previewURL)
    let player = AVPlayer(url: url)
    playerViewController.player = player
    player.play()
  }
  
}

// MARK: - UITableView

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchResults.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: TrackCell = tableView.dequeueReusableCell(for: indexPath)

    // Delegate cell button tap events to this view controller
    cell.delegate = self

    let track = searchResults[indexPath.row]
    cell.configure(track: track, downloaded: track.downloaded, download: downloadService.activeDownloads[track.previewURL])

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 62.0
  }

  // When user taps cell, play the local file, if it's downloaded
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let track = searchResults[indexPath.row]
    if track.downloaded {
      playDownload(track)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - TrackCellDelegate
// Called by track cell to identify track for index path row,
// then pass this to download service method.
extension SearchViewController: TrackCellDelegate {

  func downloadTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.startDownload(track)
      reload(indexPath.row)
    }
  }

  func pauseTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.pauseDownload(track)
      reload(indexPath.row)
    }
  }
  
  func resumeTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.resumeDownload(track)
      reload(indexPath.row)
    }
  }
  
  func cancelTapped(_ cell: TrackCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let track = searchResults[indexPath.row]
      downloadService.cancelDownload(track)
      reload(indexPath.row)
    }
  }

  // Update track cell's buttons
  func reload(_ row: Int) {
    tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
  }

}


