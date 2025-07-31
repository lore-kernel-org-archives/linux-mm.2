Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CDBC87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D516B00C7; Thu, 31 Jul 2025 19:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B906B00C8; Thu, 31 Jul 2025 19:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDF66B00C9; Thu, 31 Jul 2025 19:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A4AA26B00C7
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 804D1160C35
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:44 +0000 (UTC)
X-FDA: 83726131608.25.216D132
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 80BF240007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=klSHwkdP;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
	b=n50tNn03rbUyzl+fSrrSxmOBc2fNYkt5q5SQglwwc5GbM9rJb/09M+fUywGbmPfoIKHuAm
	SShx0yPTs0AGh7hirVcLZfKm0cHpFt6v+vUr85EAP/c4g7DSOxIbixdUaMeN6qq9z2W9Za
	pb7vpFgyLj+kYolnV2ok+3BlIJJ9saU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004042; a=rsa-sha256;
	cv=none;
	b=0a6/aLXi//oSUJEPv9ZFcx12mefQ+FNnF+iEWbOrnCa8JMglLMmGe42sVm+GW1YDeyErRo
	2UFwkuh4oaCt57xLWRwLPUwOqESWm1sSr1fADzQcFrxGauybiiPr6PkvjtPZSOvSapZ55U
	Tg4hhK36d4AHjjTHxhPuq5fAtsm9kck=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=klSHwkdP;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-31c4a546cc2so208423a91.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004041; x=1754608841; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
        b=klSHwkdPUF7vjbOZn3SsOmai/gqkNhs8DclILbDvS7qzADWjLYC03vXgTnobm3D85Z
         rXLD5HMN4BXK4Yiro7MQO5hCsGTPM0SxJTDtFgfzKVEWeEIX43IOFQ5TExNEPaHoZiob
         E1p+hbCyy4o7fd21PgPhaC7/v3ADpoYMKMg/1i4iXx0VeSfdNFmcgrqn14+yG5dsXKq9
         4SyMk4S7G2KY4L7+ItgYJ5wPDAp+uOkV1qHTuhdHlqSBOz3Mv2n0d6CIX5xeT4sMKdER
         46j895YTecpAV23NBBR45PfWF2Bb3fG2jBre1IEovMGfy26cjGKXf0vZig46khmIgTnr
         ug8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004041; x=1754608841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiO9C5CKCCKloBn/52mfoKbE3jtuDM2WhM6jV239TRE=;
        b=RAv95FcC7UIZm+pfhUaWXWfB241COkzIr6BThVXRV1m+T27PDhyD7GLGWTlvrKSs3p
         2HRRBqxdreVmQtEXaftQrFXr6Xsrm2U11funAMZYRF47dy6c3R3sZIUuk6tM5JWn8X5y
         PIjbbCDn21hUgSs7HEd5m6GqW96TsqSiAramyOzJvJWz00w3Q8jAB0W/lEBlvbY446Ng
         4+aQ1GlCOe/lVEATXY7H30Twt6n/L+LmQk5GkAozTZMvJNrrFfjIR+IXDpGhn+h/Q0q7
         o3LjPSejUzZ81RVoz+RB5EeXgxrEnCLFJrdXRQ/XMrx7jH23peHbcBhRtMfl/9xHI/N7
         VQvA==
X-Forwarded-Encrypted: i=1; AJvYcCUjHxeSVs9cIBJ8eO4QHSFaxkYsu6nKZPThLBk1ws5g5s8bIKBC4TBP8E2RVE1NzCww++4Ay2wNMQ==@kvack.org
X-Gm-Message-State: AOJu0YxQnMLkEbJ00tBokUN28CxwUbnW0JfKUxLOE7YgbhPiYbKjIm/p
	9w9tK4U+TJrRnDAEI5vksKYZsXKZSp3RjCPgcLpS4DsnFtbdtbmeMNfLmx+TNulb5OY=
X-Gm-Gg: ASbGncuxshVjgfRq1dEe9lq47gRwDcXZnijM5TZpt9g0W8otRUjnVNPxpDdokAlp/N+
	vSIXBZHiQ6DWXIB0r9zjYll0XtfwZUNq+JpoOpdXKVw4SLtmzyBWdzpxAGdd9BluFBOAHEJ8GnF
	FuRoZsy4/7ho9/oR5tWTdD/GUxVr5NvRIEpB2KXZ0y16VyIQlajwllMe7OoDE1e9CrxZbguumM+
	B9/BhWb+yMgnr7q+Bn2rs2C5PZkVzJXxmGySMuQ41nERdOnSOdC1pAf7diCdg3K50r+TFI1AusI
	t7C94kLBdeDy7QUopMJS+x2NTrPHPPzJUGFIEDHQNjPKJkPz8H9Vt6pdxVenhBCj/NseIlHjeHu
	KQAezpoDJzgniHA6ELWX5rNv9KyExsdPR
