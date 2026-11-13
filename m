Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2F7606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Bt9YMTHn
Received: by kanga.kvack.org (Postfix)
	id C1E9E6B05B3; Fri, 13 Nov 2026 18:52:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE6B6B05B4; Fri, 13 Nov 2026 18:52:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4F86B05B5; Fri, 13 Nov 2026 18:52:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83C4A6B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:52:45 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0B311601A8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:44 +0000 (UTC)
X-FDA: 85431748248.29.449B245
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0C44540005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Bt9YMTHn;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMy9JX/a9KFnIwCq14KsOs+G9vkXTmhpLfQkU1b/xSg=;
	b=3A//6iTce/UroMkj3zn5pvfrY4gXwep0o9/gNOH9rAp4qOYkqWnfrKtbAB9EsoXNW1yj/Z
	rddSIfpSKKeNX+W+naZZrRPbSnltq/DKKT00FN7PpiBiAs6TIpbU9pi/YTpY2K9UzplWYK
	j5gaq45WnpVd7o/6rZZTIQ8M6kARYYc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794613963;
	b=p8MI2XpL2i7FvxmztS8xU3AJ4otjQvksK6lqDTv2kzhcyiyGhIn6ZOgM/YIyJN9lbH1CVy
	+lgm54PAybMaKiuK4gAz36X2K8GePwGhlWHeqmAWsU1NszFgk5PIGsFwfM11/QSuybWGib
	1Ny4bEXKHsDJ6hQYVm8OkTFfKTZpWAM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Bt9YMTHn;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b32b2e691aso22913577b3.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794613962; x=1795218762; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jMy9JX/a9KFnIwCq14KsOs+G9vkXTmhpLfQkU1b/xSg=;
        b=Bt9YMTHn3h3eEKbTrkTVzXe6a4YxACPLBH/uwPv45LbqGXRSpMg0pR4uaEFnC/Un0O
         8fPHPfVJ0DKjw87j8y2m6d5S/YoNCGi3KiQfKHcnh8YKZMVmxOqZHA9R81TIUHMvH/q9
         vWnimNL5HSDtFjvxrizCCuhY8tsgVafXblYVN87Wm5uQCsakl0uvc8Jt1iizNFbLaTYK
         RNQIL6sizV8UgTx4nJlrwtR50w8rIBGI4nPxhNy+Wj/FsPHmCN8ccy6KKaIPeEYSvc4t
         Fqy9ySPlPdwCko2Ig7kHSzuDBUgyzKAbS6sO32o7vXMFuP720eL8rf+b55m6JAdHoV51
         rH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613962; x=1795218762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jMy9JX/a9KFnIwCq14KsOs+G9vkXTmhpLfQkU1b/xSg=;
        b=MWT1hmR3ahZBG14Wr0RGqCO58gCYudD+j1mPQa65LDsjg7TCmKmYP2OckDteghcJcc
         sPQ1kRnXrZTE8BieOdd1tt/AFdLK1g/+1fXGyvpz3RRxT8EZACdJL8u30D/Wcf5uFho1
         Dtc62A9/oIO5OF4UgoTm0x1txLZJRcdbL+xPli3Q2RcGQW6c9lVnKXBeIgavFejV9PRk
         mXT5mpSGioNjhybkE1QElpgVRhitfKf13iQKXZLNluvb4X3Ld287b6rk+KlVp7ggOOtI
         jFfXVc/q7d/pMpwuP2vLRHThwfMW7jGMOpTnqcu04nN8Qw0Q++r4fI4tqK426EezS1gh
         mMhg==
X-Forwarded-Encrypted: i=1; AL+hErGZTst3eaZsth3hyA9AthcMFfQQPYqI5uuwiGxyhsBTeZTsr2i9EZIz5v/f9j8Gsw4GrTkDyMZJaQ==@kvack.org
X-Gm-Message-State: APuU4Z8V0jrbAUT+ZHSS5gDnH7RVDfkMLgJXECBY/ee1fjI05Fba+IFy
	1eKpvymO2Hqns4UxsUr07Oj4/oyFq4VJ4tA+RtTq80FOjCWpLxWX2LYX
