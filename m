Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90D2CA0FF6
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E886B036F; Wed, 27 Aug 2025 04:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100AB6B0370; Wed, 27 Aug 2025 04:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE32C6B0371; Wed, 27 Aug 2025 04:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE2356B036E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:51 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A1E5C03D9
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:51 +0000 (UTC)
X-FDA: 83821856622.02.9B7DCB3
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E8BE40008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dVFwzrbfEqBcYf4ngPEd4pZjOK5u951AH3AqJSOU+30=;
	b=JVnDYbw7MkEIdTKjG25D9/+D1bEyCNpPqTqV/E0cnEkk2kC8rHVhUszE/9B5eMb41xQi4s
	/9Cc47TsN/yT0dOo700+QUBPS4GTZDiPPB8gTZ+4pug9PJWuCvtxcVxE8NxKN7COW2mww7
	XyFmlthn6PbMvrMDY1vgDRVRVazUCfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283209; a=rsa-sha256;
	cv=none;
	b=3qTXcbC26kGyzLi+RIGFL5xNNcRRjGd6mltPBkJGVYHO1n55xZRVcugxGACXM9nJUJ0RTi
	1xEiFXXjOZ1mg7S21jPDnSG6DTxFuHXa0m+fDzKZ78c/gUPFyBO35NMUlrenJc7jhkCnRM
	okGSr1uKnAkQA78oyJK0t285MwfFrGc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5D5521FF21;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 474AA13310;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6LsiETvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:36 +0200
Subject: [PATCH v6 04/10] slab: sheaf prefilling for guaranteed allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-4-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E8BE40008
X-Stat-Signature: bauq5agf7no1kpkm5fxp9opy6r7eia4i
X-Rspam-User: 
X-HE-Tag: 1756283209-295146
X-HE-Meta: U2FsdGVkX193Mn+D7SvrAao4YvRCaLvNjkQmQSLy0tCRFBMZOUuBgekVF/9FOWmoy9mIdYMAk2IH0rPJnrT6aT44HKilYwPZjksFlQNs7NW0kG68Zk/MaOQUm2jVa9nA8rrUcniQ5wDKl/MPsei5uAJZV5pz00MvLLUlArTTy2JUi4lw4Jk3Lk8wbjdwLKLGdnWCiyg4fcXpDVIP5qAQofFLg+peunkXl+3BfHxVrgcMVKWOZpYcAvyanf6UZPuSST50fjJDudkMBQtCA27QMDhs5othpYu9rLS28vj15I/7eB1flOTXFI/mrOn2M0ttmUKLmvG6tIb2Jm+mvTJCBVOkdcucpQfdkBILAWvPcBR2D/YUjT7bBC8HzPmEq92ScY0p8kJ75wunHih/Lzt7RG9btBKNCNmgmD+gTjJNlYkNxoyhHiPTj96mr8d6AcHSDzlkIVR9erKt3q0CBWcZCnRw5nTUp58mESwvj3v/Ajn87ct1tt4XzfRSRpeW6z73BzsskhzpK4YzgnG2TQPBiyab2nkCUVOIC1AyNHXs0xkrikMMOsd5ytwT/kq5LF2MfT7FkQ99uFB6+zb+w2qyC34PRo1CzIWxr14ieDdutgnsIE8rMk3dDiXDsb4oe3vGFog2jhyxUQ8xrNd8uAWm7k+fvYOi/Ml9flB3qkhi7dIBOgLEMsfMEVe+MNqx/C7Llx5Ys8JYoTinuMzjZlWmsdPPsWtKJzFMENh+QPm9OlRrOMnRCdhqg49JMqdAeMDLKyTXKsaHKf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add functions for efficient guaranteed allocations e.g. in a critical
section that cannot sleep, when the exact number of allocations is not
known beforehand, but an upper limit can be calculated.

kmem_cache_prefill_sheaf() returns a sheaf containing at least given
number of objects.

kmem_cache_alloc_from_sheaf() will allocate an object from the sheaf
and is guaranteed not to fail until depleted.

