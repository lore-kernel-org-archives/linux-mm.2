Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32700C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23496B00A0; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD44D6B00A1; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B666B00A2; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7EAAF6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:10:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D19E712032A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:41 +0000 (UTC)
X-FDA: 85123799082.13.5123597
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2C4A440006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:10:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g+fheIFq;
	spf=pass (imf07.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787281840;
	b=VSoLpwNvRAbSkFrMbphXV6ruWTNOB473HnScL2W5eYcspUseEHE0nQ3OXhXajJDx4i/soS
	ppy+HQZZ7VrPJubyru2wg3aPvsF4YH53Q/cmNHAB6qY8jJ78WDoifExBsoqgy3CHs/OuAK
	RJ1CzwceG3WMFUI0DbZFXrs8t9TOUaI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=g+fheIFq;
	spf=pass (imf07.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787281840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eyQGcLk/I018xLXVBLLUtlOMnk+JLbGJei5TJgp0VU=;
	b=nRxwfLNkoqCIr7wf85r9jn0i3mOhuuKYWaSjMzQBOdYiED495EVPdjp45KC72nkjVaccdz
	tiVZQKruV/Kr+BBj4S369na2oIFkT2BUu5tW8Ye3nH1y3PDOEhvaieKp5xombyyUx4jGAa
	EhD5ls17kRNldGJgcZawEHZZBowag3I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0eyQGcLk/I018xLXVBLLUtlOMnk+JLbGJei5TJgp0VU=;
	b=g+fheIFqBSycJ334Qz83fCGu2OqglfLRMYVHvaDkDgjgIq+bRk4gipe/Mm2/0rqEnEreeqftU
	fEjmcCQjoZCaONf1Dx8r5ddkMLwwTd19rLXe/NRiauE5ia1FglSST2PBpPEwaZtjJVPgy48m7iU
	n7hTlNkiafAb89oq/NhJCT0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hR4mX1fSSz12LFy;
	Fri, 21 Aug 2026 11:00:12 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 4FFC640575;
	Fri, 21 Aug 2026 11:10:32 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 21 Aug
 2026 11:10:31 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v2 1/2] mm/page_isolation: fix UBSAN shift-out-of-bounds warning
Date: Fri, 21 Aug 2026 10:55:00 +0800
Message-ID: <20260821025501.2752563-2-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260821025501.2752563-1-xiqi2@huawei.com>
References: <20260821025501.2752563-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspamd-Queue-Id: 2C4A440006
X-Rspam-User: 
X-Stat-Signature: 881rdrb75sysxoeyqinhu75i68ihouh1
X-Rspamd-Server: rspam06
X-HE-Tag: 1787281838-45229
X-HE-Meta: U2FsdGVkX18Vijj8jYxe1meL/kQSmhHq7ezTovPaOAyfX8ODglrKQDJ8PbaK44Wx1A/4vML7BfvsBPuRzJUX5d685k8cTTfLpC8c8RWYzKDpcMZPaNZdG19KpwKv/lFHgTdMjXm8k8NbXX0cbDpinqMmdCiFW2jrYB3BmnBWfcN25XOoecbz2I0PUIeg2pKJhFqlux0wfEaO3WFbhXEPKw10W3AxTkze/dum8pnOkaPqkQ5JJJUfnKbnxro5jPP1X89DciT/A50uVTqdO/QaOo+7CDWHfovufDLKqnok+8j1WyU3qaJMsvC8P5CiYMKH0LTyGVJk3em2qIV3lJitVR0uzpr3Uig2pZTXqPSs/6oR1+jnfhSE2mFd/TmzH+wwg6yeWVACzrB1Uis8JZZjC6XndbX1P2k+qV1/suL081MzBqWGRGQEIrzjouFiMsR/YjS8YqruARKNFEYbbq8aB1PlkDfW4nRZIraw3mGcyn5rcbs4f6DKiE1R5D/QlYayKjkrV5mK4tz1xrniNWtMCrex7Op2byuB6PKaazPSO49SUwi4fAPZWMM7BTsiQjPueuTan9xW9A2DcS8oE+dGBPIcZ1VjRxblwYEDjLkqdSXd4rIXyCuZAggdpNXhUzBMABgi2Eo6Yv+qG5N/8bS81LKErH6ZmCdP6+AY/9eo7GbyjYpoy9rrVCiJuXrIhYK1l5u2hyyHnUi/TfI6yfweZlEbazAnSlbl1NtNQxDIukzcTgdj+FeCpuLltRl+8R+G9+oJROXN0pAMjvQpA1BUV8cvGxUUYr0Z48/0zmtjR3S2AA6laU1ZuDlQoMhlbGhTIIcEA75sJ0o7Ss5p6cRorHYgduvasgE9rXB9gw0qFljEMFhbltijTrW1ds743kTrUMtQ3MGYYZ8RIabpyAsuBZVEJrRJSrzTD5K57hDhM6MYgbcsRymn18vgFxmif299ay9nBH4VVqelf1t3pVE
 PJriHvjO
 V4ajcpd6DdgmA77AoGxp/zSBp0pOqVlGAZFE6hKwFY6gEkMP9L4SkyVTRrYX67E+ZyFmAR3SclYDpdtpJlwKjTkmuIRGDQX37TT+5+RVCHhhA+KfelKBCk/itEY+CI9uNJ+OHJgNewYPMcZ/mtvFSy47GiSGTYQKyqbnRWUW0pjUjwjfSjE0lxxMbOAzUy9Ye0Z5xQPewvm37vw36XsnR49kwl5PET1re+2CM4+UbRa+YRZyKm3/BsieaVr+Iyo2kI8sXOQyKREyHZSA7IPFUA5NQo3pb70T1WZeyk2EdbM75Vhpv0hExbob1zWqJxsfa6SxnU88oxXaL0fUrY31HbK/dScVfhC6RkKk1TzKyJOMUilLknAWtqq2NLbKADRNU5974
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
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/page_isolation.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 32ce8a7d9df3..f2b648a68531 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -387,13 +387,15 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
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
+			    pfn + (1UL << order) <= boundary_pfn) {
+				pfn += 1UL << order;
+				continue;
+			}
+			goto failed;
 		}
 
 		/*
-- 
2.33.0


