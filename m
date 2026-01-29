Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DB0D358E7
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 09:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2DB36B0088; Thu, 29 Jan 2026 04:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADBE06B0089; Thu, 29 Jan 2026 04:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3D06B008A; Thu, 29 Jan 2026 04:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5E96B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 04:08:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33F50C2D23
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:08:12 +0000 (UTC)
X-FDA: 84384424824.24.B65DD8A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id A02DA160006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:08:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CuwIF6Ej;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3Nd/Tchb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CuwIF6Ej;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3Nd/Tchb";
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769677690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s0Uj5CtLWt5iohkdKRxxM31BtoyfocYHB/bXTO1htHU=;
	b=HJOuVt5tfcPbPNEjCIK+vfgptEf3JZYZis7MG0uXNLY1RHRd7Dtr/0IbTHzd1qIilhf5yJ
	/zxzejr84uXr92WK2VLO+xg9cmbkX2qrDegERPoZ/OPXjgivWZMD+24eCnSuTsa+gkrhkS
	YeZvj+4qmE9ETgnSzWtvaYyeSDvhxPQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CuwIF6Ej;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3Nd/Tchb";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CuwIF6Ej;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="3Nd/Tchb";
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769677690; a=rsa-sha256;
	cv=none;
	b=17NjfrsDBgFsp8FJVNpX6Sxc4crc8wY6RXrMsvj9Yo6Y6NxK6zXgsfX39oPrb78VSX/iHc
	jjSdKYGZAQv5dU/LBUS/4LpX7I22aeStWLsoT5hSs1SsOkX2uwYSunrPxpnoBV/SYTw/Xt
	md7cxbXRiErmaCji8Cc5g9ATLwCFOxo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F3A533405B;
	Thu, 29 Jan 2026 09:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769677688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s0Uj5CtLWt5iohkdKRxxM31BtoyfocYHB/bXTO1htHU=;
	b=CuwIF6Ej5ONspel7vrMa5mVwl690lRZUnonRizeSx0WpTjEslBcdMU3qaSWUWdOarqOYuh
	CgHAGdKd3W+5B8VjmamTggMUSLNvNqQn0QLhqLMUkAZACSnaOsosNFFlUFxrNAGYDT+U41
	mv3O5JegiqtauhP4szxQA3GULCJNBVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769677688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s0Uj5CtLWt5iohkdKRxxM31BtoyfocYHB/bXTO1htHU=;
	b=3Nd/TchbguN5/nmCiyArreevzl3xMJLSscwDUJSdmWbIjRQMUskZQwFjd/Xuh0OBtwlll5
	yPioUsPqZ1o8GoCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769677688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s0Uj5CtLWt5iohkdKRxxM31BtoyfocYHB/bXTO1htHU=;
	b=CuwIF6Ej5ONspel7vrMa5mVwl690lRZUnonRizeSx0WpTjEslBcdMU3qaSWUWdOarqOYuh
	CgHAGdKd3W+5B8VjmamTggMUSLNvNqQn0QLhqLMUkAZACSnaOsosNFFlUFxrNAGYDT+U41
	mv3O5JegiqtauhP4szxQA3GULCJNBVc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769677688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s0Uj5CtLWt5iohkdKRxxM31BtoyfocYHB/bXTO1htHU=;
	b=3Nd/TchbguN5/nmCiyArreevzl3xMJLSscwDUJSdmWbIjRQMUskZQwFjd/Xuh0OBtwlll5
	yPioUsPqZ1o8GoCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D2D6E3EA61;
	Thu, 29 Jan 2026 09:08:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XroeM3cje2l9CgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 09:08:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 29 Jan 2026 10:07:57 +0100
Subject: [PATCH] slub: avoid list_lock contention from
 __refill_objects_any()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260129-b4-refill_any_trylock-v1-1-de7420b25840@suse.cz>
X-B4-Tracking: v=1; b=H4sIAGwje2kC/x2M0QpAQBAAf0X77Op2SfErkg6LzXV0J5H8u+Nxa
 mZuCOyFA1TJDZ4PCbK6CJgm0M/GTaxkiAykqdBIpepy5XkUa1vjrnb3l137RWGhTYZEOZYZxHb
 7nPP/1s3zvG3HmjxnAAAA
