Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65923C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0506B00C0; Thu,  9 Jul 2026 13:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281556B00C2; Thu,  9 Jul 2026 13:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF216B00C3; Thu,  9 Jul 2026 13:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40EC6B00C0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:46:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 440808BF27
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:18 +0000 (UTC)
X-FDA: 84969949596.08.B9FBC45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6EDD640011
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:39:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5XkZKaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=baztC/MocpK7zrehS66GUYKmt0apE+GSow4ZuQAJzvU=;
	b=mpXLypF0kBDYy6aFFmHO7f9KWqgsI2cFXvZYLvTilphyaZ1mvnUhQZa7gDxBBnco89JEt4
	4cpumLf1s5bE4D1MKvC5UK9bII7li5hflyaT4z17KloD2QjS3pYhNzsqPJI8ZT/8P5jDmy
	FQChxIJeQSCY+vt5QWfuw6YnZNt3PxI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R5XkZKaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618756;
	b=cJvbZW+ANPY0K7B+fA9tviUXP3s51yJ09vpyov4xhHEm21JE0jDlNtogkT/q3iQ8YUrB3i
	4H8oc2i5BtwMEUVSfY6oTzUCAHvc96m5D8uafi56fItEps511HoPF4kbTEK+rJI+MjIoB0
	90CP+inRH+0YbdDhy8fYKVKeixFsgu8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C025D43332;
	Thu,  9 Jul 2026 17:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9D51F00A3A;
	Thu,  9 Jul 2026 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618755;
	bh=baztC/MocpK7zrehS66GUYKmt0apE+GSow4ZuQAJzvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5XkZKaHr3dvER62bYxDyyh8UKudrjBlIb2CCGmBJ8x0HHXiI45s2m6RehvfmVs2T
	 BTr9Fy1Cz/Ev+cFJ0iRwp0pz0LLsa9DC70yBWcO5raZuLsm0TztkW2KUYJ2GrjyRS9
	 dwFrJrNIkk3AXkg5BkgV4GT0+NBiPU+Fb5jmXSBOrDA0ejSx8QPGm6/lPO2wGmkf/1
	 2hBDJgXLQmqLY0BpDitnxhkBYdFveqmhLRnnsH3b2fgVMkNP9nq2PMrjYmH4greVE+
	 qhWqLJ+SUtVei9ilI+8xTj55Su1P+NSWH3iiTqrJTy6ayeGM+vY4d7SSlP05t556lm
	 31oPChe3c+EUA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 17/21] mm/mm_init: don't rely on memblock to get KHO scratch migratetype
Date: Thu,  9 Jul 2026 19:38:06 +0200
Message-ID: <20260709173821.429921-18-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
In-Reply-To: <20260709173821.429921-1-pratyush@kernel.org>
References: <20260709173821.429921-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6EDD640011
X-Stat-Signature: sjkfayr5enwksdrtxa89d7uysnxonuse
X-HE-Tag: 1783618756-670566
X-HE-Meta: U2FsdGVkX1/3T2843XB4ni7W5nTl3lXb6TIP5jMmBtAO2QpM9KBEcIWWdYn6l0NfTuEhJJ8CFHEBjxn6K9ILRYjT0DkNzI7BIL+VLpd35uxPMFkDAKAoGoGyk0GHfLdSeaZMz5f/OaGnacyG8czNKt4sqqVdJnos8JQDzi1PhuwnTBEj56Ek9AjVpivMP7srCHsWDblC31euPTbhPhcu+qobesvHWtSi9e1dQrMNGwJ/1LFVqMt1TsQty+5gBEPuCPnhUxe/ArvPwcGWkXEKIMEA7Hi2/ytMEMwzPuOgw0O2EQncxRe7jFZaAg4Z0eq9PmnuTd5LGq5yn08RwLTRsdRAz71+Vz8waxtifUdUfHqy+OO1DxJTaiyWmfbM8sSz+d82E3rYCZ5I3GvyWzq7Nd2gmhAWeXggDVMW3h+1w33bQ34iBYYKjjz5Yh64SLqDUyhG1Hybsxx4Ljw+ZwQV7b92FcKbIKfp4A11atB4S0lus0ywxLOSreo/+kNnW7/3rIrjy5a0qCzJYKt7g2vs9m+Ik3Wcet5en6IToEd0RcSwO5Q/XZ+qQ6fX7MMtu2ZRxg4/H8jbMYpD7VMezAUxvwaH7eUGQl09uZ1QSLAoNDN0tizDxl/P1e1ZSSmzmxp8HVnXND+uYL9XilKQVhxEUNDJHS2+OCZ2sk7oGIGnJA4K7dsWREbXOGxkMvGx4R2bhrFdQtJGKsE8B8FpNpyDCcNnGFMTGUgNhTEV6bPnjk2bFcxEN+xIw/P+E+rkl1gI3e46qXMv/r2731Jda33cnW2W9819AJrwdN8Ymn6UJJgLyKAcb6G7Ze/h/GN2l1mUe0zJrTKz2r8ergU8W/qGvbh6caM2wkvni5eq2U1CyT+Er2DFrasqo1leOYHveXAROVZsaC1QfhjG644O58ZQjQEKXllKSsJhiRakcVJuReZ8u0f7npU4HTWUDJSNFRI7cAxX1L1gDHTqXqEZrMS
 vyZQ2/uq
 QhBAgS2Fc8wvRzRnB0AR7V0z80II4JtHxZu7SRvLanFZYH4yngJ8qWDWoxvQOkNl7oQh7ZDPHufd+B3htC+8g8v7slI3xx8wnNpDbJ2xoh8ZC+KfacWjanLxhWKYr9b/3MhlSJH/tWxT/yH0l0cqVoSrwX2Viimf6wNpe/aT+iDCjsH7q7zo/fUuRlygpLTp6LvvFAeXdkTxObmql4iNgXHTNmcZCJpcCODmng92OPmwYuUI3kdhwMnrKSHdb6kibLpgKE8ZRoXakn6Q5RDi9laW7TnbMffCarimN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Currently struct page init via memmap_init() or deferred_init_memmap()
