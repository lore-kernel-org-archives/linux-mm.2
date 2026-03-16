Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54CEDD58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 05:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A8D6B011C; Mon, 16 Mar 2026 01:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722546B011D; Mon, 16 Mar 2026 01:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625BF6B011E; Mon, 16 Mar 2026 01:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46B0D6B011C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 01:13:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D55A9C4270
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:23 +0000 (UTC)
X-FDA: 84550757886.26.686CC90
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id D675C8000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:13:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773638002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=voFfjHKKSKTN0e4NINSaq7X9kTADvhK6KftiedgQewA=;
	b=ij1n9kZSyAoVh8UgFbZ2VnMsTrAoP0dJgp0KuF4P/a2u8TD0Z4khhDxe0UgGfSLQwMwzZD
	wVk8jg+2i7lrghCdzVD7mYwJ3iPbJe7cBOubcqAqq+0c9VW2Cpf2zT3z9OY5bsoO46rlEn
	v36spEIhpy5O1q5PqmGZyP/206Qbido=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773638002; a=rsa-sha256;
	cv=none;
	b=4cryuubVf7IO0VhPOxIE0KNJcQ1FeIP56wwB2jVL14Dytvfl6gvQ+MdXcpVRcllWFDX4+5
	Ui/L1hQ7Y8DgL3DtCC0w3ehFzqq6H/LLJUZ1ecpElxtlcOqTzsm5gFk6l6cSVEZoNjYhLl
	sRKe5onjbrKv/84zIgNnEJpv+JE3iDU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of rakie.kim@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=rakie.kim@sk.com;
	dmarc=none
X-AuditID: a67dfc5b-c45ff70000001609-5a-69b7916a4adf
From: Rakie Kim <rakie.kim@sk.com>
To: akpm@linux-foundation.org
Cc: gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rakie.kim@sk.com
Subject: [RFC PATCH 4/4] mm/mempolicy: enhance weighted interleave with socket-aware locality
Date: Mon, 16 Mar 2026 14:12:52 +0900
Message-ID: <20260316051258.246-5-rakie.kim@sk.com>
X-Mailer: git-send-email 2.52.0.windows.1
In-Reply-To: <20260316051258.246-1-rakie.kim@sk.com>
References: <20260316051258.246-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsXC9ZZnkW7WxO2ZBvvPcVrMWb+GzeLu4wts
	FrtuhFhMn3qB0eLEzUY2i9U31zBaPN/6i9Hi593j7Bb7nz5nsVi18BqbxfGt89gttjc8YLc4
	P+sUi8XlXXPYLO6t+c9qcXLWShaLb33SFvf7HCyOrN/OZDH50gI2i9mNfYwWtyYcY7JYvSbD
	YvbRe+wOEh47Z91l91iwqdSju+0yu0fLkbesHov3vGTy2LSqk81j06dJ7B4nZvxm8dj50NKj
	t/kdm8fHp7dYPKbOrvdYv+Uqi8eZBUfYPT5vkgvgj+KySUnNySxLLdK3S+DKePl6P1PBQfOK
	+b/nszYwrtLqYuTkkBAwkXi+cS0bjP1lynsgm4ODTUBJ4tjeGJCwiICsxNS/51m6GLk4mAVW
	skqcP/mbGaRGWCBW4uPEEJAaFgFViS+zJrKA2LwCxhJbJ02CGqkpsW7jLRaQck6g8dsWGIOE
	hYBK5j35wA5RLihxcuYTsFZmAXmJ5q2zmUFWSQh8ZZc42XeUFWKOpMTBFTdYJjDyz0LSMwtJ
	zwJGplWMQpl5ZbmJmTkmehmVeZkVesn5uZsYgbG6rPZP9A7GTxeCDzEKcDAq8fBmHNqWKcSa
	WFZcmXuIUYKDWUmEd9kRoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeo2/lKUIC6YklqdmpqQWp
	RTBZJg5OqQZGlWcMG6fMNrV33XPozfYK/3zvKcnuv+b+3GrFfp/33EdfhdiUu+Yr5CsidWXV
	Y9bonIkvSM5aaH7t25LWz7xdq1UVveabTzojpqYrW/qouSo0Puwv7wOXzzo/9521r/M/pfPv
	4ZTIK+pP3m0/Pm312d9NdltnvP2svW/jBdbssuRm04fLJ+m4KLEUZyQaajEXFScCAIL+GRHR
	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsXCNUM9Rjdz4vZMg/UHLS3mrF/DZnH38QU2
	i103QizOTZnNZjF96gVGixM3G9ksVt9cw2jxfOsvRoufd4+zW3x+9prZYv/T5ywWqxZeY7M4
	vnUeu8XhuSdZLbY3PGC3OD/rFIvF5V1z2CzurfnPanFy1koWi2990hb3+xwsDl17zmpxZP12
	JovJlxawWcxu7GO0uDXhGJPF6jUZFr+3rQAKHb3H7iDrsXPWXXaPBZtKPbrbLrN7tBx5y+qx
	eM9LJo9NqzrZPDZ9msTucWLGbxaPnQ8tPXqb37F5fHx6i8Xj220Pj8UvPjB5TJ1d77F+y1UW
	jzMLjrAHCEZx2aSk5mSWpRbp2yVwZbx8vZ+p4KB5xfzf81kbGFdpdTFyckgImEh8mfKerYuR
	g4NNQEni2N4YkLCIgKzE1L/nWboYuTiYBVaySpw/+ZsZpEZYIFbi48QQkBoWAVWJL7MmsoDY
	vALGElsnTWKDGKkpsW7jLRaQck6g8dsWGIOEhYBK5j35wA5RLihxcuYTsFZmAXmJ5q2zmScw
	8sxCkpqFJLWAkWkVo0hmXlluYmaOqV5xdkZlXmaFXnJ+7iZGYIQuq/0zcQfjl8vuhxgFOBiV
	eHgzDm3LFGJNLCuuzD3EKMHBrCTCu+wIUIg3JbGyKrUoP76oNCe1+BCjNAeLkjivV3hqgpBA
	emJJanZqakFqEUyWiYNTqoGRZ3dI+3bxaV/7Mz4vfXsj/0LV26Jws7Damw86M8/Hi/opxKhL
	azRHLbx5JuVD0WORrwsObFZ3rc/p22fUJ3dOcOPPzi1rOW6dn7snUNqwqmsy15e8WNHrM5q0
	/m+f5rX/7tL83iyVf1xNXAH9fw9VSOw2n3dReOmOjRMWybjfuRy8U2YqR/MvJZbijERDLeai
	4kQAbKmZC8wCAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: b9wsj9wg63exsrgag43m184m17nmj593
