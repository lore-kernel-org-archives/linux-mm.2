Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFD97C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC546B00A2; Mon,  3 Aug 2026 23:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D036B00A3; Mon,  3 Aug 2026 23:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92CF6B00A4; Mon,  3 Aug 2026 23:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A46506B00A2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 368E0808AD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:22 +0000 (UTC)
X-FDA: 85062224604.13.030BB15
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6F3148000A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=g9Kq2GAp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZCX0uRt3bq26YcZIyKc0yaDQHyGPM1xGVsxvUVCVRw=;
	b=qEnjnly6aj8iaJ7+dMxYGICyz64bHjCQwkDXwogwTyEMfKuMznt1fKwb5SzNrR43e3/f3h
	mq9i/eKSaaR0NmSsC1Zz7yin/jSDDxve4xs8HgXEIS2FYSglOO8qHlSvuERAwZJpE8FNMh
	P1fn9XwGsdybbfDfO7tQoFas5ihhdP4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=g9Kq2GAp;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815780;
	b=D1x+/u7t2XXudb/dFBUFb6jD3ZbEk/SYjghIJtrHorXjn9xriGYyIKsQ5IybqzWuw9UtJ5
	OQAsy7OTHPW7ucACm6kPMh+hP5KxPKm/S34FFSllwJ7XiAAEUkD3qZIw+LOuDohk6v9Fc8
	+DFghu++BNRyq4W8sa0SaS/Yo8wyoto=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cf452def93so4643375ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815779; x=1786420579; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uZCX0uRt3bq26YcZIyKc0yaDQHyGPM1xGVsxvUVCVRw=;
        b=g9Kq2GApwcKpME44tfMkYrqaMnsJ1e0ftSn2zldH2s1L8GMbkh03bDcui7OnR03+qV
         E5oLjUjHqQMK+uaHyiq9PeI8lyQdfivDp8hxjLTCCxjNJR7loI9EqsgxEhcKxvqEEcey
         vE6ij1CTGw8MmCgBzWoATo/gAgHygYaEMNHwulPlHXvcS9sowYCnE61SREDJPFyAU/VS
         W7F0de0x9tQizlKlk/sYfMi0DRUSP38W5y1s+a0pJKoPf4JcfqFZNICOQbTgH2ywXiVM
         VftNuDw2fyf0WS0+BZ9z1N4FQdazsz5Q+7jV2Ej4LYkEpDIj9HgCUycS564N/EDCRUSU
         CztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815779; x=1786420579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uZCX0uRt3bq26YcZIyKc0yaDQHyGPM1xGVsxvUVCVRw=;
        b=qvN+54w14++BtjoRSfl0CTPriVZL9oIRBkbOrJD1MMW6JToZdAbXu7vMOT3YRCxxL1
         mGpM7xlisP5VZCFkqWmFnxdD5TyEXXpSFrXlmN3fBWKD9dIJruQICWuAmrNjmANrqwj3
         K67gVfw+OZB9jGp380/50YgkdV+iwDXey97T59bwU8O1Dny+e55sU4dp5X7c5/zl6lGh
         xgJ1CGwG3pwLR0n+gmn3K7KX8mTKFGRX4R73ahC4sRkvRZ74nub66MCa/fl3aRPtPr1d
         u8xSKr0Kpfn/7jwOeYMfP2Nqgu9sMgAJgzeLzHMY65MrSVLakOCBwgnEoKgivwcTIn+4
         5KAg==
X-Forwarded-Encrypted: i=1; AHgh+RoqKCCRwAOc4Zomi70EXtz1VO1dXeh8dr2a4yTzNp2QUXv4/wEDoIPXbcib4O6gz0CXPfJ6kKpLwQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9yTlLFWzScTYETs/lzGeU1ANtO8Of88byFPPQY5cof61pgrBr
	2Yqhj/KFv0EYHQjVfMrbQMK9/Z76gcRuPs32fbi5n/YIkoX3hPbGSqswcsz0C9WQWgA=
X-Gm-Gg: AR+sD13KORZXOhtguqRNNNJQwaheEWA2lbRJ2EKsR2Bgh1iuuRK5PRBUeDv5ezE7pCT
	uMdi7V6wgUDmeOGaVnun9sHOrfI49a0sOXbT9WzyeDVN90Id04+jPmfaYe2c+PB8xJ8sqVwuX7Z
	bewgxc4bjw6tHhkjuq8jZdVOD7Nhbi6uUfQMF7JMgdMDeAaTdxocl1/oOemLGnhj6zm9cON3jHH
	Cb6OYLeRnV/J0hpEstUhwWqf8X9wFcIRCJHZeIxBrot8tq+1cYF5CO8Q9DLlpsYNkC53AKcOudC
	KrneBUclWcqaK27LAZyNQ2adqvdLycM/f91qIm3Ec/4xqHSur2tasBGDf1cExTwxt1MIQGydhOM
	g1wQwud+7OWCJy4Oct/ry26Z7lE6o7RkCg8KoC+BPCdlidRxmVFNVJjPX1o79eTfPV926YJjJ/T
	7VUr9JgAzBAbX1n30g2Sx/oRnccsDCUF/pjjrD5wyEkQoncTgiNbdpY+2YpUysLuaKN5i7q1iSB
	ddaI9rP
