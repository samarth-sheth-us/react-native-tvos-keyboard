import UIKit

@objc(TvosKeyboardViewManager)
class TvosKeyboardViewManager: RCTViewManager {
  override func view() -> UIView {
    return TvosKeyboardView()
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return true // Needs to be true to present UI from main thread
  }
}

class TvosKeyboardView: UIView, UISearchResultsUpdating {

  private var searchController: UISearchController?
  private var parentVC: UIViewController?

  @objc var onTextChange: RCTBubblingEventBlock?

  override init(frame: CGRect) {
    super.init(frame: frame)
    DispatchQueue.main.async {
      self.showSearchController()
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    DispatchQueue.main.async {
      self.showSearchController()
    }
  }

  private func showSearchController() {
    guard let topVC = UIApplication.shared.keyWindow?.rootViewController else {
      return
    }

    parentVC = topVC

    let dummyResultsVC = UIViewController()
    searchController = UISearchController(searchResultsController: dummyResultsVC)
    searchController?.searchResultsUpdater = self
    searchController?.obscuresBackgroundDuringPresentation = false
    searchController?.searchBar.placeholder = "Enter keyword"

    parentVC?.present(searchController!, animated: true, completion: nil)
  }

  func updateSearchResults(for searchController: UISearchController) {
    let text = searchController.searchBar.text ?? ""
    onTextChange?(["text": text])
  }
}
