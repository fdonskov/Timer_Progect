//
//  ViewController.swift
//  Timer_Progect
//
//  Created by Федор Донсков on 29.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
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
                
//        drawBackLayer()
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
//        setConstraints()
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
//            drawWorkForeLayer()
//            startWorkResumeAnimation()
//            startWorkTimer()
            isStarted = true
            stopButton.isHidden = false
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.systemOrange, for: .normal)
        } else {
//            pauseWorkAnimation()
            timer.invalidate()
            isStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        }
    }
    
    func workingStopTimerCountdown() {
//        stopWorkAnimation()
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
//            drawRestForeLayer()
//            startRestResumeAnimation()
//            startRestTimer()
            isStarted = true
            stopButton.isHidden = false
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.systemOrange, for: .normal)
        } else {
//            pauseRestAnimation()
            timer.invalidate()
            isStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        }
    }
    
    func restStopTimerCountdown() {
//        stopRestAnimation()
        stopButton.isEnabled = false
        stopButton.alpha = 0.0
        
        startButton.setTitle("GO", for: .normal)
        startButton.setTitleColor(UIColor.systemGreen, for: .normal)
        timer.invalidate()
        timeRest = 5 //1500
        isStarted = false
        timerRestLabel.text = "00:05"
    }
    
    


}

