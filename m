Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980ACE91290
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091996B009F; Thu,  5 Feb 2026 04:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073896B00C7; Thu,  5 Feb 2026 04:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBEA36B00C9; Thu,  5 Feb 2026 04:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAABA6B009F
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:05:25 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97E301C330
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:25 +0000 (UTC)
X-FDA: 84409819410.24.F8E3FCD
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id C23151C000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:05:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vYOlRAue;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a61eWbbzEDz2UJp1doEfV/zCU76HlIc7Sn6ibevaVaQ=;
	b=7Pl45JTy5P9Fn80XYX5cpgtfx4qTxNEUS1wBiKEWqw+lvN9Ek7Xwk2kWMRNpafkDNgszH8
	4I8liypkyveckGuLYXouFBAJLcwNHLEgaw2tXeO392VTXS/oqOrpFYS0nUGs4ra4eufODL
	HgSVHQFU9KbNsrx0chn/7LWIKVgtG+Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vYOlRAue;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282324; a=rsa-sha256;
	cv=none;
	b=rptD02jYweWQx+5Nz892kZHlYJQZxTpiPhuzLZUCjOXip3yrTjfE6FagKVHNicxGb4kRZa
	NMkN2YnJ5ZuyIYL7FRjKcuAJfXqVFYJJ/o7Fe+0Qp58SskrF2k8zUjwYuA2KdJT8wh4Jtu
	lY9rVHncb4WC1cXhuQuNqvHCxgfu5pA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a61eWbbzEDz2UJp1doEfV/zCU76HlIc7Sn6ibevaVaQ=;
	b=vYOlRAueOHnytNbF68ecTXSMe2JBGN42PMMK2NXMNWnU9ULH1WwYVSgQEIjguyt6YXj33T
	20N01Om3G23/sdvLlp/Ggtg9jACplaqESglsgpgpEqW14uYq5Pi/Kp41g10EFmcMO2KLud
	RspUx7COjcAjb9Bd1PDiROhHvqNVghU=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 28/31] mm: workingset: use lruvec_lru_size() to get the number of lru pages
Date: Thu,  5 Feb 2026 17:01:47 +0800
Message-ID: <f3a8fe43c0d8572ad942354cf649c9f25ae762bc.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C23151C000E
X-Stat-Signature: wtoxjuc4ctu57czihp5o74gw7ha7sf34
X-Rspam-User: 
X-HE-Tag: 1770282323-441505
X-HE-Meta: U2FsdGVkX19kdLVS4kCxdzRPtt9fg9uwbUqZXgXBjDlMglI2g0NoEOg+Ui7NAcKLwP4+PeE7ADz+0zppvkP/Fzp9emF9GWFf+aDMGNDEtPhiID2vNo5hoEGlArL+JGR5wCstl6ZPip0gDDpoaux63/KEqL+HNiNJnQcNB4mXQ+hE2KAZ2DMoc+bt/QOo580BTNzxWQq437WHSQyltvqJTaDjmIE5x2vM5oExiYSCDzNcDMOZkex1LF+fGFsCceaVCEWrRBlyJOUGRngSIJXou46VQOelt9V5Sz309LTydETbGgUFn0kpmLmrILwvXtFcAZS0xJyt4GolLn39GEjNmIq0hTdhQy5fyUDY/SFB5G6m5aWejuB/ppWca7Hv5pAH63YZc50i4dqXSflXe318WDUv7OXU89hMNWo5KIWMBaG9h0Mh3x0h/wvgneMWUwj++Bnd765YC+6vmHvyENk3JwotYK5ao7xFjxPU9gPDLp8XRfSIm8TAEmTGvmms+a692OSsCPFlWnaauqbFaOaHcYnrsNumg1Kgbkw7UlfhWoJeKti6KLdlAGleX5d4aWARHTQBFmSVqXn3CWBZ+qsXSFzdqjM+TsEWNpU4y+K8RNUC2m2/p7v2uKpvEJCq1nU6jn9EoGqbZXn8aNFD0ozR4piNhUBKmQ3UwGEg4aQhJIwHdvqPEC3C6qDwRXz7bx4UBjHmXXVtTeIHczjTJ0vUFlEpKUKpNcw1gtk9dKagFDxzXMyBGdTe3XnGgErml/oX0M6XvaHjO+rHhGPkyPzYt69rvSsOWhRyINX6BhgxfbMzg6iRWHahKmBlnBjnN3no3pAgXSN16JwfErgWd89daQKxfC4nuz+Xjg4d+s77FeTla6ZRjndmSA1L8fY05QasUCzb5o25gw4XfCvyhRPFqeO1JHs5v8Nyq0RXWZhGZwJlIKJyPG4TlJNZEajhv+xlg5tRCb0N2Fbjx1UtnqU
 Km3ic8pH
 GepTXN8adWHMwEfkIkRnjEB7xf8g5fR9xei/qe0skXIuZalZPuPQJdiyjxqb6oWKIkj52kXJuHntKz7hFjx/eEUcH4VKklGEQhTKVtwwnQFWuRDoB+zwlWBXOSjk2kekNj/mxrN8YekUVZfnzo6PxqkR2r8GDxmKfZqiZV1Tb8sd1TESUPWVe3nOlBG+HrSnYVBXiZ6eN6MD/rK0IZ2DjkLbznsqVdH2fRi63yZJqkueQwHGXS/ljimZoCN+tv/F8DhSlJqNkGoL5s1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

For cgroup v2, count_shadow_nodes() is the only place to read
non-hierarchical stats (lruvec_stats->state_local). To avoid the need to
consider cgroup v2 during subsequent non-hierarchical stats reparenting,
use lruvec_lru_size() instead of lruvec_page_state_local() to get the
number of lru pages.

For NR_SLAB_RECLAIMABLE_B and NR_SLAB_UNRECLAIMABLE_B cases, it appears
that the statistics here have already been problematic for a while since
slab pages have been reparented. So just ignore it for now.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/swap.h | 1 +
 mm/vmscan.c          | 3 +--
 mm/workingset.c      | 5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 62e124ec6b75a..2ee736438b9d6 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -370,6 +370,7 @@ extern void swap_setup(void);
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8c6f8f0df24b1..4dc52b4b4af50 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -390,8 +390,7 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
  * @lru: lru to use
  * @zone_idx: zones to consider (use MAX_NR_ZONES - 1 for the whole LRU list)
  */
-static unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				     int zone_idx)
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
 	unsigned long size = 0;
 	int zid;
diff --git a/mm/workingset.c b/mm/workingset.c
index 2be53098f6282..ecdc293cd06fb 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -684,9 +684,10 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
+
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_page_state_local(lruvec,
-							 NR_LRU_BASE + i);
+			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
+
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.20.1


