Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A86C624D6
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 16:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701A36B0095; Sat,  5 Sep 2026 12:51:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A9C6B0096; Sat,  5 Sep 2026 12:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8B76B0098; Sat,  5 Sep 2026 12:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3370F6B0095
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 12:51:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 666581A0394
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:17 +0000 (UTC)
X-FDA: 85180298994.22.62BD5BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6182B1C0009
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:51:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVS7HyXt;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788627075;
	b=XdorS3CAgQOaVO6hStSjGb7l47AOGf7Qhw8YRWuc0K7MwFrajAubBjBgZqCEESfqkgATuJ
	kneM6kRsfsOYlvgvGFM1OobcK+IWv9uI2J9ys51sxtXpB4skZ6H4c66+OObzKm04QgIoIf
	LXsXgbHmkw0yqQAB1DSyBPLL6glcDqA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rVS7HyXt;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788627075;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOYmTbybTCmUcx74emnHDrSn0dG1Yr40Q44pk0Ez/qA=;
	b=k6x5LwnqRrm7MevP0K9pAfOgHOxyhqL9f/x4yBpaHqW0ciDeQ/4E18/ucGvVghWVDhXgV7
	q7sPsy+sK5A5jsmdXn6zxtZR1PQw1bSak7rxSs3bGOyJDUxZOMxNr8did6/uG2pIG5YaCZ
	rO3f3CkOAcKaBYA9fA92c1UXqAglDEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E12A4451D;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3FF9FC2BCB3;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788627074;
	bh=KMrSNubmkF/JaZ/wfERNyBhwr4/ZnB6C7ORAuEMkmAc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rVS7HyXt1p0UVk9pDTqV9NWGdFgiQAcCJTzjW2UCLVa+4FjpvdOg1tNfpg4nH6hIz
	 LBSoZOdbs65ToG0MDUOlnaJDJPgs8eR4jALrXmfl74ZhvtgraWKHwNOtOPgAbQ273a
	 ZKbWoS39t9V6SntOuaUaoP/Zk1DAw4dqx2WswT0+p3foz78MTuqJojh3oesh/CB62B
	 D+mdQ0QBW6iJdj06Socd4ZCjSSzD8ZxBAitz7FEvKWJ13Wu0X+M6bfvBruwSqGWbKP
	 yIHX5ItxdcwkCpyiSgDe5mdtmYJ/B/3TazD7F9eTKZt3slcHn/eG6Div+Ax9oF7mnd
	 fj4EKWwktheFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21B2FC624D6;
	Sat,  5 Sep 2026 16:51:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 06 Sep 2026 00:51:06 +0800
