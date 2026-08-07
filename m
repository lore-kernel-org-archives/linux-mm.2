Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44A2C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367686B00A3; Fri,  7 Aug 2026 16:21:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1A56B00A4; Fri,  7 Aug 2026 16:21:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA206B00A5; Fri,  7 Aug 2026 16:21:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEFFE6B00A3
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54471120135
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:24 +0000 (UTC)
X-FDA: 85075593288.01.1575960
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 94C4A1A0003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YxBBBwrz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gNurNSPYyJZesKOZSqzZdKIcfvAei88zp/AV04IWMMU=;
	b=VLVdISbWQoitxbC4+Jdn+xOnzIAsAg2vo3nUH/uepWVU+YYn0SgfenLI9S3BMd89cJ0XKC
	yx40eLNLHcNxJFsGpPS+WP4+a6U7ZttIUOmnfbew2AtabmYw29hoVw7Vrf2g/01Ft+3it7
	u/XJ6BPoU+bMTbiZBYhSmFrjHiFHAYU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YxBBBwrz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134082;
	b=4Lanz8DtT+YSHBpl/EFPizJGk+N7XmXuE21oIxaZgqd6+uU9zg/USXGBFuMzDo3YwhL+55
	tDPV4AzAJJdGF2MMc3ZGSmcvmtnKB4bmnhJ1GuwxIod3sxeIpbK9c+McTQxVD7BRnKwE8L
	8tcJRhNilDSn31YPcOIo8CWchYD/09Y=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6aae90e595fso1713324eaf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134081; x=1786738881; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gNurNSPYyJZesKOZSqzZdKIcfvAei88zp/AV04IWMMU=;
        b=YxBBBwrz5MtBFyAPs6Dask+B9boDOCJsvLtua1vSdOXTuS3NieIdgLJGkSFZWSmF7u
         Hpgbr8IRCIzjoURld656UIBFu3IQlF2iaST0/6WgRxzhzkQCPv0k9pRv9ihZFnxLvVMd
         q01RGXCwm/8Jf5Xj+pRAUtJwiGdglpSj/lWlj7RNAYEfCvJxpjvkzy8Lx2uW6SAzErlB
         s/HiceXfY4dCFKZig06Vf0dWy1E4D3Buqp3AN3xWShJAnZ6ZWQgIb8yKVUSHWxeyWoau
         KS9b70ko1bw5ljQ9e4f1dmfn/5DwrB3p2oAmJaALPgOIznj+s+xUBrlJwJ3dnNr+51Pw
         qGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134081; x=1786738881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gNurNSPYyJZesKOZSqzZdKIcfvAei88zp/AV04IWMMU=;
        b=Bv3F6G7aJkZp1MSVNn2Toh/XfQU/PmWmJEck+Pi8LspKznitrKXB17QGnG4KZhf/ma
         LcmuCtIUrQZJPgzoNOrjqnCQt+S3Lvv8tFcBFXilyPpWGrPYqP3pxLQM9XJGaLNvDDFL
         0KuUzD7bJc0EykloM9piIxrTpiAcvqJ8cbjJ+2JVVFa1kVN5Hqx+tRaTdj9JE9XOXlS5
         3NtIcHxUeHFtlnsk+okXwZRbNqntQCExWCm0yOp3U2lPycc4Uk0u078Qmstu5SvmpTFS
         YIt0V/8z2xSxzDrmcE5+o0yTw7VyAa/ykN58kHPBAmV9IoicjEsrRO96f09XcBtsEov8
         fkvg==
X-Forwarded-Encrypted: i=1; AHgh+Rqp+/cahRRRWnGD+vcqBhOuZXynGWQHK+aTMjJzg0Sa2CNgWrqR4Cl+CiXCguRZqJceRuUIfmMcBQ==@kvack.org
X-Gm-Message-State: AOJu0YzVVzr1Ab0+HhEYQZhvKx57eDWFwjuW+8E6MBqV8Ol+EbP8rnJq
	0cEEbRsSuhXZaj8MsWr8am4XTbP21eLK5EaQROxR752VdHokz+N6Hu0v
X-Gm-Gg: AR+sD13YN9l5nj/IJ2Z0jTncobQrJE9gDPbRG80nWrUN4bVKIdJTr/PLGc4zKFmaynf
	ajGx+mw92R/r7h32BHj3Mp47buwNSFLDILH6m+L7PaHLzHPKaZVEcz1Npra01KBk/hbkLMEaKrM
	WZSj7Ty2ksW5jo6cdliiE5ns25jZzAKb2i0ftlLNsy7yTx4FQH6Lfh+Ik8QTtTJHOShWRqFgXaW
	CKUCNUsUTyi2XiFvbe1VcvuCPvrd/Zvm+5yxgc5oQxN2EcYVTloXvRFNVXZsJ/deIjfBiM5O/Pk
	QdMqhSP6GUHmNpjNpainKTiHMVvbIyMXlMlZb5QIWf0DXJZyArOgWhB0uSGEClD63R9rv268yjG
	H4PtNGMOS+OcMz956U024LTd6vEBVVEsvO/KazxhWjoXqX8J5/BIkeRcxHzgqfSx6nTmaK6LJC9
	RSfYabvU8/ebmzjBwZ/yvLSDNw8ASwTYNOlwdZfWFrg3JQIqH463eKoXQP26gkTkFxD1I6MYBXW
	IVjmMkmE4c1aQ5Q/E4=
