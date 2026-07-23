Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 116FBC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEBF96B00A1; Thu, 23 Jul 2026 10:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CFE6B00A2; Thu, 23 Jul 2026 10:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDB956B00A3; Thu, 23 Jul 2026 10:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2A5B6B00A1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29F09404F4
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:13 +0000 (UTC)
X-FDA: 85020278826.21.9CE55D1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7ECA51A0002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kx0YnXAB;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817071;
	b=yYG4/kELvYQmmBWx2CYNJdv1ang8HC2LSdtuZ1ItcvqLVhB8zDByVj+513KyJUYrwwb5vS
	wVEZkBwzG25iz2in54H0Upr/gh8RG2TlUR8nV1n3wruJZO7rzyR/sL1ya+uyh3x1PnXs91
	6nul19NcAi18BenB4ndca2rRj43wNyI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=kx0YnXAB;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6B5uzR9OdXO8nYEWFbGyWYL1jpdG251Ai6iDz0lbMs=;
	b=WasRZPXqElpR/cxYb5SYQS86tAPe8RTmYbzuXmg37EGX355+DWaRtY+oUI1jVAwljBqMBY
	46gGKOvzyCX2zQD0Xrllw7/mDMRRu38M2QbSIjqm6MdaPeQChNNrxDp4vAHgJ6MeMicdVS
	Y7kcTSWnT9pZymLTOOMVOlcERlAm8EM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=p6B5uzR9OdXO8nYEWFbGyWYL1jpdG251Ai6iDz0lbMs=; b=kx0YnXAB/onfB8JRGqLAoIaCtc
	dikwqySzkZo9jbm7cDu7u/kPIw5GfBPYqjV7f+OiVuYlYqxxOJbt7PXOpjco/8V6PRBcwdZVPtK2H
	sQeQyZpino5ajGS8kCWckrZeUUVTcP2hfdF8LDVBGNlxJK7jf5lfWA+c7qycuppJd0+KVtk818WaH
	q7I+QbBAfJFop5smtj2+gkynWGiRlg35zZCf/XVM3MZ22hzcnQjkjZSrAS/Tc3Rw+OfFKMGCplgz+
	OrqJfJrccv6NlOGss6L/I/l9nQXrjk+VsENfFm5hemL8rZwPeQRaOw6dDbJGarRwBEU+n92a1k7uE
	XEuw2JIA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000ji1-0Sb5;
	Thu, 23 Jul 2026 14:30:37 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v4 07/14] hugetlb: Use the has_hwpoisoned flag
