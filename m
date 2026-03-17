Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B56FB5EBB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 05:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5F86B0005; Tue, 17 Mar 2026 01:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2670D6B0088; Tue, 17 Mar 2026 01:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C6E6B0089; Tue, 17 Mar 2026 01:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 04B226B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 01:07:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 985BD1C7CF
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:07:32 +0000 (UTC)
X-FDA: 84554371944.02.9426225
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 62EF6180009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:07:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kq8XzDBT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773724051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jvrzqhBOTMeu5FRh46JduvKJCMGJbDc0HHQDFMieGFg=;
	b=UTLtTtwt6wRtPIuYFE9yFh8rhMRU/QNUhJxxc0KuM16MvhCbXMppasdY97TeNwNs2ywAQ+
	TfBWCHke5kEeL8JkzkM7ICfFDEcUp2PnT+/7Gzn5iB+EmiwW0NnjRvdLEjSk4j+PFzUoly
	TRRQTMs8vcRqDsaMxW23E8C5AqnBzW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773724051; a=rsa-sha256;
	cv=none;
	b=Atjn/fzk4wbOaLXNGIrOeaHQ4w2z5UHQxJmBHrT1xKGGXOpY7kV4qTk6znSq5V4SxtGcOn
	QH0BP2mUG/yKgdRnnjiRjhovYK4PXhcxZlWG5Vuk9YOSuKuvkjzOLMbGIX9ZYWIYUKQTXv
	3n7Xc3H5+wzS+A4aqQSN4Fk9PRge1SA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kq8XzDBT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773724045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jvrzqhBOTMeu5FRh46JduvKJCMGJbDc0HHQDFMieGFg=;
	b=kq8XzDBTIQsxWSNBDIDdDU3wpU2A9uAaKLj7F9RRgUTdEKLh/aUKY096/XXdbF1cfVia0G
	UuxREMFrxr3Gnv+Z8n/bBMoN3+lBsu+rPARb1wyLivp3zdOxajcPEPmzxts+MYlwKHRhra
	ybVR7w+A29IdIhXoL6edmwz2nJTjky4=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	vbabka@suse.cz,
	ying.huang@linux.alibaba.com
Cc: apopple@nvidia.com,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH v3] mm/mempolicy: track user-defined mempolicy allocations
Date: Mon, 16 Mar 2026 22:06:57 -0700
Message-ID: <20260317050657.47494-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 62EF6180009
X-Stat-Signature: fsbj8m4d8q9ybpgq4sgw9bmzhibzjwcb
X-Rspam-User: 
X-HE-Tag: 1773724049-73082
X-HE-Meta: U2FsdGVkX18vJCLqIdXHM7eKObwnv/gNEebZcNTV7enqRkURK3t2pDkarbvTAr58uHne3YKtUowDclIQ9Y7OJN0JXt0B72YdxiKgqZd6PNpki7HzMuS2WjgqrFbTfbrRKqLUWwOh/0jkSplGrO64DkhfTvIfDAEbfXted3mBZm7usLpPob6mvbEP0qJNiyGMUqT+hZdCDNUbP5Rpi/Pvvw/lWiYiISFjpaBKSWEpBBxEgbeyyPy85cM/ZsllF+e96Sdodi40JIHHrpt0Xw/JlnJlR3fNCROydiQIIgqsPILzSJWk7opcXT58HpnLAVB6JhoB7b8rDJY7bref2De+RCizhEIxOymt2/ViucrBJc9feGhqhyBRywLSdaPcYhpiU3KdmKdYvUBKfExIa4JM8RwIUJmfgW/Mp4TSDxiFNUyus3r/jfO7PDbfx2IoTSbltrMvDiOhW41/Iz7iDStSOKOsGAUFdoQ0tE/d27lvssWvWZ/iYamIffwDRAEHUEQoKsTmOAe/RIj7UZO4jf+kMDK0fkCeOpWRat3tW1Qveh9AMJpdzCdN0vQe6i+uZt3ELGe09QXnEDCm4JwSnwJbK0STpKYda1gtMjgaUWBAVKbRuNRRMbys960hKUsc+DFFaXaC+08SH+ug8XZ+ct6i0ERjN6en9YvF6wsixX6NBY3r9h5xhEDDbpUNtdGgst935Dia9yFXOmx5uZrjLskMLdhVd8OQiom4YMEc8ki6RUrozS5FyRFYzap9G5Ow1f/n17QptnQfeKRf6wpcNEaiR1nvxwCdhxcQAyCnGE7eGahXLfUZEUoSJ/fY8oVT148srgPsgd2y7JSx6E5c/Iv7hvIXkgVQnsh0ezR1SeEadO0ZABHVJa8YkmWJ+/zxrMZBtjaEQpfPlhAKPfKdzINA7hutj8AS6vWExkvulm+qQTSxOZY7he1m6fGOuOrWNBQZHE8As2LDCf9m8KhDGC9
 e0/Fxrnf
 hz684iLmEl12Ilc+ZTTI4xMHF7c6k93Kk3r+T5uJvljDxJYFgQledcpb2IAs3i/hr4UfGWvCIPaFGMSz6mtjZ30OqoeASyAVB080X18/mxT7TKMsWZ27h/2Yp4eGgz9V8ddbkzy0EUARFbOzFUQselYOT/uK3aKw2VcJ8uOcldhDjRhTUxO4zlGhrQAssD7eHPXYjoWOhVw85v4mHSArip7gPXyHn+5TKBLBO4MSDlj63P+fUeBrR9mj3V3UoqDptZEIXYQTuDNiPivYBwEpSlcgIcXwo7IwkBr5USawqnyLQol1j6ae6xmsASbYmJRLnLCTL
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
    - counted on the node of the allocation
  miss
    - allocation intended for other node, but happened on this one
    - counted on other node
  foreign
    - allocation intended on this node, but happened on other node
    - counted on this node

