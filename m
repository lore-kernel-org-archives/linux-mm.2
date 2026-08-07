Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7068CC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB236B009D; Fri,  7 Aug 2026 16:21:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785506B009E; Fri,  7 Aug 2026 16:21:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D776B009F; Fri,  7 Aug 2026 16:21:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 324AB6B009D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9DC4FC0192
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:16 +0000 (UTC)
X-FDA: 85075592952.22.EB61410
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id D902A8000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FItVHQzv;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFD6EfRm/L4Zg2p1Y1cVpL/1kzGCx7Oqw9Sl1lvWZlg=;
	b=xJlwBoiTq4fWExDQXTjeIxuc8PLDanoEI9MXiXDm+5KSeCHDMMU5hR/vqzNwF0bSy42YMf
	j8Mmh371u/MNigDlNfZWCB3nm/jM3B6Mdvf5q9e4SzV0iCt7X1u5wzv2vPVAqRAmFbRaDS
	uofiiX5pmIZLl9x6P4MMdUm1EajOi4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134074;
	b=pTTg/rShP3RQjvMQthD8lceNWhEek5ChWDD70djx8HrdkTQJ2FvHB5XZlrSgc8YODtatNA
	2MlxRKAgpwiiPGsOSK5f9zT8V4CWTmf7tYK3DWjQYyH/m66wrY0MIe0BbeeV0VjvvIzU4q
	LEXEkQbWai79PvppcS9TiqdYrjjJNrw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FItVHQzv;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso3979597a34.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134074; x=1786738874; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qFD6EfRm/L4Zg2p1Y1cVpL/1kzGCx7Oqw9Sl1lvWZlg=;
        b=FItVHQzvL0f0rh4P17gQxcVQDNzu7P2MEzQ+0PH2WXUwJa8crUVMCU7aD0NivN6520
         IjV/mqkhHfgzaaIGlRS98IPPJzdB9wvU6nizpLERAw7u26fcQziI7GmE3jGtyUXwa80Q
         kBdzDm69N952fEWKmlwVbb0LmAXV3/ZzRM8OgK+GHdxwlf6BKJsz1VJ+mq+XeCnWHRTK
         nAVceiASniKfMGjGgZlSmKA8Ijq8Lgk0fBuyT7HHW5ZnsI6RHTwFZdkVvj6OxbeaFRdr
         h9vv0lO9BAWUHR0rTFQztZXSQVjMSgBBvioSERyEq9ljA6JNY0iIeMy7rg596NNj0bXd
         0oQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134074; x=1786738874;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qFD6EfRm/L4Zg2p1Y1cVpL/1kzGCx7Oqw9Sl1lvWZlg=;
        b=ETxTuyXSgQAvcg0PeVcrzjMsUAOwOcugI1Z/OydTcF9YKCt4l5EFz5eNMdpT3rU8kX
         va2WBG2BSeMpJYewD3sJzvB0g12lpFFwR4kCjphVQClFWmruYjD4Dc5AHB7os1feAWTB
         LJxhJn/uDHJaawdDQt5my8gzgTPJ709DoTED4JFt9UoIR/JvMT+7NtTdUcFOkeP7oKq2
         Kp3VzwtawYIuwpYTWGkLZmH9dy/7wMvcyhFSCFLvBJfsl4v4kwJ5BpBiETMPCUQlzyPo
         9aUSV/Nn7wo2pXmuCghctYiIrWFaPHZO5gPZdCOE7AadPyeSCSN1fTF/3j5zKl4BU7o1
         yeSw==
X-Forwarded-Encrypted: i=1; AHgh+RppMCicwOuUazTB3WisSHaTDlPY//G1yS0VAGNxQY8ZkkAGGV080C4tlL8dzYbC0Juo31fs6KLt3w==@kvack.org
X-Gm-Message-State: AOJu0Yxo4ACl5cIULAjv1epNbGMAikrCWcOcxcrtuwIZAUOoF+K1HeT8
	dF3wQPu8oun0A/l4arHcyCnAQir5OZ8BuCwZK4R02GBgvfk1e6tRHqSf
