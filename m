Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A298CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 03:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8202B8E00E2; Mon,  3 Nov 2025 22:22:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7378E00DC; Mon,  3 Nov 2025 22:22:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CEB8E00E2; Mon,  3 Nov 2025 22:22:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60C228E00DC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 22:22:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D75621603C0
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:22:08 +0000 (UTC)
X-FDA: 84071475936.06.4CB0515
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C0A01C000A
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 03:22:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=WOx7AAOX;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf21.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762226527; a=rsa-sha256;
	cv=none;
	b=PhXJCWBXutazc3FIG0xBv0ZGdEONzQE6Zlr7/44NYsPRxOK4d0zPW1OcMqLop7cSomNMXU
	2iISE+dD+OvauwHXkL/sJWQU/NKzvNTa7JaQgiHGduYGM8T1dF7Du244JWnhFKz1Buu4fZ
	+/Qiv19I1ejpdweoeTRZKrVMOTkk0KU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=WOx7AAOX;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf21.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762226527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vXCmE7H6x7fyKpOMWrBQ1sPfqnG3V4Jxw1CcNvLnI7g=;
	b=1hyMvTrrUpsLwpYJeqv5r3+or0n2mrf3ppdaKoSnpTqbxpAKp9vvwxd/aoTtLkZHWEF/cw
	mjpvbizNlcdJ1DfQxvn6BPrZjCfRS08lE+WzapiYwlRto5JB0Wu39CntIuC+1iubm4yEEC
	XiW0xtW0tCu94niHirZRFUwEUTUqz/c=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-28e7cd6dbc0so63517215ad.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 19:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762226525; x=1762831325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vXCmE7H6x7fyKpOMWrBQ1sPfqnG3V4Jxw1CcNvLnI7g=;
        b=WOx7AAOXtg8X9UnwRiJJ+ixCuOqYP7lfG5pH4uArAlnA/Ec7ZpDVDYcrUJUp8KwcKA
         JCoUAVij2sBA5iLG0Q0OkO9fNA5A1X/O85M2egqCqI7FyW8xFTfeHKZQsh1bQV+QRPs8
         8uCevf6wsqEuCtzcs9Vkt6NIlP2X4WHdSj6kgV4ygEsGZ15gERA48AXOK35oBGP51511
         zRgEo5EpCYnx86owdyNFd7g8JlUvGnGfekj6vvNDQJi+ktmU5tC8DBto4IpzVykJ9wBk
         rnSLBtFrDHXuzIKrjqy3ezOtkeuPUDijqxsZyVNfDo3s3zBXru8PNVujWdg/fpENlXTM
         5Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762226525; x=1762831325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vXCmE7H6x7fyKpOMWrBQ1sPfqnG3V4Jxw1CcNvLnI7g=;
        b=gM24PiawEXGL8xaxD2TkgFfwK/FQ8eGGYTxoYt3lzlaf67ExdQLffZ0Ni3/Iehc72N
         UB5mXEbzEY/D4zqBjCX21fjakfX29bXWPncXIk0XCztgVxwTGVoQenUdONhOhOe8EpXu
         3CyXblmMHls9XwKD8OrjEFZGaW2/Z0ZQPU+RRtCA0J2hDRbFupDSN7PB0HxwaxgUAxhF
         nGt18KBnQM19jICsG87/+jjL+fmQ56rmHorN1YsgHKDwG40Yoi5DYfIXl5SYBMjmBDjc
         8WW1mAj/2FlkYPt9SzDnXCR763Pff+Kj/Z0HJ+6oEY2szJW96SXZni6Ku69sODmQo8Jv
         ekBA==
X-Gm-Message-State: AOJu0YwSw8tMEvb9ghVrX7iemi/ltXyIR3Nt+1PSfJS/Kp/2mtUe/6bc
	f47+WoEc9fKE0IbAXYT82ZSQnJPNr1QEqSHl+XFoaOR0pzA/8xYQeUlNfICUa329rH3V5itOeJN
	U0xtpxoJy6jjBEXw01CZ+RSWFsyJCAvGpyj/HHZhp+ofAKscR7A6IiDhjKn1k6TRrMrtWElvW87
	l537/a1LBoojolx4tfJzLSNty11Tqh4d8TIR8xe5DiuIG/Pw==
