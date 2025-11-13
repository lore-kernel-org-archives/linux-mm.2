Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4637ACD4F3E
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E208E001B; Wed, 12 Nov 2025 19:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5AB48E001F; Wed, 12 Nov 2025 19:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FA328E001D; Wed, 12 Nov 2025 19:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 682758E001B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D64112E239
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:50 +0000 (UTC)
X-FDA: 84103736220.26.450E618
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16CCF180006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ABNEJHOh;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994628;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gSZIZiIe1rFHzirY+RE3NHaD/H1uyvQkN5ahK+tEx4=;
	b=kyE3juLj+CaI6YUyoXdBjjrIZYkJd3IZ15Hl9/x32uYx9+bHKwpkiMa0IKMw5sdxM1gHet
	DxD2pKaFgY16qWq4t6dhZueIOXfDGVVlhs2vqSc+R91DHxsaZK6YafaWx3FL5jmDaosVWD
	5RYs+g0WCKssnykPWCA8qAu0wtW89Ec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ABNEJHOh;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994628; a=rsa-sha256;
	cv=none;
	b=QUBDoeFlaiDUlEWhyW+TUTYjysOAyq/SYhlRWPn9E1e1UD0cKn+dLYTl4oIW7oA/hB6hoq
	tEk5gdQ26y8aPYhZKyuspZsc4WO/jt5vDGzzMmARGdjsgeyKAxAzvaR6jcxybalgo4hsN7
	+SZHqd6hJ5EfGFvuzCe8DhUYrVpOY98=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3056544732;
	Thu, 13 Nov 2025 00:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2F43C4AF66;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=PlVOTfxiFdxRNLTdX4dqlDsv054uEXpji11bw+5kLIE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ABNEJHOhi1b5/hMKYkGs4kvDzI0NfnPawHLysP3CShJGbA4xOkqCbo38vFXapIMBA
	 WFtmJx+ad6R+paF3O4U6rtjnRqsrHEzkMsLZnsOAno+8XMZeExYtVWlsv8tslWU+4p
	 mduyCNSaityvwENGGKEME9vkyp7ixpwNMQFQnJRAd0VTPUqb4q6+ZCUDgHqiCvh+IH
	 R93Z+lUDel4phjlrCTub700EZt47MNQONYGZeH8iSjQZ70BqGSCDsq8LWUX37IuidN
	 RshmL1DFN9s7ej5G3rG1QnMCnOGGL9Wjm2puh1T49Na5+mQOSgBXhpFQK87p3Hh4Lm
	 lYwOmsTr8Py4g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B14CD4F2C;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:08 -0800
Subject: [PATCH v23 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-10-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
In-Reply-To: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=5859;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=5Dpi0F62LP39Dgmrt3WyznsUlZ0jmq2vQ8Erm0w2YDA=;
 b=0zbfRV6ft7uUyS3BpZFufQcaAwEUyRAzLqTZI+C906j6EIvtF5vjZo8QRB6Kn3BBLl5ycPZzL
 A2ZABIQlvbcD665RPcIiSJUSZQ57aQU49K3/zN50+bRYAYMhRd9pAUI
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16CCF180006
X-Stat-Signature: 4d95q37zeg95p6j5yapz3nm3qg3k33it
X-Rspam-User: 
X-HE-Tag: 1762994627-293660
X-HE-Meta: U2FsdGVkX1/s7s8twvGyNPaeJsAv+9arjga+2ATdha3PMnK9fQbuL2JtUUUpEwsCzIkJPnvzAcipTnLI+EMEiFT+NZmoeXnsQYK+t9/LEhNvV8tobEx4NAiPRvRlUDZw93RGd6TB0lOzUemBFrVvsEBAXhcnq2QPVaCbuTdrFu/XejV4AhYDPnK7N/LTtEARpMoMAuaUd2LyO4SNqoy+PU8d4FUGAvZG2XL88GvMWc6ucck0r6coKtHcWh4sFDZmTgznsqpARziTvKg+WswKn2PPpDjn0tFsdsXPjgDo2512U9CBCn4VcqzRt5zSLB7LBe4frb3wpTJpbL/4p/GYEKOl3W0jDJ35EIYJV68C2pJ8OkPF+AtUuvOFSzCOXLL7u+0E77IZLI62Topwd0GjSPMOCPbXIQ4q4mQHMSwQNWElkcRbYiLdjaL6sQHyG+i6IwkfUhhQxu+PaWIalnfs2aXLd8O4Aa1DhM7s/WF44Y/94OE3hToesyW/4y8xBmz1p+iBd/MZhhS/nP/HInE04WfAaY2CImdjBiSm4jaewrf3VyW0p8zKkWpF9H0T4cyRu4zVt3/Y8DRyAy17A3qoS+6kRjjWucMxzu4QdvnR2cmvqZ56bLOB8JzJiyk2oMUdp5wTHp6UEYjwMyyM647LX5ZajZeYlWkEEgDYtoBRs5YBhe0eByOuAYebHoJsGkvWJipFCKyZ9lmSpy14ngqu8XkGSvX8LEB5U5jm+Dg9EuSLSQPgPTvgDMr5jHVu19z9c3HLePbAk/8epcmkbvD30Zw6hsvBnQzh/3/o//tof+1HQUBAcg3G4s5GUz01xzFpydtB1lyyGrSEzO/vnXhodI0vVmBy9ic5Mz8fnyVQIfXp8f/+TK3iqHkobwS9puj3PAZ70SsVHRF2rv4pSZ77YQlU0jKvvPGYCbsRhYK/7D/LYNzP8iGALw5SgaeolhzG/avwkc04ed0UsgDdzsM
 SOG4zq6h
 r1wA/jLgtA9b/HDKAAKqmJcg3obnvfuLqZL56ax8EdNqyz/QkrJ6ZLSj/xwYweAltA9dVVKxGFtvryPjR21SPqolN8C2fVQUghHO447rtZhrKB7ZA0FMbb1Kd9mO+9Gl/NX3zYP56z4ixnuOg9spQ5engawIAF82i4EdZfUvQruQ0UPYV3Fi4aZzd65Z/8mfl+GLo1kfZauYTI6jVgqKYwRTEwpgTRbtcIub0RHaHCN7FMov3AbbKilKlJvmisXG3WgesEN5IJtJP1tH2UxWs3wuxX3ZPPhXRtEPWznXUIbsSxLnR+mSmXGvWR5bkUeessM0/vMDZQRCVjCFMCTjvsO+H2hkfBT09x8qFmC5yyXHuDYkNwXL0y7e5NPGrzAj4vpaOgA6dWgf+HgXcJCH+zIoDhpiB5FGC+zPiDlJf4YSUyuWDlIAfqpl3/Oq0fumGX1bwzswwyGLJpWbnjMbRxF5+kSijnUBkbw1HWCbuIJJQYqn0xcRTD4JT/1l3d102H+NZxtDy8UhSfHH07NQ7FAb3lH/pFhh9PfNf5rPOtbLG2vXp9sn9+HVSTvd6oTyU/3ErGd0xcN3Q2TE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

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
 arch/riscv/kernel/usercfi.c | 142 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)

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
index 000000000000..251c3faccbf8
--- /dev/null
+++ b/arch/riscv/kernel/usercfi.c
@@ -0,0 +1,142 @@
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
+	asm goto(".option push\n"
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



