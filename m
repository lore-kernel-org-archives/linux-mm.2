Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C03C9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BEA6B00A4; Sat, 26 Sep 2026 22:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73866B00A5; Sat, 26 Sep 2026 22:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0506B00A6; Sat, 26 Sep 2026 22:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA0BF6B00A4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33F4E40261
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:43 +0000 (UTC)
X-FDA: 85258026966.16.88E6D02
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7863FA0004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XSIcPfQ3;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoDGlxDfQClS9LJzaMCGDThB6goPDglPo8AWl0LRFoA=;
	b=cUh00MR+o+XWbtr9asJK4B10vqQIUdvg/50omHTmfjJsXEE28k+PxEF7hywLvO/yAa5VzP
	GmgH/IReYKxpcyfRwgd7Fhsp46kbmae0uY8pPfMG+nsSZKRZHnNJ8NysLjWVzIh/aScx+d
	HcCdZOnj0FYqG2HUPZhWpxTYTth+8Bw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477741;
	b=Lz6I/6lfGVUop6BkDdkn+w3yRziBPAN7LGEx1k6IcKOxTjh4OZ/QNw7mdHXBgwdgHjMgfV
	RLOpliyRRW5Ua/9hreT9BU5rvVz42gHUPN8SFePZeNvnaebJTUsSavLk0jcDlB/kCDCEMi
	ihGYR8S0Nm8mVGjpuKd4qARaBqDfSD8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XSIcPfQ3;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e44so422354a12.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477740; x=1791082540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uoDGlxDfQClS9LJzaMCGDThB6goPDglPo8AWl0LRFoA=;
        b=XSIcPfQ3qhROouo7CO2g/pzjg15LSVPrvAfQWGC3DO4i5pUZ5QGM5Tn+0IByuFbmox
         C44Ey/HlRWyGOkH4QNFW4ae+ACjeYgXVVqheoTWl0Xic7fRfhfNwDeQccvS/oimdwYWW
         gS7JGBssQeCcQdBma9WMz6mh5XuuYJvUwk89k3qhZdtUFeLinjsJSlnLaNNlch8eLR1E
         rrQMcsrJo+Bf9UrC7yNalun910z2XxNPgRGzwq7p4Hc5jmCB9il/vy5nAfkT5hwjp18B
         +3QaBJOBilr7a+6aHesekB+XiD3KSlTO2j7lhD9Wnnf+U6TNDe0YRiJ+c65+OSEq/+r3
         QOIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477740; x=1791082540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uoDGlxDfQClS9LJzaMCGDThB6goPDglPo8AWl0LRFoA=;
        b=XN2FVBFnpVqJqgeAxfJNB685gsqbKo8GqQ0wJseBI/27BQ88G6FJm8AvOpR0N7BIr6
         1pLxXU8M+/jRUTOQxQZWiRzEJKsEVmcx0W8Vgjst91iq4mRRoNQmZXGJYL/Ss6poEwnn
         YPqZ+ThaBXd4qJh7HOt/w4TVvGQ6VEBoCvz/x7yD9U1DoykdCXd5UZ92unAYbjOwvcEW
         BBDEkRf+wpnyxMDz4DHA08GubPvLEfn1vRLu3I4sbpjSl5SFAQjTaU4aZ+FfnNZhIAfB
         SS+j8gg/sFsEf3Yu9QkQA1izSQbTAF1UXkzRzNcAPTLvMv4JEQYNE4pXPrflSHb+MWkm
         d2Vg==
X-Gm-Message-State: AFq9FYJDhPADb8Bh8xlPa0YeiMkei6FeFBifGPmA+J8rqVde5ptuEL6S
	OLXvg/pCOlcq+xHWT3s8NtU8UZ4JuT29DG1vPXwdMnL4RZBlwflQ0O/9pOO93wwpfag=
X-Gm-Gg: AYBFou09ZD2Xckke1NvhGRLFOW221qNhRsV8iHIIQ6Xpz6OBwC/47qoe/t6GS9TUWqt
	+aUFLAlcjDswLjWQJItdG5+SC7iJMiaT7RqmuLqRwf2qnkku6X1OzrxGGp91LSTI+WntXsiPs6b
	OSktFdZRuq3d8mlNq/aF6KXcsCBvm02bxX7mTX+WS4gGlw0PfeoWHNZtNdik/ylQm9V04eYKa5D
	zCW7vIQ+QKxnBAXMvRWKLwlBPPZIVpagOK5HeVyy9wKc9pQXrwTmae4yGLrAPckMqheLTRPnE4L
	GcLvJRa25ohYpBCvU2HDf9N8YUM2dRW59iTulQylHUxKcThmPiY6Mg9rHLiOI3wtJa3Km6PAics
	Gt+RFYXVC6kKAJCS/zASfgWAi0ruqPghL3rQjcqY6fMsnBnXhxJexgjCRvzgYGG5z9pziVuzAMX
	cD5BaG5+Xk7KGuSRf5Z+Bj1IrpbOLHXdWSOOQOKg5puOi69WOi9UrpSUeEWYNNjetVL7OlW0UDA
	3C9zzVZsSuItptK1G5g
