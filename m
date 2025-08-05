Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1456BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87DDB6B0088; Tue,  5 Aug 2025 15:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8562E6B009A; Tue,  5 Aug 2025 15:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C086B009C; Tue,  5 Aug 2025 15:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 659526B0088
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E084C160144
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:00 +0000 (UTC)
X-FDA: 83743719360.05.D9956E4
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A33840007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:39:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=GggF1TvF;
	spf=pass (imf04.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422799; a=rsa-sha256;
	cv=none;
	b=ZjLTva/3Qms3ALfw97y/wgjPXRfxB+93vVzEizxDrP9DF41JNualavziWekWV1kauu7VD5
	bQp9pzC9F23+n6tJSHbDvF0+uqgUrXvuYyN+LRwrVKY7r5Yy66T8Fgekjgf6OAJ/FXbNfk
	lWb3+nrbmae/f3N99ZZe0uv8M4jK1FQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=GggF1TvF;
	spf=pass (imf04.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Av9ulXUYq8yypH92LgefCWXE0SBG4q/HDQdjt7nKwbs=;
	b=lfrZXEwIMt4idxoLuNalGnLBz8ojlfYp3uT9SI/Khwl47wpGKR31+SOuvkFQ290xMRyPSA
	NBA0Gth2Vm7gHZ6fyIEb92sZ6OAbJav0eR8GCkI00LpIzIc4UoTOXsye/8J5puwb8t0wmG
	4zUe6xL3BJItqKqyGdC2FJwCgJ4UlRk=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e809baeef7so179195585a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422798; x=1755027598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Av9ulXUYq8yypH92LgefCWXE0SBG4q/HDQdjt7nKwbs=;
        b=GggF1TvFbvBPpK9btEFt2abzgtukPs/xNtkz30RTPAUX3yaWgrEGh8lUkGdHvZENok
         wJC8dyqv6PcPXp+pIc4+tZx0QVzQ1qSzhTxah5aiRf63w5ue+2Uz7SNEZmiIOUE6EZ24
         /qvMk7gPzyFi8ZphFSsxjh49rzxiJrtNH/3lliqEwsE7X5sIQqCozaiYfWSgm6O2Zc8O
         H1J+3C2oQy1kTyu0v+aFUNP1i9LSzmzaZtGJAe2l3WdqitRrU5fGOGnoHJvCB8B2XjeT
         MRTCzfAw3SyDHqA8vtavary3RP8jdz8EFOoZ9cmU+uwXKq7Rjl8ePnYbku93VS14SX6C
         ZgBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422798; x=1755027598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Av9ulXUYq8yypH92LgefCWXE0SBG4q/HDQdjt7nKwbs=;
        b=omB9VQgb+PENY0h7YhZwkOlSdHynUtozrL2xyn1+pW9lH9SGGcZDeN4tReotsZBT3z
         1koeFFujr2D3LroEu4UE7uoYSjY/tsbnfULTVsWKCEIW6rWB2MvNC5fJ42/4v+IWk/pq
         FzeZM7I4hBYVmAjJ6Bfm5vk2dJviRW2TsIwZsV7bws0xDpy1RpxrY10NR1sg+CiBLjQ+
         bSghu6KvdzyHZ/F98Hbz78aOKqfJCbLESPHkCiSWpR+XNxYxz1Ufhoge+B5QsIE5t0hY
         dhwfSk384+NQ0mgkc7BrlISz2koaqxYMqSIm0Sl6SgcypsmtynIdvpS6CAccBk3VUR1A
         xA9g==
X-Forwarded-Encrypted: i=1; AJvYcCW7OTjjQAthNX5KxwaydXfe1kmyLwT3DxpZT0znoYWUlOdptOGT0GH6yYB1lUMf7L6ncbSo/ivXBA==@kvack.org
X-Gm-Message-State: AOJu0YyfaLFgdFNSJxrAw0gKEEkYBK5tKa3V1KHlq4f+QoBNlrwFFBQ6
	XvTTeNbz/P9ZWVNPN7C1FUVSan+kGWjkfn2E1EeVJnCJb+Gwvb/juU6HhKUjBE2bvhA=
X-Gm-Gg: ASbGncuM/LcFKNTnSu6y6JAVnm1/p2zyy9qU8TQB5huMwZ/hnodUzyIWM9lo/BYD5EY
	0nsdazQPdT/+Swyl4kTqUtviyhXDeAMsjG/FujRGwxhH+n81/KSFMWhm0VQk1Ie+iJQzag5EGpg
	933Z/mQIddQJLS/eUYqcZKgy67qP+6SZAyOBcboNeL9VNSFtbIErGEZ2WIn6rt+ME6o4jfwugHw
	en5zHjSHMqwRnQ7S3MIeswPBZn+VLsbef/B7W54rl2OQKvGljKHgKhF9qIOVW/McIWtZXL+bQSm
	rVw0x+ZoUHz3lpNolwchsk7BK6Gs6hWK+9I6/cxj8F8DHb4wFRYyb1pLZ9g75nq/K+VgVO00Lvg
	nnHpmlMbppwwiuJtnjkDXaQ9JEz3SL17rlwzADuC/9mCQ/uUTPRnWy371prKcAdzNcnfFJqWiXj
	4D5Y5/pw==
X-Google-Smtp-Source: AGHT+IGaYz9rbHDaluNVvJAMepELkYucyj+ueO/efwJAG+Ld5Sktyl2JYCmbLDUiGqnvS0NmhNn2LQ==
X-Received: by 2002:a05:620a:370f:b0:7e6:67b3:ebf2 with SMTP id af79cd13be357-7e814d1a1e2mr85393985a.27.1754422798022;
        Tue, 05 Aug 2025 12:39:58 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:39:57 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley  <conor.dooley@microchip.com>,
	Deepak Gupta  <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 0/8] riscv: add initial support for hardware breakpoints
Date: Tue,  5 Aug 2025 12:39:47 -0700
Message-ID: <20250805193955.798277-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A33840007
X-Stat-Signature: ic5rbz745g1dpohhq79az5qd85hr1xk5
X-HE-Tag: 1754422798-1213
X-HE-Meta: U2FsdGVkX19jOwnciJzdpX9cGp1Cqk7GBJdXx8hrbvPhv0Z9Or14XjVH5Ugt1SAVqJvJAFriZXrDnEA7724PRekGqr9dMxHRjAVdaHzNgPeQrgJuqacCKGR/IFGeEwGygEak0S88mlnEkfP4q57gSE6uC+5DpdSNLjFIX6KKshD6yxy271G3nzsDYUI215ZRqcfRCMd4EBj7i3omSzic99MqATaczNGmxj/BKX+4wABQwTnpK6HDiCf3vpA26Wu5O0B14jDs+Jr4kCpdr2pdp54iWAYvy4AnURXKInF5N4RgQdbLZN3aet6/VItE/TBPJjD97ch3+XpB5h5gExlcYknHmVKjVhgwgg1gwzMTgGsb8bRhRa2QU2WjjO2HYC/fgK9lRw5WxTT5/GPnjYcFJv6wI1DI4qJ2sxvNpZ3ofRbWjWuSpVDTw2Ey3BrrHxMqmMVQqD47EpXgYVtqgPO/1aHTY1CwlevPBdNUMehdZLjZ77TNxYv0q/xkFIVnzG4hd/9uGmjuGntmsH9G4gIGV0ieXEZpIrprFuhQyYCy1Ah4z2lyhvxA5+hZkwq3mDC9AtOPkYfCM2KR5sMQ4HJY0SmAckGYkVfJsgc0aFOumoo3k9cUDhodWfjVRVDvpkgOCrVM1tY/4AG0Irxx0N1Vp6mHq+vONmH1viXHB8eMmaKv12X9+6Xv3GfpuyS9+k4oNdN2D2HxLkCJ/Aqqje2bEUb9wW/gMBqarh0+o/hW9ww+ZQ6nM02kNVxTp195SaTfjEE1pk0QT2FHIXmgirH5XSeBdX7XeOIzdQsx8bqXK4oMYF8Aev6G9nShoKmXQGYNShB9hmw6/9GmucuPenLMy60efd34WVEdVo3kWPpDYD1MNJ8YlTbmGG3UMA99fZ77QSz3MJlaNukWG4ZPyznZ+6mvi8FwnVhkwW/2iDlqilVGRTntA9RvwuQWo4N0+5dj8tOQ0waMA728l07Fo2m
 a+i4LDRC
 WvJJlBHDZdEr6J+L1CXoPnI2O2s3Yc4+QTVYUcAaBJUVnp5/plPFSL1sJSk0Gh3WxBHnET4NWBfs7pYfqX3xDH/9p3xgM94rFnr8B61kunsTd35+3cFZ9XFf6vf0YAHDLt2SPbh8yxcgLDt01PMD+MwEPiMMmdx3Kt4aCk7ybhcF5Ws8GUssxY4ULatT5+jsRjNPj9NL73WMLkxI33BBxqBwsUtRm1/7bBmBxL57u3HIWLfxt0uheD5BJOF4+LyZOUTtFIjgLUJ1+xtkMocBFtSl4BvJCk+idf5Mr2y3KbB4v93e60PdTQ6KusoI6HMMYTtTTIzRgXt8HXFS9qjpswuHVJF8SQS/i57zTDKYjXnkx1ibjgIsyKOhrQoebEWJRZCtCSlIG+fAY0cdyFGqtrPINXbzUbpa5EuGz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds initial support for hardware breakpoints and
watchpoints to the  RISC-V architecture. The framework is built on
top of perf subsystem and SBI debug trigger extension.

Currently following features are not supported and are in works:
 - icount for single stepping
 - Virtualization of debug triggers
 - kernel space debug triggers

The SBI debug trigger extension can be found at:
https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-debug-triggers.adoc

The Sdtrig ISA is part of RISC-V debug specification which can be
found at:
https://github.com/riscv/riscv-debug-spec

based off the original RFC by Himanshu Chauhan here:
https://lore.kernel.org/lkml/20240222125059.13331-1-hchauhan@ventanamicro.com/

Second RFC by Jesse Taube here:
https://lore.kernel.org/lkml/20250722173829.984082-1-jesse@rivosinc.com/

Himanshu Chauhan (2):
  riscv: Add SBI debug trigger extension and function ids
  riscv: Introduce support for hardware break/watchpoints

Jesse Taube (6):
  riscv: Add insn.c, consolidate instruction decoding
  riscv: insn: Add get_insn_nofault
  riscv: hw_breakpoint: Use icount for single stepping
  riscv: ptrace: Add hw breakpoint support
  riscv: ptrace: Add hw breakpoint regset
  selftests: riscv: Add test for hardware breakpoints

 arch/riscv/Kconfig                            |  13 +
 arch/riscv/include/asm/bug.h                  |  12 -
 arch/riscv/include/asm/hw_breakpoint.h        |  59 ++
 arch/riscv/include/asm/insn.h                 | 132 ++-
 arch/riscv/include/asm/kdebug.h               |   3 +-
 arch/riscv/include/asm/processor.h            |   4 +
 arch/riscv/include/asm/sbi.h                  |  33 +-
 arch/riscv/include/uapi/asm/ptrace.h          |   9 +
 arch/riscv/kernel/Makefile                    |   2 +
 arch/riscv/kernel/hw_breakpoint.c             | 769 ++++++++++++++++++
 arch/riscv/kernel/insn.c                      | 165 ++++
 arch/riscv/kernel/kgdb.c                      | 102 +--
 arch/riscv/kernel/probes/kprobes.c            |   1 +
 arch/riscv/kernel/process.c                   |   4 +
 arch/riscv/kernel/ptrace.c                    | 169 ++++
 arch/riscv/kernel/traps.c                     |  11 +-
 arch/riscv/kernel/traps_misaligned.c          |  93 +--
 include/uapi/linux/elf.h                      |   2 +
 tools/include/uapi/linux/elf.h                |   1 +
 tools/perf/tests/tests.h                      |   3 +-
 tools/testing/selftests/riscv/Makefile        |   2 +-
 .../selftests/riscv/breakpoints/.gitignore    |   1 +
 .../selftests/riscv/breakpoints/Makefile      |  12 +
 .../riscv/breakpoints/breakpoint_test.c       | 246 ++++++
 24 files changed, 1657 insertions(+), 191 deletions(-)
 create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
 create mode 100644 arch/riscv/kernel/hw_breakpoint.c
 create mode 100644 arch/riscv/kernel/insn.c
 create mode 100644 tools/testing/selftests/riscv/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/riscv/breakpoints/Makefile
 create mode 100644 tools/testing/selftests/riscv/breakpoints/breakpoint_test.c

-- 
2.43.0


