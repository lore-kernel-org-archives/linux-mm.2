Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7B4C561E6
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43CB66B009E; Wed,  5 Aug 2026 17:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDC36B009F; Wed,  5 Aug 2026 17:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218E76B00A0; Wed,  5 Aug 2026 17:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB24F6B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49C991C10F0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:22 +0000 (UTC)
X-FDA: 85068449004.21.FDB8C3B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4C3DC0002
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DedLPwiq;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ElYgV7Nm7pICNbNE5oqqt2Q2KMrx3fyfKQG2OVo/VI=;
	b=BeQimU5rq8sSmQcoYtJalzjzUPowi63USaDrLZ6YMylv8K9z1hfGk6n0jxcy2aUSVCzd7p
	RLg2y2z5qGiCEbN/EXu8UUwcg65a/WsCOWskNh+SV9Syk273+LOCZILGxsAZ6O69d3njrg
	lcSFi8zDYqXPltyH73/sGaxHcZ6wz/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963980;
	b=lMgVoY+3fVgl7MU7sO95TqCM/B+AXm+yk1wBylnwDJe7Ral46W4k3UpDfeHHmleMT6ZFCW
	88YC/KBRsk3aLM4Xsa1No4tOuprdt1Ljqh/UVZypbYhahJWQqzElA/SiqdAuTduSkHYngs
	6llUy2h/HbYhPS3jGB489EveicudpZA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DedLPwiq;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9ElYgV7Nm7pICNbNE5oqqt2Q2KMrx3fyfKQG2OVo/VI=; b=DedLPwiqr1ajVb5eDR6s1CuXzC
	gsgHhPFtHhE2j7wo6ycy6D+pdA3CK6V8oZYxbSQpRWeMyLSDkOBXZkqBY2QmHtkM8oxrsNIF5Uv7c
	iyDnIhFucRYJWwhX5/BOjO6nWKRi97THW9hYpMrfotvvh8vJDFFhVo0fViqoWdPTg9d+x+eZ8VkRw
	KFiK9Nwtr1wJU2tf57Cs3GgdfY1kzmw0Tt7EAv19wyQf0Ym1mSHGQ806RbFW8fPHxEzDfkhuiWfCT
	FS/13DNR5cn9OlCuj4jqQEguYWMH7R+4mnEZXvTMf98bibJ9bEBGe/KcmaWPhHkUTjumtlEnmbTH/
	ujyGQw1A==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioK-00000004h6L-0p2f;
	Wed, 05 Aug 2026 21:06:00 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v9 09/15] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Wed,  5 Aug 2026 22:05:49 +0100
Message-ID: <20260805210557.1118966-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5jx9tpxqg787niqny779pmyc8knmmpta
X-Rspamd-Queue-Id: B4C3DC0002
X-HE-Tag: 1785963980-804401
X-HE-Meta: U2FsdGVkX182D7twzarpbLVWQIaOwNQeM8C/6x5Li4ID8/tHOfQ4lDHRR8iOpog29QgBRqNEnx6fQXABGXOgoLl3sKY5oXHoi/PMZAx5DHVSmLeoNZPGp7lMO9Xdo9/BlJOlZNk5BwxNRjtFqzyO4sGZ3ZdttoO8Cq09A40ROJVONDjfYFKsvMnqJ2d+C84v6z7gkeK+pyg7CUmWbV/rz+rgeMVMh/wKLekYgUFjyuHr+IFL7kgI3NeDFvtSoTenb+7tq9WJ9c1fKqB12/MQ/kQM87x9hlSCHIHT/K7kNGDnG8gjohlCkV1QN6sltRIzghs/T6PJsT6U0wc/7SL3AMQyToUe9g4A0hHMnyRqxepa8ornT6/zuelX2jDtUGyk28+ddvkp1aGPmHKRGbTolO5mEEmSRrKVpSYH+gsAIVmkLB1l8aiiW7m0cLtmRDKwEwTisFPpw/kqrCaFr6IlelGl9wlvKAQyfTM2yZenb99/uM7rnIdjyPZQDxa5H9ZV/sPQFdtfyj+1j1JfULtyBeal0ZoJo8xrJ2fAFidZILYopzXpaa4vT3CTMLCUhLW0xYmfRgFMubhDKFZzjK4H2PGP3FIOPlxwhGmlCoGyJuCYt6iWHPfhYf22VCtwKjnZSt6JEOzGVK2KPIYk6T6zaqZnQj2Co907rzeT0xgp7EP0M5cTEfM8rZRbddUK7otxtS5WP/YFeDXWZa8An4ilcr/wyUFdOeHoS5fEXYusLAqR+d48DcPfd94UwtNlDT7rQKrIlYRTTTtK8cD98McXsESXIzqiqsJhWsOGzCbRpOC36Cso6i4Qz9Be0ZXSk9dnrnrYU+yITHXipXvSAS1O2BgSpcARI+wjXiY2l8q0sgjnmaPqJX2svwwTcVnA0bzBQmxXxXyPaEBA3BHiJcp6TEehkswYup9FzmVe7wAfXDlBVG2AthfFCNc7fo5cZVFsouRYTydd/rqlOOUkqnb
 4zl99EPG
 RbCVFV0bFVjF4/2JIgvbQcMG5eOm9DeyGj+0oonTvL/aVvJc3g38sjE2YPxywmDqQ56PY7tqbQ6XMVHu1sorjnzc7jr2TD9L1oHwEPxGoxQHHQVyzCGjKnwSY90b5S1NZV0XM9aJTPVSJQxHMbJc4m1XuXhhohE0WiVnktHRV5oIGIonkdgPO3P0lCyImxnr7h3nSHE1HD0Wi+ytjS67ngvG0Duemg5ChrzA5fbWA9uwLTpYjMrX9wiCfJABBWyspnSRXwyfDCf8oIeP72xCFO+pFq6f2C04BDkAfs1K3ZvDqDh1n2TpNS4FG/N5lnbx+jyYMy0Rln+l7wmKOtv+qDZ5LULlrmjQwu6c2Nc/n49ehv1DBB/4t8+ZiRRGTiY6AtY5mtHIwFAZo+bGSes7vITKHid57H7V4AwaPEtPSZR9VEYF5ZyUbbAa/z9K2h5zQouH8e0h6Ul8UX9c=
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
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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


