Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C607CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F107F6B00A1; Tue, 26 May 2026 02:38:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE79F6B00A2; Tue, 26 May 2026 02:38:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE146B00A3; Tue, 26 May 2026 02:38:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD5B36B00A1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:38:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A75191A02C9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:18 +0000 (UTC)
X-FDA: 84808616676.09.FB93798
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 05EF94000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:38:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XPeb7VAn;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaafMwVJhmisO631axJNfQyL5iSj/x3rtoN54EbEjaM=;
	b=30gYdzW+1fXHvohtyGlUh6vMUDza3xl5EvGIq6Sw8NjOcQurGiYalyP9uCipBgkbZL7WZ9
	u6Qf/iO/jGXpr1mI2+fcHc7YBhBB/SaAF4THI+KORJCzu58yv9tnmu4dXdoKF7u4TDK/9e
	pIB+dkLHDnzdItN9OSBkzjAdAwLaTy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777497; a=rsa-sha256;
	cv=none;
	b=rwa7S1mRQIQ+EkKsXNKtQMQ6qPST3fhCFuW3aAbefZqgmkEh9JP4es7ATU/XmfUCtIKpdV
	PQ67BmAfaTZXtMwoh8txqqp5k8BAO5nu7Bqd5dtTrY/LwBVGeM+emtPS65tAh1DdIx4NC7
	TvKclj7VYRSjNZoh/Hms5FngmCjoSF8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XPeb7VAn;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 287C222E6;
	Mon, 25 May 2026 23:38:11 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 88B4D3F7D8;
	Mon, 25 May 2026 23:38:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777496; bh=3a2qdyS9iooMXP5Rf9L5Gd9Ex0IjBroW/6dASQVXHbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XPeb7VAnjKDu9Y6oHmEYhdxi67ob1CCvcuAItdN6n8mUzU9j2ZfUwdSqG0ZWOommg
	 fyIAYeVtUzmoeaP6YNy+j7rmk6VA/6w7GHPvaYipBaBmhRfk/UYK3EhruG/msiXOlq
	 I/R1imCEA/NE3zj74Yq8K2Sj/N8wLLmIwBoHbvAo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 08/12] mm/swapfile: Add batched version of folio_put_swap
Date: Tue, 26 May 2026 12:06:31 +0530
Message-Id: <20260526063635.61721-9-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: tiqu15xoxhau6otrgruu8iae8jmo1d1a
X-Rspamd-Queue-Id: 05EF94000B
X-Rspam-User: 
X-HE-Tag: 1779777496-980439
X-HE-Meta: U2FsdGVkX1/BRPZwH5vV8Y0z6nfN6JDgY+D6AM1i8S64gv0NrTbJdt8nMb4gZUB6NmKSo+QyMb8ZRg7aeMmVP2glHoxy+rF/i2Ovq/0iJM27N7V926+2WX/Ws7s5F67TMCjXsK7o2FZEmmjfheEk/qEXNskiClWlaszxnCb0sk9f2o6TaDhzPKZwGw+TeccntDzMxixyjtK8pFWyI3MWhx92ukBWvnby6i9mgBigNrPSAmbKw6Y+mIfZv87nuElV/nV4AwqbJ1/BBdU4OLDtMNPNF+GLY9s/krbWB/b5FxT5w36Zj/gn7K7W6HQ8CVgJGb536SvjpDmDLm/g4gHe6n6qc7zctlq3bCG+gVuZQz2QxVepKShI4V5wqPoK9v38Xp49NGq2q6k+0KNG43B+KpjWkL6/Dl/9X2EbVIsQdRZC3jL/J2PD6RdvcK163+zcP0H19jLjqv7kmgsU2bwhpyN6I+09SXZZGToy9B1e695oNUqr20iO7eW3ZN7wfbw4j3KFxqfOlHz75fUQCji3+M4dQcKdi0509bE7+O1reWn6iSnRX+h1/HsSipemLX6CCyaA1J1JO8vLQRV0hyqV2oOHdxedqNjSxt39iiF9kVA6tXXdSyEZodZj1oA+VC3HD+Lm5tENc819cGpSWwCDPjkF/Mrk0cXyFpLrdJ0WTI0PqTCoofF/JebPuhQhq3rtUdfsne/kEipPU1cJj+xZkdCTdwkZ2iEAZzd35sCvvPSq++2B4LzicgMwt69znAb/iiBSvXmc0M/lRJfRd3QXyjrSzd4NqxK3qS9o9C1VelKvkIsAhhKlwpkL+OMAv1A9dcP3HtcMie2I91SZcfUeEYAccVXgLS1f0v5AOj3k+cImQsqNOPQvEXvIBJxpiwemSf/DETk8+YstCrs1QkBxR8Fz3hUAchLUd1dkZP1l9Rvd6yvu6HMVuI7tBxWkYVtvSsdgkofkF9EJCJhA8rM
 UA6Yk3Jb
 44XvpHkxp/5kVr8xSMQIT2/LfFglan82zcbSClTApLFQKKmJkXNyf2IxzQyjVWLSK/m+4ULYK00c0HzZgu7lUQEO6ApxP+b99I0tj71TR8mC+5XDdlprkf0N9J0H1j705eSQ4XGEqRFAg4PTGckmdqywneSKSSaLfK4RXdBtd2/otKytY2G4xm3T+FEsYPwia+gFV9BIY/UgatVUVaWoMoD7yrjoObeLp44qziJMdfQIB9pdRZiUZ+Be+loeSyto2ow6MOcp2WhP682C8NoC2EhEfhLEacQGHa/M9+Sq+qRBliH7ikS4MHW3Nub9k+Moeq5R9D9NPwQb0Tvg=
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
between 1 till folio_nr_pages()), and invokes folio_put_swap() if it
wants to operate on the entire folio.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c   |  6 +++---
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     | 17 +++++++++++++++--
 mm/swapfile.c | 17 ++++++++---------
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 767c033e95da9..40cd44a7f10a1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5165,7 +5165,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5174,12 +5174,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 3065d384cadf8..c0e385882f562 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2342,7 +2342,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap_pages(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
@@ -2350,7 +2350,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap_pages(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index 5e4f521399847..bb7e0fc305d87 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1719,7 +1719,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 
 		/*
@@ -2199,7 +2199,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2429,7 +2429,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 36c69b2788c77..48e8deb95a440 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -208,7 +208,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap_pages(struct folio *folio, struct page *page,
 			 unsigned long nr_pages);
-void folio_put_swap(struct folio *folio, struct page *page);
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+			  unsigned long nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -397,7 +398,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
+				  unsigned long nr_pages)
 {
 }
 
@@ -514,4 +516,15 @@ static inline int folio_dup_swap(struct folio *folio)
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
 #endif /* _MM_SWAP_H */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c91957149ecce..f1d97989cee31 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1773,27 +1773,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
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
+			  unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 	struct swap_info_struct *si = __swap_entry_to_info(entry);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (page) {
-		entry.val += folio_page_idx(folio, page);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, page);
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
@@ -2499,7 +2497,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		new_pte = pte_mkuffd_wp(new_pte);
 setpte:
 	set_pte_at(vma->vm_mm, addr, pte, new_pte);
-	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
+	folio_put_swap_pages(swapcache,
+			     folio_file_page(swapcache, swp_offset(entry)), 1);
 out:
 	if (pte)
 		pte_unmap_unlock(pte, ptl);
-- 
2.34.1


