//
//  MainPageViewController.swift
//  Appcent Flickr API Get Recent
//
//  Created by Vural Çelik on 7.01.2020.
//  Copyright © 2020 Vural Celik. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

//Created a custom cell subclass for manipulate the images.
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!

}

class MainPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageTableView: UITableView!
    
    //Defined to determine ImageURL Path.
    let apiUrlInfo = APIUrlInfo()
    
    //This model object created for fetching the JSON datas from API.
    var photoData = [PhotoInfo]() {
        didSet {
            imageTableView.reloadData()
        }
    }
    
    //This variable defined for determine current page of images.This will be used to control image JSON datas.
    var currentPage:Int = 1
    //This array defined for store the URLs of each fetched image on Table View.
    var imageURLs : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Determined the protocols
        imageTableView.delegate = self
        imageTableView.dataSource = self
        
        //This function making a load work for every 20 request of recent images in API.
        loadJSONImagesToPhotoDataStruct()
        
    }
    //This function making a load work for every 20 request of recent images in API.
    func loadJSONImagesToPhotoDataStruct() {
    
        //Datas fetched asynchronized.
        DispatchQueue.main.async {
            for pageCounter in 1...self.apiUrlInfo.TOTAL_PAGE {
                //Using Alamofire for .GET request.
                Alamofire.request(self.apiUrlInfo.METHOD + self.apiUrlInfo.API_KEY + self.apiUrlInfo.PER_PAGE + "\(pageCounter)" + "&" + self.apiUrlInfo.FORMAT + self.apiUrlInfo.NO_JSON_CALL_BACK).responseJSON { (response) in
                    
                        //JSON Datas returned with "response" variable.
                        switch response.result {
                            case .success(let value):
                                //Used SwiftyJSON Library for fetching datas eaisly.
                                let json = JSON(value)
                                
                                //Defined "data" variable for access "photos" Category in JSON Data.
                                let data = json["photos"]
                                
                                //The fetched datas from JSON is using to append an array of all JSON data.
                                data["photo"].array?.forEach({ (photoDataArray) in
                                    //This PhotoInfo object defined for feed the "photoData" array.This will use for fetch datas on every "infite scrolling" event.
                                    let photoDataArray = PhotoInfo(id: photoDataArray["id"].stringValue, secret: photoDataArray["secret"].stringValue, server: photoDataArray["server"].stringValue, farm: photoDataArray["farm"].stringValue)
                                    //Fetched JSON datas to fill "photoData" array
                                    self.photoData.append(photoDataArray)
                                    
                                })
                            
                            case .failure(let error):
                                print(error.localizedDescription)
                        }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //Defined a variable named "urlKEY" for determine each image url of each cell.
        let urlKEY = "https://farm" + self.photoData[indexPath.row].farm + ".staticflickr.com/" + self.photoData[indexPath.row].server + "/" + self.photoData[indexPath.row].id + "_" + self.photoData[indexPath.row].secret + ".jpg"
        //Stored imageURLs in diffrent array.This will be use for show the images like fullscreen images."
        self.imageURLs.append(urlKEY)
        let urlKEYtoURL = NSURL(string: urlKEY)! as URL
        
        let cell = imageTableView.dequeueReusableCell(withIdentifier: "ImageCell") as! CustomTableViewCell
        
        Alamofire.request(urlKEY).response { (response) in
            //Making "image caching" for effiency of app.
            let cachedImage = ImageResource(downloadURL: urlKEYtoURL, cacheKey: urlKEY)
            
            //Using KingFisher Library for setImage with image cache at the same time.
            cell.cellImageView.kf.setImage(with: cachedImage)
            
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Defined for reference to DetailViewController
        let detailViewController = storyboard?.instantiateViewController(identifier: "FullScreenImageViewControllerID") as? DetailViewController
        
        //Pushed the DetailViewController for show the fullscreen image of clicked image.
        self.navigationController?.pushViewController(detailViewController!, animated: true)
        
        //Getting current image URL of clicked image.
        if let url = URL(string: imageURLs[indexPath.row]) {
            
            //Fetching image data from URL.
            let data = try? Data(contentsOf: url)
            
            //Assinging fetched image to image view ofdetailViewController
            if let imageData = data {
                detailViewController?.image = UIImage(data: imageData)!
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Pagination
        let lastItem = photoData.count - 1
        
        if indexPath.row == lastItem{
            
            if currentPage <= 50 {
                
                currentPage += 1
                imageTableView.setContentOffset(.zero, animated: false)
                //imageTableView.reloadData()
            }
            else {
                print("No more photo found!")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350.0
    }
    
}
