Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 853CBCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291A88E0001; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241D28E0012; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD3C8E0001; Wed, 10 Sep 2025 09:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E702B8E0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE0C7140889
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:11 +0000 (UTC)
X-FDA: 83873449422.02.063D766
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3F04C20010
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=89lLYaxwtTV09UIktxTHOkr2XzfyNTkjX6BZudfk1VM=;
	b=MzzavtoXso5xPx6gQAj76RQ7Y5jDrK64jiJFEHTpwpT+ajIvw3I8Rsffuv4jp7TRHl49ma
	DaYNBndg2K+szr5R6ahGLXgn9V2iDmuF4vp8CeCk+Z6TdgML+3kA4g2leGCdYXhabUpIXe
	Vc2pJE4fUJnAN2ueL0x2FHEbKPl8UGQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511610; a=rsa-sha256;
	cv=none;
	b=Dz83qU4LH0emOct4nwkNMSztb1DRwTOYtfCv0wXpXIIdzVecS90nquJvoZQ1o6p9Q8QL5W
	r4cWBeIwXUvoLr2TYax4JqgHDs1NEpRedwwV0Cb59MAZYPADq7YPFYl6mFwZVD54FttOD3
	iOXejDZGnf6CQUf/rtcVUAeio6EhBU4=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMMH12r1TzVmfv;
	Wed, 10 Sep 2025 21:39:09 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D895180417;
	Wed, 10 Sep 2025 21:40:04 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:03 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 3/5] mm: hugetlb: directly pass order when allocate a hugetlb folio
Date: Wed, 10 Sep 2025 21:39:56 +0800
Message-ID: <20250910133958.301467-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
References: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 3F04C20010
X-Stat-Signature: d5xfyi4gd9xswn9me1q3pwsrqnw4cz7s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757511608-824347
X-HE-Meta: U2FsdGVkX187Th/LdLjv9q+Peri3ywDmMEP7IubuB+qbfeGQF6eSBYUbGAsG6AmAEQJIBcJ29SSdZh55rBperspc6dM9xWKc9dipuP2ukCfDe/Pcg9Rr7B17EKy+BSvup/tizf4CxseCDx0T0VgTNqJ/pjUlaannaMot3FRDEB6jzTKNJoQWZcTu2P6Vnq+Hr18+AIOw0eX9mjB14Lg5gvs4gMnNOjStEFb5dFRh5yKO7C04Q3oYEfiHhfHlSAb1pRr/gIRwaitH43EygXFD5pqW73r5nIYf/trp35CZsE6qGfmHCbcMwu7tDCE6ABWBj4eR7psxm7NFbC2wpkzmQLuGmj0oVrfxTLF1iD1ZA1CJPFigfap3e7r3VfwWRj/cuSPpSx6RJYAtkdoty2UghsWvEN2givQ+SiMHxAW09oSuTSs74dqg7lBKVxChBHfvhd9cV9jQIYFtyTle8wgpvCniP+AijyIULeEhyIMyQU7qp3CrLxqbnaD0/dmDI3Whtx6XPA+fPqa8eXsnO9K5PM9lvHZUYYWX/58iskzexs2mFHeS/iPzajwSDRvh7og4Ci7d7U8SHZ2vB0f0/Nys6vnNHNqSVxQ5NWsOFGcfNMGnbsnisCohHwe3SBw9P29oZZHIv8aoAvJe7aFW4rGPlG4CAoTXQZyXn3LN9A8eERzBDLHD9f1eFWvdDzYRNmLG/lYpHbZkLLMCgn4LT36vaHwFsuZr4MIw+XTTuPHLhnkZKdgwwQ9kbwujOnYzDu3v24QT8ZzqdreqnVVuMpWPJdk4oWM3v3C8yzF22itz3aMCTJBRL5rxTE5As/vuyXMIVR+WJRs4SC8+Gwq/aqfObx0qKZBT7qCpqc0awSw5hmWcm8PbWApak6KH7qmu3blFbZxn4AtcsI8DLJSnA0wpmaP1bglyJtQoUDGBC+z6juVVUZHuvzD5M8+CqYcHXi+tLyDSpSYzKUaV+61u+Br
 2WAng+RN
 IRFeZ5EM5k15o14TPQAk8e2d2qZQvrRIOSXfvbeVcrGqzI3a7be0ZJNnpWwwmxOQ4hxQ933S+khpWYBwTV5v4pUqpWeWnPGR8taXdZ2dc0Ci1T/zhfQmW4i9/ui5qZrS7iFhdoIZA0YQFhjqxvUnAEw/YsGW9PhcVH4vByN3P5K5I/sIKKc9Ka3Zp0cFb2LREsy7cN71Byf5mSV5UIRPwzdfVOlQEaAMK5IYQci1DojKu5B7gEwIluuPJ/YiqIL8B8mBIWZpMkdG1iiZf3vuRkF4wqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use order instead of struct hstate to remove huge_page_order() call
