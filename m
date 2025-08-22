Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C20CA0EFC
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 11:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1042828001A; Fri, 22 Aug 2025 07:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1F38E009D; Fri, 22 Aug 2025 07:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE21828001A; Fri, 22 Aug 2025 07:28:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3C208E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 07:28:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7790A1361FE
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:28:51 +0000 (UTC)
X-FDA: 83804171262.08.B423FA2
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8E1444000A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:28:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755862130; a=rsa-sha256;
	cv=none;
	b=W1t5gmp9lLbcLol4KGU3QNOY34YRU74Kat4oz+OP8Y5wW8rCL/hk+YdR38KIp3QPboNe5u
	El5e6maEeLFibaVHL0lX4obM56EuMXnht4igFKF1eRe5WqXsLqPcTLNZhi7cBqCr6eTYZf
	7ZMuEca79TU2ImzGbr4VhGyMmvjDZ4M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755862130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=NThDOcz/SS+C7YL4hFid1zydYXIRoVikVjEAvLriz/o=;
	b=CNzl4DbBaPEeXhV7tDR2KyVp5ISrzx9S4NnYmEkLV397no7u2OBAaazsqNEGMlfxR8hPwo
	LWFrTqjMNwQ7HUfPaFzga+nHDtXiHy0O+ESKFwOSaCRZHp4Cge+arnMD7xrvBpj0Om/Jtj
	Kv1Q0W41+WLKydFcUkLk7btx0AYuaP4=
From: lirongqing <lirongqing@baidu.com>
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@redhat.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>, Wenjie Xu <xuwenjie04@baidu.com>
Subject: [PATCH] mm/hugetlb: two-phase hugepage allocation when reservation is high
Date: Fri, 22 Aug 2025 19:28:28 +0800
Message-ID: <20250822112828.2742-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjhj-exc8.internal.baidu.com (172.31.3.18) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E1444000A
X-Stat-Signature: 9symz7prxsibambm1etyj1ssbsfne8p6
X-Rspam-User: 
X-HE-Tag: 1755862128-353525
X-HE-Meta: U2FsdGVkX1+8pG3S4DM1eEmP0GruttUzwawnQbGjNtLYZCJmP3g9rwHXemkicwvSFvwyiSnOrZVyJn7nnRYdgxj95hid4+zookedpSmI8zQ0yjOo992u/EOSLv0fsPhkOO+mr2grwgeoS1HYsh03OpfM7JGq0B8ohXYcIhUl3ObQQEgsGnx4Ct8YZRYiZLrOGNsu7tPNVgW0u+IYufwoPVrazffRpNLDRAaeFHi8vvYbLjna1eG8neQ8/uIVFKHxhQAMb51ZqKCNyUWReue3nmKNg0ZPuaX3VwdEhkYq2VZsXtbkKsyM0Z1p+I6GIOux5qEp+lc8yI4/+V9z7c4W7XK1D6Thjy6prWVJ62oYBy3wUIb6uEL/hnCNMX3I+AhzDfXZ1N3132IsYfI9ZqV3UMF4IJn6DFPXL9tRl9yVtYZ0z3KgJBElF4KmqYwh8AfEZmHwYmVn9BY434jQJnGa6jpqhETu0oKokhWPVc9MpHa2skt6qppLPfSVwj3YTF4Qb82lqjmhtyvFGIH7OfCorkDYJ4AFYFSk/1G21pEhZzTj0j+dtX/6ZDZ30U6Lh5gjN5joOgBmzC32TfMrgHosnea+fIzxDCRulcZDqy+incir5+ubBZExeEO8ePtttx3DHFmiyMROP8CImjcXTBbBNE8TIafvE6lNLUAbQ8D0Lr02oJhwo8D1LPv1zHz/Sh4HedhjvelD/AK5WypJg2y3jww/wLnoH9eFrog0kWYBF9CKglnBbZuJEX8Ol3/Lbwanm6AySnE54qdSRA0lwY+kwnLIvUNttFm5ApUu6LeX6T1UZCiox82v7tbmiQJIHvzy8O8TOZXyF3J84XPUdL22j67xX055FGwu+glSfjTih4m1FsmNfOXnMvY353enfcExQkSAYl7VuEl8vmDPzSq6zR1ntHjfshQ82TSJO8jnwq8y8TrEaRwQPZfnfdRoXDbiScF8aaE2CqNAp9gX4vl
 Ou3vlcbR
 x4kkCme8ZZ50EIQjmj6XR0AG8bK/qXDlQbuSgN0SsDAZDmPP/IKjde9NZ9wiRyYMfnwj2PAzQxyEUaL6faiGQJUU+OFBcpJD9aEeOwZQFOe00vJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

When the total reserved hugepages account for 95% or more of system RAM
(common in cloud computing on physical servers), allocating them all in one
go can lead to OOM or fail to allocating huge page during early boot.

The previous hugetlb vmemmap batching change (91f386bf0772) can worsen
peak memory pressure under these conditions by deferring page frees,
exacerbating allocation failures. To prevent this, split the allocation
into two equal batches whenever
	huge_reserved_pages >= totalram_pages() * 90 / 100.

This change does not alter the number of padata worker threads per batch;
it merely introduces a second round of padata_do_multithreaded(). The added
overhead of restarting the worker threads is minimal.

Before:
[    8.423187] HugeTLB: allocation took 1584ms with hugepage_allocation_threads=48
[    8.431189] HugeTLB: allocating 385920 of page size 2.00 MiB failed.  Only allocated 385296 hugepages.

After:
[    8.740201] HugeTLB: allocation took 1900ms with hugepage_allocation_threads=48
[    8.748266] HugeTLB: registered 2.00 MiB page size, pre-allocated 385920 pages

Fixes: 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")

Co-developed-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/hugetlb.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b..a86d3a0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3587,12 +3587,23 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 		.numa_aware	= true
 	};
 
+	unsigned long huge_reserved_pages = h->max_huge_pages << h->order;
+	unsigned long huge_pages, remaining, total_pages;
 	unsigned long jiffies_start;
 	unsigned long jiffies_end;
 
+	total_pages = totalram_pages() * 90 / 100;
+	if (huge_reserved_pages > total_pages) {
+		huge_pages =  h->max_huge_pages * 90 / 100;
+		remaining = h->max_huge_pages - huge_pages;
+	} else {
+		huge_pages =  h->max_huge_pages;
+		remaining = 0;
+	}
+
 	job.thread_fn	= hugetlb_pages_alloc_boot_node;
 	job.start	= 0;
-	job.size	= h->max_huge_pages;
+	job.size	= huge_pages;
 
 	/*
 	 * job.max_threads is 25% of the available cpu threads by default.
@@ -3616,10 +3627,16 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
 	}
 
 	job.max_threads	= hugepage_allocation_threads;
-	job.min_chunk	= h->max_huge_pages / hugepage_allocation_threads;
+	job.min_chunk	= huge_pages / hugepage_allocation_threads;
 
 	jiffies_start = jiffies;
 	padata_do_multithreaded(&job);
+	if (remaining) {
+		job.start   = huge_pages;
+		job.size    = remaining;
+		job.min_chunk   = remaining / hugepage_allocation_threads;
+		padata_do_multithreaded(&job);
+	}
 	jiffies_end = jiffies;
 
 	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
-- 
2.9.4


