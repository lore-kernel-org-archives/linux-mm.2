Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF57CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285288E001A; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210478E0019; Thu, 23 Oct 2025 12:51:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060BA8E001A; Thu, 23 Oct 2025 12:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB7668E0019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9B49C0BEA
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:19 +0000 (UTC)
X-FDA: 84029969478.27.BF93E0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A630120003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvdK1IcY;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238277;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSwMSFItp0GRSIrlrBaZhZ/0a7IDeIygTJl5gQVVmxU=;
	b=VjveqSbsVpwjMQs8XL+oGd5nUIwRLk0ViysmpOtkg/DPEE6cym6X5IEjyFyg58Dp0KAsIU
	oHgm8UnxmIl6nnwJLTUAr6EhT3dlt1BpXZPmW/xSAGO7F0JsP995X5geSShzdCuZqFyh3J
	taivJ/uv0VhEQWZ2MpRwgWBA8YRaGTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KvdK1IcY;
	spf=pass (imf03.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238277; a=rsa-sha256;
	cv=none;
	b=m0Ff8fPFlR+1wP2WSKozqqE/zhOQ2rKijiek4EpeBx4zP4gk4Jxiag9ieBwGbeEW3j2kJw
	U0ECqs+B9VLB13eh2oQM1uGnTD8zXNmLqK8QbiVJNKFgQfvMuXGR/R8QkDtc6yQiBzkGLh
	P9Pi14pCT0Tls7J2usDlqjeS7o83haM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 208744B076;
	Thu, 23 Oct 2025 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98222C113D0;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=DSZOcvWZFN0rHYCNWpvA9TGjDlKItx92qqP4c9rzaOM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KvdK1IcYGXSlgjlbB9MiK86CO4touQjy+9RO+UK/jwaNnBK0lPakAMHFbJ3c4lr1m
	 6rtQvBJtdaMMQ0ALsdYSmILqMEGfQokePG0Kt/fNAn+vtQFCb8S267HjJobao3/BrQ
	 g3khV9BJhPTthbH8NOQwIJxM+4BK4by+C+XrpjyvTcyMQYkxcEauOIlc+uau+jIhtb
	 TzB52WRMqBI1rVr7nAjN2AeE9vX36IT+1I0BbnAcUy1+RCQYZ+G7eJFvQoe3D298vu
	 JPFLR9hshTSLL3jcjXv/KspjIHLsKUSJBfAET8/UDhUF0rUcmccnJrQ6yDUzXj6Xca
	 qGk00mSxucacA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86605CCF9E5;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:15 -0700
Subject: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-10-1935270f7636@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=5864;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=HpHI2zP/MHNPN2ZG0jq8qy7AdU5skeePc4YpaV5sqak=;
 b=LdZW8MX5X0gTuYgNZo+qz9v/7r3fspm5JhkJqUggQmQ+DtllbW/zuOG45fkr9bpQ/G8n4U+wl
 eEKWzSzcUPSBRnwWWMGMD6x+dEFdI8sefcErAEyd0GY8vXW/B9q0E14
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 6xqde36h4sa3bn1me1pp73gna1haxb4f
X-Rspamd-Queue-Id: A630120003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238277-103409
X-HE-Meta: U2FsdGVkX1+PCALDshG9bJPAA4f26c73zoAC6Fr7GuV1docHQzqf+iKs5dEbEc8P6rZlD+bWwrPJyMZTVKb4gxGKLfbteMobNjBIlkH2wJ0i9TKNU/GMMoSp/YTfmnIaKRaw8yD07TNqrMYOiSNHToxiOj86VC9t9IacT1asqcDqqBDPgLUANSjfaW6VH/fthZNNin0PuA2ZoQwwQAi8qGasj0mtqDLihf8zZ2lX7HtXQPEcY3gJdXSfeC1yobMvRPsN5WV6tQxgMibIzt1QiWjCAmrz3NwsesIhSVZ3bDsZ9dXhkxevRpL2lX6pa1Dx/Ow0fRlPZrFFyHT55Z8VybGHLcpGEdEeWBqpbYbyQlBpYbVhimPAWhfEaWwK939ZDP/2uqE2X2i49s9GWGcewb6tfJ27Bon/zOpin+toWGeTeoCjwJ/mXenrcVbr7AgyWeoDXcJZMyjuogrXD715G4wPC4iZSN/+bI3AaXRyHJXPnWxdAT6iDCiyDZDZqYGl6qIr/dWrAo2IgDj5vAbvwnBcBWOFISEwT79nc+gw43QRI5sSoXYWVqweXk3ntngbZsAPh5Y2By40PAsDFuyvQoYYnkXw9o1qb5iilp3VoG/6+HX0zYc3Gl3Lhzh4JWd7o5hdAhZWqjrXMT89otOL2UMXioiMwhf8pwsnfhRbII6URMRJs1TSvpFeqyypTveY9PywptTwm28+7/0DkC4OeqmfYNCVZaQ67Yn7MwOh9KX7WZRMOskpA5KR3Nxu2g0VNtqgYiG36eTo++sMpFLhSURB1KQPYBgBXVcGAr28VpxVAFXALybW6T+eJTQj/aZ0C96qbYW/8V4dd0toGTkF2T2orq6UKCTMtnA918pVyx7g7MDL9AuXmWZA56rPJbqfItrXr1+mcHA73yblVPaFqlUanq2GxNhZIm5vI7GaROZSGZj1IoxdPOit+TnFMVloeT/a87R94s6Ew4vizLQ
 Z0gFXpxV
 beA2UBhf1BeFOgZ6HwovpMijtAO4ihmxNJElFJW8tbQmPmu64rN8B0q3JZrnMnDU71zZR8FEVp3zepHy1zzSi8YAB0+AB7y0nVIIKoQMFvnXyEKbN+vnbrMzY2kXczIjnvSrvUNThWRLxIMPl4aA0fcHFlcqfBvVBlItG6wctt6wyccuw4sThemB9985iwGw3kTpdF22ywYKhgB2x0PIgqYwa4fmLsrRmlt2DlgJ4cknhmEB04fxsP2DQobA/SxUTIVnMkVM4b0u2wuGmiVdqP4OrbHxsLXcLJWPgbWePq8IqMi+YcMjyKj/YDDg/gk//XJTeoQEcVr9gFxDSkUuNFaszIwL8L8LKL1HqEevnmqCZpH+lye8HhnUIVrBpodUltJbm/pyC1nDvgJBWnFJ37UI9+fmzwSvRiSL3jdkpp5/b4KMH4HGoxU7pmlKvfZEZmf00Erwk52GJXY2QFYsxth8QorHSYI83kCrK0btnYp/cz0DLkJWXO62QcOmH6W/1Kt3KSOrtkhMOBk1Ap5mT8YJxtBZ3L2mwXiNhmHWqMd3AVhuQNY5pSMmXUy6cK32T36Ptj9AzfWMprlTsJC8qK9VR1A7caTqqta07sf3RW161aJjsPZqsfjvVHw==
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



