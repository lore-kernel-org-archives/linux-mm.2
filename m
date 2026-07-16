Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B21C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF27D6B013F; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EAC6B0140; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42F06B0142; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2C66B013F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E9BB80153
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:32 +0000 (UTC)
X-FDA: 84994605864.26.8AFBCBA
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 34E8540003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:43:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b3SUbbhk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNKb6kLr/7ftZXllrSyALai0ySExbjYkU3LL0V9fZEA=;
	b=jbOnBfDhUPfFwVc/Dfkq4Pd5Nxt0ShG1mUWVSndf6clzL71ryM5/G1IvKAJDZZfcJv1FOY
	t8fylo9/dHbo9sZ8ZoBdVctZZnAOB8uFH4gMwZKGA09ABP8ytZpXVm0sxMsCN9uudtnATz
	AarHs16vxhSkCGR+gm3039KekZN3xmM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b3SUbbhk;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205810;
	b=xZ0lBPhN0tzts6gFZhvN+jAlUTYGLWLCILp9CKptvcxlwT4b4KdaHFqQPQ7ONX9hkzTmv6
	tyct+vJQS5EG9LerTIW2DJ07TgkhxjuSZCEjdw7D7prhYW6JA4BtK1UFAJHFoiWqsEHht0
	5E0JDoAFmK0ANHmP4MZmdaUR2rBwfgM=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso4724186a12.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205809; x=1784810609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qNKb6kLr/7ftZXllrSyALai0ySExbjYkU3LL0V9fZEA=;
        b=b3SUbbhkcNLW7rbgIMz86gxbR/Z+dogZ+Ao8/h7oRX4KcoymQUnywuS/PPTC1Yu+dZ
         OOdG0DZBIPafnMaVwI0nvB3Ru+NbIxRBRt/6InCqWZ4IdXjcacyjeSXq5eL9XDy7L++h
         C9d2yJ24KWDKhOs8Nq3DsWfGTupvIc8BdWp+P7lOXraBFCkVcCTCFYTqyLOwHECl2PJy
         mHGeRY1Yxt9FenpHB76ANXL+8WisfqSXvA5G4x5mf2CRcGtMTXN9Be+pWqpq/oDxNIJZ
         RQHCQ3P+gwZT+UAtgru9bckvoy1RR+BqbOju0k2g38ecl4X6lV4ME/vULSH+CNnqR+bQ
         Pb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205809; x=1784810609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qNKb6kLr/7ftZXllrSyALai0ySExbjYkU3LL0V9fZEA=;
        b=Gj5nSh/vix2BKipsqsT7DpAY/TDVuZSzapCoelrxtaxeWTU+oiOL7ILYVZZ361yhWy
         H4pyKcKe0LBSbM97CenD5F6DtzSbJ35RW+q4b1icVNsuiZhLFx6TOdG4zyC2t1sysJlW
         p6aAxypdjQSjhFploDRoDT7mrG1MctIqoh4/N+UJml++GljBr/Q9n/MJlX7ifctAKL5+
         7k3N0RyuwcHs1GqpJDpoeAj9bCwEWZygOddk9nshj3DlPKdsuTyMUh2DVsyK0DuFTTp/
         gTKKvuJTN1DPy8rPZ2CDJ4lhrf/mEX0Yr3vPUpqqnq8Z8YfZV58kVTxGhTqUJ7R0TTtA
         nAqA==
X-Forwarded-Encrypted: i=1; AHgh+RrjZ5a3l8MSTAMJV7gCuNECoCIje3KA9XBaKtcSGpk1+TrQghHDmasdpAuLEsFLZ4P2vN/xzSRqSA==@kvack.org
X-Gm-Message-State: AOJu0YygrBaU0sAtcIKXAGzc9ruQoXx6In5Zgz9UVM99ulkbUi8J8GX1
	Iejs/6iJ3FeGYSnTsFmGraZWUHwrB6jfG6EpwRKKfRWrKSb6u6JKPUYPjxwYwPTyn2g=
