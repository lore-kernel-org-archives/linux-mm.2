Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D627CCA5FCD
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A616B00A0; Wed, 30 Sep 2026 10:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41BE6B00A1; Wed, 30 Sep 2026 10:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C31566B00A2; Wed, 30 Sep 2026 10:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D41F6B00A0
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A2101C32D1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:11 +0000 (UTC)
X-FDA: 85270607982.05.81DA550
Received: from mail-pj2-f38.google.com (mail-pj2-f38.google.com [74.125.227.166])
	by imf01.hostedemail.com (Postfix) with ESMTP id E579D40006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q5PzuS0L;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u02WzeDH0Bf7WSzC/uPCm2Q+d5VUN+9hTC8v7YtK7B0=;
	b=JGDb+0lmhH0Bgt2yfXl5vgmRNF6HgrFFoM+/PnSVCGGNYko+XQ+Q7arFHKmepNwSUAlqBZ
	RZbsxzKPxKZh7xlNiPzS0dZdH2hTxqI0XumttCzIHJIhGHk1XL/p/cvGyOSBdp3FrubHgg
	/UJFxzfMYVhvRpvgVQL1Fjrc2EG72L4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777289;
	b=a4GimwRb/PepV7O8VluzztHLCbZM+/mn1kFFZYMnwbVzak4Q8OqKd8HMxrv9lx9DGX8/KR
	W+C6Dg5jsj9H6CNWeDUtWVwB8dtEQBwieFeviOGKQndObgmPsuH76rwPOtT24m9ZEiAjiH
	BVLEu3T0GjdlxR5vx+iYndQaOHdKdSs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q5PzuS0L;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.166 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj2-f38.google.com with SMTP id 98e67ed59e1d1-3a4bd597d68so593616a91.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777288; x=1791382088; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u02WzeDH0Bf7WSzC/uPCm2Q+d5VUN+9hTC8v7YtK7B0=;
        b=Q5PzuS0LqyuwLXmL4mey3vvEjx0YM+pc8N+PBMabHMQZTNpg8MQVrelQFxTa/XBRm6
         ElD9+/ZjZXJepwza4MfExYbscaFnXyGc5k17s+7E1f+z8mNGaSDc4KoOX+ki7/gE6B37
         +7m81F+JjVhRaXgfAL3g6DOQ5+0IT2DULMSye8ihFv3dbPfuJTeikpkZEDlrcxVxMJYt
         1pAKURfe7PMFxpeTvG3Bh3hPlJluWW3FQB1wHo6xbYQjq6MrPLtuYNvat/AQGGb6MRV9
         4R6fIVAVy7MAPlA4cpGr176umOb5Ek2aD9KfTgqH55csQ0bm704LtTKl4ehZGw6Px+vp
         UrKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777288; x=1791382088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=u02WzeDH0Bf7WSzC/uPCm2Q+d5VUN+9hTC8v7YtK7B0=;
        b=r3aygeeFmz/98q6AjY5QO53rTz1pFr6hjqSeQnP6N1nM6G4DlwSZ5XqwM1TuGo+BTk
         u1PTOcpu3GMsytiKyIVhJj0yK524MI58qYtc/qPSt4Vj4+vLRC17kdD95JGIz1x/BsRo
         vplydBbKwMtjCq5ke7Wtt1mQuK9y6VOW/hXM6geikQ2bIJBaTskNrYzK7by675WIAOBH
         m1kgeyOQema5SLrtpJldUNA0R4vL4+tE0ZFxQvFaCjEQyGs9obdOlaECDAY0JM37vY9h
         6Mj4JqXbHYr466GBnbgFGLrAWmqt92VgGAe9tg1TQZl5Dvwrj0GMgmxXcmhhBbB97Mts
         p02Q==
X-Gm-Message-State: AFq9FYJ2EdqnBOHn+enG/L3qSViGnqS2hB1/gXUaUnulBJQ+2qiEDp9c
	KRJKasoygTKlEiPrr8IrPl2coy7gL9OwE9Z8MVHJuCO1CalCpgYM2HljLr9CdAQYyhU=
X-Gm-Gg: AYBFou3StunuCAenaYRkpBZVHNCE72j1czKYw3jIatn6HK5FyoaKhbD8K1XlMWAMjbV
	ubr+tgQPmmjwoFqFQohWSTxGKco3NOfW/bzEzVdMj4ecVZJ+Lx7uTx/X9aC2zhy+eKtleKvwxOu
	M7L1YYALZRAEFEIsFX14e69/ohkLfsCpE3lHOFZuUs99PeF9Knk0Re9DDjKtL3mKBuFDiVTNj1L
	hjHeq/NhkNdkaCfZUG7QqMbUvYw9SJM/YTr8Sz76pOKKNDu9IS9V384o/QkJxTCRyZJv1uBH2Q1
	GSxUzKZlmn/kB+B8KcKBWBBsN6cgEAMkvENfA8QpfQb/xazDZ/NkhxqpdVzXNaim7LGFN+rRu4c
	LoJRW4RvLRDXikmhfJgyNlOGtGV1oPqvBYEwiJYy1aeUDoCml+VQ6azJWrjUldhCbFBkI1jNulp
	KILv4ky1GACUwRWr3Iaa67f7g8uLEEdynH/RKUCBDqU80Rci3ozXSmKvBmZB3RISzUmgjki7orQ
	fS4SKvm5auo7Q==
