Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3387EC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 943306B00B2; Tue,  5 Aug 2025 15:40:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3066B00B3; Tue,  5 Aug 2025 15:40:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB676B00B4; Tue,  5 Aug 2025 15:40:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 683C46B00B2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24B9656C72
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:18 +0000 (UTC)
X-FDA: 83743720116.08.6311EA8
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 65A6A14000B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NnIV6XBf;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422816; a=rsa-sha256;
	cv=none;
	b=KO+Q1+lyHE99vSmpOq2HARZ7mbe+6DfJdcYZfPU8K5n9yc+Hy+3H+wPHXg5EBG+q6QYCRC
	AaUbh03y0+fFtdoRw7VRM8jxrAWffuRgRF5IsQnJOezg9s+2gLbMY0iKpgZhUKghN4mIsp
	3qxI5Jb2h6NLukmTufPoZo4jmb6JX48=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NnIV6XBf;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vL4PFY0aOH8JnUAWFk8/IxlbUSq0aZKvwKplwC4IJQE=;
	b=OoZeAJUOlH6PIjhihlz+KcFjCEjV4behqjQShSr7Z9RF9R2NJURCBMTVOlGrKhqZVNGpW4
	Qi2ODPLpYtrgxM7o/Kt/FQm4o3+D11zf8raNKUx1r258yABJIIMYtR33vfiLxWxwdSlGNR
	SdoNrNy7p6kDfMczdCDFUx9lhkHp5sg=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e6399d0654so318053085a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422815; x=1755027615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vL4PFY0aOH8JnUAWFk8/IxlbUSq0aZKvwKplwC4IJQE=;
        b=NnIV6XBfbADyqESlVOaWJGic1qK4M+YZsoKIhck0DW0j8VkoPp/gu7PqZins+FIQkL
         f1WR1carKWh3u1PXgy0LAR4kKmssVfi4k+ZMVEU5vGOhjKnTKyrffHXOqz/BkC92U3Uk
         K1cuUdK6AKkz7WV9JEQnmcmuUrTkOnC1+GU0aY8NxYuweWrOWpfuj/ru0+AK8LGz8JQ/
         IinNCklwdXpXbLuXrK2GQzaTfOzTklsVWQ1HX1PJxNGI6ZMuLOa8qRVinD1N0XYgCfJU
         4eO2JRyLmz9TzNMFLEqnxBKJv/gLJ6EVuHePU2P+WmNb9UNHfwA7jbH4AL8pZ3LCQliI
         rUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422815; x=1755027615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vL4PFY0aOH8JnUAWFk8/IxlbUSq0aZKvwKplwC4IJQE=;
        b=DjOyEYxDmevZ9Qrtj4dNWW8jRwOJXzRNbSXHJnZtA9S+y68E2ypgcQYhgwk1jWAxTp
         jBL9j77OyZF79RS/aVvkDVNIMUtFFvSuSciLXPqXATaR4yu8qi3QGboHVSaGPrLCv501
         WVo/zAlmQopciL6y6COQmZvACGcp613NR7UtfWAVR9Q4p/kHj+L7gs9QuZQFAR9j1IlO
         lKfLgV3h4yvYnlvgu/OdzIgxjxYXZoIYib8BN6GrtlH0sgLVN7ETkyTYz2aiEWYkMNvc
         dZ74pTGA/GvJ+++TLVeiLAWv8M4aI4uZcHCjRcJt5LZhhh/G+5nsFSzubadGXnu0tNP+
         X1Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVJmmXMkc77F2sS5qtNO88mTjgbV1kiijPE5LDEfgQbFSGJ/rJsII1gO4dxerBMvxIPt0YTNAGErw==@kvack.org
X-Gm-Message-State: AOJu0YyUzAQCePHHKR+8eRSzD9VQlA4D53RGqG54hOJzta8MozU4SN65
	Bik9f0vyVjPtVSBofUuR5GyvTJcVUBvIO7y/xwUUZvwhU+AV23QngcXzt/cyUb9sGAM=
