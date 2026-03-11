Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23BA2FD0655
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9456B008C; Wed, 11 Mar 2026 04:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2876C6B0093; Wed, 11 Mar 2026 04:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148346B0095; Wed, 11 Mar 2026 04:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0E206B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:26:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82E7E1391AA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:29 +0000 (UTC)
X-FDA: 84533100498.24.EF64BAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D234118000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lgQxR7KS;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmJR7s7xfjeRKGfTobPjXNXIjeLJR1uJal+z/lna88M=;
	b=K/H0RnmQvGbl8ltJ+XTEXDruMktf7OPITEgVdp3kJX1SfS6hkjGMo55Xza9vjMkzP6gym3
	/rZluft8ndgtFM6u53VB4m/d5mWGr2EVJqupFFm827jeJdtlh/dkmhdcfO4Hm5DRKZaBKG
	+OQjk+gyFvnBY2mKolwHSUxa82aOoqE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217587; a=rsa-sha256;
	cv=none;
	b=tycTKcQ/wkgxW7eo+z3jScitUVgd2uBP6rEurednXMitbBmLmasqMYDaVzoY9vQuUYFlce
	6UE4kOpFNaTcxcya3eJIgpYkBNKLZ+Nkyrbqx5gtcmgsYZtHkVSU5f5hyBopHqOWkR3GMI
	niEpaSuQvo9jNgsyFhUcMnvNFLQlPmw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lgQxR7KS;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 53D536132D;
	Wed, 11 Mar 2026 08:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE0C4CEF7;
	Wed, 11 Mar 2026 08:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217587;
	bh=7ftedvnDDKq5y6BWhunjYlsl4QAcgEbP/dn6zuiDQ7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lgQxR7KSv9pD12Ev8UnEWaIpcxbh0lmHLmhmzXslAhcisUhvcwew4kpyAN9sZpF+G
	 w+EaPQCNsrNUHqEcWnmvRrVSYz4vj7R1sK8DKGX1Z32pQ/U9Tih/PJDlwBcL5c1pnd
	 ETw03Brp5jcAk4Vu1imfoOU2n9WywlhXwKSyhzzenOmePitloRtTU/jzqQu8IxUqGu
	 /G5bkYgH7FpL8NOnE1g3JDwEz+DUVLau0l6zSGUuUnThuz7gn6/pkwgFSeYTuP/QDZ
	 Qg7/5N+c3bWh8OlFYJO9aG12U8FqHMDsMKcLPwdKDWKlWhGTEArtL4DnMKLYvMCtno
	 COhzKEFfs04Ow==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 11 Mar 2026 09:25:56 +0100
Subject: [PATCH 2/3] slab: create barns for online memoryless nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-b4-slab-memoryless-barns-v1-2-70ab850be4ce@kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
To: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Stat-Signature: st196uybtdq1ha7831tu5tsgfi73pgpy
X-Rspamd-Queue-Id: D234118000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1773217587-518856
X-HE-Meta: U2FsdGVkX1+vt5dFlntAWToQlkAMwCnCKEUiA5KY6vx5TQaPIm6KF0nXHoyo206iveIGYtPSq7juHLexC3YLu+4Ql6avbmg5z+i/XO6kVybxuR/gavAG1852oJyMXOawH6UkMklb+g1UdscbEoRoK+L5q7uPFK7wpaju9AWmprrjpw8oHU0FZ+BQfftAFmD6OUtlJIFFVHG1p/MjsfEQZcRpr2+26qVxehJKEy2Msmtq236eKi03Pf2qGpoCT6PkQu5veLmbMxWTB2imxJgLc/B3Pjo3vVrG16uAh2OXSJGz1wybiz+PbcOyrRQMkaDyRpCp6m5UY20HsPtg5IeSyqgTReUjMk4M5zj049Q/xOpKhISZKGQthggiA3MXQY26uETBsTd4Q6BfJfYUAKRDCRcyYNNd3PPOn4YPnjPKqDyf4OlHTFO06Y6tCFiFKao1HnFhNayWJKcv/K61E+ZFHbgeOSri43Rasg7zXw8Yjd6woFTbm5wI1pkOAQOMzRsjycXwlZagzsOsUgCuz/9O4cvnYWlJwtLeZ9wCbGQkXrWoOSVGrBJaPNPdRWHwcOzBWvUjCqsOjeYKe3rq6jxm17QPBnk8lIB84vAfnicx9SlJ/ESUB6IqjPddZSb9sksseppypvjqm5BhuwNYqmxPu5KBKVydfBVUeyrwyZdyAVSieUmKoq7budBOe854LH3FWwL7IFHx4Lf6C0OZBLXA2xPz7F+cGNPlYXO4l0I7mNgDElSmYonVJ15ZqkrjLenWckPikuVvF9e5MUxaxGieU1pudOkqfM2GPYrORR5eHuyW9UjOoOajh7TELN0JGBpkKJavxP+4pQ7hL6oTf+59dpbrEx2xhm4L1BVDmVIW6EVvVq7LUuH+fCXcipixcsXs5DlnUnVyPz9+lAxWP4fYBaDZGdqDDxE+PqaCh4Y8TrDkrf+sgrIfpFp4MhFzgdggIzGpHSEz0c2uuiaxJzH
 eshZVvxT
 Pz0Fv8Epx+14YNZVrqf689ytPwBeVHFMLYlTZGy8qHpH2UgD8erxCfLuRIYRC9ZRUHKqfBomKXL77lhWfj7zr4r6PM6ZL5VliExJZDgV3OQAjK0YmF6O9VniuMsFRBDmQl2sCy0OW3bb9jXi1+DiGI+n4zCYDVNen+mxbt36calsHveuNzoEJN5Bx7zLfsCzKBdhPbvuIYHHs5wbJdsoLlfWSJTFll6BAl1CCIJWnLfw9V3J+tErZYUfv0rL0pX0E1VhjaQTYrz1TQbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ming Lei has reported [1] a performance regression due to replacing cpu
