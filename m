Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD3BEC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D076B009B; Thu, 31 Jul 2025 19:19:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155856B009C; Thu, 31 Jul 2025 19:19:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0FEF6B009D; Thu, 31 Jul 2025 19:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DCF536B009B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B916C0B6B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:39 +0000 (UTC)
X-FDA: 83726128878.09.1FD2136
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9DFAAC0005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ftzV4DsH;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003977; a=rsa-sha256;
	cv=none;
	b=mC+xt7xe4BQJzvAHUTuDn8I6lewKQgKbBGc2HJfOQUc2qVubJuY/0Nzdm1tJ2EQFCxUuGP
	VSikznOVK2HRO1Xvz/lpTgDLZh7DuyosYFZ0Da5iCFLQr0Dxj0jsFy3t1Qzd+nfgt+qcXS
	bUw+29OP6Xi+rvQ3ju/m0LGw8cjDyJs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=ftzV4DsH;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q+opQLK2FzSG8S2sXaAJverbmrDlQ+0+XTrAM6plEM=;
	b=TOqcGR1vGX3hE4T4P/FcdYvxLm/20jVO5bh4K7cmnMMpEnXRwsgCUmKAsW7m4jbxi+NG9v
	n46nb6ecd2LwpvUByGWsAPsu4Dh00NPmOIkq9fUvT4fYPSKd8k2NwZl9G6Rj3B8DWBt4Rv
	ZpShH198Sng0Cm+zraHdirm8N9K9Bjc=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-31effad130bso188399a91.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003976; x=1754608776; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Q+opQLK2FzSG8S2sXaAJverbmrDlQ+0+XTrAM6plEM=;
        b=ftzV4DsHtpQaGzqo9bx1Y7Kb5CgGskimZUUJ3mC3VTzAZzm8xq4Pld+NHe8Jx27ccD
         4vG5gSnFdu/0q+GXjZIqtW5LrTdE8khClv2wup18v8aAzQLSmBQ5JYsitmTo/F80UNM4
         EPIBTdD8+BTH5Mk9Zp/oH3J+BXnHUh0oZ1LeMNA7ahm5vvQNVo1neVDRaD4Ryt2ynolw
         eyFMwdtX+PIrMAtn2n9LNCpeFSmZI36E2nLwlKOUwr0VffqhgTQR7A5D+FEjdSHkuhPA
         eF4mzza7ai5tolz7Sq7Vae8L6+pRdQ52bsVNTJtMWfA9NsMW00+vV/zXQkEo7gbR4fGt
         PHUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003976; x=1754608776;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Q+opQLK2FzSG8S2sXaAJverbmrDlQ+0+XTrAM6plEM=;
        b=OZDspYygYDpd9NaxPy6Aigm/BxMo8k+8NreQs1HPAEGQHsUq5MtmKzJE8EdH0DnTNC
         loEUM2xuVcLpvITkXCCLH0/WoKVCLMKp/YGCqAQGuj+Gm4fqgZ2DbdbFoui+u/fQ4ezY
         wN0ZqhHmFGNWGW4f4tbYKpGRDoyEry6I6OR3Lnlvqs6VrTrkkTaEW6erCmpjcc1Y8iJV
         hU0sIxknCuXHTuqqijrD3yEqFdqD9JIzFxYMFIc+sYXRs4Odk/KvVwQbggpE+vOgc58n
         FbfKYClBuUCoDwpuOWOwTjRqVz1ORkM9IxQWKlAHpU44fqgHeHWbpr5YlUx0yqZq2vET
         nAmg==
X-Forwarded-Encrypted: i=1; AJvYcCWgvphb13G6ZBhEqzaeBPrgvXQHsxsxxxt78bwbn8tThgKHrjNmK+ZrTSzQchmkB6OfABSeA+nvDA==@kvack.org
X-Gm-Message-State: AOJu0YyocCFM8JEZX5kn47dICTQm/4bZAjEvmSazMo7/4ireWNzwAvir
	YL5gP3QlFJ8xGrD3UaDOBtRGfit3v8h4brIWslS51p75gcvtKY5bgSHZPx8VBz6cj5k=
