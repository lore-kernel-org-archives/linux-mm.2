Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF5A5C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716EE6B00A0; Fri, 31 Jul 2026 16:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8256B00A1; Fri, 31 Jul 2026 16:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7046B00A2; Fri, 31 Jul 2026 16:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 313C66B00A0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF991A0153
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:22 +0000 (UTC)
X-FDA: 85050158844.20.87E670B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1A9C540007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nkou8scZ;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGa6uOesTo03M9rfyFpVvvQdA579LC0zO9RS6k4Rll8=;
	b=NBF8t4q30jboosftzP37R9n3FiBz9b6nKxYu0Hmr1KgMnKwE2plImwoENwykQGFjxhGlJl
	pskjiZpNjZEd5bIgRrJCCsNZwtHWKMCAqw8wu1Gon7OTbYqa/GB9J/q2WTAvGT6CJxHeHa
	Yt8As8mJkXeeu0A4Uyt7YOgrIxDjoK0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528501;
	b=iUYcxglwgmJEhcY2Dt5U8YtI5e1cRb9NWER7j9UGIhYHq9Cju75WgZFF4ePlsQUENzFmj1
	iLUqm/khC+m22Tqj4Y4Vi82pVDC5NV3QbhIT+jd3Z3rn1uo4YH9Fb1V/mzueeKEdzufl0r
	swtlMkWkEXUKurcIpB5bp1QoEPuR7ys=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nkou8scZ;
	spf=pass (imf07.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=qGa6uOesTo03M9rfyFpVvvQdA579LC0zO9RS6k4Rll8=; b=nkou8scZIO54V6vdCOpAXBVgM3
	eTUBk+kku92JG5YV7LlpljYsmYnJHZP9i+M6i0L8TfaXWzySJKklrDvUUDNg4tx2KQmw5EsoQPI0L
	dN5UCesvdy55ON1yxYR0X6DFcMvJrceuxpik4tvxcaC4afvHFLRYs0b9MLtgWikYIMeJqlRUUmQ2A
	/XdNu82UEZbSl6s1bafEB44bsEu/xFW3LH8n8gYiEpQU+46vW2Hx6gt5v3qgQYHHjC95IgHNq34YT
	zVbkSzbu1bSFLRJSAGvYwrVwpj09bEtS9nj44FOtRkbxGoYFe6CddgrBQYyMWqdTkYJ+RZgnzrzvy
	6zKXhIwg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWX-00000002PnK-0fUS;
	Fri, 31 Jul 2026 20:08:05 +0000
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
Subject: [PATCH v8 09/15] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Fri, 31 Jul 2026 21:07:54 +0100
Message-ID: <20260731200802.574821-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h41hsrdfs3oeaetwp4zew4bm6pq9ufrg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A9C540007
X-HE-Tag: 1785528500-65559
X-HE-Meta: U2FsdGVkX18wf1Pk0F4wC5vB8p8NEt2CD/mGFwV4CF39JBKC8WRvPaYxGjGG4CQDF25GC3HNIY+VPs2T5OkHmlsCF956GtRnV9PXjoM4Uzy9GKJAyldOI/D0z6fZZxBowgx5Es+xzGLyc6F4vHTKYjFFrSt+uyvGum+M7AKJWYYfqQI+5jesjHiQKN5Jcvrhho9Do+Pliwxlmd9Bk4kzxTRebEW3DMGmVwUnrxDbPrFtr44tF6r7yj2yxo5hiqIEVMscOgSTK5lZfl3yv1hYZ17rZvooUwyOXuMCeceWldNibvKcDCHs/wE/o+qLe9cm5vs20HRHGx1MnqicL4cdoJ+56RT7yEUNTw+cIiI7ht2ShQoF7CmYw2u12BPb8m3/4wja+B5tgLvLc7kpoDLS3vuxuc+KqmpruOwYqVeVrvyROLNarbEXRM7AlaHWZmU1Nx3JlugDjWE6t6qlyGlEKjKBEO9LmGgnM3pDM2V/BQ22yvm03SSw1VPPLoPr0HHdqOW3hD48thJ7fTLd3KBcZ5rixUAV2eUXPMHB9rSHiuZTd5ou4/xnCvEGKmqfB3WURbRuKxSsaPaQEQiz+w6t+5bgaV/iCstORwF/1acyMTP6LYNmxSCliLjNFzF9qZ1NUTNYRJNFj4NLWtJKIk753D2Q2bTXSyMoOFBdZqJ48CKok94zTcXwZjGVUxO9OLvG3Kx07R7wibAND+SQ9+dh4eKAgAwo4cHjRJE7ZApjqFjQPDRKSj5EC1Ams62pV+4TUSE1ZjDR32H63kyKG0I67sjorgRX7RJf8I+tDq0WyF390ws/jcin4chBlsztyWFhbILwy+B9TjvW4GDW0a/Kn+fHnLT0t5fejHmZO87tanCWhYY2NhpMhldWSEaxCBLhZmIA1M6G7iJTTvOKzuA3lIT7wHdKs+VhU26+ZOr3eml0ZLjLuqSE8I0TeSb6Dl2O5tSZVrTGBebNx7iH3lM
 QMkZ8WG7
 Pmwz8voqoHDQuxFkx9ptppFdyQRLNBZtFt8nq+CX12Ez0xQg1ubwWUoqXAorWGtVhJJXjbJUm9OTXRnJvWm4Xn+9k2G5fMKgkFYyXAplabcKaG1TKYozDUQcqf+79Tfr3zQP78JOdq2S621uB20Wdb7Seeyd0UchKlrDYFZWRdclBgzhohE3RPpZbqRj9JqtOc7oU+khmYDeFGAft/Xp01gGzMwwfuTyyi4Rw+1Y+k0HKtc1Uc+gkXGZyDZNEcksHPBjrTTlJjsKLUUb7S03EPDtHrKhXPQ1BibIsAkFC1LxDPYrq5Czryg3RD6stcTb35J9gsUVarOGwJ46aa/XGsIxzVmx/U6LPedba4CwOnsMKhYHja1Ju6eu1OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sleeping in this kind of predicate is unexpected.  Add a new spinlock
to protect access to the list, and turn it into a normal singly linked
list now that it doesn't need to be a lockless list.

Rename is_raw_hwpoison_page_in_hugepage() to hugetlb_page_hwpoison()
and make it take the folio (since the callers naturally have the folio).
Also remove the handling of non-hugetlb folios and make the arguments
const.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/hugetlbfs/inode.c     |   4 +-
 include/linux/hugetlb.h  |   5 +-
 include/linux/mm_types.h |   4 +-
 mm/memory-failure.c      | 101 ++++++++++++++++++++++-----------------
 4 files changed, 61 insertions(+), 53 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index fbac554886c3..dbca3f713bbf 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 	struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	size_t safe_bytes;
 
-	if (is_raw_hwpoison_page_in_hugepage(page))
+	if (hugetlb_page_hwpoison(folio, page))
 		return 0;
 	/* Safe to read the remaining bytes in this page. */
 	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
@@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 
 	/* Check each remaining page as long as we are not done yet. */
 	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_hugepage(page))
