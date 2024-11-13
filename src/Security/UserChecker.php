<?php

namespace App\Security;

use App\Entity\User;
use Symfony\Component\Security\Core\Exception\AuthenticationCredentialsNotFoundException;
use Symfony\Component\Security\Core\User\UserCheckerInterface;
use Symfony\Component\Security\Core\User\UserInterface;

class UserChecker implements UserCheckerInterface
{
    public function checkPreAuth(UserInterface $user): void
    {
        /**
         * @var User $user
         */
        if (!$user instanceof User) {
            return;
        }

        if (!$user->getEmail()) {
            throw new AuthenticationCredentialsNotFoundException('Bad credentials');
        }
    }

    public function checkPostAuth(UserInterface $user): void
    {
        if (!$user instanceof User) {
            return;
        }
    }
}
