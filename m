Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B39C982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28AD6B00B3; Fri, 16 Jan 2026 09:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2DF06B00B5; Fri, 16 Jan 2026 09:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38326B00B3; Fri, 16 Jan 2026 09:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDF1E6B00B3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 909CD1ACF22
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:30 +0000 (UTC)
X-FDA: 84338090340.10.CAC6011
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DB8E40018
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqKnKi9p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uAKyVaD";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqKnKi9p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uAKyVaD";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWv/6dge7GPnKkYfY68/8ppGyOUqB4oP1/FkN30jYlE=;
	b=68BTMiVANF7ErhCsN1nJ+H3pR0EzaaouGQV7hrtIFrUwrT/2VHOe3lWpys/6XpadiIVNHE
	iwvnJ+lY1dhB/pytpMG62V2pgXp0oyilK3qG356YNncQmNIFg/aiGOLGZfXVbG9xQ5C2CC
	e+41m1mDZ/4RefvBZNhNnaoXXDOgCsk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqKnKi9p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uAKyVaD";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NqKnKi9p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/uAKyVaD";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574488; a=rsa-sha256;
	cv=none;
	b=J4MnW7Dzhgd9fWFyL3fG5a8JyRAdKA4myjdGIet9xmrcNDdlKUYX3K2kDo6HK4L44VfHqa
	k7Md1yzs1TGtCpNtawEHZwkBFTQJVCehFTtbKKhrhemMoEj7jp/qB72zvFuhdAwK+M+KLo
	Xv7aFEdTnP2wY0TLYmfYV2GDwbxhTqw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AF9B5BE96;
	Fri, 16 Jan 2026 14:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWv/6dge7GPnKkYfY68/8ppGyOUqB4oP1/FkN30jYlE=;
	b=NqKnKi9py3FdS+puS3vbjHRr0pap36Zbv0qGgawUzg42hRJj3SDPpyFMO+HaK0sEbf7NED
	CD7V234X9bYmp42R+dOEpQetnZUe5qzOAmYYB0aPsyolkopzHkTPGndzZuz75+bamrzt2g
	M35GT8ZOq5XxPkSOltJkIZoHjtWCVck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWv/6dge7GPnKkYfY68/8ppGyOUqB4oP1/FkN30jYlE=;
	b=/uAKyVaDwXT4/tjvvImd/aGmj8diFB4DiRJ04r1LGFutRARvNnKqkWrwpmi4zdskjL7zE8
	nqNM7CYQF7oaziAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWv/6dge7GPnKkYfY68/8ppGyOUqB4oP1/FkN30jYlE=;
	b=NqKnKi9py3FdS+puS3vbjHRr0pap36Zbv0qGgawUzg42hRJj3SDPpyFMO+HaK0sEbf7NED
	CD7V234X9bYmp42R+dOEpQetnZUe5qzOAmYYB0aPsyolkopzHkTPGndzZuz75+bamrzt2g
	M35GT8ZOq5XxPkSOltJkIZoHjtWCVck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574439;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yWv/6dge7GPnKkYfY68/8ppGyOUqB4oP1/FkN30jYlE=;
	b=/uAKyVaDwXT4/tjvvImd/aGmj8diFB4DiRJ04r1LGFutRARvNnKqkWrwpmi4zdskjL7zE8
	nqNM7CYQF7oaziAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E080B3EA63;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IGiCNuZNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:38 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:41 +0100
