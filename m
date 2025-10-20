Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078C5CCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5758E0022; Mon, 20 Oct 2025 16:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FD68E000E; Mon, 20 Oct 2025 16:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA788E0022; Mon, 20 Oct 2025 16:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01CEF8E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:53:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CDF55B6D8A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:50 +0000 (UTC)
X-FDA: 84019694220.21.AE652C7
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id E219F1C0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:53:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=QF1oRbV7;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
	b=V1qMkXCHd/ihazhS8uRRfhCAqeW0MSfjuUgXDjopaA9O0eD3xgptY35BE+/GNtakGS8y7+
	8FEJ3xqwOTVRxBrj22cnStW97drSJFNjVIgJiHszrAtJegOfarP06ayrzut2zSZBbgkBZR
	nRi8pyUElkW5j8Qy/r/pMe24umEwzhU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=QF1oRbV7;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf20.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993629; a=rsa-sha256;
	cv=none;
	b=jszSj5+5k3MzjGbxif2WQ7vb9IxEnkJ9+97VH7SZ2H/uv+0NvuUms4aLN7hd1pzkyXl81W
	8rwSupbyyeu9oCxlH9fLQ0yqGX7Q2mZ/2tPrbQA19NUJVlYi6lcIRsFNqhR278ID6o+3ta
	3r6/ti2QmTiwv7IfPU2euiuVgNGclj8=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so6214787b3a.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993628; x=1761598428; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=QF1oRbV7hklvdjOPM3vhBJwewqR6v5Z2aXFmVGtcPYqCuh/lyCbs0HQ5UVLSe8n+XP
         NqKz8H49KfWzZwrc5jKxqQOZLIs62b3puaklgOuVH4GEGjZrkM8FW+wbsiZuxIKAB1wA
         xziOKjESFGXu66XZe1RpFXtud565SpeD+8k7KyU0LcD3bGcCq+/gH3Djy+5oUe+1nL16
         bIVMpSlEdeIayOVN0JDmxwVTPZ3iCUuQztJNR6ylgV+bRSUF/X9sUB05Pm10goOUzdDs
         cBEgsNFtDcFIPzoHUT5CxTypLqGK9mObiS71PrMDe2UxaZ1UGYa0mXaU2462rbZfKmnb
         rHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993628; x=1761598428;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=c75pLK9CmOVcTjsvcpCZjK/OM1v/YazL4HQFQxoYuu7pMivchDLjTxK6NJdfPE2KvI
         V+eAtzXUNT5+zTfWxucgaXlwbmHg6gmgiQRIiRU2xtSC2iop1mm+DKUcsO1fg9CfcYkJ
         8ruaDOANsncQprEJu151Tuc16LVN/5z2tafzOro/YCbhMMo/tbWV6Cr7mRQdUB5zFso0
         /BWfEg8PdTJR4AqKCDWaXjaEFjvILYJ361eWdqy9bUt454Hp3CTMsoXcmYAuJpYWPHl6
         ++itwwPktHUdzpNAtepi8XItPHEGnCHXKOJouOXizYTQzT5wu4tocUmhOI4KqIh+eyNF
         AV/w==
X-Forwarded-Encrypted: i=1; AJvYcCWvRyXgpIvaMUHFB8QA7GpHl77b6UkWL7Aa/8nhIZ/uqQcb/hkFVAd7Gk5Z90mCR0YiflyWu3lrag==@kvack.org
X-Gm-Message-State: AOJu0Yxa59v11QTDd2PP/mX7WyNDE1rkF7nkMheybGKpbpVvjYTnKQ4J
	tTr5QIppKImSB3QN/VnWS6DwwZBIVhhw74qCT3fEkJmABg4Rgrs2krD6/lHVNYsxgfo=
X-Gm-Gg: ASbGncv1H7Qm9Q7cRzfPelvtExKT0CqjMXQhZHHsQKfKFb/x3Tfgn78nGIPhQgG3e5L
	D+Jam99fgcDiEIHb2rdOuzQPWZNgYghpCZU6CrmyMwmZ3T2T6WZJXyX+JHblasFrYSiWFSnt03C
	hE+yQkxaemRDkhDhHP89hK08tBVdhVDvyqv5zVp96CEKVRAeKW98GSTiE5U1rMvv+DiTmFpKE91
	kEgf+WVtYt7qLZ+gzFYasJ+AK4Lki/f/davaqi2g42Zt4HPIE5NhbbDIdMJIHzwQUloPtoz5fg+
	LoZXk5RxtoQlfVlthwTRE/KPNC9RSK6ETAowTpb9NL0nHH6bgchAjA6sLkBWQfbWDV1YhpFy9QT
	8nkOedJVWQemhzY7h9NgTTpbfwCHjLtdt1tf7+gZNsPrs+2FaYGkaZuuqzHe8KjX462vGmlryGG
	Yv/a6Q2dmomtcvF5zjtH0U