X-Gm-Gg: ASbGnctpyH5p6/YAwXL0k77x9GMvaL7aU8hjuqrXqNYFz1xHPqHSmcXXWTJ6+BCyTFU
	STM55L4CTYTxTBjuE39OvrPeasLElnoHbL0ZfPTAnwFP6TK8K4GZWDIhDdcSZCJSM4eVwaOmbY5
	EKP2TMv9eG41PzZPatsjJo/sUC4rz67OAetfyy6iqPqf7yXNfDBwIokeKCoPM5WuI31ruoJWiY/
	VbhIn5B3PzLLm6lpxTMZMz6fYbuKnsU21ltdpbAnGopwemKDpgnWbbl2jj6UZTvE/uoYCx864+O
	/7lXP2huiGqdtuhydOn/QLjviyzUD9sr+MvyMCuup263eeRXe/VQPvRKTmZl6waWSzLOqA+/t+D
	z3Fwfbk4JX9S5KTw6W3P7zxlNdwwaUDiCUTLWePKCWR/URVOtd0QWxQXSvJ8NYUcHLCKXqyET8v
	wAK0MDLwrygPO7lg==
X-Google-Smtp-Source: AGHT+IF2TZ20FVdtcNu1/5M1Y2bthYAGkuFfgh/CKrUIJaaPONkop5s1tx0H2wZNuH9GtYdOsYlGuA==
X-Received: by 2002:a17:902:db0e:b0:295:6c26:9348 with SMTP id d9443c01a7336-2956c2696d4mr129368375ad.59.1762226525257;
        Mon, 03 Nov 2025 19:22:05 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29601a5751fsm7559125ad.82.2025.11.03.19.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 19:22:04 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	joel.granados@kernel.org,
	jack@suse.cz,
	laoar.shao@gmail.com,
	mclapinski@google.com,
	kyle.meyer@hpe.com,
	corbet@lwn.net,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH mm-new] mm/memcontrol: Introduce sysctl vm.memcg_stats_flush_threshold
Date: Tue,  4 Nov 2025 11:19:08 +0800
Message-ID: <20251104031908.77313-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0C0A01C000A
X-Stat-Signature: yk57sj57dq83ksyxugiajfz6c3gomcgj
X-Rspam-User: 
X-HE-Tag: 1762226526-338338
X-HE-Meta: U2FsdGVkX1+8519cJYynyLZe+a60KW+p61jCxV2kxRqQzCvf5oclfX1Gq6kFm10LFovU2vI+rLcrumfBHlpx/pxE408+m94Xxvpkbw5DzLt+dkTzpAn/VimxYUhK6UXvR7Nlbsz3w8hGCiegKFH3W46YdTJaIZf6WNEicb1qgyv+AeigGAmgGwPrqYsY6VL/UoQkK0JDOtri2KmNC5mU/aQKe/XDQQn4MHL3GKUUOAqlikLKFBFysZ0gPQPnh+LQ9MEJG0O843eD/cM+toQ4afLoZX8MKZrOHpeTxtbtxt3Bi4KRQ1yc+tZGpyzAVxNMqawLedLTWKlJhRf7hBP/41eMMwEdCu1Ydt+FhAqLC/3HwC4zNtbwRk1lzgC7tNyAd7fLuIEl6UwOqt7IHPo7WbEYH7KHkl9NxdKv/Qo+UO0W+OFWpN6cPFC++2/5pWiTf51/fcetiUnjtNha6ySK/PqAoIw/1FeJgrxegGYsMiSv7MhJXoAPNuL1KXiIL1aRSPPfZSJxU6r0uM0PE/+UuedLCeW+F/s/MBrnI8I7kdAYVyXPZvNbnbD7Z7WBZZc8whIfv/7pi/I1j8S5XK66m11q0sPMM/ZLlYZvBxAK66suI5TkeBFjueZiL0KtP92dwe5ZLPaFlRcr5zoQlUP+4w/REL9dP3qiihLPzXCE4sXbf/4WH3GmzRYlzxrdJsl/3WwtD0ujxubKI7JKSCqpOzDx9HtxXWBPHYAYRhj2v4seXxZB1/9OHBz/WZjDM9iVJ9jZJEMTz3T1+YqBRd1BI3qmS23WJetL8FBYlHPRARIT3QMMzcByOXN/l6DzKiDqEe0pfswIg8rnoloyWT2cs8Ox8V8IV95d80ZUfZ4TbOmP9MaePlSNFH16RmOn13u0PT2R3C3xljhJpjU8IqhnNR7iY+XkTWynQk5qvPGL8TZYufTbnxJqiqw3RW9VlXbxJ78JeoJZ6erGNCCjvVT
 PfaLoczR
 Qw1V/je5fZXej1+xwenJydsfsjDd7J8NZnb44ayo/Exu4t2BvTYu5RrmVMfSevBQPioIyjGLq/NoF7kcSRX5cWqTpnu3+g3cZmnPl9mtqWhy0HZBWeWwCMH8/2BjkVYABw1FttLvgqOSz6WL/uwOUlAAjWdXSKzOIYz1W1f3/ICvQ3F1nNTzODFoo5LJH6OxNENf6RBcYGTSyB6aWyD1cqBjdqyEget68q9EyqIOzXW/8S2zZ00q9kCHr6swMwXDaygCkaDIHYR32CkhngmSpjgnO5wCGGXeffkySkcrRhYUpqIDfEdaPu7fvX6bHEFA3tm5f+fyXrJckw5IiyrQEzoRrgobGIv4n1LQqe3u8QDX4ng4nKD0hUss+0wbpqGJS9+JzDYMhgPGItscdL4n8YL0xX4cr+EsWdUKQluNzbpsRb+9v6zeWqxKy92BUYCTJof+LDp+2uI/gzH8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current implementation uses a flush threshold calculated as
