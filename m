Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C91CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0246B0093; Mon, 15 Jun 2026 07:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F976B0095; Mon, 15 Jun 2026 07:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028566B0096; Mon, 15 Jun 2026 07:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E71746B0093
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:06:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B11ECA09AD
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:44 +0000 (UTC)
X-FDA: 84881869128.10.333F2BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E2F5580006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA5n6D/x";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vzykupjp/TkJaeuRT9RFHhzq2GhtOl8P56UdE38uzvc=;
	b=YrnJKaHb2TtodwMVTYKNnoMF2R4v9LpX0te/hkdyC485HaFFaDiwyq7YW+pnwfCnZ8QQGc
	Cfbql3bW7FKRAQ9/+GpfLh2w2z4PctauHMO6CG5FGPxHRWgC3NS4khS9PG7AkTxrLdgHu7
	Ec4aLXMEXv5q0ax5Bh9Jq3KPfysW66E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fA5n6D/x";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521603;
	b=HTGQV5ogq0eLsVIul/vjx68hYHR49OhWqe2S7WkspJD02EAPKZCwt6B6D9zbt7tKsVean/
	CAc8XopzCh7VJjqqQ07DLKR3xdA43esFFL3Af6CN7g/TgFbpUwpL0qQ5odcJXZmT5vrLGn
	7JXQXC39acv17mK+Pgoq6E2AVGzxuOI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A4BE40AAB;
	Mon, 15 Jun 2026 11:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB981F00A3A;
	Mon, 15 Jun 2026 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521602;
	bh=Vzykupjp/TkJaeuRT9RFHhzq2GhtOl8P56UdE38uzvc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fA5n6D/xdRqIkCyjgQaHLpiuy55LLpw8Odk7kPt1q7qPquO/6APsKZOt1vvPNap0j
	 IZrQF3FhdsABk/LsXj5TaOt92N5RnEeLlwU/v3u7ifBuh6SLcN3MEJIiuVXPtJWbI7
	 QuieDpVN3lPUIxLSHa/7ssTc6B9o5rOWFUwHHLEV9Drd7blcGJlqSqm9jEOHQ3ETwR
	 We9Fbznr645B8rYGcMIhbk+4sor4xFhcou4Yc9lSBn9zv3MG6bxRwrO7L0wtgHiB29
	 D3GqQeqysFCCSBnfr6rpcQNUrP/SqvFxNZT3HWu4nI7S9kckD95hZf0EK91LYObBQM
	 4YHMNb93LFKKg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:05:57 +0900
Subject: [PATCH for-next v3 3/9] mm/slab: handle the !allow_spin case in
 kfree_rcu_sheaf()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-3-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2F5580006
X-Stat-Signature: 6yc686sym96ek7hbe9a8w4cf88tecbms
X-Rspam-User: 
X-HE-Tag: 1781521602-366164
X-HE-Meta: U2FsdGVkX1+M91boXmL3tjy9lvFf5v+8M2FQIsO1jY1fvt4Obg935o9IKEssCwoj4cLi4EKSdcQ2VdQt19e1auwbAsoeV1x7pameKfdo6PHXfnSDSNbjyyatEyYRtc06x+NmuPCnZpRWshywIavQY2IcapYqswos+LkpwhtWD3+8shvo2kMN60AY4nOO1ZdU+0UX6D8NvU+mjvm2brytVzi7yeM/BGnahfa/SvzGjVuQWHaaxGGsEvRArFcMhr2B8Nx4MYy3UG7Q6x/Fsi+v83XFhc7JOsX1yBkggqEPfGYM6RTTB5wXZv5XehXEPsQwhiuVFS+trqjixMphgMR1wzI3fz1RmP/XP8CaFRAV8iYcXWFB9MkywXZlmQNtEuOugILmv4e43bRUkVoE4HiwHrBtMmec3ZKKCB7hSdtK6brBALHAPD/AP4QElQNMQLmyJ/xxoCB1TItt+uLYLzwdM/MFKjms7dWTRssQ+D+krIe2U68lpZr385yJbfg0R0aGVI4ymV1hx27e84GezdQ8KfxjUP56dbrPNYeLWvXLtEcQ51FRi7lRcHNMRb5Q+LWn/D4Yiz9S+5oRIDcK14gURL15sYSv6V2Qlx/xLWWaxL32lE91vc0ENtS8se8uGaS6NgvhknGK5emAW+DYmyn6pdwMC91YVTk4g9aVWlFvv1IxB0GnEYESOqgwD8IjHQyFuTYnbEkRvYE4+FRfLX/hvqK1Ckj3SGowBe7zuazKOLTdFHFEDAM0ptuB+bikFiiJmmgh+jIRhtdFm8RsjPZBKtnmr29a52eTjXHE5KvOOKCFKbPbofKVTKVIsnuVjdxXh2hVvkpRHbv4rE45blEyTCQylV4RoL+hEMVhlvpK82fmosl0vcyi2Uaij0o6blzHTSYPhHfIzAiQnq5/WeNtiFECoepRG/gzAekJMVqzsfHSLELaFgyTpSpbgJl+wKVzbuuh7isTFgMeEnEvYmU
 3v0Dlv2g
 /vi5FVS5Ut/sMPvj9twaGnIT5J1FmRcEXGjPb7UCgh18SF7pIerH3lj1Sq+sT1jTc6Mv6hNPod1TkGdAa7LHxjozrB5NTx0gLgoNiXB3LCQYhmKAs4mRJam2dOabwIaOf2K/gOJdz2mBPubb1qshTEbb5kNHiiiCp7f2aJht6W3+jQ9cy6mMQXJ+FL95uOExpRkPrDy9MjXaGOBaRe4vIlMptLk0Lc9eTbeNBEGB4V2+qF+FW6p4NKUPWc8Elm6L90wyYmmPwp8zPyLRQwMNljzbfe4dLV9LVZfiZPj/GqqiEtH2AmIdMqIVsTv8O+i9vP8U/GVsE4PCj+rRjprycGFyOcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Teach kfree_rcu_sheaf() how to handle the !allow_spin case. Try to get
