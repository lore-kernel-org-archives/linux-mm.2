Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE6BC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F546B00A1; Wed, 15 Jul 2026 10:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7678A6B00A2; Wed, 15 Jul 2026 10:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657CD6B00A3; Wed, 15 Jul 2026 10:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33E0F6B00A1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:34:03 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 949D9A0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:48 +0000 (UTC)
X-FDA: 84990889536.25.A146A97
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5CD8180009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:08:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JSn0gN0Q;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117326;
	b=kPx3VptBiAtt9b9BXhZTCg8ND9G3uQ67PScJ/NA6t/e10UFyXUBsEPpWeiLY4VZgKzCgOR
	EmT6yjeJjDLo+2Lee3rJkjaI1h1k/4rid0qZEpGe6AxoGEbiFeAAjCYT+oN0VyyR/Vw965
	kCQiCZ1LBssD4YVwGGubbePNFrqE6w8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JSn0gN0Q;
	spf=pass (imf24.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6yq7ihIfejq4Lg+OKf3wnzi+aWZFQXVEshsSbOMWJY=;
	b=EPQ8Bh5SxpSUySZp4DbEhuGosYOhrbpeNzIAtTIZNscMZsurQKfIqWMRub2U8mto0CoXAD
	d3aq5PVnurlRYmDtANwTgH01iMzLT+6iPOiIY7tV4wzxC68eJVLIY1hO0R/mfUJAJQJl71
	EsX/LuvnBN8ok4rJqIJrWJBGX5n7UU0=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so61731875ad.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117325; x=1784722125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q6yq7ihIfejq4Lg+OKf3wnzi+aWZFQXVEshsSbOMWJY=;
        b=JSn0gN0Qu6PczHJqGhLkS+B2lXnXqHL4BFsstwxZkaJb9xeR/95DwrmcfIzl5YrYjd
         MSwYrHQIHnyvutcdK3WyRfRYtzX8bTT1LEKp0cEIQPhjFbcX1OfOOO7Y51hdT2GW7KPi
         UYk2m1I4pdiNdht3dZwASNm9uDc2d0qcPitthi2r2kkSVPp4yjLWBKGVQmDutWTzJNln
         StqXmXuC0wL/qpLuNl5/UEX/NO915REaY2Lt6dy2yyofqqQ7w5zyunGhyas/Wu0rCH3B
         oVgq6nFf4HPEGwP2x+QgWuywVRIKS462EMNA88lmtor4c4yOdVupu1tsNEnhKkIP3c59
         SO6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117325; x=1784722125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q6yq7ihIfejq4Lg+OKf3wnzi+aWZFQXVEshsSbOMWJY=;
        b=UhLawrbtFG+gTnWG2kgttFWBS/+XEI1Ymvc89JW+G+y3+Fv29bT1AUFdzAOADg6JXA
         2u9TSMnAmvkMTn9+EQYD32LAKqhPU/hUv03VrWf32lG5UtL7ZK46sioV5g9olEX+BIKw
         9Bauw9e+0gwp3JPxn+SG7oasjo1udoHiagblf9BSTUnW5XCbC1QhFgVa7wCMZveGJkOG
         yAC/aZyiLQ2La4mM6AexK8vmRVszTciFWGA7u19BAxAaDJhgGqnoYqvoGfpqgIs39B4t
         5KkY1SuNhb9Z2+gfOjXz3VxDT9O0RgiXA9jKp0W+nuhOSeAsbjiyMjx/TlBMtKSbf12l
         2Dlg==
X-Forwarded-Encrypted: i=1; AHgh+Ro5UpGqAkRxtntiFJ3b1pfR0F5VJmQ6AP+GRLv/FKGAPkZlQjwOvdAanJsUYBWl9euNeIceBUIZ6A==@kvack.org
X-Gm-Message-State: AOJu0YygWb4/r7yujSs1Ye6vH32yeTvNsOb+Qm16JVplVNTftYEOYsHY
	P5pIKsGrDVr1Q/BFgYxPQS6AiGxPOyT70AO/p+YQUHAS3ZQDeqe0JrhPwVc/Dg==
X-Gm-Gg: AfdE7cm0HDrPwRiUOmSTt2ThuuF2oZEUKITPxhv4e3gMpwFWffYYx2bUZt/Xk2mz0Ey
	P0hAqtIF6dd6fdQU3C1nplfDXNPeTXnbW+bzgSjI/UYs7pPa3fjC7G8FsG/6/5YxGsPxWxZPJMT
	0Prcvn7ZbiK0mq0QVe5SvitM2VfevKgpBHNYTBUFsgseZL8f8Cs9KFAHBssYmfPvLdTAVRy4tOk
	Ki1MwXpulrteEa1TLuw0Y/TKWe6lVDtzWCQFzxH/KAjAL1vUS3UR6043x5il7eyE6aH5weBCJ90
	cfItl1wygi5ayTcxORZtqKloaa39yWXvBZr2Q+cAJSbuZJiyh4O1SUDdWaEjgxWp99wSMorwg5P
	E1S67KBBLknyCKR9Q9a6KH+kEPeJfDT4cK70KQp6xYC78LlpH4VJaEwo4mCMu9EkJ9+HklrS3H4
	DpZAOjh7E3GAi6rL+ptIkFXzKgHY1v98ri4Lw=
X-Received: by 2002:a17:903:1a45:b0:2c6:90ec:f601 with SMTP id d9443c01a7336-2cf03bd51b0mr23224295ad.8.1784117325413;
        Wed, 15 Jul 2026 05:08:45 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:08:44 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 4/7] mm/vmalloc: Extend page table walk to support larger page_shift sizes and eliminate page table rewalk
