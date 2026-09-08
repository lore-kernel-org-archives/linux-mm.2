Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FB7C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA0236B00B8; Mon,  7 Sep 2026 23:04:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77C46B00B9; Mon,  7 Sep 2026 23:04:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3FF26B00BA; Mon,  7 Sep 2026 23:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6A56B00B8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 158E81A0350
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:26 +0000 (UTC)
X-FDA: 85189101732.14.C1E4CD6
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23E3D40008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TBaIN85s;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nco6X6VSmg3b4sCsw2GCdeq7qTzf+r3pWDgUiD6K2qM=;
	b=xeJw8eTgxCPixw9mw+/neEoyouKjGq13nRVe7R/MedxzzbNo4mRMfZIvtYC/QRoHI9yXAG
	xrcHTzD+DAqLX//WhFjFOCRWF3QA0OeAN1FDjwNq3ur+hanXx9y166ZBZaDEYEFCD42gJW
	EhKNYVk6sEnGEcDq6Zpm+3y/RC+usPs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TBaIN85s;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836663;
	b=MoJJDhhjdzgVienx3pLn8XVr1jo0M8+lGblrHWHMASj6vmc7/pa5ButwU7X+/6cUChg/SM
	ms3SuX+aVcpg13ns3FwRSBnHfEJMSJ4iY+S8uAVCeCyMPZFRwo066buKAJNhXnmDCxLo78
	lclgWfgIlC6focd6KxWNvuqDF71NcD8=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8556ec44e9aso3442606b3a.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836662; x=1789441462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nco6X6VSmg3b4sCsw2GCdeq7qTzf+r3pWDgUiD6K2qM=;
        b=TBaIN85sbfuDf2FPDmXMk5tYpJ/1kPDwEcJob+/A4tWJYJREcNXemrNS1zW5tH4pHk
         v8AYdOoXxePYtwgOofwj88zd9AQSoyklJ7kTa5ocIjek76mTpS0HlT5x/NkNR5PeCRA9
         l/rO9MK8e3MOKnswgadxBAAB3OB2FS0ILgIIU+9++hNL2aP7ETHDk8W1VnqeMF3M0Uk/
         ZE2pY05iRuWwBfMh95xKkv+ECciyI1Ot2ZGe+MVV8C+inUTvGwWOgG+lKl/jmGLXO1r4
         i6fcH6iTu2zwNVw8kpBepRq9mrWZtB32XuzMFikz40o7A8q7/M3jdiS0ZkqlGIVS8yoE
         iddA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836662; x=1789441462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Nco6X6VSmg3b4sCsw2GCdeq7qTzf+r3pWDgUiD6K2qM=;
        b=Gvu6thezSE66Hab9R9l0C+zZkwVT24SLaa4POT6P6xEgdckfOWCeXUx9gTMak8y4bz
         GUkgLRddglsd+foLASVEZIaipiKvbvEF7QK4ydS0KwoKZ3XuGbAqmom4Vas4QvnMcng4
         Fy84t+9cq1nYqbPKjijeVUuWFyODynlVzJDq7AShJQxVYamaYWUsQ0lEDpr4ZqZVTG46
         pBnlMY89GMI4CWtOYnjwFEcXDNxkxo2sP/vtffD7YzM4bd3SkEQ/R1B432AsITIBXyak
         u7/XkIZtAbav7zB/cgaSOCOl6bAJIuNWD7v9Onv+2gMw2b7bhLs75sE8XnnTgty2wjzQ
         LkzQ==
X-Gm-Message-State: AFuF++kLJfsh3Hej/CK1Z2zvmUgTKrKZBPSzjxsfUdqDKS1G5hgzvJVQ
	GN9RLmJ1UMOOJxB8L+V36DNrfe6nZ31KhFRUaK79TXUUMf1Iu1AOr+r7hgDtb1ef67Q=
X-Gm-Gg: AYBFou3F3XeZgsFQA4fSsDu0Y9Ijbziupn98SC0d2upVFSYZ8bGeXsK8eoUlm6OO47w
	d/36KlBUQHlcWhoMh5awDXSa+Q16VcUC+RllKNXGvAaSG7u4Nza58RDExvRv1YCiGLs8oPZ1Jhm
	ojlVwUeKXU/m1QU0dojt+Tdss5uaOFKbFdbD/xliFrSiRda1LBOInFqSRUn+ePxBeD9uJ3nzkB9
	n1SgqDChzSInQrEXwXfM8ssqy0K1bcD4jMHYtYpFc1JigoNfUEjXN1mFmsWBFs7cESWRNJVq/Xb
	1TCQzwSZbUb94Z3ixNJjAs0r0QpQOpqqcZfUzl8fLQMy0kXvhcmiGY21tOZ8glzc0GFWVstb8yB
	w2M/5OEwU3sOK03dqzWmD5V1VsbDEO221F0v2a5qVNBu4+t1MLjUtBcDEO3E18hDgz1yjlPZOME
	uMUf/7XFFhdbG6GH565O/qu34lJ9MQ5nxJ+e565ipfnu3vJjxgA+SBLR9CJeQy6sVYscng0+6tP
	0WvkUk6/I0aGHYNPvS0wwkuGg==
