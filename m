Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E343C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AF66B00A5; Tue, 28 Jul 2026 16:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED146B00A6; Tue, 28 Jul 2026 16:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC5B6B00A7; Tue, 28 Jul 2026 16:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 449E06B00A5
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4A84C04C6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:22 +0000 (UTC)
X-FDA: 85039363164.08.850E895
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F05E20006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JpjIaAJJ;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271461;
	b=EqwBgqAk8OEZGZpG3Rw0DM6HXiqh4P37UicBUpez09/L/1kD0VSwOzRiW7hkIiCqnfz6dp
	6Pp4zOiuONJ2cjjKlxKmGk3q3UPDEHlK+nwJVe7Ipc9PuD3KhLpVfsf0qC72Cq4m2m3Iyx
	vLtl6yMXj6vvRFG9yJDEgwPXc53+8Bw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=JpjIaAJJ;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4PquJGep9XeLK1K+bYOdkYZpwLRUzc1gp+ascUjXRM=;
	b=7JX5l1lLyCYreWQSp4yYGbqfEO/hHZtRiZD4RNNLoQKNiE28HOMrmFNUvJz5UMv5i5K0FW
	ZDDJkt7iV0uQifpLPE0Kyf1h/EEbdcREHGfBI6JlxQGJnQ25k4DRYMH23G+DFH2kgKBwcw
	+gJKIIm/v7PUAwtupHIHULR5us7plsA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=a4PquJGep9XeLK1K+bYOdkYZpwLRUzc1gp+ascUjXRM=; b=JpjIaAJJWZPSMroUWGjplUBdLc
	mlP/uqIw0c+YKLKTfQlNOp2VyqngzoMhKkvTPE75Z2yzNCCK2xitJlZJjojJgB9OkWn0JfuUndGQ5
	iORept6TGYMsmpksrpVfbkcUYq8vCkcJu6yn3p+frhTz/6wmnmKu+3oj/mtxwUS9LNyy2WrTw0REM
	XX7UwLEMMFHUNxQWS2w05OM6V9THMfAfRe4nd9D0K8AKSQqI9rA5sSkHZkKLMozXngmOv+VMVoZYy
	yi/ZaawtM3LoZmHLLrvZbgmAFSrYJPFkGNCzTPEskksJcT8huas8Oa3fNAqiBHDjR5kdDvMGcX27x
	VS18wrMg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooep-0000000EFWd-0lbL;
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
Subject: [PATCH v7 05/13] hugetlb: Move poison to pages before clearing hugetlb page type
Date: Tue, 28 Jul 2026 21:43:57 +0100
Message-ID: <20260728204409.3396238-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3cpfcc9bqi7d46dgu9gaaspi3a9usmux
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F05E20006
X-Rspam-User: 
X-HE-Tag: 1785271461-806567
X-HE-Meta: U2FsdGVkX19NQUF84wykdP9a+H/MgbGgij4Bm0lOMhK0X7BCqtaM4H9M7w0i33J2PL1laqZvMKTw8CdYJEGJ1O9mSbsmvo20TMSWIm4c/21T/l/QsMvmVaNgwv4Y7PMV77ajDF1rUdW/CW4fLEUnLddLoJ8ayX6oDYqXm5n4npQN/NwDEwEzSqL1LXenwDV7tqgVhkjCfe42FcvEOEMBZuvpdr8TJw7Ob1+LCvV7fMCxIRW9s9FRo8IlehAeEg99OoCqTN/FMRPz2hpii74RbvlNU8+DTe5RRjdozgno8Wjpyv4/zogw/ET0t3M29YQWw6aTB9UCtJS345meHcaYAIvwLwsop7qvcXHkAieZpNFGS8A26NzCG7J7T0fWkzbUHYWj4q6N0DEGNNihy3htacEw88XVwLTwUPiDe0H4y7xwc43+qOqWZty3dA5m0Mkjl9/Ma9GeelRHoex8/GJkmluGa7mXnovZuOLNO6CcqCTtCjrFUN1hhkTKp7T5mcNhT6nWJwCPONJKyxsFkUV8wW8FGrBIPB2SlN1Wn/AyiKjK5zS7ZG3vwgagM/xmsbonQixw2ps7Ng/f3gbofygmNnAdV4p2EBEhjd55Vc7gIsxxf8TsTCsoeFF7/9cj1X0Bp64SShtcEWK2enMsBbePh8R9T8hAkb8ibWYYY9tYBjlSKlCPTyLlYh0MGIoGpZnUATIktW4uMJPdampf7m5Ll60AZmLyShXz8MqHuuW/pZkzVBe/eHzr05UqLTM1zyL8QYHLCpAQ18CEIwTpwUHvCNmqOxcZq4bvDktjMJZ8PeDH4z6vBDaoSsR7henqSz4KhqWQk4S/Hu9m2xiyJfqtLH03YSVFghMi2nVdwoaKvvK9pKo6Twu8px2U9WPjq2YQhXqX23PHJEDY3mEDcIXhylpIoP3seB0tcA8JAaoJq6Tv9g3tmayaG4P+SMC9iovGRvOOh3AE+raoShC0kKV
 XgjqzEKL
 O6c3jSowcHLNbLzelZDq9+7bX3CE5EGHbuC2+yRvbm0WHNMu96IGV+raH7Foq1gMY6TuQvTXFzb2l6Ux9OX/4NNw7j453p4LqDs2g/O51VM3pr78LCOe4rW0537t4eRqPw8usSAxmPUB7gI4f2Y0JT+uwAfVXnQwFCHc6UKpPTf36iDmMnQ8DtS+yHIOIvNQ7aoenHOmcGEo6NBka9OZ33LvszYT6gAFgOlF4XgUyf6Yz99JKrwJzIZa1kw7NnrHdY6bE7hs/BnMLrFpQjxGLaWAbCwjciqce4EQaMngN4a4jOPeytXU2l6MAzybDy+BxBjDGypET4FEYxhY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For is_page_hwpoison() to be reliable, we need to set the hwpoison