Date: Wed, 15 Jul 2026 20:08:10 +0800
Message-Id: <20260715120813.3609949-5-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5CD8180009
X-Stat-Signature: wxri387ag9na55m4rrrnodzj95jhc8ys
X-HE-Tag: 1784117326-41484
X-HE-Meta: U2FsdGVkX18M1hz9fajnEtSzdwr9datIWp8bzSH9zJysmZkCEjb1ox1fYSX7dI+GKlL+cNKgYrUxaQuv18CpZvBoaoXVxEsqx4Q5BZidQfDO62UjD7zKQ4+dR0KBGEK0chPTYKGhlOSwxiS5333rtl44/znExVGYFD0Ov+n4S9BcYIrKwVDDRLIwy4jxnGfsczG9y9kksKJq6pik/ITAtLjvH0mq9WgPIk/AmrnxM3wgYHMcfEWWnYOTTclIyEjB6HS1MjVNku4XUim1o2MPBulXvO+zQeZ4IGH49Ib6qFt27+mw1q+6WsxIc3bFzAEsFant+rwdtMXlSASVJqu7FRRIwNPUI7c4feHFKHG8mhqx3dAMmUxvrlnKOs8fLr+ilcxkx50DVNNd27AkjHEd8YZDF544fqneSl3AUD3308Td3uSsZJoSG1n4QtK5WAHPvfDRSpLPQbEQnXYqU/jp7yG7Cg5lQ2/mLkaqpIAcs0ZHghq8DLw5qB5G/gStlPMnGJDJdnCv02zMvASFzd5nMsOvy8fZHfBOz61d+4FBh/VWjMY+jpMOhtPVxIwRB29kYZ7+GPotvPpRo/lbDs8mEWtsO+G8DYAfk44zHMr3qSFkZCeQ0+e81VYRFecI36aqjYluK5PFbrvTDM3G1svsVgRR4ynKyR7Pz3B3UHU7ImV3+/2wP5FXGirhVnQiCL7zH3QSnKeUnC5sAeq9/h9PY+H2hvo7sSqKbtP+29gVA2uJq9SYDjSNSPrq/jqlQhVHSifa4LXXbtvg3oumGIPrHQlnQ1ERYe8PJcEFBJBIC9SSumRpbM2nre3rrdGDCIY1MGZR+NPT9TO3QjIAJSkxR1Fic2VXYGE9U47DFPN8KANuGG5ufA3raFYSwMIhBb7/Xd8ao2gH4Sm/0zNgqRvyLpSgILjxFhKadgQYIfHpeWkFITyOFBZGex/C0ki7w28hQsbV8EBiqodK7E6g1Li
 cK26pDnF
 4cO/EW8nLOscchSy5NWT2q/YMWpcAT4YDAErN2ZUwaSunQKsCLtE+Cd2fRPmLAqzbe/X3NdzJHOqBNjBYvhWcnBzAbJCIDzlu3hR9LLc/TBxDSd3XaI6CD/BCkkt3CjGvlbF+xvGm4lCfL2dovEfXrgat+0Vj//o/VE7C7vkKpPRBYS2/P90BnOD5hw+k95/N9zsMdUy3Nf+eaPL94evCqiUmTnbvmBYW7wR3ZiwuqoJ4z94nSjxbZzyk49XDVzzsHpR4qtK1bKaccoNOGFGhF5WU0ErNGpi7MkZFanakzyx1Td+vW4V5DvA2yBqfwBcGVmkimX5x383yIbXvwJVSfnJ+MESQmREBBhQewwskbmWHSrZNkoJDmftWpCqrQa5An6vXirn/PwgMDdCIjG4l9wDaH+lysOWFmt2yrrPO5av1uqdfKBARMHFrrLd9ESAzvPpSC1m6UohAA1KKXeSuj7bYUjH2QecZYBN/k1ThoyOkDWXJCR/rNvjmkmGb/rxj5K99sU9CRtSON1Ym7qQN4MITgfppYpIoKmsUlFfBS2LNuoqBK1tjbWtgC0bRVuO0UDwOLN+32bC2udGAwlv4awkf9NksmcdHUS//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