X-Gm-Gg: AfdE7cnI1or+yCUZyQqF8zitRbCRGsmUs3F/k7ShUs9+JEttvEFDTp3wx62a0WZQWEl
	eGK3/FwNFjxaObuLbCs/yNhzhQ9G9lqHlipEtJE/jFQBXKIERs2YTvQGjEFc2tesNLaN334E3mJ
	94QESJ8lPuG22oZxRG3SsTwPLJDGVV2N+IaF1TsTkhPTI/HxZykxp/1DbcKTf3tespqO9JHJLTt
	3FsbXcKomoTcp9FNT0fSooohGChr7TR/E6/rEZcqVaM77UCmr/gqFhJ8hM4wMi/IE4Vh6exOBJO
	VnobGPKlwtmjBb70g/MLsLeHL/clFn7KIktmSd7I69AQREt3f04Ab+9j78Z33CEqTaDl7ir26Ec
	/JIkRfjgZ7VHs/Y+wEDv906ysGupvnvd1M8J9VUMmaVOC4z2Q/6puKquHHY6P6eVHeW41SAdvaG
	8/kz1Y1cJcO1iiBRzlRSm2Dx4=
X-Received: by 2002:a05:6a20:e615:b0:3c0:9c19:6590 with SMTP id adf61e73a8af0-3c3576c37f6mr12231332637.74.1784205808961;
        Thu, 16 Jul 2026 05:43:28 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:26 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 05/15] mm: extend pte batch and leaf-size helpers
Date: Thu, 16 Jul 2026 20:41:40 +0800
Message-Id: <e821b31e023ee0e5b1c54daed253034bd4da0398.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34E8540003
X-Stat-Signature: g3qi1xcr4oxpjfka5z93h7hrhemdzk7s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784205810-196203
X-HE-Meta: U2FsdGVkX194gyyR4lq9Mitw980QXu0PxLL3M5E4wr0++Mz40r0AIiKUZRsGJ25CuWiAfiOCSmGDl7LFQE8E2EaKBgnM1MxDloAI1o1jnGEQsPzGn86RI8GKI9nhruMMMw49MJh0tXR08pWW0k+bkcu1V28DBvtMHgDPtOmasjJ2X3xhylXgRNH8pxED9mxlZUFM6To3wxgF8Jzaae6VXGgHGbEuveHrZLK0WDm8/Be+l7U2c4HcI20QW5kPAEgvxvwcp8bLoLgj99YGLzjSIEjy4nryc2SP1hTUqx0AIBMJOn347+lIJHDJ7Uv3Fz2W676BIHib7Iu4q6pLWXr1Zei5Nk7lfUfpT6pu8EGstNSzpwPnWiof9Nva8k8ms9fHwhpmf0EdAujC8GCMTxhDjmIPknGQBxXdpCuonAwoGJEP4ARQZCNb9l3Dae57BlKYJCwhi55UgWHBmU10OoZ7h2N7BlofUOhMiRoZMwW3Vm+2VfDB9zL4uQpqCHOB42Yi1z5gc0RoyxtpxVymDsLQ5WbIX5LY5GNSgj2c7e5O8wXCMTLgC9aGcodGmru4WrB7vowQK1SNsGUK/dogWh3vFIzRBmk2EDirQeBdtJN00WhMV1Me2cB8Kdfo0CK8DNx/8x/YDnvTSAjBPbosWkGFuxL2lYyoYgI9PfTNwrGuXSTABb7Me8DF7tadJ/HBxO99yIwiTD/0d2vCLC1S+AGgTxoBUni/DMMGyIi5u1OlIQ9rwdQQqnyqABOk/K9Sy5a4vvOrBgA9OTxyQxOA2x2EIE776kSuMHTDOaiJBDgMqdMVKGfxR29mTu7ReWyoPrw1xyo2e6wjiLTXwVCoqVboaoEPJF4mLaKEMv3VphMt2a+0yE2/7WBA1HFd2/2jmgRDSMvvujAGXYH1ZfTWYo35XpOIMlT91EQTt+tisQKHDY4u6mwW0IZMjr+75cCbRrO4MmxYhfsrZxl7Rf4kSgl
 cUBPTNzx
 w7G62fsZjyfl9ielzECoux7GG73phvGnPp6ZDnR1pEapjiUbEeqoeyKAycX+A/qp3hOCj3f0ABeXjE9EFXSaAal8kTlPAqJ/u2q8tMAKacAHNMgEm71ZbwAemVI7sox96y0HJS45V1f6dZ77d+HP5VIjCOCRi0U1AQ9wDp1h2Dy5bk2qtVOCjsHw6/xdwcdKf7x87SJ6WeBdYzCvQ90KqrcBE1r8e3SBOf1PBNaR7Bjh52NBJ4cr8sFce78IMM4vUZkLVvOtNidM+a2utE2qW0fXiKYlhNpluEvpiE3hQtzk4eYdm5ZY1b8P62jKDRjoky1lq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folded mappings such as RISC-V Svnapot need two extra pieces of generic
MM support.