Date: Thu, 23 Jul 2026 15:30:24 +0100
Message-ID: <20260723143034.175661-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7ECA51A0002
X-Stat-Signature: k7du4ocba5rr34negnyhami5xuuqgngq
X-Rspam-User: 
X-HE-Tag: 1784817071-301295
X-HE-Meta: U2FsdGVkX18mmKFlwXN2IbAjqQ2rK7cOcClJPDqRzJHWIJnHoHkKgofjEHlRnPBV+j8nCEo5WFUUtnSgQYFiUk8s57vAs1eblOgwE4p1sQbEDPrS2erD9Ui/oX0GSWQ8TCrsgH9mh5Pz+5raQUeMEo4F1JFExKjsJH+wvD0SsbAJtdpTExXLJ19OcoCRzSnluSNuOZyDg34MQcqDVQK6VTVWembDecJR+3x16QprR6Gh2+T9W0/SX/7NpoMLlafwRpoRBBnO1osHxZuGtcBm08apnMhCSxC8f0aZJwDF7pZXGbO5TAzyR9rfPIitssZf07q5MMy+/sPUtaCOVOYbvLjJHDcFm0rzyVukgVRn3vPGg4yKyZ3Eaqk++1idkghi0+WsJIpCIkcaUmWy1RnrqjfySyQgWlTrENECAIGSLKmtg6slTzZTD/0e3CelK617cwoG26f0qD3NAqW9nVgNFZ0Yufv2BUtWdN7dDjLt8No3k3cWNAy/WbJ7Cjdd3zH8EwrRrw/UanlD3mJobI42EuTFnFyx9H44bqQdL1F/eWrH652AIF6MH5fGnzOC/kGpU2ZrnE9Xlims5h/vFDrf9SM57hRXjTpQbNDRQ2zeKFYerUFReEOd4gqBtwhf16FLk5yB/W8LgF9H+BC6jh5U68iemmltxqiPwsvHGXDt7acjpiRIxauEwLncDD6T76wJEfXdvNvn5QdRE1X0dpt+G8/Tn/Ss1tnwY6eJmdIT2yrf79tqZsLAhqfB8bGbP6+E4PhLnev4nqLB2hnrVY21u78ZM/LkMp4CNalEXOkrkPgG4gzS+HR039a/zu4u16VA3U0k/yFykkYcRHc0dv6g03Kn8xxQNgSd3/dqqOiA5khNCvFxJdKfIQ6zvakPfGs5+apsb1a4HM6L5fuksusMyuBHVOniNsL1he1pl/iwVnVQz8bstmoPDzCLd/225bxIGwN2RDFhU8zAJNbDQaq
 3kr8l47x
 CEQz5J4aZGNbfCiZphje8UIQHhdaCzDxlUkjUOfAdaHT+3UTCgF2TgIUvEufDduFAjeYWnbLFjnWcTS4qdcym+Ejaos9UEsNi7rGFFfLyBYx54lYyqVEQw5Pm2vuKbgpUxvprKExnivsxHySCwWaAxk/tUctHzBk8R7PBEj8pxYNvr0NbkoLCJQcuX3s/VCJ99xStWz8BUbOplnCXp5AZC4d1RcX7Y3SLygIfvT/JP451g0CRSKaoOc9b/KY/ltb+3lOSbW04Y5v1kRfMeoTuM4q8BEQ6YVTOP+L9KpY38I/XRuMPf/Vt6oHZV6liBOIR47tolQNvC6nqDTePoHyndD3K23X3O8MhjCDGevKN4B3huWu6u/bEBhVWb9AxJHUDWWnQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Other large folios use the has_hwpoisoned flag.  Convert hugetlb to match.
This will help us use the per-page hwpoison flag in the future.

Also introduce a folio_test_huge_poison().  This has exactly the same
meaning as folio_test_has_hwpoisoned() but can be used when we don't have
a reference to the folio containing the page.  folio_test_has_hwpoisoned()
can race with folio splitting / reallocation and trip the assertions
in const_folio_flags().

This closes a gap where a page in a previously-poisoned hugetlb folio
could be observed to not have the hwpoison bit set.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/Kconfig                 |  2 +-
 fs/hugetlbfs/inode.c       |  2 +-
 include/linux/page-flags.h | 42 +++++++++++++++++++++++------
 mm/Kconfig                 |  6 ++++-
 mm/hugetlb.c               | 14 +++++-----
 mm/memory-failure.c        | 55 +++++++++++++++++++++++++++-----------
 6 files changed, 87 insertions(+), 34 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index cf6ae64776e6..eddac4ed214b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -272,7 +272,7 @@ endif # HUGETLBFS
 
 config HUGETLB_PAGE
 	def_bool HUGETLBFS
