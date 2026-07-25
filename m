Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F7FC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9EE66B009E; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75F76B00A0; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CDD6B00A1; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67BB66B009E
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C957C14039D
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:53 +0000 (UTC)
X-FDA: 85027762386.20.6CCE47F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD8DEA000B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k5ZI9YJE;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJVk9w5b5iPpwgKxuU6O9HJj1a+Kh0ZDKqsYKwQFVMo=;
	b=hnWGWStbYpJyXKR66epV8/PDlZnCIJQj0ctIlHQtArtqf+ksFWaZ4r1pd/6950fbn8xtqy
	bQL2mAaZgmC8D2Ox4vsAUoRQPDIN1/FW9iwcNCSOayyYh1vose/VugS5ntlRpnyjttF63x
	eZSknn6ge7/CNXR0QVVYaQYi+wL8vFU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k5ZI9YJE;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995252;
	b=tXWN1Pn7h1Aqjs2B7MJyXsLGBv0jomOIgdG+Xs22ZZWHbCqW6sdAPRbsxwwEAQciJPq41O
	Mc9hQa24q7gYJ2PGgnhkzvtZZyqXKq3Cv3MKHwDJEjNDhCzC8wg424uFssLAOM6nXOzYJN
	Hvv9bcPPPssy8D/MO+pdu+AJIJwaMlo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=NJVk9w5b5iPpwgKxuU6O9HJj1a+Kh0ZDKqsYKwQFVMo=; b=k5ZI9YJE/Ax9t7J82UMnxtjyCp
	YhJVhJu6KZOxJmr+6yZ3AsO7mAnMVJtJ2QV+1hITndRKyZaWB+mM6ogtjRHS+o4MnSsFOE4Q9h30S
	gDXn/dECYxqcXkVO1t3mBQ5x8W2YW/kP3w4/gqGkqnvpvX9mEM7yhc2MKCSIrNB2pt8i3NxotaSxH
	wIBTGeLtyOmBiKU6rLlj0voUcUbzeh7QFFKZFfmp4Y1w/XovmnDGgzhtGLZnJsfsYShKS6aVP6NKO
	mnlvty1RjeMEkEB0Loq94almjTeV20xIGM9R9nd/gSbwTnX8MNPnOqwNvJvY0meLL8Nn5NmN9Bo3b
	q0AlpLwQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7Y-3k3G;
	Sat, 25 Jul 2026 16:00:43 +0000
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
Subject: [PATCH v5 05/12] hugetlb: Use the has_hwpoisoned flag
Date: Sat, 25 Jul 2026 17:00:33 +0100
Message-ID: <20260725160042.1557264-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD8DEA000B
X-Rspamd-Server: rspam01
X-Stat-Signature: semffb1nrjmoza8rkj7ugxx11gxougi5
X-HE-Tag: 1784995251-881025
X-HE-Meta: U2FsdGVkX19E1c4r1CWZcbCG0DQmCGfzPkg2BkeQ9EZo4jEfhKP7bI2QIu6IkGd6/soxnVXuVjeHRNxhkAHv5Yo44KPkfTooeVMN2wI5d6q+zW32iXgjd9/+rStbXlGjvctdrQK8NQpz+Jvr5SPLLJqbUxIipujRqDn0Lmz8Y66yDIrOImGYgK7u1pPRgfBjQkrE8JsIlH668ES0xrisKz5YQU+UZVtA/YvhxGIG97IpOatNiKyQwNzAQvWZWi+NkbB4wjZ49xuDSx9z3zvQ+Lq/4Ne6fd2DkHC4j1RRcf+4xcfydtIdY0KuS2rd66FDs6ojUJWpfP0/dAgrjUK7tP7GJ1b2nq9VAO9cNXFbPH+ZMlYCs6b0jd5kqiftWrRSRhEXOKHX4fgxiPiNw5EGpwF8JucK3RLaAADAwvBGTcDv1Hi8zPtUQ9ZcMvIXFCpRQFKrPT1DBL5gBi3GoH/44P7h5CRFglg4+t+NREzQ2aY2Awm4SYwKMRSvrcFA7nXgTL6bqV/JoOaP1Dk/U7Ugv+CuwzcMBG7w6YSDDG7K0sTIo56hHJ9Ka/IZu2Ik+AiWpX7fNwtR+UQNUZ5AFz4X+pH9xfWUwZQSkET0iWE/ox8zxMubRu7tmd+ixLM7PDcIkuoT6mRkhkKpqWqvXDxV8wDOx/Xo95GvbD7j7slj5+SMxkX2SJ+514/gvirTKnmU+Ku3wKBqmHhzpMhOibcdqooLxsdrBhVRgHcr7jPU5IpfB5ku5tFZ+Ak7+u2U5aPTCw3j5q2k0eki0P1fkWZOP5pASsZJRxSXQ4SicTvWcW4/BMDlwh44fXd5OwBabhgGOyVzHVX+fX2xa3IOHy2lFONJsTPHGA1CDorUVUmjatjNhP+HtlREA13RtRnFdhgWY5UjDRlCq/qIEvxXuYkEE5JZ2qFbA4vDxK6zZNjz1FT/5ZPLJ6Eual2744iBcKR0IyHozl+r7NUvKUZC/nn
 r+zKL9Nv
 SwfRVTOWCFjx6dR9nmxyU77nT0GJUqQCFVAYGaRj81t/nUey2whW7sIJt/AwZDd5JT/u1niM+EU5VKasvQISpr4Lubwb0jrJm+t7mfmtR+wJcyPIma1mmmSXMBxhFcRKtKItfSE/NDU9eUQXov/Umu/lI3YsCEXOUzsRJknbtjOd8I79n4WJULzOku0y0sP35pq2H7vK5OBvLoHYc/Ka32T5BOEpVG1+8V+it6/TneFZszRBzEKlmI9tju3qpjUqO2HoKRrHqK5BpckWvgiYbnIz/CuXCNq6sJ+KPKbJu8CCue0NFIw80ggHCpkAxYlqBqd3hW2kxcJBUTZCnj1I3vM62g9ptZUGgxJCQ10Adm3yx57u7GVhpe37rK8lcKr5GQkmsPfQSG/RpbstuzrkVAp6yAw==
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
 include/linux/page-flags.h | 46 +++++++++++++++++++++++++------
 mm/Kconfig                 |  6 +++-
 mm/hugetlb.c               | 14 +++++-----
 mm/memory-failure.c        | 56 +++++++++++++++++++++++++++-----------
 mm/rmap.c                  | 43 ++++++++++++++++++-----------
 7 files changed, 119 insertions(+), 50 deletions(-)

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
index 4185a03a45cf..4fab3fbfd430 100644
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
@@ -1041,8 +1046,29 @@ PAGE_TYPE_OPS(Slab, slab, slab)
 
 #ifdef CONFIG_HUGETLB_PAGE
 FOLIO_TYPE_OPS(hugetlb, hugetlb)
