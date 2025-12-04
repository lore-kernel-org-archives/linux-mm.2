Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B50D29FB2
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59F26B0088; Thu,  4 Dec 2025 15:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A266B00FE; Thu,  4 Dec 2025 15:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99E96B00FF; Thu,  4 Dec 2025 15:04:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC926B0088
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 594F312D95
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:59 +0000 (UTC)
X-FDA: 84182867118.30.14F9735
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2FCDE160008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Xs5wpIn6;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878697; a=rsa-sha256;
	cv=none;
	b=5UFZ9X5aesNBooIbnJGEzLqeXaNGm/8A8V0fWK5S9EfP+ymspWNl7Vn5qSZR4LdYpDySAT
	FzV/xd50bADv3xgL8wADULt5580pBYyns/MpXEwVkxn80rP0LEiH4aiKHl1vmz6IGGd0Qm
	F7lh0QG6YL7Jx1ttH8fgt0I6LhnSjRE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Xs5wpIn6;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/dLMVRErjMw3pRZM8CLxDKF0sczy3FD8NsBSjZYZgw=;
	b=dbuFQ8tbaRihxuKZAYsc4FCEWIn4LKC6i04keavc/dhD4EEk1Y2rCbW9wHllAbNmVWsdqV
	KWLdTDIv6tAjtVKGtPwyNhSf3FcnTdwhYSwQdijmAUGhoFkWU3jwJJTwdk9P5+Al0VHs94
	azttpu+pn+OVllztabVwEjKJHyqH+mc=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b80fed1505so1523651b3a.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878696; x=1765483496; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/dLMVRErjMw3pRZM8CLxDKF0sczy3FD8NsBSjZYZgw=;
        b=Xs5wpIn61RLtWKym8erN9zQpbVrhpZglr0lUwR8ALyH6mERYJE+4MH7er/dDP8WASn
         cVp8bQU53lxTuxkPNmqEPdUffZFFoZLGoJvPkjAHlD1xU1ds89IiOpCQed018GK4RjMq
         alo9/ajpswY8dAMiw+e2RYtC2N66ED6McZwTNvFq285wIJsnyWGpBzHFihdU61UwmHt2
         X1Nx3hC6ltdOmbGYlH7ywpUW9HDwwurUFb6Ed+dXTJ1LTPCRRLdvQBt/N3wTwWTmktfP
         SFwd5x/ex8ZPkQeT1CuA7en9zxTa4Zr067YH3b9IU4XW6b2IYtmH4uL4obGjT1sel6eQ
         bPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878696; x=1765483496;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U/dLMVRErjMw3pRZM8CLxDKF0sczy3FD8NsBSjZYZgw=;
        b=RiExgb2CmkGvyaQxHd3Fp8LacYQt95gA9ydl8SJ6FyZIyj3GJpLBPxhLSjimBpLXMD
         +PFi/Lkf5ZiEJcWLsCel+riG1zPARAQ8iHSabcL/onxRaJ/kUVwaiGlgXx7liRoddOWK
         bpTH79i7mK//U18vDYkaxGEbofNIYI7mE5NRTrdg14orfJZ40qkOiy4GYKkKBEpJM9Cc
         bL66C5CrBQVlyWt69UcVJKBhqGPLCfE/B8ovVoyQCqIc8fo3kGReyLqDuD1J4m4G53gk
         9Hv2KSBohOsxkD6OJmlSHHYIV4KI8yQeqsAfvz290XTZkfXjyujGjqe4gmpSdA30RfuU
         fG9g==
X-Forwarded-Encrypted: i=1; AJvYcCVH0DJrXwmbsptxvQF9g6cZV7HZ5qUOlD/pTGyZYr9PiV/hQ9Yn27NPYRHk28F0YVQ2Ywp8kMU0AQ==@kvack.org
X-Gm-Message-State: AOJu0Yyf3VOnbOhlw69HctEJ4vzq9Hh2jquosBDdonKxjJaIOidVf2dr
	G29co0lrb2jgV+qdBD9Dg1xG3aSpS/DQq3qA05iBf+oa8y1+6hMZ6a9FjGN25ELgvwE=
X-Gm-Gg: ASbGncsaXJpKH/fGEt8PU5tKtAaBU6Vdl+Rw/wVvgSPG28rkiij5P5H5REfYq7S0I22
	W+Bgm0LIwZAYxIGDL8CB/NCp1jTYXNdF0uIjPtrRdng9y7A9u/2rsnQfT9/Af7ZFbym7c1BWpWm
	oeQXybd0rGxDtR0k6ANHXIaaG1+w8wWcyd3xFdDI1ffY4+OzCkNdYsBqQS+DWZ7rlrAhw4ZAOnl
	PDDnRo6z84q82Z2JH5P8IfeVrYen0H2F1nSVgf60K7nYJ3xXVoMyEdEl9nFiURjjWbvsWlakmQE
	9JBvbY3se2kFGuRTf8OJkmEdAnNuWugbwdg3lsNIGTTR0MGlUH9LGmDZX2xaU9uQ5tWlw+V9xSi
	E4HPLXp1Hkabb3YJcOC3vfuIAff1uqZLvT9oAR5Hp4v0xYRP4j0/+9em+rVdG0cd63Ch39NToe5
	vlg10WQcjOXI2Tn1lBAixq
