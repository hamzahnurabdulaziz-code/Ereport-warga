<?php

namespace App\Livewire\Auth;

use App\Models\User;
use Illuminate\Contracts\View\View;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Str;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;
use Livewire\Attributes\Layout;
use Livewire\Component;

#[Layout('layouts.auth')]
class Register extends Component
{
    public string $name = '';

    public string $email = '';

    public string $no_whatsapp = '';

    public string $alamat = '';

    public string $password = '';

    public string $password_confirmation = '';

    public string $role = 'warga';

    public function register(): void
    {
        $key = 'register:'.request()->ip();
        if (RateLimiter::tooManyAttempts($key, 10)) {
            throw ValidationException::withMessages(['email' => 'Terlalu banyak pendaftaran. Silakan coba lagi nanti.']);
        }
        $this->email = Str::lower(trim($this->email));
        $data = $this->validate([
            'name' => 'required|string|max:100',
            'email' => 'required|email|max:255|unique:users,email',
            'no_whatsapp' => ['required', 'regex:/^\+?[0-9]{9,15}$/'],
            'alamat' => 'required|string|max:2000',
            'password' => ['required', 'string', 'max:255', 'confirmed', Password::min(8)->letters()->numbers()],
            'role' => 'nullable|string|in:warga,admin',
        ]);
        RateLimiter::hit($key, 3600);
        $user = new User([
            'name' => $data['name'],
            'email' => $data['email'],
            'no_whatsapp' => $data['no_whatsapp'],
            'alamat' => $data['alamat'],
            'password' => $data['password'],
        ]);
        $user->role = in_array($this->role, ['warga', 'admin'], true) ? $this->role : 'warga';
        $user->save();
        Auth::login($user);
        session()->regenerate();
        if ($user->role === 'admin') {
            $this->redirectRoute('admin.dashboard');
        } else {
            $this->redirectRoute('warga.dashboard');
        }
    }

    public function render(): View
    {
        return view('livewire.auth.register')->title('Daftar Akun');
    }
}
