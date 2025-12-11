Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EBBD41D6B
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 17:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0180E6B0027; Thu, 11 Dec 2025 12:21:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFE66B002A; Thu, 11 Dec 2025 12:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6E06B0029; Thu, 11 Dec 2025 12:21:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A80B06B0027
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:21:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A07988C9D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:15 +0000 (UTC)
X-FDA: 84207856110.15.5DCA6AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63648C000B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 17:21:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3echqbA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765473673; a=rsa-sha256;
	cv=none;
	b=MOfXx6Bg7IG22Ieb0BTYaqlWntw0pi1ol6KYpghfr8uF1ZiYGnol0xR0oB9DxKAibubXwc
	BJnEKNK8pLju/esP/aApY5hx2gyDbEDDgUOCNqX/ixiq24Rg3oBNq8zuFHXJfCStO9LRNT
	fHaqdCyFrjTUi9J3wq/NGO60U1IGUPQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=S3echqbA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765473673;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkSjJz3KEg3Fo5ReCqUJTodeq3lTDSMEpnOhxCy/wHs=;
	b=Mc381KDgRWaeTronLoSOZv64iZRJvUKbH8ubSd3SgKgswcWyUam2leBsGeWwtuuM0cN6CJ
	q3Nv7JWgbTo9hYtbaqHNvYryF347EoVekqIv8Ick9LBkPNYseyEVv/xig54njC4zBbEUsm
	+XHCwLMO3U4iOnwipeNApSuVMSBmitA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA4DD444DB;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71EB2C4AF65;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765473667;
	bh=QbH4U9WsnCS4LKZRC8bN7+fGRQLAKu+WMoAcfVBmy2o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=S3echqbA2Vu6bl+MOtKWQZ/zJrVCu/d7al+n+2p7RiRk1CDxiqp1OETVLoUdW0dqG
	 G+KzHIakFCT+RQmuyUlz/elOO12+oXtf+YepL/HHxHb3YqwXr/7q+rCPYGFP0aNm9h
	 900cfqdZaDVdxPwu5tbcQe8V1d5ufxO2J4Eegve6EaFt3sSCvl66OO9QiKEtYhvFzz
	 slZ/8Mci0IwTJgcVTjWRpYlY2BZFqmpYppx/mgThxI2gmMFPl5r2bG4DpQ1tOK1f63
	 z7uuQ0qezZosvKi3PPgxq7BFy3ASIjH1i+Bg2JPqy4cXb3NKKAlVFm8gHpEpQFw/j5
	 ew5/h7tD0oy7A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56643D41D72;
	Thu, 11 Dec 2025 17:21:07 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 11 Dec 2025 09:20:43 -0800
Subject: [PATCH v26 10/28] riscv/mm: Implement map_shadow_stack() syscall
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251211-v5_user_cfi_series-v26-10-f0f419e81ac0@rivosinc.com>
References: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
In-Reply-To: <20251211-v5_user_cfi_series-v26-0-f0f419e81ac0@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765473664; l=5985;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=2itqViQexaOTmpRjpWR4wDqh6fiZE0fHduuB5yNYi2Q=;
 b=UXInGKtAUDENobkdalJfcFJmYzOp9dlfW+t5jfHDAv3IkcNPTwftB97uQh/mdOvXAqa7qrDie
 2/TftOmJFGgB6em7gArLLhLq4+y4a92zvauxSX6mxQhTyJiVzlA+jX1
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Stat-Signature: 8fcce5msthjisr1d4z38etdghedizd1j
X-Rspamd-Queue-Id: 63648C000B
X-HE-Tag: 1765473673-492517
X-HE-Meta: U2FsdGVkX1/tWyvEYNXWcbh6BrwV6uM8HeBxADdLErBLY3W6FfbVzvDA2FJdO8+aR56Wam8XdxO0vFYAB3X+PVzwErpozIKPbmnqlJoBtQxjmEztNGMw32gOu0T7fP/HsCAiJdq4EXArdTm5ywT8xlym4+aW/dLyHVS31hrpBhE2YbgQCeQ4v3QJ0FBo81d9fa1sAMYlyHIxd39ehS+YVJyoR1DZIhNJEpComtRt66aJUPKPkreRRo90lKQE8PzvHohnbdN5pKavNoT7HrigysMaZTjxTIp4GunYD/j/jNVEJO7DSX7wv1SQjAoNy3s3UjVlY2klChWqm26eDuCIkMKTZBod/EFpdpr/mkeselfXjaxG5F6rMX2LvU1vsP62XIlvbquLeoyavYSeacfBx/qBem0FermAM6XW+r2M7ECr6BSD8Njz8maAzBME0/H7Bt2QCNzvqF8wHZo3BKO++KBduRWq6EUgGNcl3VzJ+O/2Zs/r1MNjz2Yn84xMsbGmUg7e1sPzVh9956QR0DvAcPasYTQU08ImWqXJZ7Woskaq9YoVUnxDhu2zLZwJkGARuvY6rh/70Pwr59uvG8gaarlg+wXwUQ2d+49IKYX/wqFZO7Aqb72AVjwktJplilCG4r9ucr3mzAAES6YIFRSWzjxJgDMpcATsn36QtHEKmItKjw92TgMXgnfOePzvG3Ikp4ZtzQNT+PM/TARsfrYhSWbh1/obHwz+QKigphDRpjCLWvRuQ1mcRiFJjqN8eUmztzqCJYVNsn9MvogtN8KG6agp/4s1DeNlEaHd+EopGyo8BLEJeR+O0LW/bQmXsqnb5jYGXfeQ4oXRMrOMrtcAdHz1fsCq+oeIjaiL5r7BvD9FcVtMVQR9ahqHK1aucaCQLiVL2/36jBfZvlksFypT5wqhnEj4j4bh5SUpJf6JeSS9D/r9d+NPzil0/N2Io08cwjfUq1jKKltSXdYAbPY
 2nYBLVGi
 YIhl5eS9Mq4rwKDT6ElIxbArl/nlpVQZgsZQY74BKxZ6BiY7jttSvaTsoHtLDocsdGAm2jYAZmOHGkV4w2LXq7UhG++ZWdbUB11x8Q1N+BLAEzkygdsF3KcFp3StN+5ty97iou7vvuKcrqmTCttVOtxitHvI/I3Pc1HmiQ6Gz5pi0+bgDoEuxw5p+uxa9c4dltp3XGNolpM+Jm6/PWobKAoAlUJ1wShtDGiM08g80mkDQhEkiUOOYAdy62AeUGAV7SN88bqD9KlDXCr8JtnscgIGCzJpHIFzrRfeA+dKeT4+xg3szCu5e4FAVuKa9G65UMAMTARbjw2nylT2QBGR5hwRLdolQhkcJ65xRcxMx3O6jbm488mQ+JDkBrYOILlVsA6HpjF0I9Hgez3V4ZRpu7OFD0FQ3RyYse6e0CVR3/iQpihZSo6cDsOhutyZR59pvx/9sEYWf1hlGdocQm1wheu+yiprqn47XxdusRT4pWzdTXEnmUkCijN5c9JwcXG3B6EyCf2VQNxpXqNkt6pTw7ESHpekQFIgXTJFmRenjJ7hAJXE8v+8qqlhA3CToe8cL677SxNmV4ZUnuetUL+taomdMGL1BqXvEnfH2J5lKdmrrOY603YmFRZjSW6vl1S7G1YAtsQt2xtQDKK4=
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



