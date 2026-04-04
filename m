Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D2CE88D7B
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 03:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235EA6B0005; Fri,  3 Apr 2026 23:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0186B0089; Fri,  3 Apr 2026 23:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 087786B008A; Fri,  3 Apr 2026 23:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5BF16B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 23:38:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 944BE5820E
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:38:50 +0000 (UTC)
X-FDA: 84619466820.20.90C7BF4
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3CA41C000C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 03:38:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVyOiCYF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775273928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UnK6OH8b4keQaVFK/5OEkwznTAbTC+vEuBT5MrB5GfA=;
	b=CvRwRkO9/LvpMg3QTQv3gHBQdeZeL+Gs1eksuHXjja2hVuw90mHDgpACpuZTRQBi2RQ4If
	iOgv6Fu9EiK1rrW3sEagUB0M5b939xVDJULn5SvXL+6G0jXQ2Gyo8AxfvEh5XaqSGnFG/A
	uQdjfJGepdjlJJt91agETzMJQ0SqaCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775273928; a=rsa-sha256;
	cv=none;
	b=02tg68W5ylT9yMc/ho8nTs91fKYmoQb6Whs+jU/tjIacRm/qJN1uIJui10RKD5wv6kzfOK
	n92UDSe9mXG1t6hn52EpIm0XPTqK7MNF+8SoDzJppgWmZ/LQOSczdDKDDw671rSEqBmvaM
	Yjef07JxYLA4a3PEMCNX3QNefzFDDZA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OVyOiCYF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7d7653db148so1487750a34.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 20:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775273928; x=1775878728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UnK6OH8b4keQaVFK/5OEkwznTAbTC+vEuBT5MrB5GfA=;
        b=OVyOiCYFozd6Vd53AZu5WdyfMxdoIFldvY51WyaYww66S6H+AYKoV+oVWezVHOGpSe
         hiMqquF2BzLx7Yx4Lrwalxp+YxkvwE+FNdBpu7fpPAUOHkuCSZm+robuB0BrWl1qZMz6
         3pThfkRnjAQ0vHpNlP/C5D7DR6r/XyVp+OVDrQyGJfAtwylxV9VQ7VLDM4XVBup1sSxL
         quBwZ+XYd2M9iIx6deWDamoHgPOhGJQZyagVtkam1dIfBbT6VV8NfL3nOOrSnOwHsD3E
         EOiCvkyTNPHK2KbMQR/7SAWISnHxCXCP0qVi/vPzs+xTeHmYJ7+FjpePXMygqa7XuAfq
         DYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775273928; x=1775878728;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnK6OH8b4keQaVFK/5OEkwznTAbTC+vEuBT5MrB5GfA=;
        b=oLYLm6m6W/Stdw/39gTnYKnzlFosFo0tDqkdVCoy1WNyTt585vHovmEPIr9v0FseXO
         2zTREHeBgmHlgzBUmV3SXNddqCnX3swxf7qLmnysqVoGo3Bkqv24nsUwxAPns4JNJOGW
         HlNQ7uRquwRUmWGJnIdx6Ptc8B5sZASYiWnT9DgJ8m24vyRxdd6LtWFSDFSw7eN7qzeC
         2tqsky5iaiRb1BshbGON6ynGG05HnkDnXQIcByAA+l1umgPV9UPMDWXv2TvfaLXt4vES
         pvuHcDfUTA8/kWuuHK0N4c0F/8Orf8kAKWy5UJHuWIGU+5aaJgHvdT8FXRZUXmKvYgbF
         gOgA==
X-Forwarded-Encrypted: i=1; AJvYcCV9WMvlUxP028LQZP9gjCv1SOE2b1wGNYzXSiU81kwPU17RYYA30tzpDLf88AlX5pOFgma9i6AHFA==@kvack.org
X-Gm-Message-State: AOJu0Yz1STTE4059i6U7w7VVKgqcruDRknGJfjBE9opw4RUIKpzKdKKP
	FYyQILGbA/6DX7sj7JIURPs6J7wzaBY2v+eQS0N1qB7G4iVFEkAGgjlK