+
+#ifdef CONFIG_MEMORY_FAILURE
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
+#else
+FOLIO_TEST_FLAG_FALSE(huge_poison)
+#endif
 #else
 FOLIO_TEST_FLAG_FALSE(hugetlb)
+FOLIO_TEST_FLAG_FALSE(huge_poison)
 #endif
 
 PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
@@ -1069,9 +1095,10 @@ static inline bool PageHuge(const struct page *page)
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
@@ -1080,12 +1107,15 @@ static inline bool is_page_hwpoison(const struct page *page)
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
index 944e6e1d4971..9d245b4f2b8f 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1829,7 +1829,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 	struct folio *folio = page_folio(page);
 	bool ret = false;
 
-	if (!folio_test_hwpoison(folio))
+	if (!folio_test_has_hwpoisoned(folio))
 		return false;
 
 	if (!folio_test_hugetlb(folio))
@@ -1881,6 +1881,24 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
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
+	if (!folio_test_has_hwpoisoned(folio))
+		return -EBUSY;
+	folio_clear_huge_poison(folio);
+	folio_clear_has_hwpoisoned(folio);
+	return 0;
+}
+
 /*
  * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
  * to keep track of the poisoned pages.
@@ -1890,12 +1908,12 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	struct llist_head *head;
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
@@ -1950,8 +1968,8 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 		return;
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
-	folio_clear_hwpoison(folio);
 	folio_free_raw_hwp(folio, true);
+	folio_clear_has_hwpoisoned(folio);
 }
 
 static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
@@ -2104,6 +2122,11 @@ static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
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
@@ -2730,8 +2753,8 @@ int unpoison_memory(unsigned long pfn)
 			count = folio_free_raw_hwp(folio, false);
 			if (count == 0)
 				goto unlock_mutex;
+			ret = hugetlb_clear_poison(folio);
 		}
-		ret = folio_test_clear_hwpoison(folio) ? 0 : -EBUSY;
 	} else if (ghp < 0) {
 		if (ghp == -EHWPOISON) {
 			ret = put_page_back_buddy(p) ? 0 : -EBUSY;
@@ -2740,17 +2763,18 @@ int unpoison_memory(unsigned long pfn)
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
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..fd19a0bfbfe7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1978,6 +1978,22 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
+/*
+ * Since we cannot split a hugetlb folio, we want to insert a poison
+ * entry into the page table for the whole folio even if only one page
+ * is poisoned.  Otherwise, we've split down to the PTE level and we only
+ * want to poison the precise page
+ */
+static bool ttu_create_hwpoison(const struct folio *folio,
+		const struct page *page, enum ttu_flags flags)
+{
+	if (!(flags & TTU_HWPOISON))
+		return false;
+	if (folio_test_hugetlb(folio))
+		return folio_test_has_hwpoisoned(folio);
+	return PageHWPoison(page);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1993,7 +2009,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 	int ptes = 0;
 
 	/*
@@ -2023,9 +2038,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
 	}
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -2121,7 +2133,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * The try_to_unmap() is only passed a hugetlb page
 			 * in the case where the hugetlb page is poisoned.
 			 */
-			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
+			VM_BUG_ON_FOLIO(!folio_has_hwpoisoned_page(folio),
+					folio);
 			/*
 			 * huge_pmd_unshare may unmap an entire PMD page.
 			 * There is no way of knowing exactly which PMDs may
@@ -2200,12 +2213,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
+		if (ttu_create_hwpoison(folio, subpage, flags)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
+						folio_size(folio));
 			} else {
 				dec_mm_counter(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2423,7 +2436,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 	unsigned long pfn;
-	unsigned long hsz = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -2452,9 +2464,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		adjust_range_if_pmd_sharing_possible(vma, &range.start,
 						     &range.end);
-
-		/* We need the huge page size for set_huge_pte_at() */
-		hsz = huge_page_size(hstate_vma(vma));
 	}
 	mmu_notifier_invalidate_range_start(&range);
 
