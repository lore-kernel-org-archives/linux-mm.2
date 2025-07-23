Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010C4C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310ED6B00CF; Wed, 23 Jul 2025 09:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 272DD6B00D0; Wed, 23 Jul 2025 09:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C426B00D1; Wed, 23 Jul 2025 09:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0A1F6B00CF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D14380628
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:13 +0000 (UTC)
X-FDA: 83695625706.06.5E9BF6D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 550F4A0016
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w+8aWlEV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnViJaVV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w+8aWlEV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnViJaVV;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WPRX5w6VLJucQ0K8sAKz65Zi/zci5w4tOo+kRZuEhI=;
	b=QGDx8EfUENMaG+zEEWdbNN6cZJ6qU8EIyUZ7vCUZgXGmEQRbv4iWlBPfPOfZP3Vs34iy2E
	o4mpiW0Mpem8bMLhqmIOSqGkXidHC/K3ESMSr8kgADZXXXMgATjlgzwuZlxHwdLmfcJMjp
	hf7wgUGz3xlA4ZSiIRSyoWAHIEwGNx8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277711; a=rsa-sha256;
	cv=none;
	b=79Jx3Ti0LPns8kyGhj4QE3a3bPT5arGHuTTqUOCS/fP5MagvQkpIsxmQ1jIBuKRtc1qx+j
	Nc8l0IHu362qdxkCR8d1SJ66CkSKt4ZsDbJ7ab7zOI+ETkcHvWk9DkmyPhQTD1HpZ5wmdv
	EDzvTnOrwQ4r9d3YuDJTm6pDWIdcULU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w+8aWlEV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnViJaVV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=w+8aWlEV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qnViJaVV;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DA971F78F;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WPRX5w6VLJucQ0K8sAKz65Zi/zci5w4tOo+kRZuEhI=;
	b=w+8aWlEVxjdtasQJNYG4cwAS62pKLVEL254SN4W/E9p62BnWXUpEvNrYeD379SCLpkK9AU
	R66reAIdkwGTxr6Sp4X3Ywh4fQZ+h/d+z/USoEPB1/a5JsnN8xXaimuNIlFTltPix8lQ1V
	l4lE+2XHF00vWpJKHjyPv8ylbHK6HBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WPRX5w6VLJucQ0K8sAKz65Zi/zci5w4tOo+kRZuEhI=;
	b=qnViJaVVhHNa5Zhw7P2qp0WTSOuBGcG1Hd8Cn5OyqOGdTXHdM9F3tywUcqNHwE43rCd/sJ
	ea3e7m82r1YY9BBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WPRX5w6VLJucQ0K8sAKz65Zi/zci5w4tOo+kRZuEhI=;
	b=w+8aWlEVxjdtasQJNYG4cwAS62pKLVEL254SN4W/E9p62BnWXUpEvNrYeD379SCLpkK9AU
	R66reAIdkwGTxr6Sp4X3Ywh4fQZ+h/d+z/USoEPB1/a5JsnN8xXaimuNIlFTltPix8lQ1V
	l4lE+2XHF00vWpJKHjyPv8ylbHK6HBo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WPRX5w6VLJucQ0K8sAKz65Zi/zci5w4tOo+kRZuEhI=;
	b=qnViJaVVhHNa5Zhw7P2qp0WTSOuBGcG1Hd8Cn5OyqOGdTXHdM9F3tywUcqNHwE43rCd/sJ
	ea3e7m82r1YY9BBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0560313AFA;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ABEMAQjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:36 +0200
