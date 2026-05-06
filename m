Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F82CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 836366B0088; Tue,  5 May 2026 23:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF486B0093; Tue,  5 May 2026 23:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FEC6B008A; Tue,  5 May 2026 23:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404DE6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:33:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D04D08C73B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:11 +0000 (UTC)
X-FDA: 84735574182.21.C2DA93E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id 998BE4000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:33:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WSBvd4uc;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2UzznrXp3z6TFMSaQRcuSFcUYqd6gHoZMRunjrnQ/OE=;
	b=jNokemauqSqJlPrFPYYGR4sY7WY10sQeXsA/jiOmlcOY7s48NNTQExgBoBDVqtVXP4cvm/
	gKPy83J5VwLooCA/oQXSYYpHWnk3ZhBZLLoSKRfXXeCsTNRRTtKLrW0yysddFHV/+KmSY2
	4ppL3Z1v6qI/+i3PmeOXocdjy92PsXM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WSBvd4uc;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038389; a=rsa-sha256;
	cv=none;
	b=vKadNA8xZTf03Hn7ZJ/90llR0j7nfgBaqAEE93YzH5tGgTANAT+EqSJAF74h+iu7BGZ0o/
	l0miofG39ggeZWd4ryJ2b+j9MrR6EDVTi2kMaLCnPJx+5FHqAF9cOulc64b0kZAnHyeIBo
	/GJWcPTnR2sPvQfDcy+WBPJgjA62gPY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778038390; x=1809574390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=81vapQm0G2+s7Q9rjkTUxp8N8diOM+t3xvAi5oamm8g=;
  b=WSBvd4ucHsrbOE6rR1FGI8IgliFyotuYGJSPlPU6XmcIGOY43WFKsvne
   4SSkRSPaPP78Pl1DKN8HL3rKwVSby/LGMCq+8PbJEXClehoukoZpUsR+0
   PhGWLnNAWJVa2Jo93/vT7qcyZLo/faJYaNDNaFb368Ye4SnSqeUHIolf0
   OLqG6+4H/jl65REn08YcbWpKypgAW3InEUmRwSksdj3iB2STvzGIxOyfG
   AnIMCJJUdp6mL0vDBQG+fIixAQPPPSsLK1u7EPJKXQTZDQgsMKdL5HO53
   GxmQuEbfAQAPxVoGxBDUwOjhRMjb+gkQwnMr3CkgIR8Ljw97x+ufvmcvr
   A==;
X-CSE-ConnectionGUID: qQ7s3Cg6Qu27bXXSSIOp0A==
X-CSE-MsgGUID: B3Qf2nE9RW6iGdTZgoJCtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78829023"
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="78829023"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:07 -0700
X-CSE-ConnectionGUID: nIPvi29BS/e4PKxK3VvyMQ==
X-CSE-MsgGUID: 7ksHOWx2SLuT43UQAcKJtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,218,1770624000"; 
   d="scan'208";a="266342146"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 20:33:06 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH v5 1/5] mm: Wire up order in shrink_control
Date: Tue,  5 May 2026 20:32:56 -0700
Message-Id: <20260506033300.3534883-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260506033300.3534883-1-matthew.brost@intel.com>
References: <20260506033300.3534883-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: amb5azwefk6ga8c1szo5t4ce1bprtr3c
X-Rspamd-Queue-Id: 998BE4000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778038389-435153
X-HE-Meta: U2FsdGVkX1/nGE40ZvOrocEolpPed+IceRzLskL90l0spRGRBgeYyEAgeGRS6VYYQePzUxXMW51r9GzxVixTHA09h3JwTTySLmP2NMMCeRDRtYSF1X7SUG+9QcYBpI12I1cuRLVigwIG+I5J7MNOfvkxCJC4j9DpViZry0XIZJT9mCYTVEyVL56RQn1t8IF2OE6yRbrrkwQwb46rY8OjCx/+zfrMEkHf814EA9FE8lXLE3E5Sy9m21q13mIr+0xih0NkuJH+rsjT29ShKiAIxfFS2729+yzs41p3KPimy6k2dg5ARt0tROK4MwODAQzoeuRrt6xGSi2tUdvp+oeQuc5USriz9lZhnbp3Vpxy2uL2/35hQ75jCaWGuc5vFC/DoFt6DqhBJHstkDXsu6e51Dcz8p7RdRdR5a/jZvzCXtXj+Ozjxsu2VQ4BX2rvTaeKdygNetvsc59tOjVIHvsnTNlUOXFRE2MHzc6YhdzHfOOuFjvliuhqC1K7PZyGPnCPmb5HrfkEybKSaA9ABcxLSMn0i8B+ufykBHz7OJUu+iMDGUT6pMQ7jATiHst7NsdIhOM4BvW6K9ym3XNkyIoJON+b1S0F4x4ZP5qoMUs23O8EKD/N2OJmks36q3ky7laWcYB5l2aDK2IlSOaP45OsFkjv9G054Zpu5LuxiHOfXQax6jHjZY0uwEjWVPaZ8r0aouRcP5DCsmTBlUDhFu/8Cq5lX3/kkcJZumDMLIAjXXVQCy/LRQAxXdjL1eBmehi7eGpebz36FHEB4YbtSE2YfZDAsn1UfZZ5wUzDrdFiDHHV/H5kkYZniaZ4TuNZcu0VWt9bJ9oRflCnXPZ2KAMDnSSsgryPzPHy6osvHxMq3/hehiWZbIqDebMgRTaygL7bRwqUMvJwRlW4f+hPpiM55tpp5ncT10Fu49FlzYhk8AO7s26UFSXBspkeRuyjfb2AVa1AvvrOK6apnPa7Uwu
 J/VLg+tW
 ndWJET6q2VgZmDSnm/C5QqYVie2QLcAbMWwiNazHukOzpZ+huIK/acYj9Fd3fCq/1I03pSSVb1rHKDOAtRbSLCtfucIjveDaqpnY05rIYMttRNvvvAoOAa2iiHTFiH1KtSpaDi4E5ERR8KsJjoniSU1zT9ZMvlTMppFG1xWMia81tuCN+17hoWF0S1O+zN1frgzawO3Re8cKMZ9aXV+o164n+AaUcKH4HWrw6eq840EWGXx7GVboKmY9OHCrhr33BA4mKWv//tk91M7pE7kM1ognZJnmKd1j4z8MR3RzyI9xZzad9jT3eGTPn8RuahxaDmFrCqK1bgtaKyUz38FKfU2/fgawik7QdugTlsut/dXUVlaH4eUeqScc1LGWK7IGqiQAwkbNN/lHQ5E4mymcLnkjBhKxrmRXYh+/IN1L1lmun1msCRQKtZOOcJJQ9lo7s4ylEYNgLU59U1PQNqQPCYJnzrt5viB5fdZJppdcp52NKaC35J1f38sa+j86rFgiHqGlJGwfTIyHpKNSamPjaJKCk0IBLS+cvRUgdTuQ3SwekHdYitsiGmd8H7O4tqEY2To1Nyf5TnqhFeweIe3Y7B+pkMhGKqgDIhqkdje6ylFdW5xhrKCTE7RCyrf+c0eDtX5GE/BGLuf7sHxtiE3AiNLKESTlmlshW2vsK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pass the allocation order through shrink_control so shrinkers have
