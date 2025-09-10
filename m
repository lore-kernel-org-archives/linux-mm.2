Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00EBCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539298E001D; Wed, 10 Sep 2025 04:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5108D8E001A; Wed, 10 Sep 2025 04:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426B38E001D; Wed, 10 Sep 2025 04:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7F08E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE3C713BB56
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:59 +0000 (UTC)
X-FDA: 83872597158.06.BF2C8D1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 84C98A000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u1/IunZs";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QRPwuCwk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Wi/pl7pC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rlA0zlrL;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RBRID3XCadovWwOC1yDjkbntDt14oP+Yib+L6r+EoMM=;
	b=lY5cvArKFB2p+qHRB9TWcJYN1xDBCeSWcpdghF/kl9CNzWEuh7YnqACGAPW4OyY8n9P/li
	2D1rzZ5Mo2u/ImejNv0RnHmLpf12kN+FJlz4tvnFpMebcOqsr6/M8/p8OIxarFon4evfu5
	FAz7WiSg3PMoQ6zJIBpJ/66fAkhZgMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491317; a=rsa-sha256;
	cv=none;
	b=6+0OGfco3YH7Spm6t1jIPgjWefKRW2hdFX+Zxe9inazzx1XU/9nH/mY8Rr8nY67qjNN06U
	3LuTZMTNvY+U5f5pvEqUDH4zTUl5SdyQpQ+TnuKAPr5XAhUGNboQW2LYJQN5wz3Rh9XpvZ
	aw++YvuH/kdDDGNEKXcwlz67P6fCtiM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u1/IunZs";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QRPwuCwk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Wi/pl7pC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rlA0zlrL;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A1FE5CABD;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBRID3XCadovWwOC1yDjkbntDt14oP+Yib+L6r+EoMM=;
	b=u1/IunZspPhefI8jb4XSztzfR926ogR9rI/LK+s4/Ri0i2MdZNJuo0nyfd9O4RCreGPFfe
	BN86/BsK0FJuEjTGKT7laUugiXnAiqq85RGiBjzgQuVu955o3sZbYx6huLIOo11Hc2pmc1
	VP9T+oUcxOfiB9FsnA8vGQS9N/ld0MY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBRID3XCadovWwOC1yDjkbntDt14oP+Yib+L6r+EoMM=;
	b=QRPwuCwkR3icrm3hwpdcGZhLNdMlaMEo29lWQoHf2kn9tRi6CfQ9suh/afThPKQ0w5YXkU
	ye0eGyKJI4oNmoDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491266; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBRID3XCadovWwOC1yDjkbntDt14oP+Yib+L6r+EoMM=;
	b=Wi/pl7pCncZEun0bI5Wt5MwlJdkLCUQeJJh7jYsox441YSz6wSk72YMENMPn/oTMFn7eYj
	dRPFRwfiK9YmehaBmW4d21WQtF8mjhSpPfrHffk5ZVqmd/0sHpecg+I0Xn2uvP5+D6jLhU
	HDWxsx051CL9cnGyJf7RAfpbNtYQl7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491266;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RBRID3XCadovWwOC1yDjkbntDt14oP+Yib+L6r+EoMM=;
	b=rlA0zlrLRZ/0SW6eDnFXZr1ybZjcHDTxTIGOQhJ3f3dgsAUZXUXgxSE2vWjef96+M54Nmo
	JoChmFTODBCeg5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00EE413AD1;
	Wed, 10 Sep 2025 08:01:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iK6NO0EwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:05 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:06 +0200
