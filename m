Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1C8CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011868E00C6; Fri, 22 Aug 2025 13:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00BA8E009D; Fri, 22 Aug 2025 13:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDC5D8E00C6; Fri, 22 Aug 2025 13:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7AD98E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:47:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B6D41602CA
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:38 +0000 (UTC)
X-FDA: 83805125796.13.9FE893C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0F648000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:47:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SXGLBXs5;
	spf=pass (imf02.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755884856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lASAogWwaY4J3oXaSg+X8r5SCu4Wp/t1yzCv89toveQ=;
	b=8kbWFJ/QvAzzHuJBztGTU56wzrfPA87cNIcSgv8RL2oiOG7+92NSt2VXTReC7DKLIqmFov
	UPCC2lBcveEqfrIyrLQt7LKbG7AKOxlaLyKVZMIO1IwfNYbSpCUwF/nboN6ZpKMgO+cEJ9
	1RNfd3xucqYCU0MkdYcs35M8dDui3aQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=SXGLBXs5;
	spf=pass (imf02.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755884856; a=rsa-sha256;
	cv=none;
	b=3uHo2K1K+vz98wqh4bb9bPbHxTXOCUsuVhjQEImujLUjxQRBnIM8da8moHt5/Bg1VTbKuL
	P0qLiVsVit5sV6/b3kIKy6AtEjYGNfZkArksXIm6EfieUA/yTD8oyzl7mteKBZoFrjRiR7
	Hzhq2TfcBHCxfiGcGjlDe4kuecIVtT4=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4b109c6b9fcso25435531cf.3
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755884856; x=1756489656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lASAogWwaY4J3oXaSg+X8r5SCu4Wp/t1yzCv89toveQ=;
        b=SXGLBXs5hcGzy8dzda/0FWQAo/ltt/U9IRvXD7JUEGHBRGon6PtQfTAut9Y1GnI7OJ
         qEt8RdF/FqOa6tgunomkXkp7nf9ZZ64sSrqa8QC6kFLEtzwR+VebsTNi5q/h4yzS03Q+
         oxRHUODccQqW4gRcI3Tf9WwuVVAoWprTfKFhKjC7BEFtd4EEWIYgUcQX42RV2ChREhG1
         eIhRttz/GalOSvOuTqYXdJ0kFmMfZ2NF//IwH5pLJmJXRbRw65CwdbilbCqbM3N/NzHn
         PQwuQQiY3JA+ugBoW4UOUJKS7WXwVe03/gsrnK+kMN2dfZo2Xz0Jn6MLkfstEPeOHX7E
         VO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755884856; x=1756489656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lASAogWwaY4J3oXaSg+X8r5SCu4Wp/t1yzCv89toveQ=;
        b=qc3XYSy+KQJMJQdLhsSMBDM5JL7iPw123SQu3f6tnGxDHU3UCXPsFbMe1zcz4G6+GJ
         +b2HM5nhO2znEIk5xSd8197hEOwkEzrXLoRuqVyszyUPGAqyKss0RbQqVqu0vV2N5tkg
         DTWgkHjPb9MES5uSEbFZN4NtR/Bk8ssw5BrTFN/IRv2T+4loK3i8Y/xK+teLWe5IpbvR
         VXqKJ0kBi2eitHeNb4FUQaOsOKzEyfmN8hletnoYCXnPBbYEIZjD6wqMDUyNNqzW1f0I
         d+9YiAyBxxTcyNyyPdAnJX+okYnbwO9gJeVfVjRt+fplGRcdIgziRZqqMx9gYBRZ5W7e
         Z3ig==
X-Forwarded-Encrypted: i=1; AJvYcCWQBzIhBYJoDncyvg9F4SUXK0RthgXzIg8VPl/9HlnLM9wQOcVJmIQQ5Js/qUc75pD3MlC3wNF3+g==@kvack.org
X-Gm-Message-State: AOJu0Yzl/Fnfr4wLUkse4MnkdYwUz35uFxV5elaqASishpCDrehvWbWn
	pUZjgGLAJXnUNXyZMmXZ9SNFFbyr5hNWiPDsEgNbY+rbK6iGGNXYTX47ZuH+xQJy95U=
X-Gm-Gg: ASbGnctU6yqZx05SYblvdj2Ov0MJqYjzVCwvVQlF4o7amjlLA8VMOr5VZQf2uPvcyS0
	6EfNXuodZ92SOL1Lfo0Wgtc9JU+ERmjbnX+mqun/IkeKGjmkMuHb7pllIGMX9SMlrtPcRrQIFzx
	Hvu1RIK+vZLWiSbiQ3jhvvFpfA1FI06lP272GWqyzSKzFFJjzRMdiWV/HfdGUJb1J+HAyr85hOf
	BbjX4gDcIZQ+ARiZpkiNQARMbhTZV2O7JdCV1xgUol/5C92Zm/qZGPyTtjMfAHu2p9WlEBMM5Z2
	CAFLANB8tk9LukK7pcchJ2cLc1ZQAV1g0bd2vsY3hB1qi9Brzr/L0mtzaqgpmT3oZjjgRiBAe4U
	m8HPaSh/MAFVgdqKTv5UDPPLi5pu/h/WHm7w7Lt/+uDQWX39sJLD/iZy55o4q+7fmLfpaq9boPw
	R/3n1ZKQ==
X-Google-Smtp-Source: AGHT+IF7NBwPyWijDa6fVd6FPPHBKgHBj6d8UJ7rY1WXrx0r6jLeZuvNMUy7ENqP9DpN+xFIGjFOyA==
X-Received: by 2002:a05:622a:4016:b0:4ae:f8bb:7c6a with SMTP id d75a77b69052e-4b2aaaf96abmr39630891cf.54.1755884855769;
        Fri, 22 Aug 2025 10:47:35 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8e6023asm3121361cf.53.2025.08.22.10.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 10:47:35 -0700 (PDT)
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
Subject: [PATCH 8/8] selftests: riscv: Add test for hardware breakpoints
Date: Fri, 22 Aug 2025 10:47:15 -0700
Message-ID: <20250822174715.1269138-9-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
References: <20250822174715.1269138-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D0F648000F
X-Stat-Signature: 3qkkcqkhzpt3e4ekru63zy3hwi8mde11
X-Rspam-User: 
X-HE-Tag: 1755884856-844013
X-HE-Meta: U2FsdGVkX19f9W3IZebfbD5RHkZPIAA2iM5CaT4CylaSVthoZ9DKkFC0z77kzETPcqFTchJrbUUvU/x1MFV3Sw3lcLiZRiHTX/rX8GQZN+oPCSJuLkqgZyzWcr8aZdBPB2xJy5ThU92rN9qVRfSeTcPGIX29bPe2jw6cBsnAA2eQEBetYiRK4nMCr0xUi6lyC5ZsvJAX/bON9c3TCn1sIT024/F89Auj099ISu/VAdqs6D+D9mC9zf3lPoyIMCDaI8FcdR9FpgTAkphpINpihhYsx4vc09v8XTUGCxRFAjXMojfQmFyFdfrnnc5WvMbdKrGCwoDvObSGgGOxRsbhj1o7H14FENlMKUlJuP3EpFC5Q8VngqH+UrrF6a/7V1gpkbbSM40njuQqmc88U9xKvB8iQxPTevlhQE4KEqHFV7ThVBS9UgFW5NzjeIsKV7gj5omM+cYjKNm0rg4p6lARhMNFQRsetNOg185AazTmo+zbn1aas6FLxKaiXMy5hEunbT6AJGXKGkzvRPW8KdDg6MwPtx+QOxL6ibQtIeuxdRr3kOtIPhb60JjTqhwbJGB4i8amy9bkhQL8r5C9gpee6MgZboDbLcLLwhIeHdVeYB5rbikYXeWaHHkf90Ffe1fYckJl7fUAez6Ujvpl0I29NAkWS8kooIPOmQARj8Pv/gDXaYsojEpc5BiN5ncrJ3x8lO6NTEgDzCsbR00AEI/sifstwSrn5VNvk0oPkwPDiHhwL339/V8V+bm1VV4beXZnFn+U/bMCwX1wEdx9YMgR0wsrqsx7Rzije9seopjkMpyvvatR7LM/ZLY9xjYXue6xv3l2FaSvOqA0Z6dlBs/3dMQQDS3I1zc4k2J5g+wK3xcqidSEexEq2dVnX1R5AQIkknlbAFixzwNL1F2rdBlrqArf6cNRqYtBoydIyafobrqH3Gbe0yy0JXrJvnuWVnMVyO28uhkdZPtVWG8V1E2
 eFf4Levy
 dSHwkBsucYPeW+UNb0IYJ48iyGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add riscv specific selftest for hardware breakpoints.
These tests are based on:
tools/testing/selftests/breakpoints/breakpoint_test_arm64.c

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
The selftest fails as register_user_hw_breakpoint seemingly does not
call arch_install_hw_breakpoint. The test also seems to fail on arm64
in the same way when I tested it.

RFC -> V1:
 - New commit
V1 -> V2:
 - Add KHDR_INCLUDES to Makefile
 - Change <elf.h> to <linux/elf.h>
---
 tools/perf/tests/tests.h                      |   3 +-
 tools/testing/selftests/riscv/Makefile        |   2 +-
 .../selftests/riscv/breakpoints/.gitignore    |   1 +
 .../selftests/riscv/breakpoints/Makefile      |  13 +
 .../riscv/breakpoints/breakpoint_test.c       | 246 ++++++++++++++++++
 5 files changed, 263 insertions(+), 2 deletions(-)
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
index 000000000000..2315d7d874fc
--- /dev/null
+++ b/tools/testing/selftests/riscv/breakpoints/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2021 ARM Limited
+# Originally tools/testing/arm64/abi/Makefile
+
+CFLAGS += -I$(top_srcdir)/tools/include
+CFLAGS += $(KHDR_INCLUDES)
+
+TEST_GEN_PROGS := breakpoint_test
+
+include ../../lib.mk
+
+$(OUTPUT)/breakpoint_test: breakpoint_test.c
+	$(CC) -static -o$@ $(CFLAGS) $(LDFLAGS) $^
diff --git a/tools/testing/selftests/riscv/breakpoints/breakpoint_test.c b/tools/testing/selftests/riscv/breakpoints/breakpoint_test.c
new file mode 100644
index 000000000000..2675055a924e
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
+#include <linux/elf.h>
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