X-Google-Smtp-Source: AGHT+IGTp0VoCzsM1qFbHekfxUQHxO5BZ1MzKl9AFrs6sYaWWmjz/mibQPZYBjqUQQvx/C2ezR82vQ==
X-Received: by 2002:a05:6a00:21c5:b0:771:fdd9:efa0 with SMTP id d2e1a72fcca58-7a220d232a7mr20518849b3a.15.1760993627632;
        Mon, 20 Oct 2025 13:53:47 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:53:47 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:35 -0700
Subject: [PATCH v22 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-6-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
X-Rspamd-Queue-Id: E219F1C0002
X-Rspamd-Server: rspam03
X-Stat-Signature: r99co9cw5ase7setgpwmq3awnj1re63p
X-HE-Tag: 1760993628-946192
X-HE-Meta: U2FsdGVkX18Q6lMumI6RK+DRbA1iMrYuJTOJQm4oq1tRlTlgTCrGseX07c/HULWM1Zya/ik6+x9wIeBMN9MPSO7DIrL2WVom3mY6/E/xef69IC46NCfuxKBJSC+UgITSymRGkzLwnqa602g7HQEXcvSLArj/oUgXyI+P5az/bxqg6H6dbMkEV/0f1g5onzK/ZZE87h9DVWg5ne4WxOvkxD23nd7jFRQDww7Pj+aEy+nXntaMtUScoEx72xUVXRv1ccIPXb2OAZG2BPHGqQOcxs/UeQSfhMT6JBQdpBjPWCQztuo4vep6dT6lcU7jGVYo7jAd+EWBla37/swRI7ZhxFuiUF62qgSMl8Iby/UEucv1BxjlFLy2KqBpFhhgEBLkO121QzjRqgWBED/F5k09QQh3ZNuPUTgU1UXUjoxJYely8F5OOa2xqUxpTH2Xz7czBtTeK9PR+XEtXTpKyPVXCH4PKik0XlCaB9dgJLyHNT1urNGY6IC8WBM/6ymKMrBSawkvOtPpFUcM1az1OiXDDIWBTQdRopw1EaHPRHdUnEWkvYNcmDuQ10BRze4u1xLNJ5XX4qNVGnkd3mbzOpdfOTSAoXUqN9qGCV4udVY5Co6XkMUg35SBPb7E1f8+ADixEUYAvismboruI4nUQ+P26x3HMmvz3/mq2CKmUFuSAO7/+O70hlKvn4IgjCUkgg4Zpf5tpo+gPloisFrkhW8yOkwvSXb96ohy7GEpfkITWEXECTj2RXCGb6QNiztvbVlYbBNaIvuRCiLqtiRK87cENSXJz7SozVpjEG4AGLFZLd4MLc/T2a+K5SDwujBZDeHFojzDnpK95feiBO39MlgGnvZWihPmLu/v752LroMy7Vx60esCCJtWAAe5M4SsmcqVTfqqXdKYFdM3IBy3eRksSOsjHB10Dy1XX+2yK9rJZA4M98aKHpvLJ1UJGPols8VkrzfgMPqINVe7fRzWK5M
 lxTwRe6/
 R4J24MFoFgSEIL/B34vzHsZaPF3oofm+8u/Eq1GRQ1wWRAnobU7V4gH49iJTdbT3/+69aygOA9Qt6XNmJhoIlqMf4dwPYHqk+YNEdu+jzf+kaQ2QfyaR7vFtC6LmTyvpnCJuaVtoQJdQDfA3aR6zxijNEYDxJPKcpNw3y5TV6/cqXy+35YZVvbEoUcqbYTRZRTeRvr+VmqdrvPSZIZpYNcFZ6IXaG+Qk8AtQi/+VzauIiSuY6wX5O0xGhlB+2WXqsfVVDWWuNaQkZ2j++kYCTVaEOnxuZCUpSUh1ceZl8jkoPlQC8VpK3+82bUoWrpm7uFsBZB9PFxIe0VYnlEIKXbVhr+wBv1wcXIsFrLz7sTHWwQW+6Msitl1YWdo0rNhRG0qECNr7qs6cAyqx7fiWKoiiyJcn/GzC4zO3bN1R4HeXqjmXO5UFsDgUENl1XDPEAyEAJskz17cPO+AnqLmQquMriCy2qe7dP/whpeZptLtgS65qMuiCJV0FSWvA8oYsqxqxIgTtgBdCAu1RAl4Dtp7YnkggXs7FLYrev2ddKIv2+qoSl1GoifT9seQ==
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


