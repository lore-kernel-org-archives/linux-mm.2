Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D7FBCA1013
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564F38E0003; Mon,  8 Sep 2025 06:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C1A8E0001; Mon,  8 Sep 2025 06:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451ED8E0003; Mon,  8 Sep 2025 06:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD3A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:04:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B452B160AB3
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:04:18 +0000 (UTC)
X-FDA: 83865647796.04.3776CE7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id F04AD1A000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:04:16 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H+2EaMJ5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of flyinrm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=flyinrm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757325857; a=rsa-sha256;
	cv=none;
	b=mM/WROCTPCu3OZ0cnvvlT7EsOPQ0EFvU5GdQQmqROSNH7efOnZ8k1EYz8wxpY9Cxcw+sVc
	+wAV1Cb/Cdb84rhJwQaFVyiq5DDEdkP73fYQVwR1Ss+mAbB8oLqxshVnW+w18QPilXWx++
	g2U6KjqmMtF6fDFArbQvIueJ6aUIJWU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=H+2EaMJ5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of flyinrm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=flyinrm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757325857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JspKwq6xlMOVT2wn/868+r3JLwxN6lzk7a1hKsFzoaU=;
	b=yzjKsrhx41ETDYo27ARs5usPZ2J0suok8zLxczfW1zIQB6xuOTd2Tcwu7mOaZFMy8drFIR
	bgJfCNa224GdOP00ZHp6DWtVVr1DB8ZLtrAllhF7+5dQ/3t1AebHzNbPeSEs9ajI3t3DQs
	2yIfOEuHjGKssNfdmSilEXOWBC0XeE4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7725d367d44so408097b3a.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757325856; x=1757930656; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JspKwq6xlMOVT2wn/868+r3JLwxN6lzk7a1hKsFzoaU=;
        b=H+2EaMJ5AkJ4+7Fke14wzXsNGzJh56yKQgwMBz/RqRXEdwUPw5qlGaYx8EnUU7ESLT
         8jBJiIkiSRpDMY7wriCNLQsnov/wwbrPCNKvPzXJKSjdPZRED5lOb0duRLAb2O7cUcpp
         XxQEIeXqiNn0YQvn1fWDSjVCCQQZh/O3yaoJq9mbRrRvY07mUIziD7K90hPaUBuTYyWh
         2sy193mZrDPLYSvnlC3iiANI6v59+BcCkKKzmRQlp1rf/i5e6dkAxn4C9Vg3EMeK3c2o
         U1349vRCf+AzvqcqwQ7r4TdpGtJqEoI6mWYf4otWqN150/23EdYbwCpjICqg+DLzEdCi
         gzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757325856; x=1757930656;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JspKwq6xlMOVT2wn/868+r3JLwxN6lzk7a1hKsFzoaU=;
        b=jOecFPl40JrBz4HrCb9gxlfx/LMqfnhWLpdyFwDoEBdI8ql3mLLnusTu9al5pgpmNP
         PvKjj5C6jLYqi+V2//yKokx8EG2QkPnkSAI1l5OG3XuSwCmWlKk4YrGsrrORE5xUBH8A
         uG8XRVgDUy6ZDp5kDBZtGxFR5hQ1rM4qk9mr8kf6Tjmcgar3sezrfJEE+KtB9inK2de8
         02YAjnGNLXvNZGX8UKrDt+ktS5NDfNjlzDjXc5q3N5OnDoYuTorDBnakvOEJaKDUVYh/
         iGdkRaj7qkXy10igeuQJAXdeotNPVKxmU55lTdgeEmD8NH43dwckekGd+E/gaAVDpVcU
         9LaA==
X-Gm-Message-State: AOJu0Yxbskh9yd2naNwM+u5qlKSYCrw78Y0lDwkSZzEqLsjVi0DZ+m6J
	4O5RjJpjvToUAhI2tNj+zQy7Y0fqLbgrsESauP4d80mrc1+1JSNuKmFF
