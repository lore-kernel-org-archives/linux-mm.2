Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75E93C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 08:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89FE6B00AD; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C148F6B00AE; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28C36B00AF; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2CB6B00AD
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:49:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BEE580253
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:43 +0000 (UTC)
X-FDA: 85052077446.15.1B339C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6077E80006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:49:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OnukmD4t;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785574181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83kspmo8TTp4RMbxXy8Nzpo9izKR6G1SlaBEkHNGdGQ=;
	b=BnqoHzCi6fsLN6fh0p4c6/WzqGHG7v6LXSn2ftrbkZMGgDkZkV/L7xc5OLhXdh9Bcmp/vQ
	UQtYlc5JKKcq266bqNAu43rR5Pb51T1BHEmVF3nK0HsLQ8G13a/n6V2YR7JTKc+saMjDus
	ylVHu1uq6zidnVIg+pc6Bkyi8SqMbCM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785574181;
	b=YaZV63eyLvJI8Ge3ANziSRL6zv/5kYRyareMj2cvK0U8uqzx4D2VFrxPCu+ajx9ICBfBlU
	B0Qw9n8n7dEfjjKEnxMSNlDCKkbi7JoPOoo/ecS9zfKE6WSvmwW/7gp4+bp4O/CSMgY9CP
	SznXxyrJWbZmj3nMCWVN7ufe+OD+n6U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OnukmD4t;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EAC34528B;
	Sat,  1 Aug 2026 08:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8101F00ADB;
	Sat,  1 Aug 2026 08:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785574175;
	bh=83kspmo8TTp4RMbxXy8Nzpo9izKR6G1SlaBEkHNGdGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnukmD4tHNqqjGhjJ4BEg5pEvw7Mmz2XBfg5HFjZiA+79FC74k309wZqYgxPgRdgG
	 qzxQR4dI4MUU8vd3VZPLVCvCQZu6/pLvP3Xn8gvrniIh62brxxgrIzIvbSm69F+ij7
	 mTF4n7llRt5RBq4rlKaxrXnjkUHLQ5cLagPR/tkYrlp2sUtpcJpPJW5h5XH9qI6Hju
	 u7rcBGifIEMk+2V5+kqQhSLdlzWjEVjhNA/cYpxy+Xi6qVLwCGs8c4DL4gQLwRh3su
	 Pukd5GTUX1CK5V2ApqqPGdse7eD42WGRXcpqijQ62+Suks7B9OxtENZodGYRVtXDkp
	 DsyLd+vYH6wfg==
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
Subject: [PATCH v6 17/22] mm/mm_init: don't rely on memblock to get KHO scratch migratetype
Date: Sat,  1 Aug 2026 10:48:26 +0200
Message-ID: <20260801084833.1897543-18-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.571.g244d577d93-goog
In-Reply-To: <20260801084833.1897543-1-pratyush@kernel.org>
References: <20260801084833.1897543-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6077E80006
X-Stat-Signature: wb65czrghwdt6h3axrqea5ekwu3quoao
X-Rspam-User: 
X-HE-Tag: 1785574181-248997
X-HE-Meta: U2FsdGVkX1849Uplus5YsJjGGAl/Hj9f1NmwMiincAU26vS5C52V3V7S9mfJjiallS22kvEcITx65iARVCRslKdING3FNf5hEX8suQ1QHCmRh8PflQwjNoe4gZ6RXOIC2isPmd9lrYtggGXiQriSkKNdZAWdCWHHiJMKkJuzpYeg7mWpweewk3syAqHjfXDBT/oH4hOq+wW4wnSWKLZBmxSpnf+1edwZLrYRHjWe0pFJnmvFRJQjnLKVwubRYOyzAltrvQlgYLOQrQAKtmBbftomO5LolxzIbGfgZIxokWCEG3NJun9qdcKGveDuUjn1KjyOTNa08GIa0bqd/YDxcjO5CLOuJfPCwIzRv0WperusAEVluVoX30qxkHrjixuekm5ekItKfgaAIPIcNRRYw9cLaSLquWrTFwa9ePOdTMLU/E27rVJZJNFsaHFIKfHD6VqwTH+izgT2rRWdBAonFdBV/QAZZGrt3N3G44sVCg5OZRQ6pHNnpSeE6s8Nulq2JS1m+lEaxPi/z+lUBgbgX8qtO7yV59lUX2tqSd5u09EzCn6lbK31b+l6CM+I7LHMbB423tfj9NRQ9ZJOUMteTJ5DH3/ITjCzDmGf1mI7C28TmDyuf3aslIM388XFNxcPtSmBx/ehR7TF+jxh+KjmsZpVkqTrEm5BPVkBFL/5WpToSHYeNqGQl1yO23DmLENKBsjAcnT4PzYEGpUGCFTn95PaYEr96GxgK8agWInNQPq/Tt+r3scZMczXHAys/u/ru9vnDnLYguHXJNS8l9On/OsIZh5pP14zuageuuM3HNs0GYG71FJhgTcLTkglF35D3YnH1lNm3VLwb2q8kBN7b8EeNpXq6HkW0pS2UUCh101BS6e8Wi8iGraswce7ehu2wBtS5M3rzV4/VT82IN0FeHKnmifYJJ9kiNE7I5ymquMgReqQDl9EnMMacMJpp8eK2V1GH2z6HojZlvU8kly
 TB8Ur3vj
 oJmf/5rOr30+TWcsAsTxpPwm4iDWbRdsokBEKINtLg5ICF+C6xg1KtYvoivN8eP2fSAhrgAabKJ6xHyOKJNiJKvenJGXwiqCjv2+ywKU8Yzdgt+rz+T+dFvvAcsyuFQT2DgwsDP+2DbpyJSThtkSmkyeGi5RUnHLUCliDUZat2CqOz3wYdzeAcbdwcnFSbqMQzmGZUEalL/nCHvZ2+2tIuI3nztYF2xR/zbi+atrCL9/V3hpOpbOrRxMk24/6dEBRTxc132QiW1JSOX48e+n0VreiK9UIGWgLAnFs
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

