-- Panel configuration table
CREATE TABLE panels (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL DEFAULT 'Main Panel',
  total_slots INTEGER NOT NULL DEFAULT 40,
  slots_per_side INTEGER NOT NULL DEFAULT 20,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Circuits table with support for different breaker types
CREATE TABLE circuits (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  panel_id INTEGER NOT NULL DEFAULT 1,
  circuit_number TEXT NOT NULL,
  breaker_type TEXT NOT NULL CHECK (breaker_type IN ('single', 'double', 'tandem')),
  slot_start INTEGER NOT NULL,
  slot_end INTEGER,
  tandem_position TEXT CHECK (tandem_position IN ('A', 'B', NULL)),
  description TEXT NOT NULL,
  room TEXT,
  amperage INTEGER NOT NULL DEFAULT 15,
  voltage INTEGER NOT NULL DEFAULT 120,
  notes TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (panel_id) REFERENCES panels(id)
);

-- Create indexes for better performance
CREATE INDEX idx_circuits_panel_id ON circuits(panel_id);
CREATE INDEX idx_circuits_slot_start ON circuits(slot_start);
CREATE INDEX idx_circuits_breaker_type ON circuits(breaker_type);

-- Insert default panel
INSERT INTO panels (name, total_slots, slots_per_side) 
VALUES ('Main Panel', 40, 20);