visibility into the order that triggered reclaim.

This allows shrinkers to implement better heuristics, such as detecting
high-order allocation pressure or fragmentation and avoiding eviction
of working sets when reclaim is invoked from kswapd.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Kairui Song <kasong@tencent.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Suggested-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 include/linux/shrinker.h |  3 +++
 mm/internal.h            |  4 ++--
 mm/shrinker.c            | 13 ++++++++-----
 mm/vmscan.c              |  7 ++++---
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..7072f693b9be 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -37,6 +37,9 @@ struct shrink_control {
 	/* current node being shrunk (for NUMA aware shrinkers) */
 	int nid;
 
+	/* Allocation order we are currently trying to fulfil. */
+	s8 order;
+
 	/*
 	 * How many objects scan_objects should scan and try to reclaim.
 	 * This is reset before every call, so it is safe for callees
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..ff8671dccf7b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1759,8 +1759,8 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
 void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
-unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority);
+unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
+			  struct mem_cgroup *memcg, int priority);
 
 int shmem_add_to_page_cache(struct folio *folio,
 			    struct address_space *mapping,
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 76b3f750cf65..c83f3b3daa08 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -466,7 +466,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 }
 
 #ifdef CONFIG_MEMCG
-static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
+static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 			struct mem_cgroup *memcg, int priority)
 {
 	struct shrinker_info *info;
@@ -528,6 +528,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			struct shrink_control sc = {
 				.gfp_mask = gfp_mask,
 				.nid = nid,
+				.order = order,
 				.memcg = memcg,
 			};
 			struct shrinker *shrinker;
@@ -587,7 +588,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 	return freed;
 }
 #else /* !CONFIG_MEMCG */
-static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
+static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid, s8 order,
 			struct mem_cgroup *memcg, int priority)
 {
 	return 0;
@@ -598,6 +599,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
  * shrink_slab - shrink slab caches
  * @gfp_mask: allocation context
  * @nid: node whose slab caches to target
+ * @order: order of allocation
  * @memcg: memory cgroup whose slab caches to target
  * @priority: the reclaim priority
  *
@@ -614,8 +616,8 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
  *
  * Returns the number of reclaimed slab objects.
  */
-unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
-			  int priority)
+unsigned long shrink_slab(gfp_t gfp_mask, int nid, s8 order,
+			  struct mem_cgroup *memcg, int priority)
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
@@ -628,7 +630,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 	 * oom.
 	 */
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
-		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
+		return shrink_slab_memcg(gfp_mask, nid, order, memcg, priority);
 
 	/*
 	 * lockless algorithm of global shrink.
@@ -656,6 +658,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
+			.order = order,
 			.memcg = memcg,
 		};
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index bd1b1aa12581..a54d14ecad25 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -412,7 +412,7 @@ static unsigned long drop_slab_node(int nid)
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
-		freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
+		freed += shrink_slab(GFP_KERNEL, nid, 0, memcg, 0);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 
 	return freed;
@@ -5068,7 +5068,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	success = try_to_shrink_lruvec(lruvec, sc);
 
-	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
+	shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
+		    sc->priority);
 
 	if (!sc->proactive)
 		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
@@ -6170,7 +6171,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		shrink_lruvec(lruvec, sc);
 
-		shrink_slab(sc->gfp_mask, pgdat->node_id, memcg,
+		shrink_slab(sc->gfp_mask, pgdat->node_id, sc->order, memcg,
 			    sc->priority);
 
 		/* Record the group's reclaim efficiency */
-- 
2.34.1


