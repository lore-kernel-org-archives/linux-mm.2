Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E57C9FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9C26B008C; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B18E6B0092; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7176B0093; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF5A6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB001C0303
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:47 +0000 (UTC)
X-FDA: 84716045694.07.E15BCB3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99481140004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdiiuREE;
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QkHvuen1pxlKwjlFuTlSGQrT1I7ZUG9QOhCQKvrFvU=;
	b=OfZ+W80s4LaXt+2Z0uqxShYg4UMD6v5IkG6yfvZyHtwnNM1iuM5EzdQDqy7TD2/xUzqPtb
	Frs6uVPUpiwIzlaLq2rReqC3CWpjtfKSuFQtuNYOp06L9SuNUWsYiUAJmyIw5Hhz+X/kBF
	RREzy6Bd472zyQyclu9sZGXdeD5rkKM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cdiiuREE;
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573425; a=rsa-sha256;
	cv=none;
	b=GbcFj7qtNeCnGSSdo/MePGZzYJHAi3rLJY/bCEr7h05mPGRJV+GdZAyh3B0bA0g8HhH0+z
	gf4DgfZczag+q9rz7KoKfIj5Zv6w199VIkP1RFjq0wj0JGyHj/mJbjJxf2mbrXXW8C9lH0
	3JF3PQtCTEzDeDmIXHjyfssPLyZ9+hA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777573426; x=1809109426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k3yJgH8D791bhoAFURbddfZvHGIe58qtd5P3zc3tVfk=;
  b=cdiiuREEhrMemMHaZf6c20/PEZ1hODIFPaPGrfnyycFqamFqt775EeH9
   RNZ19oBALDzZzeQh+rTncNTzqJyk7GDYM77AeR/CKuBz/W+uogdMdOszJ
   6s9hZ+HzxHnhP9D2DNR04Av9XVWfl49Sf8fHAIpFJcsyw6Q4SjIY1WdTz
   R13cz8khOVFxOfrmu8m1ZpGPLV9yFgEvUaKJW9RJpQ1qf01xAocCn6isl
   VkE4FaFG1zcC7Bxkip8siEKKh/gJzDFZdPDY1nz8w3slAS6a+rsPP91GG
   7R0hzCXCeNzDLmCmoeM1j+gqbs7VCGU1yVWbq3Ep1R97rwVgl6xhNOzmm
   g==;
X-CSE-ConnectionGUID: 20Bc30TUTimKRMfbeiE4Ew==
X-CSE-MsgGUID: 4MXyltN/Qq2nqlOvw1JabQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82388991"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="82388991"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:41 -0700
X-CSE-ConnectionGUID: jJTzPlxCR6aSMAAmZ24yxQ==
X-CSE-MsgGUID: CTLX63CKQDWyf1HT8KbPfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="231532217"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:41 -0700
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
Subject: [PATCH v3 1/6] mm: Wire up order in shrink_control
Date: Thu, 30 Apr 2026 11:23:30 -0700
Message-Id: <20260430182335.2132382-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260430182335.2132382-1-matthew.brost@intel.com>
References: <20260430182335.2132382-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m7k1mam331wj3dyngg8wedk1qmqtw91q
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99481140004
X-Rspam-User: 
X-HE-Tag: 1777573425-926031
X-HE-Meta: U2FsdGVkX1+Z5fJZ3m98aOctwf4EbOaY8cRT/OFSdnwRPvkUk1uLnvCV/D4YFkHIoNV6D2rgYLxwnCUB0qRNt2hplxxHBdEEBXriUqvDePWxYD3UqVN3i/LxfIWxPytMFuE3Ht/dtfh9tH6E92wCX2P5T4LWSRS23Z+sCdPMaJqNwOt3KuEqViOXWFe+jCx/e1c3kgrKjZOK46Cyt9qylUKRum1DldpLR9tZ7Awq0sC6OUYE8sq6hzQaOdqV2Td3nFVlGPX4NN1wcTT/nL8YhdvheW+tAPrD40EYLP/dfylSCEdesJoquT77K53m6Kv40uVRO/cmytUsTiuN+7fHSl2cvVxt4zGSfWe7Z+PX4i2hfiz0pMfRwg9/pmezUfWg1/BHaF9gsOuoFkuBid8i/nEnZbmEUY0cL9VuyZjGJTFylIr3gpa6X7SPmVy3NHnsrXaIWHteMxL8AD6er87ASDtJ8cRNhsEOna/MYHIsWZhWOWUnjT+YBXPr9h3T+dnidjvP6tEBEAi0IJHm2sVycw8WBapZ1v4zXAgccB1COp+d94JAr14ZiMUyAA+sY1rfG2JhKzJ2LTWsbgBKZq3qFshiBToOz9J6H1pjgfnLTR0695F0+sf6h73da3WoVuv2yBS3fX0Qc/tZ1iaWTtYPx7cwNTDcaXN7X5dHnP4DNtrVDGRZZJxtizQPOwPQ1AS+4TMyiZUrmklrkRAvtVNnpXlpsD4slsj20eSFFgJ6vEG/ZY3PqXXEO226jE/r1081S5uDLWeiEm/rnR+XEKrZxRMxNCK3dUdxeK1dozfxiitr9/BjVkJgW1tWZ8xc0E/lSD+t2hp1i1BSYO3AB43XcpIVdvG43DxWq4NP8DJ4KED6NkMzVasKefZW8fEu1V0SK5J2CoQZnN253m9D9qZO1SfyR5SVbeZ1YXNsXXUqqO4gW2fUB50Z1dXOgmlW4QeHGhR46pS4xhBFR8sKm1S
 6/2BCI1k
 oXYbGRvWsDAvw7BR/Usd44/CBSqlzxmxW/qwXbrYZ6RVn8tK61qd4RfiC5wSIjnOwaNKXXk/Dfsv9PONQsUmCtQb14F5T/2ttzuQIG9BOdzFZ73M9ReCvRU2uu1LRNiwWAcqx0djp+O+2O1PobrsaBeKARAROxRrQ95Mh/QQ3+IskCmfgn1CGJ0qqV4jH7dkp+bZudAmnbiy8TslBIztpu1FLiCkrVFDIFUuxLnJshjogDEpxzHXt4UrHe//RnSv/yOQQ2DlCHGfqcKTEzwyTDgyFBWMXpDw3/vuC6ZRHyDOeLc5SPz/rcM8nRAcLbCpnz7EVz/uYLkFUpFvwXYR9eB0/E5khF7K96zats6rBT9QhCupFvN4u9JqqNkGXdHFBKep80uRXH2rvmPIzQk4F5GvhqBuQGRN+wKN5F1hGsvRQHaq6H0cOB8KxQjeepNR+aJWes/4qS/eSn5vpssXbK5Ji/V8/GP8XOCjpcCX2w+yi53uRgpx/XIC6bUPgBqInXryADCN3oEzPGeudY7oRvooJy3jXh81iRLViwSpW4/lMo5tHiXvFIPSBFEy8G0f7LY41KPLHjoXX91TjA2Mk3DmXQqgLAswzqCssZAcJrO8a/eepuulRBi1UsunvIJcngIfzo9QThIAXWuwkgLFrb4dDWpUYbTACs9CK5/A3Ic9m2fg=
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
 mm/shrinker.c            | 11 +++++++----
 mm/vmscan.c              |  7 ++++---
 4 files changed, 16 insertions(+), 9 deletions(-)

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
index 76b3f750cf65..fb23a338fb22 100644
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


