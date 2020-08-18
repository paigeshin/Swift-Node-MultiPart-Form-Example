//
//  ViewController.swift
//  multipart-form with URLSession
//
//  Created by shin seunghyun on 2020/08/13.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    @IBAction func startNetworking(_ sender: UIButton) {
        multipartFormRawVersion()
    }
    
    //MARK: - Example
    func multipartFormRawVersion() {
        var urlRequest: URLRequest = URLRequest(url: URL(string: "http://127.0.0.1:5454/file")!)
        urlRequest.httpMethod = "POST"
        let uuid: String = UUID().uuidString //for boundary marker
        let boundary: String = "Boundary-\(uuid)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = createBody(parameters: ["Hello": "world"],
                                         boundary: boundary,
                                         data: (UIImage(named: "example")!.jpegData(compressionQuality: 0.3))!,
                                         mimeType: "image/jpg",
                                         fieldname: "image",
                                         filename: "hello.jpg")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            
        }.resume()
    }
    
    //MARK: - Component
    func customizedMultipartFormRequest(urlString: String,
                                        method: String = "POST",
                                        bodyParameters: [String: Any]?,
                                        mimeType: String,
                                        fieldName: String,
                                        fileName: String,
                                        imageData: Data,
                                        completion: @escaping(Data) -> Void)
    {
        guard let url: URL = URL(string: urlString) else {
            print("invalid URL!")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        let uuid: String = UUID().uuidString //for boundary marker
        let boundary: String = "Boundary-\(uuid)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = createBody(parameters: bodyParameters ?? [:],
                                         boundary: boundary,
                                         data: imageData,
                                         mimeType: mimeType,
                                         fieldname: fieldName,
                                         filename: fileName)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if let error: Error  = error {
                print("error", error.localizedDescription)
                return
            }
            
            if let data: Data = data {
                completion(data)
            }
            
        }.resume()
    }
    
    //MARK: - Component
    func createBody(parameters: [String: Any],
                    boundary: String,
                    data: Data,
                    mimeType: String,
                    fieldname: String,
                    filename: String) -> Data {
        let body = NSMutableData()
        
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"\(fieldname)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--")
        return body as Data
    }
    
    
}


//MARK: - Component
extension NSMutableData {
    
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
    
}
