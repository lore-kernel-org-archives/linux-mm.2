Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E52CF8A145
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FBB6B0096; Thu, 16 Apr 2026 05:10:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725A36B0098; Thu, 16 Apr 2026 05:10:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF736B0099; Thu, 16 Apr 2026 05:10:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 528646B0096
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:10:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1631A0825
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:50 +0000 (UTC)
X-FDA: 84663849060.01.3EA6B6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F54040005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:10:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLplVIIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36iZTyAOYZW2gfoohEE7pZm8FAsaIrKGumu0xj2WWb0=;
	b=Krk+2ih7zI+zK51vRYqsqcvQ9nkcdqzF67o+tv9NklgLXVVEMfA8QQYFYwRgqou/sLOAXi
	YVLF8S8im0plh+aj4MuR1Hh4Z30ACwSVBD65mgAtdhDfQUUNgu/quI8S/NxKRhYagZAYB1
	Kqn5dVWIuUFTZJDV6HpwWn2WlpQHGkY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLplVIIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330648; a=rsa-sha256;
	cv=none;
	b=ta3gfGdf4iFYJhxcAL6CRvgSrDI9LYuoMtQnpj6n+Ii7YWxgS5PJCTOqmN9YYpGLLJGoUF
	pBF7t2RtI+4NHMG0OCZTISrGzVbZvs40WziHnJMpTLFYjN59EuxrNBRrhrHagXfougoPzT
	iHw1PNDSgKfYG29b5dhjnCZ0ooQieFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 175F060128;
	Thu, 16 Apr 2026 09:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD79EC2BCAF;
	Thu, 16 Apr 2026 09:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330647;
	bh=Hjzd7B0o3iqh0WNfRjndAmyC/o1A3INTsnmLGnK+eIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLplVIIzNsLn5/KRRbA4VwwJZV/dGQFli2DuKGpYOCnn3guWYtGn+v1CK4Rk7/xn4
	 XdgNKgCywiR9cj7scHP1VEDjxNKl6ZnkoBxnXUil/LH1SN7pQ2NVU0CnXGbjEJcBmp
	 UGLJHSV9xcfVXkaoSUkSWp8xYdDMQb0cQOsMG5gSW6pAbaIyJu03u8Oe13JtqoeK9N
	 QPJzv88IhwHc9FRETYx2/NqAl0I0CqKMIjlxyn03ZFNnmvZcqna8UsEcC4p+hVJakH
	 cyMLYxpoMD60eGWB45FqEFU1au0co5KLzQaNT3DKDHEfGVUkHH/SeHDnlQYSafYRBZ
	 WxFMpPUg1NNoQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mm/slab: wrap rcu sheaf handling with ifdef
Date: Thu, 16 Apr 2026 18:10:20 +0900
Message-ID: <20260416091022.36823-7-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260416091022.36823-1-harry@kernel.org>
References: <20260416091022.36823-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8F54040005
X-Stat-Signature: 9ar14ijtu94u7hq1tj9q6fzuoszx4896
X-Rspam-User: 
X-HE-Tag: 1776330648-798629
X-HE-Meta: U2FsdGVkX1/sQBf+DpL75W5UEIuwx0080Mty0UMR3w33Vh4FozU114m+1GSjOgnurWzgnv8K5+f+NPEgVEc/y6cBe6iLtmhbQP5iiqa2Xq8B3Y/2uXy//wwSFzenDz+hhE+IfB7uKskk88GdVRWAO9LXYS4jP9pOg3kMhvIVxZ4E4lhn5LumdbBV2hIyhUHn0XHH2QMI7t5pxc0WYz5AzEdTXtlurx/O0sPAKipWJrp3e9rZ5YZDc47TtRQPqp5eMxXZI0EK1LmHzVL7R5r2yBjTFHx3u7lRPpZ9ieLRzcHgwBHDj0NCnsETU1LYeGR3zDFs3RX7x16RwsdZwaPpaqC8IJ5rmdsEsKhSGg/Avymg1r1w/f/s2pm3oxn0NW7V0Ad6Y6zbF6Hoqs6aU8jT4HvJUHdJc8yfWxRPOJdiv5jqtX7E1Y4V3Fo7ZIlW06sQ/LcBTXPzGpjMivLXX1+jTtjrY7EhWO2PjRTf1kW9ZEfNQT+fbRH5gO00gXZ8aRR9fY4mHMi6SHiJY+QTY7EQ+LcNWeDu/6PGgKBeCw3Ka9QKLG2+b3LqWI6nValU/SfchWi6UsG4quj8WrSoZW6YErBtKUCnYCS4su8Gih/0QKHbPsQ9O01P4WiGyBFyheW+8MFPyK/VmzXu9J6jEt/dl+tXrJadfile/CD344D5QMSLM5YW+KXiaUGOfp/bGPot4Yp71ZyGNQMQQYpa2yi6W81PLcrv/MtzUJsO6TiKnwdXZO6Zr9DHxfTGkiwBzyoolx76HTgSzq3Mo6O6Xj5c2ojh9WYoxXX/Sraq/5JBejp7B/IVM+Wm4L/v1kK82dIQt848Q861DS31TQ2R3iV2rNrrjue+hkzE9Pqi8fTsuyDR5Uxy0q6aS2E4PP+sE9KTj79qk3lbvLeT3vFb9YNL/X8WeKd3xPleHtxE8O5MgGiKxT2xNFXz8rvP62aLNGy7GKVD7jZ4zmMIydxe04S
 aqEfHape
 3pGW5AQMQ3d2FW7x9QtFDzVyP7EL9OQ/HnVAq+2/ZYFs3IL0G9PNOaB84zDJBHHRCENP2/g65XlN6f+Tzi0GwCuQi9KGQCy+DjjlHDNFaZ5GH/C3NBs0zh1AgCxaSwkhc9tHUsTATHR/cbOp19t8W9eHJJTD+xTuxMe0HseU4s4wozC/tPgKd244b4NxuewCuXg59jCswnVRaCRmZnp/mx8O74SEt55xOikxzLuD4aUpJRa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freeing objects via rcu sheaves is only done with
