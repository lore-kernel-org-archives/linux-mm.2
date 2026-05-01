Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52677CD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6321F6B0096; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E39C6B0095; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4345B6B0092; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2C56B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E49A2401CD
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:15 +0000 (UTC)
X-FDA: 84720078870.28.E5CDC33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD9071A0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekkdZMD5;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5KStOUgaP6eR9KiahuE5lw4XeX/zy0bzI0UhB80o+8=;
	b=0cmC5XNlMBC9mfSpWazcZNIr/tvIW2KvHYaX6vRBrhuGuWA2XBHAzWfLB00qlxwGhvmTL1
	JuTokPMJuQ804J7tuIWnJw8yjN183dL3Ej+k5E8pIfa7m9g4uWGvz1NanoK6jyNjAnBEiz
	8CTd7dioyVITNtGMRXg+SlCidGOPCMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669454; a=rsa-sha256;
	cv=none;
	b=P6OGzKDgNdorffk2AzVPgpqJZkeEwR5xAOxckc+bb9Y212ZFoIlhfrWtVj1oKiSEopbAaC
	22B/WaacJCN94pq2TnzOOhul1nP2JlD0akCctNdnyl5NnG+hsJo7nRWN9aq3EwJRV8l+M7
	mjr4OOTxTI/XA9gRc+92+mBXFRcxu7g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ekkdZMD5;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76D1444195;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 16744C2BCC4;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=A+uGFSOjp4jpmBRuOIkwLTviq/mFB5GM+JaXwoKxQ8Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ekkdZMD5eQDMQovCA/dQWkHuNNOANDIJNLlFIJqBvmXXezb8NsS2/sN3GmcCTlF6M
	 q6q2xt6NZxVcYVNnAbDXWfCtoJGLa+JVEFHhx4djfcwAqO9fDIIL8Fa8BF5iXQr3q3
	 Sa/ygvFFaaJ2tw2En/+pqzuU0CkpUxCq6Mxbl7wiCgqRp2+1/FMdnKDgkiryEPa9E3
	 aymwL9S3AZS8TTCKnNDQW8YGJHGWMXkdv4NaBvv/9rZAaEqIdZoRjQ36Bs9hrEmIm5
	 Ijmm6cPaQK/6dS34WXVW3FkfJoGrkPBLv3FBIJZsBShHfvluW7f1xgftxBustsDLf4
	 nTmhvOL4byrOw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2EBCD3423;
	Fri,  1 May 2026 21:04:11 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:47 +0800
Subject: [PATCH RFC 01/32] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-1-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=4666;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IkFEgPrNnMULleiYp1UZ+qFJc4vNB+W+MgG/aidkTiM=;
 b=6EU6Ld0m0s7fh+UjdoyV2mk70KaMjPaHaHpHNPNMEwb7zV+0OY9j1iIwRJGitS6PnymWdKxNA
 Fg86q+QfaGpCOJmVc3UGWg+5+l9KKYo0E3RxEGsZjoPuIOrcmx5BO1o
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD9071A0006
X-Rspam-User: 
X-Stat-Signature: 3gy9rtnbeqwh3yequk4zperfzq43kfbk
X-HE-Tag: 1777669453-846096
X-HE-Meta: U2FsdGVkX1/EUL0fE07PbdfaAm/rIbelNtIQKievzqs91ml3a6FDogo1z+hxGNIj15i6BjOAx2LJdTSiUtQRKE3j2cLm3s78BE6G/oep9JPdnnJgI+PWWb9WWF4n+MobYdlRRblc8dMz/XLeGGQvu+LGW0jnY4zbEKtBDyy2Cfc/K2IBFTW8d95huGFrOIiQgySGe6/Dl+i8/4TUi0a485I1jpXRLhhKtqlJrbx1uX00AQHYzksAB+un78rbC0jVMSDEnRpR5t76F8JRBrpQJOfhOthhLjtx80wDanHJM3MWiesoEk4IyzdfrHK4pfSrEzWxGE/+0GpiSzdSs/ZICUeR5icLYRNT6v60dIWYMio2zMpK7Fv8NJjLfH0AVbYbHkwCa2m1wQ71ikbZIssSa0wX1HJCE8CUWrmt8DNg3CCX0oiXZbkJrcfXr4WEx20UuNYtE/zIXujeSPjNNqBJ14cPyesAXOaWNe3apdiR/xUI4BiycppqRaXZq447AgmejrI5qQHrkr8ZGXtqmmTM/BP+nZJYVl0gxrXOBK8QOXCSaTmTAcDny+6gOSR/+zYlX/zueb45MIufsACu2w14tvzNJ+aqTkVA7MZlIfd2KD3rrQeF4FYVc6wXSaA117kMpgLfdRjTASpE8JGAFcBG9paBJ11yfbNeVZUuY1evZ61YCdQ7MEudjjYM87YNOa60u2wPpzUcPzoxF6FdDhb7zmM0Uf+6KgqFIgD10iG/XmGl6bzhKt0v6Zfmo2nladgwCx7yu+XW5olMQFXzyKFfZu+qu8g+f94nif4cAcCqBz7i1tb00nUfeofp75tTLCj2IDgUuJdKw00j0md8UatbL5ugUEmCGZIqVASjdy8naIZqL/vnNfgMhZD0FlbIZntGoAIAakAObzosn0z8ePPR20r3+PZT619KwTLRGa8qnnDBqlL8mb8UTzzTNDQEAlWiO62BVEb35T5GkFmkmHE
 KHmiH33m
 LPMUl6naaaRXIxqR7QfULBvNSDYvjL9joXhs808gVbnV3gwtJLQIjUVC0M9icUnTpLyytx8HDmait/TjY2IpltCqj/e6xA9dEezsFky8m+IhqMOaKqYVx5uJqFcJnaR4ShPBREuRAfCrKc6kX5xO+/Wvi1nhA3FJHoq9xZtT99dGNj2JvMT6MEh+KxpxzVBww5FnWjbUZiEdrSU9Q0DW7ITEnIWvatphIWKoxte2mDAOZYocqQhuqVxDQ7NBHf1Troou09F6Y+JXuBD4JvdgdxdTPpsZKK8nF2o8unxAEak8i4Rp8nYNJy+Xl3RyiUKOUAq7NlScO69cCq+6PKFydJclkSf8Ljug1cSKd2RTW3Yi0gLQmN2DTj7+/bv/qGAUBu9UyQyzdHk+7GsT9+4a2RIvz99tmw+Rngd4t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which is
