Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D812C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12BF06B00BC; Fri,  3 Jul 2026 13:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DC8C6B00BD; Fri,  3 Jul 2026 13:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98076B00BE; Fri,  3 Jul 2026 13:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0BFD6B00BC
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4592312024F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:46 +0000 (UTC)
X-FDA: 84948177972.20.E2DD7B3
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id AAC2CC000E
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:39:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Csp+YJIC;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783100384;
	b=mbXO0C6BeKztpOuKJ5InyRv6lNwi3QXvE2J7e4BgZYdEGo4/JRyC2r+QOZNyJobmBBQ6gt
	zDSmybKJhREyNcBCVzS70M6f9tTlxIAWYlGFl9Yf/MR00YfZhqiHLN3d8QdFFqmXzFMGEU
	U7f4zyr5iPQUhV2+LCtactPtK7cHoHs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783100384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ty8Zab+PurnWFMjvtnuezE+LvfMhZMLOzuocy84baZI=;
	b=grzhJkF+1gpQD056/ROZ+RKT7pPsHro612mGuVj5idklLEmOHVfG4Y9AXJWcAEVSj46xjv
	AuUnflD7ugJiq+brLjzeS002xE2pp21Y98mdYifi6gO163XxQ1ZxhREakJqPagP+POtEWD
	UYlvb5uW0q7bPUyWI5MTXZI/mhOny8I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Csp+YJIC;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783100383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ty8Zab+PurnWFMjvtnuezE+LvfMhZMLOzuocy84baZI=;
	b=Csp+YJIC4c4lBHxRE2sRFnlRFsuVCzEDiXj++QsNpb5IfWbgUD/AIZRiN+3vLLQK2W/Djp
	2+Y/RkX/uE1n1oEeDuzHrqJ+9nvJ9yQQquvcUDKFSGCJ/sVNR0XCtPTu8lAQNzw7bBcAAj
	DjnEG1PmEUCaQNQDXuC9BtvecLs5zlg=
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 05/11] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Fri,  3 Jul 2026 10:38:22 -0700
Message-ID: <20260703173903.3789516-6-usama.arif@linux.dev>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: fr8sfg9kb4rggko8ndzy3ijnhx7pb55f
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AAC2CC000E
X-HE-Tag: 1783100384-979990
X-HE-Meta: U2FsdGVkX1+tMgcCreES2wDALCjje8yuw3mRVwnonGQ6tqTGR7WP2yMde58ww8smrj5a9SjmaxxdDo1CCTQClwD7j8kpdV2IaR9H/B0AP/+r5pV1BcbiWe/mOnDOe01g5FujYOvNtYDu416gVeitj0FuG1ozwWR7MasIGPP/Nidw3UPAmTOfUhkQf6Pm8/NRAHXoCa24NrZ4F2udyTrbuxxsI1bMYoeIQ5DuBpsFFeixZ854Yz2miotzWiqW0Vqd375TmKQWKpGSuFLmhlasvCk7XrC8n0t6g0ehRpMb9I+qej8fy7JSQPQUJVKuVtmzFNOSprL9DtbkAWyGF/YaxK15vZWo2U6oXeFx0MauBxmj6vZa9rYz/VQuSeI/wl77BUsT6c7uop2R3w3Xz3ONXJsolI1tpcv1YKBCDyyfA2RVIQS22VEXi/sKXTkvy/lt2s818jzQmWR3wENu/1JDoudkF2ZV3gr4gWdlSOiUdoFIGNj+Ab7sunR1zompxOhy2itkFNQnxAfXeRSWyHdRAHYSm9Ui+z4zo2d/kiL9NW7qGXsp36lqIJPPuPeDg/kEVwHXdkyjyXnQ9vVRov12IQnB0QUfxUgsEJAtRm/Wy5QZS+E/nWtEFDV9lMW/AEWdDbygaTgTELJgsJO5p/iETvSHCNAQgbTvHuG/lxmeyGDwlZbb4VbWzq6J9sVzeU/COZa9xchIQ5y/vzItN28Ub0OpSHx+rZ4Rf5tjx4CzzK1cHaYzvayGdd62P6bEgrm6lJATG8gd5VhefR1Hp6kXfyzx0HS/Z8ktnrsPgZUtWZyhiIvnvMyf3XLJZjrwjN/DQ3OHaT5EsoHZa+i2VJSkdZTU3zeH/Xc7Ck9v+Xe2nF3lQW3Zg0Du0KgY9jWuJ7iu+weFOFcOsJDKJiHfJxRBO/oVoFXJsKoCZPvBLrENlEJcTAx252pFdluZBrddkBS//mcFDRKxpBHBVhVCqXF
 XT71iFn6
 6oEjcDhwcTbNMDbY81CErr0/9i9L1glOLdyVESwZifVp5Szebq4GBeoukzG7qdx+NjUCnIuZr1zQDv11yN5uMCLKhxd29I2CZn6LzeXlZUVOCK87ka8jzO0Uqx3dneaq1uxzIddxauiKSHvfHTHq8rHeK5jcJa0br7ewVKov+PpExq5jY75a1QWA7cCTMIWphBA42zsYZhzLnHkw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add swap_pmd_cache_lookup() to classify the swap cache behind a PMD
