Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 245CF606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=KwdzROd7
Received: by kanga.kvack.org (Postfix)
	id 1A5BF6B060B; Wed, 28 Oct 2026 00:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D856B0611; Wed, 28 Oct 2026 00:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 093336B0612; Wed, 28 Oct 2026 00:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8A916B060B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:14:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69466120B39
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:22 +0000 (UTC)
X-FDA: 85370717964.20.4ED37EF
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78D4B140006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:14:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KwdzROd7;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793160860;
	b=PnwBCPiXAJkgobWKuHxc1H5QVhwi+WIiftoVJvTEYJlAhY5sPb+BtmE11np/alfan4/baY
	iUIrKxe/r3e65oOIYqVUp7Dhc7nEF1TC4eYQHB6D28z8wA1H68xN7kbQ1EQgbtenJM0Uw9
	R4aYXTE8ecAE8HjC8p3Jfcz1m0Xj7yg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KwdzROd7;
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793160860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv8Uf76D8g9HHwpLA0JXrynTIbbQnsLJupQzb81VbQk=;
	b=cpiVJwdrA8k64YL6CJH1yHcEjHwWe2ZUZJMZNs22yBqnU9WbRWPfLHrcmMioj2QsstkUCy
	cCZu9cGSVm/yj8KOQHdeMDuVjXT/+f7PYMgAauJNUO33LjGrzBDzCDO/gKCsUr/0ncO6oS
	pdCMfkXIVdHd1LC5/3eOCvawuJiwpEo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793160853; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Kv8Uf76D8g9HHwpLA0JXrynTIbbQnsLJupQzb81VbQk=;
 b=KwdzROd73dvrapoCQxe/K5JjQnGqsV1jX61fAbvNYfxMpoybEctfIusmvR8pbyFCLzJrcz
 4ZE8C20VHAj+Ow3nZi8W7vqc5y0DePDk9TpQxmwR70mFYkRGDKWMW2O+PpJpzZdV1fzH1K
 4b663MjktnnSkjocwwS6muWD42X1buEdt5rkz4Ry2oiGCuTxOXg9kBt9X+poN5l/87PxT2
 GMzgngDymLDMceMc/EkRIPXHHYav06ZPxINLYkhxZ/BgdJsSRJltASfjs60m6u4bIdkXo+
 xA7OgrNL+qwBv1vJQdFaRd+2Y4QEyljvs+kBFkPRbxJl1uoP/oHiX1RRrBhB6A==
Message-Id: <20261028041253.74839-2-lizhe.67@bytedance.com>
References: <20261028041253.74839-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v2 1/3] sched/numa: make free-space tiering promotion bypass configurable
Date: Wed, 28 Oct 2026 12:12:51 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20261028041253.74839-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26ae17693+8c7c5e+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <bsegall@google.com>, <david@kernel.org>, 
	<dietmar.eggemann@arm.com>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <juri.lelli@redhat.com>, 
	<kprateek.nayak@amd.com>, <ljs@kernel.org>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <riel@redhat.com>, 
	<rostedt@goodmis.org>, <vincent.guittot@linaro.org>, 
	<vschneid@redhat.com>, <ziy@nvidia.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: f8t8j51h9mp87t9xjmszprmc1pe7bwnw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 78D4B140006
X-Rspam-User: 
X-HE-Tag: 1793160859-548241
X-HE-Meta: U2FsdGVkX19luILXvVbW2uysax8cfe+9lXwB9r0DYhFGl69fyz67FXnuUoZGOqUFV+s6v2LBJUZUpV57qZ31anRiMq7AO/Hf5ZuIhnbUUWz3DjY7GafOgO+Hnlq76xgcvkaOKJCY+bcqsT2ToloO5xAgjWbDxYonJso+LttksyD8XpO6Ls2rb4Z2FrM7Ew9am7qRK2QUwcFzCo6/6nn6SmldxY23JSnLv2W8/yvY29lbBaL6cWCab9d4Aarsjc/6zCFHRCLRF7GpZtjvIbj2Xx4V/1tspjbxEmGznOukVsuAJtNK8bDTCabJdhiEdTopcbxB9i6jztIfPr3/xxBi4pGV5Xf6EcpsMukcDzjzhLvp5pWnlat39ATg6CLHN2dTr6mTPZiOgK0FV3RRYo39sRPbvuxUqtXasf3sJ+rHrUjGoNeg6SUdSQE6APCSFnPRTPnWlZ5VXP17BYFEqCc4iil6i6gt32bLNlVeA+wXZ1nv5FTKypipudxVPbnZawNWOwd7OzaEekY1loem/ztUjl4bqij5a4vCKVccYQswhfgDPSVeMpXbTjoy0uQ6+jlSh4vis1O0rOCmkUHplCTLFGmGsBonU88jS2lMGvCzgL4krMkR2W1UCHEICYUq8wpk2Y4Bwx73J3Lh0ZC8F/oUSA9zOVe6DC33BLq2eykqdcvgXOVTe8hslgL522inwsvUebTcJ0Y2Y3TKkgtsQIBtWmihqm829n7AM4hMpjMTHReZTwYlwCPzggWcK8wv8jnfpJRcC/pxuyoDBaDVScTGcGHDm1YSV1gc8tP6Rcw3anq//qiNUOpHQ4kCye9ty+497p0yEKcRsf3PmMHNzoYw9AGyVt57HuBTgOa57SdW/zQ0syUqOBSkguPqS4bUeCli9SH4CNxC2Tx4Hc6IhSfKinGixHm50o12ajicRkGFbS+6GTTDB7h8canHKVs3ZRYWXwQseXbFhEvsFrajsit
 z6uFtDl9
 852tRujsBIw5spnmmTzO2woos120BEuIgTNJeiLK8yJilgMVQRJLwb66tcnlgmlLiKh+6rzpdhFjgbUZNnOGXNXwcEyKPsJxoCzpZ5ZevddzP7A/KM2t0M0Slcv+i9J9oLho5KxEQt6dmarDmU0rCqhJlcMkxbQO2W/Cd2J5G4dDZeXiIuNnS1+UI0P++0FU/elfcGeDX7jbfIw01TnpJa0SXURojSb01Jrtt6TbyPBfzGg7QGeFu5AAONE1zy0aHJpKjV30QKHKSTNpUP1L2VKP0BMQov9U7c5tZEY+okYzqB1K/8q7goisdY3YzBCipBEDisiJvZiIV3Ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory tiering normally promotes any recently accessed slow-tier page if
