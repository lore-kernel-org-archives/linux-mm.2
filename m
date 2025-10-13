Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E0FCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECA58E00AD; Mon, 13 Oct 2025 17:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C6E8E00A2; Mon, 13 Oct 2025 17:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D8A8E00AD; Mon, 13 Oct 2025 17:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB4E88E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:57:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C666BA6A8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:57:04 +0000 (UTC)
X-FDA: 83994451968.30.3AFB3C0
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 944884000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:57:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NSxKqkHA;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
	b=MRHP6e29L1vbsXZkHtf1bpq02kVl/Z0+lkaEvF+As5wBEBxuBA7/gSlm6hQNkOSOWiNo1l
	Cq5ILJIgbSS9BMeB3RYOLU94dgFDpZGLP2amGOhVhM+/RMnNMKnPCFHMXcx4whtQTFW0cF
	gILC5bvcb0+D+NmbzKyB3OzoitDATZc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392622; a=rsa-sha256;
	cv=none;
	b=6F8JzTKQdzrzaC5Cn7gadELcpXMEN/Ud2S6jJtFl+nt2Uosvx1WL2tbYonlJE4v5/atAxQ
	AQ7nCtdMyS9wwKltE5h4A6ueo7VOBnQAG0AitsGi31Y+QG/NYL9mZrGJWPzM3+s4CZzM7Y
	vNpnwYoaCN8kPWbiHUYZB5tlx78Jt0E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=NSxKqkHA;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6271ea3a6fso2965507a12.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392621; x=1760997421; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
        b=NSxKqkHAjUAuT+d9Jyil0pQbvzN7fFIMCFGWy/snwVIoZLGNHZlYFnfQ0Q7m/CjE6/
         rb1gHftg5kugMSTqkc7Gm4mFrXSy+ZtwRcOv6hpuRyQwsDEMVLU8esBGrKJpMayUx1P6
         I9w6xbm6ZvOsGeh2Hrc4r9v+0F0Jp183QuKbp0JO135wNRv5BbWsLuFEO6A24wsalde5
         vmQjXOzeKyULTITRaEFW1WgWK3IiNuW2mPfE9kumbvNW6wbCNXui3ltXOVsE39Me4DOm
         2j59jbPHGC7bMqOR1W7NsDC3BhosE6fMqFYPwF3387r2J+Ottljw3UskXS5pdFq3B7hv
         w1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392621; x=1760997421;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
        b=a/Dip8JyRkwqQiDUU+LA9IwfCqHc/hBU75+3//eqfQ9vj6Yd8SQQEoyDWALQF3hasO
         UgP5tLCs6LVo/t/1LEJ3xyyBm9ko8AQLi3IV8gjXQew+IHw+xf2BwYrWoyZ4PCu/gOvs
         wrJiCJKN9Vwr8ve6m1KIfkakDRGT8T4XmulM3PBeSLXTd3DXbn+AdiDeq6f17Kobyksm
         cB2WJrBoYo+8V4aOVZU4aDFPqfrVIKLjgzPoTyKwjwHtheEDqBGi/xxDx71/uCnkAzgi
         9l84XWzMGZx//geHqiBoORA4oH9Uq5iPyHncqys5AaLyRRADVEbbldm5UMTKtg7xlmqe
         mbTA==
X-Forwarded-Encrypted: i=1; AJvYcCVrWdnZTriPpbdu/PuY1ViO4EM3kfvk9blaRoWdSMHaaAt+DP2z5NY/QgJAmEY7D7miWw7CIAJnyw==@kvack.org
X-Gm-Message-State: AOJu0YzRBoMjd6oD1TBTmd+LKg8xLNjfy7YhO7A5dyXmOxDhf9Nl2ndt
	4Osh5/ijgsZtD2NoDiRbZXC/SOYXkTFzVKoUkf6h0QmXz6jPir/YdMQ7RsLcAheyyvI=
