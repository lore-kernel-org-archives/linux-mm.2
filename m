Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CC2FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2066B008C; Mon, 27 Apr 2026 11:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72276B009B; Mon, 27 Apr 2026 11:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B887B6B009D; Mon, 27 Apr 2026 11:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A64CF6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:23:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAC811A110B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:15:39 +0000 (UTC)
X-FDA: 84704685198.25.351825F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf10.hostedemail.com (Postfix) with ESMTP id D300DC0014
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:15:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyC+MUfR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jd9QhMaZWQ579fnGzAG/I0g6AYG3iE95eKJUgWYdoBo=;
	b=XaxVkaTau2VaDYJcsyoS1qetUKOLc/mIXV9Dfa49tp9ABIw6VgLoGJcNFFvEbIWihbbXIP
	w7JjJ+TNtH4MNo0gtOdS9Xghf5TGcwbPSUJFb1Qz5R+BFTCWXZ9ie3NLWF3ETPg74z/y4t
	2AXS8N9Ocpp0EFMqPZQ4A11SiMYZDMY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302938; a=rsa-sha256;
	cv=none;
	b=QQRO/ClmlWq+/yD+DXpT3AChweEEzcR93TheehHsRbwSVUAdGrZJ7fNz/F9oZd7iNzm57d
	HQHVZ6WxoH1TFSNx97fISrFN1rxlLm3iK6FHTH0Dzqpj0XuWwiqB7XQjCb4eTnZS9rQHSp
	KV2aRw2+AMWcHK4/ije4eS5bIPo+CQE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uyC+MUfR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777302933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jd9QhMaZWQ579fnGzAG/I0g6AYG3iE95eKJUgWYdoBo=;
	b=uyC+MUfRhNzhccrU6CX8vtKnKxO6vG1tdjIQQt8zs6n00QnSWN+rob3uo8d2SFwPm78Tsc
	tNZgdE0d/e7l/y2roVsezpF0qdVsqEfYselYECA0HEEPDSiazt8/ugBz/1xE8fDxzpH4eF
	IiphYKVuMyOPwz3UcRYnd5/Y35F8Lcc=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	ying.huang@linux.alibaba.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	gourry@gourry.net
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v4] mm/mempolicy: track user-defined mempolicy allocations
Date: Mon, 27 Apr 2026 08:15:20 -0700
Message-ID: <20260427151520.137341-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: D300DC0014
X-Rspamd-Server: rspam04
X-Stat-Signature: 46h16mii176mt7jwnprt34cm7a75gxta
X-HE-Tag: 1777302937-330267
X-HE-Meta: U2FsdGVkX18fYJRpPqVx2cH9IoDhm8A4gDRkEFSNjKUCcvzyC1wuOHpUxRo2Y7npaUJuC9LJC6c29v3VoWNfhh9jv4zXEBlLwKl4EkhV0XPuwJ1gRirseSqai9QznGbWzx8zsr/ZrGNb7QXH69dw7ry/9OdEeAnjafPCQq1SI5xyQo/fntvGyFSXTpfvxaVMnezRpvxlmWArpUGnoorN61u+MzgU1vqFUAQ4FkH5VZ0Yr3lc5lBtTRdP+x8xyshaMpkKiypsp+g12bmPIkkh4tkdaFLBNuzCn0noHbY6Qj5b67qQ/evbkTxXwjvlvTiu3cUTu3swaph5iSYruEwpFyGm7ix0PxYCiZWRTlZmP4MnvUN9+wjkte1Lwc88fR1XqQMSaRDDshniAKfLCemfG5sT7g6BzDTYC3kXUjUAV50mFA3sqUXh0GcjgwlwiS1FGW7amAcFhesKJ4heIzFELHS2Q4O6dABc0WXGh9ljfpFtRhmaUS5WClUn+yAHbTkYH4TIif/0a1Ene/4TXtUCh1tiFbBIn7T5jXSoWEGirtR1rAUTHtuGq9KOGLLREIt4d4Ai28yEaY/sroMCSZDpnOlBhkypoVuDrIt1n0ctXvizOLHyLupTg3i+JOR41nowLXaT+oWgY9CIPPal/hN14DKvATUUPOYrIRTN0YlwOaV1DBOefLsgsuaauKf5XWWQtO0bn6p1LLbJS3LFXn98Ql3MAQUMmGZnexRJnWZwnc/Zra/Bld8d8qSo0UNuV46Ou0Bt2XPe04fgHlgz23NTO2gnBtz4s/xZ3bIZDRf3PmHfYjIlvy5WvbGtIA1fQJ0dpu15W9DvhaZm4z2S9ObGWu3RaNI8LNLyaJmqkEFZGnF1cJlWuDp7xHUh98MTj0zlxBof3kGkGapEcCfSONgAdEffFaiu6JzNRVnckdRB2W0NcdhCWG7BJ7Mnh5+NtGRuWsblDAmz/N5/zC0TkmM
 Wxv8tJ6l
 wpl4S1U7wRFL+9duf7RgLkWHMEUy7ViCZRukiiFOgLF4BTNu0l1F0Ja6+ODwX0ipd5h+uORQChJL7jzjQ64wrxtLdG34850sy4fTrWOzPA9mhmK78ZrWCSyIVm9b12m5lysOh1htiSaU+iIKzozOjoEuIkLgcY4iCMBUh7H5SSenih1O/L9M/MJZ/A1JP+t5J6v/AhiJdgdEB+kiH8wzppO4B3U2AEBJEn6EoGZWULi7rEIRE4XUrP0Q5bjjU8alaOmkd0ngqcjXCLwZ/nvb51Xzx0N7FrTzy/XcMiOvLbNwWwkQ7EvEA4Hw2i3kH2hA++0UR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When investigating pressure on a NUMA node, there is no straightforward way
