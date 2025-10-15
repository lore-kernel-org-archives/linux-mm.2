Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91987CCD19F
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67278E0069; Wed, 15 Oct 2025 14:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D182C8E0005; Wed, 15 Oct 2025 14:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B481C8E0069; Wed, 15 Oct 2025 14:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0828E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6CC0D1184C6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:00 +0000 (UTC)
X-FDA: 84001147440.17.B8134CF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7F1F41C000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:13:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dzdIbJAw;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
	b=zCAGY7GnhN7LvlcLEc7N07sn8mrSqk24CMfc7g05GWTb6igj7BvL0z9xvHRE5mJZZhsA2d
	JCIWyK4PiRtgPJAn3UKB+3Mpk15bNnKC6fsgV/dIH9P/ROeE45gVfb4V2EaTeZWTs6yDjw
	oC6R+r7XW+xtWIJmNVXfjWcxaOJIIRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552038; a=rsa-sha256;
	cv=none;
	b=1SsQl7lu0dF8pOYA9xLZDfrk5N9IlmW8xxEQUXZzZzkHzsJ0O5cV/2noHIq+4DrINdZd2D
	d9MuPctLXYhgF+7ccP5Rn/MKrmTedHAlfopBLBQkw4/ZHi/SHkdMxz1z2t66u24a8ebdMU
	4wbdlH8VMW5R1/W2+tRcSXciHjPS0sI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=dzdIbJAw;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2907948c1d2so32504035ad.3
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552037; x=1761156837; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=dzdIbJAwjs5JHKwF3kcvWpWUo+QdmWn2/LhMh5gdGrBzgwXWnN2HGpNt5NCAUDm2iq
         o8O3zO55fR5c0wLeJs9PHvq1IjNUFSbU5+DFTWXp7h2EUU/Eb1rT3pg95nKFuvs3oSmp
         qDJKb4F3u8QBTlEUp8o+Qyf4Mpdnr2hn9wbJ6vSOI1QqFeihNLlNxyWUY0BMuV2eAi/N
         FJFUAXFAUtqAIHro2NcbRWxhEpur9nRdVCFSzmRltvo+NgfrNUkbgn3EBJRpXVprdTv+
         GmNpglK1sCgFWS/JJPT6nqL3n/2dludPK0sLaHq1ybvZjmOr1m0mmEVKqzuAER1yUolZ
         nLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552037; x=1761156837;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZlhaeGyn05OIbis6SfSAIFcz6IbZPi7uJh5910jbDw=;
        b=upfV4WFDGuJd2qguHgaUr1WWTVUGx3wd6B7kxWNlZ+LQr3CZA6H5V6kKmUxg//ZkPq
         t/uObf3VwtdR4u0IG1f3Zu/Ojaw+2o044y9lRE7l+pJeXdwkOOK5Va/Syg9sXxb0Rl5C
         LFFEg5KPsUuRNULTChveC2vIX8mqc5BxjyQKrU0KYLEaMK0A6UyjWjZlv04/PIplkYU0
         Xd4x8JkGqSyeqyMG4Fr6S3Qy7T9F952/eMvXeRzycMfl74XZ/lkrYkNkpnFYOeivv3ec
         brdPdFhrACfkWz+3AqKjbpqo19Hjf+KbBuPiPkFZ345lz1W9pt7Gra2GKGog4D2rxdvS
         wlzg==
X-Forwarded-Encrypted: i=1; AJvYcCXIiO3pvuVPNopvvUd/Kt+jePYluR76stPE2tfD4Sl6UZL+rIgq/N3AsCGyMZfDk6fpETjG4gkJfA==@kvack.org
X-Gm-Message-State: AOJu0YzaXev81hd3u5HPtAqRuklIEy767JDOsTHLgAImAR0aCRhtZCnM
	fIi0tBcICbi0tzUGK/L09kGtNtrFxLs/hxOX7N8gsuYimlbgLGvLUE2BesMMFlF0Gp0Vnax5Ddy
	A0Rxj
X-Gm-Gg: ASbGncuAFIjg4LOi0M3wHDsUj2GErYK2Up4lQ0JOLCfNn3F1hEY1C1tnbSUvjU/WgX8
	ijKmQve8kUA5mFylZsuvIM45WfgbBirav3uupsS8cJKIu5QkkwSxeOnm9hYiPnSAT6fBENGN5Cg
	Os9RlyahEPaemdrlU55ipZ+U1Er9z22dwBZZRRQGdWwR5iug5yftidtr/oj/L/LQLg0Ik1shJx5
	ocFytrwV0YzQZj2sXtfhVcBM+sckwFgZ08DbB5HgFfMGXWGbPeEHgCBd18hgfWdnYccBtZ6eEPu
	8uYAelLj7sdDHTGzvl6fJfMVmAwZq88k+jSecyEIP8vYNFDcdlW3hJtAPEYtxvn6TKFd4pDYML9
	0iO4O5rmWYrDZ2XLHKMb4k8zEWA2DQRb1H8DWNOBbCzhgNOQzhk0=
