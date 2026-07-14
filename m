Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F616C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87C96B00CE; Tue, 14 Jul 2026 14:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60C06B00CF; Tue, 14 Jul 2026 14:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DE26B00D0; Tue, 14 Jul 2026 14:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 909C96B00CE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1859E1A04A7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:07 +0000 (UTC)
X-FDA: 84988168734.09.F2D8FD6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7063414000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="E2SjIS/F";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBc0BLjnLxBj6be7rNfjSxMRe0katow/KmWRC7YugX8=;
	b=nJrJijrtJGLGjIoH7JDJsEIeKDaNLR4kB6gbHlAz+gyjcaxw8M1zFaDy3kUhsR62Yk5p11
	3xa3ef4hUds/zHlO3jI4A+92IwnVF5PJw78+QJ2P2/4t49RK6ZeHO5wNdfH5tHCQQLuZ2S
	klmU/Zlz11d6CNvEKW4qsQySCACRvSs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="E2SjIS/F";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052545;
	b=JMBBZN35I9mPrDjPRWQYg4obYUIsEjXnj4IJ3M1QshfxlVWG2RGMS7BPY93xxRJaqSr/Ij
	W3xWfWHdMACAyWGK10V2CffcM8NHpMKDFU5PctseDMTc6lwgmhJsXtLGnyuaOvUtVk7aL1
	e28SjL7QHW/Yn0ArjO3HnOthl0DVowM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=jBc0BLjnLxBj6be7rNfjSxMRe0katow/KmWRC7YugX8=; b=E2SjIS/FvUT+BiHx43vzMhtiFJ
	rxjDCErkqp1IDOTaSikDI9P98JYpeQh2WbqD8yawTHcphgmHnotMFL5lmwl8TG5eCh4PTV/3L3CBh
	3+QWh4DU6OuhYV87DK+8IqwMBVemWKJqEH59/hX/mgs7mI3pwCpxGpQvcAUJFuCdoALRFhruq0y5r
	5qvN14qMGp5avEnPHKLrsUELqJ4pNSPROwgmCmUOLf5NnKoPEa2PEgHp4j9k4jnJSUMuGyw8Fbdd8
	oqabvLo6HqIfir8YExe2ZLeWRUQgdmuICGMX4ohAVt8ZBphyP4Y91CfDF8Lkr32oB8FLQqVrJEEZW
	fzMOUTFA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhYg-0000000FegU-3qiK;
	Tue, 14 Jul 2026 18:08:42 +0000
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
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v3 3/9] memory-failure: Track hugetlb poison in a hash table
Date: Tue, 14 Jul 2026 19:08:33 +0100
Message-ID: <20260714180840.3731244-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714180840.3731244-1-willy@infradead.org>
References: <20260714180840.3731244-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7063414000E
X-Stat-Signature: 16su53c68u97t31huznmfm7yiefuahzm
X-Rspam-User: 
X-HE-Tag: 1784052545-778100
X-HE-Meta: U2FsdGVkX1/EqM/BWOQGVIvPI7sZa5e+FA93d2qhJfT/jwgcxtsJCMHZM5iQwnPfQv23m6xHpSqKvLvazgpXRutzc6Y/PJlAtM/Ik57Z37qTxnWGuft5tG8/PJ90rG/vPiPEvLjAPf7L0R9gD5T0W9ja+bXmPZgsT9FhbIxbaL0X2U3WS2yWnbPmpYtBFUkOL25P76O5MZtHM5601TJBUdah07L1gy7dDaCts3Cs7nzy0H6Sz5nPCsxYeSIDS3Qb0IaK8I7K4ztHfr5ZbNT6Na+O/1CB0RB88ceby6Hn3W7/uJQTA7CeZu/V999nIb1hDD63jFvk1b4yGBx5vA2sXN3RPqup8hqfwdT96qT5NSaUj9vrOamKoFibNbSmLG/R3p9mSkbJCpeWoSK9QL1DklujLmDBHz4BhNFUjtCHot8hacFmWdoaIvFgwN+zuOGLq5TecMM2K9XjFWyF5E3463rpKVvhmd7na6QPTi7U671JBjEGtWnodoAatmon2pPPe+aTkkXO9Q82aeW2U4A0xSDIcD2LBPANcOUwufrmf9je5OBT8NRD+ok/qE4oyAcgY42X3OT3FluM6D25SfGjgIMXUReth2qVGJK8efP0v+bwbZnn3HwBvifDanFiiITMRVAGlbIBt6j3V0FXOPSFe2Gy8mckAo61ZCZv0eDbMdfJtS1AU2RrEZInCyuTimvI/Tonf5GZLz6Hs6lVygeBGjItaEdfz/sD8cie2992x8Az5D8gc0q7XxJsNb+YAyvfFDSLIDT+9L/hd8TZKQNft0iQj2MuLDGjc4jOCIO3zaLlVNmFH9Vh2jTGkRa84FAJskR3wVkmmEr2OLORiBKKkxaLzHCnX32igWuNMlfZeglGXWHyXOzQw3IcVqNVSzDNeXqWHD02znK5Sb2LPR9LrPN4kZscOuRDksc9v+G5V+Hs3mRhj2bi8yp6FetHMit7RdtzJTnTC31jl0dhvRs
 vHqmkJtC
 JMKKnC0VOZejCdsDjj1UItV7BHNFk8cmmDJ2+M2QyFXza4fSjGk7qfKEpcZFGWAxOg/IJku/Jrt1ieSTBM7VsLO4HAa4jOklrl+VSC7k/hmKhAWS2BgjSg+3DvI2ScrN8a12XTHsbANfh8XAXn+ecJCKWlLhUFx4HP4Nd6Cc3glJuql7xazrf8T9i5/h1/btfLqOr5x0TG/B6WFf5JfdVMip4gpBItbFqHPGM8Q9tpFXzRmC+jRG9T0R0VSRWFG1r1CQw818W1c90VQC+PaiKiddhgMdNtEjVZKQl7Mng+ZDf92L+0jjhEKL6mDFI0wA7pvYRVa4tOYngm5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With HVO, we cannot track per-page hwpoison as the struct pages are no
