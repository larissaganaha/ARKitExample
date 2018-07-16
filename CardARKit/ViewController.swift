//
//  ViewController.swift
//  CardARKit
//
//  Created by Larissa Ganaha on 14/07/18.
//  Copyright © 2018 Larissa Ganaha. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()

        addPokemon()
    }
    func addPokemon(x: Float = 0, y: Float = 0, z: Float = -0.5) {
        guard let carScene = SCNScene(named: "art.scnassets/eevee.scn") else { return }
        let carNode = SCNNode()
        let carSceneChildNodes = carScene.rootNode.childNodes
        for childNode in carSceneChildNodes {
            carNode.addChildNode(childNode)
        }
        carNode.position = SCNVector3(x, y, z)
//        carNode.scale = SCNVector3(0.5, 0.5, 0.5)
        sceneView.scene.rootNode.addChildNode(carNode)
    }
//    func addPokemon(x: Float = 0, y: Float = 0, z: Float = -0.5) {
//        guard let pokemonScene = SCNScene(named: "eevee.DAE"), let pokemonNode = pokemonScene.rootNode.childNode(withName: "eevee", recursively: true) else { return }
//        pokemonNode.position = SCNVector3(x, y, z)
//        sceneView.scene.rootNode.addChildNode(pokemonNode)
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.2) {
        // adds box shape (1 float = 1 meter)
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)

        // node that represents the position and the coordinates of an object in a 3D space
        let boxNode = SCNNode()
        // gives the node a visible content by giving it a shape
        boxNode.geometry = box
        // gives node position relative to the camera
        boxNode.position = SCNVector3(x, y, z)

        // scene to be displayed in the view, added the box node to the root node of the scene
        sceneView.scene.rootNode.addChildNode(boxNode)
    }

    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)

        guard let node = hitTestResults.first?.node else {

            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }

}
// transform a matriz into float3
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