flag on each page before clearing the hugetlb flag.  Introduce
folio_clear_hugetlb() to make this easier.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/hugetlb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cc8d98399913..47403d02be88 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1381,6 +1381,18 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int
 }
 #endif
 
+static void folio_clear_hugetlb(struct folio *folio)
+{
+	/*
+	 * Move HWPoison flag to each error page
+	 * which makes any healthy pages reusable.
+	 */
+	if (unlikely(folio_test_hwpoison(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
+	__folio_clear_hugetlb(folio);
+}
+
 /*
  * Remove hugetlb folio from lists.
  * If vmemmap exists for the folio, clear the hugetlb flag so that the
@@ -1419,7 +1431,7 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	 * to tail struct pages.
 	 */
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
-		__folio_clear_hugetlb(folio);
+		folio_clear_hugetlb(folio);
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[nid]--;
@@ -1493,17 +1505,10 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	 */
 	if (folio_test_hugetlb(folio)) {
 		spin_lock_irq(&hugetlb_lock);
-		__folio_clear_hugetlb(folio);
+		folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
-	 */
-	if (unlikely(folio_test_hwpoison(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
 	if (folio_test_hugetlb_cma(folio))
 		hugetlb_cma_free_frozen_folio(folio);
@@ -1595,7 +1600,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 		list_for_each_entry_safe(folio, t_folio, non_hvo_folios, lru) {
 			list_del(&folio->lru);
 			spin_lock_irq(&hugetlb_lock);
-			__folio_clear_hugetlb(folio);
+			folio_clear_hugetlb(folio);
 			spin_unlock_irq(&hugetlb_lock);
 			update_and_free_hugetlb_folio(h, folio, false);
 			cond_resched();
@@ -1620,7 +1625,7 @@ static void bulk_vmemmap_restore_error(struct hstate *h,
 			} else {
 				list_del(&folio->lru);
 				spin_lock_irq(&hugetlb_lock);
-				__folio_clear_hugetlb(folio);
+				folio_clear_hugetlb(folio);
 				spin_unlock_irq(&hugetlb_lock);
 				update_and_free_hugetlb_folio(h, folio, false);
 				cond_resched();
@@ -1653,14 +1658,14 @@ static void update_and_free_pages_bulk(struct hstate *h,
 	 * should only be pages on the non_hvo_folios list.
 	 * Do note that the non_hvo_folios list could be empty.
 	 * Without HVO enabled, ret will be 0 and there is no need to call
-	 * __folio_clear_hugetlb as this was done previously.
+	 * folio_clear_hugetlb as this was done previously.
 	 */
 	VM_WARN_ON(!list_empty(folio_list));
 	VM_WARN_ON(ret < 0);
 	if (!list_empty(&non_hvo_folios) && ret) {
 		spin_lock_irq(&hugetlb_lock);
 		list_for_each_entry(folio, &non_hvo_folios, lru)
-			__folio_clear_hugetlb(folio);
+			folio_clear_hugetlb(folio);
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
-- 
2.47.3


