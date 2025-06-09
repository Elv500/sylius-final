<?php

declare(strict_types=1);

namespace App\Entity\Order;

use Sylius\MolliePlugin\Entity\OrderInterface;
use Sylius\MolliePlugin\Entity\MolliePaymentIdOrderTrait;
use Sylius\MolliePlugin\Entity\QRCodeOrderTrait;
use Sylius\MolliePlugin\Entity\RecurringOrderTrait;
use Sylius\MolliePlugin\Entity\AbandonedEmailOrderTrait;
use Doctrine\ORM\Mapping as ORM;
use Sylius\Component\Core\Model\Order as BaseOrder;

#[ORM\Entity]
#[ORM\Table(name: 'sylius_order')]
class Order extends BaseOrder implements OrderInterface
{
    use MolliePaymentIdOrderTrait;
    use QRCodeOrderTrait;
    use RecurringOrderTrait;
    use AbandonedEmailOrderTrait;
}
