Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C7BC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BCE6B008A; Tue, 22 Jul 2025 10:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5656B00AA; Tue, 22 Jul 2025 10:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886A96B00AB; Tue, 22 Jul 2025 10:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E50E6B008A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:17:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10EA916031B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:17:01 +0000 (UTC)
X-FDA: 83692102242.02.B065FE4
Received: from esa3.hc1455-7.c3s2.iphmx.com (esa3.hc1455-7.c3s2.iphmx.com [207.54.90.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0E55D4001A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:16:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=EZ+nMRXs;
	spf=pass (imf17.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 207.54.90.49 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8H+61Ndv2tVaP6RRkPxTxO9DwJsSozK3D+J8iVdgpsQ=;
	b=8DK1ytQSx6HUf0P1lPnNbgA72x5ilOhbOF1TALPmrEjd5foRyssJpAgXgs9tAMQsunCPSy
	5Ma/I20NSm7j5BmQDEschM1y8/7iQuIAO3UaB94RbmUsNc4L4pmTS8bm1lSVbrxb2WAofA
	LLrbnEACgImaNUv+R/8iyGxdMc+Ud18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193818; a=rsa-sha256;
	cv=none;
	b=o32WEzPdzlhYPtYLMdLVlVTflM9H+31H20lJkWYERBXsItpFcc/2AFZ87XQ1pEVfRBxynZ
	2defGt4T3VotyraPzYfCcClk2CTViC0FQRWzhVMvUu4obUxH17etlFLgHY/jewESdp9XcC
	iYkSAj5qjHDlUJIt+Itc0RtINmAUviE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=fujitsu.com header.s=fj2 header.b=EZ+nMRXs;
	spf=pass (imf17.hostedemail.com: domain of ruansy.fnst@fujitsu.com designates 207.54.90.49 as permitted sender) smtp.mailfrom=ruansy.fnst@fujitsu.com;
	dmarc=pass (policy=reject) header.from=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1753193818; x=1784729818;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5dNQ6R20gA18sSDnal2PdhhzzD3NLhbrHgMrNWEtiPg=;
  b=EZ+nMRXsfa/xZmkwq1KEWoieyZZrRRkEB+iTpgw4wH0166CqKSE8asLs
   AR/gDUB+23gNIFKa8ZLLU1j+prOoggU6GSpH5aR1vt/miqGZaAUf6JS8m
   WAl0Mj33IOuGuXS7BAXy6yVUTA0np5v2jS0a8Ip2rWVc2YHJQthevQkX+
   kuiEhz7e7sqvt4dlEec6FBDZjSih8ZvLDs1OTg+cPKFJdWQ2rkhr0H2QY
   /cHeE4RN+tAu5aU8L+sYRqsNUJW4LSSGph/4ggjfZ1Q0W1YJ28PWpL0Ve
   x4H7kAtnkUAXRXvUQyrajAGOzsTLxl7P2aE8/Co9Jm7QTB11BrEkKhvjY
   Q==;
X-CSE-ConnectionGUID: C7ls8r3BRj2BrrGVX7PZCw==
X-CSE-MsgGUID: eJaUxOFIQu6IR4LWPYLP6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="207036139"
X-IronPort-AV: E=Sophos;i="6.16,331,1744038000"; 
   d="scan'208";a="207036139"
Received: from unknown (HELO az2uksmgr2.o.css.fujitsu.com) ([52.151.125.128])
  by esa3.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:16:56 +0900
Received: from az2uksmgm1.o.css.fujitsu.com (unknown [10.151.22.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgr2.o.css.fujitsu.com (Postfix) with ESMTPS id 275C7820405
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:16:56 +0000 (UTC)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 932D68D65E7
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:16:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.167.135.81])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 2C2F11A0071;
	Tue, 22 Jul 2025 22:16:51 +0800 (CST)
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
	Ben Segall <bsegall@google.com>
Subject: [PATCH RFC v3] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
Date: Tue, 22 Jul 2025 22:16:50 +0800
Message-ID: <20250722141650.1821721-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E55D4001A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 33ghqdkk15bymrxrybto1r48ccj7gjkj
X-HE-Tag: 1753193817-260147
X-HE-Meta: U2FsdGVkX18rm2x9gNhiwN85amgSyRBJRKjFHIYyddBcLpejKxuHla9cYlu5blQnXo7ySXHIuZ/dNlnhPFWepIIOUpC/2OgYofQujajaShjZoJhySHpQ1neycR+MIhtBYdAJefc94jEL1IOYLwH8OD0f/4Px6dWIM7NIa143OVL1jP/ioG4x/Ea4OsGvXazpxU+2q+H391gSM2ZL7Bj998YsdTqD5Tw2KLOi7iCB74btHG/xOCLKAia9keslpqMS8LNb6d9KgnLeDAu/lCczlW6sKmNBa3L6MADwZ5RROK3/QdL0rFQtWhw/pcJ5G/IzMLvex9JoF02MSsJ+E4/W+e378M+YD2QxtExLkrffsIRaMrXnC0LK6vB/pIyoxOkrduRE8GXwzjjWorffMI6X25vtwxMrJZnh+lpPZv9/Ujc2L8W8YXHj22u0ugFABr8iElC1RagkiHczDSrPPo5sSoL9If4fqXY2I59c0pPBXb3o0d1yOVHpxQDpFfjyCl9qz0WnBQlwvh6AWQEre6qTg2zy9JoTFlDZ9i0L6xXQOAcQ78z3Ym87nsVAjRT+H+AoO3gOKQ9C1jA8cXf5BcLfMfN75K3U21QD5IqXN8TiC2LPP1Keqpu0pV2wHK7CeJTFlvpPyIyDl/HtWyfpCy2PvT1Qx0Z8gL+PmKuxoyvrprDIuLpEraMDxpYpPqpvrZeBqbEcmSut6nMVQIB6U6nabQvhnjIK81DRZprvtp3vfJvNIZs61f82WRu+eOshBERNag4GPwtHOtOi9gLqNxCZw7ydxjemVsgaKM3WbCXe3A2IIvx9uHlYj6HM9gdNWuKgT4w0zOHGj+7WGfFTRVC/FYktqjt1r9adBzkiZM+53XHc9EEKrQVWq2HE6Ha2hnM8xpyCyBQ5HIqGIXEvPo+2GXAaMrx0gvuOYFpwIEsKS2g/lcxJK8LAjft6SQIVpLKMPEWs9SVGPXf7pttQG01
 RRb2MX5J
 xUTHEQR/LiAF7uh+0Pkk/lLj/aJ5/BzKg1y/eXDJGMG7f8mjxBIbAtD5epg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhijian <lizhijian@fujitsu.com>

===
Changes since v2:
  1. According to Huang's suggestion, add a new stat to not count these
  pages into PGPROMOTE_CANDIDATE, to avoid changing the rate limit
  mechanism.
===

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

To solve this confusing statistics, introduce this
PGPROMOTE_CANDIDATE_NOLIMIT to count the missed promotion pages.  And
also, not counting these pages into PGPROMOTE_CANDIDATE is to avoid
changing the existing algorithm or performance of the promotion rate
limit.

Perhaps PGPROMOTE_CANDIDATE_NOLIMIT is not well named, please comment if
you have a better idea.


Cc: Huang Ying <ying.huang@linux.alibaba.com>
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
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
---
 include/linux/mmzone.h | 2 ++
 kernel/sched/fair.c    | 6 ++++--
 mm/vmstat.c            | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..6216e2eecf3b 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -231,6 +231,8 @@ enum node_stat_item {
 #ifdef CONFIG_NUMA_BALANCING
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	PGPROMOTE_CANDIDATE,	/* candidate pages to promote */
+	PGPROMOTE_CANDIDATE_NOLIMIT,	/* candidate pages without considering
+					 * hot threshold */
 #endif
 	/* PGDEMOTE_*: pages demoted */
 	PGDEMOTE_KSWAPD,
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a14da5396fb..12dac3519c49 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1940,11 +1940,14 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		struct pglist_data *pgdat;
 		unsigned long rate_limit;
 		unsigned int latency, th, def_th;
+		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
 		if (pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
+			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NOLIMIT,
+					    nr);
 			return true;
 		}
 
@@ -1958,8 +1961,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		if (latency >= th)
 			return false;
 
-		return !numa_promotion_rate_limit(pgdat, rate_limit,
-						  folio_nr_pages(folio));
+		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
 	}
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a78d70ddeacd..ca44a2dd5497 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1272,6 +1272,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	"pgpromote_success",
 	"pgpromote_candidate",
+	"pgpromote_candidate_nolimit",
 #endif
 	"pgdemote_kswapd",
 	"pgdemote_direct",
-- 
2.43.0


