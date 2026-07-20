Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 470ADC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FAFA6B00A4; Mon, 20 Jul 2026 05:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2AB6B00A5; Mon, 20 Jul 2026 05:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40CAD6B00A6; Mon, 20 Jul 2026 05:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 144C96B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5E76A1031
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:29 +0000 (UTC)
X-FDA: 85008639618.19.88B04F4
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 580A61C000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=U+lo7feo;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539947;
	b=XKO4PPMAv5zytNLNmugTH8vvtdsucKRt2rbakCNur/2Cn8IFllyjXt+zqeFHw/qkz93iGu
	uSwsJXh33LKMo8PKotwXOp5MKFmJafMT3YRdNca+2CNo0BjvGdgiCTcIt2XHtK8yZYSWuS
	wyyU16i7JSjy+XdZUE7NhYz/QzMuj0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=U+lo7feo;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIl1erdJ2bKlvmuHeltJ/d9wztXmxG8GJiFqIKkszIE=;
	b=MlTuguWR2amx1qspApNh5e1LBNyomHcB5EFwc/d5aY+em/o00g1aWlQ5L5ZZBzG8sSJ5qJ
	9BU1+pfFXonW7F+TElZQeDGwCzgB1FLhVsMHnZPPdJHxi1IenMzkbypgwPOl92NSewRUkM
	f6ApldZ1FzSvpvqWF2GCIfmt3+shtIs=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2caced6038eso48404445ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539946; x=1785144746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XIl1erdJ2bKlvmuHeltJ/d9wztXmxG8GJiFqIKkszIE=;
        b=U+lo7feooB2On2M2k231IRLQSzMbC6nyW3UoFP5kPMn93TIq9vP4EzodqdXfZPbYrU
         3O4VPry+mHbYw2Uixsy9/XFLgDbBg+lx31W/r9V0GTmW8wgWMo3PGwXYjOfC+nu8JS5D
         N9uy7gDOp3Iv1osheU4fi/lx4Lmzg2Otgtnuu5zlIRAYLDw9qBnEeyc/g1hxyD8W9tl1
         Q/ctnaf4KO6NptrSrly0q54nWt9mFclgHoGu/AfeqkwCGWcey+YEBbQQdN1DId1IDkvY
         ExsWqCqvd769p8+h6JdN2l6F6ysYPtYV1ghvcda55yUIgtRx6sgbJhbtSqacQBK4sNF7
         jSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539946; x=1785144746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XIl1erdJ2bKlvmuHeltJ/d9wztXmxG8GJiFqIKkszIE=;
        b=b9FExUMvUKt2luvbIXpDRCg5tPCYZhPMe9L2HD5NeroA6j8GL6zllKutEnVXVNZR9o
         IB9RhXl+2kZAjfe/0e/Ys/jEhMQZ8dMrp+stVPu5OWmEJy0BA9BK2zS47K3guolIn7zv
         qC3UwFM9a2iVbALmtvt/NAh+vnYS49p3nnOPZ4aDMZcleVs2IcmZn8+x2V/ZiAxHxxJR
         dSGjaqU2hOlZvsK4nkW1/WzY45Zfp5bskaXk4MKi4VhgpQ2ZUw+00M3pZ6rR09ftseYE
         WTDK661hLnWmcnCVyzYYr3Ypnw6tAJxR8gtgPem18FDqjrsZom7WkTexw62pjl2ReT4Q
         oKog==
X-Forwarded-Encrypted: i=1; AHgh+RoTeMMSTl6DPR1uhVMd5sNTpeXz0AWiRgj4QlArDcJt2mWLDMet0z/RcYe5NoGs8QbfpooT6dB2/w==@kvack.org
X-Gm-Message-State: AOJu0YxinyJTjyZdO8pixaNfuVbDjDv4FHm8ArwlF2LRSr+69Z+A4RlH
	P9WyLqYoZwqvXdF3gZwXZHbRXoaJqhkfAxWrHV69BQiaBdf0LUURKDKX3b2XqvUVi4E=
