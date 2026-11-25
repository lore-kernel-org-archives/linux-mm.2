Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D95606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jhWFk78p
Received: by kanga.kvack.org (Postfix)
	id D2CEF6B0B30; Wed, 25 Nov 2026 18:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6D46B0B31; Wed, 25 Nov 2026 18:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5686B0B32; Wed, 25 Nov 2026 18:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2566B0B30
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:30:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF58E401D0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:30:33 +0000 (UTC)
X-FDA: 85475237946.01.3B9F312
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BE9E4001A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:30:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jhWFk78p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795649432;
	b=nZAoNQJfYkEIKpYiOY/IQMBAcK9iU5UWhbq4dbwJUd/+HBhW14n5NoFXkNX+CGBfUEAafN
	v2FuRZltpT4elBVJi6g6MqfV9DrQb2zSxSoIjdaqeWzRsn+4rXd3ksykRdETa8Q5eQ7l/1
	IMHAlbf8PgS933JWrO+YJUXrdKIDpvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795649432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e35aD9xDuc1hKVMZ4DHpu/O6GiR6BdX7QfpIMiYdEOE=;
	b=VlQaxWo+K4wS+jCkQmRapbAzfnAtQbqXtSbdLOfxuGAI2B6xZaeybu/cbamVbnZedzEwVj
	o2s2gaNxROSsU4fsHtfztjW8rjshV8ZboBG+mGuibJFg+FLIB+910PVOCvCcJWr4xEW9Ud
	0Kp5rPRpsdnvIu6c3G53CZyonJrVJDU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jhWFk78p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vitorhg20080@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=vitorhg20080@gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb85e07aadso78951605e9.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795649431; x=1796254231; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e35aD9xDuc1hKVMZ4DHpu/O6GiR6BdX7QfpIMiYdEOE=;
        b=jhWFk78pOfDgbvTP6dy/0qz4Bzb1qdTveApkwUfToNYgw6XOmJO0N5G2gd7nSvTdaZ
         yjLHhK6uD+n+YdMHShNEFxa/Cig3QkehlisUKehsmdfNnv5EEz/2GCRbII5glZAsQPqw
         heepM8H+bhQECWsnNBkuWpJyZ3RDWmFV9WtzuyLNi/xLDL1jSlTePUCqyVcHBzu8r8LV
         aWfcSuBSvMXTUPM56oI3bX4aWpMLGJS+Y4IYn72Nnphq9v+lUp1p18M2h0pvQ89dy5bN
         3fxbK6VnXCi+jwPQlvaoZtsPdGuiFSTyOqrebQHSS2OCwbyGmrnJiP6Kx7chSOQMW0PA
         74RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795649431; x=1796254231;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e35aD9xDuc1hKVMZ4DHpu/O6GiR6BdX7QfpIMiYdEOE=;
        b=LbwJyVJxzOp86ZBcaSZhzNu1TcyDApR+cyETHNzUjBLDfc0HqnmkUBciS3AlnCjXqe
         DMg0sx39kNYi3xDPzZh7DDWt9caTiQbuIV1HHTOpvIP4OPRQXgon/CbC8C+fBdPBRr+E
         Hqo+WW2Ex0vCQ9Ec8fpRqAZemvRd8aWUlwJ+QEINYs2Xwol3ct4nmItveWeCWI/O+lDr
         83hwi0vp8SA+Ee7YxeycmyL9lXO4Bym5qAbA5hssekH1s6BKUhZ9td1t4aCz52ClQbDd
         narGNlENUjiAbIgZgz4QgNVsLc5ZryfQVwa/wFF++oDAxEr9pHTzdgZc1eIrDxyJTDZV
         UNJA==
X-Forwarded-Encrypted: i=1; AL+hErGgtO4xk2kPgmBheu/3o/3WdpxPaZFRXeF0m2JVIqbOEnPOgGgbN7K01JFCQNXQs/KyHQWtqlt6ZA==@kvack.org
X-Gm-Message-State: APuU4Z+w1JmlZM82wF1e/ZQIPzgDRAIH5+6xTlQdezo6o5R10d5eTIxJ
	9pkmzkPfWNd3JyU1wGS4DejrHsMsnrul49A2ykKwUTSIGdITQQHD0wAa
