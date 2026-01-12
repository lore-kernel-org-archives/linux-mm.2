Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F5FCC9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C853D6B00A2; Mon, 12 Jan 2026 10:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A8E6B00A3; Mon, 12 Jan 2026 10:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0306B00A4; Mon, 12 Jan 2026 10:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9501D6B00A2
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 53DD91A045F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:13 +0000 (UTC)
X-FDA: 84323665146.14.463CCCC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D823C000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HkJ5ezc7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QTmyckr4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HkJ5ezc7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QTmyckr4;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2g8lMsPgMhUe+Zak9uNfJ1KurP7aWlEZWc/PUq01OM=;
	b=yqc/k2a8nDFOAgJaMEQJ97ZaFubIlS6RJ8zHDsNCcigq5aXl1/UIZwAKm9pn9sdvATIZQf
	YwoYFGgR9UhcMnd13mngEleiq1s+mPP/djINccn88zNtYResfZhmlrWazzlbb38T7qa8wF
	DKB0WdppUL2BMHtve4KrabqcxPuwqwA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HkJ5ezc7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QTmyckr4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HkJ5ezc7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QTmyckr4;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231031; a=rsa-sha256;
	cv=none;
	b=6wSl26UGkCevr5gAuEtyJgGE716+bFz0rvJ/f3GXQ6iPD+gCktKuzzdy1/+IXGQQSd8ZZU
	3c3i5qex5rxEOSmHeio1G2GbtUA9wpRVfYPxowCdd3sCPnLR/wqaGkF/XACJNKHPS+Mlaq
	G833QeA4nNTrIWN8w2JnXDot5dY3Ehc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D5F8B5BCC3;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2g8lMsPgMhUe+Zak9uNfJ1KurP7aWlEZWc/PUq01OM=;
	b=HkJ5ezc7yX2EBzEJGCjRUDHQ7RkvrtjYX5vldN6BUpO+/FUw8C02bWK9eblzisttBfDoo0
	Yuj/fFE/vceGtaRnYHFy62MNLM06oCzOVVQ5SAwRHeh7do1iD+rGGVhSRAdQZMXU1MgC9H
	PJzaWD9G2eLWlz9lpGNrUCDh++hULpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2g8lMsPgMhUe+Zak9uNfJ1KurP7aWlEZWc/PUq01OM=;
	b=QTmyckr4OBAImDmueC4+/2/GkIicVvBMk0/WqSEhxbNG4+g1ryFLU2DZKIbdiCDmaHcQq0
	cdZY7acwd2yh+uAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2g8lMsPgMhUe+Zak9uNfJ1KurP7aWlEZWc/PUq01OM=;
	b=HkJ5ezc7yX2EBzEJGCjRUDHQ7RkvrtjYX5vldN6BUpO+/FUw8C02bWK9eblzisttBfDoo0
	Yuj/fFE/vceGtaRnYHFy62MNLM06oCzOVVQ5SAwRHeh7do1iD+rGGVhSRAdQZMXU1MgC9H
	PJzaWD9G2eLWlz9lpGNrUCDh++hULpM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U2g8lMsPgMhUe+Zak9uNfJ1KurP7aWlEZWc/PUq01OM=;
	b=QTmyckr4OBAImDmueC4+/2/GkIicVvBMk0/WqSEhxbNG4+g1ryFLU2DZKIbdiCDmaHcQq0
	cdZY7acwd2yh+uAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0A423EA65;
	Mon, 12 Jan 2026 15:16:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GLLIJmkQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:57 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:16:58 +0100