to determine which user-defined policies are driving allocations to it.

Add NUMA mempolicy allocation counters as new node stat items. These
counters track allocations to nodes and also whether the allocations were
intentional or fallbacks.

The new stats follow the existing numa hit/miss/foreign style and have the
following meanings:

  hit
    - for nodemask-based policies, allocation succeeded within nodemask
    - for other policies, allocation succeeded on intended node
    - counted on actual_nid
  miss
    - allocation landed on actual_nid instead of intended_nid
    - counted on actual_nid
  foreign
    - allocation intended for intended_nid, but landed on actual_nid
    - counted on intended_nid

The existing numa_* counters cannot be adjusted to fill this role because
they are incremented in zone_statistics(), which also covers non-policy
allocations such as alloc_pages_node(). The mempolicy context is not
applicable at that level since in-kernel callers may make their own node
decisions independent of any task policy.

Allocations using the system default policies (default_policy and
preferred_node_policy[]) are excluded since they do not reflect a user
designation and are already accounted for in the existing numa_* stats.
This covers both task-level defaults and ensures VMA-level policies set via
mbind() are correctly counted. The logic for checking against the default
policies was already present in mpol_to_str() so it was factored out.

Counters are exposed per-node in nodeN/vmstat and globally in /proc/vmstat.
They provide the information needed in step 3 of the investigation workflow
below:

1) Pressure/OOMs reported while system-wide memory is free.
2) Check /proc/zoneinfo or per-node stats in .../nodeN/vmstat to narrow
   down node(s) under pressure.
3) Check numa_mpol_{hit,miss,foreign} counters (added by this patch) on
   node(s) to see what policy is driving allocations there (and whether
   they are intentional vs fallback).
     - If active: a user-defined policy is driving allocations to the
       node. Proceed to step 4.
     - If inactive: pressure is from allocations without a user-defined
       policy. Stop and investigate task placement or node capacity
       instead.
