Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82D24C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644636B008A; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDD06B0095; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E24D6B0098; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 41B9D6B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0713E160953
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:40 +0000 (UTC)
X-FDA: 83730997560.29.2ABC58F
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A41C12000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119898; a=rsa-sha256;
	cv=none;
	b=vs+p5HvKDy5Lb7HdmkxQ3atRpeAwHME5gU9pQBkjuaKqD9CTbOYWVM4wxQGX2UVqTH5WOg
	r9ZjOd7YD8em4fQGaIKDJb3DVuz43wPzgn6ZlAUMOAtrYjg7w9+k8MEQoyMMvrIHPftwwQ
	HnQ49M/1BznGM4VRmmZOZP8BB9IcCrI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mlOHQWnoC5xysJNsPYZEczfj7M19MxrJco4foh5Sysk=;
	b=FX6q4lytb2qnqVmw0Xt166guhqtvnd5cRmJEzjAQXSqarzY/4NLu60zKBBjP2x2ecOn0HL
	WtfEk8jsVm20Ru5JNBksubwmqusoA3FroHPklaxYK6ZBDapLoBioQnfJPgjaanGBu6KrD7
	5idRVvdOVxi3jXbNazYvd59sqBC5Nhw=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4bvDvC0Lqrz13Mnv;
	Sat,  2 Aug 2025 15:28:23 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DDE3218007F;
	Sat,  2 Aug 2025 15:31:32 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 4/7] mm: hugetlb: directly pass order when allocate a hugetlb folio
Date: Sat, 2 Aug 2025 15:31:04 +0800
Message-ID: <20250802073107.2787975-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A41C12000B
X-Stat-Signature: 4b4hw9qod3a5gycerauqbi5honqggiwy
X-HE-Tag: 1754119897-758305
X-HE-Meta: U2FsdGVkX18EIo1ciAOsJ2d6Ey8mylaMUO+E0mOqGHKPVZUeR4gDsG3pNSIimpA3gjYqdfLYoapj6zDDlC5U8vFnK3EM64iwczbDfojWnqj38Jav947QT9TVHmYHGdJn3/H0x3VPiMAaeve06aT6cwbbpr4rkDT9sr7Oa8Q5J7BhklHOvaqKRaW1xbgQaR1/z0zmCogirnNR38hQdNoswo4pxRF6IK0R8HWyCQ61i+20rZc/Mvd6abKl76kK7LPAg2g+VIdMxmIgWPuel5Fkh+ycTgYUJ2YS0CID185/xQdF7tIALJYv87yFrCOtHfSnbV5y7MxZYsW1K7LQnl57Ys+k6nIxxHPoQmT3R6Tk0ipQuAr4Sh6mc3tMs4bRKH3eKVZRnEKjKOBww43e50xiwSMr9e+6MaPdAobw1xyCx+oy/fNqTwEupKKHvsi8J95YXwGz2ecZcjZNCrt5aH/0KIXOvynF9UhmiVWoXwr+UM7/4Ll/AC9xZm16duJ2Y0dhj6Hg3M1biv4whGGTwVO31UFMaSwZzmFc6D59UgaaMqEAboEtomq3IFryWxdGwZwXOrIhpaKvxdgSAF361asSMs+H7NgmVbYd8SeV6AEpE6zsbZuPQKNmAXrEtxSpHTrqKVXuxhBNrL6ZB6qR2eBMV452zmFvyVa9noihWnfbWJZeSe/28/HCirdW8aXaaNI6MPHu1H/vBCvEafUZkgUZMVoHEqPVPM6j94ceWkn1xxS1rz6FjDRggB0fpbSu5hOJPrT6UeE6LakU+dGJcfY4QNISVEZ6Z+GbAFCopdfeOcT3e56+ehCcV+YxZ/a9gCRRUpOJ7wYNPzsQP+KL/LEJV0dwDU3xJMAhDp94zehOOW7/zRYreOzO+zOmWkXSDgOMa2rF3LwNqa+1YIEDkRVviF8grokKd+Na/30m78qJkO8cM4MBzI0/xzQjJjlM1N66IUAz8Ek+UFXzpruNq+C
 FSij+bW9
 VMM2WGvgu4ht1UsD49zlKVpeDF97p/veUoPcM/RkAgu5Hbz8LmKBl90mWJ+Cu8A86GnuOlSR+td6qweVeU7HQVE1fl0RQdyAvNozmr8JUdPJmFrvuj3puRSE5IHZoUr61L2AY36D8FV7knc4PCktI2clRunLe6/sBafSM+/xIB1x2NtSKgVUuxdZAM8X5p7LfwkwfcoP5OBUg+g13OzkjGvirCE95P3AatQa9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use order instead of struct hstate to remove huge_page_order() call
from all hugetlb folio allocation.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c     | 27 +++++++++++++--------------
 mm/hugetlb_cma.c |  3 +--
 mm/hugetlb_cma.h |  6 +++---
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 436403fb0bed..e174a9269f52 100644
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
 
@@ -1977,11 +1974,13 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nodemask_t *node_alloc_noretry)
 {
 	struct folio *folio;
+	int order = huge_page_order(h);
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
+	if (order > MAX_PAGE_ORDER)
+		folio = alloc_gigantic_folio(order, gfp_mask, nid, nmask);
 	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, node_alloc_noretry);
+		folio = alloc_buddy_hugetlb_folio(order, gfp_mask, nid, nmask,
+						  node_alloc_noretry);
 	if (folio)
 		init_new_hugetlb_folio(h, folio);
 	return folio;
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


