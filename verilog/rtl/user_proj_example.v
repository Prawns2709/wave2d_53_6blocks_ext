// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_example #(
    parameter BITS = 32
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] rdata; 
    wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = rdata;
    assign wdata = wbs_dat_i;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

wave2d_53_6blocks_ext dut(

clk,reset,

x00s,x00e,x00,
x01s,x01e,x01,
x02s,x02e,x02,
x03s,x03e,x03,
x04s,x04e,x04,
x05s,x05e,x05,
x06s,x06e,x06,
x07s,x07e,x07,
x08s,x08e,x08,
x09s,x09e,x09,
x010s,x010e,x010,
x011s,x011e,x011,
x012s,x012e,x012,

x10s,x10e,x10,
x11s,x11e,x11,
x12s,x12e,x12,
x13s,x13e,x13,
x14s,x14e,x14,
x15s,x15e,x15,
x16s,x16e,x16,
x17s,x17e,x17,
x18s,x18e,x18,
x19s,x19e,x19,
x110s,x110e,x110,
x111s,x111e,x111,
x112s,x112e,x112,

x20s,x20e,x20,
x21s,x21e,x21,
x22s,x22e,x22,
x23s,x23e,x23,
x24s,x24e,x24,
x25s,x25e,x25,
x26s,x26e,x26,
x27s,x27e,x27,
x28s,x28e,x28,
x29s,x29e,x29,
x210s,x210e,x210,
x211s,x211e,x211,
x212s,x212e,x212,

x30s,x30e,x30,
x31s,x31e,x31,
x32s,x32e,x32,
x33s,x33e,x33,
x34s,x34e,x34,
x35s,x35e,x35,
x36s,x36e,x36,
x37s,x37e,x37,
x38s,x38e,x38,
x39s,x39e,x39,
x310s,x310e,x310,
x311s,x311e,x311,
x312s,x312e,x312,

x40s,x40e,x40,
x41s,x41e,x41,
x42s,x42e,x42,
x43s,x43e,x43,
x44s,x44e,x44,
x45s,x45e,x45,
x46s,x46e,x46,
x47s,x47e,x47,
x48s,x48e,x48,
x49s,x49e,x49,
x410s,x410e,x410,
x411s,x411e,x411,
x412s,x412e,x412,

x50s,x50e,x50,
x51s,x51e,x51,
x52s,x52e,x52,
x53s,x53e,x53,
x54s,x54e,x54,
x55s,x55e,x55,
x56s,x56e,x56,
x57s,x57e,x57,
x58s,x58e,x58,
x59s,x59e,x59,
x510s,x510e,x510,
x511s,x511e,x511,
x512s,x512e,x512,

x60s,x60e,x60,
x61s,x61e,x61,
x62s,x62e,x62,
x63s,x63e,x63,
x64s,x64e,x64,
x65s,x65e,x65,
x66s,x66e,x66,
x67s,x67e,x67,
x68s,x68e,x68,
x69s,x69e,x69,
x610s,x610e,x610,
x611s,x611e,x611,
x612s,x612e,x612,

x70s,x70e,x70,
x71s,x71e,x71,
x72s,x72e,x72,
x73s,x73e,x73,
x74s,x74e,x74,
x75s,x75e,x75,
x76s,x76e,x76,
x77s,x77e,x77,
x78s,x78e,x78,
x79s,x79e,x79,
x710s,x710e,x710,
x711s,x711e,x711,
x712s,x712e,x712,

x80s,x80e,x80,
x81s,x81e,x81,
x82s,x82e,x82,
x83s,x83e,x83,
x84s,x84e,x84,
x85s,x85e,x85,
x86s,x86e,x86,
x87s,x87e,x87,
x88s,x88e,x88,
x89s,x89e,x89,
x810s,x810e,x810,
x811s,x811e,x811,
x812s,x812e,x812,

x90s,x90e,x90,
x91s,x91e,x91,
x92s,x92e,x92,
x93s,x93e,x93,
x94s,x94e,x94,
x95s,x95e,x95,
x96s,x96e,x96,
x97s,x97e,x97,
x98s,x98e,x98,
x99s,x99e,x99,
x910s,x910e,x910,
x911s,x911e,x911,
x912s,x912e,x912,

x100s,x100e,x100,
x101s,x101e,x101,
x102s,x102e,x102,
x103s,x103e,x103,
x104s,x104e,x104,
x105s,x105e,x105,
x106s,x106e,x106,
x107s,x107e,x107,
x108s,x108e,x108,
x109s,x109e,x109,
x1010s,x1010e,x1010,
x1011s,x1011e,x1011,
x1012s,x1012e,x1012,

x0110s,x0110e,x0110,
x0111s,x0111e,x0111,
x0112s,x0112e,x0112,
x0113s,x0113e,x0113,
x0114s,x0114e,x0114,
x0115s,x0115e,x0115,
x0116s,x0116e,x0116,
x0117s,x0117e,x0117,
x0118s,x0118e,x0118,
x0119s,x0119e,x0119,
x01110s,x01110e,x01110,
x01111s,x01111e,x01111,
x01112s,x01112e,x01112,

x120s,x120e,x120,
x121s,x121e,x121,
x122s,x122e,x122,
x123s,x123e,x123,
x124s,x124e,x124,
x125s,x125e,x125,
x126s,x126e,x126,
x127s,x127e,x127,
x128s,x128e,x128,
x129s,x129e,x129,
x1210s,x1210e,x1210,
x1211s,x1211e,x1211,
x1212s,x1212e,x1212,

f00s,f00e,f00,
f01s,f01e,f01,
f02s,f02e,f02,
f03s,f03e,f03,
f04s,f04e,f04,
f05s,f05e,f05,
f06s,f06e,f06,

f10s,f10e,f10,
f11s,f11e,f11,
f12s,f12e,f12,
f13s,f13e,f13,
f14s,f14e,f14,
f15s,f15e,f15,
f16s,f16e,f16,

f20s,f20e,f20,
f21s,f21e,f21,
f22s,f22e,f22,
f23s,f23e,f23,
f24s,f24e,f24,
f25s,f25e,f25,
f26s,f26e,f26,

f30s,f30e,f30,
f31s,f31e,f31,
f32s,f32e,f32,
f33s,f33e,f33,
f34s,f34e,f34,
f35s,f35e,f35,
f36s,f36e,f36,

f40s,f40e,f40,
f41s,f41e,f41,
f42s,f42e,f42,
f43s,f43e,f43,
f44s,f44e,f44,
f45s,f45e,f45,
f46s,f46e,f46,

f50s,f50e,f50,
f51s,f51e,f51,
f52s,f52e,f52,
f53s,f53e,f53,
f54s,f54e,f54,
f55s,f55e,f55,
f56s,f56e,f56,

f60s,f60e,f60,
f61s,f61e,f61,
f62s,f62e,f62,
f63s,f63e,f63,
f64s,f64e,f64,
f65s,f65e,f65,
f66s,f66e,f66,

bs11,bs12,bs13,bs14,bs15,bs16,bs17,
bs21,bs22,bs23,bs24,bs25,bs26,bs27,
bs31,bs32,bs33,bs34,bs35,bs36,bs37,
bs41,bs42,bs43,bs44,bs45,bs46,bs47,
bs51,bs52,bs53,bs54,bs55,bs56,bs57,
bs61,bs62,bs63,bs64,bs65,bs66,bs67,
bs71,bs72,bs73,bs74,bs75,bs76,bs77,

in_s,s1,s2,s3,s4,s5,

y10s,y10e,y10,

in_ss,inn_s,in_sel1,in_sel

);
endmodule

//13X13 proposed N-parallel (5,3) lifting based 2D DWT

/*`include "lifting53_single_ext.v"
`include "storage7_33.v"
`include "mux2_33.v"
`include "lifting53_ext.v"
`include "multiplexer3.v"
`include "multiplexer4.v"

`include "dflipflop.v"
`include "float_adder.v"
`include "float_multi.v"
`include "dflipflop33.v"
`include "multiplexer2.v"
`include "dflipflop8.v"
`include "dflipflop24.v"
`include "mux4_33.v"
`include "mux9_33.v"
`include "mux7_33.v"
`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "recurse.v"
`include "recurse8.v"
`include "recurse40.v"
`include "fulladd.v"
`include "halfadd.v"*/

module wave2d_53_6blocks_ext(

clk,reset,

x00s,x00e,x00,
x01s,x01e,x01,
x02s,x02e,x02,
x03s,x03e,x03,
x04s,x04e,x04,
x05s,x05e,x05,
x06s,x06e,x06,
x07s,x07e,x07,
x08s,x08e,x08,
x09s,x09e,x09,
x010s,x010e,x010,
x011s,x011e,x011,
x012s,x012e,x012,

x10s,x10e,x10,
x11s,x11e,x11,
x12s,x12e,x12,
x13s,x13e,x13,
x14s,x14e,x14,
x15s,x15e,x15,
x16s,x16e,x16,
x17s,x17e,x17,
x18s,x18e,x18,
x19s,x19e,x19,
x110s,x110e,x110,
x111s,x111e,x111,
x112s,x112e,x112,

x20s,x20e,x20,
x21s,x21e,x21,
x22s,x22e,x22,
x23s,x23e,x23,
x24s,x24e,x24,
x25s,x25e,x25,
x26s,x26e,x26,
x27s,x27e,x27,
x28s,x28e,x28,
x29s,x29e,x29,
x210s,x210e,x210,
x211s,x211e,x211,
x212s,x212e,x212,

x30s,x30e,x30,
x31s,x31e,x31,
x32s,x32e,x32,
x33s,x33e,x33,
x34s,x34e,x34,
x35s,x35e,x35,
x36s,x36e,x36,
x37s,x37e,x37,
x38s,x38e,x38,
x39s,x39e,x39,
x310s,x310e,x310,
x311s,x311e,x311,
x312s,x312e,x312,

x40s,x40e,x40,
x41s,x41e,x41,
x42s,x42e,x42,
x43s,x43e,x43,
x44s,x44e,x44,
x45s,x45e,x45,
x46s,x46e,x46,
x47s,x47e,x47,
x48s,x48e,x48,
x49s,x49e,x49,
x410s,x410e,x410,
x411s,x411e,x411,
x412s,x412e,x412,

x50s,x50e,x50,
x51s,x51e,x51,
x52s,x52e,x52,
x53s,x53e,x53,
x54s,x54e,x54,
x55s,x55e,x55,
x56s,x56e,x56,
x57s,x57e,x57,
x58s,x58e,x58,
x59s,x59e,x59,
x510s,x510e,x510,
x511s,x511e,x511,
x512s,x512e,x512,

x60s,x60e,x60,
x61s,x61e,x61,
x62s,x62e,x62,
x63s,x63e,x63,
x64s,x64e,x64,
x65s,x65e,x65,
x66s,x66e,x66,
x67s,x67e,x67,
x68s,x68e,x68,
x69s,x69e,x69,
x610s,x610e,x610,
x611s,x611e,x611,
x612s,x612e,x612,

x70s,x70e,x70,
x71s,x71e,x71,
x72s,x72e,x72,
x73s,x73e,x73,
x74s,x74e,x74,
x75s,x75e,x75,
x76s,x76e,x76,
x77s,x77e,x77,
x78s,x78e,x78,
x79s,x79e,x79,
x710s,x710e,x710,
x711s,x711e,x711,
x712s,x712e,x712,

x80s,x80e,x80,
x81s,x81e,x81,
x82s,x82e,x82,
x83s,x83e,x83,
x84s,x84e,x84,
x85s,x85e,x85,
x86s,x86e,x86,
x87s,x87e,x87,
x88s,x88e,x88,
x89s,x89e,x89,
x810s,x810e,x810,
x811s,x811e,x811,
x812s,x812e,x812,

x90s,x90e,x90,
x91s,x91e,x91,
x92s,x92e,x92,
x93s,x93e,x93,
x94s,x94e,x94,
x95s,x95e,x95,
x96s,x96e,x96,
x97s,x97e,x97,
x98s,x98e,x98,
x99s,x99e,x99,
x910s,x910e,x910,
x911s,x911e,x911,
x912s,x912e,x912,

x100s,x100e,x100,
x101s,x101e,x101,
x102s,x102e,x102,
x103s,x103e,x103,
x104s,x104e,x104,
x105s,x105e,x105,
x106s,x106e,x106,
x107s,x107e,x107,
x108s,x108e,x108,
x109s,x109e,x109,
x1010s,x1010e,x1010,
x1011s,x1011e,x1011,
x1012s,x1012e,x1012,

x0110s,x0110e,x0110,
x0111s,x0111e,x0111,
x0112s,x0112e,x0112,
x0113s,x0113e,x0113,
x0114s,x0114e,x0114,
x0115s,x0115e,x0115,
x0116s,x0116e,x0116,
x0117s,x0117e,x0117,
x0118s,x0118e,x0118,
x0119s,x0119e,x0119,
x01110s,x01110e,x01110,
x01111s,x01111e,x01111,
x01112s,x01112e,x01112,

x120s,x120e,x120,
x121s,x121e,x121,
x122s,x122e,x122,
x123s,x123e,x123,
x124s,x124e,x124,
x125s,x125e,x125,
x126s,x126e,x126,
x127s,x127e,x127,
x128s,x128e,x128,
x129s,x129e,x129,
x1210s,x1210e,x1210,
x1211s,x1211e,x1211,
x1212s,x1212e,x1212,

f00s,f00e,f00,
f01s,f01e,f01,
f02s,f02e,f02,
f03s,f03e,f03,
f04s,f04e,f04,
f05s,f05e,f05,
f06s,f06e,f06,

f10s,f10e,f10,
f11s,f11e,f11,
f12s,f12e,f12,
f13s,f13e,f13,
f14s,f14e,f14,
f15s,f15e,f15,
f16s,f16e,f16,

f20s,f20e,f20,
f21s,f21e,f21,
f22s,f22e,f22,
f23s,f23e,f23,
f24s,f24e,f24,
f25s,f25e,f25,
f26s,f26e,f26,

f30s,f30e,f30,
f31s,f31e,f31,
f32s,f32e,f32,
f33s,f33e,f33,
f34s,f34e,f34,
f35s,f35e,f35,
f36s,f36e,f36,

f40s,f40e,f40,
f41s,f41e,f41,
f42s,f42e,f42,
f43s,f43e,f43,
f44s,f44e,f44,
f45s,f45e,f45,
f46s,f46e,f46,

f50s,f50e,f50,
f51s,f51e,f51,
f52s,f52e,f52,
f53s,f53e,f53,
f54s,f54e,f54,
f55s,f55e,f55,
f56s,f56e,f56,

f60s,f60e,f60,
f61s,f61e,f61,
f62s,f62e,f62,
f63s,f63e,f63,
f64s,f64e,f64,
f65s,f65e,f65,
f66s,f66e,f66,

bs11,bs12,bs13,bs14,bs15,bs16,bs17,
bs21,bs22,bs23,bs24,bs25,bs26,bs27,
bs31,bs32,bs33,bs34,bs35,bs36,bs37,
bs41,bs42,bs43,bs44,bs45,bs46,bs47,
bs51,bs52,bs53,bs54,bs55,bs56,bs57,
bs61,bs62,bs63,bs64,bs65,bs66,bs67,
bs71,bs72,bs73,bs74,bs75,bs76,bs77,

in_s,s1,s2,s3,s4,s5,

y10s,y10e,y10,

in_ss,inn_s,in_sel1,in_sel

);

input in_ss,inn_s;
input [1:0] in_sel1,in_sel;

output y10s;
output [7:0] y10e;
output [23:0] y10;

input bs11,bs12,bs13,bs14,bs15,bs16,bs17,
bs21,bs22,bs23,bs24,bs25,bs26,bs27,
bs31,bs32,bs33,bs34,bs35,bs36,bs37,
bs41,bs42,bs43,bs44,bs45,bs46,bs47,
bs51,bs52,bs53,bs54,bs55,bs56,bs57,
bs61,bs62,bs63,bs64,bs65,bs66,bs67,
bs71,bs72,bs73,bs74,bs75,bs76,bs77;

input [1:0] s1;
input [3:0] s2,s3,s4;
input [2:0] s5;
input in_s;

input clk,reset;

input x00s,x01s,x02s,x03s,x04s,x05s,x06s,x07s,x08s,x09s,x010s,x011s,x012s;
input [7:0] x00e,x01e,x02e,x03e,x04e,x05e,x06e,x07e,x08e,x09e,x010e,x011e,x012e;
input [23:0] x00,x01,x02,x03,x04,x05,x06,x07,x08,x09,x010,x011,x012;

input x10s,x11s,x12s,x13s,x14s,x15s,x16s,x17s,x18s,x19s,x110s,x111s,x112s;
input [7:0] x10e,x11e,x12e,x13e,x14e,x15e,x16e,x17e,x18e,x19e,x110e,x111e,x112e;
input [23:0] x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x110,x111,x112;

input x20s,x21s,x22s,x23s,x24s,x25s,x26s,x27s,x28s,x29s,x210s,x211s,x212s;
input [7:0] x20e,x21e,x22e,x23e,x24e,x25e,x26e,x27e,x28e,x29e,x210e,x211e,x212e;
input [23:0] x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x210,x211,x212;

input x30s,x31s,x32s,x33s,x34s,x35s,x36s,x37s,x38s,x39s,x310s,x311s,x312s;
input [7:0] x30e,x31e,x32e,x33e,x34e,x35e,x36e,x37e,x38e,x39e,x310e,x311e,x312e;
input [23:0] x30,x31,x32,x33,x34,x35,x36,x37,x38,x39,x310,x311,x312;

input x40s,x41s,x42s,x43s,x44s,x45s,x46s,x47s,x48s,x49s,x410s,x411s,x412s;
input [7:0] x40e,x41e,x42e,x43e,x44e,x45e,x46e,x47e,x48e,x49e,x410e,x411e,x412e;
input [23:0] x40,x41,x42,x43,x44,x45,x46,x47,x48,x49,x410,x411,x412;

input x50s,x51s,x52s,x53s,x54s,x55s,x56s,x57s,x58s,x59s,x510s,x511s,x512s;
input [7:0] x50e,x51e,x52e,x53e,x54e,x55e,x56e,x57e,x58e,x59e,x510e,x511e,x512e;
input [23:0] x50,x51,x52,x53,x54,x55,x56,x57,x58,x59,x510,x511,x512;

input x60s,x61s,x62s,x63s,x64s,x65s,x66s,x67s,x68s,x69s,x610s,x611s,x612s;
input [7:0] x60e,x61e,x62e,x63e,x64e,x65e,x66e,x67e,x68e,x69e,x610e,x611e,x612e;
input [23:0] x60,x61,x62,x63,x64,x65,x66,x67,x68,x69,x610,x611,x612;