the target fast-tier node has enough free space. This preserves the
existing policy of filling available fast memory before relying on
hotness and rate-limit control.

That is not always the desired policy. Some deployments may intentionally
keep part of a workload's memory on CXL-attached memory, for example to
preserve a desired DRAM/CXL capacity split or bandwidth distribution. With
the free-space bypass, short cold accesses and bursts of hot accesses can
refill the fast tier and pull the workload away from that distribution
whenever DRAM has free space.

Redis testing exercises this policy issue. On a CXL system with node0 as
DRAM and node3 as slow-tier memory, a Redis test was run with
memory-tiering-only mode enabled. The test used a Redis dataset with 12
million 4KB values. It reclaimed memory until about 85% of Redis
anonymous memory was on node3, used a Redis benchmark configuration with
a 10% hot-key working set, and then issued a short 256MB access burst to
cold keys outside that working set. The cold-key burst mainly touches
memory outside the hot working set, which is expected to remain mostly on
the slow tier.

The upstream default promoted the cold-key burst through the free-space
bypass. The patched default preserved that behavior, while disabling the
bypass kept the same promotions behind the hotness and rate-limit checks:

                              upstream     patched default    bypass disabled
  cold-key burst ops/s          117250         115481             142505
  cold-key burst P99.9 ms        0.854          0.859              0.686
  pgpromote_candidate              0              0               1488328

Compared to upstream default, disabling the bypass improved cold-key burst
throughput by 21.5% and P99.9 latency by 19.7%.

Add a sched debugfs knob:

  /sys/kernel/debug/sched/numa_balancing/promote_free_space_bypass

It defaults to enabled, preserving the existing behavior. When disabled,
enough free space in the target fast-tier node no longer bypasses the
normal hotness and rate-limit controls.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 include/linux/mmzone.h |  5 ++---
 kernel/sched/debug.c   |  2 ++
 kernel/sched/fair.c    | 14 ++++++++------
 kernel/sched/sched.h   |  1 +
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ecd1ebd49756..bf2d604c04b3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -278,9 +278,8 @@ enum node_stat_item {
 	 */
 	PGPROMOTE_CANDIDATE,
 	/**
-	 * Not rate-limited (NRL) candidate pages for those can be promoted
-	 * without considering hot threshold because of enough free pages in
-	 * fast-tier node.  These promotions bypass the regular hotness checks
+	 * Not rate-limited (NRL) candidate pages selected for promotion through
+	 * the free-space bypass. These candidates bypass the regular hotness checks
 	 * and do NOT influence the promotion rate-limiter or
 	 * threshold-adjustment logic.
 	 * This is for statistics/monitoring purposes.
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6a3b516c703..a28f0f09c91e 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -736,6 +736,8 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
 	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
+	debugfs_create_bool("promote_free_space_bypass", 0644, numa,
+			    &numa_balancing_promote_free_space_bypass);
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_SCHED_CACHE
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfc982205b98..46a11f5ddafb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -134,6 +134,8 @@ static unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
 #ifdef CONFIG_NUMA_BALANCING
 /* Restrict the NUMA promotion throughput (MB/s) for each target node. */
 static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
+/* Preserve the existing default of using free fast-tier space eagerly. */
+bool numa_balancing_promote_free_space_bypass = true;
 #endif
 
 #ifdef CONFIG_SYSCTL
@@ -2759,11 +2761,10 @@ static inline bool cpupid_valid(int cpupid)
 }
 
 /*
- * For memory tiering mode, if there are enough free pages (more than
- * enough watermark defined here) in fast memory node, to take full
- * advantage of fast memory capacity, all recently accessed slow
- * memory pages will be migrated to fast memory node without
- * considering hot threshold.
+ * For memory tiering mode, if the target fast memory node has enough free
+ * pages, recently accessed slow memory pages can bypass the normal hotness
+ * check and rate limit so the fast tier can be filled. The bypass can be
+ * disabled by numa_balancing_promote_free_space_bypass.
  */
 static bool pgdat_free_space_enough(struct pglist_data *pgdat)
 {
@@ -2884,7 +2885,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
+		if (numa_balancing_promote_free_space_bypass &&
+		    pgdat_free_space_enough(pgdat)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
 			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 87c5335add37..662b11bd401e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3218,6 +3218,7 @@ extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
 extern unsigned int sysctl_numa_balancing_hot_threshold;
+extern bool numa_balancing_promote_free_space_bypass;
 
 #ifdef CONFIG_SCHED_HRTICK
 
-- 
2.20.1