Subject: [PATCH v5 03/14] slab: sheaf prefilling for guaranteed allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-3-b792cd830f5d@suse.cz>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 550F4A0016
X-Stat-Signature: bt75p4a1djfek3wbnyuc7nbfo9anyzpn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753277711-331536
X-HE-Meta: U2FsdGVkX18p29uBmI4jzKBba82SIjE50ovh1eDqcPRjlPhnScRUqKIT3VWh8ePV0EHiFh3sMwn+Zc0HOP6XiVA5pcwudCqzJleHcCFFoR841rknQF4rqPQI894MKGd746rfhwC49H34YCyOEWdjEOtAGyRG61aFxYTdS/8U7hsNfychBjdtttMxfm9BDFvcAZXL2a1wHDRNTyfZlncG1v1mRSPanbvKDsmGNp0hlR9o7b7LLzLj5zEHbQyDp2h2lA9RW7TxdGuEteZu9JTBuJKMx6OpBvENHzLBkr4/hQDeTgV1/4IvwZzt2rtc4+9asgBmmuZdOnRklGXGVapCfjcfReq3lNot/9jM5jUU6R21do1OOJhzJhO108hsaCc1MW/+0QzJtRjQC45lrXBXeReGgMEysMlr/LYkw1Bjf7ysnX29hSYiHimkPaq7Gnj6gm9Al8K2o9Rj7Ts0gZ6fiNhzoUDOQdUHj6xPVx8vjui/FE5V0SL7fRYFv9FgPmPtTxc4k2x1BKcZx+pM2tlp97pg7iT2GqFlkwagCsKYh/aIQexdSY7cpl4OeHn4K+N1cAj5p726JCcE9f+VI2omvdz5RVZ/xiuF1K7jiA+Zpbb0gz3O0wEKDV7chtmnbkhIGMsJJgXK8IF/T4ErIGXCYPteWqfhA/E3wZDDktEBAskrwM71Ja0vsQZXj49IoXvcWISA71xcF22Z0i4UHhGY6YDaC1qrz6XcL5o/NjMncQ4GQwxM0HjXOvrdPRc3Fqm/5kRHCfNDjbSXIW5eLgL1614O5aPKAPs3IiD1wJgmwOBO4Pqvf8aV54agw5OH4EUd4zRj3Un0jfgc9DBNvet9BQc+np41qUeG0cPBkQzt+4u7okSan1CnLPH+/U7JTX4F9N+RxhVLDhe29dwHRWYUcXcLxBnAbNd3sW9tlgx9IFY+zcSTFMrX2J5qkGM6zttvyFhbjuQ4xdUSPZmUOFs
 jgrRCS1x
 PP3zYf0dwavmKOafG3128Ac5JbnYfx88ReFgrIrYvjvWlMCwJroIGNXODCh6B+LGxOveRW3vVCd2rHo0pynO+rsqkCvh3ipaKg92fYLoNTNf4xv1J7M+3gShiTfj+ikB2bzr+dHwj53Ne8JzqsrOKAHyhFp6MZgS8TPxhrHB2qkwIRW4Pi3HhJCQsGxRM9UCehy74d++nG0sS26pENdcwbdhn4IiccncLnm1Fgu3Y9+UXlsEV0cqgkWYnR/XQKR7A5VBg4HLNkuCCatwf023Djk+HWxt7N92HGdEhzkGk41LSk5c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add functions for efficient guaranteed allocations e.g. in a critical
section that cannot sleep, when the exact number of allocations is not
known beforehand, but an upper limit can be calculated.

kmem_cache_prefill_sheaf() returns a sheaf containing at least given
number of objects.

kmem_cache_alloc_from_sheaf() will allocate an object from the sheaf
and is guaranteed not to fail until depleted.

kmem_cache_return_sheaf() is for giving the sheaf back to the slab
allocator after the critical section. This will also attempt to refill
it to cache's sheaf capacity for better efficiency of sheaves handling,
but it's not stricly necessary to succeed.

kmem_cache_refill_sheaf() can be used to refill a previously obtained
sheaf to requested size. If the current size is sufficient, it does
nothing. If the requested size exceeds cache's sheaf_capacity and the
sheaf's current capacity, the sheaf will be replaced with a new one,
hence the indirect pointer parameter.

kmem_cache_sheaf_size() can be used to query the current size.