MEMCG_CHARGE_BATCH * num_online_cpus() for determining when to
aggregate per-CPU memory cgroup statistics. On systems with high core
counts, this threshold can become very large (e.g., 64 * 256 = 16,384
on a 256-core system), leading to stale statistics when userspace reads
memory.stat files.

This is particularly problematic for monitoring and management tools
that rely on reasonably fresh statistics, as they may observe data that
is thousands of updates out of date.

Introduce a new sysctl, vm.memcg_stats_flush_threshold, that allows
administrators to override the flush threshold specifically for
userspace reads of memory.stat. When set to 0 (default), the behavior
remains unchanged, using the automatic calculation. When set to a
non-zero value, userspace reads will use the custom threshold for more
frequent flushing.

Importantly, this change only affects userspace paths. Internal kernel
paths continue to use the default threshold (or ratelimited flushing)
to maintain optimal performance. This is achieved by:

- Introducing mem_cgroup_flush_stats_user() for userspace reads
- Keeping mem_cgroup_flush_stats() unchanged for kernel internal paths
- Updating memory.stat read paths to use mem_cgroup_flush_stats_user()

The implementation adds comprehensive documentation in
Documentation/admin-guide/sysctl/vm.rst explaining the use cases,
examples for different system configurations, and the distinction
between userspace and kernel flush behaviors.

Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 48 ++++++++++++++
 include/linux/memcontrol.h              |  1 +
 mm/memcontrol-v1.c                      |  4 +-
 mm/memcontrol.c                         | 86 +++++++++++++++++++++----
 4 files changed, 124 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index ace73480eb9d..f40c629413ea 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -46,6 +46,7 @@ Currently, these files are in /proc/sys/vm:
 - lowmem_reserve_ratio
 - max_map_count
 - mem_profiling         (only if CONFIG_MEM_ALLOC_PROFILING=y)
+- memcg_stats_flush_threshold
 - memory_failure_early_kill
 - memory_failure_recovery
 - min_free_kbytes
@@ -515,6 +516,53 @@ memory allocations.
 The default value depends on CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
 
 
