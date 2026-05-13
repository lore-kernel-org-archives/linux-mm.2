Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28E8CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D546B00E6; Wed, 13 May 2026 09:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274F96B00E8; Wed, 13 May 2026 09:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BA96B00E9; Wed, 13 May 2026 09:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08CD26B00E6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C971116010B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:26 +0000 (UTC)
X-FDA: 84762432972.13.F4E7BB6
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5D3440016
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Orh9bzTg;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mBY0+2gPF5yrifjarXE+EeA1By9caS7ano4A0QDHP8=;
	b=yzoD9+stlC6t9zm20GKBLTzQbX1oYjvBl2UBBw0jCS/EikEaoGEo4zdG1O2Og5zF7Yi6pW
	ecIPDqXri0ZdJkKznJ7HJvYlNvZH6vddbnLwcEK2Rg04lWp6LvodFaQhDrd/D5OWs8DvoX
	YneoDlmrM025+02Ct6z17RICj/BnDk0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Orh9bzTg;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677884; a=rsa-sha256;
	cv=none;
	b=ZeKVBca0boTJZYhSKEdGKh9ZjxXJX17My+7UXdjpmIQzy6kVcMslgRTE2DLaT4Fr6eYOlN
	ZMOq1hHyPGOfHs3wYLBZz5I8wIC5nfbvAjBScdB8p2i+IMP67WxKIq0tdn3AtApFrVqHe5
	GIzTmWME+CYMzx68bC8zH5UL64tFtqM=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bab2548e8bso31506395ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677884; x=1779282684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mBY0+2gPF5yrifjarXE+EeA1By9caS7ano4A0QDHP8=;
        b=Orh9bzTgBLJln/i6k+aMA7cgCLKiCAt3lS5B3RAnDn0SYyQRbpGSF5ymetGsA/gOkC
         P2j5xAXxebTDk9/erPcu+NaRGhNcqkUD/n5RAIEmFWuPIps/ml2lrTZR9GxRr/JPQlRh
         TmO5YeZQJVv4hK1+lXuXRZBIlR6eLg1hxKoGClWOPC//nIb4oKn5uaxIZw/wI+MrH8Wb
         SReFzxmGXl1KNJo59i72al34sjNcCq4YrOhloaFq/ha7fRpFzEe6JH0R0NXjdwbSWuB1
         tKyFH6PELzhlycSxzeR/EsJwQ/0j+PODhvKOmVuYqEeo9Ir/msy0U2G1c+lfm/VajJee
         H9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677884; x=1779282684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4mBY0+2gPF5yrifjarXE+EeA1By9caS7ano4A0QDHP8=;
        b=EiRjLB8kgDoOoNIQH+vN1Y77R8KDNx0b+1R6AT+7J0o0yGyKFnQ4sOVmSva7H/4oEC
         4c4suToeofE4DLtbWBHx+CEvMCuc3rQ+p75YHqzclLRsS7k9MeQ5N5ibMyU4hQJYQk2e
         /+leCtadIbKmK2QX53pk9lE4vdnfwfSTFEDJpOmGaYQt+NL+5A0qu+Adprl3MjPhBBzi
         t6P2gZq6iaYhP3LUeEGA0Ac4rwfBYmS1af4oFh76vuXgQo5QgQ6m5Hdrvhdo1sWPE8ye
         LLOmn9GdB7t5zsax7VJ+1cmJTWAUAsFOORFvhDu9uUDuUL3UATJaTwvLTYtQP2SUrjdW
         q39g==
X-Forwarded-Encrypted: i=1; AFNElJ9DNrzv/utm5v7AEKqr0zLNcqf2ZM3sPtuY0PGUay7qEMIitnaxl16xlyxZlb6OCICPpVTe4LB80Q==@kvack.org
X-Gm-Message-State: AOJu0YxJiQAaw0X+7972VCOIDKnJUUeKWe1MWMtd5nQfvpbj8i7GYmqp
	cTcQf56Yal8mCmU5xYqCU+89ntisxxwi4Pf4BsWOF4YnHnjOT8mCXU0VlB9sEHtpMJC/ZTEBolF
	Sg6HdWanZgQ==
