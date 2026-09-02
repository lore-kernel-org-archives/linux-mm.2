Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F78C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD08B6B009B; Wed,  2 Sep 2026 13:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8166B009E; Wed,  2 Sep 2026 13:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE4056B00A1; Wed,  2 Sep 2026 13:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 928056B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 243F41A027E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:30 +0000 (UTC)
X-FDA: 85169544180.11.51A17BB
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf25.hostedemail.com (Postfix) with ESMTP id 327A9A0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pFUEPGIs;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371008;
	b=ZOx+hVsR3FGuXPunDufWPQ+IrTC/idkOSs7y/8bU+Pu+tg0WjUl1QFJ/4MAhIAJUrEd6Sn
	Vx46EKjoPwD7+0u1PaiEbHsh5fF0Di6V6y4bVlP9NNgsp60/DX3N8A74HRA6zAGL9KxUeT
	yQGXdrXwOpMhzYKz0XI4DUFvOYQt8fE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pFUEPGIs;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbBsKZi8rbtnosHZ3ahxPe1RD9zRkDW3KNxV4ZPxMnY=;
	b=itfrwdILdfIUOxubzTRHkxDM+fwhQXm8usVjkl8Cahk+gLxOAG8tH4qgfwyjWUlfOHvp/P
	WuENVS+Zs5AH8nH7a6brqK9lSFgOyv+8WX0kebrRBymk1wKCXmWjSOjwXyDvLazmNNNJyJ
	XLRkf5DI57SvraSFmV2d1KWgvTfP37Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rWzSf4/q6Aumm/yTV0thYJVvKmJBRESHWPrugyCcmzc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371006; v=1; x=1788975806;
 b=pFUEPGIsiZejmhTQGZnE+C0AEtFNoI+nr0XIs3/XcfpamtMkU+UUTJB+BcAXfr8jF5NyYkM8
 owcUPeq/fp4He+LnI9EtFXtOBSgZ6vajNrgCsOu2MkqVEKBS7LLzmORfzN6YCHCsgLw6P+Pfzde
 nYkzkQbE2Xw+Q8wem5RhTj5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id af3d6bcebe1df564;
	Wed, 02 Sep 2026 17:43:26 +0000