kmem_cache_return_sheaf() is for giving the sheaf back to the slab
allocator after the critical section. This will also attempt to refill
it to cache's sheaf capacity for better efficiency of sheaves handling,
but it's not stricly necessary to succeed.

kmem_cache_refill_sheaf() can be used to refill a previously obtained
sheaf to requested size. If the current size is sufficient, it does
nothing. If the requested size exceeds cache's sheaf_capacity and the
sheaf's current capacity, the sheaf will be replaced with a new one,
hence the indirect pointer parameter.

kmem_cache_sheaf_size() can be used to query the current size.

The implementation supports requesting sizes that exceed cache's
sheaf_capacity, but it is not efficient - such "oversize" sheaves are
allocated fresh in kmem_cache_prefill_sheaf() and flushed and freed
immediately by kmem_cache_return_sheaf(). kmem_cache_refill_sheaf()
might be especially ineffective when replacing a sheaf with a new one of
a larger capacity. It is therefore better to size cache's
sheaf_capacity accordingly to make oversize sheaves exceptional.

CONFIG_SLUB_STATS counters are added for sheaf prefill and return
operations. A prefill or return is considered _fast when it is able to
grab or return a percpu spare sheaf (even if the sheaf needs a refill to
satisfy the request, as those should amortize over time), and _slow
otherwise (when the barn or even sheaf allocation/freeing has to be
involved). sheaf_prefill_oversize is provided to determine how many
prefills were oversize (counter for oversize returns is not necessary as
all oversize refills result in oversize returns).

When slub_debug is enabled for a cache with sheaves, no percpu sheaves
exist for it, but the prefill functionality is still provided simply by
all prefilled sheaves becoming oversize. If percpu sheaves are not
created for a cache due to not passing the sheaf_capacity argument on
cache creation, the prefills also work through oversize sheaves, but
there's a WARN_ON_ONCE() to indicate the omission.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  16 ++++
 mm/slub.c            | 265 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 281 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 49acbcdc6696fd120c402adf757b3f41660ad50a..680193356ac7a22f9df5cd9b71ff8b81e26404ad 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -829,6 +829,22 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t flags,
 				   int node) __assume_slab_alignment __malloc;
 #define kmem_cache_alloc_node(...)	alloc_hooks(kmem_cache_alloc_node_noprof(__VA_ARGS__))
 
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
+
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf **sheafp, unsigned int size);
+
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+				       struct slab_sheaf *sheaf);
+
+void *kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *cachep, gfp_t gfp,
+			struct slab_sheaf *sheaf) __assume_slab_alignment __malloc;
+#define kmem_cache_alloc_from_sheaf(...)	\
+			alloc_hooks(kmem_cache_alloc_from_sheaf_noprof(__VA_ARGS__))
+
+unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
+
 /*
  * These macros allow declaring a kmem_buckets * parameter alongside size, which
  * can be compiled out with CONFIG_SLAB_BUCKETS=n so that a large number of call
diff --git a/mm/slub.c b/mm/slub.c
index 7492076cf8c388793c09a64496a3b8850ef0d8ec..c8dda640f95e7e738cf2ceb05b98d1176df6e83f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -401,6 +401,11 @@ enum stat_item {
 	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
 	BARN_PUT,		/* Put full sheaf to barn */
 	BARN_PUT_FAIL,		/* Failed to put full sheaf to barn */
+	SHEAF_PREFILL_FAST,	/* Sheaf prefill grabbed the spare sheaf */
+	SHEAF_PREFILL_SLOW,	/* Sheaf prefill found no spare sheaf */
+	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
+	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
+	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
 	NR_SLUB_STAT_ITEMS
 };
 
