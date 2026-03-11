Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250E4FD0659
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:26:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D596B008A; Wed, 11 Mar 2026 04:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517CA6B008C; Wed, 11 Mar 2026 04:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB846B0093; Wed, 11 Mar 2026 04:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A55D6B008A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:26:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EAA81CAB1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:27 +0000 (UTC)
X-FDA: 84533100414.10.8413810
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA8D618000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKUnPNoF;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0N696cwg8iFrwsQcdU7mGYiPRn5mA7/wJ3sc8Fo1ZZI=;
	b=cOedws+S+Z/DmifmS3VIJFEH5CKE+B+RpdlyaoYomamkv9sEMn4xDxzb10vbSQpajWF9L0
	hQ9mXilr+750skmbulDY3jw99dJao23I7KgrzdDL5vrzqPrWlDt+Tl/dcalYxilOm63xRL
	n5l2/OhViYlt/BBghSANP12uFCN8tKI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vKUnPNoF;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217585; a=rsa-sha256;
	cv=none;
	b=r29qz6OanXTIo01Azu9Fa4naU0ariInIrNt8xe3UT8aNCVuBhuWDyMpI41ibHwL3TiiYxm
	8CbSC9/4wAJoNTZc4fqX6dBZRkQAPOmk784p22JTxlK0ab2D/R5q4WhBIpfgGUN4wUrm7K
	yjxEKJC72EZDeqxjCe5ftLLGezUnZ7k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AFF3A44314;
	Wed, 11 Mar 2026 08:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F73DC2BC9E;
	Wed, 11 Mar 2026 08:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217584;
	bh=J6j7UsI+cNPPl/AmQOY+S8xOMkbllA7iRFJ8y3xLuF8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vKUnPNoFC8EPzF3wz00RcDYXtZzZprk9CE0wuKaf9wTG9GwD0V0HDSBMxA93asiCT
	 pVo8hdXNt8ncLsW3azyEEIAU8XS8HWJxiAaLFH+QrKa4nc+kdELSjyZ95E3VPjBPLG
	 o1SrCbc5KTESoC3d9eVReitG6emHwhhP5sgoGbsCyd8pqQ+5M5tqBB3RFjG5bOJAte
	 Qm1ntGa9wEv0CEgoy6e/FATIh0g3HeNF6D6ySTEhDrrrcqjxgpYqy/EwGfI1B0Hy/v
	 vJ+0QPzJZ4uivz0+rpvh8rrsHnewZmHWjcuJtHVZjNq122TqSQzAWHtfqMckchQttb
	 Ii4ceXDNYpa0g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 11 Mar 2026 09:25:55 +0100