X-Gm-Gg: AR+sD10Ycq6ob6KKzm+SnxTTVK8zCtdS5pd61jqkbTJOY/CFlLEuqMZINw3ULskFNeM
	75eSlciVm39sIuAd9JKPxJwOxzkrfVQ7M2K+1r2A3RMZY/xvMBlbcakjJ/B4RC2gqSoGP83B/6T
	8EPRqrWiu60V+g5JrHanABcfpCTstHRJUFMNmFzR9EUXeQGGBy6nejnXr12wPgE6p0cokQb+Cxe
	hPJZzD0RI8jGraSnr0cSVQMRDPm6uBlx19IALxJBA3gb+0sptpBd2GzZWKStV2mZGqbdIswy60Z
	hR5yLMJfv92QMQ6/QB5t2tq+blvJjQfzMZ9ckVxLchbmad4Kqw6L+l7aSv59UFTFOWwimXZHpgf
	ejaGQPUVwKMneU2Vbt7xg2tJDnSWEMJbIK2OB0ObkYRa3lMkR99AUqcCmSDk2+deqTb/NJtnbE/
	7a9jwwZUGyIPtIIEgEfonx6sB4xLE3Ssqnzk+d6jHToW4bi+tNT2QuAO2yQVfjPB3DZGWtvaysm
	DqKk7q5BG/47J0lCcY=
X-Received: by 2002:a05:6830:82fb:b0:7dc:c7aa:22bd with SMTP id 46e09a7af769-7f1e5ce763dmr15477492a34.6.1786134073875;
        Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b56391dsm1914394a34.1.2026.08.07.13.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 09/14] mm/memcontrol: Make memory.high tier-aware
Date: Fri,  7 Aug 2026 13:20:52 -0700
Message-ID: <20260807202059.2620949-10-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D902A8000C
X-Stat-Signature: mapi3uem1mk3g1uumpqo4p3zus65thys
X-HE-Tag: 1786134074-504116
X-HE-Meta: U2FsdGVkX19MXMmKOxYAoVmDUV6Aqub2+o2ixJpol0avwTCcT6d4MWYdAqpe6hDBahwekVjaIuTnwoWzNL9gMoAzWPFMS+e7nJMc98u0BijEvQtC8R66QT3GlmW0P2M03hnqxVMVmSIPpBPjsrQUyHWUjmfmok59DCCQd8y0hp+ebrLyPUaJdksKoFjwpA6voJ0QGG0EaERYdP5ToXy4dwH09dq/l399+y3BPiuAnK9kRA0IfABujXvn40RMs45WFVYYGkJmgBQXrn6bGJixn+AHc/2ieqGG2tcNxvTnGV9FNRJpcUL7d3nAyVM8W1qxVf30c/6XYBeKGGMhcuHFEYOS70WnCAK6skp22n/7neZ29wdq/WwJ7VxXJqPkaku9knwqkj0+C4rpqF14uwtWcoph/ge14tv4Bj+zNNiYN/4Tj9BFrhX9JJsmMFSpo0KOJds+m/J71rCFO+q2mqkCARfjBC9wsezuynhiPCNlQTvxQcCaX0eocrOA7n0NYNXtQe6+0IM96NCGD7lNDEbDxEajeL/bBkeggmyU1d85dBzvUNzEihGalc73Vgica9d4Hp8XHKlVTB6ZU97D5dk3755Hpdxsyh+n5Kfh57MZZ7yc8OsuxrQw12yP0x45SGks2GXiMqdVvPfT99UjQBb5XPhYRMdBVMahqPqFFQg9LRzz+PzODfDsuyaDQPvubzCsiFE/lHRT+w9bgI/k23eMcH/txb43Ed2Gup8yY91WgV1t+GTR9mOxRVH7hfnY9ySM0uorWyW2s2V1N9cOWwgkeYNJcbdGhVewMwOcee7NQ2m80adN1JmRJ3xLNLP0+PkVDtDSTT7HNfn9OhRqjS9W9qQf94VPe1+pg8UmU1cdw2BxQYLzJ8EdzCX0f3O0NUTFa+GL8IdocspQUjns3pjLgEzklz2cMeDfAa3Up1zyuyk9pxaDtNXQ7KrX1/4bvlODOvYrWKZ8pV6YFRvDEKH
 3NXmvm3k
 dotgcjl1mhdpHkYa4L17nP4d58hjhk0rPLvGh+Jv81Sdz85xllkb72kg4iTpFtTLlrz1+N9YzWUe+YP4aE28Gr/bATeHpwHMizxkGjQTR9bnOcWYa0zcHXPygbh47blBCOcCdzDDBJHETMMloswsM5QHh/OvbTsXqKg8bw7a4H36rP+9Ap9rNLpax7GSrS6lvM5mieewBtAdGXx/aIb5IGMdf79vQpfbcr72bJMtetEWIbJreysTTfpUed2AEnD4Av20SZCni1Nvm5DEZ5iXu3Ff4834uBNhIXLzk9nskLownmBaLd+Xk0AGE1TX86zBWWxAJ5GTMpAhsraWdHeSQRomeh0XLzAf0+W/yv8V9ECe2qZGDdG5YkN0cshYw2Xibn+AH4ehyenByVSVkGTrnTHCVAWG1BIg3apWhFx5yWj72P89Yn/lGR7OZt3rYiW6Owo9t1L7VmwGF2Av10PfH9NA/fEDBjQBq6uyh9SNIU+qLXiz1eU91Fjhrt2JHjnaHxPg4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of tiered memory among the workloads, as the only
