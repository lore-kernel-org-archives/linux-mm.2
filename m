Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDC2CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 220A56B00A7; Wed, 30 Sep 2026 10:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9716B00A9; Wed, 30 Sep 2026 10:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EDC6B00AA; Wed, 30 Sep 2026 10:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE6C56B00A7
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A99DC07A9
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:43 +0000 (UTC)
X-FDA: 85270609326.08.B335366
Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CAED1A0008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ElwK2e1k;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kejX7DiXDSEjNsfVvfwB1fwE0QuTnt9rWXUy2FUn1A4=;
	b=YIBM81n/G9Tf2vTlXTeFNa7FWGezUhROuZ2bTtXSk3Ne1BGVBstV1eHmVLVmIl1ApI38JI
	e8FDvy0JH+t6W/42T1dUXEy9i4B74hTKaoZUo9YEAtaUoqdFLzs0fXHzT+2zTRfNc/g92f
	418xdas5bmUFfrPAKBcJ1H2d0bFVk4Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ElwK2e1k;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.168 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777321;
	b=BpWLBgF7c31LMvJP/furzzR/jq/A4ZDdKvO8SJqfuxM/GeM/2PHXucPyGNDG79nMo5XBWE
	bdlT3RNNszutaqMZ6Xj38Rx5G83ib9JqazhgMWBSVofWVnn47sgQFPb1NkBrNuIcOPdakd
	gkRXuXHs99uxWsQrMcJkqueB2dx+oEE=
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0d31bda43so3327033a91.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777320; x=1791382120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kejX7DiXDSEjNsfVvfwB1fwE0QuTnt9rWXUy2FUn1A4=;
        b=ElwK2e1kxT9s+ulgC98EyouW7EmSeawG/RADRSlQy1li3CCYVpaU5BTAK1b4SaD1uB
         IKTCs9QIC4vXvAL/Nii9mPifdnHnMr7Y+wOZrVBn91dfD0nthU50cXMt5BDGbBo45aMz
         rWz+sCsny1ZK0wtD1yPt2we00vpqdNJ/MQ5i1zo/0a744dBKKgcd2OB6fMPKrxWMvwFH
         R8Z18XDuCnW+2Hvrxj5TztG6v8zF851EDcc47Jqk2MnNtT/maQRjFYFp9hEF0oEsctiy
         E4Sfos7oAGIceuHuijVS+qithxVA0JufFb6xHPWfO2AZic7S3jS+4TUhSt1BlrIeiCKt
         R2Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777320; x=1791382120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kejX7DiXDSEjNsfVvfwB1fwE0QuTnt9rWXUy2FUn1A4=;
        b=NkEkjUaPdIYhcp1b0aJeiAbG376CUfNnJ0WqQBq8+KhAPDL6k+JHrHj8YnOlRxvfOB
         MjU1zIP52sGNig/12vVr/PVYepn+wxym0UXzwnYvS+qwmFmkPRXFm3k5YC7poou+JyPx
         soO/4e30CrG2EBjxLzI4WaoTbNGo0PMKRCRHQz3BSGWAgTFH5PcMnVPah1D5OqP9E7pb
         K2VNZKDD45nW7rx5CAoNMRPOcP82MV5/kq4K4lx/ki1ZVdbnuzzeQQ3F5WsFAO8UNEL6
         mMxIhB8qWkIJBk8IXYLEMiuebSoiLiBfG2jBBvxx5tYQlTcb6i7vgr/EbtbX/Dxlby2A
         0kSQ==
X-Gm-Message-State: AFq9FYJkJFBOIclThzdMAdKRhvHTyk4PrDbYYMOp+IbsvL4z9tUyyEwu
	MTECgOUjTAQ9hl+6DmfWYAQl1G5mSidowyR92+BUY14rTJjgHuU7HoXcn3qeXwKRzOA=
X-Gm-Gg: AYBFou3d9UH5Qxmdfu6/XT9/TZqeG4FyltGSfnxpBtx1HaHtbrsNEkyBMA0QyknTPHy
	8STAKcuykXMBmjg3qUVZL5Q2xZuWD9Vt+Wls/1ucOpLJl9mgpT9oGnXvRDDrb02wiWzXm6qbm1S
	wkyuV7ptezW3LwSDTabxHlCS6aNb6KSyjatB0ZniNp3gsHVrG2OPDpzxy5FvbM7f4mqQTdozwJ/
	rLl0Wk4Ps+UZjgEDB4fkkieQ0yTKz49X/vuGG+hGbwGIr64lJ/bf6zXmb/3lnZf7zlke3nk5xJO
	Aej1Qt0fm95cHBMM13IBnOVw18TfbuKHdlEf0Z7+4inu1AgIrTuBfBQc0izMgGMTYbnv9qtLf1C
	Lqp7rkAhlxlwhtKwrZdOkWB4r+CislawTbpGUMn2sIOK5zem3Jqq47ifv++dGGM3VZWZxSKoGmN
	Hb6WTB277HqV9dwUCeteeg61NQohqQbi954tp11P0VDJ2vRlzGqKTFH5oP2UbQ7Qydd47PT67nB
	5tum20x8q4nzA==
