Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7941B60A2608
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=V67WcCis
Received: by kanga.kvack.org (Postfix)
	id 991D96B066A; Thu, 12 Nov 2026 22:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942B66B066C; Thu, 12 Nov 2026 22:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859EC6B066D; Thu, 12 Nov 2026 22:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7B86B066A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51FC1A05D2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:48 +0000 (UTC)
X-FDA: 85428681576.29.B8DFFF4
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 839B140006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V67WcCis;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540946;
	b=GFIpUjAAXEMKHyCnLeauUBYG41N2ligEOcNCAAJ2tvuCW7M1Atk7CmfUXOgyyEUbppnKUt
	QWHT3tXtrRT4+gwcP+iznx1hinlKwvctEYqiH5Nr04yUqDfL3DYqNZxnA8DSNCE317ox+J
	77b7eJrsTGYjvxjJ0vjs/5KqSZAPHbo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=V67WcCis;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nn+UByieGItxN9YlkkTIdARwSLiGlm5Ng+zJOajx6E=;
	b=UUZsF7GceZPUoUY3edpVjEornbJFrni3+loiJTZYkId9aUB3/Qp/mU9y7T56nhMpUf3AFN
	vPjkAMy1UrhjrHvDZH4GhZd21oDOYcpQAoL7iKHZmT1lNT6ta2hDpW8VEuh4Zuo5sZzRPp
	QwlQKrW/Qlsaa9+cxKGFgxEUooJu0TE=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-3720addb068so814591eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540945; x=1795145745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+nn+UByieGItxN9YlkkTIdARwSLiGlm5Ng+zJOajx6E=;
        b=V67WcCislwgVhrqmRIiOhLrgB64dAaweN0gUstFAVlBMWDAFxidi/vKiDqWBw3Lfv5
         206qajZXbXXedl3kr0rb8Tfn5E33/RifS7k+B7Z55+8wWcVUXNmhclvn+3rH/ZEenA4K
         3RBOgl3utzd7C+7HhrtZ3hGf/kwl1dJ5cB/gqGuhdCjykEGAHHZRYeUhKRvfkFsncB6W
         3LwhKudqUCMwm7jnLe1OFv6bgyvrymW0+ciUT+h0+U7WaGsuCA5PQx/ep4ljzK6WdPui
         ApjWsYbwNmH+riByKXfwfwlvUPOnYmo44DMxd40JSGQHrShkYhA5T3aWbc3dSj7EcwoE
         IPlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540945; x=1795145745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+nn+UByieGItxN9YlkkTIdARwSLiGlm5Ng+zJOajx6E=;
        b=OV3NONnqVQAy401zY5cPNIDHfFg8T15kgPAaEsVU5ROj+gArmjYkerixno8voC4p4Z
         1viO+R0GLk0uqQ2i4m9xCG9294HSeyUAk+E8yAnGUvb+YM5QYDhlcKNdDYD+t54oAPIL
         PKN9Jhu2umBsI2Owmvd9DF0FSRFS64vqoNHiu/0rhXPX8thzMWuGhPFxImnqiRJhS9hV
         3fIHgm7Jpi4zN2O4WjCoBeY+lP4xhKC8mVLZm0kNe2U0DirOfMxazjCge6gApMRN/k45
         XHmjkQrRBYdUAAMplsVdimy7nN7WNrL4YB2peeRhPcd+s+nrHN0KaEaMi84AiGK7NxPv
         HIFA==
X-Forwarded-Encrypted: i=1; AL+hErHSuXK4ZgoxDeCfQcy2alGHEXEUKw5wu54q5+zTmcbR5uZBJ6ggjhmccMy8OfZTruplBs0BqhUi9A==@kvack.org
X-Gm-Message-State: APuU4Z/DSW4m2UPdIT8YRH8qav3h42DwtyvE/o0QmUYS4GqqAxCRYdPi
	AzZu+AojagFqco6kmt/cO9ZAwOUI260p3Q9ZQ4nLRPnxw9gZPwKV8fVRpMpdjLh1/As=
