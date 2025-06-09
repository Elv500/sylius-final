<?php

declare(strict_types=1);

namespace App\Entity\Product;

use Sylius\MolliePlugin\Entity\ProductInterface;
use Sylius\MolliePlugin\Entity\ProductTrait;
use Doctrine\ORM\Mapping as ORM;
use Sylius\Component\Core\Model\Product as BaseProduct;
use Sylius\Component\Product\Model\ProductTranslationInterface;

#[ORM\Entity]
#[ORM\Table(name: 'sylius_product')]
class Product extends BaseProduct implements ProductInterface
{
    use ProductTrait;
    protected function createTranslation(): ProductTranslationInterface
    {
        return new ProductTranslation();
    }
}