X-Received: by 2002:a17:90b:2d07:b0:3a4:c673:7636 with SMTP id 98e67ed59e1d1-3a4d19d4232mr1117525a91.26.1790777320318;
        Wed, 30 Sep 2026 07:08:40 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:39 -0700 (PDT)
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
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 10/12] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Wed, 30 Sep 2026 22:06:25 +0800
Message-ID: <20260930140627.57431-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CAED1A0008
X-Rspam-User: 
X-Stat-Signature: 8nn87t6hci6ddybmpnofa6io3gukeu5r
X-HE-Tag: 1790777321-873340
X-HE-Meta: U2FsdGVkX1/XO3qZSy6W2MdW2+xmUlAR/kzdA2nJpAhZkwttiST19/3SUmGIMrP3pwHIT47hbsy6tsKH/adj2ZBNL3Na379TgBbo0A39A20FgAFuL0/0eq6GULZbTqRJcG4fuajYQQMlfZ9CLlJ7ZMxsLvYC0bw7ozMDs0U5b4Y2pRGKqpy2/8pDWvF428WA87NjyfjqcYw5FfrHPQHCylPiUzuQ4BzQbWMyAwWlzHGMHAR8KygbfqblXFbYcbRu5PX2LOG2G71ejgnEES6ybDf7Z/Q8/+0Fj+Ft6h1wgNs6kqbelNNt5bmrG1k3z5DalrCsKaHCHVQSskiKVUQEOXtp2nBtSy94mqFgkdNivmuxbVOSs+CLOQL0m3RS9X+7/ySKmYhoM/K9lmUUS/4sufQ5sL8ObhgRxzNkGdZE0TmRTEC4srDzVjPI2tqdhJvnjDqaviiHjL89nzf+ok6BATqdLaC8HUJvuQ8A912ksbT3wHqjYCTMjS+JJCZ7o1jy0ZCXrz+MG0XBKO/O990P/O14J8GVBt7ucLfuAD3ushL7fYI+HLd62UZEErVg0L7NdmBBAEWFACv1cJMrLmlt3xJeVy1R2KmZUkH4q4mjikOa2lnx9ld/Y+siV2wZvH2zXmMKuCP40c4TS8Bo/TxazktM/FvV+t4lT5+9nkvhEdTadj6QsOXxNNe5URv0O4PSclVPEsWPiZI9TGvUUNAhRD7dOrd+Owh3YkUb/0Ubd5d4FIoRQNuqL+B9PK3gVO8hvQVhNjxURMKtLEjQCK6nT/HDyy+UgiubFGphlxYdT+x4eiPTGGw3cMNLEjKe/V+k31gkyGjkaCCRfvMor378Q9ojKWyG7Cix38B/5hMpDNjhkYeTCbM/QaYQ+RXqJroNMqrRUmzmLBFUJhN5FcGHbFE5BrbW/AuR/YT+f0Q87nlon8BP+YziObH5upMMvTUmz5m3p0O9OnKv4LC/lGB
 NJsKUH/V
 FQDP/AHXSkDR0r3/mCa2vD6WLblC9LwVzdHIM/lsq4fVRp9L33WwxiMJybD7IWmPxcTqE3BALMlJtkCiADGsU41DQjd/qB3pa2gSZcW5dVJ2AllTuP3H11BZFnrGtwfEoAo26kPpJH1qI0QsVraCljH3H0YQrKXgfvxPBX/hyNQcrMLXug4FJXuVWrpvpx8x7o4dbS2XI3Ap53ntKsMj95z0mHghCuDGuolYyRLvlw23nZaZ/yuryiIZmfXsKHBc2bjcXHq6bwdLXrYWWJ2W3ZTy9V1j8Ug9F8fMyGIJaZ/vUHjQ4RqTLa/lWkVzIq7UYuZezY9NZWQGSVQe/s7sXSkLWswgLcs085hhpKufK9bJyIslZWUqTPz95J/VHaqtpbt6XceRDtczGEdyX7QkIXzygPg==
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v3:
- Collect Acked-by from Qi Zheng
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 46 ++----------------------
 include/linux/mm.h                       |  4 +--
 mm/mm_init.c                             |  2 +-
 mm/sparse-vmemmap.c                      | 13 ++-----
 4 files changed, 8 insertions(+), 57 deletions(-)

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
index 070ce27e9cd3..30a3365bca82 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,6 +38,7 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
+#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5167,7 +5168,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
@@ -5187,7 +5187,7 @@ static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
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
index e1f8a03e3d49..4cea94126cf6 100644
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
@@ -558,17 +557,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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