Subject: [PATCH v3 21/21] mm/slub: cleanup and repurpose some stat items
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-21-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: fgjxxhr5pugd69cg4tqx7rb8kdej9p4w
X-Rspamd-Queue-Id: 3DB8E40018
X-Rspamd-Server: rspam04
X-HE-Tag: 1768574487-898074
X-HE-Meta: U2FsdGVkX185qax5tww6mMBUDK2ybj4KRVhFWVi8GxNY5s9eG5ekLdG0/ndkOff0jXdh/dYzaUc3ZBf1obidID3OSdqujGhtOnK8EBZ3v0AmQpQjzLRFF4PsVjeYqvQ2qxswRsW5uNv0M5QKhHC15/LelbKQiRYVytHvNg6a+TNq2dXBP97hgGxlCQT0p89+YXNsLPthWGSQk8FRNUq6z45bBLvz+Vp0N3hXNEm4XmKH2ew3VTdG06NwIu0090SE2jSXvN5iDJgqXxPHjvs6TUp3zwTkMQ0Aa4IROM6Ap1qn2NdriORkM0mMRH5OuGP+TBH/eAFUgeEsntl89pytI/ZgPEt5JCg/IKJPYmaE2x8AJDYyfxf4vzyUgRXRGgsNcr3IphN2TMJnAXkzJELmJSyxoVYQiSTi2BNuTOnpJ4lNcFxH1WxC5uuXLhcRY30ceeyrmBGgpAm3xYoQoZ+LAx6zfFw8Qey7K7F2BpmgLMnR68w+9BnOdscDU39eIeZOzWeMs6ViXnZ45jVtOrkiIhRF4WEo9eXOlU6JcsYia+zWsStcWMQvqDDhdA0m6xBfsm20TfdMnpUsAJlKSV0ft4GfC1VUC5y/KSe674BhTQ90tvjM2fDOn4U7zoUwQpBfX4xzFtHUo9CjJG+/kMFFHj+DQGfqAPmOsINSBqbIfGkmeWc6v2bY7c6ymTcGRH4zSrrsPiE6MGQUcGVbwMjcOTMXfay9wDviJAQ7nWf8XOKSVWw+B6XlXpmaEKix/1tW9I9gAR8rdz1/P0/DEUua3Z4rUjXFFN+N6KF/ses5OO9OnS+Gz8+ehGx7nrpcEvHu+aiVVHo0LmBbN5m0NL5pn+tOyaONMYAIVHnpkUzkqzQR/QwnYHlQrzRSk842c5Bsgo94kv/B+rlzkOP3jcHdd0wzi8E0le54LifqLvzGdj7GR7gEi9hvPh08bURaP7kf5NPvbfLCzdlHTQuzgeP
 xlqXH7MR
 /uTJlTPpP7EwtaX2oaIjF8fTWLkT4xMFa6fA41W0PoVVQRiCe9cOea4T2A+JKsbY6EGLAzpoFpZVEpcyd5iJ7b5yTPkBYdFScozIv1gjRlgogkC4VkwtG9uTmeImnMy7/llKk1JzwvDEvavri47111z+V7uyY6/b/MVTsyFtqN7HkfiEqZRAsMjtdlEjkzh09ZVgmyvxeMujCsA4rhhdbrNNc2HdDVj6idmsh4ff5vEqlt0ghGz83OZSp1EwG8ZSshdZoopjJ6bbYyKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A number of stat items related to cpu slabs became unused, remove them.

Two of those were ALLOC_FASTPATH and FREE_FASTPATH. But instead of
removing those, use them instead of ALLOC_PCS and FREE_PCS, since
sheaves are the new (and only) fastpaths, Remove the recently added
_PCS variants instead.