Subject: [PATCH 1/3] slab: decouple pointer to barn from kmem_cache_node
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
To: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: BA8D618000D
X-Stat-Signature: wjdqdiiu9qthmrfp4iiadd5yoeyqpeps
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773217585-31315
X-HE-Meta: U2FsdGVkX1+wxi1tNwLXbIIawhYQlBM/WOx0gH7VbwDFwikij0YZXmVBlmBnLSW1Fy5YUkbLMS3afB8kJtH8OLKF94ulpOGS5KUNG3LMEbm3Zeai9HWQC5s1BsMuD6vFcda26WGdmMRksCbuBTJNdlwVjf9Fdd4XwdOkrTZ2orMm2esW/psdQ1zQ32EzRmprlcKhbhc17MCQwuFnnHe8sicBQ2TeV9aX/mhs+sgtuVpPrjNTKzx1M64dbu/DXjXeXiLUgDlHf+3B/rFmPd+WikeymkDFK/1NvKk0DUp1OjrnywLfOtr611zIqjuTVFWGTllpXzTQypYafAfeK/7jY7SDRSmtp+cweNPNmbNzxMVTJY4jzIRy3VzhOIRpDW2FX0NHCF02xiE7M5sLRGTt7Wu6VrnAk0DB7S3fVtGf1VTG74IlDrDRPxTBNbeksksn+16QVBwUNhQePJ7/rbFaqavgnCb93fsyoy3aNNbTG9dYYDmBMkH2uXQnGS5Yh64Wz4IO2itLW3lGKCWwpj0ik8d1EyiC2MZ0vKVVieenrUyKiMZotQZbNpnEfFILADumv9EyLdwQ0Bk9RGVrtudCYlCdyXIPqZhioz1T21cTd2PqalFShPUIuyg9M6Q7y3oZqR+T+HEGZ4XvIQTrhJW1H4TS8AreUIaOqiRqKuQakIW1vf3aX+rBqffIw10Ux1QixkV+s9wLBWnhso914TNqXIgtZbr16LcRZkEKilo29wYcqZsQS4BSAPcVvbFqNEqh181Y1FxP93zbOAjtdM2Jy6dHeSypV+IwYhdUI4t2VUWpNCGgkIeQrg1mcbKufkniD6cijd7hIqQKHZImLyQZ7HcUMxiT7Z3CWdO8URhwOxxqnn7b3VlmVauBDLzJFjzP/cMhfRpPR/j3GWYws/CZQoFBcX5mjEF+KuxmWHSSyFtUzyjmEiut5l4UMnvSoDsoEviknY2/5anMOJWUt1D
 QwihhLiw
 OaCFl1DTiJq83I+lA8qwWMlnCRj4uz7oGTsUq+BAPojiCgEM9pnw3+np7tLJIAc+ye9srxgch/zm2ISQkLuDNQfbpHOmXmP9/L/nK9qNX27I4qO+2pPX/LFGaHtsQi2oiFbd1N6kprbLt2qEHVJ01zcM37HkdoYwyVBtit5sUBoHTjOEkMCIITHb0QOTEbdRvWD9lfU+WcVwVJdTe07LDPL8HE9pUGOo8DZxFb/q7WWpR8/V4tf+UTyNvtzHtc4apovfVv9qJmNIOE16gI1/5ykAPRGDo1gcL8bBu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pointer to barn currently exists in struct kmem_cache_node. That
struct is instantiated for every NUMA node with memory, but we want to
have a barn for every online node (including memoryless).

Thus decouple the two structures. In struct kmem_cache we have an array
for kmem_cache_node pointers that appears to be sized MAX_NUMNODES but
the actual size calculation in kmem_cache_init() uses nr_node_ids.
Therefore we can't just add another array of barn pointers. Instead
change the array to newly introduced struct kmem_cache_per_node_ptrs
holding both kmem_cache_node and barn pointer.

Adjust barn accessor and allocation/initialization code accordingly. For
now no functional change intended, barns are created 1:1 together with
kmem_cache_nodes.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h |   7 +++-
 mm/slub.c | 128 +++++++++++++++++++++++++++++++++++---------------------------
 2 files changed, 78 insertions(+), 57 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e9ab292acd22..c735e6b4dddb 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -191,6 +191,11 @@ struct kmem_cache_order_objects {
 	unsigned int x;
 };
 
+struct kmem_cache_per_node_ptrs {
+	struct node_barn *barn;
+	struct kmem_cache_node *node;
+};
+
 /*
  * Slab cache management.
  */
@@ -247,7 +252,7 @@ struct kmem_cache {
 	struct kmem_cache_stats __percpu *cpu_stats;
 #endif
 
-	struct kmem_cache_node *node[MAX_NUMNODES];
+	struct kmem_cache_per_node_ptrs per_node[MAX_NUMNODES];
 };
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index 20cb4f3b636d..609a183f8533 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -59,7 +59,7 @@
  *   0.  cpu_hotplug_lock
  *   1.  slab_mutex (Global Mutex)
  *   2a. kmem_cache->cpu_sheaves->lock (Local trylock)
