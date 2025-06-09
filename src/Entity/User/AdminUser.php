<?php

declare(strict_types=1);

namespace App\Entity\User;

use Sylius\MolliePlugin\Entity\OnboardingStatusAwareInterface;
use Sylius\MolliePlugin\Entity\OnboardingStatusAwareTrait;
use Doctrine\ORM\Mapping as ORM;
use Sylius\Component\Core\Model\AdminUser as BaseAdminUser;

#[ORM\Entity]
#[ORM\Table(name: 'sylius_admin_user')]
class AdminUser extends BaseAdminUser implements OnboardingStatusAwareInterface
{
    use OnboardingStatusAwareTrait;
}
