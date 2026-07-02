Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E7EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140FD6B019D; Thu,  2 Jul 2026 21:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118326B019F; Thu,  2 Jul 2026 21:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EB06B01A0; Thu,  2 Jul 2026 21:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB8B66B019D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:16:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF6731C1BAC
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:11:01 +0000 (UTC)
X-FDA: 84944627922.05.52D4190
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf31.hostedemail.com (Postfix) with ESMTP id EF59B20007
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 18:10:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=YB5X2Vqj;
	spf=pass (imf31.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783015860;
	b=uoBuPjGHWw2MwZ3gtu9pGGvfDGVKM2lgWKxIst7CDqd+d6/7F9eS/gP5KFEXzMGLkrYTmZ
	4FY9Cnfx2IobPPk6j20L/wERIh+VTqcYH+rVZbehQCqynsgQaQGWCY1NLB850Gv/I8NsUg
	Va4XbyyESQV/HAusKYLPoZev6BCrUwQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783015860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pPFAHPxSzUNPu9IZC6QtURWk5+bIEf2CeYJZBVADvKs=;
	b=CVRz/nBcldiNEuHbOPJCLw555MotzRPBRpQrhF26gJxSXO9GYi7I877dbdZvvct4sjlQqX
	7m+eMiXDUWsLrTxQwae6KEc/tylowyebzqkTnT97EAODlWlubIlzW/oAdaiRYAViTJm69Z
	KWTMiK3Y0Zu7OmMrRXG+cXzXLIHAHA8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=YB5X2Vqj;
	spf=pass (imf31.hostedemail.com: domain of yunzhao@cloudflare.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=yunzhao@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c7c61b5292so25228335ad.0
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 11:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1783015859; x=1783620659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pPFAHPxSzUNPu9IZC6QtURWk5+bIEf2CeYJZBVADvKs=;
        b=YB5X2VqjuNpIOVDuPqIrclKoai3R87RI7fxV0BYfRIxXPSG8ykIWnKMjA9B/HIw2Ap
         Bg345GusqbbgOaHL6ozdQm430JgTJU1ibnquqnlqf0/9tW7ze0erqCqcjFjnYqxusqkj
         3uMu1VEtG6MWOQgw1630s7tNlXbrqvnMXYUre3qFTZhiJnBRBw9hWfazUYvTvNLpoHxg
         fy4X92Gs/dzv023tM3nu68CGlOYMzeY8S0/kQyzc43zIvI+jx/UxE6+Y+wZKuBFx8goQ
         Oxk1UREfOazbFiIR+LlBcFVdyKSLzAwRXPmVXrtTg8dUWQ7SzRmmDWeJta2KvMbna5lO
         rjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783015859; x=1783620659;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPFAHPxSzUNPu9IZC6QtURWk5+bIEf2CeYJZBVADvKs=;
        b=YoRiN6I0reZFLRKPy4nCWwd0Tmdvy4Mp1i3I3ogPxgR6kp8ZuN13hJWzwLrie5buaq
         R8VeLUdGuDisTC/KdXT05mVVzfNfsuVve23KlT8cRaY+f6FzDm8HCrPmMKX4TcO9/Xcd
         hojTSdbxCiv4pQrS+R8fypppJ/YHVFOz5cwIQcSvEGEw9W8ohq4Q7GOGM70e3QayycAn
         bZ2hOknsuzCDpe04MoZqow54P6lrECpm5CuAMwaHRWjPWOrlvFbAcCdPBA0XBxe8cwsM
         M9TDJPQEB08F0SWMHocJX5Id2RGfcTOO/zy/03czMTByufS/3/1cBtMibE6ffj2G90Oo
         IOyw==
X-Gm-Message-State: AOJu0Yy9BIcsrv2VdPVw7VF1By81uLfDfGKl2HPhbHhKLyNEi06xPFyh
	7vPTLoh4nOqrAW4VXaDvWtIGX1iA2/1w+70A9QVzKfGWwPvlIB0heT+8oPQpvnsP/DW0V9BJm+m
	RFrWRnpo=
X-Gm-Gg: AfdE7cleORAqFAqWJfY6BIqUaI/bqpBoYNdTNawr1y0xPVlJsKb0LzycTxHC55Pa7nz
	pYJLi2jhZJ9Q4zTDlchBgghbvjYuNaNvUpr/rgq2ZeIR5X3YFOJwvxelednl4HKIsQJdg/gIpsa
	dfuuNG15sOSqWTBma/PpsQ52g0BGzsd/raMjwpGkngGp2ecmt65lWOhNBGR2G4Jo67gLDu3wk2W
	z9v4UC+9CaQVrFeXqpg2j4pqelPtG/MCTYz4VkiwF/66P4Q4ry7vjCH+98/sbVf5y91ygVbvpCR
	NqKTYtvSS9UWFgACrdWr4WO5G6MIeI1pfCo/fKdlJ7PtjzW7hoMJD46BIDvirdcmES2PNqN5hSZ
	IGtFx8RwgqnpceDPyQOYFaKPZLC8OfJD3dqDONX8PN3wl9p62CDzEYmjQJUedyl6McqFb5Mb3xQ
	6IYB2k
X-Received: by 2002:a17:903:24d:b0:2ca:4cfd:a6ea with SMTP id d9443c01a7336-2ca91140f99mr60889225ad.16.1783015858755;
        Thu, 02 Jul 2026 11:10:58 -0700 (PDT)
Received: from 9YNJRV3.lan ([2a09:bac6:cad7:154b::21f:104])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca9a9f6abesm17168605ad.65.2026.07.02.11.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 11:10:58 -0700 (PDT)
From: Yunzhao Li <yunzhao@cloudflare.com>
To: linux-mm@kvack.org
Cc: nphamcs@gmail.com,
	yosryahmed@google.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	hawk@kernel.org,
	akpm@linux-foundation.org,
	zhouchengming@bytedance.com,
	Yunzhao Li <yunzhao@cloudflare.com>
Subject: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
Date: Thu,  2 Jul 2026 11:07:35 -0700
Message-ID: <20260702180908.150136-1-yunzhao@cloudflare.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: payw4d7tc9t99imfhi6zc3okueijgukr
X-Rspam-User: 
X-Rspamd-Queue-Id: EF59B20007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783015859-245619
X-HE-Meta: U2FsdGVkX18ey7+IBLls1PSMtD/IKQ8E19yPw0u/k/1GZ+elrUL4SVEdo1ZN9Xij5Q3Pz8svbEBO+OTygqr1n4isByP7pnuyLJYxDmsi5nIR8oqcFawoVXWKVrnFgxosNTSN7OMAmDbo/qV/K+NZdRSlCkjrTdYhEEnQhqb8pjwLwFLToVlOBOk3BH/lAL4rj9ydl9wzd6MSaA+ci7tSFc0HS+JP3w+zm2p688TwIWuwrKoLu/8dHuAhskMkBf1A9ICmeNb/O9Aih009N19tJpZoOHh25WSxkT0JgbKCmZ2onsLHEGs/JmBTfa+CWZyR8BWMQboZUk1GwqX5RZ5fh7iii10W+7A+jZd7mKCc5dRKfutKRVe6QUt2nJ9qS0xOCUzPW6+2OWY68FqF8x1f7VZGgn5cmhNAqIfb8ZgdEgpdUdgD2oARDoqtj4EwQy9rIK63EsxtrkyEJTsQdhxgpmuQcEGXb04tLrD4ZFiGVF08ZiqSX5ZNYa2K9MGulbkvBZmAd/g3WMWPUSK/mt6Krg1K/vituLNgisKFB1m/brzGCbugpMNIlboxVbzESxIG/kyAiSdl+tMaskaw++CxoKTYHI1ZIh6nFFwszYTpotWRkVPxOXvYcWGuATUkeVSj67YpOO0L8dta650DoG8z0DH8DQEiJbDduvurOuK5szdxLYasJavwNkMG6D5w1T1e9VlHwPBgFPORlFkZj3oRETk40pJsMM158709yOd5mIBYDr+MWtxw2nAFuTZ8VUJbpIrrmpURXo/PLQewzqoQMHsTnkRxhSOyMupCsbPouo/JeE6MLA9vRTak5xt7z9eHdVnNAxUJMSpiKjemVuKTHnlfDpzWywRGEpQ/8t99mL8ZRvT4Hv93B1jfSx/r+3jvYoBku2D5dFkKcV7rHuwdF1XbEDT0iQS3bKnOG8IipfuJtUo2bjMOOiEwPsMWs3DkTYyNCEjPLlyQ9I/8rQy
 +4Bb9Zcp
 FEikeUPNP3J7DLeBjOKflUCm8Dtak0H1hOXVGJ3A9tkmlHUHCGTgDou5B68mWvHky3erRS01TjJeYo9iGujrFOXZiMRcF9kBkge4UM56VzoRm5YI/w9q/Hs/vvTAzv7oLI5aLeFN1hYfP+09qtngcvsL/u/HBkRBfyceestSqONUlN2sDyoFn56GtaCOdWf2PHf1LRsGZ9iirFN9pYCnJKLDMinypPWS1XzrdjAXcc+nBMP+fL6jthy9gWPVfHE3VrzIJWtBF/NM/lmdrN9+VB8ln1oXpcIisxBV5ceDISlo+78bsPi8FZ8f6ZhDDu+4oDjKXZ3/W5Sa4kMN85t6mBb26lNZRCuvSSJ4I6Qqhr1VtGWnJvU0wGoyvxySY0YwMwIzvlZTojhZnUCuBypmtR1sQoqw0flwwBtHjIOK0Isd8L4DdP3SMgAqwsabGBcqEGm7vDEKuDnYRw+XUUmfzbyHR0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap_shrinker_count() calls mem_cgroup_flush_stats(), which takes the
global cgroup rstat lock synchronously. On machines with many CPUs and
NUMA nodes, this creates severe lock contention in the kswapd reclaim
path:

  - Multiple kswapd threads (one per NUMA node) run concurrently.
  - do_shrink_slab() invokes zswap_shrinker_count() for each
    memcg-aware shrinker pass.
  - Each call flushes the full cgroup rstat hierarchy under the global
    lock.

On AMD EPYC 9684X machines (96 cores, 192 threads, 12 NUMA nodes)
running production workloads with zswap enabled, perf shows 2.88% of
kernel cycles in osq_lock contention from this path:

     2.88%  [k] osq_lock
              --__mutex_lock.constprop.0
                  --__cgroup_rstat_lock
                      --cgroup_rstat_flush_locked
                          --cgroup_rstat_flush
                              --zswap_shrinker_count
                                  do_shrink_slab
                                  shrink_slab
                                  shrink_node
                                  balance_pgdat
                                  kswapd

84% of kswapd kernel cycles are spent in
shrink_slab -> zswap_shrinker_count -> cgroup_rstat_flush, not in actual
page reclaim (shrink_lruvec).

Controlled A/B on identical hardware and workload:

  shrinker=Y: 2.88% osq_lock, memory PSI 1.58%
  shrinker=N: 0.00% osq_lock, memory PSI 0.57%

eBPF-based rstat lock wait measurement across 8 production metals
confirms the contention splits cleanly along shrinker enablement:

  shrinker=Y: 50-250x more contended lock acquisitions (248/s vs 1.1/s)
  shrinker=N: baseline lock wait (0.0017 s/s vs 1.04 s/s)

zswap_shrinker_count() only produces a heuristic estimate, scaled by
compression ratio via mult_frac(). The actual writeback happens in
zswap_shrinker_scan(). Slightly stale stats are acceptable here.

Switch to mem_cgroup_flush_stats_ratelimited(), which only flushes if
the periodic 2-second flusher is one full cycle late. This matches the
approach already used in prepare_scan_control() (mm/vmscan.c) for the
same reclaim path.

After applying this patch, rstat flush latency and lock wait time on
shrinker=Y machines dropped to the same level as shrinker=N controls,
while the zswap shrinker continues to function (pool size remains
bounded under the max_pool_percent cap).

Previously discussed:
  - Chengming Zhou (Dec 2023): rstat contention from
    zswap_shrinker_count [1]
  - Shakeel Butt (Aug 2024): zswap_shrinker_count still uses sync
    flush [2]
  - Yosry Ahmed (Aug 2024): suggested eliminating in-kernel
    flushers [3]
  - Jesper Dangaard Brouer (Sep 2024): cgroup/rstat V11 patch [4]

[1] https://lore.kernel.org/linux-mm/20231206103935.3440502-1-zhouchengming@bytedance.com/
[2] https://lore.kernel.org/linux-mm/CALvZod7LFxLCxVpOFH8b2Ppm8T40HPGMKQwX_=NPCWB_mFW+oQ@mail.gmail.com/
[3] https://lore.kernel.org/linux-mm/CAJD7tkYvFyOSX+rP_FKGBhxvZiCDxtpsNp-c5CGOA-4Bq9oXSg@mail.gmail.com/
[4] https://lore.kernel.org/linux-mm/172616070094.2055617.17676042522679701515.stgit@firesoul/

Suggested-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
Signed-off-by: Yunzhao Li <yunzhao@cloudflare.com>
Tested-by: Yunzhao Li <yunzhao@cloudflare.com>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e..b5a17ea20 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1217,7 +1217,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	 * Without memcg, use the zswap pool-wide metrics.
 	 */
 	if (!mem_cgroup_disabled()) {
-		mem_cgroup_flush_stats(memcg);
+		mem_cgroup_flush_stats_ratelimited(memcg);
 		nr_backing = memcg_page_state(memcg, MEMCG_ZSWAP_B) >> PAGE_SHIFT;
 		nr_stored = memcg_page_state(memcg, MEMCG_ZSWAPPED);
 	} else {
-- 
2.43.0