swap entry as empty, backed by one PMD-sized folio, or requiring
per-page handling because at least one covered slot has a smaller folio
in the swap cache.  PMD swap entries are handled at PMD granularity only
while the covered cache range is empty or backed by a PMD-sized folio;
a split cache forces the entry to be split and retried through the PTE
path.

Add unuse_pmd() and call it from unuse_pmd_range() to swap in
PMD-level swap entries as whole THPs during swapoff.  This mirrors
the existing unuse_pte_range() but operates at PMD granularity.

If the PMD-order folio cannot be allocated, the swap cache already
contains per-page folios in the covered range (e.g. split in the swap
cache by deferred_split_scan() or memory_failure() while the PMD swap
entry was installed), or the folio is not uptodate, the PMD swap entry
is split into PTE-level entries via __split_huge_pmd() and a non-zero
error is returned so unuse_pmd_range() falls through to
unuse_pte_range(), which handles the individual entries at order-0.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap.h       |  17 ++++++
 mm/swap_state.c |  44 ++++++++++++++
 mm/swapfile.c   | 154 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 215 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index 44ab8e1e595b..17c2c57e0da4 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -303,6 +303,23 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
 bool swap_cache_has_folio(swp_entry_t entry);
 struct folio *swap_cache_get_folio(swp_entry_t entry);
 void *swap_cache_get_shadow(swp_entry_t entry);
+enum swap_pmd_cache {
+	SWAP_PMD_CACHE_EMPTY,
+	SWAP_PMD_CACHE_HUGE,
+	SWAP_PMD_CACHE_SPLIT,
+};
+
+#ifdef CONFIG_THP_SWAP
+enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+					  struct folio **foliop);
+#else
+static inline enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+							struct folio **foliop)
+{
+	*foliop = NULL;
+	return SWAP_PMD_CACHE_EMPTY;
+}
+#endif
 void swap_cache_del_folio(struct folio *folio);
 struct folio *swap_cache_alloc_folio(swp_entry_t target_entry, gfp_t gfp_mask,
 				     unsigned long orders, struct vm_fault *vmf,
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 6fd6e3415b71..9b9ca82ace4b 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -118,6 +118,50 @@ bool swap_cache_has_folio(swp_entry_t entry)
 	return swp_tb_is_folio(swp_tb);
 }
 
