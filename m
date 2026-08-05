Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8BE8C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D686B0099; Wed,  5 Aug 2026 17:06:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDEB6B009B; Wed,  5 Aug 2026 17:06:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDA46B009D; Wed,  5 Aug 2026 17:06:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36A996B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E142A0630
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:16 +0000 (UTC)
X-FDA: 85068448752.08.20CCE88
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1684A000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BNAnez1c;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GltmsNqVWJkuDcD5Rt9s3dnWU67+Xt6v0JKxF0Dmboc=;
	b=A+yOdAwv/+lh+VZA2oiISWX738+cBmEF7WP8prGY09JSRYc8Pfr5MN9xru4PQtveddcqvl
	qQteQ4IiB5h7nRVfDBuJ1vQ3v88q2XVqI1LbK3H5/XQRG5jyv/a5kBxd+0s92LPdSjYQYe
	r4HfvOlBcJF4pGR0AAzyOCWwf3vhiLA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963975;
	b=SkdpEgiHxDPg5yWmHozJT+1Mb61J1Q8qb7RguNaEcNDIF5MOve9hsJQubs3V8aIQWwNqmr
	zY6lDBuE3fKlQjrG7xghTk7xlakYFXfsQLZO0jC+sKasTA60RUxahUxUpUgqpE9QojCgm/
	4T8WIr+9zFckCn1kqXhjsiLukKzmiKo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BNAnez1c;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=GltmsNqVWJkuDcD5Rt9s3dnWU67+Xt6v0JKxF0Dmboc=; b=BNAnez1c1JQkBPhIjWfh1w0M4m
	ObEuUjkNWKCNBdM07gsNCQ6zLVwCPgWHcLzDSn6pYTeCYZaCOCZ31LlRmBAWtPD0JC5gVmo3YYDPW
	mulVFEIcH5niuc+yiKKyYLCI9Qv4adeZNBoCV175nz7fGWOEJyz2td/NkikknQy7NxkSF2e9mrWxV
	JUGs7+yarN2fEMhfdKkh6ai3BAnfYkxCmUl9wHR5W/V3cmoWzOmhwgSn+80gKkt1HE/J2sZVMwxRi
	ZKHIUeuE22gz7EtRtiWZS6DW/jLlzdcIWSdM7NjwawVhnewXm8F4wX3XBS4BeQ3inAPhcV/PIzzOt
	2C+24vEw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h6H-46dd;
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
Subject: [PATCH v9 07/15] hugetlb: Move poison to pages before clearing hugetlb page type
Date: Wed,  5 Aug 2026 22:05:47 +0100
Message-ID: <20260805210557.1118966-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: chk8pzucnzt1sikce1gicgkkis1kibwa
X-Rspamd-Queue-Id: A1684A000F
X-HE-Tag: 1785963974-746180
X-HE-Meta: U2FsdGVkX1+u0RbWW4ERn96hcxdhttOfgcoxGzJAQs55BLMS5ZPk+QK6kGo8RpSe552ocHY1WDtrwXPGQ8nbXv9kAHGo1iFY47MxQGXUow+hvxEFc3Z0KiCfZhIjad/YWt76o9rDWsLTwab3GRPUtLelV8Y+5tFb/0YbkwSVYbcB+pSxJ2cebKN72vuyqgN1d+thCSg05h3pV39W6mXWG3d7IkdWkmC6qHf1EuphEtQ2HSZo60IzdhT18s1dpEFcF8ie/i/RV5eR6cD+p78SQpimh4MEfinH6sNd3nuNohrugHyBDUOstmAWquytE/z5E0bGsp4o1NBiO9kjdAuFqCHt47kiFq3KDSPITvsx5p0+M4tEfEztPSXvmotCWC4+1xpV39iA+wZhgO39Yd+c0eQJ1/8UmH4n/a3ZY17Du4XM9DG4igRaCMhzA/Gae3AlXkd2sQpZY46sSBaudhKTqP+Cms8Od1EhgxY1CehTKclkHx4/PZ86vGeyHbfN1SPMmi6gqKweyFTui3dCCCT6SgfcLcN9idnEt/EwdOfCETPo2Qgsm3Js8Ke/pWfzNEVkxSScHhFgffbRAlVHm1Zw17bBSmtvwyLDHdupI9HsBodIogNuwIrutwRC44szVqjCiR9wscfyF/20DcVo3fN3OY9uvVAa9Fs2IfgtiG7Q2n3anoC4R8bWCg8srmbfzpty/Zn8rO9x5Lv5bYe9XUqX92VHbzwWIFyT4qH/yAVI/B9kjFuMwThyrVT/0OeReO7Yz4bNtIN/epW6AHoP2xf0BlX6c+11VBRkaSAmqRVXPdgZavJVPDwUZYEjXwRyOFc+9WhIy1j+LcUt2hfsg0VHX37lGmX7wTVLMtzoUOPIr/vmCSXP/7rfg98CCqA5ejkbH3GYrnijvvDHHfXl9lcfqUvOfx/vG6R6Pp7xTOJ3dUgboCnRBokrsbOPl0YQNZglR+3LGXwIfN5+ol1bLj8
 3kpHTdtY
 zCzUwtPBNO/qBIdcQnCqLEtqTRbaNSDjAz9Q1TCbYcJefML4bOf33yhcWq8w9ARaqsEDtgQbYG4btgAM/vWYEBUIsNrif20hLms28IfmJwnqe+InBMY2Emz7iO0mE/GOnsZnQtmFveFqefegkmVbrV/UeUaOGQBuYhqadPMX+5TNzSV6csFSi/iWT1WcBaSlmbGYJ/crM+AWl1YrAxT4aLOm0FFNem/qoSn0osmgvSPPktOqrn71ID0vXcT8AuQIjfqBPmGRFT+KaIMlzO2cH9Z5qZCIzrxI7TwkUVpAwyXAxjz7CQ2CGivvBCfgkUQ4eGbR7oSIlW8F3eVf7tOBrY4aeIWMfzyCKemJ0h+VuFclM5g6XLzlHD5KT9Jzuf1rTT+t65+C4rQfVysIBiACFgt9+5Yw72Hf0v5VpP7b8kE5u1XPp2c6Jl4C0sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For is_page_hwpoison() to be reliable, we need to set the hwpoison
flag on each page before clearing the hugetlb flag.  Introduce
folio_clear_hugetlb() to make this easier.  This does not by
itself make is_page_hwpoison() reliable; see subsequent patches.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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