Subject: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 84C98A000F
X-Stat-Signature: ni4zjd34smg6o4d3bhuga75mod38engo
X-Rspam-User: 
X-HE-Tag: 1757491317-680880
X-HE-Meta: U2FsdGVkX1/4bGNfTaOU+bKDppwpFmiDm5ZrxE8i/OpmwhPn2tqDPoUSCZXnh0gZJtkjjHOoJV/naW0JWfBol+JpGJcMW6KrE38jXgZGzrklUVxBZbA9guZfiiNF59IMSYW2F/xfpdEBS21P3o26xzYT6hrrRwoZYN1YBewHQE5x0oaFdw1pujcb677wi7svh+bvvPdv3NAlD1qokS9x7/lstwESKKqsM4JEZHo7feE1DS3vLUIL1OiBlKtK6eBjO3KPeFlNSueJNC/TfoPycmiF8jYKcXlXsYHxPmF0/6dLA/W6/AEAeZL7HKF2/+NjnnyenWkQK8GCETch+F5ECs2WaGT7nAHLTZ3Iao7w0JlE7PIBuLy3TnBoY03ZfUGJ69sXg3Ww/D8TOGfUrVLfYbacU+tIX6g8GKAThxhaOCfjxn+erBWvMJet7eHADBA0IIcybCVh5GYYuIm3gH2TLrkFFxcrqRzOKkGh9CijiMRDxNqE3L+yAC+v4LWOtL1F0Ld2JOyPG1RWRILPeIagrvhIKN1Fvcxx1Axm7nyKRJcGaL18C/6Z+6UcjLgS/a7L/NmnkRCh8DjaWu+FfJfSlumaWRVTGjVblpNGyL78/fqAk+xcwt0ll3Xba+tu3K+grKh/YhoYmI8FZP73OiJLQ0Qf2hPQHIaOQpArw7/lVhUTmojcfCaV13VC9tNOPA+arZkpWrZiSRzV1pQOk4sn+dpvq4m+z89tjfj6nZHDF3v+0mjhCyrHee+9UQrxL6j1Vv6irdY5AFWv2EFZQwtI78TT4vxhfnn4Xae9L+tA5utcGqY5L4V7uqNA8sTIbgl8sYB3F2U2Ho9SMNPUhf3NJwgS3C3DnSEckkoCYIHj1DCDSUKi4Qf6BG52Ql0K3Nta+fnVyrQ+9G1iIXZ0WpAHP9Mdv4d+4YmdJtcwqcb5hGSFufzvmy5uwIgTV1kuX+VITDqt21Gy/xwH/9k0S5h
 MQxwYv+G
 Vflt2wk+uAcXS5eqjJxmITB8c1ptaDau2Rtea8JRqh9Mu6tlEXIIlsvwhyJzRy51+nAflCWhyp7+k5VpakCvKbYrYPGxmPGAMiGpTY9eJ2RzDyioki4P23KcLvURcscs/uWC2b1QeQ/mtarOaJ+xLsphRqGaDeqO2pRw74bXjnGFIbKddUkJn9i1r2sKr2r9WUy/AK0qnsiN8H35+n0kgdrf4bk7GWQqKIHh7P9zpng8iWiy3knAtA8sqyq41vk0V1Zi9wxqJb8CLuiPVUm7Kp/hqnMtg1/JMaqM5RhZGCyG3yYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the sheaf infrastructure for more efficient kfree_rcu() handling.
For caches with sheaves, on each cpu maintain a rcu_free sheaf in
addition to main and spare sheaves.

kfree_rcu() operations will try to put objects on this sheaf. Once full,
the sheaf is detached and submitted to call_rcu() with a handler that
will try to put it in the barn, or flush to slab pages using bulk free,
when the barn is full. Then a new empty sheaf must be obtained to put
more objects there.

It's possible that no free sheaves are available to use for a new
rcu_free sheaf, and the allocation in kfree_rcu() context can only use
GFP_NOWAIT and thus may fail. In that case, fall back to the existing
kfree_rcu() implementation.

Expected advantages:
- batching the kfree_rcu() operations, that could eventually replace the
  existing batching
- sheaves can be reused for allocations via barn instead of being
  flushed to slabs, which is more efficient
  - this includes cases where only some cpus are allowed to process rcu
    callbacks (Android)

Possible disadvantage:
- objects might be waiting for more than their grace period (it is
  determined by the last object freed into the sheaf), increasing memory
  usage - but the existing batching does that too.

Only implement this for CONFIG_KVFREE_RCU_BATCHED as the tiny
implementation favors smaller memory footprint over performance.

Also for now skip the usage of rcu sheaf for CONFIG_PREEMPT_RT as the
contexts where kfree_rcu() is called might not be compatible with taking
a barn spinlock or a GFP_NOWAIT allocation of a new sheaf taking a
spinlock - the current kfree_rcu() implementation avoids doing that.

Teach kvfree_rcu_barrier() to flush all rcu_free sheaves from all caches
that have them. This is not a cheap operation, but the barrier usage is
rare - currently kmem_cache_destroy() or on module unload.

