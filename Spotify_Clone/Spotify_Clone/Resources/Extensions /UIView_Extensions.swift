//
//  UIView_Extensions.swift
//  Spotify_Clone
//
//  Created by Ziyad Qassem on 16/09/2024.
//

import Foundation
import UIKit

extension UIView {
    var width : CGFloat {
        return frame.size.width
    }
    
    var height : CGFloat {
        return frame.size.height
    }
    
    var viewLeft : CGFloat {
        return frame.origin.x
    }
    
    var viewRight : CGFloat {
        return viewLeft + width
    }
    
    var viewTop : CGFloat {
        return frame.origin.y
    }
    
    var viewBottom : CGFloat {
        return viewTop + height
    }
}