X-Gm-Gg: ATEYQzyAg2SJw+oLd9eeELm5+U2scmXLbD11G973wiLlqgb0buL0mJrhxnbU+I5JiOB
	6QkNMrAqnHqd+a4btixj4LPx2KXLVo0kxK+XV5M1OKvmTcNCSl6Rx354V/XI0k4YLHczv6exE/x
	s0/Bp0AIsqIFvqITTww1hdt1kB9l41I9mwn3CreGHmmWWKFNmZmJMeYUhjqQgrILnqXLtgOM2+P
	ID6uD2wAZjGEIeQBZQdt31ZV/yIYGUs0ZELT7BaEH0lE/twiGuDDbQLMDpjShO4L/CscGRXPCuL
	npMKx4+qMN9GlpaUemT86jAkRuzXr4M3S/BYv4ejLGcWhIT4ui0fzz7m5ZgAeYV4bpDFRccHRgZ
	dTLbquzHKtgc0bq7H7ZSi1oXnDRwQoOPaLMRGPKw7BI6wsRlX/g7MnnKg4f0oGU8jrQiHVx0Y+/
	gnRukeMt7PbDTY98x7UqF2
X-Received: by 2002:a05:6808:6f91:b0:467:2652:b29d with SMTP id 5614622812f47-46ef5001816mr2779936b6e.8.1775273927383;
        Fri, 03 Apr 2026 20:38:47 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46d8f9609bfsm4224118b6e.3.2026.04.03.20.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 20:38:45 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Fri,  3 Apr 2026 20:38:43 -0700
Message-ID: <20260404033844.1892595-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3CA41C000C
X-Stat-Signature: ddeindmmewxaskkqw591wy9rxmm3s3fa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775273928-13921
X-HE-Meta: U2FsdGVkX181gOK5Eo3RdP5++foa9ovF6efDrgDcSAiGHfiqvCe8K6aliQhzUt9olTBqN1faTgIhpW2kEMQBFmZM/lSH/wdYqlOhaoufWUo6yEe9qXQvzVAneRm2e/8IdXjkWVAVl3h7IehVu2jKbNPcQaYpR6t7dse3dcKZVgaqKDwLw/gVRq22/HWhbwVzj0owtxrAkoVFlvqKyoN4L29/cCyuk2jp9w91Ko0EwAD8obq+QsnNb5l3aGo5vBiNJmqqC0BvBp0g3QXR2DtA22aqL9Qp2254BrO7DIAQPKCVOwXeONWCAlPqnJ1T5DZg/U+rR691sdMDi5VRi9nuSmhqL+ezELgKNiLatJJCH6AskHCK6Lzz67bnmMIREuQSidwVjoUa4D6OxNLuVqa8Jl+kfENCrAASiICeA7B2Nx8TFmMDgRhV5LO7EZ60VceAZnJme6/7nHl2/y/hkbg8clVibwqRsfRs5vYpilzG257G1Cyn67HueEhu4KQ4DWOkGz7z6JLcqBwx4F4SYlE7uRIvzeXpucuTmlMVTISeXBrGZEIkHXfusfbVqyyNAk6cyrhgpKQ3Lv99Q7XNMmLyH9iUIy6rlDFpkUPtVia+A+HlOFoi0CTB+gxs0aG4lMhiYtoD5Pm3SV2nB7lXa6zBSBqg7cjH0DrfREAqHxPr8cEUDmc+Ash8l1AdB6chDgSgDvb29rRjslFzGxIfSHHburPm5JUG3utuXzZveSpw3HB07rimYeCVQ2QxhwJl4rOxcePwEgQj9emOasOVaTv7k9CsdyHo6aBg7oOqKGbJKhYuo7Us90j5U+uTMVs6H3xZ56BKjccDuKiZ/8NuHhuFMsggL/64hSQCcphwAbbQD7FGmrq0bmONAXxwIQrK7XvI3FYakEXDCg3pxAqYKRWYAJcAE320UbVqKaJnqUcEwWcBqQbAoohbhLi+iiOh72ScaXlBjbDxJv6QwkVgC34
 G8+QWqTH
 nW8YaN+xG6qgxZ5CcCz6+Z3eE9EeQDSa4PhItUm1hoE6iFjEPxEHhCAIaFF5JD6DQBnfrovBtw/5kgCncjwPg+/sMRUtCKfuXDHx4oKvOA+62IPJrGnstNscQPxLo27OmucULIIRe8n+vEuA6BS94G39e0RgM+RNDfwc46cKloseVRK4+EyFn5E/fKspC4jl7+g5F10+IujxWt8qn0CTwe1pUXr1HCssCqTc1q4taR0asuLJwQUA+4AQzvMFZhjt+t7Xe5KK2IvubkRJ3YBSnFLIe9bi2Vd2jUNc0w2M36VxTBXXRCtTLvPWuQrjMbxY41t5J9mA/Otw6MBYaKQK1Si/LqPYn7j844iGiwA3r3+idssOcrNfHNlEKs3zSwPk+Q0CkrdRlbx6QZbbieQcAdZZYTsM9E2Gj0L1IF2AHHMiiVz82e2roeKFBDXms+UzslpQWGyUoYQDCchkCppBBBU18VqR3XEqJtZxp03BdAcGcjrN+c2XFMubR9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

