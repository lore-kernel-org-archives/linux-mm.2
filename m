Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5AA606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 07:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=mDscme0I
Received: by kanga.kvack.org (Postfix)
	id 685396B05B3; Mon,  2 Nov 2026 02:06:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635846B05B4; Mon,  2 Nov 2026 02:06:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE9F6B05B9; Mon,  2 Nov 2026 02:06:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17F5C6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:06:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA522A0BE7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:06:11 +0000 (UTC)
X-FDA: 85389294942.25.76AA7B1
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8AC1C0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:06:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mDscme0I;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793603170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enLchkwkJtq/TfAQp+411aBERINT09YDWrENgNdLIdE=;
	b=FEw3iCeawA7u3ONDSCqAi/Bhqp/iutyVKAcpTH6AotSawUoVYT9c1xUyiYByHhFJYqzJFY
	UsGjiN/t54eAIBOAkcnLk5+S29xnQ5OUuNGK+rmnBSYXgX1KEbBo8swLhpOEEweBibb/iA
	J6NVIaKgfMbGeYHaogCGkc5A0vXYX1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793603170;
	b=2weFRbupmgzzawIeg+AlDT9y4CBQsXH7uA/Bo9kaIP/DsONOdk5wHNuE1BsQ6fo49dyAsN
	4+eR9wY9DIJ9A57j9WFfI1C6s0bZYAQvX8xrqQFpDWSVRVdhNaIbsWPDh2Tgmg9CSGEPWe
	IG/xCOnUgppuyMpMaG848BbqyCzROl8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mDscme0I;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793603163; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=enLchkwkJtq/TfAQp+411aBERINT09YDWrENgNdLIdE=;
 b=mDscme0Ira6yOrKix6TTp5H8gH9sWt80A3Vx53zOxzeiCdCIDgCaUPmVrKM0eADVS2uDi9
 Pe5bH+B2Pohw4l47wIoMVBm1Jah3IrtZ7XtfQb1QlcmlhgGs+AJLxHhXzm6I5wPGCbmBpq
 1HpNVtoEXmznWPrmr6x3CwgmfUrZ/sl+hBmI4r2BmZ2sLoNHx4r4esXC2JqLHPY5sOyRc1
 GpVb6sOln7MVHM0s7Un/2gsqFfrd3Hq9jdrNrSURbDUEZ/hslCUbjuzK+zeG/VPdTGliYn
 8Ko4tFj5a/LVpRxADrS5rlt0WBMez3paifHF00p8lOqjgV8wujb8DDcbxlwy/g==
Subject: [RFC v2 1/1] mm: add source selector to memory.reclaim
X-Mailer: git-send-email 2.45.2
References: <20261102070440.16262-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<joshua.hahnjy@gmail.com>, <ljs@kernel.org>, <mhocko@suse.com>, 
	<muchun.song@linux.dev>, <rakie.kim@sk.com>, <roman.gushchin@linux.dev>, 
	<shakeel.butt@linux.dev>, <weixugc@google.com>, 
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>
Cc: <cgroups@vger.kernel.org>, <linux-doc@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Mon,  2 Nov 2026 15:04:40 +0800
In-Reply-To: <20261102070440.16262-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261102070440.16262-2-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ae83658+4c6a87+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8AC1C0003
X-Stat-Signature: yzp4bze8kqk1gqyfat1r8mquqa99j136
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793603169-42135
X-HE-Meta: U2FsdGVkX18MOylG+WrrVP/3aT0HVHBta6GbSFA6nhUQSAQ1sw10hmbFc195gU/yYjmmGQbBR0PK84ghfAGILjKtJJeA4SfZlNRvoZ6sO5n3JRJdJqQ3WGOWeydTTOmZfsLiBnxwYrPhtE5QczB4+ZQleDITrzY7MqAnNd8hHEUdvsS+kGK+svv2RlRqKH5mhgtrCnm3hRYSicQQDlSoBsyVBsUtg5aTNESyK4f2IMzUqiFoaUgYnox5Nntkvy2xZkCjS5cH8ItQIufDhyjq9cYGVVgxMQkjNbQc1owQsea+4mVQGU8OYNSqAap4RU43LXUNl+SepAMOPEBxvOS0JkGqnMyP+KBkSLExf3tUYlq+tv4/B0hS7Bx8y8fsJyR8+Otkao+9m7/WVLO6ZWxEkOrKw7/xRptET6c2sJixqtAB+AibrGzSt7pYHfegzQ/Q+bwxv8MJfROA2iwmxwfdCoQnCtSYu6Pv2QIooBNODHdzytiZgEIDE6f6055aB2PYPcK14IL/Wu+DB6iQzb5p1860ujG5bKBXXvc+5AkYTwciSvlNEVezhqpqPz+UUf9TA13/q+VGENcl3g+AMjOrf5MfHEmeYP+4P9w0iqx0ciggPEq/CHyKX39m0NFZJs0LHUtNLnvTG9R9qj9aPlktgAD7bCYOLrPjRQ1b/t/1uOotziGaCrE5/hEvZ0Jups17PNe3dV4AASg2A8rfHa+EeBHUl1D1Y05d4D9nQsVfS0GHznKXKKzwskwf4CuhTpGQyHUWUyShppaQZmpUai+Q5EEV1Xr68HUSJs8uPXAunCGz8qg9QTIuyNTWEx3pM/Jj+pshGdEXuDlH96oEU4bnfNoZ/lPlLRZv8J32oO7m+LYh4/PoeoHCurWivcMzgLv1h3O2u2szLfO8Uvt7UVF2gklD1m3ca5VeW6IrYFGOoxQVXlMso2lzBsr6Zsiwj/lofYUnZtG2OwgTCvwJOqu
 eSsGBvLn
 vO4UnTf48wiNaEoZLX9f5SFlm/6z9REDs9RtxOoF0OXfACmS7EokgVLWfaCi9un/w7hiFG9VIXRmMR0c9L8CAQVcTNnW74rQZdsTVsVSmo1PT1Vl66AsSD2Tvmso5Hwg1lj2q9xRjVMWOHrVHUseAZEoe4qITViD0s1CIc5avQKU9Z38FL1lH70+AN8Mb99sZfV7cpPYcr9/hRo0OguWa2aDMYJesiytkT1dzH2/C9oq3VQYXF7mdLb31eDMeV9uh4bLycO4NxcKBFNPIFslR34tTKP2K05mpCMa0sPF5n7OceuGrgFY2/yHDCAvabIS3eynJLg4OvoPWmGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