CONFIG_KVFREE_RCU_BATCHED. Wrap the related functions and struct
fields with ifdef to make this dependency explicit.

Also remove a TODO about implementing __kvfree_rcu_barrier_on_cache()
for a specific slab cache, as there doesn't seem to be a simple and
effective way to do so.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        |  3 +++
 mm/slab_common.c |  4 ----
 mm/slub.c        | 27 +++++++++++++++++++++++++--
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index d7fd7626e9fe..bdad5f389490 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -409,9 +409,12 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin);
 void flush_all_rcu_sheaves(void);
 void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
+#endif
+
 void defer_kvfree_rcu_barrier(void);
 
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 46a2bee1662b..347e52f1538c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2289,10 +2289,6 @@ void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 		rcu_barrier();
 	}
 
-	/*
-	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
-	 * on a specific slab cache.
-	 */
 	__kvfree_rcu_barrier();
 }
 EXPORT_SYMBOL_GPL(kvfree_rcu_barrier_on_cache);
diff --git a/mm/slub.c b/mm/slub.c
index d0db8d070570..91b8827d65da 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -421,7 +421,9 @@ struct slub_percpu_sheaves {
 	local_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
+#endif
 };
 
 /*
@@ -2923,6 +2925,7 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	sheaf->size = 0;
 }
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 				     struct slab_sheaf *sheaf)
 {
@@ -2965,6 +2968,7 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
 
 	free_empty_sheaf(s, sheaf);
 }
+#endif
 
 /*
  * Caller needs to make sure migration is disabled in order to fully flush
@@ -2978,7 +2982,10 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
 static void pcs_flush_all(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
-	struct slab_sheaf *spare, *rcu_free;
+	struct slab_sheaf *spare;
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+	struct slab_sheaf *rcu_free;
+#endif
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -2986,8 +2993,10 @@ static void pcs_flush_all(struct kmem_cache *s)
 	spare = pcs->spare;
 	pcs->spare = NULL;
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
+#endif
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -2996,8 +3005,10 @@ static void pcs_flush_all(struct kmem_cache *s)
 		free_empty_sheaf(s, spare);
 	}
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+#endif
 
 	sheaf_flush_main(s);
 }
@@ -3016,10 +3027,12 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 		pcs->spare = NULL;
 	}
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 	if (pcs->rcu_free) {
 		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
 		pcs->rcu_free = NULL;
 	}
+#endif
 }
 
 static void pcs_destroy(struct kmem_cache *s)
@@ -3056,7 +3069,9 @@ static void pcs_destroy(struct kmem_cache *s)
 		 */
 
 		WARN_ON(pcs->spare);
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 		WARN_ON(pcs->rcu_free);
+#endif
 
 		if (!WARN_ON(pcs->main->size)) {
 			free_empty_sheaf(s, pcs->main);
@@ -3937,7 +3952,11 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-	return (pcs->spare || pcs->rcu_free || pcs->main->size);
+#ifdef CONFIG_KVFREE_RCU_BATCHED
+	if (pcs->rcu_free)
+		return true;
+#endif
+	return (pcs->spare || pcs->main->size);
 }
 
 /*
@@ -3995,6 +4014,7 @@ static void flush_all(struct kmem_cache *s)
 	cpus_read_unlock();
 }
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 static void flush_rcu_sheaf(struct work_struct *w)
 {
 	struct slub_percpu_sheaves *pcs;
@@ -4071,6 +4091,7 @@ void flush_all_rcu_sheaves(void)
 
 	rcu_barrier();
 }
+#endif /* CONFIG_KVFREE_RCU_BATCHED */
 
 static int slub_cpu_setup(unsigned int cpu)
 {
@@ -5825,6 +5846,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 	return true;
 }
 
+#ifdef CONFIG_KVFREE_RCU_BATCHED
 static void rcu_free_sheaf(struct rcu_head *head)
 {
 	struct slab_sheaf *sheaf;
@@ -6005,6 +6027,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 	lock_map_release(&kfree_rcu_sheaf_map);
 	return false;
 }
+#endif /* CONFIG_KVFREE_RCU_BATCHED */
 
 static __always_inline bool can_free_to_pcs(struct slab *slab)
 {
-- 
2.43.0


