//
//  DetailViewController.swift
//  Appcent Flickr API Get Recent
//
//  Created by Vural Çelik on 8.01.2020.
//  Copyright © 2020 Vural Celik. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var fullscreenImageView: UIImageView!

    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedFullscreenImageView()
        
    }
    
    func feedFullscreenImageView() {
        //Assinging the image that passed from imageTableView current cell.
        fullscreenImageView.image = image
        
    }

}