X-Mizu-Trace-ID: af3d6bcebe1df564
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] memcg: remove mem_cgroup_shrink_node()
Date: Wed,  2 Sep 2026 10:43:05 -0700
Message-ID: <20260902174311.1772372-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 327A9A0007
X-Stat-Signature: e47x75q695zhhzkja9aouu933aurzjzs
X-HE-Tag: 1788371007-592480
X-HE-Meta: U2FsdGVkX1/LOMOqpt3WmFWfKoNREbWsI2XrnJ3k3XlP3va4cBT4eMBF+gOUAiMW052VLt25BV5JMe2JjQ5rOMSGa3gQhMFjwtoakiWGBeCOqz8qSGhW5V1iabXdjEViWHgKzG9InY3ME6nR1//nVktyJzpprwxodoOwynrAYHbmdhD4CVoObraPy0qzSKBn18j+m5YWbvju2jB6t7MtIMNc/eojyVU9tKpUlU3wbKY41e62pjyHTLAEfHyrLxUX37GZcXH9S58g0XR3TZdv+IlVJopos4/lwg5hflhoH0ZRLPoeXiX2lAchIsrlH1LLOa59s55rvefpRHzOQ/cuwgQPb6fuYXHRY6Inz8eKtFuTKY8p/km/zOM4IrDesBVMa2sk71kbhvx096HkPDs4nTFipWFN4sKwNqyUCxG1YD7iWMazco0q2I7DHHzyZcLc40bqAd9eB6RCR1HBDflJB9puA4YqNj8l2hez+mG4WWyS3vXnij8Nu6Xuw5VjdeToBGGFVhXT6jWq9/7/ffXJZQcAoVzZZbu1Zw+MnuPSuylaYfsK1IUTZJZCtouCjyuMdYqOnVI3ze+fNWCjvgnBYiCy/hg8b63NrUD8qtXsIOi3fptnKx/372HQYlLNLHiocCEbeNaBVrk75q6KWQ+IxU+1jliUpQ/9o10XaPTiDYrlAtqOcWdcbMDkgXdIo3Ls053iabZpjawIh31RZHDcDNk9Ub7VVBvifRmcuIHEdtYRDXuNGQzpoiFpBOxjiN9PmO+Nd1h3b3nboCqFgGOyDobgE+kfH1D51X3gjBlwNvaxVVEmNCTAQBMEoJ+m+cuDyFJIE+6wKFhN/t1QXPor2viVCj2U3pMu8MqETDyRy7/pFTNJX+rIXCrWX6fVxS/fD3NZ0F3xDlOoENqNMi8pYZ6Z0ATUjNoxMyV9Bnxod44ROso8dnZDjMG3GyqddI+YeCv7fAYHpk3dGB+Xnzb
 RV/Ugzy/
 zQ5UZIOo/yn6io/bQkXOvM50hkqDpGrWXheGTHJuiHFvmQ3GFBM5M63WyC9CtsitFSJu3LcEdPXuyfJ5ND6oLA0A/qQ443mEJ/6SPnjikhYcyEHZHP2U8Lg3dOHM0JsbykgaBeqbXI02HmqfoJ1PrRY0iKHljJn2qH8QlmC2oxCvEtKWjzVNpyfJhQ8oADZhgH4jlgRHpiqL9lGkD3+Wfm1BVXuCUKDf3z8QTiOQ2FsqO5KMvgCgQh/xLrQy3p5gVH+jN6bhxBsOhnTzwfeuXbeTWteV/9s0BeQUYgadkvrGfBi0j4tx6tBtOze6j4+kb3LiQ2QoqVmIN3l60Qu51c81hEbAj6FJ+XZzYFgvB1c+WNKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Its only caller was soft limit reclaim, which is gone.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h |  4 ----
 mm/vmscan.c   | 41 -----------------------------------------
 2 files changed, 45 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5cc220db9076..e16f1250b25c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -78,10 +78,6 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
 					   int *swappiness);
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-				     gfp_t gfp_mask, bool noswap,
-				     pg_data_t *pgdat,
-				     unsigned long *nr_scanned);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0e04eaf64af3..d66b5cd167d6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6805,47 +6805,6 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 
 #ifdef CONFIG_MEMCG
 
-/* Only used by soft limit reclaim. Do not reuse for anything else. */
-unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
-						gfp_t gfp_mask, bool noswap,
-						pg_data_t *pgdat,
-						unsigned long *nr_scanned)
-{
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	struct scan_control sc = {
-		.nr_to_reclaim = SWAP_CLUSTER_MAX,
-		.target_mem_cgroup = memcg,
-		.may_writepage = 1,
-		.may_unmap = 1,
-		.reclaim_idx = MAX_NR_ZONES - 1,
-		.may_swap = !noswap,
-	};
-
-	WARN_ON_ONCE(!current->reclaim_state);
-
-	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
-			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_begin(sc.gfp_mask,
-						      sc.order,
-						      memcg);
-
-	/*
-	 * NOTE: Although we can get the priority field, using it
-	 * here is not a good idea, since it limits the pages we can scan.
-	 * if we don't reclaim here, the shrink_node from balance_pgdat
-	 * will pick up pages from other mem cgroup's as well. We hack
-	 * the priority and make it zero.
-	 */
-	shrink_lruvec(lruvec, &sc);
-
-	trace_mm_vmscan_memcg_softlimit_reclaim_end(sc.nr_reclaimed, memcg);
-
-	*nr_scanned = sc.nr_scanned;
-
-	return sc.nr_reclaimed;
-}
-
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
-- 
2.53.0-Meta


