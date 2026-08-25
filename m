Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09659C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178026B00A4; Tue, 25 Aug 2026 04:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128C66B00A5; Tue, 25 Aug 2026 04:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B396B00A6; Tue, 25 Aug 2026 04:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF96A6B00A4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F3D7A31DE
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:32 +0000 (UTC)
X-FDA: 85139168184.16.ADCF96A
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FE6C160003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AyoxL9pp;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SRpH2SWiMFBBCX+kPTKuY0N/Kvw39O9UHNj6BUBL9rc=;
	b=NRhjiUvSkPjUmTLP2/wQ/olwWMlUub1ztLSNRxSL1IQ2M8eMttpeCQOaFEmQzYdHR8TZc5
	1Xg/fHuUDRG1mC9yDQ9TrbP4ak6ZGIoZLFlb46ozZGWTuZlS/Ufs8L/IkmY7VdZXu0m0WZ
	xrHKU5QNoGaKIGujNnfR7C9Ms6UvGME=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=AyoxL9pp;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647770;
	b=rooOh+YVVebDjrw7f7p9//00FUK4+ln1OgjIQGCyQKaLld3zr9w1C8jsLHZFrYs2C0Efhz
	eJizP1DLpaP/7/VQIUQHO49g7NtUk0pxgQ3Cug6eydDSXOyvyZqCZBHO8CObP0FCa/6Bjw
	lpXRFau0yGRVaBl1A2NAeyqntlPoezc=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c9aea40d799so2732181a12.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647769; x=1788252569; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SRpH2SWiMFBBCX+kPTKuY0N/Kvw39O9UHNj6BUBL9rc=;
        b=AyoxL9pp9EdeqtqAjmXs6Bh33mq86j0+C9BzH8Opp8walbhPLmi3jyfVZbUEGbjgvK
         npOXygP/65iioGdd8qbMt7woMLFvVVBmxfPmZOa30JpftmkjN7VgHgt+KIZR44VgAgYl
         XOajr/d+zs+kB5GUOQ44My/efPYvQBMLditWoMudDaAiVZQgHPKLVjpcszMgR/48nFk/
         WB4B3lRWep6wWygx+FOpLYmSMX+Oz2W5Cp3WUpviJt2jjO+eoFbbj0ShsHR3dO7oaHsR
         NnnvJ6U32clp6LnYL7pv5rN7Ia56t9XxOvl+sfFsJW8GsJeu4YhXnTz13RDZnXHzF8AB
         O3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647769; x=1788252569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SRpH2SWiMFBBCX+kPTKuY0N/Kvw39O9UHNj6BUBL9rc=;
        b=RT8bn/SQDuqd26JhOy4uq6DZxscJ9zRa1ZobSMac5bVX9WD1epYbOmqTvtziAnNMNj
         feWa+u6Ltbq8IcNKD0ExbasOkTx4yoj6gTkASGgLkq1+1TTBs+6T7Vc8H5pmqt+HEoDx
         yvi8xwPEQ3HlJ7ybJk1HfWlufLY78w61JMtL5PCGm8f107nYwjnGKl8qUI3QvfPH8dj/
         MrusZfx1LebYrool2lE/let6HRYXd47CBtTjQ4r6QnkmKM5Jm9rGvNwoi6Aa1kda7BdD
         JeaI1FBctZsJcE47OODnDrBoV1n8SKOxIwdiB+dob2pBBnfXBaSHiQS1DOK3woHk53bE
         Pk2g==
X-Forwarded-Encrypted: i=1; AHgh+Rr9Mpmfk3uNpgyEzXHLpVNTPnjP+ie4/L/yfjjsK8Fqt4/9TTYJdc04+8dQLSyC3ZxPAAZxpXzhmw==@kvack.org
X-Gm-Message-State: AFuF++mgW9A1Fw0DuUTabp+6a+2R7lYFq/ua8q90x5F2qSSBEcLxU/kl
	nDi5k461mSwGOuvd6qe/Rxn7m/Fl/q41iDn1f7KvHizmb6WLQRXxl2Vxdc+X2WOhGAo=
