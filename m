Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D05CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95CF8E0015; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA0C8E000E; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4888E0011; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A47C58E000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:20 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D7AFB4944
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:20 +0000 (UTC)
X-FDA: 83844290880.06.0FC54E2
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DC6818000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eD+ECkpi4oqKr8EcaiK+CRLZ+00ckibajdae0MvOVJw=;
	b=oPMZ/vCrXyrb4tf7e9M3y6uaDnWjww0sPfyrI6YnFm/Uio/SczAtchvGFwSjCGAGMPxeuK
	KEJrvliPe1+fFGtldDIVq4iSZ9Bf68xwvKukKMXMtJWzh6KrXoqNLN/RbLnzv45u/eGDlD
	nnWE7Xx02+xjF7h0gXmwbBUHbowz6JI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817358; a=rsa-sha256;
	cv=none;
	b=WM3dS7ovSgPeZ6wNbBsZNnwNaaplHV3Af2HEzcDcXQ7DWSXYhLQMJVWWyIXbH4nP28rlAw
	HSmxUXTt7PurIyKJJDt6i/qX6renaoBL9CdAC6zcuzeqCZX+xpdXHDimbUh5K24W7UMtF2
	iB3uYux6QC0gMZqWArcV5NYPbGS6fZQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cGQSj28ZZz13NSy;
	Tue,  2 Sep 2025 20:45:25 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 85389140202;
	Tue,  2 Sep 2025 20:49:15 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:14 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 5/9] mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:16 +0800
Message-ID: <20250902124820.3081488-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DC6818000A
X-Stat-Signature: gmsszxik9snxyjmxnp8ahxncqn3s5ypj
X-HE-Tag: 1756817357-516477
X-HE-Meta: U2FsdGVkX1/qONsH3/QS6p0kLLY28oJsrTenEuCYrBcERe+Q9rrDYfxKXZvBWtXhsLMguu7ScpsnEFszgS5RSFCMCxuwv3fGGMXLHfpnhy8uONhka7bNHtpbhz3Ed2VpA4OvC8OtXFQPES5dTsKr/I88n+aEINLxG3OurJl3tu6dnHtWJtHcshv7y/jblxRVx/UyHlt8/s+fZR8ZDUNX7OgRztX56rz0IVatMYp3i4xs74YVTSYXk7aGC7ZERm/xQc3K1BA8S/9jDVbHChfODrPCkv39/ATNHij7gew9t63dPxgaDJ3c+9SX4EeRQX191NaxVn5HTCInE4jlUgjNdTa5bpqFiitJXq8zym2cnBG85X8fuxiwrgjl5ghWhzo74YLT2oNbD+FNh/4CBcUvBcEJrJxq1H532mwbUN8YeJ3u69WJKSRvQeww1tnsrPT93YmfToyau74UJX0VfY4oPPJc2Fe7Q42/1AzKzFirF0vnL4fbwKiHwQ4PCvEYfFQPH7LePmln/liKcqegfDu3rRc+jWzoqXPsmIMax3v24ZMahl5KM0WMM3iOE6SbGQtzDEPBMfSFADKzBP6sqOyqOEf+k6MopwumJVKF8vwDzKyimLufGuSF7jLFy3SpSUlcfKYKP8akDqPFJiSYVviPClf0dGEfp8PycLvKECApvkzMIgPhpiCBt5UYXfUtMp61t5GVViVTK/H4IybmL1ss37Rz3f1rf9sLqFw+IAzhtkT1kg1TIrriyZS45PpAoHmawDlskLZ7u7TbnYtQJvpCOAivNYKnsKnrgidcoy2aawhamguhAfyTbUFTVS+9XFyvXcfSbmlGfZ0NiZPb1TjhYc2MibqlOE7/+zvkmz5E/Ik8oe3cTnrCIDo78Mmh3PDb6Bu68vl+XFzLGmMREGambPMRjq3iux09quB+Fu43/bDaefot//cEx0qGBB8Ry4uHA4j9MXkyNW5oL6t93jK
 M1p5Y6EL
 pNwcKPiRLT8PGUZZKpaSzwUOZo3zxwNsGCwQHVZN2EROm4/mqfH0a/XZ7ACMmodQB2DUTmO+s3wzQPlH21kHOvVUAoDBE4PdIPcjfc32EtlcO3vX2BUZp7tmHIe9pK7uWs5RR90U5SY+pC3fUuqCDK6WNWghpjydvwuuXFciImAFeXCUU/XrxEIQaUyYTu3UWH0ysysmCnRD2S8JvtPH+f7op9PctGVbXfX4fOe/iTNuoeqn9cFUdWXEf44mhhRlNZ3m3KRBbPinW21UlheCwrZ9pFDJ1zT9ckwSFzqdA2EfKjvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the NUMA_NO_NODE check out of buddy and gigantic folio allocation
to cleanup code a bit, also this will avoid NUMA_NO_NODE passed as 'nid'
to node_isset() in alloc_buddy_hugetlb_folio().

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ab748964d219..4e8709d7deee 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1479,8 +1479,6 @@ static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 	struct folio *folio;
 	bool retried = false;
 
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 retry:
 	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
@@ -1942,8 +1940,6 @@ static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
 		alloc_try_hard = false;
 	if (alloc_try_hard)
 		gfp_mask |= __GFP_RETRY_MAYFAIL;
-	if (nid == NUMA_NO_NODE)
-		nid = numa_mem_id();
 
 	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
 
@@ -1979,6 +1975,9 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 	struct folio *folio;
 	int order = huge_page_order(h);
 
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
 	if (order > MAX_PAGE_ORDER)
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-- 
2.27.0


