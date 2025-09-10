Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE49CCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38E58E0013; Wed, 10 Sep 2025 04:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9588E0002; Wed, 10 Sep 2025 04:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF108E0013; Wed, 10 Sep 2025 04:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB0CE8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EA2E86E4D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:36 +0000 (UTC)
X-FDA: 83872596192.05.B70859F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4B6C540004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIRf3cRQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/wVAxdHP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIRf3cRQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/wVAxdHP";
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6xXnWAdQI//pOYwufYbMgKCqE7B9/pqugFW+usImNk=;
	b=FGa6syzg/S0+Z0YTrLQzG690uyJuUmb78zOggZXKtFQP8IJwGN+YN90Sl5WN9sG7oM3kvs
	ouuHyOrwkXdeBkHjq8x17kkKYrebp6yWKP/Y9DT2DJedZnFwPkpS4c8ae9eThtNrc9f0ZU
	cuZYtc0EZ2mEdOFP9bjkfjWiHx0MV2M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491294; a=rsa-sha256;
	cv=none;
	b=QUFSWb/YJv0mBLzr6RTixHZVRZS6lAG2EZhu8JGux1u8ENA7hSeRGCnEfCSsSHQRwnAY0d
	OURp85xDn/0sZIoiwnfp4A7votqzrT/RyfayjfHsNGFk5TLHjJBIGbtO0eiAzCGB2r5Hs9
	BfCr3YyZaN8TBCtOufcAvZqLVj8jrrk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIRf3cRQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/wVAxdHP";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZIRf3cRQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/wVAxdHP";
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2871E34C34;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6xXnWAdQI//pOYwufYbMgKCqE7B9/pqugFW+usImNk=;
	b=ZIRf3cRQDIeoF8QNqTpe70Yezy2fsPpQaCTF2Rph+2e91RhK9uLhMcyRX6xt/30bQz/f3k
	xHb3BvvHe1ZfUTvyigy2R3x/tEqjnfPKhw/Ib1ECB8ueKhvougCBI+NMQxZp0ZHBmrcU9p
	/9nSL/oO2H+ic655SZK63lvlwJz5h8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6xXnWAdQI//pOYwufYbMgKCqE7B9/pqugFW+usImNk=;
	b=/wVAxdHPTbII3WwcuHbYke6k+S/Itkv3pMv6JozOngvB1ipL/GOotw3E/8W6cDygDH48fY
	HXURtXKx+6ILpuCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6xXnWAdQI//pOYwufYbMgKCqE7B9/pqugFW+usImNk=;
	b=ZIRf3cRQDIeoF8QNqTpe70Yezy2fsPpQaCTF2Rph+2e91RhK9uLhMcyRX6xt/30bQz/f3k
	xHb3BvvHe1ZfUTvyigy2R3x/tEqjnfPKhw/Ib1ECB8ueKhvougCBI+NMQxZp0ZHBmrcU9p
	/9nSL/oO2H+ic655SZK63lvlwJz5h8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6xXnWAdQI//pOYwufYbMgKCqE7B9/pqugFW+usImNk=;
	b=/wVAxdHPTbII3WwcuHbYke6k+S/Itkv3pMv6JozOngvB1ipL/GOotw3E/8W6cDygDH48fY
	HXURtXKx+6ILpuCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C87813AE0;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0Pd+DkIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:09 +0200