@@ -462,6 +467,8 @@ struct slab_sheaf {
 	union {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
+		/* only used for prefilled sheafs */
+		unsigned int capacity;
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
@@ -2833,6 +2840,30 @@ static void barn_put_full_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf
 	spin_unlock_irqrestore(&barn->lock, flags);
 }
 
+static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
+{
+	struct slab_sheaf *sheaf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	if (barn->nr_full) {
+		sheaf = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
+					barn_list);
+		list_del(&sheaf->barn_list);
+		barn->nr_full--;
+	} else if (barn->nr_empty) {
+		sheaf = list_first_entry(&barn->sheaves_empty,
+					 struct slab_sheaf, barn_list);
+		list_del(&sheaf->barn_list);
+		barn->nr_empty--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return sheaf;
+}
+
 /*
  * If a full sheaf is available, return it and put the supplied empty one to
  * barn. We ignore the limit on empty sheaves as the number of sheaves doesn't
@@ -4962,6 +4993,230 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * returns a sheaf that has at least the requested size
+ * when prefilling is needed, do so with given gfp flags
+ *
+ * return NULL if sheaf allocation or prefilling failed
+ */
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *sheaf = NULL;
+
+	if (unlikely(size > s->sheaf_capacity)) {
+
+		/*
+		 * slab_debug disables cpu sheaves intentionally so all
+		 * prefilled sheaves become "oversize" and we give up on
+		 * performance for the debugging. Same with SLUB_TINY.
+		 * Creating a cache without sheaves and then requesting a
+		 * prefilled sheaf is however not expected, so warn.
+		 */
+		WARN_ON_ONCE(s->sheaf_capacity == 0 &&
+			     !IS_ENABLED(CONFIG_SLUB_TINY) &&
+			     !(s->flags & SLAB_DEBUG_FLAGS));
+
+		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
+		if (!sheaf)
+			return NULL;
+
+		stat(s, SHEAF_PREFILL_OVERSIZE);
+		sheaf->cache = s;
+		sheaf->capacity = size;
+
+		if (!__kmem_cache_alloc_bulk(s, gfp, size,
+					     &sheaf->objects[0])) {
+			kfree(sheaf);
+			return NULL;
+		}
+
+		sheaf->size = size;
+
+		return sheaf;
+	}
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (pcs->spare) {
+		sheaf = pcs->spare;
+		pcs->spare = NULL;
+		stat(s, SHEAF_PREFILL_FAST);
+	} else {
+		stat(s, SHEAF_PREFILL_SLOW);
+		sheaf = barn_get_full_or_empty_sheaf(pcs->barn);
+		if (sheaf && sheaf->size)
+			stat(s, BARN_GET);
+		else
+			stat(s, BARN_GET_FAIL);
+	}
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+
+	if (!sheaf)
+		sheaf = alloc_empty_sheaf(s, gfp);
+
+	if (sheaf && sheaf->size < size) {
+		if (refill_sheaf(s, sheaf, gfp)) {
+			sheaf_flush_unused(s, sheaf);
+			free_empty_sheaf(s, sheaf);
+			sheaf = NULL;
+		}
+	}
+
+	if (sheaf)
+		sheaf->capacity = s->sheaf_capacity;
+
+	return sheaf;
+}
+
+/*
+ * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
+ *
+ * If the sheaf cannot simply become the percpu spare sheaf, but there's space
+ * for a full sheaf in the barn, we try to refill the sheaf back to the cache's
+ * sheaf_capacity to avoid handling partially full sheaves.
+ *
+ * If the refill fails because gfp is e.g. GFP_NOWAIT, or the barn is full, the
+ * sheaf is instead flushed and freed.
+ */
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+			     struct slab_sheaf *sheaf)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct node_barn *barn;
+
+	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
+		sheaf_flush_unused(s, sheaf);
+		kfree(sheaf);
+		return;
+	}
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (!pcs->spare) {
+		pcs->spare = sheaf;
+		sheaf = NULL;
+		stat(s, SHEAF_RETURN_FAST);
+	}
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (!sheaf)
+		return;
+
+	stat(s, SHEAF_RETURN_SLOW);
+
+	/* Accessing pcs->barn outside local_lock is safe. */
+	barn = pcs->barn;
+
+	/*
+	 * If the barn has too many full sheaves or we fail to refill the sheaf,
+	 * simply flush and free it.
+	 */
+	if (data_race(pcs->barn->nr_full) >= MAX_FULL_SHEAVES ||
+	    refill_sheaf(s, sheaf, gfp)) {
+		sheaf_flush_unused(s, sheaf);
+		free_empty_sheaf(s, sheaf);
+		return;
+	}
+
+	barn_put_full_sheaf(barn, sheaf);
+	stat(s, BARN_PUT);
+}
+
+/*
+ * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
+ * the given size
+ *
+ * the sheaf might be replaced by a new one when requesting more than
+ * s->sheaf_capacity objects if such replacement is necessary, but the refill
+ * fails (returning -ENOMEM), the existing sheaf is left intact
+ *
+ * In practice we always refill to full sheaf's capacity.
+ */
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+			    struct slab_sheaf **sheafp, unsigned int size)
+{
+	struct slab_sheaf *sheaf;
+
+	/*
+	 * TODO: do we want to support *sheaf == NULL to be equivalent of
+	 * kmem_cache_prefill_sheaf() ?
+	 */
+	if (!sheafp || !(*sheafp))
+		return -EINVAL;
+
+	sheaf = *sheafp;
+	if (sheaf->size >= size)
+		return 0;
+
+	if (likely(sheaf->capacity >= size)) {
+		if (likely(sheaf->capacity == s->sheaf_capacity))
+			return refill_sheaf(s, sheaf, gfp);
+
+		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
+					     &sheaf->objects[sheaf->size])) {
+			return -ENOMEM;
+		}
+		sheaf->size = sheaf->capacity;
+
+		return 0;
+	}
+
+	/*
+	 * We had a regular sized sheaf and need an oversize one, or we had an
+	 * oversize one already but need a larger one now.
+	 * This should be a very rare path so let's not complicate it.
+	 */
+	sheaf = kmem_cache_prefill_sheaf(s, gfp, size);
+	if (!sheaf)
+		return -ENOMEM;
+
+	kmem_cache_return_sheaf(s, gfp, *sheafp);
+	*sheafp = sheaf;
+	return 0;
+}
+
+/*
+ * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
+ *
+ * Guaranteed not to fail as many allocations as was the requested size.
+ * After the sheaf is emptied, it fails - no fallback to the slab cache itself.
+ *
+ * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
+ * memcg charging is forced over limit if necessary, to avoid failure.
+ */
+void *
+kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
+				   struct slab_sheaf *sheaf)
+{
+	void *ret = NULL;
+	bool init;
+
+	if (sheaf->size == 0)
+		goto out;
+
+	ret = sheaf->objects[--sheaf->size];
+
+	init = slab_want_init_on_alloc(gfp, s);
+
+	/* add __GFP_NOFAIL to force successful memcg charging */
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+out:
+	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
+
+	return ret;
+}
+
+unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
+{
+	return sheaf->size;
+}
 /*
  * To avoid unnecessary overhead, we pass through large allocation requests
  * directly to the page allocator. We use __GFP_COMP, because we will need to
@@ -8488,6 +8743,11 @@ STAT_ATTR(BARN_GET, barn_get);
 STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
 STAT_ATTR(BARN_PUT, barn_put);
 STAT_ATTR(BARN_PUT_FAIL, barn_put_fail);
+STAT_ATTR(SHEAF_PREFILL_FAST, sheaf_prefill_fast);
+STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
+STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
+STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
+STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
 #endif	/* CONFIG_SLUB_STATS */
 
 #ifdef CONFIG_KFENCE
@@ -8588,6 +8848,11 @@ static struct attribute *slab_attrs[] = {
 	&barn_get_fail_attr.attr,
 	&barn_put_attr.attr,
 	&barn_put_fail_attr.attr,
+	&sheaf_prefill_fast_attr.attr,
+	&sheaf_prefill_slow_attr.attr,
+	&sheaf_prefill_oversize_attr.attr,
+	&sheaf_return_fast_attr.attr,
+	&sheaf_return_slow_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,

-- 
2.51.0


