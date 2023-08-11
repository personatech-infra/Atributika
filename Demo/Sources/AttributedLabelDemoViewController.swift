//
//  Copyright © 2017-2023 Pavel Sharanda. All rights reserved.
//

import Atributika
import AtributikaViews
import UIKit

typealias TableViewCellStyle = UITableViewCell.CellStyle

extension String {
    func styleAsTweet() -> NSAttributedString {
        let baseLinkAttrs = Attrs().foregroundColor(.blue)

        let a = TagTuner {
            Attrs(baseLinkAttrs).akaLink($0.tag.attributes["href"] ?? "")
        }

        let hashtag = DetectionTuner {
            // ignore detection if akaLink was set for its range beforehand
            if $0.firstExistingAttributeValue(for: .akaLink) != nil {
                return Attrs()
            } else {
                return Attrs(baseLinkAttrs).akaLink("https://twitter.com/hashtag/\($0.text.replacingOccurrences(of: "#", with: ""))")
            }
        }

        let mention = DetectionTuner {
            // ignore detection if akaLink was set for its range beforehand
            if $0.firstExistingAttributeValue(for: .akaLink) != nil {
                return Attrs()
            } else {
                return Attrs(baseLinkAttrs).akaLink("https://twitter.com/\($0.text.replacingOccurrences(of: "@", with: ""))")
            }
        }

        let link = DetectionTuner {
            // ignore detection if akaLink was set for its range beforehand
            if $0.firstExistingAttributeValue(for: .akaLink) != nil {
                return Attrs()
            } else {
                return Attrs(baseLinkAttrs).akaLink($0.text)
            }
        }

        return style(tags: ["a": a])
            .styleHashtags(hashtag)
            .styleMentions(mention)
            .styleLinks(link)
            .attributedString
    }
}

var tweets: [String] = [
    "Test <a href=\"https://www.muppets.com\">muppets.com</a> and www.kermit.com",
    "Test <a href=\"https://instagram.com/hashtag/hashtag\">#hashtag</a> and #hashtag",
    "Teat <a href=\"https://instagram.com/mention\">@mention</a> and @mention",
    "Thank you for everything. My last ask is the same",
    "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link</a>",
    "@e2F If only Bradley's arm was longer. Best photo ever. 😊 #oscars😊 https://pic.twitter.com/C9U5NOtGap<br>Check this <a href=\"https://github.com/psharanda/Atributika\">link that won't detect click here If only Bradley's arm was longer. Best photo ever</a>",
    "For every retweet this gets, Pedigree will donate one bowl of dog food to dogs in need! 😊 #tweetforbowls",
    "All the love as always. H",
    "We got kicked out of a @Delta airplane because I spoke Arabic to my mom on the phone and with my friend slim... WTFFFFFFFF please spread",
    "Thank you for everything. My last ask is the same as my first. I'm asking you to believe—not in my ability to create change, but in yours.",
    "Four more years.",
    "RT or tweet #camilahammersledge for a follow 👽",
    "Denny JA: Dengan RT ini, anda ikut memenangkan Jokowi-JK. Pilih pemimpin yg bisa dipercaya (Jokowi) dan pengalaman (JK). #DJoJK",
    "Always in my heart @Harry_Styles . Yours sincerely, Louis",
    "HELP ME PLEASE. A MAN NEEDS HIS NUGGS https://pbs.twimg.com/media/C8sk8QlUwAAR3qI.jpg",
    "Подтверждая номер телефона, вы\nпринимаете «<a>пользовательское соглашение</a>»",
    "Here's how a similar one was solved 😄 \nhttps://medium.com/@narcelio/solving-decred-mockingbird-puzzle-5366efeaeed7\n",
]

class AttributedLabelDemoViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .plain)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Attributed Label"
        view.addSubview(tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension AttributedLabelDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "CellId"
        let cell = (tableView.dequeueReusableCell(withIdentifier: cellId) as? TweetCell) ?? TweetCell(style: .default, reuseIdentifier: cellId)
        cell.tweet = tweets[indexPath.row]
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AttributedLabelDemoDetailsViewController()

        var x20 = String()

        for _ in 0 ..< 20 {
            x20.append(tweets[indexPath.row])
            x20.append("\n")
        }

        vc.tweet = x20
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.flashScrollIndicators()

        if let selectedRow = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRow, animated: animated)
        }
    }
}

class TweetCell: UITableViewCell {
    private let tweetLabel = AttributedLabel()

    override init(style: TableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        tweetLabel.onLinkTouchUpInside = { _, val in
            if let linkStr = val as? String {
                if let url = URL(string: linkStr) {
                    UIApplication.shared.open(url)
                }
            }
        }

        contentView.addSubview(tweetLabel)

        let marginGuide = contentView.layoutMarginsGuide

        tweetLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        tweetLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        tweetLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        tweetLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        // tweetLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 300).isActive = true

        tweetLabel.numberOfLines = 0
        tweetLabel.font = .preferredFont(forTextStyle: .body)
        // tweetLabel.highlightedLinkAttributes = Attrs().underlineStyle(.single).attributes
        tweetLabel.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes
        tweetLabel.linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()

        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture))
        tweetLabel.addGestureRecognizer(lpgr)
    }

    @objc private func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began,
           let linkValue = tweetLabel.highlightedLinkValue,
           let link = linkValue as? String
        {
            let ac = UIAlertController(title: "Link", message: link, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Copy", style: .default, handler: { _ in

            }))
            ac.addAction(UIAlertAction(title: "Open", style: .default, handler: { _ in

            }))
            ac.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { _ in

            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.popoverPresentationController?.sourceView = self
            window?.rootViewController?.present(ac, animated: true)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tweet: String? {
        didSet {
            guard let tweet = tweet else {
                return
            }

            tweetLabel.attributedText = tweet.styleAsTweet()
        }
    }
}

class AttributedLabelDemoDetailsViewController: UIViewController {
    private let attributedTextView = AttributedTextView()

    var tweet: String? {
        didSet {
            guard let tweet = tweet else {
                return
            }

            attributedTextView.attributedText = tweet.styleAsTweet()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AttributedTextView"
        view.backgroundColor = .white
        view.addSubview(attributedTextView)

        attributedTextView.isScrollEnabled = true
        attributedTextView.isSelectable = true
        attributedTextView.alwaysBounceVertical = true
        attributedTextView.numberOfLines = 0
        attributedTextView.highlightedLinkAttributes = Attrs().underlineStyle(.single).foregroundColor(.white).attributes
        attributedTextView.disabledLinkAttributes = Attrs().foregroundColor(.lightGray).attributes

        var linkHighlightViewFactory = RoundedRectLinkHighlightViewFactory()
        linkHighlightViewFactory.fillColor = UIColor.darkGray
        linkHighlightViewFactory.enableAnimations = false

        attributedTextView.linkHighlightViewFactory = linkHighlightViewFactory
        attributedTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        attributedTextView.onLinkTouchUpInside = { _, val in
            if let linkStr = val as? String {
                if let url = URL(string: linkStr) {
                    UIApplication.shared.open(url)
                }
            }
        }

        attributedTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            attributedTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            attributedTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            attributedTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            attributedTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
