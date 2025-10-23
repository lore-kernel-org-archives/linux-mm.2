Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38235CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8991F8E003D; Thu, 23 Oct 2025 09:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ADAD8E0002; Thu, 23 Oct 2025 09:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6762C8E003D; Thu, 23 Oct 2025 09:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AB758E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C9ACC0B68
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:54 +0000 (UTC)
X-FDA: 84029522388.16.3574E5F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id CF02540005
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WGt9KBeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASlRiBUD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RnNG/pQ0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R6CIlun1;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TM6deDozNl3p401cZo7KYCMKkhM0vweS25W/XL8gDI0=;
	b=6LLpqEzKyhaRdqVt5GDRhBlBcKNLDoPsqx8otCX5Jbv7gbqHqMdQOLTpjH06oyPaSLcYJD
	RR4vylgu52QsqY/0X//R/vIE4lgHX7foLgV0w6bADsTCEWqtr7/ZdSVBVobgBYjMovZmva
	9SxeoinKqcUWHBh8C9ts9GwbEsMY+Co=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=WGt9KBeH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ASlRiBUD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="RnNG/pQ0";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R6CIlun1;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227632; a=rsa-sha256;
	cv=none;
	b=gkDRRG8uQOEIVT4jg9voLGebj0NjgpPsKPYGjXL2U8rBjCekjLQ/AfUllnVVoBtYtNvLB7
	gQ7Q9XVyfaElmdGycJ4JGp34ljMe80rCwnGYnOGAqk5C/kR3ElhrszmopPp05aU7m3/GyD
	vmrtZ5eHntoZrjyU6yUFICeuooNo6Bc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 83BEC211A7;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TM6deDozNl3p401cZo7KYCMKkhM0vweS25W/XL8gDI0=;
	b=WGt9KBeHLNEJhR0pkdggJq5D06VHO+vUJd/+zlYtbYC/hLjkrL9waybo9KzusaLOV30+up
	h0ppuBamOMhhr/ibrK0vafuBuuNTh4JBwE5NLv3ptldgmbyGt1S4VITlmroaz9a1NUEb04
	VxiE/9U1rOP7Z/4Gmrh4N/3ddmkYRYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TM6deDozNl3p401cZo7KYCMKkhM0vweS25W/XL8gDI0=;
	b=ASlRiBUDoL2V6C54X57YwDjt2oaN+oa+h6zVBWAcQSsXEAOQHkSgcgF2CkXmyFixs77hfi
	zWVnmfDJlXjb+pDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TM6deDozNl3p401cZo7KYCMKkhM0vweS25W/XL8gDI0=;
	b=RnNG/pQ0vzl0sM0FAdWm0i4ru5HeHGzPOQEm4eqMmiYA4urOAFyyDFEYCixMFpUv4K8umi
	pyKARBeLgq+L6mDQ6mLTQHQqNfzlrcxumnTMNRXXSxxPm6VtMr1exHBzkxzNNSIodhW/w6
	ZVju8AhYVq+pHSLclJw8MgxjXBlkIhI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TM6deDozNl3p401cZo7KYCMKkhM0vweS25W/XL8gDI0=;
	b=R6CIlun11fcNMuKztJKkMR36Pw86ENF7NtmWJO9i36xsaKFSvpSd/epjhG+/gYhZjnsq8P
	PfmzZ9Th17+p6iBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBA9A13B07;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mHRZNTUz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:31 +0200