X-Received: by 2002:a17:90a:e7c4:b0:39e:6c6a:4b73 with SMTP id 98e67ed59e1d1-3a098e3eef6mr8558907a91.61.1790477740110;
        Sat, 26 Sep 2026 19:55:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:39 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 10/12] mm/sparse-vmemmap: drop the extra tail page from device DAX reservation
Date: Sun, 27 Sep 2026 10:54:39 +0800
Message-ID: <20260927025441.741633-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7863FA0004
X-Stat-Signature: 7htnd36picz3j6ade75bfcopcswjs53w
X-HE-Tag: 1790477741-523016
X-HE-Meta: U2FsdGVkX1/sbzU3sP4NrqaFiMaLY3BJIfT9JqyvKkVn0tUdQ7k+ZLto5tL3JPRZapaZZ1nsI0DJxDQkJeF0dpT/SNz2r6z0qibbfPDuA2/5G8wCt68BfS44INolHDKFmRvoIpq1zM/9dQVcfPYOGsUmGm18wcpvRvHu0qX/4EZqWRsFu24xbRiPsBzES5HjYgO5qvfg5+45FHFlT39tcdpXU/Ro4GAoAjGLxQ457BXbRKqQ325/CEBO5knM4BJ+NR+fpdH0gnwegCNEkzoDg2MybAtdvniRGZii/k7g0kovAI8CUPzWK/KLggSvY82aOwgefzdPhT7Ue0SpBGUabAIQCMnW3igxD9Uo7HG2nJ2YvSzVVikOn5tjhlPhZ4aLTcbm0x53CKja+NcKLDIg5dVPLBb/5QEqz5bhAJ/yJRVyqQRv7gjMsBNBLUoekB05ewpQWGxEBXc5o1ZoxhxyHWWGTvStIbKBLUnx+n5Qb0ASi6rvESmwgOcWit93VKzXxWzhx8KFurj49pGNGe0W/KrP7rheuLYszMbAIPma756NdHj6aSPJrOsPC/cjHFAa/Fk+T6MXWeHaQO1btrSe/OODx8U4T7kAMagiKB/y3WnB0o/1JyWUdZs7XvEz78ihjOld4tiJYEQi8lo4uMo5Z+RiIixZfuonIIWjMJbeIHwU0TLs3sjvuRhSqxJI/QNtzGpkEBYg9Vu4cpwWuUhhM8E+/KfFHi8s3PDTcHkVOsyQBojDi5Nq84wxfQ2KR8p0ZdYrapxL+dNMusj9Shgl4m4oTXjlZWHUoQsERG7UPxp/i4SsoQgK9+B7Od2EEsQg4PWeAjWrxnFyXvWYxLNuJ/QhtoQkxZHgeHZYUkE6NTsI2CkUrqrILhQlxUmQ5YJaqsLJdmLIwTBuSjzH+bbiTXzCAa1vqzHEPb946NkLF6M79PLERp4gqVHCdXUci4aS+p2bbQQEsv8d0s/Ev+9
 jAwVa6mW
 eB3GNU2gpmilisVTmTKSAjVYa4Tb+HxgTjZaKn2RP2bM5juwjeSTA58yvexrrV/CcVqxa4KDQa/KCdRqPXFW3ZDw4Zk7iPqfV2pa8+3fk9FJvX/tg9UddPZ+2PEfAb5tRsnc0CytW+Wtsa3oHw2x2Ugwq4WuRgpNZ3k4G2QoSfhtUqHcihbewW9rN4p9fKi5PCMziVh6ssDzeMda/IEo/6gvfICluXOa8S6myOY5oq8awCjj7DcXSnKbovIw6aguh0ArPUBr2HkNGH+YIGZH6Bw41BqfbOcQVBdtFH/4m7TjGDkncAHyDOSAjpw==
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
index 4309f8b626f5..b6378826b9a2 100644
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
@@ -550,17 +549,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
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


