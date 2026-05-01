Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC232CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED9D6B0098; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2146B008C; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4ED6B0093; Fri,  1 May 2026 17:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4573E6B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3FBF1A02C8
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:15 +0000 (UTC)
X-FDA: 84720078870.26.6357898
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D05F21C0006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQ+RGrdA;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669454;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+bqsTdvIBEMj3tg4Io6miSNjOsTxwury5zJwlhAps0=;
	b=UcgDli9hWaRV2iC0ErwJ58uzwVjP/7GA8qKgH1KF4lRi7dFZv/NIVyTNzjCFlaQw0cm0OI
	PRgs75g9hZbbsd0YIZxbb7IqRA4ZqTw90+vR2LA35SJolTxqdJrC/jI721h6qj2HOFo1N9
	vWZEHAci+LQZOYNrO4LgdmqnIDj65YQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hQ+RGrdA;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669454; a=rsa-sha256;
	cv=none;
	b=hhVY7dQkCINn4SGb0Hr/sz6zhjwHgUkKivHmVcAegUt9w/gNeZIIZ1vOusvX9H4KrbinDk
	IVmeCWYRhhLxCKOjc97X6/5QMOR1w0YxJjFMAOgUi286VvABlMkkPm3b1efio7t/OALz7k
	A76Oc31yZGtX4hIh3pQXiEQnaSiqIyw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7001340BEB;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 217E8C2BCC7;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=BtZCQ7Vt3/NuhMTCXCuVEsIVBPtMyx52Q47wxXig3d8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hQ+RGrdAVg+Y7Czpeuyr/HnIGGt/gwxGoFve+P81oYA0YXQ3+nZ73exutv8Vl8i19
	 52QHz1UnEcEnNXBMGIoR2XGljZbV0686WKQKdEkbJL2bw2+5yl63/HY7V/NcEpyVZC
	 E1mltgN6ym8uGIM9K48pJVxQo5+SqfRham8W0i0TN+vCMDjNWrXd58oZcEFjdNUOI1
	 MPltQAnP541kb0+KKgfeenXb0o9NGWqLQRORs/BOW49o3aBpl+xX/x1+2pXLXmwL/l
	 yUZbWrg+aY7dslTIUBIHkGmOItSKilIJ9aK1jm27KH0VcoKXn4W8GhnPwB6/Ez6Du6
	 P6dWBJMkmQqRQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F957CD3425;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:48 +0800
Subject: [PATCH RFC 02/32] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-2-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=2443;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7DMvb7Upt/bAaZ8grY+SULfcG8KtwGIhgqyxd6Mp/ho=;
 b=akq/u4487d3d37xhZaBqbl7RVG5EPHWQXhVgyD5RxHWhgIuLeyYAv7xavx0FgEr6W1ZuEMAME
 3Ik58RxwOAlAu+wSikCBBnd3YkAKUEsEbo3Lq/yaKRgvyfSyBBFTfS+
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: rd73rd1grbw91pai35zjo3puai8cwewy
X-Rspamd-Queue-Id: D05F21C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777669453-150731
X-HE-Meta: U2FsdGVkX1+uEU5Lp2QsyYfzygYTk5wpSgfgilo8ra0VzDi3xjYztclpc1jXObjULFHXPq5Fv7w7xAtSo+McOrSAxZsno3m5RoD+lF0BxsTIVcxwkUHP82fanaNZbod0CyNQ3bhUSbxwNtLszt8bCHvFYbTwMb4mAk6kLXMDmedJbExHUTEhIF0J/3kik5AdExc/2fjtl+JXr1k/L0IiwhM/fN+t6efQLg5pv4A7Vyavdt4eZwh1svMdkMm/BCVimSX9MEGPVSHY+0louRnrfCWQn7sI0aW/1j/JhLxmJCWVJBorc3NCWiB820OQoZlRC8+CMxopu7EJaddcbmmQ0KQ6Tpk0q1dnoUWC9euSc4ot0bhZcE4qEA78fIT+FV8FaGU9dowJIxHDWDyUR6FjwsIwXIxIRG5mGzWv7FAIQQjlIrhfnwTOANljMdJIbPNU6XkGBOdc6CKN+OGt0omcfnXo9UJhAUHjdzdkoM0PkjX8LobD2Zv8FhbAPgos7X7hJueBwWGHXmQEZn9m88MbuQfEk7Pn1z/gr1ZGtEu7Jci7p+oNmPO2vrOpG5MrZ4VRpaA0bLMH5JJ7mhVpzOm+aHsFwdnOFOQEOVQAA0MqI9BBLW3cGCo6NRmPrzl32LzMKVR1r2N+gw6iIDNTGmDw5t0r4c6P6J2tsoX54as9E57eAUE+BUjgXM/bfdUa8GB0YgsvjUl7Own2Bqoacl0VTQbzejI69zBGi5znHF1dnGCPCBJxCmZAxmNRkQ8UbcRvdQ6dgK3hiGn0ZcCfZdvuVMtk0/aiW1lx7EEj0noZ8xKE862PuiLncYQWcG6WVSVRx7N1NB005qURhDVUhchQYSVc4ZyW4bmhof6IDwQIQJPp1lZPM2Zge9qrgwow+yxEY2Sx6zkBhzjCpmUMEuMbjmWmuHgorLprTNVMsKzBWtg59tTTywGHVTJM2iUrDo0UOcUdLcJJO5N85NwlMLC
 1U6/i7fH
 cexMnaYUl3XS/XiHgqwzxjS5zTPPiVX12O5Ud2iCcNPXTc0a+DRMGSCRjA4NXA4k2F4w5dKHqX3RgLCt5n+tc2g1d7ASQNzR5B6B+lkzJRaX38B6vpTBorZfdrDvpJX5CKQLFSi64MkC7j3alXIJgg1Yunh89Ra/M+lx3DEM2POFq0GIqsbhy/pI6SI6nDe6vPW6D8OsfbvS2HwSCF1uWhpwif87pFzCMWWqu+eJUw0fSGn8L+PhMYMeSIbF60hE14x0Pk0/AVQONJBGgyUSMWLOwG22ZLILFfbdWmzP57llz25dHeiMUQP9QI2ZoJWaLEtL2n6kR1yNzGwy87ZC54r3JQ5LUxPxAFJYjbdbIu7kscEdlMOXqBJH/+kWb6egW3XyvBtsTubjS7zUM0K7FBQao6g==
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
index 345a6ba8a3a7..2552f24afe38 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -889,7 +889,7 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 
 	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
 	val = atomic_long_read(&mz->lru_zone_size[zone_idx][lru]);
-	if (WARN_ON_ONCE(val < 0))
+	if (val < 0)
 		return 0;
 
 	return val;
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f0..045f9ee3880a 100644
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
index 71fad2239973..a3571763e813 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1477,8 +1477,8 @@ struct lruvec *folio_lruvec_lock_irqsave(struct folio *folio,
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
2.54.0