Add CONFIG_SLUB_STATS counters free_rcu_sheaf and free_rcu_sheaf_fail to
count how many kfree_rcu() used the rcu_free sheaf successfully and how
many had to fall back to the existing implementation.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h        |   3 +
 mm/slab_common.c |  26 ++++++
 mm/slub.c        | 266 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 293 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 206987ce44a4d053ebe3b5e50784d2dd23822cd1..e82e51c44bd00042d433ac8b46c2b4bbbdded9b1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -435,6 +435,9 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
 }
 
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
+void flush_all_rcu_sheaves(void);
+
 #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
diff --git a/mm/slab_common.c b/mm/slab_common.c
index e2b197e47866c30acdbd1fee4159f262a751c5a7..005a4319c06a01d2b616a75396fcc43766a62ddb 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1608,6 +1608,27 @@ static void kfree_rcu_work(struct work_struct *work)
 		kvfree_rcu_list(head);
 }
 
+static bool kfree_rcu_sheaf(void *obj)
+{
+	struct kmem_cache *s;
+	struct folio *folio;
+	struct slab *slab;
+
+	if (is_vmalloc_addr(obj))
+		return false;
+
+	folio = virt_to_folio(obj);
+	if (unlikely(!folio_test_slab(folio)))
+		return false;
+
+	slab = folio_slab(folio);
+	s = slab->slab_cache;
+	if (s->cpu_sheaves)
+		return __kfree_rcu_sheaf(s, obj);
+
+	return false;
+}
+
 static bool
 need_offload_krc(struct kfree_rcu_cpu *krcp)
 {
@@ -1952,6 +1973,9 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
 	if (!head)
 		might_sleep();
 
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
+		return;
+
 	// Queue the object but don't yet schedule the batch.
 	if (debug_rcu_head_queue(ptr)) {
 		// Probable double kfree_rcu(), just leak.
@@ -2026,6 +2050,8 @@ void kvfree_rcu_barrier(void)
 	bool queued;
 	int i, cpu;
 
+	flush_all_rcu_sheaves();
+
 	/*
 	 * Firstly we detach objects and queue them over an RCU-batch
 	 * for all CPUs. Finally queued works are flushed for each CPU.
diff --git a/mm/slub.c b/mm/slub.c
index cba188b7e04ddf86debf9bc27a2f725db1b2056e..19cd8444ae5d210c77ae767912ca1ff3fc69c2a8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -367,6 +367,8 @@ enum stat_item {
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
 	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
 	FREE_PCS,		/* Free to percpu sheaf */
+	FREE_RCU_SHEAF,		/* Free to rcu_free sheaf */
+	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
 	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
 	FREE_FROZEN,		/* Freeing to frozen slab */
@@ -461,6 +463,7 @@ struct slab_sheaf {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
 	};
+	struct kmem_cache *cache;
 	unsigned int size;
 	void *objects[];
 };
@@ -469,6 +472,7 @@ struct slub_percpu_sheaves {
 	local_trylock_t lock;
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
+	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
 };
 
 /*
@@ -2531,6 +2535,8 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
 	if (unlikely(!sheaf))
 		return NULL;
 
+	sheaf->cache = s;
+
 	stat(s, SHEAF_ALLOC);
 
 	return sheaf;
@@ -2655,6 +2661,43 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	sheaf->size = 0;
 }
 
+static void __rcu_free_sheaf_prepare(struct kmem_cache *s,
+				     struct slab_sheaf *sheaf)
+{
+	bool init = slab_want_init_on_free(s);
+	void **p = &sheaf->objects[0];
+	unsigned int i = 0;
+
+	while (i < sheaf->size) {
+		struct slab *slab = virt_to_slab(p[i]);
+
+		memcg_slab_free_hook(s, slab, p + i, 1);
+		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
+
+		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+			p[i] = p[--sheaf->size];
+			continue;
+		}
+
+		i++;
+	}
+}
+
+static void rcu_free_sheaf_nobarn(struct rcu_head *head)
+{
+	struct slab_sheaf *sheaf;
+	struct kmem_cache *s;
+
+	sheaf = container_of(head, struct slab_sheaf, rcu_head);
+	s = sheaf->cache;
+
+	__rcu_free_sheaf_prepare(s, sheaf);
+
+	sheaf_flush_unused(s, sheaf);
+
+	free_empty_sheaf(s, sheaf);
+}
+
 /*
  * Caller needs to make sure migration is disabled in order to fully flush
  * single cpu's sheaves
@@ -2667,7 +2710,7 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 static void pcs_flush_all(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
-	struct slab_sheaf *spare;
+	struct slab_sheaf *spare, *rcu_free;
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -2675,6 +2718,9 @@ static void pcs_flush_all(struct kmem_cache *s)
 	spare = pcs->spare;
 	pcs->spare = NULL;
 
+	rcu_free = pcs->rcu_free;
+	pcs->rcu_free = NULL;
+
 	local_unlock(&s->cpu_sheaves->lock);
 
 	if (spare) {
@@ -2682,6 +2728,9 @@ static void pcs_flush_all(struct kmem_cache *s)
 		free_empty_sheaf(s, spare);
 	}
 
+	if (rcu_free)
+		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+
 	sheaf_flush_main(s);
 }
 
@@ -2698,6 +2747,11 @@ static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
 		free_empty_sheaf(s, pcs->spare);
 		pcs->spare = NULL;
 	}
+
+	if (pcs->rcu_free) {
+		call_rcu(&pcs->rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+		pcs->rcu_free = NULL;
+	}
 }
 
 static void pcs_destroy(struct kmem_cache *s)
@@ -2723,6 +2777,7 @@ static void pcs_destroy(struct kmem_cache *s)
 		 */
 
 		WARN_ON(pcs->spare);
+		WARN_ON(pcs->rcu_free);
 
 		if (!WARN_ON(pcs->main->size)) {
 			free_empty_sheaf(s, pcs->main);
@@ -3780,7 +3835,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-	return (pcs->spare || pcs->main->size);
+	return (pcs->spare || pcs->rcu_free || pcs->main->size);
 }
 
 /*
@@ -3840,6 +3895,80 @@ static void flush_all(struct kmem_cache *s)
 	cpus_read_unlock();
 }
 
+static void flush_rcu_sheaf(struct work_struct *w)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *rcu_free;
+	struct slub_flush_work *sfw;
+	struct kmem_cache *s;
+
+	sfw = container_of(w, struct slub_flush_work, work);
+	s = sfw->s;
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	rcu_free = pcs->rcu_free;
+	pcs->rcu_free = NULL;
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (rcu_free)
+		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
+}
+
+
+/* needed for kvfree_rcu_barrier() */
+void flush_all_rcu_sheaves()
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slub_flush_work *sfw;
+	struct kmem_cache *s;
+	bool flushed = false;
+	unsigned int cpu;
+
+	cpus_read_lock();
+	mutex_lock(&slab_mutex);
+
+	list_for_each_entry(s, &slab_caches, list) {
+		if (!s->cpu_sheaves)
+			continue;
+
+		mutex_lock(&flush_lock);
+
+		for_each_online_cpu(cpu) {
+			sfw = &per_cpu(slub_flush, cpu);
+			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
+
+			if (!pcs->rcu_free || !pcs->rcu_free->size) {
+				sfw->skip = true;
+				continue;
+			}
+
+			INIT_WORK(&sfw->work, flush_rcu_sheaf);
+			sfw->skip = false;
+			sfw->s = s;
+			queue_work_on(cpu, flushwq, &sfw->work);
+			flushed = true;
+		}
+
+		for_each_online_cpu(cpu) {
+			sfw = &per_cpu(slub_flush, cpu);
+			if (sfw->skip)
+				continue;
+			flush_work(&sfw->work);
+		}
+
+		mutex_unlock(&flush_lock);
+	}
+
+	mutex_unlock(&slab_mutex);
+	cpus_read_unlock();
+
+	if (flushed)
+		rcu_barrier();
+}
+
 /*
  * Use the cpu notifier to insure that the cpu slabs are flushed when
  * necessary.
@@ -5413,6 +5542,130 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
 	return true;
 }
 
+static void rcu_free_sheaf(struct rcu_head *head)
+{
+	struct slab_sheaf *sheaf;
+	struct node_barn *barn;
+	struct kmem_cache *s;
+
+	sheaf = container_of(head, struct slab_sheaf, rcu_head);
+
+	s = sheaf->cache;
+
+	/*
+	 * This may remove some objects due to slab_free_hook() returning false,
+	 * so that the sheaf might no longer be completely full. But it's easier
+	 * to handle it as full (unless it became completely empty), as the code
+	 * handles it fine. The only downside is that sheaf will serve fewer
+	 * allocations when reused. It only happens due to debugging, which is a
+	 * performance hit anyway.
+	 */
+	__rcu_free_sheaf_prepare(s, sheaf);
+
+	barn = get_node(s, numa_mem_id())->barn;
+
+	/* due to slab_free_hook() */
+	if (unlikely(sheaf->size == 0))
+		goto empty;
+
+	/*
+	 * Checking nr_full/nr_empty outside lock avoids contention in case the
+	 * barn is at the respective limit. Due to the race we might go over the
+	 * limit but that should be rare and harmless.
+	 */
+
+	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
+		stat(s, BARN_PUT);
+		barn_put_full_sheaf(barn, sheaf);
+		return;
+	}
+
+	stat(s, BARN_PUT_FAIL);
+	sheaf_flush_unused(s, sheaf);
+
+empty:
+	if (data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
+		barn_put_empty_sheaf(barn, sheaf);
+		return;
+	}
+
+	free_empty_sheaf(s, sheaf);
+}
+
+bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *rcu_sheaf;
+
+	if (!local_trylock(&s->cpu_sheaves->lock))
+		goto fail;
+
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (unlikely(!pcs->rcu_free)) {
+
+		struct slab_sheaf *empty;
+		struct node_barn *barn;
+
+		if (pcs->spare && pcs->spare->size == 0) {
+			pcs->rcu_free = pcs->spare;
+			pcs->spare = NULL;
+			goto do_free;
+		}
+
+		barn = get_barn(s);
+
+		empty = barn_get_empty_sheaf(barn);
+
+		if (empty) {
+			pcs->rcu_free = empty;
+			goto do_free;
+		}
+
+		local_unlock(&s->cpu_sheaves->lock);
+
+		empty = alloc_empty_sheaf(s, GFP_NOWAIT);
+
+		if (!empty)
+			goto fail;
+
+		if (!local_trylock(&s->cpu_sheaves->lock)) {
+			barn_put_empty_sheaf(barn, empty);
+			goto fail;
+		}
+
+		pcs = this_cpu_ptr(s->cpu_sheaves);
+
+		if (unlikely(pcs->rcu_free))
+			barn_put_empty_sheaf(barn, empty);
+		else
+			pcs->rcu_free = empty;
+	}
+
+do_free:
+
+	rcu_sheaf = pcs->rcu_free;
+
+	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
+
+	if (likely(rcu_sheaf->size < s->sheaf_capacity))
+		rcu_sheaf = NULL;
+	else
+		pcs->rcu_free = NULL;
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (rcu_sheaf)
+		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
+
+	stat(s, FREE_RCU_SHEAF);
+	return true;
+
+fail:
+	stat(s, FREE_RCU_SHEAF_FAIL);
+	return false;
+}
+
 /*
  * Bulk free objects to the percpu sheaves.
  * Unlike free_to_pcs() this includes the calls to all necessary hooks
@@ -6909,6 +7162,11 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	struct kmem_cache_node *n;
 
 	flush_all_cpus_locked(s);
+
+	/* we might have rcu sheaves in flight */
+	if (s->cpu_sheaves)
+		rcu_barrier();
+
 	/* Attempt to free all objects */
 	for_each_kmem_cache_node(s, node, n) {
 		if (n->barn)
@@ -8284,6 +8542,8 @@ STAT_ATTR(ALLOC_PCS, alloc_cpu_sheaf);
 STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
 STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
 STAT_ATTR(FREE_PCS, free_cpu_sheaf);
+STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
+STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
 STAT_ATTR(FREE_FROZEN, free_frozen);
@@ -8382,6 +8642,8 @@ static struct attribute *slab_attrs[] = {
 	&alloc_fastpath_attr.attr,
 	&alloc_slowpath_attr.attr,
 	&free_cpu_sheaf_attr.attr,
+	&free_rcu_sheaf_attr.attr,
+	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
 	&free_frozen_attr.attr,

-- 
2.51.0


