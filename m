Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77289C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5600C6B0174; Wed, 29 Jul 2026 10:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511696B0176; Wed, 29 Jul 2026 10:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400346B0177; Wed, 29 Jul 2026 10:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 143FB6B0174
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:57:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7DD812068C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:08 +0000 (UTC)
X-FDA: 85042116936.27.9686132
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 28D432000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:57:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuXJ1yNm;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785337027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghdDFZPLf2rtp958iY2Vuuv2OEyj36gLpSUuWrXiyDE=;
	b=e0Vjp/AdxBXK5UpX+bfxj6fIZw7Glz0SQLO2s3+eLpRVM65NgmDdF4K60QX4bhdVYFIBZ4
	hU0w/7QA51RdEvkl9RnXjPYbgcZ5MLgQKB6ERxh0ANndIvwcDODqucqigY1xsEEVmQJvWS
	tq/GXbVnZMfcJjBGZG5ZC1fdNufJNN8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785337027;
	b=eAiRslCU3580mv9OT6l8O4vpzRuo9JZO/KWGPO+t+iBkvWSxlaBv4nWDfvmVr/aZM5iIUt
	+I/eimZyzXvnPuJ7rcVx9TTSHM2NTV8Qrnc8mpfRB7CmvOCCGpqc7FNMqeQMwe4Gvoq4TA
	C3hmR0jnmEy/mspjj+Wsrno7B86oZos=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fuXJ1yNm;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE4AF600BB;
	Wed, 29 Jul 2026 14:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CA1F00A3A;
	Wed, 29 Jul 2026 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785337026;
	bh=ghdDFZPLf2rtp958iY2Vuuv2OEyj36gLpSUuWrXiyDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuXJ1yNmvGKFR748t9f6fpDhb0cQYf/pXwGUGFDpz8vbslke3Xgxcmo+K/K9qvNfM
	 LTHzvHdHyu6mKMG3QCsDz3LtTKIIRp+b50ShMgkIb6Qxr+o4BOCBBBD2a+ZKoJTf/p
	 1/fgbwbEWZX/a2QTh43zywoItnIyf6lE91TiQ2Cs3gd7yL5Ef5ZkMYiH294imE0bQD
	 YfMEefrOERUIvj77eNTLIWTur1fSRuWagZcaZzezh6SQT2TlmSUS9U6nEFqR+NlWIe
	 Fv9hWovvgS+/YykHjuTIlnRmPZMlZhB537O54AD0ijMUDA3GiZqlTFVIl2UMRKxckU
	 M/y43Z6qW85Zg==
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
Subject: [PATCH v5 17/22] mm/mm_init: don't rely on memblock to get KHO scratch migratetype
Date: Wed, 29 Jul 2026 16:56:02 +0200
Message-ID: <20260729145610.2827231-18-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <20260729145610.2827231-1-pratyush@kernel.org>
References: <20260729145610.2827231-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 28D432000C
X-Stat-Signature: 3z7eozidkqn9acjbtpcopakrozmsoapq
X-Rspam-User: 
X-HE-Tag: 1785337026-180165
X-HE-Meta: U2FsdGVkX1+/gDyJKllhsQ1lPw5tKoNe8yFaJZf3YTgIvqqjZAqV7SW1A7El7RaQK+FbXEFiB5sFhmDUdXsR0cOq2lxuKqinZO2Gjnn37DBHiAqbZYJwLkMlPMUPjU6PS8q/PX57j2Kh5s6YPeFUWLJmYmpGIzEPemkgluxWlbkizkwO0zGKik3z97WR04PGJWxRHelyzOSjfvSiDvarQHJRitNYoeya0mLJ6T6hjw0QPaHi1zr1MyfXaHu0dG9kCCQyN94wETd0lSWCjRDaJnfAAS7V6YsQVk6k8xcee5ZUvC0h748AFni5lqPsG5frTmzhDDK9eQArq1QwAyO9l59TnukRsZvR88LnfReWnA1zauM6YBqbHyauawWH4MJpjbNQV3JnsKa9flY1Szsfw3dDdi5bA5AWzorrEazsVS/xceMWhecCutMBPGrHzfN3Mv/0vM0CvIt1nqEG0gMbWX73ma/CLIIZW556IhMrxdvi7BWU+K3xAaXO5E2CsJbbkkwirGNKmag9nQYCbUDgKkJt/PU4zNJZhIulfnH8rZOV5VyvEwiRKqyviMG8Ei0lnx4QP676SdiOWkeaUBeCDtIgqEo4SKBPJL2pokqg+y5uzZtdvYdSwSZKT8UL3tAUIxWaMkEDLDFhuWZ+0weor+ByY9s3VS6tcQgaOVdS2LrMv3UuzX5CXv+fRItX+zWdHVbccTvIpoLQwdktnjck+Ifc5vS5g7acbO2y652ZE2ulo8PukigOpTdObMxlkb3qPg9xcsw0G4HgBUA6bxx/eWX/FLbC2lM5Df3q6wftVrB0KQXm60M5QWsyujphaPESJJgVZC6GtKu2h9+2UtgeVzuVcqA7IB7arCztRm7+KDc+zC6jmIGHgz50iulVvRNeIyCNrsNFjAnkR3vJJ2X813qc8mbW/t2IRcdbLl7ItcylxCHTknOz+oVv+1qlhQuVNC1yxFXGnCxP9RQHyy0
 HZzE+PE8
 yuT49OFiXyOGGfxMe29FCHgoBb0Keu6qQ+WrT7cDWvf25TwYAWLIxp891ZpwoLfWYCpSJRU3lNC3IYdc71S6dkDnvYlCxt5LUUkEmxgf7Ct710XV7b7js0uI1nKKZR8uL09quUQ1e/SseA9q7KnQ5EcELcm2OMjMpDV1DhjPQS5cOmLGODQfBQN2MgujFoJZJ49RiJwWYyb8y6A5xgE3/FmDjFU5QuxH9ECcSBbTEKIqlVMQu1UwFosh7CaZrE84xeF20zuDEMgkR13Ow528tUrIeWpYzttt1su6/
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
index 18ba417f1ada..c83ec4a15fe7 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -5,6 +5,7 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/types.h>
+#include <linux/mmzone.h>
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
2.55.0.508.g3f0d502094-goog