Subject: [PATCH RFC 09/19] slab: add optimized sheaf refill from partial
 list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-9-6ffa2c9941c0@suse.cz>
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: CF02540005
X-Rspamd-Server: rspam03
X-Stat-Signature: mfxwc6ggzqgurdiyjcmrinxhap4sn49t
X-HE-Tag: 1761227631-194486
X-HE-Meta: U2FsdGVkX19IHxe3DIxYtiYiR+epICHzt3KhVckc4CibdpMTg/kmH0UGQRhqJLRVHa8+SpHwxg8K2rrfcEV0cYfykoZQ6DYSvyhbpjEUEBXiTFDr3jRamlYKZ9tea3Sss9FbEYDWqT+YaSHb+ov6sXtBz3/RZh+TGki+GeOmrNio8TCERO5OKasNAol+7EBS1ovjdpwiZR3Qiz8sjRxbEJq32oCxszjcsiVQbd8mwT2naneZ8MdC7Uce/lVuzoiF93nxTOjEqTr1l3mafMYb3LQZcjHVe0eIXmEAVK9YS7bvxykI4Ff8nEBIEpvuy9eixlg3juwgb1dtxtxUQvlE2mzQ3v30c/ZXfAuCi5ndI4sZQ22kp+6K8ddd5ejL+YJ8tFW2CGItJthSxtSXMY6LaRDuzKgOlaspUXH0P6YQVQZcHQIPSa/2O91HG2gFdK+51G09bAJzl6qR6u6QH7nGAw4DFjNVT8xhjCLc/MkzplI6fNv944hHhjcLgWWXFXs+Kfj3zt9Ojp8LeSTZ1C/D3aFWCVHjO2cLad+T4FkrtLgq0PJeV7nNT1OXXUrx3pLsAGIExNaOspuMi5anVwE8dkCvw4uYs/GBqv2sHQhmpm5yq2aV25CgIBCsjXAPoAh649PvSVQw8WtarTxUPVmPs/IxkPMGEZl9cX9kBpElbAeu49a23Kb9h+GslIx0sJAQ4jJgi1DQ3YX//Ws+w4FsO7dCbZktFC2eU0IrsdQGCl00YXrDR4qe6f8pjSv6+qVOm9dg8xHIPSwdo0N8tI1a8YOXVi9ytAQi4/U78RZA71g6E+BJ5/tiGeaJr9MSc4QLKi94aRHM5EqmcF0VBLwaNz0QJVYNxOXw1VTirmJycv0NnpoNpPYn3rste0UWw6WAS3tl6qs7/dzj4D7gMayTnP/BMM0w2xeGizg1ezqKMeutPrnJS+9Gvwwv1EYZ7XTStOhl04V35/lRXVdRLE1
 jvFe8IuI
 ff3p6FLBg6q6p+yDmnMteQQolTfq2ls4oIrh+2BF07bKHsnnbe2JNqrGXdny9LwOQbMXlFqK4KpKZBKqnVUXKQ/RaSWS7q2VtkKSzqNlrNQ6yjudpz+V4mlwCz61djg8SaIRwSIeqDia4ggmZht+nBC9oH/B8kxwM8qc2RxhvH/VDwZe/8/rLzFEMaz6SQdNydTqgexh8ean1e6QQ3a/flwvBJq4xHL+zP73QB9NOe8vTxqy7NQMyxv2jEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point we have sheaves enabled for all caches, but their refill
is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
slabs - now a redundant caching layer that we are about to remove.

The refill will thus be done from slabs on the node partial list.
Introduce new functions that can do that in an optimized way as it's
easier than modifying the __kmem_cache_alloc_bulk() call chain.

Extend struct partial_context so it can return a list of slabs from the
partial list with the sum of free objects in them within the requested
min and max.

Introduce get_partial_node_bulk() that removes the slabs from freelist
and returns them in the list.

Introduce get_freelist_nofreeze() which grabs the freelist without
freezing the slab.

Introduce __refill_objects() that uses the functions above to fill an
array of objects. It has to handle the possibility that the slabs will
contain more objects that were requested, due to concurrent freeing of
objects to those slabs. When no more slabs on partial lists are
available, it will allocate new slabs.

Finally, switch refill_sheaf() to use __refill_objects().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 235 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 230 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a84027fbca78..e2b052657d11 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -246,6 +246,9 @@ struct partial_context {
 	gfp_t flags;
 	unsigned int orig_size;
 	void *object;
+	unsigned int min_objects;
+	unsigned int max_objects;
+	struct list_head slabs;
 };
 
 static inline bool kmem_cache_debug(struct kmem_cache *s)
@@ -2633,9 +2636,9 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	stat(s, SHEAF_FREE);
 }
 
-static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
-				   size_t size, void **p);
-
+static unsigned int
+__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		 unsigned int max);
 
 static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 			 gfp_t gfp)
@@ -2646,8 +2649,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	if (!to_fill)
 		return 0;
 
-	filled = __kmem_cache_alloc_bulk(s, gfp, to_fill,
-					 &sheaf->objects[sheaf->size]);
+	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
+			to_fill, to_fill);
 
 	sheaf->size += filled;
 
@@ -3508,6 +3511,69 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
 #endif
 static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
+static bool get_partial_node_bulk(struct kmem_cache *s,
+				  struct kmem_cache_node *n,
+				  struct partial_context *pc)
+{
+	struct slab *slab, *slab2;
+	unsigned int total_free = 0;
+	unsigned long flags;
+
+	/*
+	 * Racy check. If we mistakenly see no partial slabs then we
+	 * just allocate an empty slab. If we mistakenly try to get a
+	 * partial slab and there is none available then get_partial()
+	 * will return NULL.
+	 */
+	if (!n || !n->nr_partial)
+		return false;
+
+	INIT_LIST_HEAD(&pc->slabs);
+
+	if (gfpflags_allow_spinning(pc->flags))
+		spin_lock_irqsave(&n->list_lock, flags);
+	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+		return false;
+
+	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
+		struct slab slab_counters;
+		unsigned int slab_free;
+
+		if (!pfmemalloc_match(slab, pc->flags))
+			continue;
+
+		/*
+		 * due to atomic updates done by a racing free we should not
+		 * read garbage here, but do a sanity check anyway
+		 *
+		 * slab_free is a lower bound due to subsequent concurrent
+		 * freeing, the caller might get more objects than requested and
+		 * must deal with it
+		 */
+		slab_counters.counters = data_race(READ_ONCE(slab->counters));
+		slab_free = slab_counters.objects - slab_counters.inuse;
+
+		if (unlikely(slab_free > oo_objects(s->oo)))
+			continue;
+
+		/* we have already min and this would get us over the max */
+		if (total_free >= pc->min_objects
+		    && total_free + slab_free > pc->max_objects)
+			continue;
+
+		remove_partial(n, slab);
+
+		list_add(&slab->slab_list, &pc->slabs);
+
+		total_free += slab_free;
+		if (total_free >= pc->max_objects)
+			break;
+	}
+
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return total_free > 0;
+}
+
 /*
  * Try to allocate a partial slab from a specific node.
  */
