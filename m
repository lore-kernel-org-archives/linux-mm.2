Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD596C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB406B00B6; Fri, 16 Jan 2026 09:41:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 389AC6B00B8; Fri, 16 Jan 2026 09:41:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7A56B00B9; Fri, 16 Jan 2026 09:41:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18EE46B00B6
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B89CF1A0159
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:40 +0000 (UTC)
X-FDA: 84338090760.19.C041F10
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72F4D140002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Umj/qy2M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MJUYj2s8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Umj/qy2M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MJUYj2s8;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYPFN/yW/JKvudjCCeDF8Mzn+JOB4FaaxcACY1SSQAU=;
	b=v1zwT1ILb6GaMM9NDgBhhDpBwEN0qgFHUYWakodp5p4QKMGasuC661niAMfVdalPZCHKQe
	Hc6ezJOwP3F3QCQ+Duia/tXBr8euiYf4lPaNlrUdXH1Gxp0UJw26o7uKF7huGeLAtu554o
	+mCSM77R3EAkm3VM0F80topae44rI34=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Umj/qy2M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MJUYj2s8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Umj/qy2M";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MJUYj2s8;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574498; a=rsa-sha256;
	cv=none;
	b=Ecmpv/NGeIsS1SELNKOJEE2kzs256QU31N7hKrlpm/BZw2JRVpYf55OSsMB++mbhGh/djG
	9G+CLexTPMz+Vpzqe0Elp6NV57Twrt7c0ds57pFOoov/moHUCyv5YNgyfou4rRTDrlpTkK
	lFcWplu5Hnf0/88hiNQECnt8ROZZ2YM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 822D6337D7;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYPFN/yW/JKvudjCCeDF8Mzn+JOB4FaaxcACY1SSQAU=;
	b=Umj/qy2MtjJqJS5BFPaleWC/Vag7s20UXJBVp0xP2nbaR/cJXU1fhw8cG7NpztaSObd3nd
	vLa9WafVlZNBmG+XKu/iPnlRY94mxK/J89LQvzV7juxZrE7pbZ8dn0StDtfjiGeljo0I2V
	1g6rFa2I2P5bWxyYFssckucwK6dnJj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYPFN/yW/JKvudjCCeDF8Mzn+JOB4FaaxcACY1SSQAU=;
	b=MJUYj2s82y1Z/ZXm7D/b+gwMsPyZV2aZmisTd7uY3TLeP/VOPRqk2S3fJG92/Fl6I7CtIb
	5PpeMWqHPVlaScDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYPFN/yW/JKvudjCCeDF8Mzn+JOB4FaaxcACY1SSQAU=;
	b=Umj/qy2MtjJqJS5BFPaleWC/Vag7s20UXJBVp0xP2nbaR/cJXU1fhw8cG7NpztaSObd3nd
	vLa9WafVlZNBmG+XKu/iPnlRY94mxK/J89LQvzV7juxZrE7pbZ8dn0StDtfjiGeljo0I2V
	1g6rFa2I2P5bWxyYFssckucwK6dnJj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYPFN/yW/JKvudjCCeDF8Mzn+JOB4FaaxcACY1SSQAU=;
	b=MJUYj2s82y1Z/ZXm7D/b+gwMsPyZV2aZmisTd7uY3TLeP/VOPRqk2S3fJG92/Fl6I7CtIb
	5PpeMWqHPVlaScDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 66D243EA65;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WHXYGOZNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:38 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:37 +0100