X-Gm-Gg: AfdE7cmHeeU5ayO29xEpu2KHFbz39ITsz27zuy2dnayoHOUySPYtV7YFhZ2OxXlpJpv
	+GhFw5Ph4QzTPF4PteSN8QUzZqye4A4VNDH8NIQSbiZ1IpRNBGeAb9Cfks/deZF3zj19AB552Fh
	X30BCbEoUfvLzUOqukgIjKKfoDwSUhYCCalJ3wNYZ8lfl7omnHc3p5CbOjMSW+/5pC2lz0Mu96O
	OVXFII85lILGUWQwo6FENp6N7NAWIcho9q8lJhcKzeb+SC5pgGakUIKJ4QB3Aqtc84EBn9T+7oA
	6g22InRkDIjGu9hVDi07rwEbp6yY1tr7fa4l8ComBWLC/1CdM5BrdEsAJRqDlwhp8kVG1SmFSHg
	HpRPozWuqrB3jcnuXeVMHf3jrO156sWMiSUBjW32vmxpj70lDmCUAP8jaICXDq7V4Ps4Nn+ldZA
	EC8pf+h7eZpcDOJi37l7W5ff0=
X-Received: by 2002:a17:903:198c:b0:2c9:c517:d08b with SMTP id d9443c01a7336-2cf34a50497mr134993955ad.22.1784539946139;
        Mon, 20 Jul 2026 02:32:26 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:24 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 08/17] mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Mon, 20 Jul 2026 17:31:18 +0800
Message-ID: <20260720093127.540540-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 580A61C000B
X-Stat-Signature: m5bm7upcjub6t7buhcra6fcm1bph5cq7
X-HE-Tag: 1784539947-922482
X-HE-Meta: U2FsdGVkX18vT/ZAzWAHEoHheVWXoCoHH8Fbj9Nu5xuc8J6DLt+7GTXyNPDQXCHbirTL0JklF9rnM12QKmKwrG29NNqu2JEik3JCd95K4JdfU0hxO/FO18/HOwaANKQwSxIe9dmsywsbzOPMcu4FkzsQy22TzH52/ne+KDcS/rjVKEgKRcRihKvG3Md7hmgStmRneuC4wTKiSAztxpBBUItUWRDFvWpEBvlIuFW1aJx8wNVRDCFQP7wHi3aO6qT9O7g8VlIngmr/Lv//mseDjKzPE9UKTxJYTLpaejpgBAH0dLp/xJLq3Y4lmWXH1Pwwrqqg38BNDdjBnoxPKmBXmtX2cjsYiuiuNyMORUNKA4iDocN+s3f3rkSBhOhBKITXlxiIuvPUvr1b96spl1J9BxWyaRchj4LPVpDea174YTg2dGK4f5OXO+QzvxE0YdoXcVD6YuVLL5AIeo87jMnNoT6F+aHd7fLVeQTFD9DrduQjVOtF1J7crGU90QH3l8pTh/GS5TsJDOt/jNFucSYdcBzo5FnE+vfQC7qEcsoDVfJOkGQq3GmZeCGun3/cK1rgk62jeSyVVe9WR8TYGpTyAVyRWrKFE/yx7I3/O7xvVWrpgHV0DNTrz7OEjdrfJg0odK2LB8wpircFne7G+rdhAsIiGEur5uzsDppXyLF3s616bHbcTAuUJeuT8rQF55PdFc2Ij2iUppgNzV74CfJ0LHk61nIWfRyuDjC0M61T9n7xppgIilunXOx1D3WdktamZvOTRZTOx89HDo7R1rJk3sU/9FI72T4R3VZsn6X1mgcMciwdt3GjxkKDlRnTraoeIIOL1BsLK+TzlH3LIzd1kBPwOG4a+zzfv4533swMAcwkhf5R4E0EZfoCvyeTV3IqZSawNnZtOm5b7E3nXHpaV6/cnXvpVGJO2AqD82ODLGY0BcIQ7uds+Iruk89By3YFSWjwmTn78pvMUYST4WG
 E18PjgZ6
 gEJjVTs/ozVyQLHAyCKgvvsBXVY8cGvrJ6wvRWHK6Uwc+X1XV84Pb3waM+yq/EYoI+9DK/N4UpeXa+LnRyTkF2genq+bBC9tmIs1NEGh99vl2ijDt2JkoZpsWEsNdW+5DUMS/y0eLS8JyXWy0YSy/pfvIVLaj3ndt/DToDvDy1iyldX6XfLlWAtnDR8U2YyDgCRFyIpGm9+FK8rbW97YGJp1k2MM8X5MgYxS8Yy/ezd4RHjC+J3LAuxweZXk9Hcgwm29bceL2PJgGtaOReT7wMl6rc4Ut7PXqSKvAZpt4TC9tXdx3b7XrL60ADTQaJBVrxe0tgKls8O8fc6wm1WemFpYLDhp1MgnqQSOHgqHGOcnVZ58WGk4QzwnH2LfMpadRWWd7uDhAJFzTUh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach sparse-vmemmap population code to use the compound page order
