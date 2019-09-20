//
//  ViewController.swift
//  URLSessionProgressTracker
//
//  Created by Shawon Ashraf on 9/20/19.
//  Copyright © 2019 Shawon Ashraf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // fit image to the view
        imageView.contentMode = .scaleAspectFill
    }

    // MARK: event handler
    @IBAction func startButtonTapped(_ sender: Any) {
        let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Polarlicht_2.jpg/1920px-Polarlicht_2.jpg?1568971082971"
        
        if let imageURL = getURLFromString(url) {
            download(from: imageURL)
        }
    }
    
    // MARK: download image from url
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    // MARK: prepare url from string
    func getURLFromString(_ str: String) -> URL? {
        return URL(string: str)
    }
    
    
    // MARK: protocol stub for download completion tracking
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        // get downloaded data from location
        let data = readDownloadedData(of: location)
        
        // set image to imageview
        setImageToImageView(from: data)
    }
    
    // MARK: protocol stubs for tracking download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
        
        // update the percentage label
        DispatchQueue.main.async {
            self.percentageLabel.text = "\(percentDownloaded * 100)%"
        }
    }
    
    // MARK: set image to image view
    func setImageToImageView(from data: Data?) {
        guard let imageData = data else { return }
        guard let image = getUIImageFromData(imageData) else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    func getUIImageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    // MARK: read downloaded data
    func readDownloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
}

