Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDDD2EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E83F6B00C2; Sun,  5 Apr 2026 08:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF9E6B00C4; Sun,  5 Apr 2026 08:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5F86B00C5; Sun,  5 Apr 2026 08:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2CB6B00C2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:56:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 014125BF48
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:09 +0000 (UTC)
X-FDA: 84624500100.09.34F1380
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1979440007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=frWfCryI;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuildpo+hHfNl+izDYgZmo65TSC8uYjcfc21fVKbu/w=;
	b=4OFoEqYY3jmiU0WVUPJRqJU1GFXVeF/k5AKZIA4lkrHfLifZ6JEMSkFoZjA6tSiNOyEfs1
	WUDyjdAfqXCTePdNC7ue7pXhG4vJHon9UIzJic8AM8zCkIxeIA9mg+3qJtViEn/5SIfqWy
	X9m1yjEcVjps0tIiBtfUWmZQOfmn1wA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=frWfCryI;
	spf=pass (imf12.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393768; a=rsa-sha256;
	cv=none;
	b=1uUkOhlNG6mxWiG5u/9V26ZfHvubo23TYTnEjo2yf9swp/PCA4qvhd++d26fw/lhdj04Kt
	8sG0VYlhREIkNjGJodrenotE+02iojcp9qmrO8a64PXFUBXPCPxOlGZDvvr6Ch14JAdfAg
	P/oZasS02705W2MYvchkCYU5SPEU1Go=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-35d8e548a05so3517107a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393767; x=1775998567; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yuildpo+hHfNl+izDYgZmo65TSC8uYjcfc21fVKbu/w=;
        b=frWfCryIfoGCx2qdNPVsHtAbCqYWTxFqzcWVytdPk5thugInM0OhYV7LNYgfVs2yNS
         baR82rqgVeL1qUWpvLxGeR9b9rHEF0X0e51bnwWOsrkXYSacWrAJyRXxJZEVDzJsTa2x
         Z6AK7IYQ0KkX7ZDsXPqtr4QejWhGAbP2TBooet4JhpMEBjvp9OQZl0f0pwBHyy+Gsr9n
         r1jku6r6+BGaqtJ/Eq5g4AngqKgStM9iGSF/BRqq9evrnUyvAOJFB7hx7P1xU+Xn+N6c
         BOZa+FnTRc/QEiRsNy2tohuCfK6s/9rFJAnZE0qa73nDLn82Y3VaV3gDVcfu0t7xeHCT
         u6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393767; x=1775998567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yuildpo+hHfNl+izDYgZmo65TSC8uYjcfc21fVKbu/w=;
        b=flj2H2qDjfkBV3wgUKR+CiIuwRrsBQy4btWtg6kKITCgqLqwdrKNZYgIdLs1FOuSVB
         UUVJHdrtrx43aNpdvF+8iR0agtvUvtMa1NjHtdLpgihyyisdhTu/JPulptRgjWtuEHZ3
         /56s2+k2NdiERNhuP2Omia4HwQIUAm7NJAcvey5I+d1FcC0y1MAwcPbVmZM9n1kULnZe
         Vvdf5t603uJNB4SnC6DaI7Lt0Tn52/VEftI0Iw5Ps5VC6z7K1cSdA7PiQ3+b+6pvl4Jp
         0ZPUJvMCxfKxg8srARoYkg1uQmIa2TgiiGfmQFGinWO3qQI47NlIT34FLd02jFX72u7a
         L6vg==
X-Forwarded-Encrypted: i=1; AJvYcCW0uE/awMOf7ySyyaLY6n8A2KAnQXk54zo1Utypnzvzf4jnA3WON5v+7X1LY88Q85YvDmAQAT1R6Q==@kvack.org
X-Gm-Message-State: AOJu0YzCUULohYPzE8Zqim5yJ6fZBm6QHwfONgp6JMQtCOmUgXfs2RLU
	EbF8lxR0VVL+ZdtgyTji+rVdrjQlS7AkkbxXczmVg9/Jv+vsaKo2pi35TXcvXyKDGOM=
X-Gm-Gg: AeBDiesMr0veh+SoeToC61ApQqtpAMwvbSlXrAGPYtMp7WI0h+lMA6kVAK4UpLGseMY
	+m1DtXPhLDiXN8QhZVWE8cMmvf1XVxTPe32fOuZKfQTm8bskgmUoU+LWrUALXWxerm603V/F3JE
	AfDIkxVkQV4PZDT+/90HvH4rjVOCcCt+lYkd1ZEixhYUA8hURK+KvTjvd0PIY+ks/KKuVGNfQ9W
	24jYoUMcm/BRnFnZhawm3EBAXjFBT7tlpYGR5j9rhENho5CO/7mWG49rH1O4NkpMCzPYQlomOyz
	8R1sRwWexzHJ1zemRT0NA14XNQZdgMTWwxUV6a9ElwlOO8mrqPuMYfwGa7fE0SVHGhADu+Av+AI
	LN1WW7v7XS876GBimcY91XrEYsdA17WxxBOz5rSe9u7DU28Fd0EN7daHuOz2PedppBHFqYJJH1C
	cauN30Kt1bEAZeSwNgA/IAoU2QOB2pm5forwGIYP9y1T9EmNulBCDp7A==
X-Received: by 2002:a17:90b:4ac7:b0:35b:9720:98d0 with SMTP id 98e67ed59e1d1-35de679086dmr9103094a91.5.1775393766817;
        Sun, 05 Apr 2026 05:56:06 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 25/49] mm/sparse-vmemmap: support vmemmap-optimizable compound page population
