Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF71FCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AB18E0018; Wed,  3 Sep 2025 09:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1628A8E0015; Wed,  3 Sep 2025 09:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6908E0019; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1D4E8E0018
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 916B65AAF8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:33 +0000 (UTC)
X-FDA: 83847947946.03.023D065
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2D964100018
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHokq7Id;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pmosW3Z5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHokq7Id;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pmosW3Z5;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wINAnmJZsrmMDedeNn5PMbqYkUg3J6y9665h1Yp2O34=;
	b=zlNOCVs5csxDAFt50Xsm/ek6pEr/Bq/oLxBlj2hvg2DXU0mBIIb/bGICGpmUuqMsh6LDfx
	UWAdhT4pZAC5LGN6zEZpFVMLQStm6Zk64+u7/8N2mZ3ScOXQHdyKwTV1JOrAoSaaTp42o/
	aDBvAHwTqIY48Y+6l7lMeziOC3CC8qY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHokq7Id;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pmosW3Z5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UHokq7Id;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pmosW3Z5;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904431; a=rsa-sha256;
	cv=none;
	b=z65j2wcPMauUnTF/AOl6Ji/KDskXrE6FRaBBJ0er8/0lpaFWZF/a+O44mjxirk39KkHLgR
	ognHiehPjg7EOgCKp9refaTPt/+fnbTxWwjAy0LvhX3b91cZg+IOEfzPjR4oBxeUfaeRrn
	SLei3HGO+IyQlSwRYlSn5Du5uF8PmvY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 547E21F461;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wINAnmJZsrmMDedeNn5PMbqYkUg3J6y9665h1Yp2O34=;
	b=UHokq7Idup178YOMFRbRTiP4XrmwipxKAOlMqzVkHx/ucsWcZ0adA7aM9Qz/9+dcZZH1jH
	YuzBVF+h3ODeXefcBjtYIm0nCGq8WP2SZDZi5xojADd7AOCzy5UwL5WpiLsZZN0+kQ96DQ
	aSRw2ptS66V4PY2kY6npMzJvH+piN0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wINAnmJZsrmMDedeNn5PMbqYkUg3J6y9665h1Yp2O34=;
	b=pmosW3Z5p3aeVp5MFCU2sc+FAPShkKRa9OZpBEOCIdBZC3IpupKPpA/m48UjM8JttsxVoB
	3wqUe5+0EEHZT3AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wINAnmJZsrmMDedeNn5PMbqYkUg3J6y9665h1Yp2O34=;
	b=UHokq7Idup178YOMFRbRTiP4XrmwipxKAOlMqzVkHx/ucsWcZ0adA7aM9Qz/9+dcZZH1jH
	YuzBVF+h3ODeXefcBjtYIm0nCGq8WP2SZDZi5xojADd7AOCzy5UwL5WpiLsZZN0+kQ96DQ
	aSRw2ptS66V4PY2kY6npMzJvH+piN0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wINAnmJZsrmMDedeNn5PMbqYkUg3J6y9665h1Yp2O34=;
	b=pmosW3Z5p3aeVp5MFCU2sc+FAPShkKRa9OZpBEOCIdBZC3IpupKPpA/m48UjM8JttsxVoB
	3wqUe5+0EEHZT3AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9EE2413AFF;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kMuCJtk7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:49 +0200
Subject: [PATCH v7 07/21] slab: skip percpu sheaves for remote object
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-7-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2D964100018
X-Rspam-User: 
X-Stat-Signature: myptat31bez7miqwhzdrq4e1uo4ngt69
X-Rspamd-Server: rspam09
X-HE-Tag: 1756904430-887430
X-HE-Meta: U2FsdGVkX19VKX0c16BnIBphGe7G9Hm68N99m2o6r8W4YgCbVMgIFt7bYYu0HHJz/Z58u+6ryeQSBmFieZhhzJ6e/HrQYsLx1kg8IcNHxwUusCLTe7m6hoAHpmYtYLi1y2dtB7RiGn7oAkpc+3X5m3W0H8j/O5Y1bOUiUI6fWymPOoOpYOl6PnrckcikvCGChBzn0zzff4JDb5SISJy9r3bXFtFogMgh19GQDvcAlF814ICKAtIDaqgFqmECWjc9TpRWktD1ube6QW4l23JTbSN5dbTK7jEF/iWRbDbn3xhYCN6UY4vNVSQg1aYVgOIndbJOmsE5FmJD18M1SE6HhOTtVRCv6wRB1YftcQnOO+kUAJdXc3iU2xl+Xa0kmFvaisWnSXaeatMsMkcr2ncWkGyFDt/8AaTNmMFoYH3ap17+ugGRu0AqfzJpSNnpF+xYQBP3m5a9XSZyPhe4JgO4J2VQgiMsZ1EFm+wHZOrZz9KozloVrYGBapVnWsbUiw4IBNcuTgLn27DmOPtMGbrp9VSvnAtNGyR9A7j1rBpKdOwqhwz3mNQplJGXDcT5jR8ILpj5pwGhUv3/mKWbWFap7eLXsz5CJlGbhm5SAMMiZ2I2SAas6bg8esonhmbN5IzW6bAGcfsqNsX00POFP15kPwrLNodFRaYjE6dC4ETZjmtNxnSIEy6bv4sY03uF2Lz53L28iByuAfXZIJO9G0biJcdj09sfBxG5pWoK/iLNRN67RpibWP+72rkEHzUmjj0VVLIzT9tk8SXheNZtYaEPLkV2+3EJKxRUBCHfcqupy2goPxTLEYiibCNOzf5ytILytHjrM9CPCk36GpRteU7c/LOUIVUWAI3hjlwihFLt2KWGBL+OqQTR6RMQ19Hx+KC6vmvel/RtUSS3xoZFC07AZ5Q0ucAsnPZ+SoptQaS/X0MYmkqrrcURoHIxJb23kgACbsvskyCCVZdx4HO9nl1
 ZwEDFSau
 CS6DpLDh7jatF+M5mxMFUxbPaHMEK0LwtWC4UV4weOTtuR7i5y4hCFX4EFXEDEX44Xz/cOdLIydc5hH0FKaSF6zD8pHZ6DthIBVx8XwYaO51dMqH6XOMExtH7ghpnmV+laiPC6RfCCQX9Olf3e2mY4IVx9HvUMDTvPkklBwExSPOV3D/8tDjBpU3syIVDFC3LB5wSCrsZmFYratchmLZnqima6xjN8X8wMC/HROGRul7JTIU=
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
index d078630f7211b617f390a16fa080da8a1df45355..8e34d6afccf41efad0c6620126e09f874bdcb663 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -472,6 +472,7 @@ struct slab_sheaf {
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
+	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
 
@@ -5756,7 +5757,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 */
 	__rcu_free_sheaf_prepare(s, sheaf);
 
-	barn = get_node(s, numa_mem_id())->barn;
+	barn = get_node(s, sheaf->node)->barn;
 
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
@@ -5842,10 +5843,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
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
 
@@ -5872,7 +5875,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	bool init = slab_want_init_on_free(s);
 	unsigned int batch, i = 0;
 	struct node_barn *barn;
+	void *remote_objects[PCS_BATCH_MAX];
+	unsigned int remote_nr = 0;
+	int node = numa_mem_id();
 
+next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -5882,7 +5889,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
 
@@ -5952,6 +5967,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
@@ -6043,8 +6067,14 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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


