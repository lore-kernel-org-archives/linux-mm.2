Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C504C531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED61F6B0099; Thu, 23 Jul 2026 10:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADD26B009B; Thu, 23 Jul 2026 10:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEBC76B009D; Thu, 23 Jul 2026 10:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A06866B0099
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:30:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F755A1153
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:58 +0000 (UTC)
X-FDA: 85020278196.15.591437D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5D20D1A0010
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RF0dAL5x;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWzDgbDHh//kjXI/UxyCil9pIzMkVEMEYobg48le8fA=;
	b=cNWrUbO/1m1dkz6ILi8gevn+6BgTbxYDwLE4n7HlGmvGhAqHm/kulIMAqfbVAfaJGEOnmD
	v1DbzkeKhk4A5CEkeNGoVADfRB+Lf24W9f7DitVVq6EJKfsCtX3jyXK0koMdiEnlUjEJZs
	Zuw0vWEalHsPqaIJhyD/2gimzIBtmzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817056;
	b=sDDrQ9XUr8MpSPU0Efaa6TnlMVdpiRECYlkNiZUQc2vN8Cc6RTMUKzAgZugtNjuOcxSsLa
	Gam4mpWsIUVjtT/+ohu6Zav6tM9zQDUxjckkWv4445T9qq2O5FWupfycmcY+RqHkJUjovB
	/8X/MQDjxpjHGuLJmen+w3HDQ9IM/XA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RF0dAL5x;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=pWzDgbDHh//kjXI/UxyCil9pIzMkVEMEYobg48le8fA=; b=RF0dAL5xzCgBVp2cK1G93xF2Qt
	nwnm/gIfwlF586XfPkjlxdKVuiRoe3O1I8BSXvIZ/LzoLkkJQewcaB6ztYIf9D0sd7SClqep+jfga
	CF0A5lxFBiUAqGUdmS3liGX9CuVbepfguCGZFf/fEKuM51dyw7jmBTwnx9mIEZ9aFZ2o3pPycKhWa
	G/rc8OsHfnGH2dz2PfTXpb3zC2PxfdCIKhBHzaXMHxcFBeL4cd/MOaVG9s6Yx08/OWyX7s5lwN9MO
	CJQd6FpH1EiWmG0CsVty6fHCjAAwknbM5m6BX3OsNt0LGnkz9ELTZ6mK2oiiVXMOfvs7wrwg0arR/
	XRORdQ9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRZ-00000000jhz-00cA;
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
Subject: [PATCH v4 06/14] memory-failure: Remove raw_hwp_list_head()
Date: Thu, 23 Jul 2026 15:30:23 +0100
Message-ID: <20260723143034.175661-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D20D1A0010
X-Stat-Signature: 4x19wxyooj58e533opmnppxo94jpacgx
X-Rspam-User: 
X-HE-Tag: 1784817056-725447
X-HE-Meta: U2FsdGVkX19eyEdG7YQ4jLS3GmyXBCTZ5oNHifR7m8ugO+aYa2o8Aj/cLlaIU0oO/2zoj4IEeKlSboxqYKalB8uelsSnpYvJ5FxWSMhx+nkk2mu0E7xMK9FB43qsUc2t9nkU7b7qVFvnuHAA6dLPWWwTAi8FDzccjhIC6jQCEfLmCfqCFF5+mjuf7bMMeMJRdzxoYuOro+gcq+ADQ91DSJeaLki1p//l7LrEQq9BMr6orPclRIeZPy0nQqL7Gzaj56+vmOXGkVhSBxIn50SnRcwYrj+QUMplRwicg5/RcHCXOguIJIk1wKklZMupj/y9JXl11IgTRG//IA6u7qV++0ZNRegx6mK4NOeNr9a6CihP+NSL5C3WyEwCK8UENXeyqTwGdCLzKFWLr670kM0jkDIHznZC2hT28TLOQsOsc31W5OxXFN1YbZ+ecZRz558koF2PBL+R3Fx4jo6eGKBz3wqDEV1Afnw4ik+lItSCgtHhyAqxZ3nrzimqLKDzqheDER1dlmDKRaRfGCRopVUBiez/wC1HHHDSvtj7rAjU2GOc9R2p/AJxaK597mqx8u3Dsji+bvL9YbbOb14Vb8MmixeXmvxhLJtq2bhLdG9MY79ED0AUsMMS0zdRmNjO946jcY62r0Fo73zIam7O13Cn2dX53WJ0WKRpXLVx0Wdtacjc3r4ugKyIzrJ07WId+M75o2Gsjg2iOUfjCqx9ws7G/QN0cuOd234dcu9YCvpmq6E5jfUi1mFUzwzi6fXlBwYVSEBo92W2UQhNxDFlqI1XMhZfu1mJPBWq6XuMlah/sqkYZzFatXSWMOf2+/W3esnYzQDUO+2x/q/Bh9Ueh6J1N/rgam8F+5fEuSxOIpPpQHXOmFoJ8BRxhDrwdQFSGDSAkOuFT2HvALDchX7/LJOfDMmGlM8IotksbbnTyaAkPE+bSI3ic29hXons+SI2PFz3YiZTAznsEVWXczANYvT
 zbqHisIY
 rg3iP9XXVhLEkkW9drlo5uy+DI1w7QxXLIKFbIbF4wT1sYyTUJwg4Ocxl1Up+BM2jUhMoVsICDz8jVHulmbmbDNwZqH5tmnrJdCUFLkOSWHaaL05wjQL+j6daDxYnaKhUURcUHcVpU3urV4Id1Z43zfHG9piUmoSgR4pPuPu6BcbZlONv/gBiPxH9u5PHz+ZlAuZNUQuTpQPj0WdO2nYJYqEkRtsEPPjAVrx5FRE+/t2y07P3WbJ2UwxonaiHORJ1IvwtZHQeGUzHwPLKRVlc2NtviwgGvN3n+eW1478Kbx/DT0G+k46KziNSc44RqfEim1gEdHaE2hPKklNJJmP+PcAfB9Y6RMwPwbBOdzle3M+qEmWYfEUJ4qWj57JnJDYp/clPzhifXDv138r11mJGDF+N+g==
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
index b18c2b2e7d2c..d7a9b0d8bbdf 100644
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
+			struct llist_head hugetlb_hwpoison;
 	/* private: the union with struct page is transitional */
 		};
 		struct page __page_3;
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3615ced0a11b..18691c905ac9 100644
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