- *   2b. node->barn->lock (Spinlock)
+ *   2b. barn->lock (Spinlock)
  *   2c. node->list_lock (Spinlock)
  *   3.  slab_lock(slab) (Only on some arches)
  *   4.  object_map_lock (Only for debugging)
@@ -136,7 +136,7 @@
  *   or spare sheaf can handle the allocation or free, there is no other
  *   overhead.
  *
- *   node->barn->lock (spinlock)
+ *   barn->lock (spinlock)
  *
  *   This lock protects the operations on per-NUMA-node barn. It can quickly
  *   serve an empty or full sheaf if available, and avoid more expensive refill
@@ -436,26 +436,24 @@ struct kmem_cache_node {
 	atomic_long_t total_objects;
 	struct list_head full;
 #endif
-	struct node_barn *barn;
 };
 
 static inline struct kmem_cache_node *get_node(struct kmem_cache *s, int node)
 {
-	return s->node[node];
+	return s->per_node[node].node;
+}
+
+static inline struct node_barn *get_barn_node(struct kmem_cache *s, int node)
+{
+	return s->per_node[node].barn;
 }
 
 /*
- * Get the barn of the current cpu's closest memory node. It may not exist on
- * systems with memoryless nodes but without CONFIG_HAVE_MEMORYLESS_NODES
+ * Get the barn of the current cpu's memory node. It may be a memoryless node.
  */
 static inline struct node_barn *get_barn(struct kmem_cache *s)
 {
-	struct kmem_cache_node *n = get_node(s, numa_mem_id());
-
-	if (!n)
-		return NULL;
-
-	return n->barn;
+	return get_barn_node(s, numa_node_id());
 }
 
 /*
@@ -5791,7 +5789,6 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 
 static void rcu_free_sheaf(struct rcu_head *head)
 {
-	struct kmem_cache_node *n;
 	struct slab_sheaf *sheaf;
 	struct node_barn *barn = NULL;
 	struct kmem_cache *s;
@@ -5814,12 +5811,10 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	if (__rcu_free_sheaf_prepare(s, sheaf))
 		goto flush;
 
-	n = get_node(s, sheaf->node);
-	if (!n)
+	barn = get_barn_node(s, sheaf->node);
+	if (!barn)
 		goto flush;
 
-	barn = n->barn;
-
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
 		goto empty;
@@ -7430,7 +7425,7 @@ static inline int calculate_order(unsigned int size)
 }
 
 static void
-init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
+init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
 	spin_lock_init(&n->list_lock);
@@ -7440,9 +7435,6 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
 	atomic_long_set(&n->total_objects, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
-	n->barn = barn;
-	if (barn)
-		barn_init(barn);
 }
 
 #ifdef CONFIG_SLUB_STATS
@@ -7537,8 +7529,8 @@ static void early_kmem_cache_node_alloc(int node)
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
 	slab->freelist = get_freepointer(kmem_cache_node, n);
 	slab->inuse = 1;
-	kmem_cache_node->node[node] = n;
-	init_kmem_cache_node(n, NULL);
+	kmem_cache_node->per_node[node].node = n;
+	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);
 
 	/*
@@ -7553,15 +7545,20 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
 	int node;
 	struct kmem_cache_node *n;
 
-	for_each_kmem_cache_node(s, node, n) {
-		if (n->barn) {
-			WARN_ON(n->barn->nr_full);
-			WARN_ON(n->barn->nr_empty);
-			kfree(n->barn);
-			n->barn = NULL;
-		}
+	for_each_node(node) {
+		struct node_barn *barn = get_barn_node(s, node);
 
-		s->node[node] = NULL;
+		if (!barn)
+			continue;
+
+		WARN_ON(barn->nr_full);
+		WARN_ON(barn->nr_empty);
+		kfree(barn);
+		s->per_node[node].barn = NULL;
+	}
+
+	for_each_kmem_cache_node(s, node, n) {
+		s->per_node[node].node = NULL;
 		kmem_cache_free(kmem_cache_node, n);
 	}
 }
@@ -7582,31 +7579,36 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 
 	for_each_node_mask(node, slab_nodes) {
 		struct kmem_cache_node *n;
-		struct node_barn *barn = NULL;
 
 		if (slab_state == DOWN) {
 			early_kmem_cache_node_alloc(node);
 			continue;
 		}
 
-		if (cache_has_sheaves(s)) {
-			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
-
-			if (!barn)
-				return 0;
-		}
-
 		n = kmem_cache_alloc_node(kmem_cache_node,
 						GFP_KERNEL, node);
-		if (!n) {
-			kfree(barn);
+		if (!n)
 			return 0;
-		}
 
-		init_kmem_cache_node(n, barn);
+		init_kmem_cache_node(n);
+		s->per_node[node].node = n;
+	}
+
+	if (slab_state == DOWN || !cache_has_sheaves(s))
+		return 1;
+
+	for_each_node_mask(node, slab_nodes) {
+		struct node_barn *barn;
+
+		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
+
+		if (!barn)
+			return 0;
 
-		s->node[node] = n;
+		barn_init(barn);
+		s->per_node[node].barn = barn;
 	}
+
 	return 1;
 }
 
@@ -7895,10 +7897,15 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	if (cache_has_sheaves(s))
 		rcu_barrier();
 
+	for_each_node(node) {
+		struct node_barn *barn = get_barn_node(s, node);
+
+		if (barn)
+			barn_shrink(s, barn);
+	}
+
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
-		if (n->barn)
-			barn_shrink(s, n->barn);
 		free_partial(s, n);
 		if (n->nr_partial || node_nr_slabs(n))
 			return 1;
@@ -8108,14 +8115,18 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 	unsigned long flags;
 	int ret = 0;
 
+	for_each_node(node) {
+		struct node_barn *barn = get_barn_node(s, node);
+
+		if (barn)
+			barn_shrink(s, barn);
+	}
+
 	for_each_kmem_cache_node(s, node, n) {
 		INIT_LIST_HEAD(&discard);
 		for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
 			INIT_LIST_HEAD(promote + i);
 
-		if (n->barn)
-			barn_shrink(s, n->barn);
-
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		/*
@@ -8204,7 +8215,8 @@ static int slab_mem_going_online_callback(int nid)
 		if (get_node(s, nid))
 			continue;
 
-		if (cache_has_sheaves(s)) {
+		if (cache_has_sheaves(s) && !get_barn_node(s, nid)) {
+
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
 
 			if (!barn) {
@@ -8225,13 +8237,17 @@ static int slab_mem_going_online_callback(int nid)
 			goto out;
 		}
 
-		init_kmem_cache_node(n, barn);
+		init_kmem_cache_node(n);
+		s->per_node[nid].node = n;
 
-		s->node[nid] = n;
+		if (barn) {
+			barn_init(barn);
+			s->per_node[nid].barn = barn;
+		}
 	}
 	/*
 	 * Any cache created after this point will also have kmem_cache_node
-	 * initialized for the new node.
+	 * and barn initialized for the new node.
 	 */
 	node_set(nid, slab_nodes);
 out:
@@ -8323,7 +8339,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 		}
 
 		barn_init(barn);
-		get_node(s, node)->barn = barn;
+		s->per_node[node].barn = barn;
 	}
 
 	for_each_possible_cpu(cpu) {
@@ -8394,8 +8410,8 @@ void __init kmem_cache_init(void)
 	slab_state = PARTIAL;
 
 	create_boot_cache(kmem_cache, "kmem_cache",
-			offsetof(struct kmem_cache, node) +
-				nr_node_ids * sizeof(struct kmem_cache_node *),
+			offsetof(struct kmem_cache, per_node) +
+				nr_node_ids * sizeof(struct kmem_cache_per_node_ptrs),
 			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
 
 	kmem_cache = bootstrap(&boot_kmem_cache);

-- 
2.53.0