vmap_pages_range_noflush_walk() (formerly vmap_small_pages_range_noflush())
provides a clean interface by taking struct page **pages and mapping them
via direct PTE iteration. This avoids the page table rewalk seen when
using vmap_range_noflush() for page_shift values other than PAGE_SHIFT.

Extend it to support larger page_shift values, and add PMD- and
contiguous-PTE mappings as well.

Rename it to vmap_pages_range_noflush_walk() since it now handles
more than just small pages.

For vmalloc() allocations with VM_ALLOW_HUGE_VMAP, we no longer need to
iterate over pages one by one via vmap_range_noflush(), which would
otherwise lead to page table rewalk. The code is now unified with the
PAGE_SHIFT case by simply calling vmap_pages_range_noflush_walk().

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 86 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 34 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b9b29f7857bb2..afc695d5973e8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -541,8 +541,10 @@ void vunmap_range(unsigned long addr, unsigned long end)

 static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
+	unsigned long pfn, size;
+	unsigned int steps;
 	int err = 0;
 	pte_t *pte;

@@ -573,9 +575,10 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,
 			break;
 		}

-		set_pte_at(&init_mm, addr, pte, mk_pte(page, prot));
-		(*nr)++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
+		pfn = page_to_pfn(page);
+		size = vmap_set_ptes(pte, addr, end, pfn, prot, shift);
+		steps = PFN_DOWN(size);
+	} while (pte += steps, *nr += steps, addr += size, addr != end);

 	lazy_mmu_mode_disable();
 	*mask |= PGTBL_PTE_MODIFIED;
@@ -585,60 +588,90 @@ static int vmap_pages_pte_range(pmd_t *pmd, unsigned long addr,

 static int vmap_pages_pmd_range(pud_t *pud, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pmd_t *pmd;
 	unsigned long next;
+	int err;

 	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
 	if (!pmd)
 		return -ENOMEM;
 	do {
 		next = pmd_addr_end(addr, end);
-		if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+
+		if (shift >= PMD_SHIFT) {
+			struct page *page = pages[*nr];
+			phys_addr_t phys_addr;
+
+			if (WARN_ON(!page))
+				return -ENOMEM;
+			if (WARN_ON(!pfn_valid(page_to_pfn(page))))
+				return -EINVAL;
+
+			phys_addr = page_to_phys(page);
+
+			if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
+						shift)) {
+				*mask |= PGTBL_PMD_MODIFIED;
+				*nr += 1 << (PMD_SHIFT - PAGE_SHIFT);
+				continue;
+			}
+		}
+
+		err = vmap_pages_pte_range(pmd, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pmd++, addr = next, addr != end);
 	return 0;
 }

 static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	pud_t *pud;
 	unsigned long next;
+	int err;

 	pud = pud_alloc_track(&init_mm, p4d, addr, mask);
 	if (!pud)
 		return -ENOMEM;
 	do {
 		next = pud_addr_end(addr, end);
-		if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pmd_range(pud, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (pud++, addr = next, addr != end);
 	return 0;
 }

 static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
 		unsigned long end, pgprot_t prot, struct page **pages, int *nr,
-		pgtbl_mod_mask *mask)
+		pgtbl_mod_mask *mask, unsigned int shift)
 {
 	p4d_t *p4d;
 	unsigned long next;
+	int err;

 	p4d = p4d_alloc_track(&init_mm, pgd, addr, mask);
 	if (!p4d)
 		return -ENOMEM;
 	do {
 		next = p4d_addr_end(addr, end);
-		if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask))
-			return -ENOMEM;
+		err = vmap_pages_pud_range(p4d, addr, next, prot, pages, nr, mask, shift);
+		if (err)
+			return err;
 	} while (p4d++, addr = next, addr != end);
 	return 0;
 }

-static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
-		pgprot_t prot, struct page **pages)
+/*
+ * It can take an array of pages which are not all contiguous, but it
+ * may have contiguous chunks, as hinted by @shift.
+ */
+static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
+		pgprot_t prot, struct page **pages, unsigned int shift)
 {
 	unsigned long start = addr;
 	pgd_t *pgd;
@@ -653,7 +686,7 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 		next = pgd_addr_end(addr, end);
 		if (pgd_bad(*pgd))
 			mask |= PGTBL_PGD_MODIFIED;
-		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask);
+		err = vmap_pages_p4d_range(pgd, addr, next, prot, pages, &nr, &mask, shift);
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
@@ -676,27 +709,12 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
 int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 		pgprot_t prot, struct page **pages, unsigned int page_shift)
 {
-	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
-
 	WARN_ON(page_shift < PAGE_SHIFT);

-	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
-			page_shift == PAGE_SHIFT)
-		return vmap_small_pages_range_noflush(addr, end, prot, pages);
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
+		page_shift = PAGE_SHIFT;

-	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
-		int err;
-
-		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
-					page_to_phys(pages[i]), prot,
-					page_shift);
-		if (err)
-			return err;
-
-		addr += 1UL << page_shift;
-	}
-
-	return 0;
+	return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
 }

 int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
--
2.34.1


