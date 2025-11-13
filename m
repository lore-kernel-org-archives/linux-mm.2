Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C15CD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E054C8E0019; Wed, 12 Nov 2025 19:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DBE8E0016; Wed, 12 Nov 2025 19:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7D918E0019; Wed, 12 Nov 2025 19:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACD0D8E0016
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:43:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BE9312E23E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:48 +0000 (UTC)
X-FDA: 84103736136.09.956B3EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7327940003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:43:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSPZRyz9;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762994626;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkuWRk+Hw3Iwq2yIUED4SPO3SLGbi8C5ZzKMsGI5lDE=;
	b=SP5h2+E442/xfy27T2ZpxDBmTezCDt92owUhPrCotK8wG97XTkGJm41LuriuZfA2n5WivB
	Z3GMVio3xXE+RaekXxOwj1mn7u0CwQH7jvO7XB4augLFS8oiSjCJjXqk7KfxvJg51aVfra
	aKOQ+GMIvfIZHeY3XdGbFLAH/HO4dJE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSPZRyz9;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762994626; a=rsa-sha256;
	cv=none;
	b=mEu58b5dXC2Q7sRSDp71U0I1cdpXaG8fDYVHuu0WcZ55xLFcczo3PmI8yoImoIXaqCORP+
	jce7AtOe4luVfFUavJvJwSG7p19X0VgeowXqh7gS5enH6oJ6N0M5wbpyF24GOVandVh8YE
	Ub4Y/uePz52UtSbibV/2EzwaYcElAnY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DE79044715;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A751C2BCC4;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762994622;
	bh=jfi/tBpf4uppa0Lsww7t4vNIORLQ7w31XNrfEZ1Fvxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CSPZRyz90p9IYKaaaaxCVnp4Nl9gA+/7KQU38fL7JJGFm0W+y9rb7HoiKsyY0l6zA
	 UCPl1cOXxnqAd5e3Nye2FKxIcbzccDFwzbP1K57RTWWLuqNgj+m7yOYptWnz5dkhcd
	 13qFz4HVSrHs/yGHCQwU1Pw77jcRXbpoM74BOzC8lBSqcC4qfsnJS+UfIAcbkLB5kD
	 m7miouHw17QaYY1mXHMbA+DWxpUgN4HRPDoq61U6P2rHWx8k3Ib/R+kqToWJoV8ROn
	 NLKHJVO2VugSJ3kQaogHndjOSxyyw8neQ5BncoO+ZC+vJ0rxNT1gI2Rz2F6Wz8UsE5
	 Lc5eAJAxIMgAA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C156CD4F2A;
	Thu, 13 Nov 2025 00:43:42 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Wed, 12 Nov 2025 16:43:04 -0800
