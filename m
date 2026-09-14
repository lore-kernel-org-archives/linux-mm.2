Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F23C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABFF6B00AC; Mon, 14 Sep 2026 08:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37096B00AD; Mon, 14 Sep 2026 08:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D85D6B00AE; Mon, 14 Sep 2026 08:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 788506B00AC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:40 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FCAC803ED
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:40 +0000 (UTC)
X-FDA: 85212303960.03.338BB59
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	by imf31.hostedemail.com (Postfix) with ESMTP id 186A42000E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6EHoH7p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389098;
	b=2EkNnp16IuGqdgMo45XllxNPzBB1brFbGynh+BojX19XUo2lNi3JrLdBDmlLTPF6+oRm4N
	K5CalCWjRXopDZy6p4JhPMt/fFC+df4Dfzo94id3H1aLfzIUC3YbdooUoIUhOxhkD68zkd
	Wk0Q+GbufccfKYBfBXfsY+djDomPWyU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6EHoH7p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zO7TQ52N1wnPDuTBG70fmkA1X7e6HBVZEl4FId2i/TA=;
	b=DjbBhBcnXtrD+A76Q1a0qoQ2brwodJ1N1OleDGAyRuUYZrTiNnmSjnmXy1qU9siOH2ZVa8
	5ytkAxutt4Ugu6JWXeDWKXrzBRtzynCTvoTw8fdlbRMaARNsNpS6K2dAmoGMmjV6OPfFlP
	x256V8ZZpCXvIG4L0R7dP/U2FEPAx2Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UU6mVmZlzcFG6qUy1vyDg8aJu6LdyzlIdDsmwZMkMj8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389096; v=1; x=1789993896;
 b=O6EHoH7pRvuIjxe4PppDjtKeoe0dpKCsoIb5QebHiC06IP5fPdXyibiFLIQVSEMGlTKt8zV0
 b5NjnMI1OGn6+sSV5s+01qIVIaCKl6/ta0ZDoJ26c9QHf4frxLMrB9oEu4tKMW1kbLoz4IWLwrl
 HlQXCDHhSMSS3BIG3s6znnmY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 32f750c12cce9baf;
	Mon, 14 Sep 2026 12:31:36 +0000
X-Mizu-Trace-ID: 32f750c12cce9baf
X-Migadu-Flow: FLOW_OUT
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
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 14/29] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Mon, 14 Sep 2026 05:28:04 -0700
Message-ID: <20260914122950.3283997-15-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 186A42000E
X-Stat-Signature: 3mor8f7f3qjeqagka9afr5ohwozfu3so
X-HE-Tag: 1789389097-465156
X-HE-Meta: U2FsdGVkX1997/3u7uctOZA+9hi8Eil/maNLxNVJTORbjVifo1FzUVq0f3TQDX4QY1QpogeVr2OrrBbEa+KNl5CsAME6d5ALcQX5CbRKhwLJnLZqXV98YhRBdTDFsrPmVJFoZuKw5lau/lbpRk/zB6q1LbdnkDlPojiIrnT+BWOgiTgXjJeHs38VjcwKUYLWBrpFKjqAeh1FYqsn/J36UQEqB2borZczPHAuoDUln7JvtxLnrpRDmhAbHGGy0rCTrUmGdKiqQCS/u3jdaWYuH/IdQPZNqHWcbhzIcem+GyJ73fV5hVU7dpa11ZqH0bUfJ7MXHVDibCUNAWpT9NXdyKUFg3/4/+bsHojr4rqjQuxZ98oj658tdGEOekhC+XIcCGU+OE5+4qO2UWAZ0VMWQq1EnP5HBj7u+77fM431fD6D2jwqPqnBSjy1EXKBPNA2gWvaAXbglsApGPmP/PrihKPc/3RGD1D1JanJZyD/yibdORclK52f3aBDf13JoeA7HTEWU20OSzyiB2k1xn781PZkfItnN7ISpOkOWpnhKiLvstz2aFA0+BJqmC7Ka6HpgkuIcnUXyhSYWRW3vzdZwkRE6gR3kkKBQR8K+yNrK3954e0fNvmECZrg9V2komotQAo88HAB2mem9F1Uq0KECH96HN3jbm59RUiKgIttgRKE5aPRkbmUYlQT0jNnQDQ10uIa7qPCNPrVhBJKU9Lrn28kazt0zZ7XjSOYiDZ5HAexTrVidenomRmQ7MjEOJopjYOmFYI2Gh77OKJSHR1yJsmd2OtwAA3rlenbMKnb9l+W3MVMdBR0SXY8RETomK7pdxZ28zeY3uFmTZ46nDoQhL/pBSxw3ZXI8ZAKj/qimkLGJ1oe/sMS1dGAOEYb+8RiGX49Hqi+8oLgohIr+3kDgRa8IONsi48wGvaNiRV138Sda/5Ced8EGs8ek14IRdJSWV4yDeptgOAiYOOmZsZ
 hD8xxVUn
 oejWNbNaQqEgdiLO2Ow7LE673qGRK1Kq54hUTjcXgtKCVLJk8wkEs2U6Tilt+7K9+V9cOMR+YNN7ZdTndwdIafDIVqtlTwX2A335z9q0pxVrPYH7Y1vddnu8mjqfaVHW3xJAjnDtdEq36HV4FSJOdYneN8K6zEpwydSwELcCtWsJNoQMBw7uOF1s5YaoxKb1KtMp8hbKj3N0S4/pCinlTZPCVBUdOACHu0ZnqjNC3KjIU+SU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swapoff walks every mm and faults every slot of the device back in.
unuse_pte_range() only understands PTEs, so a PMD swap entry would never be
found and swapoff would never complete.