X-Google-Smtp-Source: AGHT+IFOz8hCUfxo8tYK5MT/uROM3qsQYu3DFPs8lhkMfDb8wRA8yvfGV/q1zs9wlmhbpMhp7oHNAw==
X-Received: by 2002:a05:7022:689c:b0:11b:7f9a:9f00 with SMTP id a92af1059eb24-11df0c53284mr6852274c88.4.1764878694864;
        Thu, 04 Dec 2025 12:04:54 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:54 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:17 -0800
Subject: [PATCH v24 28/28] kselftest/riscv: kselftest for user mode cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-28-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=22854;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=cy/go0Ocykt8hYEQpblFr2v7taXgkTnajdoNVCaPVoY=;
 b=X1LON6KvJN3jowsitkGcYe9sSNoDXel5hWlcNf+vCiz7pGUXQ6/v5+oKZ/5xMALX0D4Pt0UV8
 g7FTrEDJtaYA/92HOrbibqWj5xq69oUT85N4oTo94ImCvas4Oghs48E
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2FCDE160008
X-Stat-Signature: jz4qt9ha737q9nxxs9ez8wwipdizcagx
X-Rspam-User: 
X-HE-Tag: 1764878696-821117
X-HE-Meta: U2FsdGVkX19tbhTIHSa6oAXsGKKgQNNuHmUXQa/ZXzNSNv8YNy+IMjVQ71A2ciV3H+G04A58nEA/vqdpLtGFdFYW8q/dqU34i7lxwB8l8C3IIC+jco8WthjiLfL874ZxpdJdqLUtbcEaHlYVnTdTFKuIIPqw7irxlNhD3XsQHZAtINdHty8Sy768ycqw21dlMKGD9bvgZ6i78CZYGu+i6AQBMudi0m/SyRXGfFKefBCmCbM26KgkITjn6qtiW8GEUW2qU496i6G5sk/mnMIvPImrDUeyJ0wlA3V3zgUvDfaybM8X1sVFm4WZxB+RN0zmBQ+T8vmMgjdb6CAEQfuqearL6rAt39YmwvhpR9RZQ1wrP3KWDPRSwapRkaNpzEmyJTErhQiiekryHI+lWiCG0YNKt7r9Ls3bpTGKrVwP4WNO0AD7o2h/CXZ3h4kfGnITTe2D5tuBu9Er9caFLyZizgfpB0nZFWUIKvar45DOLQm2oInQTbaDkqGlRke1Wo1VTFlWTwYR9/Xvxos5Y/hD6yLmVtuaYj2UFlocYnpnHNw6Zmf9IGqk5aWxBOz7KUwZMVzG6Fk5dr+1cZ51Wf7kTmAKe6T4v4eH1f3BCxmcKJted8NjdGncY5ORbmHTJrn82ifPvkFfLBQjUQQyQkfzCD/oJYqq0TZzQV0/hH3+J6glC7G5R1Oltaem5i13UV6p318a7vnl41/3zQL4uhTi2B7m7l6ZY0y6NeDWDUkl0cP74i0W1hdwVS+zcl3wfMi2pbRrI76ikmtU+Wir21bQP1OFGQXzddtLXexAcmEGHYfs/8JuoYIsbPqtulTOEnuDdy/KbPVVXfIJEgtgdSif6C2SeB9bDGjOzFTPX98W99/ivf+toF9U+llffslMJZ7KBCQpdSN9t0jpY+sRqOnM+Bu0H9jDx/ZvvqHZsRWiMWaTaw0N6wiQbtBX7pOP8w6J6zctnbThJDEhxDTfNLk
 mp/yvi9q
 2VM+8sbUAxMoS7e4rwJExbSgM2DluWqKWtm25koNvpluKNHk8om+tP43bl1vOKEZB8gQQqFaTwpQqHcRjwKDvU6KkcDESLFBz0t34nDQ36jXHwMfXOh15fCAYXFa8qcykk5Re0Gjxbc4BivQptspvneabgt9pepWNCdbIFvNEj4Sb70pEqGOlfZWNnEVfLQeGmmr6y42DJzJGsEoj8repxmFAEtbK6Wkcr3fzoHkcaj+mJXaMJl35UOMxW6otgPYOfVQFYp26dROHZB8fU79no58U2TV6x2g0Uv+vxH/t547yheAchY0zp82DbD0sq9cuYtEDF8LImarUfr95sqIjrZLGLhlHVZSdcB2RS0aFipgAsTSt6oKf4VaEW5Fvnlp5JhNkL++CPJDTapKkKBrteA/h6pri2YMYXyoC6NS5UMckJjz+tuoSgsyvATOYXZxQCK2O7PAPGs0NHIqwNjMklyUpd8qYq7sq2goF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adds kselftest for RISC-V control flow integrity implementation for user
