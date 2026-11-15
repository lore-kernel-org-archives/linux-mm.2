Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3278606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=d6oHpRZr
Received: by kanga.kvack.org (Postfix)
	id D200F6B05B5; Sun, 15 Nov 2026 09:39:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7116B05B6; Sun, 15 Nov 2026 09:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34DE6B05B7; Sun, 15 Nov 2026 09:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99E0F6B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:39:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1FCFA1A076D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:39 +0000 (UTC)
X-FDA: 85437612078.23.BFA1022
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 746F61C0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d6oHpRZr;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753577;
	b=27Blgdtu56hHnGPGruSOOgu/xwcn2oW82oXItVF8eMslMiadhw2gEP/d7dEv9vZVkhJVaJ
	GHSOMYzrUx6lJnshzCp+q3iXjvfV156mii38b/bjZ/WndinXs34RRP0HuF8gvHnbBeqiFt
	8OXsE764hszJw2SbHn4MY3Atih3Zdx8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=d6oHpRZr;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0Fhp0fRuLUl+ZFa4HGrIw6RwbVLNvEbBYosLLbbPhQ=;
	b=LyaHzEuHCuh1/046J0fvBUW0pOC9lb+fWGo/ZPbwiCFa7xub3oeLbSbkbLICnvWxM8uStB
	URPcyuGMBPQIjehOHcTx1e3QK77kJ6ssEX3BnazLJmKQ51wyrRuLHGnSVPCi6d6chZOtbP
	eElqIKyxcTNBru/+bKK9EXVK0DFiN9I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AB1D1575;
	Sun, 15 Nov 2026 06:39:33 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 663E43F85F;
	Sun, 15 Nov 2026 06:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753576; bh=zA70M/FX7BJCJkrrfkJkpzOjUbXIa1jcfVlm2yKz02c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6oHpRZrTTfSPkJ7wYBRg9DyuIJQ8SN8/qSd8501rLb9HwRI0mjPiXob7qKS+lJkP
	 Kt0u4URQoV+NDz0Lh4J8JNl69basL3kw7HqoDwJgMuzAe7wzerwVMxwIgADF4SViYT
	 JUzXRuc3qDgnHAtrGUj7x4d3jLG2rP3+gc3+OeZw=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
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
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 2/9] mm/swapfile: add batched version of folio_put_swap
Date: Sun, 15 Nov 2026 14:38:57 +0000
Message-ID: <20261115143905.3045084-3-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8zf5t931pnbknwh4pcop8fxgsb5d8e1s
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 746F61C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794753577-715399
X-HE-Meta: U2FsdGVkX19s1edy586zV/0Vcv08fBATvSphtFzOvQQpHr4Ditqru4rZGwFxR5nszm3D8tz13Y9zJRBLcWKp5LhUQ/B/c6Iqd9VjRcJ+suHDfTq1h/HOxAPVBvo2bR2ba5UELU4QqPMFbhkf4t/RyEXF+1wZyRVmZj8xyGRYuRKblmNFp6UFc2dzoItsNOl1joVuJ0DvmBvHiydqIV6/misNsN+q1mD54KHFHpihBrkka22Dm2z/uJDY50GfZpDRa0aao6jFxVpoXw5NP026EXEhgfpKHmetPn9wnOZu6YfDRQqHd7tQuOh523ZQGR3A0REzQJ++r7PDzI7OsPXk1f8QyUIFbJryHEmNfBdeT6gf1hYHuIuVNTpabEonJ/wObZ4W/6ANIPH1pPiU3ieax2VGGjKPNHEk6Z3pbGtiRtSWfSUjR5JGdft48RaDo6duPVILQQ3CE840XDcxTIwOms7dmvHroofaLUnwVk6KAzo9kb9dsji4S+VyV3galayWoCs118reczwxEBph4nFf7B+g1KSQ2CuUam+zthGFCbcnoAsafb3ZULXLXvXWUe33/AhRurQfe/dMJ8Gu4aXK7zykujueQJlVyrfGHL8GPjdsfFU7wY+1U6At7/VujqunZMHhYOktws7tCKlNLht8oMNKlbkOOgxgQXXFP4BIDZbBsYIDJEYncAhpGGlTRLGPmUlmXsZRQgpLe83Rp8yhNjIPYOO2Aebv0U8giIs74YBPQZH4NUYET6H2w4l0EzgGHbxpW6PqYJtO6IqHh+U0Wc6KhKRs4WIA90i8RSevAQOVaDL3btf2Not2DSOj10Yt8jjh5ZjxDptYEsvkQnn2GKcMetHahoFUDRUllO84bEcKBE+HJ7jZblJLJm4RDqzrkzB1iVsf8jlfr6zIaHWizVT4T/iJfEATjRLboAaev9Kn55qQWYviWuZiFcBplgZwc9+SsgFUGQHe/eUr1lm
 RdjNZe17
 OuNY8PAYofKgxckY0gkocvVGk6ge32WZgia9U3gUGiaH2Tyx4GOowOCVPF9DoM/Q0GM3IN158d9GQl+0ggtIG5V9QmfmgoHCgQKCFrFEcpz/PJTEC+huq9sWo2ZJTOEIudinuteMx51saypJgWXDIsANcX6di6HEAO3ofnZkbVRGBfl/ihfi5IMWMKwmZri1qK/HWTAQBJHEH1YgfKYsgye+6HrgtAMXsdVEXZg2YuK5oNDNizz2VmVc1YvTnRivYl7ZOGoSV1CBtS/6Oc/mG2MW19JC6oxW6Fj62mAvI0+ELyvIrkqwAHf7TtZFJem9hSi7MtjOv+Eg4/F57Gi3l4Qexdg==
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
index d477a4f986bc8..d8466be900d59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5285,8 +5285,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -5295,12 +5296,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
index 512a3a1c63c73..6a6fb9b56f2cd 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2174,13 +2174,13 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
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
index e3db6e45cae0c..e0c6037eba59a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1980,7 +1980,7 @@ int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		/* Swap entry might be erased by racing shmem_free_swap() */
 		if (!error) {
 			shmem_recalc_inode(inode, 0, -nr_pages);
-			folio_put_swap(folio, NULL);
+			folio_put_swap(folio);
 		}
 		shmem_allow_eviction(info);
 
