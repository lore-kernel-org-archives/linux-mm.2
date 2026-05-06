Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754E0CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 09:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D997E6B0093; Wed,  6 May 2026 05:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4AB26B009F; Wed,  6 May 2026 05:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60116B0095; Wed,  6 May 2026 05:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD1346B009F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 05:46:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 739DF1A07A0
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:21 +0000 (UTC)
X-FDA: 84736514562.28.3EBF6F5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id C16D212000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:46:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=arbQ6CGG;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778060779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgFhI89YEPAMRvGz4GHZpp5gYMRw9x8Eu3ZDmmomyZo=;
	b=llPpWMPIivHAl39e2rmh4hpvZx57HDHI2EzeRMd5ViZ80L9/pz0GXSJDkPmxcywznxJRwt
	msC0eS/b15ATuRSqNrnJVsOfLo/KtV5jQprjhqztpyo4cMEhSjIUn9NZIh47DzokPPOPYf
	qi3GBg/1NfGQ/SOSxADW0FbuQmRrjqo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=arbQ6CGG;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778060779; a=rsa-sha256;
	cv=none;
	b=HSysOniNrGGc99wQklOAU0hFov/jQE/+bCPgGe1qnQ0OfYW3uKl3kqoImcOETySGNzry5g
	XoPzVoZe1mxmmvnMJS9anlIXqPxfvlkmHImfkaGNoQNSk8LLfPTTUiWIBhju/TGMpaKpql
	T6/XoFijyAjCt17SCeZ23RtJRIltNyc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95553337B;
	Wed,  6 May 2026 02:46:13 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0C6FF3F7B4;
	Wed,  6 May 2026 02:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778060778; bh=vu+7MIlDr3dLCbzbvbMX1jfuSzlMmMtsr8AqWBf9OHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arbQ6CGGs3g/S5geCz1DpueB0+Xsa2Qx3hf3Io+gJ6PmsiH+W8t2YCegJXYYVFK0Q
	 sPjaKKEdNZsWr/ehHVlZFbB353xFMnGwbyyd0Ex/crIE36ZhgR/3+tzZ3vrTdbs2bj
	 vhUEkTwZ83s8Jb1WSOcfG6Pp3cpkAQeC/kofvQRk=
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 7/9] mm/swapfile: Add batched version of folio_put_swap
Date: Wed,  6 May 2026 15:15:02 +0530
Message-Id: <20260506094504.2588857-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506094504.2588857-1-dev.jain@arm.com>
References: <20260506094504.2588857-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C16D212000B
X-Stat-Signature: 454sozw9cr87sdnsto44ur6oy4sqg5r7
X-HE-Tag: 1778060779-838175
X-HE-Meta: U2FsdGVkX18tYD4p8iRyhKcLxuRZpK1PBQboC0SAxPoDPqXYJl5J3mE1rXut66/X4w3dPuOgCx8q4heYKNMWWEWK67/uZNH077J5IhXOJAIjtx+454cDV+AjEpehfcY8b5CAjst9WG5z7pV20CydmHUTa0ApibOFo1iO9dfUVi6rMOowwxLa89AAjkMIbmv22Ux8r3w3AhBcYM6ncb5vAytdGMLhe3oyVScLUi+cTjyEYBvkvLhF31WrDZH/w2RxL7mmiN03L7tc14h2hjdZysq6xxtbPLt/b0iaqg/6Ns7zpXtwBTnKTCI7HDxBANDSI8O2dYokqBL2rYesP0dvkJbUb9Oj6ZkCp2nEA5IGtF2c64Zw8MiXdeSydZny0qJm+VZ11YI5KHpmweKl+SqVfB/s8jgZOS3hWznIViCIunYy37hQlHroV8Zvm2fWC5JjgQX5ICaeqaxJV0hbdcth0YmCnWpxSAtrD7SwkvxfnfmCRWVerP1FK11JmaL22xliwUumhns/rbf+tcRFuX6+Uz8VJQUF2gnX41wpeqH+o/slRlIIrqKkCTYWzd0/zHduBpwL+T9hcv+OUEQzDGrxEydGoC+U4dFoLvZyEjHze/R8l4eE2HUqJ4T0OFYdqe+wBikLNvQQyuAwCsAsYZhv6V1umST+kPJx/LCbdpo8Ix4JIaoKZMNUC5Snao51Mh7i8LGGvgl2LpIQ+ruErJc7NvpfoRMv8+Cy6sn5ugkR4/h8jkiL7z1ORjBu0eaMXJtoCZq+Leil7Dbj6wvA0ML7A+w3Rjf7MtF6gCR5kBKolWTT8qxL4Ef837+yzafDSqtMVQ3dCBh/Mlz6e+hYBpLFSopj7j2aU9hG1FvIs/G8JYqR41LvKyh7tHTkvOkFApwhtwGcKvr6eejUbnuy0goylCB+z/jnAZD90cFsf5cjKFgZYPe2UG/tNxkZ41AiAtvWRI3NvhnEWFq0iboMgRy
 uAInNiz6
 cEX4DBsoLPhnFLNwOlTc5bMZtWjaMD3H6L/UurLakr5AiZN20IQWbscv23/ipM2Hv+xbkiq13tHMgjoMFmDQ10ip87+GMOJ4bv0jh8N+h3fW6fFSkho5vFyj27TeInlA6gZ+LBrO6lf9wtYcZucG6wHKBFemIDTAo9SAozEthYJsBjwnhARRWLCbrJq/275SB1ICeA3g8/Hf8JihW+p5uba1toFGbU8OxtmBk3s/CBPacM7jGCZpNspAvS9/9pQiaWBZ6WNl8JS6YQogUrkUMfmnCxYx0IrghgWF1XBkf8lBw7bQfUDl5j5NyO+Z35wEUYn+N1Vvw+CIZlIU=
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
index f14311c4d2001..c5605a779ce4d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5104,7 +5104,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache, NULL);
+		folio_put_swap(swapcache);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5113,12 +5113,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 352ba77d90f67..7cbf850182187 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2325,7 +2325,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * so we'll not check/care.
 			 */
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
-				folio_put_swap(folio, subpage);
+				folio_put_swap_pages(folio, subpage, 1);
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
@@ -2333,7 +2333,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
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
index 28daf92839e77..ac576cc63b194 100644
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


