Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93B3FD2ECFF
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 02:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052846B0348; Mon, 19 Jan 2026 21:44:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029BB6B034A; Mon, 19 Jan 2026 21:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2BD6B034B; Mon, 19 Jan 2026 21:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D693E6B0348
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 21:44:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E63516039F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:44:53 +0000 (UTC)
X-FDA: 84350799666.17.E33375C
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id C1F65C000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:44:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CddlsIq/";
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768877092; a=rsa-sha256;
	cv=none;
	b=es76f/M2zd1TYl+lAfAzX/CbijQ5LMtK/TH+7TDIk+EuaR5eQIzFWwiuxGg4L+uoJR8ozW
	ZCMD2GkAtt8betx87mCDlaKzXqhhlIFkO3tLA2NXFlV49dFLo5qQgRxSilWwBvHHOd2E2+
	An+THSq2Ryi9qyzzfok5JeIyG1ImRRI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CddlsIq/";
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768877091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pls5MXmyRyRItrjpCM4LqoeGJ08hhYmNWXA6AmLbX1E=;
	b=4kSvK6CFNRmkVE4UyVGXA6f3/Ci8TRe7Ax0VpHblx+/C44hlbnRE8+u6P9aWUa7j4Paw3n
	Zpp56CHChogb0N7MP8y5PESq7L5oMH6t5y0hANAeBkzoXo/XTeHIwT/AIP3MJ1RXLdb9Ng
	WNBNGK4XRhI5DYxzUueRRbHpfQcaRdY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768877090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pls5MXmyRyRItrjpCM4LqoeGJ08hhYmNWXA6AmLbX1E=;
	b=CddlsIq/Ciydyqy4nKbcYe6ckcjbSG+ZOowYiATHpCXohzhOJCjnIjqmiLbLJWxRorTMPY
	tDX3Ud3S3yxDcjyHrSJEj4zQtkOz/RK8+FnIs5eNgF0sXMYDMFXFXA8xFcPdn6K7sq/xbI
	YTYn0BLs4eO9e2FdexEzxOwtLkEJkgI=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
Date: Tue, 20 Jan 2026 10:43:48 +0800
Message-ID: <20260120024402.387576-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260120024402.387576-1-jiayuan.chen@linux.dev>
References: <20260120024402.387576-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: x4hobyptzsgfhkmcq6tzy85cwq99ukto
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C1F65C000B
X-Rspam-User: 
X-HE-Tag: 1768877091-428020
X-HE-Meta: U2FsdGVkX19z3srN4oCk4xeNqS4AJkKrO55Qcuqvs5DQ6PutYx85iToMQeAIAM4WulDaCu1VCjFiu0jPHJD4sOWUdjaJdpc1Ls0fUuPJLC8dzzSSbhCHhEt1SDp8rD3cz3sPedcJxo5b4Zcf7KEJ/vkmJW/OOYK2ll6KrwcvXFoyRrp6vtTqQ8+zni9vC4IMkaNjbz9LErfHZCRvs5dXSAZKz9Zzf9Z+j0wVsse8f3QbEBcQs4Xk2jyRSnaC2Hkw6b7jcslmsxZNuNHYA4Vmv2apCV+n2NV9R6vPOzqU3YJwqNhLl9PerXueQkRBnuZaSaoM3aCayW9aRLUMuM7dqywR32YDwHXyXelsVE3Oy7PZTttRpnqcWi8xVm2oZB9QvoiI7XuvEukVFgNgsO68F6EWXEZD+/U5b9UvYkH5Y4gpRzlH2q11E3KvHIxt5FB/gFzmu7dSbaEiQQWl/pGWbbKKNmPyewxNLaaQ7wRnMZb4JxLH4En6Mu6xMjcziiA/ulHn4iLUjgAKBGqR2Qz+rwcsBKSIcuVfZ87l1iJjNCWvM09TDtvld36wLgG9yR/GkA3STWSIuisN9O11mf3gukLcLDSmlyUcMvk9tJAkzUyoMwMovEBPU2u1yCkdnl12DAZZ3npyrxMC20kIEGFPLxiJ7o9gibQTMh4eaAcTQRaqmZfj5iwmGyxqs5Tz/+MjcuME/arbr556HmOKGr/oxg0RYE3mJb6vK2Uo5bcbRWw49pfDSzze/VDGRsrk6iUgoax22FP2mDKAJuVbHAu7XTDuoA1jSMIwWRSOFIzK0Co+VFrkYR3jJ8Mj1yfTp2R0Zg/FQUtkYCMaghJS/iU2MDLz9FfxFrcQN7JqLTd4eicvZ567FV1jL1kBDthEFf+wVw8uiwJYWgui+ICGGAd3i4TUl/OHdM/aP9MLsu46eD0i4jveIO3XFJzvA8IOTBDCC61x7OAiI++TBBmHlyF
 DIVCiPoK
 u1UdZizTMiqyx5yAf7/2VF3e6uDumZj71YymcbcBD2BY/c4YaqgzYNDa3BeBMob2dzFFAKlatwaPPZ29Vp3ArZTJUGeeuC+LJ+VH4x9dUpTlC0DI/s98a0MdG0nNVDghRr3STrvthqt2sOlAyU+LsFByBiUzhPJNUDb8OW/vPs6X0RwKdRdjZKYBTaRmioSc+GQOZWrUv3A+3JUHwYB642W/48xCpNWCw5S2pj+CgijpXSu+aqiCmPpIQdGsZxKckJNJ0bKI8oiG58ZjRVqJWTbAkcZ6CVllbZQ7R0mrt592ellT5VBK134YBSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