enum memcg_stat_item includes memory that is tracked on a per-memcg
level, but not at a per-node (and per-lruvec) level. Diagnosing
memory pressure for memcgs in multi-NUMA systems can be difficult,
since not all of the memory accounted in memcg can be traced back
to a node. In scenarios where numa nodes in an memcg are asymmetrically
stressed, this difference can be invisible to the user.

Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
to give visibility into per-node breakdowns for percpu allocations.

This will get us closer to being able to know the memcg and physical
association of all memory on the system. Specifically for percpu, this
granularity will help demonstrate footprint differences on systems with
asymmetric NUMA nodes.

Because percpu memory is accounted at a sub-PAGE_SIZE level, we must
account node level statistics (accounted in PAGE_SIZE units) and
memcg-lruvec statistics separately. Account node statistics when the pcpu
pages are allocated, and account memcg-lruvec statistics when pcpu
objects are handed out.

To do account these separately, expose mod_memcg_lruvec_state to be
used outside of memcontrol.

The memory overhead of this patch is small; it adds 16 bytes
per-cgroup-node-cpu. For an example machine with 200 CPUs split across
2 nodes and 50 cgroups in the system, we see a 312.5 kB increase. Note
that this is the same cost as any other item in memcg_node_stat_item.

Performance impact is also negligible. These are results from a kernel
module which performs 100k percpu allocations via __alloc_percpu_gfp
with GFP_KERNEL | __GFP_ACCOUNT in a cgroup, across 20 trials.
Batched performs 100k allocations followed by 100k frees, while
interleaved performs allocation --> free --> allocation ...

+-------------+----------------+--------------+--------------+
|    Test     | linus-upstream |    patch     |     diff     |
+-------------+----------------+--------------+--------------+
| Batched     | 6586 +/- 51    | 6595 +/- 35  | +9 (0.13%)   |
| Interleaved | 1053 +/- 126   | 1085 +/- 113 | +32 (+0.85%) |
+-------------+----------------+--------------+--------------+

One functional change is that there can be a tiny inconsistency between
the size of the allocation used for memcg limit checking and what is
charged to each lruvec due to dropping fractional charges when rounding.
In reality this value is very very small and always lies on the side of
memory checking at a higher threshold, so there is no behavioral change
from userspace.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Updated commit message to be more explicit about motivation, suggested
  by Michal Hocko.
