Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E13C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87EA66B009B; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8273D6B00A1; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9276B00A2; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE406B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D73C61A0194
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:34 +0000 (UTC)
X-FDA: 85136539908.27.C5E7CA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D93DAA0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNHeNCf9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585193;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUDbLl6GFq3AXFVmUsZ621ipDHQmBt1g1Mu6F1/B6b0=;
	b=xEbcC3Yho8ATcaNG7AVt0m9mheX4L0456V0M3OPwoEsDLX9/ppG14iAiI2aWtBXfBKtt7Y
	YbGKkY+BQAY3qTlc8KI+eo+NWRABNn9tisqG/qUlQ7HUWHZ3PcHAp7TpGrjnr5wxh58Gjv
	NiGklKQhugGDt7gXd3jG24lrg2l8rro=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZNHeNCf9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585193;
	b=gU3htmjZnWroL3VKEzSbGy7MwwYVDRSb2KZVPVqeUkRtMgMSzBP4CSwESadcpIw9pmJZic
	xgQW3BSd5va38S4Xakcn+lJYyPjlMW6A41ZyIwTuwZk1d1wrZ1DTOvHmIvFFNhQY2ClHlk
	2vqEFu/6Q+UH6CS1JXXoyuAwfrF++nM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BBA443BD5;
	Mon, 24 Aug 2026 15:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D36A4C19425;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787585191;
	bh=bN2F8gmSHKc1/jt75s0wLe0MmFp59ane/uTTthFFmOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZNHeNCf9t7zLgIVI7HBfTfunv7f59iFTKQczIwTWr0zUM5Uij6nDVv8g8FZbHI52I
	 X56PQNRAEgFeTT1t5csi3wRpmkxhvxRT0rziugCWbeZX2bvpy8zury5iAQF11cK37O
	 sCWbnVVdXvhxrCtESr9CT99nSjxyrkf/PR3kKg4T0A6ZlTb0J6BqK9PKF16evvBGp6
	 p6Hrfr94J0Vo+z8PlnQ29wC7T7fKGlc9Jad0/PUJSNBzkAobmkfsAPfmNW0Bu9NTd4
	 iYPBOcYZmj7O9fxu0k/X1BkAujPKgGC/NOXJtsMfTNET5xUNwxowOIAtdA/ldIgnnT
	 3meD7YAwdZrYA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CBBC5DF9C;
	Mon, 24 Aug 2026 15:26:31 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 24 Aug 2026 23:26:28 +0800