X-Gm-Gg: AYBFou1EVHpvp7Ey/6M7WZJvZ7XEuuoEcVdVZVRGlBbEFDZ9GP7fjSjSDgJNK8amUMq
	JHgHM1/MgcmaZyLIMiyrQI/riLElP7gsUkakh60MLcwKUzjh/MyyTw6GFkb9Ihs8dSGB0WlJMV5
	Hocmw88pO0hQJ3S2hBhHO5dHajjNrlZz6UayA8E832jVmvKUXe560zRdnr2LHnWGcNqLdSFN+4o
	3ymC1Pqb/hY6r4GjqiteQX4YTDbQO+x2Kmb9r5evEsTYC1bjbzyKkEsGTiet9877YwkRK9htJ53
	ZAk6g/7E6wzp/sjcEeybm1HxKJi9MXtqYl2azdbZC9mgckUPExaIBH9qzMuBNb2p75Ut5QvYFtX
	SRgkhwO8WZ8Yg892gwnn8ayiVQ7PCtIr8HQgPtDAgrx0ks1P+N+X1aeySzn0K/8L2eNNT5lyLQw
	dAeJWE+X8g1lK5hw98mReahlIBiGLXWtSL6mpKgwg0k60zwWjW0/aKUng6Yl+crrBahnVh5I6kz
	jW4KdL4gSoCxD8espEEVAIsfYRczdJcfLKGdU94GgvktSRbslAYfXGHMfoa9KZZOPSylU8WWd/L
	pqOq78KQ+yrdH/upojg1xPzFSDfO0CXvgRno94caZRL3ZLu6RdhwTBloB9vn
X-Received: by 2002:a05:690c:e20b:10b0:8b1:60a0:c311 with SMTP id 00721157ae682-8b4aa2fa74dmr17270837b3.33.1794613962178;
        Fri, 13 Nov 2026 15:52:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9dc1c9sm33104697b3.36.2026.11.13.15.52.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:52:41 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/3] mm/vmscan: consolidate promo vs. high watermark checks
Date: Fri, 13 Nov 2026 15:52:36 -0800
Message-ID: <20261113235238.3595412-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zodsmjxusdjeyrkdykjbmxns98eessfo
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0C44540005
X-Rspam-User: 
X-HE-Tag: 1794613962-734431
X-HE-Meta: U2FsdGVkX18P/3Uks4N72GIIp7pfdqTJELVhVSF8hIe4HcEVS6K/7P1tRG9jxRtWOBAzrVGgihAB2RaRAiE23Z20dQbYmeVMlUHRxYRaeyRX4Xo9lR+g/mqyjiwWsWMbP3pOFxDCNOshzLIiGjlt+ftzcMSfRoTLveGCb2MtMmQ/8spBDEfU+++koOAX2RLXSpXdVGCLxnSf6zlL0GBZACSt25u62BASxuGBXcQpOZQYdKNfnppCrc/GzWdhv9R53MVG2deLVpsXrKIq00MtOg7Gkjxfods7Nk32ziNU6xInwggpEuTz7bkZh+B0BB1eqf60Pvquv2dxJocBJF4qibu2RgrQnXtzNMA3mbjxbLE+II0F+1oYJxwCjvCkP9gQf7WIM1gKQJf5DDLLSk0ioi2KOUSpCw/Vs2BIPvoEZ2b9G322uBQ2w1T18In8LmTkrxxsQwpO/9/yuiP5G3X/KRX03P/75OcPZoJ299MdMM+RCh+0Ebrigg8OhGbc5TMFCeQmwdpP9fuL/u8vcOz/b0owULwNf2cBDlNMY4ZHsCzMiZLfPSq63j4tsme8y0qvEpyElGdzPK198TltzKoFn22QzyygaRA8YtR/jQ0d2AyqgWq01OM/H4HIFGHwe4A/D76LGPO6JTVmjJ2BlHCyhZrxGP7evcyY+SuDJlA/yWMKzBfbphk7IoTHr7pA9F23uzPmq1GlVx4IZVhZgU9V+PpIw5LVLia2nXjIareTMnPMjVFTEKXdhRKg9EBSbXgPtl7epDVuCJX+sFVh8MHLDrIf7etHqeqbPvDNSwMzzjLFCU7QxuIW4KVhkGPtFROjfUS40rrLfp85y3PmCV5Ljfq7mxxN3QogNWhheSdMKmDPsM+oX3ZvXj32anSD9HTDEkOIIEGLPplhwgR60R6vuOFdZl3StmfWvzaXSdsYIMKe+R4GXoeAHbVrV3TvuAF+OXy/Wox3VFHpuAVzuOe
 itRcV2c1
 vQ8cyiy94/4DrgfWYjglLQAMezUkD1BZhVEGrnie4ia5bVZhnjk67fftcx/5gL6yWf8xffV/SERdbzfdRMb+E9yxhkiDVQwNzPtrWFBGgonNfHKIfXuB4J/wLbsL5oH/4G0I2kkGBXSj7I9hQXB8YvPe73mw3Rb18oQNkyXoHKY0yJ6CIqIuyUXIaJ52rf9r7S7OH2qWkZknJsBIEtF/Ed50dImIaTo27DPWIfyX8mDh3xj01PQRR8wiU9JdYXxmsZQ0RLuUS5vi+ULygu9wDbHn/FnoVY8wit1qRuuQ99admX+Jv1sod2re+vLYYhiPdrdyuZp34MyPAnV2NBjRfyhgRELaWKwGgPFU1m+OmPNjdcsLAts2uYmkrk4lwmocnV35sjiKrxoJGdoUkf0UXBSregRj8yVsTpZZRz1d4Q+OQKd25nKE+ECkH6bJIPFhCwCFivDk+IGZg8dU0bEYQljqwYVBoWg7ZFbBKMOjsfKoGGabPWpZo9ZCDZxME49UwugL4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There are three sites which all check the watermark that kswapd reclaims
