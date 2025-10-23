Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82665CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38768E0023; Thu, 23 Oct 2025 09:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8238E0002; Thu, 23 Oct 2025 09:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0468E0023; Thu, 23 Oct 2025 09:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3D038E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EB8C129BF4
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:53 +0000 (UTC)
X-FDA: 84029451786.16.18B22A4
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7445340019
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=X20RSRdv;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225951; a=rsa-sha256;
	cv=none;
	b=X1BA/rt97oM/EM4FiHkWLPX19I19FcLnQi7xc7Jrw1L2+yPXns/K2GAUwd8cNTk91wVL4d
	3n8yLKHgJgYW5yWPGSMptHF8NUjTUWiBedhRFrtJKP4dew9XTXID0kJEdqu2Ms2vPc5noE
	pw6H1x5Y5ecIq1cIjV1NS9cBNMwrjMY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=X20RSRdv;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf27.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
	b=VMxlu+hdBlYXGywmJyWZ9vb3n3LFbyOrHTw+P6XaBH4qK1nd7HZsmXvCRY+PUvIA3IKtit
	6+ATqyU5+XMLlWuu9k8rVVB0OFskpEI37ElJrV8KRDq+bSwoXyDWe105SXVPEse/dDk9jU
	L7kgQK5+CATph8gSaJt/SIvBnelAysk=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6cf30e5bbcso645906a12.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225950; x=1761830750; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=X20RSRdvjYl7BUcIy3UPPDkIEWwLF0hzJgPA9oWcRGDXIsSWrEAW4AvK2Pgb5UoTMW
         XMaNJME9Vib8X+vFNykezxMy7ZzJjpUl/SkYQl3baNfJsSG4ejrwNNPcI0rJq57jfDPn
         4PyXpa6RTZRpQFkRRBpRxkPKqZYwtwUTZVYNRGUUAvun6ZnHuaZoRCodLMmEeuHr8JQ6
         L0IyxncxlwvFiRTkaKuxO9+dfKeaKEupHBGwuYtLpPeRM6+QfBAwI2Q5RsDLTO5qzYS9
         WE2vegWWdWV8Wa+ctHl4N9SC3/6CaRJzkCzZ4EgQAdx87B2EtqHopOBzgqWjjB5KonL0
         sUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225950; x=1761830750;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=lNO6R+S8ojZdjcEDeVwf02zgqCsPRpB1xdwRtvlYHU7369DI4A8vYOWcL0dmVBsBTG
         rPycLcYYm2EKG/UYON6t9to1MCeji+ZZeyydGURgkE8pa9xHhVTn5Djb48TrHnZw8GXR
         MKnTwMVUResWB0Xk9HfHfnrtD5sSuSaUYhay6q36n2OIgntn+8zIIh1ySzh97rtEi/Mh
         uIDz57GWSISRVNWlKwf7+GYBT7iPtokV6nMMTW0/WV8vq8GfvQFlgurSb1UZkKgt8Pyd
         Am/CIyOPHobMsDZMhhrldsd/1Wp+mfVzdlu+MRmhBwFFrqhUHTBSQx+Fn5XHI/QCGY9S
         PClQ==
X-Forwarded-Encrypted: i=1; AJvYcCWforhRsBCaXEQhqXhsdQKXDIyvOudJWirGPf3VDgGi1QefdMtToPx/XodYh9mdmsBnAW6rVrbvYQ==@kvack.org
X-Gm-Message-State: AOJu0YzxQPDzWY/IbnuhpT7F4rX0vTFSvjhsNEe5fKAO7tVL/vwI6Bhr
	dco7qTbTq5fbSWLJX1JHn2KeCJDQzJ4kMYaCm0ASk2IdtfrgZbGJpkvc1Z+Nx1L2HL0=
X-Gm-Gg: ASbGncuxbZm9t7Po9iiB4l8nDP5rKx+oEK3WDGfcYxi6/mqE5ZY1Zgqilu81/YhbAln
	fjW+80mfjwzcXDAR00zFMUY80Bmedk79tM/Yv9y5znhXm/lGvJTGfhWu1dQaJVNr3G3SvQWuJz2
	qttioTvo9DgEKU2d4RTm25nzeCVrk7tjbKDqpM7mxxE0qO1cwn5cc1f1Ckk+jEcBXFOu3AEva9J
	9yqEPkhQxs3iuKUm3FJCBpDHxcxjJs2nUBN6w2ASHQ3BcjlOOzBNpaoZ3IAGOHG6+9pxwaNGBvZ
	F9bjuS+B9FuMexyaOMMZMYu1uxStfNsbZ2W9itPzKlithG/bYtcIBksZfu+n9/O/iwV37b4YJGe
	tYF+DmtsWPN1oJvTX+8T5OegoC0PMr8eT4e9sUUU/DGzKX+kLMcAoUVdzYGBXzk4F4Gui7hmLHa
	A711ga29BldLWrB+Sk4cQ5