+		if (hugetlb_page_hwpoison(folio, page))
 			break;
 
 	return min(safe_bytes, bytes);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index e200c93088bc..ec604cee8d22 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1088,10 +1088,7 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-/*
- * Check if a given raw @page in a hugepage is HWPOISON.
- */
-bool is_raw_hwpoison_page_in_hugepage(struct page *page);
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
 
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..86a2d0fee557 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -387,7 +387,7 @@ typedef unsigned short mm_id_t;
  * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
- * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
+ * @hugetlb_hwpoison: List of pages with hwpoison.
  * @_deferred_list: Folios to be split under memory pressure.
  * @_unused_slab_obj_exts: Placeholder to match obj_exts in struct slab.
  *
@@ -499,7 +499,7 @@ struct folio {
 			void *_hugetlb_subpool;
 			void *_hugetlb_cgroup;
 			void *_hugetlb_cgroup_rsvd;
-			void *_hugetlb_hwpoison;
+			struct hwp_page *hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_3;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 714e1b398f2c..437a2be6c58c 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1808,63 +1808,60 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 
 #ifdef CONFIG_HUGETLB_PAGE
 
+/* Protects all lists of hwp_pages */
+static DEFINE_SPINLOCK(hwp_page_lock);
+
 /*
- * Struct raw_hwp_page represents information about "raw error page",
- * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
+ * hwp_page represents information about "error page",
+ * constructing singly linked list from folio->hugetlb_hwpoison field.
  */
-struct raw_hwp_page {
-	struct llist_node node;
+struct hwp_page {
+	struct hwp_page *next;
 	struct page *page;
 };
 
-static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
-{
-	return (struct llist_head *)&folio->_hugetlb_hwpoison;
-}
-
-bool is_raw_hwpoison_page_in_hugepage(struct page *page)
+/*
+ * Check if a given @page in a hugetlb folio is HWPOISON.
+ */
+bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page)
 {
-	struct llist_head *raw_hwp_head;
-	struct raw_hwp_page *p;
-	struct folio *folio = page_folio(page);
-	bool ret = false;
+	const struct hwp_page *p;
+	unsigned long flags;
 
 	if (!folio_test_has_hwpoisoned(folio))
 		return false;
 
-	if (!folio_test_hugetlb(folio))
-		return PageHWPoison(page);
+	spin_lock_irqsave(&hwp_page_lock, flags);
 
 	/*
-	 * When RawHwpUnreliable is set, kernel lost track of which subpages
-	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
+	 * When RawHwpUnreliable is set, kernel lost track of which pages
+	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
 	 */
-	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
+	if (folio_test_hugetlb_raw_hwp_unreliable(folio)) {
+		spin_unlock_irqrestore(&hwp_page_lock, flags);
 		return true;
+	}
 
-	mutex_lock(&mf_mutex);
-
-	raw_hwp_head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, raw_hwp_head->first, node) {
-		if (page == p->page) {
-			ret = true;
+	for (p = folio->hugetlb_hwpoison; p; p = p->next) {
+		if (page == p->page)
 			break;
-		}
 	}
+	spin_unlock_irqrestore(&hwp_page_lock, flags);
 
-	mutex_unlock(&mf_mutex);
-
-	return ret;
+	return p != NULL;
 }
 
 static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
-	struct llist_node *head;
-	struct raw_hwp_page *p, *next;
+	struct hwp_page *p, *next;
 	unsigned long count = 0;
 
-	head = llist_del_all(raw_hwp_list_head(folio));
-	llist_for_each_entry_safe(p, next, head, node) {
+	next = folio->hugetlb_hwpoison;
+	folio->hugetlb_hwpoison = NULL;
+
+	while (next) {
+		p = next;
+		next = p->next;
 		if (move_flag)
 			SetPageHWPoison(p->page);
 		else
@@ -1905,9 +1902,8 @@ static inline int hugetlb_clear_poison(struct folio *folio)
  */
 static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
-	struct llist_head *head;
-	struct raw_hwp_page *raw_hwp;
-	struct raw_hwp_page *p;
+	struct hwp_page *p;
+	unsigned long flags;
 	int ret = hugetlb_set_poison(folio);
 
 	/*
@@ -1917,16 +1913,23 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return MF_HUGETLB_FOLIO_PRE_POISONED;
-	head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, head->first, node) {
+
+	spin_lock_irqsave(&hwp_page_lock, flags);
+	for (p = folio->hugetlb_hwpoison; p; p = p->next) {
 		if (p->page == page)
-			return MF_HUGETLB_PAGE_PRE_POISONED;
+			break;
 	}
 
-	raw_hwp = kmalloc_obj(struct raw_hwp_page, GFP_ATOMIC);
-	if (raw_hwp) {
-		raw_hwp->page = page;
-		llist_add(&raw_hwp->node, head);
+	if (p) {
+		spin_unlock_irqrestore(&hwp_page_lock, flags);
+		return MF_HUGETLB_PAGE_PRE_POISONED;
+	}
+
+	p = kmalloc_obj(*p, GFP_ATOMIC);
+	if (p) {
+		p->page = page;
+		p->next = folio->hugetlb_hwpoison;
+		folio->hugetlb_hwpoison = p;
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -1935,16 +1938,20 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 		 */
 		folio_set_hugetlb_raw_hwp_unreliable(folio);
 		/*
-		 * Once hugetlb_raw_hwp_unreliable is set, raw_hwp_page is not
+		 * Once hugetlb_raw_hwp_unreliable is set, hwp_page is not
 		 * used any more, so free it.
 		 */
 		__folio_free_raw_hwp(folio, false);
 	}
+	spin_unlock_irqrestore(&hwp_page_lock, flags);
 	return ret;
 }
 
 static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
+	unsigned long count;
+	unsigned long flags;
+
 	/*
 	 * hugetlb_vmemmap_optimized hugepages can't be freed because struct
 	 * pages for tail pages are required but they don't exist.
@@ -1959,7 +1966,11 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return 0;
 
-	return __folio_free_raw_hwp(folio, move_flag);
+	spin_lock_irqsave(&hwp_page_lock, flags);
+	count = __folio_free_raw_hwp(folio, move_flag);
+	spin_unlock_irqrestore(&hwp_page_lock, flags);
+
+	return count;
 }
 
 void folio_clear_hugetlb_hwpoison(struct folio *folio)
-- 
2.47.3