Date: Sun,  5 Apr 2026 20:52:16 +0800
Message-Id: <20260405125240.2558577-26-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wz1mheoy83mfhaxpwocfuhb6auff158e
X-Rspamd-Queue-Id: 1979440007
X-Rspamd-Server: rspam09
X-HE-Tag: 1775393767-637226
X-HE-Meta: U2FsdGVkX18av5AjKcR25Z1T4iMf4vFjv6ElFH5awqUDKGepe/eI035FnhJsCcT/tRGlJ555+k5PZk3YW6v+tpghdB+FRvayLC24UaIJ/qLVdcO51D3Q52ohs4whcRUDwnDtwBWNM2/O7ZrdLZukHOvaj83ZrG157+T/9zLgubC0G8SXMQDYVEsxddgjaANVNdwCBmtqXHaZLc9dZLGF8G8IJyXwEzItF1CrqnJTo/BMO+fojdbV4tX1hri6H9CL3YKPketf3re1vwyIuRsLTC5iKRh3movnZ8bCcKlt9iL9BtcxRrCenImJqT3/isUycGPsZfFvWu1OH471yTGfJmtzAnZmfwzx4nxzJN7nWWdkHog89y4LjHu4gFEScfT/T37PtF3LyqluAAWYO8dcRzjhlYAawU90uf+yLD+JjORiRgE0L6YZa8qq3jaHk8ZgmS8j5Gr/yeU18yEgCYBnL0CGJG/QrcQh0cwEP0H70pjju8qIBIMHl2IfyZDV52gZKbwACKI/N/pGkpdhwvcOVwPh1Z0H9vMNkRTJzBzs2Z3KccAppoLpnbclw5gqBnPlPVGNy39pZANvJZFNK0NrwhV+aS0IIbt9wW/XcbGgcjr7uFfCWq+mekvZYCRkOH25yc+q3iUIu/bQBhG354oDFsfFMtaItnbV+PHMojuP7k5MazSRKnsHjHjb+pwDWT6QYzWl2IRlXv66qp6DE+bzND33Dxs9vj1oGc9lcCnk1Tm9UBXJzhwp/A6C/xEHHrJYR0eAeGnFVL69l+4k71LZZUOvCDPALm5Qd4dC7Na3tuVmrJUwRehAbcXgzfBVeldHNo1qLxxf/FqK7j7+a8nD9Aayv1kHlknbicpZylpwe+fg9asuxIsMOQNR/iFJLK4qFitEe6+x8ewy8QFHJDXp0BZ0H5MwLTgMeY9SzerFVy2eNCVlGIuqG+0WWiQFhDJt61HqYvUwdzte0rgBUIu
 qUjT/pB2
 fPcJFMzAhhespWN3YQ7cAj97vjrAs2zyHEoTAAo6G3CoWOBJ+jlDqkbILZPN+DJSEMnaZFf1K/mIdzCHBY+8jJTL6VWEwiwKyT2x+cmDdYxs6OWn6EDO0LPm2mp8VJEEFwH7obrXqpwcVQUNRTOcDB2Kf3rJgpaKvgiO6FYLiSREptEBLvA6KmbKBa3f7kSEJEDwKEuG3axKbBpkVf6DWVEpJQH5fLWOSuQBLpMQt2oo59rfipzzuSbl54jLgwPKpGi0F3WXdAGgctRitxYzFThFmu2OGXalgf1/vK6v+SYDNOEFAnY7lNNkoWAQSnh50b/A/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, vmemmap optimization (HVO) was tightly coupled with HugeTLB
and relied on CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP. With the recent
introduction of compound page order to struct mem_section, we can now
generalize this optimization to be based on sections rather than being
HugeTLB-specific.

This patch refactors the vmemmap population logic to utilize the new
section-level order information by updating vmemmap_pte_populate() to
dynamically allocates or reuses the shared tail page if a section
contains optimizable compound pages.

