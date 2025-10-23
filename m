Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA1B0CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 369708E003A; Thu, 23 Oct 2025 09:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319418E0002; Thu, 23 Oct 2025 09:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2080B8E003A; Thu, 23 Oct 2025 09:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9208E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFB8813C12D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:44 +0000 (UTC)
X-FDA: 84029521968.21.72C5DE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C44C40011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227622; a=rsa-sha256;
	cv=none;
	b=hI2zNM92Id1TMeXHYsKkgCyBTjtLp8v0tV+0ZziXBRZE+1k/bRQznCnXda/oMIBqMCMZss
	aHYja/s0CPm1kGn0NkTB6GmAZ0cOpHMKSgNYg0qUf4MhXTEoCZ5JsZLeN41i3pHefscoyT
	jbfmY8Qi58shftEcOslKN+HSFo84G4Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FdsfcgWiQTdjWc+591nyXqsvmY3zD37UPWy6kdzpGKM=;
	b=d94lo2BQsL8uV0s6gmJeWlMsT2OTyhdtVFyMyr5+BAt3iXfRqPrxQs7hX8qv9aSOYGrcGD
	ArQh9Rd4XceFT8xvt1gCS07CwW1wqsfRr4GkN/jYy3ThhX6VHSvv4Z/aAs0723TEVn7yG4
	K6IsxWwxzrpRzwh79kB9ipQgKJvMLzM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AFC0F1F7CE;
	Thu, 23 Oct 2025 13:53:01 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BF88613B0F;
	Thu, 23 Oct 2025 13:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oPB8LjYz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:54 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 23 Oct 2025 15:52:39 +0200
Subject: [PATCH RFC 17/19] slab: refill sheaves from all nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-sheaves-for-all-v1-17-6ffa2c9941c0@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9C44C40011
X-Stat-Signature: uo916rrt96qmekc7te4j5g5bxyq3g9n3
X-HE-Tag: 1761227622-219673
X-HE-Meta: U2FsdGVkX1+ix05Q5bPDWhjMPz9xcP7X8onGsirK6msqPE98xT3xfvdVql/Aog8UZ7DASV6xojv0/X8NQ2v6Uh+iH2uVh169NHWN42gqno5hSHW0AODtJ9suNXACzELcfNeJORC/Q9iX8Z3mOpUvUUdNETQSuzdeXH5aXpNjbZA8mYI9ZYj1GmXkQRU5Ko9ZVPdOT4kMoVVqn4vb17g7pUUsqeNZxgDnkIAD5c2HcZIoIZwxmxdAHO2xArte++oFXY8Y8ipUWMLhyrstb7N93oGpNgLkJ6G1Kz/Az8OomD90sl4PGWIWq4s8VHiivKPBIClwq0S+ddRE7CUPJWZtOUV5deGcbwcKlLw33uNtryWj2dnfkCJYZlr0UzIm0MSYWi+KbYLSWVgHC1cc4MA86ltAwzI19lKJXtF9ArDDPAwyuhCSCArmA09pVGw245guz0kjdEd4TItKWyLK/xsV++/26tDYLycmlMWVd2x9qO61K5NQOQcnqLvGeIIuewv7IdwS2+bpPOyc5BllycSyLaG2geB88fg7eDJJ/ByZhw3bj5umMBbN2CmP0Yx8So9M09WWo3GBFhqc9zw2YZLkM7Dn3j+ZgOVgKG5aZNqaSc3AZxUnTeScLvdu4hUXe3zOZj5G3t73Ldd8+D4dS68A+fWInDh+Cs+sVzvaq+NO5poUL3BK4vLJjnK5oE1Sh8k48fPtVGuG5y8MhgwfZB6c92+HRTrWvofFgzb8Oay6JVl6a0itXpNS63ZthTAdCENhzfMZwtZBlz60F0GghK7GhG6kM18iBNk/aTPPCB6S8jDRaBspbTp4q4jLllaZdycfUSZvzXhfppTdGVj9+z4irl6od9rs3O4RetGn6v8dRG+ueEHVN2TZb1KoAZyaOC1CbzGAwvb39B8K745Ps7CXqw1klczQmvUlo0p8GVaj58VWvHZdUlK3mObJeViLapH3ggcafOH676LxHzoEjep
 Jkw8yiHh
 T+5AqgdXaRwOV5wWIg//Rhz68DsKsSC2RCt/Y5SzIXQ0oIYfAFZZ/gWRgXskfyizfJKjIcx78Gwt2Wl6Yg+N64WzO2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__refill_objects() currently only attempts to get partial slabs from the
local node and then allocates new slab(s). Expand it to trying also
other nodes while observing the remote node defrag ratio, similarly to
get_any_partial().

This will prevent allocating new slabs on a node while other nodes have
many free slabs. It does mean sheaves will contain non-local objects in
that case. Allocations that care about specific node will still be
served appropriately, but might get a slowpath allocation.

Like get_any_partial() we do observe cpuset_zone_allowed(), although we
might be refilling a sheaf that will be then used from a different
allocation context.

