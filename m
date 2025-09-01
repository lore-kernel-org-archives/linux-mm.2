Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F98DCA0FE8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 02:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD906B0007; Sun, 31 Aug 2025 22:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A53C6B000C; Sun, 31 Aug 2025 22:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC656B000D; Sun, 31 Aug 2025 22:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 442576B0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 22:05:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AFDF885A62
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:05:48 +0000 (UTC)
X-FDA: 83839040376.17.6124549
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C62018000A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:05:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=kXVZbkHI;
	spf=pass (imf06.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756692346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkwMikD7vdoG4QRqzBh1h4IiEAAf+m6g9ARGphSbDds=;
	b=VDmwgdHDZXhxw/h79/mBps2lpmK5r2xq97qp0dOxjo1zfpVvTX5XsYNgJyZ2tsH9nl9LxP
	fyoqj1OMbKmmLhEfRbzhnNX3N4zMs7KTPZfxA9FXr7Oe4pip85GIK+YLc8zhZW2n+/3pRH
	ZHwC5apAgxX+JhGCVJnO3DKw4vkrOW0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=kXVZbkHI;
	spf=pass (imf06.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756692346; a=rsa-sha256;
	cv=none;
	b=DCFBp27fOOsleBueKoFQ4014jeNM5Ou1IMRlJzhMNLwn+4lgwh7lfmcyhszPg1MvXVpDwx
	Zo2sXIil+Q0/TdqNMP58tJ3PfUcnHmN22w1PDoJf6JWj09g6T+PAkLVdqhMXfY8nkpsDQX
	5MMyC1XMk+ctY/6Rk7nflJii2Fsd3iU=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1756692346; x=1788228346;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=n1kVlBxB9nyQY/ojhVZA3zpRuBr13yVP8/DwVDm7lxk=;
  b=kXVZbkHIwndEGgl2GS2RwV7ukdqJfvzGx2HzJWWqEiCk8cFRqp16gJaA
   TocTpIch0eAjBsARBlaIjXA/N8Uzb9zRFb7oN2ou/CdzinD0LbqKm1l6J
   rXDB7tvYyvXytcpyomttq/OWlO0bi3l5BvI8nMoFA9iheHTFk4SX/lTK8
   LHca6H1X+5j2yPV1OUa9tEEBunkjt1jDcJ1OrfIOoAcFKNRTp07l5p5ff
   uovihDr56WkBx9TqfvY7/B/LiO7I7t4sLALLkR2jQSn+OZ+zzeGOVJp5s
   MASRKo8bKkvfKooGLD7QdcuLVtTsXyTIUQwMv+6NVIfq0mdsMssMaqSx8
   A==;
X-CSE-ConnectionGUID: 7YdI2qqnTgKh5DN6G4fq1Q==
X-CSE-MsgGUID: pWSsBIi+Speg8j6E7cWtTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="190112817"
X-IronPort-AV: E=Sophos;i="6.18,225,1751209200"; 
   d="scan'208";a="190112817"
Received: from unknown (HELO az2uksmgr1.o.css.fujitsu.com) ([52.151.125.19])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 11:05:45 +0900
Received: from az2uksmgm3.o.css.fujitsu.com (unknown [10.151.22.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgr1.o.css.fujitsu.com (Postfix) with ESMTPS id F152E1C1C702
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:05:44 +0000 (UTC)
Received: from az2nlsmom4.fujitsu.com (az2nlsmom4.o.css.fujitsu.com [10.150.26.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm3.o.css.fujitsu.com (Postfix) with ESMTPS id A9222C01181
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:05:44 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmom4.fujitsu.com (Postfix) with ESMTPS id 2D4052000222;
	Mon,  1 Sep 2025 02:05:42 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 9794A1A0074;
	Mon,  1 Sep 2025 10:05:38 +0800 (CST)
From: Ruan Shiyang <ruansy.fnst@fujitsu.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	lkp@intel.com,
	ying.huang@linux.alibaba.com,
	akpm@linux-foundation.org,
	y-goto@fujitsu.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	mgorman@suse.de,
	vschneid@redhat.com,
	Li Zhijian <lizhijian@fujitsu.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Ben Segall <bsegall@google.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Date: Mon,  1 Sep 2025 10:05:38 +0800
Message-ID: <20250901020538.3960468-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ntq15hzf4t8gnywhripw8sctjudjb71z
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C62018000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756692346-842621
X-HE-Meta: U2FsdGVkX18/WpI2IlrgXaLDJuvvDw7FTn8foe2TOHqKQE5dbmaSETE6kiY+nkG1gTlczdRI1DnkiNKcCQNYRhu7Ucl2SqPkkzu9hTkjv5FQuzg2ieCa0u5FPSdrXMFMRKGbBcRugHN7E4oyz2yD7szmIb5IW1c9IbIW5a8mh1lfZacGzah17PaFk7bWqneyNHhDc0HkXJ0HhihQ2aKF3pSgYV5/RTv7eU96ZSoRoP4KU1Jzc8pNbwmBx7h0fLa+5tl5Pta7f3PKbnWSFq3aBK7mqZYEK1PEhlGFPtISYmq/Rb5n9YuwmKjTHlbOuBVDUN/WDUUDiR1r10MO2C/b/sevadTUex77t9faD9EwbM6lgncHTLJfgAkfEEyaZVjdOvVkuy6TcyxVnQlvupW4sYpuQ/RQd2PwNHebBNhpvKJzKQE8LlQ5DPnvB+zuAdoHavo5QXl4T5hMrS9doYLp4UVRcmI94aEgdHf06TJdD4YBXJMdvgGO2XqdJ3N3TtmkBMDK3lktdj2TYX6AVP5D9vRq4Btcu6RwzfZXkY+7tUT1zNdgDl0UI8K8lJQMtlraZNGz4uNiGChGIuU3FgOJEIK2gPEejYGknzR5Q+YlKgaKIIDPYxc/24HCFor6QlnqcJn1nC9t1aIzUrUy5Asd+VlZ/kqRNAFUUQbX3FaiKD+beIvWfNq/Owdci3aEOpYLr3f7fsSD2spdZUySXsfFefj2Okji1ZoMvYVlpEHDkJ6C5cB2Iu8h5uY68Fp8q/hRMGFItEpkPgsU0Lg0Y03wlRS6W1MarddLVvAq5QtpQGx+RZn1MHo0aCGtQevgx/x0Vu6cJgxVShpwCAeu91t4enryx0AXPqdRHOfBoDZWbxr2asgr8tMZwGEzvu773WG0j/25sZOHoj9NnEeKR33sN1W+eXsXsNZEVQO6AV9pdgp6LdRpirsZSDsGGLBmjYEUr2yxCSQs+WgnGfRfxKi
 ph+poJib
 iw+Oc1++FcdB5him7oy+/qWxDhqecNDy2oU7PCkqR5sDxWWxAD2eGTm2gOT/19XmMwbbbFVbYwxpg8q7ShdqszdYm56qjEyzGUKNLyUxLzRQvV4X5j5jwTVJfl0EMInbuyMJhJqwGQxMKKOTOYl73QmqKd+fUJvCFI6v41yCQBQe7Bi7B2SWeT32KBhqOXt3epkCCrf7WZU5XEQP+LNq7L4/G+nHYxJ8DSntcv8flWQSFafmOl7w6CBDxdatMhrgzoMWvH0V1DBsOuvlwsmlry9rFv21XakTpkSSEQlBYjg6QmbrnybFJFiKgvKraPA77PWQow4/HYTIZZNZD9j88tyL/UT32AbjSFQbw1VLXUv9mRo811P7TWxyG+SmTXkDFyiGagq6lejeRFxVwwVafNlermcDgQhAm7N0C+7dfsL9bPvY0su7RFIzIZaDEmjxopSbWd/v4Fwt1jHlsiDrJlR09GeFf0AOamdO9L+zTSH13QhwCnAuTMqwmi0jN2ylTe1Q4lFf3ROGmSrB9CMVvII71M5Q9IBKr132A+7tdUGyw5NG/5B3GTrm3j2/aWQJSpiq+8oNrKB9M5FqgrpuASk5kydm0RCterqYrxiPV8B9KbZr53ziqHtgq1tBF4S0sACehob1olE1FZHdQXOoqAuA2BAQr6DlUXB5umVFizPLY+RsBCQQfASfXKm03pGkk72UZIXKE80AfWDHDGYczTUYhbADimFX73PbbVkoTm9EA+SM/tLDrbvyIRn+8VTDhUiAr7wV9VZLCUbuhEhUgz6JLX0PeeUXNUhCz5LqSq/Q8t+KCE5O2to066WUBuZeXZICF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Goto-san reported confusing pgpromote statistics where the
pgpromote_success count significantly exceeded pgpromote_candidate.

On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
 # Enable demotion only
 echo 1 > /sys/kernel/mm/numa/demotion_enabled
 numactl -m 0-1 memhog -r200 3500M >/dev/null &
 pid=$!
 sleep 2
 numactl memhog -r100 2500M >/dev/null &
 sleep 10
 kill -9 $pid # terminate the 1st memhog
 # Enable promotion
 echo 2 > /proc/sys/kernel/numa_balancing

After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
$ grep -e pgpromote /proc/vmstat
pgpromote_success 2579
pgpromote_candidate 0

In this scenario, after terminating the first memhog, the conditions for
pgdat_free_space_enough() are quickly met, and triggers promotion.
However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
not in PGPROMOTE_CANDIDATE.

To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
count the missed promotion pages.  And also, not counting these pages into
PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
performance of the promotion rate limit.

Link: https://lkml.kernel.org/r/20250729035101.1601407-1-ruansy.fnst@fujitsu.com
Co-developed-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
Changes since v1:
  1. change Li Zhijian from 'Signed-off-by' to 'Co-developed-by' per Vlastimil.
  2. add Acked-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/mmzone.h | 16 +++++++++++++++-
 kernel/sched/fair.c    |  5 +++--
 mm/vmstat.c            |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..9d3ea9085556 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -234,7 +234,21 @@ enum node_stat_item {
 #endif
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
-	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+	/**
+	 * Candidate pages for promotion based on hint fault latency.  This
+	 * counter is used to control the promotion rate and adjust the hot
+	 * threshold.
+	 */
+	PGPROMOTE_CANDIDATE,
+	/**
+	 * Not rate-limited (NRL) candidate pages for those can be promoted
+	 * without considering hot threshold because of enough free pages in
+	 * fast-tier node.  These promotions bypass the regular hotness checks
+	 * and do NOT influence the promotion rate-limiter or
+	 * threshold-adjustment logic.
+	 * This is for statistics/monitoring purposes.
+	 */
+	PGPROMOTE_CANDIDATE_NRL,
 #endif
 	/* PGDEMOTE_*: pages demoted */
 	PGDEMOTE_KSWAPD,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b173a059315c..82c8d804c54c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1923,11 +1923,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
+		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
 		if (pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
+			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
 			return true;
 		}
 
@@ -1941,8 +1943,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		if (latency >= th)
 			return false;
 
-		return !numa_promotion_rate_limit(pgdat, rate_limit,
-						  folio_nr_pages(folio));
+		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..e74f0b2a1021 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1280,6 +1280,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	[I(PGPROMOTE_SUCCESS)]			= "pgpromote_success",
 	[I(PGPROMOTE_CANDIDATE)]		= "pgpromote_candidate",
+	[I(PGPROMOTE_CANDIDATE_NRL)]		= "pgpromote_candidate_nrl",
 #endif
 	[I(PGDEMOTE_KSWAPD)]			= "pgdemote_kswapd",
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
-- 
2.43.0


