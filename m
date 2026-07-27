Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB355C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F35B6B0098; Mon, 27 Jul 2026 14:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07C156B0099; Mon, 27 Jul 2026 14:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60B26B009B; Mon, 27 Jul 2026 14:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B953C6B0098
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 429DF160139
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:21 +0000 (UTC)
X-FDA: 85035353802.02.8F2ECCD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51BC280006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tXgNtBOH;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785175999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HEZyCL0gyH+VlZAsWVXP9WLjumW9FjcjozzJUqEKwI0=;
	b=P969AaUTueHe2PmHuTZEWTdiye6v/VxTPrnno0pvFzjIprICIq28XkK1m3DV3TmbJZYbOi
	Tkqu5RviWDaeB9MVpo1KlzGH9MmW5IHKAlfnSxJtze1GWlwUF2GErIXeo43Vj2Q7MMmXbV
	uXZCNy3ZaAbMxoBl+YTod52K+h4zPEE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tXgNtBOH;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785175999;
	b=ggGccoE/PinYUX/HIJXMsSMcf+AtpnKjIeN238e1jTQ/wJvg+DLRZj1dhzC7voZSq24iV/
	4/EoL7dIr4H+kmzYJyk0xFSLn+kKBgjPFY9nr2j0JrIK3KN54ojFqUtnaoPNGeQ76iOaeN
	RpkT6MWYFCw91g4wF52I+/ZuTsNgAFo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=HEZyCL0gyH+VlZAsWVXP9WLjumW9FjcjozzJUqEKwI0=; b=tXgNtBOH9K8jFy3TG04mLi5iZK
	8M+LFVQ4gAfT4PUgwGbi8B1Nc6Q814PHvhieHW1PrGkZ1/ZlRhtxF12cOZ9hXKDJBi+vSyh5aRTe9
	osPLB0y2ezLGnCnYKnAxdRRb3Dhp77xaL7uGC8MQTPn8M6jQS+v4Uv3lqg+KXLsk27meDUGIzH37N
	CZjiTA720Xc2RnE0om1qp2kmD5TRW3EQw6uvtoxtwN3DFnQljqjns/aEkYf30P46WqOV2ipZWs/YL
	M7bfCA7p9snXl4pJg2kHlHsjGOfvc4Cwe9ill78MdR3iZROvwTs+LbI2Azc9hCKbcZZJMndCyXktY
	s+6VJSAA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7Y-1dZj;
	Mon, 27 Jul 2026 18:13:12 +0000
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
Subject: [PATCH v6 06/12] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Mon, 27 Jul 2026 19:13:02 +0100
Message-ID: <20260727181310.2671972-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51BC280006
X-Rspam-User: 
X-Stat-Signature: xma9qqqrqt1x64rj9hr77x1sbahggu4z
X-Rspamd-Server: rspam04
X-HE-Tag: 1785175999-937590
X-HE-Meta: U2FsdGVkX18dGvB4Ay+zCDaTzOEsWkUoLY4hQXWvfRM42P9wflKXuseJ5laR65A5J5wM7jgHY4IBnCRYS2aItrkAD/MjToV7+2q7U1uZTDZAtyl6/FG9eptLHxPIaO/3XfzwBli1e6zi+nK2a+L+jAJArtk5CuanQpBmzwQq/wxQ9rOhfUEdowdms5quen+OjR3Hn5O0JhHNEvGt85U12e9+T41BZIX0rN1vvO9FRsTo1Q+Gfzxs4PH0GHDtHBnWjjuJLYcJD9msUYuGJOKPnvJd+oGlSilB+U0KK3NoZk5U3wwHeF31CIfatH8Y865Xv0iCi9W2bJzZ0Yco7chkTe6SqHtPnugoz/mr9X+SWOxCeIRLNi2Pv9omYKlRbImdGVy94ROJYVZysKvI+RxWwGJFmm4u2SLXKFWhLUYA5AWkS3lAj5WGNoqt4vDJjaPIpOOacqkHbZAKR+7m8Zm1U0IPqrG4jd7mtCp7V3U88ShNmSSHMHOKbjDaIZ7xD75VQW05wuGd9ZZ8et3pLIw3MkAOq7UR9llkZyaLOQMz7faR0Jq7FUMwN8FZllTQ/EHmYBB0vcnJ8+Q1LlqhxQqbDbbaJGjlAO82Ya5t4Vdihdf7Wr8a8Y3H5HtQVoavKSB6B0KjOuEa9f4N2lEPkwLdcYwpZWqDHjGPFPf0WiyS1K3DfO245fTE+PKbhf3cjPdFSwuuYRjxsnsrNYInmAw9wytdm+huHsDCvF6/PMMU15eD7UslGlg4v7G2Ozt63hwu4bJzTypBGiP39yqgWySPkG9eXJpA/Z+TwwMAq+C/F8nKJ6iMFCZ95pRdn6UQ4NFg+/tfWrdv7hhdPXC/dBNOQ8di6Spsgc91XqCARxfXYTULQMMwFM7Sq2LumIUepEFDIS2uT4/e5YQqkgraioHRckys2WTx9EG+d9yhTGrKsOMITaDHuQzeTAksCMrtV53sMoM5vMBeMlSetUjQnjy
 ETasoJNr
 SxkdFgH10sEIfspZir5RfvWh7STdGM0220Xa2C3zl6RCdeErHxhVmY70NlhILx2Anqg3OQ2We8rt2otLUHjvsq6s0k+Yvnq6XHbX271zvqyrjgt6eaCGu4/F5q+s9buuv0U7KB75D9TMpVks/PmsT9CXB47B4Adlz4jdi19w5EifqAmPBbH5N/GUTHTc1l74qczjK2F6ygdywJPVSLb0a3Kv8o31tqMFpNbnnWkAnxI1SBhgp86zClV2cFbRXdSrst4aW2RG7n8kUSUErQyqjWs/WSLllq9ogmuT4fgXM6DLximbix+0CqTfxeaxsDa8YY2ixhmTXVjy2H3k/SZ9qL7dxdK98Cri7RTe4wtDdTjBVkBt0NGWQ+zM7vQ==
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
index c09bad4d97f1..e358f6a33d27 100644
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


