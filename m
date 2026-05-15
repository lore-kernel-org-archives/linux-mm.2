Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEADCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BA56B0092; Fri, 15 May 2026 12:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BD76B0093; Fri, 15 May 2026 12:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F2F6B0095; Fri, 15 May 2026 12:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB2566B0092
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73DB71A019A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:44 +0000 (UTC)
X-FDA: 84770177688.13.DCFB469
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id A580C18000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NHj4PGGj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkxhFXOgIhMCgcajGlkZOv/65bya0xaHvZldaI1GMjo=;
	b=u2CpSHwIuvluufsoS4dmAYNnfJNPaBHYNb8oRAJ5xRy1xeOhcVjlll4kcwi8u4eOMUM6jK
	a+L0SBgF7k8WeZOMpsN3H9mspH8fXqEHdlaqrVLiCbiaWtA4dQJe7n+jBLaAthhBjS4Y9O
	wj75SMroSbYgKbUS4SS80D6w4bwb4DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862282; a=rsa-sha256;
	cv=none;
	b=i/kP2x8lqjp01O35pkiVsK9I2TRDhS1yiWceFVYd01BXEFhwakPzQeF9SjdvDVPf7zNjaq
	HMqUjhImIT6rOuZI97FoStvDuxav7UHRyr08aLUp04eiXfXefaDAsNEkFotf/9rhEMP8i9
	TVQFb9s+ICymsv5zOQW9G31lmPJEfK8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NHj4PGGj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6129444AF;
	Fri, 15 May 2026 16:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05EFC2BCB3;
	Fri, 15 May 2026 16:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862281;
	bh=EYPxp3BS503vPYeqgCva7KZMCxYvgQlPQAcZTIN2fQA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=NHj4PGGjWVqj4heBlOwpnCF8Lu2CxX7rp0GRoOUwVffhmaROBnA665SPrxppjDVyh
	 S8tr9O1BkG1+pHvszW1CKnFNhQZFb70OkMgKicuWRsnEd/Egz24qMPdCku9T87mAcr
	 iNGRZsUQJOhO/PuutCm9BSfBdJe8+Qo5Ek+VwMXMxpesqmVyGwZin7jvVJ3wRH1s/B
	 bTtyL1I5hMwY+O8k9Vuk6JvZliEOre0/CnWysb1XkngTVhZHwmFSFA8gqDaS4qGlKg
	 KLQNhFUCaZj0d5d9vWusw4b+jsMG8jP4flA+Nwg9+xP6ZzLcfpFAXF0Eqm0TOYyNdt
	 7FOGiwx/9iG+A==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:25 +0900
Subject: [PATCH RFC 1/8] mm/slab: do not store cache pointer in struct
 slab_sheaf
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-1-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A580C18000A
X-Stat-Signature: zd3wctsrhtzj6i1ecozftkx56exwdek9
X-Rspam-User: 
X-HE-Tag: 1778862282-841992
X-HE-Meta: U2FsdGVkX1+BCd0yi6j3YjAvC5s1Sx+y9DDATX7T01yt0ahSpgxhuSs0OFl70CNvXWDJUtfzA7Kv8XfYQdSuMY9QqyL89QY+Sq0RumNfMnvm/mkI0r1gRWMXIhTCnD7H8HpWZxxBpskllHndX3tYMzettW/e7UFbmeEOKaCzRnXu2Nr7XfVVzoBDR6ql+PgTCMYNYsB11WqPcVSyfHqJvOceDxG5m+IdUvEwg6NBDPJeVOsUW752yk5v3RWPLIR8KfVexlzQwJHP/QjpARh7osniZJHQAQAqrc4uZn//S8y5agTZC5qfPeSxjT3jq2OPRwzJbBMlzSjVG8xubLGZ659QrA9Az0s1Odmg2CLBynuBK4fVCMD8RMgJKjO3uwC2RdeLerG+t8+VwZkQyd8FNaGj8JoNdNUZx6DhzJYx61W95yBpZcb25d3VkRiEaE9s5X+O72mnVt8H0q/k4T67LF2vJj5t+m7takOciudLZYt430pNdf/jY17Pi4+vAH76IzXufNgoi08AuwKV2Cy3SLlF0BMReZXq6eAmmYTmnS/2enADh9hz4kKTvxKSo1zWO3PAqa+kjdXGWItZzf+TfoUI5ULY5HvQ1FSaHXDQgMy+mzclOFHUqOLu8nbhKSSVU/gGOstUxKzF3NMybHPfPbBybGyrKQS6RrcMycP5B5tj9YxXV5P256spFiMJH9zObIsjajGu9WrQmn5RSz7awJDwtimfqZygNwJBunI1otVawdZvanwKJ2JU5rsTcZuSb90Q7ZOX1koP9z5lgtigd2f4lt5iX8zoZiPyO4qyBI8+WaKQTeKeUfUT+8BKMbLGyv/l8diJGDuzrl/Q3FSFFUNnZEDb3spqnaF5pHm58kjqtkPNnEmBE8l1T45P9UW3mhqppUucv2V9QMGriySFlCjZUYD4/6HO2jxjZ7PI2LJk00aav5nXYxhzO/PySt8DDCeBnwEUOcjk8yGMnt3
 7LTcWBia
 jsbvhdRb1KGpEkvl/X4/5Q1vpb8l227eM9BrpSD/ZmUkP31SvHm9obV881WypUZFgB9oXkNL5aTAaL/+jlCehxbajlrRZf/jJQ50nOM4kxsyNa4ycosSeMXvgK0D9etWdc4E6/dBLFJ3LgcNPjBl9UOBDyQI0FWLA+ntrn2BwNNHjUcknVCX6We4nO1Ubpgz8yDmIsNY7ENhXf2GQNR0kNawsprs16l1sbyijtsViTP8o15RyEruVEgK+O1Lcq6rNwpwNQUao84cgA+zaYFgvfRQ2oHy50ETHJa1l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The `cache` field of struct slab_sheaf is only read on the slow path