Subject: [PATCH v8 07/23] slab: skip percpu sheaves for remote object
 freeing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-7-ca3099d8352c@suse.cz>
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
X-Rspamd-Action: no action
X-Stat-Signature: mbg4fbncn6mfus7dssb17epnm44thywy
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B6C540004
X-Rspamd-Server: rspam10
X-HE-Tag: 1757491294-31035
X-HE-Meta: U2FsdGVkX1/sySqJHYqCoTEPGLigFD7jBOiqi6KLGrCpW8JSEGG8R7CP51Uby+ildZYm7iaP64X95cbUvBJocuQVunlgppB4XUOH5jenPrSpWoahUYG1HqOoQrSXwZjepMj8XtevJ8c6F0U5MFJcyUmfT0+j7bYV7mxLlDso3zqJZz/N5nBzjgnUQVFZc/khSGDpMR/05RFpFAoDZZsDpphgT55DHm5ROYGvYUw7dH77lwlGp3aECiOZdfyNg08rDarwp7RwabMqGq4JMu0GuikFHhKb5fQou/+2paKNX4L8xr/SvvpmJDfk+wzeYSBiuL6M1DQGe+M6cmY45RsqKQiseqblGrbIj04Ucf2WMDmx6csqrqCP3NEk33ZNICm52wBmzR0F9GBloaISsA6WHeOqs+wqD+noW4vwNqQupTkcbrUavtwLZfvyqQS1FPdVCcg96OOH8cg6zk++4Ob/fH+9V9ZjK9V/C1HHwzcmjNXSSsbUHuzr4PcWbi3Sa+6QbmNc9DunjcSkYNhwC0ZKceE+GWwXxRLHcYIebvYMJi2qrrTnX4nuht12hN/kXWZfm9SBbKLnpzB5aKFaaQIU0YMt5DNO1KhnxUBJs+6JREhaIu1/IJeso++Buc74ZY5ju96vO00iddrzoPFLkTD688EZ2RRjvrChvx4X5s4uHypCNYbzJM64T29PmSOiGTnqTIt1VkcX18qoiOqmdNllyNexjQGvHsy1a2GynXdjP0VHGtpMBTRpQGoqF1R9fhabAYRjjofiOH2gQp1bncWpQVrYyRLP0U8XqeXZvA3mZUGaPvT1MLlU1B7ScmCSaKs3iF4qeyrutGhhaEEzy0iJ/2kGxiVss7fa+wiwVnXzx4Me59KAw+FB7fDkevOGcThm4GtI0IOvKuf8q/yVj1S25pIjlpVCg/HaAAxTkaGoeAJPEblHEp1w2FGr3hckHd+nQOmL7COdRLgSIy1M/Rn
 nQ7fCsk+
 0+j4Tz5WjMWvNb2dFZcW69/0huRIP2FvJwqmc4NNWEidC8tuxY/tSA+ESnE0Ejd/W4qHTGiNl5Z+EjdrlqaB0O5Ly4YArJnZJ3Dl0h6LlaYww9hJn3Mh4xCiI7mV++svlDuaxI7Frf1Qtv6nv4xcFEWOC9tfmUOtwZCf3rehO2o48pASaOquzVzahFY9F5EbN1/nuz0GnjOe6nalTmlEZ/H8ttk1Gs+jenBx/SMRwix8pFyo=
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
index 005a4319c06a01d2b616a75396fcc43766a62ddb..b6601e0fe598e24bd8d456dce4fc82c65b342bfd 100644
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
index 35274ce4e709c9da7ac8f9006c824f28709e923d..9699d048b2cd08ee75c4cc3d1e460868704520b1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -472,6 +472,7 @@ struct slab_sheaf {
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
+	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
 
@@ -5828,7 +5829,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 */
 	__rcu_free_sheaf_prepare(s, sheaf);
 
-	barn = get_node(s, numa_mem_id())->barn;
+	barn = get_node(s, sheaf->node)->barn;
 
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
@@ -5914,10 +5915,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
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
 
@@ -5944,7 +5947,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	bool init = slab_want_init_on_free(s);
 	unsigned int batch, i = 0;
 	struct node_barn *barn;
+	void *remote_objects[PCS_BATCH_MAX];
+	unsigned int remote_nr = 0;
+	int node = numa_mem_id();
 
+next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -5954,7 +5961,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
 
@@ -6024,6 +6039,15 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
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
@@ -6115,8 +6139,14 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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