only queries the migrate type from KHO for each discrete memory range.
That works currently since KHO scratch memory has a different memory
type so it is always it its own region.

An upcoming patch will add support for discovering blocks of memory with
no preservations and it will mark it as MEMBLOCK_KHO_SCRATCH to allow
allocations from them. This can lead to the bootmem KHO scratch areas to
be merged into larger free ranges. This merging breaks the selection of
migrate type.

Get rid of kho_scratch_migratetype(). Instead, let the struct page init
logic set the migratetype to MIGRATE_MOVABLE for all pages, and then
give KHO a chance to update the migrate type of its bootmem scratch
areas to MIGRATE_CMA. Since scratch areas should be a few order of
magnitues smaller than the total system memory, doing it this way is
more efficient than searching the kho_scratch array for every pageblock.

Since kho_scratch_migratetype() no longer exists, drop the migratetype
argument to memmap_init_zone_range() and deferred_init_pages().

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h     |  6 ++++
 include/linux/memblock.h           | 19 ------------
 kernel/liveupdate/kexec_handover.c | 27 +++++++++++++++++
 mm/memblock.c                      | 10 -------
 mm/mm_init.c                       | 47 +++++++++++++++++++-----------
 5 files changed, 63 insertions(+), 46 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 18ba417f1ada..30a71710565a 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -39,6 +39,7 @@ void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
 
 bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+void kho_init_scratch_migratetype(unsigned long start_pfn, unsigned long end_pfn);
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -122,6 +123,11 @@ static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
 {
 	return false;
 }
+
+static inline void kho_init_scratch_migratetype(unsigned long start_pfn,
+						unsigned long end_pfn);
+{
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5afcd99aa8c1..f142c8a8cd5b 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -613,28 +613,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-bool memblock_is_kho_scratch_memory(phys_addr_t addr);
-
-static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
-						       enum migratetype mt)
-{
-	if (memblock_is_kho_scratch_memory(PFN_PHYS(pfn)))
-		return MIGRATE_CMA;
-	return mt;
-}
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline bool memblock_is_kho_scratch_memory(phys_addr_t addr)
-{
-	return false;
-}
-
-static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
-						       enum migratetype mt)
-{
-	return mt;
-}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 6e8682469bd7..b400976851e7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -781,6 +781,33 @@ bool kho_scratch_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+/*
+ * Mark all KHO scratch pageblocks between start_pfn and end_pfn as
+ * MIGRATE_CMA.
+ */
+void kho_init_scratch_migratetype(unsigned long start_pfn, unsigned long end_pfn)
+{
+	for (unsigned int i = 0; i < kho_scratch_cnt; i++) {
+		unsigned long scratch_start, scratch_end, pfn;
+
+		scratch_start = PHYS_PFN(kho_scratch[i].addr);
+		scratch_end = PHYS_PFN(kho_scratch[i].addr + kho_scratch[i].size);
+
+		/* Target range doesn't overlap with scratch. */
+		if (start_pfn >= scratch_end || end_pfn <= scratch_start)
+			continue;
+
+		pfn = max_t(unsigned long, start_pfn, scratch_start);
+		pfn = pageblock_start_pfn(pfn);
+
+		while (pfn < end_pfn && pfn < scratch_end) {
+			init_pageblock_migratetype(pfn_to_page(pfn),
+						   MIGRATE_CMA, false);
+			pfn += pageblock_nr_pages;
+		}
+	}
+}
+
 /**
  * kho_reserve_scratch - Reserve a contiguous chunk of memory for kexec
  *
diff --git a/mm/memblock.c b/mm/memblock.c
index 6349c48154f4..8b2e551435ae 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2511,16 +2511,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-bool __init_memblock memblock_is_kho_scratch_memory(phys_addr_t addr)
-{
-	int i = memblock_search(&memblock.memory, addr);
-
-	if (i == -1)
-		return false;
-
-	return memblock_is_kho_scratch(&memblock.memory.regions[i]);
-}
 #endif
 
 #ifdef CONFIG_KEXEC_HANDOVER
diff --git a/mm/mm_init.c b/mm/mm_init.c
index bd9dc1829005..1d2f302d8cd9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -707,9 +707,10 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 	__init_single_page(pfn_to_page(pfn), pfn, zid, nid);
 
 	if (pageblock_aligned(pfn)) {
-		enum migratetype mt =
-			kho_scratch_migratetype(pfn, MIGRATE_MOVABLE);
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
+		init_pageblock_migratetype(pfn_to_page(pfn), MIGRATE_MOVABLE,
+					   false);
+		/* Update the migrate type in case it is KHO scratch. */
+		kho_init_scratch_migratetype(pfn, pfn + 1);
 	}
 }
 
