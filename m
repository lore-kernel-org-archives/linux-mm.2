Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFAFC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC52D6B00E3; Wed, 23 Jul 2025 09:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B737E6B00E4; Wed, 23 Jul 2025 09:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3D9B6B00E5; Wed, 23 Jul 2025 09:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8900B6B00E3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10A851A0621
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:44 +0000 (UTC)
X-FDA: 83695627008.01.7B2277A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id D86BF1C0011
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ac//nzqZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uIY0+D3R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ac//nzqZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uIY0+D3R;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xx1ef+51dA8FUNwEKzJAep3O9/h2Ns+stsV3pscdNoI=;
	b=mDBHOkP22VkCPr1AWQYFEalboWipoJnXHBgd4EQrB4xb/jDDoQlSqT29ShlqyKJVG2brVk
	YWa6UlMiOWZtCthd1TfpzjXdxdS53M0PLn2fOb/q2+sdeGHuAcame1V/71sAAsvdYc31JP
	TuZ0/h/6cwjMbSfinACN5MvFGigUUr4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ac//nzqZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uIY0+D3R;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="ac//nzqZ";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uIY0+D3R;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277742; a=rsa-sha256;
	cv=none;
	b=tWuUXuCDPQ4sfAjw/z5QD8LcF812bqS6D2He3rAg//2urDXU9p3xC14eBcC5NPq1p+4WME
	1Mmzx9yVmzkmIIKmefxOs6lFPCwsPFt3s/Dg5ePP+c2BdVlUc6yIqyQWyS21TXt8nagsGC
	h/3nSxgpWZUUWisDxolJLwOhR6JmL6k=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8FFEC1F793;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx1ef+51dA8FUNwEKzJAep3O9/h2Ns+stsV3pscdNoI=;
	b=ac//nzqZhn5GVqCvO6Wl9B+zJ3xm92fWBlCmqfGlFAX6d4dQnif4NgHOySxICkO/ZuMGLB
	xt4nEVAPg47fzE1xnq2u1bYu5eZWB7wqQ5BQjqjSNl4Beg0RY3iu4fjjjW2RNKIjnVkmUx
	WnFMxzzVxzhn39bXqr/dtiotEGIZqjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx1ef+51dA8FUNwEKzJAep3O9/h2Ns+stsV3pscdNoI=;
	b=uIY0+D3RMIzg9fp1EL0Jg+kkqIX+hqQi29BGGg8gk1rjf0FrzMua/5Xnko2j1n1bjgCMMK
	h7l1g0MyEiyHCiDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx1ef+51dA8FUNwEKzJAep3O9/h2Ns+stsV3pscdNoI=;
	b=ac//nzqZhn5GVqCvO6Wl9B+zJ3xm92fWBlCmqfGlFAX6d4dQnif4NgHOySxICkO/ZuMGLB
	xt4nEVAPg47fzE1xnq2u1bYu5eZWB7wqQ5BQjqjSNl4Beg0RY3iu4fjjjW2RNKIjnVkmUx
	WnFMxzzVxzhn39bXqr/dtiotEGIZqjY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xx1ef+51dA8FUNwEKzJAep3O9/h2Ns+stsV3pscdNoI=;
	b=uIY0+D3RMIzg9fp1EL0Jg+kkqIX+hqQi29BGGg8gk1rjf0FrzMua/5Xnko2j1n1bjgCMMK
	h7l1g0MyEiyHCiDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7872E13AFA;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNwiHQjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:42 +0200
Subject: [PATCH v5 09/14] mm, slub: skip percpu sheaves for remote object
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-9-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Queue-Id: D86BF1C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: kp7teau5dh76jbkiokrdirh7ukenxnyo
X-HE-Tag: 1753277741-209497
X-HE-Meta: U2FsdGVkX1/qv92XB02ulMf3zlLFvZjrXnnRka+O6eCRoJshRLCV9W+BksSbW8GqQC2SAxKn/967u9qfnbEwXwUb+XSM8EJuB/IQ8xOZRSzpqOoc+GsszwRzLAzJq7+Iz8lWVUQbHdKQBorg4aUnpXStFDjj9teIx6L7QjlSOuIWZsfUALBSgSsqHhNQ1OAEkZfg63PqTD5R8UHEM5Np1qUzVLuubLNRDbRO8ux/lnVCZo2DznyOOyQ5xEk+trpFYXN6xkmRCaGhLGJrSWlLKYMmLew0QUq0kn+fzBc2TVYYxiuFB7VqVT6WosiK9WJ77oMIOhV8zrsAd0vId/ytbSOJo8TX48Wa34cyB6aVw/XWLvX/rGS4gvbnc1YOwA2b6H3J/KFjXbPh8ayJ3nlWHuOZvJTftLe6mxRAZ1FQkUYIfV9hQIjcjWiWxRUcWdzgsvMXOMcYy0EscS3DiOP/I+cCvjhSM9z+uSRirU2cQp4V+NnUx58Gy7QcrcmkZyOGuKwQl6lCg0lG2bZrGa0Mh4c5Mv0uD2wJ2E57PXeJ6Ol1LHmbuB1QJR5hypPMjxZRMc8WDijuvVnjWGvBXOxvOkJctYUKQpAdp+2fvByM9qesLjYPHlOekF98m+EQ8L+zBFM8qrVqUkUINxnkGBSY+JVB+lWLT+NcAr0sTyXMYqSCGBn20k1yf9smFwtl72hXpwAUqwY6UXRDr6KllibRpBRHrZ2xwzhlGt6ABPeCii3gW44OoQGxFLw8okvZNJmwPM0xM0zGiVanZG7KV7jEMYGQJNKFg8xUdEtZyqZNCkflSxQZhgTHWpDnowKKmxugVWnXYA8IHfJPy4N8QNJmFCL9kDPNGxI8gqXOWmb1ntAKlvwcYWl7tkY9qJvQN8VudEQQWZ7TeZnVvwc1M2JFLmpXBkoOQXEijT9fK94vkuYM7Pqy3R8YqpM69Ba4T7B7Gvfclm8+PftxDXMSCHN
 aSavG511
 biY+yYyIOD4V4E+LsSzioXSjtUGTp/BkbQFRpTTMrQSPqIw30GjhJlak0DRQm5ODo+FacDuuF/F7HLOUVDl5UW33J8ISf0fTDPjF+5XLhunleYuFp07ZawKXF7xiXt9H76WM1i9VvsR5el424DCXp7LVlX2bEHKWCeaYFlakz+KBtl6gLJiVZNYR1k5dfLRqurCpv3VG9QaeCliJUnI/b0dk/A1o/lZtdK8x0VnmdXV+3T6RSZbaQTMH+kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we don't control the NUMA locality of objects in percpu sheaves,