The implementation supports requesting sizes that exceed cache's
sheaf_capacity, but it is not efficient - such "oversize" sheaves are
allocated fresh in kmem_cache_prefill_sheaf() and flushed and freed
immediately by kmem_cache_return_sheaf(). kmem_cache_refill_sheaf()
might be especially ineffective when replacing a sheaf with a new one of
a larger capacity. It is therefore better to size cache's
sheaf_capacity accordingly to make oversize sheaves exceptional.

CONFIG_SLUB_STATS counters are added for sheaf prefill and return
operations. A prefill or return is considered _fast when it is able to
grab or return a percpu spare sheaf (even if the sheaf needs a refill to
satisfy the request, as those should amortize over time), and _slow
otherwise (when the barn or even sheaf allocation/freeing has to be
involved). sheaf_prefill_oversize is provided to determine how many
prefills were oversize (counter for oversize returns is not necessary as
all oversize refills result in oversize returns).

When slub_debug is enabled for a cache with sheaves, no percpu sheaves
exist for it, but the prefill functionality is still provided simply by
all prefilled sheaves becoming oversize. If percpu sheaves are not
created for a cache due to not passing the sheaf_capacity argument on
cache creation, the prefills also work through oversize sheaves, but
there's a WARN_ON_ONCE() to indicate the omission.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  16 ++++
 mm/slub.c            | 265 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 281 insertions(+)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 6cfd085907afb8fc6e502ff7a1a1830c52ff9125..3ff70547db49d0880b1b6cb100527936e88ca509 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -829,6 +829,22 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t flags,
 				   int node) __assume_slab_alignment __malloc;
 #define kmem_cache_alloc_node(...)	alloc_hooks(kmem_cache_alloc_node_noprof(__VA_ARGS__))
 
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
+
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+		struct slab_sheaf **sheafp, unsigned int size);
+
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+				       struct slab_sheaf *sheaf);
+
+void *kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *cachep, gfp_t gfp,
+			struct slab_sheaf *sheaf) __assume_slab_alignment __malloc;
+#define kmem_cache_alloc_from_sheaf(...)	\
+			alloc_hooks(kmem_cache_alloc_from_sheaf_noprof(__VA_ARGS__))
+
+unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
+
 /*
  * These macros allow declaring a kmem_buckets * parameter alongside size, which
  * can be compiled out with CONFIG_SLAB_BUCKETS=n so that a large number of call
diff --git a/mm/slub.c b/mm/slub.c
index f6d86cd3983533784583f1df6add186c4a74cd97..8b3093ee2e02c9ff4e149ac54833db4972b414a3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -384,6 +384,11 @@ enum stat_item {
 	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
 	BARN_PUT,		/* Put full sheaf to barn */
 	BARN_PUT_FAIL,		/* Failed to put full sheaf to barn */
+	SHEAF_PREFILL_FAST,	/* Sheaf prefill grabbed the spare sheaf */
+	SHEAF_PREFILL_SLOW,	/* Sheaf prefill found no spare sheaf */
+	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
+	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
+	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
 	NR_SLUB_STAT_ITEMS
 };
 
