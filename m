Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E88C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742FB6B00A7; Sat, 25 Jul 2026 12:01:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE0C6B00A9; Sat, 25 Jul 2026 12:01:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A246B00AA; Sat, 25 Jul 2026 12:01:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A74A6B00A7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91B60A1398
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:14 +0000 (UTC)
X-FDA: 85027763268.29.5522D57
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4A5A4001A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bncmpMSH;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C3lxQfPbSj2TlORIW6mcTqwgjFER+2idfU92vK8Lmfw=;
	b=Wa7b25xrSj1dYAk/BE67v2t/ngYU0/77f9rB+diabPno9zGKXCJig5pcN8xXnHyjtttT37
	H03anVwBFMgLD9XmN2aaCTs0h498bWQx4yVewx5cXh2M1P0KwnpydB98cTHiuMtEeMuJXw
	L4G5AHfJVjS2442ztrU8usUuAgCWCMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995273;
	b=gHSmdijQ0YEeQdPujl3ZWR5kDm9GRHd8ospkLShyhI6pOVHR3D6ieD2FeojvYacDUAWuFb
	BQAU2Hhj/0Gi7jfbZp+J1O4nAOmuXlh+9xtl9iQBrA05/m65G5VhyC2Ogr0t5iH3azKiWH
	I8pNho1hXpLZbRL91n+dYQl6vFtwLt4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bncmpMSH;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=C3lxQfPbSj2TlORIW6mcTqwgjFER+2idfU92vK8Lmfw=; b=bncmpMSHawWOQYhYkV2THigODK
	qnDMfrJVQ2B0xPfIApQGCQ9A5wVWWoAQlk/L4Khn5sxiRK26JhVSaJRtzsgiPmOfSkyOBEVezKpNx
	qGgWEVEzsa8BAhN4v0UbP4cBbDv+TQl1riTuxYrXmSebJX3JxFpfIvw3p/7yQ/eAtZiBtoNRCIqfk
	o/gxReISH94zqa3yyU1fN3ABMeSPzUngomEF7+Yt6Mo2eQnnvY6N98cnZGGmK5F2w5VebvMzErpti
	B0Z4QTyymeRY+kv6aJRGGp9x8r/IzMWTDQFS2AY9KPuh2t0dCueaSMf6AEucQUd3pO482mSpUSDCY
	9WAFyYVg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnens-00000006X7a-04rf;
	Sat, 25 Jul 2026 16:00:44 +0000
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
Subject: [PATCH v5 06/12] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Sat, 25 Jul 2026 17:00:34 +0100
Message-ID: <20260725160042.1557264-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E4A5A4001A
X-Stat-Signature: ip6txt1pmq64m4ugsddoeza9azwyxdqt
X-HE-Tag: 1784995272-385192
X-HE-Meta: U2FsdGVkX19S080F7b39+uGL4yL9h8BNcBW9ZjelnSiZbMpxUnOnPc6Nsl8VxaX7SeoYx8ome72dX4HwGAVkjsYiLOz5/d4OmubifWQDC2T09KVHWKzsda+l4B4d39ErByt1q11YWqniHRGBWXtP/pFpFkCwQidJQZIwpmPntDTMeNYIP9WXUPs/s16jzvgseJUq8olsQaXgGmmDbYjmrAttRNOd6fzrCOKh73O+P4+fhocP771ys5hDRZTx17Ma6fLpDwshyjLAt8hMftgzcJRQwCNJNE41ONgj8nvKG5auG9KKKpXhmzGwdjWkTW1qfFtROUMuOyEnmTlQxqtsnRFwtyyvZx3umOQfMi+WOc3MnI00KRwRjwjQm2Senmetvlh1BOGOdqz3bMJ+9Ln0ve3ExX5r5RoY/4Blz9qDGIHDYW5/3qQHghelsnJmIiQ9FWhPZCIuwUW6IQi/dpeK8+ujThaL9+43bxbQtR8dYNe7cUeSsnlF49K+Rsuyt4Ek8G64SsIjgV1K2CgiO1dGOWIHLgfW1mIS1+rR8D54ogZo3lrYtf1QoHANC6fjsjVFJF9NmW12fhX/T9SaHkeqqcb0XLXg2YdrfnmuLMzQ1ScPQ02SctC9PiMH5OXTjDj7BvfAXQYVLBKJm4kjhV48hDhc6c7CFnbzC8lDp64XT9FAvQ0D1nY13sO5ZVShRncVbMF9FU3SYR9Kr6+KL1Zc0YX3PBUXr6aULjDS/kLNjht5ehJk1XF5c3UgqBliu3Dkjc0uNzATghaN/LIRdX7lCem6yburA6dTwNn2e+r8UPArnCe9ICPr5VPSHM2dCaBZcRR7LT8gHlytfrM3WNeAvMgfnqz7i/R/JDlzw5SD1C0IZDJv/1l+JuQYur4XAlPNfb6wO+eSphhMndVJLhXbgcg1+GNauVRcY1bWu+TE+jLzpT7LUdMaNMgwyY1DEOSNHqTR86EGtH5xt6Pk+Tv
 nJ/OvoWa
 8xKmpndW51lTfE0fy34TbXa95aA7dqH1GCU7ALApdK9+efs84U9i/zWHNEUsYRWWyaYe9N3uBvFo2xr6LDdrDmTNAMJdl87yfJN5L2hKQ0WJiMIG6/t60KDyd4k1DU4Pr3vcUGihu99r9t3Xhxh+3laYp00/eNy3duF+HcJI7C4AIl0FGyDVQX6wji/w8U+vhrFrBB1pNTu0yk/LgR8vyHn2AJOafesAICltjtk6D9ZYmZRB2f2cn0fUcyPLdxTeLnnyGD/yREV5mnTVEUz0s9XtMX5mD3iJWlyuLM0Kk8wWHxZ/GDNG2IiMR2iIW9jjhtgOMbxcU2pRanUwXyCl2nMfkf5eWT+QqHaWvjbssDfjWT8xLjCy33gV+jQ==
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
 fs/hugetlbfs/inode.c     |  4 +-
 include/linux/hugetlb.h  |  5 +-
 include/linux/mm_types.h |  4 +-
 mm/memory-failure.c      | 98 ++++++++++++++++++++++------------------
 4 files changed, 58 insertions(+), 53 deletions(-)

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
index 18661a7cdb37..325f0404a7eb 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1069,10 +1069,7 @@ void hugetlb_register_node(struct node *node);
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
index 9d245b4f2b8f..e2f50b4aba82 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1808,63 +1808,57 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 
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
-
 	/*
-	 * When RawHwpUnreliable is set, kernel lost track of which subpages
-	 * are HWPOISON. So return as if ALL subpages are HWPOISONed.
+	 * When RawHwpUnreliable is set, kernel lost track of which pages
+	 * are HWPOISON. So return as if ALL pages are HWPOISONed.
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return true;
 
-	mutex_lock(&mf_mutex);
-
-	raw_hwp_head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, raw_hwp_head->first, node) {
-		if (page == p->page) {
-			ret = true;
+	spin_lock_irqsave(&hwp_page_lock, flags);
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
@@ -1905,9 +1899,8 @@ static inline int hugetlb_clear_poison(struct folio *folio)
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
@@ -1917,16 +1910,23 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
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
@@ -1935,16 +1935,20 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
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
@@ -1959,7 +1963,11 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
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