First, architecture pte_batch_hint() implementations need access to the
same batch flags and normalization rules used by folio_pte_batch(), so
folded ranges can participate in batching with semantics consistent with
generic folio comparisons.

Second, leaf-size users may need the original PTE pointer instead of the
public ptep_get() view. For folded mappings, the public helper can return
a logical per-page sub-PTE, while the effective leaf size still depends
on the raw encoded entry in the page table.

Move the batch flag helpers into pgtable.h, extend pte_batch_hint() to
take the batch flags, add __ptep_leaf_size(), and update the generic
callers to use the new interfaces.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/arm64/include/asm/pgtable.h |  9 +++++-
 include/linux/pgtable.h          | 53 +++++++++++++++++++++++++++++++-
 kernel/events/core.c             |  2 +-
 mm/internal.h                    | 39 ++---------------------
 mm/mincore.c                     |  2 +-
 mm/mremap.c                      |  2 +-
 6 files changed, 65 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d7553584..018781a1fcbee 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -5,6 +5,13 @@
 #ifndef __ASM_PGTABLE_H
 #define __ASM_PGTABLE_H
 
+#ifndef __ASSEMBLY__
+#ifndef __LINUX_FPB_T
+#define __LINUX_FPB_T
+typedef int __bitwise fpb_t;
+#endif
+#endif
+
 #include <asm/bug.h>
 #include <asm/proc-fns.h>
 
@@ -1705,7 +1712,7 @@ static __always_inline void contpte_try_unfold(struct mm_struct *mm,
 }
 
 #define pte_batch_hint pte_batch_hint
-static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte, fpb_t flags)
 {
 	if (!pte_valid_cont(pte))
 		return 1;
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a8..da14328093a86 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -3,6 +3,35 @@
 #define _LINUX_PGTABLE_H
 
 #include <linux/pfn.h>
+
+#ifndef __ASSEMBLY__
+#ifndef __LINUX_FPB_T
+#define __LINUX_FPB_T
+typedef int __bitwise fpb_t;
+#endif
+
+/* Compare PTEs respecting the dirty bit. */
+#define FPB_RESPECT_DIRTY		((__force fpb_t)BIT(0))
+
+/* Compare PTEs respecting the soft-dirty bit. */
+#define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
+
+/* Compare PTEs respecting the writable bit. */
+#define FPB_RESPECT_WRITE		((__force fpb_t)BIT(2))
+
+/*
+ * Merge PTE write bits: if any PTE in the batch is writable, modify the
+ * PTE at @ptentp to be writable.
+ */
+#define FPB_MERGE_WRITE			((__force fpb_t)BIT(3))
+
+/*
+ * Merge PTE young and dirty bits: if any PTE in the batch is young or dirty,
+ * modify the PTE at @ptentp to be young or dirty, respectively.
+ */
+#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
+#endif /* !__ASSEMBLY__ */
+
 #include <asm/pgtable.h>
 
 #define PMD_ORDER	(PMD_SHIFT - PAGE_SHIFT)
@@ -397,6 +426,7 @@ static inline void lazy_mmu_mode_resume(void) {}
  * pte_batch_hint - Number of pages that can be added to batch without scanning.
  * @ptep: Page table pointer for the entry.
  * @pte: Page table entry.
+ * @flags: Flags that control PTE normalization for batch comparisons.
  *
  * Some architectures know that a set of contiguous ptes all map the same
  * contiguous memory with the same permissions. In this case, it can provide a
@@ -407,7 +437,7 @@ static inline void lazy_mmu_mode_resume(void) {}
  *
  * May be overridden by the architecture, else pte_batch_hint is always 1.
  */
-static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte, fpb_t flags)
 {
 	return 1;
 }
@@ -1855,6 +1885,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 	return pmd;
 }
 #endif
