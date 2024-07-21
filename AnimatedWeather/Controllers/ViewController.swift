//
//  ViewController.swift
//  AnimatedWeather
//
//  Created by Yernur Adilbek on 7/17/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var weatherBrain: WeatherBrain?
    
    private let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let options = ["day", "night", "rainy", "snowy"]
    
    private let backgroundImage = UIImageView(image: UIImage(named: "land"))
    
    private var selectedWeather: String?
    private var currentSelection: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherBrain = WeatherBrain(mainView: self.view)
        
        view.addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalToConstant: view.frame.height * 0.5)
        ])
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        view.addSubview(myCollectionView)
        
        view.addSubview(optionLabel)
        NSLayoutConstraint.activate([
            optionLabel.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor),
            optionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        let indexPath = weatherBrain?.randomOption(count: options.count)
        selectedWeather = options[indexPath!.row]
        myCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        collectionView(myCollectionView, didSelectItemAt: indexPath!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        myCollectionView.frame = CGRect(x: 0, y: view.frame.height * 0.05, width: view.frame.size.width, height: view.frame.height * 0.15).integral
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let imageView = UIImageView(image: UIImage(named: options[indexPath.row]))
        imageView.contentMode = .scaleAspectFit
        cell.contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWeather = options[indexPath.row]
        
        if selectedWeather == currentSelection {
            return
        }
        
        let previousSelection = currentSelection
        currentSelection = selectedWeather
        
        let localizedText = NSLocalizedString(selectedWeather!, comment: "Weather option")
        optionLabel.text? = localizedText
        
        switch previousSelection {
        case "day":
            weatherBrain?.stopAnimateMainImage()
            weatherBrain?.stopAnimateClouds()
        case "night":
            weatherBrain?.stopAnimateMainImage()
            weatherBrain?.stopAnimateClouds()
            weatherBrain?.stopAnimateStar()
        case "rainy":
            weatherBrain?.stopAnimateClouds()
            weatherBrain?.stopAnimateDrops()
            weatherBrain?.stopStormEffect()
        case "snowy":
            weatherBrain?.stopAnimateClouds()
            weatherBrain?.stopAnimateDrops()
            weatherBrain?.removeBackgroundImage()
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            switch selectedWeather {
            case "day":
                weatherBrain?.animateBackColor(to: "dayBlue")
                weatherBrain?.animateMainImage(with: "sun")
                weatherBrain?.animateClouds(cloudImage: "cloud1")
            case "night":
                weatherBrain?.animateBackColor(to: "nightBlue")
                weatherBrain?.animateStar()
                weatherBrain?.animateMainImage(with: "moon")
                weatherBrain?.animateClouds(cloudImage: "nightCloud2")
            case "rainy":
                weatherBrain?.animateBackColor(to: "rainBlue")
                weatherBrain?.startStormEffect()
                weatherBrain?.animateDrops(imageName: "rain")
                weatherBrain?.animateClouds(cloudImage: "rainCloud1")
            case "snowy":
                weatherBrain?.changeLand(landImage: "landSnow")
                weatherBrain?.animateBackColor(to: "snowBlue")
                weatherBrain?.animateDrops(imageName: "snow")
                weatherBrain?.animateClouds(cloudImage: "snowCloud2")
            default:
                break
            }
        }
    }
}