X-Gm-Gg: AYBFou0iQUOxmPNpro4H+DSYo0pKvheAwYcQ/oKeSwZ2ugoD8ZeZ0s8pLVYfq/USFtQ
	fFEjwPHZYBsNKi8ygPbxW8YuwvInhCSVTc7VYtEv/j6LI4Az3S0sY7dNE0zL+AXTtuKRbsQJrZQ
	9+377BdnW2nD7SHow6H/qS/+8eQ5UJTRyq4pKIXHtBrIdaStO4QVDWgQXLQRAPy3KxY4RpGXq3Q
	NNWV0pTVRsIfzVfiTlZ7fi3CWbayITzi7Yo3e37N5bfQihPpDgmbSzM3G1Y8Ua3TXR1gPaOXrmA
	XI4BHUqjVwwbOZRnWMFQMVSbZOyNGoe2e4d8jvR0p/WlGJwxNusHqg6DELNwBWZ1ySeTQSA07zh
	YXy2o4u1KIVUgyCld5pGewDU6A1vAkfWWVsm2s8RVO/h8UpP3Uq5L/n3yDFWM71g5ypH8myRZST
	hVzE0qJHME/t+gHb9Xxd0BQ06XaIR9nNlAyRdMVR8611EEeaR+ENhCVTC08dRTV0T37NeEHdzOl
	KbNkdj0B8/qPvRp7iGiLBKgJ+Qj5D56lLsupiPazFkVbjbC9j7VPleVPeJNq2QxihpzBl2FloWj
	UW057stkGgKH/LIyzs+Mzljb8NNqNxz2SlUTCbxvwFc7ZjwxSVTeA8cIlhxF+A==
X-Received: by 2002:a05:693c:4019:b0:35f:2858:aa4b with SMTP id 5a478bee46e88-379675fc9ebmr986727eec.30.1794540945090;
        Thu, 12 Nov 2026 19:35:45 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:44 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 06/14] mm/mm_init: factor out frozen compound page initialization
Date: Fri, 13 Nov 2026 11:34:34 +0800
Message-ID: <20261113033442.62970-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: on5k3uf93znb9a1h9icqhdaw4iucguzn
X-Rspamd-Queue-Id: 839B140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794540946-7054
X-HE-Meta: U2FsdGVkX180RLbUVjcuG6+ApDI4Bp5dIdisk7yID2WFkPk8FWyoe9qBfktOT+u3kKhDChKZBX30bIhGVUfNYgGQsfR2hWlYV4Fd7gwgrHxcyeSGokVjpj5pT/Q15m/7vx0Dkfew+FSif+fDwtK89lSZ1YD11AfigoPuzQc5hHQUnOAuE1jajCLC3rpNohntFIpRDgJXontVgSIY5Xype4Wb00OnPpdbTL2M1NEnnV+bNsVjFtUlCd/+Yryk6GmrAmaI1Wy/XwDDCV2ptO4hTSZ4CLaAdn1lOX3TlNSualxwpffdl9L8+GnDTEASEbu4RMJx65dviMsiXRaDghi7YN9+y4kRDxi4XUcb7mTG5D6uVDKrGg/zSdrA3HdinypakFWViz951l1bySzEhMHfiXCdP0dpV+KBbYKpn/i5sQRF3DNvNDibfuN2VBklgiYmK6xmMhYlGQIv0dpqip3dAo5xISsgah4aJz9bZBFGE9LcAs8/+R6fw7SQGAsqNFJFMrrfU0jtLPaQg6Jy8JPNsxxuvrjg/In2tAd6wM+xWvuqeNGmea3lhxCDQCefCOqvgmPOYWMZj7L0kDzuco3618aUDkbjWZqJUdho4TvxuIV4AoY2C0s+kekLdPUM5SSGphMAuLYgCbq0IsqAmEtf1CMOtiqirY1iQYVqCqCi55rpf6vWRdAV9aiEGAxcd62XjfkOS5VGwNT05unWUeKTeZWaRnkQ86lXTMX0/Eifv0Mr5KEZKiJdd5VvjfTQMjtbrytDNzkNEnwSrybT+NCLmAWH3E2ZhmlN/yXKNeVeiODDju0NaONf/GZnHhZ0itIKWLi+y4P9Zz76VupzKwIU1Ted0wt+pzcK7Z4O0J0weOisbw9XFKlqrvUdkQaEAsSx9RG7mMNMIFs+DJKsTjhNbzJokWDoRM/X+BxfnSJ5FO7PlIZSKkwkXDjeoFyP9IJTqVD50z6yocpOLXKKjQl
 2S5dDTTY
 HDWIGbuEMANflpiag2nlB1AG84J12KN8d6BXYCCe+DdiOC2ITfb1O6+otjcM2u1cdyspgtE1FrJSwxiSsqVhNQFk2a5f8F0Ck1c47gLgyzWKxHiubF+u3JBr20+/AlvxO+7eRMrP63g3I5buvuzLHhE5z2slKfbCc9OYnLGQgJ55fF9ej2HJMuktcg31Ei+PERFl05fBVQnW7GlGx54FsLsyZLCDJV/UXK8CspU+3rQAbczg4zvdHDWxg+yNElLVajQiL7k3MxDuEiOBed05ALjrRCej3fLVWvHym/nNyRwo1tEyEDURmdf5hCrEQ2EiH5W/Azpo6jG5BfUFpzyLheHPtOFttB8uy21PAoyVZuBAeqsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ZONE_DEVICE initializes compound struct pages while their refcounts remain
