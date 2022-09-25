/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Preview provider context menu example for UICollectionView.
*/

import UIKit

class CollectionViewPreviewProvider: BaseCollectionViewTestViewController {
    
    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView,
                                 contextMenuConfigurationForItemAt indexPath: IndexPath,
                                 point: CGPoint) -> UIContextMenuConfiguration? {
        if let cellItemIdentifier = dataSource.itemIdentifier(for: indexPath) {
            let identifier = NSString(string: "\(cellItemIdentifier.name)") // Use the image name for the identifier.
            return UIContextMenuConfiguration(identifier: identifier, previewProvider: {
                if let previewViewController =
                    self.storyboard?.instantiateViewController(identifier: "PreviewViewController") as? PreviewViewController {
                    previewViewController.imageName = cellItemIdentifier.name
                    previewViewController.preferredContentSize = UIScreen.main.bounds.size
                    return previewViewController
                } else {
                    return nil
                }
            }, actionProvider: { suggestedActions in
                return UIMenu(title: "", children: [])
            })
            
        } else {
            return nil
        }
    }
    
    // Called when the interaction is about to "commit" in response to the user tapping the preview.
    override func collectionView(_ collectionView: UICollectionView,
                                 willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
                                 animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion {
            // Get the identifier to access the image name.
            guard let identifier = configuration.identifier as? String else { return }
            if let previewViewController =
                self.storyboard?.instantiateViewController(identifier: "PreviewViewController") as? PreviewViewController {
                self.navigationController?.show(previewViewController, sender: nil)
                
                Swift.debugPrint("User tapped the preview with image: \(identifier)")
            }
        }
        
    }
    
}
