Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35F9C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741B46B00AD; Tue, 25 Aug 2026 08:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5616B00B0; Tue, 25 Aug 2026 08:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1CE6B00B2; Tue, 25 Aug 2026 08:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3947F6B00AD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:21:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3DEE803B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:38 +0000 (UTC)
X-FDA: 85139702676.09.234787C
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA4722000D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RpHvSnmF;
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+yU2iTET97sRJAGTn5W0IvEia2BUUbmJ1Zs5LLHB3Y=;
	b=RXqvzSMC+YMAgF5ilSH036whBYDJQRYoOPhwOFZmuwXHIy/+OBXht5EqEc4+enSeeiFnHl
	zVYeOlH2vdf0i8RIY2HNvKRwQQO4MAE9U/ga8HOYpIhgfvu/Css1G3p1o6ZcQW/YJx0BUn
	zcjNRPxbVTinBfXXnuyYdrBRAG3TZOc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RpHvSnmF;
	spf=pass (imf03.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660497;
	b=ml2cJaJhV7LnxnsIasZGw+MFPni6rAjW+MZv0QLk6KXPL7iYlGUWgqlbZ2SpSApS4eCJsN
	EY7wVcRONjsRGDyDe/2eRlyb5QjCHZ6TKa7RXdljYTZRQW9zyo84aAQ1yh/e/NwMxCzx1J
	P0rP7MyfHb10LRK80ICR1KoDAxsQfXc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2+yU2iTET97sRJAGTn5W0IvEia2BUUbmJ1Zs5LLHB3Y=;
	b=RpHvSnmFdWztqQ06v5lfMfWUFuh3MTIgKMj2yyhUTkGbHpY5ZTxpsFlenNssTOyC0goqcNDq7
	PXuxyBfVe1f3HlAz9fzmSDCBsgpQRodPccoYxcEcQ+NbfAxCZmYLgnfmOVS+w2OOKnhZ75JCjFH
	Q59/nkiFkzqhBli/DwSo/ec=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hTmnt2FJFzRhR0;
	Tue, 25 Aug 2026 20:10:42 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 76C6A202E6;
	Tue, 25 Aug 2026 20:21:25 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 25 Aug
 2026 20:21:24 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v3 1/2] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Tue, 25 Aug 2026 20:05:48 +0800
Message-ID: <20260825120549.966271-2-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260825120549.966271-1-xiqi2@huawei.com>
References: <20260825120549.966271-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA4722000D
X-Stat-Signature: sepuagbrj97a1ghs7ndd1q8ek55dn67w
X-Rspam-User: 
X-HE-Tag: 1787660495-443522
X-HE-Meta: U2FsdGVkX1/JXaIWq29xzlwjtKNkP6s7OCS3rCqNvMZ9K9oTyZsGTXzaTWFFuGBHobP6X0HgHhKn5jiXp+QXU/aZTghlHHehZMLXNcKudoHu56Ecph+n6/UG/+WB9DxCnVo90Xu04Lrh6afwmRsc7hkJzQw+EFUlogOE/yBhO2iqC2MzIfZAbfKKLLl+0YsAbVwT+DV/YpK+hi6wcwQYWaWMg7FTwcCF4l+qa7WVBwZlZRLEDZm1tHQcY3ip74d3muXiPgYd4XmpWDldMmzqzogxkfA3DXjO45YHjPXAzEYkJq6nu+WT2Yftc1y/DX00MdGfWciP8OOwRr6oVN97dSZd1Lrc/sHRPkCvblfHiSbrNTl430hDMRT385DGjYMTTG/8KM+PtoAJ1KFGuNzOxUtzdCPLqy/yup/olOVccMRBZ3SOdw636tWgwLnqZlI8U5EOCIrA5tL7NElwOpdXqhw+shu1ykGpoa65yrDtxmf/T+6nVTPRJ7TCZwHUFwIUCE1/R89P+pH/c5H+zfg/q5Yyq/1wQxvid1rCUIqAGnyQ80BecRiH3XOrNnpsNf9/+/9JBcHQqHXQG3AiFtBQPjm+9hT1PrDpEaPO+dvQlpZKElqxEhkS9kzYJ5fxjt5/QIiuC/0OEbYHkipEG2B9eAjEPtAvTVFr5FX/Ea+6Up0XdkmqrcYyar1lLS4wOMl2dG54QGZcjSzSfJK83x00HL74MQmv8j/LSAcUxk2mq9VyXiPxMJlP7GNhU3u6BAghnuktuoq3V7EW9c2bz/iugWb2PMPLIhBX0i9bebZ8tJp7cEH2jzeALy3K2a5u/m48UnYMhznrcIuV+031aGBvtfn5/DvYauD6zKvsGLu6unUR6Dmxm2W7N77ZImq48KPdsNS0Qp/DwpgnMWhU7IuLpGscpAyH6pELG0Ql7inX3K9Zu6nE4ffX3g8eoMXM29rCdxAkjGo+4hpo9xZXzr3
 J3WFCQzT
 RBTy6qlbZCnuwT0xecfz7XHjDZHkTPcLGydlhplEYdppXvyCywPGTHeFyN0liCYVrKNfXQAXxxqKI5aJTo/9mxb7p7+K6AyQdcQwraXs3kCu9p5Ngs1wdMbfsuaVuxs44gIhSaZZVRNEBII4OrsV8kEWBkc3CIEFRQpqVU5aOtMw2pm+AL8Zdr8fvoVY79kWDLSTKO4REXGdblHPWJuRChZDCCbRbucb5uhciLjsUQCiTddRAxk+04NQlgrU0J8+iMnQQzDZeELIZdtjO02NhZuO4B+kCC9O64Evm9BLdoIvOvl4qvNYAJbApl9VdGL/dG3Mf9gWtiviZ6LoPPTvcjvQfKVMaW72K4+CbZFNZmSrLU/pNJTRRkvCtxnmnaZ/yXWY8NgwFyR8PIpFgAJzpj7inLCBycZLbbkEV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A contig-range allocation racing with buddy allocation on the adjacent