X-Rspam-User: 
X-Rspamd-Queue-Id: D675C8000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773638001-727256
X-HE-Meta: U2FsdGVkX19TrPKHwWZPbUdkcKqyMm5xsdcCHxFG3sI+Gnv8S3vvnsqOxQ73D4A2hD+9HmcXwCl8rYPN+RbPivSVs2Gd4jpw9pdSNiOQx6VCy3YmSaJdYzSZEbH8bz5nMBIKV3FHS9260AcJrCQZwbt5aTYhGyirL4dw/CKqcarN5YJCFNJdvMxblUWYk6wXfWvUD9diWtQUNkVXm/m3UOY2Lq1eA0yIgXMb/Zm+FD2h1kAKCHwANgsYzyICYVh6/kzfwwDrzLJuq8RM8EU2nI+LMa0sJaiIhW4g+tx5nDgmp2fl17hXXLMmrgrHAqQSvK5jOsKBYGnL56LaAHVQcfB/w0Z6RazSdsmNp32oRqCYOsaueSA24sRWQe75J36FYD7Cc6o4WqKN+QdyxPt9X4UyTlZ5PAS98V0pCr2YSwCWb0wkjPmU3ejlk9YVvfc/waA4iDx7/qnxvOM48cU2qXLcTcCdZpGMjHHsqEtuv0PtJPCJto4DHsXDkYMWmbgBzpERa7ox0tzCKNc83pfiplCI50+WNuQtxc6e38giEsSzvj7rxBzE65Kx2WV9tT4HoPpmV8b7o/oMwFImt3tu1VpXiEHnopwm2RHwP7dpjfyQcqsqvxIFqu1h4+edzHvmlsktiSCgyl+lSTmLK3IJwNWSoz1oCVHUgNbnmx/ygjEO0tyonwuTn/pWyPtY/CIswLph3Lvs7QDs1IXmM3nX3osJiy0+2PLuOuqERHADubizGYvT7hn4x9zRt4bivtLceftFjQ9sMNhrObruo8PciaPhprOBPtWhKX45hFVUdOgCEAXLc/GG+TSau1AyK+VElZGYfnXo9DkD9iS7FhRgv1ZXb8ommSOsSrQTV7PHO0b6pOz/puXG76VU66+4iwWAEN5lkr2/03seTlK4N10+U27gg7l5QpJclTOx77VrDA1W9WW+eRHBKIzJNU6VlG7WgpqLboka/2nBVU8W61d
 zV3SJ7dC
 iVza40LHBCQFnN/xi58OMnEYWRarX+H4dhBZxCnKfLY1HjIgiYBZ0Gm2TyP7Kqm+Cc+kZIAhYpzjYmqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Flat weighted interleave applies one global weight vector regardless of
