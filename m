Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33878C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 05:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 301E86B009E; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B10E6B00A0; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4A36B00A1; Fri, 11 Sep 2026 01:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCBF06B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:04:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C0ABC0703
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:14 +0000 (UTC)
X-FDA: 85200290028.14.DE2EB68
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5374540002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:04:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T1ktmnOh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=T1ktmnOh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789103052;
	b=lKL5fQ6MvcLh+DR+tfRqOmNyTkEW/PRVuD7ueF4MwMT1QFFGGgPfRbeM1/x1rh9tpRWPjW
	bEoc1MkR+9lGv8+OWFmguGDuLx3DhUC7DWJOCTIlP2TSWRECkVKbzcBSbdrcgO1hjV1qdT
	MO+FnIlwFq8nTPqhrvb/UHSDZ3D4sf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789103052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZ9EEhriv4uQFVrwFElKF7ZgZH1tSjYdJIJZrcuS8I4=;
	b=bRVP4yBB16Feh+cX3Cf143ThzQM3NT5LJ/selwmT3CX6g1teAZpI6w4TyVrrTyQomAwjcE
	gfzycjcYRx5hE2cUCTDugTxNeqEZOJ1ARQOvwcxMX4Ou25SfaF/y3BvNCxhzWy1WPUFrcE
	mjupofKAVIGYgP9oG0YVJoS1gTAH7fQ=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd78e6eso150741a91.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:04:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789103051; x=1789707851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OZ9EEhriv4uQFVrwFElKF7ZgZH1tSjYdJIJZrcuS8I4=;
        b=T1ktmnOhlb7/aYGbB5TfZZ8e1WNB3TcKxCx6AzxZQXDJP+Vdv50/J/F2KJ2u9u8RAl
         x2MAEfTx7mOPlfjkkgtpbF0YIuCwxEC7liDuOKAOfHJl+fX9m73gMt5+tswtBRysCYmi
         fBvj9VHxZ9QxLwR/lWtiPnFuXrs0zTOp86cQXYsHF1e7y67/Kujgo1G24awnV1YEalwd
         eWKRh83/kfjDl5c7oXSrPpE4lcN/NKbZ7/VLB5aRemxE2meNrKdP09Fkg9ng8O4z1MBw
         2WrRZ2BAqrc4FB9rL5YnyxBv2yPDz0AR1hApaOvy5lN7teQRqwJhRPOiACoOaydryTZq
         0Tcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789103051; x=1789707851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OZ9EEhriv4uQFVrwFElKF7ZgZH1tSjYdJIJZrcuS8I4=;
        b=U81q7MQBGhMECLNPgtqWxM0fZaazTHxdTB/SIkxdi86X+w4QPotpfgpEOv7mcfn1bZ
         iMkJfxPWbqS6KYtdmpuZMCHQzRV4r9dreZMDT2Io4ywyLmXijQ5600E7cmtTVuVgHpZX
         6feLM0mOU9h2vBpwxXGsJkINx6a1+zbFIVZXEhff87953+F3Phz37K60HJnSz6WGOMGE
         rB+qYSfuCK7MIDyJwlRp2C/iP5WS853Qn3GuWGcwmwjftI44D0L3lbHc7Co48hBF9gs9
         rVhMsZYPDIKTbNw4VJ05Ot9m9pvYIl3DxX2ZijY84uqyf3fD5oVxeo2cjDg8fZjstxTR
         Yjyg==
X-Gm-Message-State: AFuF++nSHC3+1XWQQI8rzYeDRkXyAWOnFhxn0ifavfcm+LxNJtfsAr8l
	MF0tMgh0dik/kSFlMnlfYfF3Ut2w1TA5nAP3v+jT39hcu3umjmZr7z5Hzk4CwPd59tI=
X-Gm-Gg: AYBFou0eYe8Droc7Oqkytw22+8WnODIzL/zAj5zi7GfeftJ2ERpmfXFl1njn2BMsGbW
	63ovrgJBLeDj3S2LZVkIoC9vktbOI2GwRZuHqW5VRD76fHPOyZ7t2Exs2ugFy4QY/wAq22mYLDJ
	zPAGK52lOSXP34HqR1tspKve2sPW5Q8us1uyx1Dd1UoGcDKM81Rq5jbQLBTR9ez69Y03CL6V3fI
	AqbPQ5/LSTvcNbUxqpt0dxvDlzLREqcJfPa8iy8NTbcql8kI8hDM3UchzmMvlYEc595ekMi23G3
	F45jZ4WALjhmYO9kpv61kippBfGMOn892GXy7AoZgbBpXW/5K67gnsAorQF9hSLnriBmiyBFHuI
	3JlJ3nw6g0iUN34ElphpWEEMZJEHh3U58Cq2QCVck7LNp8hyjtBUSKf9QFQaggTh17yE83fA16v
	kqWXALI994QA1KQ8Twb2BwRgeHXH/JM6wzh1wh9oVzhISU5t4HfBTY1xCD91ewzmeGdBegG0B4I
	EybV9wjCeEdhsI8o34QWnL/RTUXR25cO6j/
X-Received: by 2002:a17:90b:4c4e:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-39d9805da27mr2729392a91.9.1789103051065;
        Thu, 10 Sep 2026 22:04:11 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d99531b16sm2651561a91.14.2026.09.10.22.04.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 22:04:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 09/11] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Fri, 11 Sep 2026 13:02:26 +0800
