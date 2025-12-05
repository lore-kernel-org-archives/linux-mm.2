Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E79A1D339BA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B2696B0285; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762976B0287; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A1B6B0288; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53AB96B0285
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:41:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EED7133596
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:57 +0000 (UTC)
X-FDA: 84186286674.04.CF1CE9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1F85F4000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:41:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFfszPMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764960115;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWzcR5c9YDnx425qwvIid5QvjL66zxIJ0Ca0MgIZGqE=;
	b=EivOGDPuHHuKjhy2lfoD/SHhoOUSBGc5hrsaqtoQF7Tj62LMi/HpzjHf5z58Q19XvMUPh7
	9OeFhJUrUUlfvDNyjRuX8BodxBsLbKWRpltGAJ/I5pPoSEu3BEN2s6rQV3vzd0STcCR865
	BefNeJcJWVfPvh1tbktf715SzPJL/ug=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFfszPMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764960115; a=rsa-sha256;
	cv=none;
	b=KIs2hqJdDBoYHsvDmweAYgS9SVwIpZldAdLaiSvPJq3SUndglpxHzaGxEZmRW4FTwYZuYS
	bZTs0R/KVKNwymQvGP6bV8pfmmFWAoQ1YxMv7JCPtcvkGlKMAC729fzdCQRNFzL/7d/9Uh
	AApkR5QgOUqTrK8vY+Em+Vor9VpBXbw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB3D6444FF;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D00EC2BCF4;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764960110;
	bh=lJBxGtUxX1ML+GQ5mbkI60bpfUo2bpfFzmOpADbeTJI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eFfszPMqogm3poECa6l5ZBewpXUVt2N6P/zkLgDcUO06wQzbGQRcKve/EHquUgN3r
	 mbw+wV68+POkLtfXAwmoZMIGDFVQ+sVg6irgqlunaAxwW/mfh5SCE5D2yZMsmYSUg5
	 FB0OQymmjS5qmyntv3UUAseYgkgq1n1woesROJUKqRQo9Xt0KQa+Mv1Jx1q5s/y36n
	 3zo6tvDkTQNHVil+j6oQnR5hXH27PRpynCeU7J/XH9B0iAbu7jZhNl4+Iuql1UYph2
	 /m5SqhuQCBD8QWXrIU63it5MZBjluXw7JBQIFicubyt5FG4b3zLjARMbaSp/ofs8uS
	 xsj1ey80/Q4gQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58AD4D339AE;
	Fri,  5 Dec 2025 18:41:50 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Fri, 05 Dec 2025 10:41:44 -0800
Subject: [PATCH v25 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-6-1a07c0127361@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764960107; l=4345;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=S6iS9MzpSn4NM/2oev7SNcHK5+9hek6gf9jlYKR3Pow=;
 b=kQiEjA+LjJtIWm+kVaGpIuG4bRWyodQTXnps3YB4gSBRWO6TSLPPTluKf24r9u97jagShSGal
 RVo+f/hXzR2BjSwHRqEPLWJduK68WVNyi/q7QyADFw6qh8Yh9gKArNY
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Rspam-User: 
X-Stat-Signature: hmrb1xuowna5cxe3q3txqxhby4cpnmx7
X-Rspamd-Queue-Id: 1F85F4000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1764960114-605323
X-HE-Meta: U2FsdGVkX18N8oW/iwTIaZdVXBhYOu0kFdaaRqoZJBgOodRRdy2+/NSpCab3Aie2jJ2xzqmNtrZ3Obg/xc7ySlEqNiorkjFebBqKtncW7ek5BpUT4tGrKiMPH9shEtQJmq3dDS5Uhfnbf1LFGsCnWnOnroWa61L6OlhcseU8dZir9Jy6NSwW7yE+imd35aQZ3/r7u6hT/UbKkLdLEneIigl/HU/4GksJHGitsZLzWG0o8lo/qwXterZfuU2Ir5HkdmMu97ouh/RjQghCdCXRULIaYt23DBZ8yEuZyk6Ud4PHInIpyN8QVcVOKjgqrO7zubXZk/De6CQcWznPa7Eb25dZzqDOkfQ6iTrljpMb70dydTI4HsWv3jitj70Da1/4IaY0aFP8SqIcles8xrE/4t/U2RatMmSm0Q0vhenwG4dKkDfDTH5u3QLi6i9yGo/iOr1cD5oqXsPWo+L90a4CI+0cFvz6Utw+pCE4kavWxXqnyQyPZVh54bj+qGz1iKFb/9nT6OTOGYXQliWdu2dzc4/emc6h5dElqyOHvZaktqxi6Rhbifp7Z+oU10fRFnJY8UYpeiBsnKVXmZLkv100O9cvF2zv9cWXYtoHrGvVJJEaw1bpV1VuE7bJJsRk1+a4kOFo/DHz4erBDjOmV4GFDYaXHUae/X8EsZGYoaFHG0lDGHt+rDvQmkb2MF0nnYk272NFMh4mc6Yx0PlszfKos9kfrnAWXuGGr/6tYYNy5dNh9oSmiiHHoQOsUY/jcOPTRqB88wvWmmoBhyIqo3ye5z18U0dDeTt3G/vU5f9EsWepZj6UVsLBiIQNF8orSZ8Dznler/jtn9ZWZMTNE7USA/oplF02Av4u2XLcD3DCadUXlBpVjqyWSau92iHk/9UGjDQYN4eaMe8t6fC1fp+7yj4g8Ct2vqDAWKmVF4jmC2ip2aPGirQ1PSzKkjT2Q+Mq0t2FxutRuqyFh1qu/b9
 ieltTdq2
 +FrM9c0DTpmNWKrxsFtyJnO1qbObyG5YtVdKV/L4POruDy0gI0l4+s9KGFvaLRG2WjM//U6EXrW9Wz/X9/+WUSiRGCadhxfq2QOqCaQ/BdEDC2YrQl/JfTnp5fcqpF4VDyeJ2xB6ncT1sxEVIciYQDKfGye3NjJazXc4L9qZbE3YU09Jw9lysCKZwbX6f6sUR2WLtD2epTqLjqA7qfo58Y30iIx2CLCPz/PUNLjvCKg7lC7i1V2L6uvpIOH+LBh1rlfw0f62GGDlw4LJCCh+QpxJ+NAeOyvld3xd0pjdNUctr8fv8SSDnJcWzoy9De/UgIAfDnxrdp+RY7uA2VSNhjugIhF303DT+1ngdIogVVWo5K0/lrIVAZuQHaksg4Qeh0JlHKfRhbFsjIqTRwCHINoaXIwPID7+3dBj7lpuou3Mf4+5MgRvSTr2nzOrZzR801anRYOuw21BpuzmOtviFK5/tBdTQhvuKuhPlaWIHtdRD4gf98rMZUtOHsF9Ym89nr7mxa4Ctcd59WdJiQh83N5Wp9XLDd//Nderxh/mDPTSl22v8hHgcuI3oGO3jMSiPR6AZP7gwHSiAmhAwV3kdxGB1JmNwqOpLRcJKoLiffzvBEl8=
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
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
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



