Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5BACCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF67B8E0005; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8428E0012; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2B88E0005; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9116F8E0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:51:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60641129D4F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:15 +0000 (UTC)
X-FDA: 84029969310.19.9FF1D1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49719180003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:51:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNpbFPI3;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761238273;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkuWRk+Hw3Iwq2yIUED4SPO3SLGbi8C5ZzKMsGI5lDE=;
	b=BtVdsnu9XQ+DwiN5g8QqDvDBjmgg4ZFXutM+bnbX2FCJCZTNj0CWaAyFbEB6mqZ+rNkPDD
	svyn3uafAJDZXsrt+m9Pzsi44US5vGPf4lqTWM12ITP0xzdfO95U/lCPsehSH9GfcJro12
	/jOjnxddbRx3ZQCCRSq05jo3kTAMckQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jNpbFPI3;
	spf=pass (imf06.hostedemail.com: domain of devnull+debug.rivosinc.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+debug.rivosinc.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761238273; a=rsa-sha256;
	cv=none;
	b=v6Yjum0pOTM5ymB5MsGxdyeiXDNFFWM1lzr+9HBU1tfL8Fy7EKIChpwEnTXtkgAKSaZCTh
	pJiybROEIkyqaUWzaOV8LC/GUAlX1M3gu/H00WF4M8Jhg52VfOBVyHezQuhfIe0iiqCtPp
	fpj2+n0Y9HzVgEAoraoHdD3+/yizfY0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 676504B017;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DE6EC116C6;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761238270;
	bh=jfi/tBpf4uppa0Lsww7t4vNIORLQ7w31XNrfEZ1Fvxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=jNpbFPI3zHJ61LqWyHXQ1svtatEX8huvKCgO3B46751FGEWkxqJYea5bgaWIQBSxK
	 tTw/lQk0+SrkIescu7VxzrmTiRtZFienQmNxoBMPfjsfUuOQsJuKYIy05XKqCEVa0v
	 jK36OhpGOpCPtFf0SWleDdIfdUTnut4TlY8lFg6jQ1CGtxoz7262LzTrlavSp8DVfZ
	 wo+NPqhA7Jza1u9If62CNFf9lkzwGFzdJYpKDkFLNinXOmQ0IWEwInFaJQTtWqm2VA
	 brrUs0P+BWmvrYmkXkzKphdMOauSzfdqQNPQzGLFOnhTCMpkkMkJz+uTW7TBP1y+6X
	 l4s/2uHVJnNdA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FACECCD193;
	Thu, 23 Oct 2025 16:51:10 +0000 (UTC)
From: Deepak Gupta via B4 Relay <devnull+debug.rivosinc.com@kernel.org>
Date: Thu, 23 Oct 2025 09:51:11 -0700
Subject: [PATCH v22 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-6-1935270f7636@rivosinc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761238267; l=4219;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=lpSh/4YF4b6DV2vqO7uhXaAxm8ZQQfhDo9tNU1Zgc2g=;
 b=0EylOW1HFcIz/5REMir3O/jSROrnVVUk5arLG4UzCxrsPyagp0KCSw051bXWgRu0w/V5QIP59
 g3KUekTmgpwAXR3nS2Bj03Wx2+Ir/1Z/wbGjSWUq8l95BYeMUQF6vu0
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Endpoint-Received: by B4 Relay for debug@rivosinc.com/20251023 with
 auth_id=553
X-Original-From: Deepak Gupta <debug@rivosinc.com>
Reply-To: debug@rivosinc.com
X-Stat-Signature: 9xe75geshn59xu8gtmkcgpasohgtsgfu
X-Rspamd-Queue-Id: 49719180003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761238273-110889
X-HE-Meta: U2FsdGVkX1+t4dnRFnVE9ppwKKmz87Am14l1xolzoJqybJvdV9uwkCyxihRmtzEVItvfDoS9xhTt7DOYfuqrPE9qzfHW/2okS+ZTiUBzwyY9vesDhfHYtfFo0yUewHy3Q3CBdu6JRdGIr+p7wcyEisFSV/+7T0eXO83piTUYqouwFQppWHOuMxLsv24mlfX7Y442a7Qhhz1QjzVJnpe/o4jmgSEdKO6LrIcvjC1VBVHkTGWPwTLjoytwVet3DrqNxtoiIrRzRN6QHbH+kT8oLT+/0VpuwTQJbwzS68qPEKYsMp8hQdvCh17LaRY5RkT5Q0sh3Gu4SBk19nOFtHgU4EXQbhNafJUyPdtcLdqqY7/V7EEhLrPEAzDouhNpMkl9u9EWxCw0/C3nFR0q+Gn9CDV3XEpuMBJHRia09O6cSUpFNCo6C1aMa2pN4a6LUE6Rc2d5v7ZmSZ8XSZI9r8Av/xee3blOG5FisR6UHKE+RGxbKrkwwXSt3T1p6FRalxMR23cTzm/OAO3GfDXJ9+ARWeOXwSLCmT9MprXbNlK2PPa0YNYOg9a56TiJIZg8H9hoxKQaAUIeOI/iIqZpYUIE9xDzby7i6/7ZMPn5WR3GNmlrDUPWFtIqdjKuo20jFYv0jWKWeHaDEChpEegwxMZDMbNPoOU2opYDRFKNdTDgGxL1O3IlAhGgv08d5rRsUs+7ldhKr2ILsZXQxdU16+dCMcLNK4/3leDxlnakB0DBLqPHWEramfo0i3qgGORu+55oBdpv2b82uIUC1ccoyiZfpqlpUEHQqeV1CC5qn6wVetmseKMiZsrp+eBxFYttVmGpmOxOP062+DFEbNp0hr4JbACWuG2CJBR8TDI+QUuEdOjI7NiY/nMXnI0p3SvOeiTf91EXdVnoD8XUMqMmIGnwVMVBYPDbUeh4Gj7mb5YIXGcmiGW6ds7GIqOkEZYrqRN7V+1+TY+jTI9X9tDn/cW
 keEz3jF6
 2tHR9GigJIG6W2nhkpZ7q0HIhIFrsiRaNT4HwQ7hCDKNb4HVUNu2eBhhppza77f18vF46Ui2HEFlpiU+dBSkSq7KWMgjNg2s4BOCiN03YsS2rL/0FbIz/cwiWUjp/tBtlzTKNqIJFPHoxGcD0ckKQdIE+WAX2u+Pmh0lMzVhNBZIOF5ox8jx9gfDKtPze6jA4ZJisOqdMqBgqNMuoJHCCw63q8QxE0iLf/iq44pwS62CWdXsDSSSBb6Juk03VwWbKedsv0+xLStjRDpZfKWMdf0CHLjp8VZjHrl+mXJR/d9BttaGabr/QFihGYU2eYpGv2TvobZNqMKvd8U5j+u9DNf9yPTRAjFUlNkiLSWGEWtgx0YbOJZy3PHsuHvDMI6ztWgN8H+04HFs3h1VtRIiOlXJZ6J67llHtb1J2wQ9mPc+jxAP3RX/4SUuOTJfnvuZBKQa+Cij5VfQyQfh4pyPOwrFIidQRroBmwJ9MCCA/o9FQKacY9o7+gAjEEBOhcCs/cjICqVCRosnrQjJGgFV3cOJPTlhVaKqmF5gJgFdJ9LcjtdGYzCYk/Gqh/jcTpDPpRjNq/5khzAQghqej0Knf07BNIUTQVUxsqZBcpWDa/u2J6goWg+qgGOFHiQ==
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



