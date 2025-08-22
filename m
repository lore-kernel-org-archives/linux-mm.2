Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066E1CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42A5E8E00BE; Fri, 22 Aug 2025 13:47:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DAC88E009D; Fri, 22 Aug 2025 13:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9048E00BE; Fri, 22 Aug 2025 13:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1918D8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C0EEAC02B8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:20 +0000 (UTC)
X-FDA: 83805125040.06.C94D94C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1A9EC40008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ehtOZuQ0;
	spf=pass (imf11.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884839; a=rsa-sha256;
	cv=none;
	b=W4tw9A7ESJhMzNNnLbJigfkSwsKkTfr1FTyVCbLZjm8gWOLiP7q4LBJnrGCNnXuFaaUnWe
	sluoBbAtrHgCfMp7rhH792jXQ6KWCLjpfbohd+UcrFoKYN3eFhzMwzJ0e9aAYI3alSHvsC
	BVoYD47hcFa0/D++vTYUbnLjAoxcDe8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ehtOZuQ0;
	spf=pass (imf11.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7xWd683exLd05Xd2k+2/c9D8N3YKjun132TYqkPk7vQ=;
	b=m6Tiyk2KMeR1WVfbSujXC0jiSOP+4Ql7hCQLVKLuCDCsqQHU0RyoSKDkpwWkQx60XCP0od
	nr+uRyb+dqrllD2tYecibk5wrNtpEHz8vSRiAPtv/pn5Zl6LYYZEFeJWzyPcTsHiKcpdiE
	Zy309cgZCLqL2LthS8Put7MQ0gcaaCc=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b109919a09so28982251cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884838; x=1756489638; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7xWd683exLd05Xd2k+2/c9D8N3YKjun132TYqkPk7vQ=;
        b=ehtOZuQ0t+h+vS6oLCnSiIz1hSY+d/vlAH3Lhbl+CXkw/GTGHr2vMhBkgKvxkB/Nyb
         E9mtvAkaDGBZyPH6yDMPxNjTGIBEIkke1X+obqmhSyDCcYkdQgja8+rN3DcEmWzdrMKO
         hTn99UdXbMPAZS0Z79AQFZtTid2uWTv345iDOdnNGBzwDV/MbA0s7oTUSpVbPJZ0bjH8
         9KGV+tUcwM8D6tpXPN84z1y2XRdqT2pQyt/LFfbiEwxpwQYflfirTUfrp4i02Pp8tNm3
         NSblSotTpEuD/AMdIJyRA9RlJf+BDdKnZilrkTIHxAKzMDrpp43Qi/UCGGBs6RK1hlYP
         vSNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884838; x=1756489638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xWd683exLd05Xd2k+2/c9D8N3YKjun132TYqkPk7vQ=;
        b=kaQexMViYmo4eDf1mb4vBRhpVtxwMp2eD1jPizTOTDZTjvGGJdTr+H3MTKRwCqXFoB
         lFzuXWfbo84fKo9Q0tHMDx4QnKhDuD8mGgsYq7L1OqkukMM3cyX4ZEsrN5E0rS3pBTxs
         B/BZVh7fTl+3/Lqn+Xc9Y6Y1NV0XXVy+v717ctqKd94fZ1QITcB3NE8OdudQqwNLnukL
         UOqeyqNAciEgegkc69aC1dwYwG5KBiM/qLZ/+2BHr2K8FPP5mPExyAW3UHu1QOVLbaQJ
         zpxkdBO6RuHbDprG52VswNGej5n4scAmKdt3zqRxgKqn881tk/3FG23v3NmNPvTHmapW
         CKfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWeI4Mx0sw2cvaKkuuwcQHSXFB2FHFcoFSXyaRr2i1SwY+oa8ZMcG5LjFb4/O2AIFIiqWCwM5SIXg==@kvack.org
X-Gm-Message-State: AOJu0YwSk4Iczyuz1X/bl1NERVbYyls+I8Hkl+HTRclADOLgoh+jqM4o
	17OGZt4nvfPYKxUbOyo5OeUcr/IvSJdDSROlqIclLH/m6nBlRiUGIfnIhimMz9gnuwY=
X-Gm-Gg: ASbGnct5dP5Ch573sOMnJpPQVSvoLxfCdqfQ0VH45/dyEIuNGnx/EwdVoRSYVaq9NLX
	hU3E0E2ogByI7lMScmhcz3ulno+hFF1nSNYowpnmmBrD5xcVcEbeB9l2I6xsQtKxgkUyDQvg3r2
	Jm1ZER40zGJr2mQaDTslYcQbWMKfYTN1a2S4VTXb2w+9DJwXLifLov86r4YTPxSEHiNw1rZoF+P
	1bfkoZrUU5u/KftfrtA6JDAavKma9I9AnIZMjtQ9rp4d7KM6EF9o4KxioXYQ7k0+beTUEslw9ah
	S/qp7KxNnU1THiKxNwA79nJ4C/2pha6+T0OWtyT/K43hkpqrezClx2ls5dGEBqINs7qndt5GT+F
	raZSIcq34G4VJuLkSOelIpSBqYbdfIhb3gijOTxtUW2mQ5pfrt7PuLourfQ3uxg1zgamzH7+B/g
	nlz/X+/JdMzdc3Cs8d
X-Google-Smtp-Source: AGHT+IERB8md7pMPxdX8kJ5ivrUWSgGAVukLkHuaDgpDlvNNBoFxuibBgYX+uodyqeWSfvVnl+l5kA==
X-Received: by 2002:a05:622a:1885:b0:4b2:8ac5:2586 with SMTP id d75a77b69052e-4b2aab78821mr43353651cf.77.1755884838018;
        Fri, 22 Aug 2025 10:47:18 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:17 -0700 (PDT)
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
	"Liang Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
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
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 0/8] riscv: add initial support for hardware breakpoints
Date: Fri, 22 Aug 2025 10:47:07 -0700
Message-ID: <20250822174715.1269138-1-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A9EC40008
X-Stat-Signature: ejtf469aa9utrbg5faky88indkhx4je3
X-Rspam-User: 
X-HE-Tag: 1755884838-283572
X-HE-Meta: U2FsdGVkX19R9dMiSpd07S/k8JtvfNDnE7QIXcPJ+XBydi57bjb2+Byz96P7CS/8w7d3GgIFh2YdGH/tAck219HQqR6iPutImNXw7Dx9gYM2TxTaz1wptvT7cOyKW0y7OZF8DJoCPybtzA6uhoEOAzpHAqx8pkztNO5KXKvQ+yIDnKa5s9xIiuEbzbCu7j3togjrk1OoCbfsyQs2Z0M7dxzPKZ0CkrkqlNBQSqZcL4RCOaSeK3Rem1otVU8PQgni8NA+jdvQO/hj/hTykTgDb/qwQdrt0AgGB99rcUYQFTd8gKX5wsZxFl0Mp8nbs4zpZTVMsDjt31IWxTM+GrTeIJcouT8Ju7JRYAYqeLMAObNCw7rMF2Hj4b64RtmwotVmQaleuJ8q009HXQ9DS+C2HXMkDWi8jcHtS11OS/wFy3TRZZAc5g5QIyfeLBXUJKHNvKJ3Lk1rhrm8nG2F6zXK5ShltSw1k7CT+/F5aoU8WDG+H9amfXH5HR+YueGJAqZoWCCUyNPFx/dA3L1rGDVfBx9nQAW42317RoE8hPETuCF58UMzHAaNsK7JOVDnVDRZOtbouyah01/cwzKoXn2zHgaYAhEoC1gdFBOeQ3OjTmKSVG0/ny2Y+ctVMqDWX6CJ4QGytj9XDXbRHDpFcDWQ0G8DJJTZ3EBzoTTGgnQgB/kWYYuuNm5bP8nHVmxg9jtSZSGqUbp16qHz4Ff2/EkMV4un7L6K/i95viIdAxuN7jUbYwXAJGNSIxgC2FmGF7K8PfsjxjQH7R7zFyebcsMwHbqB8wjix3pIaokiDpo0uLQeamMcVEI5vOCpTbwWYN6Ik39JXwtC9UQK04f1SKQ/MqESGYts0MCwgQSn5GBB5JDwmv6RmD0/7NFIeXPHj6ey2EnPJJkc/+FVZ+zYS9X4bhyzK4BaG9QC+REaaCcJofiPrMEDL9NEhqj2Ouyddxv1VAX5/cJ66xQKhrf7Sxo
 VJUKZ0gv
 8AhmJbcsrIZfvYbkZVGT2N7UJrA==
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

 arch/riscv/Kconfig                            |   2 +
 arch/riscv/include/asm/bug.h                  |  12 -
 arch/riscv/include/asm/hw_breakpoint.h        |  59 ++
 arch/riscv/include/asm/insn.h                 | 132 ++-
 arch/riscv/include/asm/kdebug.h               |   3 +-
 arch/riscv/include/asm/processor.h            |   4 +
 arch/riscv/include/asm/sbi.h                  |  33 +-
 arch/riscv/include/uapi/asm/ptrace.h          |   9 +
 arch/riscv/kernel/Makefile                    |   2 +
 arch/riscv/kernel/hw_breakpoint.c             | 763 ++++++++++++++++++
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
 .../selftests/riscv/breakpoints/Makefile      |  13 +
 .../riscv/breakpoints/breakpoint_test.c       | 246 ++++++
 24 files changed, 1641 insertions(+), 191 deletions(-)
 create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
 create mode 100644 arch/riscv/kernel/hw_breakpoint.c
 create mode 100644 arch/riscv/kernel/insn.c
 create mode 100644 tools/testing/selftests/riscv/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/riscv/breakpoints/Makefile
 create mode 100644 tools/testing/selftests/riscv/breakpoints/breakpoint_test.c

-- 
2.43.0


