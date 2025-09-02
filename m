Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4196CCA100D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155A58E0010; Tue,  2 Sep 2025 08:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060088E000E; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5BA08E000F; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBA738E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B2AD55AD0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:18 +0000 (UTC)
X-FDA: 83844290796.28.072B0F9
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8AB92160004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZf7Ee6V9kehDy+5Gg4zRY2A0yeR9f+pMkPe4wIx/g0=;
	b=Z+kJqqg6EEZbsPqL9H4vRxkw9LFbOlhulPYNKBXkSoJySdS9BOZa3fmmxOtQtR7Q8G9Ue+
	+zQqqbKr+FCwWicMZOalQQXOgQnfdTf+FNXi4yDHa7vYaah0F043BZ4U23RyGEtI4z2c0Z
	2V7GI3l2xf0iLj1fA/pJM2IhuUDI0zc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817356; a=rsa-sha256;
	cv=none;
	b=EBqgXfSqcLrsPYOgSRhN/YRI2hUQVlU8ZCrxoi29S/M+0QVXMz4s0Fbhi/6QQxqcwxo0NY
	2NW2D1PmeEPNXaEqzj6+nr+7iHLKpvaACirWglaBNsI6LaPL+EVzk+8lcHAgu6j/aUU7w8
	hm/GYueO86Gr/gAdf6fsiB64cYzHoJE=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4cGQZM1vYHz27jVR;
	Tue,  2 Sep 2025 20:50:19 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8B4F91A0188;
	Tue,  2 Sep 2025 20:49:11 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:10 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 1/9] mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
Date: Tue, 2 Sep 2025 20:48:12 +0800
Message-ID: <20250902124820.3081488-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8AB92160004
X-Stat-Signature: f1dzofs1nfxhkyzk7d3xuaf7r88cxc4f
X-Rspam-User: 
X-HE-Tag: 1756817355-774269
X-HE-Meta: U2FsdGVkX19xbFEI8tMtSDs48+pQVEYpqEIOn03GvqkcoLp+N5iz7X3Ht526umPAKaZw1iCGS/my4JBHLR4CcVbtgYsOhaRNS4+JG+Q3Xw2WHbR9sTKDKuFTryNd1vnDLOGL6pOUbvgMMXYSh3hj/K3xzBZ+SUyVhcFNdgaFz1hxwy/hWi3oxZjOZMG+dyn8oq1yN6gG2kJkv5lZ0uQ2OcaDSDZH0O9FbQIzQfOdv5JcN8+kQ06nhqH+Xj1RCj+Chb7BtvdPuQt0GHt3/fSgkhQUI1dngREDFjXNOBj3XVY+bmtr6oRay4S9CkgSBV9ljagjTHafKq3HQI85Hi6GvG0V9u7ObX6NypCgfcqc4QF4Cc0/mBi6opO85lK3EB4fuHcz3N1Etq2R/F3PBoAbZvfX9j8mK/7cMg1xVeitNn+SU16d2k5EyWCigexg2PlEQrPHcI3xEzEvVXiqtXy+oxtAnoA9wwBwYLKpWfpQCPLieqNBHdq7aOA941xxQMKciurQ77az3aGF2T5bj4dFn0dqEN6YO5o35J1Wjurxa8ErMcRlX4WjW88bDPdVjKoie8c2GrIB+tkjuHAkGdMFDoQ2nFZZem6DzoceWun/yfl3bNSxtIoU55tZF7AZU5C0G1oEg/l5YMG/wAZa9JsqVMNpJrh+jli0HnI+qMUHGl/EG+fFxNVM+QyftrJGdiO6Lxr5X/Yc5bI/fjp/+48O4dpPqCuBf2rwSoRYyzMyg1Lwna/7M1A0oz/MRxEzdyK7CwP/4p6Li1gM/UY0GRQXC3dpC3V3RS29xIsS3dN6NMVXj4vpj4WWgHP/UNzV8/Tzen6Hg+OMBFh3RWWL7RxHtcMWMAMTWYnIhook03AgDW4pS8Cwp4Jyih+Z5si3M7XoNk7FX7S3QmNPDz5x627T0VsBbHuFUJcvLEXsrGreKhni1Aas4zCK3yf/PgT1VL0IUl17c/1BFjzt5L9MQw+
 OMc0rD7/
 Sg5og9hlVZ31iu38ak+5QETXzj3p2+a/5h+/d6FeAj1UXzbemkxgEta3TMqhxAwsO+3t6DAPZHkfWDWhj2JFi6k+bG6USlyPShJLxCGIbDh4+rITEL1SZCXi3oS028VtOqeM9mZa3LzcUm/HSbeOomZStj4qhpVMdEguam/Zm+xj0NV8puIAZjVX8OBI6A+ZG5tmarqAZt9li+FaNP5VuCKa2qfM/H9w12cPP
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

Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 44 +++++++++++++-------------------------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 572b6f777284..93aa32c51265 100644
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
@@ -2005,10 +1991,10 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 }
 
 /*
- * Common helper to allocate a fresh hugetlb page. All specific allocators
- * should use this function to get new hugetlb pages
+ * Common helper to allocate a fresh hugetlb folio. All specific allocators
+ * should use this function to get new hugetlb folio
  *
- * Note that returned page is 'frozen':  ref count of head page and all tail
+ * Note that returned folio is 'frozen':  ref count of head page and all tail
  * pages is zero.
  */
 static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
@@ -2016,14 +2002,9 @@ static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
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


