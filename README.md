# Swift-Node-MultiPart-Form-Example

# Swift

### Example for understanding

```swift
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
```

### Make reusable Component

```swift
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
```

### Entire Code

```swift
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
```

# Node

- if you implement `multer` , it automatically handles `file` request.
- further experiments are required for files such as audio & video file type.
- `req.file`

```jsx
const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');

const app = express();

//MARK Disk Storage
const fileStorage = multer.diskStorage({
	destination: (req, file, cb) => {
		cb(null, 'images'); //pointing images folder
	},
	filename: (req, file, cb) => {
		cb(null, new Date().toISOString() + '-' + file.originalname);
	}
});

//MARK: File Filter
const fileFilter = (req, file, cb) => {
	//WARNING, note that if you want to check mimetype, you should type `mimetype` instead of `mimeType`. I spent 2 hours figuring it out.
	if (file.mimetype === 'image/png' || file.mimetype === 'image/jpg' || file.mimetype === 'image/jpeg') {
		cb(null, true); //file upload success
	} else {
		cb(null, false); //file upload fail
	}
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(
	multer({ storage: fileStorage, fileFilter: fileFilter }).single('image') //field 이름이 image
);

app.use('/images', express.static(path.join(__dirname, 'images')));

app.use((req, res, next) => {
	res.setHeader('Access-Control-Allow-Origin', '*');
	res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
	res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, form-data, multipart/form-data');
	next();
});

app.post('/file', (req, res, next) => {
	if (!req.file) {
		const error = new Error('No image provided');
		error.statusCode = 422;
		throw error;
	}

	const imageUrl = req.file.path;
	res.json({ message: 'Image sent successfully', url: imageUrl });
});

app.get('/', (req, res, next) => {
	res.send('Hello World');
});

app.use((error, req, res, next) => {
	const status = error.statuscode || 500;
	const message = error.message;
	const data = error.data;
	console.log(message);
	console.log(data);
	res.status(status).json({ message: message, data: data });
});

app.listen(3000);
```