The existing numa_* counters cannot be adjusted to fill this role because
they are incremented in zone_statistics(), which also covers non-policy
allocations such as alloc_pages_node(). The mempolicy context is not
applicable at that level since in-kernel callers may make their own node
decisions independent of any task policy.

Allocations where task mempolicy is NULL are excluded since they do not
reflect a user designation and are already accounted for in the existing
numa_* stats.

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
v3:
  - Moved stats off of memcg
  - Switched from per-policy to aggregated counters (18 -> 3)
  - Filter allocations with no user-specified policy

v2: https://lore.kernel.org/linux-mm/20260307045520.247998-1-jp.kobryn@linux.dev/
  - Replaced single per-policy total counter (PGALLOC_MPOL_*) with
    hit/miss/foreign triplet per policy
  - Changed from global node stats to per-memcg per-node tracking

v1: https://lore.kernel.org/linux-mm/20260212045109.255391-2-inwardvessel@gmail.com/

 include/linux/mmzone.h |  5 ++++
 mm/mempolicy.c         | 53 +++++++++++++++++++++++++++++++++++++++---
 mm/vmstat.c            |  5 ++++
 3 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241c..a9407a3b4c8a 100644
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
index e5528c35bbb8..c3bacc927a21 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2426,6 +2426,47 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	return page;
 }
 
+/*
+ * Count a user-defined mempolicy allocation. Stats are tracked per-node.
+ * The following numa_mpol_{hit/miss/foreign} pattern is used:
+ *
+ *   hit
+ *     - for nodemask-based policies, allocation succeeded within nodemask
+ *     - for other policies, allocation succeeded on intended node
+ *     - counted on the node of the allocation
+ *   miss
+ *     - allocation intended for other node, but happened on this one
+ *     - counted on other node
+ *   foreign
+ *     - allocation intended for this node, but happened on other node
+ *     - counted on this node
+ */
+static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
+				  struct page *page, unsigned int order)
+{
+	int actual_nid = page_to_nid(page);
+	long nr_pages = 1L << order;
+	bool is_hit;
+
+	if (!current->mempolicy)
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
@@ -2444,8 +2485,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
-	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		goto out;
+	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2471,7 +2514,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
 				nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
-				return page;
+				goto out;
 			/*
 			 * If hugepage allocations are configured to always
 			 * synchronous compact or the vma has been madvised
@@ -2494,6 +2537,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
+out:
+	if (page)
+		mpol_count_numa_alloc(pol, nid, page, order);
+
 	return page;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b33097ab9bc8..4a8384441870 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1291,6 +1291,11 @@ const char * const vmstat_text[] = {
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


