Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A15CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574D96B0158; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5252F6B015A; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECE36B015B; Mon, 13 Jul 2026 13:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0965D6B0158
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:16:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF7388B6CA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:32 +0000 (UTC)
X-FDA: 84983855544.20.7504A03
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id 269F980010
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:37:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fBbkAIFQ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783949851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kquTgKG2tUftdhkjvrowfIPLMW91GHe6VxDcWet49Dg=;
	b=sV9SAqQbDuO1wJsvS9kMJHFu3Sim6IhYFOjz6x5/pwMy5QoPUQghoXs5uT7mDK3GRlqC8i
	Y5Pa27h6+qWeIWBgaawgwJGJn4Ge0eM3JJqkRCcIe41jBVRq7mZDGKaH0dEmoaoBTlGDTo
	8hIhekgtVkx3oloP+jJO5p/3BmeW5n4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fBbkAIFQ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783949851;
	b=BTR4xwx23Q68UlfB7v0SYU09ejVVIVpzC27JKDlDpBMV2pPPhITyXz9U4u4A7bzJ1pkqHh
	gkNqa6tadD1OJJgsO5RlOjLEimHxFNUzU3PwExEPC94c9yIbqy8euBrWf0A/ULefl34WOW
	9b7rKYRrjJgILKsQMQMohKcWmFoBqjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783949849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kquTgKG2tUftdhkjvrowfIPLMW91GHe6VxDcWet49Dg=;
	b=fBbkAIFQS3zQFlWxPb/v61B6TMHh3+fV7PqurWDyL/D/GL+VDJsFFmswg59dmBUY10cbU8
	oiE2PBPYl7M/3Trby0a5ntlgn3WLY7SI5cmCmIKvTXu9AsInS7WtgplVLruizirQUtdy2m
	ZUglO3A16XD9o3YF1hGgelR2kzGYmUM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 10/11] mm: install PMD swap entries on swap-out
Date: Mon, 13 Jul 2026 06:35:45 -0700
Message-ID: <20260713133613.2707815-11-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-1-usama.arif@linux.dev>
References: <20260713133613.2707815-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 269F980010
X-Stat-Signature: upiawbo7ssqr94o4kxr9zfjmf5btzi66
X-HE-Tag: 1783949850-665834
X-HE-Meta: U2FsdGVkX1/DDmG3p+LZY1xEyBHd6zllxN1xTE70X6353QCB2wCO5NBM9kjuNRDJcPOq7+XE1rYzNXn5OZkVAZn+kt58x0yU0QUrukHzxJPdPP3MjQfRk8olaAC9jV8mFlYAyBe4wlOkPU43xZ3te/dcHYixyP5GR5wQP9Vgxwk3xtXgagaP/oLaOUunChcuGP+oGFL0Y99faBZYpOi/1WOtPBnDav6aYcBbxXvY8eOcopD+X6/wLkC1afceIg65+D4Jtw3ej7IeHXocvSh4t8GXvPSRi354veMgGtWDg1F9+5ZNsRK0sWtnJXco4SYCyi5c7yDyuEwN6xHDfCGdVT3ZCS9Ty6dLtiwsRA/EGaEC3ZH1EWnuJCwDRm9JOqBmvxK+XRJTH05/wyx+ZbpvQenCwoSMeKIpVjRAG7e4HMd62AMQmH3PR7A4JgCTIY+uQWKkpz86xKpZmEjKzZ5EgcrhVwMOqgOJaqeGWG4XbQFDoioPnf36sBQzv7ZqnEj9t4sAR/5pjP6gKAPClOIda6YKphwLbBpN/QWz0tGx7QzDN/9cav3ONtI7pIzYkOSALXgV892OoYXB+qy9FMALbiT20zdtQwsPBiew7ANjdNrvS7I3QZhU2k/pCvLnsZjhrlxguGrUxBodTblKT4i+YCC8roaSk4/oC+gICo7RqR38st4krUD9EM0zYgIlYkhmiC8KNBf71dlqRhx/EELtk0WBfb7msO77REYINagoGb+fVAESNbSQN+WXVgi1kwnVR2uv/vXZCv3j6Wh5NEiX7Oxx5kjktoORWEQgu2X8cAHZziuFbGcV9ySdtvoMe49c/EbVKF/siTYh2Z455A2mvsTY9owr9Hj6L1NS5bZaK0dthvchSkgX9LSm3+JmfRtZ0XoiYqU9ecTENnFZqAPERmhyWzLiGK8QukPdSr29RjqwcGJAw5J/IcCOLpFGwcpB2Kl3inF6v6tw1ZWe+m1
 +H688nbC
 8i+hr/m8v6cijyjqhbs0yhOGhEP2NlctCFYLH9emvdSjcZXSfs17RbosOCXdtbzGhcOk1Ryjr4Eacsyw7eJkuZXQ5VPieTDjcrh9oFsGQRSKKkW+HNNLebH8mSXFCGUYtRgXCET0XfaGj7SIWOLZJrs7yQqfqpvn02R7yhwH4SYPd5zv0o7K6JWlgpNkqVvoyJkq2HQUIr6ocNfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim today splits a PMD-mapped anonymous THP into 512 PTE swap
