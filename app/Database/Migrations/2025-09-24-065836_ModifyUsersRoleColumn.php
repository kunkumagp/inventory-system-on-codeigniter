<?php

namespace App\Database\Migrations;

use CodeIgniter\Database\Migration;

class ModifyUsersRoleColumn extends Migration
{
    public function up()
    {
        // Modify the role column to change enum values and default
        $fields = [
            'role' => [
                'type'       => 'ENUM',
                'constraint' => ['admin', 'manager', 'trader', 'viewer'],
                'default'    => 'trader', // Changed default to 'trader' since 'employee' is removed
            ],
        ];
        
        $this->forge->modifyColumn('users', $fields);
    }

    public function down()
    {
        // Rollback to original role column
        $fields = [
            'role' => [
                'type'       => 'ENUM',
                'constraint' => ['admin', 'manager', 'employee', 'viewer'],
                'default'    => 'employee',
            ],
        ];
        
        $this->forge->modifyColumn('users', $fields);
    }
}