+memcg_stats_flush_threshold
+============================
+
+Control the threshold for flushing memory cgroup statistics when reading
+memory.stat from userspace. Memory cgroup stats are updated frequently in
+per-CPU counters, but these updates need to be periodically aggregated
+(flushed) to provide accurate statistics.
+
+**Important**: This setting ONLY affects userspace reads of memory.stat files.
+Internal kernel paths continue to use the default threshold (or ratelimited
+flushing) to maintain optimal performance in latency-sensitive code paths.
+
+When set to 0 (default), userspace reads use the automatic threshold:
+MEMCG_CHARGE_BATCH * num_online_cpus()
+
+This means on systems with many CPU cores, the threshold can become very high
+(e.g., 64 * 256 = 16,384 updates on a 256-core system), potentially resulting
+in stale statistics when reading memory.stat.
+
+Setting this to a non-zero value overrides the automatic calculation for
+userspace reads only. Lower values result in fresher statistics when reading
+memory.stat but may increase overhead due to more frequent flushing.
+
+Examples:
+
+- On a 256-core system with default (0):
+  Userspace reads use threshold = 64 * 256 = 16,384 updates
+  Internal kernel paths use default thresholds (unaffected)
+
+- Setting to 2048:
+  Userspace reads use threshold = 2,048 updates (much fresher stats)
+  Internal kernel paths use default thresholds (performance maintained)
+
+- Setting to 1024:
+  Userspace reads use threshold = 1,024 updates (even fresher stats)
+  Internal kernel paths use default thresholds (performance maintained)
+
+Note: Memory cgroup statistics are also flushed automatically every 2 seconds
+regardless of this threshold.
+
+Recommended for systems with high core counts where the default threshold
+results in statistics that are too stale for monitoring or management tools,
+while keeping internal kernel operations performant.
+
+Default: 0 (auto-calculate based on CPU count)
+
+
 memory_failure_early_kill
 =========================
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8d2e250535a8..208895e6cf14 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -955,6 +955,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
 
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
+void mem_cgroup_flush_stats_user(struct mem_cgroup *memcg);
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
 
 void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val);
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..3eeb20f6c5ad 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1792,7 +1792,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_user(memcg);
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -1873,7 +1873,7 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_user(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c34029e92bab..fffcf6518ae0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -63,6 +63,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <linux/sysctl.h>
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
@@ -556,10 +557,40 @@ static u64 flush_last_time;
 
 #define FLUSH_TIME (2UL*HZ)
 
-static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
+#define FLUSH_DEFAULT_THRESHOLD (MEMCG_CHARGE_BATCH * num_online_cpus())
+
+/*
+ * Threshold for number of stat updates before triggering a flush.
+ *
+ * Default: 0
+ *   - When set to 0 (the default), the threshold is calculated as:
+ *         FLUSH_DEFAULT_THRESHOLD
+ *     (i.e. MEMCG_CHARGE_BATCH * num_online_cpus())
+ *
+ * Tunable:
+ *   - This value can be overridden at runtime using the sysctl:
+ *         /proc/sys/vm/memcg_stats_flush_threshold
+ *   - Useful for systems with many CPU cores, where the default threshold may
+ *     result in stale stats; a lower value leads to more frequent flushing.
+ */
+static int memcg_stats_flush_threshold __read_mostly;
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table memcg_sysctl_table[] = {
+	{
+		.procname	= "memcg_stats_flush_threshold",
+		.data		= &memcg_stats_flush_threshold,
+		.maxlen		= sizeof(memcg_stats_flush_threshold),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+};
+#endif
+
+static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats, int threshold)
 {
-	return atomic_read(&vmstats->stats_updates) >
-		MEMCG_CHARGE_BATCH * num_online_cpus();
+	return atomic_read(&vmstats->stats_updates) > threshold;
 }
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
@@ -581,7 +612,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
 		 * flushable as well and also there is no need to increase
 		 * stats_updates.
 		 */
-		if (memcg_vmstats_needs_flush(statc->vmstats))
+		if (memcg_vmstats_needs_flush(statc->vmstats, FLUSH_DEFAULT_THRESHOLD))
 			break;
 
 		stats_updates = this_cpu_add_return(statc_pcpu->stats_updates,
@@ -594,9 +625,9 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
 	}
 }
 
-static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
+static void __mem_cgroup_flush_stats_threshold(struct mem_cgroup *memcg, bool force, int threshold)
 {
-	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
+	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats, threshold);
 
 	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
 		force, needs_flush);
@@ -610,6 +641,20 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
 	css_rstat_flush(&memcg->css);
 }
 
+static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
+{
+	__mem_cgroup_flush_stats_threshold(memcg, force, FLUSH_DEFAULT_THRESHOLD);
+}
+
+static void mem_cgroup_flush_stats_threshold(struct mem_cgroup *memcg, int threshold)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	memcg = memcg ? : root_mem_cgroup;
+	__mem_cgroup_flush_stats_threshold(memcg, false, threshold);
+}
+
 /*
  * mem_cgroup_flush_stats - flush the stats of a memory cgroup subtree
  * @memcg: root of the subtree to flush
@@ -621,13 +666,24 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
  */
 void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	if (mem_cgroup_disabled())
-		return;
+	mem_cgroup_flush_stats_threshold(memcg, FLUSH_DEFAULT_THRESHOLD);
+}
 
-	if (!memcg)
-		memcg = root_mem_cgroup;
+/*
+ * mem_cgroup_flush_stats_user - flush stats when reading memory.stat from userspace
+ * @memcg: root of the subtree to flush
+ *
+ * This function uses a potentially custom threshold set via sysctl
+ * (memcg_stats_flush_threshold). It should only be used for userspace reads
+ * of memory.stat where fresher stats are desired. Internal kernel paths
+ * should use mem_cgroup_flush_stats() to maintain performance.
+ */
+void mem_cgroup_flush_stats_user(struct mem_cgroup *memcg)
+{
+	int threshold = READ_ONCE(memcg_stats_flush_threshold);
 
-	__mem_cgroup_flush_stats(memcg, false);
+	threshold = threshold ? : FLUSH_DEFAULT_THRESHOLD;
+	mem_cgroup_flush_stats_threshold(memcg, threshold);
 }
 
 void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
@@ -1474,7 +1530,7 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 	 *
 	 * Current memory state:
 	 */
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_user(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -4544,7 +4600,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	mem_cgroup_flush_stats(memcg);
+	mem_cgroup_flush_stats_user(memcg);
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
@@ -5176,6 +5232,10 @@ int __init mem_cgroup_init(void)
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
 
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("vm", memcg_sysctl_table);
+#endif
+
 	return 0;
 }
 
-- 
2.51.2