X-Google-Smtp-Source: AGHT+IEHY7zI2nM4g3gPAMySUNFQlHWGbNzHIjBZCB5gajpWZtOBTzgHVWp5MlgKB+cFABF2H9LLUw==
X-Received: by 2002:a17:902:d483:b0:267:9601:dca0 with SMTP id d9443c01a7336-292ffc8a00cmr86856515ad.27.1761225950264;
        Thu, 23 Oct 2025 06:25:50 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:49 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:35 -0700
Subject: [PATCH v22 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-6-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Stat-Signature: uccxgo1c4yha69m1oadn59rpppojhz4r
X-Rspamd-Queue-Id: 7445340019
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761225951-597105
X-HE-Meta: U2FsdGVkX1/tlovkzL30vtJBEqZmAWgYaTNC/7r9oz7D20c7L/QtafgqiJ7ay1foY8XB0Drjqdxri0ZmGkrC08CXQ24CFS5M2PBqBDYi5iiogj1jCHvFRTaIk2ligXJev/elDNi4xjkt5VESn8YsFVKZtQ0EXs+E+lfRdZy5PS5q4yWJa0GHPjLLMCmy2JFES6+hzS83aehHGwPRkIH4GG20R2QQnZPN8LBXvCCARChgzrUHUdXT4h8ihMhzVif7Ls6Sd60Uzamz/CYV4ufsL1O66rQmGcIFOM90grRypzFnDmJl+SLmNopU7MH1t5gJHSmNk1BlvopQWkEan0u/tcchqzlLR7RjUFsXRSwPA+pgOyzJ1nKnBSWZ8xe0E4XrC+eMKungIFQLOVBqIN7OodQ0x1XNuqaMb4HvaFvSpac2dDQPX4N6GpTQaDXFi5BoRKk3dKt+s55K84l9jx7GhtuJLmRfcb2jpd1j9FuBJdDSGBh7AJJk2y68AFEX0Xy5NH7tJtnU1/wIpI8Ruv982BebE28NNH2mAuj9tWQUa+ZU03YIoLylISsDbFAV15O3CInU5BWxiGqZom8oyoCt5ombVfzXpKphEh7CBjAxtJCL3TW+iRW6Buj7xUDMBr4zO44gp70B/UZk1TlxzLbed8mbd9HGICKaFhGQmmi70mhdQXoCQYv+YHHJBsh40/QAg+L2u2gcc03YiAAMbQmGpiI7eEaTM0dqYy1twXioKHrM3anISxCrfifICFBBe4uVxaVJUgLG9EMk+pUQ6ZW1dBLbyBaoev2bhhMVdjtMBkpcPZwHB0QBMLgV1/IcCJKlPILupfMnG/xCRy6NTPjJeBcArML5PKwtrOFuZ22emlOZk85dny5hCNtPB0GNelli/RWkyTWNvT53nr2ENuhMtzM497/sPhwlouJ4pBXnyXvxjK5P7sWw046Ef7qMb6MiLtueZKiNHu8zwViH2IA
 y7mB6qUX
 oh8q+FEnqrPWXiG3GL1t2Bl5yhEk87FEqwbaHsE04QXnUx3fY4i2eg66fQy2HSvYute6EukGJsLvFY553bNDQ1LFyI5pPMxmZVTL0b+rZFTkkU33LepTmhKO6lqUvV2CisClguFfVRwO2js1oHf/RM3LRhoaRq9YbmrOfdqINVhIYg75Zcgf+MC0DRoBu6B8D3M4W3d7VIQLeqh9ABM5kJ7ZCL0podZHQKHGjzjYikRjHEP6DaCeNoTXu7Oo1uqhIjxTw4OXvGbFzrt9Rbynqtfeb8vt/XoUvCfFBIi9hM1tw9yswDueWkikFMdQMCCobG/qsAjW1UERwIptg5LwnF2+WYh27XQagp4wXDWck5OxCcm3Zf2pATdpg8cTLaCOR7XS1kecui5PjxoaTF7qZnFhDkhHCSCCZIJJsip2X6nhZIUKinuVrCDst1oSBlcO9RJS7JjU0mtNVphh5gHAlnY3WpLFXqPgnb9J2Swq201YwOJyw1LGEPLxs8a5qTkDfyB4rkN4xEepZD0GAB/0pAda6nWbiRPdu0l7kqcBa0sSagB1+b8fexyRriQ==
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