When kswapd fails to reclaim memory, kswapd_failures is incremented.
Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
futile reclaim attempts. However, any successful direct reclaim
unconditionally resets kswapd_failures to 0, which can cause problems.

We observed an issue in production on a multi-NUMA system where a
process allocated large amounts of anonymous pages on a single NUMA
node, causing its watermark to drop below high and evicting most file
pages:

$ numastat -m
Per-node system memory usage (in MBs):
                          Node 0          Node 1           Total
                 --------------- --------------- ---------------
MemTotal               128222.19       127983.91       256206.11
MemFree                  1414.48         1432.80         2847.29
MemUsed                126807.71       126551.11       252358.82
SwapCached                  0.00            0.00            0.00
Active                  29017.91        25554.57        54572.48
Inactive                92749.06        95377.00       188126.06
Active(anon)            28998.96        23356.47        52355.43
Inactive(anon)          92685.27        87466.11       180151.39
Active(file)               18.95         2198.10         2217.05
Inactive(file)             63.79         7910.89         7974.68

With swap disabled, only file pages can be reclaimed. When kswapd is
woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
raise free memory above the high watermark since reclaimable file pages
are insufficient. Normally, kswapd would eventually stop after
kswapd_failures reaches MAX_RECLAIM_RETRIES.

However, containers on this machine have memory.high set in their
cgroup. Business processes continuously trigger the high limit, causing
frequent direct reclaim that keeps resetting kswapd_failures to 0. This
prevents kswapd from ever stopping.

The key insight is that direct reclaim triggered by cgroup memory.high
performs aggressive scanning to throttle the allocating process. With
sufficiently aggressive scanning, even hot pages will eventually be
reclaimed, making direct reclaim "successful" at freeing some memory.
However, this success does not mean the node has reached a balanced
state - the freed memory may still be insufficient to bring free pages
above the high watermark. Unconditionally resetting kswapd_failures in
this case keeps kswapd alive indefinitely.

The result is that kswapd runs endlessly. Unlike direct reclaim which
only reclaims from the allocating cgroup, kswapd scans the entire node's
memory. This causes hot file pages from all workloads on the node to be
evicted, not just those from the cgroup triggering memory.high. These
pages constantly refault, generating sustained heavy IO READ pressure
across the entire system.

Fix this by only resetting kswapd_failures when the node is actually
balanced. This allows both kswapd and direct reclaim to clear
kswapd_failures upon successful reclaim, but only when the reclaim
actually resolves the memory pressure (i.e., the node becomes balanced).

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/mmzone.h |  2 ++
 mm/vmscan.c            | 22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..3a0f52188ff6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1536,6 +1536,8 @@ static inline unsigned long pgdat_end_pfn(pg_data_t *pgdat)
 void build_all_zonelists(pg_data_t *pgdat);
 void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
 		   enum zone_type highest_zoneidx);
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx);
 bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 			 int highest_zoneidx, unsigned int alloc_flags,
 			 long free_pages);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..ecd019b8b452 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5067,7 +5067,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 }
 
 /******************************************************************************
@@ -6141,7 +6141,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -7414,6 +7414,24 @@ void wakeup_kswapd(struct zone *zone, gfp_t gfp_flags, int order,
 	wake_up_interruptible(&pgdat->kswapd_wait);
 }
 
+static void kswapd_clear_hopeless(pg_data_t *pgdat)
+{
+	atomic_set(&pgdat->kswapd_failures, 0);
+}
+
+/*
+ * Reset kswapd_failures only when the node is balanced. Without this
+ * check, successful direct reclaim (e.g., from cgroup memory.high
+ * throttling) can keep resetting kswapd_failures even when the node
+ * cannot be balanced, causing kswapd to run endlessly.
+ */
+void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+			       unsigned int order, int highest_zoneidx)
+{
+	if (pgdat_balanced(pgdat, order, highest_zoneidx))
+		kswapd_clear_hopeless(pgdat);
+}
+
 #ifdef CONFIG_HIBERNATION
 /*
  * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
-- 
2.43.0


