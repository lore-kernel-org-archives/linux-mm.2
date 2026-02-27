Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203A8FEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8170D6B0098; Fri, 27 Feb 2026 12:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEF56B009B; Fri, 27 Feb 2026 12:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FA06B009D; Fri, 27 Feb 2026 12:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53D166B0098
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:08:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D63661C7F9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:13 +0000 (UTC)
X-FDA: 84490869666.06.74906B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A5194000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nIusV8/z";
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg5HgRWiegO+FFORuSsjEnW4Kl5H7f+Ll0D/ot3uL30=;
	b=3ezD3W3frAhXa+/rfCoSPAtUHFibo6a94wH/51RCQiJFo362rOJKaatjLUPZB07rLKcjub
	q9iwBfWPDYtzfz4KKmk/SV7e3LiVkob/eC9TWih5OOccl0mzWjayNYnIh7eoC7Bc3chzQ0
	+xmFJbuJW1xAd0aL1Sga95hWPj1S1n8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772212092; a=rsa-sha256;
	cv=none;
	b=M+/M/2n+ANaaaQw1TyqCMwS2K5Tqoe+qlMnEAsCrf+qiKaD1EgXMDr/ZkiGE4P9AJwD8um
	XN8ej55zrGZ/jOwGhA9wd213YLX8lJU8isBEATDJRmWOPI3CnXWZewSdWwi70WOu+VJNKx
	JOqzaFhJe3yvo1jJPLS1h5uswl2RqX0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="nIusV8/z";
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9A9B60133;
	Fri, 27 Feb 2026 17:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FF9C2BC87;
	Fri, 27 Feb 2026 17:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212091;
	bh=WUPDRrdwa5SkEyMU6GHPLmb001wCRNzEwHKZ7p9JCcI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nIusV8/zKNisDdm7CqRh9RiJxfIUV+V+BJVzPXzF7x2LZZPgK/DyfuzonpoBJ/jCy
	 hOrK9MB3PDZ0UBi2NiR4TnW9Hd05XeDJELywAS/IlR7w42XZUNZ2TMi8B4I3lfA4d5
	 1VeTqLhlgEyGa60Z1/FLBMKuFUhPRjcuPXs8BVqWlU0nWeSsEJrGReNa29OgzzcRwV
	 aSpVrWoysuIiAGO35s1hviNh4nCqGpY7ACZlLbXk/CnN4RUabZ6YwlQiMYiBZR4cbu
	 O+dpm/uNsffyVps9Fgk1tw1A3WIXbEKv0nigd2zJs31u4ChCEHGhPjtP5aIZTCH7UE
	 SJpCZZ+9ObdPQ==
From: Vlastimil Babka <vbabka@kernel.org>
Date: Fri, 27 Feb 2026 18:07:59 +0100
Subject: [PATCH 2/3] mm/page_alloc: remove IRQ saving/restoring from pcp
 locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-b4-pcp-locking-cleanup-v1-2-f7e22e603447@kernel.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, 
 Matthew Wilcox <willy@infradead.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5A5194000E