X-Gm-Gg: ASbGncv24iQsJjUw0iOGNUsK9XMvvGouaWSGF+UyY0Y/SZPQtnHb7bWH8Ffy4wg7fhu
	8r1o9U4u07S1/ZHuTkssVF1bFJdp77k71lFJFnXAkKgOA16MELIy6KZooKmnu1z/7WSkpbNmVBu
	wZ3+BCmG1qP7Rkuiob+p2PihGeqKTkPUiHXX8bAxzQbJv9uT0LyKFIfS6Zf24pGlhBj1t7UCxkC
	FvqREPcAd+0cy7G/cGiVpOMI4cQJgwYVFyLNxDhhnrx8CS+5Uk5GhEc/+vjVID3yTeO12Xe5vwg
	eXgkM3rZcD9KMDh9eCJdFkN4NFtcKjmOCboy9mxaoNtBWM0IjfqxO2dguXuHCHXNWGqaXS1hNSR
	LEWV/keu6xFJBHlb7NPPACwIvR7lkSA==
X-Google-Smtp-Source: AGHT+IGpbsRm4gpTKuncaeM+adwFbGp9mwK+cNXTZVo6TmiguOksGzlU/8b3HMiz0iYEBD4vLPbV1w==
X-Received: by 2002:a05:6a00:17a7:b0:771:f892:719d with SMTP id d2e1a72fcca58-7742deaeaaamr5109046b3a.7.1757325855349;
        Mon, 08 Sep 2025 03:04:15 -0700 (PDT)
Received: from pcw-MS-7D22 ([115.145.175.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-772517906a8sm23110454b3a.96.2025.09.08.03.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 03:04:15 -0700 (PDT)
Date: Mon, 8 Sep 2025 19:04:10 +0900
From: Chanwon Park <flyinrm@gmail.com>
To: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, david@redhat.com, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, flyinrm@gmail.com
Subject: [PATCH] mm: re-enable kswapd when memory pressure subsides or
 demotion is toggled
Message-ID: <aL6qGi69jWXfPc4D@pcw-MS-7D22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: F04AD1A000A
X-Stat-Signature: fexa5y4zqhyt5jhz6nwotuo5cyk6ycfc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757325856-87430
X-HE-Meta: U2FsdGVkX1/Ei5rO5dhz5XlWSNhm5h2tBGhwQVL3DnPxnrf/YxtxEY9MyS+SaXEqaEJBR2vhN3XebjObG6DXRQfyi/qZG8Nr4qBPuv0JrmSVbQAqfSfeZfrcmw/nA6TRtxvuBGO+KInR7Z8qk1k7BEkCB5vs5gOu3JvbjyZ8GGwMjRK97C5dzi0NJaE315sG2arBp48a7j1CN1rTLSS75WuDTsUhmI9WIoLzABxD6e5pkF7lZBnPkP9ewohjvPsa+2iEnLEUp3lze6lsb73Wvfj+duZkx76TSecsMgB9uoYtuI5211TN8gkblnT6xlE5f3Ab233anEASjZMD1U6GDRBEmKoahMqXoeWoHy8gJX1GMkDu6hkIABh2IUkf9aE8ROKyWkWr2ohZIkSCK+MP9FT3M6iaphtMepNHRyOWGIgGxw17FJXcfqfGHziveFIXon1E4hRAdHPgWFVhPxSC6ilIeFrSyNR/7evHFF5gIGrCIBqa42E2P/MzVWecri6hPFquYIwe1TENcvyhrP62Wi7MSXJ0l8sbOS1bH5FfJ5ZMExNWbQJyO8HyKRfRksrfpt2jtSK1buxHkI1z7xYo1N59lV1ryMY7O+cear3fAS/sE6f+KP3yGPXdFs3/VzWANcnAwy3tbOQGra2WirrSnop9qWrMiAA5tZ7vyiaqkXZJFH0gHCSyX+P8Q4ECvKMA32ABE/bDVl9vPPguJBof8YMJME6FQoU5tpqEhtdbF4nLAB+q+VmkPwZr/NOqgT2pq82wXlU95eRRbgmcaHZTvMerivZarU0xj/99p4LzeefZNwzewCvuTlawRRzA7+RhGQABUeVVNblzdgU5r67AuztkfEkNHm0TrH0G173kribaRhTM335rwROC12ufH5y8s+SKVb9at/RU4Q1nKKXhtlBed12RgtBgQR1rUquOKfSg3P16rhcc8UwGDqoNAl+iiDCw8O07dW5fscCqH3D
 X112T3EJ
 oAqcF8gsuJgal0gsCYHrYvjZNyYjHBTtn/cADM2H2lf/3TaGYg5K3nu/aO28iSneijh54gqOTLjEp1g5q7E5HhT3fbu1M4okOvaHWpnauRWtqLKeeojZ43PKgoHypCLW2Q0reB47zwKcpQ4ttT7U6AU3I82kd0hdGanwNLICh/wnX448COwWExEQ/We3LgVb5WFHmZShp8SWYRADOrWE3fdYKskSdd6ugmzbqHYqQ9xOmgx9YJafY7gFCI2pe7rVIfpnqdFNDQBUI35GPStQKU7iIpGHsaftoqI6GfIkGK6H9jEpPkNKJwgUiA6qNgRjsu+b1X0Wgtn2k8uKnjnkxeXmrXJVVLJsS9aCdaRriYWbXO8krroDEljW/c1ABp0sJCh2DgGm3JuO23vv6KM4u4ANMUKJzLWYUxKUvI6w4c4Qjq39gNyB86ZXraTC3BE3RPi9k+bQNKglmiqaVN8htFY3mxhkn6w2iLeLgRFKeTEu681sR5PBs10k2iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If kswapd fails to reclaim pages from a node MAX_RECLAIM_RETRIES in a
row, kswapd on that node gets disabled. That is, the system won't wakeup
kswapd for that node until page reclamation is observed at least once.
That reclamation is mostly done by direct reclaim, which in turn enables
kswapd back.

However, on systems with CXL memory nodes, workloads with high anon page
usage can disable kswapd indefinitely, without triggering direct
reclaim. This can be reproduced with following steps:

   numa node 0   (32GB memory, 48 CPUs)
   numa node 2~5 (512GB CXL memory, 128GB each)
   (numa node 1 is disabled)
   swap space 8GB

   1) Set /sys/kernel/mm/demotion_enabled to 0.
   2) Set /proc/sys/kernel/numa_balancing to 0.
   3) Run a process that allocates and random accesses 500GB of anon
      pages.
   4) Let the process exit normally.