X-Gm-Gg: ASbGnctA5C/idGWQv9eoydphonQvrNkVrViyL9sNdyJfe9ZS3SK+87zMCADSRcEORd6
	ox+vK0rBPiOkL1rZcSLzRdX9zwlFJOiST6UnVciQUtIhM2mrz2zghi1e86X77Gu3QJUSCJRNZ8v
	ijsMlwzCTlVdPhK3IuO3sKp1MfxQ4IjhwoUuBhtQPiJoRlcbIwzF8nRFrkqEIYnF+wnzvUvGhpC
	AeoKFUI/teB2pUkeTk92aq6aIb4wuTriTXhPigkA521JhkDEfObuzUyZGwYHgNdrj7iK5FyIni5
	vyjKiyqp1rmVGzgw9ENewaqmrfmUB80MV6Jm2g9o+385cT1hGQzh8CVnPp3Kxa/fodeP/K2Ca6x
	hmSDL7uRe2TdOwaFezEHjtSMpdt0JRWoJ
X-Google-Smtp-Source: AGHT+IGABS+p37R/P5mdKrWprh+fxm1AkxodO7yHAv0NE+ymflNPOOyo5XNFxvM0Bd9kHf1WjL7RRQ==
X-Received: by 2002:a17:90b:4c49:b0:311:ef19:824d with SMTP id 98e67ed59e1d1-31f5dd9d45bmr12079768a91.2.1754003976327;
        Thu, 31 Jul 2025 16:19:36 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:35 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:16 -0700
Subject: [PATCH v19 06/27] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-6-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9DFAAC0005
X-Stat-Signature: s19gt61ty4i8387hkpx98rgugz7qh181
X-HE-Tag: 1754003977-229918
X-HE-Meta: U2FsdGVkX18SNIa7raD60h7Jr0373oY3ncTPgQoPhQx6JmrumKZPaPam4PnbSJRX34Mz0NWvAn9e/Qtm3HCdvE06BVzZwxBMoZ0C+3PXSYDwS0oRy+RNR+eqIjiPOoOsmElBxqfiit05xglJ4hdVa0thE+DsSdPA97QgGpxT6pjsFBIYWhXN6zpG5DgQY9v1JACVfB2nrOsczoROR1ntS28acyGrmTyGomdWsRL/iXAGrnpGqZNxnda6FLTE2KDn6R3uXbpFTeb0BES5NG5EdSAmYaJcwmNVBQXjsEDYaqg19NO961vLUuVsDtts6/rbWSVit0lwMJEjDomgwcfjkCkmw5f+mkVbf1VQi0UivgT+3RlfX4wUf4uaAjbNKL0v8hFbbGL07kEQxPifIJ811ZcGjRigtOriV4UVC8MIzIOWmJsInThVrydPN/6mLT29FdbiQL8cRhPenR1g9PCaJIGvODRh6pB0wXWDanqoQGPP/3HSPNZoUWnA7m9oylfwx4ZMi5+s/GvIRwiAv/HJNt9DQ6ajV7UxuDk2imXQbPrIAu8w4liuqA+nXnjNZinHqcjLzYNplBSR9DxmVr1PYWCfcIM/9ihUThOa4MMfE6oe2LdrHkp1RfH/VfuvDsrphrwEXiS5bYNpqnegGZDMr7z7oCKmS+JbsAA1sYa7orOox+55sev58n9XZjTIVUg5tmdYbD1utTGrQ0oxkJ7kX3wasdKfHAcmYYpasUkES3A3XOuXx9DLVHgzmMWKbdPSGKukaDUBDtNBo2ik9rID4DrqaTNNPjPRcXDtXL5yMFXbKgOzpBAYUKTd9MaDpkd3No01b8uaJ1DnNwrE4SWZHOrO33SX8QmWG61bgVdu8klZnalEuDE0S1TFZxaGAqr7fODxBsXdzW9ku9CWNN4fWt7uHpfTrME6mqIRnj9ZH1qpFn1LjxkVzZ3zdU4y5l/QmeJxNAiH2SNkuehfPUv
 W4MpoNuU
 r6ekmiJnX/T3SrKLBl1AdPNXEpeF0ERe6sOtRoSKB817+BVnFuG7vsZ/k++G23bU/eyebTkC009h5tAeE5oE0Lk9nfFpYDafFLoWeGHntOccVmHxWhWGjTELcDZ7KiwrR8l2Jyx6blQzae/M1oMPGr1tyPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index a11816bbf9e7..c0d7e67c67ff 100644
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
index d77afe05578f..43a448bf254b 100644
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
index 8d0374d7ce8e..1af3c0bc6abe 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -375,7 +375,7 @@ pgd_t early_pg_dir[PTRS_PER_PGD] __initdata __aligned(PAGE_SIZE);
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


