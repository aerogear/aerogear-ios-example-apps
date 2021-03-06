import Apollo
import Kingfisher
import UIKit
import AGSSync

class MemesTableViewCell: UITableViewCell {

    var memeId: String?
    var memeNumberOfLikes: Int = 0

    @IBOutlet var likesLabel: UILabel!
    @IBOutlet var memeImageView: UIImageView!
    @IBOutlet var userLabel:UILabel!
    @IBOutlet var avatarImageView:UIImageView!

    func configure(with meme: MemeDetails) {
        memeId = meme.id
        memeNumberOfLikes = meme.likes
        
        avatarImageView.kf.setImage(with: URL(string: meme.owner.pictureurl!), placeholder: UIImage(named: "loading"))
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2;
        avatarImageView.clipsToBounds = true;
        userLabel?.text = meme.owner.displayname
        
        memeImageView.kf.setImage(with: URL(string: meme.photourl), placeholder: UIImage(named: "loading"))
        
        likesLabel?.text = "\(memeNumberOfLikes) likes"
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }

    @IBAction func upvote(_ sender: UIButton) {
        AgsSync.instance.client?.perform(mutation: LikeMemeMutation(memeId: memeId!)) { result, error in
            if let err = result?.errors {
                print("Error:", err)
            } else {
                self.memeNumberOfLikes += 1
                self.likesLabel?.text = "\(self.memeNumberOfLikes) likes"
                sender.setBackgroundImage(UIImage(named: "favorite"), for: UIControlState.normal)
            }
            return
        }
    }
}
