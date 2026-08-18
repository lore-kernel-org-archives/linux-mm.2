Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84962C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 05:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264F66B0146; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1CD6B0147; Tue, 18 Aug 2026 01:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FDF6B014B; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C20566B0147
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:38:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D112A3751
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:27 +0000 (UTC)
X-FDA: 85113285054.03.FFBE92C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 782BE80007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:38:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxaW6lZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787031505;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juWPkc5m22wYkE1lGGoo3Hccxa+wk+R2kwWIVCV7tqA=;
	b=A0GBW4u8FgkJCG6GKlv8S4qRx6GIV9YwNzdv93wbtXNvCPuR+Yf7X4NU6Qx60w43kUsWb2
	MLyr1cGiLsjBOHYxkWZ8/hwe3+RA21BT/e1lxUupRhKg/U9tsoElzGpAc9ydtlIg2mkGA3
	ktz5k8bBpKli728bFMEKqUrgj4rjQu0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YxaW6lZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787031505;
	b=x5OQgRaVvtwoJyedT6QSYUoXFY0h9MERG17KCr09pMtWA6+hnLGQAW+e/+AP1Y9yH1awEX
	EI0hcsMsIDrL/bk/HieV+ZKm+b8YtaxqtEPWFqSSF3Nsxsd6B8gZoU6jypimCNHFND4bye
	7xBZElZiOVDNz05nk+QIJ6Q91Liwr0I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D867600C8;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DAF8C2BCF7;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=2gRxy25hnembdVhYLwRZncDSQOFGYsoukSzLF39j9ZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YxaW6lZinIMHZU5k8okndOkUM+44MLlwH4XKPA/n2SQtOh00509sra1motCX6yPLb
	 v303PCaLott/IN8Y9Mxvoif0JOAC3NzgFkyFlFiMYPHTDFik/VKnjovSp6Mu9/AwzS
	 SbIjaGWqpfmi6BZUIQQeBWtDMLHY+gQ0v21BBucNC/MhvtdCsBiPDtuO/c0BAe+28O
	 syxICUizu05TX5YVNN3ynL03nKj3L/4Wwf5gzOuAYe0TOpe2Yx/eauSamHItpoiTZ/
	 ZdO5IasUTVc+eVfxWULRZUux8AjPrTMmv3JTxz+qUtCoDDHhOOFXJctygz/ei1BtG0
	 HK+Q81jqOTysQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD9EC5DF67;
	Tue, 18 Aug 2026 05:38:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 18 Aug 2026 13:38:03 +0800
Subject: [PATCH 1/7] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-mglru-flags-cleanup-v1-1-8dbbdac0d28c@tencent.com>
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
In-Reply-To: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=3566;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=/T+OKeuJl3olH2b22zrXZqywkoz/djv44CIgkgQ7VaQ=;
 b=i+2Ei8YdqwDPFssEabm+WHT0ilQlC8IDHXtxYrZA1/QkexYde2gP0a8PvqjROPnzKpImG2i9Y
 ylZAtICzyIeApv5ta641aTQM6nqveZq6AQ9GZ+1AADs+c31OLcPr2CK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 782BE80007
X-Stat-Signature: 3bxdgsy9f637gxhbrurdxoznzz6kmt1k
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787031505-212391
X-HE-Meta: U2FsdGVkX197KpuOklDvOuHfFZzS3MbyD/f/dCHk1a+H+yGTmU56pAnyruIv0y3OSz9f/smeluHq6j7NqpM3nzFiUbP7Qwj2IHF/kFavqHrYtSzIkb0BMi3PpzDb8BkcPxUB4qFUC2HB/e5o1FCn0p2HcgjPsAL+QhQRAjkAgzR9+NnPYTYlCDFqbc+J5vyu+2fkfUQKS3bt+lAU/UKuY4r6eFJQg3nOs+wS86vpCnpXBFzgrF7v4QQV/HDo18LDG8ws1xkVmK5qLztSgjh6FzMnx6ssIw7b3dXPGwBNVjtFGZphoVfTi7T5hFYp+R2LGKXEyYikNbmewGFDSQL9XzSHB2wV0BLy0kHJvYDGZwWy0ViaVQbeRII7gXFX0SZHVhk3GwY1WUPLT1QTeWXuXzwnpatbua4ZXjBk9Q1bQUKPof8lG2Z6KLHDXs+MlQyc/r6I9aZw+oMf0t/3G4oa+xH7ZqTIQatH2Zupu7s9jj9lHMxBHc4lN3PHskQ/VNy1A6iE5JdGqiKdgNfbg5U/1OxmIehP+VFchQzdyYtBBC3MiCax4P6tggGjdJUugpv9sa9b8Mw2OZJ0eetM2yatMbuMYYPE50B9Fo/gjT4l1ijFzISa0V+F70Jt6i9aGZhemfPaEWqEeVhbhzi8kMtYZy4LaZujVG5OZrLfcCok/V7SgnkwtRpmYpQ8oP/U+9ZT8G/Y807EORpWk59EJQzBmys0a4XI+dF4Len6q+m0dOLYxPNgoRtK9gOtw9Pq0AEGxOc0G0rYdmHF6DqHP4S3fIatUiDA1O8tBSybGw3uJ8GgrXZTF8cr/BXpk/ca0hB2p9jJ8dLTF1pk4nfRYQTqKQjgH43Z6ABIKRrfF0KiqrNqTFXVthQk/wBftXSS6Uzrhj13tmfQzcibIjNikqP837B1+mq5GtJ3OTNFdeLnHFHWu3wPhNpR4Qfg7x+J45j9M5EM0jfoSRyxNMGiaEV
 SoezQ+hJ
 qRqYrhxbkVuDhodsGg/pcQducqIDobsGxANUMVtKVl1PecKKKiHkcc7zPyS+1BjEo7hkaaTpLF5kQl0rQsOI0nVxHkRIXhmeVkyKdN5MZIZpPrZnQ/GFSqC5Q8JS7AtJCmvy0AQRtC4/zHz7gxHuR9FHY+j2CXu11HJO/G8N4E1KKBXmWGrMHtNzl8Yptawx5Qy7t7ZJ0H4+jYJs8q1i+8NBanXaI31SYiaic3D03AHgLJkJ5EdnGs8dk1mu7fkCttGVW4sX2ukbnezctMEEJgHwwJBya2dzRa4VJ8wzFDBuMGS44TM2lGzVh/Q7+yZnvBY1wBM5Bc64MDQtQqJD3o4cskzfoE+jMnT/nTwWeN4YWZN8v31DaTG3WT2CfcuigjokWlOGZL/g0dpR05v8+giTgCBRKU9Wgmc5SfWPO9tnMkFTEIevOj0T9EjmUPp07mzzWvIRGQxq7nlI=
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

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

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
index 1d3339520809..9d0ee3d3bda7 100644
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