allocations with node restrictions bypass them. Allocations without
restrictions may however still expect to get local objects with high
probability, and the introduction of sheaves can decrease it due to
freed object from a remote node ending up in percpu sheaves.

The fraction of such remote frees seems low (5% on an 8-node machine)
but it can be expected that some cache or workload specific corner cases
exist. We can either conclude that this is not a problem due to the low
fraction, or we can make remote frees bypass percpu sheaves and go
directly to their slabs. This will make the remote frees more expensive,
but if if's only a small fraction, most frees will still benefit from
the lower overhead of percpu sheaves.

This patch thus makes remote object freeing bypass percpu sheaves,
including bulk freeing, and kfree_rcu() via the rcu_free sheaf. However
it's not intended to be 100% guarantee that percpu sheaves will only
contain local objects. The refill from slabs does not provide that
guarantee in the first place, and there might be cpu migrations
happening when we need to unlock the local_lock. Avoiding all that could
be possible but complicated so we can leave it for later investigation
whether it would be worth it. It can be expected that the more selective
freeing will itself prevent accumulation of remote objects in percpu
sheaves so any such violations would have only short-term effects.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c |  7 +++++--
 mm/slub.c        | 42 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2d806e02568532a1000fd3912db6978e945dcfa8..f466f68a5bd82030a987baf849a98154cd48ef23 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1623,8 +1623,11 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	slab = folio_slab(folio);
 	s = slab->slab_cache;
-	if (s->cpu_sheaves)
-		return __kfree_rcu_sheaf(s, obj);
+	if (s->cpu_sheaves) {
+		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
+			   slab_nid(slab) == numa_node_id()))
+			return __kfree_rcu_sheaf(s, obj);
+	}
 
 	return false;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 339d91c6ea29be99a14a8914117fab0e3e6ed26b..50fc35b8fc9b3101821c338e9469c134677ded51 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -455,6 +455,7 @@ struct slab_sheaf {
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
+	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
 
@@ -5682,7 +5683,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 */
 	__rcu_free_sheaf_prepare(s, sheaf);
 
-	barn = get_node(s, numa_mem_id())->barn;
+	barn = get_node(s, sheaf->node)->barn;
 
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
@@ -5765,10 +5766,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
 	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
 
-	if (likely(rcu_sheaf->size < s->sheaf_capacity))
+	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
-	else
+	} else {
 		pcs->rcu_free = NULL;
+		rcu_sheaf->node = numa_mem_id();
+	}
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -5794,7 +5797,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	struct slab_sheaf *main, *empty;
 	bool init = slab_want_init_on_free(s);
 	unsigned int batch, i = 0;
+	void *remote_objects[PCS_BATCH_MAX];
+	unsigned int remote_nr = 0;
+	int node = numa_mem_id();
 
+next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -5804,7 +5811,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
 			p[i] = p[--size];
 			if (!size)
-				return;
+				goto flush_remote;
+			continue;
+		}
+
+		if (unlikely(IS_ENABLED(CONFIG_NUMA) && slab_nid(slab) != node)) {
+			remote_objects[remote_nr] = p[i];
+			p[i] = p[--size];
+			if (++remote_nr >= PCS_BATCH_MAX)
+				goto flush_remote;
 			continue;
 		}
 
@@ -5872,6 +5887,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	 */
 fallback:
 	__kmem_cache_free_bulk(s, size, p);
+
+flush_remote:
+	if (remote_nr) {
+		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+		if (i < size) {
+			remote_nr = 0;
+			goto next_remote_batch;
+		}
+	}
 }
 
 #ifndef CONFIG_SLUB_TINY
@@ -5963,8 +5987,14 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		return;
 
-	if (!s->cpu_sheaves || !free_to_pcs(s, object))
-		do_slab_free(s, slab, object, object, 1, addr);
+	if (s->cpu_sheaves && likely(!IS_ENABLED(CONFIG_NUMA) ||
+				     slab_nid(slab) == numa_mem_id())) {
+		if (likely(free_to_pcs(s, object))) {
+			return;
+		}
+	}
+
+	do_slab_free(s, slab, object, object, 1, addr);
 }
 
 #ifdef CONFIG_MEMCG

-- 
2.50.1


