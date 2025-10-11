Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD00CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 06:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883EB8E0023; Sat, 11 Oct 2025 02:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BA48E000E; Sat, 11 Oct 2025 02:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771B18E0023; Sat, 11 Oct 2025 02:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 685848E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:35:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1A97EB9CF5
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:35:58 +0000 (UTC)
X-FDA: 83984873196.24.1E2E867
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31A57A0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 06:35:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qNPMHD4M;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760164556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cB2a6FvfZoFG5BjjslGyhKO4IIOwHuEpk/Nu2vPyBPI=;
	b=xgZmY4yGDm4f8JGCKg5ocsyuCBtI3rZMB6E1Hv+2ZAuZcQ/RTITw4KkHuM3p71Mni1nQwl
	+pVeKU+lX3ZFd2HwfwemKJ1tbp/D0UzSs6k7rQrx7r2mGdUCBgCOIQjDTOiB6LqUgM9a31
	2trDMu+1vQwJM/kjVuSCRq+JmR5wjjQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qNPMHD4M;
	spf=pass (imf25.hostedemail.com: domain of mawupeng1@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=mawupeng1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760164556; a=rsa-sha256;
	cv=none;
	b=0GRPWxDa9J1BgBXM+iBTxY1aRRB8TA+YQ7Wl111Yl+2W88ogrqRCPkss2jlQrXvEB8yNcM
	eM4HA6dUnvk2RaOj9Lhr/4vAhshXdOMQ3SP/7FKNb7jR3giuxapFRuFUjK1WXCCNVjjRcA
	B+w78+VdzWQd0Yb/L1Aw+En6Lk1WgEw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cB2a6FvfZoFG5BjjslGyhKO4IIOwHuEpk/Nu2vPyBPI=;
	b=qNPMHD4Mnek+7/aQYnkWxzTP0b9w+KvbupDqPbD9wJZCGhUVP8+OSi8+LKUEVENcGZrCd6DBc
	qy/u5RADP72/owxAGk6U52xLKkB4coCULu9B2OmNfxq2mikfhrwe07xelaGzGk5uXc3utsxpUMe
	dcozPpaWaEkph8t8mdd4Qds=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ckDPw48DtzKm54;
	Sat, 11 Oct 2025 14:35:32 +0800 (CST)
Received: from kwepemj100016.china.huawei.com (unknown [7.202.194.10])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E5F518005F;
	Sat, 11 Oct 2025 14:35:50 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemj100016.china.huawei.com
 (7.202.194.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 11 Oct
 2025 14:35:49 +0800
From: Wupeng Ma <mawupeng1@huawei.com>
To: <akpm@linux-foundation.org>, <david@redhat.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <zhengqi.arch@bytedance.com>, <shakeel.butt@linux.dev>
CC: <mawupeng1@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] mm: vmscan: wakeup kswapd during node_reclaim
Date: Sat, 11 Oct 2025 14:20:43 +0800
Message-ID: <20251011062043.772549-1-mawupeng1@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemj100016.china.huawei.com (7.202.194.10)
X-Rspamd-Queue-Id: 31A57A0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ii6ypbe4akedeadbx9sydtde5xj9uu39
X-HE-Tag: 1760164554-348356
X-HE-Meta: U2FsdGVkX18pluPhBczE++72tja31viNe7T/dCwvUxy8EDr1UWWvuP3tVJ01UTadacF9PRm7WoO5jMC0xnaDM+myGxBjCWmlUMVIYHazA5dQNEe4uNmkMdoh8q3NyCb9+59wieOBUp3/4RRTaAplW/LKqrUwZr0wqmr2ur+zk//Whs6mCPkrkyHXIIEUPpHxXaxom2+q2b1mWhL5wsqOItjOEdka2Z73F1xHgkaSyjDyaDlaBa9eTm/ys0RXjp1xLYq8nYgOmKczmiAM2hlHaxKO+9dbA+1jA7DcuEDGkz49BIIwvzgNQZ9DlT5JP4DBeg8fGVjDAjCwka+QHnRmdHNtG5srB6AUIGcZ7RoZ2jkcl9tzXkS1PeuLAtBU1OStgVoW2OWljluoq6CMfvwekCJt020WqCQ51f99E2uEiytoPbEISTHLSRKnFbmrB0pktpGvuTO2aUWzmLSGrJGlFwaFKFjlfZEZqoBBQF8wSfQyeTJqnS+cBE/vTz/qI2oggh3l19lJ+8Yr53FYmFDuWN1Gchf6hTKmyu4jVrcSxWa7zzc2crXTfydPnYO57G9VmLwuOUqH9xj75C1uP04zzKGUf5dYyJqeLKEoM7bE1ITmuA32ckFfOSv/6qtrrlJsNRxNjRnmSEg6de4YJ/xhcUzYbZoVmxBYYimBKpQwj+Lwnhq2mxdlEIHD2pgmhuxzmBkh1kp6TN4MYSgrYldTOg2CDzMCwevS3BVb4OnfmA3RJrLEGOGBmaV2fFoEFn3SMyr2SnCCI9v0Pay8eOpgk6iczzMt/XuWIkYpvdf+dBZICic7Rcjsji4eumHTinmJcNknt1IECyZffu4/bUWxiS7ry4fAP0WhmG+njEowOHIJFeI+On0B1o4mZyJVBJjqEkeEzcqHKV0AweCwLo1QnIIIweeB13aDcUuY5OGLBo71ed26awuMKDVNaa+feMhloEOILOt4aFP9WhOiE4T
 Sy7cT1bi
 MZlNzA6YnftSuYfH1giQtoqgRgK799kF0PCl+x2n9+Lg303G4WuZved8cFHfGAlUb2BHTm1DEvW6w+eNH+a+DsEsTYBzVSNrXa7eyMPwrOauVIB9MwBNukuzv2AJWVoYrtRTkk/9JB+Y+XGO++0Ut4FEvLNT6gZlYNeq8czse91Q5Dr/DiAuX2oQ7Sm42kutOgILBvDAXukKC6c4MUR4+dcnieLYvK8j/tehWXzRizOt8rD8rrbwOcseBAyfrjmpnohUdqY8cBVft1onwk/1YrPMmSw0Qkx2Jo324y9dixsf6mKdO/ZCQcuyqBL1LHDR/f4B55Qbzy6st0a4+3z4Zxr7VMSqr9yCi5hRgAZBqF/kNaL1UFSGwzBhhtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During testing, we observed that memory allocation with node_reclaim_mode
enabled becomes extremely slow when a large allocation is attempted on a
node whose free memory is mostly occupied by clean page cache.

The slowness arises because during node reclaim, only direct reclaim-like
behavior is triggered — recycling only 32 pages at a time — without
waking kswapd, even when the watermark levels and alloc_flags already
satisfy the condition to activate kswapd.

This patch wakes kswapd during node reclaim, allowing background reclaim
to bring free memory up to the high watermark and avoid excessive node
reclaim overhead.

Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
---
 mm/internal.h   | 14 ++++++++------
 mm/page_alloc.c |  6 +++++-
 mm/vmscan.c     | 19 +++++++++++++++++--
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..5303123dd0a8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1196,21 +1196,23 @@ static inline void mminit_verify_zonelist(void)
 }
 #endif /* CONFIG_DEBUG_MEMORY_INIT */
 