X-Received: by 2002:a17:90b:35cc:b0:3a4:9656:413 with SMTP id 98e67ed59e1d1-3a4d1795eefmr1315479a91.41.1790777287518;
        Wed, 30 Sep 2026 07:08:07 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.07.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:06 -0700 (PDT)
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
Subject: [PATCH v6 06/12] mm/sparse-vmemmap: set compound page order for device DAX
Date: Wed, 30 Sep 2026 22:06:21 +0800
Message-ID: <20260930140627.57431-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: i9wxdis9qdgotesiote9pk3xzhbeggr3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E579D40006
X-HE-Tag: 1790777288-967705
X-HE-Meta: U2FsdGVkX1+3PZ9CLlA7Sw6IosemATqLVX0Czq3kyjO2BMQHz4z6PWIpBZG0dzjf/8pKwljpbQI4gvRoHSyVbo5RwpZzXi7mLSnhAKG53M85MDcDeq6IWlU691hfe8e4dT2WEececH+hXKbO6QbTP68Tk/N4tgYTw8k8XvN8fmZowiYyHQ927xVECz04XnnMT757NsqtCfwno6KkCoOtQx6Ya2lz8CL2daLqKladh3HodCdaVBuh7+up0w06syVO4BSe0SlRHcCzQ7vWHGknBB+vpDXLgO++do4hcU3BPKwIRDRARtHVzlHuy6d2SfZqmBOYwPgwjBB8FtWM1sD9OoC6kFy8OxKASlzm1fdo4yF553aLcY4f4wIWB6qKSo3n2YcQo8sdmVcJd4HBgv+y7fF6yVHEcdHkIkEZWKDRFr2CSzZ3Di57ZUN5kWH4X9RadkoDz7dAEnw6X4uVd7rgGyEuT2iNBI+Wt0DPQDHSQwRw+dMt10gH/jdJtaQ/j46Vv4xr9zF2ci6ubGxRs/JokMYkARbndxod95ZwiIp+6VnQaWcAX4SwFxCkLQFAxZlF5j9pNd5urbjr/w5Anxglg0M9r2tDoQq7zmVRU/d6d57X3I2wwBnVz1vvEMCbkqcfKT9eu63w7Qi2cX89gsQ8oURuDlaBbhqfbTY69eYedcPXenVbbSifNSk+QLa1uFhXGXarNqOKLA2lU44Ek8va7A83FnjankXORepZGDV0qhbF3+7e153P/CK+7tk3CNiQ/N2wlJFaU8IMlr2Rd134O7RrtkPiywEArfQ2RkpbpS41HaScXc+pgswUyYWcspzgHikCtpqvbWkJWhDPlYBo4hb/IroXMok3drs/rulTnJnuKbU+mycfHMf7Xb1N+SgM86vqvX6hRXRnLlV6sOtWV0PvWBFv99MFZrLvAzaN2C/7oo7hckYLrHWfvXzs3Xwrcto0Hp7M0FYqiFF2Mof
 a/OheUpj
 MTREw1pqbvcm2pyVlBbwpPd/VZVhjUDbGlmHNCwLHxLAxckDpgJ7TBykFWWjrwlDZXdQov5gxbAT6om3GzhGGv1IuqqmilHLUJErtEEKhJmvvkGaukoiSNIke85vT7LxxAfQrxZC8/e2lb9+2EXx3o38hygtdkw5zE+oQvBTJRoacHyznaVJ+miazxccLyIKiyt+D07E8re7ex/Ncj6JGkcNGe8zYB2+jeV8i7cD3+6tyVbrquENNL3QpRizJj3o6sT0jre8UeERFy7Zm9OuMUi58Tnf3W6n8nv9O4OBwo0GJMKqFOvvusf9hqY+aHjJCMVUAyyZcA1Cvalvqkm3p63jkrhzmYuPZ00DBJOq2r0WomduIao6NgcWmA8J7fgZKM9sSqYXTVkBTNmcyFYkDn0xRhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX can use vmemmap optimization only when a full section is
populated with a compound-page geometry. Record that geometry as the
compound page order in section metadata before populating the section, so
later vmemmap accounting and population decisions can use the section state
directly.

Clear the compound page order when the section becomes empty again. Also
reject partial additions to a section that already has optimized vmemmap
mappings. compound_nr_pages() determines how many struct pages to
initialize with a section as the smallest granularity. A section therefore
cannot safely mix optimized and ordinary vmemmap layouts.

Partial additions continue to use ordinary vmemmap population, so they do
not save vmemmap memory. Such additions are uncommon, and the lost saving
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand

v3:
- Update the subject and commit message to use compound page order
  terminology
- Use EOPNOTSUPP instead of ENOTSUPP

v2:
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Collect Acked-by from Qi Zheng
---
 mm/mm_init.c        | 15 +++++----------
 mm/sparse-vmemmap.c | 16 ++++++++++++----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 97e0158d2aca..efffa8609b85 100644
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
index b4b72f233bf6..26be355aaa37 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,14 +135,14 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_compound_order(ms);
+	const int order = section_compound_order(ms);
 	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
@@ -612,7 +612,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -831,8 +831,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_compound_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -842,8 +844,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -869,6 +876,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_compound_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
-- 
2.54.0


