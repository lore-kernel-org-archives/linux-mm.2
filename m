Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3751FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D076B00A1; Thu,  9 Jul 2026 14:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC5A6B00A3; Thu,  9 Jul 2026 14:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCEF6B00A6; Thu,  9 Jul 2026 14:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B44E06B00A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:47:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C241402A8
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:56 +0000 (UTC)
X-FDA: 84970122552.19.7059AC7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6B3E940002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:47:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S4Tv8EGY;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PI1T4q5X682UwZ4EURsA+/ZoxJRVoodZbOrIQIJ/AVQ=;
	b=nVE5DKrX+wb3zebohP/tkmwFoMVg8h66OGJIeW3v6dTBQvhFLETFA9XSAWXDxukhqWVaTZ
	CHd73LrkIzvx1misufdIkRWaMZcJn2ogDLzrHqJg1tHji5+31VNmQEQftDzq/9Ag8aIGXt
	oQ1n2R+MccirCVPlv+t5OZohQYPz+2s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S4Tv8EGY;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622874;
	b=A9jlXgtrhHEFIXaQ1u+XOhRjCujld/xmtf5crlz/qRStpOT/KXyxA2X02NZ/DDmTzbWIUT
	k48ropK5YWhwNPIQzqKs30At8O8UquSA0kGawWWI8zgFpaGqUnsL3cLlV3Yh+iJTKXU9jL
	B04uJs47XqWnjjwhhfStN8cgSyA7PcM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=PI1T4q5X682UwZ4EURsA+/ZoxJRVoodZbOrIQIJ/AVQ=; b=S4Tv8EGYY++NwAF0kQcSLoL7pl
	xpLZ+uLJ+mYVW+wldiNH1mumhaYiNq18TnXsgdn00W/sPi4z2fCK5BFyC9oy2ImTlRoJQjDVCWq12
	YrM8gLGbm43taDEpT/2SehGvMlcEfT37cCHY4EOIZm7l+Fl8eJlO+C3TyI8+kn7O1hD3LQCQDuPSl
	MH4712qCgzpmr92zpIAxIJqS+Q+N3Ot9qXR3dixU4xvysHFCw/m1DIYoQBySffGmp67h670cRaKus
	ZvW0iJwfhPpdG0ESw/lh1/lx1r8jJs6tH3R+mKFDxrnNaR/bkNFb80IVha5piCLK7XJmp6zX9TuDH
	6DJxB3Ig==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhJ-3Fk9;
	Thu, 09 Jul 2026 18:47:42 +0000
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
Subject: [PATCH v2 05/10] memory-failure: Remove raw_hwp_list_head()
Date: Thu,  9 Jul 2026 19:47:33 +0100
Message-ID: <20260709184740.1286561-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B3E940002
X-Stat-Signature: 5afs3wym6dfas8dkmfh6euhd13euzewz
X-HE-Tag: 1783622874-888214
X-HE-Meta: U2FsdGVkX19hrZmMO5kcbRLx4nRHFMMWKe0Pgz7DX3NTa6/r2dva2qIrlBuj14orPDtrcQzi1eX8i767BEjl2bZBpdI1Kh1yPtWn/EYHN4Y8rUstIhV1DbZQvY1GttQShqEwihn6slqug3I7H9DrLVju4kuyFdajxrw9lOdmLVjlvOyaVvP83Gg83gBGKquM072gqDzif0InZnxl0DLXECmYcOA/RI8qnVHR8vmhFqbp8uDbWVAsteD0UIYdTJVmPM4J5Co292GSrKFFOitja4VOcKgq5I9v8OfEenS7gHFmz7Kz9u5n2AkM1tyXhEOt3uQB4OEEwrHPCSUZJ8UnFOHgbs4jllg5KrMm3ggWvCVfu4p+3n04Xx4DEieCdSIl85GPsD1gZGTFUUf73wmE3U5hj7gxNNLIwICfO7641s2cpwQYh59deDlVawfHuUwrQa1LUq+2M7zUf8vrc0QbBuPrFgI3eENBi6RJJrWP5N77HcM23A7t8u9wgHzhnhp2WGKxV0B6resfFDKI1X3syUG7un/eWFSyKH2bLQgmcq5qkHuYceZRrYxXbTxs9hTXBrJkggwi93E6t2F1LrMjOZP4vKB/vcvJa1XfCsRA8n0eu6SuMIV4GX9KHccfcLVfcnJvmY3tnkeFvUCgd4jmRKuIuTC5HCyPCthXWqTcqZpvWx6aFnDppM7+amJpK9JlpAcSAyD26pf+LxF7YsKlgfqEAk5AGBP3yl/UCj/QB0DH1y71MIwZA+eAVdp5iHOwxD/y2BTkJR+NbZju7vhDl9q8TtKYEAV7XrKwtuoDPooGYQg0yZkDe4kxBlOag8lj97Pifo9KJdaHWCI57D3bsauLEhbk8q9KoPcPe+wd85IZ6Nvg+VWPS2ACqrwBIVSa4a0+L4B0ae1psteVpiM39m2gK4KGjO+aQdBynZ7B/9DRMNCIOEfkgkKmXSm0M6e/YyMDYjk37Wbz5JFQibw
 VMj81bU/
 bXEPhbK9I4K1CKnRoquRQH5yiiIriyVECn2DQ06cGNjfpt1G8kbfE0LJhf6F4Y4Buetq06T71RHzptgY2OKw5+n4FUdC+KOh8+3TqvKTMyV7vnp8vqOQgIfK58sq2Yg3yeN5dX7I41ka7brUNqJiTGUNcQsTU/Tko/Gf7A2Bfnp8OfKmEIsdd88Uy7O2li3qfE91sChV6X+DZfthPWfg5YVL7R2E4csaYBrXOUiL4c080rWWdjx5rn8E2RiCAXT1Uj8ON0xnNgGmkEnWSg5KLD46OBxJS3XdhDUrI6PvQviOZ85n7gYsGP5/CVzMI4PRfSbm0j3rH/GphKIbwWA835jXLM1PP9x19Fn3V06dJcLGf73GhiICHM7S/WY9JqgHWH6qjHBrGswAS9Bp6Uxkeryzo0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to hide the llist_head; we can just declare it