X-Gm-Gg: ASbGnctDipy/OKXJIu2YSf6Rdr9vVKwwdsyphLoz9UZ5UAE4IUcKSPiwXCg7nkRl1ej
	vGRiH4pyT7M6ho1/ZVxPq56DRX7sxr/Kfo26K5Qmb3qPpI8hPDIOnVCYJFkOQ+Krp8LblGLdzoE
	yMREyQT2MlJTpJEZRKy0xNlY6x+TdEOuES+kUlSSVlZVFGOjOk4hEugPCgiBaae+K2RKXJ6bZiJ
	+Sesf9Sv9n9vUwgi/VD4ShrwuBYnnqdODwIhbkiwjW3nEp+HVuREcoYd9uzu8PJXJ2j/2GktpgE
	emUQ+E+WBkaff4dZzpG/BiaIjUhAmQU51j5avZh4MNWW+A/ICB+Wnp8cUHsqrHYL8Q4bgvFhGfZ
	9bcsUWqlyIViyL7x9bSOEka5kZiOtHJ7ZBKYYjyXuU9NYWnbbtOnMKP1Z6Mkfhf47XHpVt6Ze3B
	SWpyVjr8nDXEGHGT5l
X-Google-Smtp-Source: AGHT+IGXS15aibedECz6CkDF0iaK6CSzoEd5PRNEgnuhiSDuN9qkS/vQpcn9djWvm2zxOAxHWnrvxg==
X-Received: by 2002:a05:620a:aa09:b0:7e6:969e:c54 with SMTP id af79cd13be357-7e814e175f0mr73691085a.63.1754422815267;
        Tue, 05 Aug 2025 12:40:15 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:15 -0700 (PDT)
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
Subject: [PATCH 8/8] selftests: riscv: Add test for hardware breakpoints
Date: Tue,  5 Aug 2025 12:39:55 -0700
Message-ID: <20250805193955.798277-9-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5b4idzt5g5egdrbcms65hpmxtqhz1oy
X-Rspam-User: 
X-Rspamd-Queue-Id: 65A6A14000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1754422816-694282
X-HE-Meta: U2FsdGVkX18tnCyIlqwXcReQQw5sxS/7xypVgbfYt+lqbXdKNqzIMDVj4h0R3D9tyVXZLUQZzOazOgpBXCyFga48TDUlCsNB2T5MSM/cTP2OXreaMDI8zgnTvSOMe836+irOADw8mIHuoQ2rmen1WRgEa97qJTjqvp4hDqIdsI/vj1dUQAcyRJQFSBaiq7MIBwGebXEDIny9NEZfGc4f6oWkUNamqKBSkDx2JlbI7Q3U+r3gaohNeY7YOTRGaJ4xMdyFywfJEdgSvUcGW6XWVM5l5nuh5WOGC3QgMEVoOUItmV7Z0hxIUJDQ/kiiFeAAPoRZEz0FDkQ35PJmQHqz9kq7c97UK6Gnp8KXmUMl+3nvcT1H/aA5fmkH5t/farzwMYnOedFPqTOqnJXhQ7kgU1TyPr7xy7FCufUjlGDrnYxQhjmMirjMQOZthqNI1+qLX+a8xgM7p95rppdgIlEoirCDypB9o6MO9z9gSIjYUFecIDmDfMYcnvVjPxue6+R1yX/8XFLRdbWTI4qTwD69+jrWKqH4XW3BzdFwEX4hlNGnsCcpQcwKvvc973+Wq2HbbEDHQj9ynK6ZWn06KPdLs6fIRvk2Zj1stqkvnllYTkl6WEhfBc5dTMe7f/3qAH3ib5aa0F1Fhw4v4Dst3cx+ricPhLmyTNvCS6S7N9lPmwDMbbNqEUt+POtC34KxdfiW8dtMcsT1awtFSSJ5nYvhClk9Z6VFz1S5jn+shFWcB4tzQymPAGfQi/RVcvJ4MP0aV0U2fPLkeXUplq2NBXFyLtMoUP/qaKR7XEh8n+w9yRLUhsI19SN4/NSBNo8Nbrt362bqz11QJU/PXHNHildjoR6QNmXDrPcGWCYPQguOo8FkYooDpmpSQsDa7NnEGxSZYIBYmuDyHRtTihPqn4GzsSVO+ePcuuKGxRU7RNh7ufiPB7fXdwmAQax8RT/baKPyHWM1fqG9/MjgaUKP785
 zL60OIxl
 uyE0w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add riscv specific selftest for hardhardware breakpoints.