input x70s,x71s,x72s,x73s,x74s,x75s,x76s,x77s,x78s,x79s,x710s,x711s,x712s;
input [7:0] x70e,x71e,x72e,x73e,x74e,x75e,x76e,x77e,x78e,x79e,x710e,x711e,x712e;
input [23:0] x70,x71,x72,x73,x74,x75,x76,x77,x78,x79,x710,x711,x712;

input x80s,x81s,x82s,x83s,x84s,x85s,x86s,x87s,x88s,x89s,x810s,x811s,x812s;
input [7:0] x80e,x81e,x82e,x83e,x84e,x85e,x86e,x87e,x88e,x89e,x810e,x811e,x812e;
input [23:0] x80,x81,x82,x83,x84,x85,x86,x87,x88,x89,x810,x811,x812;

input x90s,x91s,x92s,x93s,x94s,x95s,x96s,x97s,x98s,x99s,x910s,x911s,x912s;
input [7:0] x90e,x91e,x92e,x93e,x94e,x95e,x96e,x97e,x98e,x99e,x910e,x911e,x912e;
input [23:0] x90,x91,x92,x93,x94,x95,x96,x97,x98,x99,x910,x911,x912;

input x100s,x101s,x102s,x103s,x104s,x105s,x106s,x107s,x108s,x109s,x1010s,x1011s,x1012s;
input [7:0] x100e,x101e,x102e,x103e,x104e,x105e,x106e,x107e,x108e,x109e,x1010e,x1011e,x1012e;
input [23:0] x100,x101,x102,x103,x104,x105,x106,x107,x108,x109,x1010,x1011,x1012;

input x0110s,x0111s,x0112s,x0113s,x0114s,x0115s,x0116s,x0117s,x0118s,x0119s,x01110s,x01111s,x01112s;
input [7:0] x0110e,x0111e,x0112e,x0113e,x0114e,x0115e,x0116e,x0117e,x0118e,x0119e,x01110e,x01111e,x01112e;
input [23:0] x0110,x0111,x0112,x0113,x0114,x0115,x0116,x0117,x0118,x0119,x01110,x01111,x01112;

input x120s,x121s,x122s,x123s,x124s,x125s,x126s,x127s,x128s,x129s,x1210s,x1211s,x1212s;
input [7:0] x120e,x121e,x122e,x123e,x124e,x125e,x126e,x127e,x128e,x129e,x1210e,x1211e,x1212e;
input [23:0] x120,x121,x122,x123,x124,x125,x126,x127,x128,x129,x1210,x1211,x1212;

output f00s,f01s,f02s,f03s,f04s,f05s,f06s; //L3 outputs
output [7:0] f00e,f01e,f02e,f03e,f04e,f05e,f06e;
output [23:0] f00,f01,f02,f03,f04,f05,f06;

output f10s,f11s,f12s,f13s,f14s,f15s,f16s; //L3 outputs
output [7:0] f10e,f11e,f12e,f13e,f14e,f15e,f16e;
output [23:0] f10,f11,f12,f13,f14,f15,f16;

output f20s,f21s,f22s,f23s,f24s,f25s,f26s; //L3 outputs
output [7:0] f20e,f21e,f22e,f23e,f24e,f25e,f26e;
output [23:0] f20,f21,f22,f23,f24,f25,f26;

output f30s,f31s,f32s,f33s,f34s,f35s,f36s; //L3 outputs
output [7:0] f30e,f31e,f32e,f33e,f34e,f35e,f36e;
output [23:0] f30,f31,f32,f33,f34,f35,f36;

output f40s,f41s,f42s,f43s,f44s,f45s,f46s; //L3 outputs
output [7:0] f40e,f41e,f42e,f43e,f44e,f45e,f46e;
output [23:0] f40,f41,f42,f43,f44,f45,f46;

output f50s,f51s,f52s,f53s,f54s,f55s,f56s; //L3 outputs
output [7:0] f50e,f51e,f52e,f53e,f54e,f55e,f56e;
output [23:0] f50,f51,f52,f53,f54,f55,f56;

output f60s,f61s,f62s,f63s,f64s,f65s,f66s; //L3 outputs
output [7:0] f60e,f61e,f62e,f63e,f64e,f65e,f66e;
output [23:0] f60,f61,f62,f63,f64,f65,f66;

//row processor

wire r10s,r11s,r12s,r13s,r14s,r15s,r16s,r17s,r18s,r19s,r110s,r111s,r112s;
wire [7:0] r10e,r11e,r12e,r13e,r14e,r15e,r16e,r17e,r18e,r19e,r110e,r111e,r112e;
wire [23:0] r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r110,r111,r112;

wire r20s,r21s,r22s,r23s,r24s,r25s,r26s,r27s,r28s,r29s,r210s,r211s,r212s;
wire [7:0] r20e,r21e,r22e,r23e,r24e,r25e,r26e,r27e,r28e,r29e,r210e,r211e,r212e;
wire [23:0] r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r210,r211,r212;

lifting53_single_ext rr00(clk,reset,

r10s,r10e,r10,
r20s,r20e,r20,

x00s,x00e,x00,
x01s,x01e,x01,
x02s,x02e,x02,
x03s,x03e,x03,
x04s,x04e,x04,
x05s,x05e,x05,
x06s,x06e,x06,
x07s,x07e,x07,
x08s,x08e,x08,
x09s,x09e,x09,
x010s,x010e,x010,
x011s,x011e,x011,
x012s,x012e,x012,

f60s,f60e,f60,
f50s,f50e,f50,
f40s,f40e,f40,
f30s,f30e,f30,
f20s,f20e,f20,
f10s,f10e,f10,
f00s,f00e,f00,

in_s,s1,s2,s3,s4,s5

);

lifting53_single_ext rr01(clk,reset,

r11s,r11e,r11,
r21s,r21e,r21,

x10s,x10e,x10,
x11s,x11e,x11,
x12s,x12e,x12,
x13s,x13e,x13,
x14s,x14e,x14,
x15s,x15e,x15,
x16s,x16e,x16,
x17s,x17e,x17,
x18s,x18e,x18,
x19s,x19e,x19,
x110s,x110e,x110,
x111s,x111e,x111,
x112s,x112e,x112,

f61s,f61e,f61,
f51s,f51e,f51,
f41s,f41e,f41,
f31s,f31e,f31,
f21s,f21e,f21,
f11s,f11e,f11,
f01s,f01e,f01,

in_s,s1,s2,s3,s4,s5

);

lifting53_single_ext rr02(clk,reset,

r12s,r12e,r12,
r22s,r22e,r22,

x20s,x20e,x20,
x21s,x21e,x21,
x22s,x22e,x22,
x23s,x23e,x23,
x24s,x24e,x24,
x25s,x25e,x25,
x26s,x26e,x26,
x27s,x27e,x27,
x28s,x28e,x28,
x29s,x29e,x29,
x210s,x210e,x210,
x211s,x211e,x211,
x212s,x212e,x212,

f62s,f62e,f62,
f52s,f52e,f52,
f42s,f42e,f42,
f32s,f32e,f32,
f22s,f22e,f22,
f12s,f12e,f12,
f02s,f02e,f02,

in_s,s1,s2,s3,s4,s5

);

lifting53_single_ext rr03(clk,reset,

r13s,r13e,r13,
r23s,r23e,r23,

x30s,x30e,x30,
x31s,x31e,x31,
x32s,x32e,x32,
x33s,x33e,x33,
x34s,x34e,x34,
x35s,x35e,x35,
x36s,x36e,x36,
x37s,x37e,x37,
x38s,x38e,x38,
x39s,x39e,x39,
x310s,x310e,x310,
x311s,x311e,x311,
x312s,x312e,x312,

f63s,f63e,f63,
f53s,f53e,f53,
f43s,f43e,f43,
f33s,f33e,f33,
f23s,f23e,f23,
f13s,f13e,f13,
f03s,f03e,f03,

in_s,s1,s2,s3,s4,s5

);

lifting53_single_ext rr04(clk,reset,

r14s,r14e,r14,
r24s,r24e,r24,

x40s,x40e,x40,
x41s,x41e,x41,
x42s,x42e,x42,
x43s,x43e,x43,
x44s,x44e,x44,
x45s,x45e,x45,
x46s,x46e,x46,
x47s,x47e,x47,
x48s,x48e,x48,
x49s,x49e,x49,
x410s,x410e,x410,
x411s,x411e,x411,
x412s,x412e,x412,

f64s,f64e,f64,
f54s,f54e,f54,
f44s,f44e,f44,
f34s,f34e,f34,
f24s,f24e,f24,
f14s,f14e,f14,
f04s,f04e,f04,

in_s,s1,s2,s3,s4,s5

);


lifting53_single_ext rr05(clk,reset,

r15s,r15e,r15,
r25s,r25e,r25,

x50s,x50e,x50,
x51s,x51e,x51,
x52s,x52e,x52,
x53s,x53e,x53,
x54s,x54e,x54,
x55s,x55e,x55,
x56s,x56e,x56,
x57s,x57e,x57,
x58s,x58e,x58,
x59s,x59e,x59,
x510s,x510e,x510,
x511s,x511e,x511,
x512s,x512e,x512,

f65s,f65e,f65,
f55s,f55e,f55,
f45s,f45e,f45,
f35s,f35e,f35,
f25s,f25e,f25,
f15s,f15e,f15,
f05s,f05e,f05,

in_s,s1,s2,s3,s4,s5

);

//column porcessor

//high pass/high pass outputs 

wire y1s,y2s,y3s,y4s,y5s,y6s,y7s,y8s,y9s,y10s,y11s,y12s;
wire [7:0] y1e,y2e,y3e,y4e,y5e,y6e,y7e,y8e,y9e,y10e,y11e,y12e;
wire [23:0] y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12;