longer there.  Instead, they were being tracked in a linked list
anchored in the folio.  Unfortunately, we need to be able to determine
whether pages are hwpoison without holding a reference to the folio and
there's no way to atomically check whether a folio is hugetlb and get
the list of hwpoison pages.

Switch to a global hashtable of hwpoison pages which is only queried
when the folio indicates that it has pages in that hashtable.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h |  2 --
 mm/memory-failure.c      | 71 +++++++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 36 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..ed5c0829ff56 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -387,7 +387,6 @@ typedef unsigned short mm_id_t;
  * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
- * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
  * @_deferred_list: Folios to be split under memory pressure.
  * @_unused_slab_obj_exts: Placeholder to match obj_exts in struct slab.
  *
@@ -499,7 +498,6 @@ struct folio {
 			void *_hugetlb_subpool;
 			void *_hugetlb_cgroup;
 			void *_hugetlb_cgroup_rsvd;
-			void *_hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_3;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..490aed0b25b4 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -43,6 +43,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
+#include <linux/hashtable.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -1808,24 +1809,18 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 
 #ifdef CONFIG_HUGETLB_PAGE
 
-/*
- * Struct raw_hwp_page represents information about "raw error page",
- * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
- */
-struct raw_hwp_page {
-	struct llist_node node;
+/* Protects hugetlb_hwpoison list */
+static DEFINE_SPINLOCK(htlb_hwpoison_lock);
+static DEFINE_HASHTABLE(htlb_hwpoison, 5);
+
+struct hwp_page {
+	struct hlist_node node;
 	struct page *page;
 };
 
-static inline struct llist_head *raw_hwp_list_head(struct folio *folio)
-{
-	return (struct llist_head *)&folio->_hugetlb_hwpoison;
-}
-
 bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 {
-	struct llist_head *raw_hwp_head;
-	struct raw_hwp_page *p;
+	struct hwp_page *p;
 	struct folio *folio = page_folio(page);
 	bool ret = false;
 
@@ -1842,36 +1837,39 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return true;
 
-	mutex_lock(&mf_mutex);
+	spin_lock(&htlb_hwpoison_lock);
 
-	raw_hwp_head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, raw_hwp_head->first, node) {
+	hash_for_each_possible(htlb_hwpoison, p, node, (unsigned long)page) {
 		if (page == p->page) {
 			ret = true;
 			break;
 		}
 	}
 
-	mutex_unlock(&mf_mutex);
+	spin_unlock(&htlb_hwpoison_lock);
 
 	return ret;
 }
 
-static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
+static unsigned long __folio_free_hwp(struct folio *folio, bool move_flag)
 {
-	struct llist_node *head;
-	struct raw_hwp_page *p, *next;
+	int b;
+	struct hwp_page *p;
+	struct hlist_node *tmp;
 	unsigned long count = 0;
 
-	head = llist_del_all(raw_hwp_list_head(folio));
-	llist_for_each_entry_safe(p, next, head, node) {
+	hash_for_each_safe(htlb_hwpoison, b, tmp, p, node) {
+		if (page_folio(p->page) != folio)
+			continue;
 		if (move_flag)
 			SetPageHWPoison(p->page);
 		else
 			num_poisoned_pages_sub(page_to_pfn(p->page), 1);
+		hash_del(&p->node);
 		kfree(p);
 		count++;
 	}
+
 	return count;
 }
 
@@ -1887,9 +1885,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
  */
 static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
-	struct llist_head *head;
-	struct raw_hwp_page *raw_hwp;
-	struct raw_hwp_page *p;
+	struct hwp_page *p;
 	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
 
 	/*
@@ -1899,16 +1895,18 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return MF_HUGETLB_FOLIO_PRE_POISONED;
-	head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, head->first, node) {
-		if (p->page == page)
+	spin_lock(&htlb_hwpoison_lock);
+	hash_for_each_possible(htlb_hwpoison, p, node, (unsigned long)page) {
+		if (p->page == page) {
+			spin_unlock(&htlb_hwpoison_lock);
 			return MF_HUGETLB_PAGE_PRE_POISONED;
+		}
 	}
 
-	raw_hwp = kmalloc_obj(struct raw_hwp_page, GFP_ATOMIC);
-	if (raw_hwp) {
-		raw_hwp->page = page;
-		llist_add(&raw_hwp->node, head);
+	p = kmalloc_obj(struct hwp_page, GFP_ATOMIC);
+	if (p) {
+		p->page = page;
+		hash_add(htlb_hwpoison, &p->node, (unsigned long)page);
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
@@ -1920,13 +1918,15 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 		 * Once hugetlb_raw_hwp_unreliable is set, raw_hwp_page is not
 		 * used any more, so free it.
 		 */
-		__folio_free_raw_hwp(folio, false);
+		__folio_free_hwp(folio, false);
 	}
+	spin_unlock(&htlb_hwpoison_lock);
 	return ret;
 }
 
 static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 {
+	unsigned long count;
 	/*
 	 * hugetlb_vmemmap_optimized hugepages can't be freed because struct
 	 * pages for tail pages are required but they don't exist.
@@ -1941,7 +1941,10 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return 0;
 
-	return __folio_free_raw_hwp(folio, move_flag);
+	spin_lock(&htlb_hwpoison_lock);
+	count = __folio_free_hwp(folio, move_flag);
+	spin_unlock(&htlb_hwpoison_lock);
+	return count;
 }
 
 void folio_clear_hugetlb_hwpoison(struct folio *folio)
-- 
2.47.3


