Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C4C2EFD202
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3B56B00C4; Wed, 25 Feb 2026 02:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863F26B00C6; Wed, 25 Feb 2026 02:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79AA66B00C7; Wed, 25 Feb 2026 02:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63EF76B00C4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:56:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2886E8BC0E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:03 +0000 (UTC)
X-FDA: 84482220606.14.73C36F3
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7D0AD14000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:56:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a1YwsQ2P;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772006161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ih1p6IEUWMwvOImSKCL1YcoSFVupYh3GoMOZwrQGBdQ=;
	b=T2PJzaSK4aZOpWnHCoDm2iXSqgw2qlA3M2mDmFZITLgLGA8mykugp867svXt6s+H9mphGL
	6D5tosQ5qjlob/uEAlDZXxdOXDFGWxEVNLDsg8K6z8SbM6h+cXfaeQzi37zDWIaoFfC3OG
	D1GHjLm9TbMhGzI/gACno/+i/a0sTJQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a1YwsQ2P;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772006161; a=rsa-sha256;
	cv=none;
	b=ueQiLawpKKsWLiQsrWqjZvE6zOwnWE4DKWAAV3J9T59yKpsbKeE6DZKmlIn6ODO0X5QUAr
	iQtjUq3vigRfnJectkhUtRdblsNksi5rrON50ahijkgpwDKjl9IdFkjtDvNdwQvxWRI69+
	qI9OKpW3YRq9gQ0QbtTVgY7zq0sg6MM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772006159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ih1p6IEUWMwvOImSKCL1YcoSFVupYh3GoMOZwrQGBdQ=;
	b=a1YwsQ2PzzmX/ma7ssZUFCwp9hvUyPHoOcM4V22f4Ryq7nhp6VOl7tQ2b9GrlO4ZGbE19u
	BGemZ3AfFYpjeikpWspM57ajQ/aRUMsL3XBmcOfwS1f/c4UcxT09aV2wUuUYG9hrK95w4i
	tMpM6lSDBvtaZm3TWKzHPURAFSmi6Lg=
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
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 27/32] mm: memcontrol: refactor memcg_reparent_objcgs()
Date: Wed, 25 Feb 2026 15:53:10 +0800
Message-ID: <2e5696db1993e593a51004c1dacedbc261689629.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D0AD14000F
X-Rspamd-Server: rspam02
X-Stat-Signature: nabnfewift5q5cyw5yt3u9jsk4ygjjz3
X-HE-Tag: 1772006161-860292
X-HE-Meta: U2FsdGVkX19EnH8PLVe6QRWuJLthHcKbPL8XfknM5QOPKbFfanlSXTIatCKo4tUYGrPvYGhYjSUh+HLlVyfgxS37EuE6iRgSkKeQNy52YkmKwdbV6VSt/ba+nbM1y/1ka977Qq1gK0+mVGWlBmlhwnUsiei/JGuWBDXlpZ4jR8XvhkgNzzwl98GGFtyFgbtXLf2NQka3s+ejUZjbLDl3dDZoenXKAF6pFjE6aHOhbXPNbfHy048d1s0CEtT7V8jmAUy1Q6aYioOho4EUsuN3ZKzHR0AORX5NWHAb6m966g9uMooWFsB+gIcIU7gH4pNXiNP/0WRJUR/31CeKeOXP/Ch41RLlMt+5S3ryFM7uJVYdH184CH5xM6mu+R8tb8nvTIdNYT+rvKsudmLIl7mcuRVEPMAHK0O2tvrF1BdrLqiylPziGAf5Odp5YVn+FkZ9NZ3wShdhIIFDER7oJrkVYcJFwolCMV1P4dj3pSS2ocxatW/i8C44POuV2SKFUMv9uSkLLSRjmDjorz5kp2/b9myUChMO/Okcg20TVPyW1x7DLtsLfkr9L75ke/aVaKSOf3LOTOZiNJcdwBUS0Gz5IvhuCmSHBZ4eMe8vQ6usAidzh26XFqG48c30LDojuGSCN+qem5zcsvqlOBaxd9v0ae+3bosNbeLpXiGnO4Uv6MmsvTKSVWo8RD2iGuO3njwz4RnOAKdF2FNZtEaZ39jZYtTMpwSqKtdWIhxO9djFWciaWL2KVcfvQij9GDtU/zc2077XR/SUayNfCDNxNER6QwASfqQGvd5ibpxMY8jadYdohBSbAJSrOo/IZPYid0JSmoXX526Omni3X8qju2Qq4m/GrlN3JFq++hjMWrGiG7XNZlMtyCEw4jED8eGuKFVh3b3di/anMaJ664b+ylGJPq0qx7a+fDiMndwFu1I5l8NJFkqP81UJDMyLGbpCbCuqgkdE+nE4jascyfCyD1W
 TKcL+sDI
 a0O5KfksAkYe1SXLdwELrMFOVTUITMti27XA6IiJhwJ1j7VaODwC8R/c8az4Niu5y/Glo3AQP5vYjEXQJYAquxs6yQv5dv8J26g/d1NaKZtZp99DqoWz61GTt6QBwgAMQAxtDV1MViOofix0fbIvg/wU0VyNYJ1uAK9dfmeJhCJd3DZ1nlY63QkU7yC3jmDkzQstrTyick4cQCJ0T5b5bE+UCWqMVTDwj2ai1rcnCzV9B4orF9UULTeI8vk20UZl/lwAa1TpR0FlAVsuSwyN2LzYscfmjp+BYNHcvL0N2GB+iSRhPUCm41jmeZ/n2A+tPMpe5qGNNaweQg0/NqPCtBwZtfpFmpiqX2Qz1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Refactor the memcg_reparent_objcgs() to facilitate subsequent reparenting
LRU folios here.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 mm/memcontrol.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49a076b7c2e42..5929e397c3c31 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -209,15 +209,12 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+static inline struct obj_cgroup *__memcg_reparent_objcgs(struct mem_cgroup *memcg,
+							 struct mem_cgroup *parent)
 {
 	struct obj_cgroup *objcg, *iter;
-	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
-
-	spin_lock_irq(&objcg_lock);
-
 	/* 1) Ready to reparent active objcg. */
 	list_add(&objcg->list, &memcg->objcg_list);
 	/* 2) Reparent active objcg and already reparented objcgs to parent. */
@@ -226,7 +223,29 @@ static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
+	return objcg;
+}
+
+static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
+	spin_lock_irq(&objcg_lock);
+}
+
+static inline void reparent_unlocks(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	spin_unlock_irq(&objcg_lock);
+}
+
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
+{
+	struct obj_cgroup *objcg;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
+
+	reparent_locks(memcg, parent);
+
+	objcg = __memcg_reparent_objcgs(memcg, parent);
+
+	reparent_unlocks(memcg, parent);
 
 	percpu_ref_kill(&objcg->refcnt);
 }
-- 
2.20.1


