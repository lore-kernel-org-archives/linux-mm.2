Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197D0C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC9C6B00C8; Tue,  1 Sep 2026 01:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283CC6B00CA; Tue,  1 Sep 2026 01:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199C66B00CB; Tue,  1 Sep 2026 01:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E06AD6B00C8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71B78C0316
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:28 +0000 (UTC)
X-FDA: 85164103416.14.27F5536
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A267140008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BK9TIEMF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQezC7K4iz5Mxn27Y4x6zgLYvTxf7QSTeeQh5sepn3o=;
	b=gowJW/SwUn0luLpd/rCstE2Zb1IJtqql0y4ocNvHkXt5vb2HrWDXlNdOrwbayuzKvlgKNx
	G8SusbWLaMzkyeUkjFuW9/8VU9fZgJmRqu0AGvafB2uJTeI42c0y0qv/rYFMvaKSS5VDMq
	Fl2CbUW3c56qi/H0t/EY0LXYnMuXbrY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=BK9TIEMF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241466;
	b=tOcWrt2cU1dcGS0gyEtcBvvFQ8MU3up0UEWt93XCPkO/D14JgDCTkNFqlu8k1qrXEmK9Wy
	3hpdvhBh53ujR/GxqMY5qRdy0RXK4V8jZQ9FzH8M3b0AThTGvXDwd2McmUjchdSZu7IW/R
	bxweg5+27rhNY8YVl4SAkhJxU7jsI98=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D70491756;
	Mon, 31 Aug 2026 22:44:21 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BF7153F85F;
	Mon, 31 Aug 2026 22:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241465; bh=E2ktIYiViPu9MnUaU8AeLIAVoGUmKFh4+m0Y1CBWS4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK9TIEMFCOEDM5tAyRTeOzg/0PPizZCgEpvn0On2eINATQ6RHoSeKLHTLRcmI4NGk
	 VhIdCsAPgy2d2/fwOlTLKYpkwDAU69IXATxDssn/+V06oTCebY6DuU/YpX58ZU42MQ
	 nYHTpOmHVwtSvuD0jemjfqhEb5b0A9nwHPq1z2Dk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 2/8] mm/swapfile: add batched version of folio_put_swap
Date: Tue,  1 Sep 2026 05:43:49 +0000
Message-ID: <20260901054358.4049095-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A267140008
X-Stat-Signature: riw65bo93zwap7au9n8ixznzb1hs5h8o
X-Rspam-User: 
X-HE-Tag: 1788241466-223792
X-HE-Meta: U2FsdGVkX18HhAPlOHlkYFNuoHp0niBoeficvNlDFxqprCB9KLF7pW0/8WB8PQycdINc1ME8LnoiECWr2XX6OLmVCySlSAiIwPd5QvqU8uytBkKhLi0SoiQMr6bhnHDSweZ+q2FdpUCPi1Usxzk5otsCRDNBb4U4c9QXZ3JrJDr8W4aVLfVD73sUUfnus45VP2zgEARm4cXjhVgpZ8WWtQrXFzMUq74xslyRdKgLahKScvDwiw4+wNmtcHb0LeBQOhzS9ebtUojYdiPOlj80wC8uhH19tjqaJQDeuSoeC6aYwQrJfA709axHGJqyUTPpckXNlJbBAXMnai9Hb0WUjka1Jw63b/nWHttZPOSj/1jNoidd/yufPdGPY280Ks6ZFqCcoklkQXsdCV2AziE7mjBSamkp7oCp2k+xMW7McE2irrSdO0Yt7/7LEiYzYZe9r/fqz/TaJHFqEdqFRqbeFc5cM43eVc2CKImkkwGn+aQVjT8DmSleLLD4xUzZ+CTtonsrY2csNp+ykFFcZPfBvc+btazZh7HVkgqq/bc52hHFN/QiDtNna6HiGXPgzHcRsbY0EUf3glayqqA5tVoJc0qODEptKAMKJ9P/oOQcZH4eY1Q5M6ox0ovM2O+rVK+syzbjBaTroOq3GpnCHOz59Hq//E2W+FeLNyWxnkeUdhfcsawFhVrvjW0+0oN79ZkJdi0NPBtYIv0xhisKJJgdqJ/72PS6YfOUMVI1St6i0zIGXVdB80bMSwgyqVZQmZZQNssXTRDju06GmHY6D04dIrKpa2hOr4W/xIasjwlPSbZOI8wvTuxqNnuzAQrsLpwpkPL570vKEe0CEZVj9zjzEUzTekGgo65u9F9O6JlQDwxeKWZEpXKVP5kBI2ObYuXA+ESXFxWdsT+mLTwdStEtS1Wut6sLpQUMlCAW0mirFXUpc3q4/87cLBVcwX72lKimeZ2KM3qySAhy7RJxgw+
 KljBDQw6
 2sWQfeGCHH4MmhC20Cu99gvW2y3qFJne+5fXVtNNarL88n2xFRgHZT2g00m3ZgjgJ5QDHqNhWI7nPlnSTPgleXzNUgcn3ng30N6GLo+BPKSU5u3Dw7F+HpEbOR07YhPv08apXfZ9C7/Bf86MaGmfO3iP1Z0gEZxmpXwE3IsBi3OzNh8asAo0p8q/y25aokRsNy0x/qNmZ2wITwaZ2HbrFS9ye7mP58JUo0DEjgC58hHuS4EcC1xqgzzGFZs+2ybLgpbG8dlkIC/RoKc91qbGCxjwE7g2PXkpIDvCIZ63avdszpjyfOauOrXoT6F4JVdn+uMtq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_put_swap_pages to handle a batch of consecutive pages. Note