enforceable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring consistent baseline performance difficult, as each
workload's performance is heavily impacted by workload-external factors
such as which other workloads are co-located in the same host, and the
order in which the workloads are started.

Extend the existing memory.high protection to be tier-aware.

Depending on the combination of limit breaches, selectively reclaim on
tiers: when memory.high is breached, perform reclaim on all tiers.
When memory.high is safe but individual tier limits are breached,
perform targeted reclaim on those tiers only.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 66 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 025496794cb91..44ea465b2005d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2387,6 +2387,28 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 	return 0;
 }
 
+static bool memcg_tier_over_limit(struct mem_cgroup *memcg,
+				  unsigned long *overage, int *breached_slot)
+{
+	int nr_tier_slots = mt_nr_tier_slots();
+
+	for (int slot = 0; slot < nr_tier_slots; slot++) {
+		unsigned long usage = page_counter_read(&memcg->tier[slot]);
+		unsigned long limit = READ_ONCE(memcg->tier[slot].high);
+
+		if (usage <= limit)
+			continue;
+
+		if (overage)
+			*overage = usage - limit;
+		if (breached_slot)
+			*breached_slot = slot;
+		return true;
+	}
+
+	return false;
+}
+
 static unsigned long reclaim_high(struct mem_cgroup *memcg,
 				  unsigned int nr_pages,
 				  gfp_t gfp_mask)
@@ -2395,10 +2417,19 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 	do {
 		unsigned long pflags;
+		const nodemask_t *reclaim_nodes = NULL;
 
 		if (page_counter_read(&memcg->memory) <=
-		    READ_ONCE(memcg->memory.high))
-			continue;
+		    READ_ONCE(memcg->memory.high)) {
+			int slot;
+
+			if (!mem_cgroup_tiered_limits())
+				continue;
+			if (!memcg_tier_over_limit(memcg, NULL, &slot))
+				continue;
+
+			reclaim_nodes = mt_tier_nodes(slot);
+		}
 
 		memcg_memory_event(memcg, MEMCG_HIGH);
 
@@ -2406,7 +2437,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL, NULL);
+							NULL, reclaim_nodes);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2842,23 +2873,25 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		bool mem_high, swap_high;
+		bool mem_high, swap_high, tier_high;
 
 		mem_high = page_counter_read(&memcg->memory) >
 			READ_ONCE(memcg->memory.high);
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
+		tier_high = mem_cgroup_tiered_limits() &&
+			memcg_tier_over_limit(memcg, NULL, NULL);
 
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
-			if (mem_high) {
+			if (mem_high || tier_high) {
 				schedule_work(&memcg->high_work);
 				break;
 			}
 			continue;
 		}
 
-		if (mem_high || swap_high) {
+		if (mem_high || swap_high || tier_high) {
 			/*
 			 * The allocating tasks in this cgroup will need to do
 			 * reclaim or be throttled to prevent further growth
@@ -4967,13 +5000,24 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
+		unsigned long reclaimed, charge;
+		const nodemask_t *reclaim_nodes = NULL;
 
 		if (high != READ_ONCE(memcg->memory.high))
 			break;
 
-		if (nr_pages <= high)
-			break;
+		if (nr_pages <= high) {
+			int slot;
+
+			if (!mem_cgroup_tiered_limits())
+				break;
+			if (!memcg_tier_over_limit(memcg, &charge, &slot))
+				break;
+
+			reclaim_nodes = mt_tier_nodes(slot);
+		} else {
+			charge = nr_pages - high;
+		}
 
 		if (signal_pending(current))
 			break;
@@ -4988,9 +5032,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+		reclaimed = try_to_free_mem_cgroup_pages(memcg, charge,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL);
+					NULL, reclaim_nodes);
 
 		if (!reclaimed && !nr_retries--)
 			break;
-- 
2.53.0-Meta