4) Use /proc/*/numa_maps to identify tasks using the policy.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
The main feedback addressed up to this point has been the semantics behind the
stats. The stats are only counted for user-specified policies.

v4:
  - Factor out default policy check from mpol_to_str()
  - Check against default policies instead of using current->mempolicy
  - Change wording for hit/miss/foreign meaning to use {actual,intended}_node

v3: https://lore.kernel.org/linux-mm/20260317050657.47494-1-jp.kobryn@linux.dev/
  - Moved stats off of memcg
  - Switched from per-policy to aggregated counters (18 -> 3)
  - Filter allocations with no user-specified policy

v2: https://lore.kernel.org/linux-mm/20260307045520.247998-1-jp.kobryn@linux.dev/
  - Replaced single per-policy total counter (PGALLOC_MPOL_*) with
    hit/miss/foreign triplet per policy
  - Changed from global node stats to per-memcg per-node tracking

v1: https://lore.kernel.org/linux-mm/20260212045109.255391-2-inwardvessel@gmail.com/

 include/linux/mmzone.h |  5 ++++
 mm/mempolicy.c         | 65 +++++++++++++++++++++++++++++++++++++-----
 mm/vmstat.c            |  5 ++++
 3 files changed, 68 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da59..602060b4da4b3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,11 @@ enum node_stat_item {
 	PGSCAN_ANON,
 	PGSCAN_FILE,
 	PGREFILL,
+#ifdef CONFIG_NUMA
+	NUMA_MPOL_HIT,
+	NUMA_MPOL_MISS,
+	NUMA_MPOL_FOREIGN,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4e4421b22b59f..28e82753317b2 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2432,6 +2432,54 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	return page;
 }
 
+static bool is_default_policy(struct mempolicy *pol)
+{
+	return pol == &default_policy ||
+	       (pol >= &preferred_node_policy[0] &&
+		pol <= &preferred_node_policy[ARRAY_SIZE(preferred_node_policy) - 1]);
+}
+
+/*
+ * Count a user-defined mempolicy allocation. Stats are tracked per-node.
+ * The following numa_mpol_{hit/miss/foreign} pattern is used:
+ *
+ *   hit
+ *     - for nodemask-based policies, allocation succeeded within nodemask
+ *     - for other policies, allocation succeeded on intended node
+ *     - counted on actual_nid
+ *   miss
+ *     - allocation landed on actual_nid instead of intended_nid
+ *     - counted on actual_nid
+ *   foreign
+ *     - allocation intended for intended_nid, but landed on actual_nid
+ *     - counted on intended_nid
+ */
+static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
+				  struct page *page, unsigned int order)
+{
+	int actual_nid = page_to_nid(page);
+	long nr_pages = 1L << order;
+	bool is_hit;
+
+	if (is_default_policy(pol))
+		return;
+
+	if (pol->mode == MPOL_BIND || pol->mode == MPOL_PREFERRED_MANY)
+		is_hit = node_isset(actual_nid, pol->nodes);
+	else
+		is_hit = (actual_nid == intended_nid);
+
+	if (is_hit) {
+		mod_node_page_state(NODE_DATA(actual_nid), NUMA_MPOL_HIT, nr_pages);
+	} else {
+		/* account for miss on the fallback node */
+		mod_node_page_state(NODE_DATA(actual_nid), NUMA_MPOL_MISS, nr_pages);
+
+		/* account for foreign on the intended node */
+		mod_node_page_state(NODE_DATA(intended_nid), NUMA_MPOL_FOREIGN, nr_pages);
+	}
+}
+
 /**
  * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
@@ -2450,8 +2498,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
-	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		goto out;
+	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2477,7 +2527,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
 				nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
-				return page;
+				goto out;
 			/*
 			 * If hugepage allocations are configured to always
 			 * synchronous compact or the vma has been madvised
@@ -2500,6 +2550,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
+out:
+	if (page)
+		mpol_count_numa_alloc(pol, nid, page, order);
+
 	return page;
 }
 
@@ -3559,10 +3613,7 @@ void mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol &&
-	    pol != &default_policy &&
-	    !(pol >= &preferred_node_policy[0] &&
-	      pol <= &preferred_node_policy[ARRAY_SIZE(preferred_node_policy) - 1])) {
+	if (pol && !is_default_policy(pol)) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 761718eea2827..a5e7a0cb4678d 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1290,6 +1290,11 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
 	[I(PGREFILL)]				= "pgrefill",
+#ifdef CONFIG_NUMA
+	[I(NUMA_MPOL_HIT)]			= "numa_mpol_hit",
+	[I(NUMA_MPOL_MISS)]			= "numa_mpol_miss",
+	[I(NUMA_MPOL_FOREIGN)]			= "numa_mpol_foreign",
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
-- 
2.52.0


