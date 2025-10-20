Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F87CCCD1A5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C55F8E0002; Mon, 20 Oct 2025 16:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7766B8E0016; Mon, 20 Oct 2025 16:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B9E8E0002; Mon, 20 Oct 2025 16:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 465388E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B6221A02AB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:54 +0000 (UTC)
X-FDA: 84019616268.05.EAAA6AC
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id 360B8180006
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TPIG2FHx;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyem79rLJLXQpzWR0JwioWbcU+J8r0OLXTuCA/SaFvw=;
	b=ID+1yfBndSG8ksCS9dg1o+Bj8pq11BI9wqLqo6prk0LuixM1UrpvNomYnt/vKr6nWsKz5Y
	9D+RIhgIdVXgfA772wdwy9HR6mF6l1IsHksvULNRbOXOVsKORQ7CFpXlFqH3mU9A+deTUi
	5zAxNrutI1DjYx2ewG0DPn2DqGai7kY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=TPIG2FHx;
	spf=pass (imf16.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991772; a=rsa-sha256;
	cv=none;
	b=ruLJTDCVMk+JLqK2KmFYzlvRIYZLGCLrHxH8ClzsjCC8WC+nLeBLbxRZqHA3rS183C+Kvt
	1kNBTKpqnSrhO3CqTqxdoV/aUXApAlFnnuiWFrQVoq6lI9VBamtvIgoQJ0753VT/ZoD0DK
	RawIjjfpuaxvKuaZMgdeloYblkGS2Eg=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7800ff158d5so4289526b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991771; x=1761596571; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pyem79rLJLXQpzWR0JwioWbcU+J8r0OLXTuCA/SaFvw=;
        b=TPIG2FHxqATEoEg9Sk94fWMGoml6armpdkJlMIpRU7rFXPyEIdAtOSA5Y62usvmyvA
         iSM17ArAaGZO05aS/JWZB5AtCI5n3h0xIQL3t4/RfY4XkEhWz0Rlq05709apLhSja9Aq
         aGL4+URuTzY8q8lsvq0RSnCtMJer6toYg/pQF4FyDs+NIjoynvy1lZpE25BtDMFMRrJN
         Cl0Na2G2U9hLby136/epD4y6ruIeubkE1JI7irufn95CAeveCwiATeMfBYdkPF6b7cWF
         w2erghRLzllOZA+CUqgUe4dfk6Cnt8M5/3jxP6EznJGKrlS9qunVhEWoYbJVrpwdjI2W
         Rexw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991771; x=1761596571;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pyem79rLJLXQpzWR0JwioWbcU+J8r0OLXTuCA/SaFvw=;
        b=WAmSk8CTqh8w2NeijhJ4k3kDbxxgmv71Ywev5Z1LcUQ1MjQI0orMgSMycknaT9EY3v
         +nxxGvR0lyswtAM6we2K25A/dfspfbD9kN+N2bjZ7hxXN23KkErWd6xMOW7TH1Bxl0Tu
         ZlIBPG8Wu2hcPop9rtR0e0YlLqmgpJsgtTYhxMnXnlf6OjTZ7AiG8xf11LXUMHipib5w
         +JyIMX7i5fHwTl1r3+uGfP8eIqJKI27Hc4rmWIBfgir7z/RQ8Xj2uQRJucWjOlca9310
         wS3/06rZlhWPqW66YyNmq+4aQ1MoxZzbT6gWcuFyUFskxfLo4R5Pzxmcknk6TRRPzzdW
         sS2A==
X-Forwarded-Encrypted: i=1; AJvYcCV4hhTJ/a+fB81T3ToSCfJEFgZOwySsvLqlpWMc5hbY13hoY+/0hfjl8nSK7M1Bg7bKf8ysPcrPZg==@kvack.org
X-Gm-Message-State: AOJu0YxF53xj07Kpnum+cAW0wiAygTGL5zTSBNegBI6GUcpuDbv0AOA6
	YH6ToL15iY4Ai49KOHobC7DhRQOwAEB73QdE1Nxfd3qiaOH4mfLeXfkO5D0irUa/918=
X-Gm-Gg: ASbGnctP6OjndygUJDrYCA3/1FX+MxcQ8k5cb7Hc0zbn0g7rjOO7t0AK2fVdnFNfKGQ
	jk4qSBddbTPMpKo5hrdrj/p4Aghh+/Kky0EiiIqxnlGPQ4BGeHJpG6us9ry6frBj9gFkbsoRVOy
	VnealMapjzFEKo5g/kK4YS4+aWW30f7JOzwUs8e28MpbabpcCKC2UCntGrRRDAMJ2xz0p/hupPG
	LRvQZG15jEiVpcTeyZXk73pLeDwQXtNrbpU58uT8kLr9sJ3aswnXR0bCkQyfo/tWvU+CmuW2lzI
	We7BPUO7mC/MTdB3y64h8TxNX3WEjkY5Xu6uPumnWs8LPU266s1eN6eRbtrKvBPGGVQckJzCdAE
	s/f/2WMzbMnAXOaTw8xx0xlthSagUtGb6LnULKZcbFJ8qRD0W1tHRvHw+wWjCWmE6aq3dSbzl8e
	YvGD39XhwRXA==
X-Google-Smtp-Source: AGHT+IHCUggIPMFs3p3YqDKdkPO2jCwhmhi/bL773/KhCAQLWB8ulShW9Lr2mVwOqzrGgVQh6gVvsg==
X-Received: by 2002:a05:6a20:42a3:b0:334:a82b:97d0 with SMTP id adf61e73a8af0-334a84cf411mr17749764637.22.1760991770903;
        Mon, 20 Oct 2025 13:22:50 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:50 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:35 -0700
Subject: [PATCH v22 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-6-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
X-Stat-Signature: wqce5ukw5ronw3bm5hiw8arx66aa8owf
X-Rspamd-Queue-Id: 360B8180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760991771-142167
X-HE-Meta: U2FsdGVkX18Kwk8YgFoKNGhlCFCI0O/Bh4PAQsQl2CHIogN9H/irUIze2xWQuwjDAI+p1DURn9mFFXuVHMUMKEdCZo7GYr2YmVNvXcU1HlCXXdjmlKL6M23hX3LVJVMJQCC89Q6POf8c4N7TkfBYJ8P+27owKLO0Gm9+znGEG32F4ju5gD0Q9dKAacu2/ukV0Js/exDVn3CdsI4Zoma3qyP+fGjhVdrnIr+Vm4W6Y2zzwmaLe44CDwzgCJySYM8o1c8FImZj5bpeOxOmpXH2VMTgoeZTYPdIt1kcsRIzM7ow0bxGOiKl7SoStpv0dbtio2JqTU4embjgN9K+vO++bcXr8B91wCx4L7ZS3nH2AK/R2UB3jONi0Vm8dDYeosnw15K7k/2ijv5ESsBeBG2FMHWDWdcahAbiJqDRiFmazKUMHxMObmK6VUsZ8zWgNgak9O8//7aulRTJ50NR1EPqEb0gqr2TxqDCApH8zGeropnkJqYKBgRI8XgtsUgIXG1h0w7dERoBtfFJLDgw3E37HKAgyX2BsnI/YVnM6pj/T5zUznTS/LTsbJkxgSZbeg0zS838bWD7FBwMmq6gMdkWb4SlqQIdohPpsTCpEV5Qq0teUpLAWd5fra1SUUZRNF9uABgsBNEcLnFnnlBmHHRJFOFuDPBVnmBd74QOg/5IAtK5leeLk45ZaNCRbG7cOU8Xa6lglt91bfwQAX7MxQEvyxyUJjKlBfCGcTU5LTTjgmvjnJZ15RAOxMhi6dwU5kt5TriOEEKBOXlH6lK4we6rCFaPB2I8a+1f1TVS+FLCL0UriLGrVGhoqjuge0MTOJOe5wihok73AoEnYshE18OMARp4ag6/6utT/YXlhxEMW25BTnGxNl7q81yc8rugwRTFwOcuECG2PvmyJYsM/LHbSZRttWwAPMzY6wa2hhVeGrShI4o4T1+hMAzCf/F34WV1s4QyZmKrcp1EivmzG/5
 gyvezBEO
 c09pY/TwfrJeaJ3DdywS1fcRcP3Q1LjIyPoSRUCMCQ85th42foDUQxDvR09QzhR+1F5oMwQOlic1Vr2SlJS2EZdH4SWdvyUsnxk46FT2u3FEJ1+icty4mGu5jHVKvnZ2huJFpiuUGby9mkd8=
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
2.45.0


