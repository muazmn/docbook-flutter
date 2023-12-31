<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Specialization extends Model
{
    use HasFactory;

    protected $guarded = ['id'];

    public function doctors()
    {
        return $this->hasMany(Doctor::class);
    }
    public function tmpDoctors()
    {
        return $this->hasMany(TmpDoctor::class);
    }
}
