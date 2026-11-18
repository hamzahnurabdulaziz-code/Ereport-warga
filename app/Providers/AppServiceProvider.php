<?php

namespace App\Providers;

use App\Http\Middleware\EnsureRole;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Livewire\Livewire;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        Livewire::addPersistentMiddleware([EnsureRole::class]);

        if ($this->app->environment('production')) {
            URL::forceScheme('https');
        }
    }
}
