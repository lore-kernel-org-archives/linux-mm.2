Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E855DCAC583
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B798E000C; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AB28E0001; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90428E000C; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A921D8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64DD3140878
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:11 +0000 (UTC)
X-FDA: 83873449422.28.3089ABF
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf20.hostedemail.com (Postfix) with ESMTP id 47A5E1C000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511609; a=rsa-sha256;
	cv=none;
	b=Uuy6dKtC6zZ/p5ddBly4Vi+lqtkNmrfeLoyilHY5+4n1AlQguXfUM16n3rq2obTuclD/E4
	CN6CSwI6CVxmZW2Bfw8CCTraqKIpYjQ4YWQNsdESQjxiLRTRA6LWhsmzQ8uT1qVJxzY2KS
	SxQ2KjZirEiOr5jHDNRKqog42rxbRcI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=14knfjPMFd0AfR7pfUEVleGNvviN9OuoCRzdAGT/7h8=;
	b=yx7wI/UvvPcGxE8Hs8cfhHrX1++qYbR01/WPkIRaBA5ew4qXe1d2JFLBjm+HFk3j8E0Y05
	DtXr00DcEiuRVUhJrxrBrEe7tjCcepqPxDkJ1z/iCIX/hgqiVgme8rMhS+eaHbD0+MQUMt
	qeWzlv4x3jC9wH2vlJKLakp+JvAzz2A=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMMDL3H7Gz2TTF3;
	Wed, 10 Sep 2025 21:36:50 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 97C86140145;
	Wed, 10 Sep 2025 21:40:06 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:05 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 5/5] mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:58 +0800
Message-ID: <20250910133958.301467-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
References: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47A5E1C000C
X-Stat-Signature: gm1arhygc8gk6hmra1jahtjr4s3fkij9
X-Rspam-User: 
X-HE-Tag: 1757511608-273768
X-HE-Meta: U2FsdGVkX1+htXOrfTFgyLV6K5ZYZG/53YlcXkRqUsubhVxSoh7sbAQwN4bdHqsiGPP/qWIq/2ByvKWMN15ON8igOuJTFa7nfUgtCis4MNLnlAYMSZwrpdFXDYe+WLyqRXQIsb5tq/7ezAMiaHMPD6phygkQq6b1U4YnXE1L5LqClpJs5cBkjAmPdQspqNNKJ3jfbCcCp402Pll8y6RTrfVGK8xwi9hi7i4iMWnXDYyWj5XJGjKNLyJtPnvMgqhH2sBYg8undaBrnXyK6CyFcPDIQqP0BivHrlnhIPHuzyhm/9+tVVHpAzZPQvGEhszGu2w3bqnZUgMb1iW91q43JrJm5rjpCMtgcfIxt+//lEfwL4IntZje45pIjz9NXthwbKs/p68EVBOG9KCMwlYKB0Bv8LD63V/NZtLEEN94Kv4p7DAEdojbA9RBZI8aj7lCfJcfsLnepUAqKNMa2+Mh84kpCF294y6MXzXR4jUqOSWgIlwu7uQE108nQPMtfZy9IuPIGwB2dGRpLxhaLnpJwPt4jLjXF6yUPSki60KRqSsFcJY6q9ePBhEmcUY1/5+CtAXi4P2U7Xw/8dmvb8jO5t/3HjYD5w3n4aDCHrQftQpCoLB12OHi6Tk2ZwsgqFcPSTA+HOUQFByOJr0jy8cA2U018uVkCkx9MxwHzk1zD8OvI/gjpGvuJT6W/cnNCzaTGPt+mRuzLWin5SRBnYxmL1ZPHNXfA5/5VzPLsVWlDH5DZ8e/ul0q4+azecJy/BHJ391TqrQrJWLH2UGwCDZIB/+ycLYHPrn8ROc/c0O8eCRprEvtiwBJ4s8pmAxgjd+ptgJAq25dO8NNPsVVK6sXu/L5e2vNoHSzUGV3GqDMr1wwNYzniWmluSDa9hiQDdXh7ZAO/HLPBN3gpSbVyta+oxq+lSwAAxqyfpE70DN/qiwKWwMSlK3zmeFJATOM20u8AXa7mGTlbqcV7AAkbbr
 SEZR14x/
 m+RH6
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

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 28519a73eab7..856f6ec3a41a 100644
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
 	if (order_is_gigantic(order))
 		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-- 
2.27.0


