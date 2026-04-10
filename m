Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A872AE99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2316E6B0099; Fri, 10 Apr 2026 06:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2986B009B; Fri, 10 Apr 2026 06:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB546B009D; Fri, 10 Apr 2026 06:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE1446B0099
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:33:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACE561B7FAA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:24 +0000 (UTC)
X-FDA: 84642284328.10.AB2BD80
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0567EC0017
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ih7hSGVa;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817203; a=rsa-sha256;
	cv=none;
	b=B9ioxiMimqupxbsveHJY5Q2IW2BiIjdO10jJMqDvmhdULs/33qpbIOs+eiLs2G4DOTJWpg
	8D3OPJng9Hyh17e6KjsssZGXqY2zeYQqF1VvMJVvuqJXvLtGfUeg10hNLRONJVhObIUGJ4
	ffzQgbflUoByPBEyoD/dC05QQRJwjnw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwxvANS+F/zUTUbWpFDHn5aG4OwlJtsajvfz3fa5stg=;
	b=JxGWyT/NfCFRkYBW4cbunE83GNQ1xu4yhZGenetbYt1DglGR3sA02VjM1tmGESKYry+65G
	Tiha+nwRMr8pPskhO5TYpbRXVUQlGgPij8CVxFKsXCZZZWia/8npngr/d/OsL7rN/Loa7d
	pcgi8SO0b23269qbwyguZgfZpifA/Gk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ih7hSGVa;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 45ECA2682;
	Fri, 10 Apr 2026 03:33:16 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C96383FAF5;
	Fri, 10 Apr 2026 03:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817202; bh=bsHtG+pqYrgnynFwDuTLl6TEYR+rvmf81J2ef4PKREM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih7hSGVaCiEv29B/vfG2bp2W/3IRDX6R2oWnvXwewVRKpaz+2G5dpkF18231ZixhL
	 +9M4kNcEOzXeB+6ll4JGrAEpD6Lcro1YA/xl06cZPTqFl9hEwNpsLTA7m8bekSEsEg
	 ZPvVeH6CL19ARqJIppYk+maFKDV+VULRm9w6OWuw=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 7/9] mm/swapfile: Add batched version of folio_put_swap