X-Received: by 2002:a17:903:98f:b0:2cf:461a:3863 with SMTP id d9443c01a7336-2d08ab8bec3mr18723735ad.22.1785815779325;
        Mon, 03 Aug 2026 20:56:19 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:18 -0700 (PDT)
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
Subject: [PATCH v3 08/17] mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Tue,  4 Aug 2026 11:55:26 +0800
Message-ID: <20260804035535.2846016-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6F3148000A
X-Stat-Signature: z6rxkn8kk46pimrzhwwdqpqno4bnffe4
X-Rspam-User: 
X-HE-Tag: 1785815780-981256
X-HE-Meta: U2FsdGVkX1+8CFxw93Im5HqATLdw2WBX4AglaQHkAPTM1D7P3X6CbmWB85PZGyZIMAigDjNOi8b6MaFuxLHcLyBAxnlQkvnEbeER661L30fxt/n/CgwfdWRCXtZ/JPGc0OQjFKHcO+azlT5izW2RWZDXm0EFU0JmFmVTDHxir0+Ly59rcomoerrbV/GnekWU26LqUqPyAmLIwWfsPPKsZ9N+9d2Q6bY5hZWqoomf6+HmNASp2wYp2qOqDqFCnrb5cV/r1OZcEkvY7O6ZnlR3/p00ILg15Re3EheCmCD0tsBh0VUXh7zxaGTg5gmRZO96urZ7HEBxMrzw/+R8z42Ncq3ThQI54Zxj+JagaDIgpR3QxbaiArgFfZgMuSlvweckrh3uS4ljG17ws9Gg4c0OuxBXAlZk+5pUoATbxOAhhtfgSgr+5bArNHBgPM/o0V2o7LzD3849hgtp2XGrVuLARE3FetrDxi/sxXfIG7tnIw0nXup/LbACvTiYMJNA5o3fN9+5+LVH/Ni1l6JJAYIyQwCJiuixr6eFO8ArQj+m07EHZJ7pRfdCIZQv1ub6R08RAoaOYXiD2XPVAj6Xwh46cdwdQ1duk9zag0BraMwL7R07wbB8nlrWbqMZ6ELkWz9zGI1DXIi4LJOgvpcsipESzCQUHCF95HHT/2gE0MPibS656yFuP2yQ4Su46sKwh1xtInTwAmqGn8YPYh9V16r3JNOxpHlkN8suZftdB77gIUwxCIadyg9mm/XXT9r33K7YmpP/FcLpHZEmfYMl1hnu6VaDPHueuyu7oEyGzvLiMsSIrRmH+9cHYxg9cTU+RWLXD3pbatZBOSkQB84nXNwLaRi0Vu8YFIaNQwPXMRfJVga8teeSY18St8NDPiVW0AJAD8UiPVurSLMiZDOrmvtGxdzfNhOeQVbzFM7amH5EPOG7Mps9eG9qJgyLgA3uTVLMMg/m9dhVpjtFPA9ZQjD
 y2+XVqAe
 Ve1rDrItg/9dul6HxIOWlluSA2Bhi84gC+VBoDkyawojxIv8qZfvVPf4x59y5pQ8rOQIDsf0wkXToIwmcCzYpM6ZwKHg6ZXkuyoH9d7Keg28peLRxpb/rZDZr4yc7f1/7FUhXJ/divjg23HynkSeFiqLz+YCCHxjq0TfSZG24d8rf7Xxa/bnAb1dR66is8V8RFvYXq9aU6X8nQlWRPweQ0EahpZV4TeK3RO8tZXOu/WTz8wc+e/qUFYPi7oDxpUH4RZ79uoTHOmdmHHtv5JR6yA8WTEhPSn2yI3UG5/9Ff90W6nGQbM1nK0JvRYxBkoVTU3j/uHlVTuLQ/Kd06PhyWjhKh5I6m2FwBQYtRyGWefkqaX6C9K1QGOBV7LxvvhQyOOyA7D/zziFVQNQ=
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
index b770fe2428fd..b69a7af76858 100644
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
+			unsigned int order = pfn_to_section_order(pfn);
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
index 6ad190ec48cf..f8f852f9f8a2 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -105,8 +105,15 @@ static inline void sparse_init(void) {}
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