X-Gm-Gg: AZFdTZdl2nvV/Do9XBmImwMzQ4bsoKuifGqehzimivwUkmzZfjEKYWsuOZdpuQF5AoJ
	9iPeWPKB+ui1S4PHyaa5bEttDMuAFcu+eti9rAfS4qR+Azsvq3JhCTW9ykB/ktma7zLvR1V6S7r
	adl0/N6qgc4gP/QOESG/NIjIq3N/oCMmB7NcFHIWYZl6YX8JER8yxEhezLcPbG7jKndScFe57Yq
	Zxo3HBlMoljQe3pUEjIcBY8ii8ewUvmmwiqX+aorG53Y6CvQuZEjQGB02nHnLUaEARbhLDNijEH
	cJfwVNHlOG8tCraik8l7hZfWNWgOtUK9Al4FT2h06NmD2EqhxFzXqtHTVKMj8llKseyA4ifp8Ax
	e5loxdbA4YvV/Y+4Euy0YClRBQgwHuDdwUylsD8lxzkasLGrzo/80rgatW31JSTZa2nJdxcO2wr
	G7sP54Vcknjl39Eo6zdXFaPK15cdg9tPrpcyho5tH7shr1+kSwzZzlFgxMZE5kBY6AAvaeCNsEz
	P/oTPPx6z0m1tIJZY4j2lIqF7y1F0LHqMy77/37HkpuIKPORPjmUdx2GBR4IMFGyf29GittPijQ
	NsvJENdScJW1fzDBeFIFcOOh+3I4/x0axKYJC2Wr2hOjkP/hl2pRXfguVy8UwseZFK4BCI9YfeM
	mSKR/lFV4lHqtbuu6u0wLSxpI5BWYfV8=
X-Received: by 2002:a05:600c:4f50:b0:4a2:1612:637a with SMTP id 5b1f17b1804b1-4bb888063f3mr484937095e9.16.1795649430462;
        Wed, 25 Nov 2026 15:30:30 -0800 (PST)