X-Received: by 2002:a05:6a00:4ac6:b0:847:7ffd:ce35 with SMTP id d2e1a72fcca58-86168992df1mr41275963b3a.8.1788836661718;
        Mon, 07 Sep 2026 20:04:21 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.04.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:04:21 -0700 (PDT)
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
Subject: [PATCH v2 05/11] mm/sparse-vmemmap: set section order for device DAX
Date: Tue,  8 Sep 2026 11:03:29 +0800
Message-ID: <20260908030335.96549-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260908030335.96549-1-songmuchun@bytedance.com>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: acktggaus8xo51dk1ruyzzcrco7daxr9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23E3D40008
X-Rspam-User: 
X-HE-Tag: 1788836662-355191
X-HE-Meta: U2FsdGVkX1/iXemNTxd5dQxWJSDaQ4bsM5vWIwMy4JI87ylj8U8C2yHZs7EZlrXi0IQoezXyULKaDq5W8HUdGdI48kNmxnsxT9W44ShGzQxYApNCM6AlDvhtrvf+pkrqRNEYFTJNm1UvsE0QnlqdhLQ0ndeduNvjz1oWEPC56kO8IuQxgWOu3Vj8BXf74LzRe6Mh+TVBx5Q7ccWXLMJSs6FyLtLu0xkrrygBxSkNcsSuWbNVxoG0yf0yZ3FYCs08sxS7hL6N2G0lYScP5lqnxSGPtfzBA551JpdZz+hH0pPN1CUedYxn+VMmRVj3FKzmS64bOKcHgVGkCk1/d79YeqHkDB1MGhBtnpnumnDNlVsmaMJsG3UeNdGJBit5yYdhcD+EDlHlJNomHG5MeoOK55i/mX1RP+Sihy0uJHEem4o3ohAXYKiPVO/qCHNOjwsf9wNvGdnx3WuOa+e2dFXs2s5S7nWsV4f5dkGkJh+0s/qLzfYuZ9KonsIvvBalJrFNHFCX6FdBmjasD3WLsJOD3V0iy0xLcLTLH4WcJJeGfiJbXuIJlOpAvhc4ueC1Wl/oJkN18/7NLnWyeHRltWlODhcgeDozYMJI8G2OSTGtFLXRJhd8MNQO26L9tvM5PVmFklciHfa76O8RUm7YxCSqncX8zL89i1oQyQChWnc7mp59av/JWZkuNqip2sX+AymCKZHdXDC1mfKBkf3QFTW1VMJjlFxAVcbYKWwC1Q+yJPitEkzlA1tr/WhmymJfAOkMDxctG+kcTUX0Iq2FWrExzBueyE84GEDVLlMAHeyiQ8rJCZmr80Ubnhl2C3Pcg0Jhs2PRsR+lVy8vssJHjmOkRE4pKF+8AqqgtQ9NlMY6AF8NFeApWYEGqI++Py5rNuCINewsJ3AY1piGo1Qp4DGHfwW/arfNe4PG+MIeMJG/zXHB8RPavo9eZW627aAMjbJ2RjjIg1aDh6mYLAGnUWs
 jeeOnium
 idFKOHmgF9IiZYi2FeFWOkEFX7ctDUceT87k4UTrAi63iPLjSuO+jbrJCLQhtZWD8Yar93CPN3ueKa+nOaXqxIdAg3za+NwnczQo0zwblx05dftTS6QGDVeL1ZGJuyJ35WUWUvmrl90fPRszS9vfKK1rfcGRba7arcMGcno5TLRNm0fcNv4uvMTijQ7oacZ44k26xwe9awXSTXYXikFDworp7VJPw6tpsox8BOWwvqcatQLVbdAWQNueQbJF2T8OzC0bqhY9l7MRTSnGI6NtBVewncLK6ocZvG1PYgMzXtJqMtIfkn7y0W4+VFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX can use vmemmap optimization only when a full section is
populated with a compound-page geometry. Record that geometry in the
section order before populating the section, so later vmemmap accounting
and population decisions can use the section state directly.

Clear the section order when the section becomes empty again. Also reject
partial additions to a section that already has optimized vmemmap mappings.
compound_nr_pages() determines how many struct pages to initialize with a
section as the smallest granularity. A section therefore cannot safely mix
optimized and ordinary vmemmap layouts.

Partial additions continue to use ordinary vmemmap population, so they do
not save vmemmap memory. Such additions are uncommon, and the lost saving
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/mm_init.c        | 15 +++++----------
 mm/sparse-vmemmap.c | 16 ++++++++++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 9e8ffd01b4f7..7a2e58d631c2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1049,16 +1049,11 @@ static void zone_device_page_init_from_template(struct page *page,
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	/*
-	 * If DAX memory is hot-plugged into an unoccupied subsection
-	 * of an early section, the unoptimized boot memmap is reused.
-	 * See section_activate().
-	 */
-	if (early_section(__pfn_to_section(pfn)) ||
-	    !vmemmap_can_optimize(altmap, pgmap))
+	const struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1144,7 +1139,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	memcpy(&template, page, sizeof(*page));
 	if (pfns_per_compound != 1)
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	pfn += pfns_per_compound;
 
 	/* Initialize the remaining head pages from template. */
@@ -1160,7 +1155,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 54ae8c284324..aed1e7429daa 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,14 +135,14 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int order = section_order(ms);
 	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
@@ -573,7 +573,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -792,8 +792,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -803,8 +805,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	if (nr_pages < PAGES_PER_SECTION && section_order(ms))
+		return ERR_PTR(-ENOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -830,6 +837,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
-- 
2.54.0


