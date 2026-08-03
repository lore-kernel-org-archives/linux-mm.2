Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2BB2C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CA16B0092; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4826B0095; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC916B0093; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00FF26B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A7BA1C13A6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:25 +0000 (UTC)
X-FDA: 85060992450.17.4CC4137
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92E37C0002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="udvo/HNH";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786443;
	b=hXwTR5jjXDsk+lMygPZBov166xkrJlpbsgS7wPX02HaPkQyS8W9X6OxtSxocd0Ui5MhLuw
	QG7twHR4ciADrJ/082vG2phrIMK+i5WCMO95npMwlf/qEPgB6JJsr7qF+ME5j6FtqVJK0c
	nic/SSE4DF9lhi9DLNZ02QN7ltcUXj4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="udvo/HNH";
	spf=pass (imf22.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786443;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=on8RTQwKjqpRcHdxApUoOz0uKuGSuZLKMuT3VYoRsYc=;
	b=yzYnlrbmj8MYmGe5R7ES6rGXISaasU8Jf9zKeU3SM1mIkRFeIKLvAVCM5suRrOwOAG1dSb
	u0lxIcav1HBai6uJKcCOsDCQhmo0/+7qkZgAp7OVkgP8AVIXYebza/utxtPKvUx2ByCjF+
	AqTBCAWZuPNaciNkQ5qFHCtOnYKIT3I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C41BC60AAE;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D230C2BCB9;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=NO0EAYWsY2ldlhO3iQN1yFZTxIcpW5QnD5tDVs0IMKg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=udvo/HNHAcQodDJe4VeBYpgCYG+6cyZ5dGXMZLKK+zBmGUlId2GrM2uqxC+mbR9r1
	 AwH4n2l0kIGVLI20cOsgLkpCTcDG2z95fCSZ590MWFVy1CzySezuJUfqRAdajLDeEu
	 NLxbxiU4FrYvG7+oJpExh6UMxBJ71f/yrX0D+iy8G4BtTzcS6FodOdS7EpvXhDfFXU
	 QW6a3qa2hMO4pVpti9hfkuEdXTnaohOuFXf3y8IWI6Z/iZ+ZDk3GcLg2HB2WORhanZ
	 5GLUQNFbE14/9PoYuAKrFgq96MleabxwAzqCB4cnYHooFWsdqM+SGFWqhomOaJlIJl
	 y39iVeyyRnbRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5DDC55182;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:46:57 +0800
Subject: [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-1-4d8dad39dad6@tencent.com>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=4666;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=VmGMj3oQ5WlKjZNi9BvygZeEmYIa6a/WBZg5ksVdh2w=;
 b=a0JTNWuPi48o3Fm1tmk0HF76NfE1tnogbipupV7MsafExoMnGyTXKGtgtIoml53Gk31D5uRJs
 EGfJ/FlOQdeCuvTUuafmuiYvO38wQEj4NOhVPlp6aOqx5ZKeCI4/sef
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92E37C0002
X-Stat-Signature: jinj3hdwr1q9xy747xz5w3w5go8a5it1
X-Rspam-User: 
X-HE-Tag: 1785786443-828752
X-HE-Meta: U2FsdGVkX1+XjXxfG0QgsYU/2IUJ+OMSUZsk2cDZ0Cyavzw9EMsPuWrjtvOctpesEWNA0WgU7UlXIqnXZGjdfq0PRzoyLAnlBK+snbDEOYNVsSncQ9wIInJ9tNuD8MahjuNo/qkZtRhbKOmMOq0quXFnKtf7USrJVfTmB7+DfmUdde341AVy7/mQUiZKGmPD84TvulqLYC3jIoSYF3UF9HNE5UhzITYd+30h0aaMjHDzw9NbnCDfJXDAgKb/t8b3amwZwC7v3PJzo7x36f5wmVNhE6ZPgX9CplIw+OeihF+EozM2OS/iqFpU7/zusELZfKKNdXJ0CPtWSFdZh6q/Nt74badm4cDjWu/oYUWlTLzKkn1z1lAZH1G1Z941aifz+4TCvLnSrsGtVuobNRsErCYf+3nVOV81L1uz+XdOpQQ7hvYmFnJHC/PZipg+oeu2xDSjomks35nNpkgypHjqyAEOct4p/DB3hnVyQDdwsk4QANIFAP6lORjq6sm9fSNVf4x8knW9/UFc0MMeRW+HtZI0frqPJyy6qXRmLCVYkfKrPGO2POQ942vHUg+I5FlYWgLdBmUOTVWBfaUlM5j+tFGWiMmxcSpPigznsM4SZ2c2J3WZHhpzL5dY3vYKQjKi/5myuwIknSGnTxI2Z69yMjVDSDmbF0sSABMXTfiUBRGIbobA+RG4z1vXuqStuGwiFK5p3vhYblAb48BzGrZWlxP09PDtxvo1TQixzkMHoLCLeRIteCXJ38gak3PK4Gbs6gJE0drYR95OjdZZvD9c1s2YXRHXIRdx/udpDiJI6yWjaTnRgSEe9l7AvyMTNHGBiIZt4u8anpUYoJxNdnOPHk944ycdSpOasQfVMfK6tJ3hI8sZ86R6/CAOQWz3ezELfKjyWhQCA64AB1lQEXGZc7aX2xrN4lwSNNRBQ+tpyvPnlhnnKIvIR4Dz2Ixg0mweTu9wp7yXRa7QBFvEpUl
 5VLh81zj
 HMtP8aHwiPViaJsuFvtt5me3QspUZs+0U+uR9w4379dXkIVdwvAS6SI3gEBYZGrtk+RZya2PkRXmEt0BF3euJphcA4xHjInaHkItQP3U2EJqBQ1tXx6tBlGXEkj9ZuNUkZBBDCdEFpdByGFirB84giNC6FvlsCky1Ctq3qSBLzAgUAHTyHbhY9ECeWN2AHrVIbp9HK4hkU84x5gLAqsMXbKYEB+d5H2MjOcrJ6N0HyBtY+EUdzz7Q1ZoqC0opulousbVF8Zc+ljYT1K/WMqsjNpcfF2AUffuceYfvqgHcFPQsVbkjBny+KLPCI/YSiOhodh0GFKKBYoahAy/4gh0aKIt0iKhTxukmpWjPq7LWS7QkkzFOOySDTtW+Ski8r+b2wHOCUvHIYaSbiJ/4R0GcVmDtuHagS4JIMwKwyH8XqzUgAN0/6A8m+Hrb94j7UbYEjbqtO8+nk/+mCI8=
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
index e78bc98ab229..b13e3f056319 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	atomic_long_t		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -897,10 +897,15 @@ static inline
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
index 1bde9d5af88a..7511773b3491 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1529,28 +1529,12 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
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
index 17d2b793cbfc..fe7cf5d42e0c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1636,10 +1636,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	return nr_reclaimed;
 }
 
-/*
- * Update LRU sizes after isolating pages. The LRU size updates must
- * be complete before mem_cgroup_update_lru_size due to a sanity check.
- */
 static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 			enum lru_list lru, unsigned long *nr_zone_taken)
 {
@@ -1651,7 +1647,6 @@ static __always_inline void update_lru_sizes(struct lruvec *lruvec,
 
 		update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
 	}
-
 }
 
 /*

-- 
2.55.0