Change where FREE_SLOWPATH is counted so that it only counts freeing of
objects by slab users that (for whatever reason) do not go to a percpu
sheaf, and not all (including internal) callers of __slab_free(). Thus
flushing sheaves (counted by SHEAF_FLUSH) no longer also increments
FREE_SLOWPATH. This matches how ALLOC_SLOWPATH doesn't count sheaf
refills (counted by SHEAF_REFILL).

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 77 +++++++++++++++++----------------------------------------------
 1 file changed, 21 insertions(+), 56 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c12e90cb2fca..d73ad44fa046 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -330,33 +330,19 @@ enum add_mode {
 };
 
 enum stat_item {
-	ALLOC_PCS,		/* Allocation from percpu sheaf */
-	ALLOC_FASTPATH,		/* Allocation from cpu slab */
-	ALLOC_SLOWPATH,		/* Allocation by getting a new cpu slab */
-	FREE_PCS,		/* Free to percpu sheaf */
+	ALLOC_FASTPATH,		/* Allocation from percpu sheaves */
+	ALLOC_SLOWPATH,		/* Allocation from partial or new slab */
 	FREE_RCU_SHEAF,		/* Free to rcu_free sheaf */
 	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
-	FREE_FASTPATH,		/* Free to cpu slab */
-	FREE_SLOWPATH,		/* Freeing not to cpu slab */
+	FREE_FASTPATH,		/* Free to percpu sheaves */
+	FREE_SLOWPATH,		/* Free to a slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
 	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
-	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from node partial list */
-	ALLOC_SLAB,		/* Cpu slab acquired from page allocator */
-	ALLOC_REFILL,		/* Refill cpu slab from slab freelist */
-	ALLOC_NODE_MISMATCH,	/* Switching cpu slab */
+	ALLOC_SLAB,		/* New slab acquired from page allocator */
+	ALLOC_NODE_MISMATCH,	/* Requested node different from cpu sheaf */
 	FREE_SLAB,		/* Slab freed to the page allocator */
-	CPUSLAB_FLUSH,		/* Abandoning of the cpu slab */
-	DEACTIVATE_FULL,	/* Cpu slab was full when deactivated */
-	DEACTIVATE_EMPTY,	/* Cpu slab was empty when deactivated */
-	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
-	DEACTIVATE_BYPASS,	/* Implicit deactivation */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
-	CMPXCHG_DOUBLE_CPU_FAIL,/* Failures of this_cpu_cmpxchg_double */
 	CMPXCHG_DOUBLE_FAIL,	/* Failures of slab freelist update */
-	CPU_PARTIAL_ALLOC,	/* Used cpu partial on alloc */
-	CPU_PARTIAL_FREE,	/* Refill cpu partial on free */
-	CPU_PARTIAL_NODE,	/* Refill cpu partial from node partial */
-	CPU_PARTIAL_DRAIN,	/* Drain cpu partial to node partial */
 	SHEAF_FLUSH,		/* Objects flushed from a sheaf */
 	SHEAF_REFILL,		/* Objects refilled to a sheaf */
 	SHEAF_ALLOC,		/* Allocation of an empty sheaf */
@@ -4347,8 +4333,10 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 	 * We assume the percpu sheaves contain only local objects although it's
 	 * not completely guaranteed, so we verify later.
 	 */
-	if (unlikely(node_requested && node != numa_mem_id()))
+	if (unlikely(node_requested && node != numa_mem_id())) {
+		stat(s, ALLOC_NODE_MISMATCH);
 		return NULL;
+	}
 
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return NULL;
@@ -4371,6 +4359,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 		 */
 		if (page_to_nid(virt_to_page(object)) != node) {
 			local_unlock(&s->cpu_sheaves->lock);
+			stat(s, ALLOC_NODE_MISMATCH);
 			return NULL;
 		}
 	}
@@ -4379,7 +4368,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	stat(s, ALLOC_PCS);
+	stat(s, ALLOC_FASTPATH);
 
 	return object;
 }
@@ -4451,7 +4440,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	stat_add(s, ALLOC_PCS, batch);
+	stat_add(s, ALLOC_FASTPATH, batch);
 
 	allocated += batch;
 
@@ -5111,8 +5100,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	unsigned long flags;
 	bool on_node_partial;
 
-	stat(s, FREE_SLOWPATH);
-
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
 		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
@@ -5416,7 +5403,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	stat(s, FREE_PCS);
+	stat(s, FREE_FASTPATH);
 
 	return true;
 }
