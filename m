Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86E83C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750006B00AA; Wed, 19 Aug 2026 05:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6675A6B00AB; Wed, 19 Aug 2026 05:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0CB6B00AC; Wed, 19 Aug 2026 05:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6616B00AA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:53:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD092A2E72
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:32 +0000 (UTC)
X-FDA: 85117556664.22.146D931
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC277C0003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:53:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e1cw6dYZ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133210;
	b=zhFfnxznPfj1yy2JjvrKT4cPABuSXvfvkIku7SSpYDDoBhnGlyIx5hoQAKuKpOzfq9LDcX
	X5Hzcr/unWJ3lLmuMnFeahPvoyyTjZcwtVdEjUOuAR2hfsq6lKgJBqX9NNPhndbneDTW7E
	zurhWLuuPiioL8R/93JBf9LzBPP1Ays=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=e1cw6dYZ;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=671AwO9cxknmM2yc6/2dzWMjTOAP7N0nlaeCKAVGNAc=;
	b=hZVaTzHfTNmjlIIkM/J8cPgayr1Cq2KTkVhm8LK6U3lea9StchcIMd41/yPoxrX/nvCkZz
	E7YBZhT5v3nI5quP7K3KMyIRmbnSYGdfzmZzkxOOkglwBSE8/o0WvVk9cNSNefbpuACs+E
	0IokpVpGycVFWV6VgfUGX1sHa3vrHrU=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d5335cf904so6449745ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133210; x=1787738010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=671AwO9cxknmM2yc6/2dzWMjTOAP7N0nlaeCKAVGNAc=;
        b=e1cw6dYZFZziPhx7bxG/lvipo8WPS20iGmpfqwqRc+1kgzBx1twQNenEm3+UU2I0/w
         ensoJ32LNbIqWjDcob6P8pWnBfdAW5QMI3FScfRp0T07czlyvY7B+A5X7bJeRs+oydbO
         oI8/6MzFTS2yP6V5zGuE7VtO1NHP5u+YFjAr3B4vv4mkHkTqFssX5JuepgA56o1nN02k
         D+K6PprdV9FobJluenWy/BQCO31/BAAAzX/p5aHFeFHUDLE1IL84c6BviosI5ueFr5iH
         cLKYUixc6gUQCxc0H326c/JJbL28vdiBIpUKbOcYPNkVuAAXk+7/MiCsb0FN+3BYAaKY
         66FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133210; x=1787738010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=671AwO9cxknmM2yc6/2dzWMjTOAP7N0nlaeCKAVGNAc=;
        b=NX4TVgMJXWWwGDClsjRH62aSRYH9yQO988ppHqudPqvbrW9Hn46RXeDGCzK/VjsGG8
         +ld4XUvQ6J+oGdAOJq5E2CS7h1aWhN5Da2RJtMUovrTsBn2UnPgkpwFVoPJaM/tWvYfz
         l5cJjXpl98be5DzO/wyRwcTNS7KYPp2E3pzqC00os1juXJIJd0PA74LqNQexEGyrju9j
         YAqHdJMNpuEOwDSBX5vsiO83hamjJlrzx3O+2Lrbs9fJaIQe92dMjkRzHlt9HEfWgqPd
         c1QlBMo95O00nnjA7jcy6HOVgvB/xe8mJvVncQmSPnXWHDgcAGwkxK5Sorytu4swjOcw
         UoXg==
X-Forwarded-Encrypted: i=1; AHgh+RopL/FLCTmyoem6fQOhlKyyiO0+soacAMJPg4VkilD6HOSTVuC6S3SWE/Q5lGiSCE0Zf6u4GSC/EA==@kvack.org
X-Gm-Message-State: AFuF++kiPXaGvymSibBNxjxKRzpkzlc34svB8HjOBU0tvmx3U4BKI9Gl
	dV19/lPtz2XAX5tGW0wdARwR0x/TmzUe0FrtZYumLSs3e88Xi7lUXnMxKQRwuopopIA=
X-Gm-Gg: AR+sD10vj/u+m8/ol84zEpkyvgiT+Q1qyXdIqzYLaU5MYgqEWCHCG8X6wZcxCLs3QCU
	8G9XSKBd+Y9mvlYi/ddlgfrDzvYAavlz8rwAffhfyEhG1+oaE+m+ifnw1zyb2ggkFO8JloZtvHC
	uMt+DYfIsc6AVXbSV1xeNuW6IZlU9RrSvohUEngrwUPb72FIaXcby+qFxTRJOs/FdM4Qk4vpaj3
	PVxfnOfWaqFXOUw0cmF7qtQKvJs9F8o6P/qc3QSMt63pp+gBPfA1n+sLfPu4xBZzzWUCmMpONQ9
	2Idm9wVLgdLmOmGN6oyJNDHIMAQubkT9JxXdoCylRkJxn/V+I6355sFtdfMon3Ie5hBeVor1CH1
	S/jWdO5vu/UFGEPJ6lJKrChWmTKbFsl1rv96FZ4qO5wOoSRVMseu5LSq/qAr3cvEvr2uxOX6fdr
	g7/hjlk0J/lETNCyOoYRZpJKcdhNrJySLqjTFS7wCPu9edrhu4CZPfBhmfESciImX2FxxzuPFSP
	YYEmWpmHgn3HgF0PpUIUyopQQ==
X-Received: by 2002:a17:902:cf08:b0:2d0:cc92:f7a3 with SMTP id d9443c01a7336-2d5fd5ec972mr66156725ad.2.1787133209699;
        Wed, 19 Aug 2026 02:53:29 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:53:28 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 08/17] mm/sparse-vmemmap: support section-based vmemmap optimization