X-Google-Smtp-Source: AGHT+IF4EsC9DuhmT7rk9ptTnU4PDviv/V93ULDr1Oe/Ycd2qKf5MIh5teSfdDkNf1OPwXT1XZ+ltw==
X-Received: by 2002:a17:902:ef10:b0:271:5bde:697e with SMTP id d9443c01a7336-29027213340mr391816915ad.3.1760552036518;
        Wed, 15 Oct 2025 11:13:56 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:56 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:38 -0700
Subject: [PATCH v21 06/28] riscv/mm : ensure PROT_WRITE leads to VM_READ |
 VM_WRITE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-6-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: bpjbipg6fbmtixkqtuqjoqoah4xchw3i
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F1F41C000D
X-HE-Tag: 1760552038-815880
X-HE-Meta: U2FsdGVkX1/WHj53m+elEhV5nN6Zy0VB1GHIBLItHs1Qi7OCejwaWeG0lyB104LQukBhccCzRu728NiEYSDmmlm/O0eYDUuTBAemz1Ygzf/mmYVDSqgTniSJiyGTRkioUWp24JiW7kVeP0Wh6SwYk3ezok+xtAVSCsT7/mcfkxOqwtHoX8Wa4VjIeDJi2Qed92jg2UGDK6oh8VLvTe0FQ2OeQna2J7u5HEsljLjWn7TB1exsxlplQKJjv+YH8+CZgoIqinrBhrWxcHb7bsL/aq9ZT1jRm+Rg58G///+llSBHArmFNK4a0Vn47bGZZpP+2Zeq6ZEEIhzi9F3fgTkhZEG1H/wDAxYTPtbSTvMRE99Ai8z5PlS+sY6lZQ0sbzchYuFQQloDni3qrsdJjyHbgN6oQCxvhwOtNS5afiz+3hrYfsUrNwmGjP+FyTPecLQoB1TfKVykzSw6tz6djT2b+7f1zcFRfeTACa1zgBmNadOH7pqTntmM5U85nryq5BHmjGriVmBsC3Zr/+3l6BQIrpP70kIX4hb/Z8hCIryWCwVILMt88b5uAhQe6YdzQyjQb+qnh3FnGOUg0OYnLiFr8GTnl5MGJZTL+gssrCD4EIpjyYbi7Jxq0QlQPQ8yJ1NX4pgb8H/qidmMh/bsXj/5f3/w5Y4+QIT7+rcVAxsCvlobVE1/rAqjjOJNdMdUA8xhaLanSnebhCy8+VTmSTNUdzHxuHbtyi7kUfc/TBi5bw/QuyoO2jo3NE9S5Uei1i1gQM6karVIkraej/mNufkrGdX+B9zMAwYpFClS/KpMD+nfKlaouy3IwuU1tvuupsTkvho39WFV6GUx1x/eqgxNL2kqi2Db6JjR4HDpyhcm6i/oKXDpFW3frogNGt3mBRMp8XUSS5cXXcne3KYIZsGUeQdxh7PD76HVIOhTKa2QjnT9CaLDXsj3TEtQM7B5U+rOM10xG5XlOOC75w+HoU+
 y9isgV14
 YipoQjSZGcCoGUR9ZqNJGjzcxnKc9PHppETxLFnj+PwsOO4cSk9w0dOPgQhy4Euy2HaOLI87pwtKApvQ25UUvYL8fWgCOp+NYzcrhxgpSndWHeQi2tcRCM/2Hqhssbgi/qA6+FGIkvLx04kkjOrvQK/iA7PfXlIXr+zHgDyg5w5P2dVLE9XKhkWBjm0ze2tt3Qs0zb1W8kk8KKiNOitO+Pb/xfYZPvFm5nYDf22G4SLbu7JQsF822u82XRnYfUmYUtmFexPPcSduVZubyTAL3L6vcVUL70Jlkbm9DqJVsEERTp85AotbY2vIPAsk31eEkYs8qUIj5kB6+5CtPNLIutRMWYoLFAe40KOb9VyC+oOyeBjeFWbdMiNvRJRgQ01kjQQctTisTkDGRl193nja3rJyDOtgdPCx9IcedwXvHeR/NOOKrC44WxPMukSTW531DFCLl/o07VmEmncVUJb+6nWIvMSlpwH5uUjjT3NWR2QRmAvflVESahfBOol0Ix/kDfYLffqGRdH3y0+goe4igxIW56m+W3DFpD0C3jXrVQZy/uFCiDGLErVJgLA==
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


