<?php

namespace App\DataFixtures;

use App\Entity\User;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class UserFixture extends Fixture
{
    private UserPasswordHasherInterface $passwordHasher;

    public function __construct(UserPasswordHasherInterface $passwordHasher)
    {
        $this->passwordHasher = $passwordHasher;
    }

    public function load(ObjectManager $manager): void
    {
        // Create a new user instance
        $user = new User();
        $user->setEmail('user@example.com');
        $user->setRoles(['ROLE_USER']);

        // Hash the password before setting it
        $hashedPassword = $this->passwordHasher->hashPassword($user, 'user_password');
        $user->setPassword($hashedPassword);

        // Persist the user
        $manager->persist($user);

        // You can create and persist additional users here if needed

        // Flush all changes to the database
        $manager->flush();
    }
}
