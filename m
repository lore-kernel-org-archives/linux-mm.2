Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CB9C55822
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA696B0096; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961C66B0093; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876A76B0098; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 559AB6B0093
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:47:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD8BE1207B9
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:25 +0000 (UTC)
X-FDA: 85060992450.03.A9E9E22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D97581C0007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:47:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7P1axca;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786444;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sLJb6vRmQazSEukalwxuSuWNwMSxE3WaQ0evUXikFpA=;
	b=Gfe6Ty2pilDVkvpBTsUSVp9Btbde9nvF3kMB8s51XfehHlZjnt6mywqgt12fSSa4+eIB8x
	tDVkv/67JVYuq7hu7+OgQ0N2fSaL3C1QjJZdwOms/Q26EZcrYX7v3NWqL++sQj+C/IcmOB
	O3OwtcS0rHaulgIod3I5NRQIWIHwBlU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785786444;
	b=2eIhsaY8XpL2q0Jv9z3yqEhv949zXjfmS8fxwa+dfmrcqRtS6ls07OvyR2PvA7BiXMLEMh
	AKQ3Elo1k7ovyv4JHwVltdqMQ2WdY6S8g/ynB+zD2IIOHlzGTRrvwsOmoiZzD7cn+bDai8
	EVqp4/zstCX54ldCdZK502CTgm8tn+Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R7P1axca;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3C5C43D58;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60311C2BCFA;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785786442;
	bh=TjoR3Q+A/75X5CmlKSstBL+V/RoGE3aGMjE+kfk6FR0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R7P1axcakJNma1d6DuaGGoEgfK2OzXAzNi+Mv/cg47QiL1r1DdF7o44v9HsRZtfSj
	 GcAjs7OZPa+Dyp7aWJVjrQrwO/lD0mKmSNLayy+yI5cdGOfeL8H7nKWhSWR+qYFesJ
	 nCd94i7xeq3HnPzNX6ystfYRy2auErIRpTW5YebkMSlmQZgmVxeWVP5GOxnwJHzLwT
	 Nx7gdGo6citbgBfA04y+d4jcCKf9uaKOQS5u2ql5cshdJHeRrF1tZA+bdq7hBfw1FT
	 QPSsF68Z7AZ9nYAZbu6b5EnXX8NrVQWkhXpaMV7w1uDLoSV712syYsX6r4YcmJBu4f
	 tRvI3jtpwT10g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EDDEC55822;
	Mon,  3 Aug 2026 19:47:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 04 Aug 2026 03:46:58 +0800