from all hugetlb folio allocation, also order_is_gigantic() is added
to check whether it is a gigantic order.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/hugetlb.h |  7 ++++++-
 mm/hugetlb.c            | 29 ++++++++++++++---------------
 mm/hugetlb_cma.c        |  3 +--
 mm/hugetlb_cma.h        |  6 +++---
 4 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 526d27e88b3b..8e63e46b8e1f 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -788,9 +788,14 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
+static inline bool order_is_gigantic(unsigned int order)
+{
+	return order > MAX_PAGE_ORDER;
+}
+
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
-	return huge_page_order(h) > MAX_PAGE_ORDER;
+	return order_is_gigantic(huge_page_order(h));
 }
 
 static inline unsigned int pages_per_huge_page(const struct hstate *h)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6378f5f40f44..b98736ad60d3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1473,17 +1473,16 @@ static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
 
 #ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
 #ifdef CONFIG_CONTIG_ALLOC
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask)
 {
 	struct folio *folio;
-	int order = huge_page_order(h);
 	bool retried = false;
 
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 retry:
-	folio = hugetlb_cma_alloc_folio(h, gfp_mask, nid, nodemask);
+	folio = hugetlb_cma_alloc_folio(order, gfp_mask, nid, nodemask);
 	if (!folio) {
 		if (hugetlb_cma_exclusive_alloc())
 			return NULL;
@@ -1506,16 +1505,16 @@ static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
 }
 
 #else /* !CONFIG_CONTIG_ALLOC */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
 #endif /* CONFIG_CONTIG_ALLOC */
 
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE */
-static struct folio *alloc_gigantic_folio(struct hstate *h, gfp_t gfp_mask,
-					int nid, nodemask_t *nodemask)
+static struct folio *alloc_gigantic_folio(int order, gfp_t gfp_mask, int nid,
+					  nodemask_t *nodemask)
 {
 	return NULL;
 }
@@ -1926,11 +1925,9 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
 	return NULL;
 }
 
-static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
-		gfp_t gfp_mask, int nid, nodemask_t *nmask,
-		nodemask_t *node_alloc_noretry)
+static struct folio *alloc_buddy_hugetlb_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
 {
-	int order = huge_page_order(h);
 	struct folio *folio;
 	bool alloc_try_hard = true;
 
@@ -1980,11 +1977,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
+	int order = huge_page_order(h);
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
+	if (order_is_gigantic(order))
+		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
+		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
+						  node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(h, folio);
 	return folio;
@@ -2872,7 +2871,7 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
 	 * alloc_contig_range and them. Return -ENOMEM as this has the effect
 	 * of bailing out right away without further retrying.
 	 */
-	if (folio_order(folio) > MAX_PAGE_ORDER)
+	if (order_is_gigantic(folio_order(folio)))
 		return -ENOMEM;
 
 	if (folio_ref_count(folio) && folio_isolate_hugetlb(folio, list))
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index f58ef4969e7a..e8e4dc7182d5 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -26,11 +26,10 @@ void hugetlb_cma_free_folio(struct folio *folio)
 }
 
 
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	int order = huge_page_order(h);
 	struct folio *folio = NULL;
 
 	if (hugetlb_cma[nid])
diff --git a/mm/hugetlb_cma.h b/mm/hugetlb_cma.h
index f7d7fb9880a2..2c2ec8a7e134 100644
--- a/mm/hugetlb_cma.h
+++ b/mm/hugetlb_cma.h
@@ -4,7 +4,7 @@
 
 #ifdef CONFIG_CMA
 void hugetlb_cma_free_folio(struct folio *folio);
-struct folio *hugetlb_cma_alloc_folio(struct hstate *h, gfp_t gfp_mask,
+struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask);
 struct huge_bootmem_page *hugetlb_cma_alloc_bootmem(struct hstate *h, int *nid,
 						    bool node_exact);
@@ -18,8 +18,8 @@ static inline void hugetlb_cma_free_folio(struct folio *folio)
 {
 }
 
-static inline struct folio *hugetlb_cma_alloc_folio(struct hstate *h,
-	    gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+static inline struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
+		int nid, nodemask_t *nodemask)
 {
 	return NULL;
 }
-- 
2.27.0