Subject: [PATCH v6 1/6] mm/memcontrol: move the lru_zone_size sanity check
 to the reader side
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-mglru-flags-cleanup-v6-1-9aacbd77d4ca@tencent.com>
References: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
In-Reply-To: <20260906-mglru-flags-cleanup-v6-0-9aacbd77d4ca@tencent.com>
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
 Ridong Chen <ridong.chen@linux.dev>, Lian Wang <lianux.mm@gmail.com>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788627071; l=4187;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EYrildgCvRSUGmNpRTMK06MGOLnwFTMd8i9BSJaT+KI=;
 b=7eFXJ886R15Rfl+KuEe3nxOaw1Rvkl4X6+AtgtO7SeNqrxdqKSqrjlTADLAiWOzmcoPyx7B6B
 Yp8QVqqxogVDzhlrb7hO5Xd8UWxVNNE0sJ3EOHuAjP7na6umHZNCPkl
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: px7ekfe11zhj6x5o8pxh4c7atf7d97gs
X-Rspamd-Queue-Id: 6182B1C0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788627075-271914
X-HE-Meta: U2FsdGVkX18gpsiS6F9zSyWJv19BnQhy8DkvPYqR+NQ9+JqvWkcibvV0aFxg751btsR6upgVIRE4ixAdRX/gYmbGdmG3i0CynX6Lpd6A4gyq6JEp9XBvBynguXsnRBJKfwK3HizhA1RT6lTpL77Bt1U9z+AorjKYQT+NXcyztE0RAkNPecOdhZLoux4wcCXCViYFm7F6lpT3w7fPJXbZ3zIQhyX/HBn6iGAU+B9brF4c4kzcGWpVCpJzC+hXqPGmXZCWY7Z2EgAiZ1OSeveoC54HzBWGnB5tiqpaawKXHRxVIZCKZDNoPTBh72zvh/ZmwbvEE+7C4q4dKAPN4kVXSU0RTHbgKDb3xNpYleAYc0MOnf4YKQmZQsN1WCaAnRl8GdPa2RT1eg3Cvb8g4XC54NsCVaE9x/k72m55Han7Nqeap1CM5mDPbkEvWCryfBZJdZRvOAtzejNM4HTKnFoARL26mxrXQ7O1sI4xfNfmK++6LS1Y9eUJVe+J4d8k62PHYnpd/7g57kpaHduDpRkv8OItdoX7mxeNDUVggDaop5lgMGf3WYO9ZXQUmsh0Ys74TFxdX0x+Uj0FR/b3NGu4Rn4YOfAS4L3p5pZGu+cNVeCnPdyeRkd2OExjFiDPDprhHtJHVeGBQN5fJpbfWt5AN/dVLyRmw/52Ut6DyyoOrsb+XgiTT1LpFUgtDMwoyRyogq/YHx48qsZG+Tgw7hPxL/A9o6HfReUN8Apq/ULZTuP39kUpJZG9Xh5EMBIEBu6tz5QN0MnHUmQpewv4gPxgAEObss5G0Tmsi/zN2posiUISgszAfu0Grfw+4IeIhev4Wdze5QVTfpN7ITaVIpZwydRuiVYzQgM9F2uYqsjsb5Y+XIBOU/E7pyY/5hZMq4UPsG0n2TSKwAkKzky1CR4wxa+Y/vSGt4PtJv/S42GFd8xCom7J8hgsbiztrdKrcQi43Y6EzyffHl7zfpIiCeL
 g8seJcdj
 Al5W3tSth4HTJupC7aQUlvd2Omb2oHhAbq7S+F8RVBOeo0/ZL8+r4LjFJU+sRTDZ+NJck3UaiWCTwdphSsf6DX/obBF4NySw+0uCK3/k6tWacUW0+zIF7StBrrAJZKeAzoUvpm9i8PV5+Tjox25XBPqzC44vZ3tb8wceGuzL1+120kakZwYpZeNpMLDMRhanl2NQBpwTI/whUh+84827aMltjvZ3y/hTRqI86iBPBmBYsFafq+SLTB+4RTSGhKEpgTruBrf8cfLdKzS8C1xPjm3H/zN8aqkwCh4DvZVcwNfPVGsBzJMH7vNXJ2onZND1zXNXavh4nMRLIiSm6ypcm9tqWV6CRNdb2Pbaj4LYbqxsM2ujH1yzJRlo5idKVAO/cteIar5IQv2JgxNuQNG7xs1bZVKBgLnthQBVWVrdUQgk8rQpHOx8lhIVf/YOnbtN/OmLlRPPiYvapcB+uEmkdwEbopCUlf2y66WKlqqA+vGjPJUC3A1t9W2o0/qDv79pWV0iGd/9mP9O17M4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of using an unsigned long and checking the counter value at
the updater side, turn the counter into a signed long and check at the
reader side. This reduces overhead and simplifies the code.

commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
added a sanity check for memcg counter underflow: lru_zone_size is
unsigned, so an underflow wraps it around and returns an enormously
large number, then the memcg shrinker loops almost forever as the
calculated number of folios to shrink is huge. It also checked if a
zero value matches the empty LRU list, so the positive and negative
deltas had to be handled separately. However that emptiness check was
already removed by commit b4536f0c829c ("mm, memcg: fix the active list
aging for lowmem requests when memcg is enabled"), so handling the
deltas separately is no longer needed.

The remaining update-side check is costly and cannot really catch the
leak it is after anyway. It runs on every LRU folio, and if a folio was
removed without updating the counter while other folios remain on the
LRU, the WARN only triggers much later, from a likely innocent
callsite. While readers are much rarer than writers, only the reclaim
and reparenting paths read it, once per batch.

Checking at the reader side instead leaves the update path a plain
addition, and puts the warning where the value is actually consumed.

Note this changes the behavior on underflow: the correction is removed
and a negative value is kept. A massive leak of the LRU size counter
would indicate that something else has gone very wrong, and one should
fix that leaking site instead. Besides, the original behavior might
cause false positives, or make things worse if the accounting happens
after the actual insertion: the value is not leaked, just delayed, so
force-fixing it would cause a bigger problem. The warning now only kicks
in when a consumer actually uses it, in which case the reader gets zero.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h |  9 +++++++--
 mm/memcontrol.c            | 18 +-----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c79992643556..2b67694285d0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -100,7 +100,7 @@ struct mem_cgroup_per_node {
 	/* Fields which get updated often at the end. */
 	struct lruvec		lruvec;
 	CACHELINE_PADDING(_pad2_);
-	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
+	long			lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
 	struct mem_cgroup_reclaim_iter	iter;
 
 	/*
@@ -887,10 +887,15 @@ static inline
 unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
 {
+	long val;
 	struct mem_cgroup_per_node *mz;
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	val = READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
+	if (WARN_ON_ONCE(val < 0))
+		return 0;
+
+	return val;
 }
 
 void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bd1e7e154426..f17b2b2d6105 100644
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
+	mz->lru_zone_size[zid][lru] += nr_pages;
 }
 
 /**

-- 
2.55.0



