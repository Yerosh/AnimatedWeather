//
//  WeatherBrain.swift
//  AnimatedWeather
//
//  Created by Yernur Adilbek on 7/20/24.
//

import UIKit

struct WeatherBrain {
    
    var mainView: UIView
    private var mainImageView: UIImageView?
    private var cloudViews: [UIImageView] = []
    private var starViews: [UIImageView] = []
    private var currentLayer: CAEmitterLayer?
    private var backgroundImageView: UIImageView?
    private var stormAnimationLayer: CALayer?
    
    init(mainView: UIView) {
        self.mainView = mainView
    }
    
    func randomOption(count: Int) -> IndexPath {
        let randomIndex = Int.random(in: 0..<count)
        let indexPath = IndexPath(item: randomIndex, section: 0)
        return indexPath
    }
    
    func animateBackColor(to colorName: String) {
        UIView.animate(withDuration: 1.0) {
            mainView.backgroundColor = UIColor(named: colorName)
        }
    }
    
    mutating func animateMainImage(with mainImage: String) {
        mainImageView = UIImageView(image: UIImage(named: mainImage))
        guard let mainImageView = mainImageView else { return }
        mainImageView.frame = CGRect(x: mainView.frame.width, y: mainView.frame.height * 0.3, width: 100, height: 100)
        mainImageView.contentMode = .scaleAspectFill
        mainView.addSubview(mainImageView)
        let centerView = mainView.frame.width / 2 - 50
        
        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveEaseInOut], animations: {
            mainImageView.frame.origin.x = centerView
        }, completion: nil)
    }
    
    func stopAnimateMainImage(){
        if let mainImageView = mainImageView {
            UIView.animate(withDuration: 1.0, animations: {
                mainImageView.frame.origin.x = -mainImageView.frame.width
            }, completion: { _ in
                mainImageView.removeFromSuperview()
            })
        }
    }
    
    mutating func animateClouds(cloudImage: String) {
        for i in 0..<2 {
            let cloudView = createCloudView(imageName: cloudImage)
            cloudView.frame.origin.x = -cloudView.frame.width
            cloudView.frame.origin.y = mainView.frame.height * 0.25 + CGFloat(i * 100)
            mainView.addSubview(cloudView)
            cloudViews.append(cloudView)
            animateCloud(cloudView, toX: mainView.frame.width * 0.4 - cloudView.frame.width * 0.9 - CGFloat(i * 50))
        }
        
        for i in 0..<2 {
            let cloudView = createCloudView(imageName: cloudImage)
            cloudView.frame.origin.x = mainView.frame.width
            cloudView.frame.origin.y = mainView.frame.height * 0.25 + CGFloat(i * 100)
            mainView.addSubview(cloudView)
            cloudViews.append(cloudView)
            animateCloud(cloudView, toX: mainView.frame.width / 2 + cloudView.frame.width * 0.05 + CGFloat(i * 50))
        }
    }
    
    private func createCloudView(imageName: String) -> UIImageView {
        let cloudView = UIImageView(image: UIImage(named: imageName))
        cloudView.frame = CGRect(x: 0, y: 0, width: 120, height: 70)
        cloudView.contentMode = .scaleAspectFill
        return cloudView
    }
    
    private func animateCloud(_ cloudView: UIImageView, toX x: CGFloat) {
        UIView.animate(withDuration: 5.0, delay: 0, options: [.curveEaseInOut], animations: {
            cloudView.frame.origin.x = x
        }, completion: { _ in
            self.swayCloud(cloudView)
        })
    }
    
    private func swayCloud(_ cloudView: UIImageView) {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
            cloudView.frame.origin.x += 10
        }, completion: nil)
    }
    
    func stopAnimateClouds(){
        for cloudView in cloudViews {
            UIView.animate(withDuration: 1.0, animations: {
                if cloudView.frame.origin.x < mainView.frame.width / 2 {
                    cloudView.frame.origin.x = -cloudView.frame.width
                } else {
                    cloudView.frame.origin.x = mainView.frame.width
                }
            }, completion: { _ in
                cloudView.removeFromSuperview()
            })
        }
    }
    
    mutating func animateStar() {
        for _ in 0..<5 {
            let size = CGFloat.random(in: 20...40)
            let starView = UIImageView(image: UIImage(named: "star"))
            starView.frame = CGRect(x: CGFloat.random(in: 0...mainView.frame.width), y: CGFloat.random(in: 200...(mainView.frame.height / 2)), width: size, height: size)
            mainView.addSubview(starView)
            starViews.append(starView)
            
            UIView.animate(withDuration: 2.0, delay: Double.random(in: 0...2.0), options: [.curveEaseInOut, .repeat, .autoreverse], animations: {
                starView.alpha = 0.1
            }, completion: nil)
        }
    }
    
    func stopAnimateStar() {
        for starView in starViews {
            UIView.animate(withDuration: 1.0, animations: {
                starView.alpha = 0.0
            }, completion: { _ in
                starView.removeFromSuperview()
            })
        }
    }
    
    mutating func animateDrops(imageName: String) {
        currentLayer = CAEmitterLayer()
        guard let currentLayer = currentLayer else { return }
        currentLayer.emitterPosition = CGPoint(x: mainView.frame.width / 2, y: -10)
        currentLayer.emitterSize = CGSize(width: mainView.frame.width, height: 0)
        currentLayer.emitterShape = .line
        
        if imageName == "rain" {
            let rainDrop = CAEmitterCell()
            rainDrop.birthRate = 20.0
            rainDrop.lifetime = 5.0
            rainDrop.velocity = 100
            rainDrop.velocityRange = 20
            rainDrop.yAcceleration = 300
            rainDrop.emissionRange = 0
            rainDrop.contents = UIImage(named: "rain")?.cgImage
            rainDrop.scale = 0.02
            rainDrop.scaleRange = 0.01
            
            currentLayer.emitterCells = [rainDrop]
            mainView.layer.addSublayer(currentLayer)
        } else {
            let snowDrop = CAEmitterCell()
            snowDrop.birthRate = 5.0
            snowDrop.lifetime = 20.0
            snowDrop.velocity = 30
            snowDrop.velocityRange = 20
            snowDrop.yAcceleration = 10
            snowDrop.emissionRange = .pi
            snowDrop.spinRange = 0.5
            snowDrop.contents = UIImage(named: "snow")?.cgImage
            snowDrop.scale = 0.05
            snowDrop.scaleRange = 0.02
            
            currentLayer.emitterCells = [snowDrop]
            mainView.layer.addSublayer(currentLayer)
        }
    }
    
    func stopAnimateDrops() {
        guard let currentLayer = currentLayer else { return }
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            currentLayer.removeFromSuperlayer()
        }
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = currentLayer.opacity
        fadeAnimation.toValue = 0.0
        fadeAnimation.duration = 1.0
        currentLayer.add(fadeAnimation, forKey: "fade")
        CATransaction.commit()
    }
    
    mutating func changeLand(landImage: String) {
        backgroundImageView = UIImageView(image: UIImage(named: landImage))
        guard let backgroundImageView = backgroundImageView else { return }
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.heightAnchor.constraint(equalToConstant: mainView.frame.height * 0.5),
            backgroundImageView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: 50),
            backgroundImageView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
    }
    
    mutating func removeBackgroundImage() {
        if let backgroundImageView = backgroundImageView {
            backgroundImageView.removeFromSuperview()
            self.backgroundImageView = nil
        }
    }
    
    mutating func startStormEffect() {
        stormAnimationLayer = CALayer()
        guard let stormAnimationLayer = stormAnimationLayer else { return }
        stormAnimationLayer.frame = mainView.bounds
        stormAnimationLayer.backgroundColor = UIColor.clear.cgColor
        mainView.layer.addSublayer(stormAnimationLayer)
        
        let flashAnimation = CABasicAnimation(keyPath: "backgroundColor")
        flashAnimation.fromValue = UIColor.white.cgColor
        flashAnimation.toValue = UIColor.clear.cgColor
        flashAnimation.duration = 0.2
        flashAnimation.autoreverses = true
        flashAnimation.repeatCount = .greatestFiniteMagnitude
        flashAnimation.beginTime = CACurrentMediaTime() + 2.0
        flashAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        stormAnimationLayer.add(flashAnimation, forKey: "flashAnimation")
    }
    
    mutating func stopStormEffect() {
        if let stormAnimationLayer = stormAnimationLayer {
            stormAnimationLayer.removeFromSuperlayer()
            self.stormAnimationLayer = nil
        }
    }

}
