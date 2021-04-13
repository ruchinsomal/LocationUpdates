//
//  ViewController.swift
//  LocationUpdate
//
//  Created by Ruchin Somal on 2021-04-13.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var locationArr: [CLLocation] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Locatons"
        appDelegate?.startLocationServices()
        addClearButton()
        addSwitch()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(newLocationAdded(_:)), name: .newLocationSaved, object: nil)
        guard let arr = LocationLogger().readLocation() else {
            return
        }
        locationArr = arr
        tableView.reloadData()
    }
    
    private func addSwitch() {
        let swtch = UISwitch(frame: .zero)
        swtch.isOn = true // or false
        swtch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
        let swtchNavBarItem = UIBarButtonItem(customView: swtch)
        navigationItem.rightBarButtonItem = swtchNavBarItem
    }
    
    private func addClearButton() {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Clear", for: .normal)
        btn.tintColor = .blue
        btn.addTarget(self, action: #selector(btnPressed(_:)), for: .touchUpInside)
        let btnNavBarItem = UIBarButtonItem(customView: btn)
        btnNavBarItem.tintColor = .black
        navigationItem.leftBarButtonItem = btnNavBarItem
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
        if sender.isOn {
            appDelegate?.startLocationServices()
        } else {
            appDelegate?.stopLocationServices()
        }
    }
    
    @objc func btnPressed(_ sender: UIButton) {
        LocationLogger().clear()
        locationArr.removeAll()
        tableView.reloadData()
    }
    
    @objc func newLocationAdded(_ notification: Notification) {
        guard let location = notification.userInfo?["location"] as? CLLocation else {
            return
        }
        locationArr.append(location)
        tableView.reloadData()
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let location = locationArr[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = location.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "MapViewController") as? MapViewController else {
            return
        }
        vc.selectedLocation = locationArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Notification.Name {
    static let newLocationSaved = Notification.Name("newLocationSaved")
}

