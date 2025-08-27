Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A41BC8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6986B0372; Wed, 27 Aug 2025 04:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E0C6B0377; Wed, 27 Aug 2025 04:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 594DA6B0378; Wed, 27 Aug 2025 04:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3428E6B0372
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:27:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFC1B139BE7
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:03 +0000 (UTC)
X-FDA: 83821857126.12.43A913E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id ABA481C0004
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:27:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJHA00Q1us5OgEgc6JVqqFZGKGjL2L0yc9ftJvJUT+k=;
	b=GZZLE3bcrJs8uAxbq+aIgb1bbTqdES13MUOCVj43JU/QJmhxAuEV1LEzPQ6xUO2Y1HbN/t
	KUkpomI1uABFbZkFKllDbcb4bdIcwZJeOZ+tnFrSA47SXeFLY+7kknA6qxdxi+d/A64jyX
	txFw/Nhsbez3nCvQkF4iZvMchIBmKsw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283222; a=rsa-sha256;
	cv=none;
	b=eFpNWcjRslYXpr9wdgTe3MpvCV/kHv7UbjyqbV1WRbcYgs6NYgHb0jXO/ZSJGPk6idj3I4
	bWnHVi6m62mvMjLxMCooxs3cjyEiOCme+gN/ANBBKXOmwCQQCoMOcP67u7+rmGYkgeHv8x
	1mSJKlGZ9zp5qJnuk2BrL/ZcvJ2pFM8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8CABB1FF23;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6CA6E13310;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLlDGjvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:38 +0200
Subject: [PATCH v6 06/10] slab: skip percpu sheaves for remote object
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-6-f0f775a3f73f@suse.cz>
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
X-Rspamd-Queue-Id: ABA481C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: g8ibmttxyocag4nkdy3d39kniwqwb9xe
X-HE-Tag: 1756283221-759276
X-HE-Meta: U2FsdGVkX1+OghR5/vZr/j6MARnJ36iZUkXexMMuhfqJlZ1FCJS9+zkJMlInFI/xtQaidAOZ0vp0bvZqecL/KHZK5L9rBYpHbNdM3PiLRTMqR1P7IJSFAgIL+n9F24dpxflOv9SMmUettwGGC35c5FC90nWdyzjOyPxgflCwfQ33hntLQPHZPUdshUEECb7YAsKGukxLg4qsLb42F04isYRxVK2MZ+zFzn8QPc3UNHOc5/+M6OE4mbFhUjJpnruX+NmpAh0Ams/TLMlTT71zvTEECYv+5pDEq3WQt0QVHylXCCEJHhkUB0yXghfqGsgAJo7POzJGtjjjsTOMfUvDhuvWxFkf+7Ov0uY7dv+0Y7JEX8EoH9gG0TLcuWdOiZzS8zUF5+KiSSb7dVX7JqP9wmQollE+zGjONKgARkTwWM7BeYFanXRF1+iE/nTHGq7fg6MdMfxA02fgCUtQhXWvAGRmf3RMw+Nc1JOcrXQqb/i7wQZsiHFIVCnbvek+8gpauJRICbL4b+zCrbg0ew6WDTs34tj7RstUsd4kAGlJYmlrsK4PWdmlKj3kZmMQfs7p9GpHdqYjNhvQKx1HwLFAA89A3Tj8++iRFq6Mz4YMnKU1UvAPzWLQbS3QJ8o9cmZJfhqU3xLIhoOzAE1+YRnQykt1k7LN+xIkc3DxDqUis7QWWe/Yo81YzyRXpECwpK1PcIcazhdJf7r6nFiwqUmfgQmC0AJY2GW/WDfdwcQh4goidoNYnVJ4ttTI2llXb8ZHohw2edCdAHwnbQ/pBcU5HfYbmJGXy+M2MhXO2487vWV5iwdtWBer6lRntj35gn3qQoDcq8IC6cUk3meK4K/JmAvUhP3r0kAjakVuIqixhKMiLePSS5nqRAhqvq61+UCoDzqYaho7hSGmaS+IBzOaPCoJoWsmGSp1yy1IAxB+TiGQwzd0HJlvtEssFjKHhDi+6fL6QwxleTCuQfLfm5c
 weIO8fPC
 PQWHC5Avvd7AnDBpUhsuZG2Ss4i8j4rNX/rc3QwmHIc0ODzFhJqQz7BZm4M7nXjhYYx60Ih/7uxto86c=
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

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c |  7 +++++--
 mm/slub.c        | 42 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 2d806e02568532a1000fd3912db6978e945dcfa8..08f5baee1309e5b5f10a22b8b3b0a09dfb314419 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1623,8 +1623,11 @@ static bool kfree_rcu_sheaf(void *obj)
 
 	slab = folio_slab(folio);
 	s = slab->slab_cache;
-	if (s->cpu_sheaves)
-		return __kfree_rcu_sheaf(s, obj);
+	if (s->cpu_sheaves) {
+		if (likely(!IS_ENABLED(CONFIG_NUMA) ||
+			   slab_nid(slab) == numa_mem_id()))
+			return __kfree_rcu_sheaf(s, obj);
+	}
 
 	return false;
 }
diff --git a/mm/slub.c b/mm/slub.c
index ee3a222acd6b15389a71bb47429d22b5326a4624..b37e684457e7d14781466c0086d1b64df2fd8e9d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -472,6 +472,7 @@ struct slab_sheaf {
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
+	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
 
@@ -5744,7 +5745,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 */
 	__rcu_free_sheaf_prepare(s, sheaf);
 
-	barn = get_node(s, numa_mem_id())->barn;
+	barn = get_node(s, sheaf->node)->barn;
 
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
@@ -5827,10 +5828,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
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
 
@@ -5856,7 +5859,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	struct slab_sheaf *main, *empty;
 	bool init = slab_want_init_on_free(s);
 	unsigned int batch, i = 0;
+	void *remote_objects[PCS_BATCH_MAX];
+	unsigned int remote_nr = 0;
+	int node = numa_mem_id();
 
+next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -5866,7 +5873,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
 
@@ -5934,6 +5949,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
@@ -6025,8 +6049,14 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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
2.51.0