X-Gm-Gg: AR+sD12e2CneAGdBZWqpvrsp2Aha0Sn4vNoRG4moCNMAevZxQauyt0a5iJLEKcFVr/T
	Z4miFZKveaEraeLbCIX6Wr+RbKIi+WaURXVEyUhuZ/poMSiT/GzvjJWGdllbl2DLBO3ZsrAYTFa
	wcGiTmfOD/xEyq5Yc/rPp/qJgeE2ZY1F8XKVtj+YhlISsU4wcS7MuszePoQZ/AwCqcyn5DlGGj6
	wXHqwQ/17WMb++Gun20dIHWWuCep1jAyPh8tjCK+vI7FKsO7NqAV10z4060MJ4FltkRz0f5a0Mw
	+IB63W7UTumdGX/sFGbgmJC0DSfh5BLBTzt/DARKXJFgp510IPWEHADUlfic4hllRZlavgaaR+Z
	fJXBOqa+2MGwCa8+aHjzg+oUJ10ExVyi+t86H85XGLTRIHK2jhi+mHpcrzsrJ+O9Qj7/QIUZmvG
	csUrR43/qSW73RM0zt9xpB7BWeASG7JQ+ujSbNW7pHNyXalAp/qXQ+GkGAlPlGk4f4YkRNNBGda
	/hNK54N288P4DXgLZzqdArF+g==
X-Received: by 2002:a17:90b:53c7:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-396464a15f2mr10522868a91.11.1787647768873;
        Tue, 25 Aug 2026 01:49:28 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:28 -0700 (PDT)
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
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 07/17] mm/sparse-vmemmap: move helpers ahead of future callers
Date: Tue, 25 Aug 2026 16:45:58 +0800
Message-ID: <20260825084608.47437-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7FE6C160003
X-Stat-Signature: ca1yt761wjr9iui7nwcow8r7j4a9pocy
X-Rspam-User: 
X-HE-Tag: 1787647770-951883
X-HE-Meta: U2FsdGVkX19TYeCrGRo7/emRgF8xEG4bcI3D/9Z2RWAo24Dz7b81u9DU9KBfyo5jGpI9ZnyGqXU9pAzblLIxvN4Gn0z1cqDpBO/RTKfaGHlRGRFeQOQpbZSlXWDoRCS5fLRQq4R0EPD5Xk3HaLOSJbm91SdJFkXD3ux8fqedUePtuP8RvDOdmswfk348xLd+kNhgv+hRfU93K9bbUiojoih5xBqrKY2me70NPAjzkTO+Ryy5ScqwDQRiMJugTa5Rp/7crNWYJt7Qy3O4fD5Yo1YdX0CMRetvd/P4M58V/2hiA06T6iNXcXmvhw0Bfkh9Kai9GgDdBKIa0DemNnkHfys5f7t4I0sCCxxv2eFY3vpeDU+1pRQ0vQfXgMPafytkfEDbSqCQRlNuThinWXzR9NgYRg4KuPq9C3GA1ox5/M9BgyjclrlEtuHEh/ftSPmHffz9EUkinuojx4MXkyNx8q+DnIXlJfoS0j5b5otPMp1JL4Cbs8bwinWkCT+yZDPfzBpAZbvu5jAg6jmMFchMRmnC6qzul+qd62t5MVKvtIi12O3pGqyj0V7kXwKhT1/KbkWD1+pDMgzRlbOHFjeTDnim+CHWTBfRmmoPYTnkIk+Mu3+JXhYzhf4OlhfIowh2zLqkjo+k+y3dC6U0uLyt4poMVzludzauwaTp6xQbMcZdbFKbdttUSZrToCMURptNhxe9gncnUr4D6dPK6G792zW0UzTCXj1wW/+brJn+mcd7J1xVvXW40JkZ5Euda7bCtja8lfv13945l1FGtCv1Rj+B8lVDRGoUx+1FAL3uk0gX/lXsSPPpdrn0ORJs4O+AqM5Ur+AtoFGDnqF0SsoAbmnPPyfVzsY8wSYxJtJ6QV7SFSrrQkHlRWZgNQ8D9z+5z6rpvZMQiGgkrh27yFXimdPDGudITMRDkf2ub6xCNqROD4XMqg8BB6U2Q87RPNlyE/HPps/E1ipJC+7fBY9
 Hk2CVVUa
 BLn9EXk1yvGAMBPMl9qbdGFK+WHtnpVgwaJpFc1ikWpXORBN6flq9Wh+XioYL4S2EZTbFefFgVWadfyM87tHYRkqNz9TI546VNspAYmim0i6bQpCrVrght7MGftF1LA9Tpg3j01i8BtDjX5IY+lK9201vFCdABKaxFcc6cXwv4T/uwi0fxbFMJAKQlpYtLnRgIXWslqFobBuJzVa001NJOFOvvO2CVpc2kG6LxSzFSrSi7uQLkWVDWH+IQKTYJS7+1GSx3cMT2eQcw28KC2EuMb84FRYC6U5KoTU3OaKBKvYwJ5sxADxkiMOE5X61rPsK61eOu7lGeXJ2lreHYcmTOZNkHec/iyuxufIhsnmIrwxmpmxMwe86uwFT95ZS//vfsE3+wAjy3lfVIiTC+NZwEzthquOx5AFMzWRA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for section-based vmemmap optimization by moving helpers that
