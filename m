Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 990A8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hgDZs5Dr
Received: by kanga.kvack.org (Postfix)
	id 4343E6B05B7; Mon, 23 Nov 2026 00:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E5576B05B8; Mon, 23 Nov 2026 00:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4DE6B05B9; Mon, 23 Nov 2026 00:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 055936B05B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E682C07ED
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:14 +0000 (UTC)
X-FDA: 85465273068.28.5A545D7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9EB4440004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hgDZs5Dr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412172;
	b=nWRYG0owj35WWp7cVIPA/Yl7NNHy6EsiamVAlxjzl/8b8/Wd6930d4sr1ikt9iCIInzKlX
	PeA7GVhrWOVSMoFS3/u9m62fHwwvOOWt0P1sxSdTCsrxwei71ce1r67q+24Q0fIKK/I4+b
	33ECwR04toNKZxm0T3DktpkEivjssH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwUABIJPcG4wkw/8tyCLv0mDdg/1SOEEW0H7s6Vds+g=;
	b=F1diBx1PM/N0f8bJHn0heAsSZczfxrXKRUyvFrbI5q4Q/qyLglEc1r1+eBFYbx9ixVx1OO
	mL1xZ6Qnv0NdKuaHwFxSmdUo4Yyjez5qPNrl9iiL2nH2/vdBlr+KDSXDhtsQUi9CDo8cg+
	ZRPOK8/uD4rSa+UWKVv9gVcTyz7WWc8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hgDZs5Dr;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD3581692;
	Sun, 22 Nov 2026 21:36:08 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E12903F632;
	Sun, 22 Nov 2026 21:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412171; bh=GiyoVPsQ8pJcUMUz9ig14lCYYTm6ntdIpsEuyMUyRbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgDZs5DrWBKasgA1sCCmE6LfT51UNHaqp1BBGWf9znpKYhJ/7K8mmGdfv5Un9DAQB
	 yK+6djzg+yN1Pajfm7rRvNkPWKqi2ZAtbS6cJ2ZQ+9YZJ70b81ijTjvbjBDfqUTfCI
	 DIFPijrpv7cG4fow+F7WXNa9YP9aeCwSx/SVsFms=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
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
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 2/8] mm/swapfile: add batched version of folio_put_swap
Date: Mon, 23 Nov 2026 05:35:36 +0000
Message-ID: <20261123053543.295467-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: auwngntgrfwmfqrr5rr6yctowtd1pdan
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9EB4440004
X-HE-Tag: 1795412172-441821
X-HE-Meta: U2FsdGVkX19/CVM/PGMlJtt6qSf6AptDwZL2XK3WnQup6i6INot7cix4dBBUCwm09SMn9Me/7hGX/mr9e507agmaff9BZE1ZpRKGOTQwpygr8wvd81T8NQwjTvkSK3b9om09/UpVIUKro/O5RMLWiWtpMqDLn0rA70BngjzNgmpSBzT6I0Jg6SgwQp8+sILkvBinW/nCWD71uyGXikpPFUi+URwCiiUlhzN1y3PA8a5JQ3EEtX63jvPPIVYv8Ja9xVybQaCa8H4EDpgHLLCahOdpVqeMk6Dyhtq4R7a3RN1ixfsM9li/+7H7cE/jrQH4s2VMZM0G2qA3QXbzbxrSSHPW2Cayqi+WabU2C0UV1NR5pU++XvvHAg87/lD/Lpz5HnQr52+1J4qnPW0V2ALjaTD4Y1r0sjpJ6yNAUw38/i7SAYGnuH/tD2M5xQ4dD2b4Uug4wM6VnzC3x7X67d39mas2Zh+ILJkp7w4UwwxWXhkQfKKpNE0KpFRsuZYU13BMhlRS0fW7AdrAn7oj73bntECSaT6GAm042fMddlm90TZv65g+D6Q8Cp8pXZvKx3I0XBcJ+bEF3vJh0CCwNsGLt1xWoVGn2Bujm9AXAJAhjEHeaIEdVG1+vLJa5aRhDd2PZ8nPVP6mM7ECdkyBVxBwBoPwiJt9sBjBVhOR4STzmKhcRUKla7y+Ric+l2x1bqux3uFHo71mMxirE7WwaCWRWWCdMA2bqu7Hj0ZnFWdWWbubZSLMQxlDzRgEK3SklmjvNllKtdmGpujoru8tPavQ82sU9vh7v7u7x7z84wVTtH2FsyQV1b7KdI1t8XTkLxHC/tLeUhl+Ueh5rT5ftdDOFcycjtoZ2jJAxhwPbGYQZgRNnoAon2kNtEAQc5jotFNZ+4Wz7Cr3kI1ZGugTOzAI2GlHbZJ792oJMfIV91yZSfx9fH3trUIjIjlYXZPS//xuGVDfAMbUYU7QRcUqn7b
 utCLg0vd
 MLm54DYfQkmiUY4wgq+/JDmIQo0TWVtketTsYcBioekrHxLMMyCqxddqT0lX8c64XNovQT2wFmJ/gWUP+YzBX6A73U+ZuKmDX+mtVR9Vti2d3uVKWLnXS2E7hJbQVbPjoUCDrJjYp0TLU3d3BQ6A14xzp7SuhcBuQ6yF7l4QaF2ZVXMy0dgW2ZnVteFSXnB7RbjgxKO4nPTcOcLdy75v6xyAgmBf1lGNrGXfhmJ+5RixHHwnp6HFJqhL1shOzBEZM+sULd0vTdHNRcTATZqy7BSlkk70+kk6TOuDcBRohE1NQ7uFga9PLjFqvUm2O/a49mBLuT0sVH3siW7QDFSdr5d1IfZgyOnnKsU5YtixGKSDHbBqepbuCYMhdMsBJgceNKBj5hRPn7Zs8+wfOXZdqSIkY7rswK+ESTBJSlDVd0gC3rUHbzblOR4e0xbuBMvCDC67OBqQEw3eEgFJfE6ZuBt+jUyKeUw5RkA28TbSd2gvsQD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/memory.c   |  9 +++++----
 mm/rmap.c     |  4 ++--
 mm/shmem.c    |  6 +++---
 mm/swap.h     | 17 +++++++++++++++--
 mm/swapfile.c | 21 ++++++++++-----------
 5 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 6a23198c1c67..ed6dfdb63994 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5327,8 +5327,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (unlikely(folio != swapcache)) {
 		folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(folio, vma);
-		folio_put_swap(swapcache,
-			       folio_file_page(swapcache, swp_offset(entry)));
+		folio_put_swap_pages(swapcache,
+				     folio_file_page(swapcache, swp_offset(entry)),
+				     1);
 	} else if (!folio_test_anon(folio)) {
 		/*
 		 * We currently only expect !anon folios that are fully
@@ -5337,12 +5338,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index ea94e69010da..98690947ef19 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2176,13 +2176,13 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
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
index aff46b2508a7..0af500103036 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2008,7 +2008,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 		shmem_allow_eviction(info);
 
@@ -2445,7 +2445,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Let shmem_recalc_inode() reduce alloced and release the block charge
@@ -2679,7 +2679,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index ea710cec986c..891f41c4556c 100644
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
index a7d7e1f81c79..cd81a7bcffb8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1836,27 +1836,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
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
@@ -2602,7 +2600,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
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