Received: from localhost (bl20-90-91.dsl.telepac.pt. [2.81.90.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6c4353d6sm35729850f8f.56.2026.11.25.15.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 15:30:29 -0800 (PST)
From: =?UTF-8?q?V=C3=ADtor=20Hugo=20Silva?= <vitorhg20080@gmail.com>
To: linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	linux-serial@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC 00/19] riscv: Add initial support for Espressif ESP32-P4
Date: Wed, 25 Nov 2026 23:30:01 +0000
Message-ID: <20261125233020.1380594-1-vitorhg20080@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: tukwkkszqmn56hf61ez56x7q7qr7urmp
X-Rspamd-Queue-Id: 1BE9E4001A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795649431-666227
X-HE-Meta: U2FsdGVkX1/qERwxX0djN0MP3xWzfyYnx/kGupCntgUkmYNRUlxbBqF1qk6PzPKwb9ciz9o8VCt95/HN/zouzAydaQrIICHCkDNCtqZQQSkw++MsW/KXKXfBYOA1iS1fH2KXeON13GafbfL9eDie9qSbovX3bCUt3XpRTL5GcDGOAApi/ukgK3q+hSW3KgzfFV0t0jKkx0V0yPXef83UdCxYXDA2Ygs82dz4GdryhmtMl3uB7TsINJo483xBCosrfiLHveL3+XC5eyzUuPLtht1ompvgS42OmWyQKJPNacZ5B59Jr1IJoTBjiN0v8kNNXjLk38mEk2pQT/POthW2/9nv8QOJx6QbP7phbbOOXtwdP1XeJzLXdoineI5BG98PITvHbvrGUYJ5A0EbcXulQWW8Kdxl4Tvxyl2m2poeGophE3DenG3Aub7NZkR35NWFEPdtwRG2tXIFQxVvz4RyWRjG24xV3/Ez6d3WidF2Xd7NALjo/cm1SYD5yNHnwR6G/D/5N3vRce9rb9WGfBWULPQAfvs7b/S7CSZ/HiwYIGqSL/caTGPvHTfBWKsj03bN4RgHLT9Ggw/LSxpFdKmLxYmM2aqVRv5sruZHObR3GBUd3yLNlh+tPuDMHcKcn3Ui3zqELe9ca/CAiCSy2mh0MYtiaNVCYDX/JIRHE8XfvNW5f//sNAh4bN2r+uIM62/cPrYUGMPuiIlFyttAujU7ONFUPPvcxeLO8QlfNVTyLWof+l7ZHECuDnqDSHFX7OQxcPbtzpazIimTRWoXNh3SZCDf5FbEIZ+ueBlWVaZy4l/V0r0yvZr+5IxZ4JAVZSuP90MbSs2KHMh2FBCghFtQnH2QSTXX4qbKzt+hd3wddPfwXx9ohDHspd+njm7RDXxrVIRGTmhmTmWBYqqWY5q8khQLJlzHjJv9NAWwiu+zqwl0Dxmj7ODsInNMMAtWEHKtKlcxRAHR+uMEu4lPhiI
 cUNUJZXR
 JWmoiQNN1E3SgNv2R+ZWV+w1SFK7nKBcxE5WNLw8UO1bTftDp4AO9plqH0gDPezO5QY2hwHI4ltokrhaa+4ixTPq/UlhFoz6P+LK7A08ZYSn6bamo6fkweAIL7K7xD2x1EuT3TNp4weYum22akZSThXU8h90/YWPO2YhQFTZ9cojGUr749GHmwHjN7gi7PIReqdgsyv0NXISWvTOCiWf0w5X3x5DznV4dLoArEKJbxfuey4Dq35hXXF8faQVCQb0NFtCyo4ZbS6G8J5OnZfCk7h7I1Of9cLH8Zg0RQK6bKerdUPEW4dXqQDigoM1kqEIPUGIf1tVZd3bXdgBoWvGfi26TeKg+ay6ZB2sLBekkzZnNpQiQi6o8DWxYWRVFY55AAPKZfd68LXAAGKTAnxoFhUevQaWmcMdjdXBGpY8GRUqIJcp3+Lf2KCEnP0RyRyynN0Zju13m/tgxMpT/QYm2SMOQ16GPBmvkApoqYD/FkB+134G2ECj4OrEB/gSJ5jg1XWUqM0IHA2BxDwWbF8dyJeqTXxvkvk9OkgPHc0eCtGyZmURPx+FHQ5w3gMPe7Tx/t392jGxifUP/iU3ydDh2ZS8wW2JsJxKrzA607a1ujyAsq+lvhMUOfS9tq+0oTxusTrAG3anbVbe3VUrNtQMh4f4zkrV6YVCmPF5gvYcZ3VEWiTYiJbMsdRx0asQYjHs7CRjEJOfZX+UK4h36TNhF0FB0aR0m3A1PpGJUOLxfv3W+X5jBdyJ1FVttUK6p9htwMN+C9Wli6gUev+TYao1s/WaWV98R70AXuOTApmHkInvNWKdFO4HjdPjeWivGZY4NOH/Mz4nJjQEhOVhCYb9Mad9xG6wr1AFTjANV3/CNB9jyk3DVi6A0R0IXxVGPGQiU4a2u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

This series of patches adds the initial support for the Espressif's
ESP32-P4 on the Waveshare ESP32-P4-Module-DEV-KIT. It boots in M-mode on
a RV32 NOMMU kernel with one HP hart.

The series adds CLIC trap handling, drivers for clic and for interrupt
matrix, and extends the CLINT timer driver. It restores a previously
removed ESP32 UART driver with ESP32-P4 UART support and early console
support. It also synchronizes the instructions written to the PSRAM,
aligns the init data to the ESP32-P4 PMP granularity, and it adds DT
bindings and the board devicetree.

The boot firmware initializes PSRAM, loads the kernel, DTB and the
initramfs from the microSD, and it supplies the timebase-frequency
before jumping into the kernel.

The bootloader source and microSD boot instructions are available at:
https://github.com/pushdword/waveshare-esp32-p4-bootloader/blob/390880e881208ab16aa16eb520b3e5ea0c63c0a2/README.md

I tested this series on the hardware, the Waveshare
ESP32-P4-Module-DEV-KIT with the ESP32-P4 revision v3.2 with 32MB of
PSRAM. The kernel booted to the UART shell from the initramfs. The
/proc/interrupts showed the CLINT IRQ's increased, UART0 interrupts were
routed through the interrupts matrix. 

It would be nice to you all send feedback on restoring the interrupted
CLIC level before irq_exit_rcu() and the interface for propagating
instruction-cache sync failures to NOMMU executable loading, and signal
setup.

AI disclaimer: I have used 6.2-Sol to assist development and to assist
debug/troubleshoot some ongoing issues. I have used Codex's 6-Sol
with Daybreak Blue enabled to generate peer-review-like report to
pinpoint potential security issues regarding the patches. I manually
reviewed and validated each change, including the AI-assisted changes.
I also manually tested each change on the hardware as described above.

Vítor Hugo Silva (19):
  riscv: Prepare ESP32-P4 early CLIC trap vectors
  riscv: Handle ESP32-P4 CLIC trap context
  dt-bindings: interrupt-controller: Add Espressif ESP32-P4 CLIC
  irqchip: Add Espressif ESP32-P4 CLIC support
  dt-bindings: interrupt-controller: Add Espressif ESP32-P4 interrupt
    matrix
  irqchip: Add Espressif ESP32-P4 interrupt matrix support
  dt-bindings: timer: Add Espressif ESP32-P4 CLINT
  clocksource/drivers/timer-clint: Add Espressif ESP32-P4 support
  dt-bindings: serial: Add Espressif ESP32-P4 UART
  serial: esp32: Restore the ESP32 UART driver
  serial: esp32: Add support for the ESP32-P4 UART
  serial: esp32: Rearm TX interrupts when the FIFO is full
  serial: esp32: Add early console support for ESP32-P4
  riscv: Synchronize instructions written to ESP32-P4 PSRAM
  riscv: Align init data to the ESP32-P4 PMP granularity
  dt-bindings: riscv: Add Waveshare ESP32-P4-Module-DEV-KIT
  dt-bindings: riscv: cpus: Document Espressif ESP32-P4 HP harts
  riscv: dts: Add Waveshare ESP32-P4-Module-DEV-KIT
  MAINTAINERS: Add the Espressif ESP32-P4 platform

 .../esp,esp32p4-clic.yaml                     |  53 +
 .../esp,esp32p4-intmtx.yaml                   |  67 ++
 .../devicetree/bindings/riscv/cpus.yaml       |  17 +-
 .../devicetree/bindings/riscv/espressif.yaml  |  22 +
 .../bindings/serial/esp,esp32-uart.yaml       |   4 +-
 .../bindings/timer/sifive,clint.yaml          |  28 +
 MAINTAINERS                                   |  14 +
 arch/riscv/Kconfig.socs                       |   9 +
 arch/riscv/boot/dts/Makefile                  |   1 +
 arch/riscv/boot/dts/espressif/Makefile        |   2 +
 .../esp32p4-waveshare-module-dev-kit.dts      |  46 +
 arch/riscv/boot/dts/espressif/esp32p4.dtsi    |  64 ++
 arch/riscv/include/asm/asm-prototypes.h       |   4 +
 arch/riscv/include/asm/cacheflush.h           |   6 +
 arch/riscv/include/asm/ptrace.h               |   4 +
 arch/riscv/kernel/asm-offsets.c               |   3 +
 arch/riscv/kernel/entry.S                     |  67 ++
 arch/riscv/kernel/head.S                      |  13 +
 arch/riscv/kernel/patch.c                     | 132 ++-
 arch/riscv/kernel/signal.c                    |   6 +-
 arch/riscv/kernel/traps.c                     |   4 +
 arch/riscv/kernel/vmlinux.lds.S               |   4 +
 drivers/clocksource/timer-clint.c             |  57 +-
 drivers/irqchip/Makefile                      |   2 +
 drivers/irqchip/irq-esp32p4-clic.c            | 178 ++++
 drivers/irqchip/irq-esp32p4-intmtx.c          | 139 +++
 drivers/tty/serial/Kconfig                    |  15 +
 drivers/tty/serial/Makefile                   |   1 +
 drivers/tty/serial/esp32_uart.c               | 940 ++++++++++++++++++
 fs/binfmt_flat.c                              |   6 +-
 fs/exec.c                                     |  10 +-
 include/linux/cacheflush.h                    |   7 +
 32 files changed, 1910 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/esp,esp32p4-clic.yaml
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/esp,esp32p4-intmtx.yaml
 create mode 100644 Documentation/devicetree/bindings/riscv/espressif.yaml
 create mode 100644 arch/riscv/boot/dts/espressif/Makefile
 create mode 100644 arch/riscv/boot/dts/espressif/esp32p4-waveshare-module-dev-kit.dts
 create mode 100644 arch/riscv/boot/dts/espressif/esp32p4.dtsi
 create mode 100644 drivers/irqchip/irq-esp32p4-clic.c
 create mode 100644 drivers/irqchip/irq-esp32p4-intmtx.c
 create mode 100644 drivers/tty/serial/esp32_uart.c


base-commit: aebb7274476403040d582c61478df8f4a7bf9cd3
-- 
2.56.1


