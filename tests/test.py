import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer

@cocotb.coroutine
def reset(dut):
    dut.rst <= 1
    dut.data <= 1
    yield Timer(15, units='ns')
    yield RisingEdge(dut.clk)
    dut.rst <= 0
    dut.x_i <= 1000
    dut.y_i <= 0
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_cordic(dut):
    cocotb.fork(Clock(dut.clk, 1, units='ns').start())
    yield reset(dut)
    yield Timer(99, units='ns')
    yield RisingEdge(dut.clk)
    for _ in range(10):
        yield RisingEdge(dut.clk)
