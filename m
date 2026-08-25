Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C69E6C61DC2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EADD6B00AC; Tue, 25 Aug 2026 08:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2386B00AD; Tue, 25 Aug 2026 08:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B3C6B00B0; Tue, 25 Aug 2026 08:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC66C6B00AC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:21:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E314402B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:37 +0000 (UTC)
X-FDA: 85139702634.02.01B1C34
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf24.hostedemail.com (Postfix) with ESMTP id 019DC180003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:21:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QojxQPHB;
	spf=pass (imf24.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787660495;
	b=pqOFaWjBODErvUpDsl9lc4LExOLXiofcMBKga3xJcy9JW9ERcf0SrDlxMYj5k4kDGekMkU
	bKdLtEkMGfylU2j3+wiySJkQy3Fk3VG583AnBpkWrVIxsFcUe5h4brNqEyX/7ps1fdgLNv
	EpkgEORVTH9OvkCs2PXG2OzEbOT7s7U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QojxQPHB;
	spf=pass (imf24.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787660495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZT765UJFYyMTJoOY408mF7kpDLgZOjbYjc0ctgYvIGo=;
	b=5Sb9kqtqPpYvRnyEuLPpBKK8QfgkD92Hg5z8HfbhzupopwE6+AZUNZiI8wJ0KRuSfWhhQN
	hx6QX04Fc6uiIx+OliJTZeqDkEYlEBZcoxkIu0hjkvefdFwPYj2exFUuiDraKB9eHtGCwK
	MpNYzlPRrpnvn6mlnyx8cyf3Hue4mwM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZT765UJFYyMTJoOY408mF7kpDLgZOjbYjc0ctgYvIGo=;
	b=QojxQPHB6N8tDMeJFSG82r1iHX1BVlZHZrbQSWRiFspic1EIA+RwZ0FC0jGJskGYu5RmgraAv
	c65bZaRMxp4ipe8VBMIWIkUjlkCaDKLeFIEvCiXFpRgJIqA0s5pxfkPvUyTWbTdfomQ63LlmQhd
	k+uB+ArmyiEZPXYoTpz7CEs=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hTmnr5Xj8zLlTk;
	Tue, 25 Aug 2026 20:10:40 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id D27664056C;
	Tue, 25 Aug 2026 20:21:25 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 25 Aug
 2026 20:21:25 +0800
From: Qi Xi <xiqi2@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>
CC: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v3 2/2] mm/page_isolation: guard compound_order() against racing
Date: Tue, 25 Aug 2026 20:05:49 +0800
Message-ID: <20260825120549.966271-3-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260825120549.966271-1-xiqi2@huawei.com>
References: <20260825120549.966271-1-xiqi2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 019DC180003
X-Stat-Signature: 5fqzj7ihqmeixuzuj5c7hjsr3redxfii
X-HE-Tag: 1787660494-385964
X-HE-Meta: U2FsdGVkX1+Z5CjV9Ov+NJjteJCJBrRAbu9NA1bS6vevj6h61J/s0OaE6JjNmRvVnzlo3KU0m3OaYmylR3Pzfki2ojtRGpBun9LmyI0oldz0DJoVYCWjSDS/myB7wQXNrtw0OlglW2o0GdVWCUnTey9i+qHw5hINxfmNkmyaH4rQrXvNKK84HxlLsVwd9ppzakIXFO5y/QPdqYi2RWavqblZesX8AgglQMa46GJ6eLtOHjndfb/WlBhHrcFOCbLad+RY5fYnzWlQ33EJX4qc3T2qIs91Ab7o8g8duBUJLwTuoD1fPYFnhyqHZfaI1D8h2r0mjKNVofz5k2I/2IkxZk0R1eRLXPfLjzAwn+c6CSYFP4OMUKtwjS3IcdYdJpoouEKu4jK2IPn+lULd+domJsX/wCLK5KIGDEJA4NATxR6d+8ABQezks456Wp/6oUV9jiEABoKFuyIibe4eM5kpwhpt57Joie4uRycdEzfX+ynrEELH9HkFkGEG3yrguZVmgzOg2eYpJcBnwWFO4sRSst/3Of6YWG1zs3ZckVw1xFwsuXksZsd9X5S26MSvua0YZO1//qDOgrFRVTuOhT8xnWD59wrOIxCrIu9JD0TT5Ai9zN4sw6B9Fk7GZzQC2HY90aJR4Pcql0a/vgFZ+g1ftVOazuMCcl5zIdjBjYQmhD9d/R3cQ5TxXoqWxO1SWAUtWqmoCZxdFjnIAElaiPDb+wiQklNYt0qaMxY6V55m/7Uvd80nuGODlsnup21+dPeUnwWW5uoJbICLC/IxlVhHeN6geVS1VXzEud46ddxmz8BlSoUOSg4fSqwOnm9xLjdrpK6xJE8+uN1/oP/S2hn/GhDfrS76XPhblvX/0G1+p25F9aSufbPjEmshMALJR94SUXL6zADbWUWkL0A4SzfeE7DQexHiU8uhVceNLSntQYuxG0KUspd7Od/2Rn2g4h2r5z88tox79bM3cVsYR/Q
 2xvQl++K
 GB4dOTPx6E03mPT1EmNFnXjIhZ8F3U+LEwQCb1KEZ2gSz1IboypdN0bBSsLKubc1IlCb9lqjlyQaN0vnkS5XvHk0JD74Blq3heSCRPyijhVUMdM+Mg9COeo1CnJGMZtDecKWLihs7bmpThI9lC6skIarBVnsp+99R042hYwowCaDfMgbzfsHEY2uMGvQ6jrACmH1CvkFkWcYHMGqLptstNNvcoU1AqZfQuR+Z/u8RI7zg7KTma4lnvWPCqpA+75ZNIaqsKb8ZEhCasRpuUJIEwyK19ycsk3T7NAwdsX0GCSAlnAzWQzNqr4D0e7QBO6R1FQrhrOOAisXFM7Yui7pUa/LxEP5DcE4cqfkavz/vkjbK+HFXeOzZhn/1xPKeDBw/Lc3y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PageCompound branch reads compound_head() without holding a reference.
A racing split or free can cause compound_head() to return a stale pointer,
and compound_nr() reads the order from that stale head, leading to
out-of-range shifts and making the skip distance meaningless.

Read the order explicitly with compound_order() and validate it is within
MAX_FOLIO_ORDER before shifting. Also verify the derived head_pfn against
the legitimate pfn: the head must not be past pfn, must be aligned to
nr_pages, and pfn must fall within the compound page. Bail out with
-EBUSY if any check fails.

Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Cc: stable@vger.kernel.org
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 mm/page_isolation.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 61efc03500ef..eca6fb78f73a 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -418,10 +418,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		if (PageCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			unsigned long nr_pages = compound_nr(head);
+			unsigned int order = compound_order(head);
+			unsigned long nr_pages;
+
+			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
+			if (order > MAX_FOLIO_ORDER)
+				goto failed;
+
+			nr_pages = 1UL << order;
+
+			/*
+			 * compound_head() is also racy, so the derived head_pfn
+			 * needs additional checks to make sure it is valid.
+			 * Otherwise, just fail the check. pfn comes from
+			 * __first_valid_page() as a legitimate PFN, so use it to
+			 * check head_pfn.
+			 */
+			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
+			    pfn - head_pfn >= nr_pages)
+				goto failed;
 
 			if (head_pfn + nr_pages <= boundary_pfn ||
-			    PageHuge(page)) {
+			    PageHuge(head)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
-- 
2.33.0


