<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class SecurityController extends AbstractController
{
    /**
     * @Route("/api/logout", name="api_logout", methods={"POST"})
     */
    public function logoutAction()
    {
        // Handle the logout process here
        // This will be triggered by the `logout_firewall` in the configuration
        return new JsonResponse(['message' => 'Logged out successfully']);
    }
}
