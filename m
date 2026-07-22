Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC92C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA1B6B00BD; Wed, 22 Jul 2026 11:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1E86B00BE; Wed, 22 Jul 2026 11:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7B36B00BF; Wed, 22 Jul 2026 11:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 704866B00BD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:21:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F23B51C00FD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:45 +0000 (UTC)
X-FDA: 85016777370.08.67B9BDD
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3F3351A0009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nt6UaRce;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733704;
	b=h31L2k5o7Ogr6SNutLF5eIn5tXeT7/v7N2u0cBHsUe8ftmI1IlHWSMNQTY4HRc5C1Ta48b
	tiunSazaHm07cwaAVR/K9392YT61rsoN0yvOM9l9G4H/ECzG8V6N45PvU6vBKyczVKZipL
	fz6gYTuWxBPNPlU6fomqquD3G3Ut4QM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nt6UaRce;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lsoLL2F1/Prpfz8Vt3I3Nq39ciU7C60PdmTpaDWh4KY=;
	b=sPTR3Q1oQnWJPjCbrIsR5vWQJm1YjiXwOYTG7PS9rqTEjcZGniAT4cATVdg9Y1KHjC4UrT
	Den/gIFlYcyU2r/p1324/SoHSkWG8eRekD8ped2k5viij7sp95f3bMXujcKvu0HNGCt2nG
	Fiv3B1zhOSlAN2onDGMgaNFpo4dSiDw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lsoLL2F1/Prpfz8Vt3I3Nq39ciU7C60PdmTpaDWh4KY=;
	b=nt6UaRceTewFhUyhNRAyyacTOxzNhvYFmFO5EAVS+hX5UhDs0SY38hygRZnpHSdNX35LI8
	xYvj9dz2Z807ozqEqZQRHRirzOTco6uk090e8n/SlXO9h2/Dux93iUWPPF8Akn2VIZfs1g
	7OkEPQnh2pxbR4LYbb9x5smj+FHMe9o=
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
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 05/11] mm: swap in PMD swap entries as whole THPs during swapoff
Date: Wed, 22 Jul 2026 08:19:36 -0700
Message-ID: <20260722152043.2273289-6-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b69tcjp3ubpmxd5e4jdiwsre6ickerm8
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F3351A0009
X-Rspam-User: 
X-HE-Tag: 1784733704-890007
X-HE-Meta: U2FsdGVkX18YMvHWHE5uI5Rr7MuiIMsRI9eYg6KMG9Nr2unNjFPheu/Drrz7r3Z/yMNLlWyu66XZOFVK5JhRht6mHwKWURVUP3acyvVNqYgjJy+Lp6YUZFcz/mj08SKz/FIlOs37aqT8f8dfW8rmhVbHjKYyvJvTiRBzWScDCpTFoY993TbICM6SWZ4JSW9Fqa47zRa9WhE734iZGtoQ+4W8zazC3P3tuSz83iwBgv/TvRaBgd1oMOs1npjKx8Vv/80/tDJmMHruC4CV1HY6nypzUIGpLRi0Q3xwO+vWUTk0OaH/Fe8i4QXr8mWZ72Mn3IGbFRdyFYERJhs6cYZgZYhUAdAt3eUxTyUbpj11nVMbj14I13hwN1zh8dvZ5a/MrWzGOodry9v/lVM/3DZtg5GUzqZn40+EfBO5USupMoZfPNwnzBCX+xqBb8ITrBenShVHNMWvh0CQQWW3YTd6qSgJrPwFhr4HpvS60cR/1ZbSCMxgzcCC+qgv+bN++tK4RdAC83VjFKXeQgBrx99ikyP3QlI0kgplBE4IhMmXpQvt8VbdAHf7ztN1AL0bWLHkAd5xny2Q3wOI68ewGKHpNwV3RT13cuDr1SjijKYcsJoNSt4uBPfxsn82mg+CjPdrmW7SPvZzK53dF9OVwcPujwctidyNE8NWtxzfsnQSXvI53/XGbvu6bOwVdCRg1IzGxyKXN6M+Vm75TLVyr5CoIpQKxm5plAGxFjSxTc724e+CmahVqalD/eHcMfHUg0+k8+sOlzMuQ1f8jwo/ckNmjFdES80W1Jhsb56DXk9YI97MZUBIAg1U2BBJWEMxFBCgW4RWF2pzemGtP5ZJ2fDU0cNMf9XKA3jl+kG1ECXzGKwr86sL/UvdiM08/8vKbY24R+Zpf3cRBX7urjQDtpacfQu4+esLPqBIddArwB+qwWcwHTnp1tPLSH2xthThzLqhunanct/RHMTGG8P4TOm
 2XkHO2xF
 EmTMWEgCWwBAb+PFUgyzAwOYilZn1Xqh2BLcSAqfCtxYAWXbhbej8OWS7oBaGTSd8fXsLx53CYpGobdWZ4Bhr1/yYJnuSiOO+hC2c4mBD7Mwzg5nbvtxpLztufn67wTGpqNeEgdFHolkOtwz7FP9zJk7/I0Z9RKE9ymjkl/SzPlJTwOxzjwo+fKFLHEfeyxY/dbsxpdEvSAnwuJ8=
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
Preserve soft-dirty, exclusive, and UFFD state when installing the
present PMD.  If an RWP VMA has a UFFD-marked swap entry, also restore
PAGE_NONE so the first subsequent access still generates a userfault.

If the PMD-order folio cannot be allocated or read, the swap cache
already contains per-page folios in the covered range (e.g. split in
the swap cache by deferred_split_scan() or memory_failure() while the
PMD swap entry was installed), the folio is not uptodate, or any
subpage is hardware-poisoned, the PMD swap entry is split into
PTE-level entries via __split_huge_pmd() and a non-zero error is
returned so unuse_pmd_range() falls through to unuse_pte_range(),
which handles the individual entries at order-0.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/swap.h       |  17 +++++
 mm/swap_state.c |  44 +++++++++++++
 mm/swapfile.c   | 162 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 223 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index 326bbb7ef831..855e793bf17a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -318,6 +318,23 @@ static inline bool folio_matches_swap_entry(const struct folio *folio,
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
index 5be825911e64..1f08fb522036 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -123,6 +123,50 @@ bool swap_cache_has_folio(swp_entry_t entry)
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
index 1292c6bfe8c0..46f4f4c07bf6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,6 +42,7 @@
 #include <linux/suspend.h>
 #include <linux/zswap.h>
 #include <linux/plist.h>
+#include <linux/huge_mm.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -2663,6 +2664,153 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
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
+	if (unlikely(!folio_test_uptodate(folio) ||
+		     folio_contain_hwpoisoned_page(folio))) {
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
+	folio_unlock(folio);
+	folio_put(folio);
+	return ret;
+
+split_fallback:
+	__split_huge_pmd(vma, pmd, addr, false);
+	return ret;
+}
+#endif
+
 static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 				unsigned long addr, unsigned long end,
 				unsigned int type)
@@ -2675,6 +2823,20 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	do {
 		cond_resched();
 		next = pmd_addr_end(addr, end);
+
+#ifdef CONFIG_THP_SWAP
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
+#endif
+
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)
 			return ret;
-- 
2.53.0-Meta


