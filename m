Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626C0C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765C76B0095; Mon,  7 Sep 2026 23:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73D886B0096; Mon,  7 Sep 2026 23:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 653BE6B0098; Mon,  7 Sep 2026 23:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7F26B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:41:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42D5BA4293
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:43 +0000 (UTC)
X-FDA: 85189195686.06.2ED1350
Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	by imf29.hostedemail.com (Postfix) with ESMTP id 50560120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAEnLWfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlMr8ysiw1MQVlli9mPBpZcIDcHuzZcNn75rG1fxJ3Q=;
	b=NnulTb4alipRa0r0ZX5NEP9midnzCmnJcwD72l0jepltyiXioWtwdKIjADwiO65FrTo0nL
	AtrfN223vbz2F25TLn/RWmwymHPeOGvfESOPU/HGiy3v5ZyY5lr6kH4BH2OFbQ7bkjYz/H
	fdqw2G8lz9DYjdXzKgOezHMPaYw6sR0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAEnLWfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.57 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838901;
	b=JxK617lrtUAocXDHaUM6hYczn/hE2TqytEZKrPueEGN/4fvCJpAiM47rbP64gpSU3oM/gu
	U7RjXON4Go7G02RWhmpav35XkB9EtR5lnB/wF4Tft8FdWNe8qOzCTphBCBIb/DYoG7M7jB
	KulCRpuiooT0c+18H3LQbxXMjm3iF4o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lG7+VxQE9zUCiUgD2bZJA+1KtHaOwgs94O/ucBNwUz8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838900; v=1; x=1789443700;
 b=PAEnLWfuOG0+HCa7sS2d8nGMQfXu+5fj5SWvYq7fhSADlz4g+Wj6A0YnulKz3+Zp6uKyr0ez
 qsZZ4QFSJrVxl5btS1pna884qWw0ctfW75u5A4kOv6kKg/7fW5Tb8KGU4lRYmSUvQXwu4uOFFST
 GgOr1T18xfNOp+9ZA83GGogk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c4918b52a91f44bb;
	Tue, 08 Sep 2026 03:41:39 +0000
X-Mizu-Trace-ID: c4918b52a91f44bb
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v4 2/4] mm: workingset: use lruvec_page_state_local() to count lru pages
Date: Tue,  8 Sep 2026 11:41:12 +0800
Message-ID: <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788837625.git.zhuhui@kylinos.cn>
References: <cover.1788837625.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dj54n6mfigoji7cyubkb7csk3ikhzdm3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50560120004
X-Rspam-User: 
X-HE-Tag: 1788838901-716899
X-HE-Meta: U2FsdGVkX1/hN6cZkaVxlVeqTvyGGL15Vb5iv/ezt3ph2SNBs6b4t1pbUOQltR1av0ZZwax0sP6tJnhm8WE1Ym3SJqk1Fz2gY+O+v/nPz57Au6GP0Rfh8wtb6g9LCjqn+zO6lCZS/OeJs/IC6/Ia9sjNEzzdt1+Lwph7V3UloeVHSQku4Luq6UZCehbtEj/ZKploMLIMGXXsYIzLAlKD8yTn+cgRHkU+61UzHj9zey+MzRbYmgrjR166r1iRBdi8DH/1nIFddBtwRCM4LupFPQ8JGwpnuc1Jtrm1BZGZfo5TDtg6AAr8XdWTmsTHU2hLDxYX4g4/zKsjcwKE6DYk6h5Kmv5qs7btT2xXAeZ3M1CSx+t3jcN9r/iFu6LypRH5ecIEyZii8N5CAFKhJx8p43QuDW0RA8vCe1Lk5rg6zxwE0mDyUkk/UxzXMMt5MDHHFkgiCh6usvRULeaWNgQARWcf86D+oBQ65FIeO/REccErc/sLCbjlpFSs+M07NPpvBR7b1QgdOELXQ9AIa/XbM16vl59xbT/ORuKQC0CVDe6xzLCQZgEt3YSDJVyfZinpWTxPYo2bvD5gU/+Y1LM1XvTw2GIld+nhtHHsJgpXl3gHYQAANlpYoOVYj7BB9EKTrkdnxJe2RjZMYoGZVqU/Imr5GwEg47oyI3GT4dtqBsKWf6+kXLlfSBxsDxsqHc96pHwehf3UdEbS3161J4wRzyex/HqXhBJsoaOvA5qSY2u4ycB8m9JYyEPE9tjnieB2OMM9Ls4wUzAsGuhb1It2wieSYePBs+Yxvtyi/aN56s6C7AMQ+1RTNhyOwa9NEVBv7rz5rV8ZQ2JSBkprnIquxEuBd44l29aNrJjtU2v14AEs7imVQM28t1v5ct43urkSlIbMFTBznUuM99tTrUNDmYHSrFHqaR20veTAeT58Egyj/HyHqIRVEDYMpQ8Dl7uP8jzvM8kxGUiJ5fIU/pl
 dBOC/fCM
 DWhwpY4RWxD2eCmSd8nChFPpfDrZiGtYL+wzLuXgo7zC7dSjeL3m1au9H1+T8fdhE0QLNWAq9xEkWNSxMF6w2iAgibMYCGYv2oBNaVxQzhB1hzeVNcWDvnleC9AD81eYKXIAcbZBTPrKjNIKzr6xwZogY5/DRDul3qXnoqXyR4rGua/d6hIlCRb8ko1a1Id/6gBMj9IqCllcg1Qmof2IcrPrtRN3iY5hEggd+nSOrJ/1ztOPpVBakkNBqA71yITH+sioCzj17WJx6CIwIe3YlVOlAWAQBccL3deWVoyth7nQ69AziE1sNA+5ZJHV24fPZKV0KtHBlcmF+t5+GSp2fFj/YvNVFwIpd/zpgXuBcg/UoOzJXsNpi9HK3hBcmnlJQes7s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
which only the classic LRU paths maintain.  MGLRU accounts its pages
through __update_lru_size(), which skips that array, so with MGLRU on the
four evictable LRU lists are always seen as empty.  The shadow node budget
(pages >> 3) then collapses to slab plus unevictable pages, and the
workingset shadow shrinker reclaims eviction tokens almost as fast as they
are created, losing thrashing protection.

lruvec_page_state_local() reads lruvec_stats->state_local instead, which
both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
race this re-exposes on cgroup v2 is closed by the preceding patch that
redirects dying-memcg stat updates for all hierarchies.

Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/workingset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae5..8412f4840ae35 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -688,10 +688,9 @@ static unsigned long count_shadow_nodes(struct shrinker *shrinker,
 
 		mem_cgroup_flush_stats_ratelimited(sc->memcg);
 		lruvec = mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid));
-
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
-			pages += lruvec_lru_size(lruvec, i, MAX_NR_ZONES - 1);
-
+			pages += lruvec_page_state_local(lruvec,
+							 NR_LRU_BASE + i);
 		pages += lruvec_page_state_local(
 			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
 		pages += lruvec_page_state_local(
-- 
2.43.0


