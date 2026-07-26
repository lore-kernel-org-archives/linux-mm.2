Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41529C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208FA6B009B; Sun, 26 Jul 2026 18:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E0C26B009D; Sun, 26 Jul 2026 18:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E706B009E; Sun, 26 Jul 2026 18:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9E3B6B009B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 303911A05BD
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:35 +0000 (UTC)
X-FDA: 85032355590.21.6A4F675
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86FD11C000A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h+iSFEKO;
	spf=pass (imf20.hostedemail.com: domain of 35IhmaggKCOkULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=35IhmaggKCOkULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tm0BvJAKZPCt0zL1nFBZwS1cb/7w8R7o2etn3uisi0o=;
	b=T1QaFwjA5VA/TXO/ND2CMEAYilZcrTkN/TzUBueal6FZqKM+h7nNtkv3DHS7D6zYzA0CZ2
	ivZacSl9MvzKE5NJbEpY8TKfOzMMoPPTOwLlodagBUNU0BDdsoScMKHCCdf0ujNvD9F22C
	E5aboIYej7AVDnYriV6bGpQkOlF6G1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104613;
	b=IlpNZUK+Nqs0XZ4sBji1RLK60dB9KQiMXSdbOXigeRS3gU4dPTeW7sn+U39J89nO0Qvrm6
	LlAcZBExKWZ/6UtUJeD+P8CEFGGr7tYZAfiQgIXYWHLTtxgLuTJZ5iyOimabKZBVjrG6M5
	dRsu1m9uxDRo3CUaequL6b5cg5kXXVI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h+iSFEKO;
	spf=pass (imf20.hostedemail.com: domain of 35IhmaggKCOkULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=35IhmaggKCOkULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4954fe32d6eso10041095e9.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104612; x=1785709412; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tm0BvJAKZPCt0zL1nFBZwS1cb/7w8R7o2etn3uisi0o=;
        b=h+iSFEKOpUq26VHEWYj8gB4SmQcr1lUDrRZZfsEAoRIS1zNi5lYKRcdGyeUNPe9HaF
         GNEQgPLq0rmJvBpcZQcPUSwfKbww5d9kHVG22E/CSp0Rg2A8tySmI7beBcUC+XzS0I2p
         KuJV4dlXRFwwmprK5YTOawKwE1l8YRW/4kJBMmLjh+9OmldPhxJxJIEK6USMpI287329
         btI84P4f/pRZj3AxFno0V+CVPPqdKxqgC8UkuGNhOFhYvHN7t0jfQCYuxsRiyMsQ8Kql
         doWD0cYoJFf/wM/mICCmixFLqoQtTPHGIhevwrVfHZf/xTWbRhpXKMXyI1QYF6FqbnSN
         97yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104612; x=1785709412;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tm0BvJAKZPCt0zL1nFBZwS1cb/7w8R7o2etn3uisi0o=;
        b=KyoSsSk2zV9dRpRlzIlpp2o9Muo8j7XXMmjxl2CXKKh6lmrHW2qyYyRNogXcPiUsKR
         GQqUSZRM0GdwtbzcykC+g8dojUDcc4c/iiINMf/QQdQtW4/X/pi3pBUPmcFOY3YbQ0Z4
         W+R2Kb3oMavLqRwnAvuKw9aegaOnMiTog3847Ht9rwWyZDBTQMn3N6VoDAhocyzyKFe9
         PdULb5La1zeCgcOog3B9uBqiHUbqgtTSCe83QScQj/2WdYoYU27sSHs5AsyhDh7OLBjc
         3/dw73qxLGFH2H5bGL41uo1yQnuiFeHRQhPQgaDrbhmpzqziqQn7u1QvyYz4LH+FK0eU
         GIgg==
X-Gm-Message-State: AOJu0YxcrY9+XKHKa3VEU/tIJbYKiyp0yenO8/HPfgQb88W8DveKMxAe
	H2litKD+Q+ZevdXdf6TqmzArDP53T/YfYyAxCVRpyUoH1rLRO7/cBz2tleDycwBtTSOBSl0nf1s
	QqVPfjSYjCajAGw==
X-Received: from wrxn16.prod.google.com ([2002:a5d:6b90:0:b0:470:5ce8:b634])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1f8c:b0:496:bbcb:b0bb with SMTP id 5b1f17b1804b1-496bbcbb36emr44098055e9.18.1785104612089;
 Sun, 26 Jul 2026 15:23:32 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:41 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-8-6f5729aa9832@google.com>
Subject: [PATCH v3 08/26] x86/mm: move LDT remap into mm-local region
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: dd9n8a7obh76s1a1krat8ww17qchptt9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86FD11C000A
X-HE-Tag: 1785104613-638084
X-HE-Meta: U2FsdGVkX19UXk6Fe7hpRZT09W2bRPOEmyIJTqrQ1qzKOBoHYLJLXmb7HNfA4F4k0eGkdr2rfWSpEss8Hunk9t5uMUOJVXdr6IrhWTb2sa/TGCwSIdOnJfjEyhXp4icYa5hequ1CZ4A1lnWqVJ6RyXwZZw/xztV1Rx/cyY2dqVUfC4k7RCxcQBlFSQXezPhBcpcCHZTv5Jyli+sDvvXXl+4BeRAdkZtZZ5B5zd/LfXhpK5bhhWH16PY0LsynKpD3ttByzMWC0I4T/UOaALwc3fXIcnnb0d5G/EFa2Z/q2ka3HzKwOxSYRHU7QACesWWV71JtHCDKJsnzYMrNfwEjKAHxQpH2gYKt6BrBLJdO4R5R9YTSfR2tjxIqu7ltincJZYQyE18FRlDR8iw6oVErfNIWAEUNEXLRtNTOCCuTi1uN0HS63FwmOlfClibpOKFdiiUpn3DCD94AU/0OJmH6qmUH73I8+55GIpghSmV54edFlk+sS/HaA+PKxL3xc4PoSpyklQydiUsUnrTaLsQcHfVgLx2f6j2ujE+qj5Y4cUrpyvPAN8+2KlJcwaIsZjikBni6X8x07/PezGmROQGWt36wQvC8NVOc667MM6uKquXJYCM4EWhLlkN2NA0BzTcwB2VlfHXHPrmU4Zeh+3pERvot4Kc7WFpduOQ8zieo4Hp+nFzxxiJQKUGgbQE59O6jY60XWX/PBxTTTJp45h/fuZkbqWcyyXQeHcxwnPGRPR86zQ0RhybjjU/Khyk/GAidiuj7eESFZB/Lv0ww+7qbTTz+zI3SwCUza9mP3NbQpyYdYNpxMxchqhaoVo04cKWGLhA7fR0dqDCX3eVh5hw7F0+5yNHnGxUP/1TU2yP6mkxaxQMjhEC4wJKoFGmj39D9LFXPMxgw5Jw9OaYqQnlw4qbN5uC8b/A/05cxv66BohSrkS3X4wu38rHnzVxmIIlMoFtcssECEdAXzBIn4PK
 W8AI6BbX
 o3WkQ4eUSiLJGnwYn0Ja7YNGO6OGDglBVQRgT2MnXFeroYY2LeNJuVOpPw6FmNHSzeR6oHpUavbkt4UUUqd+4Xo5A3K0KLjdLwWVDcKdDt/pLT24CQiBnYQJ+F05AwoO1rRJroVmeXhcnA7sChfz3yIGMySyr09UgjnOJsccfRjafy0i5DIEBNLcFK2DIVFBYB/3lPJLubA9iouw0WtTIzZNvHWDu2pHD70AFiSlLVYH4C37IJBezNfTlzMumcmzDJBCdxK+bXMD86Jx5agxgk0SfqzVMArNEt5nSkvRMW5F/hvRRiCdO4sbWbZhTN/C3M1BPDWPsuruwgZs7X2xgfl+dIOYHew8W6XXQxjaEHYoFsk+9G+2gT8dKtcTXLijZ1eeBfqKnZQyXvRd6c9H03YS3apkhFUVuGlIH3L5pX0jbMkMaAqk/P5tBe156Y+mdK9u+2PHY0MgwMbMbpQ/1mzeVdZJ/3c0FR84fhdmQbnA8cQUjoK0JJ1M6MBtUmSMwO7V64XW2asikZc+puCsaQDVyMG3KUCCXUXhTdt6Tm3rLsjsmTG0bjIOdCHq6n6qkJyMl+sjxf15HqbQIRHNH4VRSCF/CyKNu6PN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that x86 processes have a general mm-local region, the LDT-specific
management of the higher-level pagetables can mostly be replaced by just
using the generic mm-local API.

Drop all management of pagetable allocation and freeing; that is now
handled automatically by virtue of the pagetables being in the mm-local
region.

Drop explicit logic to map LDTs into the user pagetables under PTI; that
also happens automatically for this region.

Unify the sanity-checking logic between x86_64 and PAE: use the generic
set_memory.c mechanism to walk pagetables. This means the
sanity-checking is slightly more relaxed, since lookup_address_in_pgd()
is more flexible than pgd_to_pmd_walk(), but this seems to be worth it
for the simplified code. It means that ldt.c doesn't have to know about
the exact structure of the mm-local region's pagetables.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/arch/x86/x86_64/mm.rst |   4 +-
 arch/x86/Kconfig                     |   4 +-
 arch/x86/include/asm/mmu_context.h   |   2 -
 arch/x86/kernel/ldt.c                | 124 +++++------------------------------
 4 files changed, 20 insertions(+), 114 deletions(-)

diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x86/x86_64/mm.rst
index a6cf05d51bd8c..fa2bb7bab6a42 100644
--- a/Documentation/arch/x86/x86_64/mm.rst
+++ b/Documentation/arch/x86/x86_64/mm.rst
@@ -53,7 +53,7 @@ Complete virtual memory map with 4-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ffff800000000000 | -128    TB | ffff87ffffffffff |    8 TB | ... guard hole, also reserved for hypervisor
-   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | LDT remap for PTI
+   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | MM-local kernel data. Includes LDT remap for PTI
    ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)
    ffffc88000000000 |  -55.5  TB | ffffc8ffffffffff |  0.5 TB | ... unused hole
    ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
@@ -123,7 +123,7 @@ Complete virtual memory map with 5-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ff00000000000000 |  -64    PB | ff0fffffffffffff |    4 PB | ... guard hole, also reserved for hypervisor
-   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | LDT remap for PTI
+   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | MM-local kernel data. Includes LDT remap for PTI
    ff11000000000000 |  -59.75 PB | ff90ffffffffffff |   32 PB | direct mapping of all physical memory (page_offset_base)
    ff91000000000000 |  -27.75 PB | ff9fffffffffffff | 3.75 PB | ... unused hole
    ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3efab3524a6cf..33c1282bfbf93 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,8 +132,7 @@ config X86
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_RT
-	# LDT remap temporarily clashes with mm-local region, can't have both.
-	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64 || X86_PAE && !MODIFY_LDT_SYSCALL
+	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64 || X86_PAE
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
@@ -2280,6 +2279,7 @@ config CMDLINE_OVERRIDE
 config MODIFY_LDT_SYSCALL
 	bool "Enable the LDT (local descriptor table)" if EXPERT
 	default y
+	select MM_LOCAL_REGION if MITIGATION_PAGE_TABLE_ISOLATION || X86_PAE
 	help
 	  Linux can allow user programs to install a per-process x86
 	  Local Descriptor Table (LDT) using the modify_ldt(2) system
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 3d4f54673014f..09b8d8e6a56ea 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -61,7 +61,6 @@ static inline void init_new_context_ldt(struct mm_struct *mm)
 }
 int ldt_dup_context(struct mm_struct *oldmm, struct mm_struct *mm);
 void destroy_context_ldt(struct mm_struct *mm);