These changes centralize the HVO logic within the core sparse-vmemmap
code, reducing code duplication and paving the way for unifying the vmemmap
optimization paths for both HugeTLB and DAX.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h |  8 ++++-
 mm/internal.h          |  3 ++
 mm/sparse-vmemmap.c    | 66 +++++++++++++++++++++++++-----------------
 mm/sparse.c            | 30 +++++++++++++++++--
 4 files changed, 78 insertions(+), 29 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 620503aa29ba..e4d37492ca63 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1145,7 +1145,7 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 	struct page *vmemmap_tails[NR_OPTIMIZABLE_FOLIO_SIZES];
 #endif
 } ____cacheline_internodealigned_in_smp;
@@ -2250,6 +2250,12 @@ static inline unsigned int section_order(const struct mem_section *section)
 }
 #endif
 
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	return is_power_of_2(sizeof(struct page)) &&
+	       section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
+}
+
 void sparse_init_early_section(int nid, struct page *map, unsigned long pnum,
 			       unsigned long flags);
 
diff --git a/mm/internal.h b/mm/internal.h
index 1060d7c07f5b..c0d0f546864c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -996,6 +996,9 @@ static inline void __section_mark_present(struct mem_section *ms,
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
+
+int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+			  struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 #else
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 2a6c3c82f9f5..6522c36aac20 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -144,17 +144,47 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+static struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (enum zone_type zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		struct zone *zone = &pgdat->node_zones[zone_type];
+
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone);
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 					      struct vmem_altmap *altmap,
 					      unsigned long ptpfn)
 {
 	pte_t *pte = pte_offset_kernel(pmd, addr);
+
 	if (pte_none(ptep_get(pte))) {
 		pte_t entry;
-		void *p;
+
+		if (vmemmap_page_optimizable((struct page *)addr) &&
+		    ptpfn == (unsigned long)-1) {
+			struct page *page;
+			unsigned long pfn = page_to_pfn((struct page *)addr);
+			const struct mem_section *ms = __pfn_to_section(pfn);
+
+			page = vmemmap_get_tail(section_order(ms),
+						pfn_to_zone(pfn, node));
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
@@ -323,7 +353,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
 {
 	struct page *p, *tail;
@@ -352,6 +381,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	return tail;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -404,6 +434,9 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 		return vmemmap_populate_compound_pages(start, end, node, pgmap);
 
 	for (addr = start; addr < end; addr = next) {
+		unsigned long pfn = page_to_pfn((struct page *)addr);
+		const struct mem_section *ms = __pfn_to_section(pfn);
+
 		next = pmd_addr_end(addr, end);
 
 		pgd = vmemmap_pgd_populate(addr, node);
@@ -419,7 +452,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			return -ENOMEM;
 
 		pmd = pmd_offset(pud, addr);
-		if (pmd_none(pmdp_get(pmd))) {
+		if (pmd_none(pmdp_get(pmd)) && !section_vmemmap_optimizable(ms)) {
 			void *p;
 
 			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
@@ -437,8 +470,10 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 				 */
 				return -ENOMEM;
 			}
-		} else if (vmemmap_check_pmd(pmd, node, addr, next))
+		} else if (vmemmap_check_pmd(pmd, node, addr, next)) {
+			VM_BUG_ON(section_vmemmap_optimizable(ms));
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap, pgmap))
 			return -ENOMEM;
 	}
@@ -705,27 +740,6 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 	return rc;
 }
 
-static int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-					   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
-	unsigned long pages_per_compound = 1L << order;
-
-	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
-	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
-
-	if (!vmemmap_can_optimize(altmap, pgmap))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT)
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
-
-	return 0;
-}
-
 /*
  * To deactivate a memory region, there are 3 cases to handle:
  *
diff --git a/mm/sparse.c b/mm/sparse.c
index cfe4ffd89baf..62659752980e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -345,6 +345,32 @@ static void __init sparse_usage_fini(void)
 	sparse_usagebuf = sparse_usagebuf_end = NULL;
 }
 
+int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+				    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	unsigned long pages_per_compound = 1L << order;
+	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
+
+	if (vmemmap_can_optimize(altmap, pgmap))
+		vmemmap_pages = VMEMMAP_RESERVE_NR;
+
+	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
+	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT)
+		return vmemmap_pages * nr_pages / pages_per_compound;
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
@@ -376,8 +402,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 							nid, NULL, NULL);
 			if (!map)
 				panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
-			memmap_boot_pages_add(DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
-							   PAGE_SIZE));
+			memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION,
+								    NULL, NULL));
 			sparse_init_early_section(nid, map, pnum, 0);
 		}
 	}
-- 
2.20.1


