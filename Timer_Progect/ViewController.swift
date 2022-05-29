//
//  ViewController.swift
//  Timer_Progect
//
//  Created by Федор Донсков on 29.05.2022.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {
    
    private lazy var foreProgressLayer = CAShapeLayer()
    private lazy var foreProgressLayerSecond = CAShapeLayer()
    private lazy var backProgressLayer = CAShapeLayer()
    private lazy var animation = CABasicAnimation(keyPath: "strokeEnd")
    private lazy var isWorkAnimationStarted = false
    private lazy var isRestAnimationStarted = false
    
    private lazy var timer = Timer()
    private lazy var isWorkTime = true
    private lazy var isStarted = false
    private lazy var timeWork: Double = 10 // 1500
    private lazy var timeRest: Double = 5 // 300

    // MARK: - Configuration of elements
    
    let timerWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "00:10"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let timerRestLabel: UILabel = {
        let label = UILabel()
        label.text = "00:05"
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("GO", for: .normal)
        button.setTitleColor(UIColor.systemGreen, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let stopButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.backgroundColor = .white
        button.isHidden = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        timerRestLabel.isHidden = true
        
        view.addSubview(timerWorkLabel)
        view.addSubview(timerRestLabel)
        view.addSubview(startButton)
        view.addSubview(stopButton)

        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        drawBackLayer()
        setConstraints()
    }
    
    // MARK: - Actions buttons
    
    @objc func startButtonTapped() {
        if isWorkTime {
            workingStartTimerCountdown()
        } else {
            restStartTimerCountdown()
        }
    }
    
    @objc func stopButtonTapped() {
        if isWorkTime {
            workingStopTimerCountdown()
        } else {
            restStopTimerCountdown()
        }
    }
    
    func workingStartTimerCountdown() {
        stopButton.isEnabled = true
        stopButton.alpha = 1.0
        
        if !isStarted {
            drawWorkForeLayer()
            startWorkResumeAnimation()
            startWorkTimer()
            isStarted = true
            stopButton.isHidden = false
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.systemOrange, for: .normal)
        } else {
            pauseWorkAnimation()
            timer.invalidate()
            isStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        }
    }
    
    func workingStopTimerCountdown() {
        stopWorkAnimation()
        stopButton.isEnabled = false
        stopButton.alpha = 0.0
        
        startButton.setTitle("GO", for: .normal)
        startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        timer.invalidate()
        timeWork = 10 //1500
        isStarted = false
        timerWorkLabel.text = "00:10"
    }
    
    func restStartTimerCountdown() {
        stopButton.isEnabled = true
        stopButton.alpha = 1.0
        
        if !isStarted {
            drawRestForeLayer()
            startRestResumeAnimation()
            startRestTimer()
            isStarted = true
            stopButton.isHidden = false
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.systemOrange, for: .normal)
        } else {
            pauseRestAnimation()
            timer.invalidate()
            isStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        }
    }
    
    func restStopTimerCountdown() {
        stopRestAnimation()
        stopButton.isEnabled = false
        stopButton.alpha = 0.0
        
        startButton.setTitle("GO", for: .normal)
        startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        timer.invalidate()
        timeRest = 5 //1500
        isStarted = false
        timerRestLabel.text = "00:05"
    }
    
    // MARK: - Settings timer
    // Timer 1500 seconds
    func startWorkTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateWorkTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateWorkTimer() {
        if timeWork < 1 {
            timerRestLabel.isHidden = false
            stopButton.isEnabled = false
            stopButton.alpha = 0.0
            startButton.setTitle("GO", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
            timer.invalidate()
            timeWork = 10 //1500
            isStarted = false
            isWorkTime = false
            timerWorkLabel.text = "00:10"
            timerWorkLabel.isHidden = true
        } else {
            timeWork -= 1
            timerWorkLabel.text = formatWorkTime()
        }
    }

    func formatWorkTime() -> String {
        let minutes = Int(timeWork) / 60 % 60
        let seconds = Int(timeWork) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // Timer 300 seconds
    func startRestTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateRestTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateRestTimer() {
        if timeRest < 1 {
            timerWorkLabel.isHidden = false
            stopButton.isEnabled = false
            stopButton.alpha = 0.0
            startButton.setTitle("GO", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
            timer.invalidate()
            timeRest = 5 //300
            isStarted = false
            isWorkTime = true
            timerRestLabel.text = "00:05"
            timerRestLabel.isHidden = true
        } else {
            timeRest -= 1
            timerRestLabel.text = formatRestTime()
        }
    }

    func formatRestTime() -> String {
        let minutes = Int(timeRest) / 60 % 60
        let seconds = Int(timeRest) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // MARK: - Animation cicrle timer
    
    // - Background of the circle
    let startAngle = -90.degreesToRadians
    let endAngle = 270.degreesToRadians
    
    func drawBackLayer() {
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 150,
                                              startAngle: startAngle,
                                              endAngle: endAngle,
                                              clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.white.cgColor
        backProgressLayer.fillColor = UIColor.clear.cgColor
        backProgressLayer.lineWidth = 15
        view.layer.addSublayer(backProgressLayer)
    }
    
    // - Animation timer 1500 seconds
    func drawWorkForeLayer() {
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 150,
                                              startAngle: startAngle,
                                              endAngle: endAngle,
                                              clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.systemRed.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startWorkResumeAnimation() {
        if !isWorkAnimationStarted {
            startWorkAnimation()
        } else {
            resumeWorkAnimation()
        }
    }

    func startWorkAnimation() {
        resetWorkAnimation()
        foreProgressLayer.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 10 //1500
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animation, forKey: "strokeEnd")
        isWorkAnimationStarted = true
    }
    
    func resetWorkAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isWorkAnimationStarted = false
    }
    
    func pauseWorkAnimation() {
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), to: nil)
        foreProgressLayer.speed = 0.0
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func resumeWorkAnimation() {
        let pausedTime = foreProgressLayer.timeOffset
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), to: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused
    }
    
    func stopWorkAnimation() {
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isWorkAnimationStarted = false
    }
    
    // - Animation timer 300 seconds
    func drawRestForeLayer() {
        foreProgressLayerSecond.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 150,
                                              startAngle: startAngle,
                                              endAngle: endAngle,
                                              clockwise: true).cgPath
        foreProgressLayerSecond.strokeColor = UIColor.systemOrange.cgColor
        foreProgressLayerSecond.fillColor = UIColor.clear.cgColor
        foreProgressLayerSecond.lineWidth = 15
        view.layer.addSublayer(foreProgressLayerSecond)
    }
    
    func startRestResumeAnimation() {
        if !isRestAnimationStarted {
            startRestAnimation()
        } else {
            resumeRestAnimation()
        }
    }

    func startRestAnimation() {
        resetRestAnimation()
        foreProgressLayerSecond.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 5 //1500
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayerSecond.add(animation, forKey: "strokeEnd")
        isRestAnimationStarted = true
    }
    
    func resetRestAnimation() {
        foreProgressLayerSecond.speed = 1.0
        foreProgressLayerSecond.timeOffset = 0.0
        foreProgressLayerSecond.beginTime = 0.0
        foreProgressLayerSecond.strokeEnd = 0.0
        isRestAnimationStarted = false
    }
    
    func pauseRestAnimation() {
        let pausedTime = foreProgressLayerSecond.convertTime(CACurrentMediaTime(), to: nil)
        foreProgressLayerSecond.speed = 0.0
        foreProgressLayerSecond.timeOffset = pausedTime
    }
    
    func resumeRestAnimation() {
        let pausedTime = foreProgressLayerSecond.timeOffset
        foreProgressLayerSecond.speed = 1.0
        foreProgressLayerSecond.timeOffset = 0.0
        foreProgressLayerSecond.beginTime = 0.0
        
        let timeSincePaused = foreProgressLayerSecond.convertTime(CACurrentMediaTime(), to: nil) - pausedTime
        foreProgressLayerSecond.beginTime = timeSincePaused
    }
    
    func stopRestAnimation() {
        foreProgressLayerSecond.speed = 1.0
        foreProgressLayerSecond.timeOffset = 0.0
        foreProgressLayerSecond.beginTime = 0.0
        foreProgressLayerSecond.strokeEnd = 0.0
        foreProgressLayerSecond.removeAllAnimations()
        isRestAnimationStarted = false
    }
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopWorkAnimation()
        stopRestAnimation()
    }
}

// MARK: - Extensions

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

// MARK: - Constraints

extension ViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            timerWorkLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 360),
            timerWorkLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            timerRestLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 360),
            timerRestLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            startButton.topAnchor.constraint(equalTo: timerWorkLabel.bottomAnchor, constant: 5),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stopButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            stopButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}
