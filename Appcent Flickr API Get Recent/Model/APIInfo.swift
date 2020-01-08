//
//  APIInfo.swift
//  Appcent Flickr API Get Recent
//
//  Created by Vural Çelik on 7.01.2020.
//  Copyright © 2020 Vural Celik. All rights reserved.
//

import Foundation

struct APIUrlInfo {
    var API_KEY = "api_key=be4926c3ba28d62327e0176b27059605&"
    var METHOD = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&"
    var FORMAT = "format=json&"
    var NO_JSON_CALL_BACK = "nojsoncallback=1"
    var PER_PAGE = "per_page=20&"
    var TOTAL_PAGE = 50
    //https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=be4926c3ba28d62327e0176b27059605&per_page=20&page=\(pageCounter)&format=json&nojsoncallback=1
}
