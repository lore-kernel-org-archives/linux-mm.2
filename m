Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0610CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 23:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5418E000C; Wed, 22 Oct 2025 19:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066658E0002; Wed, 22 Oct 2025 19:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48A38E000C; Wed, 22 Oct 2025 19:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D09A18E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 19:29:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A1A12129826
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:53 +0000 (UTC)
X-FDA: 84027345066.24.BA6EB2F
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDEFE1C0004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:29:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HFesGPpe;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761175791; a=rsa-sha256;
	cv=none;
	b=wjc7X7LJd/yahIyQoc5tnTKrvEXiOB3RnEz1lEzCQTYt4oyeOYUQFOKQTXnefeMvf1hjhs
	bbgKJK3tA12X563pRkgZ9vWaJZAoDsmoTsY05Hkd1hn/lMk+nmgJYHHF6IXLzkAr09yZZT
	Amo9Vf/m1iTh3ZmL4NH159p6eNPfQpI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HFesGPpe;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf21.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761175791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
	b=lRmuL9BJBCLOKEauXn9nWPB+JHTbYGWMffZcmPAAUN3r0jqMCqgfpJfN/dfe96y/hmO/zJ
	SSiL4P9XTsE0IX8/ttDz8WomFgfwbN/KXJBRdHmpvLf+uUYdnOPs+EYb68laNojgucw8eT
	FLeLS91h1raHL5kgmT/H7lWtUgC7CAs=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-781206cce18so161284b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761175791; x=1761780591; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=HFesGPpe62lNk9YhCV1iOyJ0PuiySSoRZn3moWvQkjnWjfZ8kFTrAWD7dm4McP7W/c
         vZDnXlkBkgDTHfe/RT3UyvSc7pUaTs6UxnRin/MDL38YEdp5NPrD6vz3EiH/DDGi4owQ
         y6eSJjzpPV4WBO7YdTwlbqTYmiFBXF1dqYtwHC/DY9zPadn1qK9ad/yAj1MLOVCfLUGT
         OuUKpU0oZvrIHOfxbmmAagk0ZY8JQc+pX/54OrsY34+WFDeeBoC9HUyurRF52+NVu5vZ
         AqWHRd8E96Gr8mLDTz0wGUR909K7L7ioHLpwpMJUIwF5BFEHI4CG+dKchGWNvP+fLfDv
         IAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761175791; x=1761780591;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=A+9o+2AtQWgj0t3Q0aYUNw4ASO51+IsXNjTTWDDJHQ7kG+99UJasIqPmWI7eFcEz8g
         ZqtK4X5nMv5hYe3V9AHnBB7cFbqwXC0QorSAkmCA2yhZroSoSre1EzvZ8c+cVk7zVb0k
         CDVYO9zTK0m0cLcGJOVRnq0tZEOLQbXrGCSn9807GoTG1+9Q2pgSFKVkP37SfH/7JDaM
         +uaGNgoppuzAX2b7n3DQ3kdvgQjJABTKepOJWfLKMTXZA0hyUGOY9IJFyy74VvcoYg/Q
         o//CFFZ2dhFL/XuGMYzjxYpEEk7IVCCiyKJdX/uXSlEiZ2Rr63FOcAITRpr+kFP7LY47
         g8Ng==
X-Forwarded-Encrypted: i=1; AJvYcCW1U58kHbmrqqD8TY9+B5Y+CL7/MPKdOBXb+mvdu1lOl473/naJSr90fVY3+4LyYD3teESVxqJ/tA==@kvack.org
X-Gm-Message-State: AOJu0Yx4a3NFDX2Wqcgf1bIzSGdn1VM1VqqTvk5Kq+wqAzVCS9Fx6MeC
	SDtLYmay7hcQGNq/eB8FO9Tyk43fFksECVSiwg8LZOKXO8poJPBVtjN+hdYyVD0xIXc=