Message-ID: <20260911050228.58884-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911050228.58884-1-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5374540002
X-Stat-Signature: q8rsfx8d67tdcdfacfi49pz51n9usx1c
X-Rspamd-Server: rspam01
X-HE-Tag: 1789103052-942346
X-HE-Meta: U2FsdGVkX18YhpQVezgO+zljmkwWB8TdmDFecDzr0iSirWTQrS14CTRZYvzJNyrVy1I7Z4iWBYE99p6bhWtFlA/x0AKxNZCHSlQli17d2//6BjRTzRbkHIAbGMGIJ5tKu0NmwCuEMYYFjX4lZo+1TPabtT0fh+xSbsv339U8qBXWxYx9IOTU13z3/N8QV8+U/V+MGyjdWcIKBvRpimGCv3jpOeUHX4rwueHmPeai8rGsXtIRaZ/JoaW2SmbqceL3Mv0J/eE6whKaYp0ozVI85q7ogPg6jxCVfRT++Q0M5V0GWS0MxUjeNEzWbuTXaTSflbs2GrnVzfqeatDe72A7U0t6cdqbUv0FO4uekIGcTBNH4x95LYnPERnx0ZkTSciUiiT6BqJWAhPrw8dOpe+/znnoRW5LMeo3H7SaNegr7bCeQrFZTXtRa+gZctQWLhDyz5nwKwxo6kfqEC5wvdRplVWJUaFuTZTmZ6ZBbu7cTTuniigFS5Hkh3qes7V9s8s77uPxfbHe/Hwef2R3E3trfKL4VTJqJMrJ0yC4v6sq5C7eFktbFMKcHeBAvSskTbHXNM/t8W2s4TuiwUc+pdTK688gPFA3lS+m9C8XQEaW2KGiWRQPagyASiCLtcHqlU/W3OgztkkDPFD+MI4x4qjRSHnPAExQNN1Tp+AyFeNaO3hOQ6LqLFC5NsRXG3NBI828iw0Qlv7NCrjJkljsE+2kEh98tGj7Zhk5KZ3P5UQCSiRioJJkhF/QZhSRk8FcSA0eqMZCbmVaHWlBQQidQMXtYW4IdYy50T8piW6ZlKuiA0r96lL0yQh72N3DPD1szqw1RPfhf5ryuJLj85LXfd3P/MjEPL31nTlhRpzZINqa9oVMjC0b80nfYw8gmQlnAs71tdH0nTWFyQ8KHr//WUkIbXxf7JQ97N0RhZrbFwXZ4/GxeQoD8AoxOtSy4GgOgtDRkHVspbRh7Faq731hg21
 9J2Z0INa
 +Jlg97bhaBJ/P5JNkCyppRqC74ecFDe2cwFX3qWJGSlAGIa4ZW/pS9nSfAONih/W+nw9hr+XyMBSOOQdTfx4CraE+o7Mt032qncqlN2I9murpm5DSzZ/BHS5a34RcyXBq/aljWWsWJNgdDE6pnKBeG2WUwMeq5w8BNdO3O7QWD8V9wlaGUbaudSKJiSwdtGXfviOcOv9BYi4oBO/eEXgfqJMENfx/ReByuxEUQDYm6Z+74WuptrLGlavJgpxGZ940QWaziloyZuLUyH2BRC+O0jvGNFz0aXYblMKzjAFoMPP4MBfL2Ozc7v89VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The device DAX vmemmap population still reserves one extra tail vmemmap
page after the head page.

Drop that extra reservation and let the shared tail page cover all tail
vmemmap pages after the head page, so DAX follows the same reservation
model as HugeTLB.

This reduces the reserved vmemmap pages for optimized DAX mappings to
one and removes the now-unneeded first-tail population from the generic
and powerpc paths to simplify the code as well.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Collect Acked-by from Qi Zheng
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 46 ++----------------------
 include/linux/mm.h                       |  3 +-
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 13 ++-----
 4 files changed, 7 insertions(+), 57 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index ee068f24a79f..9ca28e4a610a 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1218,39 +1218,6 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
-							 struct vmem_altmap *altmap,
-							 struct page *reuse)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = vmemmap_pud_alloc(p4d, node, addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, addr);
-	if (!pte)
-		return NULL;
-	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1297,7 +1264,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte_none(*pte)) {
 			/*
 			 * This could be because we already have a compound
-			 * page whose VMEMMAP_RESERVE_NR pages were mapped and
+			 * page whose retained vmemmap page was mapped and
 			 * this request fall in those pages.
 			 */
 			next = addr + PAGE_SIZE;
@@ -1318,16 +1285,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				/*
-				 * Populate the tail pages vmemmap page
-				 * It can fall in different pmd, hence
-				 * vmemmap_populate_address()
-				 */
-				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-
-				next = addr + 2 * PAGE_SIZE;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2ebe87e7654..969594074fd2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5167,7 +5167,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5187,7 +5186,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
 	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
 	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_RESERVE_NR);
+	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
 }
 /*
  * If we don't have an architecture override, use the generic rule
diff --git a/mm/mm_init.c b/mm/mm_init.c
index efffa8609b85..56bb4567a494 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1056,7 +1056,7 @@ static inline unsigned long compound_nr_pages(unsigned long pfn,
 	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
-	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
+	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
 }
 
 static void __ref memmap_init_compound(struct page *head,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7b5b9ceec697..39f0cfeefc6a 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -136,7 +136,6 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
 	const int order = section_compound_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
@@ -147,13 +146,13 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return VMEMMAP_OPTIMIZATION_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return VMEMMAP_OPTIMIZATION_PAGES;
 
 	return 0;
 }
@@ -521,17 +520,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte)
 			return -ENOMEM;
 
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1, flags);
-		if (!pte)
-			return -ENOMEM;
-
 		/*
 		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
-		next += PAGE_SIZE;
+		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
 					    page_to_pfn(page), flags);
 		if (rc)
-- 
2.54.0