During 3), free memory on node 0 gets lower than low watermark, and
kswapd runs and depletes swap space. Then, kswapd fails consecutively
and gets disabled. Allocation afterwards happens on CXL memory, so node
0 never gains more memory pressure to trigger direct reclaim.

After 4), kswapd on node 0 remains disabled, and tasks running on that
node are unable to swap. If you turn on NUMA_BALANCING_MEMORY_TIERING
and demotion now, it won't work properly since kswapd is disabled.

To mitigate this problem, reset kswapd_failures to 0 on following
conditions:

   a) ZONE_BELOW_HIGH bit of a zone in hopeless node with a fallback
      memory node gets cleared.
   b) demotion_enabled is changed from false to true.

Rationale for a):
   ZONE_BELOW_HIGH bit being cleared might be a sign that the node may
   be reclaimable afterwards. This won't help much if the memory-hungry
   process keeps running without freeing anything, but at least the node
   will go back to reclaimable state when the process exits.

Rationale for b):
   When demotion_enabled is false, kswapd can only reclaim anon pages by
   swapping them out to swap space. If demotion_enabled is turned on,
   kswapd can demote anon pages to another node for reclaiming. So, the
   original failure count for determining reclaimability is no longer
   valid.

Since kswapd_failures resets may be missed by ++ operation, it is
changed from int to atomic_t.