follow-up changes will use. vmemmap_get_tail() will be called from the PTE
population path. section_nr_vmemmap_pages() will be made visible outside
the memory hotplug code and called from sparse_init_nid().

Move vmemmap_alloc_block_zero() together with vmemmap_get_tail(), since
the tail helper depends on it. Move section_nr_vmemmap_pages() earlier
into its own CONFIG_MEMORY_HOTPLUG block. That lets the later patch change
its visibility and callers without also moving the function body.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v5:
- Move section_nr_vmemmap_pages() earlier under its own CONFIG_MEMORY_HOTPLUG
  block to avoid code movement in the later visibility change
- Reword the subject and commit message for the helper movement
- Collect Acked-by from Mike Rapoport

v2:
- Add this new patch to move vmemmap_get_tail() before PTE
  population (suggested by Mike Rapoport)
---
 mm/sparse-vmemmap.c | 134 +++++++++++++++++++++++---------------------
 1 file changed, 69 insertions(+), 65 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b7abc5494bb9..ea3cacec0a79 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -148,6 +148,75 @@ void __meminit vmemmap_verify(pte_t *pte, int node,
 			start, end - 1);
 }
 
+#ifdef CONFIG_MEMORY_HOTPLUG
+static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
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
+#endif
+
+static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
+{
+	void *p = vmemmap_alloc_block(size, node);
+
+	if (!p)
+		return NULL;
+	memset(p, 0, size);
+
+	return p;
+}
+
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+#endif
+
 static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, int node,
 				       struct vmem_altmap *altmap,
 				       unsigned long ptpfn, unsigned long flags)
@@ -181,17 +250,6 @@ static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long addr, in
 	return pte;
 }
 
-static void * __meminit vmemmap_alloc_block_zero(unsigned long size, int node)
-{
-	void *p = vmemmap_alloc_block(size, node);
-
-	if (!p)
-		return NULL;
-	memset(p, 0, size);
-
-	return p;
-}
-
 static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long addr, int node)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
@@ -323,33 +381,6 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 }
 
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
-static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
-{
-	struct page *p, *tail;
-	unsigned int idx;
-	int node = zone_to_nid(zone);
-
-	if (WARN_ON_ONCE(order < VMEMMAP_OPTIMIZATION_MIN_ORDER))
-		return NULL;
-	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
-		return NULL;
-
-	idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;
-	tail = zone->vmemmap_tails[idx];
-	if (tail)
-		return tail;
-	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-	if (!p)
-		return NULL;
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail(p + i, NULL, order, zone);
-
-	tail = virt_to_page(p);
-	zone->vmemmap_tails[idx] = tail;
-
-	return tail;
-}
-
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       unsigned int order, struct zone *zone,
 				       unsigned long headsize)
@@ -646,33 +677,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
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
-- 
2.54.0


