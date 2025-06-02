<?php

declare(strict_types=1);

namespace App\Tests\Api;

use App\Tests\Support\ApiTester;

class DemoCest
{
    public function getDemoSuccess(ApiTester $I)
    {
        $I->sendGet('/demo');
        $I->seeResponseCodeIsSuccessful();
        $I->seeResponseIsJson();
        $I->seeResponseMatchesJsonType(['message' => 'string', 'path' => 'string']);
    }
}
