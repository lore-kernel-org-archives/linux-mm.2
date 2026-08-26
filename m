Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3AFAC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9966A6B008C; Wed, 26 Aug 2026 08:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96D536B0092; Wed, 26 Aug 2026 08:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABC06B0095; Wed, 26 Aug 2026 08:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670CA6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:44:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9681D80368
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:44:31 +0000 (UTC)
X-FDA: 85143389142.02.56ED44A
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7F2C11C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:44:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jlq+R6xr;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787748270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6BrUxZKKQbWD3WGymsB3qG3VwwxALIFOCAC4NEHV0AY=;
	b=e8A132VA+RPDrgWMHXwDsXof/1nee3aky9X0jjj8K8MjUYY6YloLfXLPPdnaVBjx/eRrd9
	WzAVH4bV98Pp6gNJyxFu8ElymcR985O+wuJ5HOSf4gYIKibCxab3cb3YV14GnR3Y9ShKBk
	bFtZxf5JJKVqIyLvA5AKAbquExWJpw0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787748270;
	b=D4J/AYRNfCnu9FRNVeNM9OaZvuxlOWi+Idg75Zw/KPLGvvRwF9+aeBjUKWSEmd8U/14rqW
	c2uBLWGrk0iO9Yg/uiJ8tRPAJq56jf8ylFIIFbjZEMWlOeEfZ/k5rIAS1XwUEZcrMmXAHs
	JNISbAI7l1X6CuEzN8fZtldk21Vlj0k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jlq+R6xr;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IzFZRj95FedhBG7vUWVbKK27BO98pC0xOrlDItWw6R4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787748268; v=1; x=1788353068;
 b=Jlq+R6xr0RmFc4fb0Z0uoWumjHnkqYl6PcH8XDuSBFvGqCk80HWl01bwTou/Qefq9SAh3FhN
 lwwSa2tgiAHnuhf6BomiF3C6l1WhGCYCQ5wcIruG6k2bDWMA7s5xMVsnCxdHtt4XrHERFJQRhSl
 Hno5drnYDTZ+6CZHeZDgyj3A=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 4a6433d0eb768628;
	Wed, 26 Aug 2026 12:44:28 +0000
X-Mizu-Trace-ID: 4a6433d0eb768628
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] mm/vmscan: drop the combined limit gate in __node_reclaim()
Date: Wed, 26 Aug 2026 20:44:09 +0800
Message-Id: <20260826124409.35569-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F2C11C0002
X-Stat-Signature: wnpu9nrfxgqn4fsmeo849waw9f4g15wz
X-HE-Tag: 1787748269-226657
X-HE-Meta: U2FsdGVkX1+fifRoikBwNgcfLALtJjHV44ASc5ktn2Kv7IK76RguDE3v7VWlVCm6bcnzbVbpKIJKCqqPWbVD22YBjB0xJ9eEmCE0DEOoASFPggJ3/vFs5t2wz2LWSDa9NtPi9swWq+oRzHV2YWt1LYBbZFhUBiVfQ8iEqm0fbDMh86iHG1SXrazVDUbh3CpxrU3aWBfGPeHrpNGuwxxbi6jZfIffFioAqI8RvbyyiHU8phAS9BEP7DO3RbuZVm1r5E4nUnqXTa3bjV5q5aKWrvVxV+1aXafXbd8tm/IFqSykQWWfZvzG9QsesNIoMODQqFvesp2Ej6EHQNWUNXMerZV8PUgZ/0PEsdTmuvDbnkeW7IwIRHn0fsB5BhJyCRI4JWosr6l5aV3VSHgBUhayZIJCTD9UplWKK0HX8RqJyg7aPpy7wuHIkfJw44xay0TIbzPYp0kHTeUEhE9D520xYZ02tiGv2Pr0xOTM2ue3oPqiR+cr5qCaq1NMT9yMxf2UVBRUiiYACDgLgBXMrN4FWco1Ne7JpeGWglV/a/Gh07jccrtt1qIEvOIjDoLhieKx/ApgzBNBft6mjDogwJOqrjP579aAnHyVxxHTwSFn24MzfJA3+5/vN/8XIN5sswVFAXGtMzphJ6ABdjM32UUCmoZfMiYxq4XHguAEE5PbsAtEHEsNgKS+mTECYfsD8TzeYcMD0i1SzbdexDdx7Bq5HjR3ydzxYXjXLva99UGwx/jYICFUJ27DXrRhhdj04iLSggQb8wQPg+/KGHwo/+GbGG3wpKmI82LOQ653WsPTLWAMwMKXPvmu1pK7MGtcv902ANI3kFhc35sBeXeOQY0aSTLYDLOA7CoUaK9MuxWo1mQnT2rwA3Q8LipXmE5gbBChJIlFNPVDc8JaiZuWeLLX8wwbT7o076l/HYIPK6Ayztcj74off3FSezjrUY+3jFi1E5EhbJ5WQJ0IZPKq82Y
 EsG1zHGG
 /ZDLEDqmoYm+AXDV2oGR5/JTcT2zpaBfc3BRJAmVywhc0ifQoqVcT+dLmEpmgSE7CdEyg8Kb74ymfyy0cItNSRlC9uDgjjeqKGs2LJPNTbJO0dNjAUq6w4qp5+8whYOrcWuUcKF7+lqFN5b2jRqmA4If8NBzY2ewpkMMEApFtfZ7D/sWcXFG/kpTpszfb1BXIsjktKINAah/iGR2XP1Qrt14Q5va5Kylg+MoEDwmkVX+eiz2AkN1n4Vzt4joi53glx5OwZu/v1lKlq56mTMV9esJK2x70J5uucykNDPDKBOlXtZ9S3Qk0Sow/2z4+MkNDrGtEwdeLF0YLJPQ+8c5NKsfeb8S+MDSjy5yxD5y19DQ1XT6MKviR4J8leaOkp5DTroSo46HKWxb+hTZJmh47PChre7ZZqDzLWqZ1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

__node_reclaim() is called from two paths: node_reclaim() and
user_proactive_reclaim().

node_reclaim() already bails out early unless node_pagecache_reclaimable()
is over pgdat->min_unmapped_pages or the reclaimable slab is over
pgdat->min_slab_pages.  The identical check inside __node_reclaim() that
guards the shrink_node() loop is therefore redundant for this path.

user_proactive_reclaim() is proactive reclaim driven by userspace and
should not be gated by the per-node min_unmapped_pages / min_slab_pages
limits at all [1].  With the gate in place, a proactive request is silently
turned into a no-op whenever the node happens to sit below both
thresholds.

Drop the gate in __node_reclaim() and always run the shrink_node() loop.
The node_reclaim() path is unchanged, since its caller has already applied
the same test; the proactive path is no longer wrongly gated.

[1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..6dff207ad8c6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7851,16 +7851,9 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 	noreclaim_flag = memalloc_noreclaim_save();
 	set_task_reclaim_state(p, &sc->reclaim_state);
 
-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
-		/*
-		 * Free memory by calling shrink node with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		do {
-			shrink_node(pgdat, sc);
-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
-	}
+	do {
+		shrink_node(pgdat, sc);
+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
 
 	set_task_reclaim_state(p, NULL);
 	memalloc_noreclaim_restore(noreclaim_flag);
-- 
2.34.1