when freeing an RCU sheaf. Storing it in every sheaf is an overkill.

Drop the field. In rcu_free_sheaf() and rcu_free_sheaf_nobarn(),
fetch the kmem_cache pointer via
virt_to_slab(sheaf->objects[0])->slab_cache instead.

As sheaf is only attached to pcs->rcu_free once it holds at least one
object, the lookup is safe. Add a WARN_ON_ONCE() in case an empty
sheaf ever reaches the RCU free path. In that case, the cache is
unknown, so free_empty_sheaf() now tolerates a NULL cache argument.
However, the case is never expected to trigger.

While at it, remove the stale comment in init_percpu_sheaves().

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5ef54d546bc2..75281eb802de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -422,7 +422,6 @@ struct slab_sheaf {
 			bool pfmemalloc;
 		};
 	};
-	struct kmem_cache *cache;
 	unsigned int size;
 	int node; /* only used for rcu_sheaf */
 	void *objects[];
@@ -2781,8 +2780,6 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely(!sheaf))
 		return NULL;
 
-	sheaf->cache = s;
-
 	stat(s, SHEAF_ALLOC);
 
 	return sheaf;
@@ -2802,13 +2799,14 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	 * warning, therefore replace NULL with CODETAG_EMPTY to indicate
 	 * that the extension for this sheaf is expected to be NULL.
 	 */
-	if (s->flags & SLAB_KMALLOC)
+	if (s && (s->flags & SLAB_KMALLOC))
 		mark_obj_codetag_empty(sheaf);
 
 	VM_WARN_ON_ONCE(sheaf->size > 0);
 	kfree(sheaf);
 
-	stat(s, SHEAF_FREE);
+	if (s)
+		stat(s, SHEAF_FREE);
 }
 
 static unsigned int
@@ -2968,12 +2966,15 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
 	struct kmem_cache *s;
 
 	sheaf = container_of(head, struct slab_sheaf, rcu_head);
-	s = sheaf->cache;
+	if (WARN_ON_ONCE(!sheaf->size)) {
+		free_empty_sheaf(NULL, sheaf);
+		return;
+	}
 
+	s = virt_to_slab(sheaf->objects[0])->slab_cache;
 	__rcu_free_sheaf_prepare(s, sheaf);
 
 	sheaf_flush_unused(s, sheaf);
-
 	free_empty_sheaf(s, sheaf);
 }
 
@@ -5019,7 +5020,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 			return NULL;
 
 		stat(s, SHEAF_PREFILL_OVERSIZE);
-		sheaf->cache = s;
 		sheaf->capacity = size;
 
 		/*
@@ -5873,8 +5873,12 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	struct kmem_cache *s;
 
 	sheaf = container_of(head, struct slab_sheaf, rcu_head);
+	if (WARN_ON_ONCE(!sheaf->size)) {
+		free_empty_sheaf(NULL, sheaf);
+		return;
+	}
 
-	s = sheaf->cache;
+	s = virt_to_slab(sheaf->objects[0])->slab_cache;
 
 	/*
 	 * This may remove some objects due to slab_free_hook() returning false,
@@ -7616,10 +7620,6 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * It's also safe to share the single static bootstrap_sheaf
 		 * with zero-sized objects array as it's never modified.
 		 *
-		 * Bootstrap_sheaf also has NULL pointer to kmem_cache so we
-		 * recognize it and not attempt to free it when destroying the
-		 * cache.
-		 *
 		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
 		 * caches with debug enabled, and all caches with SLUB_TINY.
 		 * For kmalloc caches it's used temporarily during the initial

-- 
2.43.0