X-Google-Smtp-Source: AGHT+IENkb+4ldgB9jpN2MPjKxjgVLKWrj3harodGzxMzJdpqaADTlQyaSoy0l3Iq8YWQhEKNv4baQ==
X-Received: by 2002:a17:90b:1f88:b0:31f:336a:f0db with SMTP id 98e67ed59e1d1-31f5ddc4b7fmr13164288a91.10.1754004041233;
        Thu, 31 Jul 2025 16:20:41 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:40 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:37 -0700
Subject: [PATCH v19 27/27] kselftest/riscv: kselftest for user mode cfi
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-27-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 80BF240007
X-Stat-Signature: u4dajksn4ys4nrmowgf91smu9ensq9gj
X-Rspam-User: 
X-HE-Tag: 1754004042-300995
X-HE-Meta: U2FsdGVkX19UHI0h9R9a1Sfi4cpE+W9b43btMXI4A4E8MvKpeGryTWiPamMTwnYrT/xY++IKtFdY/6UQQz+Y9ngwtiS+j5ZLtReyOhW4F2B/yo2OoxQEn0iziSmPoTFm/g7AWHLXMl83sHa1GEkXZzqxio/UPTafCn+9O0UXalIB7Cd+EZRvR4EtJx5cyvy3IcGNXieCszT72OGKBlKXhILnu9a9t/Sx7svHXGaNHnjZRzD3Wr2D3UnSUaIKspotVgAoYLMSessdquMsYJPg54fqlv71Xcbpqfzu9pGnaheB4GCJaNUZWPaR1bcpO0eoyUMPnsBg2gW3sVojFWhkvZuD1eFh6Aep3ZfjAtLpHTKB1ESU1Y9/hMwVSuOnxRSbAfrZW88TnugJmC3THZbkHvUUXOJ7r5GAqq+An2+oV0SwFTmD7W9A4mepFD9v9d5WZLCuuTbhkuv1tCKAMJSsUHj0LdQk4wykkZEIPt+Qv5OIQdIasD4aF15vnCd15xTuJbTuwqef7V4KqmNazepyxps/i04uG9P7R2YgcQZ61rwDoV6FZFehTGsLL7lbdFy6WZP93CFjecpOKoQz28Dy0dM4JxZJ/RUiLrEusn0kHJ0ZrC3EQRjYxfPdwWjFuVtu2aeFnPPyPvNIPToH678kybMeFgzBZbpjDV3MCy/tnPOJd/5s1AA7yUI1fjvlCGIM7M4BV4numnIpMpzQrRBwr4gUA7F4UZ5FnrxIWmX/pdn1cxId7Txor3LNplOtvTkA4nzG5znRUTofzmmtil1c2apccOG+viAsbUI9HplM9Oje/yYo7ODiM/eleyUEKtCxsVYnTCA0i5MHfNtun+gMemxvBcHzHb9HqBhzI/5KPCOsjX2RfcmoeUm/pbrp4TprJ9BBS+Bxtm86tKYBoAPyFpN8KFHkUKs6HBzGfNdg0GUGBH+n8X/pBkyQub3k4xh5UMmEhdn6UZSI5hrGz3Y
 BYXMyFYq
 5zrc0jtpbF6l1rMO84l/fmNTG3HaSeJ7w1aIAnvhAiA7HCZSgqUGQ8RNrUKhJDqIntFUtusHdR+CpkbckTbnfsWy/0M1hhYenglk3OT8nVJmm5mha7e5DT/D0RjGO6Djm2FMLXAdBdS2uOpsh3uoIr6fb5u1E6HnvkgkhgO+dadgegq35se65QDZQq9y5bZa0oVVFuxBn/fqOXB0CRXiwM5DwS5tfykLLpJCHWgEFn1g205Ieb6iiInvxGZ7pwucD2ccJF2UoNwtVfMElLbgngTI9xOsOV0q3VXhkugjWFvMwDohyBEkuDnVmLHiSCr0Gt2DFDuizivCBDZ/BHSvDOSkX/Gm6eRxLeeARNWn5xeGSa0G8JDnp+f0qljs1Kws74wrYLWXydQWh9255F2+3jkDv6DWShlFkrnQNWxie3DqrnQhxJB9kstuQ4vIKqOCzmMDS66GwlSSlQG7zRnGWbAI6vTS7EEwCuCuuegzV40BeVwpju/ByC96WsA==
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