frozen. The setup is open-coded in memmap_init_compound(), including the
per-page initialization and compound tail preparation.

Factor the common setup into memmap_init_compound_page_frozen(). Keep the
pgmap association and MEMORY_DEVICE_GENERIC refcount handling in the
ZONE_DEVICE-specific path.

This provides an MM-internal helper for other early memmap users to
share.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Rebase on memmap_init_page_from_template().
- Rename memmap_init_zone_device_head_page to memmap_init_zone_device_head_fields.
---
 mm/mm_init.c | 114 +++++++++++++++++++++++++--------------------------
 mm/mm_init.h |   2 +
 2 files changed, 59 insertions(+), 57 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 69bbaf75f935..ea9ff690d4e0 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -739,6 +739,28 @@ void __meminit memmap_init_page_from_template(struct page *page,
 	vmemmap_optimization_verify_zone(page);
 }
 
+void __meminit memmap_init_compound_page_frozen(struct page *head,
+		unsigned long pfn, const struct zone *zone, unsigned int order)
+{
+	unsigned long nr_pages = 1UL << order;
+	struct page template;
+
+	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
+	prep_compound_tail(&template, head, order);
+
+	/* Initialize the head page. */
+	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
+	set_page_count(head, 0);
+	__SetPageHead(head);
+
+	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
+		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+	/* Initialize the tail pages from PFN-independent template page. */
+	for (unsigned long i = 1; i < nr_pages; i++)
+		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
+	prep_compound_head(head, order);
+}
+
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1064,44 +1086,39 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-/*
- * With compound page geometry and when struct pages are stored in ram most
- * tail pages are reused. Consequently, the amount of unique struct pages to
- * initialize is a lot smaller that the total amount of struct pages being
- * mapped. This is a paired / mild layering violation with explicit knowledge
- * of how the sparse_vmemmap internals handle compound pages in the lack
- * of an altmap.
- */
-static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct dev_pagemap *pgmap)
+static void memmap_init_zone_device_head_fields(struct page *head,
+		struct dev_pagemap *pgmap)
 {
-	const struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (!section_vmemmap_optimizable(ms))
-		return pgmap_vmemmap_nr(pgmap);
-
-	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
+	/*
+	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
+	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
+	 * @head may be a stack template, while init_page_count() expects a
+	 * memmap-backed page.
+	 */
+	if (pgmap->type == MEMORY_DEVICE_GENERIC)
+		atomic_set(&head->_refcount, 1);
+	/*
+	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer and
+	 * zone_device_data. It is a bug if a ZONE_DEVICE page is ever freed
+	 * or placed on a driver-private list.
+	 */
+	((struct folio *)head)->pgmap = pgmap;
+	head->zone_device_data = NULL;
 }
 