X-Received: by 2002:a05:6820:150f:b0:6ab:3c7:da56 with SMTP id 006d021491bc7-6ae96f6cfdbmr12464583eaf.24.1786134081584;
        Fri, 07 Aug 2026 13:21:21 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02be475b6sm3130491eaf.11.2026.08.07.13.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:21 -0700 (PDT)
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
Subject: [RFC PATCH v3 14/14] mm/page_alloc: steer allocations away from exhausted memory tiers
Date: Fri,  7 Aug 2026 13:20:57 -0700
Message-ID: <20260807202059.2620949-15-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ridj65fwhkriz51dfku8zt6daf73fxpz
X-Rspamd-Queue-Id: 94C4A1A0003
X-HE-Tag: 1786134082-913863
X-HE-Meta: U2FsdGVkX1+sA/9AraaWXTWAx7TTTByuTGTL/slnU5EQLPCfQJR73XpRnTNPIW1hlHZfcU6SaEgqnp+DxyXOB8TQJfcIhwLyh+LJKepNAXh16951j5urlJMEJa45kRNfJPvqrKN1axJZVxH4bBmimFXTu7NsHGGZPCAp6f12/PCf0PD5PzURGs9GYaA363ei7ye426hNi9dnDnYKNh0L8psrq0CD8UyDM2taToBGe9n2jtorAKISaD4Le277C4ii9SLbDlMct51xR96j4luGi+vjGRXFDkjNBi+2PZaOKoBPaTJpT/Ekybqg7WyE5mcobFHdF7RUxLxr+/7enQeYcelkkn0HdH0AVxhze20c0HrUjQjsrzzm4tXOO8g40Zt4VsVif11F9RLvgtVi33Ru+g6QJBw5NOs1gtyKE/QZHWFQUFT0Nrb+D7c52ItTZkaWoeCi2AKv5pdUouUUvQ8ZkS67LFZBLzqqf/Y1j771RaeL6VxBpwjFDfmr2mEnNIlnIWUH9OwsnDfeM4YSIqTIvMMPISpcv26M0Kb4aDZVSaUraqeei51Y2LkQ5U2SD6gMAHGg6y5XK443T5n0WLgp16Cbpom/WdJlasyYptoxHYcd9+juBow8OpmRPIHYSDWgMj/K64x73Tf1csa5HvZsSt1syz6pr8IOh0PEOQn2Q4VYe8IedSCUEgx/2eTiaWxe3DnYq05TLUwsYB2SDZeE7FlbmRE7QbTa7qtCnQdloub4YvKVb9Bt/Qw+TtbS5QwMMx+nisqoKE7bMgJ9aJvwepFext7tqq228pVJgfNnHV2KFzDyTNClOzg4tsB4LsPp3UNSySwCE9DQcQS1v40GLXKl3RYQbiWx7GgOQJ1VDc6G49IRodslajRQIYnvC3/yH3h50BqfltLlGvtgQmWIvNtgl/rjula9LEr0A5sgTanYgSBirns+RPp+EdA+rZAhrs/+ZQ3qDIlwztFDqlu
 xADRvuDl
 ayNbSWxy/Y+ezklVa0BvX6ULNbefiWFUJg1Zytk/v5UhwiRsOjs8n0ea4CZb53nproPoDCNJL9narvhiDDNe09h20oSXKXJNDYt9VHwYTLRNA2mzSJXSXRRjpMngvYzmHApXmQ21ij9E8s9hNL6UQg60YeiQTiNFNvQ+zF+o1oGEeGxbMDR3Qq/uODzANd+1x4ihkMpV8PQ9wXss9gg77EZE+msSajshwm+ZSbAb7QYxaJNwEnLnEdAXTbU1x2MlXc7Eu3M+WzIXIkFnmml3GLtgmUjrbI/bg0UHKyTVrd63Dfyg2h2LthkrnWdMmjkPfgTzQ2t/Kf3/glvKU1ee2UGSqhg8/pTwPRkTfn1YIJKLGg7TUtA/XvADT4qkamiHSveYXYfyFm9MXZrNSZNBq2kxLGYDwXCEc3g2tCEfCYy3GF/u6Fv/SB5x1UD/tUjDDeLpbR6zy8F3z6+v894XlXjl0Qs7rnxvZoYTHnJku08Lg0yLDrkhJ7VBC9hkyjxcPwGOgNevbzGtTnD2kwND6d09h7z9qpqs6Uyjmdq1lsc/FRkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A memcg only finds out that it is over a tier's limit at
try_charge_memcg time, after the page has already been allocated on the
full tier's node. This triggers reclaim to push memory to lower tiers or
to swap, much like how zone_reclaim_mode triggers reclaim when a node is
full.