lifting53_ext fh1(r10s,r10e,r10,r10s,r10e,r10,r12s,r12e,r12,r11s,r11e,r11,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y1s,y1e,y1,y2s,y2e,y2);
lifting53_ext fh2(1'b0,8'd0,24'd0,r12s,r12e,r12,r14s,r14e,r14,r13s,r13e,r13,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y3s,y3e,y3,y4s,y4e,y4);
lifting53_ext fh3(1'b0,8'd0,24'd0,r14s,r14e,r14,r14s,r14e,r14,r15s,r15e,r15,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y5s,y5e,y5,y6s,y6e,y6);

lifting53_ext fl1(r20s,r20e,r20,r20s,r20e,r20,r22s,r22e,r22,r21s,r21e,r21,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y7s,y7e,y7,y8s,y8e,y8);
lifting53_ext fl2(1'b0,8'd0,24'd0,r22s,r22e,r22,r24s,r24e,r24,r23s,r23e,r23,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y9s,y9e,y9,y10s,y10e,y10);
lifting53_ext fl3(1'b0,8'd0,24'd0,r24s,r24e,r24,r24s,r24e,r24,r25s,r25e,r25,1'b0,8'd0,24'd0,clk,reset,in_sel,in_sel1,in_ss,inn_s,y11s,y11e,y11,y12s,y12e,y12);

//7X7-storage buffer

//storage7_33(i,d1,d2,d3,d4,d5,d6,d7,s1,s2,s3,s4,s5,s6,s7,clk,reset);

storage7_33 bu1({y1s,y1e,y1},{f00s,f00e,f00},{f10s,f10e,f10},{f20s,f20e,f20},{f30s,f30e,f30},{f40s,f40e,f40},{f50s,f50e,f50},{f60s,f60e,f60},bs11,bs12,bs13,bs14,bs15,bs16,bs17,clk,reset);
storage7_33 bu2({y3s,y3e,y3},{f01s,f01e,f01},{f11s,f11e,f11},{f21s,f21e,f21},{f31s,f31e,f31},{f41s,f41e,f41},{f51s,f51e,f51},{f61s,f61e,f61},bs21,bs22,bs23,bs24,bs25,bs26,bs27,clk,reset);
storage7_33 bu3({y5s,y5e,y5},{f02s,f02e,f02},{f12s,f12e,f12},{f22s,f22e,f22},{f32s,f32e,f32},{f42s,f42e,f42},{f52s,f52e,f52},{f62s,f62e,f62},bs31,bs32,bs33,bs34,bs35,bs36,bs37,clk,reset);
storage7_33 bu4({y1s,y1e,y1},{f03s,f03e,f03},{f13s,f13e,f13},{f23s,f23e,f23},{f33s,f33e,f33},{f43s,f43e,f43},{f53s,f53e,f53},{f63s,f63e,f63},bs41,bs42,bs43,bs44,bs45,bs46,bs47,clk,reset);
storage7_33 bu5({y3s,y3e,y3},{f04s,f04e,f04},{f14s,f14e,f14},{f24s,f24e,f24},{f34s,f34e,f34},{f44s,f44e,f44},{f54s,f54e,f54},{f64s,f64e,f64},bs51,bs52,bs53,bs54,bs55,bs56,bs57,clk,reset);
storage7_33 bu6({y5s,y5e,y5},{f05s,f05e,f05},{f15s,f15e,f15},{f25s,f25e,f25},{f35s,f35e,f35},{f45s,f45e,f45},{f55s,f55e,f55},{f65s,f65e,f65},bs61,bs62,bs63,bs64,bs65,bs66,bs67,clk,reset);
storage7_33 bu7({y1s,y1e,y1},{f06s,f06e,f06},{f16s,f16e,f16},{f26s,f26e,f26},{f36s,f36e,f36},{f46s,f46e,f46},{f56s,f56e,f56},{f66s,f66e,f66},bs71,bs72,bs73,bs74,bs75,bs76,bs77,clk,reset);

endmodule

//conventional 5/3 lifting based wavelet with 3 octaves

module lifting53_ext(in_as,in_ae,in_a,in_bs,in_be,in_b,in_cs,in_ce,in_c,in_ds,in_de,in_d,in_es,in_ee,in_e,clk,reset,in_sel,in_sel1,in_ss,in_s,
r1s,r1e,r1,s4s,s4e,s4);

input in_as,in_bs,in_cs,in_ds,in_es;
input [7:0] in_ae,in_be,in_ce,in_de,in_ee;
input [23:0] in_a,in_b,in_c,in_d,in_e;

input in_ss,in_s,clk,reset;
input [1:0] in_sel1,in_sel;

output r1s,s4s;
output [7:0] r1e,s4e;
output [23:0] r1,s4;

wire as,bs,cs,ds,es;
wire [7:0] ae,be,ce,de,ee;
wire [23:0] a,b,c,d,e;

dflipflop d00(as,in_as,clk,reset);
dflipflop d01(bs,in_bs,clk,reset);
dflipflop d02(cs,in_cs,clk,reset);
dflipflop d03(ds,in_ds,clk,reset);
dflipflop d04(es,in_es,clk,reset);
dflipflop8 d05(ae,in_ae,clk,reset);
dflipflop8 d06(be,in_be,clk,reset);
dflipflop8 d07(ce,in_ce,clk,reset);
dflipflop8 d08(de,in_de,clk,reset);
dflipflop8 d09(ee,in_ee,clk,reset);
dflipflop24 d10(a,in_a,clk,reset);
dflipflop24 d11(b,in_b,clk,reset);
dflipflop24 d12(c,in_c,clk,reset);
dflipflop24 d13(d,in_d,clk,reset);
dflipflop24 d14(e,in_e,clk,reset);

wire ss,s;
wire [1:0] sel,sel1;

dflipflop d15(sel[0],in_sel[0],clk,reset);
dflipflop d16(sel[1],in_sel[1],clk,reset);
dflipflop d17(sel1[0],in_sel1[0],clk,reset);
dflipflop d18(sel1[1],in_sel1[1],clk,reset);
dflipflop d19(ss,in_ss,clk,reset);
dflipflop d20(s,in_s,clk,reset);

wire [32:0] p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,s0,s1,s2,s3;

multiplexer3 m1({as,ae,a},s1,s3,p1,sel1);
multiplexer4 m2({bs,be,b},s1,s2,s2,p2,sel);
multiplexer4 m3({cs,ce,c},s3,{s4s,s4e,s4},s3,p3,sel);
multiplexer4 m4({ds,de,d},s2,s3,{s4s,s4e,s4},p4,sel);
multiplexer2 m5({es,ee,e},s2,p5,ss);

wire sign;
assign sign=~p4[32];

float_adder f1(p2[32],p2[31:24],p2[23:0],p3[32],p3[31:24],p3[23:0],p6[32],p6[31:24],p6[23:0]);
float_multi f2(p6[32],p6[31:24],p6[23:0],1'b0,8'b01111111,24'b100000000000000000000000,p7[32],p7[31:24],p7[23:0]);
float_adder f3(p7[32],p7[31:24],p7[23:0],sign,p4[31:24],p4[23:0],p8[32],p8[31:24],p8[23:0]);

wire [32:0] r2;
wire r1s,s4s;
wire [7:0] r1e,s4e;
wire [23:0] r1,s4;

dflipflop33 d21({r1s,r1e,r1},p8,clk,reset);
dflipflop33 d22(r2,{r1s,r1e,r1},clk,reset);

//dflipflop33 d23(p9,p1,clk,reset);
//dflipflop33 d24(p13,p5,clk,reset);

assign p9=p1;
assign p13=p5;

wire sj;
//dflipflop d25(sj,s,clk,reset);

assign sj=s;

float_adder f4(r1s,r1e,r1,r2[32],r2[31:24],r2[23:0],p10[32],p10[31:24],p10[23:0]);
float_multi f5(p10[32],p10[31:24],p10[23:0],1'b0,8'b01111111,24'b100000000000000000000000,p11[32],p11[31:24],p11[23:0]);
float_adder f6(p11[32],p11[31:24],p11[23:0],p13[32],p13[31:24],p13[23:0],p12[32],p12[31:24],p12[23:0]);

multiplexer2 m6(p9,p12,p14,sj);

dflipflop33 d30({s4s,s4e,s4},p14,clk,reset);
dflipflop33 d26(s3,{s4s,s4e,s4},clk,reset);
dflipflop33 d27(s2,s3,clk,reset);
dflipflop33 d28(s1,s2,clk,reset);
dflipflop33 d29(s0,s1,clk,reset);

endmodule

// D flip flop

module dflipflop(q,d,clk,reset);
output q;
input d,clk,reset;
reg q;
always@(posedge reset or negedge clk)
if(reset)
q<=1'b0;
else
q<=d;
endmodule

// D flip flop

module dflipflop8(q,d,clk,reset);
output [7:0] q;
input [7:0] d;
input clk,reset;
reg [7:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=8'b00000000;
else
q<=d;
endmodule

// D flip flop

module dflipflop24(q,d,clk,reset);
output [23:0] q;
input [23:0] d;
input clk,reset;
reg [23:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=24'b00000000;
else
q<=d;
endmodule

//mux3to1

module multiplexer3(in0,in1,in2,y,sel);

input [32:0] in0,in1,in2;
input [1:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or sel)
begin
case(sel)
2'b00:y=in0;  
2'b01:y=in1;
2'b10:y=in2;
default:y=33'bx;	 
endcase   
end

endmodule

//mux4to1

module multiplexer4(in0,in1,in2,in3,y,sel);

input [32:0] in0,in1,in2,in3;
input [1:0] sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or in2 or in3 or sel)
begin
case(sel)
2'b00:y=in0;  
2'b01:y=in1;
2'b10:y=in2;	
2'b11:y=in3;  
endcase   
end

endmodule

//mux2to1

module multiplexer2(in0,in1,y,sel);

input [32:0] in0,in1;
input sel;
output [32:0] y;

reg [32:0] y;
always@(in0 or in1 or sel)
begin
case(sel)
1'b0:y=in0;  
1'b1:y=in1;	 
endcase   
end

endmodule

//single precision floating point adder

/*`include "kgp.v"
`include "kgp_carry.v"
`include "recursive_stage1.v"
`include "recurse8.v"
`include "recurse.v"*/

module float_adder(nps3,npe3,np3,nps4,npe4,np4,is,ie,i);

input nps3,nps4;
input [7:0] npe3,npe4;
input [23:0] np3,np4;
output is;
output [7:0] ie;
output [23:0] i;

reg [7:0] s11,s22;
reg [23:0] oopnn,ooann;
reg [7:0] npee;

wire z11;
assign z11=nps3 ^ nps4;

always@(npe3 or npe4 or np3 or np4 or z11)
	begin
		if(npe3>npe4)
			begin
				s11=npe3-npe4;
				npee=npe3;
				s22=8'b000;
			end
		else if (npe3<npe4)
			begin
				s22=npe4-npe3;
				npee=npe4;
				s11=8'b00;
			end
		else if (z11==1'b1 && npe3==npe4 && np3==np4)
			begin
				npee=8'b00000000;
				s11=8'b00;
				s22=8'b00;
			end
		else if (npe3==npe4)
			begin
				npee=npe4;
				s11=8'b00;
				s22=8'b00;
			end		
	end

wire [23:0] ooo;
assign ooo=24'b000;	
wire [47:0] pp33,opp;

assign pp33[47:0]={np4[23:0],ooo[23:0]};

//barrel48 b211(opp,pp33,s11);	
assign opp=pp33>>s11;
wire i11;

wire [26:0] op11;
wire [23:0] op22;
assign i11= opp[21] | opp[20] | opp[19] | opp[18] | opp[17] | opp[16] | opp[15] | opp[14] | opp[13] | opp[12] | opp[11] | opp[10] | opp[9] | opp[8] | opp[7] | opp[6] | opp[5] | opp[4] | opp[3] | opp[2] | opp[1] | opp[0];
assign op11[26:0]={opp[47:22],i11};
assign op22[23:0]=op11[26:3];

wire [47:0] a11,oaa;

assign a11[47:0]={np3[23:0],ooo[23:0]};
//barrel48 b122(oaa,a11,s22); 
assign oaa=a11>>s22;

wire i22;

wire [26:0] oa11;
wire [23:0] oa22;
assign i22= oaa[21] | oaa[20] | oaa[19] | oaa[18] | oaa[17] | oaa[16] | oaa[15] | oaa[14] | oaa[13] | oaa[12] |oaa[11] | oaa[10] | oaa[9] | oaa[8] | oaa[7] | oaa[6] | oaa[5] | oaa[4] | oaa[3] | oaa[2] | oaa[1] | oaa[0];
assign oa11[26:0]={oaa[47:22],i22};
assign oa22[23:0]=oa11[26:3];

always@(op11 or op22)
	begin	
		if((op11[2]==1)&&(op11[1]==1))      //G=1,R=1,round up (add 1 to lsb)
			begin
				 oopnn=op22+1;			
			end
		else if(op11[2]==0)	//G=0 round down (no change)	
			begin
				 oopnn=op22;
			end
		else if((op11[2]==1) && (op11[1]==0) && (op11[0]==1))	//G=1,R=0,S=1,round up (add 1 to lsb)
			begin
				 oopnn=op22+1;
			end
		else if((op11[2]==1)&&(op11[1]==0)&&(op11[0]==0)&&(op11[3]==0)) //G=1,R=0,S=0,round to nearest even (leave it if lsb is 0)
			begin
				 oopnn=op22;
			end
		else if((op11[2]==1)&&(op11[1]==0)&&(op11[0]==0)&&(op11[3]==1)) //G=1,R=0,S=0,round to nearest even (add 1 to lsb if lsb is 1)
			begin
			 oopnn=op22+1;			
			end
	end
	
always@(oa11 or oa22)
	begin	
		if((oa11[2]==1)&&(oa11[1]==1))      //G=1,R=1,round up (add 1 to lsb)
			begin
				ooann=oa22+1;				
			end
		else if(oa11[2]==0)	//G=0, round down (no change)	
			begin
				 ooann=oa22;
			end
		else if((oa11[2]==1) && (oa11[1]==0) && (oa11[0]==1))	//G=1,R=0,S=1,round up (add 1 to lsb)
			begin
				 ooann=oa22+1;
			end
		else if((oa11[2]==1)&&(oa11[1]==0)&&(oa11[0]==0)&&(oa11[3]==0)) //G=1,R=0,S=0,round to nearest even (leave it if lsb is 0)
			begin
				 ooann=oa22;
			end
		else if((oa11[2]==1)&&(oa11[1]==0)&&(oa11[0]==0)&&(oa11[3]==1)) //G=1,R=0,S=0,round to nearest even (add 1 to lsb if lsb is 1)
			begin
				 ooann = oa22+1;				
			end
	end
//////////////////////	
	
wire [23:0] np2222,r11,r22;
assign np2222=(~oopnn)+1;
wire c11,c22;

///////////////////////////////////////////////////////////

wire c10,c20;
wire [31:0] r111,r222;

//cladder32 c1(r111,c10,{8'b0,ooann},{8'b0,np2222},1'b0);
//cladder32 c2(r222,c20,{8'b0,ooann},{8'b0,oopnn},1'b0);

recurse c1(r111,c10,{8'b0,ooann},{8'b0,np2222});
recurse c2(r222,c20,{8'b0,ooann},{8'b0,oopnn});

assign r11=r111[23:0];
assign r22=r222[23:0];
assign c11=r111[24];
assign c22=r222[24];

//assign {c11,r11[23:0]}={1'b0,ooann}+{1'b0,np2222};
//assign {c22,r22[23:0]}={1'b0,ooann}+{1'b0,oopnn};

/////////////////////////////////////////////////////////////

reg [23:0] pp11;
reg [7:0] pnee;
reg is;
always@(c11 or r11 or c22 or r22 or nps3 or np3 or np4 or nps4 or npe3 or npe4 or z11 or npee)
	begin
	
	 if (c22==1 && z11==0 && np3!=24'b000 && np4!=24'b000)
		begin
			is=nps3;
			pnee=npee+1;
			pp11={c22,r22[23:1]};
		end
	else if (c22==0 && z11==0 && np3!=24'b000 && np4!=24'b000)   
		begin
			is=nps3;
			pnee=npee;
			pp11=r22;
		end			
	 else if (c11==0 && z11==1 && np3!=24'b000 && np4!=24'b000)
		begin
//			is=1'b1;
			is=(~nps3);
			pnee=npee;
			pp11=(~r11)+1;
		end
	else if (c11==1 && z11==1 && np3!=24'b000 && np4!=24'b000)
		begin
//			is=1'b0;
			is=nps3;
			pnee=npee;
			pp11=r11;
		end
	else if (np3!=24'b0000 && np4==24'b000)
		begin
		   	is=nps3;
			pnee=npe3;
			pp11=np3;
		end
	else if (np4!=24'b0000 && np3==24'b000)
		begin
		   	is=nps4;
			pnee=npe4;
			pp11=np4;
		end	
	else if (np4==24'b0000 && np3==24'b000)
		begin
		   	is=1'b0;
			pnee=8'b00;
			pp11=24'b00;
		end		

	end

reg [4:0] sl11;
always @(pp11)				//normalization
begin 
	if(pp11[23]==1'b1)
		begin
			sl11=5'b00000;
		end
	else if(pp11[23:22]==2'b01)
		begin
			sl11=5'b00001;              	
		end
	else if(pp11[23:21]==3'b001)
		begin
			sl11=5'b00010;
		end
	else if(pp11[23:20]==4'b0001)
		begin
			sl11=5'b00011;
		end
	else if(pp11[23:19]==5'b00001)
		begin
			sl11=5'b00100;
		end
	else if(pp11[23:18]==6'b000001)
		begin
			sl11=5'b00101;
		end
	else if(pp11[23:17]==7'b0000001)
		begin
			sl11=5'b00110;
		end
	else if(pp11[23:16]==8'b00000001)
		begin
			sl11=5'b00111;
		end
	else if(pp11[23:15]==9'b000000001)
		begin
			sl11=5'b01000;
		end
	else if(pp11[23:14]==10'b0000000001)
		begin
			sl11=5'b01001;
		end
	else if(pp11[23:13]==11'b00000000001)
		begin
			sl11=5'b01010;
		end
	else if(pp11[23:12]==12'b000000000001)
		begin
			sl11=5'b01011;
		end
	else if(pp11[23:11]==13'b0000000000001)
		begin
			sl11=5'b01100;
		end
	else if(pp11[23:10]==14'b00000000000001)
		begin
			sl11=5'b01101;
		end
	else if(pp11[23:9]==15'b000000000000001)
		begin
			sl11=5'b01110;
		end
	else if(pp11[23:8]==16'b0000000000000001)
		begin
			sl11=5'b01111;
		end
	else if(pp11[23:7]==17'b00000000000000001)
		begin
			sl11=5'b10000;
		end
	else if(pp11[23:6]==18'b000000000000000001)
		begin
			sl11=5'b10001;
		end
	else if(pp11[23:5]==19'b0000000000000000001)
		begin
			sl11=5'b10010;
		end
	else if(pp11[23:4]==20'b00000000000000000001)
		begin
			sl11=5'b10011;
		end
	else if(pp11[23:3]==21'b000000000000000000001)
		begin
			sl11=5'b10100;
		end
	else if(pp11[23:2]==22'b0000000000000000000001)
		begin
			sl11=5'b10101;
		end
	else if(pp11[23:1]==23'b00000000000000000000001)
		begin
			sl11=5'b10110;
		end
	else if(pp11[23:0]==24'b000000000000000000000001)
		begin
			sl11=5'b10111;
		end
	else if(pp11[23:0]==24'b000000000000000000000000)
		begin
			sl11=5'b00000;
		end
end 
wire [23:0] ii,i;

wire [7:0] sl3,sl2,iie;
wire c7,c8;
assign sl2=~{3'b000,sl11}; 
recurse8 r801(sl3,c7,sl2,8'b00000001);
recurse8 r811(iie,c8,pnee,sl3);
reg [7:0] ie;

//barrel24 b111(ii,pp11,sl11);
assign ii=pp11<<sl11;

always@(iie or ii)
 begin
   if(ii==24'b00000)
	ie=8'b00000;
   else
	ie=iie;
 end

assign i=ii;

endmodule

//32 bit recursive doubling technique

module recurse(sum,carry,a,b); 

output [31:0] sum;
output  carry;
input [31:0] a,b;

wire [65:0] x;

assign x[1:0]=2'b00;  // kgp generation

//assign {x[3:2]}=(a[0]==b[0])?((a[0]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[5:4]}=(a[1]==b[1])?((a[1]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[7:6]}=(a[2]==b[2])?((a[2]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[9:8]}=(a[3]==b[3])?((a[3]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[11:10]}=(a[4]==b[4])?((a[4]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[13:12]}=(a[5]==b[5])?((a[5]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[15:14]}=(a[6]==b[6])?((a[6]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[17:16]}=(a[7]==b[7])?((a[7]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[19:18]}=(a[8]==b[8])?((a[8]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[21:20]}=(a[9]==b[9])?((a[9]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[23:22]}=(a[10]==b[10])?((a[10]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[25:24]}=(a[11]==b[11])?((a[11]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[27:26]}=(a[12]==b[12])?((a[12]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[29:28]}=(a[13]==b[13])?((a[13]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[31:30]}=(a[14]==b[14])?((a[14]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[33:32]}=(a[15]==b[15])?((a[15]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[35:34]}=(a[16]==b[16])?((a[16]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[37:36]}=(a[17]==b[17])?((a[17]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[39:38]}=(a[18]==b[18])?((a[18]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[41:40]}=(a[19]==b[19])?((a[19]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[43:42]}=(a[20]==b[20])?((a[20]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[45:44]}=(a[21]==b[21])?((a[21]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[47:46]}=(a[22]==b[22])?((a[22]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[49:48]}=(a[23]==b[23])?((a[23]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[51:50]}=(a[24]==b[24])?((a[24]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[53:52]}=(a[25]==b[25])?((a[25]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[55:54]}=(a[26]==b[26])?((a[26]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[57:56]}=(a[27]==b[27])?((a[27]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[59:58]}=(a[28]==b[28])?((a[28]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[61:60]}=(a[29]==b[29])?((a[29]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[63:62]}=(a[30]==b[30])?((a[30]==1'b1)?2'b11:2'b00):2'b01;
//assign {x[65:64]}=(a[31]==b[31])?((a[31]==1'b1)?2'b11:2'b00):2'b01;

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);

wire [63:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);

wire [63:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);

wire [63:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);

wire [63:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);

wire [63:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);

 // final sum and carry

assign sum[0]=a[0]^b[0]^x5[0];
assign sum[1]=a[1]^b[1]^x5[2];
assign sum[2]=a[2]^b[2]^x5[4];
assign sum[3]=a[3]^b[3]^x5[6];
assign sum[4]=a[4]^b[4]^x5[8];
assign sum[5]=a[5]^b[5]^x5[10];
assign sum[6]=a[6]^b[6]^x5[12];
assign sum[7]=a[7]^b[7]^x5[14];
assign sum[8]=a[8]^b[8]^x5[16];
assign sum[9]=a[9]^b[9]^x5[18];
assign sum[10]=a[10]^b[10]^x5[20];
assign sum[11]=a[11]^b[11]^x5[22];
assign sum[12]=a[12]^b[12]^x5[24];
assign sum[13]=a[13]^b[13]^x5[26];
assign sum[14]=a[14]^b[14]^x5[28];
assign sum[15]=a[15]^b[15]^x5[30];
assign sum[16]=a[16]^b[16]^x5[32];
assign sum[17]=a[17]^b[17]^x5[34];
assign sum[18]=a[18]^b[18]^x5[36];
assign sum[19]=a[19]^b[19]^x5[38];
assign sum[20]=a[20]^b[20]^x5[40];
assign sum[21]=a[21]^b[21]^x5[42];
assign sum[22]=a[22]^b[22]^x5[44];
assign sum[23]=a[23]^b[23]^x5[46];
assign sum[24]=a[24]^b[24]^x5[48];
assign sum[25]=a[25]^b[25]^x5[50];
assign sum[26]=a[26]^b[26]^x5[52];
assign sum[27]=a[27]^b[27]^x5[54];
assign sum[28]=a[28]^b[28]^x5[56];
assign sum[29]=a[29]^b[29]^x5[58];
assign sum[30]=a[30]^b[30]^x5[60];
assign sum[31]=a[31]^b[31]^x5[62];


kgp_carry kkc(x[65:64],x5[63:62],carry);

endmodule

//kgp

module kgp(a,b,y);

input a,b;
output [1:0] y;
//reg [1:0] y;

//always@(a or b)
//begin
//case({a,b})
//2'b00:y=2'b00;  //kill
//2'b11:y=2'b11;	  //generate
//2'b01:y=2'b01;	//propagate
//2'b10:y=2'b01;  //propagate
//endcase   //y[1]=ab  y[0]=a+b  
//end

assign y[0]=a | b;
assign y[1]=a & b;

endmodule


module kgp_carry(a,b,carry);

input [1:0] a,b;
output carry;
//reg carry;

//always@(a or b)
//begin
//case(a)
//2'b00:carry=1'b0;  
//2'b11:carry=1'b1;
//2'b01:carry=b[0];
//2'b10:carry=b[0];
//default:carry=1'bx;
//endcase
//end

wire carry;

wire f,g;
assign g=a[0] & a[1];
assign f=a[0] ^ a[1];

assign carry=g|(b[0] & f);

endmodule

module recursive_stage1(a,b,y);

input [1:0] a,b;
output [1:0] y;

wire [1:0] y;
wire b0;
not n1(b0,b[1]);
wire f,g0,g1;
and a1(f,b[0],b[1]);
and a2(g0,b0,b[0],a[0]);
and a3(g1,b0,b[0],a[1]);

or o1(y[0],f,g0);
or o2(y[1],f,g1);

//reg [1:0] y;
//always@(a or b)
//begin
//case(b)
//2'b00:y=2'b00;  
//2'b11:y=2'b11;
//2'b01:y=a;
//default:y=2'bx;
//endcase
//end

//always@(a or b)
//begin
//if(b==2'b00)
//	y=2'b00;  
//else if (b==2'b11)
//	y=2'b11;
//else if (b==2'b01)
//	y=a;
//end

//wire x;
//assign x=a[0] ^ b[0];
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[0]=b[0];  
//1'b1:y[0]=a[0]; 
//endcase
//end
//
//always@(a or b or x)
//begin
//case(x)
//1'b0:y[1]=b[1];  
//1'b1:y[1]=a[1];
//endcase
//end


//always@(a or b)
//begin
//if (b==2'b00)
//	y=2'b00; 
//else if (b==2'b11)	
//	y=2'b11;
//else if (b==2'b01 && a==2'b00)
//	y=2'b00;
//else if (b==2'b01 && a==2'b11)
//	y=2'b11;
//else if (b==2'b01 && a==2'b01)
//	y=2'b01;
//end

endmodule

//48 bit recursive doubling technique

//`include "kgp.v"
//`include "kgp_carry.v"
//`include "recursive_stage1.v"

module recurse8(sum,carry,a,b); 

output [7:0] sum;
output  carry;
input [7:0] a,b;

wire [17:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);

wire [15:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);

wire [15:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);

wire [15:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);

// final sum and carry

assign sum[0]=a[0]^b[0]^x3[0];
assign sum[1]=a[1]^b[1]^x3[2];
assign sum[2]=a[2]^b[2]^x3[4];
assign sum[3]=a[3]^b[3]^x3[6];
assign sum[4]=a[4]^b[4]^x3[8];
assign sum[5]=a[5]^b[5]^x3[10];
assign sum[6]=a[6]^b[6]^x3[12];
assign sum[7]=a[7]^b[7]^x3[14];

kgp_carry kkc(x[17:16],x3[15:14],carry);

endmodule

// radix2 Wallace tree based single precision floating point multiplier

module float_multi(as,ae,a,bs,be,b,ms,me,m);
input as,bs;
input [23:0] a,b;
input [7:0] ae,be;
output ms;
output [7:0] me;
output [23:0] m;

wire [47:0] r1;
wire [47:0] r;
wire [23:0] p0;
wire [23:0] p1;
wire [23:0] p2;
wire [23:0] p3;
wire [23:0] p4;
wire [23:0] p5;
wire [23:0] p6;
wire [23:0] p7;
wire [23:0] p8;
wire [23:0] p9;
wire [23:0] p10;
wire [23:0] p11;
wire [23:0] p12;
wire [23:0] p13;
wire [23:0] p14;
wire [23:0] p15;
wire [23:0] p16;
wire [23:0] p17;
wire [23:0] p18;
wire [23:0] p19;
wire [23:0] p20;
wire [23:0] p21;
wire [23:0] p22;
wire [23:0] p23;

wire [25:0] sum1;
wire [25:0] sum2;
wire [25:0] sum3;
wire [25:0] sum4;
wire [25:0] sum5;
wire [25:0] sum6;
wire [25:0] sum7;
wire [25:0] sum8;
wire [28:0] sum9;
wire [26:0] sum10;
wire [28:0] sum11;
wire [26:0] sum12;
wire [28:0] sum13;
wire [31:0] sum14;
wire [30:0] sum15;
wire [32:0] sum16;
wire [37:0] sum18;
wire [36:0] sum19;
wire [46:0] sum20;
wire [31:0] sum21;
wire [46:0] sum22;
wire [47:0] sum23;

wire [23:0] carry1;
wire [23:0] carry2;
wire [23:0] carry3;
wire [23:0] carry4;
wire [23:0] carry5;
wire [23:0] carry6;
wire [23:0] carry7;
wire [23:0] carry8;
wire [23:0] carry9;
wire [25:0] carry10;
wire [23:0] carry11;
wire [25:0] carry12;
wire [23:0] carry13;
wire [25:0] carry14;
wire [26:0] carry15;
wire [25:0] carry16;
wire [27:0] carry18;
wire [28:0] carry19;
wire [32:0] carry20;
wire [23:0] carry21;
wire [40:0] carry22;
wire [39:0] carry23;

wire c_in0,c_in1,c_in2,c_in3,c_in4,c_in5,c_in6,c_in7,c_in8,c_in9,carry_in;
assign carry_in=1'b0;

assign p0[23:0] = b[0] ? a[23:0] : 24'b000000000000000000000000;
assign p1[23:0] = b[1] ? a[23:0] : 24'b000000000000000000000000;
assign p2[23:0] = b[2] ? a[23:0] : 24'b000000000000000000000000;
assign p3[23:0] = b[3] ? a[23:0] : 24'b000000000000000000000000;    
assign p4[23:0] = b[4] ? a[23:0] : 24'b000000000000000000000000;
assign p5[23:0] = b[5] ? a[23:0] : 24'b000000000000000000000000;
assign p6[23:0] = b[6] ? a[23:0] : 24'b000000000000000000000000;
assign p7[23:0] = b[7] ? a[23:0] : 24'b000000000000000000000000;
assign p8[23:0] = b[8] ? a[23:0] : 24'b000000000000000000000000;
assign p9[23:0] = b[9] ? a[23:0] : 24'b000000000000000000000000;
assign p10[23:0] = b[10] ? a[23:0] : 24'b000000000000000000000000;
assign p11[23:0] = b[11] ? a[23:0] : 24'b000000000000000000000000;    
assign p12[23:0] = b[12] ? a[23:0] : 24'b000000000000000000000000;
assign p13[23:0] = b[13] ? a[23:0] : 24'b000000000000000000000000;
assign p14[23:0] = b[14] ? a[23:0] : 24'b000000000000000000000000;
assign p15[23:0] = b[15] ? a[23:0] : 24'b000000000000000000000000;
assign p16[23:0] = b[16] ? a[23:0] : 24'b000000000000000000000000;
assign p17[23:0] = b[17] ? a[23:0] : 24'b000000000000000000000000;
assign p18[23:0] = b[18] ? a[23:0] : 24'b000000000000000000000000;
assign p19[23:0] = b[19] ? a[23:0] : 24'b000000000000000000000000;    
assign p20[23:0] = b[20] ? a[23:0] : 24'b000000000000000000000000;
assign p21[23:0] = b[21] ? a[23:0] : 24'b000000000000000000000000;
assign p22[23:0] = b[22] ? a[23:0] : 24'b000000000000000000000000;
assign p23[23:0] = b[23] ? a[23:0] : 24'b000000000000000000000000;

//csa 1

assign sum1[0]=p0[0];
halfadd h11(sum1[1],carry1[0],p0[1],p1[0]);
fulladd f101(sum1[2],carry1[1],p0[2],p1[1],p2[0]);
fulladd f102(sum1[3],carry1[2],p0[3],p1[2],p2[1]);
fulladd f103(sum1[4],carry1[3],p0[4],p1[3],p2[2]);
fulladd f104(sum1[5],carry1[4],p0[5],p1[4],p2[3]);
fulladd f105(sum1[6],carry1[5],p0[6],p1[5],p2[4]);
fulladd f106(sum1[7],carry1[6],p0[7],p1[6],p2[5]);
fulladd f107(sum1[8],carry1[7],p0[8],p1[7],p2[6]);
fulladd f108(sum1[9],carry1[8],p0[9],p1[8],p2[7]);
fulladd f109(sum1[10],carry1[9],p0[10],p1[9],p2[8]);
fulladd f110(sum1[11],carry1[10],p0[11],p1[10],p2[9]);
fulladd f111(sum1[12],carry1[11],p0[12],p1[11],p2[10]);
fulladd f112(sum1[13],carry1[12],p0[13],p1[12],p2[11]);
fulladd f113(sum1[14],carry1[13],p0[14],p1[13],p2[12]);
fulladd f114(sum1[15],carry1[14],p0[15],p1[14],p2[13]);
fulladd f115(sum1[16],carry1[15],p0[16],p1[15],p2[14]);
fulladd f116(sum1[17],carry1[16],p0[17],p1[16],p2[15]);
fulladd f117(sum1[18],carry1[17],p0[18],p1[17],p2[16]);
fulladd f118(sum1[19],carry1[18],p0[19],p1[18],p2[17]);
fulladd f119(sum1[20],carry1[19],p0[20],p1[19],p2[18]);
fulladd f120(sum1[21],carry1[20],p0[21],p1[20],p2[19]);
fulladd f121(sum1[22],carry1[21],p0[22],p1[21],p2[20]);
fulladd f122(sum1[23],carry1[22],p0[23],p1[22],p2[21]);
halfadd h12(sum1[24],carry1[23],p1[23],p2[22]);
assign sum1[25]=p2[23];

//csa 2

assign sum2[0]=p3[0];
halfadd h21(sum2[1],carry2[0],p3[1],p4[0]);
fulladd f201(sum2[2],carry2[1],p3[2],p4[1],p5[0]);
fulladd f202(sum2[3],carry2[2],p3[3],p4[2],p5[1]);
fulladd f203(sum2[4],carry2[3],p3[4],p4[3],p5[2]);
fulladd f204(sum2[5],carry2[4],p3[5],p4[4],p5[3]);
fulladd f205(sum2[6],carry2[5],p3[6],p4[5],p5[4]);
fulladd f206(sum2[7],carry2[6],p3[7],p4[6],p5[5]);
fulladd f207(sum2[8],carry2[7],p3[8],p4[7],p5[6]);
fulladd f208(sum2[9],carry2[8],p3[9],p4[8],p5[7]);
fulladd f209(sum2[10],carry2[9],p3[10],p4[9],p5[8]);
fulladd f210(sum2[11],carry2[10],p3[11],p4[10],p5[9]);
fulladd f211(sum2[12],carry2[11],p3[12],p4[11],p5[10]);
fulladd f212(sum2[13],carry2[12],p3[13],p4[12],p5[11]);
fulladd f213(sum2[14],carry2[13],p3[14],p4[13],p5[12]);
fulladd f214(sum2[15],carry2[14],p3[15],p4[14],p5[13]);
fulladd f215(sum2[16],carry2[15],p3[16],p4[15],p5[14]);
fulladd f216(sum2[17],carry2[16],p3[17],p4[16],p5[15]);
fulladd f217(sum2[18],carry2[17],p3[18],p4[17],p5[16]);
fulladd f218(sum2[19],carry2[18],p3[19],p4[18],p5[17]);
fulladd f219(sum2[20],carry2[19],p3[20],p4[19],p5[18]);
fulladd f220(sum2[21],carry2[20],p3[21],p4[20],p5[19]);
fulladd f221(sum2[22],carry2[21],p3[22],p4[21],p5[20]);
fulladd f222(sum2[23],carry2[22],p3[23],p4[22],p5[21]);
halfadd h22(sum2[24],carry2[23],p4[23],p5[22]);
assign sum2[25]=p5[23];

//csa 3

assign sum3[0]=p6[0];
halfadd h31(sum3[1],carry3[0],p6[1],p7[0]);
fulladd f301(sum3[2],carry3[1],p6[2],p7[1],p8[0]);
fulladd f302(sum3[3],carry3[2],p6[3],p7[2],p8[1]);
fulladd f303(sum3[4],carry3[3],p6[4],p7[3],p8[2]);
fulladd f304(sum3[5],carry3[4],p6[5],p7[4],p8[3]);
fulladd f305(sum3[6],carry3[5],p6[6],p7[5],p8[4]);
fulladd f306(sum3[7],carry3[6],p6[7],p7[6],p8[5]);
fulladd f307(sum3[8],carry3[7],p6[8],p7[7],p8[6]);
fulladd f308(sum3[9],carry3[8],p6[9],p7[8],p8[7]);
fulladd f309(sum3[10],carry3[9],p6[10],p7[9],p8[8]);
fulladd f310(sum3[11],carry3[10],p6[11],p7[10],p8[9]);
fulladd f311(sum3[12],carry3[11],p6[12],p7[11],p8[10]);
fulladd f312(sum3[13],carry3[12],p6[13],p7[12],p8[11]);
fulladd f313(sum3[14],carry3[13],p6[14],p7[13],p8[12]);
fulladd f314(sum3[15],carry3[14],p6[15],p7[14],p8[13]);
fulladd f315(sum3[16],carry3[15],p6[16],p7[15],p8[14]);
fulladd f316(sum3[17],carry3[16],p6[17],p7[16],p8[15]);
fulladd f317(sum3[18],carry3[17],p6[18],p7[17],p8[16]);
fulladd f318(sum3[19],carry3[18],p6[19],p7[18],p8[17]);
fulladd f319(sum3[20],carry3[19],p6[20],p7[19],p8[18]);
fulladd f320(sum3[21],carry3[20],p6[21],p7[20],p8[19]);
fulladd f321(sum3[22],carry3[21],p6[22],p7[21],p8[20]);
fulladd f322(sum3[23],carry3[22],p6[23],p7[22],p8[21]);
halfadd h32(sum3[24],carry3[23],p7[23],p8[22]);
assign sum3[25]=p8[23];

//csa 4

assign sum4[0]=p9[0];
halfadd h41(sum4[1],carry4[0],p9[1],p10[0]);
fulladd f401(sum4[2],carry4[1],p9[2],p10[1],p11[0]);
fulladd f402(sum4[3],carry4[2],p9[3],p10[2],p11[1]);
fulladd f403(sum4[4],carry4[3],p9[4],p10[3],p11[2]);
fulladd f404(sum4[5],carry4[4],p9[5],p10[4],p11[3]);
fulladd f405(sum4[6],carry4[5],p9[6],p10[5],p11[4]);
fulladd f406(sum4[7],carry4[6],p9[7],p10[6],p11[5]);
fulladd f407(sum4[8],carry4[7],p9[8],p10[7],p11[6]);
fulladd f408(sum4[9],carry4[8],p9[9],p10[8],p11[7]);
fulladd f409(sum4[10],carry4[9],p9[10],p10[9],p11[8]);
fulladd f410(sum4[11],carry4[10],p9[11],p10[10],p11[9]);
fulladd f411(sum4[12],carry4[11],p9[12],p10[11],p11[10]);
fulladd f412(sum4[13],carry4[12],p9[13],p10[12],p11[11]);
fulladd f413(sum4[14],carry4[13],p9[14],p10[13],p11[12]);
fulladd f414(sum4[15],carry4[14],p9[15],p10[14],p11[13]);
fulladd f415(sum4[16],carry4[15],p9[16],p10[15],p11[14]);
fulladd f416(sum4[17],carry4[16],p9[17],p10[16],p11[15]);
fulladd f417(sum4[18],carry4[17],p9[18],p10[17],p11[16]);
fulladd f418(sum4[19],carry4[18],p9[19],p10[18],p11[17]);
fulladd f419(sum4[20],carry4[19],p9[20],p10[19],p11[18]);
fulladd f420(sum4[21],carry4[20],p9[21],p10[20],p11[19]);
fulladd f421(sum4[22],carry4[21],p9[22],p10[21],p11[20]);
fulladd f422(sum4[23],carry4[22],p9[23],p10[22],p11[21]);
halfadd h42(sum4[24],carry4[23],p10[23],p11[22]);
assign sum4[25]=p11[23];

//csa 5

assign sum5[0]=p12[0];
halfadd h51(sum5[1],carry5[0],p12[1],p13[0]);
fulladd f501(sum5[2],carry5[1],p12[2],p13[1],p14[0]);
fulladd f502(sum5[3],carry5[2],p12[3],p13[2],p14[1]);
fulladd f503(sum5[4],carry5[3],p12[4],p13[3],p14[2]);
fulladd f504(sum5[5],carry5[4],p12[5],p13[4],p14[3]);
fulladd f505(sum5[6],carry5[5],p12[6],p13[5],p14[4]);
fulladd f506(sum5[7],carry5[6],p12[7],p13[6],p14[5]);
fulladd f507(sum5[8],carry5[7],p12[8],p13[7],p14[6]);
fulladd f508(sum5[9],carry5[8],p12[9],p13[8],p14[7]);
fulladd f509(sum5[10],carry5[9],p12[10],p13[9],p14[8]);
fulladd f510(sum5[11],carry5[10],p12[11],p13[10],p14[9]);
fulladd f511(sum5[12],carry5[11],p12[12],p13[11],p14[10]);
fulladd f512(sum5[13],carry5[12],p12[13],p13[12],p14[11]);
fulladd f513(sum5[14],carry5[13],p12[14],p13[13],p14[12]);
fulladd f514(sum5[15],carry5[14],p12[15],p13[14],p14[13]);
fulladd f515(sum5[16],carry5[15],p12[16],p13[15],p14[14]);
fulladd f516(sum5[17],carry5[16],p12[17],p13[16],p14[15]);
fulladd f517(sum5[18],carry5[17],p12[18],p13[17],p14[16]);
fulladd f518(sum5[19],carry5[18],p12[19],p13[18],p14[17]);
fulladd f519(sum5[20],carry5[19],p12[20],p13[19],p14[18]);
fulladd f520(sum5[21],carry5[20],p12[21],p13[20],p14[19]);
fulladd f521(sum5[22],carry5[21],p12[22],p13[21],p14[20]);
fulladd f522(sum5[23],carry5[22],p12[23],p13[22],p14[21]);
halfadd h52(sum5[24],carry5[23],p13[23],p14[22]);
assign sum5[25]=p14[23];

//csa 6

assign sum6[0]=p15[0];
halfadd h61(sum6[1],carry6[0],p15[1],p16[0]);
fulladd f601(sum6[2],carry6[1],p15[2],p16[1],p17[0]);
fulladd f602(sum6[3],carry6[2],p15[3],p16[2],p17[1]);
fulladd f603(sum6[4],carry6[3],p15[4],p16[3],p17[2]);
fulladd f604(sum6[5],carry6[4],p15[5],p16[4],p17[3]);
fulladd f605(sum6[6],carry6[5],p15[6],p16[5],p17[4]);
fulladd f606(sum6[7],carry6[6],p15[7],p16[6],p17[5]);
fulladd f607(sum6[8],carry6[7],p15[8],p16[7],p17[6]);
fulladd f608(sum6[9],carry6[8],p15[9],p16[8],p17[7]);
fulladd f609(sum6[10],carry6[9],p15[10],p16[9],p17[8]);
fulladd f610(sum6[11],carry6[10],p15[11],p16[10],p17[9]);
fulladd f611(sum6[12],carry6[11],p15[12],p16[11],p17[10]);
fulladd f612(sum6[13],carry6[12],p15[13],p16[12],p17[11]);
fulladd f613(sum6[14],carry6[13],p15[14],p16[13],p17[12]);
fulladd f614(sum6[15],carry6[14],p15[15],p16[14],p17[13]);
fulladd f615(sum6[16],carry6[15],p15[16],p16[15],p17[14]);
fulladd f616(sum6[17],carry6[16],p15[17],p16[16],p17[15]);
fulladd f617(sum6[18],carry6[17],p15[18],p16[17],p17[16]);
fulladd f618(sum6[19],carry6[18],p15[19],p16[18],p17[17]);
fulladd f619(sum6[20],carry6[19],p15[20],p16[19],p17[18]);
fulladd f620(sum6[21],carry6[20],p15[21],p16[20],p17[19]);
fulladd f621(sum6[22],carry6[21],p15[22],p16[21],p17[20]);
fulladd f622(sum6[23],carry6[22],p15[23],p16[22],p17[21]);
halfadd h62(sum6[24],carry6[23],p16[23],p17[22]);
assign sum6[25]=p17[23];

//csa 7

assign sum7[0]=p18[0];
halfadd h71(sum7[1],carry7[0],p18[1],p19[0]);
fulladd f701(sum7[2],carry7[1],p18[2],p19[1],p20[0]);
fulladd f702(sum7[3],carry7[2],p18[3],p19[2],p20[1]);
fulladd f703(sum7[4],carry7[3],p18[4],p19[3],p20[2]);
fulladd f704(sum7[5],carry7[4],p18[5],p19[4],p20[3]);
fulladd f705(sum7[6],carry7[5],p18[6],p19[5],p20[4]);
fulladd f706(sum7[7],carry7[6],p18[7],p19[6],p20[5]);
fulladd f707(sum7[8],carry7[7],p18[8],p19[7],p20[6]);
fulladd f708(sum7[9],carry7[8],p18[9],p19[8],p20[7]);
fulladd f709(sum7[10],carry7[9],p18[10],p19[9],p20[8]);
fulladd f710(sum7[11],carry7[10],p18[11],p19[10],p20[9]);
fulladd f711(sum7[12],carry7[11],p18[12],p19[11],p20[10]);
fulladd f712(sum7[13],carry7[12],p18[13],p19[12],p20[11]);
fulladd f713(sum7[14],carry7[13],p18[14],p19[13],p20[12]);
fulladd f714(sum7[15],carry7[14],p18[15],p19[14],p20[13]);
fulladd f715(sum7[16],carry7[15],p18[16],p19[15],p20[14]);
fulladd f716(sum7[17],carry7[16],p18[17],p19[16],p20[15]);
fulladd f717(sum7[18],carry7[17],p18[18],p19[17],p20[16]);
fulladd f718(sum7[19],carry7[18],p18[19],p19[18],p20[17]);
fulladd f719(sum7[20],carry7[19],p18[20],p19[19],p20[18]);
fulladd f720(sum7[21],carry7[20],p18[21],p19[20],p20[19]);
fulladd f721(sum7[22],carry7[21],p18[22],p19[21],p20[20]);
fulladd f722(sum7[23],carry7[22],p18[23],p19[22],p20[21]);
halfadd h72(sum7[24],carry7[23],p19[23],p20[22]);
assign sum7[25]=p20[23];

//csa 8

assign sum8[0]=p21[0];
halfadd h81(sum8[1],carry8[0],p21[1],p22[0]);
fulladd f801(sum8[2],carry8[1],p21[2],p22[1],p23[0]);
fulladd f802(sum8[3],carry8[2],p21[3],p22[2],p23[1]);
fulladd f803(sum8[4],carry8[3],p21[4],p22[3],p23[2]);
fulladd f804(sum8[5],carry8[4],p21[5],p22[4],p23[3]);
fulladd f805(sum8[6],carry8[5],p21[6],p22[5],p23[4]);
fulladd f806(sum8[7],carry8[6],p21[7],p22[6],p23[5]);
fulladd f807(sum8[8],carry8[7],p21[8],p22[7],p23[6]);
fulladd f808(sum8[9],carry8[8],p21[9],p22[8],p23[7]);
fulladd f89(sum8[10],carry8[9],p21[10],p22[9],p23[8]);
fulladd f810(sum8[11],carry8[10],p21[11],p22[10],p23[9]);
fulladd f811(sum8[12],carry8[11],p21[12],p22[11],p23[10]);
fulladd f812(sum8[13],carry8[12],p21[13],p22[12],p23[11]);
fulladd f813(sum8[14],carry8[13],p21[14],p22[13],p23[12]);
fulladd f814(sum8[15],carry8[14],p21[15],p22[14],p23[13]);
fulladd f815(sum8[16],carry8[15],p21[16],p22[15],p23[14]);
fulladd f816(sum8[17],carry8[16],p21[17],p22[16],p23[15]);
fulladd f817(sum8[18],carry8[17],p21[18],p22[17],p23[16]);
fulladd f818(sum8[19],carry8[18],p21[19],p22[18],p23[17]);
fulladd f819(sum8[20],carry8[19],p21[20],p22[19],p23[18]);
fulladd f820(sum8[21],carry8[20],p21[21],p22[20],p23[19]);
fulladd f821(sum8[22],carry8[21],p21[22],p22[21],p23[20]);
fulladd f822(sum8[23],carry8[22],p21[23],p22[22],p23[21]);
halfadd h82(sum8[24],carry8[23],p22[23],p23[22]);
assign sum8[25]=p23[23];

//csa 9

assign sum9[1:0]=sum1[1:0];
halfadd h991(sum9[2],carry9[0],sum1[2],carry1[0]);
fulladd f901(sum9[3],carry9[1],sum1[3],carry1[1],sum2[0]);
fulladd f902(sum9[4],carry9[2],sum1[4],carry1[2],sum2[1]);
fulladd f903(sum9[5],carry9[3],sum1[5],carry1[3],sum2[2]);
fulladd f904(sum9[6],carry9[4],sum1[6],carry1[4],sum2[3]);
fulladd f905(sum9[7],carry9[5],sum1[7],carry1[5],sum2[4]);
fulladd f906(sum9[8],carry9[6],sum1[8],carry1[6],sum2[5]);
fulladd f907(sum9[9],carry9[7],sum1[9],carry1[7],sum2[6]);
fulladd f908(sum9[10],carry9[8],sum1[10],carry1[8],sum2[7]);
fulladd f909(sum9[11],carry9[9],sum1[11],carry1[9],sum2[8]);
fulladd f910(sum9[12],carry9[10],sum1[12],carry1[10],sum2[9]);
fulladd f911(sum9[13],carry9[11],sum1[13],carry1[11],sum2[10]);
fulladd f912(sum9[14],carry9[12],sum1[14],carry1[12],sum2[11]);
fulladd f913(sum9[15],carry9[13],sum1[15],carry1[13],sum2[12]);
fulladd f914(sum9[16],carry9[14],sum1[16],carry1[14],sum2[13]);
fulladd f915(sum9[17],carry9[15],sum1[17],carry1[15],sum2[14]);
fulladd f916(sum9[18],carry9[16],sum1[18],carry1[16],sum2[15]);
fulladd f917(sum9[19],carry9[17],sum1[19],carry1[17],sum2[16]);
fulladd f918(sum9[20],carry9[18],sum1[20],carry1[18],sum2[17]);
fulladd f919(sum9[21],carry9[19],sum1[21],carry1[19],sum2[18]);
fulladd f920(sum9[22],carry9[20],sum1[22],carry1[20],sum2[19]);
fulladd f921(sum9[23],carry9[21],sum1[23],carry1[21],sum2[20]);
fulladd f922(sum9[24],carry9[22],sum1[24],carry1[22],sum2[21]);
fulladd f923(sum9[25],carry9[23],sum1[25],carry1[23],sum2[22]);
assign sum9[28:26]=sum2[25:23];

//csa 10

assign sum10[0]=carry2[0];
halfadd h101(sum10[1],carry10[0],sum3[0],carry2[1]);
halfadd h102(sum10[2],carry10[1],sum3[1],carry2[2]);
fulladd f1001(sum10[3],carry10[2],sum3[2],carry2[3],carry3[0]);
fulladd f1002(sum10[4],carry10[3],sum3[3],carry2[4],carry3[1]);
fulladd f1003(sum10[5],carry10[4],sum3[4],carry2[5],carry3[2]);
fulladd f1004(sum10[6],carry10[5],sum3[5],carry2[6],carry3[3]);
fulladd f1005(sum10[7],carry10[6],sum3[6],carry2[7],carry3[4]);
fulladd f1006(sum10[8],carry10[7],sum3[7],carry2[8],carry3[5]);
fulladd f1007(sum10[9],carry10[8],sum3[8],carry2[9],carry3[6]);
fulladd f1008(sum10[10],carry10[9],sum3[9],carry2[10],carry3[7]);
fulladd f1009(sum10[11],carry10[10],sum3[10],carry2[11],carry3[8]);
fulladd f1010(sum10[12],carry10[11],sum3[11],carry2[12],carry3[9]);
fulladd f1011(sum10[13],carry10[12],sum3[12],carry2[13],carry3[10]);
fulladd f1012(sum10[14],carry10[13],sum3[13],carry2[14],carry3[11]);
fulladd f1013(sum10[15],carry10[14],sum3[14],carry2[15],carry3[12]);
fulladd f1014(sum10[16],carry10[15],sum3[15],carry2[16],carry3[13]);
fulladd f1015(sum10[17],carry10[16],sum3[16],carry2[17],carry3[14]);
fulladd f1016(sum10[18],carry10[17],sum3[17],carry2[18],carry3[15]);
fulladd f1017(sum10[19],carry10[18],sum3[18],carry2[19],carry3[16]);
fulladd f1018(sum10[20],carry10[19],sum3[19],carry2[20],carry3[17]);
fulladd f1019(sum10[21],carry10[20],sum3[20],carry2[21],carry3[18]);
fulladd f1020(sum10[22],carry10[21],sum3[21],carry2[22],carry3[19]);
fulladd f1021(sum10[23],carry10[22],sum3[22],carry2[23],carry3[20]);
halfadd h103(sum10[24],carry10[23],sum3[23],carry3[21]);
halfadd h104(sum10[25],carry10[24],sum3[24],carry3[22]);
halfadd h105(sum10[26],carry10[25],sum3[25],carry3[23]);

//csa 11

assign sum11[1:0]=sum4[1:0];
halfadd h111(sum11[2],carry11[0],sum4[2],carry4[0]);
fulladd f1101(sum11[3],carry11[1],sum4[3],carry4[1],sum5[0]);
fulladd f1102(sum11[4],carry11[2],sum4[4],carry4[2],sum5[1]);
fulladd f1103(sum11[5],carry11[3],sum4[5],carry4[3],sum5[2]);
fulladd f1104(sum11[6],carry11[4],sum4[6],carry4[4],sum5[3]);
fulladd f1105(sum11[7],carry11[5],sum4[7],carry4[5],sum5[4]);
fulladd f1106(sum11[8],carry11[6],sum4[8],carry4[6],sum5[5]);
fulladd f1107(sum11[9],carry11[7],sum4[9],carry4[7],sum5[6]);
fulladd f1108(sum11[10],carry11[8],sum4[10],carry4[8],sum5[7]);
fulladd f1109(sum11[11],carry11[9],sum4[11],carry4[9],sum5[8]);
fulladd f1110(sum11[12],carry11[10],sum4[12],carry4[10],sum5[9]);
fulladd f1111(sum11[13],carry11[11],sum4[13],carry4[11],sum5[10]);
fulladd f1112(sum11[14],carry11[12],sum4[14],carry4[12],sum5[11]);
fulladd f1113(sum11[15],carry11[13],sum4[15],carry4[13],sum5[12]);
fulladd f1114(sum11[16],carry11[14],sum4[16],carry4[14],sum5[13]);
fulladd f1115(sum11[17],carry11[15],sum4[17],carry4[15],sum5[14]);
fulladd f1116(sum11[18],carry11[16],sum4[18],carry4[16],sum5[15]);
fulladd f1117(sum11[19],carry11[17],sum4[19],carry4[17],sum5[16]);
fulladd f1118(sum11[20],carry11[18],sum4[20],carry4[18],sum5[17]);
fulladd f1119(sum11[21],carry11[19],sum4[21],carry4[19],sum5[18]);
fulladd f1120(sum11[22],carry11[20],sum4[22],carry4[20],sum5[19]);
fulladd f1121(sum11[23],carry11[21],sum4[23],carry4[21],sum5[20]);
fulladd f1122(sum11[24],carry11[22],sum4[24],carry4[22],sum5[21]);
fulladd f1123(sum11[25],carry11[23],sum4[25],carry4[23],sum5[22]);
assign sum11[28:26]=sum5[25:23];

//csa 12

assign sum12[0]=carry5[0];
halfadd h121(sum12[1],carry12[0],sum6[0],carry5[1]);
halfadd h122(sum12[2],carry12[1],sum6[1],carry5[2]);
fulladd f1201(sum12[3],carry12[2],sum6[2],carry5[3],carry6[0]);
fulladd f1202(sum12[4],carry12[3],sum6[3],carry5[4],carry6[1]);
fulladd f1203(sum12[5],carry12[4],sum6[4],carry5[5],carry6[2]);
fulladd f1204(sum12[6],carry12[5],sum6[5],carry5[6],carry6[3]);
fulladd f1205(sum12[7],carry12[6],sum6[6],carry5[7],carry6[4]);
fulladd f1206(sum12[8],carry12[7],sum6[7],carry5[8],carry6[5]);
fulladd f1207(sum12[9],carry12[8],sum6[8],carry5[9],carry6[6]);
fulladd f1208(sum12[10],carry12[9],sum6[9],carry5[10],carry6[7]);
fulladd f1209(sum12[11],carry12[10],sum6[10],carry5[11],carry6[8]);
fulladd f1210(sum12[12],carry12[11],sum6[11],carry5[12],carry6[9]);
fulladd f1211(sum12[13],carry12[12],sum6[12],carry5[13],carry6[10]);
fulladd f1212(sum12[14],carry12[13],sum6[13],carry5[14],carry6[11]);
fulladd f1213(sum12[15],carry12[14],sum6[14],carry5[15],carry6[12]);
fulladd f1214(sum12[16],carry12[15],sum6[15],carry5[16],carry6[13]);
fulladd f1215(sum12[17],carry12[16],sum6[16],carry5[17],carry6[14]);
fulladd f1216(sum12[18],carry12[17],sum6[17],carry5[18],carry6[15]);
fulladd f1217(sum12[19],carry12[18],sum6[18],carry5[19],carry6[16]);
fulladd f1218(sum12[20],carry12[19],sum6[19],carry5[20],carry6[17]);
fulladd f1219(sum12[21],carry12[20],sum6[20],carry5[21],carry6[18]);
fulladd f1220(sum12[22],carry12[21],sum6[21],carry5[22],carry6[19]);
fulladd f1221(sum12[23],carry12[22],sum6[22],carry5[23],carry6[20]);
halfadd h123(sum12[24],carry12[23],sum6[23],carry6[21]);
halfadd h124(sum12[25],carry12[24],sum6[24],carry6[22]);
halfadd h125(sum12[26],carry12[25],sum6[25],carry6[23]);

//csa 13

assign sum13[1:0]=sum7[1:0];
halfadd h131(sum13[2],carry13[0],sum7[2],carry7[0]);
fulladd f131(sum13[3],carry13[1],sum7[3],carry7[1],sum8[0]);
fulladd f1302(sum13[4],carry13[2],sum7[4],carry7[2],sum8[1]);
fulladd f1303(sum13[5],carry13[3],sum7[5],carry7[3],sum8[2]);
fulladd f1304(sum13[6],carry13[4],sum7[6],carry7[4],sum8[3]);
fulladd f1305(sum13[7],carry13[5],sum7[7],carry7[5],sum8[4]);
fulladd f1306(sum13[8],carry13[6],sum7[8],carry7[6],sum8[5]);
fulladd f1307(sum13[9],carry13[7],sum7[9],carry7[7],sum8[6]);
fulladd f1308(sum13[10],carry13[8],sum7[10],carry7[8],sum8[7]);
fulladd f1309(sum13[11],carry13[9],sum7[11],carry7[9],sum8[8]);
fulladd f1310(sum13[12],carry13[10],sum7[12],carry7[10],sum8[9]);
fulladd f1311(sum13[13],carry13[11],sum7[13],carry7[11],sum8[10]);
fulladd f1312(sum13[14],carry13[12],sum7[14],carry7[12],sum8[11]);
fulladd f1313(sum13[15],carry13[13],sum7[15],carry7[13],sum8[12]);
fulladd f1314(sum13[16],carry13[14],sum7[16],carry7[14],sum8[13]);
fulladd f1315(sum13[17],carry13[15],sum7[17],carry7[15],sum8[14]);
fulladd f1316(sum13[18],carry13[16],sum7[18],carry7[16],sum8[15]);
fulladd f1317(sum13[19],carry13[17],sum7[19],carry7[17],sum8[16]);
fulladd f1318(sum13[20],carry13[18],sum7[20],carry7[18],sum8[17]);
fulladd f1319(sum13[21],carry13[19],sum7[21],carry7[19],sum8[18]);
fulladd f1320(sum13[22],carry13[20],sum7[22],carry7[20],sum8[19]);
fulladd f1321(sum13[23],carry13[21],sum7[23],carry7[21],sum8[20]);
fulladd f1322(sum13[24],carry13[22],sum7[24],carry7[22],sum8[21]);
fulladd f1323(sum13[25],carry13[23],sum7[25],carry7[23],sum8[22]);
assign sum13[28:26]=sum8[25:23];

//csa 14

assign sum14[2:0]=sum9[2:0];
halfadd h141(sum14[3],carry14[0],sum9[3],carry9[0]);
halfadd h142(sum14[4],carry14[1],sum9[4],carry9[1]);
fulladd f1401(sum14[5],carry14[2],sum9[5],carry9[2],sum10[0]);
fulladd f1402(sum14[6],carry14[3],sum9[6],carry9[3],sum10[1]);
fulladd f1403(sum14[7],carry14[4],sum9[7],carry9[4],sum10[2]);
fulladd f1404(sum14[8],carry14[5],sum9[8],carry9[5],sum10[3]);
fulladd f1405(sum14[9],carry14[6],sum9[9],carry9[6],sum10[4]);
fulladd f1406(sum14[10],carry14[7],sum9[10],carry9[7],sum10[5]);
fulladd f1407(sum14[11],carry14[8],sum9[11],carry9[8],sum10[6]);
fulladd f1408(sum14[12],carry14[9],sum9[12],carry9[9],sum10[7]);
fulladd f1409(sum14[13],carry14[10],sum9[13],carry9[10],sum10[8]);
fulladd f1410(sum14[14],carry14[11],sum9[14],carry9[11],sum10[9]);
fulladd f1411(sum14[15],carry14[12],sum9[15],carry9[12],sum10[10]);
fulladd f1412(sum14[16],carry14[13],sum9[16],carry9[13],sum10[11]);
fulladd f1413(sum14[17],carry14[14],sum9[17],carry9[14],sum10[12]);
fulladd f1414(sum14[18],carry14[15],sum9[18],carry9[15],sum10[13]);
fulladd f1415(sum14[19],carry14[16],sum9[19],carry9[16],sum10[14]);
fulladd f1416(sum14[20],carry14[17],sum9[20],carry9[17],sum10[15]);
fulladd f1417(sum14[21],carry14[18],sum9[21],carry9[18],sum10[16]);
fulladd f1418(sum14[22],carry14[19],sum9[22],carry9[19],sum10[17]);
fulladd f1419(sum14[23],carry14[20],sum9[23],carry9[20],sum10[18]);
fulladd f1420(sum14[24],carry14[21],sum9[24],carry9[21],sum10[19]);
fulladd f1421(sum14[25],carry14[22],sum9[25],carry9[22],sum10[20]);
fulladd f1422(sum14[26],carry14[23],sum9[26],carry9[23],sum10[21]);
halfadd h143(sum14[27],carry14[24],sum9[27],sum10[22]);
halfadd h144(sum14[28],carry14[25],sum9[28],sum10[23]);
assign sum14[31:29]=sum10[26:24];

//csa 15

assign sum15[1:0]=carry10[1:0];
halfadd h151(sum15[2],carry15[0],carry10[2],sum11[0]);
halfadd h152(sum15[3],carry15[1],carry10[3],sum11[1]);
halfadd h153(sum15[4],carry15[2],carry10[4],sum11[2]);
fulladd f1501(sum15[5],carry15[3],carry10[5],sum11[3],carry11[0]);
fulladd f1502(sum15[6],carry15[4],carry10[6],sum11[4],carry11[1]);
fulladd f1503(sum15[7],carry15[5],carry10[7],sum11[5],carry11[2]);
fulladd f1504(sum15[8],carry15[6],carry10[8],sum11[6],carry11[3]);
fulladd f1505(sum15[9],carry15[7],carry10[9],sum11[7],carry11[4]);
fulladd f1506(sum15[10],carry15[8],carry10[10],sum11[8],carry11[5]);
fulladd f1507(sum15[11],carry15[9],carry10[11],sum11[9],carry11[6]);
fulladd f1508(sum15[12],carry15[10],carry10[12],sum11[10],carry11[7]);
fulladd f1509(sum15[13],carry15[11],carry10[13],sum11[11],carry11[8]);
fulladd f1510(sum15[14],carry15[12],carry10[14],sum11[12],carry11[9]);
fulladd f1511(sum15[15],carry15[13],carry10[15],sum11[13],carry11[10]);
fulladd f1512(sum15[16],carry15[14],carry10[16],sum11[14],carry11[11]);
fulladd f1513(sum15[17],carry15[15],carry10[17],sum11[15],carry11[12]);
fulladd f1514(sum15[18],carry15[16],carry10[18],sum11[16],carry11[13]);
fulladd f1515(sum15[19],carry15[17],carry10[19],sum11[17],carry11[14]);
fulladd f1516(sum15[20],carry15[18],carry10[20],sum11[18],carry11[15]);
fulladd f1517(sum15[21],carry15[19],carry10[21],sum11[19],carry11[16]);
fulladd f1518(sum15[22],carry15[20],carry10[22],sum11[20],carry11[17]);
fulladd f1519(sum15[23],carry15[21],carry10[23],sum11[21],carry11[18]);
fulladd f1520(sum15[24],carry15[22],carry10[24],sum11[22],carry11[19]);
fulladd f1521(sum15[25],carry15[23],carry10[25],sum11[23],carry11[20]);
halfadd h154(sum15[26],carry15[24],sum11[24],carry11[21]);
halfadd h155(sum15[27],carry15[25],sum11[25],carry11[22]);
halfadd h156(sum15[28],carry15[26],sum11[26],carry11[23]);
assign sum15[30:29]=sum11[28:27];

//csa 16

assign sum16[1:0]=sum12[1:0];
halfadd h161(sum16[2],carry16[0],sum12[2],carry12[0]);
halfadd h162(sum16[3],carry16[1],sum12[3],carry12[1]);
fulladd f1601(sum16[4],carry16[2],sum12[4],carry12[2],sum13[0]);
fulladd f1602(sum16[5],carry16[3],sum12[5],carry12[3],sum13[1]);
fulladd f1603(sum16[6],carry16[4],sum12[6],carry12[4],sum13[2]);
fulladd f1604(sum16[7],carry16[5],sum12[7],carry12[5],sum13[3]);
fulladd f1605(sum16[8],carry16[6],sum12[8],carry12[6],sum13[4]);
fulladd f1606(sum16[9],carry16[7],sum12[9],carry12[7],sum13[5]);
fulladd f1607(sum16[10],carry16[8],sum12[10],carry12[8],sum13[6]);
fulladd f1608(sum16[11],carry16[9],sum12[11],carry12[9],sum13[7]);
fulladd f1609(sum16[12],carry16[10],sum12[12],carry12[10],sum13[8]);
fulladd f1610(sum16[13],carry16[11],sum12[13],carry12[11],sum13[9]);
fulladd f1611(sum16[14],carry16[12],sum12[14],carry12[12],sum13[10]);
fulladd f1612(sum16[15],carry16[13],sum12[15],carry12[13],sum13[11]);
fulladd f1613(sum16[16],carry16[14],sum12[16],carry12[14],sum13[12]);
fulladd f1614(sum16[17],carry16[15],sum12[17],carry12[15],sum13[13]);
fulladd f1615(sum16[18],carry16[16],sum12[18],carry12[16],sum13[14]);
fulladd f1616(sum16[19],carry16[17],sum12[19],carry12[17],sum13[15]);
fulladd f1617(sum16[20],carry16[18],sum12[20],carry12[18],sum13[16]);
fulladd f1618(sum16[21],carry16[19],sum12[21],carry12[19],sum13[17]);
fulladd f1619(sum16[22],carry16[20],sum12[22],carry12[20],sum13[18]);
fulladd f1620(sum16[23],carry16[21],sum12[23],carry12[21],sum13[19]);
fulladd f1621(sum16[24],carry16[22],sum12[24],carry12[22],sum13[20]);
fulladd f1622(sum16[25],carry16[23],sum12[25],carry12[23],sum13[21]);
fulladd f1623(sum16[26],carry16[24],sum12[26],carry12[24],sum13[22]);
halfadd h163(sum16[27],carry16[25],carry12[25],sum13[23]);
assign sum16[32:28]=sum13[28:24];

//csa 18

assign sum18[3:0]=sum14[3:0];
halfadd h181(sum18[4],carry18[0],sum14[4],carry14[0]);
halfadd h182(sum18[5],carry18[1],sum14[5],carry14[1]);
halfadd h183(sum18[6],carry18[2],sum14[6],carry14[2]);
fulladd f1801(sum18[7],carry18[3],sum14[7],carry14[3],sum15[0]);
fulladd f1802(sum18[8],carry18[4],sum14[8],carry14[4],sum15[1]);
fulladd f1803(sum18[9],carry18[5],sum14[9],carry14[5],sum15[2]);
fulladd f1804(sum18[10],carry18[6],sum14[10],carry14[6],sum15[3]);
fulladd f1805(sum18[11],carry18[7],sum14[11],carry14[7],sum15[4]);
fulladd f1806(sum18[12],carry18[8],sum14[12],carry14[8],sum15[5]);
fulladd f1807(sum18[13],carry18[9],sum14[13],carry14[9],sum15[6]);
fulladd f1808(sum18[14],carry18[10],sum14[14],carry14[10],sum15[7]);
fulladd f1809(sum18[15],carry18[11],sum14[15],carry14[11],sum15[8]);
fulladd f1810(sum18[16],carry18[12],sum14[16],carry14[12],sum15[9]);
fulladd f1811(sum18[17],carry18[13],sum14[17],carry14[13],sum15[10]);
fulladd f1812(sum18[18],carry18[14],sum14[18],carry14[14],sum15[11]);
fulladd f1813(sum18[19],carry18[15],sum14[19],carry14[15],sum15[12]);
fulladd f1814(sum18[20],carry18[16],sum14[20],carry14[16],sum15[13]);
fulladd f1815(sum18[21],carry18[17],sum14[21],carry14[17],sum15[14]);
fulladd f1816(sum18[22],carry18[18],sum14[22],carry14[18],sum15[15]);
fulladd f1817(sum18[23],carry18[19],sum14[23],carry14[19],sum15[16]);
fulladd f1818(sum18[24],carry18[20],sum14[24],carry14[20],sum15[17]);
fulladd f1819(sum18[25],carry18[21],sum14[25],carry14[21],sum15[18]);
fulladd f1820(sum18[26],carry18[22],sum14[26],carry14[22],sum15[19]);
fulladd f1821(sum18[27],carry18[23],sum14[27],carry14[23],sum15[20]);
fulladd f1822(sum18[28],carry18[24],sum14[28],carry14[24],sum15[21]);
fulladd f1823(sum18[29],carry18[25],sum14[29],carry14[25],sum15[22]);
halfadd h184(sum18[30],carry18[26],sum14[30],sum15[23]);
halfadd h185(sum18[31],carry18[27],sum14[31],sum15[24]);
assign sum18[37:32]=sum15[30:25];

//csa 19

assign sum19[3:0]=carry15[3:0];
halfadd h191(sum19[4],carry19[0],carry15[4],sum16[0]);
halfadd h192(sum19[5],carry19[1],carry15[5],sum16[1]);
halfadd h193(sum19[6],carry19[2],carry15[6],sum16[2]);
fulladd f1901(sum19[7],carry19[3],carry15[7],sum16[3],carry16[0]);
fulladd f1902(sum19[8],carry19[4],carry15[8],sum16[4],carry16[1]);
fulladd f1903(sum19[9],carry19[5],carry15[9],sum16[5],carry16[2]);
fulladd f1904(sum19[10],carry19[6],carry15[10],sum16[6],carry16[3]);
fulladd f1905(sum19[11],carry19[7],carry15[11],sum16[7],carry16[4]);
fulladd f1906(sum19[12],carry19[8],carry15[12],sum16[8],carry16[5]);
fulladd f1907(sum19[13],carry19[9],carry15[13],sum16[9],carry16[6]);
fulladd f1908(sum19[14],carry19[10],carry15[14],sum16[10],carry16[7]);
fulladd f1909(sum19[15],carry19[11],carry15[15],sum16[11],carry16[8]);
fulladd f1910(sum19[16],carry19[12],carry15[16],sum16[12],carry16[9]);
fulladd f1911(sum19[17],carry19[13],carry15[17],sum16[13],carry16[10]);
fulladd f1912(sum19[18],carry19[14],carry15[18],sum16[14],carry16[11]);
fulladd f1913(sum19[19],carry19[15],carry15[19],sum16[15],carry16[12]);
fulladd f1914(sum19[20],carry19[16],carry15[20],sum16[16],carry16[13]);
fulladd f1915(sum19[21],carry19[17],carry15[21],sum16[17],carry16[14]);
fulladd f1916(sum19[22],carry19[18],carry15[22],sum16[18],carry16[15]);
fulladd f1917(sum19[23],carry19[19],carry15[23],sum16[19],carry16[16]);
fulladd f1918(sum19[24],carry19[20],carry15[24],sum16[20],carry16[17]);
fulladd f1919(sum19[25],carry19[21],carry15[25],sum16[21],carry16[18]);
fulladd f1920(sum19[26],carry19[22],carry15[26],sum16[22],carry16[19]);
halfadd h194(sum19[27],carry19[23],sum16[23],carry16[20]);
halfadd h195(sum19[28],carry19[24],sum16[24],carry16[21]);
halfadd h196(sum19[29],carry19[25],sum16[25],carry16[22]);
halfadd h197(sum19[30],carry19[26],sum16[26],carry16[23]);
halfadd h198(sum19[31],carry19[27],sum16[27],carry16[24]);
halfadd h199(sum19[32],carry19[28],sum16[28],carry16[25]);
assign sum19[36:33]=sum16[32:29];

//csa 20

assign sum20[4:0]=sum18[4:0];
halfadd h201(sum20[5],carry20[0],sum18[5],carry18[0]);
halfadd h202(sum20[6],carry20[1],sum18[6],carry18[1]);
halfadd h203(sum20[7],carry20[2],sum18[7],carry18[2]);
halfadd h204(sum20[8],carry20[3],sum18[8],carry18[3]);
halfadd h205(sum20[9],carry20[4],sum18[9],carry18[4]);
fulladd f2001(sum20[10],carry20[5],sum18[10],carry18[5],sum19[0]);
fulladd f2002(sum20[11],carry20[6],sum18[11],carry18[6],sum19[1]);
fulladd f2003(sum20[12],carry20[7],sum18[12],carry18[7],sum19[2]);
fulladd f2004(sum20[13],carry20[8],sum18[13],carry18[8],sum19[3]);
fulladd f2005(sum20[14],carry20[9],sum18[14],carry18[9],sum19[4]);
fulladd f2006(sum20[15],carry20[10],sum18[15],carry18[10],sum19[5]);
fulladd f2007(sum20[16],carry20[11],sum18[16],carry18[11],sum19[6]);
fulladd f2008(sum20[17],carry20[12],sum18[17],carry18[12],sum19[7]);
fulladd f2009(sum20[18],carry20[13],sum18[18],carry18[13],sum19[8]);
fulladd f2010(sum20[19],carry20[14],sum18[19],carry18[14],sum19[9]);
fulladd f2011(sum20[20],carry20[15],sum18[20],carry18[15],sum19[10]);
fulladd f2012(sum20[21],carry20[16],sum18[21],carry18[16],sum19[11]);
fulladd f2013(sum20[22],carry20[17],sum18[22],carry18[17],sum19[12]);
fulladd f2014(sum20[23],carry20[18],sum18[23],carry18[18],sum19[13]);
fulladd f2015(sum20[24],carry20[19],sum18[24],carry18[19],sum19[14]);
fulladd f2016(sum20[25],carry20[20],sum18[25],carry18[20],sum19[15]);
fulladd f2017(sum20[26],carry20[21],sum18[26],carry18[21],sum19[16]);
fulladd f2018(sum20[27],carry20[22],sum18[27],carry18[22],sum19[17]);
fulladd f2019(sum20[28],carry20[23],sum18[28],carry18[23],sum19[18]);
fulladd f2020(sum20[29],carry20[24],sum18[29],carry18[24],sum19[19]);
fulladd f2021(sum20[30],carry20[25],sum18[30],carry18[25],sum19[20]);
fulladd f2022(sum20[31],carry20[26],sum18[31],carry18[26],sum19[21]);
fulladd f2023(sum20[32],carry20[27],sum18[32],carry18[27],sum19[22]);
halfadd h2026(sum20[33],carry20[28],sum18[33],sum19[23]);
halfadd h207(sum20[34],carry20[29],sum18[34],sum19[24]);
halfadd h208(sum20[35],carry20[30],sum18[35],sum19[25]);
halfadd h209(sum20[36],carry20[31],sum18[36],sum19[26]);
halfadd h2010(sum20[37],carry20[32],sum18[37],sum19[27]);
assign sum20[46:38]=sum19[36:28];

//csa 21

assign sum21[5:0]=carry19[5:0];
halfadd h211(sum21[6],carry21[0],carry19[6],carry13[0]);
halfadd h212(sum21[7],carry21[1],carry19[7],carry13[1]);
fulladd f2101(sum21[8],carry21[2],carry19[8],carry13[2],carry8[0]);
fulladd f2102(sum21[9],carry21[3],carry19[9],carry13[3],carry8[1]);
fulladd f2103(sum21[10],carry21[4],carry19[10],carry13[4],carry8[2]);
fulladd f2104(sum21[11],carry21[5],carry19[11],carry13[5],carry8[3]);
fulladd f2105(sum21[12],carry21[6],carry19[12],carry13[6],carry8[4]);
fulladd f2106(sum21[13],carry21[7],carry19[13],carry13[7],carry8[5]);
fulladd f2107(sum21[14],carry21[8],carry19[14],carry13[8],carry8[6]);
fulladd f2108(sum21[15],carry21[9],carry19[15],carry13[9],carry8[7]);
fulladd f2109(sum21[16],carry21[10],carry19[16],carry13[10],carry8[8]);
fulladd f2110(sum21[17],carry21[11],carry19[17],carry13[11],carry8[9]);
fulladd f2111(sum21[18],carry21[12],carry19[18],carry13[12],carry8[10]);
fulladd f2112(sum21[19],carry21[13],carry19[19],carry13[13],carry8[11]);
fulladd f2113(sum21[20],carry21[14],carry19[20],carry13[14],carry8[12]);
fulladd f2114(sum21[21],carry21[15],carry19[21],carry13[15],carry8[13]);
fulladd f2115(sum21[22],carry21[16],carry19[22],carry13[16],carry8[14]);
fulladd f2116(sum21[23],carry21[17],carry19[23],carry13[17],carry8[15]);
fulladd f2117(sum21[24],carry21[18],carry19[24],carry13[18],carry8[16]);
fulladd f2118(sum21[25],carry21[19],carry19[25],carry13[19],carry8[17]);
fulladd f2119(sum21[26],carry21[20],carry19[26],carry13[20],carry8[18]);
fulladd f2120(sum21[27],carry21[21],carry19[27],carry13[21],carry8[19]);
fulladd f2121(sum21[28],carry21[22],carry19[28],carry13[22],carry8[20]);
halfadd h213(sum21[29],carry21[23],carry13[23],carry8[21]);
assign sum21[31:30] = carry8[23:22];


//csa 22

assign sum22[5:0]=sum20[5:0];
halfadd h221(sum22[6],carry22[0],sum20[6],carry20[0]);
halfadd h222(sum22[7],carry22[1],sum20[7],carry20[1]);
halfadd h223(sum22[8],carry22[2],sum20[8],carry20[2]);
halfadd h224(sum22[9],carry22[3],sum20[9],carry20[3]);
halfadd h225(sum22[10],carry22[4],sum20[10],carry20[4]);
halfadd h226(sum22[11],carry22[5],sum20[11],carry20[5]);
halfadd h227(sum22[12],carry22[6],sum20[12],carry20[6]);
halfadd h228(sum22[13],carry22[7],sum20[13],carry20[7]);
halfadd h229(sum22[14],carry22[8],sum20[14],carry20[8]);
fulladd f2201(sum22[15],carry22[9],sum20[15],carry20[9],sum21[0]);
fulladd f2202(sum22[16],carry22[10],sum20[16],carry20[10],sum21[1]);
fulladd f2203(sum22[17],carry22[11],sum20[17],carry20[11],sum21[2]);
fulladd f2204(sum22[18],carry22[12],sum20[18],carry20[12],sum21[3]);
fulladd f2205(sum22[19],carry22[13],sum20[19],carry20[13],sum21[4]);
fulladd f2206(sum22[20],carry22[14],sum20[20],carry20[14],sum21[5]);
fulladd f2207(sum22[21],carry22[15],sum20[21],carry20[15],sum21[6]);
fulladd f2208(sum22[22],carry22[16],sum20[22],carry20[16],sum21[7]);
fulladd f2209(sum22[23],carry22[17],sum20[23],carry20[17],sum21[8]);
fulladd f2210(sum22[24],carry22[18],sum20[24],carry20[18],sum21[9]);
fulladd f2211(sum22[25],carry22[19],sum20[25],carry20[19],sum21[10]);
fulladd f2212(sum22[26],carry22[20],sum20[26],carry20[20],sum21[11]);
fulladd f2213(sum22[27],carry22[21],sum20[27],carry20[21],sum21[12]);
fulladd f2214(sum22[28],carry22[22],sum20[28],carry20[22],sum21[13]);
fulladd f2215(sum22[29],carry22[23],sum20[29],carry20[23],sum21[14]);
fulladd f2216(sum22[30],carry22[24],sum20[30],carry20[24],sum21[15]);
fulladd f2217(sum22[31],carry22[25],sum20[31],carry20[25],sum21[16]);
fulladd f2218(sum22[32],carry22[26],sum20[32],carry20[26],sum21[17]);
fulladd f2219(sum22[33],carry22[27],sum20[33],carry20[27],sum21[18]);
fulladd f2220(sum22[34],carry22[28],sum20[34],carry20[28],sum21[19]);
fulladd f2221(sum22[35],carry22[29],sum20[35],carry20[29],sum21[20]);
fulladd f2222(sum22[36],carry22[30],sum20[36],carry20[30],sum21[21]);
fulladd f2223(sum22[37],carry22[31],sum20[37],carry20[31],sum21[22]);
fulladd f2224(sum22[38],carry22[32],sum20[38],carry20[32],sum21[23]);
halfadd h2210(sum22[39],carry22[33],sum20[39],sum21[24]);
halfadd h2211(sum22[40],carry22[34],sum20[40],sum21[25]);
halfadd h2212(sum22[41],carry22[35],sum20[41],sum21[26]);
halfadd h2213(sum22[42],carry22[36],sum20[42],sum21[27]);
halfadd h2214(sum22[43],carry22[37],sum20[43],sum21[28]);
halfadd h2215(sum22[44],carry22[38],sum20[44],sum21[29]);
halfadd h2216(sum22[45],carry22[39],sum20[45],sum21[30]);
halfadd h2217(sum22[46],carry22[40],sum20[46],sum21[31]);

//csa 23

assign sum23[6:0]=sum22[6:0];
halfadd h231(sum23[7],carry23[0],sum22[7],carry22[0]);
halfadd h232(sum23[8],carry23[1],sum22[8],carry22[1]);
halfadd h233(sum23[9],carry23[2],sum22[9],carry22[2]);
halfadd h234(sum23[10],carry23[3],sum22[10],carry22[3]);
halfadd h235(sum23[11],carry23[4],sum22[11],carry22[4]);
halfadd h236(sum23[12],carry23[5],sum22[12],carry22[5]);
halfadd h237(sum23[13],carry23[6],sum22[13],carry22[6]);
halfadd h238(sum23[14],carry23[7],sum22[14],carry22[7]);
halfadd h239(sum23[15],carry23[8],sum22[15],carry22[8]);
halfadd h2310(sum23[16],carry23[9],sum22[16],carry22[9]);
halfadd h2311(sum23[17],carry23[10],sum22[17],carry22[10]);
halfadd h2312(sum23[18],carry23[11],sum22[18],carry22[11]);
halfadd h2313(sum23[19],carry23[12],sum22[19],carry22[12]);
halfadd h2314(sum23[20],carry23[13],sum22[20],carry22[13]);
halfadd h2315(sum23[21],carry23[14],sum22[21],carry22[14]);
fulladd f2301(sum23[22],carry23[15],sum22[22],carry22[15],carry21[0]);
fulladd f2302(sum23[23],carry23[16],sum22[23],carry22[16],carry21[1]);
fulladd f2303(sum23[24],carry23[17],sum22[24],carry22[17],carry21[2]);
fulladd f2304(sum23[25],carry23[18],sum22[25],carry22[18],carry21[3]);
fulladd f2305(sum23[26],carry23[19],sum22[26],carry22[19],carry21[4]);
fulladd f2306(sum23[27],carry23[20],sum22[27],carry22[20],carry21[5]);
fulladd f2307(sum23[28],carry23[21],sum22[28],carry22[21],carry21[6]);
fulladd f2308(sum23[29],carry23[22],sum22[29],carry22[22],carry21[7]);
fulladd f2309(sum23[30],carry23[23],sum22[30],carry22[23],carry21[8]);
fulladd f2310(sum23[31],carry23[24],sum22[31],carry22[24],carry21[9]);
fulladd f2311(sum23[32],carry23[25],sum22[32],carry22[25],carry21[10]);
fulladd f2312(sum23[33],carry23[26],sum22[33],carry22[26],carry21[11]);
fulladd f2313(sum23[34],carry23[27],sum22[34],carry22[27],carry21[12]);
fulladd f2314(sum23[35],carry23[28],sum22[35],carry22[28],carry21[13]);
fulladd f2315(sum23[36],carry23[29],sum22[36],carry22[29],carry21[14]);
fulladd f2316(sum23[37],carry23[30],sum22[37],carry22[30],carry21[15]);
fulladd f2317(sum23[38],carry23[31],sum22[38],carry22[31],carry21[16]);
fulladd f2318(sum23[39],carry23[32],sum22[39],carry22[32],carry21[17]);
fulladd f2319(sum23[40],carry23[33],sum22[40],carry22[33],carry21[18]);
fulladd f2320(sum23[41],carry23[34],sum22[41],carry22[34],carry21[19]);
fulladd f2321(sum23[42],carry23[35],sum22[42],carry22[35],carry21[20]);
fulladd f2322(sum23[43],carry23[36],sum22[43],carry22[36],carry21[21]);
fulladd f2323(sum23[44],carry23[37],sum22[44],carry22[37],carry21[22]);
fulladd f2324(sum23[45],carry23[38],sum22[45],carry22[38],carry21[23]);
halfadd h2316(sum23[46],carry23[39],sum22[46],carry22[39]);
assign sum23[47]  = carry22[40];

//cla 

assign r1[7:0]=sum23[7:0];
//cladder40 ckck40(sum23[47:8],carry23[39:0],r1[47:8],c_in9);
recurse40 ckck40(r1[47:8],c_in19,sum23[47:8],carry23[39:0]);

wire ms1;

assign ms1=as^bs;

wire [7:0] exp,exp1,exp2,exp3;
wire cr1,cr2,cr3,cr4;

recurse8 r81(exp,cr1,ae,8'b10000001);
recurse8 r82(exp1,cr2,exp,be);
recurse8 r83(exp2,cr3,ae,8'b10000010);
recurse8 r84(exp3,cr4,exp2,be);

reg [7:0] me;
reg [23:0] m;
reg ms;

always@(exp1 or exp3 or r1 or a or b or ms1)
	begin
		if(r1[47]==1'b1 && a!=24'b000 && b!=24'b0000)
			begin
				m[23:0]=r1[47:24];
				me[7:0]=exp3;
				ms=ms1;
			end
		else if(r1[47]==1'b0 && a!=24'b000 && b!=24'b0000)
			begin
				m[23:0]=r1[46:23];
				me[7:0]=exp1;
				ms=ms1;
			end
		else if (a==24'b0000 || b==24'b00000)
			begin
			   m[23:0]=24'b000;
			   me[7:0]=8'b0000;
			   ms=1'b0;
		   end
	end

endmodule

// Full Adder Module
module fulladd(sum, carry, x,y,z);

output sum,carry;
input x,y,z;

wire w;	
	assign 	 w = x ^ y;
        assign	 sum = w ^ z;
	assign 	 carry = (x & y)|(w & z);
endmodule


// half Adder Module
module halfadd(sum, carry, x,y);

output sum,carry;
input x,y;

	assign	 sum = x ^ y;
	assign 	 carry = x & y;
	
endmodule

//40 bit recursive doubling technique

//`include "kgp.v"
//`include "recursive_stage1.v"

module recurse40(sum,carry,a,b); 

output [39:0] sum;
output  carry;
input [39:0] a,b;

wire [81:0] x;

assign x[1:0]=2'b00;  // kgp generation

kgp a00(a[0],b[0],x[3:2]);
kgp a01(a[1],b[1],x[5:4]);
kgp a02(a[2],b[2],x[7:6]);
kgp a03(a[3],b[3],x[9:8]);
kgp a04(a[4],b[4],x[11:10]);
kgp a05(a[5],b[5],x[13:12]);
kgp a06(a[6],b[6],x[15:14]);
kgp a07(a[7],b[7],x[17:16]);
kgp a08(a[8],b[8],x[19:18]);
kgp a09(a[9],b[9],x[21:20]);
kgp a10(a[10],b[10],x[23:22]);
kgp a11(a[11],b[11],x[25:24]);
kgp a12(a[12],b[12],x[27:26]);
kgp a13(a[13],b[13],x[29:28]);
kgp a14(a[14],b[14],x[31:30]);
kgp a15(a[15],b[15],x[33:32]);
kgp a16(a[16],b[16],x[35:34]);
kgp a17(a[17],b[17],x[37:36]);
kgp a18(a[18],b[18],x[39:38]);
kgp a19(a[19],b[19],x[41:40]);
kgp a20(a[20],b[20],x[43:42]);
kgp a21(a[21],b[21],x[45:44]);
kgp a22(a[22],b[22],x[47:46]);
kgp a23(a[23],b[23],x[49:48]);
kgp a24(a[24],b[24],x[51:50]);
kgp a25(a[25],b[25],x[53:52]);
kgp a26(a[26],b[26],x[55:54]);
kgp a27(a[27],b[27],x[57:56]);
kgp a28(a[28],b[28],x[59:58]);
kgp a29(a[29],b[29],x[61:60]);
kgp a30(a[30],b[30],x[63:62]);
kgp a31(a[31],b[31],x[65:64]);
kgp a32(a[32],b[32],x[67:66]);
kgp a33(a[33],b[33],x[69:68]);
kgp a34(a[34],b[34],x[71:70]);
kgp a35(a[35],b[35],x[73:72]);
kgp a36(a[36],b[36],x[75:74]);
kgp a37(a[37],b[37],x[77:76]);
kgp a38(a[38],b[38],x[79:78]);
kgp a39(a[39],b[39],x[81:80]);

wire [81:0] x1;  //recursive doubling stage 1
assign x1[1:0]=x[1:0];

recursive_stage1 s00(x[1:0],x[3:2],x1[3:2]);
recursive_stage1 s01(x[3:2],x[5:4],x1[5:4]);
recursive_stage1 s02(x[5:4],x[7:6],x1[7:6]);
recursive_stage1 s03(x[7:6],x[9:8],x1[9:8]);
recursive_stage1 s04(x[9:8],x[11:10],x1[11:10]);
recursive_stage1 s05(x[11:10],x[13:12],x1[13:12]);
recursive_stage1 s06(x[13:12],x[15:14],x1[15:14]);
recursive_stage1 s07(x[15:14],x[17:16],x1[17:16]);
recursive_stage1 s08(x[17:16],x[19:18],x1[19:18]);
recursive_stage1 s09(x[19:18],x[21:20],x1[21:20]);
recursive_stage1 s10(x[21:20],x[23:22],x1[23:22]);
recursive_stage1 s11(x[23:22],x[25:24],x1[25:24]);
recursive_stage1 s12(x[25:24],x[27:26],x1[27:26]);
recursive_stage1 s13(x[27:26],x[29:28],x1[29:28]);
recursive_stage1 s14(x[29:28],x[31:30],x1[31:30]);
recursive_stage1 s15(x[31:30],x[33:32],x1[33:32]);
recursive_stage1 s16(x[33:32],x[35:34],x1[35:34]);
recursive_stage1 s17(x[35:34],x[37:36],x1[37:36]);
recursive_stage1 s18(x[37:36],x[39:38],x1[39:38]);
recursive_stage1 s19(x[39:38],x[41:40],x1[41:40]);
recursive_stage1 s20(x[41:40],x[43:42],x1[43:42]);
recursive_stage1 s21(x[43:42],x[45:44],x1[45:44]);
recursive_stage1 s22(x[45:44],x[47:46],x1[47:46]);
recursive_stage1 s23(x[47:46],x[49:48],x1[49:48]);
recursive_stage1 s24(x[49:48],x[51:50],x1[51:50]);
recursive_stage1 s25(x[51:50],x[53:52],x1[53:52]);
recursive_stage1 s26(x[53:52],x[55:54],x1[55:54]);
recursive_stage1 s27(x[55:54],x[57:56],x1[57:56]);
recursive_stage1 s28(x[57:56],x[59:58],x1[59:58]);
recursive_stage1 s29(x[59:58],x[61:60],x1[61:60]);
recursive_stage1 s30(x[61:60],x[63:62],x1[63:62]);
recursive_stage1 s31(x[63:62],x[65:64],x1[65:64]);
recursive_stage1 s32(x[65:64],x[67:66],x1[67:66]);
recursive_stage1 s33(x[67:66],x[69:68],x1[69:68]);
recursive_stage1 s34(x[69:68],x[71:70],x1[71:70]);
recursive_stage1 s35(x[71:70],x[73:72],x1[73:72]);
recursive_stage1 s36(x[73:72],x[75:74],x1[75:74]);
recursive_stage1 s37(x[75:74],x[77:76],x1[77:76]);
recursive_stage1 s38(x[77:76],x[79:78],x1[79:78]);
recursive_stage1 s39(x[79:78],x[81:80],x1[81:80]);

wire [81:0] x2;  //recursive doubling stage2
assign x2[3:0]=x1[3:0];

recursive_stage1 s101(x1[1:0],x1[5:4],x2[5:4]);
recursive_stage1 s102(x1[3:2],x1[7:6],x2[7:6]);
recursive_stage1 s103(x1[5:4],x1[9:8],x2[9:8]);
recursive_stage1 s104(x1[7:6],x1[11:10],x2[11:10]);
recursive_stage1 s105(x1[9:8],x1[13:12],x2[13:12]);
recursive_stage1 s106(x1[11:10],x1[15:14],x2[15:14]);
recursive_stage1 s107(x1[13:12],x1[17:16],x2[17:16]);
recursive_stage1 s108(x1[15:14],x1[19:18],x2[19:18]);
recursive_stage1 s109(x1[17:16],x1[21:20],x2[21:20]);
recursive_stage1 s110(x1[19:18],x1[23:22],x2[23:22]);
recursive_stage1 s111(x1[21:20],x1[25:24],x2[25:24]);
recursive_stage1 s112(x1[23:22],x1[27:26],x2[27:26]);
recursive_stage1 s113(x1[25:24],x1[29:28],x2[29:28]);
recursive_stage1 s114(x1[27:26],x1[31:30],x2[31:30]);
recursive_stage1 s115(x1[29:28],x1[33:32],x2[33:32]);
recursive_stage1 s116(x1[31:30],x1[35:34],x2[35:34]);
recursive_stage1 s117(x1[33:32],x1[37:36],x2[37:36]);
recursive_stage1 s118(x1[35:34],x1[39:38],x2[39:38]);
recursive_stage1 s119(x1[37:36],x1[41:40],x2[41:40]);
recursive_stage1 s120(x1[39:38],x1[43:42],x2[43:42]);
recursive_stage1 s121(x1[41:40],x1[45:44],x2[45:44]);
recursive_stage1 s122(x1[43:42],x1[47:46],x2[47:46]);
recursive_stage1 s123(x1[45:44],x1[49:48],x2[49:48]);
recursive_stage1 s124(x1[47:46],x1[51:50],x2[51:50]);
recursive_stage1 s125(x1[49:48],x1[53:52],x2[53:52]);
recursive_stage1 s126(x1[51:50],x1[55:54],x2[55:54]);
recursive_stage1 s127(x1[53:52],x1[57:56],x2[57:56]);
recursive_stage1 s128(x1[55:54],x1[59:58],x2[59:58]);
recursive_stage1 s129(x1[57:56],x1[61:60],x2[61:60]);
recursive_stage1 s130(x1[59:58],x1[63:62],x2[63:62]);
recursive_stage1 s131(x1[61:60],x1[65:64],x2[65:64]);
recursive_stage1 s132(x1[63:62],x1[67:66],x2[67:66]);
recursive_stage1 s133(x1[65:64],x1[69:68],x2[69:68]);
recursive_stage1 s134(x1[67:66],x1[71:70],x2[71:70]);
recursive_stage1 s135(x1[69:68],x1[73:72],x2[73:72]);
recursive_stage1 s136(x1[71:70],x1[75:74],x2[75:74]);
recursive_stage1 s137(x1[73:72],x1[77:76],x2[77:76]);
recursive_stage1 s138(x1[75:74],x1[79:78],x2[79:78]);
recursive_stage1 s139(x1[77:76],x1[81:80],x2[81:80]);

wire [81:0] x3;  //recursive doubling stage3
assign x3[7:0]=x2[7:0];

recursive_stage1 s203(x2[1:0],x2[9:8],x3[9:8]);
recursive_stage1 s204(x2[3:2],x2[11:10],x3[11:10]);
recursive_stage1 s205(x2[5:4],x2[13:12],x3[13:12]);
recursive_stage1 s206(x2[7:6],x2[15:14],x3[15:14]);
recursive_stage1 s207(x2[9:8],x2[17:16],x3[17:16]);
recursive_stage1 s208(x2[11:10],x2[19:18],x3[19:18]);
recursive_stage1 s209(x2[13:12],x2[21:20],x3[21:20]);
recursive_stage1 s210(x2[15:14],x2[23:22],x3[23:22]);
recursive_stage1 s211(x2[17:16],x2[25:24],x3[25:24]);
recursive_stage1 s212(x2[19:18],x2[27:26],x3[27:26]);
recursive_stage1 s213(x2[21:20],x2[29:28],x3[29:28]);
recursive_stage1 s214(x2[23:22],x2[31:30],x3[31:30]);
recursive_stage1 s215(x2[25:24],x2[33:32],x3[33:32]);
recursive_stage1 s216(x2[27:26],x2[35:34],x3[35:34]);
recursive_stage1 s217(x2[29:28],x2[37:36],x3[37:36]);
recursive_stage1 s218(x2[31:30],x2[39:38],x3[39:38]);
recursive_stage1 s219(x2[33:32],x2[41:40],x3[41:40]);
recursive_stage1 s220(x2[35:34],x2[43:42],x3[43:42]);
recursive_stage1 s221(x2[37:36],x2[45:44],x3[45:44]);
recursive_stage1 s222(x2[39:38],x2[47:46],x3[47:46]);
recursive_stage1 s223(x2[41:40],x2[49:48],x3[49:48]);
recursive_stage1 s224(x2[43:42],x2[51:50],x3[51:50]);
recursive_stage1 s225(x2[45:44],x2[53:52],x3[53:52]);
recursive_stage1 s226(x2[47:46],x2[55:54],x3[55:54]);
recursive_stage1 s227(x2[49:48],x2[57:56],x3[57:56]);
recursive_stage1 s228(x2[51:50],x2[59:58],x3[59:58]);
recursive_stage1 s229(x2[53:52],x2[61:60],x3[61:60]);
recursive_stage1 s230(x2[55:54],x2[63:62],x3[63:62]);
recursive_stage1 s231(x2[57:56],x2[65:64],x3[65:64]);
recursive_stage1 s232(x2[59:58],x2[67:66],x3[67:66]);
recursive_stage1 s233(x2[61:60],x2[69:68],x3[69:68]);
recursive_stage1 s234(x2[63:62],x2[71:70],x3[71:70]);
recursive_stage1 s235(x2[65:64],x2[73:72],x3[73:72]);
recursive_stage1 s236(x2[67:66],x2[75:74],x3[75:74]);
recursive_stage1 s237(x2[69:68],x2[77:76],x3[77:76]);
recursive_stage1 s238(x2[71:70],x2[79:78],x3[79:78]);
recursive_stage1 s239(x2[73:72],x2[81:80],x3[81:80]);

wire [81:0] x4;  //recursive doubling stage 4
assign x4[15:0]=x3[15:0];

recursive_stage1 s307(x3[1:0],x3[17:16],x4[17:16]);
recursive_stage1 s308(x3[3:2],x3[19:18],x4[19:18]);
recursive_stage1 s309(x3[5:4],x3[21:20],x4[21:20]);
recursive_stage1 s310(x3[7:6],x3[23:22],x4[23:22]);
recursive_stage1 s311(x3[9:8],x3[25:24],x4[25:24]);
recursive_stage1 s312(x3[11:10],x3[27:26],x4[27:26]);
recursive_stage1 s313(x3[13:12],x3[29:28],x4[29:28]);
recursive_stage1 s314(x3[15:14],x3[31:30],x4[31:30]);
recursive_stage1 s315(x3[17:16],x3[33:32],x4[33:32]);
recursive_stage1 s316(x3[19:18],x3[35:34],x4[35:34]);
recursive_stage1 s317(x3[21:20],x3[37:36],x4[37:36]);
recursive_stage1 s318(x3[23:22],x3[39:38],x4[39:38]);
recursive_stage1 s319(x3[25:24],x3[41:40],x4[41:40]);
recursive_stage1 s320(x3[27:26],x3[43:42],x4[43:42]);
recursive_stage1 s321(x3[29:28],x3[45:44],x4[45:44]);
recursive_stage1 s322(x3[31:30],x3[47:46],x4[47:46]);
recursive_stage1 s323(x3[33:32],x3[49:48],x4[49:48]);
recursive_stage1 s324(x3[35:34],x3[51:50],x4[51:50]);
recursive_stage1 s325(x3[37:36],x3[53:52],x4[53:52]);
recursive_stage1 s326(x3[39:38],x3[55:54],x4[55:54]);
recursive_stage1 s327(x3[41:40],x3[57:56],x4[57:56]);
recursive_stage1 s328(x3[43:42],x3[59:58],x4[59:58]);
recursive_stage1 s329(x3[45:44],x3[61:60],x4[61:60]);
recursive_stage1 s330(x3[47:46],x3[63:62],x4[63:62]);
recursive_stage1 s331(x3[49:48],x3[65:64],x4[65:64]);
recursive_stage1 s332(x3[51:50],x3[67:66],x4[67:66]);
recursive_stage1 s333(x3[53:52],x3[69:68],x4[69:68]);
recursive_stage1 s334(x3[55:54],x3[71:70],x4[71:70]);
recursive_stage1 s335(x3[57:56],x3[73:72],x4[73:72]);
recursive_stage1 s336(x3[59:58],x3[75:74],x4[75:74]);
recursive_stage1 s337(x3[61:60],x3[77:76],x4[77:76]);
recursive_stage1 s338(x3[63:62],x3[79:78],x4[79:78]);
recursive_stage1 s339(x3[65:64],x3[81:80],x4[81:80]);

wire [81:0] x5;  //recursive doubling stage 5
assign x5[31:0]=x4[31:0];

recursive_stage1 s415(x4[1:0],x4[33:32],x5[33:32]);
recursive_stage1 s416(x4[3:2],x4[35:34],x5[35:34]);
recursive_stage1 s417(x4[5:4],x4[37:36],x5[37:36]);
recursive_stage1 s418(x4[7:6],x4[39:38],x5[39:38]);
recursive_stage1 s419(x4[9:8],x4[41:40],x5[41:40]);
recursive_stage1 s420(x4[11:10],x4[43:42],x5[43:42]);
recursive_stage1 s421(x4[13:12],x4[45:44],x5[45:44]);
recursive_stage1 s422(x4[15:14],x4[47:46],x5[47:46]);
recursive_stage1 s423(x4[17:16],x4[49:48],x5[49:48]);
recursive_stage1 s424(x4[19:18],x4[51:50],x5[51:50]);
recursive_stage1 s425(x4[21:20],x4[53:52],x5[53:52]);
recursive_stage1 s426(x4[23:22],x4[55:54],x5[55:54]);
recursive_stage1 s427(x4[25:24],x4[57:56],x5[57:56]);
recursive_stage1 s428(x4[27:26],x4[59:58],x5[59:58]);
recursive_stage1 s429(x4[29:28],x4[61:60],x5[61:60]);
recursive_stage1 s430(x4[31:30],x4[63:62],x5[63:62]);
recursive_stage1 s431(x4[33:32],x4[65:64],x5[65:64]);
recursive_stage1 s432(x4[35:34],x4[67:66],x5[67:66]);
recursive_stage1 s433(x4[37:36],x4[69:68],x5[69:68]);
recursive_stage1 s434(x4[39:38],x4[71:70],x5[71:70]);
recursive_stage1 s435(x4[41:40],x4[73:72],x5[73:72]);
recursive_stage1 s436(x4[43:42],x4[75:74],x5[75:74]);
recursive_stage1 s437(x4[45:44],x4[77:76],x5[77:76]);
recursive_stage1 s438(x4[47:46],x4[79:78],x5[79:78]);
recursive_stage1 s439(x4[49:48],x4[81:80],x5[81:80]);

wire [81:0] x6;  // recursive doubling stage 6
assign x6[63:0]=x5[63:0];

recursive_stage1 s531(x5[1:0],x5[65:64],x6[65:64]);
recursive_stage1 s532(x5[3:2],x5[67:66],x6[67:66]);
recursive_stage1 s533(x5[5:4],x5[69:68],x6[69:68]);
recursive_stage1 s534(x5[7:6],x5[71:70],x6[71:70]);
recursive_stage1 s535(x5[9:8],x5[73:72],x6[73:72]);
recursive_stage1 s536(x5[11:10],x5[75:74],x6[75:74]);
recursive_stage1 s537(x5[13:12],x5[77:76],x6[77:76]);
recursive_stage1 s538(x5[15:14],x5[79:78],x6[79:78]);
recursive_stage1 s539(x5[17:16],x5[81:80],x6[81:80]);

// final sum and carry

assign sum[0]=a[0]^b[0]^x6[0];
assign sum[1]=a[1]^b[1]^x6[2];
assign sum[2]=a[2]^b[2]^x6[4];
assign sum[3]=a[3]^b[3]^x6[6];
assign sum[4]=a[4]^b[4]^x6[8];
assign sum[5]=a[5]^b[5]^x6[10];
assign sum[6]=a[6]^b[6]^x6[12];
assign sum[7]=a[7]^b[7]^x6[14];
assign sum[8]=a[8]^b[8]^x6[16];
assign sum[9]=a[9]^b[9]^x6[18];
assign sum[10]=a[10]^b[10]^x6[20];
assign sum[11]=a[11]^b[11]^x6[22];
assign sum[12]=a[12]^b[12]^x6[24];
assign sum[13]=a[13]^b[13]^x6[26];
assign sum[14]=a[14]^b[14]^x6[28];
assign sum[15]=a[15]^b[15]^x6[30];
assign sum[16]=a[16]^b[16]^x6[32];
assign sum[17]=a[17]^b[17]^x6[34];
assign sum[18]=a[18]^b[18]^x6[36];
assign sum[19]=a[19]^b[19]^x6[38];
assign sum[20]=a[20]^b[20]^x6[40];
assign sum[21]=a[21]^b[21]^x6[42];
assign sum[22]=a[22]^b[22]^x6[44];
assign sum[23]=a[23]^b[23]^x6[46];
assign sum[24]=a[24]^b[24]^x6[48];
assign sum[25]=a[25]^b[25]^x6[50];
assign sum[26]=a[26]^b[26]^x6[52];
assign sum[27]=a[27]^b[27]^x6[54];
assign sum[28]=a[28]^b[28]^x6[56];
assign sum[29]=a[29]^b[29]^x6[58];
assign sum[30]=a[30]^b[30]^x6[60];
assign sum[31]=a[31]^b[31]^x6[62];
assign sum[32]=a[32]^b[32]^x6[64];
assign sum[33]=a[33]^b[33]^x6[66];
assign sum[34]=a[34]^b[34]^x6[68];
assign sum[35]=a[35]^b[35]^x6[70];
assign sum[36]=a[36]^b[36]^x6[72];
assign sum[37]=a[37]^b[37]^x6[74];
assign sum[38]=a[38]^b[38]^x6[76];
assign sum[39]=a[39]^b[39]^x6[78];

assign carry=x6[80];

endmodule

// D flip flop

module dflipflop33(q,d,clk,reset);
output [32:0] q;
input [32:0] d;
input clk,reset;
reg [32:0] q;
always@(posedge reset or negedge clk)
if(reset)
q<=33'b00000000;
else
q<=d;
endmodule

//MUX 9to1
module mux9_33(o,i0,i1,i2,i3,i4,i5,i6,i7,i8,s);

input [32:0] i0,i1,i2,i3,i4,i5,i6,i7,i8;
input [3:0] s;
output [32:0] o;
reg [32:0] o;

always@(i0 or i1 or i2 or i3 or i4 or i5 or i6 or i7 or i8 or s)
	begin
		case(s)
		 4'b0000:o=i0;
		 4'b0001:o=i1;
		 4'b0010:o=i2;
		 4'b0011:o=i3;
		 4'b0100:o=i4;
		 4'b0101:o=i5;
		 4'b0110:o=i6;
		 4'b0111:o=i7;
		 4'b1000:o=i8;
		default:o=34'bx;
		endcase
	end


endmodule

//MUX 7to1
module mux7_33(o,i0,i1,i2,i3,i4,i5,i6,s);

input [32:0] i0,i1,i2,i3,i4,i5,i6;
input [2:0] s;
output [32:0] o;
reg [32:0] o;

always@(i0 or i1 or i2 or i3 or i4 or i5 or i6 or s)
	begin
		case(s)
		 3'b000:o=i0;
		 3'b001:o=i1;
		 3'b010:o=i2;
		 3'b011:o=i3;
		 3'b100:o=i4;
		 3'b101:o=i5;
		 3'b110:o=i6;
		default:o=33'bx;
		endcase
	end


endmodule

//MUX 4to1
module mux4_33(o,i0,i1,i2,i3,s);

input [32:0] i0,i1,i2,i3;
input [1:0] s;
output [32:0] o;
reg [32:0] o;

always@(i0 or i1 or i2 or i3 or s)
	begin
		case(s)
		 2'b00:o=i0;
		 2'b01:o=i1;
		 2'b10:o=i2;
		 2'b11:o=i3;
		endcase
	end


endmodule

//MUX 2to1
module mux2_33(o,i0,i1,s);

input [32:0] i0,i1;
input s;
output [32:0] o;
reg [32:0] o;

always@(i0 or i1 or s)
	begin
		case(s)
		 1'b0:o=i0;
		 1'b1:o=i1;
	endcase
	end


endmodule

//conventional 5/3 lifting based wavelet with 3 octaves (row processor)

module lifting53_single_ext(clk,reset,

r1s,r1e,r1,ls,le,l,

x0s,x0e,x0,
x1s,x1e,x1,
x2s,x2e,x2,
x3s,x3e,x3,
x4s,x4e,x4,
x5s,x5e,x5,
x6s,x6e,x6,
x7s,x7e,x7,
x8s,x8e,x8,
x9s,x9e,x9,
x10s,x10e,x10,
x11s,x11e,x11,
x12s,x12e,x12,

f0s,f0e,f0,
f1s,f1e,f1,
f2s,f2e,f2,
f3s,f3e,f3,
f4s,f4e,f4,
f5s,f5e,f5,
f6s,f6e,f6,

in_s,s1,s2,s3,s4,s5

);

input [1:0] s1;
input [3:0] s2,s3,s4;
input [2:0] s5;
input in_s;
input clk,reset;

input x0s,x1s,x2s,x3s,x4s,x5s,x6s,x7s,x8s,x9s,x10s,x11s,x12s,f0s,f1s,f2s,f3s,f4s,f5s,f6s;
input [7:0] x0e,x1e,x2e,x3e,x4e,x5e,x6e,x7e,x8e,x9e,x10e,x11e,x12e,f0e,f1e,f2e,f3e,f4e,f5e,f6e;

input [23:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,f0,f1,f2,f3,f4,f5,f6;

output r1s,ls;//r1 is high pass and l is low pass outputs
output [7:0] r1e,le;
output [23:0] r1,l;

///////////////////////////////////////////////////////////////////////////////////

wire [1:0] s1;
wire [3:0] s2,s3,s4;
wire [2:0] s5;

wire in_as,in_bs,in_cs,in_ds,in_es;
wire [7:0] in_ae,in_be,in_ce,in_de,in_ee;
wire [23:0] in_a,in_b,in_c,in_d,in_e;

mux4_33 m1({in_as,in_ae,in_a},{x0s,x0e,x0},{x12s,x12e,x12},{f0s,f0e,f0},{f6s,f6e,f6},s1);
mux9_33 m2({in_bs,in_be,in_b},{x0s,x0e,x0},{x2s,x2e,x2},{x4s,x4e,x4},{x6s,x6e,x6},{x8s,x8e,x8},{x10s,x10e,x10},{f0s,f0e,f0},{f2s,f2e,f2},{f4s,f4e,f4},s2);
mux9_33 m3({in_cs,in_ce,in_c},{x2s,x2e,x2},{x4s,x4e,x4},{x6s,x6e,x6},{x8s,x8e,x8},{x10s,x10e,x10},{x12s,x12e,x12},{f2s,f2e,f2},{f4s,f4e,f4},{f6s,f6e,f6},s3);
mux9_33 m4({in_ds,in_de,in_d},{x1s,x1e,x1},{x3s,x3e,x3},{x5s,x5e,x5},{x7s,x7e,x7},{x9s,x9e,x9},{x11s,x11e,x11},{f1s,f1e,f1},{f3s,f3e,f3},{f5s,f5e,f5},s4);
mux7_33 m5({in_es,in_ee,in_e},{x2s,x2e,x2},{x4s,x4e,x4},{x6s,x6e,x6},{x8s,x8e,x8},{x10s,x10e,x10},{f2s,f2e,f2},{f4s,f4e,f4},s5);

wire as,bs,cs,ds,es;
wire [7:0] ae,be,ce,de,ee;
wire [23:0] a,b,c,d,e;

dflipflop d00(as,in_as,clk,reset);
dflipflop d01(bs,in_bs,clk,reset);
dflipflop d02(cs,in_cs,clk,reset);
dflipflop d03(ds,in_ds,clk,reset);
dflipflop d04(es,in_es,clk,reset);
dflipflop8 d05(ae,in_ae,clk,reset);
dflipflop8 d06(be,in_be,clk,reset);
dflipflop8 d07(ce,in_ce,clk,reset);
dflipflop8 d08(de,in_de,clk,reset);
dflipflop8 d09(ee,in_ee,clk,reset);
dflipflop24 d10(a,in_a,clk,reset);
dflipflop24 d11(b,in_b,clk,reset);
dflipflop24 d12(c,in_c,clk,reset);
dflipflop24 d13(d,in_d,clk,reset);
dflipflop24 d14(e,in_e,clk,reset);

wire s;

dflipflop d20(s,in_s,clk,reset);

wire [32:0] p6,p7,p8,p9,p10,p11,p12,p13,p14;

wire sign;
assign sign=~ds;

float_adder fa1(bs,be,b,cs,ce,c,p6[32],p6[31:24],p6[23:0]);
float_multi fa2(p6[32],p6[31:24],p6[23:0],1'b0,8'b01111111,24'b100000000000000000000000,p7[32],p7[31:24],p7[23:0]);
float_adder fa3(p7[32],p7[31:24],p7[23:0],sign,de,d,p8[32],p8[31:24],p8[23:0]);

wire [32:0] r2;
wire r1s,ls;
wire [7:0] r1e,le;
wire [23:0] r1,l;

dflipflop33 d21({r1s,r1e,r1},p8,clk,reset);
dflipflop33 d22(r2,{r1s,r1e,r1},clk,reset);

//dflipflop33 d23(p9,{as,ae,a},clk,reset);
//dflipflop33 d24(p13,{es,ee,e},clk,reset);

assign p9={as,ae,a};
assign p13={es,ee,e};

wire sj;
//dflipflop d25(sj,s,clk,reset);

assign sj=s;

float_adder fa4(r1s,r1e,r1,r2[32],r2[31:24],r2[23:0],p10[32],p10[31:24],p10[23:0]);
float_multi fa5(p10[32],p10[31:24],p10[23:0],1'b0,8'b01111111,24'b100000000000000000000000,p11[32],p11[31:24],p11[23:0]);
float_adder fa6(p11[32],p11[31:24],p11[23:0],p13[32],p13[31:24],p13[23:0],p12[32],p12[31:24],p12[23:0]);

multiplexer2 m6(p9,p12,p14,sj);

dflipflop33 d30({ls,le,l},p14,clk,reset);

endmodule

// storage buffer

//`include "mux2_33.v"
////`include "dflipflop33.v"

module storage7_33(i,d1,d2,d3,d4,d5,d6,d7,s1,s2,s3,s4,s5,s6,s7,clk,reset);

input [32:0] i;
input s1,s2,s3,s4,s5,s6,s7,clk,reset;
output [32:0] d1,d2,d3,d4,d5,d6,d7;

wire [32:0] m1,m2,m3,m4,m5,m6,m7,d1,d2,d3,d4,d5,d6,d7;

mux2_33 mu1(m1,d1,i,s1);

dflipflop33 df1(d1,m1,clk,reset);

mux2_33 mu2(m2,d2,d1,s2);

dflipflop33 df2(d2,m2,clk,reset);

mux2_33 mu3(m3,d3,d2,s3);

dflipflop33 df3(d3,m3,clk,reset);

mux2_33 mu4(m4,d4,d3,s4);

dflipflop33 df4(d4,m4,clk,reset);

mux2_33 mu5(m5,d5,d4,s5);

dflipflop33 df5(d5,m5,clk,reset);

mux2_33 mu6(m6,d6,d5,s6);

dflipflop33 df6(d6,m6,clk,reset);

mux2_33 mu7(m7,d7,d6,s7);

dflipflop33 df7(d7,m7,clk,reset);

endmodule








`default_nettype wire
