//
//  ViewController.swift
//  RanDog
//
//  Created by Gokhan Namal on 21.10.2020.
//

import UIKit

struct RandomImageResponse: Decodable {
    let message: String
    let status: String
}

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPressRandomImage(_ sender: Any) {
        fetchRandomDogImage()
    }
    
    private func fetchRandomDogImage() {
        // baglanti adresi https://dog.ceo/api/breeds/image/random
        
        guard let url = URL(string: "https://dog.ceo/api/breeds/image/random") else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self = self, let data = data else { return }
            
            let decoder = JSONDecoder()

            do {
                let randomImageJson = try decoder.decode(RandomImageResponse.self, from: data)
                self.downloadImage(urlString: randomImageJson.message)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    private func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let self = self, let data = data else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
        
        task.resume()
    }
}

