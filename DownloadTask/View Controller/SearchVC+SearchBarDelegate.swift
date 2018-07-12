//
//  SearchVC+SearchBarDelegate.swift
//  SearchVC+SearchBarDelegate
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: UISearchBarDelegate {

  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    if !searchBar.text!.isEmpty {
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      queryService.getSearchResults(searchTerm: searchBar.text!) { results, errorMessage in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if let results = results {
          self.searchResults = results
          self.tableView.reloadData()
          self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
        if !errorMessage.isEmpty { print("Search error: " + errorMessage) }
      }
    }
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    view.removeGestureRecognizer(tapRecognizer)
  }
}