X-Gm-Gg: Acq92OG5z52BmX/UjvN5CnDJXvZQ77YE1g0XH4wJqJYO/ZP3gdFt7MigWNHFJUxxS6m
	Db9m+Y1gdjzQg4Ie8RWwTxCxwi2byOUT3crsgQRSq3aMZbAKze/ypqdsmrgBlYwFM3A7inYnEpN
	S6rw9RYPVGBAbZyg6rIGo4cD1Px+HjV1jzABaoFMtU3Dv61Gf8U9RGpKn4eckMUys+jyPcGaJLB
	lNdMySG+KY/JkPol0rI4bO0TQ1MQS/AvAgV5O7dh4juqIeZoVP+YXqHWwy4Y3ZywBQBCXcyV97W
	IigJj41nl48sVITFk32w2+jAqJQGouaa8dpooKlgS1WmAptenPx1pubzKP4tqLQIeLNbUP2bgDe
	447JIQUVjfyvWENdY5W7E/siuto1MO/gkAp9wDIHTX34+EH/CZu9FC0m9XhRIaO97AN8Onq6HGG
	i6OAZTS+Tk+qbvcRIQMrru3HMjkcZ+puRnmGHuivq7y477LQ7K7Vv5+r0MKCU=
X-Received: by 2002:a17:903:290f:b0:2b2:539b:d2b1 with SMTP id d9443c01a7336-2bd2f6071femr19517135ad.16.1778677883529;
        Wed, 13 May 2026 06:11:23 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:23 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 42/69] mm/sparse-vmemmap: Switch DAX to section-based vmemmap optimization
Date: Wed, 13 May 2026 21:05:10 +0800
Message-ID: <20260513130542.35604-43-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5D3440016
X-Stat-Signature: x6kga5msio8qzsnnp5i8pfeyp9nzyze3
X-HE-Tag: 1778677884-460847
X-HE-Meta: U2FsdGVkX183yahaO51B6GRLtGOBS09Bdd2n1FpDh0rJ9uflia8gc+dVj/0wc74+KGT+rs62A5E+u/It/5DQsPUbl7v5haNUVCgs1BFgIhghnW6gPaF6cmqHgnQHSRB68ygkvRpLCM61c2iVXftUhccYN3NRYQz4gptFc0aE05nO4hyqqO86BbbxtLHACBFoJUTjteOPVaxBUl5WuxYkoHiWBEBfmR7y+d4MIXvYDx8U5F41lXCVQ2gb+1IOOf/IenO422ILnWTb81tQbv0SIHCynEl7vXfjSDNmYrWXhdlMIsrG1SkR7h8ZFC+qMwnyd8SDufYro1rLLKv7NmLX/SYiJ3N3DY/rJ/drCfMYEZ9BcrofF4iTnUuIyw6x9rk7EN+pHDLQtsMWfEF8TVPKoTZiNIbBD7x1uslam5fI8lQmBg99GFa3okr6O5VxW208K2CYPupMN62IQdvAygQ38iv61l0N0iUZRbra6zgQmZsjRDFQT3q/cUrCpS7c4xN5AMCF7IYkJFn5pxAqa+DxLR2xdyceIesi8ap1QhUdMknLkbSJ50nx2cNjMX/GbxOC6DV/4vTAyM+cmnDzKOnMKZs+YZwGn4dJgmCoDzWxPQHxOxURG12dH3u+R/QBGqHYNqlD+tRJxMJvGqo7kKjc+h12CEbeCv0UlIojs4n66zlC5FaxSt/oTjqmGa9rK7cjlAzKqeDQebqFGteg6QCW/NAJwRszRO2vOwr1CitWrkiQ7fOkTzHOBUsUh3n8nCvsHtxS4Gqtyla9WsOdqJiACnIqWgtSW2i4B3GnjXBeGsdQFe/awu/QFqEoj25VkAlDBaradisYamqQlsuDy4DfKvaiA6TaqRdxJa28rRZd/XVMiFkCrailYx6Ccqpp6I0r5cf1NwXChKuOrPFsyD4JgU4s3jv71ksEEnW1ztU0TF4YEmc/zh0+i95fSP0/ZbZOhfkMkahUTU7Jgoi848p
 l14yeenl
 q1CBPU37JA3NHhXVNqXowWfDn018ZYrGd1d8UQusj1qSsbEBU3AoU94Epm3rdIlrrjqLNUWXY5E7CjZSLxxbLY9IQnv4TGYhPS0pN/FzpEg0ssnx/XE/6a4UrFjIB5VLlszEpGui3/2yIBgi/d9uXSJgq6NE6kNjVMYeU5YTeqvFjKrfTuQgdtz+/lJ53KQdeIF/B25hywsqnTy2i1c07SgX7t5oLf9SMTUcdL/b3p2XzfKzTQJIgNvc2UUB1Qz5dlFXwuioLNS+8LABygKff2CB+MUddmwt7YuiqeBca8XQmueDNUqoa6ljZxxW1/S/nTs5h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAX vmemmap optimization still uses pgmap-specific state to decide