These tests are based on:
tools/testing/selftests/breakpoints/breakpoint_test_arm64.c

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
The selftest fails as register_user_hw_breakpoint seemingly does not
call arch_install_hw_breakpoint. The test also seems to fail on arm64
in the same way when I tested it.

RFC -> V1:
 - New commit
---
 tools/perf/tests/tests.h                      |   3 +-
 tools/testing/selftests/riscv/Makefile        |   2 +-
 .../selftests/riscv/breakpoints/.gitignore    |   1 +
 .../selftests/riscv/breakpoints/Makefile      |  12 +
 .../riscv/breakpoints/breakpoint_test.c       | 246 ++++++++++++++++++
 5 files changed, 262 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/riscv/breakpoints/.gitignore
 create mode 100644 tools/testing/selftests/riscv/breakpoints/Makefile
 create mode 100644 tools/testing/selftests/riscv/breakpoints/breakpoint_test.c

diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 8aea344536b8..5ff35304c11a 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -183,7 +183,8 @@ DECLARE_SUITE(util);
  * Just disable the test for these architectures until these issues are
  * resolved.
  */
-#if defined(__powerpc__) || defined(__s390x__) || defined(__arm__) || defined(__aarch64__)
+#if defined(__powerpc__) || defined(__s390x__) || defined(__arm__) || defined(__aarch64__) || \
+    defined(__riscv)
 #define BP_SIGNAL_IS_SUPPORTED 0
 #else
 #define BP_SIGNAL_IS_SUPPORTED 1
diff --git a/tools/testing/selftests/riscv/Makefile b/tools/testing/selftests/riscv/Makefile
index 099b8c1f46f8..96aba246cb3e 100644
--- a/tools/testing/selftests/riscv/Makefile
+++ b/tools/testing/selftests/riscv/Makefile
@@ -5,7 +5,7 @@
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
 
 ifneq (,$(filter $(ARCH),riscv))
-RISCV_SUBTARGETS ?= abi hwprobe mm sigreturn vector
+RISCV_SUBTARGETS ?= abi hwprobe mm sigreturn vector breakpoints
 else
 RISCV_SUBTARGETS :=
 endif