This causes a lot of unnecessary churn. Instead of allocating a page on
a full tier only to immediately reclaim, make the page allocator
aware of tier limits at allocation time and steer the first allocation
attempt to nodes belonging to tiers with tiered limit headroom.

This only affects the ac->nodemask for the fastpath, meaning if no
node can satisfy this allocation, it falls back to the caller's nodemask
and places a page on a full tier, triggering reclaim. Moreover, if it
turns out that the intersection of the allocation context nodemask and
the under-limit nodemask is empty, skip the steering.

This steering only affects MIGRATE_MOVABLE allocations. We try not to
steer kernel allocations using NUMA_NO_NODE which would prefer to remain
on higher tiers, even if they are full.

This steering also does not affect alloc_pages_bulk_noprof, since
its callers do not charge their memory allocations to a tier.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  6 +++++
 mm/memcontrol.c            | 46 ++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            | 19 +++++++++++++---
 3 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a7c366b431a0e..b700f3224cbaa 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -655,6 +655,7 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 }
 
 bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid);
+bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask);
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
@@ -1179,6 +1180,11 @@ static inline bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
 	return false;
 }
 
+static inline bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask)
+{
+	return false;
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 05611a01aa082..e499e58baa287 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2625,6 +2625,52 @@ bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
 	return false;
 }
 
+/*
+ * Returns whether a mem_cgroup is above a tier's limit.
+ * The nodemask becomes populated with nodes that are under their limits.
+ */
+bool mem_cgroup_tier_allowed_nodemask(nodemask_t *mask)
+{
+	struct mem_cgroup *memcg;
+	int nr_tier_slots;
+	bool restricted = false;
+
+	if (!mem_cgroup_tiered_limits())
+		return false;
+
+	nr_tier_slots = mt_nr_tier_slots();
+	*mask = node_states[N_MEMORY];
+
+	rcu_read_lock();
+	memcg = active_memcg();
+	if (!memcg && in_task() && current->mm)
+		memcg = mem_cgroup_from_task(rcu_dereference(current->mm->owner));
+
+	for (; memcg && !mem_cgroup_is_root(memcg);
+	     memcg = parent_mem_cgroup(memcg)) {
+		if (READ_ONCE(memcg->memory.max) == PAGE_COUNTER_MAX &&
+		    READ_ONCE(memcg->memory.high) == PAGE_COUNTER_MAX)
+			continue;
+
+		for (int slot = 0; slot < nr_tier_slots; slot++) {
+			struct page_counter *tier = &memcg->tier[slot];
+			unsigned long limit;
+
+			limit = min(READ_ONCE(tier->high),
+				    READ_ONCE(tier->max));
+
+			if (page_counter_read(tier) <= limit)
+				continue;
+
+			restricted = true;
+			nodes_andnot(*mask, *mask, *mt_tier_nodes(slot));
+		}
+	}
+	rcu_read_unlock();
+
+	return restricted;
+}
+
 /*
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0aeca106a4fde..7ca0acc37d2af 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5153,7 +5153,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		int preferred_nid, nodemask_t *nodemask,
 		struct alloc_context *ac, gfp_t *alloc_gfp,
-		unsigned int *alloc_flags)
+		unsigned int *alloc_flags, nodemask_t *tier_nodes)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
 	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
@@ -5187,6 +5187,17 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	/* Dirty zone balancing only done in the fast path */
 	ac->spread_dirty_pages = (gfp_mask & __GFP_WRITE);
 
+	if (mem_cgroup_tiered_limits() && tier_nodes &&
+	    !(gfp_mask & __GFP_THISNODE) &&
+	    ac->migratetype == MIGRATE_MOVABLE &&
+	    mem_cgroup_tier_allowed_nodemask(tier_nodes)) {
+		if (ac->nodemask)
+			nodes_and(*tier_nodes, *tier_nodes, *ac->nodemask);
+		/* tier_nodes must outlive the function call since ac uses it */
+		if (!nodes_empty(*tier_nodes))
+			ac->nodemask = tier_nodes;
+	}
+
 	/*
 	 * The preferred zone is used for statistics but crucially it is
 	 * also used as the starting point for the zonelist iterator. It
@@ -5269,7 +5280,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp,
+				 &alloc_flags, NULL))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5451,6 +5463,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 		.alloc_flags = alloc_flags,
 	};
 	unsigned int fastpath_alloc_flags = alloc_flags;
+	nodemask_t tier_nodes;
 
 	/* Other flags could be supported later if needed. */
 	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
@@ -5481,7 +5494,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	gfp = current_gfp_context(gfp);
 	alloc_gfp = gfp;
 	if (!prepare_alloc_pages(gfp, order, preferred_nid, nodemask, &ac,
-			&alloc_gfp, &fastpath_alloc_flags))
+			&alloc_gfp, &fastpath_alloc_flags, &tier_nodes))
 		return NULL;
 
 	if (!(alloc_flags & ALLOC_NOLOCK)) {
-- 
2.53.0-Meta


