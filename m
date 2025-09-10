Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9703CCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688948E0006; Wed, 10 Sep 2025 09:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 639798E0001; Wed, 10 Sep 2025 09:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48BA58E0006; Wed, 10 Sep 2025 09:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 377F68E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0258DC0903
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:09 +0000 (UTC)
X-FDA: 83873449380.28.2D1CD8B
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1593840011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S8eo55YCAeH1ltx5sqtyubec9sOgbsTzAcuRYGls7Dk=;
	b=y6h9umJryqgm2E9CcbWws74kHqhrtC7rih6vwAm3wxneKfkMIbG/q+jCxVxXnCYqAH0lOw
	v/3UaQJfmNgBg/4Tz7zu0NjSSAyfrV9pngqWdCuiYllnZ7c8bTTJWKWIM9KYXcXwpcNrJq
	mcS5aFyUuXhLIlyVMCvYdHEfMSfd5aE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511608; a=rsa-sha256;
	cv=none;
	b=no8hICZ7ETDcyhOWJt9kpFVS8ij+QUlpNHYw7pq9NMNCE1lqY0oVxVfiopPow8J4gKYUa6
	bcG+cMd2jHsq5vPA7Of0G0e/c3yGroEmWzqQAanHmIwIq2NKpj1uKvcqRkDYX8qKH3RS63
	Uz5tU+hoiHskwi+dB4pwxdQ7Vbn7sr4=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMMGz2554zVmgK;
	Wed, 10 Sep 2025 21:39:07 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 65D57180080;
	Wed, 10 Sep 2025 21:40:02 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:01 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 1/5] mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
Date: Wed, 10 Sep 2025 21:39:54 +0800
Message-ID: <20250910133958.301467-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
References: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 1593840011
X-Rspamd-Server: rspam05
X-Stat-Signature: fccgif7quh33puf5dnaornfx5mob8uc1
X-Rspam-User: 
X-HE-Tag: 1757511606-217327
X-HE-Meta: U2FsdGVkX19551sOULSK9Pjz32OIlNEk+oiGvGTbTe1W8EPdhK6j/xTgzLiutQqbYpVL1WbIyr6gT5+607TYD/Q+xfzY9KNwz/qV2DlH4LH5nh4PAQfsKItH4PSOqR+eKYDPROr5KRaeoZgv88HvPooVUCU6AZytQoInxq7EnmoLUawj1QDoifoe8pb9Ls0wjh9YXPYixhbTjUu/vCkvx12C7Mp02maxLKXLxRIozhXE9+VLzWouXzMprXUTUnKhiqloif0OVO6WBOdlOyZYasnp2oxrwWfcztdSNse7I/KGuUyM7tr3katUfsefLKfzWtkMoPLiGmBMChTEpp3OXJzzSSoXNkZmMqAJebnglphanWM2CupZ1CujD43EKEr3CK2MWPvYWCPUJ7Vewab7696bQzJAJfZWuSSHNOjm3fYR9utiXuIDnEAoEAtjALF9OdsTLseu7hB8SNHpshWEmoFDpVPz2M1GIV4C6+qMKkakycO4D4KwEeusKmW+B8NyjNz0bcg5Lp1ck0XQzcm/xEHMhded62bNfFrLaMuttvM+pAK0bDciHqkAyOocLIrNu3CMtSL+ohcB8i4WwZasLPO47z6QuqV1botccRpvR+S/TbaPR9MlOCynAZahRUAo24+oKES7GvGXyr09+/EwJCquu9C/ifCOxfPTBkzYEgIq0oTR+p4ai0JtJ+wUVgOLl6QQ8pSxgPnAl31WdhBqT/8yjBC9nttpLx5mmKTPG9ujZZxexkImP1Ja9bmaO/BXnHf8C8muprhdRZNw6Bwm7BmwLOKRxn6sdGA/HAGejqTbk+mbgtSydCr1QXm4sblls5gOhz3Q0QbVG5eHPPRzPJwYQ5B/szJb3vr9HT63aCao254BFlc3YvekTwA9Mfrf2A5oonXcSUXouOgbsgLPrbUGq9te/S1EMpZ0az9Na6A7zrS0rdH6Ojox+v2hy6lzFo8FysXG7zfv7Y4KE6D
 hZ36UTFp
 3vLHrQ5AtaO1t5Fzk49wIHe50vQA9yECm0GHn7i1gwz43ecxrJelWRviFs6v15n7imgq4ORza2rHywU/JDkyUbAeO1gtp/lV2VPGg/19zJ2sL9POzgCmbq5NhG9BExjY5q1kzKwwYOXE6tA7o0PvQA0bG/Juf7jBrs86NZbxy3WSwvArCdlMR8Fp0+jwzd710BQjnDhoJXxoSUUWanr+uD5wKjxzz7MSsIHOf8I0Z7z/ByyuUyFJwffy2lBNNjgno3b7SnqE+Cq813mgQpK/TnG2MWcDsxSLFoWmm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify alloc_fresh_hugetlb_folio() and convert more functions