entries before unmap, losing the huge mapping across the swap
round-trip and forcing khugepaged to rebuild it later. The contiguous
swap range was already secured when the folio was added to the swap
cache (a non-contiguous allocation would have split the folio earlier),
so the PMD can be replaced by a single PMD-level swap entry instead.

This patch mirrors the existing PTE swap-out path at PMD granularity:
- shrink_folio_list() drops TTU_SPLIT_HUGE_PMD for PMD-mappable
  swapcache folios. zswap is handled by the PMD swap-in users: if any
  covered slot currently has a zswap entry, they split the PMD swap
  entry and fall back to the per-PTE path.
- try_to_unmap_one() now has a PMD branch that calls
  set_pmd_swap_entry() and adjusts MM_ANONPAGES / MM_SWAPENTS by
  HPAGE_PMD_NR before walk_done. TTU_SPLIT_HUGE_PMD remains the
  fallback.
- set_pmd_swap_entry() is the installer. Mirroring the PTE swap-out
  sequence at PMD granularity, it clears the present mapping (keeping
  the original for rollback), bumps the swap_map refcount for the
  folio's 512 slots, transfers the exclusive state in the swap entry,
  propagates the dirty bit to the folio so writeback is not lost,
  and installs a swap PMD that preserves the original
  soft-dirty / uffd-wp / exclusive bits. Any failing step rolls back
  the present mapping.

The swap entry value matches what 512 PTE swap entries would encode, so
swap_map refcounting is unchanged: each of the 512 slots carries a
count of 1, released individually on later split or together on swap-in.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h       |  2 +
 include/linux/vm_event_item.h |  1 +
 mm/huge_memory.c              | 80 +++++++++++++++++++++++++++++++++++
 mm/rmap.c                     | 19 +++++++++
 mm/vmscan.c                   |  9 +++-
 mm/vmstat.c                   |  1 +
 6 files changed, 111 insertions(+), 1 deletion(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b6ab28ff7eee..6d294d446f7b 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -536,6 +536,8 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf);
 
 #ifdef CONFIG_THP_SWAP
 vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf);
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio);
 #else
 static inline vm_fault_t do_huge_pmd_swap_page(struct vm_fault *vmf)
 {
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..7267c06674c0 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -108,6 +108,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		THP_ZERO_PAGE_ALLOC_FAILED,
 		THP_SWPOUT,
 		THP_SWPOUT_FALLBACK,
+		THP_SWPOUT_PMD,
 #endif
 #ifdef CONFIG_BALLOON
 		BALLOON_INFLATE,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 60f42d136945..2f5c01a043fe 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5544,3 +5544,83 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	trace_remove_migration_pmd(address, pmd_val(pmde));
 }
 #endif