Subject: [PATCH v23 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251112-v5_user_cfi_series-v23-6-b55691eacf4f@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1762994618; l=4219;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=lpSh/4YF4b6DV2vqO7uhXaAxm8ZQQfhDo9tNU1Zgc2g=;
 b=He5Ojlz6cjGM/VJRt23CyG7jXvrwDEs5E2Wo+I1dwe36mE0DfaK3v9msi0F2FBLNzYQgnAzJ0
 JkIknttpojPATvNAgIhKBl9T2uMGuISM1b3cMPXkVi0RP8B2W2E2qCX
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspamd-Queue-Id: 7327940003
X-Stat-Signature: jy83cm9aaicsmh5d5xcwg3dk9149qf8h
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762994626-286225
X-HE-Meta: U2FsdGVkX196NWXYOItd8tLTSgODmK6lwiZr6jZsHohK+tmqwgSadY7P0YUetgbQ1idlnNrQV22qbh8m9aNAFhRqfxkG1QrsxxCrjpQCWNiSGPUyllIpXxfB3bf6Aig/Vf8ZYhvD4f4TF8Y32sqp/pk0qcB6vJKzqdQAGvUlzZasAg1mlm8ok3Cmc9SnX4JNFPExr6gz1A+UuCUCYyI/8JgUUafeboVIx4/2wT6+nOJ0WgGSBYQ6km3nOS5PAzL8dllNzKzW+HeV+y4L0F4Jxyt+tjib7uJjVZayCbJKevH56Hs7+OFR1crgZz/cLt9fCv45pOgBnb2k520updYjY8TgeNRlK6fWOwu/R67BDCmZA2CbGWCPCNRs0kvMrDOhO4THO10drrN95l1jD1c/VUc2N1MXaA14OJfa5hQxqqBl10Vx15OOjmW7ZCcg7MzXfQTrGkzjTPCc42Xty13w1moYFnk44SBdqjAO4ydk57e295LKN2tJf7keqS0Xu8+dIjHjIs6SCO7nwF0wr595TGUMF5oGvzSs4dN6WWwn99re4GZK3WdLz873A7i7x4I4mALEnSOhYPHmVdd714yk2PF3VaShTPB7+d43mR0CKcJV8NCMJcU0lXG7ny/3t2TlqiY8CS0OsTWl/STGBj68xokqoahxJi9bGw1kalWsEktKAfXDtfgaKtYXGBLDCt4Aij4Z0kFiy3uMbRFTBqy2Puj0wpfIAht1qe0feyetj/O0z2LIIZFk7dpAHxfhXNcEj78K6VtpDJLcFIsMThTirM2Vp0NnheIUK6NDmDYjny2r000jC6KKZz8gdxJcLH2VPXM7oBwMYf/Gs/FQ7JcJOUZo6HM/hhCCQDHmuUJzXL+SRWgHCPivRegHyy685QZ7jUrDkQ2Ryq72RvyQA3TpSHPfgcmaE86ImUS71GpoTNk3CbMPhq7s4DDmporVbuAS9WP1MdLLMsCBlfXVX8S
 O/rTxJFJ
 41fBKksRrSSueUY4FHlpuXkcPRlP3YG6diuvwCihEh6T6zp3SlOszmjoD1lpdzRirNwOtCiyT6dVoGXN3FtZ/KUwmLNsSXqeyzHdpPZNLEm/VQQohsEgVrgs88q8oUywaW6ehJI8Fh6SNfEPtA/S/CI6Ly2MDDvAN5MA/bUnJujo/XtoQjgHGM83Ae6QHS4tKty2jMMPFdi6PCVqGZ3aP2Hq5OtRyZR9yZHN29QhVBOHRNX2gBYTJn7sOebGi/KmldChMEQspfLI1b4R2XXMy06782oLWy/K6zqW93X5YPLz3+K8OK5HpXYx8RZfS0TAtOhc0unvPZZjlEpmpNduYdTa1Sln3PJsKj2VmTg8oFjA2BhAEdnUPWhr/11+f37hAy4TGFWcrzewY3GI1v4cSsHsBfm93yi3sAugT/WtW0uQmObJr8xKEw8XmkV+zCTwDm4DMIgliJGp+9Kry09gD5F8Ss4Oiyvt8fvUQOgWAjqY/SMWkrwTwdBUSGKSminRgTMdk/bprbugQasTGPlM2sjC7W4hyjS+cMpU2EF1PNA4beCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Deepak Gupta <debug@rivosinc.com>

`arch_calc_vm_prot_bits` is implemented on risc-v to return VM_READ |
VM_WRITE if PROT_WRITE is specified. Similarly `riscv_sys_mmap` is
updated to convert all incoming PROT_WRITE to (PROT_WRITE | PROT_READ).
This is to make sure that any existing apps using PROT_WRITE still work.

Earlier `protection_map[VM_WRITE]` used to pick read-write PTE encodings.
Now `protection_map[VM_WRITE]` will always pick PAGE_SHADOWSTACK PTE
encodings for shadow stack. Above changes ensure that existing apps
continue to work because underneath kernel will be picking
`protection_map[VM_WRITE|VM_READ]` PTE encodings.

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/mman.h    | 26 ++++++++++++++++++++++++++
 arch/riscv/include/asm/pgtable.h |  1 +
 arch/riscv/kernel/sys_riscv.c    | 10 ++++++++++
 arch/riscv/mm/init.c             |  2 +-
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/mman.h b/arch/riscv/include/asm/mman.h
new file mode 100644
index 000000000000..0ad1d19832eb
--- /dev/null
+++ b/arch/riscv/include/asm/mman.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_MMAN_H__
+#define __ASM_MMAN_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <uapi/asm/mman.h>
+
+static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
+						   unsigned long pkey __always_unused)
+{
+	unsigned long ret = 0;
+
+	/*
+	 * If PROT_WRITE was specified, force it to VM_READ | VM_WRITE.
+	 * Only VM_WRITE means shadow stack.
+	 */
+	if (prot & PROT_WRITE)
+		ret = (VM_READ | VM_WRITE);
+	return ret;
+}
+
+#define arch_calc_vm_prot_bits(prot, pkey) arch_calc_vm_prot_bits(prot, pkey)
+
+#endif /* ! __ASM_MMAN_H__ */
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 29e994a9afb6..4c4057a2550e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -182,6 +182,7 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define PAGE_READ_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ | _PAGE_EXEC)
 #define PAGE_WRITE_EXEC		__pgprot(_PAGE_BASE | _PAGE_READ |	\
 					 _PAGE_EXEC | _PAGE_WRITE)
+#define PAGE_SHADOWSTACK       __pgprot(_PAGE_BASE | _PAGE_WRITE)
 
 #define PAGE_COPY		PAGE_READ
 #define PAGE_COPY_EXEC		PAGE_READ_EXEC
diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.c
index 795b2e815ac9..22fc9b3268be 100644
--- a/arch/riscv/kernel/sys_riscv.c
+++ b/arch/riscv/kernel/sys_riscv.c
@@ -7,6 +7,7 @@
 
 #include <linux/syscalls.h>
 #include <asm/cacheflush.h>
+#include <asm-generic/mman-common.h>
 
 static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 			   unsigned long prot, unsigned long flags,
@@ -16,6 +17,15 @@ static long riscv_sys_mmap(unsigned long addr, unsigned long len,
 	if (unlikely(offset & (~PAGE_MASK >> page_shift_offset)))
 		return -EINVAL;
 
+	/*
+	 * If PROT_WRITE is specified then extend that to PROT_READ
+	 * protection_map[VM_WRITE] is now going to select shadow stack encodings.
+	 * So specifying PROT_WRITE actually should select protection_map [VM_WRITE | VM_READ]
+	 * If user wants to create shadow stack then they should use `map_shadow_stack` syscall.
+	 */
+	if (unlikely((prot & PROT_WRITE) && !(prot & PROT_READ)))
+		prot |= PROT_READ;
+
 	return ksys_mmap_pgoff(addr, len, prot, flags, fd,
 			       offset >> (PAGE_SHIFT - page_shift_offset));
 }
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index d85efe74a4b6..62ab2c7de7c8 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -376,7 +376,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
 static const pgprot_t protection_map[16] = {
 	[VM_NONE]					= PAGE_NONE,
 	[VM_READ]					= PAGE_READ,
-	[VM_WRITE]					= PAGE_COPY,
+	[VM_WRITE]					= PAGE_SHADOWSTACK,
 	[VM_WRITE | VM_READ]				= PAGE_COPY,
 	[VM_EXEC]					= PAGE_EXEC,
 	[VM_EXEC | VM_READ]				= PAGE_READ_EXEC,

-- 
2.43.0