whether a section should use the optimized layout.

Switch DAX to the compound page order recorded in struct mem_section, so
it follows the same section-based optimization state as the rest of
sparse-vmemmap.

This lets the DAX population, initialization, and teardown paths make
their optimization decisions from the section metadata instead of
carrying separate pgmap-specific state.

This makes DAX vmemmap optimization section-granular. Only
section-aligned ranges record a compound page order, so subsection
mappings remain unoptimized. The resulting loss of vmemmap savings
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c |  5 +++--
 mm/memory_hotplug.c                      |  6 +-----
 mm/mm_init.c                             | 13 ++++---------
 mm/sparse-vmemmap.c                      | 24 ++++++++++++++++++------
 mm/sparse.c                              |  2 +-
 5 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index fb8738016b30..f0043c57694e 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1235,8 +1235,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pmd_t *pmd;
 	pte_t *pte;
 	struct page *tail_page;
+	const struct mem_section *ms = __pfn_to_section(start_pfn);
 
-	tail_page = vmemmap_shared_tail_page(pgmap->vmemmap_shift, device_zone(node));
+	tail_page = vmemmap_shared_tail_page(section_order(ms), device_zone(node));
 	if (!tail_page)
 		return -ENOMEM;
 
@@ -1268,7 +1269,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << section_order(ms);
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9ff830703785..c9c69f827efa 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -551,11 +551,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		/*
-		 * This is a temporary workaround to prevent the shared vmemmap
-		 * page from being overwritten; it will be removed later.
-		 */
-		if (!zone_is_zone_device(zone))
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
 			page_init_poison(pfn_to_page(pfn),
 					 sizeof(struct page) * cur_nr_pages);
 	}
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 35c99e5c215c..2b94115e6dd5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1071,16 +1071,11 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -1150,7 +1145,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false, false);
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index b5c109b8af6f..ad3e5b54abf7 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -455,8 +455,9 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pte_t *pte;
 	int rc;
 	struct page *page;
+	const struct mem_section *ms = __pfn_to_section(start_pfn);
 
-	page = vmemmap_shared_tail_page(pgmap->vmemmap_shift, device_zone(node));
+	page = vmemmap_shared_tail_page(section_order(ms), device_zone(node));
 	if (!page)
 		return -ENOMEM;
 
@@ -464,7 +465,7 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		return vmemmap_populate_range(start, end, node, NULL,
 					      page_to_pfn(page));
 
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	size = min(end - start, (1UL << section_order(ms)) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
@@ -501,7 +502,9 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	/* This may occur in sub-section scenarios. */
+	if (vmemmap_can_optimize(altmap, pgmap) &&
+	    section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -718,8 +721,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -729,8 +734,14 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	/* All sub-sections within a section must share the same order. */
+	if (nr_pages < PAGES_PER_SECTION && section_order(ms) && section_order(ms) != order)
+		return ERR_PTR(-ENOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -756,6 +767,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
@@ -801,14 +813,14 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!section_vmemmap_optimizable(ms))
 		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
diff --git a/mm/sparse.c b/mm/sparse.c
index 54c38ea08190..6878f8941b4c 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -251,7 +251,7 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 	if (vmemmap_can_optimize(altmap, pgmap))
 		vmemmap_pages = VMEMMAP_RESERVE_NR;
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
-- 
2.54.0