directly in struct folio and do away with raw_hwp_list_head().

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h |  4 ++--
 mm/memory-failure.c      | 19 +++++--------------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b18c2b2e7d2c..d46f81f94848 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -387,7 +387,7 @@ typedef unsigned short mm_id_t;
  * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
  * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
  * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
- * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
+ * @_hugetlb_hwpoison: Raw error pages, see struct raw_hwp_page.
  * @_deferred_list: Folios to be split under memory pressure.
  * @_unused_slab_obj_exts: Placeholder to match obj_exts in struct slab.
  *
@@ -499,7 +499,7 @@ struct folio {
 			void *_hugetlb_subpool;
 			void *_hugetlb_cgroup;
 			void *_hugetlb_cgroup_rsvd;
-			void *_hugetlb_hwpoison;
+			struct llist_head hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_3;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..53063e2a1f97 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1810,21 +1810,15 @@ EXPORT_SYMBOL_GPL(mf_dax_kill_procs);
 
 /*
  * Struct raw_hwp_page represents information about "raw error page",
- * constructing singly linked list from ->_hugetlb_hwpoison field of folio.
+ * constructing singly linked list from folio->hugetlb_hwpoison field.
  */
 struct raw_hwp_page {
 	struct llist_node node;
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
 	struct raw_hwp_page *p;
 	struct folio *folio = page_folio(page);
 	bool ret = false;
@@ -1844,8 +1838,7 @@ bool is_raw_hwpoison_page_in_hugepage(struct page *page)
 
 	mutex_lock(&mf_mutex);
 
-	raw_hwp_head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, raw_hwp_head->first, node) {
+	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
 		if (page == p->page) {
 			ret = true;
 			break;
@@ -1863,7 +1856,7 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
 	struct raw_hwp_page *p, *next;
 	unsigned long count = 0;
 
-	head = llist_del_all(raw_hwp_list_head(folio));
+	head = llist_del_all(&folio->hugetlb_hwpoison);
 	llist_for_each_entry_safe(p, next, head, node) {
 		if (move_flag)
 			SetPageHWPoison(p->page);
@@ -1887,7 +1880,6 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
  */
 static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 {
-	struct llist_head *head;
 	struct raw_hwp_page *raw_hwp;
 	struct raw_hwp_page *p;
 	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
@@ -1899,8 +1891,7 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	 */
 	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
 		return MF_HUGETLB_FOLIO_PRE_POISONED;
-	head = raw_hwp_list_head(folio);
-	llist_for_each_entry(p, head->first, node) {
+	llist_for_each_entry(p, folio->hugetlb_hwpoison.first, node) {
 		if (p->page == page)
 			return MF_HUGETLB_PAGE_PRE_POISONED;
 	}
@@ -1908,7 +1899,7 @@ static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
 	raw_hwp = kmalloc_obj(struct raw_hwp_page, GFP_ATOMIC);
 	if (raw_hwp) {
 		raw_hwp->page = page;
-		llist_add(&raw_hwp->node, head);
+		llist_add(&raw_hwp->node, &folio->hugetlb_hwpoison);
 	} else {
 		/*
 		 * Failed to save raw error info.  We no longer trace all
-- 
2.47.3


