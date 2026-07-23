Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F6FC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A3C6B00A6; Thu, 23 Jul 2026 03:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073F96B00DD; Thu, 23 Jul 2026 03:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1266B00DE; Thu, 23 Jul 2026 03:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6C56B00A6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:09:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2458214014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:37 +0000 (UTC)
X-FDA: 85019165994.05.6D430E4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 687A01C0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:09:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qS89mZ/K";
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qK56V3/3N9YVnvD7rfuMKgqK3R2tE8iIUbffrpot+bE=;
	b=T5BzYqzM1ciO4vf3PpqNp4FNPQtxgxhWN8lglVHStCUd8fAnd7/tqvwxJblOBCQzBiPg1D
	au/kBcxFVselsl5ZAxBsn4hn7ju0Dqed3rWWGlzwYvQ79X+0AfCSN0qfnXmB9o5sWsDbHr
	smihullNK9zNn1a+HjpfoKyHuyltHfI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790575;
	b=SxOCtia+A4F2L4Oes1meXvSWRj9ud37pQdfVI4WNQYcijKBd8FBFuYpvQA2URI/nt4gKhY
	+Rulu98XWimc4gIQRYGxEOMwcLZYkw8BprktyxlPFe5rbBRDTU4REVYAM72hxCgi5rXoc4
	gLeLGbGQs+AYdmarm5O7di6CpJubGhM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="qS89mZ/K";
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3ADD31595;
	Thu, 23 Jul 2026 00:09:30 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 829523F66F;
	Thu, 23 Jul 2026 00:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790574; bh=in16ERm83whBnaR8I3B7RmlCct2RsNvzRgAbm2ORH6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS89mZ/KibBNTjCFCu+jqW7Xf2WkX4stZXXmsHptYWilaKtLRJC168a7MN8jNcT5j
	 ubr5mp29phzeekx+hLLj/wx2c0mrKnEnwSSsXmj1GJ3PhaU6K+NT0m4qrYEUHXsGUe
	 3kbQI010fLRqy9S0KVfb7IFz2Uci3Y2TCH4Qve6I=
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
Subject: [PATCH 2/8] mm/swapfile: add batched version of folio_put_swap
Date: Thu, 23 Jul 2026 07:08:58 +0000
Message-ID: <20260723070905.3422276-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 687A01C0002
X-Stat-Signature: 1nr6iqaeduqqbkare5jmy4cewf7xnbu9
X-HE-Tag: 1784790575-269471
X-HE-Meta: U2FsdGVkX18RPIhNkO2UlV/k65lKkMZBY6e4/J6Ce8EM0QTUPpSt7vr64YPkHty39APzN2YZKqmgJBWj3c1ExcMx5Z1KfEjoKANiSfaNIakztbY2RNz5T+tVCjqBwaR7AMiiKvyySelERJx3aONKkZNv6ktOQ7wXPNLD2eeKraxHVoOfhB7jd0L/VSfOxn+NefQzPAOFhw5jfSAy+VG83pr6WjR2KxBDJZ5gEeOQVACVjBJQB0mL4fp1ckysSXQ/RHGkLPJWUPi+pwwz46XR6OASl550p/rBMzZbghdXyo1B+jo/Mqj/K8WqP5bx1i8KKLyl2UDHHETBXkUPwKieoV7R4TISYlFhirTeYYuBnR2OCx+ks+lCtTfdKlZQ+JdkFEbhV5ThiMXk8VfJwHxm4BBfbKGEsCNB3MjfGw1OJLOviFhhHYtATr1YMc3aNoGptn1pwKVhsptXDhpwylLVhgxu1u1LrlXnQiiUgBMjWdaA3KeQglVhjxu6vAWKu+7P5oTZulQT689+nW9da7ZoK7JqkJ2Hl35HgAho5dnfPEVuVNA6ISc+Iodarual9k+gEK1pNdUaD3Psv6XlVuo1pFBIgFPjn+8WAxNYCrFhd6020lXWexFMKytADYg0S2GxxgxAltYXi+W4xj5eEToU1fwwwMKxsUNOFaUknESjPgiFIg/o12WVhX7FsF2ByfM0XjngEcMkcpNQ8Q2wq6D1wF2yQSv6Ff0CLIrhTus5h04mAWj5sqyt2MhouPtCUAF713Ks8cmRiJ0nbn2TP3MMJdg8N3oGUA6f/NcOFG1G4CehWL8S9qWfEjuMBSXydYpPxgTEIaPB7D5JcA4E8ZzdZmSvyNxLy0mFej9OviV/CQfzAL4mMyRotZfsiAmXnMXjmvIBVprU9+1TAdvqquhZYXmU5toJu3HrPRaCqFIy5VOv9snuXDB2pLobk9B1W1944ze9B91w54+ctjLaTxg
 5LggFjp5
 TckE8e7zOCw+35msIuvLuUAKrFWnqqaOW8bnEWGXlkAUWT6agy8/kHGGtUybYlX7CsxL870AZHAjbNut0IBaiYs8cKofCOx2n6CKN+/xWW5kV/spEE3YpCpkHo1/D1x7n2uJKs9b3m9G/FNcgw+/PsiWfAtHD3klrIYuxI/G9hGu0S5xrJFglsb/ZzzquPN1OI67Brye5I9fLup8XGyAFBQ/UlmOjCT0JPguhb4Y0vdAjBUlNkGwIyHf5vkwYqetZUhtbH5RmJ7s09wOr2LQVAB4hJGNONxevcZQvQuUR8aaz/6T1sG8hsf2PijHxQv2OC+1+
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
---
 mm/memory.c   |  6 +++---
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     | 17 +++++++++++++++--
 mm/swapfile.c | 17 ++++++++---------
 5 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index a620d425ec95e..d88df15018268 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5198,7 +5198,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5207,12 +5207,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 4ca809a596dfe..c1988dae8d4a2 100644
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
index 501365158f8d8..bd7fae7033644 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1719,7 +1719,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 
 		/*
@@ -2149,7 +2149,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2379,7 +2379,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index bbf665a33014b..aae1fc9b6addf 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -253,7 +253,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap_pages(struct folio *folio, struct page *page,
 		unsigned long nr_pages);
-void folio_put_swap(struct folio *folio, struct page *page);
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -382,7 +383,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 }
 
@@ -484,6 +486,17 @@ static inline int folio_dup_swap(struct folio *folio)
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
index 0709a6266cf1f..ef214b924bf50 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1817,27 +1817,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
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
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (page) {
-		entry.val += folio_page_idx(folio, page);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, page);
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
@@ -2570,7 +2568,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
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


