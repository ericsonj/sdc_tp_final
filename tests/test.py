import cocotb
from cocotb.triggers import RisingEdge
from cocotb.clock import Clock, Timer


@cocotb.coroutine
def reset(dut):
    dut.rst <= 1
    yield RisingEdge(dut.clk)
    dut.rst  <= 0
    dut.en_i <= 0
    dut.data_i <= 0
    yield RisingEdge(dut.clk)
    dut.rst._log.info("Reset complete")

@cocotb.test()
def test_cordic(dut):
    cocotb.fork(Clock(dut.clk, 1, units='ns').start())
    yield reset(dut)
    
    for i in range(16):
        dut.data_i <= i
        dut.en_i <= 1
        yield Timer(13, units='ns')
        dut.en_i <= 0
        yield Timer(3, units='ns')

    yield RisingEdge(dut.clk)
    for _ in range(10):
        yield RisingEdge(dut.clk)
