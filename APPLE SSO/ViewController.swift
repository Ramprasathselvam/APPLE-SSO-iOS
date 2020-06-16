//
//  ViewController.swift
//  APPLE SSO
//
//  Created by RamprasathSelvam on 10/06/20.
//  Copyright © 2020 RamprasathSelvam. All rights reserved.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {

    @IBOutlet var stackView:UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpAppleSSOBtn()
    }
    
    private func setUpAppleSSOBtn(){
        
        let signInWithAppleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
        signInWithAppleButton.addTarget(self, action: #selector(signInWithAppleButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(signInWithAppleButton)
        
    }
    
    @objc private func signInWithAppleButtonPressed() {
      let authorizationAppleIDProvider = ASAuthorizationAppleIDProvider()
      let authorizationRequest = authorizationAppleIDProvider.createRequest()
      authorizationRequest.requestedScopes = [.fullName, .email]
        
        let authorizationPasswordProvider = ASAuthorizationPasswordProvider()
        let authorizationPasswordRequest = authorizationPasswordProvider.createRequest()

      let authorizationController = ASAuthorizationController(authorizationRequests: [authorizationRequest])
      authorizationController.presentationContextProvider = self
      authorizationController.delegate = self
      authorizationController.performRequests()
    }
    
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
       guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }

       print("User ID: \(appleIDCredential.user)")

       if let userEmail = appleIDCredential.email {
         print("Email: \(userEmail)")
       }

       if let userGivenName = appleIDCredential.fullName?.givenName,
         let userFamilyName = appleIDCredential.fullName?.familyName {
         print("Given Name: \(userGivenName)")
         print("Family Name: \(userFamilyName)")
       }

       if let authorizationCode = appleIDCredential.authorizationCode,
         let identifyToken = appleIDCredential.identityToken {
         print("Authorization Code: \(authorizationCode)")
         print("Identity Token: \(identifyToken)")
         //First time user, perform authentication with the backend
         //TODO: Submit authorization code and identity token to your backend for user validation and signIn
         return
       }
       //TODO: Perform user login given User ID
     }
     
     func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
       print("Authorization returned an error: \(error.localizedDescription)")
     }

}