-static void __ref memmap_init_compound(struct page *head,
-				       unsigned long head_pfn,
-				       unsigned long zone_idx, int nid,
-				       struct dev_pagemap *pgmap,
-				       unsigned long nr_pages)
+static void memmap_init_zone_device_basepages(unsigned long start, unsigned long end,
+		const struct zone *zone, struct dev_pagemap *pgmap)
 {
-	unsigned long pfn, end_pfn = head_pfn + nr_pages;
-	unsigned int order = pgmap->vmemmap_shift;
 	struct page template;
 
-	memmap_init_page_common(&template, zone_idx, nid);
-	prep_compound_tail(&template, head, order);
+	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
+	memmap_init_zone_device_head_fields(&template, pgmap);
 
-	__SetPageHead(head);
-	/* Initialize the tail pages from template. */
-	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++)
-		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
-					       device_zone(nid), &template);
-	prep_compound_head(head, order);
+	for (unsigned long pfn = start; pfn < end; pfn++) {
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone, &template);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
 }
 
 void __ref memmap_init_zone_device(struct zone *zone,
@@ -1110,16 +1127,11 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				   struct dev_pagemap *pgmap)
 {
 	unsigned long pfn, end_pfn = start_pfn + nr_pages;
-	struct pglist_data *pgdat = zone->zone_pgdat;
 	struct vmem_altmap *altmap = pgmap_altmap(pgmap);
 	unsigned int pfns_per_compound = pgmap_vmemmap_nr(pgmap);
-	unsigned long zone_idx = zone_idx(zone);
 	unsigned long start = jiffies;
-	int nid = pgdat->node_id;
-	struct page template;
-	struct page *page;
 
-	if (WARN_ON_ONCE(!pgmap || zone_idx != ZONE_DEVICE))
+	if (WARN_ON_ONCE(!pgmap || !zone_is_zone_device(zone)))
 		return;
 
 	/*
@@ -1134,32 +1146,20 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
 
-	memmap_init_page_common(&template, zone_idx, nid);
-	page_folio(&template)->pgmap = pgmap;
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of one in the free
-	 * path. The remaining ZONE_DEVICE types start from zero here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	if (pgmap->type == MEMORY_DEVICE_GENERIC)
-		atomic_set(&template._refcount, 1);
+	if (pfns_per_compound == 1) {
+		memmap_init_zone_device_basepages(start_pfn, end_pfn, zone, pgmap);
+		goto out;
+	}
 
-	/* Initialize the head pages from template. */
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
-		page = pfn_to_page(pfn);
-
-		memmap_init_page_from_template(page, pfn, zone, &template);
+		struct page *head = pfn_to_page(pfn);
 
+		memmap_init_compound_page_frozen(head, pfn, zone, pgmap->vmemmap_shift);
+		memmap_init_zone_device_head_fields(head, pgmap);
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-
-		if (pfns_per_compound == 1)
-			continue;
-
-		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, pgmap));
 	}
-
+out:
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
 					 /* isolate */ false, /* atomic */ false);
 
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 9de9db31320d..721221d2e4c0 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -114,5 +114,7 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
 void __meminit memmap_init_page_from_template(struct page *page,
 		unsigned long pfn, const struct zone *zone, struct page *template);
+void __meminit memmap_init_compound_page_frozen(struct page *head,
+		unsigned long pfn, const struct zone *zone, unsigned int order);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.54.0


