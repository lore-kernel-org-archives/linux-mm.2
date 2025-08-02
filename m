Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C57FC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 07:31:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078636B0096; Sat,  2 Aug 2025 03:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B546B008C; Sat,  2 Aug 2025 03:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09A76B0095; Sat,  2 Aug 2025 03:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29536B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 03:31:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8EAE21408F8
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:38 +0000 (UTC)
X-FDA: 83730997476.10.4D542BB
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FFDF14000E
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:31:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754119896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntgCPiKkruZkLODQgvbDapgG5C6MDDeWBoDbN2epLN4=;
	b=1Zrd+0o0K7ED9SlJM4LKSeGzhn+oXuuXp3D+otqBRiy/jb1duFsLueiB+KHupTwghf0VJt
	wISxgKiZnVQfx2lDfNcikWRX0nXHcMePyRnZryuU9uWFdtKeaS6XF2/lLeO9gzEf0nCp8D
	7/JN2iZskkgmQKS7BOirjy185A7M6QM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754119896; a=rsa-sha256;
	cv=none;
	b=QWko/3Cfjo8+CDADiRNZODZJ0h2Y77BDCHiKSon0bQVpnSwMmThZhOjINqxcGmLSZm3izH
	+J37pTPeSbBYdacJZbieMOKi3+qB9r/1M2LvZ0I4VUWchzIXVrz3K+n2n7iIjhMIY3dT3m
	rXASSrOjs6vDJLMagHbIfTtTngpssJg=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bvF0064npz27j07;
	Sat,  2 Aug 2025 15:32:32 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C9F3C1A0188;
	Sat,  2 Aug 2025 15:31:30 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 15:31:30 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>
CC: <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/7] mm: hugetlb: convert to alloc_fresh_hugetlb_hvo_folio()
Date: Sat, 2 Aug 2025 15:31:01 +0800
Message-ID: <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
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
X-Rspamd-Queue-Id: 3FFDF14000E
X-Rspamd-Server: rspam06
X-Stat-Signature: xpthwchzgn5mjgibgs1sjokeq7qxi5d8
X-HE-Tag: 1754119894-619994
X-HE-Meta: U2FsdGVkX1+NgWVtYrRp3I7V5KwacehW8Bo/kHAisCXESjNJRDyi+IsXjvHMFqWFKkMGtLxDQAoIi13GV62mMJTb4+2CyibjL4YGXqjzzjLVp09Pbkeppg8oSnq5wKv8xyfjt9dYqqoE8yxanVk902B32TSO2wv04O6F8LBAvgKcs6fJla0LrMLwXtx6EBYl+HSBE4D0er9Q0Q9EvIWlGq1cc99Y5i3ChD73R5c+ao8D+erid6BmDfGFY5ANwPXDDUEhw2r/r5bS01RRF/EVPPYACsqx3jFBuZYQECh5frq0l7Mw1YFJc53yjmjIuyuUgI5FlybopKfIZpjoBB6KqSQtOcIP+JSo2HzCgKMLhwgOKy/p+haYMXhdgHnz4owV6JMnHREgezIMFMu4AJGBop/e5Fhit8zd7k/EbhSxeLYzD5dPH//AOhA78+Hpa1CUhhxvuW0eVGWZUdI8F6VzNO/+Ytc/luA+RLnKnDkliPDbA9TLP1Puagf0vgihk4NlUVF4b/hKCDq+5GgYKeSVaqAqbhhiWek5JAE7UR3FWDV0NCaAKlqoY0glbi4tFNB3FGgqXQDt9ebUrLZxwbBoiX7BB7MnxuzS1Y41wjnfsFrcCxxUrEta1D0MLpFmF/YOaef/JkXtlXXTX/VpaCTRldhU1F9Zxdw8wrCyrxUP/ukXdT2xo+m24HlrqQHEq0+8L4llOzu1bbr5ftbMdAFi5G2T1WavKye3PjmmAlVJuT0PU5t3/P31j9mA+Vf/vjYdId4/0ka9TtsDRsxQsGBtwuhh4gxX6tO4sVtrLC5s8K6aw/rjPsTFjxvcHLvEJFrf4dkxPujCrrbDRoV9TVbwnJwjkp71DFa/ITDDrHuReREZCWUfpc9fspX6uOcx5ccIvWAcYt/r52HKgNlhxAtgPTTz0xkejTTwSuarLOiweYjtKo4IUi33k63l0lQyay9l4Uk/fdUTZoXhk7aq3K0
 I6+/ZnKp
 FcWkMGDofiK/qocVVzse34fn+fPszYXyWKQNZhXf7sNIHtpTEiBbcPD1xVqht7T8C0KPXFH/2lrKYLj8eS9k96GFRkI5uTX/Noo6Vc/EzEArSOwcGUk/y1xvA3FTzlbcFCSo97SLJ++CX04zK+dpfeaGtrOxShIjDNWIMsUdI+TPSe2rBEecdvtmvQPyWRg90DW3R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now alloc_fresh_hugetlb_folio() is only called by
alloc_migrate_hugetlb_folio(), cleanup it by converting to
alloc_fresh_hugetlb_hvo_folio(), also simplify the
alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
too which help us to remove prep_new_hugetlb_folio() and
__prep_new_hugetlb_folio().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 48 +++++++++++++++---------------------------------
 1 file changed, 15 insertions(+), 33 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..5b4c19e7a5f7 100644
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
+ * Note that returned folio is 'frozen':  ref count of head page and all tail
  * pages is zero.
  */
-static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
+static struct folio *alloc_fresh_hugetlb_hvo_folio(struct hstate *h,
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
+	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
 	if (!folio)
 		return NULL;
 
-	hugetlb_vmemmap_optimize_folio(h, folio);
-
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2286,10 +2265,14 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
+	folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
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
+			new_folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask,
+								  nid, NULL);
 			if (!new_folio)
 				return -ENOMEM;
-			__prep_new_hugetlb_folio(h, new_folio);
 			goto retry;
 		}
 
-- 
2.27.0