Get rid of memblock_is_kho_scratch_memory(). Instead, use
kho_scratch_overlap() to decide the migrate type of the PFN. Since
kho_scratch_migratetype() only uses KHO functions, move it to
kexec_handover.h.

Instead of calling kho_scratch_migratetype() once for each free range,
call it once for each pageblock. Update
pageblock_migratetype_init_range() and memmap_init_range() to do so.

Since the migrate type is now evaluated for each pageblock and not each
free range, drop the migratetype arguments to deferred_free_pages() and
memmap_init_zone_range() and use MIGRATE_MOVABLE directly.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 include/linux/kexec_handover.h | 15 +++++++++++++++
 include/linux/memblock.h       | 19 -------------------
 mm/memblock.c                  | 10 ----------
 mm/mm_init.c                   | 27 +++++++++++++--------------
 4 files changed, 28 insertions(+), 43 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 18ba417f1ada..46de86dc343e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/mm.h>
 #include <asm-generic/kexec_handover.h>
 
 struct kho_vmalloc;
@@ -39,6 +40,14 @@ void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
 
 bool kho_scratch_overlap(phys_addr_t phys, size_t size);
+
+static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+						       enum migratetype mt)
+{
+	if (kho_scratch_overlap(PFN_PHYS(pfn), pageblock_nr_pages << PAGE_SHIFT))
+		return MIGRATE_CMA;
+	return mt;
+}
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -122,6 +131,12 @@ static inline bool kho_scratch_overlap(phys_addr_t phys, size_t size)
 {
 	return false;
 }
+
+static inline enum migratetype kho_scratch_migratetype(unsigned long pfn,
+						       enum migratetype mt)
+{
+	return mt;
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
index 30355effe1f2..dc20d6814e48 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -681,7 +681,9 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
-		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
+
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
 		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
 	}
@@ -932,8 +934,9 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * over the place during system boot.
 		 */
 		if (pageblock_aligned(pfn)) {
-			init_pageblock_migratetype(page, migratetype,
-					isolate_pageblock);
+			enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
+
+			init_pageblock_migratetype(page, mt, isolate_pageblock);
 			cond_resched();
 		}
 		pfn++;
@@ -943,8 +946,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 static void __init memmap_init_zone_range(struct zone *zone,
 					  unsigned long start_pfn,
 					  unsigned long end_pfn,
-					  unsigned long *hole_pfn,
-					  enum migratetype mt)
+					  unsigned long *hole_pfn)
 {
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
@@ -957,7 +959,8 @@ static void __init memmap_init_zone_range(struct zone *zone,
 		return;
 
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
-			  zone_end_pfn, MEMINIT_EARLY, NULL, mt, false);
+			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
+			  false);
 
 	if (*hole_pfn < start_pfn)
 		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
@@ -973,8 +976,6 @@ static void __init memmap_init(void)
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
-		enum migratetype mt =
-			kho_scratch_migratetype(start_pfn, MIGRATE_MOVABLE);
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = node->node_zones + j;
@@ -983,7 +984,7 @@ static void __init memmap_init(void)
 				continue;
 
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
-					       &hole_pfn, mt);
+					       &hole_pfn);
 			zone_id = j;
 		}
 	}
@@ -1973,7 +1974,7 @@ unsigned long __init node_map_pfn_alignment(void)
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-		unsigned long nr_pages, enum migratetype mt)
+		unsigned long nr_pages)
 {
 	struct page *page;
 	unsigned long i;
@@ -1981,7 +1982,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, mt, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, true);
 
 	page = pfn_to_page(pfn);
 
@@ -2051,8 +2052,6 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
 		unsigned long spfn = PFN_UP(start);
 		unsigned long epfn = PFN_DOWN(end);
-		enum migratetype mt =
-			kho_scratch_migratetype(spfn, MIGRATE_MOVABLE);
 
 		if (spfn >= end_pfn)
 			break;
@@ -2065,7 +2064,7 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
 			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn, mt);
+			deferred_free_pages(spfn, chunk_end - spfn);
 
 			spfn = chunk_end;
 
-- 
2.55.0.571.g244d577d93-goog