mode. There is not a lot going on in kernel for enabling landing pad for
user mode. cfi selftest are intended to be compiled with zicfilp and
zicfiss enabled compiler. Thus kselftest simply checks if landing pad /
shadow stack for the process are enabled or not and executes ptrace
selftests on cfi. selftest then register a signal handler for SIGSEGV.
Any control flow violation are reported as SIGSEGV with si_code =
SEGV_CPERR. Test will fail on receiving any SEGV_CPERR. Shadow stack part
has more changes in kernel and thus there are separate tests for that

- Exercise `map_shadow_stack` syscall
- `fork` test to make sure COW works for shadow stack pages
- gup tests
  Kernel uses FOLL_FORCE when access happens to memory via
  /proc/<pid>/mem. Not breaking that for shadow stack.
- signal test. Make sure signal delivery results in token creation on
  shadow stack and consumes (and verifies) token on sigreturn
- shadow stack protection test. attempts to write using regular store
  instruction on shadow stack memory must result in access faults
- ptrace test: adds landing pad violation, clears ELP and continues

In case toolchain doesn't support cfi extension, cfi kselftest wont
get built.

Test outut
==========

"""
TAP version 13
1..5
  This is to ensure shadow stack is indeed enabled and working
  This is to ensure shadow stack is indeed enabled and working
ok 1 shstk fork test
ok 2 map shadow stack syscall
ok 3 shadow stack gup tests
ok 4 shadow stack signal tests
ok 5 memory protections of shadow stack memory
"""

Suggested-by: Charlie Jenkins <charlie@rivosinc.com>
Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 tools/testing/selftests/riscv/Makefile          |   2 +-
 tools/testing/selftests/riscv/cfi/.gitignore    |   2 +
 tools/testing/selftests/riscv/cfi/Makefile      |  23 ++
 tools/testing/selftests/riscv/cfi/cfi_rv_test.h |  82 +++++
 tools/testing/selftests/riscv/cfi/cfitests.c    | 173 +++++++++++
 tools/testing/selftests/riscv/cfi/shadowstack.c | 385 ++++++++++++++++++++++++
 tools/testing/selftests/riscv/cfi/shadowstack.h |  27 ++
 7 files changed, 693 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/riscv/Makefile b/tools/testing/selftests/riscv/Makefile
index 099b8c1f46f8..5671b4405a12 100644
--- a/tools/testing/selftests/riscv/Makefile
+++ b/tools/testing/selftests/riscv/Makefile
@@ -5,7 +5,7 @@
 ARCH ?= $(shell uname -m 2>/dev/null || echo not)
 
 ifneq (,$(filter $(ARCH),riscv))
-RISCV_SUBTARGETS ?= abi hwprobe mm sigreturn vector
+RISCV_SUBTARGETS ?= abi hwprobe mm sigreturn vector cfi
 else
 RISCV_SUBTARGETS :=
 endif
