Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C645CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786638E00C2; Fri, 22 Aug 2025 13:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F708E009D; Fri, 22 Aug 2025 13:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CEA8E00C2; Fri, 22 Aug 2025 13:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA6C8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D8854B738B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:30 +0000 (UTC)
X-FDA: 83805125460.02.B5DF838
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 25D8A160004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="PH08/LEy";
	spf=pass (imf08.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fOsch9BTYSqQ7yHbVB1d7sGG+vsty5tD44+7UPMzgWI=;
	b=pa8qq5JNXX4aknP6peP5ilBMY+yGRlB78wRgoo702Pmw7scd99CJ395R32IU2hprwS2ix7
	Ru2twK31JQULdJ3XIyqBSv5EcBP+twTdMY0oQ9nh9uR2WpSJcL1MQd7ZfzkBMHihUljizz
	KTbOQVBDxvy41noHE5WzeggxNfTMq9w=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="PH08/LEy";
	spf=pass (imf08.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884849; a=rsa-sha256;
	cv=none;
	b=GevI8eXIJk9vINpKDkbY20DHGDuS7SGRKbGmI1lrsRt3m2B56jfq4LFh8wA4E6ByRT6W2U
	jbjyj/VTBwLCU2SSYmkPI43dl0z2kVnm73mbYElWaJ3XTXFS/7eUw6L40w4CBycIrtZclJ
	r6oFwbysHFCCaXSRqsFMLShMMyDx9cw=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b109c6532fso27387991cf.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884848; x=1756489648; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fOsch9BTYSqQ7yHbVB1d7sGG+vsty5tD44+7UPMzgWI=;
        b=PH08/LEySZ7tU6EnheYm0gTOmNhIz0Zch3TihUwd9SajZwgJLcuGvmy6U1JJpkLSZ+
         GQJhWaC2ilXY2P9McuRkT1kKmIIizW0jqouGwaTsxHrAzYbgpUMYXXQTQcg/jNqWLUK6
         LUWTIFZHQhHtkBVskiVbdSS/sIBuNA+0LKV3usQE63Rnhlji8UmVf5C6j2KBY7xnz+m8
         HxcPej1P2OzATBs3x03GZuuC714AwFP4cImxEOd3OSxB+rV2p6diRHT86pus6Au4QwHw
         yEV9TpC1B9kKKc6NBWOeVeirQsBgB4LLnVerY8VoD53KrURgKL8q9bfTnaCEnxx+z0Qv
         6z1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884848; x=1756489648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fOsch9BTYSqQ7yHbVB1d7sGG+vsty5tD44+7UPMzgWI=;
        b=NQBGMxP8+987aZAZLDvVoAAZQDDM+mTgS57IdtguA51R6F9fP0FN4shq8lUFf2PLjJ
         0v0FPiouG2fw933xdQmSWZl7L1+Cq6ulk0IueMLgtUi+i3rZc09/MvEqMBa0JmovYxGb
         cY8OzAyadub4/Rbx3qlprcob6WooeOkxx7YiMLPprd4ezutqPno1Nrl5hYX+mx7x7wTa
         hPRJPr4vJVmp3Wg3vN/t9AeZcMgp4+qA0SPWehVDfOR7+CF5OWfZh6UXy9eng4NsfDny
         lnA/YCJPBYexMPsu0Vv1kSRXxIBGJe8UFdOswRCbZm0MREZP29tiGJn7awA7fbNhxDo2
         edtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV/y2iqwOZJh9K6Nc+180z5hB7yBgbIut/wm4TP5kMRvP5zRsuUcEPp8LhQK2JnYfpAAILqlnXhg==@kvack.org
X-Gm-Message-State: AOJu0YxnTLVBgV/kexvPJ45bx1FmAgVXj1L7zhU3D8cw3mlof3GKs/QN
	8EXv+SRm4xPZYU7lt0y4NAQp7tzAzjRXDOaN0mE/63BvFaWE7P1bsgq5cOYXERJ9Un0=
X-Gm-Gg: ASbGncsmvQuC0AaGi/MYOJXiAha0oAhr7/JJFyctFwWDgxWQBwuoaGAhfieOocfvx0s
	tJdwm0JvPKtOhgGOfzNEu5KRszn7C/f3TscPXANmBZjI65simyQ+9OHyqMCh34kTH0LNM760kZp
	/7+niXHIHLpgvjBq4OXSNWI2g5VSTDw45JrbjIuckcCtBlCeTNrpvsVP3CvAd5sOv5RE58lJFis
	K9/uq9Q4mO/T3hZkZRBCV29czmPVF4b1/jFngIuuHDHc9zGp4LjZftuKfIarH8BgXKdFaPha7eM
	SsVOxA5SyewIYaXVxg0/cXtDpxYbNaZadKlWWI96SAXNKI85Z9/v69D4UwfgqNxg/NXSZ9GYPH+
	zy5+Q7Je868OpQCPbejCOrUXq6KQV0k+Juh4uC1Hq0L1MqGvchuYCYjRevjCFzopOAhsN1pjVvn
	NOAEG90Q==
X-Google-Smtp-Source: AGHT+IHPnKj86bXuhSb+aVxY48yHR1TxfG62VZSUdYoVpxtQs3hsSZOq4XaawpO4CeN8AVMNRCbEEw==
X-Received: by 2002:a05:622a:558d:b0:4b0:aa78:d770 with SMTP id d75a77b69052e-4b2aab3d156mr48000291cf.49.1755884847368;
        Fri, 22 Aug 2025 10:47:27 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:27 -0700 (PDT)
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
Subject: [PATCH 4/8] riscv: Introduce support for hardware break/watchpoints
Date: Fri, 22 Aug 2025 10:47:11 -0700
Message-ID: <20250822174715.1269138-5-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25D8A160004
X-Stat-Signature: tqmfrrc89zshrygmxc8n5mahbzu683rz
X-Rspam-User: 
X-HE-Tag: 1755884848-957217
X-HE-Meta: U2FsdGVkX1/XsSh8zNsbiSCYKf39KJ9Ld2VxPWamtAnUPcerrmuqQU7ozLELpGtJeaAD3yJa6xRTKg5ROCoMcVPTSFfY3PAwbEQTHHwmDAPhZG0VxJAcMYbUuL+w2DjwsouQ0kISfTmVEP8mwhH+O05jtq/GcKtV5lUL07+tB2aHsQDcYTAgu166o2yQ4sBWg9cruOOl8lSJ41Q6p6i1UxEg59KupkZOheV8O3Xr0pb1bTL+jZE5xqtBEBVev/5DDJwQOJMQndAkF5a6xZYFa6ibDlksvAKygVk0JcDI7pnplcKNWSAdHP9FW2wTLg8FvTA7fKqlAIoUzt8Tq1n9szFY6eYDa8beP5UL8qC0/Y6STmnx/ec4uoD+ZtSWsYl6jLDvZuegYFjOFXt1grXkGpgl0ShrixhprJUGlXtqTooEkUW+jvg56LNe/FC0EWjsVcWbA1zsxYKfjx8JIg62rF6h4LNcfEjQc6fOhvUD1ggEXUKPy3OCrN83ofS0+g+cojHhHoLkZP89SDFegAvcAlSqfSLz63D0V2k2bWV20xsvoOpEXWkffy7RrbrbXqe//zY7OnSyyixhAooToa3V1HTjJON9Rfg3fmJZU7xHMvBCO1baAmq86gJkEfNJluxEctzIhOXb3C2M9Cu1cKVZJuXIEMHG5jQ517UASkrsLWgA6D8iBCMotidx6fh37yS2kXLMlm9bKmSLjntZksSQ6WVCJJ8PWIQs7hPcPHKjVSgDgS4mjWt2h5U9e1/0e+oRrpGBUncnsyj3a+GtptG14gP7wHepc6QSDbDyLQQjoxG39CFtl0vGVFsi63tCTAU0BTnuOxT0ZN1F1ACZkCAkUE26iy5W4yQsOYHavSg+32gC7xRs9mMnR5z/Ss4lKHKFO0FAwFE81Lou9kzOgEXFWk3ldKXMNMhRx5DMDhbchf2AaR8NiSZizyg1T6IJRVMBPIwKs1t8EnZAfvl+L74
 Mk6b3k4e
 K12ubyRowwDBC2OIL+lx0TpeCaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Himanshu Chauhan <hchauhan@ventanamicro.com>

RISC-V hardware breakpoint framework is built on top of perf subsystem and uses
SBI debug trigger extension to install/uninstall/update/enable/disable hardware
triggers as specified in Sdtrig ISA extension.

Signed-off-by: Himanshu Chauhan <hchauhan@ventanamicro.com>
Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
RFC -> V1:
 - Add dbtr_mode to rv_init_mcontrol(6)_trigger
 - Add select HAVE_MIXED_BREAKPOINTS_REGS
 - Add TDATA1_MCTRL_SZ and TDATA1_MCTRL6_SZ
 - Capitalize F in Fallback comment
 - Fix in_callback code to allow multiple breakpoints
 - Move perf_bp_event above setup_singlestep to save the correct state
 - Use sbi_err_map_linux_errno for arch_smp_teardown/setup_sbi_shmem
V1 -> V2:
 - No change
---
 arch/riscv/Kconfig                     |   2 +
 arch/riscv/include/asm/hw_breakpoint.h |  59 +++
 arch/riscv/include/asm/kdebug.h        |   3 +-
 arch/riscv/include/asm/sbi.h           |   4 +-
 arch/riscv/kernel/Makefile             |   1 +
 arch/riscv/kernel/hw_breakpoint.c      | 614 +++++++++++++++++++++++++
 arch/riscv/kernel/traps.c              |   6 +
 7 files changed, 687 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
 create mode 100644 arch/riscv/kernel/hw_breakpoint.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index bbec87b79309..fd8b62cdc6f5 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -163,6 +163,7 @@ config RISCV
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_GCC_PLUGINS
 	select HAVE_GENERIC_VDSO if MMU && 64BIT
+	select HAVE_HW_BREAKPOINT if PERF_EVENTS && RISCV_SBI
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KERNEL_BZIP2 if !XIP_KERNEL && !EFI_ZBOOT
 	select HAVE_KERNEL_GZIP if !XIP_KERNEL && !EFI_ZBOOT
@@ -176,6 +177,7 @@ config RISCV
 	select HAVE_KRETPROBES if !XIP_KERNEL
 	# https://github.com/ClangBuiltLinux/linux/issues/1881
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !LD_IS_LLD
+	select HAVE_MIXED_BREAKPOINTS_REGS
 	select HAVE_MOVE_PMD
 	select HAVE_MOVE_PUD
 	select HAVE_PAGE_SIZE_4KB
diff --git a/arch/riscv/include/asm/hw_breakpoint.h b/arch/riscv/include/asm/hw_breakpoint.h
new file mode 100644
index 000000000000..cde6688b91d2
--- /dev/null
+++ b/arch/riscv/include/asm/hw_breakpoint.h
@@ -0,0 +1,59 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 Ventana Micro Systems Inc.
+ */
+
+#ifndef __RISCV_HW_BREAKPOINT_H
+#define __RISCV_HW_BREAKPOINT_H
+
+struct task_struct;
+
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+
+#include <uapi/linux/hw_breakpoint.h>
+
+#if __riscv_xlen == 64
+#define cpu_to_le cpu_to_le64
+#define le_to_cpu le64_to_cpu
+#elif __riscv_xlen == 32
+#define cpu_to_le cpu_to_le32
+#define le_to_cpu le32_to_cpu
+#else
+#error "Unexpected __riscv_xlen"
+#endif
+
+struct arch_hw_breakpoint {
+	unsigned long address;
+	unsigned long len;
+
+	/* Callback info */
+	unsigned long next_addr;
+	bool in_callback;
+
+	/* Trigger configuration data */
+	unsigned long tdata1;
+	unsigned long tdata2;
+	unsigned long tdata3;
+};
+
+/* Maximum number of hardware breakpoints supported */
+#define RV_MAX_TRIGGERS 32
+
+struct perf_event_attr;
+struct notifier_block;
+struct perf_event;
+struct pt_regs;
+
+int hw_breakpoint_slots(int type);
+int arch_check_bp_in_kernelspace(struct arch_hw_breakpoint *hw);
+int hw_breakpoint_arch_parse(struct perf_event *bp,
+			     const struct perf_event_attr *attr,
+			     struct arch_hw_breakpoint *hw);
+int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+				    unsigned long val, void *data);
+int arch_install_hw_breakpoint(struct perf_event *bp);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp);
+void hw_breakpoint_pmu_read(struct perf_event *bp);
+
+#endif /* CONFIG_HAVE_HW_BREAKPOINT */
+#endif /* __RISCV_HW_BREAKPOINT_H */
diff --git a/arch/riscv/include/asm/kdebug.h b/arch/riscv/include/asm/kdebug.h
index 85ac00411f6e..53e989781aa1 100644
--- a/arch/riscv/include/asm/kdebug.h
+++ b/arch/riscv/include/asm/kdebug.h
@@ -6,7 +6,8 @@
 enum die_val {
 	DIE_UNUSED,
 	DIE_TRAP,
-	DIE_OOPS
+	DIE_OOPS,
+	DIE_DEBUG
 };
 
 #endif
diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
index be2ca8e8a49e..64fa7a82aa45 100644
--- a/arch/riscv/include/asm/sbi.h
+++ b/arch/riscv/include/asm/sbi.h
@@ -282,7 +282,9 @@ struct sbi_sta_struct {
 	u8 pad[47];
 } __packed;
 
-#define SBI_SHMEM_DISABLE		-1
+#define SBI_SHMEM_DISABLE	(-1UL)
+#define SBI_SHMEM_LO(pa)	((unsigned long)lower_32_bits(pa))
+#define SBI_SHMEM_HI(pa)	((unsigned long)upper_32_bits(pa))
 
 enum sbi_ext_nacl_fid {
 	SBI_EXT_NACL_PROBE_FEATURE = 0x0,
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 4f719b09e5ad..3e72505734bd 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_DYNAMIC_FTRACE)	+= mcount-dyn.o
 
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 obj-$(CONFIG_HAVE_PERF_REGS)	+= perf_regs.o
+obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
 obj-$(CONFIG_RISCV_SBI)		+= sbi.o sbi_ecall.o
 ifeq ($(CONFIG_RISCV_SBI), y)
 obj-$(CONFIG_SMP)		+= sbi-ipi.o
diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
new file mode 100644
index 000000000000..3f96e744a711
--- /dev/null
+++ b/arch/riscv/kernel/hw_breakpoint.c
@@ -0,0 +1,614 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2024 Ventana Micro Systems Inc.
+ */
+
+#include <linux/hw_breakpoint.h>
+#include <linux/perf_event.h>
+#include <linux/spinlock.h>
+#include <linux/percpu.h>
+#include <linux/kdebug.h>
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+#include <linux/cpu.h>
+#include <linux/cpuhotplug.h>
+
+#include <asm/insn.h>
+#include <asm/sbi.h>
+
+#define DBTR_TDATA1_TYPE_SHIFT		(__riscv_xlen - 4)
+#define DBTR_TDATA1_DMODE		BIT_UL(__riscv_xlen - 5)
+
+#define DBTR_TDATA1_TYPE_MCONTROL	(2UL << DBTR_TDATA1_TYPE_SHIFT)
+#define DBTR_TDATA1_TYPE_MCONTROL6	(6UL << DBTR_TDATA1_TYPE_SHIFT)
+
+#define DBTR_TDATA1_MCONTROL6_LOAD		BIT(0)
+#define DBTR_TDATA1_MCONTROL6_STORE		BIT(1)
+#define DBTR_TDATA1_MCONTROL6_EXECUTE		BIT(2)
+#define DBTR_TDATA1_MCONTROL6_U			BIT(3)
+#define DBTR_TDATA1_MCONTROL6_S			BIT(4)
+#define DBTR_TDATA1_MCONTROL6_M			BIT(6)
+#define DBTR_TDATA1_MCONTROL6_SIZE_FIELD	GENMASK(18, 16)
+#define DBTR_TDATA1_MCONTROL6_SELECT		BIT(21)
+#define DBTR_TDATA1_MCONTROL6_VU		BIT(23)
+#define DBTR_TDATA1_MCONTROL6_VS		BIT(24)
+
+#define DBTR_TDATA1_MCONTROL6_SIZE_8BIT		1
+#define DBTR_TDATA1_MCONTROL6_SIZE_16BIT	2
+#define DBTR_TDATA1_MCONTROL6_SIZE_32BIT	3
+#define DBTR_TDATA1_MCONTROL6_SIZE_64BIT	5
+
+#define TDATA1_MCTRL6_SZ(sz) \
+	FIELD_PREP(DBTR_TDATA1_MCONTROL6_SIZE_FIELD, sz)
+
+#define DBTR_TDATA1_MCONTROL_LOAD		BIT(0)
+#define DBTR_TDATA1_MCONTROL_STORE		BIT(1)
+#define DBTR_TDATA1_MCONTROL_EXECUTE		BIT(2)
+#define DBTR_TDATA1_MCONTROL_U			BIT(3)
+#define DBTR_TDATA1_MCONTROL_S			BIT(4)
+#define DBTR_TDATA1_MCONTROL_M			BIT(6)
+#define DBTR_TDATA1_MCONTROL_SIZELO_FIELD	GENMASK(17, 16)
+#define DBTR_TDATA1_MCONTROL_SELECT		BIT(19)
+#define DBTR_TDATA1_MCONTROL_SIZEHI_FIELD	GENMASK(22, 21)
+
+#define DBTR_TDATA1_MCONTROL_SIZELO_8BIT	1
+#define DBTR_TDATA1_MCONTROL_SIZELO_16BIT	2
+#define DBTR_TDATA1_MCONTROL_SIZELO_32BIT	3
+/* value of 5 split across HI and LO */
+#define DBTR_TDATA1_MCONTROL_SIZELO_64BIT	1
+#define DBTR_TDATA1_MCONTROL_SIZEHI_64BIT	1
+
+#define TDATA1_MCTRL_SZ(lo, hi) \
+	(FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZELO_FIELD, lo) | \
+	 FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZEHI_FIELD, hi))
+
+enum dbtr_mode {
+	DBTR_MODE_U = 0,
+	DBTR_MODE_S,
+	DBTR_MODE_VS,
+	DBTR_MODE_VU,
+};
+
+/* Registered per-cpu bp/wp */
+static DEFINE_PER_CPU(struct perf_event *, pcpu_hw_bp_events[RV_MAX_TRIGGERS]);
+static DEFINE_PER_CPU(unsigned long, ecall_lock_flags);
+static DEFINE_PER_CPU(raw_spinlock_t, ecall_lock);
+
+/* Per-cpu shared memory between S and M mode */
+static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry, sbi_dbtr_shmem);
+
+/* number of debug triggers on this cpu . */
+static int dbtr_total_num __ro_after_init;
+static unsigned long dbtr_type __ro_after_init;
+static unsigned long dbtr_init __ro_after_init;
+
+static int arch_smp_setup_sbi_shmem(unsigned int cpu)
+{
+	union sbi_dbtr_shmem_entry *dbtr_shmem;
+	unsigned long shmem_pa;
+	struct sbiret ret;
+	int rc;
+
+	dbtr_shmem = per_cpu_ptr(&sbi_dbtr_shmem, cpu);
+	if (!dbtr_shmem) {
+		pr_err("Invalid per-cpu shared memory for debug triggers\n");
+		return -ENODEV;
+	}
+
+	shmem_pa = virt_to_phys(dbtr_shmem);
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_SETUP_SHMEM,
+			SBI_SHMEM_LO(shmem_pa), SBI_SHMEM_HI(shmem_pa), 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to setup shared memory. error: %ld\n", __func__, ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	pr_debug("CPU %d: HW Breakpoint shared memory registered.\n", cpu);
+
+	return rc;
+}
+
+static int arch_smp_teardown_sbi_shmem(unsigned int cpu)
+{
+	struct sbiret ret;
+
+	/* Disable shared memory */
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_SETUP_SHMEM,
+			SBI_SHMEM_DISABLE, SBI_SHMEM_DISABLE, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to teardown shared memory. error: %ld\n", __func__, ret.error);
+		return sbi_err_map_linux_errno(ret.error);
+	}
+
+	pr_debug("CPU %d: HW Breakpoint shared memory disabled.\n", cpu);
+
+	return 0;
+}
+
+static void init_sbi_dbtr(void)
+{
+	struct sbiret ret;
+
+	/*
+	 * Called by hw_breakpoint_slots and arch_hw_breakpoint_init.
+	 * Only proceed if this is the first CPU to reach this code.
+	 */
+	if (test_and_set_bit(0, &dbtr_init))
+		return;
+
+	if (sbi_probe_extension(SBI_EXT_DBTR) <= 0) {
+		pr_debug("%s: SBI_EXT_DBTR is not supported\n", __func__);
+		dbtr_total_num = 0;
+		return;
+	}
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
+			DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to detect mcontrol6 triggers. error: %ld.\n",
+			__func__, ret.error);
+	} else if (!ret.value) {
+		pr_warn("%s: No mcontrol6 triggers available.\n", __func__);
+	} else {
+		dbtr_total_num = ret.value;
+		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL6;
+		return;
+	}
+
+	/* Fallback to legacy mcontrol triggers if mcontrol6 is not available */
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
+			DBTR_TDATA1_TYPE_MCONTROL, 0, 0, 0, 0, 0);
+	if (ret.error) {
+		pr_warn("%s: failed to detect mcontrol triggers. error: %ld.\n",
+			__func__, ret.error);
+	} else if (!ret.value) {
+		pr_err("%s: No mcontrol triggers available.\n", __func__);
+		dbtr_total_num = 0;
+	} else {
+		dbtr_total_num = ret.value;
+		dbtr_type = DBTR_TDATA1_TYPE_MCONTROL;
+	}
+}
+
+int hw_breakpoint_slots(int type)
+{
+	/*
+	 * We can be called early, so don't rely on
+	 * static variables being initialised.
+	 */
+	init_sbi_dbtr();
+
+	return dbtr_total_num;
+}
+
+int arch_check_bp_in_kernelspace(struct arch_hw_breakpoint *hw)
+{
+	unsigned int len;
+	unsigned long va;
+
+	va = hw->address;
+	len = hw->len;
+
+	return (va >= TASK_SIZE) && ((va + len - 1) >= TASK_SIZE);
+}
+
+static int rv_init_mcontrol_trigger(const struct perf_event_attr *attr,
+				    struct arch_hw_breakpoint *hw, enum dbtr_mode mode)
+{
+	unsigned long tdata1 = DBTR_TDATA1_TYPE_MCONTROL;
+
+	switch (attr->bp_type) {
+	case HW_BREAKPOINT_X:
+		tdata1 |= DBTR_TDATA1_MCONTROL_EXECUTE;
+		break;
+	case HW_BREAKPOINT_R:
+		tdata1 |= DBTR_TDATA1_MCONTROL_LOAD;
+		break;
+	case HW_BREAKPOINT_W:
+		tdata1 |= DBTR_TDATA1_MCONTROL_STORE;
+		break;
+	case HW_BREAKPOINT_RW:
+		tdata1 |= DBTR_TDATA1_MCONTROL_STORE | DBTR_TDATA1_MCONTROL_LOAD;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (attr->bp_len) {
+	case HW_BREAKPOINT_LEN_1:
+		hw->len = 1;
+		tdata1 |= TDATA1_MCTRL_SZ(DBTR_TDATA1_MCONTROL_SIZELO_8BIT, 0);
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		hw->len = 2;
+		tdata1 |= TDATA1_MCTRL_SZ(DBTR_TDATA1_MCONTROL_SIZELO_16BIT, 0);
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		hw->len = 4;
+		tdata1 |= TDATA1_MCTRL_SZ(DBTR_TDATA1_MCONTROL_SIZELO_32BIT, 0);
+		break;
+#if __riscv_xlen >= 64
+	case HW_BREAKPOINT_LEN_8:
+		hw->len = 8;
+		tdata1 |= TDATA1_MCTRL_SZ(DBTR_TDATA1_MCONTROL_SIZELO_64BIT,
+					  DBTR_TDATA1_MCONTROL_SIZEHI_64BIT);
+		break;
+#endif
+	default:
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case DBTR_MODE_U:
+		tdata1 |= DBTR_TDATA1_MCONTROL_U;
+		break;
+	case DBTR_MODE_S:
+		tdata1 |= DBTR_TDATA1_MCONTROL_S;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hw->tdata1 = tdata1;
+
+	return 0;
+}
+
+static int rv_init_mcontrol6_trigger(const struct perf_event_attr *attr,
+				     struct arch_hw_breakpoint *hw, enum dbtr_mode mode)
+{
+	unsigned long tdata1 = DBTR_TDATA1_TYPE_MCONTROL;
+
+	switch (attr->bp_type) {
+	case HW_BREAKPOINT_X:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_EXECUTE;
+		break;
+	case HW_BREAKPOINT_R:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_LOAD;
+		break;
+	case HW_BREAKPOINT_W:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_STORE;
+		break;
+	case HW_BREAKPOINT_RW:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_STORE | DBTR_TDATA1_MCONTROL6_LOAD;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (attr->bp_len) {
+	case HW_BREAKPOINT_LEN_1:
+		hw->len = 1;
+		tdata1 |= TDATA1_MCTRL6_SZ(DBTR_TDATA1_MCONTROL6_SIZE_8BIT);
+		break;
+	case HW_BREAKPOINT_LEN_2:
+		hw->len = 2;
+		tdata1 |= TDATA1_MCTRL6_SZ(DBTR_TDATA1_MCONTROL6_SIZE_16BIT);
+		break;
+	case HW_BREAKPOINT_LEN_4:
+		hw->len = 4;
+		tdata1 |= TDATA1_MCTRL6_SZ(DBTR_TDATA1_MCONTROL6_SIZE_32BIT);
+		break;
+	case HW_BREAKPOINT_LEN_8:
+		hw->len = 8;
+		tdata1 |= TDATA1_MCTRL6_SZ(DBTR_TDATA1_MCONTROL6_SIZE_64BIT);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (mode) {
+	case DBTR_MODE_U:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_U;
+		break;
+	case DBTR_MODE_S:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_S;
+		break;
+	case DBTR_MODE_VS:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_VS;
+		break;
+	case DBTR_MODE_VU:
+		tdata1 |= DBTR_TDATA1_MCONTROL6_VU;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	hw->tdata1 = tdata1;
+
+	return 0;
+}
+
+int hw_breakpoint_arch_parse(struct perf_event *bp,
+			     const struct perf_event_attr *attr,
+			     struct arch_hw_breakpoint *hw)
+{
+	int ret;
+
+	/* Breakpoint address */
+	hw->address = attr->bp_addr;
+	hw->tdata2 = attr->bp_addr;
+	hw->tdata3 = 0x0;
+	hw->next_addr = 0x0;
+	hw->in_callback = false;
+
+	switch (dbtr_type) {
+	case DBTR_TDATA1_TYPE_MCONTROL:
+		ret = rv_init_mcontrol_trigger(attr, hw, DBTR_MODE_U);
+		break;
+	case DBTR_TDATA1_TYPE_MCONTROL6:
+		ret = rv_init_mcontrol6_trigger(attr, hw, DBTR_MODE_U);
+		break;
+	default:
+		pr_warn("Unsupported trigger type %lu.\n", dbtr_type >> DBTR_TDATA1_TYPE_SHIFT);
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * setup_singlestep - Update breakpoint to next instruction after breakpoint.
+ * @event: Perf event to change
+ * @regs: regs at breakpoint
+ *
+ * Update breakpoint to next instruction that would have
+ * executed after the current breakpoint.
+ *
+ * This allows for single-stepping the instruction being debugged.
+ * Then restoring the original breakpoint.
+ *
+ * Returns Zero on success, negative on failure
+ */
+static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+	struct perf_event_attr bp_insn;
+	unsigned long insn, next_addr = 0;
+	int ret;
+
+	/* Remove breakpoint even if return error as not to loop */
+	arch_uninstall_hw_breakpoint(event);
+
+	ret = get_insn_nofault(regs, regs->epc, &insn);
+	if (ret < 0)
+		return ret;
+
+	next_addr = get_step_address(regs, insn);
+
+	ret = get_insn_nofault(regs, next_addr, &insn);
+	if (ret < 0)
+		return ret;
+
+	bp_insn.bp_type = HW_BREAKPOINT_X;
+	bp_insn.bp_addr = next_addr;
+	/* Get the size of the intruction */
+	bp_insn.bp_len = GET_INSN_LENGTH(insn);
+
+	ret = hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
+	if (ret)
+		return ret;
+
+	ret = arch_install_hw_breakpoint(event);
+	if (ret)
+		return ret;
+
+	bp->in_callback = true;
+	bp->next_addr = next_addr;
+	return 0;
+}
+
+/*
+ * HW Breakpoint/watchpoint handler
+ */
+static int hw_breakpoint_handler(struct pt_regs *regs)
+{
+	int i, ret = 0, bp_ret = NOTIFY_DONE;
+	bool expecting_callback = false;
+	struct arch_hw_breakpoint *bp;
+	struct perf_event *event;
+
+	for (i = 0; i < dbtr_total_num; i++) {
+		event = this_cpu_read(pcpu_hw_bp_events[i]);
+		if (!event)
+			continue;
+
+		bp = counter_arch_bp(event);
+		switch (event->attr.bp_type) {
+		/* Breakpoint */
+		case HW_BREAKPOINT_X:
+			if (event->attr.bp_addr == regs->epc) {
+				perf_bp_event(event, regs);
+				ret = setup_singlestep(event, regs);
+				if (ret < 0) {
+					pr_err("%s: setup_singlestep failed %d.\n", __func__, ret);
+					goto exit;
+				}
+
+				bp_ret = NOTIFY_STOP;
+				goto exit;
+			}
+			break;
+
+		/* Watchpoint */
+		case HW_BREAKPOINT_W:
+		case HW_BREAKPOINT_R:
+		case HW_BREAKPOINT_RW:
+			/* Watchpoints will trigger on smaller loads than the given type.
+			 * To allow for this, check if the load was within the size of
+			 * the type. Cast badaddr to the type of bp_addr.
+			 */
+			if (abs_diff(event->attr.bp_addr, (__u64)regs->badaddr) < bp->len) {
+				perf_bp_event(event, regs);
+				ret = setup_singlestep(event, regs);
+				if (ret < 0) {
+					pr_err("%s: setup_singlestep failed %d.\n", __func__, ret);
+					goto exit;
+				}
+
+				bp_ret = NOTIFY_STOP;
+				goto exit;
+			}
+			break;
+
+		default:
+			pr_warn("%s: Unknown type: %u\n", __func__, event->attr.bp_type);
+			goto exit;
+		}
+
+		if (bp->in_callback) {
+			expecting_callback = true;
+			if (regs->epc != bp->next_addr) {
+				continue;
+			}
+
+			arch_uninstall_hw_breakpoint(event);
+			/* Restore original breakpoint */
+			if (hw_breakpoint_arch_parse(NULL, &event->attr, bp))
+				goto exit;
+			if (arch_install_hw_breakpoint(event))
+				goto exit;
+
+			bp_ret = NOTIFY_STOP;
+			goto exit;
+		}
+
+	}
+
+	if (expecting_callback) {
+		pr_err("%s: in_callback was set, but epc (%lx) was not at next address(%lx).\n",
+		       __func__, regs->epc, bp->next_addr);
+	}
+exit:
+	return bp_ret;
+
+}
+
+int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
+				    unsigned long val, void *data)
+{
+	struct die_args *args = data;
+
+	if (val != DIE_DEBUG)
+		return NOTIFY_DONE;
+
+	return hw_breakpoint_handler(args->regs);
+}
+
+/* atomic: counter->ctx->lock is held */
+int arch_install_hw_breakpoint(struct perf_event *event)
+{
+	struct arch_hw_breakpoint *bp = counter_arch_bp(event);
+	union sbi_dbtr_shmem_entry *shmem = this_cpu_ptr(&sbi_dbtr_shmem);
+	struct sbi_dbtr_data_msg *xmit;
+	struct sbi_dbtr_id_msg *recv;
+	struct perf_event **slot;
+	unsigned long idx;
+	struct sbiret ret;
+	int err = 0;
+
+	raw_spin_lock_irqsave(this_cpu_ptr(&ecall_lock),
+			      *this_cpu_ptr(&ecall_lock_flags));
+
+	xmit = &shmem->data;
+	recv = &shmem->id;
+	xmit->tdata1 = cpu_to_le(bp->tdata1);
+	xmit->tdata2 = cpu_to_le(bp->tdata2);
+	xmit->tdata3 = cpu_to_le(bp->tdata3);
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_INSTALL,
+			1, 0, 0, 0, 0, 0);
+
+	if (ret.error) {
+		pr_warn("%s: failed to install trigger. error: %ld\n", __func__, ret.error);
+		err = sbi_err_map_linux_errno(ret.error);
+		goto done;
+	}
+
+	idx = le_to_cpu(recv->idx);
+	if (idx >= dbtr_total_num) {
+		pr_warn("%s: invalid trigger index %lu\n", __func__, idx);
+		err = -EINVAL;
+		goto done;
+	}
+
+	slot = this_cpu_ptr(&pcpu_hw_bp_events[idx]);
+	if (*slot) {
+		pr_warn("%s: slot %lu is in use\n", __func__, idx);
+		err = -EBUSY;
+		goto done;
+	}
+
+	pr_debug("Trigger 0x%lx installed at index 0x%lx\n", bp->tdata2, idx);
+
+	/* Save the event - to be looked up in handler */
+	*slot = event;
+
+done:
+	raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock),
+				   *this_cpu_ptr(&ecall_lock_flags));
+	return err;
+}
+
+void arch_uninstall_hw_breakpoint(struct perf_event *event)
+{
+	struct perf_event **slot;
+	struct sbiret ret;
+	int i;
+
+	for (i = 0; i < dbtr_total_num; i++) {
+		slot = this_cpu_ptr(&pcpu_hw_bp_events[i]);
+
+		if (*slot == event) {
+			*slot = NULL;
+			break;
+		}
+	}
+
+	if (i == dbtr_total_num) {
+		pr_warn("%s: Breakpoint not installed.\n", __func__);
+		return;
+	}
+
+	ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_UNINSTALL,
+			i, 1, 0, 0, 0, 0);
+	if (ret.error)
+		pr_warn("%s: Failed to uninstall trigger %d. error: %ld\n", __func__, i, ret.error);
+}
+
+void flush_ptrace_hw_breakpoint(struct task_struct *tsk) { }
+
+void hw_breakpoint_pmu_read(struct perf_event *bp) { }
+
+static int __init arch_hw_breakpoint_init(void)
+{
+	unsigned int cpu;
+	int rc = 0;
+
+	for_each_possible_cpu(cpu)
+		raw_spin_lock_init(&per_cpu(ecall_lock, cpu));
+
+	init_sbi_dbtr();
+
+	if (dbtr_total_num) {
+		pr_debug("%s: total number of type %lu triggers: %u\n",
+			__func__, dbtr_type >> DBTR_TDATA1_TYPE_SHIFT, dbtr_total_num);
+	} else {
+		pr_debug("%s: No hardware triggers available\n", __func__);
+		return rc;
+	}
+
+	/* Hotplug handler to register/unregister shared memory with SBI */
+	rc = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+			       "riscv/hw_breakpoint:prepare",
+			       arch_smp_setup_sbi_shmem,
+			       arch_smp_teardown_sbi_shmem);
+
+	if (rc < 0)
+		pr_warn("%s: Failed to setup CPU hotplug state\n", __func__);
+
+	return rc;
+}
+arch_initcall(arch_hw_breakpoint_init);
diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 938a8b841f94..2ac471ec79a8 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -289,6 +289,12 @@ void handle_break(struct pt_regs *regs)
 	if (probe_breakpoint_handler(regs))
 		return;
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	if (notify_die(DIE_DEBUG, "EBREAK", regs, 0, regs->cause, SIGTRAP)
+	    == NOTIFY_STOP)
+		return;
+#endif
+
 	current->thread.bad_cause = regs->cause;
 
 	if (user_mode(regs))
-- 
2.43.0