Subject: [PATCH v3 17/21] slab: refill sheaves from all nodes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-17-5595cb000772@suse.cz>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 72F4D140002
X-Stat-Signature: 4n9omephgtcbf91m4r7wzgmkjjwsahjw
X-HE-Tag: 1768574498-520997
X-HE-Meta: U2FsdGVkX1/K92dc5g6W3xh4nQj/tVoN6b5CPE4WvK0/ZL3B5XEN2b6Uir3C1t08PUAkl+uOa6xLAC3juKEnItqiaPU+plSWS73eFdIe8PENwcezGnMql3W21Oz6wk+HH2Wu761BNda6MKvvZ5MA+hVNhVFbBKgGT9dY+WAQcQL1OXeWsjo5KrgUCYyjsBfLZE/+HT4oGX+Wd46elQhFRilfnPRrX05JNSR31fOlr53pQwkWKHFqmIq47yT/dK1+AFrqyTeiJUPRkiasvmkWfqWbhII8tJdng/iKDe5r+GHTB1Sh06TSecsBLhPwiZ3+pd2I/9b3k9TjcLEDmG9rg0OWQQ0ZFaQ9Dzwdhmj/l2Qjrq9X6i91f0C8aRu66QrTXEuHMxxq65uzyUhpBetvvHgCclqmPJ00E5rmmEJ0ck0kYS+rIA9qPZBHo58VOjfh8Cba+QSz8ZY/sh1cI6QPWSHCWDZKI0JBm9OldroCuO7rCDBqST6IKLZSSyD09Nxl1xGhoSV9YWn6ZQkjzl72K/Zwd+FFaQomLxuCbS/Uq9UWLcAwS2GECGsDM9R0XIoXTwO6K5Mq9e8PCMZjWpHddRSZQkHIB+L2NuX0pWA3NZML4zJUnxqxGMbmvVVFbgNj9+P1wNiAtEGihF7VhzkqpvV0iwsz467XxT/+eK2HMo7jiqC9WGkf7QytMXwtNlQFM9HpAxFCS7YiRgxoN0UZrax41AM6E9XuTfefvZBRBpB8CE0JOO371REJWkd6kq6sjjl7rM6HY9iAfMsaM3FLL/BwcetAR2jKO4YG1RuzYQBVanaaDdAlK0Zx6z2bYZcETGz+211+PDfN6+KN4iBLLaX4H/cMAIPfZqRIRKJS13CuDl767Nn2+C68U/RySB2xNcGArG5ZZyJ8JRdmOI1IDPRfWP0HZRMTWZBNer4Ddb0gZoWjz4i2tAgRnAbkFIKrt5qGOg2JwR6kFB7r7xb
 XBZHKwug
 L4muPYvqIIs74VizkjZ07RpR46laNX2O8O+xowx8d74u7LJNoyBs5ghcFyJzp2cCkMVwf37hziG+w0rmqcz7TfFErW6JhbgXeOop+afH08Iavc36iJmSbx1UXuJ6EhSLnErXkbvftFW/WW1bGmKjJ8mVeITP7vgOQuKpbtnQCF+QtwWrE/ymGNmc0CsO6jMD/siHzLHHFSYYmARZwBRWNE93ddBjzMvNybuKvPZCLuUZcD0ubmEEy668s7oEtZDJRtUCx1adhT8cYy6gQGasoUbSlBA==
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
Its users also have gfp flags that allow spinning, so document that
as a requirement.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 137 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 106 insertions(+), 31 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d52de6e3c2d5..2c522d2bf547 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2518,8 +2518,8 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 }
 
 static unsigned int
-__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
-		 unsigned int max);
+refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+	       unsigned int max);
 
 static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 			 gfp_t gfp)
@@ -2530,8 +2530,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	if (!to_fill)
 		return 0;
 
-	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
-			to_fill, to_fill);
+	filled = refill_objects(s, &sheaf->objects[sheaf->size], gfp, to_fill,
+				to_fill);
 
 	sheaf->size += filled;
 
@@ -6522,29 +6522,22 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
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
-	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
+	if (!get_partial_node_bulk(s, n, &pc))
 		return 0;
 
-	/* TODO: consider also other nodes? */
-	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
-		goto new_slab;
-
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
 
 		list_del(&slab->slab_list);
@@ -6582,8 +6575,6 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 	}
 
 	if (unlikely(!list_empty(&pc.slabs))) {
-		struct kmem_cache_node *n = get_node(s, node);
-
 		spin_lock_irqsave(&n->list_lock, flags);
 
 		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
@@ -6605,13 +6596,92 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
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
+	struct slab *slab;
+
+	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
+		return 0;
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
 
@@ -6626,8 +6696,8 @@ __refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 	if (refilled < min)
 		goto new_slab;
-out:
 
+out:
 	return refilled;
 }
 
@@ -6637,18 +6707,20 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
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
@@ -6659,7 +6731,10 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 
 }
 
-/* Note that interrupts must be enabled when calling this function. */
+/*
+ * Note that interrupts must be enabled when calling this function and gfp
+ * flags must allow spinning.
+ */
 int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 				 void **p)
 {

-- 
2.52.0


