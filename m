Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8294CC87FCA
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 03:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A066B007B; Mon, 28 Jul 2025 23:51:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27596B0089; Mon, 28 Jul 2025 23:51:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC006B008A; Mon, 28 Jul 2025 23:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99BC06B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 23:51:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF3C2133D9E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:51:11 +0000 (UTC)
X-FDA: 83715926742.14.AAF80E9
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD895100002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:51:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b="OS/U2AAv";
	dmarc=pass (policy=reject) header.from=fujitsu.com;
	spf=pass (imf05.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753761070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fjw6uBbrXYnB3KYnoz6uoEBDNRfC4XudKhGDGEI9kQs=;
	b=zrVy0WPPa64OpOBhb0Pk/NuRKnOdYg4+XwkzOGniTelqdZYlYoPGH+T2PrtyywsnVtf5z2
	xAq8ThKRg7fOs4m/jRzQJzClHqrx5jVGdnO13Yc7LwY5tN8FjDPd8wBNy1RadF8UGFpXSS
	Fr8mTJ1s9SYUQWMoyJ5CteQEQo7DcFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753761070; a=rsa-sha256;
	cv=none;
	b=Yr0qvnTjs5KAa6bBbiHMPELVjzy5Mxsc8ys3Tn9cr5FGIGdXf27CZqIVqcB0lpg8Ya2/Mm
	TW+yVmGZWdajnzHw0uvaVe2/WmKgqhfj1dpQBxil+CMMLvoqcvOOZ3f4D5BZ3lFy+q617C
	mppBRf78UafM3o/mYt0414Fkqm74v4Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b="OS/U2AAv";
	dmarc=pass (policy=reject) header.from=fujitsu.com;
	spf=pass (imf05.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1753761069; x=1785297069;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=t4dePJYQNi95GjMpjzF3niKU/R6TTc6eXMIeT7hJrSE=;
  b=OS/U2AAvhehRZNOOo3VKHw8BxCLA7CWI+sDCmMPlRw/gVJURAVxIzC7I
   4vaNvXtkzWNiJgVIIB4Mn2ovhrT4JvGIrHOyCKSH+BqjzMfy5yB5la/92
   FI2Ai61sdN3wkPsIrZM/P7+BDJxJ+p2adNUMQorL+NKB8lao1dkrGvEkL
   GkxvwwfT6Hm/z68wOcTwz73l60RUwdint2tYzJgGCoVVYu3+x3PHCqbVR
   b2up/SMOYAFowb98Rux+KCs97UVzBe2VmbX8qUKLol6hkvtxoz7n8MKuj
   rLQqE/4KWglLHXNAtgnaE510stZqds1O8NYAtkw//u/niPvykMk77RxKR
   A==;
X-CSE-ConnectionGUID: jTJZK2s8SHegkHV1uIjVJg==
X-CSE-MsgGUID: 0nJLtqZrQC21bAmSIlC/KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11505"; a="186665724"
X-IronPort-AV: E=Sophos;i="6.16,348,1744038000"; 
   d="scan'208";a="186665724"
Received: from unknown (HELO az2uksmgr2.o.css.fujitsu.com) ([52.151.125.19])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 12:51:08 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgr2.o.css.fujitsu.com (Postfix) with ESMTPS id 3BD878200B1
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:51:08 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id A7E0B860835
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 03:51:07 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 99DC51A0071;
	Tue, 29 Jul 2025 11:51:02 +0800 (CST)
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
	Ben Segall <bsegall@google.com>,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
Date: Tue, 29 Jul 2025 11:51:01 +0800
Message-ID: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD895100002
X-Stat-Signature: xxhdrdtouc3p1rituctcd413q5fq6ser
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753761069-850414
X-HE-Meta: U2FsdGVkX18GJY6Di8szwtj/3OYcoEWV4Ok3HISwiKoZXgJnj3z71Pk42fL6ctrhnOL2FcS4Olnmbobg2aIAt4A0JroXvd5U+EJov6P0RjZcRzAyxdVExFGBv4OQ++ui9snhs7u7pcxus1f5y6tEdw4yvYiGenlHksqBMeLHbrlvfENHMLaqGQ1ftg7jhCQ6Q921fyBTlHGxBlnyI4Z7BimKbRmywt0nDlxpJsAG5GpFsmpS03oJFModGlnuLjpyHXUCCb45us6sbk6CXdNeze7odC2/TLbXx6Aj7fJdzCSBaeXFteemZsFa5x71bw50QL2EwiB5sk+lb4rfi1iIvaEhFKe3wsk/juaCR86EmBXYADDZXw/VyBDNlz1hCoztNFZ6sAJP0DEswYyMKxZZh/2Aaj3i2APcU95jsq0IOfqbaaKbk+/BEpRqU0RwzPFNgruQi2PRCU8bOHKa5G+FbcBS4H4zRYxKBYQmF7Cv+7Uwz7E09KdZzytbwEWU4r2/PXZtoQjl22WoxRig9JyLiaJymlWFnoTW3nh/uBYgkbAZcI/LpVw8/oyXUdi4muAvI118+PKZNvSjftosMlR3TiWm42v92ym2mm6o8r1RWc23gFpFRfOGEtc48BX9888p9ewX51ihG0aWY0QxDYfwPsKiYILdZqX0AfdWCFAyaJjyXpPdbC1PYfdftRk1ciKsDSxdBEiT0juyY8JLUFbTteYlEo1rWPv/pU6C9cg5IkMF8DC+iA/XBK5j2NONZ4jNdbTD+C7TcCsW7c2EfRDBXrnsaBNGiGk2AB29pcsrWcx7inZIRq1YI75KjtWu/fZ6xgGhHgeccCTkT1Zj65k/c8bFdO/AiXfPP52SFZgGP1OPd8Au3y7kL4Bn++qfkVf62jtXGgZpbulPUyuCm+vM4c/iYlcOFzqgJfEXyAjZiwvT9HW7F5ycCu8sFx+3P/4MANSuepvEeJLuymHD8qm
 SU4y/5qm
 Pm0LT4keccomkyCoJT8BDRd0B1pV9I9c06LSG6/NrLGPG4Z0ha9gQqSIaENuyuM+vv6JU2WBKsDuosKOdQJGh8i0Etaqv2mAtHkrYFgiqr1z2GTwl3FiFINf4TJjTjG7hPYmze0HYm5GYM18vmd042YzE6HrwuR0VFPXC3c5fqkxyY/IUWPtoxZAoU6gF8I4WfBo+z6py8U1eyerCP3fTVhaut7d5V4bWK34gUDK4JRslsowpxb9PP2av4wUNMpBDD9oKBtdgqjJatFDBTcZ6c3mhyf802dfUJqTVn90Lfb/HtsY8UwjZ83Y3dJmawYroSvx5yOl6wtJQUJEUR5K9cF3YUU7eUhzCXzCSVdr7B0d0TCIQBLb2dMPKxCEVQIN4EOnefnPlj1SnkNIoaWJWBTnpGtT0U8GEycXB8G2tUFNdSCvgFrSDyJEh9b2fFpQVtV0Wq6NmCJ/FUYekSMj8Uf1texmTjyMg/u7yGXpqr+WqygDCNU59QbpxCiPruvPKB7b9LOsdz+Y8NTyCIf0HAyUn3fTSjxPOxPWSdPF+xmKV/3zDGXya6pmr6M4jzoh2AWY3Uazn94/qazBwwi3HrOWx1Phvi7AzCisnhD5phg4p7r9Q305lIzHm5wUmiCsY66+YjV/wLHzU4k9Y7W3M6WXLOu8SejbaHiKqEjZ3zj4+i/RVNnuqj/zLm5TViHeL/gAvOiDv9CkypC4=
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

To solve this confusing statistics, introduce this PGPROMOTE_CANDIDATE_NRL
to count the missed promotion pages.  And also, not counting these pages
into PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
performance of the promotion rate limit.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
---
Changes since RFC v3:
  1. change the naming of new added stat to PGPROMOTE_CANDIDATE_NRL.
  2. improve the description of the two stats.
---
 include/linux/mmzone.h | 16 +++++++++++++++-
 kernel/sched/fair.c    |  5 +++--
 mm/vmstat.c            |  1 +
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..4345996a7d5a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -230,7 +230,21 @@ enum node_stat_item {
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
index 7a14da5396fb..4022c9c1f346 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1940,11 +1940,13 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
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
 
@@ -1958,8 +1960,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		if (latency >= th)
 			return false;
 
-		return !numa_promotion_rate_limit(pgdat, rate_limit,
-						  folio_nr_pages(folio));
+		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a78d70ddeacd..bb0d2b330dd5 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+	"pgpromote_candidate_nrl",
 #endif
 	"pgdemote_kswapd",
 	"pgdemote_direct",
-- 
2.43.0