(partial) slabs with sheaves. With slub stats enabled, a large amount of
slowpath allocations were observed. The affected system has 8 online
NUMA nodes but only 2 have memory.

For sheaves to work effectively on given cpu, its NUMA node has to have
struct node_barn allocated. Those are currently only allocated on nodes
with memory (N_MEMORY) where kmem_cache_node also exist as the goal is
to cache only node-local objects. But in order to have good performance
on a memoryless node, we need its barn to exist and use sheaves to cache
non-local objects (as no local objects can exist anyway).

Therefore change the implementation to allocate barns on all online
nodes, tracked in a new nodemask slab_barn_nodes. Also add a cpu hotplug
callback as that's when a memoryless node can become online.

Change rcu_sheaf->node assignment to numa_node_id() so it's returned to
the barn of the local cpu's (potentially memoryless) node, and not to
the nearest node with memory anymore.

Reported-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/all/aZ0SbIqaIkwoW2mB@fedora/ [1]
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 59 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 609a183f8533..d8496b37e364 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -472,6 +472,12 @@ static inline struct node_barn *get_barn(struct kmem_cache *s)
  */
 static nodemask_t slab_nodes;
 
+/*
+ * Similar to slab_nodes but for where we have node_barn allocated.
+ * Corresponds to N_ONLINE nodes.
+ */
+static nodemask_t slab_barn_nodes;
+
 /*
  * Workqueue used for flushing cpu and kfree_rcu sheaves.
  */
@@ -4084,6 +4090,51 @@ void flush_all_rcu_sheaves(void)
 	rcu_barrier();
 }
 
+static int slub_cpu_setup(unsigned int cpu)
+{
+	int nid = cpu_to_node(cpu);
+	struct kmem_cache *s;
+	int ret = 0;
+
+	/*
+	 * we never clear a nid so it's safe to do a quick check before taking
+	 * the mutex, and then recheck to handle parallel cpu hotplug safely
+	 */
+	if (node_isset(nid, slab_barn_nodes))
+		return 0;
+
+	mutex_lock(&slab_mutex);
+
+	if (node_isset(nid, slab_barn_nodes))
+		goto out;
+
+	list_for_each_entry(s, &slab_caches, list) {
+		struct node_barn *barn;
+
+		/*
+		 * barn might already exist if a previous callback failed midway
+		 */
+		if (!cache_has_sheaves(s) || get_barn_node(s, nid))
+			continue;
+
+		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
+
+		if (!barn) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		barn_init(barn);
+		s->per_node[nid].barn = barn;
+	}
+	node_set(nid, slab_barn_nodes);
+
+out:
+	mutex_unlock(&slab_mutex);
+
+	return ret;
+}
+
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -5936,7 +5987,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		rcu_sheaf = NULL;
 	} else {
 		pcs->rcu_free = NULL;
-		rcu_sheaf->node = numa_mem_id();
+		rcu_sheaf->node = numa_node_id();
 	}
 
 	/*
@@ -7597,7 +7648,7 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 	if (slab_state == DOWN || !cache_has_sheaves(s))
 		return 1;
 
-	for_each_node_mask(node, slab_nodes) {
+	for_each_node_mask(node, slab_barn_nodes) {
 		struct node_barn *barn;
 
 		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
@@ -8250,6 +8301,7 @@ static int slab_mem_going_online_callback(int nid)
 	 * and barn initialized for the new node.
 	 */
 	node_set(nid, slab_nodes);
+	node_set(nid, slab_barn_nodes);
 out:
 	mutex_unlock(&slab_mutex);
 	return ret;
@@ -8328,7 +8380,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 	if (!capacity)
 		return;
 
-	for_each_node_mask(node, slab_nodes) {
+	for_each_node_mask(node, slab_barn_nodes) {
 		struct node_barn *barn;
 
 		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
@@ -8400,6 +8452,9 @@ void __init kmem_cache_init(void)
 	for_each_node_state(node, N_MEMORY)
 		node_set(node, slab_nodes);
 
+	for_each_online_node(node)
+		node_set(node, slab_barn_nodes);
+
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 			sizeof(struct kmem_cache_node),
 			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
@@ -8426,7 +8481,7 @@ void __init kmem_cache_init(void)
 	/* Setup random freelists for each cache */
 	init_freelist_randomization();
 
-	cpuhp_setup_state_nocalls(CPUHP_SLUB_DEAD, "slub:dead", NULL,
+	cpuhp_setup_state_nocalls(CPUHP_SLUB_DEAD, "slub:dead", slub_cpu_setup,
 				  slub_cpu_dead);
 
 	pr_info("SLUB: HWalign=%d, Order=%u-%u, MinObjects=%u, CPUs=%u, Nodes=%u\n",

-- 
2.53.0