+
 #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
 static inline int pte_soft_dirty(pte_t pte)
 {
@@ -1917,6 +1948,17 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 
+static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
+{
+	if (!(flags & FPB_RESPECT_DIRTY))
+		pte = pte_mkclean(pte);
+	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
+		pte = pte_clear_soft_dirty(pte);
+	if (likely(!(flags & FPB_RESPECT_WRITE)))
+		pte = pte_wrprotect(pte);
+	return pte_mkold(pte);
+}
+
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of
@@ -2414,6 +2456,15 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 #define __pte_leaf_size(x,y) pte_leaf_size(y)
 #endif
 
+#ifndef __ptep_leaf_size
+#ifndef __ASSEMBLY__
+static inline unsigned long __ptep_leaf_size(pmd_t pmd, pte_t *ptep, pte_t pte)
+{
+	return __pte_leaf_size(pmd, pte);
+}
+#endif /* !__ASSEMBLY__ */
+#endif
+
 /*
  * We always define pmd_pfn for all archs as it's used in lots of generic
  * code.  Now it happens too for pud_pfn (and can happen for larger
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 51c1200ea3fdd..37b860abe9e61 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8551,7 +8551,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 
 	pte = ptep_get_lockless(ptep);
 	if (pte_present(pte))
-		size = __pte_leaf_size(pmd, pte);
+		size = __ptep_leaf_size(pmd, ptep, pte);
 	pte_unmap(ptep);
 #endif /* CONFIG_HAVE_GUP_FAST */
 
diff --git a/mm/internal.h b/mm/internal.h
index 874be94cf2570..aff00a3fdff50 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -343,41 +343,6 @@ static inline int anon_vma_prepare(struct vm_area_struct *vma)
 	return __anon_vma_prepare(vma);
 }
 
-/* Flags for folio_pte_batch(). */
-typedef int __bitwise fpb_t;
-
-/* Compare PTEs respecting the dirty bit. */
-#define FPB_RESPECT_DIRTY		((__force fpb_t)BIT(0))
-
-/* Compare PTEs respecting the soft-dirty bit. */
-#define FPB_RESPECT_SOFT_DIRTY		((__force fpb_t)BIT(1))
-
-/* Compare PTEs respecting the writable bit. */
-#define FPB_RESPECT_WRITE		((__force fpb_t)BIT(2))
-
-/*
- * Merge PTE write bits: if any PTE in the batch is writable, modify the
- * PTE at @ptentp to be writable.
- */
-#define FPB_MERGE_WRITE			((__force fpb_t)BIT(3))
-
-/*
- * Merge PTE young and dirty bits: if any PTE in the batch is young or dirty,
- * modify the PTE at @ptentp to be young or dirty, respectively.
- */
-#define FPB_MERGE_YOUNG_DIRTY		((__force fpb_t)BIT(4))
-
-static inline pte_t __pte_batch_clear_ignored(pte_t pte, fpb_t flags)
-{
-	if (!(flags & FPB_RESPECT_DIRTY))
-		pte = pte_mkclean(pte);
-	if (likely(!(flags & FPB_RESPECT_SOFT_DIRTY)))
-		pte = pte_clear_soft_dirty(pte);
-	if (likely(!(flags & FPB_RESPECT_WRITE)))
-		pte = pte_wrprotect(pte);
-	return pte_mkold(pte);
-}
-
 /**
  * folio_pte_batch_flags - detect a PTE batch for a large folio
  * @folio: The large folio to detect a PTE batch for.
@@ -430,7 +395,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 	max_nr = min_t(unsigned long, max_nr,
 		       folio_pfn(folio) + folio_nr_pages(folio) - pte_pfn(pte));
 
-	nr = pte_batch_hint(ptep, pte);
+	nr = pte_batch_hint(ptep, pte, flags);
 	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
 	ptep = ptep + nr;
 
@@ -447,7 +412,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 			any_dirty |= pte_dirty(pte);
 		}
 
-		cur_nr = pte_batch_hint(ptep, pte);
+		cur_nr = pte_batch_hint(ptep, pte, flags);
 		expected_pte = pte_advance_pfn(expected_pte, cur_nr);
 		ptep += cur_nr;
 		nr += cur_nr;
diff --git a/mm/mincore.c b/mm/mincore.c
index 53b9828037713..e23ef3f270db6 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -191,7 +191,7 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			__mincore_unmapped_range(addr, addr + PAGE_SIZE,
 						 vma, vec);
 		else if (pte_present(pte)) {
-			unsigned int batch = pte_batch_hint(ptep, pte);
+			unsigned int batch = pte_batch_hint(ptep, pte, 0);
 
 			if (batch > 1) {
 				unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
diff --git a/mm/mremap.c b/mm/mremap.c
index 384ef4cc2195b..f8b585e59771d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -184,7 +184,7 @@ static int mremap_folio_pte_batch(struct vm_area_struct *vma, unsigned long addr
 		return 1;
 
 	/* Avoid expensive folio lookup if we stand no chance of benefit. */
-	if (pte_batch_hint(ptep, pte) == 1)
+	if (pte_batch_hint(ptep, pte, 0) == 1)
 		return 1;
 
 	folio = vm_normal_folio(vma, addr, pte);
-- 
2.39.5


