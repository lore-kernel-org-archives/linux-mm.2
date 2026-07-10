Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2A4C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68D1B6B0098; Fri, 10 Jul 2026 02:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E3F6B0099; Fri, 10 Jul 2026 02:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9096B009B; Fri, 10 Jul 2026 02:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEE16B0098
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:40:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A19111C890B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:40:01 +0000 (UTC)
X-FDA: 84971917002.11.EEC3BB7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id C48DA140009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:39:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xWXjz9Tp;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf26.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783665599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVuc8c8CL1L4mxT89UY2Ilb3xehlm2PPmppx0Mwue+M=;
	b=PRQYAd4iObd1QhI3fnUlm+f+YsbIuYlCOC0flbjJlAsqAclNLNXfEEaeA3eekkn+egr8Qn
	jFSRSnL9VrtljGl4q0HGJFkhk81b9FgXQZBvBH5a31DhLkm1TiKGl+3r2F0BtQ+WORPaJU
	11k28GcgvMn7dRD3bz4s7UTOqZ3yrkU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=xWXjz9Tp;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf26.hostedemail.com: domain of BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6dbb437d89e5d5f1fa5+8356+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783665599;
	b=w+XhQoSdAKHPjdmi6ahCkvmbwcm/ZBqSs1TgbMMqF4ltSYU1wa4IJkytAZ1lj5skAxk+mE
	HN7pAYa5HAsUmyoST9HfZgm+zd6hxRsNEpK+rq12s3BgqHULSj8bci6YLKOiWgdQP5SE7z
	Fy9cBZBOpx5OvawW9tLgVSWSuGu7DaA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yVuc8c8CL1L4mxT89UY2Ilb3xehlm2PPmppx0Mwue+M=; b=xWXjz9TpgDyr8W8woCho/s6sGg
	ID+zSzxVSZFt7aEReUliPFcFeFCZjncK677ECJrZo0/sFBQhPSx2VracsoOn0kFhN048/7pQOjfLZ
	ZPBmDnJKu38bHHCCIcgw09+PGZ4c4BQwjTi/NUuR9vFRDFkcFoUDvbPJKwEJ9x7X2+964DCIxolFr
	LF0cwf6d7zpYe5vQnFO5SyAoDSki4/l0s7adqkUQW8b1TEr7ffHhgOWtvgRm7l3h6aksJ+dUNpcxM
	hVaPEIxklfkM8onrivqFEEAyGbIOYdKg1FcY39IVY81zwqQbHxyCp0fDlSN8QpHjnt0+f6SoyQOnO
	rmb9sy/w==;
Received: from [2001:4bb8:2cc:d72d:4dff:292f:a943:a4b9] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wi4tt-00000004HRR-1t1C;
	Fri, 10 Jul 2026 06:39:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/swap: remove count_swpout_vm_event
Date: Fri, 10 Jul 2026 08:39:15 +0200
Message-ID: <20260710063927.1891452-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: C48DA140009
X-Stat-Signature: odkcgxmenrewbcnd1xxcytfxh5cayn1j
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783665599-467726
X-HE-Meta: U2FsdGVkX189BMk0WDvwS+Y8I6ac3dtWbnvi5jaUP9031OsHdxdfKgoVzRATqgHXfF5iMuUvElqCFJFjEzcssqBYRLGCGv2qjS9+6Lxqta139giv4ivjbqOYLtYkXXD03yUXeDQ3wu+21TmJHwX8b5zJCAGerCLvWcn1Cg9EIY9kZQaiV7JpaUUf18RszySrFxwU/A4j+oPWWVTrhGySwZjJ8tvrezR+oWow8WHstJBapuBVzoyAQU8aSleOSRf48mY3nZ/j0rHTltDiRsl1U3fmWwrc/gxwyj5i8szrxaKLDMweQjiryIxagsFEuAfOnzspzD9n3SKGM7XU2kbBb4YfDP/D8PEQ6G5AI7uIM0jyMvZcC18W/6SbVUQMvkolB5UAsjtuwcFRdKd080CikxLs/WuYeOFR/tfKwTPQ/zpUetc3Fhx7hvdZMM5COH65PaOBiYmeeYYupXszsF6wViza4TEYSU3TWy5aOyviJ9yZFFpAWAKu/6+FM1Hj2iE1z7CQOxmFugj8lFjII6T3x1gUNO/VH2zqeiWdg6KvdsQNczrFD1gt4d7F3mb0xwJusrWM02n1M724FPOiOagFm/AoS8dsbPRing8Rox9AQbRWmigGQfM4MeIGVJORGqAgfpW6t63FP3toMnDUaZJCHkHSmH2Zrn84DnJq8qqTraZo3sOzXH1lC5Nd6NEd2cfYR0lbWUe6LfQBG/fhUOYyXFDmeHMs5sOYsBzIjPopW4OXs0EZe8YfOukixRRT5oSBv1p7hOEZz63TZn3aF1vrt5krYnnF1hbajuCOQc3fq3yNo+U3NAYgHnofkyhHeJYJdxpWVng+cDAXZ6qZ95gXJcesFn/zqQ9OUnTrt1yFzCrFmDUOe4ZawHV2bSALBnbgW3GgYAQulJc02HXI/7SWfA3NQ1KKsxadhVyEuiYGwbLTrd+n1R/uqjdzFsoByKnirZJyvGc+X4z2hR7dsHN
 07CXtNQS
 3XJ2EvAHXeMth210HQ+zs/cYWFbbEf5BvpT5RPGHpTv5H49idee5RTVoaXYAuLEmRf7+Hg3PmM2sUzvZ/wR06Q+XWjBHVjo9hMRJJYJFlDYsvpOH1oQ5jVZYOeWadMy0Qxhxz/tkeoyXbvL89pJrHkFRCDUcXGkbvCZYiaEZIj9gZ73b2UNPWkLJabYpgqpLUDO4itLzExkl6m5a8wMeHY8OkQOW+cn7i/uX9uVV0bYsaNJK++jB8htRa+30HYbSpSnGuFa174sVijxG2bTgAoAFsxNHacD9YIe35wopapf47jJQfWWgnBld+st6qMtI2FCoEL093R5VRaeXxeB2mhVpENEqc7d1+0Pymxp+irwwAI1+JDTxvYurGzf7eEPuU84RVS2UqRN+wpGzQaxhtJ2dnDPVIUSMS8JKCtOcQVJIENKQY61peSEp6HHRKSOcCeY6aiA/HoyjwrXDnYkjrjBKsgmC88N5Os2gdfcY50CGjHYO68eb86r1tndWNs1LXeABkXzUXdRqZrZiWg6cKqdT/2PYwO0kFZbS6zp3z1Xy2WtJEpGABYy8bWBpp0LOx9clKRxnbZB0oC0tozLN58EwlOSuSTQ8o/zALFcdSsJV/Fe8kYoZvthAqX69p25B75+p9bKhq5B0E7KltoZJOz22sCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller left, so merge it into that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/page_io.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 76dd38294ced..6c78aa641c86 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -254,19 +254,6 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return ret;
 }
 
-static inline void count_swpout_vm_event(struct folio *folio)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio))) {
-		count_memcg_folio_events(folio, THP_SWPOUT, 1);
-		count_vm_event(THP_SWPOUT);
-	}
-#endif
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
-	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
-}
-
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
 {
@@ -397,7 +384,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	count_swpout_vm_event(folio);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
+		count_vm_event(THP_SWPOUT);
+	}
+#endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	swap_add_folio(ctx, folio, WRITE);
-- 
2.53.0