to use it, which help us to remove prep_new_hugetlb_folio() and
__prep_new_hugetlb_folio().

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 46 ++++++++++++++--------------------------------
 1 file changed, 14 insertions(+), 32 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..42f79c4b916b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1906,20 +1906,6 @@ static void init_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 	set_hugetlb_cgroup_rsvd(folio, NULL);
 }
 
-static void __prep_new_hugetlb_folio(struct hstate *h, struct folio *folio)
-{
-	init_new_hugetlb_folio(h, folio);
-	hugetlb_vmemmap_optimize_folio(h, folio);
-}
-
-static void prep_new_hugetlb_folio(struct hstate *h, struct folio *folio, int nid)
-{
-	__prep_new_hugetlb_folio(h, folio);
-	spin_lock_irq(&hugetlb_lock);
-	__prep_account_new_huge_page(h, nid);
-	spin_unlock_irq(&hugetlb_lock);
-}
-
 /*
  * Find and lock address space (mapping) in write mode.
  *
@@ -2005,25 +1991,20 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 }
 
 /*
- * Common helper to allocate a fresh hugetlb page. All specific allocators
- * should use this function to get new hugetlb pages
+ * Common helper to allocate a fresh hugetlb folio. All specific allocators
+ * should use this function to get new hugetlb folio
  *
- * Note that returned page is 'frozen':  ref count of head page and all tail
- * pages is zero.
+ * Note that returned folio is 'frozen':  ref count of head page and all tail
+ * pages is zero, and the accounting must be done in the caller.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, int nid, nodemask_t *nmask)
 {
 	struct folio *folio;
 
-	if (hstate_is_gigantic(h))
-		folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
-	else
-		folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
-	if (!folio)
-		return NULL;
-
-	prep_new_hugetlb_folio(h, folio, folio_nid(folio));
+	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	if (folio)
+		hugetlb_vmemmap_optimize_folio(h, folio);
 	return folio;
 }
 
@@ -2241,12 +2222,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		goto out_unlock;
 	spin_unlock_irq(&hugetlb_lock);
 
-	folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, NULL);
+	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
-	hugetlb_vmemmap_optimize_folio(h, folio);
-
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2290,6 +2269,10 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (!folio)
 		return NULL;
 
+	spin_lock_irq(&hugetlb_lock);
+	__prep_account_new_huge_page(h, folio_nid(folio));
+	spin_unlock_irq(&hugetlb_lock);
+
 	/* fresh huge pages are frozen */
 	folio_ref_unfreeze(folio, 1);
 	/*
@@ -2836,11 +2819,10 @@ static int alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
 		if (!new_folio) {
 			spin_unlock_irq(&hugetlb_lock);
 			gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
-			new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
-							      NULL, NULL);
+			new_folio = alloc_fresh_hugetlb_folio(h, gfp_mask,
+							      nid, NULL);
 			if (!new_folio)
 				return -ENOMEM;
-			__prep_new_hugetlb_folio(h, new_folio);
 			goto retry;
 		}
 
-- 
2.27.0


