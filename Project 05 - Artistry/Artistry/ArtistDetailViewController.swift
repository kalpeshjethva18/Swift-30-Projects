
import UIKit

class ArtistDetailViewController: UIViewController {

  var selectedArtist: Artist!
  
  let moreInfoText = "Select For More Info >"
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = selectedArtist.name
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 300
    
    NotificationCenter.default.addObserver(forName: .UIContentSizeCategoryDidChange, object: .none, queue: OperationQueue.main) { [weak self] _ in
      self?.tableView.reloadData()
    }
  }
}

extension ArtistDetailViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return selectedArtist.works.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WorkTableViewCell
    cell.selectionStyle = .none
    
    let work = selectedArtist.works[indexPath.row]
    
    cell.workImageView.image = work.image
    
    cell.workTitleLabel.text = work.title
    cell.workTitleLabel.backgroundColor = UIColor(white: 204/255, alpha: 1)
    cell.workTitleLabel.textAlignment = .center
    cell.workTitleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    
    cell.moreInfoTextView.textColor = UIColor(white: 114 / 255, alpha: 1)
    cell.moreInfoTextView.text = work.isExpanded ? work.info : moreInfoText
    cell.moreInfoTextView.textAlignment = work.isExpanded ? .left : .center
    cell.moreInfoTextView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    
    return cell
  }
}

extension ArtistDetailViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? WorkTableViewCell else {
      return
    }
    
    var work = selectedArtist.works[indexPath.row]
    work.isExpanded = !work.isExpanded
    selectedArtist.works[indexPath.row] = work
    
    cell.moreInfoTextView.text = work.isExpanded ? work.info : moreInfoText
    cell.moreInfoTextView.textAlignment = work.isExpanded ? .left : .center
    
    tableView.beginUpdates()
    tableView.endUpdates()
    
    tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
}