pageblock can trigger:

 UBSAN: shift-out-of-bounds in mm/page_isolation.c:393:15
 shift exponent -749042176 is negative
 Call trace:
  isolate_single_pageblock
  start_isolate_page_range
  alloc_contig_frozen_range_noprof
  alloc_contig_range_noprof

isolate_single_pageblock() first calls set_migratetype_isolate() with
zone->lock held, which marks the pageblock MIGRATE_ISOLATE and moves any
free page straddling the boundary out of the way.  Once the lock is
dropped, it scans the MAX_ORDER_NR_PAGES-aligned window [start_pfn,
boundary_pfn) locklessly, only to skip the free pages already handled
above and to detect in-use pages straddling the boundary.  Since this
scan only reads page state to decide how far to skip and returns -EBUSY
on a straddling in-use page, it does not take the lock.

The window also covers the adjacent pageblock, whose free pages stay on
the normal movable/CMA freelist and can be allocated concurrently.  So
after the scan observes PageBuddy(page), another CPU can allocate the
page, leaving a stale value in page->private that makes "1 << order" shift
out of range.

Use buddy_order_unsafe() with READ_ONCE to read the order, and validate
it is within MAX_PAGE_ORDER before shifting to prevent UBSAN warnings.

Since pageblock_isolate_and_move_free_pages() already handles free pages
straddling boundary_pfn under zone->lock, bail out with -EBUSY instead
of VM_WARN_ON_ONCE() when a PageBuddy page appears to cross the boundary
during the lockless scan.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/page_isolation.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 32ce8a7d9df3..61efc03500ef 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -387,13 +387,19 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		}
 
 		if (PageBuddy(page)) {
-			int order = buddy_order(page);
+			unsigned int order = buddy_order_unsafe(page);
 
-			/* pageblock_isolate_and_move_free_pages() handled this */
-			VM_WARN_ON_ONCE(pfn + (1 << order) > boundary_pfn);
-
-			pfn += 1UL << order;
-			continue;
+			/* buddy_order_unsafe() is racy. Validate the order before shifting. */
+			if (order <= MAX_PAGE_ORDER &&
+				/*
+				 * pageblock_isolate_and_move_free_pages() splits
+				 * cross-boundary PageBuddy, verify it.
+				 */
+			    pfn + (1UL << order) <= boundary_pfn) {
+				pfn += 1UL << order;
+				continue;
+			}
+			goto failed;
 		}
 
 		/*
-- 
2.33.0