X-Gm-Gg: ASbGncsINUlDXfulJqaqALzWvKMJGwF2CBv7CB4YeqoIQSbY2NNu+nU0dROsskWaEhZ
	n9FSw88wL/UTDPudfeM9E2l/nOqTrxH3UR7BPYZdWnusZmlP24i1GL86eF9vV3oc89gu5gu+LCW
	VhIi/ZI6NPnqzXzoqFCvByg59pbRTqzOpYw8jOl50C6ZvH6StlGKYMcW193TujvlUgVhRwbK8fX
	ZZjT5Z1VCrS5QvAp06qEiCMQHx6ou/AsbxCtXmjcnwWXqnSgcLiOZzz1nb3/DGtdstRcKhcP1zW
	2N+KrcMcOiEHx23oJiSfbCay8kTgr8DD7JM7tTua5LiakFdekkKpSLRRDMCwio2qBNpNJaFc3y1
	mFptanlqppE7BvtZkcHrWtULnlFMxxIPUwo2F80dm/+4kXu6tYGZH8FiaxospMA==
X-Google-Smtp-Source: AGHT+IH+3lQijGt7y8J7FJlumm4VHtJd+GQSqGYYHJpEiO78GhLy4UySBcXxj3KCk9A+C08j4EmOCA==
X-Received: by 2002:a17:903:3c4d:b0:269:b6c4:1005 with SMTP id d9443c01a7336-2902730331amr278507405ad.55.1760392621205;
        Mon, 13 Oct 2025 14:57:01 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:57:00 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:20 -0700
