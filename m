Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2DF7FCC9D1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5C86B009B; Tue, 10 Mar 2026 03:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28CAA6B009D; Tue, 10 Mar 2026 03:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ACF96B009E; Tue, 10 Mar 2026 03:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0D2CB6B009B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:31:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A89671A051B
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:54 +0000 (UTC)
X-FDA: 84529334148.15.9C8E9F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01F43C0002
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:31:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvYpRvj5+TGn+HTb8Dk89sqCtfLDOSMxC/TcKst43Ho=;
	b=cbmtWwBKW7GWm1TTqSaTtT1ck5DSkgPaEdYByqN3Hfdxl40Co/73sCRliURzDfVl4HJNmn
	twkDV/CbvidwL0fhIi20nxPMal38DvGH+VDfPI4y8oAxa+0P1wUkTXEKYJmmyuPOfo2nNA
	Iny0cSSEQVEc1JyMRrjUVa0oAD8W1ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127913; a=rsa-sha256;
	cv=none;
	b=voIR1rdt1XyD2B9pUrjsPrri1Q+NB/ny7Sp5aEPUxg4izLij0y/pDsB/aZZE5yF8J7wLU+
	AY14xwTADWvN+V07s3E+6HH6Kb1S1c+x2aoZmN7xBKXiTw1hYObk4mbcdXCdpnh0cfEyJ4
	yblXJOCLTJZdoz+1tS/lP7jHgKNy4Jk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C27501BB0;
	Tue, 10 Mar 2026 00:31:45 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 21F903F73B;
	Tue, 10 Mar 2026 00:31:42 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
Date: Tue, 10 Mar 2026 13:00:11 +0530
Message-Id: <20260310073013.4069309-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 01F43C0002
X-Stat-Signature: p47qhcsntqxm3sqsxzup79w8sb7qmrmw
X-Rspam-User: 
X-HE-Tag: 1773127912-569317
X-HE-Meta: U2FsdGVkX1+of+4s+EloApB5hVI+1XwsBZxkhnzfr0g5eKcDAPuzfl2mb3l9tWBfgTS6NAC3trZVTFw3wIqjydHih5yBgMyXel/1etrSXV8Lk/cXe7UFgrqamJepaQoyHOUufaWHfKWDBmuASatA+BLwyKOzo3rowIpYI4Vemoaf6O5VY0s/ZHLRVBfwaITkOSKtYgM/PUL/GAKVxfSERjP2tEt3TTu5WPasq6hIst0cOiQ6qMU9VR7e8Rc/eB50sEulDXGF438E9okavYpvc0iWNW2Jw8h0EBwHEym7eCQeCbOQqILqBgBesrLeHyzzb5mpRQAlrQar2Rv9CROBZu4MWP9NfT0/FjqK5bgiKyVvHWc8pKG0n+LYkMmwJPkaQA0aBi9DkJ9S686CZ/1e7JR06AiiDO0BYa2Uz93GqAJqJMOfC8RhE1Y9rWFVCWqZSR/eT51p8EUUN7TCnwz1s1RLVhFfpdvy/ELzwWML0fTHb6994u923+DaRyEeLXJ8qmTcYPUJ0bOSDtNW7EqKrvmXEtS0z/2EtJG4DQOVFsmmSHCEVYwcZBKbe7acQ3Jm7YMUj/NYlger8o77tAyzChNwO4Ac5K6uNSur8OgTbvn/X1yVduWBvfWVZa9Z/ota6dIW5jrqiZAJ87bK3CLK/oDywUfgWF0Lt94qqn0PkQVCJNmXzF40nNK3I7STCVz0+4ilzgmrI8E0/wP+DKNAiLcbeycxDwzxKe5nXcI08drbavHfATctQ6EB80Tm5sGbUQx/dW8A/vMayLZ/MotvC1oh5K4daMgMwoL7m9ETLl7P+QNsb7PkYnOeSff8lcPCNnCXg2xMdyi7XshuDeIBIQHklrpM/OOeh0zGgbk+tCdJgY1ZXgFQ2Kkh9HM9kfyBQbgv3P9NaK3x2yqqiAZjb/v6ZC44e+uY5KgMJTmpV0eekKb6qUbA7VI9f3MH2yWG47wfhE907IV75LAlOcg
 h3O3Arf4
 OXI06h0Gb/Pvx6DzblSuRwJNKwrx9czc3HFkN6Q6e+grQXv8to9oeRwze+6pyb5Gd6vKsh/kkUlz5KAn7PS+kqh7HK+uRjHbm9Nm8S5YbAl9eLhlavGqMGtugJ1HjKSup3BSlm+qM0G7orUiOAyWaEGb3oqf9KbrqzTMulU8D5zrJ2d6fgssG2wen7HMuSOBVqdq+eOhmaNqkRkuCs59AzbNmuzfmPQIW8HUewx7/MvRnZmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach folio_put_swap to handle a batch of consecutive pages. Note that
folio_put_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection, and explicitly pass subpage != NULL, and the number of
pages required.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c   |  6 +++---
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     |  5 +++--
 mm/swapfile.c | 13 +++++--------
 5 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 768646c0b3b6a..8249a9b7083ab 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5002,7 +5002,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache, folio_page(swapcache, 0), folio_nr_pages(swapcache));
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5011,12 +5011,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) != nr_pages, folio);
 		VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 		folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
-		folio_put_swap(folio, NULL);
+		folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
 	} else {
 		VM_WARN_ON_ONCE(nr_pages != 1 && nr_pages != folio_nr_pages(folio));
 		folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, address,
 					 rmap_flags);
-		folio_put_swap(folio, nr_pages == 1 ? page : NULL);
+		folio_put_swap(folio, page, nr_pages);
 	}
 
 	VM_BUG_ON(!folio_test_anon(folio) ||
diff --git a/mm/rmap.c b/mm/rmap.c
index f6d5b187cf09b..42f6b00cced01 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2293,7 +2293,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
@@ -2301,7 +2301,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index 86ee34c9b40b3..d9d216ea28ecb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1716,7 +1716,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
 		}
 
 		/*
@@ -2196,7 +2196,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2426,7 +2426,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio, folio_page(folio, 0), folio_nr_pages(folio));
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index d9cb58ebbddd1..73fd9faa67608 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -207,7 +207,7 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  */
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
-void folio_put_swap(struct folio *folio, struct page *subpage);
+void folio_put_swap(struct folio *folio, struct page *subpage, unsigned int nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -396,7 +396,8 @@ static inline int folio_dup_swap(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap(struct folio *folio, struct page *page,
+				  unsigned int nr_pages)
 {
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index eaf61ae6c3817..c66aa6d15d479 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1770,25 +1770,22 @@ int folio_dup_swap(struct folio *folio, struct page *subpage,
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @subpage: if not NULL, only decrease the swap count of this subpage.
+ * @subpage: decrease the swap count of this subpage till nr_pages.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *subpage)
+void folio_put_swap(struct folio *folio, struct page *subpage,
+		    unsigned int nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, subpage);
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
@@ -2334,7 +2331,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mkuffd_wp(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
+	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)), 1);
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
-- 
2.34.1