Date: Fri, 10 Apr 2026 16:02:02 +0530
Message-Id: <20260410103204.120409-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0567EC0017
X-Stat-Signature: 9o8u6p4mctrxb7t6utm7dc7nhp15tmyt
X-HE-Tag: 1775817202-702414
X-HE-Meta: U2FsdGVkX1/WFmPInfj4Zox5klDAE/A6p5NiHxcRLRDZpMrv90aNS4KyAUkzV3uuJNOMXTcQj+ukqzozGaGrQkONvuvkDfmDY9Efg0wmf091GmJ5vBSsYZHLCbv1MnFO/KrnEhbjXFRrICBgVfJGlN42E1CBAi/4YqUQKYB6bEJcjoHtJXnLfDJkzgn0nZlDKUKdH222z/x/IB7YYZ4SWlB0Lks7eKHIRj3L3G0nk0f6/y/LRfGOxM/cHAyILgtHXyqyqiNDi8UNmND6JYLmgtzWSVXP137P55W/ik5x0QUXMdElLlZxPNl45zUbm+QBDgIIGbc1ekAdbLnTiNcVivIVH3W3Mln1meUEAB6Xs+QsGg5khPqCITDOASiHZCQfhie5TVXNwQ+xEPMByemvAP0slTD+gILcLpvbl8YNAfNf6bwB2+1kePEdsmI31YOrdb2nsC35pv5vmB9cBsYhMsrzimvzQEr1WAipq++uIOv8tcRITGna/0CqoMRnL7HL6I7rQ7Wfblhc+nhWF5nL2m0Uf4K5epTyKNsGX4gXnUNo7gZlsBFLh3LmP8Bvqw1n3khf3UIiFOg5mPjoUiJ2+dVLq8s8/sgm7pN+U6Li9vR6EIkBh88aaKmWV9k6GhbCmiJL2UJ4OaetssV6QjGRdpHpDX/7v3bTwsyM+orm1FBt1orGdrKFqTYxtGNXdKyRWb0CnyRTUx92kt/+lK7Al6xttQy32gBXckTWaz8/7yKsxqn2I/qVMGnXKbtIZXtRdsjNDnVAQxN+0ooa/tdMHkp63Zpukx5l13VNwSnemOcSrhpHBlEXbBxalpQd9UD5BPszz0+GKg6VNqGFwas/wxV2Pybk6llt0TMzkbbTg3Kq3Yv0ddmOuOdbuf1ZS+0k1Ot8kL/vR0dHVRA+EhsWCAMOQEkCD2N2lXc+zWuoWsE+BbnM9+pwCCdBh6elIXiwmBlhgdFENiij05WI4C8
 zFQP01DG
 ZyhMeRnzJeFzuJxyXG/XRsHvHF5ahu9CdCNLBC595kC38N5aeWcW8InQ1ildUcUwq7aK2w3EFAanFQNWp6wh6kuxQHOtNGY21FBeB1G+SiJynQMH9+i0Pn+PJ66AQ2OhUokuJK6OMOznwVyP9BBLm5HhoqSNpAy8xcL8wsKQTE5klvf7Ov2ff8gClNE7A8YQ/1PoyQCqp1/Ctxjr2i9c/fOrF0quXrHq1YSfnDyfdGsTbXhWtiEPf37M8kut27Ol9o3v/DkJnajOmVqa/Ae5S4zFrFLxIBJnk3+keFbqfhMyMGXewGngUiinn41rCQBHWWn/zWGpqeaCPsWE=
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
 mm/swap.h     | 11 +++++++++--
 mm/swapfile.c | 22 +++++++++++++---------
 5 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index eef144fa293d4..d6da01867baf9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5088,7 +5088,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5097,12 +5097,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 6412103fcd6cb..9b20ef7f211e1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2322,7 +2322,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap_pages(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
@@ -2330,7 +2330,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			/* See folio_try_share_anon_rmap(): clear PTE first. */
 			if (anon_exclusive &&
 			    folio_try_share_anon_rmap_pte(folio, subpage)) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap_pages(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index 3f9523c97b9ed..f49bf07e806a7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1716,7 +1716,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 
 		/*
@@ -2196,7 +2196,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
@@ -2426,7 +2426,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index 3c25f914e908b..343547469927a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -209,7 +209,9 @@ int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap(struct folio *folio);
 int folio_dup_swap_pages(struct folio *folio, struct page *page,
 			 unsigned long nr_pages);
-void folio_put_swap(struct folio *folio, struct page *subpage);
+void folio_put_swap(struct folio *folio);
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+			  unsigned long nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -403,7 +405,12 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap(struct folio *folio)
+{
+}
+
+static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
+				  unsigned long nr_pages)
 {
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 22be05a0bb200..d8fae3925e171 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1778,31 +1778,34 @@ int folio_dup_swap(struct folio *folio)
 }
 
 /**
- * folio_put_swap() - Decrease swap count of swap entries of a folio.
+ * folio_put_swap_pages() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @subpage: if not NULL, only decrease the swap count of this subpage.
+ * @page: the first page in the folio to decrease the swap count for.
+ * @nr_pages: the number of pages in the folio to decrease the swap count for.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *subpage)
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+			  unsigned long nr_pages)
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
+	entry.val += folio_page_idx(folio, page);
 
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
+void folio_put_swap(struct folio *folio)
+{
+	folio_put_swap_pages(folio, folio_page(folio, 0), folio_nr_pages(folio));
+}
+
 /*
  * When we get a swap entry, if there aren't some other ways to
  * prevent swapoff, such as the folio in swap cache is locked, RCU
@@ -2443,7 +2446,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
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


