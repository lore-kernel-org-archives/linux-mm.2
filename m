Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9EB2C54F4D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E2F6B008A; Tue, 28 Jul 2026 12:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF2E6B008C; Tue, 28 Jul 2026 12:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6186B009E; Tue, 28 Jul 2026 12:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22E1F6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:22:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 841681403F2
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:22:42 +0000 (UTC)
X-FDA: 85038703764.03.B46A673
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6CC50160003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:22:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PXGBd4US;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785255760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wSk2Ld0c6a3XqggT3KeRl4WdEkjEbh6p1yuvObcObD4=;
	b=3Hxha/FZ4jDVNcV4M1lfLsXKDXOrPSLeFJjkbNX+1Q2xacrmNGknGGvbq3Y7+XFWBlCNlG
	190ptukJ5q/gqM57UwNzRzili532eKRErj6L8CV7DtEDVmdrJQk6RqZUq+3vEBlqq3yq3B
	LB84B5M/VTTheL1DMDCbI7zxS1kjjxE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PXGBd4US;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785255760;
	b=3ClKsSvpijNb6V+RPVN/rxDQuKSqe1TZy8onZGf2YqXiEk3xcuYj+EifRdLbjDdIgef8eN
	X2fe9PbCB6kPMzSutho3blPI23dQw3d3qR6Lbj2fkSD/Zch0ToO+KvguWjGyJBf23ctJ+7
	WoYCi5CVpINiUFPkI0jOntTXCroL0GU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=wSk2Ld0c6a3XqggT3KeRl4WdEkjEbh6p1yuvObcObD4=; b=PXGBd4USwFb9LJG+HEpGlc5Oqa
	NVoEeNTUhQe4dx0lRQsO9l4SVGcZP6hsyDnHq8TcAtxckHAnyjFlwwjxAuvOZO3a4XhVRCPitO1CH
	0uE0vYRHT96wpdsXlP0lWoPK/lEN0SlmCsc2GfWF/nl6B7082mTWQD6r1WqZEI5eOiTnxUr6qUhUl
	6EfFDXVfKpUdnNHtux3SmydVSSmZlQKXpdiZzxf8juZTKRkZa9j9Fs1TIhLELU39penBwD67dV2mz
	WbV8MKToqkUP+AH7GHq/ganjTtXFkg2Pgrb8gWlwLyol+nlDQiiwd3jayrMDn+Jy6gQbB+eqzwWhO
	G1qCYUVg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wokZg-0000000Dgtl-3fNJ;
	Tue, 28 Jul 2026 16:22:36 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] hugetlb: Move poison to pages before clearing bugetlb page type
Date: Tue, 28 Jul 2026 17:22:33 +0100
Message-ID: <20260728162234.3263114-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6CC50160003
X-Rspam-User: 
X-Stat-Signature: jbuyo51o51s4fnz6j3khq56e7sbgnxcc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785255760-243090
X-HE-Meta: U2FsdGVkX19x2T85k20KduWVYvjC+j9ilGbsEkEa01p9SHTBc+dv5abix/gc9Snz2MykIoOqUvY5HeZnDIT2SyMJ/t5Z8fJvozPy5hYXEkdQpl5fZhXZQ9SRgi1Na0sgBxcgxp1DYcTka5YDC6ou6/zdUtFww3YjZkmrELYeUiDYszhkCyHcbGwFoGrhboKgKLFzer25hox4fjdJ0RttvpgMdpQn2mX7ONZd8GSFWW4tXT5nN0YamyVl9/r6dLToQj58+zV9s/ybHCQIFeCt0pBya4MFOE1xI7xiIuGAT9AwLXx8TJRdSP+XwuDqcDJP5F85cuj7cACtGY73Y6SkoTemTmqlLpfx9eOw0wAeCReq4f2zTQV5sEfg0GQwwGxUAfP/RDM6k6soeNs5OmyGI7yxsO5KzVhBGMd8v0Q40tUu/TaT6Ry6Ie6krdO2Oc0XVatCnmVNGT39Jgx3YL1ExBUwMeC1eYRB8RIhNIl5qW6AC2NSQHf3O2gYGtwpCcwPVli9gg9PaqdnTMlLZndi8yzIFLc2K2bEIqDM8rcnPzh3h7usmP0kpcgOy5ZUUHouk8i5QnkiHGUWSR0Jx4NaKAH9s/QjQL8WQ0Pp6dxAEsSI2BGhCGycNaEkRClEwms3N0+Z2022eYtGHZDiVypH+Jpi1rsLBvixgn+IqG+YYr8cTsv2073hg9bSTCo9xyXGaKWT1iqaqS4aeR96dVFjqVTOdYfECbJN6C/DabcYxSFqc+9HuIaVfVnfKfcBCI9r0fIiJ4eAt4FsOMrjXfBTEReVyAoo7P8EVOI2yfCrOw3Nqd3bk8sK+zfwe+GkgNKzDH232GGt2Fn4VL26505m0Y11BBtfAL6GXtY7Xhv22xGVG3V94cKk4pB1CDt5aJudKnutueWwBb85RqVPUAan5wJR456QNn09+kuYXFg2AH5mh0ffAshM00jTg4RvspCcwGQ4zAoo1g+34lh7hlo
 GCpAQNap
 3FRpjodYKsJpMwFJMIbNVZIy03cARvGJayAxbmZW0m8Bz26W0qMqExkh8mObDiYDyTfLnr4OPVBIJE2DdYCWCzWk5IYhbBfShsTox6lip6ZfKIIXaotleX+urhBkyfUxJFX+yqU6/rC3iV3RxkQZa2x4asAXVFHNsW7PvHptczDFqqMcfYecEkov4hJe0nCxAfgKth0PMoBiWgRt2UqwKumTAD332lGh+k6v7tvVQH5yAwnXljqbs9UxSvBfS6NvVZPq30Y/ZstD1Wl3CwQE/YkCrDQ==
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
I'm going to include this as part of the bigger patch series later
today, but sending it out now so Sashiko can look at it.

 mm/hugetlb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..27ee2dfaafa6 100644
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
+	if (unlikely(folio_test_has_hwpoisoned(folio)))
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