Subject: [PATCH RFC v2 04/20] slab: add sheaves to most caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-4-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D823C000B
X-Stat-Signature: h99ob19np7r4rq5kicczbbjkmr6do8kz
X-HE-Tag: 1768231031-551025
X-HE-Meta: U2FsdGVkX19OYVbY/rgULkbs0ymRO3jQcITd7irHmQTOQGu58/dzp+AF38t3kUBQDO6kvwQnfH7x4/BO9qoMQDeGr6vdsxfEj3GTNL259mPRTP7B3zcEyh6+Ioonb3c8kAYsT82GT0jhXQFo4I1KZNMIZvOu/3xwImGoffWL5QflJXD3+swKjXKSZOvsNpfn73/TNpW73FXp4HYefHv8UiICBdrYzlQOf0CWBurkeGAzI0+jK+dX9h8C3Oy1rL+bBhkZzZ3fy4B59E/yskbGqcdfyjd715GFVBcFzGRkraZsV141xNYVEZv+iV4hdSLALBoIUVntgLBYs7WM7mOz10/UHpKTVwXu7a0N0uGROnIFjz6ls0PO533YlPew7zvMGNf04V4wSjJMHLJBUW4eZmqeZbcLEtMZQiXd4M3yaOqj1BmejDksbbaeYWhH0fbS86w/fFw1Qhv4sQcrht1Q7GvcR2nSRITpKw66z4n3KWb497fugw6Yut4/PLTUErGU5SJ+cc+R2KyCzs5LHHxa1FmtI+gJhiZC+nNZA240EMYgXtoQwn3y2viHE/GJgpKZdJu1KPSAHef1V744a50PUS4/ugV3OFRCFf7oBP4XKWKva/taMRySgpSaUPBURkW7H8aZD3gaBHIwpkmsHYY7jLh/JLJjmahjWeMgbc1Wl4V/yO04ogzmlnnEEL3IgAMDouKp+U/XKLZI4VFbxj2JC66cXzDUQYbqRHzPebMhEpiel6wQ0GQ8GFsgpkrn8R8DLbcAfT8PDKCvPeCxnrjAzWk6cyE7eVHXPQXAhToBcppJc2UQvChqCBp4/Ph1pKs9oFr0nhuISLMwEb0gMDT1d9S8dy26OXL62X5ZmprWf2Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the first step to replace cpu (partial) slabs with sheaves, enable
sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
and calculate sheaf capacity with a formula that roughly follows the
formula for number of objects in cpu partial slabs in set_cpu_partial().

This should achieve roughly similar contention on the barn spin lock as
there's currently for node list_lock without sheaves, to make
benchmarking results comparable. It can be further tuned later.

Don't enable sheaves for bootstrap caches as that wouldn't work. In
order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
even for !CONFIG_SLAB_OBJ_EXT.

This limitation will be lifted for kmalloc caches after the necessary
bootstrapping changes.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/slab.h |  6 ------
 mm/slub.c            | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2482992248dc..2682ee57ec90 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -57,9 +57,7 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
-#ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
-#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -238,11 +236,7 @@ enum _slab_flag_bits {
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /* Slab created using create_boot_cache */
-#ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
-#else
-#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
-#endif
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
diff --git a/mm/slub.c b/mm/slub.c
index 8ffeb3ab3228..6e05e3cc5c49 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7857,6 +7857,48 @@ static void set_cpu_partial(struct kmem_cache *s)
 #endif
 }
 
+static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
+					     struct kmem_cache_args *args)
+
+{
+	unsigned int capacity;
+	size_t size;
+
+
+	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
+		return 0;
+
+	/* bootstrap caches can't have sheaves for now */
+	if (s->flags & SLAB_NO_OBJ_EXT)
+		return 0;
+
+	/*
+	 * For now we use roughly similar formula (divided by two as there are
+	 * two percpu sheaves) as what was used for percpu partial slabs, which
+	 * should result in similar lock contention (barn or list_lock)
+	 */
+	if (s->size >= PAGE_SIZE)
+		capacity = 4;
+	else if (s->size >= 1024)
+		capacity = 12;
+	else if (s->size >= 256)
+		capacity = 26;
+	else
+		capacity = 60;
+
+	/* Increment capacity to make sheaf exactly a kmalloc size bucket */
+	size = struct_size_t(struct slab_sheaf, objects, capacity);
+	size = kmalloc_size_roundup(size);
+	capacity = (size - struct_size_t(struct slab_sheaf, objects, 0)) / sizeof(void *);
+
+	/*
+	 * Respect an explicit request for capacity that's typically motivated by
+	 * expected maximum size of kmem_cache_prefill_sheaf() to not end up
+	 * using low-performance oversize sheaves
+	 */
+	return max(capacity, args->sheaf_capacity);
+}
+
 /*
  * calculate_sizes() determines the order and the distribution of data within
  * a slab object.
@@ -7991,6 +8033,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	/* kmalloc caches need extra care to support sheaves */
+	if (!is_kmalloc_cache(s))
+		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
+
 	/*
 	 * Determine the number of objects per slab
 	 */
@@ -8595,15 +8641,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
 	set_cpu_partial(s);
 
-	if (args->sheaf_capacity && !IS_ENABLED(CONFIG_SLUB_TINY)
-					&& !(s->flags & SLAB_DEBUG_FLAGS)) {
+	if (s->sheaf_capacity) {
 		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
 		if (!s->cpu_sheaves) {
 			err = -ENOMEM;
 			goto out;
 		}
-		// TODO: increase capacity to grow slab_sheaf up to next kmalloc size?
-		s->sheaf_capacity = args->sheaf_capacity;
 	}
 
 #ifdef CONFIG_NUMA

-- 
2.52.0