We can also use the resulting refill_objects() in
__kmem_cache_alloc_bulk() for non-debug caches. This means
kmem_cache_alloc_bulk() will get better performance when sheaves are
exhausted. kmem_cache_alloc_bulk() cannot indicate a preferred node so
it's compatible with sheaves refill in preferring the local node.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 130 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 102 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d55afa9b277f..4e003493ba60 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2505,8 +2505,8 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 }
 
 static unsigned int
-__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
-		 unsigned int max);
+refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+	       unsigned int max);
 
 static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 			 gfp_t gfp)
@@ -2517,8 +2517,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	if (!to_fill)
 		return 0;
 
-	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
-			to_fill, to_fill);
+	filled = refill_objects(s, &sheaf->objects[sheaf->size], gfp, to_fill,
+				to_fill);
 
 	sheaf->size += filled;
 
@@ -6423,25 +6423,21 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
 static unsigned int
-__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
-		 unsigned int max)
+__refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		      unsigned int max, struct kmem_cache_node *n)
 {
 	struct slab *slab, *slab2;
 	struct partial_context pc;
 	unsigned int refilled = 0;
 	unsigned long flags;
 	void *object;
-	int node;
 
 	pc.flags = gfp;
 	pc.min_objects = min;
 	pc.max_objects = max;
 
-	node = numa_mem_id();
-
-	/* TODO: consider also other nodes? */
-	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
-		goto new_slab;
+	if (!get_partial_node_bulk(s, n, &pc))
+		return 0;
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
@@ -6480,8 +6476,6 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	}
 
 	if (unlikely(!list_empty(&pc.slabs))) {
-		struct kmem_cache_node *n = get_node(s, node);
-
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
@@ -6503,13 +6497,91 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 		}
 	}
 
+	return refilled;
+}
 
-	if (likely(refilled >= min))
-		goto out;
+#ifdef CONFIG_NUMA
+static unsigned int
+__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		     unsigned int max, int local_node)
+{
+	struct zonelist *zonelist;
+	struct zoneref *z;
+	struct zone *zone;
+	enum zone_type highest_zoneidx = gfp_zone(gfp);
+	unsigned int cpuset_mems_cookie;
+	unsigned int refilled = 0;
+
+	/* see get_any_partial() for the defrag ratio description */
+	if (!s->remote_node_defrag_ratio ||
+			get_cycles() % 1024 > s->remote_node_defrag_ratio)
+		return 0;
+
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		zonelist = node_zonelist(mempolicy_slab_node(), gfp);
+		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
+			struct kmem_cache_node *n;
+			unsigned int r;
+
+			n = get_node(s, zone_to_nid(zone));
+
+			if (!n || !cpuset_zone_allowed(zone, gfp) ||
+					n->nr_partial <= s->min_partial)
+				continue;
+
+			r = __refill_objects_node(s, p, gfp, min, max, n);
+			refilled += r;
+
+			if (r >= min) {
+				/*
+				 * Don't check read_mems_allowed_retry() here -
+				 * if mems_allowed was updated in parallel, that
+				 * was a harmless race between allocation and
+				 * the cpuset update
+				 */
+				return refilled;
+			}
+			p += r;
+			min -= r;
+			max -= r;
+		}
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+	return refilled;
+}
+#else
+static inline unsigned int
+__refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		     unsigned int max, int local_node)
+{
+	return 0;
+}
+#endif
+
+static unsigned int
+refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+	       unsigned int max)
+{
+	int local_node = numa_mem_id();
+	unsigned int refilled;
+	unsigned long flags;
+	struct slab *slab;
+	void *object;
+
+	refilled = __refill_objects_node(s, p, gfp, min, max,
+					 get_node(s, local_node));
+	if (refilled >= min)
+		return refilled;
+
+	refilled += __refill_objects_any(s, p + refilled, gfp, min - refilled,
+					 max - refilled, local_node);
+	if (refilled >= min)
+		return refilled;
 
 new_slab:
 
-	slab = new_slab(s, pc.flags, node);
+	slab = new_slab(s, gfp, local_node);
 	if (!slab)
 		goto out;
 
@@ -6541,8 +6613,8 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 	if (refilled < min)
 		goto new_slab;
-out:
 
+out:
 	return refilled;
 }
 
@@ -6552,18 +6624,20 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 {
 	int i;
 
-	/*
-	 * TODO: this might be more efficient (if necessary) by reusing
-	 * __refill_objects()
-	 */
-	for (i = 0; i < size; i++) {
+	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		for (i = 0; i < size; i++) {
 
-		p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
-				     s->object_size);
-		if (unlikely(!p[i]))
-			goto error;
+			p[i] = ___slab_alloc(s, flags, NUMA_NO_NODE, _RET_IP_,
+					     s->object_size);
+			if (unlikely(!p[i]))
+				goto error;
 
-		maybe_wipe_obj_freeptr(s, p[i]);
+			maybe_wipe_obj_freeptr(s, p[i]);
+		}
+	} else {
+		i = refill_objects(s, p, flags, size, size);
+		if (i < size)
+			goto error;
 	}
 
 	return i;

-- 
2.51.1