X-Gm-Gg: ASbGncuYYjuE6Teo/MQaeRbvJzcapM2aEk5gh00QYMRqFrupRugHfVw0ryGci3wBIkV
	98/2dfPqiipFAq5x0NIN2roKEXeAaR7RywLAxlwHxyubvLUAgTQcq8B+v8hjNy7uJi5UhitOEUV
	4rl8r7x0qBFNSrQVn4JhHuQ3TX6lSJRhvTnS5dzrUMSretn3Ub/5KIbbyk2uvnHMBwgtYX9hIHa
	dHODsNk/HYBiJSg2JQ7DqIfrjx3+AmXGhiXFidoYVoctxERFJQAdwgpcnTgL9lVRY7gXl4fIwCR
	XpMTSnPMIHqxrA/WsbFz+VyALu1YF4dpYxmglieeHlG/lhrnfNspWh5Ri0jVlGA3vlmL1zrO4Hg
	i1PJdTDcV3pYjGPNGMcWJ9Exui/YywHjYbjBnuCI2fSjJtsmgBl59l8t2b9jROF4wk1/7BIsGGr
	yPZTU3Cy+1pw==
X-Google-Smtp-Source: AGHT+IG4cbiBVjJNCgBYLEYEdqajOum54aXNq+CrIlTed76CQmY277uQptUVhs68Tc/ubzYSOTYfdg==
X-Received: by 2002:a05:6a00:bd11:b0:781:1fa9:151e with SMTP id d2e1a72fcca58-7a2647cb491mr5883654b3a.15.1761175790644;
        Wed, 22 Oct 2025 16:29:50 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a274dc12b2sm392646b3a.67.2025.10.22.16.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:29:50 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 22 Oct 2025 16:29:32 -0700
Subject: [PATCH v22 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251022-v5_user_cfi_series-v22-6-fdaa7e4022aa@rivosinc.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
In-Reply-To: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
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
X-Stat-Signature: 9m8cc3yhu66w3kgyeg1makzoo56jekgk
X-Rspamd-Queue-Id: DDEFE1C0004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761175791-766023
X-HE-Meta: U2FsdGVkX1+0SIZAS2Nk1XnIoaLj7PtARqrKLug1bGgpCOXXJeN5sFFiLPI0+Y725QJ7J4hAkDECrc39vnmaLLVWWQkUc+sOv805DdcN92YudeltTnQBFQwGwdIo3pkxjM+XKVf6LRmJBuUb1EbqchtOntl5Uu+7GjGbLSCAr0KqeVSGwOBG7axZmNkaedTYuX3JDTFrBA50KT490zd0e+ls4q2DyoNL4tNGjqhJnlB1o3TkbM7H8woLmn5tYtNNoYRng7BuRvPqDJYT7WfSUYOHL/dbwCsIQHRFpRtOpApJUg24/i/45xsvfaOzPn8OEsunjS+oBxTGa/SFPKxduIPJEcU+IMSxPkl+zQagvfYTzjmOnE5/O4DhhkEbWuG7IDwpmS0VUC21/X2MP2nT4dkcHP6LkAOSUdCH0+MEn8axB3DPfHGF+6wyi54O31EUaLMSE20TuaGaD7WTYeSdtKc0r/oEm9g7ihkFCBX+a9nE2qx6dkCp33gdm7meE+ce/zPnLDrXF1rvizidwPM+ia7lyPlT9gkU6HIkc1JNKXY0thpdHj+QLgN/945hYJ82ECIChlsi0x158gCTzhRYkjajkr+Md8A2ffLONXN6qLqS+lpS+HeRq9vBmS1Sb4ywMRyd9oM1bqoNfOSnf0DhvQhOvhtgV2iV5u+cgFeDnooOBb2imp3SmwpUbRhjq/o8Jj5tkDpR4CTI7uGishfuVT/EgwZcif5D+Tn4WZUSU1CRBD+BTOwJ4RNNsj2hvlg9763ORWgdsZ6I7+5jMD4lTYGLWsP5uScCHiw/Jorhp+k12CO6q4HrOh/DlPpb5dr8RnW2xJig54p0bzxLUURztQ504FyyGoMANjiupHsV8OsOCiaMlYddtiJM6SySLLQEiTyGz2Dq2PIsr90ngmR3tJng63jnWuu/RVRyR+xQHQhRM8W6E6tdll+ZoLurWjw7AZd7KV9flqjkT5h/anu
 Wlwjl82r
 aFQOp6YrMg0Hbxg4RN70XX9d85wshwpHeFlv5KLhsFHqggZJqUgX3DvvOlV5yzwzv7OlubfBI2cw7b3KC/5zrIJ5ABut4xgWbqyGhGiajIxULF1zCOaWhlNjgckhxlm+p8zKDl/BDBiANjEA=
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


