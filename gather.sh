#!/usr/bin/env python3

from subprocess import check_output
import json
import re
import math
from pathlib import Path


class Lshw:
    def __init__(self):
        data = json.loads(check_output("lshw -json", shell=True))
        self.system = data[0]

    def model(self):
        print(
            "Manufacturer Model: {} {}".format(
                self.system["vendor"], self.system["configuration"]["family"]
            )
        )

    def model_details(self):
        print("Model details: {}".format(self.system["product"]))

    def serial(self):
        print("Serial Number: {}".format(self.system["serial"]))

    def processor(self):
        for part in self.system["children"]:
            if part["id"] == "core":
                for core in part["children"]:
                    if core["class"] == "processor":
                        processor = core["product"]
                        print("Processor: {}".format(processor))
                        return
        raise "Can't find processor info"


class Xrandr:
    def __init__(self):
        data = str(check_output("xrandr", shell=True), "utf-8")
        self.data = data.split("\n")

    def display_sizes(self):
        screen_number = 0
        for line in self.data:
            match = re.search(r"(\d+)mm x (\d+)mm$", line)
            if match:
                screen_number += 1
                x = int(match[1]) * 0.03937008
                y = int(match[2]) * 0.03937008
                diag = math.sqrt(x * x + y * y)
                print('Display {} size: {}"'.format(screen_number, round(diag)))


class Lsblk:
    def __init__(self):
        data = json.loads(check_output("lsblk --json", shell=True))
        self.blockdevices = data["blockdevices"]

    def storage(self):
        disk_count = 0
        for disk in self.blockdevices:
            if disk["type"] == "disk":
                disk_count += 1
                print("Disk {} size: {}".format(disk_count, disk["size"]))


class Lsmem:
    def __init__(self):
        data = json.loads(check_output("lsmem --bytes --json", shell=True))
        self.data = data["memory"]

    def memory(self):
        sizes = [int(m["size"]) for m in self.data]
        gbs = sum(sizes) / 10 ** 9
        print("Memory: {} Gb".format(round(gbs, 2)))


class Batt:
    def __init__(self):
        path = Path("/sys/class/power_supply/")
        self.batteries = path.glob("BAT*")

    def charge_counts(self):
        count_files = [b / "cycle_count" for b in self.batteries]
        for i, file in enumerate(count_files):
            with file.open() as fi:
                print(
                    "Battery cycles for battery {}: {}".format(i + 1, fi.read().strip())
                )


def os_version():
    version = check_output("lsb_release -sd", shell=True)
    print("OS: {}".format(str(version, "utf-8").strip()))


lshw = Lshw()
lshw.model()
x = Xrandr()
x.display_sizes()
lshw.processor()
lsblk = Lsblk()
lsblk.storage()
lsmem = Lsmem()
lsmem.memory()
batt = Batt()
batt.charge_counts()
lshw.serial()
os_version()