where a task runs. On multi-socket systems this ignores inter-socket
interconnect costs and can steer allocations to remote sockets even when
local capacity exists, degrading effective bandwidth and increasing
latency.

Consider a dual-socket system:

          node0             node1
        +-------+         +-------+
        | CPU0  |---------| CPU1  |
        +-------+         +-------+
        | DRAM0 |         | DRAM1 |
        +---+---+         +---+---+
            |                 |
        +---+---+         +---+---+
        | CXL0  |         | CXL1  |
        +-------+         +-------+
          node2             node3

Local device capabilities (GB/s) versus cross-socket effective bandwidth:

         0     1     2     3
     0  300   150   100    50
     1  150   300    50   100

A reasonable global weight vector reflecting device capabilities is:

     node0=3 node1=3 node2=1 node3=1

However, applying it flat to all sources yields the effective map:

         0     1     2     3
     0   3     3     1     1
     1   3     3     1     1

This does not account for the interconnect penalty (e.g., node0->node1
drops 300->150, node0->node3 drops 100->50) and thus permits cross-socket
allocations that underutilize local bandwidth.

This patch makes weighted interleave socket-aware. Before weighting is
applied, the candidate nodes are restricted to the current socket; only
if no eligible local nodes remain does the policy fall back to the wider
set. The resulting effective map becomes:

         0     1     2     3
     0   3     0     1     0
     1   0     3     0     1

Now tasks running on node0 prefer DRAM0(3) and CXL0(1), while tasks on
node1 prefer DRAM1(3) and CXL1(1). This aligns allocation with actual
effective bandwidth, preserves NUMA locality, and reduces cross-socket
traffic.

Signed-off-by: Rakie Kim <rakie.kim@sk.com>
---
 mm/mempolicy.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 90 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a3f0fde6c626..541853ac08bc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -117,6 +117,7 @@
 #include <asm/tlb.h>
 #include <linux/uaccess.h>
 #include <linux/memory.h>
+#include <linux/memory-tiers.h>
 
 #include "internal.h"
 
@@ -2134,17 +2135,87 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 	return zone >= dynamic_policy_zone;
 }
 
