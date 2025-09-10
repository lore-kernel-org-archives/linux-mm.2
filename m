Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECF6CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0F88E0008; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 304B58E0001; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A5C88E0008; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B20C8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAF061608BE
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:10 +0000 (UTC)
X-FDA: 83873449380.15.7AA1D6B
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 64E3F40004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmA1e0JWIBESTjeodQ3FSfaQwLnOJXfn8wH2o53Z0vw=;
	b=ZOdE9Y5k8ueaT91EbnT76sBXdfNwZvrRajrS2hc5OGfGAaJ3ohaeey1Uom9BCl5e0+Fjiv
	6xnCpZtxuxLzjCthcCXgoQthiTui2c6vUfCwEK65gouNMnZLpdNjPiYXkCB4kB/x1vEa7l
	WKTccqLzXEOz92c8rvAIwvYmsNVYEMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511609; a=rsa-sha256;
	cv=none;
	b=k6E23roewKJCTYfNFl2HoKeWb4KSNp/NAi/ZOoDkCuRq4hKmJVRU6qhisd/GTvPdcL372O
	pA5qkKvQllK2h2KxEAPl9TltB0g4TeP49bkQbwC5p4rvpvIMlx0RpIBDa0jy4v5bA4T+wO
	opCfjMBy9XljCmVyhzzl2FP+IoIbU2Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMMH02PJVzVmh7;
	Wed, 10 Sep 2025 21:39:08 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7078E140136;
	Wed, 10 Sep 2025 21:40:03 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:02 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 2/5] mm: hugetlb: convert to account_new_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:55 +0800
Message-ID: <20250910133958.301467-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
References: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 64E3F40004
X-Stat-Signature: g4ouxisi8c15mwnkkkdmnwyn8tfx5ed9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757511607-222865
X-HE-Meta: U2FsdGVkX19GtefLLMw7/KCp8e7JrCdmq7WQgrfM4YWqDVrF2F+uUhiURleAuHrhBTeeI7DzkhtNeyoMKcmmexpkPikBtrfzhWgZUvQ9PjOerWVQ9/XyKGifrU/yzVJeKABBd6X8X8c3IcSbTIXAR7dc5Ke61PnUUWS+taOZUfJ4HJ3iwoJVlu/hEBylG8q/HW+5VhKdziLDkZtlXKibvIboqIw63OBeiSBKcsWgUBx7RewH2TK8xELvM56+zaNQVM1bI/hpOEu0J9L7b/ouLiLULecInuZj285wzm9t/g4WWsCCZqnrwEZbjACb+7AkaL4ZRR3JwSx5cCmtQCIrnHJzOAxCdVxssV53zTaX9ZpKLUJUViDzvZsF5jY3BlI4Kk9Q7ywtpGVICvmc5nDUtSHTT3e6FfFJtZxGI0R0f/V9kAIphd0GqZ4ZcJ5mOy73CYLM9YZr1eZ8aPBC3jTZhzW/lMLxbTjzvSfYJYn9QrU7jeXGBoZrAqUNjyjh+MrT00k5UuKEfNelL5L21dkPuBGhnaqrtsLteKHNWjT963wXmBV3gdsYb3mHwYEq1gIYQsf+1iybRIq8PN1hqapVtUdHCuDB26beI1fr8pvKuXVUmmBPhUigm4MCigvcy1Pdje2FLKuIJWWpa9t6WS3HZRaHugGugD9DgxUXb4w3UqmnlYkVX4HRsMVP6vKAefqPAX5W5TtpamMYe3UNoAvB6+uVOVZk2hNEfj767883wSlSXxJsoXQy8AgR0s+nLRoZCJWViX4MgTpGjQnxPyYKTVFobMh6XYwxfAjzAzfCWeQJUilPXJXcnYUELJeawRXwKYbmMcfIyl2d7ZmjXWZ9X2D3gC3pzyZGUr+H9GoQr+IRd0nUZru106Tkf3/bUQZptcAIXqfgKDzmRHkAQe8OQcK2SWJi+uI2ea1hrA6ElGQUN0WIOCaYtDWD5tmTOvZEzDIbjTqmQI6Kkx2jA5k
 LU+mhiy3
 wn7gkLFUWRiyBya/SGLTlmXoeiKESg6CEUnftkvdxc2ZUyMzwQnEUGn4KYt9b8iaFK69iM7Bd3yOt4MVDF4DY+rPdIZSLgiMT2HbfNkC6vbUwk66Fdxd6YeMa3bVRKlcnSLI0tO6Be8wMhLjNF5tWbM06uAq+A19h/dhbuqPtaxF0jMtIWu9DhxXXr0rHC6vTcYxOYeKI5QI3Q6bKihS/Jzr/Xy2RZ7VQwvUrT5hqnX8twQy9e4q3RYvnsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to avoid the wrong nid passed into the account, and we
did make such mistake before, so it's better to move folio_nid()
into account_new_hugetlb_folio().

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 42f79c4b916b..6378f5f40f44 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1890,11 +1890,11 @@ void free_huge_folio(struct folio *folio)
 /*
  * Must be called with the hugetlb lock held
  */
-static void __prep_account_new_huge_page(struct hstate *h, int nid)
+static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
 	lockdep_assert_held(&hugetlb_lock);
 	h->nr_huge_pages++;
-	h->nr_huge_pages_node[nid]++;
+	h->nr_huge_pages_node[folio_nid(folio)]++;
 }
 
 static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
@@ -2020,7 +2020,7 @@ static void prep_and_add_allocated_folios(struct hstate *h,
 	/* Add all new pool pages to free lists in one lock cycle */
 	spin_lock_irqsave(&hugetlb_lock, flags);
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 	}
 	spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2232,7 +2232,7 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 
 	/*
 	 * We could have raced with the pool size change.
@@ -2270,7 +2270,7 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, folio_nid(folio));
+	account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2829,7 +2829,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		/*
 		 * Ok, old_folio is still a genuine free hugepage. Remove it from
 		 * the freelist and decrease the counters. These will be
-		 * incremented again when calling __prep_account_new_huge_page()
+		 * incremented again when calling account_new_hugetlb_folio()
 		 * and enqueue_hugetlb_folio() for new_folio. The counters will
 		 * remain stable since this happens under the lock.
 		 */
@@ -2839,7 +2839,7 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		 * Ref count on new_folio is already zero as it was dropped
 		 * earlier.  It can be directly added to the pool free list.
 		 */
-		__prep_account_new_huge_page(h, nid);
+		account_new_hugetlb_folio(h, new_folio);
 		enqueue_hugetlb_folio(h, new_folio);
 
 		/*
@@ -3309,7 +3309,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
-		__prep_account_new_huge_page(h, folio_nid(folio));
+		account_new_hugetlb_folio(h, folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 	}
-- 
2.27.0