+#ifdef CONFIG_THP_SWAP
+/**
+ * swap_pmd_cache_lookup - classify the swap cache behind a PMD swap entry
+ * @entry: first swap slot encoded by the PMD swap entry
+ * @foliop: returned PMD-sized folio, with a reference, if present
+ *
+ * A PMD swap entry is a compact page-table encoding for HPAGE_PMD_NR
+ * consecutive swap slots. The swap cache behind those slots can be empty,
+ * one PMD-sized folio, or per-slot folios after the original folio was split.
+ *
+ * Context: Caller must keep @entry valid using the usual swap cache rules.
+ * Return: SWAP_PMD_CACHE_EMPTY if no slot in the PMD range has a cached folio,
+ * SWAP_PMD_CACHE_HUGE if one PMD-sized folio covers the range, or
+ * SWAP_PMD_CACHE_SPLIT if the range needs per-page handling.
+ */
+enum swap_pmd_cache swap_pmd_cache_lookup(swp_entry_t entry,
+					  struct folio **foliop)
+{
+	unsigned int type = swp_type(entry);
+	pgoff_t offset = swp_offset(entry);
+	struct folio *folio;
+	int i;
+
+	*foliop = NULL;
+
+	folio = swap_cache_get_folio(entry);
+	if (folio) {
+		if (folio_nr_pages(folio) == HPAGE_PMD_NR) {
+			*foliop = folio;
+			return SWAP_PMD_CACHE_HUGE;
+		}
+		folio_put(folio);
+		return SWAP_PMD_CACHE_SPLIT;
+	}
+
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
+		if (swap_cache_has_folio(swp_entry(type, offset + i)))
+			return SWAP_PMD_CACHE_SPLIT;
+	}
+
+	return SWAP_PMD_CACHE_EMPTY;
+}
+#endif
+
 /**
  * swap_cache_get_shadow - Looks up a shadow in the swap cache.
  * @entry: swap entry used for the lookup.
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0695dbd1a8b1..664956da60c8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/huge_mm.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -2641,6 +2642,147 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	return 0;
 }
 
+/*
+ * unuse_pmd - Map a locked folio at PMD granularity during swapoff.
+ *
+ * The caller provides a locked, swapped-in folio.  Returns 0 on success
+ * (PMD was mapped).  Returns -EAGAIN if the swap cache folio no longer
+ * matches the entry or the PMD changed under the lock (try_to_unuse will
+ * rescan).  Returns -EIO if the folio is not uptodate; in that case the
+ * PMD is split so unuse_pte_range() can handle individual pages.
+ */
+static int unuse_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		     unsigned long addr, softleaf_t entry,
+		     struct folio *folio)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page;
+	pmd_t new_pmd, old_pmd;
+	spinlock_t *ptl;
+	rmap_t rmap_flags = RMAP_NONE;
+	bool exclusive;
+
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		return -EAGAIN;
+
+	if (unlikely(!folio_test_uptodate(folio))) {
+		__split_huge_pmd(vma, pmd, addr, false);
+		return -EIO;
+	}
+
+	page = folio_page(folio, 0);
+
+	ptl = pmd_lock(mm, pmd);
+	old_pmd = pmdp_get(pmd);
+
+	if (!pmd_is_swap_entry(old_pmd) ||
+	    softleaf_from_pmd(old_pmd).val != entry.val) {
+		spin_unlock(ptl);
+		return -EAGAIN;
+	}
+
+	exclusive = pmd_swp_exclusive(old_pmd);
+
+	/*
+	 * Some architectures may have to restore extra metadata to the folio
+	 * when reading from swap. This metadata may be indexed by swap entry
+	 * so this must be called before folio_put_swap().
+	 */
+	arch_swap_restore(folio_swap(entry, folio), folio);
+
+	add_mm_counter(mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+
+	new_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
+	new_pmd = pmd_mkold(new_pmd);
+	if (pmd_swp_soft_dirty(old_pmd))
+		new_pmd = pmd_mksoft_dirty(new_pmd);
+	if (pmd_swp_uffd_wp(old_pmd))
+		new_pmd = pmd_mkuffd_wp(new_pmd);
+
+	if (exclusive)
+		rmap_flags |= RMAP_EXCLUSIVE;
+
+	folio_get(folio);
+	if (!folio_test_anon(folio))
+		folio_add_new_anon_rmap(folio, vma, addr, rmap_flags);
+	else
+		folio_add_anon_rmap_pmd(folio, page, vma, addr, rmap_flags);
+
+	set_pmd_at(mm, addr, pmd, new_pmd);
+	folio_put_swap(folio, NULL);
+
+	spin_unlock(ptl);
+
+	folio_free_swap(folio);
+	return 0;
+}
+
+/*
+ * Try to swap in a PMD swap entry as a whole THP. Returns 0 on success.
+ * If the swap cache no longer has one PMD-sized folio, zswap may require
+ * per-page loading, or a PMD-order allocation/read fails, split the PMD so
+ * the caller can fall back to unuse_pte_range(). Otherwise propagates the
+ * error from unuse_pmd().
+ */
+static int unuse_pmd_entry(struct vm_area_struct *vma, pmd_t *pmd,
+			   unsigned long addr, softleaf_t entry)
+{
+	struct folio *folio;
+	enum swap_pmd_cache cache_state;
+	int ret;
+
+	cache_state = swap_pmd_cache_lookup(entry, &folio);
+	if (cache_state == SWAP_PMD_CACHE_SPLIT) {
+		ret = -EAGAIN;
+		goto split_fallback;
+	}
+	if (!folio) {
+		struct vm_fault vmf = {
+			.vma = vma,
+			.address = addr,
+			.real_address = addr,
+			.pmd = pmd,
+		};
+
+		if (zswap_range_has_entry(entry, HPAGE_PMD_NR)) {
+			ret = -EAGAIN;
+			goto split_fallback;
+		}
+
+		folio = swapin_sync(entry, GFP_HIGHUSER_MOVABLE,
+				    BIT(HPAGE_PMD_ORDER), &vmf, NULL, 0);
+		if (IS_ERR_OR_NULL(folio)) {
+			ret = folio ? PTR_ERR(folio) : -ENOMEM;
+			goto split_fallback;
+		}
+	}
+
+	folio_lock(folio);
+	folio_wait_writeback(folio);
+	/*
+	 * If the cached folio is no longer PMD-sized (e.g. split in the
+	 * swap cache by deferred_split_scan() or memory_failure() while
+	 * the PMD swap entry was installed), the PMD swap entry no longer
+	 * maps a single contiguous folio.  Split the PMD swap entry so
+	 * unuse_pte_range() can swap the per-slot folios in individually.
+	 */
+	if (folio_nr_pages(folio) != HPAGE_PMD_NR) {
+		folio_unlock(folio);
+		folio_put(folio);
+		ret = -EAGAIN;
+		goto split_fallback;
+	}
+	ret = unuse_pmd(vma, pmd, addr, entry, folio);
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+
+split_fallback:
+	__split_huge_pmd(vma, pmd, addr, false);
+	return ret;
+}
+
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				unsigned int type)
@@ -2653,6 +2795,18 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	do {
 		cond_resched();
 		next = pmd_addr_end(addr, end);
+
+		pmd_t pmdval = pmdp_get(pmd);
+
+		if (pmd_is_swap_entry(pmdval)) {
+			softleaf_t sl = softleaf_from_pmd(pmdval);
+
+			if (swp_type(sl) == type) {
+				if (!unuse_pmd_entry(vma, pmd, addr, sl))
+					continue;
+			}
+		}
+
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
-- 
2.53.0-Meta


