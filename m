Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C90A606A88A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=BEnmhypO
Received: by kanga.kvack.org (Postfix)
	id 129C26B05CD; Mon, 16 Nov 2026 06:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAF06B05CE; Mon, 16 Nov 2026 06:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F376F6B05CF; Mon, 16 Nov 2026 06:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB6036B05CD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:05:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40ACA8091D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:49 +0000 (UTC)
X-FDA: 85440702018.27.78AC93B
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf30.hostedemail.com (Postfix) with ESMTP id 65B448000D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:05:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BEnmhypO;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C4ywSkJsWV8hlNQvfAA7CBUzypleCa5Ls4MfcbDg+g0=;
	b=bL0a3ABo0GlKIl/VZGedLr4WmjmMLr+OGVUzz9d4Jhoq9DfUB26MPXcVEe1DhZk0B7jRoR
	lyc03FmaGzJfAELlW93y7np3LTaBkbjEg7SQ8/684HSHGV+5iiMMimSfUEjcdkouYxsw5V
	txLMAKVX/+mtVmQSG7kH3Z/lvH05f6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827147;
	b=IwNotCP2lHK86NzxxpsR0pJjue1in0MQjdScthQIp8MqUl8uP21mYS07CoAeCyRz5J14Ab
	NrOSj+wfHfC4EbXDajTrKtQg0s7IbeOjh49fs0wCGi3oiuy5CTo62D3hv7LhDUNMkbl98O
	caDXSVOX2b65rMC4mFJN5QjiI/WynKM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BEnmhypO;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794827140; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=C4ywSkJsWV8hlNQvfAA7CBUzypleCa5Ls4MfcbDg+g0=;
 b=BEnmhypOpsh8uhkP7ys8vGEhOgri2TNsfrE/klF/J3zgBfdFWBR1RoQu42PMcb9bnnpB8s
 9PDQ14h/LDSmfFvg2FA9yzjNQVvcuJfNYMRFDA5KtVQ4DOcu2wT5dHXL/XNuQiWcMgGB7M
 Krzsl60SL5rtx+9Hm6yJEqVYyZSOx02uOQpARx3gqFff+I4bu9SPJQ0vKOHgnrswnUm+93
 6faG3mCXqPosxFuz1kTtSzWCrNjUQrR8mwkBB9wYS6jaT/Hyz3KwTR7VkpLCLpYm27fXE4
 bWk5VHCMWckw0V7R8XLkXhbxMyDbP2ROXsQjO/gMR9uqEpP18R3qQGVKJKtHDA==
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26afae383+0ae50b+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v3] mm: add source selector to memory.reclaim
Date: Mon, 16 Nov 2026 19:04:59 +0800
To: <joshua.hahnjy@gmail.com>, <akpm@linux-foundation.org>, 
	<david@kernel.org>, <gourry@gourry.net>, <hannes@cmpxchg.org>, 
	<ljs@kernel.org>, <mhocko@suse.com>, <muchun.song@linux.dev>, 
	<rakie.kim@sk.com>, <roman.gushchin@linux.dev>, <shakeel.butt@linux.dev>, 
	<weixugc@google.com>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Message-Id: <20261116110459.11048-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 4spuorutfajzb6iakka5htryrjankwhd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 65B448000D
X-Rspam-User: 
X-HE-Tag: 1794827147-723104
X-HE-Meta: U2FsdGVkX19c3AeRUerkT42/a4ljBodHb1ii273gP9IlOBJKIpDNmJ+A+DwbEdBmYHz6MahAPv8vKWauEs0a1hc8Epq855QlwkzQg/Cz9yywun2LOnyHl7H481Rko6xT/KBWnja4Okunb9t2lqAzUmQg4y4QVJlabOxaeJl2AjGKjjXrGACvrF5/IRifBhqY4cqYb3aaHHxEcAYmGddiLNGkm1VH83247m9fOe/38fSfrmluKKf/smv9cP4Vv0kCDNrPZn9iH7LAfzsVqxkGJihNXZRHFMfMJRYua8pItQtFbj+OPc1LXA4DM+jn/i1qpgaL8BJ0fGf0uucXAQks3/DzHI3DzPTvFDFnfzsoe5VS9hswik2mLa0N7cY0yPdAH4ixN5hkZXhI7NsljfH8wgJM0ntSCxhv+av605d+WY7RBiMVuelg0IUbi1Uk4gmt5tLc59aIgrqvOLU/I/JfuP/6s/kOnvqfvUtjCOBS/i1Lml8+DmMFPz3PE/ax0HTwGff1JLly54vppXt0mNmBBGWhdWASa+7M9NttGJ8CwMseR2p5Rdh4eEHcPh9Qj5kKrm0G/8nPwMN/qPwaSKWTqFYEBJDZoSVSPIuX0PPaOz7teaQLXkOPNSOjHEsPJjtJw5hvrcBY/jyoQrDFakF1oA+gnOChB37fN/B8UhD0hv60Gs87wUIJU0EynCVF6kAio74gtWxp1BbgJwswRb/apc6cNNsx82/A/tHu8bnyq923TBUtXM7kWWgHfmRBKGjUZP3jcLOrHo0Wa6vjYIJAYvDfnjv68rXvW0RBR8NaRkC6vMt+PSSrjX6P2Sz8sNiIFgfkt7t49C7HDqNe3H8rN0s93hYNMtHI4BwxrAplakhigfKBmu498b/8/jp4qbTGakQju35Fgplyde7ao6Bou0GF4CR2rM93hY5i2jqy5Fj6ZvANU1bnjO6p4eD2tZfY+p9P025BqkmWEZ9OV49
 JZ/BbVzD
 xx66kMGvF0NDNd/e8wmSoqJ6QPnnY+1HGvZotgpAD4Raz8wx5Ruoa+igJBuwi0Yk6JXxXfJiocPlWPDhtD1VDUYivfGWjlE+20DcZYt1WjwEWVDughJJLA6cFn8Cpk+QUXBhsQdGPzEUxK95fYYQ4AnYeZm6Y0Qdy0uUifw+kxg5/LTTFawBBViyOLMNggqBdNQ5n/JFDojN/sI0sC8VxDu5c2EWI+ROm9GTu5wvZ+ddcJyn4nLUOwpZAoitPLTbxqrZ59i97KNOMtQyk5d2RY8hwGbK1y+hTl9FECzFp6F71+RGE5UOU+nATOPhBarTigQexhFXBg91IF8UQYt7ABQVzNkJDyhAVQv0uqEOMKGZD/3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memory.reclaim can apply proactive reclaim to a memcg, but it cannot