Subject: [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-mglru-fg-v1-2-4d8dad39dad6@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785786439; l=2443;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5ef1JMmzTBWQNcW2bqr39zuDrTRlv1xJUE0rVPZJ1C4=;
 b=UvqFhP7b4fq/TB0tz3nC3HBptpJwoGpzzJy32pvAzSQ2v9hQM5SwhY+4eceXnqcf0tEbwa++W
 fjNuHNjeJheAat9Cj1uzPEjUbiHDcOtF8tc1fq2VEat9TX/fYD3goID
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: tchdkhjbqye6t3thiuuitjnjejh7u9fm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D97581C0007
X-HE-Tag: 1785786443-657180
X-HE-Meta: U2FsdGVkX19W8I7EYBe0+iDIjIpUcqzfP1K03VsITDPsFIbcpJU6R8ZPUPXZQ9UGsqa5tD5VxMtIu3ArWuK8L3OZkcLCcjpKTe5r4TC1lqqeKMYf2g0o+EfYy2659RFHkRlAFy+GKtd6rRfy0y+P1xcT0/2/bNckc96ybYTyaCPet/R5zuuzG0e2zQgJ6naaMxKcYM/DY9HPswx097FmA5keUEtH5oM2JKIshnFd+88g6qBcO2fEAN4+oblHey5R7hzTsSDkwp27gel9nwt9oQMHbtkvvLKp3W2gaLhLqpuVdaIG7kaeDG9DKOuI1iNRYMVlNB+FHn9A5uRAMsvJI9gBcOJhzAeRNnpLF6tGSK9W4NyEQZJQboE1vPVnC7k+KKV35bdTl69PfqKSbXkdhWZiwv4J5n6XmGDEnSyeH5lswpOpmefrvxNZMTx/Z313cXqqCJeuHfcuLMNhOlSeGaXinEa4zayrOhuJHXWMwrd35c374RNwo49/chmJdPsBSDpts6fth/ianA+lLFSre8HCm4KtuDWwCTUtnnZN1lJAhYZgSHdk0s7sTm7Oc7rmOPKgMkOH5ZpEKFvO2GZXjQmUbntKD/beMIlGPXxsJKQPlSShxH8dbBC5Sz5wCYUVcaWvGwxhFIgcyaoOV6PUKbCBm9IVQw2hkmrE0Dj/OhnKAQXr5hDzsrcoA06bOJ1RS9ckkqyYdev3O9dVSde5P8ypEcwYLORgAdwYM1SybIiKsVBOK0kN2Pbjb48JzeaG5i0iPtvFm6E0+2brbaDnfIlxf0ipJ4xVO6/vP5gv3HQQwGM2E7w9jrSHsLBqV91k2e52jWeHLzaLYYvPFV237HeUoLfV0681GhPp1wVW7j2wtIaJk8fNGw46uttNXAROisHYaeTWYvrBY8freDnCf1L3x/ZyqzQ3aUIfJjjrYEL6ML7VG0a418BnbjfJby8y3xC5AC3T/tazN4ydBxK
 Emg0oh5t
 VgkHEYIlAwl0amw7Vj1JAlwxR4KD1M/SKANO7dZnnw8bsAW+BVlkJnW2SO0dpzrP7oehNzVprl+4C0jNtJORPYr8Av+E46zy9ICyFVwYDfT7aomvxL/5tSvn++gifN4zvP3wTXliFEx/CQu21tXfsD+2rsUdMabICHIuLdwHFiVeluS8RrJJHkOWNf/K63jAca7ajzullmnyAGSm0LzUZAffrnAj+sqHqjRpA7z174FaUjdnZ1zPWKX3h+x/Xj/WwQE8OAhNRbtbPYuhxTh+e93NsIvo83MuJ3lSNEHpyH/n8zfAGGLUfTkcb5XQRu0N8SxOFyvsZ0SDJF8Vj5X5K39Wm3Gz91WTxYSg3xPvxjC3teokX/4qVnYgU1I74XZLGpCqELy9sHwOSlfOt41QYINuSGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To enable moving file pages in folio_mark_accessed directly and lazily
for MGLRU, allow updating the LRU statistic atomically without holding a
lock. It may cause temporary counter underflow, which should be fine as
we still follow final consistency of the counter, and it only serves as
a factor for calculating the reclaim budget in vmscan. A little
inaccuracy has no visible effect.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 2 +-
 include/linux/mm_inline.h  | 3 +--
 mm/memcontrol.c            | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b13e3f056319..68f363000d7f 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -902,7 +902,7 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
-	if (WARN_ON_ONCE(val < 0))
+	if (val < 0)
 		return 0;
 
 	return val;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..3ad1619ce8ca 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -36,11 +36,10 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	lockdep_assert_held(&lruvec->lru_lock);
 	WARN_ON_ONCE(nr_pages != (int)nr_pages);
 
 	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
-	__mod_zone_page_state(&pgdat->node_zones[zid],
+	mod_zone_page_state(&pgdat->node_zones[zid],
 				NR_ZONE_LRU_BASE + lru, nr_pages);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7511773b3491..3fbd7a6f6650 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1522,8 +1522,8 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
  * @zid: zone id of the accounted pages
  * @nr_pages: positive when adding or negative when removing
  *
- * This function must be called under lru_lock, just before a page is added
- * to or just after a page is removed from an lru list.
+ * This function must be called when a page is added to or removed from
+ * an lru list. Caller need to protect the lruvec from being freed.
  */
 void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 				int zid, long nr_pages)

-- 
2.55.0