more like a workaround for another bug: lru_zone_size is unsigned, so
underflow will wrap it around and return an enormously large number,
then the memcg shrinker will loop almost forever as the calculated
number of folios to shrink is huge. That commit also checks if a zero
value matches the empty LRU list, so we have to hold the LRU lock, and
do the counter adding differently depending on whether the nr_pages is
negative.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging for
lowmem requests when memcg is enabled") already removed the LRU
emptiness check, doing the adding differently is meaningless now. And if
we just turn it into an atomic long, underflow isn't a big issue either,
and can be checked at the reader side. The reader size is much less
frequently called than the updater.

So let's turn the counter into an atomic long and check at the
reader side instead, which has a smaller overhead. Use atomic to avoid
potential locking issue. The underflow correction is removed, which
should be fine as if there is a mass leaking of the LRU size counter,
something else may also have gone very wrong, and one should fix that
leaking site instead. Besides, doing the sanity check in updater is
unlikely to catch the leaking site, e.g. a folio was removed minutes ago
without updating the counter, while there are still other folios on the
LRU, the WARN won't be triggered until other folios are removed from a
likely correct callsite.

For now still keep the LRU lock context, in theory that can be removed
too since the update is atomic, if we can tolerate a temporary
inaccurate reading, but currently there is no benefit doing so yet.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 mm/vmscan.c                |  5 -----
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..345a6ba8a3a7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -112,7 +112,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -884,10 +884,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..71fad2239973 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1484,28 +1484,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)
 {
 	struct mem_cgroup_per_node *mz;
-	unsigned long *lru_size;
-	long size;
 
 	if (mem_cgroup_disabled())
 		return;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	lru_size = &mz->lru_zone_size[zid][lru];
-
-	if (nr_pages < 0)
-		*lru_size += nr_pages;
-
-	size = *lru_size;
-	if (WARN_ONCE(size < 0,
-		"%s(%p, %d, %ld): lru_size %ld\n",
-		__func__, lruvec, lru, nr_pages, size)) {
-		VM_BUG_ON(1);
-		*lru_size = 0;
-	}
-
-	if (nr_pages > 0)
-		*lru_size += nr_pages;
+	atomic_long_add(nr_pages, &mz->lru_zone_size[zid][lru]);
 }
 
 /**
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8df21364ef71..53b43e3f5795 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1641,10 +1641,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	return nr_reclaimed;
 }
 
-/*
- * Update LRU sizes after isolating pages. The LRU size updates must
- * be complete before mem_cgroup_update_lru_size due to a sanity check.
- */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			enum lru_list lru, unsigned long *nr_zone_taken)
 {
@@ -1656,7 +1652,6 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 
 		update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
 	}
-
 }
 
 /*

-- 
2.54.0