when deciding whether a vmemmap page can be optimized.

With this information, the common sparse-vmemmap population path can
allocate or reuse shared tail vmemmap pages directly instead of relying
on HugeTLB-specific handling.

This centralizes vmemmap optimization logic in the sparse-vmemmap code,
based on section metadata, and prepares for sharing the same mechanism
across different users of vmemmap optimization, including HugeTLB and
DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Keep vmemmap accounting and population logic in sparse-vmemmap.c
  (suggested by Mike Rapoport)
- Move vmemmap_get_tail() before its first use instead of adding only a
  forward declaration in the previous patch (suggested by Mike Rapoport)
- Simplify the PMD path handling for HVO-covered sections
---
 mm/sparse-vmemmap.c | 36 ++++++++++++++++++++++++++++++------
 mm/sparse.c         |  4 ++--
 mm/sparse.h         |  7 +++++++
 3 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b770fe2428fd..e818b4109777 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -186,6 +186,11 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 
 	return tail;
 }
+#else
+static inline struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	return NULL;
+}
 #endif
 
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
@@ -193,12 +198,24 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 				       unsigned long ptpfn, unsigned long flags)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+	unsigned long pfn = page_to_pfn((struct page *)addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
+
+		if (pfn_vmemmap_optimizable(pfn) && ptpfn == (unsigned long)-1) {
+			unsigned int order = section_order(__pfn_to_section(pfn));
+			struct zone *zone = pfn_to_zone(pfn, node);
+			struct page *page = vmemmap_get_tail(order, zone);
+
+			if (!page)
+				return NULL;
+			ptpfn = page_to_pfn(page);
+		}
 
 		if (ptpfn == (unsigned long)-1) {
-			p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+			void *p = vmemmap_alloc_block_buf(PAGE_SIZE, node, altmap);
+
 			if (!p)
 				return NULL;
 			ptpfn = PHYS_PFN(__pa(p));
@@ -217,7 +234,8 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 		}
 		entry = pfn_pte(ptpfn, PAGE_KERNEL);
 		set_pte_at(&init_mm, addr, pte, entry);
-	}
+	} else if (WARN_ON_ONCE(pfn_vmemmap_optimizable(pfn)))
+		return NULL;
 	return pte;
 }
 
@@ -406,6 +424,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 	pmd_t *pmd;
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -421,7 +442,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -439,8 +460,11 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			if (WARN_ON_ONCE(section_vmemmap_optimizable(ms)))
+				return -ENOTSUPP;
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
@@ -648,7 +672,7 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
diff --git a/mm/sparse.c b/mm/sparse.c
index ca9875f568d3..24555a32a5d9 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -315,8 +315,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 							nid, NULL, NULL);
 			if (!map)
 				panic("Failed to allocate memmap for section %lu\n", pnum);
-			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-							   PAGE_SIZE));
+			memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
+								       NULL, NULL));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
diff --git a/mm/sparse.h b/mm/sparse.h
index 1e9fcea10181..4377b097dc8d 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -87,8 +87,15 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
  */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(void);
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init_subsection_map(void) {}
+static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 #endif /* __MM_SPARSE_H */
-- 
2.54.0


