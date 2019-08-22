import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

xValues = [16384,
        15137,
        11585,
        6270,
        0,
        -6270,
        -11585,
        -15137,
        -16384,
        -15137,
        -11585,
        -6270,
        0,
        6270,
        11585,
        15137]

yValues = [0,
        6270,
        11585,
        15137,
        16384,
        15137,
        11585,
        6270,
        0,
        -6270,
        -11585,
        -15137,
        -16384,
        -15137,
        -11585,
        -6270]

@cocotb.coroutine
def reset(dut):
    dut.rst <= 1
#     yield Timer(15, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    dut.x_i <= 16384
    dut.y_i <= 0
    dut.en_i <= 0
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_cordic(dut):
    cocotb.fork(Clock(dut.clk, 1, units='ns').start())
    yield reset(dut)
#     yield Timer(12, units='ns')
    
    for i in range(len(xValues)):
        dut.en_i <= 1
        dut.x_i <= xValues[i]
        dut.y_i <= yValues[i]
        yield Timer(1, units='ns')
        dut.en_i <= 0
        yield Timer(13, units='ns')

    yield RisingEdge(dut.clk)
    for _ in range(10):
        yield RisingEdge(dut.clk)