@@ -2414,7 +2414,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
 
 	nr_pages = folio_nr_pages(folio);
 	folio_wait_writeback(folio);
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	/*
 	 * Let shmem_recalc_inode() reduce alloced and release the block charge
@@ -2648,7 +2648,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	if (sgp == SGP_WRITE)
 		folio_mark_accessed(folio);
 
-	folio_put_swap(folio, NULL);
+	folio_put_swap(folio);
 	swap_cache_del_folio(folio);
 	folio_mark_dirty(folio);
 	put_swap_device(si);
diff --git a/mm/swap.h b/mm/swap.h
index cbcfd587aac1a..9c89c0e848396 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -247,7 +247,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 int folio_alloc_swap(struct folio *folio);
 int folio_dup_swap_pages(struct folio *folio, struct page *page,
 		unsigned long nr_pages);
-void folio_put_swap(struct folio *folio, struct page *page);
+void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
@@ -394,7 +395,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
 	return -EINVAL;
 }
 
-static inline void folio_put_swap(struct folio *folio, struct page *page)
+static inline void folio_put_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 }
 
@@ -503,6 +505,17 @@ static inline int folio_dup_swap(struct folio *folio)
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
 static inline bool swap_cache_folio_mappable(struct folio *folio,
 		unsigned int nr_pages)
 {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index d46cb1cf6469d..d1de36296fb1a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1892,27 +1892,25 @@ int folio_dup_swap_pages(struct folio *folio, struct page *page,
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
@@ -2658,7 +2656,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 
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