X-Change-ID: 20260129-b4-refill_any_trylock-160a31224193
To: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel test robot <oliver.sang@intel.com>, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3956; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=zmpKCilcQbXL+ot7k1JLUEd55SrQAzLCYoOUemDwyQQ=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWRWK5csZ/rupuZm9tB3/8w3vhP+P+0XKVCXde0o/RMg2
 /FE2HlJJ6M/CwMjB4OlmCJL9e4TjqIzlT2mefh+hBnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DA11gEwGLk4BmOrmJPa/sn7LLNqv+UWnyT5dP3OdYqKeC2eTU9UvH45denP2JjJ9Plg9WaD7GVu
 5r2XZVaaFdTutp9qb7d5ae+90mcgNvgaB/b8OPVII+dN0aEJNjpjgZa1Z6euWV31RDm/UdhYreB
 /9TudjVKDwgR/8Ub4ijo2tamtMl/hLfl8mJXb03qnr+nrLrrQxLozLyuWSfqvDuGzioaUfJ2c+W
 v+Z0fNh1yHj66s+S3Qyc/5x732Ve4U3bEri3PRLb3nyGFYtvHFk+VXWOt+1up+1al4aXImXOJIU
 ++V1+BPOGJHS05ER729e2RVcUHflwPc/CyyYAg+vq+nf0xBReqCRrVPvyryF0Wy21fcD5K9XOFq
 87LgBAA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: pcx8xeeueigi83czr7cxoq8oe85tmfwm
X-Rspamd-Queue-Id: A02DA160006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769677689-310090
X-HE-Meta: U2FsdGVkX19AJ4F2yCVFxYpmWUWDEkRRxka8i2qscqdnIb95knKSBszL9Tx6ozMP8/mEKM8CzrgPV5ydkw45JhaCcgb6koLX/gPVYAEBciBszYsestGtuORv30pVckE20rN53szMYpTdwt1d6PpvKQnNQD89YhLO1z3yE8HBpbEk717W+yfcBhTOCD9IICNj4EzKJTmvCswVcE2fdkVm/R2T/nXS0IFF3Bl+XIrie9WE+63pAen1MaOpWGwvkcrV1h8aFC0daShd0Sxm4jwMoNtQmLr+njciDrroVFFJG1vQheU2RYevJAVM+j/BG9d5lNFBq1Aphaqn+TQ7iXvLg0LpbAc2t9y8LegARWbAus35UmQM3TZwZbAEnZYVJm7d3hXZPLMelmqzK+FlyTIAnHRt1Bp9suQNI0GNljEfNQD56mC51oig5AhgOluzPx6Y9x3PgrOHT3rUYTdzjNGnUcI0x8atWdPLYxWwFLew1u49Y8BRXSUlM8K5zJMH3krYIk4t8I/V570RL5kHDxF31e9g8wZu6Oz+tbtLXXo5HjJlSckaWfObkfqv2/l8/RmWelKPdaUIrINDPsaBH8xWBPrOo5fvkvk45/bbRX68Bh3MJjOYS4d3xPjcxdxB/vNBUnGK6hn17odFK5jJzfsnFuwoRQBoasZRrWFIoNQQ2u6zOYBc+5L/TmEHi9JL5A+6pywa13KJWZ1Rg6aT3ZQ5LFFn8O869DU7mSY/wiFqbIiCgadfh04wDehNafBY9x2RJLfcmMWpdJWuPEEqIfsko1eo2actZZ3xpilP8bTomjsNzISGKgKlOUS66/K/yZJ0kwDIkDZ81KJjwqttwOVmNOyMhNw6hNvp6iFPa5eyJnEwWstqIgQdB7ZwuVdLxVmfCQtlLgDz/DO7mz2j6qmQ3m0sKiXu8O8yAcg522z9uVfUBOqYodMj+370gixczjenCXq4kmAfXWos/iKVdie
 58jaKxfU
 T7fm1T9JtBAJ2w6xA0nJZQXyBZcgYBONBoKmVcOXmK5Z1NxGA5IdZheT99eH1vQcqbLtL6bzbgPfQo57znRJJco8NliTktRVUmxaPUXmx9PJpJF7rglZuYb7/ejAikWghxCkpiuHIg5AfKMjV0fEgDwOL5GrS51PlwUkimfuNQuVusmcyvtGS2fzNqFti7NZW/2+r5bWE+jigwF0MUP3RJgWRzK3gbzPyFtBoT/Oaz49y5khIYL06t/Mbz6zzLDf9r6d3ZqoS/WiwVdvUWfhSRd0yFxLLTtmAnaHjVKXnEqdYngE/POe40FGki9ge1/CImIOnkQgXXyC4m6GqQ9glHO4SJWY5Kmd3ejEQh1TPWRfvV2J/Lr2uQT1vwaOTw7M30C9r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kernel test robot has reported a regression in the patch "slab: refill