@@ -938,13 +939,22 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		}
 		pfn++;
 	}
+
+	/*
+	 * Update the migrate type for any pageblocks that fall in a KHO scratch
+	 * area. Do this here outside the loop because most pageblocks will not
+	 * be KHO scratch, so only search once.
+	 *
+	 * Only pageblocks up to pfn are updated, deferred pageblocks will be
+	 * updated later.
+	 */
+	kho_init_scratch_migratetype(start_pfn, pfn);
 }
 
 static void __init memmap_init_zone_range(struct zone *zone,
 					  unsigned long start_pfn,
 					  unsigned long end_pfn,
-					  unsigned long *hole_pfn,
-					  enum migratetype mt)
+					  unsigned long *hole_pfn)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
@@ -957,7 +967,8 @@ static void __init memmap_init_zone_range(struct zone *zone,
 		return;
 
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
-			  zone_end_pfn, MEMINIT_EARLY, NULL, mt, false);
+			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
+			  false);
 
 	if (*hole_pfn < start_pfn)
 		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
@@ -973,8 +984,6 @@ static void __init memmap_init(void)
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
-		enum migratetype mt =
-			kho_scratch_migratetype(start_pfn, MIGRATE_MOVABLE);
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = node->node_zones + j;
@@ -983,7 +992,7 @@ static void __init memmap_init(void)
 				continue;
 
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
-					       &hole_pfn, mt);
+					       &hole_pfn);
 			zone_id = j;
 		}
 	}
@@ -1973,7 +1982,7 @@ unsigned long __init node_map_pfn_alignment(void)
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-		unsigned long nr_pages, enum migratetype mt)
+		unsigned long nr_pages)
 {
 	struct page *page;
 	unsigned long i;
@@ -2012,8 +2021,7 @@ static inline void __init pgdat_init_report_one_done(void)
  * Return number of pages initialized.
  */
 static unsigned long __init deferred_init_pages(struct zone *zone,
-		unsigned long start_pfn, unsigned long end_pfn,
-		enum migratetype mt)
+		unsigned long start_pfn, unsigned long end_pfn)
 {
 	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = end_pfn - start_pfn, pfn = start_pfn;
@@ -2027,7 +2035,14 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
 	pfn = pageblock_align(start_pfn);
 	page = pfn_to_page(pfn);
 	for (; pfn < end_pfn; pfn += pageblock_nr_pages, page += pageblock_nr_pages)
-		init_pageblock_migratetype(page, mt, false);
+		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
+
+	/*
+	 * Update the migrate type for any pageblocks that fall in a KHO scratch
+	 * area. Since most pageblocks will not be KHO scratch, do it outside
+	 * the loop to only do the search once.
+	 */
+	kho_init_scratch_migratetype(start_pfn, end_pfn);
 
 	return nr_pages;
 }
@@ -2057,8 +2072,6 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
 		unsigned long spfn = PFN_UP(start);
 		unsigned long epfn = PFN_DOWN(end);
-		enum migratetype mt =
-			kho_scratch_migratetype(spfn, MIGRATE_MOVABLE);
 
 		if (spfn >= end_pfn)
 			break;
@@ -2070,8 +2083,8 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
-			nr_pages += deferred_init_pages(zone, spfn, chunk_end, mt);
-			deferred_free_pages(spfn, chunk_end - spfn, mt);
+			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
+			deferred_free_pages(spfn, chunk_end - spfn);
 
 			spfn = chunk_end;
 
-- 
2.55.0.141.g00534a21ce-goog


