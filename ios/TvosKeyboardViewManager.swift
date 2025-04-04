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

class TvosKeyboardView: UIView, UISearchResultsUpdating {

  private var searchController: UISearchController!
  private var containerVC: UISearchContainerViewController!

  @objc var onTextChange: RCTBubblingEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSearchController()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupSearchController()
  }

  private func setupSearchController() {
    // Dummy results VC, just required by UISearchController
    let resultsVC = UIViewController()
    resultsVC.view.backgroundColor = .clear

    // Create search controller
    searchController = UISearchController(searchResultsController: resultsVC)
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.automaticallyShowsCancelButton = false
    searchController.searchBar.placeholder = "Enter keyword"

    // Embed search controller in container
    containerVC = UISearchContainerViewController(searchController: searchController)
    containerVC.view.translatesAutoresizingMaskIntoConstraints = false
    containerVC.view.clipsToBounds = true

    self.addSubview(containerVC.view)
    self.clipsToBounds = true

    // Pin to edges
    NSLayoutConstraint.activate([
      containerVC.view.topAnchor.constraint(equalTo: self.topAnchor),
      containerVC.view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      containerVC.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      containerVC.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
  }

  // Allow JS to call this and focus the search bar (which triggers keyboard)
  func focusSearchBar() {
    DispatchQueue.main.async {
      self.searchController.searchBar.becomeFirstResponder()
    }
  }

  // Called as user types
  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text ?? ""
    onTextChange?(["text": text])
  }
}