@@ -5664,7 +5651,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-	stat_add(s, FREE_PCS, batch);
+	stat_add(s, FREE_FASTPATH, batch);
 
 	if (batch < size) {
 		p += batch;
@@ -5686,10 +5673,12 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	 */
 fallback:
 	__kmem_cache_free_bulk(s, size, p);
+	stat_add(s, FREE_SLOWPATH, size);
 
 flush_remote:
 	if (remote_nr) {
 		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+		stat_add(s, FREE_SLOWPATH, remote_nr);
 		if (i < size) {
 			remote_nr = 0;
 			goto next_remote_batch;
@@ -5784,6 +5773,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	}
 
 	__slab_free(s, slab, object, object, 1, addr);
+	stat(s, FREE_SLOWPATH);
 }
 
 #ifdef CONFIG_MEMCG
@@ -5806,8 +5796,10 @@ void slab_free_bulk(struct kmem_cache *s, struct slab *slab, void *head,
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt)))
+	if (likely(slab_free_freelist_hook(s, &head, &tail, &cnt))) {
 		__slab_free(s, slab, head, tail, cnt, addr);
+		stat_add(s, FREE_SLOWPATH, cnt);
+	}
 }
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -6705,6 +6697,7 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 		i = refill_objects(s, p, flags, size, size);
 		if (i < size)
 			goto error;
+		stat_add(s, ALLOC_SLOWPATH, i);
 	}
 
 	return i;
@@ -8704,33 +8697,19 @@ static ssize_t text##_store(struct kmem_cache *s,		\
 }								\
 SLAB_ATTR(text);						\
 
-STAT_ATTR(ALLOC_PCS, alloc_cpu_sheaf);
 STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
 STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
-STAT_ATTR(FREE_PCS, free_cpu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
-STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
-STAT_ATTR(ALLOC_REFILL, alloc_refill);
 STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
 STAT_ATTR(FREE_SLAB, free_slab);
-STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
-STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
-STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
-STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
-STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
-STAT_ATTR(CMPXCHG_DOUBLE_CPU_FAIL, cmpxchg_double_cpu_fail);
 STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
-STAT_ATTR(CPU_PARTIAL_ALLOC, cpu_partial_alloc);
-STAT_ATTR(CPU_PARTIAL_FREE, cpu_partial_free);
-STAT_ATTR(CPU_PARTIAL_NODE, cpu_partial_node);
-STAT_ATTR(CPU_PARTIAL_DRAIN, cpu_partial_drain);
 STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
 STAT_ATTR(SHEAF_REFILL, sheaf_refill);
 STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
@@ -8806,33 +8785,19 @@ static struct attribute *slab_attrs[] = {
 	&remote_node_defrag_ratio_attr.attr,
 #endif
 #ifdef CONFIG_SLUB_STATS
-	&alloc_cpu_sheaf_attr.attr,
 	&alloc_fastpath_attr.attr,
 	&alloc_slowpath_attr.attr,
-	&free_cpu_sheaf_attr.attr,
 	&free_rcu_sheaf_attr.attr,
 	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
-	&alloc_from_partial_attr.attr,
 	&alloc_slab_attr.attr,
-	&alloc_refill_attr.attr,
 	&alloc_node_mismatch_attr.attr,
 	&free_slab_attr.attr,
-	&cpuslab_flush_attr.attr,
-	&deactivate_full_attr.attr,
-	&deactivate_empty_attr.attr,
-	&deactivate_remote_frees_attr.attr,
-	&deactivate_bypass_attr.attr,
 	&order_fallback_attr.attr,
 	&cmpxchg_double_fail_attr.attr,
-	&cmpxchg_double_cpu_fail_attr.attr,
-	&cpu_partial_alloc_attr.attr,
-	&cpu_partial_free_attr.attr,
-	&cpu_partial_node_attr.attr,
-	&cpu_partial_drain_attr.attr,
 	&sheaf_flush_attr.attr,
 	&sheaf_refill_attr.attr,
 	&sheaf_alloc_attr.attr,

-- 
2.52.0