target source nodes the way global node reclaim can. Proactive memcg
reclaim follows a fast-to-slow fallback order, which attempts demotion
before reclaiming from slower tiers.

As a result, a memcg controller cannot decide whether reclaim should
start from DRAM or from a slower tier. For a cgroup that is close to OOM
and needs charge reduction, or for a controller trying to shape a
workload's DRAM/CXL resident distribution, the default policy may spend
reclaim effort on the wrong source tier.

Add source=nodes:<nodelist> to memory.reclaim. The selector only chooses
the resident source nodes where the existing memcg reclaim path applies
pressure. It does not select demotion targets, force demotion, force
eviction, promote pages, or change completion accounting. Leaving source
unspecified preserves existing behavior.

With this, userspace can build the policy it needs on top of existing
kernel reclaim behavior:

1. start reclaim from lower-tier nodes to reduce the cgroup's memory
   usage more directly;
2. steer reclaim toward over-represented nodes to shape a workload's
   DRAM/CXL resident distribution; and
3. reclaim from lower-tier nodes first so later top-tier reclaim has
   room for demotion.

Example: nodes 0-2=DRAM, node3=CXL

  echo 1G > memory.reclaim # progress from nodes 0-3
  echo "1G source=nodes:3" > memory.reclaim # reclaim from CXL
  echo "1G source=nodes:0-2" > memory.reclaim # usually demote to CXL

The typed source= form also leaves room for future source selectors
without changing the ABI introduced here.

Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
resident ratio while a background workload created reclaim and demotion
pressure. With source=nodes, all eight cgroups ended with 45%-55% of
their memory on DRAM. Under the same pressure, the plain memory.reclaim
baseline left the worst cgroup far away from the target range.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/#t
v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/

Changes since v2:
- Dropped the separate cover letter and shortened/refocused the commit
  message, as suggested by Joshua Hahn and Gregory Price.
- Added an eight-cgroup CXL test summary under background
  reclaim/demotion pressure, as suggested by Joshua Hahn.

---
 Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 72 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2..992f9bdc46a1 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1458,6 +1458,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  source                Source to apply reclaim pressure to
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1468,6 +1469,16 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	Specifying a source value constrains where proactive reclaim applies
+	pressure. Currently only source=nodes:<nodelist> is supported. For
+	example::
+
+	  echo "1G source=nodes:0-1" > memory.reclaim
+
+	This applies proactive reclaim pressure to memory of the target cgroup
+	resident on nodes 0-1. It does not constrain demotion targets and does
+	not change memory.reclaim completion accounting.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..7d98f55a044f 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
 	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
 						    MEMCG_RECLAIM_MAY_SWAP |
 						    MEMCG_RECLAIM_PROACTIVE,
-						    swappiness == -1 ? NULL : &swappiness);
+						    swappiness == -1 ? NULL : &swappiness,
+						    NULL);
 
 	return nr_reclaimed * PAGE_SIZE;
 }
diff --git a/mm/internal.h b/mm/internal.h
index e3f92883bf23..ff24a58d47e8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   const nodemask_t *source_nodes);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f286888507..74aa06fee76a 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			break;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 84f4a8fd4d16..116c6853c9ba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..15e2e5710468 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
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
@@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   const nodemask_t *source_nodes)
 {
 	return 0;
 }
@@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
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
+#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_NODES) - 1)
+
+static int parse_memory_reclaim_source(const char *source,
+				       nodemask_t *source_nodes)
+{
+	const char *nodes;
+
+	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
+		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
+		return -EINVAL;
+
+	nodes = source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
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
@@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
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
@@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
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