@@ -2607,14 +2616,14 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		if (PageHWPoison(subpage)) {
+		if (ttu_create_hwpoison(folio, subpage, TTU_HWPOISON)) {
 			VM_WARN_ON_FOLIO(folio_is_device_private(folio), folio);
 
 			pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));
 			if (folio_test_hugetlb(folio)) {
 				hugetlb_count_sub(folio_nr_pages(folio), mm);
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
-						hsz);
+						folio_size(folio));
 			} else {
 				dec_mm_counter(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
@@ -2644,7 +2653,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			if (arch_unmap_one(mm, vma, address, pteval) < 0) {
 				if (folio_test_hugetlb(folio))
 					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
+							pteval,
+							folio_size(folio));
 				else
 					set_pte_at(mm, address, pvmw.pte, pteval);
 				ret = false;
@@ -2657,7 +2667,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				if (anon_exclusive &&
 				    hugetlb_try_share_anon_rmap(folio)) {
 					set_huge_pte_at(mm, address, pvmw.pte,
-							pteval, hsz);
+							pteval,
+							folio_size(folio));
 					ret = false;
 					page_vma_mapped_walk_done(&pvmw);
 					break;
@@ -2703,7 +2714,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			}
 			if (folio_test_hugetlb(folio))
 				set_huge_pte_at(mm, address, pvmw.pte, swp_pte,
-						hsz);
+						folio_size(folio));
 			else
 				set_pte_at(mm, address, pvmw.pte, swp_pte);
 			trace_set_migration_pte(address, pte_val(swp_pte),
-- 
2.47.3


