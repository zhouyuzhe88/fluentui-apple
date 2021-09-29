//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import UIKit

class SearchBarDemoController: DemoController, SearchBarDelegate {
	private lazy var searchBarAutocorrectWithBadgeView: SearchBar = buildSearchBar(
		autocorrectionType: .yes,
		placeholderText: "Type badge to add a badge"
	)
	
	private lazy var badgeView: BadgeView = {
		let avatar = MSFAvatar(style: .default, size: .xsmall)
		avatar.state.image = UIImage(named: "avatar_kat_larsson")
		let badge = BadgeView(dataSource: BadgeViewDataSource(text: "Kat Larrson", style: .default, size: .small, avatar: avatar))
		badge.disabledBackgroundColor = Colors.Palette.green20.color
		badge.disabledLabelTextColor = .white
		badge.isActive = false
		return badge
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBarNoAutocorrect = buildSearchBar(autocorrectionType: .no, placeholderText: "no autocorrect")
        let searchBarAutocorrect = buildSearchBar(autocorrectionType: .yes, placeholderText: "autocorrect")

        container.addArrangedSubview(searchBarNoAutocorrect)
        container.addArrangedSubview(searchBarAutocorrect)
		
		searchBarAutocorrectWithBadgeView.badgeView = badgeView
		container.addArrangedSubview(searchBarAutocorrectWithBadgeView)
    }

    func buildSearchBar(autocorrectionType: UITextAutocorrectionType, placeholderText: String) -> SearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.delegate = self
        searchBar.style = .darkContent // we want the opposite as we're not embedded in the header
        searchBar.placeholderText = placeholderText
        searchBar.hidesNavigationBarDuringSearch = false
        searchBar.autocorrectionType = autocorrectionType
        return searchBar
    }

    // MARK: SearchBarDelegate

    func searchBarDidBeginEditing(_ searchBar: SearchBar) {
    }

    func searchBar(_ searchBar: SearchBar, didUpdateSearchText newSearchText: String?) {
		if searchBar != searchBarAutocorrectWithBadgeView {
			searchBar.placeholderText = newSearchText ?? "search"
		} else if searchBar.searchText?.lowercased() == "badge" && searchBarAutocorrectWithBadgeView.badgeView == nil {
			searchBarAutocorrectWithBadgeView.badgeView = badgeView
			searchBar.searchText = ""
		}
    }

    func searchBarDidFinishEditing(_ searchBar: SearchBar) {
    }

    func searchBarDidCancel(_ searchBar: SearchBar) {
        searchBar.progressSpinner.stopAnimating()
    }

    func searchBarDidRequestSearch(_ searchBar: SearchBar) {
        searchBar.progressSpinner.startAnimating()
    }
}
