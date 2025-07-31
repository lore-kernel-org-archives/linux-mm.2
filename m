Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8289DC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413EB6B00A4; Thu, 31 Jul 2025 19:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4CD6B00A5; Thu, 31 Jul 2025 19:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D4E6B00A6; Thu, 31 Jul 2025 19:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 145C66B00A4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3B8681041
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:51 +0000 (UTC)
X-FDA: 83726129382.27.6815300
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 00ED9C0002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=zENtzfXi;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003990; a=rsa-sha256;
	cv=none;
	b=M2KhzzAepRAFtVYCQrf8k3oigJOGx24HYCC6J1tdDHZYXvS2WcED74agD8pWaSvIcYXWZk
	izHUslQldGnN5WfMXRHSBwJEMwloHS0ejFyHGc5ny2tODvizLr76t5q7iy9oZ2847QH436
	72yBdXYEs1UXqF4mJIoX1OLPLmKzssg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=zENtzfXi;
	spf=pass (imf10.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDxI/yYSpi877MHHGVz9e95SZkFrsQJCFVNaVAxUNkQ=;
	b=gH4ReWwV4Zo647pFX8XhlBPrsiqmilxAuWmqkH4gqKHoJ40LhsrV/BDLzLaLZ3xWlr40Vb
	3TUf5vcEX0fb6hxSt6flrV4FICXSgC+koAxO2WuFe0CPwpGERvkxoNOPxZug6cFmlQIP7Q
	R1T59WUCZ4YUhU3lgrfOKDLUkvxYC+w=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b34c068faf8so1641771a12.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003989; x=1754608789; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDxI/yYSpi877MHHGVz9e95SZkFrsQJCFVNaVAxUNkQ=;
        b=zENtzfXixk9sKT6/vAb1Ke+wPB804/B7BOTKhwVylTNudC/yDjeDWOCZf71WGtBy2W
         mYbSPXC07joVQ49QhwJhTev/l+XpJyRD29tektvrd6h01oddteVY3s8GKEG1YLJZHCH4
         /L9iWjcnFMXJndWLMr4RPPGZAuy4aymxfoVgmlBlcxgr82yTRvERI+rOt9bDEk2Iqnz8
         sZY9JbVU60D2Tyly1G3zYHd9vJ6iHVws7qRUoYK0vQICjdXVyW+PixJIx6atYHgPMuoK
         TEnbUr3diUTRNk6Kl7a16HYovzAPR6RRoHRvPbYHFdroOhGyz0gUjBzIPxKH9bbOw+o3
         LKpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003989; x=1754608789;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BDxI/yYSpi877MHHGVz9e95SZkFrsQJCFVNaVAxUNkQ=;
        b=NRfEMRu6iahRdAMyQ09ra8RDNyqtmCndaDhUNtq6DyzzLzBlakn8Nfy0uO4UfpY5yl
         pqXJ4yZ4Ql0Emg8vTj8AbE7m5at2ZrtH70Aiy2O3t6ZHIps2Fojwo842agmvjNu8hzp8
         E/PVVuLLRvt1R74jHcp+/UwSVGVV3n9cNToHaAou2fWNIC41tH39qKZFEzIP8Ota6Ivm
         7LEuLqbnk0lu8iitUim1PPPVBIjH/a3KYRYfQBnk6MTAU2b5uWckRwKP2huOiYisIHWn
         ibwMubpCGe+zzPEkeqbfPGhDsLbxZU29VjKEnjN1oveFUys7KcvUwiLzqx3YcTigWGRD
         YZ/A==
X-Forwarded-Encrypted: i=1; AJvYcCXvSFQhiY4j5S/LFpxwTw77sMjDVJqGBJzR7mT4G2PQBCZLvafxwV2r/nTE3r8/d19SUqBBAzbRpw==@kvack.org
X-Gm-Message-State: AOJu0YyFZN4loqVq6rnZHgn3QF+VvmI8spZKtCb1QoHXkY33pgkMsAWT
	kwp902cvv/qaM2I8HufzvcE4bWez4HIkMXzqbbdfcHPl1qcfPV42Le42eF3qfkpITgc=
X-Gm-Gg: ASbGncuU1Qv1zvUW22mbTNAYOt3dQEmxI2tpkCbOjuDknmxcnVncRGHTUjaAj+ELmiX
	7S64INmkOrv4oE0kl7wCq6mUxVLBTj/nNntWKqOPqSfb9lpsTix6aJiVWoRytU1/2vqLHjlIJmZ
	X2Hl/QN8CikOKzDWIZtDJIXpn82FTCKuByqY+wTChQ3nBV7qWt9qOTmZVFO71+WK04iWcYfkYxo
	j7ZkvXUlJQRjE+LRGzpU7mZMxnxWuAbG1+ZzlvfwMmP+QrZOE8ZwTq+MQpQxBIbh/s7D29p/E4I
	tCnvxgbHEuKbzHsMoSMR52QWDpyZFbLjLa/XrOU4qaD8EdKJxJ4F952zvnAajwxwouE1xGt2wvL
	XxNy4zcgix1y6QU4tddY6rP7whe23CLFp
X-Google-Smtp-Source: AGHT+IHbRNe6ZNAYcBCSeC6LgZjYMzbQ0gTo/m7tfbL6HfTv2l858/hsg/mRI/zEh5G32b1XeBkKGQ==
X-Received: by 2002:a17:902:d4c1:b0:240:1f25:d443 with SMTP id d9443c01a7336-24096ae7162mr126383425ad.30.1754003988752;
        Thu, 31 Jul 2025 16:19:48 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:48 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:20 -0700
Subject: [PATCH v19 10/27] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-10-09b468d7beab@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00ED9C0002
X-Stat-Signature: fd9zxd7gf8nugxfiwa7ufmyx9ifg6ag9
X-HE-Tag: 1754003989-618344
X-HE-Meta: U2FsdGVkX19uSacn4osxpU8LKxkJNGgLBeL9MmDrHgWt3x4hyayErfZrwjMDU+BDnODl6pR4eeCMoiZXo4sDzryc6Oifu2asK2KZWZPbmS+P4v+KE2Ndfz66bvUTw3hufyZ51DMPspya4ih2vo6otnh2fBjiAKge8kjFn8aK5j5VrbYQc0iAKK07x+xMjVP3zlUFFIeXWAE/NT9jXFsFnuPDCxR9BMlH9kPZjoLO5XrmndbCx1BUoprQd3keD3pged3iEw0zHTGO4sMIc5XFfKAyxbEyv2SRL2cLUSzHTK1o1OQoUeeSse+v0w/XboKgDqUuhFQ/sMEO8cKqyz4bHNLucE/awAr6lrn0RqILm8b4hZkq9vS5rMd81fbi3ebHCiXtHP8j6CKQ2oahzz81dEGbHg/DCJLKm8/jQsLYpi5Gr3qau/wvzynR2xv4U5hL62/OxDOGrzQk76Z91JWvzCEsBoxDst8Su1jQDgMqhqpLdCLQKic/0cBPtW6xgsk2zh98pEfkDCq4dB0b+hAayudREsF8gkzxdDZ+0t8JnNefJmepSc5SFGjV8RUzPPuphVQnhXTBQZDx0Y5kwusW4taKNMW5rOg8AaTNTEAhc1hLAx39OgNJiELTQoJlACugmxSC/PbDBt4Da6+Z8w6nVph9Wlk2z7FPc0srSTVgmpag6Kc2FK3D+uXIVLg/Rqi2BydAGsKVrt4NeAr6784AHfPL4SRrtbz/oF5yzYl/YoRv8/8jkWom0+6wOl+ogLzoC2erpKXND5aoIbXBvj54g4mdZUm4OQKMIdQ1vkSKI54yBrrvtY3ZVRA5gr2YGtCD7gJF+fkOuVh0Drd3rBnxGmRdNChNzyKqlIgJoLcCxk5+NRiCj8/vW1jNfM2TGQSBJD3VRZYI2755ZWYtl8NUVabfqgJ1iVdQQLEs+geA9zoYk90ge7AenEPhxNGwDHB2qpU/o/dN7uXR/A1W7s+
 65ncEdcy
 XUyD+FCzgUQfBqkdou0/PWmlAjD6rJNRhPCa7fuy+yTITr304jhsZE7q4613Zi7ku3Iv4S0aSrttKZRorTp9wtqxKguRITybFayK8s45cJ5T3WUpaQH6Xk4kMtLNK2rqMfjAkN4IpJdXGxOiKGdtzeRXRkuSo5oIWGi9Fl+qop9JrgIevtkDgZhsvsZZnsp74oO1EeJJGFSIfxYBcgQWo8x4Wh69qMhzI4QgLG5iko6+ReYLwAoCD20DMXs95yzoAZ72lnlYY7qZwbHl4IenmbzAeri/zj2Mrz3KExTkBdBg58YjHGvsQAS3AGgNmusHPUVTdwXK3SjXDDx5At01iHBp/suZBzIBQ0kssPDHugwjCNh7+0s4YM8q8WSmZHF+trbbMuH3oo3ogphpd8PTfLN/ys0tliawcQpbZh630TPc0rQeXdVFlPDi6UJHqi2jVXMT5nPgDs4s7eu43RJ54BqdX/5DipJm097SAxtC5zERVSYQvWz6EL4xjqSAljzQHHhRB9YDGO+35/ylT4YZUZV+/3fkNzxTglgRQuyuZoQIMXye0VztOlch4jS3SNVFu97/KeuGbsZr8Fs+5bcpcnBihdA+WHgd4Rnoo+WCR8xiRM1v4DY9S3qkR8zoDldQ9mf3xE7pdgK5Z+Qg=
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
index c7b542573407..0b245f36731e 100644
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