Subject: [PATCH v2 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-mglru-flags-cleanup-v2-1-0104132114ae@tencent.com>
References: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
In-Reply-To: <20260824-mglru-flags-cleanup-v2-0-0104132114ae@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kairui Song <ryncsn@gmail.com>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787585189; l=3616;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RexeF1U3Yfl0k0lRFmBeywxr/pHJWWKLBeFtqNt3agc=;
 b=BZLmo0P2XGHFX1zI7sUUmKSe4H3Wpg70rneiSn6rerCZeGSMyCua0Uo+7VKEzGhYmGwVtnAdv
 7TwR1hIlpuTAf9aQp09WtZ/jGtYwqgpmaPHmB5ZMWy4z5yZucbnyrIx
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: jhqof6ubr63j96874fo6795d516e9as9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D93DAA0004
X-HE-Tag: 1787585192-552447
X-HE-Meta: U2FsdGVkX1+IdERScfBPFlR1MrLtRI9cz+LHlP6RcFHdYeaIAbR0YjUrpRGc9/KyYNQnNFjiqgzjOJa9IpEt9pgks18C2xqOu8/8SdY7MaQVQnAl/qrBewNFk9cHXgVpyHfjNgdwxbVQF+XJj1Wm1iqc3WsVaSKZmxqO1mj5stbo+JGI+EjX/7b+BAzjXBgoZSVCT4fwSSdl3axNGMksu0FrDkp3hZg1AdjqhaCaEXoTXkJWfTfo56+bQXKvjEOs6My/6pcJwmqNJp0fQUHzRfTE34/p2iBfNWMX96lgb4/Q0GNWbTBy7PZuSK5zmUE2C47Er1DizKJSvc3yrCkUtSCcIbnulD45os88bRVcuDZPVIdEniX0tpw2JTKaBe0BlwpRgYe97oxmiEf4wmdUIPk5EFPr/SdkX6oIgms8lEog70JSxRv6beb4FDgsCaHAvBuYCMQZ9RpntsAHyelUVeFnu2QlshTOFaJXr69E3jSvlXV4KcJWleMz2gTs5FI0MK4L589O33+dcHMfV6gVJANUIsduVB/d+1r3HwEWVMzWjrS4bXfJrsjkPn2549a2n9XxHFuAILxwCsQsM5OpuyZBApKxV0pJU796UuSR1gV90LluZCsEahd7Vi0n47rMpiUXkVOaouNcIelVJq29/5PVFft2nyHWLKxX0sw9lCthTWZL6mOd+H2kPYGwLSvGG1Xa0wn0tL6QQ+zHP9pt8Qaamu8mgdceQXBvA/HX5968+GdIwsbvPOTdzPQa5jPKKe3KWazYOVLxFpbZObsw5oSKK9Xp0cAZj+C+OM/mJ9Vh6p1QrFID6NXZ8U9KYxq56XWirtuh33Ebc6Xsg4gtpdnemw6zxBtzJEfG+URy47u5w76600lUMWvaTL216bWLpB6wkHn+9U7G/EzGeBeuIsC8D/6XYCWRYqWdcUpQsi2MEdeWj9CPSCAnR+MFMMojnYf2tU59JTG+yGwubtv
 Dfuq73NF
 gHkr/vDjo39HxlXbP5vnzb5XPwShyp3+mgRwoUgJlydGABIvE1MzVGkMRIbecx4L5vhl/HPw1HfovOb8l9aH0IZUz0JCT0t3iMe6AJhWcFmcnNc3sUZ9cQnfgZwKKzcvLiitpIqfqs5NT7gq+rztspfyUvr3kjmEhgGJN/zD0v0VWheB8gHJZasUTAIDe5w1YC0Tsi3FTkiyEPsQN/o61jTMnZvJHNgQTzWUSeAvhDOrJySKnGgeMYznmlNz+yG18WTMC4foWy1QmEb6zTpcS4hEB0ys3EkjUltO0S2UkSbVMRFp5Tl/TQW6hjJ9/B9KttnJku9CsmP9aVC+WVLlJDd97/XZt56oUgYNd9b767slgWyE9RGpv2NUZvbhtiFD/Z1M6qJwaQucel7zcXDkkqxdFvggR88oHeCXau+2qYko3/LHj40Zu0dsx2sdxKFbrUzmp/A6AGAOSxdY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
introduced a sanity check to catch memcg counter underflow, which was
more of a workaround for another bug: lru_zone_size is unsigned, so
underflow wraps it around and returns an enormously large number, then
the memcg shrinker loops almost forever as the calculated number of
folios to shrink is huge. That commit also checked if a zero value
matches the empty LRU list, so we have to hold the LRU lock, and
handle the positive and negative deltas separately.

But later commit b4536f0c829c ("mm, memcg: fix the active list aging
for lowmem requests when memcg is enabled") already removed the LRU
emptiness check, so handling the deltas separately is no longer
needed. And if we just turn it into an atomic long, underflow isn't a
big issue either, and can be checked at the reader side, which is
called much less frequently than the updater.

So let's turn the counter into an atomic long and check at the reader
side instead, which has a smaller overhead. The underflow correction
is removed: a massive leak of the LRU size counter would indicate
that something else has gone very wrong, and one should fix that
leaking site instead. Besides, the updater-side sanity check is
unlikely to catch the leaking site anyway: if a folio was removed
without updating the counter while other folios remain on the LRU,
the WARN only triggers much later, from a likely innocent callsite.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 215e2e87f42b..7b89d0cb5f6c 100644
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
@@ -902,10 +902,15 @@ static inline
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
index 11b85f4b6828..a7572ded56c9 100644
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

-- 
2.55.0



