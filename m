Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417A2CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E038E001E; Mon,  1 Sep 2025 05:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937868E0010; Mon,  1 Sep 2025 05:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8270A8E001E; Mon,  1 Sep 2025 05:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 69C5B8E0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:01:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08E21160732
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:01:33 +0000 (UTC)
X-FDA: 83840088066.18.EAD7AED
Received: from esa12.hc1455-7.c3s2.iphmx.com (esa12.hc1455-7.c3s2.iphmx.com [139.138.37.100])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9377840003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:01:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=EWd7l56v;
	spf=pass (imf17.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756717291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mWtLVKvBMoQSA7NcVLCjga3UpzQqTq3480ME8VMx+0=;
	b=bV297qhQyjObT6znpHKdA4+IE+WHVYTwcEvNi1bi8tnjG0E4hjl/nzO7PgPH2qqGwGpY+x
	KnZPqxsKNQHCO/LhvDjbtjunmOOwgZZjh53FBXNq3xNYRpK18SEbW9BngkLAi9Xj/ZwMOE
	MfFuc08D45th6taDl9iiq0ZvBZVkwMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756717291; a=rsa-sha256;
	cv=none;
	b=XT+hxNsxRLrMjF9WArDLsWJp99Yoc07y2qSyPuFfw9tFwESKGUpwzLn256gvKQ6awjpxOi
	Q7xuJSGj1A16uXsg/uaGtQKBU9i6yBbwpEyqHKuYMD+XStmlOiXxGjhWIayy463Hn9mM34
	Dor/jRj0fGarAQW64Bs+ASbBGL9G4u4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=EWd7l56v;
	spf=pass (imf17.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 139.138.37.100 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1756717290; x=1788253290;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DmveVU/MnaZyGYU+Kvug6KJv7C/KbcI9vz1rPmmlMYc=;
  b=EWd7l56vqh/MJnYwIbY6e3bXN5vluB7KmqIEbb4+3vpcEIDY1pvswmmh
   //n5ckAQ+LH6fBy2rINVLz2UxJ22VRB4tNMpAYORp+uNH+6yI/gdu/eSB
   lI0uNY7hFiV9TueacriOEKJMyGZaSKg1CGRy2S+Vc7qo2w8Gl9/VQklt8
   FZRxND/Oa/HMLQ50nVQ3Mxb2igtTraSxRFu1zuGYJW8qf/Hn55tDRCbUR
   elXmHf2rZ4R99+BmnAqLYTPCMuKAYzWUkBY+HG1lB4IwbjHoprPmXdxOV
   4ljPkvZgP1irrOF6jaZYWMs+/BIwCGmjs+wGorTyqFxOPskF9LIeM5nh6
   g==;
X-CSE-ConnectionGUID: YO4+xteoRaGUyT2I+p2geQ==
X-CSE-MsgGUID: KDpMBNj4Q/iPJUb2HLXNtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11539"; a="190167371"
X-IronPort-AV: E=Sophos;i="6.18,225,1751209200"; 
   d="scan'208";a="190167371"
Received: from unknown (HELO az2nlsmgr2.o.css.fujitsu.com) ([51.138.80.169])
  by esa12.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 18:01:29 +0900
Received: from az2nlsmgm2.o.css.fujitsu.com (unknown [10.150.26.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgr2.o.css.fujitsu.com (Postfix) with ESMTPS id 352821554
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:01:29 +0000 (UTC)
Received: from az2uksmom3.o.css.fujitsu.com (az2uksmom3.o.css.fujitsu.com [10.151.22.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm2.o.css.fujitsu.com (Postfix) with ESMTPS id DF91A1C002EF
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:01:28 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom3.o.css.fujitsu.com (Postfix) with ESMTPS id B6A3A10005B6;
	Mon,  1 Sep 2025 09:01:26 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 349431A0071;
	Mon,  1 Sep 2025 17:01:23 +0800 (CST)
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
Subject: [PATCH v3] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
Date: Mon,  1 Sep 2025 17:01:22 +0800
Message-ID: <20250901090122.124262-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9377840003
X-Stat-Signature: ngb1hpigx1bh8m8ihd6fihco6nucs54k
X-Rspam-User: 
X-HE-Tag: 1756717290-927974
X-HE-Meta: U2FsdGVkX1+jbjLqWG5iHwwRuR5MEr0I3lMdLfhUvnobLtObI7l4fMhcvweL4/1+zQvoajS5L8nRROdob89RSUAGXMRKqwHUdKNqdQrG7KZqZ3Wq+vADPrPjHf3GUV52w05tS5FSM2WzjzO+U0bnHml0so2SvxJKe1jiToW8FMgkTiO5Janh519GF5aO8Av8YeWoq0qZsu3BZuAqMK2z4Bq4zop9V2mMipkKp4ASTdJskEY2bvPN4ioFa23qLxncsbJjB1UP7Lesvt6+dR93X6mrCPh76SpC42QvZoe8rPxsoFPDTf75FtgpEdy97i4OZRhwvKiIwm+2RjvDihj83ulbo5ltNwHowPQgsIAAlC9kPg5BK1xoF4N6LMIX+Y58uWEkVwHKcdHFezjr7gz4GZ7AAM7c6rIvYSXkKixyNx5Cc2yNgF31dHOZUuq6n3t6drcL8jABlUg7lrD8EJBnZU3LvZ8iB+6RxF70C5lkYvlaT3adtuLi7Avl7tDDRRy9DmBIFm0/ql8DntF8UPxnfiMds9Txs8srHhWrWZhgO+a96LktJv5HMn3LaqtNW7OUcB6E5sz6r9pNSQ/hd0VRovg0iHs5B7cUSlySuNdLkO30zYSZwQP/sh8+Mo7L/BnZgWG+lp74NO9hFU2uTe1pX0s1mEtol5yaYkQ4rUCRGrSQB3yjFukK9OI00ilzGzb96+1MJsvOGoZgSjIlu5mZFONhQqLUh+DrZQNd0Kgo0tU2MXSM/q2zilR2aj7ZDU/bUuW9iNe7VDOAd0ZB3C1h4mpOwaXlg3EEfQRwX3jYNKzc4kZdeHyRY1h3FOWd1lCLPg/xQu1luGQiwyO52ijDSIo1pmC0QNfZQ1EiiTPlJl6L0UcCoDr72K7Ov1Ua51lmLopVvIBUazks4NGNTnU8Ts2MSFhrz/yLgwTMuJh2Ey8oFqRisk0V3/826onyITQ4z1OgWfiq4qdj5AER4Mg
 728WoyIh
 RX3zwCMndIfiEIdVgzeD+ZMnCPVNd2Mx+r2sHhDC7bf5PWa94axRAsJzJmTVe6N9OC9arKxCI5JeVT1BOrdScKpebMpJ7aZRXf+6y/C+JoNXrSrVVmYVruKmpc/Lds2rY6gMNR/Nxb41jtdWY14+LmRxHbZB7EGp+RUCL3FtllwjkizW9hIVUYbEYHmd/kKapOlNiQs8BCbkSEHem5htbP9dzDnFyDya2EhqH9Xs9m97dRSCfwEXyZyPk6nrcv5qGR61zDqLwLx/9Lrp4yOaZQkxfYERvqeL4pmKeqKV3BgGIIIz1UDFMeA0vIRpgGmH/BhkA3C357x+KPCWkU4K+/KMvqexpRsLA8G7jfP4lFEQEKxld5YRcqzYv2ZviZ6S1OVgRgEBF7zy1l4Mc1SAkgXLhXbHFKEbai2VhMeDcXDy2JRtugjz/JyfMdwe5TXle9lfH7QiRgLxTF0B6a4UvqriWHh209Emw8FZ5lp39Wmr7QDHwC+Ja9yRnhCGpzueurYPwLvDMPEHEWZ3IKxaLKXSR9gJ5AKIv/066+ZUdwt6pLOP8l1Nbg+OfZD9g5fmwiBKcZo0eLSaXSXcW7fw7o3AV47MEayQCZWj4n+nMTmTLhoDz+tk+EiTh9pH0MEmnCaHBuh0yoFEH6qO6gfT9YIjYI3rh58XSbsi1xB7qvAa1jhu8nqWE6BykA6ok2a8F4r4EhbHC7b4n2IN1SZi0BPVIZeuot8S8ibsZHtSKzAcEPT2mubQym4T+iwOVrkYYRRdjuc4MTj3Zfl9yQ0Ql3ypvZ4HSP3FSbU8IcNevwg9zGJqh3L158e83xgrk3WGj6zoL
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
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
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
Changes since v2:
  1. add 'Co-developed-by: Li Zhijian' followed by 'Signed-off-by' per Vlastimil.
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