an empty sheaf from pcs->spare or the barn even when spinning is not
allowed. Unlike __pcs_replace_full_main(), try harder to allocate
an empty sheaf because the fallback path will be more expensive than
kfree_nolock().

When trylock fails or the kernel observes non-NULL pcs->rcu_free after
lock acquisition, free the sheaf instead of putting it to the barn.
This is rare and not worth complicating the code.

Since call_rcu() cannot be called in an unknown context,
kfree_rcu_sheaf() fails when the rcu sheaf becomes full.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        |  2 +-
 mm/slab_common.c |  2 +-
 mm/slub.c        | 39 ++++++++++++++++++++++++++++++---------
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 509f330654b8..b1bd33a16544 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -429,7 +429,7 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b6426d7ceec9..bc1a8ec938d9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1605,7 +1605,7 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	s = slab->slab_cache;
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
-		return __kfree_rcu_sheaf(s, obj);
+		return __kfree_rcu_sheaf(s, obj, /* allow_spin = */ true);
 
 	return false;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 87ca154ccd80..b0d38d515386 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2815,7 +2815,8 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 	return __alloc_empty_sheaf(s, gfp, alloc_flags, s->sheaf_capacity);
 }
 
-static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+static void __free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
+			       bool allow_spin)
 {
 	/*
 	 * If the sheaf was created with SLAB_ALLOC_NO_RECURSE flag then its
@@ -2827,11 +2828,20 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 		mark_obj_codetag_empty(sheaf);
 
 	VM_WARN_ON_ONCE(sheaf->size > 0);
-	kfree(sheaf);
+
+	if (likely(allow_spin))
+		kfree(sheaf);
+	else
+		kfree_nolock(sheaf);
 
 	stat(s, SHEAF_FREE);
 }
 
+static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
+{
+	__free_empty_sheaf(s, sheaf, /* allow_spin = */ true);
+}
+
 static unsigned int
 refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	       unsigned int max);
@@ -3132,7 +3142,6 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
  * intended action due to a race or cpu migration. Thus they do not check the
  * empty or full sheaf limits for simplicity.
  */
-
 static void barn_put_empty_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf)
 {
 	unsigned long flags;
@@ -6065,7 +6074,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
  */
 static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
 
-bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *rcu_sheaf;
@@ -6081,9 +6090,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
 	if (unlikely(!pcs->rcu_free)) {
-
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
+		unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
+		gfp_t gfp = GFP_NOWAIT;
 
 		/* Bootstrap or debug cache, fall back */
 		if (unlikely(!cache_has_sheaves(s))) {
@@ -6103,7 +6113,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn, true);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6112,20 +6122,25 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 		local_unlock(&s->cpu_sheaves->lock);
 
-		empty = alloc_empty_sheaf(s, GFP_NOWAIT, SLAB_ALLOC_DEFAULT);
+		if (unlikely(!allow_spin)) {
+			alloc_flags = SLAB_ALLOC_TRYLOCK;
+			gfp = 0;
+		}
+
+		empty = alloc_empty_sheaf(s, gfp, alloc_flags);
 
 		if (!empty)
 			goto fail;
 
 		if (!local_trylock(&s->cpu_sheaves->lock)) {
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, allow_spin);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
 		if (unlikely(pcs->rcu_free))
-			barn_put_empty_sheaf(barn, empty);
+			__free_empty_sheaf(s, empty, allow_spin);
 		else
 			pcs->rcu_free = empty;
 	}
@@ -6143,6 +6158,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
+		if (unlikely(!allow_spin)) {
+			/* call_rcu() cannot be called in an unknown context */
+			rcu_sheaf->size--;
+			local_unlock(&s->cpu_sheaves->lock);
+			goto fail;
+		}
 		pcs->rcu_free = NULL;
 		rcu_sheaf->node = numa_node_id();
 	}

-- 
2.53.0