- Added performance and memory impacts, suggested by Michal Hocko and
  Yosry Ahmed.
- Instead of completely dropping the "extra" overhead of obj_cgroup
  pointers, they are now distributed among the nodes, proportional to
  the number of CPU each node has.
---
 include/linux/memcontrol.h |  4 +++-
 include/linux/mmzone.h     |  4 +++-
 mm/memcontrol.c            | 12 +++++-----
 mm/percpu-vm.c             | 14 ++++++++++--
 mm/percpu.c                | 45 ++++++++++++++++++++++++++++++++++----
 mm/vmstat.c                |  1 +
 6 files changed, 66 insertions(+), 14 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0861589695298..96dae769c60d6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -34,7 +34,6 @@ struct kmem_cache;
 enum memcg_stat_item {
 	MEMCG_SWAP = NR_VM_NODE_STAT_ITEMS,
 	MEMCG_SOCK,
-	MEMCG_PERCPU_B,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -909,6 +908,9 @@ struct mem_cgroup *mem_cgroup_get_oom_group(struct task_struct *victim,
 					    struct mem_cgroup *oom_domain);
 void mem_cgroup_print_oom_group(struct mem_cgroup *memcg);
 
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val);
+
 /* idx can be of type enum memcg_stat_item or node_stat_item */
 void mod_memcg_state(struct mem_cgroup *memcg,
 		     enum memcg_stat_item idx, int val);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7bd0134c241ce..e38d8fe8552b1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -328,6 +328,7 @@ enum node_stat_item {
 #endif
 	NR_BALLOON_PAGES,
 	NR_KERNEL_FILE_PAGES,
+	NR_PERCPU_B,
 	NR_VM_NODE_STAT_ITEMS
 };
 