zones up to, which is the promo watermark when NUMA balancing memory
tiering is enabled, and the high watermark otherwise.

Consolidate the patern into a helper function. While at it, remove the
include for <linux/sched/sysctl.h> in mm/page_alloc.c now that the
dependency on sysctl_numa_balancing_mode has been abstracted into
vmscan code.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/internal.h   |  1 +
 mm/page_alloc.c |  6 +-----
 mm/vmscan.c     | 22 +++++++++++++---------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce485..8beb5b263ca1f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -68,6 +68,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 				gfp_t gfp_mask, const nodemask_t *mask);
 unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 			      int zone_idx);
+unsigned long kswapd_wmark_pages(const struct zone *zone);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2fe49f3c0de13..6d6da844f4b76 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -45,7 +45,6 @@
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/sysctl.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
 #include <linux/memcontrol.h>
@@ -3801,10 +3800,7 @@ static bool should_skip_kswapd_zone(struct zone *zone, unsigned int order,
 	if (waitqueue_active(&zone->zone_pgdat->kswapd_wait))
 		return false;
 
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		mark = promo_wmark_pages(zone);
-	else
-		mark = high_wmark_pages(zone);
+	mark = kswapd_wmark_pages(zone);
 	return !zone_watermark_fast(zone, order, mark, ac->highest_zoneidx, 0);
 }
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..9af50783fc824 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -478,6 +478,17 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	return size;
 }
 
+/*
+ * The watermark kswapd reclaims zones up to. With NUMA balancing memory
+ * tiering, kswapd keeps room above the high watermark for promotions.
+ */
+unsigned long kswapd_wmark_pages(const struct zone *zone)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return promo_wmark_pages(zone);
+	return high_wmark_pages(zone);
+}
+
 static unsigned long drop_slab_node(int nid)
 {
 	unsigned long freed = 0;
@@ -5212,7 +5223,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 {
 	int i;
-	enum zone_watermarks mark;
 
 	if (unlikely(sc->proactive && signal_pending(current)))
 		return true;
@@ -5224,12 +5234,9 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
-
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
-		unsigned long size = wmark_pages(zone, mark) + MIN_LRU_BATCH;
+		unsigned long size = kswapd_wmark_pages(zone) + MIN_LRU_BATCH;
 
 		if (managed_zone(zone) && !zone_watermark_ok(zone, 0, size, sc->reclaim_idx, 0))
 			return false;
@@ -7131,10 +7138,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-			mark = promo_wmark_pages(zone);
-		else
-			mark = high_wmark_pages(zone);
+		mark = kswapd_wmark_pages(zone);
 
 		/*
 		 * In defrag_mode, watermarks must be met in whole
-- 
2.53.1-Meta