@@ -4436,6 +4502,38 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 	return freelist;
 }
 
+/*
+ * Get the slab's freelist and do not freeze it.
+ *
+ * Assumes the slab is isolated from node partial list and not frozen.
+ *
+ * Assumes this is performed only for caches without debugging so we
+ * don't need to worry about adding the slab to the full list
+ */
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+{
+	struct slab new;
+	unsigned long counters;
+	void *freelist;
+
+	do {
+		freelist = slab->freelist;
+		counters = slab->counters;
+
+		new.counters = counters;
+		VM_BUG_ON(new.frozen);
+
+		new.inuse = slab->objects;
+		new.frozen = 0;
+
+	} while (!slab_update_freelist(s, slab,
+		freelist, counters,
+		NULL, new.counters,
+		"get_freelist_nofreeze"));
+
+	return freelist;
+}
+
 /*
  * Freeze the partial slab and return the pointer to the freelist.
  */
@@ -5373,6 +5471,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	return ret;
 }
 
+static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
+				   size_t size, void **p);
+
 /*
  * returns a sheaf that has at least the requested size
  * when prefilling is needed, do so with given gfp flags
@@ -7409,6 +7510,130 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
+static unsigned int
+__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		 unsigned int max)
+{
+	struct slab *slab, *slab2;
+	struct partial_context pc;
+	unsigned int refilled = 0;
+	unsigned long flags;
+	void *object;
+	int node;
+
+	pc.flags = gfp;
+	pc.min_objects = min;
+	pc.max_objects = max;
+
+	node = numa_mem_id();
+
+	/* TODO: consider also other nodes? */
+	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
+		goto new_slab;
+
+	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+		list_del(&slab->slab_list);
+
+		object = get_freelist_nofreeze(s, slab);
+
+		while (object && refilled < max) {
+			p[refilled] = object;
+			object = get_freepointer(s, object);
+			maybe_wipe_obj_freeptr(s, p[refilled]);
+
+			refilled++;
+		}
+
+		/*
+		 * Freelist had more objects than we can accomodate, we need to
+		 * free them back. We can treat it like a detached freelist, just
+		 * need to find the tail object.
+		 */
+		if (unlikely(object)) {
+			void *head = object;
+			void *tail;
+			int cnt = 0;
+
+			do {
+				tail = object;
+				cnt++;
+				object = get_freepointer(s, object);
+			} while (object);
+			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
+		}
+
+		if (refilled >= max)
+			break;
+	}
+
+	if (unlikely(!list_empty(&pc.slabs))) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
+				continue;
+
+			list_del(&slab->slab_list);
+			add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		}
+
+		spin_unlock_irqrestore(&n->list_lock, flags);
+
+		/* any slabs left are completely free and for discard */
+		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+			list_del(&slab->slab_list);
+			discard_slab(s, slab);
+		}
+	}
+
+
+	if (likely(refilled >= min))
+		goto out;
+
+new_slab:
+
+	slab = new_slab(s, pc.flags, node);
+	if (!slab)
+		goto out;
+
+	stat(s, ALLOC_SLAB);
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
+
+	/*
+	 * TODO: possible optimization - if we know we will consume the whole
+	 * slab we might skip creating the freelist?
+	 */
+	object = slab->freelist;
+	while (object && refilled < max) {
+		p[refilled] = object;
+		object = get_freepointer(s, object);
+		maybe_wipe_obj_freeptr(s, p[refilled]);
+
+		slab->inuse++;
+		refilled++;
+	}
+	slab->freelist = object;
+
+	if (slab->freelist) {
+		struct kmem_cache_node *n = get_node(s, slab_nid(slab));
+
+		spin_lock_irqsave(&n->list_lock, flags);
+		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	if (refilled < min)
+		goto new_slab;
+out:
+
+	return refilled;
+}
+
 static inline
 int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			    void **p)

-- 
2.51.1


