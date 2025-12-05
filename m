Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066F5D339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67AD06B028B; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568986B028D; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455FB6B028E; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 343D36B028B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF6EDC02EB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:58 +0000 (UTC)
X-FDA: 84186286716.25.4409116
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4E42140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKMBLQlG;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960117;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkSjJz3KEg3Fo5ReCqUJTodeq3lTDSMEpnOhxCy/wHs=;
	b=d0Iie/rewIbwPIL4lygwVx9YNXW9MLG/DwWr7fHNOaCuYgKnDBBi23LJPrS1n9DSnklgYZ
	D0dom8wWwW3bZ4ascPPWku0/dgo8s8Dd2iztKrKUTAPvhOTFCaWzU1DeYzevALf3+wUo6o
	388FCPKX30AZ3UreV3UmghQUrXbgSlQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pKMBLQlG;
	spf=pass (imf26.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960117; a=rsa-sha256;
	cv=none;
	b=l0zZdv0tiLmSL5lhKh4zV51LUoRK053MKHI1Ibv+H+FLA6xeSuvjfjJ8UFoIdAoR150y1W
	/d70v38c8fhwTOa1NiyGdOmgffWURbuTS/ehGh4lgK91SAe4nj98PylZgTauC9UhIQSFKe
	d66XYz7jCs437lcN3593eEBuFZzy1GA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 297EE4453D;
	Fri,  5 Dec 2025 18:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D18BCC4AF12;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960111;
	bh=QbH4U9WsnCS4LKZRC8bN7+fGRQLAKu+WMoAcfVBmy2o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pKMBLQlG+zbmaq09bAbM6CLSu5Kl1w/T0b8jLnh5W0kV09NZCdqZ4UL0YtralIWQG
	 0JTtZQnuCbMPuF2EUR7jrWpyH8dEKNrtQ2Md36K/ESLC9/n8V+USoPXblOuDc9gY/i
	 eRFRsV14tdPHkek8VHij/QL9oYpoUqM7KSevJ8uK8hqBEfzVuI0HHpBTGyoEDyc01Q
	 bWcNItc52nKpkDwCiOkwLAsWL839jIhTE0PJpU70bchqNqlyQjLH1A1m6mizUR1RWq
	 /hDJk8UF1M4IdYOLC5KVZ+uOekzVenHXaeZVH9D/E1XBh74FC1Ft9KrWylsjxTyhPy
	 xBHV6gaTQcmiQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3628D339B9;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:48 -0800
Subject: [PATCH v25 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-10-1a07c0127361@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-1a07c0127361@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=5985;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2itqViQexaOTmpRjpWR4wDqh6fiZE0fHduuB5yNYi2Q=;
 b=L5rs+4Im+MQcjOOAl+1K4AEUkyAGwv6SJo/Wgr8AYqxhgQZdtv1/nV7zT+ArvSggHfXprPrAv
 Yw4nzPVye+FC2Mbd8oECuHiarrwvnQHZzBS+LbZNteZBcyH6QlF8t4S
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: dek9ckqnnyh7gm3yogfuw6kf88cc7cyo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4E42140006
X-HE-Tag: 1764960116-82629
X-HE-Meta: U2FsdGVkX1/L3yTDb3N4J4K7etQiXIe3VnL8o7Vc8idivitEr/6JvBMQNpSKNobah7i8WG3B3u9oX4v/azWoXpDY+/Z2rjHXk1Sqi3nWouiksjjrUjQiLEKTKdnbnqliQi3alyUA2ODN3M56iSk6khXAWc1UZsCEX8jA5NrWJyezExjVGK2jpRrwzRYYxDmAtflsN7PBUKT43cfs0gbu6wx9Lsfi8DIRS/07HXjHnjJMX3aoLS5FuI9FyZ7xNwF0Ghl2vRCZlP3B/LF1wbHfqEvXhExIx4ZCr97pm9oGqZTgwoUkpKA/Dgd5pakNVPbBEoF0q4ZgIDIObAN3TBMEREzned0aSb1WAzJE63bvxgSlFAZ6tQnK9/N9MvmxOyNeQ9ny29dCCz8PerymCoGROGf9NoTJxMDBCU6gktzZLgT5d81QLgn5QPCl6NOL8JfTXcpOKWwgPYR5sLDjbcI8oSEPuQHdlfLlpLonP18VAnV0PIXN+BdJU8VI788aI2OVuBUEFIyj7dnGiRL+zBiymKe2koTBJPenXHw6RKmG3clGZ3WshS5VMaHhZPH0Bdcek+IV7l/URYje7+Wjx0N45u2Y9L1ej60lRyIVPdd1rPMpE3ZsNKZNG4h63aPjP+KupE+NGInrsS8qvPfLqBeFBaFH6KAmroh8Vccf/MvTfeOarH7ZPqM+gY0W9GQ4xPWmcX8fi/RQK9r37ycqzONrXMENzK2km8BEOHYHFTWydv5ZrDL5b785TLO06QqFxe+vlZqb7ALXfd6INa6WA/kShA/V2cA2ZQaJtjYZaTugUi1sj/RLEKFG+675Ed+yJUJM6RXcatC+Hlm3B6Fa78GtCmwWKKhyS17QKhPFflLIdd7HoWU7iraKMAb8ZVVS6pmEdRX+Op9XE21D9APthx2/5Y7REB6t6wO17IlRCFnOq0XmxPUa4ixTPEKTeMbtkq6XbwK9Tu8MnlXo7YjkHXv
 L0Xmkjxe
 P2TtrI3IV5jIqD2XADqXwBd4ILu1bTLLHAIKGmVd6z/nGr7yAtZR9wa7UXW++KROi+4FXy13WHG2jse3j6gHcPXvAR1JXJQXqbtl38p9NWaKr8fnlbK/HT9P7Im1DY2ZXRfkcfl9+gmUpQoILZBTvW25DNnqKau2ByivilDit1GHXJWHL2T+n2Afb6Gk4pLAVXY1ZNkVGcTByRxhTjzU9y4LcQXKDEV60R/PjFr+LYTyZrdJ60CFV2qRLu+7/L9an2diy8SFSUU8x+pZfU4YarDpvELmUeUd4VsHys5TvqY0LxkbyOuXVwN878etb4Kubt2an9LMDYSc6bJxhGMMPPCJxgZBLKpXlYIX8H20ihYoNPTw1b11PhNiO/V1OtWa25LfmulTo9oJOja8+Uqrof+tSZEqKvmo8D+B9Jsw5uT87yxEkUN2gbvtJWym2NLyTFgonMMst4haw2f6HZZuMuwTOnieb2CwywvVLJcN8n+pUHv2oF7xtmdP+cuyuOlUUA9t1nOfKGVQtwk3YJII4xFcpYFYOPgY1c7jU5mUmkOX3Nx9XlqWfF248y9MT9+HQWNtvgaVIzIW4Ii29fgtqo/zoRas1lUo7uR6dr51kqAWLQSPXz7DRAqOkx222xSTrAOJPDpvuISeEzMc=
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