-#define NODE_RECLAIM_NOSCAN	-2
-#define NODE_RECLAIM_FULL	-1
-#define NODE_RECLAIM_SOME	0
-#define NODE_RECLAIM_SUCCESS	1
+#define NODE_RECLAIM_NOSCAN		-2
+#define NODE_RECLAIM_FULL		-1
+#define NODE_RECLAIM_SOME		0
+#define NODE_RECLAIM_SUCCESS		1
+#define NODE_RECLAIM_KSWAPD_SUCCESS	2
 
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 
-extern int node_reclaim(struct pglist_data *, gfp_t, unsigned int);
+int node_reclaim(struct pglist_data *pgdat, gfp_t mask, unsigned int order,
+		 int alloc_flags, struct zone *zone);
 extern int find_next_best_node(int node, nodemask_t *used_node_mask);
 #else
 #define node_reclaim_mode 0
 
 static inline int node_reclaim(struct pglist_data *pgdat, gfp_t mask,
-				unsigned int order)
+		unsigned int order, int alloc_flags, struct zone *zone)
 {
 	return NODE_RECLAIM_NOSCAN;
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..2472000cab78 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3859,7 +3859,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			    !zone_allows_reclaim(zonelist_zone(ac->preferred_zoneref), zone))
 				continue;
 
-			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order);
+			ret = node_reclaim(zone->zone_pgdat, gfp_mask, order,
+					   alloc_flags, zone);
 			switch (ret) {
 			case NODE_RECLAIM_NOSCAN:
 				/* did not scan */
@@ -3867,6 +3868,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 			case NODE_RECLAIM_FULL:
 				/* scanned but unreclaimable */
 				continue;
+			case NODE_RECLAIM_KSWAPD_SUCCESS:
+				/* kswapd reclaim enough */
+				goto try_this_zone;
 			default:
 				/* did we reclaim enough */
 				if (zone_watermark_ok(zone, order, mark,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..ebee8b6330a8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7680,9 +7680,11 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
 	return sc->nr_reclaimed;
 }
 
-int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
+int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order,
+		 int alloc_flags, struct zone *zone)
 {
 	int ret;
+	enum zone_type highest_zoneidx = gfp_zone(gfp_mask);
 	/* Minimum pages needed in order to stay on node */
 	const unsigned long nr_pages = 1 << order;
 	struct scan_control sc = {
@@ -7693,7 +7695,7 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 		.may_writepage = !!(node_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(node_reclaim_mode & RECLAIM_UNMAP),
 		.may_swap = 1,
-		.reclaim_idx = gfp_zone(gfp_mask),
+		.reclaim_idx = highest_zoneidx,
 	};
 
 	/*
@@ -7729,6 +7731,19 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
 	if (test_and_set_bit_lock(PGDAT_RECLAIM_LOCKED, &pgdat->flags))
 		return NODE_RECLAIM_NOSCAN;
 
+	if (alloc_flags & ALLOC_KSWAPD) {
+		unsigned long mark;
+
+		wakeup_kswapd(zone, gfp_mask, order, highest_zoneidx);
+
+		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
+		if (zone_watermark_ok(zone, order, mark, highest_zoneidx,
+					alloc_flags)) {
+			clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
+			return NODE_RECLAIM_KSWAPD_SUCCESS;
+		}
+	}
+
 	ret = __node_reclaim(pgdat, gfp_mask, nr_pages, &sc) >= nr_pages;
 	clear_bit_unlock(PGDAT_RECLAIM_LOCKED, &pgdat->flags);
 
-- 
2.43.0


