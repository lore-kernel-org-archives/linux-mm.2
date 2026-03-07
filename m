Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FE6FC9ECA
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 04:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998A56B0005; Fri,  6 Mar 2026 23:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945F86B0089; Fri,  6 Mar 2026 23:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844EE6B008A; Fri,  6 Mar 2026 23:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 710716B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:55:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05E70BAFA5
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:55:45 +0000 (UTC)
X-FDA: 84518054250.28.A0E5C8D
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 324B54000C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:55:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AD62MGvs;
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772859343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qslBai9ysHE9ew/L17AVF59o+oz2ik2mT2v5csquk7k=;
	b=nqhb0gZh/HgBHu8ToNSNyCZrGuWBEzAOtnntda7Dnn3cygM0RrezzFN0RmExLtCZmA7UGX
	GRz7oRD5eJo1EAgKXf++SvX8Gv/IuTLjaf16d9fnJGorrn1we9fMDr1Wao/9VOgiaMN52S
	fYY0UR+J5g5JqDqlQ8TOqJ/P1Tebxpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772859343; a=rsa-sha256;
	cv=none;
	b=f6Mr6TeiBo8Q93n6FX9r8FuFhHNUiPP3KEXnkaNmqY9EU1PEfHNgYOboM4kSgSkFnl2FFp
	KDUEz0WWcSECvZgGtZT0s71Pdu7NqVnXdwgTlbXTpdYcy62PBH8Q712x1tgyG6nxTIoi2C
	qoH16sTK/SCG12qqqNMZaypXWwwvfv0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AD62MGvs;
	spf=pass (imf01.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772859340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qslBai9ysHE9ew/L17AVF59o+oz2ik2mT2v5csquk7k=;
	b=AD62MGvsgH5UsbaKcQmRpgY543m3jajlSbPMoIzoG1ox73ZbOLGlu5RHggz9CLInOOhWlh
	K7PziIlMA4BR/cAYNrbQYv4+yPPWBBijyp9pYVeyGAuY3uYXXSIWgSSdeoStPKb9hJ6dNK
	bPxwLiR1vUs8Ih4vjMA0pYjqY7x8evs=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	mhocko@suse.com,
	vbabka@suse.cz
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
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Date: Fri,  6 Mar 2026 20:55:20 -0800
Message-ID: <20260307045520.247998-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: wgdqj6hjcsm74zx9km9igoys8nofy1w7
X-Rspam-User: 
X-Rspamd-Queue-Id: 324B54000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1772859342-157548
X-HE-Meta: U2FsdGVkX19mNooxRgDeJ3cQYiPDAxg4qfELe6NohKXEZRHSVD5ySPaQLAX7/mWiU/4jbzR/hFZLpSUB5qmv1Rp24rPRmQ15o2y14PeJKHfeH8X7t2SpEQoAT98kTjCXGkOyhkfQYjnPQRLOVQGecscoBv1D7MGQ4W1a9VjM1aOuA4StMG97VPRJSpmiDU22qlKMzo2Z21Vl532b9GdOyMrdrt8NoswKzbXy4bwF9drjr6Fh56rq4CjGMyYfBoGH25wxnsIKtykh4rIUr+rcWZlcmxneS3ex3jdaU8vAXyqaj2qNC5VGIPQFhRwpvRGlo2KXXp+uukC4RQCdn4cqKRuEOjKtzL+N+qwpUXsrvfm7g+oFOqk9MfeD5LbI23MwXDR+H+7LBSKWjd/EYtiX+waBiJCVsPi8OpKE66NfdOK2emIlFAJfl9g3qrohZOqSNexbVo6/oQrhbLQJUqh9CMj1svv7007Oi2l2EjW7bDRFEp1fiIITY+wwWpsdmqY5e0BE1//IE2aq02zmkPgdrm5wMeH41uQD1zSCKrl9HNx2gr+C8w8OwsIY2Nxd/woxww8hQyu1HeKlYEIwCq/5NAlBXThqhLAXXScQhM/vrM2NzXsd0MVyZcOfwfwCYjqLjo02Hsq9ZPArzOP2y5OXU+9Zm5csogxthjBiD92505cQelptFiDVipOmTmGBfFzLuD8LezOwOrSWAHBGKKSa7bAerS4J+q7lUve78RTzm4sx1OOsgG+t+ffDSghkzdDOr1cLj/wTSIiiTf3SbheGU7zFksWC9wgOodCDxmFhpuWa79M03WwE1me3iK9DgkBQ+Ns/Z+a4Im6QIvHn5IqTm6Yo1tceZ9EoAyVzUY/YHrJw78SagNJLuX3/4LXsH24VdYYMgVJdRLXvFyzvWVD423+YpMzCq0ZF8ZOV/t1ZCHP+U4EVkzFzdxNvS1hnUkG1zPfD+j1zXMpjPthi4WG
 YyuvtaBj
 wjjo3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When investigating pressure on a NUMA node, there is no straightforward way
to determine which policies are driving allocations to it.

Add per-policy page allocation counters as new node stat items. These
counters track allocations to nodes and also whether the allocations were
intentional or fallbacks.

The new stats follow the existing numa hit/miss/foreign style and have the
following meanings:

  hit
    - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
    - for other policies, allocation succeeded on intended node
    - counted on the node of the allocation
  miss
    - allocation intended for other node, but happened on this one
    - counted on other node
  foreign
    - allocation intended on this node, but happened on other node
    - counted on this node

Counters are exposed per-memcg, per-node in memory.numa_stat and globally
in /proc/vmstat.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
v2:
  - Replaced single per-policy total counter (PGALLOC_MPOL_*) with
    hit/miss/foreign triplet per policy
  - Changed from global node stats to per-memcg per-node tracking

v1:
https://lore.kernel.org/linux-mm/20260212045109.255391-2-inwardvessel@gmail.com/

 include/linux/mmzone.h | 20 ++++++++++
 mm/memcontrol.c        | 60 ++++++++++++++++++++++++++++
 mm/mempolicy.c         | 90 ++++++++++++++++++++++++++++++++++++++++--
 mm/vmstat.c            | 20 ++++++++++
 4 files changed, 187 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241c..c0517cbcb0e2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,26 @@ enum node_stat_item {
 	PGSCAN_ANON,
 	PGSCAN_FILE,
 	PGREFILL,
+#ifdef CONFIG_NUMA
+	NUMA_MPOL_LOCAL_HIT,
+	NUMA_MPOL_LOCAL_MISS,
+	NUMA_MPOL_LOCAL_FOREIGN,
+	NUMA_MPOL_PREFERRED_HIT,
+	NUMA_MPOL_PREFERRED_MISS,
+	NUMA_MPOL_PREFERRED_FOREIGN,
+	NUMA_MPOL_PREFERRED_MANY_HIT,
+	NUMA_MPOL_PREFERRED_MANY_MISS,
+	NUMA_MPOL_PREFERRED_MANY_FOREIGN,
+	NUMA_MPOL_BIND_HIT,
+	NUMA_MPOL_BIND_MISS,
+	NUMA_MPOL_BIND_FOREIGN,
+	NUMA_MPOL_INTERLEAVE_HIT,
+	NUMA_MPOL_INTERLEAVE_MISS,
+	NUMA_MPOL_INTERLEAVE_FOREIGN,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 982231a078f2..4d29f723a2de 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -420,6 +420,26 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_ANON,
 	PGSCAN_FILE,
 	PGREFILL,
+#ifdef CONFIG_NUMA
+	NUMA_MPOL_LOCAL_HIT,
+	NUMA_MPOL_LOCAL_MISS,
+	NUMA_MPOL_LOCAL_FOREIGN,
+	NUMA_MPOL_PREFERRED_HIT,
+	NUMA_MPOL_PREFERRED_MISS,
+	NUMA_MPOL_PREFERRED_FOREIGN,
+	NUMA_MPOL_PREFERRED_MANY_HIT,
+	NUMA_MPOL_PREFERRED_MANY_MISS,
+	NUMA_MPOL_PREFERRED_MANY_FOREIGN,
+	NUMA_MPOL_BIND_HIT,
+	NUMA_MPOL_BIND_MISS,
+	NUMA_MPOL_BIND_FOREIGN,
+	NUMA_MPOL_INTERLEAVE_HIT,
+	NUMA_MPOL_INTERLEAVE_MISS,
+	NUMA_MPOL_INTERLEAVE_FOREIGN,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS,
+	NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -1591,6 +1611,26 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
+#ifdef CONFIG_NUMA
+	{ "numa_mpol_local_hit",		NUMA_MPOL_LOCAL_HIT		},
+	{ "numa_mpol_local_miss",		NUMA_MPOL_LOCAL_MISS		},
+	{ "numa_mpol_local_foreign",		NUMA_MPOL_LOCAL_FOREIGN		},
+	{ "numa_mpol_preferred_hit",		NUMA_MPOL_PREFERRED_HIT		},
+	{ "numa_mpol_preferred_miss",		NUMA_MPOL_PREFERRED_MISS	},
+	{ "numa_mpol_preferred_foreign",	NUMA_MPOL_PREFERRED_FOREIGN	},
+	{ "numa_mpol_preferred_many_hit",	NUMA_MPOL_PREFERRED_MANY_HIT	},
+	{ "numa_mpol_preferred_many_miss",	NUMA_MPOL_PREFERRED_MANY_MISS	},
+	{ "numa_mpol_preferred_many_foreign",	NUMA_MPOL_PREFERRED_MANY_FOREIGN },
+	{ "numa_mpol_bind_hit",			NUMA_MPOL_BIND_HIT		},
+	{ "numa_mpol_bind_miss",		NUMA_MPOL_BIND_MISS		},
+	{ "numa_mpol_bind_foreign",		NUMA_MPOL_BIND_FOREIGN		},
+	{ "numa_mpol_interleave_hit",		NUMA_MPOL_INTERLEAVE_HIT	},
+	{ "numa_mpol_interleave_miss",		NUMA_MPOL_INTERLEAVE_MISS	},
+	{ "numa_mpol_interleave_foreign",	NUMA_MPOL_INTERLEAVE_FOREIGN	},
+	{ "numa_mpol_weighted_interleave_hit",	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT },
+	{ "numa_mpol_weighted_interleave_miss",	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS },
+	{ "numa_mpol_weighted_interleave_foreign", NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN },
+#endif
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -1642,6 +1682,26 @@ static int memcg_page_state_output_unit(int item)
 	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
+#endif
+#ifdef CONFIG_NUMA
+	case NUMA_MPOL_LOCAL_HIT:
+	case NUMA_MPOL_LOCAL_MISS:
+	case NUMA_MPOL_LOCAL_FOREIGN:
+	case NUMA_MPOL_PREFERRED_HIT:
+	case NUMA_MPOL_PREFERRED_MISS:
+	case NUMA_MPOL_PREFERRED_FOREIGN:
+	case NUMA_MPOL_PREFERRED_MANY_HIT:
+	case NUMA_MPOL_PREFERRED_MANY_MISS:
+	case NUMA_MPOL_PREFERRED_MANY_FOREIGN:
+	case NUMA_MPOL_BIND_HIT:
+	case NUMA_MPOL_BIND_MISS:
+	case NUMA_MPOL_BIND_FOREIGN:
+	case NUMA_MPOL_INTERLEAVE_HIT:
+	case NUMA_MPOL_INTERLEAVE_MISS:
+	case NUMA_MPOL_INTERLEAVE_FOREIGN:
+	case NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT:
+	case NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS:
+	case NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN:
 #endif
 		return 1;
 	default:
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..2417de75098d 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -117,6 +117,7 @@
 #include <asm/tlb.h>
 #include <linux/uaccess.h>
 #include <linux/memory.h>
+#include <linux/memcontrol.h>
 
 #include "internal.h"
 
@@ -2426,6 +2427,83 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	return page;
 }
 
+/*
+ * Count a mempolicy allocation. Stats are tracked per-node and per-cgroup.
+ * The following numa_{hit/miss/foreign} pattern is used:
+ *
+ *   hit
+ *     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
+ *     - for other policies, allocation succeeded on intended node
+ *     - counted on the node of the allocation
+ *   miss
+ *     - allocation intended for other node, but happened on this one
+ *     - counted on other node
+ *   foreign
+ *     - allocation intended on this node, but happened on other node
+ *     - counted on this node
+ */
+static void mpol_count_numa_alloc(struct mempolicy *pol, int intended_nid,
+				  struct page *page, unsigned int order)
+{
+	int actual_nid = page_to_nid(page);
+	long nr_pages = 1L << order;
+	enum node_stat_item hit_idx;
+	struct mem_cgroup *memcg;
+	struct lruvec *lruvec;
+	bool is_hit;
+
+	if (!root_mem_cgroup || mem_cgroup_disabled())
+		return;
+
+	/*
+	 * Start with hit then use +1 or +2 later on to change to miss or
+	 * foreign respectively if needed.
+	 */
+	switch (pol->mode) {
+	case MPOL_PREFERRED:
+		hit_idx = NUMA_MPOL_PREFERRED_HIT;
+		break;
+	case MPOL_PREFERRED_MANY:
+		hit_idx = NUMA_MPOL_PREFERRED_MANY_HIT;
+		break;
+	case MPOL_BIND:
+		hit_idx = NUMA_MPOL_BIND_HIT;
+		break;
+	case MPOL_INTERLEAVE:
+		hit_idx = NUMA_MPOL_INTERLEAVE_HIT;
+		break;
+	case MPOL_WEIGHTED_INTERLEAVE:
+		hit_idx = NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT;
+		break;
+	default:
+		hit_idx = NUMA_MPOL_LOCAL_HIT;
+		break;
+	}
+
+	if (pol->mode == MPOL_BIND || pol->mode == MPOL_PREFERRED_MANY)
+		is_hit = node_isset(actual_nid, pol->nodes);
+	else
+		is_hit = (actual_nid == intended_nid);
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_task(current);
+
+	if (is_hit) {
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
+		mod_lruvec_state(lruvec, hit_idx, nr_pages);
+	} else {
+		/* account for miss on the fallback node */
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
+		mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
+
+		/* account for foreign on the intended node */
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
+		mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
+	}
+
+	rcu_read_unlock();
+}
+
 /**
  * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
@@ -2444,8 +2522,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
-	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		goto out;
+	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2471,7 +2551,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
 				nid, NULL);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
-				return page;
+				goto out;
 			/*
 			 * If hugepage allocations are configured to always
 			 * synchronous compact or the vma has been madvised
@@ -2494,6 +2574,10 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
+out:
+	if (page)
+		mpol_count_numa_alloc(pol, nid, page, order);
+
 	return page;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b33097ab9bc8..d9f745831624 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1291,6 +1291,26 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
 	[I(PGREFILL)]				= "pgrefill",
+#ifdef CONFIG_NUMA
+	[I(NUMA_MPOL_LOCAL_HIT)]		= "numa_mpol_local_hit",
+	[I(NUMA_MPOL_LOCAL_MISS)]		= "numa_mpol_local_miss",
+	[I(NUMA_MPOL_LOCAL_FOREIGN)]		= "numa_mpol_local_foreign",
+	[I(NUMA_MPOL_PREFERRED_HIT)]		= "numa_mpol_preferred_hit",
+	[I(NUMA_MPOL_PREFERRED_MISS)]		= "numa_mpol_preferred_miss",
+	[I(NUMA_MPOL_PREFERRED_FOREIGN)]	= "numa_mpol_preferred_foreign",
+	[I(NUMA_MPOL_PREFERRED_MANY_HIT)]	= "numa_mpol_preferred_many_hit",
+	[I(NUMA_MPOL_PREFERRED_MANY_MISS)]	= "numa_mpol_preferred_many_miss",
+	[I(NUMA_MPOL_PREFERRED_MANY_FOREIGN)]	= "numa_mpol_preferred_many_foreign",
+	[I(NUMA_MPOL_BIND_HIT)]			= "numa_mpol_bind_hit",
+	[I(NUMA_MPOL_BIND_MISS)]		= "numa_mpol_bind_miss",
+	[I(NUMA_MPOL_BIND_FOREIGN)]		= "numa_mpol_bind_foreign",
+	[I(NUMA_MPOL_INTERLEAVE_HIT)]		= "numa_mpol_interleave_hit",
+	[I(NUMA_MPOL_INTERLEAVE_MISS)]		= "numa_mpol_interleave_miss",
+	[I(NUMA_MPOL_INTERLEAVE_FOREIGN)]	= "numa_mpol_interleave_foreign",
+	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT)]	= "numa_mpol_weighted_interleave_hit",
+	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS)]	= "numa_mpol_weighted_interleave_miss",
+	[I(NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN)] = "numa_mpol_weighted_interleave_foreign",
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
-- 
2.47.3


