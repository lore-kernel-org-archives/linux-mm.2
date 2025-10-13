Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3B2CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA2B8E009A; Mon, 13 Oct 2025 17:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0794F8E0031; Mon, 13 Oct 2025 17:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DFF8E009A; Mon, 13 Oct 2025 17:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4A58E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6785147038
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:24 +0000 (UTC)
X-FDA: 83994450288.25.BAFF31A
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 85121A000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="JNe/gVUa";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392582; a=rsa-sha256;
	cv=none;
	b=4kWqhv59FlRS8HatYVy34xDu0MzdxbodZqxrSacS0P2ikh5qgV9Rql4EoEwAe3kfEAiQME
	3RkNFijyg1OXSQ+faeosMCzYr/xgdrQi/5ku9eeQVRclUrwnrdaYv6X2AhLVPONFobyyLW
	9DDKWmkVmLwE3LAs8Pm1EBY3OKfBLJQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="JNe/gVUa";
	spf=pass (imf25.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
	b=M5NSdpSRQErp7G9m+QpO9LrnXXGwtki+Un+Lhd8NnCv4belOSYLVs6wFst72JrMRe+Rg2H
	SsLQ3P3MFWLJ0TMQC/5yK7SpDw6n744jneWHwRo/escfupdDVhpmdWbj2rCp5/k2VGOlND
	/t7UKQx8eWOoQubrqBcSK7dG7JpNoLI=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3369dcfef12so5321578a91.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392581; x=1760997381; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=JNe/gVUakucQB04OZq+juDislJP1l1bigMyJ6MLT4qb4bLKdktph6BO0UcpLm1g4ut
         TOt9B1VUhQh6+EgBveA/frt9NDrDiqY+191gqSdcWvCrkdQCZaDDZh2uAO07QUFZ6Jue
         Nw/6/d7kY0Wi3+M3zEBjcy/Zywn3qpUsN+w4j3F3rHcgBImhkJ+swyxHkcYr6gGDUuNG
         wn/0JyRD+b8PKO8O0Zt5NBHbW/FGqHhxeVPN9HVABxS8vDGIqEQPJ+6eiIUit7rD8RMj
         2yGVKDArNa09q6Fi9UFdegCZNqGjk8/g//RmNu9myS9xteOP564MUZyUbF0mZ2Odtw2j
         OB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392581; x=1760997381;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2zbm+cvasSeWoh5NRRT51waj2rRu/qBUWCUacGfv0Qo=;
        b=ni9utsFIlRdMUYMicIWrRaZ8Jz/72nfPT4ybYG59JsVHQAJu5zzRLngX7yddFZFwbc
         PPfYDERtbX39CSKutLNvY+syY1uVU2OPYHwxDlKH+0lcxzyCBMZIz/GlC3Y5PJwl9hmW
         P8tWB50ZF/pZQXG3oF94OhuNWnS6tDyj9/RWdPIejKXxb5qWlfYh5ylrO8dCvyJvOcO2
         HMdD7Nwb82hGZ6kC+f6ZpBU0q7fNPB90yJyqbFIr4uxlyYkHod5kaZWWaY+oAV0awyR7
         F2ibb6wqCCpHNTZQEdrhjnRK3Hd9JaJjiTLhisl8eD82Xkv4K+DLCLVS+QqeGCZDN4KP
         y7rA==
X-Forwarded-Encrypted: i=1; AJvYcCUJTrkhoV0xxayPDK3LXF8X2ZIXRNJ7Mb3EybT0gQ8hhQzsg6RSrqDeXaT0Vtfu4cxCDO8r/f/7cQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4PV82jGBKEd44iP9P4tIrsthYhKrS2PXdKMSnhq2tty5gHcZx
	oDtvbtSwBJAvUJqiT+UvFGXMiRxN87uQFeAhkA08DqbKHNw0Gt0+ceHe6rlmwUXsY2U=
X-Gm-Gg: ASbGnctbf1WBB6ro3QqWqHgujtiFgUTNjvE+ROJoipF67uh2iJKA/Hf5PVJ39ciAhQP
	i+vEAwXH68meDaNnvi6f/nomzIDZIfiLvm9hsSVU0uqGae55LwhKCmv6Ey+TYOLRWA4dRAZnbO8
	rlpyLFcvAsPWjY73xznOnYtmV1t20pxOakhsGgeJC03iRlMbOuLMFkCvGVxC5ZBclhpzSNvIUcI
	FB4ClIGA8B0WNVtnY4hbEbVuxDyvloxQBLeD7fxsGHHQpOhrWto4vUAilySMfZynx+lwShE4Fv8
	WZrCJYw3JEpzh9UtbhLlr4ADmBs7rAxvzJCbUZmqr90KklVERZ11Uh+kjYNvq0fdzeEJC1tsWVT
	jQm8mXxHsIzoCvI+CsHW10BjRNMMo89ALk7Gl2m4VGKc53rgVKrRnOslWjYfNRg==
X-Google-Smtp-Source: AGHT+IH2aM16uziaM+H2JTzUiIlcdNp/HFJgSd8zU/93dEXG3WxK3O7M3bw31zbvPmN0Ojf7SBbvIA==
X-Received: by 2002:a17:90b:1b43:b0:32e:18f2:7a59 with SMTP id 98e67ed59e1d1-33b5116251cmr34255365a91.11.1760392581262;
        Mon, 13 Oct 2025 14:56:21 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:20 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:02 -0700
Subject: [PATCH v20 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-10-b9de4be9912e@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: aq1iwqy7cbzrq8mg76nuroc7q1swjirc
X-Rspamd-Queue-Id: 85121A000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760392582-521017
X-HE-Meta: U2FsdGVkX1/GtKLrXcIU0m0Tpw4++LjOqqe37H33zIssXeTKmpa4lAT3bgBEOd0P7xG83nVwex2t5UYNTpnE+ATOvMUu9RNjKJ2pYfOrJtIXVuaH4YSbTJuPJcc8oa5tyxHkUCM/Pxy1hzKK8Zr3PpfyYxjn4Gl89g+MlXCOP74zaOD+02FiwvL+cs+pRLDp7KTnNcdFtmK8KZIghD4lW3NDh/hDX1v3KfsGpMJZ4dnoZ2ghC2GKAwW0ga1uRcCEbeeX1cfzB7HtBUyxBMmHO1Pk4lK0xshk1WIiQoLUjGY3mqfrMbk2i33NekRNVGEOxNQIppNb17DUNg/p+lRwgLmocPeWOVnK/bt4pJ6v9d3XN3ZgIpPH0ifeeddRKIBkiA95MOWPejzymYmiub82I11KTXM3XNLJS4bjgXKxyye5v59O31R5pkIaB4KqtlfkgEENGhwQt14l2PmK/2uFhwhIVAm25eg1FXd3mflnWF7Ust43Q0BCyCNPtaXix3mwiQe7ptM/4miSMRg2heKr5EJV0sagDslcOf//OI5/Gd1QWUifruPM/bgE8RuRd8y7vuD2dPb9kt//StlYoe5gZPJXCZGeHtcm2o57Ti8Dm2/ThPpOqzRuqq+y542eUupuoNl9bw4HLsaNfewu/9H81zydvST6ug7M87GlhPj0dTEzeO9vhsdC6UUCStBGtnpOhn1fomI2vy5/tXS/hXZtANY1wlN9fu2Gsk2Ae8T7OoBfQv11eQsYeDVY/qKAhmOQHXyCPIrG14y3M2F8RTjg/5WHehZr496rQet44a6zmMxTdEkjGYltwo+b2TaYcZUHLaaH7tQxKnPGwD3NzDxt4C2UQ4DTXpm4TZzbLODtPK4oVKiiVwd9rBLTFyYDqkIemQaNJ2KrzXzAjPxltenesPPgqV24z/isnwYrBSlAzyT9i4Tgb2ESmVprhGQhaLguDokrSukAskBq9z9cEcy
 7grOQ7ts
 7CrNJxJiwr/HrbNVc/pG38iETVbW7qYxM4kA01bOCSUUlk/GLp79di1Tybzf3IBv0Pfbr4r2oZH1X0HLz0XIw+lezBRLrFjL+m8TEHfW3NwX/UdCYcm2hpl+KIVDpcO4jHyoU86dH5jrEAyE+o+GFG1Olscn4kQSQ3IqzOxdqvi9NQUReIGjxnyP636pzvtsI3GoF2FHIlfzo6a/eEPwR9Y+ojVYS8Ufd4clXAkqv1Iff2MB81m4uQXrqzVYApv8vRyBdiG3WDR3kK6SRoUlgUNXbTkGqQZCj7kBjKVGXQQ4KmP6pftkR/FQNm6brX3T58EHZBnQUiduHcRX2levU/oWBydSoON+OLya0D2oOWdNE5B/C8mFIl8vWb5KQfCi/LSOpN5dXkT4jM9Gr2CSCojM4Wv8MMLNlKNgJnuzpkTelN0ye35+8DFQAVPtMBb4AkmiR8BWk1Vf14/ykMPdDEvrjjmRJjlz75CH7Jmms38mZGhVrP5VDAztdkkZQtMtu+eUhkUYbRyVZSV3LhpC7/8z9ir4kfxyQ9G1q2SGl+02v5TvL/gR9thJ2Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed extensively in the changelog for the addition of this
syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
existing mmap() and madvise() syscalls do not map entirely well onto the
security requirements for shadow stack memory since they lead to windows
where memory is allocated but not yet protected or stacks which are not
properly and safely initialised. Instead a new syscall map_shadow_stack()
has been defined which allocates and initialises a shadow stack page.

This patch implements this syscall for riscv. riscv doesn't require token
to be setup by kernel because user mode can do that by itself. However to
provide compatibility and portability with other architectues, user mode
can specify token set flag.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/Makefile  |   1 +
 arch/riscv/kernel/usercfi.c | 143 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+)

diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f60fce69b725..2d0e0dcedbd3 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -125,3 +125,4 @@ obj-$(CONFIG_ACPI)		+= acpi.o
 obj-$(CONFIG_ACPI_NUMA)	+= acpi_numa.o
 
 obj-$(CONFIG_GENERIC_CPU_VULNERABILITIES) += bugs.o
+obj-$(CONFIG_RISCV_USER_CFI) += usercfi.o
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
new file mode 100644
index 000000000000..0b3bbb41490a
--- /dev/null
+++ b/arch/riscv/kernel/usercfi.c
@@ -0,0 +1,143 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2024 Rivos, Inc.
+ * Deepak Gupta <debug@rivosinc.com>
+ */
+
+#include <linux/sched.h>
+#include <linux/bitops.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/uaccess.h>
+#include <linux/sizes.h>
+#include <linux/user.h>
+#include <linux/syscalls.h>
+#include <linux/prctl.h>
+#include <asm/csr.h>
+#include <asm/usercfi.h>
+
+#define SHSTK_ENTRY_SIZE sizeof(void *)
+
+/*
+ * Writes on shadow stack can either be `sspush` or `ssamoswap`. `sspush` can happen
+ * implicitly on current shadow stack pointed to by CSR_SSP. `ssamoswap` takes pointer to
+ * shadow stack. To keep it simple, we plan to use `ssamoswap` to perform writes on shadow
+ * stack.
+ */
+static noinline unsigned long amo_user_shstk(unsigned long *addr, unsigned long val)
+{
+	/*
+	 * Never expect -1 on shadow stack. Expect return addresses and zero
+	 */
+	unsigned long swap = -1;
+
+	__enable_user_access();
+	asm goto(
+		".option push\n"
+		".option arch, +zicfiss\n"
+		"1: ssamoswap.d %[swap], %[val], %[addr]\n"
+		_ASM_EXTABLE(1b, %l[fault])
+		".option pop\n"
+		: [swap] "=r" (swap), [addr] "+A" (*addr)
+		: [val] "r" (val)
+		: "memory"
+		: fault
+		);
+	__disable_user_access();
+	return swap;
+fault:
+	__disable_user_access();
+	return -1;
+}
+
+/*
+ * Create a restore token on the shadow stack.  A token is always XLEN wide
+ * and aligned to XLEN.
+ */
+static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
+{
+	unsigned long addr;
+
+	/* Token must be aligned */
+	if (!IS_ALIGNED(ssp, SHSTK_ENTRY_SIZE))
+		return -EINVAL;
+
+	/* On RISC-V we're constructing token to be function of address itself */
+	addr = ssp - SHSTK_ENTRY_SIZE;
+
+	if (amo_user_shstk((unsigned long __user *)addr, (unsigned long)ssp) == -1)
+		return -EFAULT;
+
+	if (token_addr)
+		*token_addr = addr;
+
+	return 0;
+}
+
+static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
+					   unsigned long token_offset, bool set_tok)
+{
+	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
+	struct mm_struct *mm = current->mm;
+	unsigned long populate, tok_loc = 0;
+
+	if (addr)
+		flags |= MAP_FIXED_NOREPLACE;
+
+	mmap_write_lock(mm);
+	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
+		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
+	mmap_write_unlock(mm);
+
+	if (!set_tok || IS_ERR_VALUE(addr))
+		goto out;
+
+	if (create_rstor_token(addr + token_offset, &tok_loc)) {
+		vm_munmap(addr, size);
+		return -EINVAL;
+	}
+
+	addr = tok_loc;
+
+out:
+	return addr;
+}
+
+SYSCALL_DEFINE3(map_shadow_stack, unsigned long, addr, unsigned long, size, unsigned int, flags)
+{
+	bool set_tok = flags & SHADOW_STACK_SET_TOKEN;
+	unsigned long aligned_size = 0;
+
+	if (!cpu_supports_shadow_stack())
+		return -EOPNOTSUPP;
+
+	/* Anything other than set token should result in invalid param */
+	if (flags & ~SHADOW_STACK_SET_TOKEN)
+		return -EINVAL;
+
+	/*
+	 * Unlike other architectures, on RISC-V, SSP pointer is held in CSR_SSP and is available
+	 * CSR in all modes. CSR accesses are performed using 12bit index programmed in instruction
+	 * itself. This provides static property on register programming and writes to CSR can't
+	 * be unintentional from programmer's perspective. As long as programmer has guarded areas
+	 * which perform writes to CSR_SSP properly, shadow stack pivoting is not possible. Since
+	 * CSR_SSP is writeable by user mode, it itself can setup a shadow stack token subsequent
+	 * to allocation. Although in order to provide portablity with other architecture (because
+	 * `map_shadow_stack` is arch agnostic syscall), RISC-V will follow expectation of a token
+	 * flag in flags and if provided in flags, setup a token at the base.
+	 */
+
+	/* If there isn't space for a token */
+	if (set_tok && size < SHSTK_ENTRY_SIZE)
+		return -ENOSPC;
+
+	if (addr && (addr & (PAGE_SIZE - 1)))
+		return -EINVAL;
+
+	aligned_size = PAGE_ALIGN(size);
+	if (aligned_size < size)
+		return -EOVERFLOW;
+
+	return allocate_shadow_stack(addr, aligned_size, size, set_tok);
+}

-- 
2.43.0


