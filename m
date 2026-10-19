Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EA1CCF2E5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DAFD6B0274; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C286B0275; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6523E6B0277; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9B66B0274
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:16:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C2D2406D0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:16:00 +0000 (UTC)
X-FDA: 85339574880.10.EBD0CC5
Received: from sg-3-111.ptr.tlmpb.com (sg-3-111.ptr.tlmpb.com [101.45.255.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8ED96A0010
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:15:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HhEh75DT;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 101.45.255.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419357;
	b=RpuJSKl/oP/0BF5IPIAxhRLfYjBvpCyqSWa/VlbnHytSCcqObZZ6xj1OTsX8ng2xqxCMUB
	9LnHqbG0FcGYUejzJ1AtYjJnZZKsG3gS5ZKO/TbJgbYKh+Lnqsy6OGhe0/aDMybrmsQisx
	ALLhU02iUIHuyKrvDyaJhTHoscaClFU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HhEh75DT;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 101.45.255.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KJMWpu/UgB92zfuX3x+6i2oD6X1DfxXO1Ew5ezvvpE0=;
	b=URLq5rqTg1gST91SfbDbFN+FJx2owpKSMdhTvJ9zMlr7LDUos29H94EhQ5PNSm5RLudr3z
	L6OLfAh911MXv2GoigiZeODBqvEr8nGYbum5f5NbgWpDQYyED0C/BKCuEDMlhrUiPqZxmK
	XW6xPNxokQFWNk4g2q3Ze/9OrpNrRsU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792419300; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KJMWpu/UgB92zfuX3x+6i2oD6X1DfxXO1Ew5ezvvpE0=;
 b=HhEh75DTprzGdtEikWOk4RVpGhfVd8SG4HPVeFE+0RoXSHNSUDzm1nqUTPFIHGl9sHdnOd
 hiwiMUF+6DYNpBpPoe4Hz7fTZtGiHQwCRoPMVEttzVDviirNqkxAze8fhCgZTVvcoD9eFk
 ae9HknLda9nasoCvC2lc4JxVWrWJ/wCDfpxXXx8WTH8ZSbmavmgjUG9l1RGpVIwUwBudNT
 uieyChwX3gvzm3cUECxjvTBDV/lGXCmFfmTwRx4nPtRpohqS/klwa+awwIfikypbYlviMO
 v6YVgBggrWYF8uISO6ewdM/LUKjQs57IINORwvTWCGvo+d+pJ18ITLRHKFrMrw==
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>
Message-Id: <20261019141401.11927-2-lizhe.67@bytedance.com>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [RFC 1/2] mm: add source selector to memory.reclaim
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 19 Oct 2026 22:14:00 +0800
X-Lms-Return-Path: <lba+26ad625e2+98762c+kvack.org+lizhe.67@bytedance.com>
X-Stat-Signature: 6sraedo3nbfm6aypnonp61unkw3wiif4
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8ED96A0010
X-Rspam-User: 
X-HE-Tag: 1792419356-787914
X-HE-Meta: U2FsdGVkX1/xvvhZ9E4W9aofLlwEiVDYzlqnJXFzX7ScSGey/lgJanPwYdCLrHcJzKbBuuODibTNJlz/23HgxmvRtt1d3DojMxzI3zxY7/Ibb/mcymOaYmEv1rXi70qCf20+VnvOvRLSPjLc2yp4el5C2rRLMMKo7e+5MYGlbjPYlGa8y77+7T21CtdODW2D9HSgg+AYYaMPJUlUzivEfreKR78yxkD5G0izv9AGDgqxALagfiNUmSUQA8UsGbF5W6PS4ZhzGEPDUmSeUY/QAoidFpNnkrKNz6zOHnLNmvvyEcvQFRgVfWQ9t/jsl6gkROViInYDiADE6B0d94CznsnW21sBWNDMejzVSJkEiVqSVjvK82FUqZqWUYCcNxmb2CemHPitKdEyPV3QjG8bSgC2q9A/h9pZaMTN7P3OdaeGGmtld5L1hJbzo+SNQKslSKFi6dfxfjB9iP35nn4DQMvGYFg+F43eTLhY2UiXhWUqk9cdl93ZOGxOvgJ3FCdQJZle3KnrBL3vRnZcFRtVZllYpQdBnPr/WIbHvq0Ny4rCiOnr3aR4Z6A52aHiVhgXBEb2BfoTljF5PDH6KINJ7jHlOmbBlJcY7BysoVtMV/RoDRcooWm7iypQe379j+dMi9+St9l6V2bDV/siCwFp0ZNN79wQFxxQRyLtMzy3B7gmMVSGIG+dBgDClGKHMpN1zQGAQAQRYFwXR7O0r4Uyyu0FHM4O+mv24/4vyh1n2048E1srLpfSdZNdjR1U9kXWmUdxzcYb+y2YylFo5LkRrQ9cqiT6SIB8C2NyXgVV3bBDdfWScPtf6i14hOetNzgdtrBEfnbAFXpuYaDQv6TTbgvzhXZcVDvmVeJx5A3lwYYbTF3JEU7xS4PdyV5pNfUg1r8o2yIkmerQkHYtkon9CYz2LMGXnnPS4NCvsPYPhyPADi+Bg6JgZ/eTzfmrcpzJF8IcWUz7vIMmnt5vqLi
 0j3FExzg
 E4uZWGKcuPjxfrepnZ65MiQrmuIT+xn3PmVYChcRacu1fjl99uUbnl8Es8w41V4nX2hZpMm4wW4qNGIMFJ/P7kkuGe1ClMW9+5bpJbTWn1qRm//bo4gwKi48Ln53/s5jJ0mkxxwVjS6Sbov5soahaIplPp2P7Gs2pS/pHfij8z8gwWH5pxzts0SbaCRBcLI0wjz20rGBWmXB8c0TAncJALV1U8ZgNS6NwNVYxkG9arfyQKNHVrBKRV81hVQCftfHYZxqSBrDDuX0xogsgFRs/eniJXekgRI22c3SODimM8mXRplg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memory.reclaim was added as a generic proactive reclaim
interface for memcgs, but memory tiering makes its practical
meaning less obvious. Reclaim may demote cold folios from a
faster tier to a slower tier before they are eventually evicted.
As a result, a write to memory.reclaim can either move folios
between tiers or evict them from the cgroup, depending on where
the reclaim walk finds eligible memory and whether demotion is
available.

That ambiguity is awkward for userspace controllers. A controller
that is trying to manage DRAM, CXL, or other tier occupancy cannot
direct reclaim pressure to a specific source tier or node. It can
only ask the kernel to reclaim from the memcg as a whole, while the
resulting progress is reported as one aggregate value. This makes
effective tier-ratio control largely infeasible: userspace can
observe that the distribution of memory across tiers has drifted
away from the controller's preferred balance, but it cannot ask
memory.reclaim to apply pressure to the tier that should be
relieved. It also makes controlled charge reduction unreliable: a
controller that wants to free memory from a terminal tier cannot
ask reclaim to start from that tier.

Add a typed source= selector to memory.reclaim. The first
supported form is source=nodes:<nodelist>. The selector declares
the source nodes on which userspace wants the kernel to apply the
normal reclaim aging pipeline. It constrains the source to which
reclaim pressure is applied; it is not a demotion-only goal, an
eviction-only goal, or a demotion target selector.

The selector only chooses where the existing reclaim policy is
applied. It does not change when the kernel decides to demote,
evict, activate, or keep a folio. On common tiered-memory systems,
a source in a non-terminal tier will usually make progress through
demotion when an allowed demotion target exists. A source in the
terminal tier has no lower demotion target, so successful reclaim
progress from that source is eviction.

With this primitive, userspace can build higher-level policies by
choosing different sources across requests. For example, a
controller can issue one request against top-tier nodes for tier
balancing, and another request against terminal-tier nodes when it
needs actual charge reduction. This composes tiering policies from
a simple source selector instead of adding policy-specific
memory.reclaim keys. This patch does not change the reclaim policy:
memory.reclaim continues to run the kernel's existing aging-based
reclaim pipeline, now with an optional source constraint.

Leaving source unspecified preserves the existing memory.reclaim
behavior.

The source= key is intentionally typed so future selectors can be
added without reinterpreting the nodes form. For example, later
patches may add source=tier:<selector> or other source types while
keeping source=nodes:<nodelist> as the NUMA-node source selector.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 23 ++++++++++++
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++--
 mm/memcontrol.c                         | 11 +++---
 mm/vmscan.c                             | 48 +++++++++++++++++++++++--
 5 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 86a2a0099178..a016575010ba 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1454,6 +1454,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  source                Source to apply reclaim pressure to
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1464,6 +1465,28 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	The source key declares where the normal reclaim aging pipeline is
+	applied. It is a typed selector in the form source=<type>:<selector>.
+	Currently only source=nodes:<nodelist> is supported. For example::
+
+	  echo "1G source=nodes:0-1" > memory.reclaim
+
+	This instructs the kernel to apply reclaim pressure to memory of target
+	cgroup that are currently resident on nodes 0 and 1. Reclaim then
+	follows the normal reclaim path for selected folios. The source
+	selector does not choose a demotion or eviction policy. On tiered
+	memory systems, a source node in a non-terminal tier will usually make
+	progress through demotion when an allowed demotion target exists. A
+	source node in the terminal tier has no demotion target, so successful
+	reclaim progress from that source is eviction.
+
+	The source selector is a source constraint only. It does not select or
+	limit demotion targets; those are still chosen by the kernel's memory
+	tier demotion policy. Specifying source does not change reclaim
+	completion accounting. On tiered memory systems, completion may include
+	demotion progress that moves folios away from the selected source nodes
+	without reducing memory.current.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..c730309d39c8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -84,7 +84,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   const nodemask_t *source_nodes);
 unsigned long mem_cgroup_shrink_node(struct mem_cgroup *memcg,
 				     gfp_t gfp_mask, bool noswap,
 				     pg_data_t *pgdat,
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 05ef55cae4dc..00ee18f1e08c 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1814,7 +1814,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1850,7 +1851,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			break;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..40a2eab03032 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2394,7 +2394,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2716,7 +2716,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4878,7 +4879,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -4937,7 +4939,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..155d0ef82b48 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6856,12 +6856,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *source_nodes)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
 	struct scan_control sc = {
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
+		.nodemask = source_nodes,
 		.proactive_swappiness = swappiness,
 		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
 				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
@@ -6897,7 +6899,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *source_nodes)
 {
 	return 0;
 }
@@ -7947,20 +7950,50 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
 enum {
 	MEMORY_RECLAIM_SWAPPINESS = 0,
 	MEMORY_RECLAIM_SWAPPINESS_MAX,
+	MEMORY_RECLAIM_SOURCE,
 	MEMORY_RECLAIM_NULL,
 };
 static const match_table_t tokens = {
 	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
 	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
+	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
 	{ MEMORY_RECLAIM_NULL, NULL },
 };
 
+#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
+
+static int parse_memory_reclaim_source(const char *source,
+				       nodemask_t *source_nodes)
+{
+	const char *nodes;
+
+	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
+		    strlen(MEMORY_RECLAIM_SOURCE_NODES)))
+		return -EINVAL;
+
+	nodes = source + strlen(MEMORY_RECLAIM_SOURCE_NODES);
+	if (!*nodes)
+		return -EINVAL;
+
+	nodes_clear(*source_nodes);
+	if (nodelist_parse(nodes, *source_nodes))
+		return -EINVAL;
+
+	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
+	if (nodes_empty(*source_nodes))
+		return -EINVAL;
+
+	return 0;
+}
+
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat)
 {
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	unsigned long nr_to_reclaim, nr_reclaimed = 0;
 	int swappiness = -1;
+	nodemask_t source_nodes;
+	const nodemask_t *source_nodemask = NULL;
 	char *old_buf, *start;
 	substring_t args[MAX_OPT_ARGS];
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -7991,6 +8024,14 @@ int user_proactive_reclaim(char *buf,
 		case MEMORY_RECLAIM_SWAPPINESS_MAX:
 			swappiness = SWAPPINESS_ANON_ONLY;
 			break;
+		case MEMORY_RECLAIM_SOURCE:
+			if (!memcg || source_nodemask)
+				return -EINVAL;
+			if (parse_memory_reclaim_source(args[0].from,
+							&source_nodes))
+				return -EINVAL;
+			source_nodemask = &source_nodes;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -8030,7 +8071,8 @@ int user_proactive_reclaim(char *buf,
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
 						 batch_size, gfp_mask,
 						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+						 swappiness == -1 ? NULL : &swappiness,
+						 source_nodemask);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.20.1

