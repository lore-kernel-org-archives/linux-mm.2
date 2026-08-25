Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9235CC61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 17:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884566B008C; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8039B6B0092; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740236B0096; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 460F06B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:53:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BEF5A40178
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:41 +0000 (UTC)
X-FDA: 85140539442.13.A6906DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C727A80009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:53:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqXPH2B1;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787680419;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vUDbLl6GFq3AXFVmUsZ621ipDHQmBt1g1Mu6F1/B6b0=;
	b=QcWrSDs+07cuwyTLSSQ/fPevVPHXru1QCZ+8W1gXUT1DHGzTRioaMf+eGVgVAOnmhDHGp/
	5FWkMM+32CtK755nJt2h6JnCQvpicD1ZIwVJqwFmDO/YgJLSqafYOFIZjXxlUN+lvbmirO
	HS8FDczZnCAtOWZAXgK3cctwXmATL1k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787680419;
	b=EuFo80kgkbFeO+Ohf06YXMDJGZERcjAVwD3XfKLapNOQBjppmlQvfkgCMkEdERtgAqg+hs
	WMhJADIENSoa0B4ZWe+o6M+MmSv2DlpylDf4olGC6Uf0ibbo1BtZsaFkHAJffv+HkLb29C
	0PfQO5W1U8+9Y2FZUjMZfWicSJQKn3w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cqXPH2B1;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C746D40BAC;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F2EFC2BD01;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787680418;
	bh=bN2F8gmSHKc1/jt75s0wLe0MmFp59ane/uTTthFFmOQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cqXPH2B1Tbo/UZTXG/bWFiARh5SXiSK4jLyeI0/DdXT8PwH3GKj7/b4JwnKKdX8sp
	 aO+sAtdbaYZCqvzQJ51s4oB0SXMlxBmfy1S6ksG1tqfsG6C5wKKgT+rsdsWlD9vK3F
	 iaygB0llnnitavfUvEqrop74d4R77o+Aek1kY5j0klg0n0CazTt9L/DLrosMmJ7Jr1
	 jdCCZ68pv0muCDZuFAtb4UN3h1rFBKZefOtnG3l25h4y2XKZhbdAtcgc/lqAfVWZFD
	 6uoQQjgZnCRCB5EaEFmcZsjj0Bjb+1bwdM6Wj8jg9CvbSeGFu/tm8G2G4D9Qy87Z1V
	 qpP2MBqtgxJjA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C8AAC61DBE;
	Tue, 25 Aug 2026 17:53:38 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 26 Aug 2026 01:53:34 +0800
Subject: [PATCH v3 1/6] mm/memcontrol: make lru_zone_size atomic and
 simplify sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-mglru-flags-cleanup-v3-1-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787680416; l=3616;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RexeF1U3Yfl0k0lRFmBeywxr/pHJWWKLBeFtqNt3agc=;
 b=gUaOq2rQo4oBgo97U6jJXYV7TvwIKRgBbtQe/5t2G5bpOqWGlmVO9SnvffZqvtfOw2HtbQXgU
 4WxdrostOy+B4D4CjNL0X9ma96UZAcGpuHRGpMFKs8UJs+7EUVg6pVR
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 915ki6bcct8ueqq9cxq3kwts77as8ctz
X-Rspamd-Queue-Id: C727A80009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787680419-815005
X-HE-Meta: U2FsdGVkX1/o62Zi0eBs2GH1GRzEPeYuV/RCp59D0ElKie9xG9nS5zASzhe7C9jAfxxduJfxy7zfpjCmnepXI4dQNdaR5vihRSKUNdDoZc4Rvm8CWf5lUpZi0EJik7XkFUm+4BZhjdwZzCm1866+ROWh3dNcPVdhflliV5NcVOxruiZobiQc3vSaVMFIJ0gUZtqI3+lG8MM/erO26ITTY5vFZR2q2UpJbbFhulwyH4E5dbn3cxgzSMLfaY2wTN3O9aHqtTuMbu6M6HrdK85NfS1Zk6WnvJksXbFJZXPf51y44T/eiYWxxaXnT3LdWzXhYp+rRWz0GX45YurUgAd2hs//Jj6j5hHn6QwELLHBhsE1scnU6BVZkgoVlKHyw3rGrt1GIUf4gKcar42kIZI2jVylQGTiZJhjCoEpVPXOLa8EYuXiYOHnj6qd3bbf5rebI8Vnw+sGHODnpPACw38NFgQlPYi6LTSiSnvkNLJS8TntEZRAf81Ar0D6BAMbPZDjCwUeEhIxzVuGXVP89xrLW8dnaDKf3wXGiUdiSw0B3+x6+suWfMYQBw8z5bQW43JqjZ7wrEx8RcHzjTLhTyGMydGFGv6H0C3V5NEjVnuFiCN5pJ+nhfEXRMUExQSqidMuBoRMYQv3Gcm0e0JD9Uj5DwIVFupHhjU5F7UO8XpZenlR5R80KcueXgVDSpQrK15e3DeAkN5NO9RFOPJ6m0XdRxc3IbtaRSVG9pPRTNGqw09ZZOwOdHb3MY3WkcI0gXMMV90MQmjoT5iLyrJ7z4wzdIqCOC01V+BO/FciDacRIbaDFaUrB0icfcpc1e62Gg2opATtvWCN6Ya4KH6vZIPCq9ljoQL8i7VrUXd7jdyDf12uIwWZtor17KaLAqF3HE8OdRCXlzEsc5iHslHeHisEUtOOlvWVMSUjqZCA6oM2qOh7AdldW0lZzdGRhUOUVw0JCs4XHSajfp3PwyUrPz5
 Kpt0DpPF
 MoCJCE7rgWkwEhjKQI7g7UwaMaOzz5xI4HYJYTd4J7zJ6Ut2XKpkgN6UX1B70FiAlN6Pett64Plw2fAFRDTsoeLBAIVRb00oKChdSRbi8I40c3E59a+j4fAjlrNykK5RY/f4QBTBKD613KSVqXmnwTtXjbVZQgXBhnK8fXkwAqiCINcznIMZzEyYVrBDrI0QDC9WWpdksR2xwHEH2DxY3lcje0KJqfckSNeAPbhkc0wAKLYHDGa0talXFgpVyES0SA6kKIBk/NIR5s5iyiKH+xhHHijO3Z2RGdjFlDaL65ddbZNIbcr0/PbzzIoArXEZXUo7D4ovnetb3C6QkJU/cRIJyZuumy8ZEQizKK0ueqHQmU1yJIWIZleO+qBwM0MDP+EmkCv08EXkUJTijoQgC4l3DP3xh0upjHOzJ+oIrRx0LNfd4b1VCNX8sk4tJkIUeLt2MyjNdECB0MyU=
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