direct reclaim pressure to the resident memory it wants to relieve.
It can only ask the kernel to reclaim from the memcg as a whole,
while the resulting progress is reported as one aggregate value.
This makes effective tier-ratio control largely infeasible:
userspace can observe that the distribution of memory across tiers
has drifted away from the controller's preferred balance, but it
cannot direct the next reclaim request to the corresponding source
nodes. It also makes controlled charge reduction unreliable: a
controller that wants to free memory from a terminal tier cannot ask
reclaim to start from that tier.

Add a typed source= selector to memory.reclaim. The first
supported form is source=nodes:<nodelist>. The selector declares
the source nodes to which userspace wants the kernel to apply the
normal memcg reclaim path. It constrains the source to which reclaim
pressure is applied; it is not a demotion-only goal, an eviction-only
goal, or a demotion target selector.

The selector only chooses where the existing reclaim policy is
applied. It does not change when the kernel decides to demote,
evict, activate, or keep a folio.

With this primitive, userspace can build higher-level policies by
choosing different sources across requests. For example, a
controller can issue one request against top-tier nodes for tier
balancing, another request against lower-tier nodes to make room for
later demotion, and another request against terminal-tier nodes when
it needs actual charge reduction. This composes tiering policies from
a simple source selector instead of adding policy-specific
memory.reclaim keys. This patch does not change the reclaim policy:
memory.reclaim continues to run the kernel's existing reclaim path,
now with an optional source constraint.

Leaving source unspecified preserves the existing memory.reclaim
behavior.

The source= key is intentionally typed so future selectors can be
added without reinterpreting source=nodes:<nodelist>.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  9 +++++
 mm/bpf_memcontrol.c                     |  3 +-
 mm/internal.h                           |  3 +-
 mm/memcontrol-v1.c                      |  6 ++-
 mm/memcontrol.c                         | 11 ++++--
 mm/vmscan.c                             | 49 +++++++++++++++++++++++--
 6 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 9e3c67b02ae2e..ee42da817c062 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1458,6 +1458,7 @@ The following nested keys are defined.
 
 	  ==========            ================================
 	  swappiness            Swappiness value to reclaim with
+	  source                Source to apply reclaim pressure to
 	  ==========            ================================
 
 	Specifying a swappiness value instructs the kernel to perform
@@ -1468,6 +1469,14 @@ The following nested keys are defined.
 	The valid range for swappiness is [0-200, max], setting
 	swappiness=max exclusively reclaims anonymous memory.
 
+	Specifying a source value constrains where proactive reclaim applies
+	pressure. Currently only source=nodes:<nodelist> is supported. For
+	example::
+
+	  echo "1G source=nodes:0-1" > memory.reclaim
+
+	This reclaims memory of the target cgroup resident on nodes 0-1.
+
   memory.peak
 	A read-write single value file which exists on non-root cgroups.
 
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c285600..7d98f55a044fa 100644
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
index 566cbd2dce485..b16efceb58458 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness);
+					   int *swappiness,
+					   nodemask_t *source_nodes);
 
 #ifdef CONFIG_NUMA
 extern int sysctl_min_unmapped_ratio;
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index b7f2868885071..74aa06fee76a0 100644
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
index a05d9a8baa1b6..f07dc44b9e4fc 100644
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
@@ -2771,7 +2771,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4996,7 +4997,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}
 
 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -5055,7 +5057,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..265807e437af4 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness,
+					   nodemask_t *source_nodes)
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
+					   nodemask_t *source_nodes)
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
+	nodemask_t *source_nodemask = NULL;
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