diff --git a/tools/testing/selftests/riscv/cfi/.gitignore b/tools/testing/selftests/riscv/cfi/.gitignore
new file mode 100644
index 000000000000..c1faf7ca4346
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/.gitignore
@@ -0,0 +1,2 @@
+cfitests
+shadowstack
diff --git a/tools/testing/selftests/riscv/cfi/Makefile b/tools/testing/selftests/riscv/cfi/Makefile
new file mode 100644
index 000000000000..96a4dc4b69c3
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/Makefile
@@ -0,0 +1,23 @@
+CFLAGS += $(KHDR_INCLUDES)
+CFLAGS += -I$(top_srcdir)/tools/include
+
+CFLAGS += -march=rv64gc_zicfilp_zicfiss -fcf-protection=full
+
+# Check for zicfi* extensions needs cross compiler
+# which is not set until lib.mk is included
+ifeq ($(LLVM)$(CC),cc)
+CC := $(CROSS_COMPILE)gcc
+endif
+
+
+ifeq ($(shell $(CC) $(CFLAGS) -nostdlib -xc /dev/null -o /dev/null > /dev/null 2>&1; echo $$?),0)
+TEST_GEN_PROGS := cfitests
+
+$(OUTPUT)/cfitests: cfitests.c shadowstack.c
+	$(CC) -o$@ $(CFLAGS) $(LDFLAGS) $^
+else
+
+$(shell echo "Toolchain doesn't support CFI, skipping CFI kselftest." >&2)
+endif
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/riscv/cfi/cfi_rv_test.h b/tools/testing/selftests/riscv/cfi/cfi_rv_test.h
new file mode 100644
index 000000000000..1c8043f2b778
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/cfi_rv_test.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef SELFTEST_RISCV_CFI_H
+#define SELFTEST_RISCV_CFI_H
+#include <stddef.h>
+#include <sys/types.h>
+#include "shadowstack.h"
+
+#define CHILD_EXIT_CODE_SSWRITE		10
+#define CHILD_EXIT_CODE_SIG_TEST	11
+
+#define my_syscall5(num, arg1, arg2, arg3, arg4, arg5)			\
+({									\
+	register long _num  __asm__ ("a7") = (num);			\
+	register long _arg1 __asm__ ("a0") = (long)(arg1);		\
+	register long _arg2 __asm__ ("a1") = (long)(arg2);		\
+	register long _arg3 __asm__ ("a2") = (long)(arg3);		\
+	register long _arg4 __asm__ ("a3") = (long)(arg4);		\
+	register long _arg5 __asm__ ("a4") = (long)(arg5);		\
+									\
+	__asm__ volatile(						\
+		"ecall\n"						\
+		: "+r"							\
+		(_arg1)							\
+		: "r"(_arg2), "r"(_arg3), "r"(_arg4), "r"(_arg5),	\
+		  "r"(_num)						\
+		: "memory", "cc"					\
+	);								\
+	_arg1;								\
+})
+
+#define my_syscall3(num, arg1, arg2, arg3)				\
+({									\
+	register long _num  __asm__ ("a7") = (num);			\
+	register long _arg1 __asm__ ("a0") = (long)(arg1);		\
+	register long _arg2 __asm__ ("a1") = (long)(arg2);		\
+	register long _arg3 __asm__ ("a2") = (long)(arg3);		\
+									\
+	__asm__ volatile(						\
+		"ecall\n"						\
+		: "+r" (_arg1)						\
+		: "r"(_arg2), "r"(_arg3),				\
+		  "r"(_num)						\
+		: "memory", "cc"					\
+	);								\
+	_arg1;								\
+})
+
+#ifndef __NR_prctl
+#define __NR_prctl 167
+#endif
+
+#ifndef __NR_map_shadow_stack
+#define __NR_map_shadow_stack 453
+#endif
+
+#define CSR_SSP 0x011
+
+#ifdef __ASSEMBLY__
+#define __ASM_STR(x)    x
+#else
+#define __ASM_STR(x)    #x
+#endif
+
+#define csr_read(csr)							\
+({									\
+	register unsigned long __v;					\
+	__asm__ __volatile__ ("csrr %0, " __ASM_STR(csr)		\
+				: "=r" (__v) :				\
+				: "memory");				\
+	__v;								\
+})
+
+#define csr_write(csr, val)						\
+({									\
+	unsigned long __v = (unsigned long)(val);			\
+	__asm__ __volatile__ ("csrw " __ASM_STR(csr) ", %0"		\
+				: : "rK" (__v)				\
+				: "memory");				\
+})
+
+#endif
diff --git a/tools/testing/selftests/riscv/cfi/cfitests.c b/tools/testing/selftests/riscv/cfi/cfitests.c
new file mode 100644
index 000000000000..79aaa75f25d4
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/cfitests.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "../../kselftest.h"
+#include <sys/signal.h>
+#include <asm/ucontext.h>
+#include <linux/prctl.h>
+#include <errno.h>
+#include <linux/ptrace.h>
+#include <sys/wait.h>
+#include <linux/elf.h>
+#include <sys/uio.h>
+#include <asm-generic/unistd.h>
+
+#include "cfi_rv_test.h"
+
+/* do not optimize cfi related test functions */
+#pragma GCC push_options
+#pragma GCC optimize("O0")
+
+void sigsegv_handler(int signum, siginfo_t *si, void *uc)
+{
+	struct ucontext *ctx = (struct ucontext *)uc;
+
+	if (si->si_code == SEGV_CPERR) {
+		ksft_print_msg("Control flow violation happened somewhere\n");
+		ksft_print_msg("PC where violation happened %lx\n", ctx->uc_mcontext.gregs[0]);
+		exit(-1);
+	}
+
+	/* all other cases are expected to be of shadow stack write case */
+	exit(CHILD_EXIT_CODE_SSWRITE);
+}
+
+bool register_signal_handler(void)
+{
+	struct sigaction sa = {};
+
+	sa.sa_sigaction = sigsegv_handler;
+	sa.sa_flags = SA_SIGINFO;
+	if (sigaction(SIGSEGV, &sa, NULL)) {
+		ksft_print_msg("Registering signal handler for landing pad violation failed\n");
+		return false;
+	}
+
+	return true;
+}
+
+long ptrace(int request, pid_t pid, void *addr, void *data);
+
+bool cfi_ptrace_test(void)
+{
+	pid_t pid;
+	int status, ret = 0;
+	unsigned long ptrace_test_num = 0, total_ptrace_tests = 2;
+
+	struct user_cfi_state cfi_reg;
+	struct iovec iov;
+
+	pid = fork();
+
+	if (pid == -1) {
+		ksft_exit_fail_msg("%s: fork failed\n", __func__);
+		exit(1);
+	}
+
+	if (pid == 0) {
+		/* allow to be traced */
+		ptrace(PTRACE_TRACEME, 0, NULL, NULL);
+		raise(SIGSTOP);
+		asm volatile ("la a5, 1f\n"
+			      "jalr a5\n"
+			      "nop\n"
+			      "nop\n"
+			      "1: nop\n"
+			      : : : "a5");
+		exit(11);
+		/* child shouldn't go beyond here */
+	}
+
+	/* parent's code goes here */
+	iov.iov_base = &cfi_reg;
+	iov.iov_len = sizeof(cfi_reg);
+
+	while (ptrace_test_num < total_ptrace_tests) {
+		memset(&cfi_reg, 0, sizeof(cfi_reg));
+		waitpid(pid, &status, 0);
+		if (WIFSTOPPED(status)) {
+			errno = 0;
+			ret = ptrace(PTRACE_GETREGSET, pid, (void *)NT_RISCV_USER_CFI, &iov);
+			if (ret == -1 && errno)
+				ksft_exit_fail_msg("%s: PTRACE_GETREGSET failed\n", __func__);
+		} else {
+			ksft_exit_fail_msg("%s: child didn't stop, failed\n", __func__);
+		}
+
+		switch (ptrace_test_num) {
+#define CFI_ENABLE_MASK (PTRACE_CFI_LP_EN_STATE |	\
+			PTRACE_CFI_SS_EN_STATE |	\
+			PTRACE_CFI_SS_PTR_STATE)
+		case 0:
+			if ((cfi_reg.cfi_status.cfi_state & CFI_ENABLE_MASK) != CFI_ENABLE_MASK)
+				ksft_exit_fail_msg("%s: ptrace_getregset failed, %llu\n", __func__,
+						   cfi_reg.cfi_status.cfi_state);
+			if (!cfi_reg.shstk_ptr)
+				ksft_exit_fail_msg("%s: NULL shadow stack pointer, test failed\n",
+						   __func__);
+			break;
+		case 1:
+			if (!(cfi_reg.cfi_status.cfi_state & PTRACE_CFI_ELP_STATE))
+				ksft_exit_fail_msg("%s: elp must have been set\n", __func__);
+			/* clear elp state. not interested in anything else */
+			cfi_reg.cfi_status.cfi_state = 0;
+
+			ret = ptrace(PTRACE_SETREGSET, pid, (void *)NT_RISCV_USER_CFI, &iov);
+			if (ret == -1 && errno)
+				ksft_exit_fail_msg("%s: PTRACE_GETREGSET failed\n", __func__);
+			break;
+		default:
+			ksft_exit_fail_msg("%s: unreachable switch case\n", __func__);
+			break;
+		}
+		ptrace(PTRACE_CONT, pid, NULL, NULL);
+		ptrace_test_num++;
+	}
+
+	waitpid(pid, &status, 0);
+	if (WEXITSTATUS(status) != 11)
+		ksft_print_msg("%s, bad return code from child\n", __func__);
+
+	ksft_print_msg("%s, ptrace test succeeded\n", __func__);
+	return true;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret = 0;
+	unsigned long lpad_status = 0, ss_status = 0;
+
+	ksft_print_header();
+
+	ksft_print_msg("Starting risc-v tests\n");
+
+	/*
+	 * Landing pad test. Not a lot of kernel changes to support landing
+	 * pad for user mode except lighting up a bit in senvcfg via a prctl
+	 * Enable landing pad through out the execution of test binary
+	 */
+	ret = my_syscall5(__NR_prctl, PR_GET_INDIR_BR_LP_STATUS, &lpad_status, 0, 0, 0);
+	if (ret)
+		ksft_exit_fail_msg("Get landing pad status failed with %d\n", ret);
+
+	if (!(lpad_status & PR_INDIR_BR_LP_ENABLE))
+		ksft_exit_fail_msg("Landing pad is not enabled, should be enabled via glibc\n");
+
+	ret = my_syscall5(__NR_prctl, PR_GET_SHADOW_STACK_STATUS, &ss_status, 0, 0, 0);
+	if (ret)
+		ksft_exit_fail_msg("Get shadow stack failed with %d\n", ret);
+
+	if (!(ss_status & PR_SHADOW_STACK_ENABLE))
+		ksft_exit_fail_msg("Shadow stack is not enabled, should be enabled via glibc\n");
+
+	if (!register_signal_handler())
+		ksft_exit_fail_msg("Registering signal handler for SIGSEGV failed\n");
+
+	ksft_print_msg("Landing pad and shadow stack are enabled for binary\n");
+	cfi_ptrace_test();
+
+	execute_shadow_stack_tests();
+
+	return 0;
+}
+
+#pragma GCC pop_options
diff --git a/tools/testing/selftests/riscv/cfi/shadowstack.c b/tools/testing/selftests/riscv/cfi/shadowstack.c
new file mode 100644
index 000000000000..53387dbd9cf5
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/shadowstack.c
@@ -0,0 +1,385 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "../../kselftest.h"
+#include <sys/wait.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <asm-generic/unistd.h>
+#include <sys/mman.h>
+#include "shadowstack.h"
+#include "cfi_rv_test.h"
+
+static struct shadow_stack_tests shstk_tests[] = {
+	{ "shstk fork test\n", shadow_stack_fork_test },
+	{ "map shadow stack syscall\n", shadow_stack_map_test },
+	{ "shadow stack gup tests\n", shadow_stack_gup_tests },
+	{ "shadow stack signal tests\n", shadow_stack_signal_test},
+	{ "memory protections of shadow stack memory\n", shadow_stack_protection_test }
+};
+
+#define RISCV_SHADOW_STACK_TESTS ARRAY_SIZE(shstk_tests)
+
+/* do not optimize shadow stack related test functions */
+#pragma GCC push_options
+#pragma GCC optimize("O0")
+
+void zar(void)
+{
+	unsigned long ssp = 0;
+
+	ssp = csr_read(CSR_SSP);
+	ksft_print_msg("Spewing out shadow stack ptr: %lx\n"
+			"  This is to ensure shadow stack is indeed enabled and working\n",
+			ssp);
+}
+
+void bar(void)
+{
+	zar();
+}
+
+void foo(void)
+{
+	bar();
+}
+
+void zar_child(void)
+{
+	unsigned long ssp = 0;
+
+	ssp = csr_read(CSR_SSP);
+	ksft_print_msg("Spewing out shadow stack ptr: %lx\n"
+			"  This is to ensure shadow stack is indeed enabled and working\n",
+			ssp);
+}
+
+void bar_child(void)
+{
+	zar_child();
+}
+
+void foo_child(void)
+{
+	bar_child();
+}
+
+typedef void (call_func_ptr)(void);
+/*
+ * call couple of functions to test push pop.
+ */
+int shadow_stack_call_tests(call_func_ptr fn_ptr, bool parent)
+{
+	ksft_print_msg("dummy calls for sspush and sspopchk in context of %s\n",
+		       parent ? "parent" : "child");
+
+	(fn_ptr)();
+
+	return 0;
+}
+
+/* forks a thread, and ensure shadow stacks fork out */
+bool shadow_stack_fork_test(unsigned long test_num, void *ctx)
+{
+	int pid = 0, child_status = 0, parent_pid = 0, ret = 0;
+	unsigned long ss_status = 0;
+
+	ksft_print_msg("Exercising shadow stack fork test\n");
+
+	ret = my_syscall5(__NR_prctl, PR_GET_SHADOW_STACK_STATUS, &ss_status, 0, 0, 0);
+	if (ret) {
+		ksft_exit_skip("Shadow stack get status prctl failed with errorcode %d\n", ret);
+		return false;
+	}
+
+	if (!(ss_status & PR_SHADOW_STACK_ENABLE))
+		ksft_exit_skip("Shadow stack is not enabled, should be enabled via glibc\n");
+
+	parent_pid = getpid();
+	pid = fork();
+
+	if (pid) {
+		ksft_print_msg("Parent pid %d and child pid %d\n", parent_pid, pid);
+		shadow_stack_call_tests(&foo, true);
+	} else {
+		shadow_stack_call_tests(&foo_child, false);
+	}
+
+	if (pid) {
+		ksft_print_msg("Waiting on child to finish\n");
+		wait(&child_status);
+	} else {
+		/* exit child gracefully */
+		exit(0);
+	}
+
+	if (pid && WIFSIGNALED(child_status)) {
+		ksft_print_msg("Child faulted, fork test failed\n");
+		return false;
+	}
+
+	return true;
+}
+
+/* exercise `map_shadow_stack`, pivot to it and call some functions to ensure it works */
+#define SHADOW_STACK_ALLOC_SIZE 4096
+bool shadow_stack_map_test(unsigned long test_num, void *ctx)
+{
+	unsigned long shdw_addr;
+	int ret = 0;
+
+	ksft_print_msg("Exercising shadow stack map test\n");
+
+	shdw_addr = my_syscall3(__NR_map_shadow_stack, NULL, SHADOW_STACK_ALLOC_SIZE, 0);
+
+	if (((long)shdw_addr) <= 0) {
+		ksft_print_msg("map_shadow_stack failed with error code %d\n",
+			       (int)shdw_addr);
+		return false;
+	}
+
+	ret = munmap((void *)shdw_addr, SHADOW_STACK_ALLOC_SIZE);
+
+	if (ret) {
+		ksft_print_msg("munmap failed with error code %d\n", ret);
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * shadow stack protection tests. map a shadow stack and
+ * validate all memory protections work on it
+ */
+bool shadow_stack_protection_test(unsigned long test_num, void *ctx)
+{
+	unsigned long shdw_addr;
+	unsigned long *write_addr = NULL;
+	int ret = 0, pid = 0, child_status = 0;
+
+	ksft_print_msg("Exercising shadow stack protection test (WPT)\n");
+
+	shdw_addr = my_syscall3(__NR_map_shadow_stack, NULL, SHADOW_STACK_ALLOC_SIZE, 0);
+
+	if (((long)shdw_addr) <= 0) {
+		ksft_print_msg("map_shadow_stack failed with error code %d\n",
+			       (int)shdw_addr);
+		return false;
+	}
+
+	write_addr = (unsigned long *)shdw_addr;
+	pid = fork();
+
+	/* no child was created, return false */
+	if (pid == -1)
+		return false;
+
+	/*
+	 * try to perform a store from child on shadow stack memory
+	 * it should result in SIGSEGV
+	 */
+	if (!pid) {
+		/* below write must lead to SIGSEGV */
+		*write_addr = 0xdeadbeef;
+	} else {
+		wait(&child_status);
+	}
+
+	/* test fail, if 0xdeadbeef present on shadow stack address */
+	if (*write_addr == 0xdeadbeef) {
+		ksft_print_msg("Shadow stack WPT failed\n");
+		return false;
+	}
+
+	/* if child reached here, then fail */
+	if (!pid) {
+		ksft_print_msg("Shadow stack WPT failed: child reached unreachable state\n");
+		return false;
+	}
+
+	/* if child exited via signal handler but not for write on ss */
+	if (WIFEXITED(child_status) &&
+	    WEXITSTATUS(child_status) != CHILD_EXIT_CODE_SSWRITE) {
+		ksft_print_msg("Shadow stack WPT failed: child wasn't signaled for write\n");
+		return false;
+	}
+
+	ret = munmap(write_addr, SHADOW_STACK_ALLOC_SIZE);
+	if (ret) {
+		ksft_print_msg("Shadow stack WPT failed: munmap failed, error code %d\n",
+			       ret);
+		return false;
+	}
+
+	return true;
+}
+
+#define SS_MAGIC_WRITE_VAL 0xbeefdead
+
+int gup_tests(int mem_fd, unsigned long *shdw_addr)
+{
+	unsigned long val = 0;
+
+	lseek(mem_fd, (unsigned long)shdw_addr, SEEK_SET);
+	if (read(mem_fd, &val, sizeof(val)) < 0) {
+		ksft_print_msg("Reading shadow stack mem via gup failed\n");
+		return 1;
+	}
+
+	val = SS_MAGIC_WRITE_VAL;
+	lseek(mem_fd, (unsigned long)shdw_addr, SEEK_SET);
+	if (write(mem_fd, &val, sizeof(val)) < 0) {
+		ksft_print_msg("Writing shadow stack mem via gup failed\n");
+		return 1;
+	}
+
+	if (*shdw_addr != SS_MAGIC_WRITE_VAL) {
+		ksft_print_msg("GUP write to shadow stack memory failed\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+bool shadow_stack_gup_tests(unsigned long test_num, void *ctx)
+{
+	unsigned long shdw_addr = 0;
+	unsigned long *write_addr = NULL;
+	int fd = 0;
+	bool ret = false;
+
+	ksft_print_msg("Exercising shadow stack gup tests\n");
+	shdw_addr = my_syscall3(__NR_map_shadow_stack, NULL, SHADOW_STACK_ALLOC_SIZE, 0);
+
+	if (((long)shdw_addr) <= 0) {
+		ksft_print_msg("map_shadow_stack failed with error code %d\n", (int)shdw_addr);
+		return false;
+	}
+
+	write_addr = (unsigned long *)shdw_addr;
+
+	fd = open("/proc/self/mem", O_RDWR);
+	if (fd == -1)
+		return false;
+
+	if (gup_tests(fd, write_addr)) {
+		ksft_print_msg("gup tests failed\n");
+		goto out;
+	}
+
+	ret = true;
+out:
+	if (shdw_addr && munmap(write_addr, SHADOW_STACK_ALLOC_SIZE)) {
+		ksft_print_msg("munmap failed with error code %d\n", ret);
+		ret = false;
+	}
+
+	return ret;
+}
+
+volatile bool break_loop;
+
+void sigusr1_handler(int signo)
+{
+	break_loop = true;
+}
+
+bool sigusr1_signal_test(void)
+{
+	struct sigaction sa = {};
+
+	sa.sa_handler = sigusr1_handler;
+	sa.sa_flags = 0;
+	sigemptyset(&sa.sa_mask);
+	if (sigaction(SIGUSR1, &sa, NULL)) {
+		ksft_print_msg("Registering signal handler for SIGUSR1 failed\n");
+		return false;
+	}
+
+	return true;
+}
+
+/*
+ * shadow stack signal test. shadow stack must be enabled.
+ * register a signal, fork another thread which is waiting
+ * on signal. Send a signal from parent to child, verify
+ * that signal was received by child. If not test fails
+ */
+bool shadow_stack_signal_test(unsigned long test_num, void *ctx)
+{
+	int pid = 0, child_status = 0, ret = 0;
+	unsigned long ss_status = 0;
+
+	ksft_print_msg("Exercising shadow stack signal test\n");
+
+	ret = my_syscall5(__NR_prctl, PR_GET_SHADOW_STACK_STATUS, &ss_status, 0, 0, 0);
+	if (ret) {
+		ksft_print_msg("Shadow stack get status prctl failed with errorcode %d\n", ret);
+		return false;
+	}
+
+	if (!(ss_status & PR_SHADOW_STACK_ENABLE))
+		ksft_print_msg("Shadow stack is not enabled, should be enabled via glibc\n");
+
+	/* this should be caught by signal handler and do an exit */
+	if (!sigusr1_signal_test()) {
+		ksft_print_msg("Registering sigusr1 handler failed\n");
+		exit(-1);
+	}
+
+	pid = fork();
+
+	if (pid == -1) {
+		ksft_print_msg("Signal test: fork failed\n");
+		goto out;
+	}
+
+	if (pid == 0) {
+		while (!break_loop)
+			sleep(1);
+
+		exit(11);
+		/* child shouldn't go beyond here */
+	}
+
+	/* send SIGUSR1 to child */
+	kill(pid, SIGUSR1);
+	wait(&child_status);
+
+out:
+
+	return (WIFEXITED(child_status) &&
+		WEXITSTATUS(child_status) == 11);
+}
+
+int execute_shadow_stack_tests(void)
+{
+	int ret = 0;
+	unsigned long test_count = 0;
+	unsigned long shstk_status = 0;
+	bool test_pass = false;
+
+	ksft_print_msg("Executing RISC-V shadow stack self tests\n");
+	ksft_set_plan(RISCV_SHADOW_STACK_TESTS);
+
+	ret = my_syscall5(__NR_prctl, PR_GET_SHADOW_STACK_STATUS, &shstk_status, 0, 0, 0);
+
+	if (ret != 0)
+		ksft_exit_fail_msg("Get shadow stack status failed with %d\n", ret);
+
+	/*
+	 * If we are here that means get shadow stack status succeeded and
+	 * thus shadow stack support is baked in the kernel.
+	 */
+	while (test_count < RISCV_SHADOW_STACK_TESTS) {
+		test_pass = (*shstk_tests[test_count].t_func)(test_count, NULL);
+		ksft_test_result(test_pass, shstk_tests[test_count].name);
+		test_count++;
+	}
+
+	ksft_finished();
+
+	return 0;
+}
+
+#pragma GCC pop_options
diff --git a/tools/testing/selftests/riscv/cfi/shadowstack.h b/tools/testing/selftests/riscv/cfi/shadowstack.h
new file mode 100644
index 000000000000..0be510167de3
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/shadowstack.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef SELFTEST_SHADOWSTACK_TEST_H
+#define SELFTEST_SHADOWSTACK_TEST_H
+#include <stddef.h>
+#include <linux/prctl.h>
+
+/*
+ * a cfi test returns true for success or false for fail
+ * takes a number for test number to index into array and void pointer.
+ */
+typedef bool (*shstk_test_func)(unsigned long test_num, void *);
+
+struct shadow_stack_tests {
+	char *name;
+	shstk_test_func t_func;
+};
+
+bool shadow_stack_fork_test(unsigned long test_num, void *ctx);
+bool shadow_stack_map_test(unsigned long test_num, void *ctx);
+bool shadow_stack_protection_test(unsigned long test_num, void *ctx);
+bool shadow_stack_gup_tests(unsigned long test_num, void *ctx);
+bool shadow_stack_signal_test(unsigned long test_num, void *ctx);
+
+int execute_shadow_stack_tests(void);
+
+#endif

-- 
2.45.0