@@ -445,6 +450,8 @@ struct slab_sheaf {
 	union {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
+		/* only used for prefilled sheafs */
+		unsigned int capacity;
 	};
 	struct kmem_cache *cache;
 	unsigned int size;
@@ -2797,6 +2804,30 @@ static void barn_put_full_sheaf(struct node_barn *barn, struct slab_sheaf *sheaf
 	spin_unlock_irqrestore(&barn->lock, flags);
 }
 
+static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
+{
+	struct slab_sheaf *sheaf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	if (barn->nr_full) {
+		sheaf = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
+					barn_list);
+		list_del(&sheaf->barn_list);
+		barn->nr_full--;
+	} else if (barn->nr_empty) {
+		sheaf = list_first_entry(&barn->sheaves_empty,
+					 struct slab_sheaf, barn_list);
+		list_del(&sheaf->barn_list);
+		barn->nr_empty--;
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return sheaf;
+}
+
 /*
  * If a full sheaf is available, return it and put the supplied empty one to
  * barn. We ignore the limit on empty sheaves as the number of sheaves doesn't
@@ -4919,6 +4950,230 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * returns a sheaf that has at least the requested size
+ * when prefilling is needed, do so with given gfp flags
+ *
+ * return NULL if sheaf allocation or prefilling failed
+ */
+struct slab_sheaf *
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct slab_sheaf *sheaf = NULL;
+
+	if (unlikely(size > s->sheaf_capacity)) {
+
+		/*
+		 * slab_debug disables cpu sheaves intentionally so all
+		 * prefilled sheaves become "oversize" and we give up on
+		 * performance for the debugging. Same with SLUB_TINY.
+		 * Creating a cache without sheaves and then requesting a
+		 * prefilled sheaf is however not expected, so warn.
+		 */
+		WARN_ON_ONCE(s->sheaf_capacity == 0 &&
+			     !IS_ENABLED(CONFIG_SLUB_TINY) &&
+			     !(s->flags & SLAB_DEBUG_FLAGS));
+
+		sheaf = kzalloc(struct_size(sheaf, objects, size), gfp);
+		if (!sheaf)
+			return NULL;
+
+		stat(s, SHEAF_PREFILL_OVERSIZE);
+		sheaf->cache = s;
+		sheaf->capacity = size;
+
+		if (!__kmem_cache_alloc_bulk(s, gfp, size,
+					     &sheaf->objects[0])) {
+			kfree(sheaf);
+			return NULL;
+		}
+
+		sheaf->size = size;
+
+		return sheaf;
+	}
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (pcs->spare) {
+		sheaf = pcs->spare;
+		pcs->spare = NULL;
+		stat(s, SHEAF_PREFILL_FAST);
+	} else {
+		stat(s, SHEAF_PREFILL_SLOW);
+		sheaf = barn_get_full_or_empty_sheaf(pcs->barn);
+		if (sheaf && sheaf->size)
+			stat(s, BARN_GET);
+		else
+			stat(s, BARN_GET_FAIL);
+	}
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+
+	if (!sheaf)
+		sheaf = alloc_empty_sheaf(s, gfp);
+
+	if (sheaf && sheaf->size < size) {
+		if (refill_sheaf(s, sheaf, gfp)) {
+			sheaf_flush_unused(s, sheaf);
+			free_empty_sheaf(s, sheaf);
+			sheaf = NULL;
+		}
+	}
+
+	if (sheaf)
+		sheaf->capacity = s->sheaf_capacity;
+
+	return sheaf;
+}
+
+/*
+ * Use this to return a sheaf obtained by kmem_cache_prefill_sheaf()
+ *
+ * If the sheaf cannot simply become the percpu spare sheaf, but there's space
+ * for a full sheaf in the barn, we try to refill the sheaf back to the cache's
+ * sheaf_capacity to avoid handling partially full sheaves.
+ *
+ * If the refill fails because gfp is e.g. GFP_NOWAIT, or the barn is full, the
+ * sheaf is instead flushed and freed.
+ */
+void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
+			     struct slab_sheaf *sheaf)
+{
+	struct slub_percpu_sheaves *pcs;
+	struct node_barn *barn;
+
+	if (unlikely(sheaf->capacity != s->sheaf_capacity)) {
+		sheaf_flush_unused(s, sheaf);
+		kfree(sheaf);
+		return;
+	}
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (!pcs->spare) {
+		pcs->spare = sheaf;
+		sheaf = NULL;
+		stat(s, SHEAF_RETURN_FAST);
+	}
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (!sheaf)
+		return;
+
+	stat(s, SHEAF_RETURN_SLOW);
+
+	/* Accessing pcs->barn outside local_lock is safe. */
+	barn = pcs->barn;
+
+	/*
+	 * If the barn has too many full sheaves or we fail to refill the sheaf,
+	 * simply flush and free it.
+	 */
+	if (data_race(pcs->barn->nr_full) >= MAX_FULL_SHEAVES ||
+	    refill_sheaf(s, sheaf, gfp)) {
+		sheaf_flush_unused(s, sheaf);
+		free_empty_sheaf(s, sheaf);
+		return;
+	}
+
+	barn_put_full_sheaf(barn, sheaf);
+	stat(s, BARN_PUT);
+}
+
+/*
+ * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
+ * the given size
+ *
+ * the sheaf might be replaced by a new one when requesting more than
+ * s->sheaf_capacity objects if such replacement is necessary, but the refill
+ * fails (returning -ENOMEM), the existing sheaf is left intact
+ *
+ * In practice we always refill to full sheaf's capacity.
+ */
+int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
+			    struct slab_sheaf **sheafp, unsigned int size)
+{
+	struct slab_sheaf *sheaf;
+
+	/*
+	 * TODO: do we want to support *sheaf == NULL to be equivalent of
+	 * kmem_cache_prefill_sheaf() ?
+	 */
+	if (!sheafp || !(*sheafp))
+		return -EINVAL;
+
+	sheaf = *sheafp;
+	if (sheaf->size >= size)
+		return 0;
+
+	if (likely(sheaf->capacity >= size)) {
+		if (likely(sheaf->capacity == s->sheaf_capacity))
+			return refill_sheaf(s, sheaf, gfp);
+
+		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
+					     &sheaf->objects[sheaf->size])) {
+			return -ENOMEM;
+		}
+		sheaf->size = sheaf->capacity;
+
+		return 0;
+	}
+
+	/*
+	 * We had a regular sized sheaf and need an oversize one, or we had an
+	 * oversize one already but need a larger one now.
+	 * This should be a very rare path so let's not complicate it.
+	 */
+	sheaf = kmem_cache_prefill_sheaf(s, gfp, size);
+	if (!sheaf)
+		return -ENOMEM;
+
+	kmem_cache_return_sheaf(s, gfp, *sheafp);
+	*sheafp = sheaf;
+	return 0;
+}
+
+/*
+ * Allocate from a sheaf obtained by kmem_cache_prefill_sheaf()
+ *
+ * Guaranteed not to fail as many allocations as was the requested size.
+ * After the sheaf is emptied, it fails - no fallback to the slab cache itself.
+ *
+ * The gfp parameter is meant only to specify __GFP_ZERO or __GFP_ACCOUNT
+ * memcg charging is forced over limit if necessary, to avoid failure.
+ */
+void *
+kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
+				   struct slab_sheaf *sheaf)
+{
+	void *ret = NULL;
+	bool init;
+
+	if (sheaf->size == 0)
+		goto out;
+
+	ret = sheaf->objects[--sheaf->size];
+
+	init = slab_want_init_on_alloc(gfp, s);
+
+	/* add __GFP_NOFAIL to force successful memcg charging */
+	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, init, s->object_size);
+out:
+	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
+
+	return ret;
+}
+
+unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
+{
+	return sheaf->size;
+}
 /*
  * To avoid unnecessary overhead, we pass through large allocation requests
  * directly to the page allocator. We use __GFP_COMP, because we will need to
@@ -8464,6 +8719,11 @@ STAT_ATTR(BARN_GET, barn_get);
 STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
 STAT_ATTR(BARN_PUT, barn_put);
 STAT_ATTR(BARN_PUT_FAIL, barn_put_fail);
+STAT_ATTR(SHEAF_PREFILL_FAST, sheaf_prefill_fast);
+STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
+STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
+STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
+STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
 #endif	/* CONFIG_SLUB_STATS */
 
 #ifdef CONFIG_KFENCE
@@ -8564,6 +8824,11 @@ static struct attribute *slab_attrs[] = {
 	&barn_get_fail_attr.attr,
 	&barn_put_attr.attr,
 	&barn_put_fail_attr.attr,
+	&sheaf_prefill_fast_attr.attr,
+	&sheaf_prefill_slow_attr.attr,
+	&sheaf_prefill_oversize_attr.attr,
+	&sheaf_return_fast_attr.attr,
+	&sheaf_return_slow_attr.attr,
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,

-- 
2.50.1