-	select XARRAY_MULTI
+	select LARGE_FOLIO
 
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 216e1a0dd0b2..fbac554886c3 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -258,7 +258,7 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		} else {
 			folio_unlock(folio);
 
-			if (!folio_test_hwpoison(folio))
+			if (!folio_test_has_hwpoisoned(folio))
 				want = nr;
 			else {
 				/*
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4185a03a45cf..7c4652dd517a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -893,14 +893,19 @@ static inline int PageTransCompound(const struct page *page)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_LARGE_FOLIO)
 /*
- * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
- * compound page.
+ * folio_has_hwpoisoned indicates that at least one page is hwpoisoned in the
+ * folio.  That page will usually also have the HWPoison flag set, but this
+ * is not possible for folios which have HVO (see memory-failure for the
+ * scheme used in that case).  You probably don't want to call this directly;
+ * use folio_has_hwpoisoned_page() instead.
  *
  * This flag is set by hwpoison handler.  Cleared by THP split or free page.
  */
 FOLIO_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
+FOLIO_TEST_SET_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
+FOLIO_TEST_CLEAR_FLAG(has_hwpoisoned, FOLIO_SECOND_PAGE)
 #else
 FOLIO_FLAG_FALSE(has_hwpoisoned)
 #endif
@@ -1041,8 +1046,25 @@ PAGE_TYPE_OPS(Slab, slab, slab)
 
 #ifdef CONFIG_HUGETLB_PAGE
 FOLIO_TYPE_OPS(hugetlb, hugetlb)
+
+static inline bool folio_test_huge_poison(const struct folio *folio)
+{
+	return (READ_ONCE(folio->page.page_type) >> 23) ==
+		((PGTY_hugetlb << 1) | 1);
+}
+
+static inline void folio_set_huge_poison(struct folio *folio)
+{
+	folio->page.page_type |= (1 << 23);
+}
+
+static inline void folio_clear_huge_poison(struct folio *folio)
+{
+	folio->page.page_type &= ~(1 << 23);
+}
 #else
 FOLIO_TEST_FLAG_FALSE(hugetlb)
+FOLIO_TEST_FLAG_FALSE(huge_poison)
 #endif
 
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
@@ -1069,9 +1091,10 @@ static inline bool PageHuge(const struct page *page)
 }
 
 /*
- * Check if a page is currently marked HWPoisoned. Note that this check is
- * best effort only and inherently racy: there is no way to synchronize with
- * failing hardware.
+ * Check if a page is currently marked HWPoisoned.  This check is best
+ * effort only and inherently racy: there is no way to synchronize with
+ * failing hardware.  The caller may not have a refcount on the folio
+ * containing the page, so we must be careful to not trip any assertions.
  */
 static inline bool is_page_hwpoison(const struct page *page)
 {
@@ -1080,12 +1103,15 @@ static inline bool is_page_hwpoison(const struct page *page)
 	if (PageHWPoison(page))
 		return true;
 	folio = page_folio(page);
-	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
+	if (folio_test_huge_poison(folio))
+		return true;
+	/* In case we raced with hugetlb transferring flags */
+	return PageHWPoison(page);
 }
 
 static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
-	return folio_test_hwpoison(folio) ||
+	return PageHWPoison(&folio->page) ||
 	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 9e0ca4824905..e666dd14ca0c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -843,11 +843,15 @@ config PERSISTENT_HUGE_ZERO_FOLIO
 config MM_ID
 	def_bool n
 
+config LARGE_FOLIO
+	def_bool n
+	select XARRAY_MULTI
+
 menuconfig TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
 	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE && !PREEMPT_RT
 	select COMPACTION
-	select XARRAY_MULTI
+	select LARGE_FOLIO
 	select MM_ID
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cc8d98399913..aaac6e2af4c2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1255,7 +1255,7 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		if (pin && !folio_is_longterm_pinnable(folio))
 			continue;
 
-		if (folio_test_hwpoison(folio))
+		if (folio_test_has_hwpoisoned(folio))
 			continue;
 
 		if (is_migrate_isolate_page(&folio->page))
@@ -1498,10 +1498,10 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	}
 
 	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
+	 * Move HWPoison flag to each error page
+	 * which makes any healthy pages reusable.
 	 */
-	if (unlikely(folio_test_hwpoison(folio)))
+	if (unlikely(folio_test_has_hwpoisoned(folio)))
 		folio_clear_hugetlb_hwpoison(folio);
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -3998,7 +3998,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 		struct folio *folio, *next;
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
-			if (folio_test_hwpoison(folio))
+			if (folio_test_has_hwpoisoned(folio))
 				continue;
 
 			remove_hugetlb_folio(src, folio, false);