@@ -365,7 +366,8 @@ static __always_inline bool vmstat_item_in_bytes(int idx)
 	 * byte-precise.
 	 */
 	return (idx == NR_SLAB_RECLAIMABLE_B ||
-		idx == NR_SLAB_UNRECLAIMABLE_B);
+		idx == NR_SLAB_UNRECLAIMABLE_B ||
+		idx == NR_PERCPU_B);
 }
 
 /*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f1..b320b6a426966 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -377,6 +377,7 @@ static const unsigned int memcg_node_stat_items[] = {
 	NR_UNEVICTABLE,
 	NR_SLAB_RECLAIMABLE_B,
 	NR_SLAB_UNRECLAIMABLE_B,
+	NR_PERCPU_B,
 	WORKINGSET_REFAULT_ANON,
 	WORKINGSET_REFAULT_FILE,
 	WORKINGSET_ACTIVATE_ANON,
@@ -428,7 +429,6 @@ static const unsigned int memcg_node_stat_items[] = {
 static const unsigned int memcg_stat_items[] = {
 	MEMCG_SWAP,
 	MEMCG_SOCK,
-	MEMCG_PERCPU_B,
 	MEMCG_KMEM,
 	MEMCG_ZSWAP_B,
 	MEMCG_ZSWAPPED,
@@ -920,9 +920,8 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
-static void mod_memcg_lruvec_state(struct lruvec *lruvec,
-				     enum node_stat_item idx,
-				     int val)
+void mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
+			    int val)
 {
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
@@ -936,6 +935,7 @@ static void mod_memcg_lruvec_state(struct lruvec *lruvec,
 
 	get_non_dying_memcg_end();
 }
+EXPORT_SYMBOL(mod_memcg_lruvec_state);
 
 /**
  * mod_lruvec_state - update lruvec memory statistics
@@ -1535,7 +1535,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "kernel_stack",		NR_KERNEL_STACK_KB		},
 	{ "pagetables",			NR_PAGETABLE			},
 	{ "sec_pagetables",		NR_SECONDARY_PAGETABLE		},
-	{ "percpu",			MEMCG_PERCPU_B			},
+	{ "percpu",			NR_PERCPU_B			},
 	{ "sock",			MEMCG_SOCK			},
 	{ "vmalloc",			NR_VMALLOC			},
 	{ "shmem",			NR_SHMEM			},
@@ -1597,7 +1597,7 @@ static const struct memory_stat memory_stats[] = {
 static int memcg_page_state_unit(int item)
 {
 	switch (item) {
-	case MEMCG_PERCPU_B:
+	case NR_PERCPU_B:
 	case MEMCG_ZSWAP_B:
 	case NR_SLAB_RECLAIMABLE_B:
 	case NR_SLAB_UNRECLAIMABLE_B:
diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index 4f5937090590d..e36b639f521dd 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -55,7 +55,8 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 			    struct page **pages, int page_start, int page_end)
 {
 	unsigned int cpu;
-	int i;
+	int nr_pages = page_end - page_start;
+	int i, nid;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
@@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 				__free_page(page);
 		}
 	}
+
+	for_each_node(nid)
+		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
+				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
 }
 
 /**
@@ -84,7 +89,8 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 			    gfp_t gfp)
 {
 	unsigned int cpu, tcpu;
-	int i;
+	int nr_pages = page_end - page_start;
+	int i, nid;
 
 	gfp |= __GFP_HIGHMEM;
 
@@ -97,6 +103,10 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 				goto err;
 		}
 	}
+
+	for_each_node(nid)
+		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
+				    nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
 	return 0;
 
 err:
diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed0..51c160deca01a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1632,6 +1632,45 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	return true;
 }
 
+/*
+ * pcpu_mod_memcg_lruvec - update per-node memcg percpu stats
+ * @objcg: object cgroup to charge
+ * @size: size of pcpu allocation
+ * @sign: 1 for charge, -1 for uncharge
+ *
+ * Charge percpu memory across NUMA nodes proportional to per-node CPU count.
+ * Includes the obj_cgroup pointer overhead (see pcpu_obj_full_size) from the
+ * chunk's obj_exts array, but spreads proportionally across all nodes to
+ * avoid attributing it to a single node.
+ *
+ * The "extra" size calculation is best-effort but deterministic.
+ * Charges will equal uncharges, although there may be small discrepancies
+ * due to rounding up/down.
+ */
+static void pcpu_mod_memcg_lruvec(struct obj_cgroup *objcg, size_t size,
+				  int sign)
+{
+	struct mem_cgroup *memcg;
+	size_t extra = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+	int nid;
+
+	memcg = obj_cgroup_memcg(objcg);
+	for_each_node(nid) {
+		struct lruvec *lruvec;
+		unsigned int nr_cpus = nr_cpus_node(nid);
+		long charge;
+
+		if (!nr_cpus)
+			continue;
+
+		charge = nr_cpus * size +
+			 mult_frac(extra, nr_cpus, num_possible_cpus());
+
+		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		mod_memcg_lruvec_state(lruvec, NR_PERCPU_B, sign * charge);
+	}
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1644,8 +1683,7 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
 		rcu_read_lock();
-		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+		pcpu_mod_memcg_lruvec(objcg, size, 1);
 		rcu_read_unlock();
 	} else {
 		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
@@ -1667,8 +1705,7 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
 
 	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+	pcpu_mod_memcg_lruvec(objcg, size, -1);
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b33097ab9bc81..d73c3355be715 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1296,6 +1296,7 @@ const char * const vmstat_text[] = {
 #endif
 	[I(NR_BALLOON_PAGES)]			= "nr_balloon_pages",
 	[I(NR_KERNEL_FILE_PAGES)]		= "nr_kernel_file_pages",
+	[I(NR_PERCPU_B)]			= "nr_percpu",
 #undef I
 
 	/* system-wide enum vm_stat_item counters */
-- 
2.52.0


