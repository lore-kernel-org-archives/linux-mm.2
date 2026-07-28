Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0F2C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343556B0095; Tue, 28 Jul 2026 12:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4C16B0096; Tue, 28 Jul 2026 12:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3BC6B0098; Tue, 28 Jul 2026 12:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB34F6B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:51:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D05A40425
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:51:44 +0000 (UTC)
X-FDA: 85038776928.18.FA5EF63
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65827A000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:51:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cr1MWBnk;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785257502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a4PquJGep9XeLK1K+bYOdkYZpwLRUzc1gp+ascUjXRM=;
	b=dd0AYF1Y6tViXsIoMtjW36F1YPUcyv5WCzaQOax92RruNE5QqgWwI23vrlJ9PpLKaUvbOc
	LrhZGKO/J4Y2v8/CQPvWvKkDfZFIJ9eM2cLczmIDipbBvM3kIg0RRv5mXwHI+nFrmtYmUc
	aM309z1dOC/D9YKeOA9MlNTE+6G9vXA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785257502;
	b=ZXMlIJ1ezI6OdbA+fCxqEK8ChN86q9Jky5OKt3PbIeZIyRMQAUxlgqZW9raG2MSeL3DNg7
	e6xvK52TdSe4zxYEdZ3wF0gHa0ZBXPwNyfylDNmZWgT8nqc89VmimqYnhe0PY/VlSkfkbe
	nUEJ8eGEhBDdE7Dw7FosfCNiVO9y72Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cr1MWBnk;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=a4PquJGep9XeLK1K+bYOdkYZpwLRUzc1gp+ascUjXRM=; b=cr1MWBnk3m7+8EUdIGlVwuvOAz
	+dEvOVTN59YYcoayBwIFaBdrHKp4GuczEmJm8yZyrwmZEADAcbhIbD97KozqJ7QOXt+1Ng/u28CSD
	VyG150tF4UaFyMNm9Q1bJkmZUU/kpkhQF5HQO5HENHl2II7yQFpStGEdL791jrNFlLXDJF18eqOLa
	teTStpgmjWrlyeqx6jxW3h1/J8oDln9ORwLex3E3shLAZkyC39M9H3MSMISByLSwIkHHu/Q0cJ6CJ
	mv9seOnX/sRGuT3RyOv+Kos2kxBCfhkRFydfrg9vXqlxvCqD96MkzNk0dTmaKiWb7KLSIeIg3jxAT
	tpE8Sbfw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wol1p-0000000Dkti-17XD;
	Tue, 28 Jul 2026 16:51:41 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v2] hugetlb: Move poison to pages before clearing hugetlb page type
Date: Tue, 28 Jul 2026 17:51:37 +0100
Message-ID: <20260728165139.3278492-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 65827A000E
X-Stat-Signature: zaz5bt1eqqdqa9jawymgwz5go4tt6am4
X-HE-Tag: 1785257502-154079
X-HE-Meta: U2FsdGVkX1945KAtFM2GXtwFjQCeyTkd2/Fabx1Zgq4X8Rn/NrQdMw6WzRZDPuHUQiSHfcKmCzQJJoUWPLSEFPwJN/WMKKszOBOJBV6q76kV5i0QAlb0KxY3eoZTqlX6NYswdroimUgoUbfKN7amRam59F1q3nC9isOYRlWgqBQdSzA1TLMZuIdpluDyi3JDcU4BTSW7WzM7qU0VlfX+IyC64eqZJ2jx3QR/6qCf1u9MtKKwngXtMi6QrtvvfwMZ8KK9EqXR7PXlVsryI7KdFv1/0Z2v0LUExLAPi8pmiarMFXgZf7fGxQkBWovggYlYPQZujYmPaEaIfwN4KwG9n+HatqC/IVidAsC7uoxlsBGadVNKTaBlZTuCVQYXEt588bLi+Fk1cmLU1aVX+f8UjgNJ1bdp8Tuf0hE8soTMXrYVxJAnbhDRPAY1s1om4Ph832Zl/gj16YD0wTkBhzYodClY3MjoAviMpL2CaNZuOjbhEZ7etiNml3JblQoDUcrqA3tBl8xufviPP3T6mPv7YZXV5FveQ5cq3Zu5VvBdVZj9tui76KLrIgD6a9XHdGIikXab8izlKmoXVADW09V5K4Xqg1Z52fC66zJOC5yuS8smdJ4gVKTBwAyOaoCDXjyk6QE6JccynWmOUqLkyCYrLHc3gJKXdFyJMMpCMC6Gx13JohBgsEsCloncx61nBNQ9+xu/b4D0nMzp2mJVPrQ0EiGRQLdw56r3j93jeTdcwnq//W2gYfirOoWGN+rokXK+o4nMSMtR4x2LwVxm/9W69ODKktbuJmtCYP7KJiQ+eODNxpxV/4JFHmnEHDnK/pZfsDRI+xpT9MiuUSGEVaByex2hT0709NOhSABkrfIRRoVlOLzYNp0gaHDDhjkQjT92RZxe4B65FOV66yJ9aCntGZ8N4Cdcbma5QE4QmbNRNiTMz1FnS3qUfrVUg0FhcXdfACnd/SnA0CP+D4AsOKr
 +KAHI1Vs
 FcnryCOL39wPNkbtcpy1DfiKEWtDWW4GjpJREfTs2ean/PdsdeFtimeiJDmUdVRNARZoQOS/VJ0aa3JRt6p+nHf/jXXG59z6gLRHOfxzOr9GN8C5iYuYfkF8J0ncE8tAprSkc4kPfPjGcQVTuiT+o+OJR1NixEg7o/7c1khFjrVmh/k2wChrujDpqGjXq8BzX3AjFeIurx8J3RAmgQ2KrdxAGmVZ1gv25juoqNewAVaeDd3BwX0/2spqnftnStCcYNUvG
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