-void ldt_arch_exit_mmap(struct mm_struct *mm);
 #else	/* CONFIG_MODIFY_LDT_SYSCALL */
 static inline void init_new_context_ldt(struct mm_struct *mm) { }
 static inline int ldt_dup_context(struct mm_struct *oldmm,
@@ -70,7 +69,6 @@ static inline int ldt_dup_context(struct mm_struct *oldmm,
 	return 0;
 }
 static inline void destroy_context_ldt(struct mm_struct *mm) { }
-static inline void ldt_arch_exit_mmap(struct mm_struct *mm) { }
 #endif
 
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 40c5bf97dd5cc..685664c1ee770 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -186,10 +186,16 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 
-static void do_sanity_check(struct mm_struct *mm,
-			    bool had_kernel_mapping,
-			    bool had_user_mapping)
+static void sanity_check_ldt_mapping(struct mm_struct *mm)
 {
+	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
+	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
+	unsigned int k_level, u_level;
+	bool had_kernel_mapping, had_user_mapping;
+
+	had_kernel_mapping = lookup_address_in_pgd(k_pgd, LDT_BASE_ADDR, &k_level);
+	had_user_mapping   = lookup_address_in_pgd(u_pgd, LDT_BASE_ADDR, &u_level);
+
 	if (mm->context.ldt) {
 		/*
 		 * We already had an LDT.  The top-level entry should already
@@ -210,76 +216,6 @@ static void do_sanity_check(struct mm_struct *mm,
 	}
 }
 
-#ifdef CONFIG_X86_PAE
-
-static pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
-{
-	p4d_t *p4d;
-	pud_t *pud;
-
-	if (pgd->pgd == 0)
-		return NULL;
-
-	p4d = p4d_offset(pgd, va);
-	if (p4d_none(*p4d))
-		return NULL;
-
-	pud = pud_offset(p4d, va);
-	if (pud_none(*pud))
-		return NULL;
-
-	return pmd_offset(pud, va);
-}
-
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
-	pmd_t *k_pmd, *u_pmd;
-
-	k_pmd = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
-	u_pmd = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pmd(u_pmd, *k_pmd);
-}
-
-static void sanity_check_ldt_mapping(struct mm_struct *mm)
-{
-	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
-	bool had_kernel, had_user;
-	pmd_t *k_pmd, *u_pmd;
-
-	k_pmd      = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
-	u_pmd      = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-	had_kernel = (k_pmd->pmd != 0);
-	had_user   = (u_pmd->pmd != 0);
-
-	do_sanity_check(mm, had_kernel, had_user);
-}
-
-#else /* !CONFIG_X86_PAE */
-
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pgd(kernel_to_user_pgdp(pgd), *pgd);
-}
-
-static void sanity_check_ldt_mapping(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	bool had_kernel = (pgd->pgd != 0);
-	bool had_user   = (kernel_to_user_pgdp(pgd)->pgd != 0);
-
-	do_sanity_check(mm, had_kernel, had_user);
-}
-
-#endif /* CONFIG_X86_PAE */
-
 /*
  * If PTI is enabled, this maps the LDT into the kernelmode and
  * usermode tables for the given mm.
@@ -290,7 +226,7 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 	unsigned long va;
 	bool is_vmalloc;
 	spinlock_t *ptl;
-	int i, nr_pages;
+	int i, nr_pages, err;
 
 	if (!boot_cpu_has(X86_FEATURE_PTI))
 		return 0;
@@ -304,6 +240,10 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 	/* Check if the current mappings are sane */
 	sanity_check_ldt_mapping(mm);
 
+	err = mm_local_region_init(mm);
+	if (err)
+		return err;
+
 	is_vmalloc = is_vmalloc_addr(ldt->entries);
 
 	nr_pages = DIV_ROUND_UP(ldt->nr_entries * LDT_ENTRY_SIZE, PAGE_SIZE);
@@ -339,9 +279,6 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 		pte_unmap_unlock(ptep, ptl);
 	}
 
-	/* Propagate LDT mapping to the user page-table */
-	map_ldt_struct_to_user(mm);
-
 	ldt->slot = slot;
 	return 0;
 }
