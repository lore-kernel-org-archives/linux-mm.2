Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B3EC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82BF26B008C; Thu, 24 Sep 2026 09:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8034C6B0092; Thu, 24 Sep 2026 09:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7197F6B0093; Thu, 24 Sep 2026 09:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42F026B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 873C28034A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:41 +0000 (UTC)
X-FDA: 85248692802.26.95169BD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD9E4C000E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LHgzJ1D+;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VC5avyjU50/7HpkOIjVKcB/9OJvzcsg6W5Pq645BfA=;
	b=wxEuk+SRGc3UaaNAG8RItwHurnkrBjo7FWN4/R5KoFqvQcCy+rbrjegf95jvPxWwi2Hk++
	tc8+59CRUvyxCdsEfOYbWDSeu1rEuwCF5fbXWK4bFzLdMRFxvK0oHicca7U00yrS1RZuF+
	IP4urLmeaBk7JR7PYnnR4zUoDFZ26QU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255499;
	b=eOrtfD1LznYOk6ydD+tstCFF5khAzQhtFYkF8a298z86Fk94boz/mAM3bLqX8pC+cBt1J7
	zk2wlo0AMm3nN+TUIaY7VbS3XZk6pskGSrgzB/feMO+N6JndnDxl+YBMtoQFGMoQNW+d0Y
	8qRYkPU/RmAd3IUvO1gb0Dn6vikAXUc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LHgzJ1D+;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8667C1756;
	Thu, 24 Sep 2026 06:11:35 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E38E13F86F;
	Thu, 24 Sep 2026 06:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255499; bh=r91eES0EP0FmtjnUnc9tQIU8yObnhTUHKWz83dXANF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHgzJ1D+YUx8Zf/vSao78zcMMuId0jb4jC2PGpCdBi+0m7bCpyVpvCW27m/U9+kHG
	 0jgysohKuvpAQbD2MptRuX5aW08iuQ2fZMpCQdb3FfIprMEQRXhTK+voRr85hhrE1i
	 zPAGOgg+yN4NqhDcxIWQNOYQbDZzoFnTCWDmr20w=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 2/9] mm/swapfile: add batched version of folio_put_swap
Date: Thu, 24 Sep 2026 13:09:30 +0000
Message-ID: <20260924131106.1730494-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD9E4C000E
X-Stat-Signature: b98n5popefcj3x654uid43bpt97abguu
X-Rspam-User: 
X-HE-Tag: 1790255499-80532
X-HE-Meta: U2FsdGVkX18ANj5U3YSjW4/KtrPFphGISTvGRRXn1b5ggNt2N3gZMcp+QHqVOUdR8rrLO3vyFWLhm7wRaziZRa63D1YhByq2v8cDA+yKeJbkwsDp/a4wKT/M3495gk/Q0DF5XePt34MCTDn+l7CzQS1DqxIhx38OWNFbDpnG7j/O6Lj2XIHFZOG/3REeGJ5kl8bifiPVg1BnWc+oIJWDjW2NoSOR603Ewb4BxBgebKQoCoII+dT0BbQOyzwVhYbizy1Yhlu+qFtFsB4jf7MuZgLBwDHy9BBcNlrYpiQcFMsdb7BWksMjOWVYvDgW5WYIZS6Oa+UK3NVKdaf2onAvdLKazxKTAJWWhyEDLqLC9gm2/ulF+Y8egjMM/OJS8bOf7E3p5uh2TA2oTGzRpa1yE2FK1Ii4T3l4/Izggd/Cq/6o5VifBfynyftsqIJFfB0OuhaCdmTlGL5RBpDrAktMmCYG9Dy3NHq42OjLeRzaLFhJbmwtItqNyp/xu4cAi3No4FER23atXrUWZDXAeDQJAtp2Eu3D82Yl7cqrIOx6/eZB8mfXixJZrNA6h+fVs5tQw/BRn1mRxZcN7KBdnG24ZkgFDZduSDWh9K9i+K8dwCiyELYRUPxuTdvGuxLOCw0TIDha4ZL9M08HZ0yIuNnON3liIQGlk0r+4C7ZZImLAjhx1unqwOqTAaQ07+3v11YvsQ1LTzQ8JfYGJbQlmv6sFaq+hp26/LUU018h1YOOs/23VtDRDCDzYc6rYeCBas+RSd6L3B8fek7AAP7Bav5mA3C4es5PoMNf8mRAFM2NnF8WncyJK4dbm7LHDv5tGob+7Wbt3wVWwCN6THwABvhjvAQXPYMJe4U/O5e1JVNfdSUpFQ15gTxSjiG/KIuYuGVSB0r/un6vHC1p+ogkIah299HDULeXIZAXs+3AXWRYBGT6IHsG/Pc+TR82h5DOAQs1cAAPwDFHszkwUgok5WM
 TsVNxQEv
 dUSNOEKuUNihAqAjImAocBqfnterPV3ZblXHk+vWHlye0QckdpEOgDQNSu/Ror/76tPyr1u16IxMd6k2xSmgFHsSggYKzqLY2PPa/dy7qpHXPgvZZjTAFmIHxqi0GqkuuwdbGv8ga/KO/T17Bh6Q6JydEutEm9nsumErhIsCfFxiAlIih4jIqDVdkfhw3xxlCtHLaAuIIsX1TkwVj1+/SGRv8YT13AvlTlHNGQR37t/0+aZj01oC0Fpq19wFvvzI6vcw9yM2WeR43tld+9Vmh+gx1WhlH4a2Qi5Aj6mbdlhskHaGDeWZfPAO4/G7++FuqFPwv
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
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c   |  6 +++---
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     | 17 +++++++++++++++--
 mm/swapfile.c | 21 ++++++++++-----------
 5 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 338fce99e7119..a7e979bfc814b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5267,7 +5267,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5276,12 +5276,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index a70dbc8d544e1..fa9fc8374fc26 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2159,13 +2159,13 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
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
index d5bd9506ce500..5f46061c6320c 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1935,7 +1935,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 
 		/*
@@ -2368,7 +2368,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2598,7 +2598,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 47290510de264..7ae915f594034 100644
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
 
@@ -478,6 +480,17 @@ static inline int folio_dup_swap(struct folio *folio)
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
index 75167b8580cc0..8b47e7f1e1931 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1831,27 +1831,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
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
-	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
+	swp_entry_t entry = folio_page_swap_entry(folio, page);
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
+	unsigned long idx = folio_page_idx(folio, page);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
-
-	if (page) {
-		entry = folio_page_swap_entry(folio, page);
-		nr_pages = 1;
-	}
+	VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
@@ -2535,7 +2533,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
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