sheaves from all nodes". When taken in isolation like this, there is
indeed a tradeoff - we prefer to use remote objects prior to allocating
new local slabs. It is replicating a behavior that existed before
sheaves for replenishing cpu (partial) slabs - now called
get_from_any_partial() to allocate a single object.

So the possibility of allocating remote objects is intended even if
remote accesses are then slower. But the profiles in the report also
suggested a contention on the list_lock spinlock. And that's something
we can try to avoid without much tradeoff - if someone else has the
spin_lock, it's more likely they are allocating from the node than
freeing to it, so we can skip it even if it means allocating a new local
slab - contributing to that lock's contention isn't worth it. It should
not result in partial slabs accumulating on the remote node.

Thus add an allow_spin parameter to __refill_objects_node() and
get_partial_node_bulk() to make the attempts from __refill_objects_any()
use only a trylock.

Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202601132136.77efd6d7-lkp@intel.com
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
To be applied on top of:
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves
---
 mm/slub.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index eb1f52a79999..ca3db3ae1afb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3378,7 +3378,8 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
 static bool get_partial_node_bulk(struct kmem_cache *s,
 				  struct kmem_cache_node *n,
-				  struct partial_bulk_context *pc)
+				  struct partial_bulk_context *pc,
+				  bool allow_spin)
 {
 	struct slab *slab, *slab2;
 	unsigned int total_free = 0;
@@ -3390,7 +3391,10 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 
 	INIT_LIST_HEAD(&pc->slabs);
 
-	spin_lock_irqsave(&n->list_lock, flags);
+	if (allow_spin)
+		spin_lock_irqsave(&n->list_lock, flags);
+	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+		return false;
 
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 		struct freelist_counters flc;
@@ -6544,7 +6548,8 @@ EXPORT_SYMBOL(kmem_cache_free_bulk);
 
 static unsigned int
 __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
-		      unsigned int max, struct kmem_cache_node *n)
+		      unsigned int max, struct kmem_cache_node *n,
+		      bool allow_spin)
 {
 	struct partial_bulk_context pc;
 	struct slab *slab, *slab2;
@@ -6556,7 +6561,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 	pc.min_objects = min;
 	pc.max_objects = max;
 
-	if (!get_partial_node_bulk(s, n, &pc))
+	if (!get_partial_node_bulk(s, n, &pc, allow_spin))
 		return 0;
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
@@ -6650,7 +6655,8 @@ __refill_objects_any(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min
 					n->nr_partial <= s->min_partial)
 				continue;
 
-			r = __refill_objects_node(s, p, gfp, min, max, n);
+			r = __refill_objects_node(s, p, gfp, min, max, n,
+						  /* allow_spin = */ false);
 			refilled += r;
 
 			if (r >= min) {
@@ -6691,7 +6697,8 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 		return 0;
 
 	refilled = __refill_objects_node(s, p, gfp, min, max,
-					 get_node(s, local_node));
+					 get_node(s, local_node),
+					 /* allow_spin = */ true);
 	if (refilled >= min)
 		return refilled;
 

---
base-commit: 6f1912181ddfcf851a6670b4fa9c7dfdaf3ed46d
change-id: 20260129-b4-refill_any_trylock-160a31224193

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