that folio_put_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection: the caller invokes folio_put_swap_pages() if it wants to
operate on a range of pages in the folio (i.e nr_pages may be anything
between 1 and folio_nr_pages()), and invokes folio_put_swap() if it
wants to operate on the entire folio.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/memory.c   |  6 +++---
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     | 17 +++++++++++++++--
 mm/swapfile.c | 19 ++++++++++---------
 5 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3de..6cfea4faf0588 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5202,7 +5202,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5211,12 +5211,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
 		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
-		folio_put_swap(folio, NULL);
+		folio_put_swap(folio);
 	} else {
 		VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					 rmap_flags);
-		folio_put_swap(folio, nr_pages == 1 ? page : NULL);
+		folio_put_swap_pages(folio, page, nr_pages);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
diff --git a/mm/rmap.c b/mm/rmap.c
index 0a4aa06b66de6..1b9f07d4d1be9 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2157,13 +2157,13 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	 * so we'll not check/care.
 	 */
 	if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-		folio_put_swap(folio, page);
+		folio_put_swap_pages(folio, page, 1);
 		return false;
 	}
 
 	/* See folio_try_share_anon_rmap(): clear PTE first. */
 	if (anon_exclusive && folio_try_share_anon_rmap_pte(folio, page)) {
-		folio_put_swap(folio, page);
+		folio_put_swap_pages(folio, page, 1);
 		return false;
 	}
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 6cea018d69f04..316bf14136d63 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1733,7 +1733,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 
 		/*
@@ -2163,7 +2163,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2393,7 +2393,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index f52ecbedae8b8..0e0d00bf4daa6 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -246,7 +246,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap_pages(struct folio *folio, struct page *page,
 		unsigned long nr_pages);
-void folio_put_swap(struct folio *folio, struct page *page);
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -375,7 +376,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 }
 
@@ -477,6 +479,17 @@ static inline int folio_dup_swap(struct folio *folio)
 				    folio_nr_pages(folio));
 }
 
+/**
+ * folio_put_swap() - Decrease swap count of all swap entries of a folio.
+ * @folio: folio with swap entries bound.
+ *
+ * See folio_put_swap_pages() for more information.
+ */
+static inline void folio_put_swap(struct folio *folio)
+{
+	folio_put_swap_pages(folio, folio_page(folio, 0), folio_nr_pages(folio));
+}
+
 extern const struct swap_ops swap_bdev_ops;
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 25bb6fc562c57..da5e66bdcef10 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1819,27 +1819,27 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
 }
 
 /**
- * folio_put_swap() - Decrease swap count of swap entries of a folio.
+ * folio_put_swap_pages() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @page: if not NULL, only decrease the swap count of this page.
+ * @page: the first page in the folio to decrease the swap count for.
+ * @nr_pages: the number of pages in the folio to decrease the swap count for.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *page)
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	unsigned long idx = folio_page_idx(folio, page);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
+	VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
 
-	if (page) {
-		entry.val += folio_page_idx(folio, page);
-		nr_pages = 1;
-	}
+	entry.val += idx;
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
@@ -2518,7 +2518,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
+	folio_put_swap_pages(swapcache,
+			     folio_file_page(swapcache, swp_offset(entry)), 1);
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
-- 
2.43.0