+/**
+ * policy_resolve_package_nodes - Restrict policy nodes to the current package
+ * @policy: Target mempolicy whose user-selected nodes are in @policy->nodes.
+ * @mask:   Output nodemask. On success, contains policy->nodes limited to
+ *          the package that should be used for the allocation.
+ *
+ * This helper combines two constraints to decide where within a socket/package
+ * memory may be allocated:
+ *
+ *   1) The caller's package: derived via mp_get_package_nodes(numa_node_id()).
+ *   2) The user's preselected set @policy->nodes (cpusets/mempolicy).
+ *
+ * The function obtains the nodemask of the current CPU's package and
+ * intersects it with @policy->nodes. If the intersection is empty (e.g. the
+ * user excluded every node of the current package), it falls back to the
+ * node in @policy->nodes, derives that node's package, and intersects
+ * again. If the fallback also yields an empty set, @mask stays empty and a
+ * non-zero error is returned.
+ *
+ * Examples (packages: P0={CPU:0, MEM:2}, P1={CPU:1, MEM:3}):
+ *   - policy->nodes = {0,1,2,3}
+ *       on P0: mask = {0,2}; on P1: mask = {1,3}.
+ *   - policy->nodes = {0,1,3}
+ *       on P0: mask = {0}      (only node 0 from P0 is allowed).
+ *   - policy->nodes = {1,2,3}
+ *       on P0: mask = {2}      (only node 2 from P0 is allowed).
+ *   - policy->nodes = {1,3}
+ *       on P0: current package (P0) & policy = NULL -> fallback to policy=1,
+ *               package(1)=P1, mask = {1,3}. (User effectively opted out of P0.)
+ *
+ * Return:
+ *   0 on success with @mask set as above;
+ *   -EINVAL if @policy/@mask is NULL;
+ *   Propagated error from mp_get_package_nodes() on failure.
+ */
+static int policy_resolve_package_nodes(struct mempolicy *policy, nodemask_t *mask)
+{
+	unsigned int node, ret = 0;
+	nodemask_t package_mask;
+
+	if (!policy || !mask)
+		return -EINVAL;
+
+	nodes_clear(*mask);
+
+	node = numa_node_id();
+	ret = mp_get_package_nodes(node, &package_mask);
+	if (!ret) {
+		nodes_and(*mask, package_mask, policy->nodes);
+
+		if (nodes_empty(*mask)) {
+			node = first_node(policy->nodes);
+			ret = mp_get_package_nodes(node, &package_mask);
+			if (ret)
+				goto out;
+			nodes_and(*mask, package_mask, policy->nodes);
+			if (nodes_empty(*mask))
+				goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
 static unsigned int weighted_interleave_nodes(struct mempolicy *policy)
 {
 	unsigned int node;
 	unsigned int cpuset_mems_cookie;
+	nodemask_t mask;
 
 retry:
 	/* to prevent miscount use tsk->mems_allowed_seq to detect rebind */
 	cpuset_mems_cookie = read_mems_allowed_begin();
 	node = current->il_prev;
-	if (!current->il_weight || !node_isset(node, policy->nodes)) {
-		node = next_node_in(node, policy->nodes);
+
+	if (policy_resolve_package_nodes(policy, &mask))
+		mask = policy->nodes;
+
+	if (!current->il_weight || !node_isset(node, mask)) {
+		node = next_node_in(node, mask);
 		if (read_mems_allowed_retry(cpuset_mems_cookie))
 			goto retry;
 		if (node == MAX_NUMNODES)
@@ -2237,6 +2308,21 @@ static unsigned int read_once_policy_nodemask(struct mempolicy *pol,
 	return nodes_weight(*mask);
 }
 
+static unsigned int read_once_policy_package_nodemask(struct mempolicy *pol,
+						      nodemask_t *mask)
+{
+	nodemask_t package_mask;
+
+	barrier();
+	if (policy_resolve_package_nodes(pol, &package_mask))
+		memcpy(mask, &pol->nodes, sizeof(nodemask_t));
+	else
+		memcpy(mask, &package_mask, sizeof(nodemask_t));
+	barrier();
+
+	return nodes_weight(*mask);
+}
+
 static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 {
 	struct weighted_interleave_state *state;
@@ -2247,7 +2333,7 @@ static unsigned int weighted_interleave_nid(struct mempolicy *pol, pgoff_t ilx)
 	u8 weight;
 	int nid = 0;
 
-	nr_nodes = read_once_policy_nodemask(pol, &nodemask);
+	nr_nodes = read_once_policy_package_nodemask(pol, &nodemask);
 	if (!nr_nodes)
 		return numa_node_id();
 
@@ -2691,7 +2777,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	/* read the nodes onto the stack, retry if done during rebind */
 	do {
 		cpuset_mems_cookie = read_mems_allowed_begin();
-		nnodes = read_once_policy_nodemask(pol, &nodes);
+		nnodes = read_once_policy_package_nodemask(pol, &nodes);
 	} while (read_mems_allowed_retry(cpuset_mems_cookie));
 
 	/* if the nodemask has become invalid, we cannot do anything */
-- 
2.34.1