X-Stat-Signature: sb3agocum9qojojc3nt1ywybzais3o14
X-HE-Tag: 1772212092-584176
X-HE-Meta: U2FsdGVkX1/QUouYxXxyYaMQrlYpeJj3xqz6T3wEIFR/M+fgC+D2RnXz8rqdskZWdY3zZx5cCSvWwg32OgAJ/O7KEZN+dK7dSD4A+vgRl92fQ9kyK+eTwskpaAcAGt0amOAQc5/WDBRKuewXBIPpQhHBKRTszU6J4COVmJWOtKwH45PsGLu2ntx1KOrXKNna4261ROHK3Q2VD6n+ISxXdaKhWq7JCwIHpz7I3XRIlh2A3piAdqwQi6wBV0DVXkdCyuoiq3/Y1wyJxkjNT8N+oqkPtsV7XFpgpNJsY6+S5hvDKwleWXRBuBEZ66kZIu64D9LOYQ9yj7NY/V/JkbDiqfvtdMgmDJ+GXj8cNleQTAIO2jThcmQGGGybSXZQfNBBmXM0E6xV+xRDYKKexd56gJlbfjHcD6M0JeUyKWyrDpP3To7RoQrrWrCOCCXYdeANdnXVcKhCKuduOzrSFTohKpRXeaJJUTqAmnkIvyAdVkZq3I1hPooOOtRe/8qabUNK27zkUM0WQnJMtLrolmCeKQKZ5++425zFeno+1sjBZ0COAylMtL2DYfgy2MFaRtExESdbYoIgifO8uN9Qmze+rZUtZb3wHBXU33C2o2ZLgv3rFBvjp5iUzcsN7yZV241hIQWEpwbxOqwfA3uMGE9mqe/PefuT5bk+xs4SaoVZ2WfKuXSSA/ZL2C7ZUuPSjnnFWiTMUFkGVkUz6SQOGZ3OoeB6bbuMiuosohxzs4yl5R5d/chm+aRGCRRT/JIQld1nE7mfHgkpqYlngjBukDOcTpLy+YHFY9g2kj1Er5TkUuHo9YwVR0eR4jIogc2PwzUn+27aQhrufw7r4RrjOHAykx9VERjIohBRtaQJsuidAyvy/bHrVI5McFHQTsWpIlea6/I2+ZzAHboxM7sbIE5Cpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Effectively revert commit 038a102535eb ("mm/page_alloc: prevent pcp
corruption with SMP=n"). The original problem is now avoided by
pcp_spin_trylock() always failing on CONFIG_SMP=n, so we do not need to
disable IRQs anymore.

It's not a complete revert, because keeping the pcp_spin_(un)lock()
wrappers is useful. Rename them from _maybe_irqsave/restore to _nopin.
The difference from pcp_spin_trylock()/pcp_spin_unlock() is that the
_nopin variants don't perform pcpu_task_pin/unpin().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65efcaeb8800..8e5b30adfe40 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -155,24 +155,14 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 		BUG_ON(1)
 #endif
 
-#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
-static inline void __flags_noop(unsigned long *flags) { }
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-({							\
-	 __flags_noop(&(flags));			\
-	 spin_lock(&(ptr)->lock);			\
-})
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-({							\
-	 spin_unlock(&(ptr)->lock);			\
-	 __flags_noop(&(flags));			\
-})
-#else
-#define pcp_spin_lock_maybe_irqsave(ptr, flags)		\
-		spin_lock_irqsave(&(ptr)->lock, flags)
-#define pcp_spin_unlock_maybe_irqrestore(ptr, flags)	\
-		spin_unlock_irqrestore(&(ptr)->lock, flags)
-#endif
+/*
+ * In some cases we do not need to pin the task to the CPU because we are
+ * already given a specific cpu's pcp pointer.
+ */
+#define pcp_spin_lock_nopin(ptr)			\
+		spin_lock(&(ptr)->lock)
+#define pcp_spin_unlock_nopin(ptr)			\
+		spin_unlock(&(ptr)->lock)
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2572,7 +2562,6 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
 	int high_min, to_drain, to_drain_batched, batch;
-	unsigned long UP_flags;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2592,9 +2581,9 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	to_drain = pcp->count - pcp->high;
 	while (to_drain > 0) {
 		to_drain_batched = min(to_drain, batch);
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 		todo = true;
 
 		to_drain -= to_drain_batched;
@@ -2611,15 +2600,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
  */
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	unsigned long UP_flags;
 	int to_drain, batch;
 
 	batch = READ_ONCE(pcp->batch);
 	to_drain = min(pcp->count, batch);
 	if (to_drain > 0) {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		free_pcppages_bulk(zone, to_drain, pcp, 0);
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	}
 }
 #endif
@@ -2630,11 +2618,10 @@ void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp)
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	unsigned long UP_flags;
 	int count;
 
 	do {
-		pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+		pcp_spin_lock_nopin(pcp);
 		count = pcp->count;
 		if (count) {
 			int to_drain = min(count,
@@ -2643,7 +2630,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
 		}
-		pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+		pcp_spin_unlock_nopin(pcp);
 	} while (count);
 }
 
@@ -6127,7 +6114,6 @@ static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 {
 	struct per_cpu_pages *pcp;
 	struct cpu_cacheinfo *cci;
-	unsigned long UP_flags;
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
 	cci = get_cpu_cacheinfo(cpu);
@@ -6138,12 +6124,12 @@ static void zone_pcp_update_cacheinfo(struct zone *zone, unsigned int cpu)
 	 * This can reduce zone lock contention without hurting
 	 * cache-hot pages sharing.
 	 */
-	pcp_spin_lock_maybe_irqsave(pcp, UP_flags);
+	pcp_spin_lock_nopin(pcp);
 	if ((cci->per_cpu_data_slice_size >> PAGE_SHIFT) > 3 * pcp->batch)
 		pcp->flags |= PCPF_FREE_HIGH_BATCH;
 	else
 		pcp->flags &= ~PCPF_FREE_HIGH_BATCH;
-	pcp_spin_unlock_maybe_irqrestore(pcp, UP_flags);
+	pcp_spin_unlock_nopin(pcp);
 }
 
 void setup_pcp_cacheinfo(unsigned int cpu)

-- 
2.53.0