Subject: [PATCH v20 28/28] kselftest/riscv: kselftest for user mode cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-28-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 944884000F
X-Rspamd-Server: rspam02
X-Stat-Signature: s3ekob9x6ijxsdhphodracukkeq3memk
X-HE-Tag: 1760392622-928672
X-HE-Meta: U2FsdGVkX1/fDcMecgiAxljs2ouq6Det7/pkpkRp00v75246cUaIVVvDrSVo0i3SiLal+rdD6Sd9qi2a2uMfYshqmQM0w33SUtDZolsAhJJ71etGA7gO02AJbbTmnZrwAcCWLZeOM5MVS6Vd0HvoxSHD29tw9NRkFQMM+sIir1v9Had5vinY2gV4aC1hg3gHI4nm8/6T1uc1j1cR1qCdZRdn5Jb2gLrIbIMn9UeuL15W4vA45ybm9rOisP0dylrM8wVWPIHCNuRlQK1QLbt+7zc+RlD1LRjH2vdo45Jq//pZwhlPEQLtKITPLYu/1QIYmx6l694Lr7vGUC3EmNom+kjQNBM50QLKNHkcF2o/DXg7vxBd7yjXZAbXCqf6r2AoclqIkaw3M+IhumI0e//cwantPytvNZABWtRkhZtMU09l/siQwffw5mu2v6ZFfe8pvTtWmm8wyteLE9Ltp8+OCsSnT0bSfM/eok9tBW/H6cadvo5SVjf/PyDjDPAw2o9lYqnmIueKFjAoBM/pc8wzOGnJf4uIbAMg8bTx1/I/6oUzjKnLe1sshs13xH8yFtZLhyYRRsaZMLrQ0kDQjntlA3i1OGIPJi1roWGv8mQfGKvdKBbFZmLGe/3OW7e0uvkiwL1e/72+MWoBL/7R3GMuL4j4+rQNZotKCydkxtLZnffLrGDULnDPicd2w/pfZa4HANKayzDeWM7jxuRu7hvxiBUx+MentuQ0xPXhkt0xH8FSFSsFDth9tUWukpyvQmG2fr0MqIXEMhlWmlKKe3mmXNR9eTy0y+bDEEUjtY65wOUGMSvOr+Slc2lEA1ISZoTTVmj0GmwRvEIlURdCdPLplCiXASfY5/QXXcqrwW0Phs2nHBQJj6MMu1GHDjSj9CJxHVraZhwZadUYp6Te5waGfNhL3b/Puq7EbNmKVEosPZmFK4rSY/0yJ65g7UfiUpxFBuZlXjStJwtjMK5LiGL
 eKBuU43C
 2GsqiwDG2DpRZ41fmRHToOugrAl3S1rq1KUL/BBrLwMWwNXHoUV55EiBWVKx18YzthIrBO7dmYlnNH4Ogi+2dgNeJ2bcWurKUm85FVbrFyo5yGbbs4c+6ofqJ2OPJDIl7UgrLn0glezPNxSoc6fHanWxfMZnbPwLXi2OQBbU2U+dcYFx34tLmVbC60BDMc6wwuFu/zknddc/9oPNTcBUuxNEAi2qgW1g3euwcSZ5wwrfsJlkkXPkojupiOW5B6rRdFAnSNicM3hr454xIMsTqaN1Tu/lX6NJJyb/5j6V0Yzrpgz2xmiwXN1GAO7T/IiXQ4UJ9nvGh4A0MJ7X15oer0yRrBleYChTV8hkfH1StnK3TKCo9MBdSFYHfoT5Mufxgy56opRXZAJXRybMm6pqCUMi4KckrVTblvJVh
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

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Suggested-by: Charlie Jenkins <charlie@rivosinc.com>
---
 tools/testing/selftests/riscv/Makefile             |   2 +-
 tools/testing/selftests/riscv/cfi/.gitignore       |   3 +
 tools/testing/selftests/riscv/cfi/Makefile         |  16 +
 tools/testing/selftests/riscv/cfi/cfi_rv_test.h    |  82 +++++
 tools/testing/selftests/riscv/cfi/riscv_cfi_test.c | 173 +++++++++
 tools/testing/selftests/riscv/cfi/shadowstack.c    | 385 +++++++++++++++++++++
 tools/testing/selftests/riscv/cfi/shadowstack.h    |  27 ++
 7 files changed, 687 insertions(+), 1 deletion(-)

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
index 000000000000..82545863bac6
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/.gitignore
@@ -0,0 +1,3 @@
+cfitests
+riscv_cfi_test
+shadowstack
diff --git a/tools/testing/selftests/riscv/cfi/Makefile b/tools/testing/selftests/riscv/cfi/Makefile
new file mode 100644
index 000000000000..55165a93845f
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/Makefile
@@ -0,0 +1,16 @@
+CFLAGS += -I$(top_srcdir)/tools/include
+
+CFLAGS += -march=rv64gc_zicfilp_zicfiss -fcf-protection=full
+
+ifeq ($(shell $(CC) $(CFLAGS) -nostdlib -xc /dev/null -o /dev/null > /dev/null 2>&1; echo $$?),0)
+TEST_GEN_PROGS := cfitests
+
+include ../../lib.mk
+
+$(OUTPUT)/cfitests: riscv_cfi_test.c shadowstack.c
+	$(CC) -o$@ $(CFLAGS) $(LDFLAGS) $^
+else
+include ../../lib.mk
+
+$(shell echo "Toolchain doesn't support CFI, skipping CFI kselftest." >&2)
+endif
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
diff --git a/tools/testing/selftests/riscv/cfi/riscv_cfi_test.c b/tools/testing/selftests/riscv/cfi/riscv_cfi_test.c
new file mode 100644
index 000000000000..486a2e779053
--- /dev/null
+++ b/tools/testing/selftests/riscv/cfi/riscv_cfi_test.c
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
+		asm volatile (
+		"la a5, 1f\n"
+		"jalr a5 \n"
+		"nop \n"
+		"nop \n"
+		"1: nop\n"
+		: : : "a5");
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
+		} else
+			ksft_exit_fail_msg("%s: child didn't stop, failed\n", __func__);
+
+		switch (ptrace_test_num) {
+#define CFI_ENABLE_MASK (PTRACE_CFI_LP_EN_STATE |	\
+			PTRACE_CFI_SS_EN_STATE |	\
+			PTRACE_CFI_SS_PTR_STATE)
+		case 0:
+			if ((cfi_reg.cfi_status.cfi_state & CFI_ENABLE_MASK) != CFI_ENABLE_MASK)
+				ksft_exit_fail_msg("%s: ptrace_getregset failed, %llu\n", __func__,
+				cfi_reg.cfi_status.cfi_state);
+			if (!cfi_reg.shstk_ptr)
+				ksft_exit_fail_msg("%s: NULL shadow stack pointer, test failed\n",
+				__func__);
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
2.43.0


