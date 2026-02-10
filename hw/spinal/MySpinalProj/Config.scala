package MySpinalProj

import spinal.core._

object Config {
  def spinal = SpinalConfig(
    targetDirectory = "hw/gen",
    defaultConfigForClockDomains = ClockDomainConfig(
      resetActiveLevel = HIGH
    ),
    onlyStdLogicVectorAtTopLevelIo = false
  )
}

object verilog {
  def apply[T <: Module](gen: => T) = Config.spinal.generateVerilog(gen)
}

object vhdl {
  def apply[T <: Module](gen: => T) = Config.spinal.generateVhdl(gen)
}