A PMD swap entry is a compact encoding for HPAGE_PMD_NR slots, not a
promise that the swap cache holds one folio for them. Add
swap_pmd_cache_lookup() to classify the covered range as empty, one
PMD-sized folio, or already split, and unuse_pmd() to map the first two
cases back in as one THP, preserving soft-dirty, exclusive and UFFD state.

Everything else falls back to PTEs: a split cache, per-page zswap state, a
failed PMD-order allocation or read, or a poisoned subpage. Check
PageHWPoison on every subpage rather than the folio-level flag, which
memory_failure() only sets after taking the folio lock.

All the fallback reasons are observed without the PMD lock and possibly
after sleeping, so they share one exit that re-checks the PMD is still the
entry we were called for before splitting it. That exit also drops a folio
that is not uptodate, or that has never been mapped, from the swap cache:
the PTE path cannot re-read the first, and would add a single-page rmap to
the second.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/internal.h   |  16 ++++
 mm/swap.h       |  17 +++++
 mm/swap_state.c |  44 +++++++++++
 mm/swapfile.c   | 189 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 266 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 05179c4b2090e..ec7f007bc2c0d 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -24,6 +24,22 @@
 
 struct folio_batch;
 
+/*
+ * Unlike folio_contain_hwpoisoned_page(), this does not rely on the folio-level
+ * PG_has_hwpoisoned, which memory_failure() only sets after taking the folio
+ * lock and so can lag a tail-page poison.
+ */
+static inline bool folio_has_hwpoisoned_subpage(const struct folio *folio)
+{
+	long nr = folio_nr_pages(folio);
+	long i;
+
+	for (i = 0; i < nr; i++)
+		if (PageHWPoison(folio_page(folio, i)))
+			return true;
+	return false;
+}
+
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 			    bool flush);
diff --git a/mm/swap.h b/mm/swap.h
index 2321c9a2c2c58..0b54026f32d6f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -311,6 +311,23 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
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
index 251b48b2c60e1..15f93b9a3eb2a 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -125,6 +125,50 @@ bool swap_cache_has_folio(swp_entry_t entry)
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
index 27ae3964a158e..fe3cadfc3a017 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/huge_mm.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -2696,6 +2697,182 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 	return 0;
 }
 
+#ifdef CONFIG_THP_SWAP
+/*
+ * unuse_pmd - Map a locked folio at PMD granularity during swapoff.
+ *
+ * The caller provides a locked, swapped-in folio.  Returns 0 on success
+ * (PMD was mapped).  Returns -EAGAIN if the swap cache folio no longer
+ * matches the entry or the PMD changed under the lock (try_to_unuse will
+ * rescan). Returns -EIO if the folio is not uptodate or contains a poisoned
+ * subpage; in that case the PMD is split so unuse_pte_range() can handle
+ * individual pages.
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
+	/* Let PTE fallback reread each slot, or isolate the poisoned ones. */
+	if (unlikely(!folio_test_uptodate(folio)))
+		return -EIO;
+	if (unlikely(folio_has_hwpoisoned_subpage(folio)))
+		return -EIO;
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
+	if (pmd_swp_uffd(old_pmd))
+		new_pmd = pmd_mkuffd(new_pmd);
+	if (pmd_swp_uffd(old_pmd) && userfaultfd_rwp(vma))
+		new_pmd = pmd_modify(new_pmd, PAGE_NONE);
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
+	enum swap_pmd_cache cache_state;
+	struct folio *folio;
+	pmd_t pmdval;
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
+		if (zswap_is_present(entry, HPAGE_PMD_NR)) {
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
+	/*
+	 * PTE fallback cannot add a single-page rmap to a newly allocated,
+	 * PMD-sized !anon folio, and it cannot do anything useful with a folio
+	 * that failed to read. Remove either from the swap cache so each slot
+	 * is read back into an order-0 folio. An uptodate anon swap-cache folio
+	 * can be mapped one PTE at a time and must stay cached so poisoned
+	 * subpages remain visible.
+	 */
+	if (ret && folio_matches_swap_entry(folio, entry) &&
+	    (!folio_test_uptodate(folio) || !folio_test_anon(folio)))
+		swap_cache_del_folio(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+	if (ret == -EIO)
+		goto split_fallback;
+	return ret;
+
+split_fallback:
+	/*
+	 * Every reason we get here was observed without the PMD lock and
+	 * possibly after sleeping, so re-check that the PMD is still the entry
+	 * we were called for. A racing fault may already have swapped the range
+	 * back in as a THP, and splitting that would demote it for nothing.
+	 */
+	pmdval = pmdp_get(pmd);
+	if (pmd_is_swap_entry(pmdval) &&
+	    softleaf_from_pmd(pmdval).val == entry.val)
+		__split_huge_pmd(vma, pmd, addr);
+	return ret;
+}
+#else	/* !CONFIG_THP_SWAP */
+static inline int unuse_pmd_entry(struct vm_area_struct *vma, pmd_t *pmd,
+				  unsigned long addr, softleaf_t entry)
+{
+	return -EAGAIN;
+}
+#endif	/* CONFIG_THP_SWAP */
+
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				unsigned int type)
@@ -2706,8 +2883,20 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 
 	pmd = pmd_offset(pud, addr);
 	do {
+		pmd_t pmdval;
+
 		cond_resched();
 		next = pmd_addr_end(addr, end);
+
+		pmdval = pmdp_get(pmd);
+		if (IS_ENABLED(CONFIG_THP_SWAP) && pmd_is_swap_entry(pmdval)) {
+			softleaf_t entry = softleaf_from_pmd(pmdval);
+
+			if (swp_type(entry) == type &&
+			    !unuse_pmd_entry(vma, pmd, addr, entry))
+				continue;
+		}
+
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
-- 
2.53.0-Meta


