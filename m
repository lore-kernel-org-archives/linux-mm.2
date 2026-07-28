Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604D7C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F59E6B00AE; Tue, 28 Jul 2026 16:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CDD66B00AF; Tue, 28 Jul 2026 16:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AC46B00B0; Tue, 28 Jul 2026 16:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EFC1E6B00AE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81F291204F8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:43 +0000 (UTC)
X-FDA: 85039364046.02.74DCDD6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6C2412000F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s5QYp6Yu;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOaRJ24DEqH0RO/tTZ5gHGKvtUC1B5aShvKQInsts7M=;
	b=h/8MHZBRlKrp3dC2WR7hdRCGMF7i7cDsmKOW7O+WIBMYgHX1ob1vmNCaN2XB/4Or0L3Egt
	wrEm0z4Vl5PN68WqH9vusyOfzNpF9DTj2oolRvz1uxOWJIBHcpVqFwX/m5LiMlZNCI8vtz
	ytEC2KwYO90mi6TYo4g3Y3r0040tRBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271482;
	b=8cXbNaHLvBgzCig8stmQYnH07uxRxYGYU/M3hr6n4aRQi5emUSRQP3e0+001Nm3tDzeERY
	v5lW15GbL11mYSRU45SNYF2FKLDXlV8AT0fmssFpR5gxBbd9d0yhkLDSSy3qf8t1WRuRCR
	mczeGpI5S+/ntNICEn/YM05CYStsrHg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s5QYp6Yu;
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=AOaRJ24DEqH0RO/tTZ5gHGKvtUC1B5aShvKQInsts7M=; b=s5QYp6YuvpFLszQOM51zVcZ43z
	rtfFuMv0q5OUsuPe6r4qQjlm/D6AOmMvLphsSx+16oKBL2TvDjvH4E08s6xejXtPtsnHBkOsvqSSN
	TR/GONKeNcX6WE/KinCInuwOc9qviy1tJ/xvjwbxFnJUwKKie9j+nXONxZ+xj8Oo1bpBx12d3tjti
	E/ls25QIHXR61wabAYILJipe10ZB9akM5ANl8VEQrXTz081V5ZQG1uOUfN58QrIVtnPoPcXxfThkk
	d0sMM6CwLJyYjnzgRRruJaN2e876+IqIJavj+Rke9nLobcGLGmPdHCfE3vE1LaHsc8A8pqlzJcZ+E
	ZUI6sDdg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooep-0000000EFWi-2oEg;
	Tue, 28 Jul 2026 20:44:11 +0000
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
Subject: [PATCH v7 07/13] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
Date: Tue, 28 Jul 2026 21:43:59 +0100
Message-ID: <20260728204409.3396238-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6C2412000F
X-Stat-Signature: 98dxqa4ppy4wk9iqe9deht6kqxu9kt5u
X-Rspam-User: 
X-HE-Tag: 1785271481-383848
X-HE-Meta: U2FsdGVkX19NmtqKCmGGVoTISOtAq/LCIyHGvxELDRBYIuemAvFm64CRThjHVdknBN/rRwp+LE3z7ZAE6NSbLFeux1pRjKHW4e967C5orRRtpMcYS0E9jyO72dwS+tt/XFkaCuBxk0hg7dvYulv3wFjdXhq/MMbivubl9xwaM0hiuhvqmdIsMqtkIOKCd18MhI+SlqooxU8pFNK6RiyFw5xr9doo7uEJtVty0+ORGkmw2pxjDy8DkDvhoRGPW+MfXnbicrS+rr0csDQroUmsggS8skTeEojoNDGUTuKqrcVksNGi+grxkU6OstBcof1qJ7LHCYy2LoNabZLeadpcbec3i1FGwzuJBxOJFBFDk6qQJkUcdTYVK65A+2G3RUq9ayGUvQ7dZfq5lGvuZUlNQEhgbxelEsv9a3rBv4eCZ3K9Rxhvx7MgOt1jGhMIGxLC92lizssze9iZd2/CVYzxYOlELR0S8Q3YRKO/vTD8PfMqu9/zUH3N4gl8bu8cANA+p89o1yRMvQIsBL9IAH+lkyqib9asCPpqEoX6pzQWdq9Ry2TKBiOijllBe/o+G2Qy2ktHhf4hbM3g8E39WgLcn0HF1C1CJfF0375wXoAlkOrUWFaZWZEDtSCxxgSfvOQgafP4cZiPf3GAROQKt1Yp3YyslQaV2GOQK6JV75i1Cm8QQeNFqIKOJIGQM2Ka4m0y2gy8cGxCpPjDBzNsJUrFxH1uZQEAkuN2q+0NPcf+SGfOHWnOSEIoy+x5EZ7VrHvvzzAjph7oGxbOQYnNzpBoIrmz5IiaWNs7+JeKbEUGptDLIQ23pPN3lhiMRilyHJKvLRlKTJPPwgRH89qlkYv0LXN1qZpc8IWJ5frGivoNoRzxDeh7n17Kpp+7XMgMIa6Ugp4hqTuwhgeiZqyahx99sFvIFTNKCDPYEtw5qtdZdOWyrcSFVj0e40uY5VZIPNtXHSRE4/HMjYv0CYSQ6lT
 iUsEinvM
 1QsQ+Uw5IfKRqNwDDrHJNw2y9eoSYtDfaGeGeboQ3x4+5bJkKJcXa8Ew/tGgirwTDxxDBqb6YTG97fux/8/kv8EpY//KX+9tggG4OTTD90iRZc8FdT+O4Ojhen66yVNQ6UQ+86T5AE+dVefwWjVTDquY6Nroz7JjOrU7hMqooKmS2sZpzN4iwuQFqkkwYM4zaI+Gc2ytIspVHBCc5kxVXJ/H8nZOfb2XkQLoxTmm6abAiwJ0GNGYugRpmnMnY0Y7ml7ZcIqDw+oxqlXJf2x9GbeZeOcbKzL5uAJJJJkQr/VY4qj+vJkqy7D+ZRx54qcPpqmGcMm3Xy8C+AN8nFgGqwCrpJJhgDYn3gL3BbWEe+Jz0ch540UYJcL/vBSG4JGOjHRXLBMh4evXxkiki60SLf+ElmQ==
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
index fda6698e5e0f..30470f8ea590 100644
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