diff --git a/tools/testing/selftests/riscv/breakpoints/.gitignore b/tools/testing/selftests/riscv/breakpoints/.gitignore
new file mode 100644
index 000000000000..9b3193d06608
--- /dev/null
+++ b/tools/testing/selftests/riscv/breakpoints/.gitignore
@@ -0,0 +1 @@
+breakpoint_test
diff --git a/tools/testing/selftests/riscv/breakpoints/Makefile b/tools/testing/selftests/riscv/breakpoints/Makefile
new file mode 100644
index 000000000000..91e1c02c0073
--- /dev/null
+++ b/tools/testing/selftests/riscv/breakpoints/Makefile
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 ARM Limited
+# Originally tools/testing/arm64/abi/Makefile
+
+CFLAGS += -I$(top_srcdir)/tools/include
+
+TEST_GEN_PROGS := breakpoint_test
+
+include ../../lib.mk
+
+$(OUTPUT)/breakpoint_test: breakpoint_test.c
+	$(CC) -static -o$@ $(CFLAGS) $(LDFLAGS) $^
diff --git a/tools/testing/selftests/riscv/breakpoints/breakpoint_test.c b/tools/testing/selftests/riscv/breakpoints/breakpoint_test.c
new file mode 100644
index 000000000000..faeecc72da12
--- /dev/null
+++ b/tools/testing/selftests/riscv/breakpoints/breakpoint_test.c
@@ -0,0 +1,246 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2016 Google, Inc.
+ *
+ * Original Code by Pavel Labath <labath@google.com>
+ *
+ * Code modified by Pratyush Anand <panand@redhat.com>
+ * for testing different byte select for each access size.
+ * Originally tools/testing/selftests/breakpoints/breakpoint_test_arm64.c
+ */
+
+#define _GNU_SOURCE
+
+#include <asm/ptrace.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <sys/ptrace.h>
+#include <sys/param.h>
+#include <sys/uio.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <stddef.h>
+#include <string.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <elf.h>
+#include <errno.h>
+#include <signal.h>
+
+#include "../../kselftest.h"
+
+#define MAX_BP_SIZE 8
+
+static volatile uint8_t var[3*MAX_BP_SIZE] __attribute__((__aligned__(MAX_BP_SIZE)));
+
+static void child(int size, int wr)
+{
+	volatile uint8_t *addr = &var[MAX_BP_SIZE + wr];
+
+	if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) != 0) {
+		ksft_print_msg(
+			"ptrace(PTRACE_TRACEME) failed: %s\n",
+			strerror(errno));
+		_exit(1);
+	}
+
+	if (raise(SIGSTOP) != 0) {
+		ksft_print_msg(
+			"raise(SIGSTOP) failed: %s\n", strerror(errno));
+		_exit(1);
+	}
+
+	if ((uintptr_t) addr % size) {
+		ksft_print_msg(
+			 "Wrong address write for the given size: %s\n",
+			 strerror(errno));
+		_exit(1);
+	}
+
+	switch (size) {
+	case 1:
+		*addr = 47;
+		break;
+	case 2:
+		*(uint16_t *)addr = 47;
+		break;
+	case 4:
+		*(uint32_t *)addr = 47;
+		break;
+	case 8:
+		*(uint64_t *)addr = 47;
+		break;
+	}
+
+	_exit(0);
+}
+
+static bool set_watchpoint(pid_t pid, int size, int wp)
+{
+	const volatile uint8_t *addr = &var[MAX_BP_SIZE + wp];
+	const int offset = (uintptr_t)addr % 8;
+	const unsigned int type = 2; /* Write */
+	const unsigned int enable = 1;
+	struct __riscv_hwdebug_state debug_state;
+	struct iovec iov;
+
+	memset(&debug_state, 0, sizeof(debug_state));
+	debug_state.addr = (uintptr_t)(addr - offset);
+	debug_state.len = size;
+	debug_state.ctrl = enable;
+	debug_state.type = type;
+	iov.iov_base = &debug_state;
+	iov.iov_len = sizeof(debug_state);
+	if (ptrace(PTRACE_SETREGSET, pid, NT_RISCV_HW_BREAK, &iov) == 0)
+		return true;
+
+	if (errno == EIO)
+		ksft_print_msg(
+			"ptrace(PTRACE_SETREGSET, NT_RISCV_HW_BREAK) not supported on this hardware: %s\n",
+			strerror(errno));
+
+	ksft_print_msg(
+		"ptrace(PTRACE_SETREGSET, NT_RISCV_HW_BREAK) failed: %s\n",
+		strerror(errno));
+	return false;
+}
+
+static bool run_test(int wr_size, int wp_size, int wr, int wp)
+{
+	int status;
+	siginfo_t siginfo;
+	pid_t pid = fork();
+	pid_t wpid;
+
+	if (pid < 0) {
+		ksft_test_result_fail(
+			"fork() failed: %s\n", strerror(errno));
+		return false;
+	}
+	if (pid == 0)
+		child(wr_size, wr);
+
+	wpid = waitpid(pid, &status, __WALL);
+	if (wpid != pid) {
+		ksft_print_msg(
+			"waitpid() failed: %s\n", strerror(errno));
+		return false;
+	}
+	if (!WIFSTOPPED(status)) {
+		ksft_print_msg(
+			"child did not stop: %s\n", strerror(errno));
+		return false;
+	}
+	if (WSTOPSIG(status) != SIGSTOP) {
+		ksft_print_msg("child did not stop with SIGSTOP\n");
+		return false;
+	}
+
+	if (!set_watchpoint(pid, wp_size, wp))
+		return false;
+
+	if (ptrace(PTRACE_CONT, pid, NULL, NULL) < 0) {
+		ksft_print_msg(
+			"ptrace(PTRACE_CONT) failed: %s\n",
+			strerror(errno));
+		return false;
+	}
+
+	alarm(3);
+	wpid = waitpid(pid, &status, __WALL);
+	if (wpid != pid) {
+		ksft_print_msg(
+			"waitpid() failed: %s\n", strerror(errno));
+		return false;
+	}
+	alarm(0);
+	if (WIFEXITED(status)) {
+		ksft_print_msg("child exited prematurely\n");
+		return false;
+	}
+	if (!WIFSTOPPED(status)) {
+		ksft_print_msg("child did not stop\n");
+		return false;
+	}
+	if (WSTOPSIG(status) != SIGTRAP) {
+		ksft_print_msg("child did not stop with SIGTRAP\n");
+		return false;
+	}
+	if (ptrace(PTRACE_GETSIGINFO, pid, NULL, &siginfo) != 0) {
+		ksft_print_msg(
+			"ptrace(PTRACE_GETSIGINFO): %s\n",
+			strerror(errno));
+		return false;
+	}
+	if (siginfo.si_code != TRAP_HWBKPT) {
+		ksft_print_msg(
+			"Unexpected si_code %d\n", siginfo.si_code);
+		return false;
+	}
+
+	kill(pid, SIGKILL);
+	wpid = waitpid(pid, &status, 0);
+	if (wpid != pid) {
+		ksft_print_msg(
+			"waitpid() failed: %s\n", strerror(errno));
+		return false;
+	}
+	return true;
+}
+
+static void sigalrm(int sig)
+{
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+	bool succeeded = true;
+	struct sigaction act;
+	int wr, wp, size;
+	bool result;
+
+	ksft_print_header();
+	ksft_set_plan(213);
+
+	act.sa_handler = sigalrm;
+	sigemptyset(&act.sa_mask);
+	act.sa_flags = 0;
+	sigaction(SIGALRM, &act, NULL);
+	for (size = 1; size <= MAX_BP_SIZE; size = size*2) {
+		for (wr = 0; wr <= MAX_BP_SIZE; wr = wr + size) {
+			for (wp = wr - size; wp <= wr + size; wp = wp + size) {
+				result = run_test(size, MIN(size, 8), wr, wp);
+				if ((result && wr == wp) ||
+				    (!result && wr != wp))
+					ksft_test_result_pass(
+						"Test size = %d write offset = %d watchpoint offset = %d\n",
+						size, wr, wp);
+				else {
+					ksft_test_result_fail(
+						"Test size = %d write offset = %d watchpoint offset = %d\n",
+						size, wr, wp);
+					succeeded = false;
+				}
+			}
+		}
+	}
+
+	for (size = 1; size <= MAX_BP_SIZE; size = size*2) {
+		if (run_test(size, 8, -size, -8))
+			ksft_test_result_pass(
+				"Test size = %d write offset = %d watchpoint offset = -8\n",
+				size, -size);
+		else {
+			ksft_test_result_fail(
+				"Test size = %d write offset = %d watchpoint offset = -8\n",
+				size, -size);
+			succeeded = false;
+		}
+	}
+
+	if (succeeded)
+		ksft_exit_pass();
+	else
+		ksft_exit_fail();
+}
-- 
2.43.0