Signed-off-by: Chanwon Park <flyinrm@gmail.com>
---
 include/linux/mmzone.h |  2 +-
 mm/memory-tiers.c      | 12 ++++++++++++
 mm/page_alloc.c        | 17 ++++++++++++++++-
 mm/show_mem.c          |  3 ++-
 mm/vmscan.c            | 14 +++++++-------
 mm/vmstat.c            |  2 +-
 6 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..68db1dbf375d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1411,7 +1411,7 @@ typedef struct pglist_data {
 	int kswapd_order;
 	enum zone_type kswapd_highest_zoneidx;
 
-	int kswapd_failures;		/* Number of 'reclaimed == 0' runs */
+	atomic_t kswapd_failures;	/* Number of 'reclaimed == 0' runs */
 
 #ifdef CONFIG_COMPACTION
 	int kcompactd_max_order;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index fc14fe53e9b7..f8f8f66fc4c0 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -949,11 +949,23 @@ static ssize_t demotion_enabled_store(struct kobject *kobj,
 				      const char *buf, size_t count)
 {
 	ssize_t ret;
+	bool before = numa_demotion_enabled;
 
 	ret = kstrtobool(buf, &numa_demotion_enabled);
 	if (ret)
 		return ret;
 
+	/*
+	 * Reset kswapd_failures statistics. They may no longer be
+	 * valid since the policy for kswapd has changed.
+	 */
+	if (before == false && numa_demotion_enabled == true) {
+		struct pglist_data *pgdat;
+
+		for_each_online_pgdat(pgdat)
+			atomic_set(&pgdat->kswapd_failures, 0);
+	}
+
 	return count;
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2ef3c07266b3..827c9a949987 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2681,8 +2681,23 @@ static void free_frozen_page_commit(struct zone *zone,
 				   pcp, pindex);
 		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
-				      ZONE_MOVABLE, 0))
+				      ZONE_MOVABLE, 0)) {
+			struct pglist_data *pgdat = zone->zone_pgdat;
 			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+			/*
+			 * Assume that memory pressure on this node is gone
+			 * and may be in a reclaimable state. If a memory
+			 * fallback node exists, direct reclaim may not have
+			 * been triggered, leaving 'hopeless node' stay in
+			 * that state for a while. Let kswapd work again by
+			 * resetting kswapd_failures.
+			 */
+			if (atomic_read(&pgdat->kswapd_failures)
+			    >= MAX_RECLAIM_RETRIES &&
+			    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
+				atomic_set(&pgdat->kswapd_failures, 0);
+		}
 	}
 }
 
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 0cf8bf5d832d..18b3b32a9ccf 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -280,7 +280,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 #endif
 			K(node_page_state(pgdat, NR_PAGETABLE)),
 			K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
-			str_yes_no(pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES),
+			str_yes_no(atomic_read(&pgdat->kswapd_failures)
+				   >= MAX_RECLAIM_RETRIES),
 			K(node_page_state(pgdat, NR_BALLOON_PAGES)));
 	}
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 424412680cfc..e09d69b1f873 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -526,7 +526,7 @@ static bool skip_throttle_noprogress(pg_data_t *pgdat)
 	 * If kswapd is disabled, reschedule if necessary but do not
 	 * throttle as the system is likely near OOM.
 	 */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	/*
@@ -5093,7 +5093,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		pgdat->kswapd_failures = 0;
+		atomic_set(&pgdat->kswapd_failures, 0);
 }
 
 /******************************************************************************
@@ -6167,7 +6167,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		pgdat->kswapd_failures = 0;
+		atomic_set(&pgdat->kswapd_failures, 0);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -6479,7 +6479,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
 	int i;
 	bool wmark_ok;
 
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	for_each_managed_zone_pgdat(zone, pgdat, i, ZONE_NORMAL) {
@@ -6880,7 +6880,7 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order,
 		wake_up_all(&pgdat->pfmemalloc_wait);
 
 	/* Hopeless node, leave it to direct reclaim */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES)
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES)
 		return true;
 
 	if (pgdat_balanced(pgdat, order, highest_zoneidx)) {
@@ -7148,7 +7148,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 	}
 
 	if (!sc.nr_reclaimed)
-		pgdat->kswapd_failures++;
+		atomic_inc(&pgdat->kswapd_failures);
 
 out:
 	clear_reclaim_active(pgdat, highest_zoneidx);
@@ -7407,7 +7407,7 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 		return;
 
 	/* Hopeless node, leave it to direct reclaim if possible */
-	if (pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES ||
+	if (atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES ||
 	    (pgdat_balanced(pgdat, order, highest_zoneidx) &&
 	     !pgdat_watermark_boosted(pgdat, highest_zoneidx))) {
 		/*
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a78d70ddeacd..3c0ea637ed85 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1826,7 +1826,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
 	seq_printf(m,
 		   "\n  node_unreclaimable:  %u"
 		   "\n  start_pfn:           %lu",
-		   pgdat->kswapd_failures >= MAX_RECLAIM_RETRIES,
+		   atomic_read(&pgdat->kswapd_failures) >= MAX_RECLAIM_RETRIES,
 		   zone->zone_start_pfn);
 	seq_putc(m, '\n');
 }
-- 
2.34.1