@@ -390,28 +327,6 @@ static void unmap_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt)
 }
 #endif /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
 
-static void free_ldt_pgtables(struct mm_struct *mm)
-{
-#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
-	struct mmu_gather tlb;
-	unsigned long start = LDT_BASE_ADDR;
-	unsigned long end = LDT_END_ADDR;
-
-	if (!boot_cpu_has(X86_FEATURE_PTI))
-		return;
-
-	/*
-	 * Although free_pgd_range() is intended for freeing user
-	 * page-tables, it also works out for kernel mappings on x86.
-	 * We use tlb_gather_mmu_fullmm() to avoid confusing the
-	 * range-tracking logic in __tlb_adjust_range().
-	 */
-	tlb_gather_mmu_fullmm(&tlb, mm);
-	free_pgd_range(&tlb, start, end, start, end);
-	tlb_finish_mmu(&tlb);
-#endif
-}
-
 /* After calling this, the LDT is immutable. */
 static void finalize_ldt_struct(struct ldt_struct *ldt)
 {
@@ -472,7 +387,6 @@ int ldt_dup_context(struct mm_struct *old_mm, struct mm_struct *mm)
 
 	retval = map_ldt_struct(mm, new_ldt, 0);
 	if (retval) {
-		free_ldt_pgtables(mm);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}
@@ -494,11 +408,6 @@ void destroy_context_ldt(struct mm_struct *mm)
 	mm->context.ldt = NULL;
 }
 
-void ldt_arch_exit_mmap(struct mm_struct *mm)
-{
-	free_ldt_pgtables(mm);
-}
-
 static int read_ldt(void __user *ptr, unsigned long bytecount)
 {
 	struct mm_struct *mm = current->mm;
@@ -645,10 +554,9 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		/*
 		 * This only can fail for the first LDT setup. If an LDT is
 		 * already installed then the PTE page is already
-		 * populated. Mop up a half populated page table.
+		 * populated.
 		 */
-		if (!WARN_ON_ONCE(old_ldt))
-			free_ldt_pgtables(mm);
+		WARN_ON_ONCE(old_ldt);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}

-- 
2.54.0