@@ -5809,7 +5809,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 		 * don't have hwpoisoned swap entry for errored virtual address.
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
-		if (unlikely(folio_test_hwpoison(folio))) {
+		if (unlikely(folio_test_has_hwpoisoned(folio))) {
 			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
@@ -6318,7 +6318,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 	ptl = huge_pte_lock(h, dst_mm, dst_pte);
 
 	ret = -EIO;
-	if (folio_test_hwpoison(folio))
+	if (folio_test_has_hwpoisoned(folio))
 		goto out_release_unlock;
 
 	ret = -EEXIST;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 18691c905ac9..4200deab2c3c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1823,7 +1823,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 	struct folio *folio = page_folio(page);
 	bool ret = false;
 
-	if (!folio_test_hwpoison(folio))
+	if (!folio_test_has_hwpoisoned(folio))
 		return false;
 
 	if (!folio_test_hugetlb(folio))
@@ -1874,6 +1874,23 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 #define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
 #define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
 #define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
+
+static inline int hugetlb_set_poison(struct folio *folio)
+{
+	if (folio_test_set_has_hwpoisoned(folio))
+		return MF_HUGETLB_FOLIO_PRE_POISONED;
+	folio_set_huge_poison(folio);
+	return 0;
+}
+
+static inline int hugetlb_clear_poison(struct folio *folio)
+{
+	if (!folio_test_clear_has_hwpoisoned(folio))
+		return -EBUSY;
+	folio_clear_huge_poison(folio);
+	return 0;
+}
+
 /*
  * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
  * to keep track of the poisoned pages.
@@ -1882,12 +1899,12 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
-	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
+	int ret = hugetlb_set_poison(folio);
 
 	/*
 	 * Once the hwpoison hugepage has lost reliable raw error info,
-	 * there is little meaning to keep additional error info precisely,
-	 * so skip to add additional raw error info.
+	 * there is no point in keeping additional error info precisely,
+	 * so skip adding additional raw error info.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return MF_HUGETLB_FOLIO_PRE_POISONED;
@@ -1941,8 +1958,8 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 		return;
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
-	folio_clear_hwpoison(folio);
 	folio_free_raw_hwp(folio, true);
+	folio_clear_has_hwpoisoned(folio);
 }
 
 static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
@@ -2095,6 +2112,11 @@ static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
 {
 	return 0;
 }
+
+static inline int hugetlb_clear_poison(struct folio *folio)
+{
+	return 0;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 /* Drop the extra refcount in case we come from madvise() */
@@ -2722,8 +2744,8 @@ int unpoison_memory(unsigned long pfn)
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0)
 				goto unlock_mutex;
+			ret = hugetlb_clear_poison(folio);
 		}
-		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
@@ -2732,17 +2754,18 @@ int unpoison_memory(unsigned long pfn)
 			unpoison_pr_info("%#lx: failed to grab page\n",
 					 pfn, &unpoison_rs);
 		}
-	} else {
-		if (folio_test_hugetlb(folio)) {
-			huge = true;
-			count = folio_free_raw_hwp(folio, false);
-			if (count == 0) {
-				folio_put(folio);
-				goto unlock_mutex;
-			}
-			p = &folio->page;
+	} else if (folio_test_hugetlb(folio)) {
+		huge = true;
+		count = folio_free_raw_hwp(folio, false);
+		if (count == 0) {
+			folio_put(folio);
+			goto unlock_mutex;
 		}
-
+		folio_put(folio);
+		ret = hugetlb_clear_poison(folio);
+		if (!ret)
+			folio_put(folio);
+	} else {
 		folio_put(folio);
 		if (TestClearPageHWPoison(p)) {
 			folio_put(folio);
-- 
2.47.3


