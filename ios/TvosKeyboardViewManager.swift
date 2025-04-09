import UIKit
import React

@objc(TvosKeyboardViewManager)
class TvosKeyboardViewManager: RCTViewManager {
  override func view() -> UIView {
    return TvosKeyboardView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  // Expose focus method to JS
  @objc func focusSearchBar(_ reactTag: NSNumber) {
    DispatchQueue.main.async {
      if let view = self.bridge.uiManager.view(forReactTag: reactTag) as? TvosKeyboardView {
        view.focusSearchBar()
      }
    }
  }
}

class TvosKeyboardView: UIView, UISearchResultsUpdating, UISearchBarDelegate {

  private var searchController: UISearchController!
  private var containerVC: UISearchContainerViewController!

  @objc var onTextChange: RCTBubblingEventBlock?
  @objc var onFocus: RCTBubblingEventBlock?
  @objc var onBlur: RCTBubblingEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSearchController()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSearchController()
  }

  private func setupSearchController() {
    let resultsVC = UIViewController()
    resultsVC.view.backgroundColor = .clear

    searchController = UISearchController(searchResultsController: resultsVC)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.automaticallyShowsCancelButton = false
    searchController.searchBar.placeholder = "Enter keyword"

    // Add delegate to detect focus
    searchController.searchBar.delegate = self

    containerVC = UISearchContainerViewController(searchController: searchController)
    containerVC.view.translatesAutoresizingMaskIntoConstraints = false
    containerVC.view.clipsToBounds = true

    self.addSubview(containerVC.view)
    self.clipsToBounds = true

    NSLayoutConstraint.activate([
      containerVC.view.topAnchor.constraint(equalTo: self.topAnchor),
      containerVC.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      containerVC.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      containerVC.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
  }

  func focusSearchBar() {
    DispatchQueue.main.async {
      self.searchController.searchBar.becomeFirstResponder()
    }
  }

  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text ?? ""
    onTextChange?(["text": text])
  }

  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    onFocus?(["focused": true])
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    onBlur?(["blurred": true])
  }
}