+
+#ifdef CONFIG_THP_SWAP
+/**
+ * set_pmd_swap_entry() - Replace a PMD mapping with a PMD-level swap entry.
+ * @pvmw: Page vma mapped walk context, must have pvmw->pmd set and
+ *        pvmw->pte NULL (i.e. PMD-mapped).
+ * @folio: The folio being swapped out. Must be in the swap cache.
+ *
+ * This installs a PMD-level swap entry in place of a present PMD mapping,
+ * avoiding the need to split the PMD into PTE-level swap entries.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int set_pmd_swap_entry(struct page_vma_mapped_walk *pvmw,
+		       struct folio *folio)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address = pvmw->address;
+	unsigned long haddr = address & HPAGE_PMD_MASK;
+	struct page *page = folio_page(folio, 0);
+	bool anon_exclusive;
+	pmd_t pmdval;
+	swp_entry_t entry;
+	pmd_t pmdswp;
+
+	if (!(pvmw->pmd && !pvmw->pte))
+		return 0;
+
+	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
+
+	if (unlikely(folio_test_swapbacked(folio) !=
+			folio_test_swapcache(folio))) {
+		WARN_ON_ONCE(1);
+		return -EBUSY;
+	}
+
+	flush_cache_range(vma, haddr, haddr + HPAGE_PMD_SIZE);
+
+	pmdval = pmdp_invalidate(vma, haddr, pvmw->pmd);
+
+	/* Update high watermark before we lower rss */
+	update_hiwater_rss(mm);
+
+	if (folio_dup_swap(folio, NULL) < 0) {
+		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
+		return -ENOMEM;
+	}
+
+	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
+	anon_exclusive = PageAnonExclusive(page);
+	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
+		folio_put_swap(folio, NULL);
+		set_pmd_at(mm, haddr, pvmw->pmd, pmdval);
+		return -EBUSY;
+	}
+
+	mm_prepare_for_swap_entries(mm);
+
+	if (pmd_dirty(pmdval))
+		folio_mark_dirty(folio);
+
+	entry = folio->swap;
+	pmdswp = softleaf_to_pmd(entry);
+	if (pmd_soft_dirty(pmdval))
+		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
+	if (pmd_uffd(pmdval))
+		pmdswp = pmd_swp_mkuffd(pmdswp);
+	if (anon_exclusive)
+		pmdswp = pmd_swp_mkexclusive(pmdswp);
+	set_pmd_at(mm, haddr, pvmw->pmd, pmdswp);
+
+	folio_remove_rmap_pmd(folio, page, vma);
+	folio_put(folio);
+
+	count_vm_event(THP_SWPOUT_PMD);
+	return 0;
+}
+#endif /* CONFIG_THP_SWAP */
diff --git a/mm/rmap.c b/mm/rmap.c
index e854679553b9..b431d52cc2e3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2079,6 +2079,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto walk_abort;
 			}
 
+#ifdef CONFIG_THP_SWAP
+			/*
+			 * If the folio is in the swap cache and we're not
+			 * asked to split, install a PMD-level swap entry.
+			 */
+			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
+			    folio_test_anon(folio) &&
+			    folio_test_swapcache(folio)) {
+				if (set_pmd_swap_entry(&pvmw, folio))
+					goto walk_abort;
+
+				add_mm_counter(mm, MM_ANONPAGES,
+					       -HPAGE_PMD_NR);
+				add_mm_counter(mm, MM_SWAPENTS,
+					       HPAGE_PMD_NR);
+				goto walk_done;
+			}
+#endif
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				/*
 				 * We temporarily have to drop the PTL and
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 986dde8e7429..ffc72a2f635b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1322,7 +1322,14 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = folio_test_swapbacked(folio);
 
-			if (folio_test_pmd_mappable(folio))
+			/*
+			 * With THP_SWAP, PMD-mappable folios already in the
+			 * swap cache can be unmapped with a PMD-level swap
+			 * entry, avoiding the cost of splitting the PMD.
+			 */
+			if (folio_test_pmd_mappable(folio) &&
+			    !(IS_ENABLED(CONFIG_THP_SWAP) &&
+			      folio_test_swapcache(folio)))
 				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
 			 * Without TTU_SYNC, try_to_unmap will only begin to
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3b5cb1031f72..08af18f2b4dc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1422,6 +1422,7 @@ const char * const vmstat_text[] = {
 	[I(THP_ZERO_PAGE_ALLOC_FAILED)]		= "thp_zero_page_alloc_failed",
 	[I(THP_SWPOUT)]				= "thp_swpout",
 	[I(THP_SWPOUT_FALLBACK)]		= "thp_swpout_fallback",
+	[I(THP_SWPOUT_PMD)]			= "thp_swpout_pmd",
 #endif
 #ifdef CONFIG_BALLOON
 	[I(BALLOON_INFLATE)]			= "balloon_inflate",
-- 
2.53.0-Meta


