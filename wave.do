onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {TOP}
add wave -noupdate /tb/DUT/reset
add wave -noupdate /tb/DUT/clock
add wave -noupdate /tb/DUT/start
add wave -noupdate /tb/DUT/EA
add wave -noupdate /tb/DUT/count
add wave -noupdate /tb/DUT/data_a
add wave -noupdate /tb/DUT/data_b
add wave -noupdate /tb/DUT/op
add wave -noupdate -divider {DADOS}
add wave -noupdate /tb/DUT/mantissa_a
add wave -noupdate /tb/DUT/mantissa_a_inv_wire
add wave -noupdate /tb/DUT/mantissa_b
add wave -noupdate /tb/DUT/mantissa_b_inv_wire
add wave -noupdate /tb/DUT/expoente_a
add wave -noupdate /tb/DUT/expoente_b
add wave -noupdate /tb/DUT/expoente_calculo
add wave -noupdate /tb/DUT/mantissa_soma
add wave -noupdate /tb/DUT/erro
add wave -noupdate /tb/DUT/mantissa_o
add wave -noupdate /tb/DUT/expoente_o
add wave -noupdate /tb/DUT/sinal_o
add wave -noupdate -divider {SAÍDA}
add wave -noupdate /tb/DUT/data_o
add wave -noupdate /tb/DUT/busy
add wave -noupdate /tb/DUT/ready
add wave -noupdate /tb/DUT/complemento
add wave -noupdate /tb/DUT/virgula


TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1800 ns}