Date: Wed, 19 Aug 2026 17:51:30 +0800
Message-ID: <20260819095140.17252-9-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC277C0003
X-Stat-Signature: 5dqhdjuqt78958s53ja69tucytqoxutt
X-HE-Tag: 1787133210-668034
X-HE-Meta: U2FsdGVkX18V9rW6t/zj3fuzKzW0ZqO2zWRChYc/lqsGVA3VQjYAWeJxc5ENVfIVJYbD5vfTT2cYAxBzckDWjqPNbt+1/jPooBEvRbbjCetoUqqaSesmLUaMmKSaVt9yj4yCrtAFjOZoURo39pgQXypJbUjjzQFQDkP7TPmeSPieMQq0E5T8nxkQQQiNGSgYvOBXue1as38DMLBt0wMtTVL8OkhnAw3x+Gp9fOP+c5foQqxTGGvCl7S9475IhVQfv83IW283ZZESqtojP9oapYHrjuUlWu7IxdmcTWNiGMEX9+JpVFOGQC6OXEFN+sE0DnbS3mrOtGBM9sRfaECIu0d98Q08ptrmRRrITDALvQoUo85PugX7jwkFDUezDESMl+PRVHGzySzlLZ5+KV82CDJJbzb1FbiIJwsZj3T2npBzIDx/yMxbJY04EzLTQA6SoQae0EkUMMh11ODDMLBct60xg276BKmGuLwRT35gNJzK4JAQqfEmxrjH6aDLesBEcTXzGcY/7lZP/Heu2VhWBSbe3mGsQIXbTd9hCnSsSnrSX1mOc7SH6zbi57qn+IDVeEqQQiIhHSe8hr2Iy7Tuk+yRJyRAlqYxHNSsK/zO3TBU9G2fAQc0od+F/GvDpcHVipv7GmkR8nKA0+db/QBimLjj6SQLjh45rqTPKNgmzPTAltXFl7O8lth6EmC5RekqRHUQU1tRIwcOip8Sfk7dQQbVxl/os6Go3ODPNshNZMTCPVzlGaYGlS5GzjW44gQvdP0XtHC14T6azHgmrFwtwiK8tNUzgH6ZAO5MUvoNoNduZnLUoVNUfmCD2Vr/pbi4zj1aSBE0rGOUFxJVtoAiAgGWqkiUj2DL1JPM8xda+wVP7ucN46+K3gDHGgiTsul42JmkHJoHQvwpfO9QhZaPP632FE6tLslykKDU/9zcKw64HQ/gjHr1qgj2Gwcj2IJv0ur9i/qpQBpNvHmUuiu
 Gufy3hSe
 Dpi0a4qdBGYn1fH0jX56PPpDfKzn6TjYg2/MpJgrcJn8f2MePpMx+SL8mFUpbd1/MQmFbC3icIjVErjEjmSXDqPz60nSPIu6+SMZan2HtR2jfUwM2uiDdbR8RuWb4mlhnysO6pgIlMrudiqKh/NJ9UTbUQkgR6YPmhgJPPuIw9jbKPQ/Zi2cKI62w6aKQd8j+1+U4Xr6yUoCiPNUpWIf0nzct8byiZsm4YEfdVAqpFJTYDh+8jgmfpId/Y8dBImjaEVQ3EbSpbno724EsWaug6wRlPL3ZW/vGHZPG/SCjWJAsludYFDkNIx2eUpwVsqaBEB2QlCYzn5JCOUF7sU9SOzYVjeIx+qwlYpBsMJPHqd2uroWm6iXrKEBwpFKd67m85+vkjOP/TX3S+WY=
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
v4:
- Move section_nr_vmemmap_pages() outside CONFIG_MEMORY_HOTPLUG to
  fix CONFIG_MEMORY_HOTPLUG=n builds (reported by kernel test robot)

v2:
- Keep vmemmap accounting and population logic in sparse-vmemmap.c
  (suggested by Mike Rapoport)
- Move vmemmap_get_tail() before its first use instead of adding only a
  forward declaration in the previous patch (suggested by Mike Rapoport)
- Simplify the PMD path handling for HVO-covered sections
---
 mm/sparse-vmemmap.c | 88 ++++++++++++++++++++++++++++-----------------
 mm/sparse.c         |  4 +--
 mm/sparse.h         |  7 ++++
 3 files changed, 65 insertions(+), 34 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b770fe2428fd..737d50bdd3ef 100644
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
+		if (vmemmap_optimizable_pfn(pfn) && ptpfn == (unsigned long)-1) {
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
+	} else if (WARN_ON_ONCE(vmemmap_optimizable_pfn(pfn)))
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
+				return -EOPNOTSUPP;
 			continue;
+		}
 		if (vmemmap_populate_basepages(addr, next, node, altmap))
 			return -ENOMEM;
 	}
@@ -620,6 +644,33 @@ void __init sparse_init_subsection_map(void)
 		sparse_init_subsection_map_range(start, end - start);
 }
 
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+{
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
+	const unsigned long pages_per_compound = 1UL << order;
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
+	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
+
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return vmemmap_pages * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return vmemmap_pages;
+
+	return 0;
+}
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 /* Mark all memory sections within the pfn range as online */
@@ -648,33 +699,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
-{
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
-	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
-	const unsigned long pages_per_compound = 1UL << order;
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
-	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
-
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
-		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
-
-	return 0;
-}
-
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
diff --git a/mm/sparse.c b/mm/sparse.c
index c84b4c7b8c70..e6cb67ca9c8d 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -305,8 +305,8 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
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
index 02ed0f34eac8..1569774270fb 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -111,8 +111,15 @@ static inline void sparse_init(void) {}
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


