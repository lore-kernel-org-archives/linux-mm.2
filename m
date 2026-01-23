Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32C2BD62602
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EAF6B040E; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736AE6B0410; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638F96B0411; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48A0C6B040E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:53:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14516B835C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:57 +0000 (UTC)
X-FDA: 84362313714.17.D630370
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id DAA5F1C0002
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:53:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AenYz2Wq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2jAD4uRN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AenYz2Wq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2jAD4uRN;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rV01kHooLadLBYTqNh94OxZ2PfqtzMHrFv9yp7Y7yLs=;
	b=ozLW1wznztD4WjIdGYpgQermOjn5nBP+YeP6hppFM/JHoAHx4Le2w8Uq6L5B5EM+ACWxOx
	dUFnl+RKsIK9h3eoW1SOOIajJJy1g15qN+Z4QWIGDfjQZY0ktecTn+RB5uraz8+A1Hro5g
	cUVBDwBeGHpHXTeIG7dUJdRiZpSsZTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151235; a=rsa-sha256;
	cv=none;
	b=3dYxtO/Q/KpodpQ3rhzbz10giOBo2g4CnfQCKSuIHl3JmnwSzimL4Vw1BKcvDa8c7fPqIg
	Eh8GnDNje3D5rvHGM1zqlvwlKIKuob386iLC5A3eL/TPj+Rmm4LNiXqBUWon+7FxO3p389
	AhvV9mCivdCZDMODz6XaDs90yjuBlKI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AenYz2Wq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2jAD4uRN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=AenYz2Wq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2jAD4uRN;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C13383376E;
	Fri, 23 Jan 2026 06:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rV01kHooLadLBYTqNh94OxZ2PfqtzMHrFv9yp7Y7yLs=;
	b=AenYz2WqR3hKBS9aBpv7ivOXMmyu4wNyqUZbqps1NSt+kGHN+Hg4CM8nbtrz/G0/EMGZ0S
	vRpMKgc0Np/hDHEYd/KCQs7N0AU3Xkw5B4rJWPDFkBNNZuAGNPGW7JJLK7sVtloXKSAbUS
	GsjlCQpbQYItiBMXcTIDWjfRR+vPRPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rV01kHooLadLBYTqNh94OxZ2PfqtzMHrFv9yp7Y7yLs=;
	b=2jAD4uRN7yVkafUmQ6e2z6pai0Yh+Rxx1wcA+rdjuphJZY6YSliIksLbgBtXQJl+yDpbh3
	VBY6BcesMhKRusBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rV01kHooLadLBYTqNh94OxZ2PfqtzMHrFv9yp7Y7yLs=;
	b=AenYz2WqR3hKBS9aBpv7ivOXMmyu4wNyqUZbqps1NSt+kGHN+Hg4CM8nbtrz/G0/EMGZ0S
	vRpMKgc0Np/hDHEYd/KCQs7N0AU3Xkw5B4rJWPDFkBNNZuAGNPGW7JJLK7sVtloXKSAbUS
	GsjlCQpbQYItiBMXcTIDWjfRR+vPRPE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151190;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rV01kHooLadLBYTqNh94OxZ2PfqtzMHrFv9yp7Y7yLs=;
	b=2jAD4uRN7yVkafUmQ6e2z6pai0Yh+Rxx1wcA+rdjuphJZY6YSliIksLbgBtXQJl+yDpbh3
	VBY6BcesMhKRusBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6A43139EF;
	Fri, 23 Jan 2026 06:53:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sH8GONUac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:46 +0100
Subject: [PATCH v4 08/22] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-8-041323d506f7@suse.cz>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
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
X-Rspamd-Queue-Id: DAA5F1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 79gm4834zxii568rgfk6umbd6qytrujy
X-HE-Tag: 1769151234-959061
X-HE-Meta: U2FsdGVkX19zz67TOBjQREhfD3TzMjUXDmcMfFSPSoo/kx3tZ7EK3wGre/W9fslcG9cSMHu2B7a5Tz2txMSVlcdv5WeHUmxdXAB8L+hKyfzLh9rf/v09RmbcAqk3YLIbIP8z3jMsEwQ5UuwVa/qDRjcIw73IE+SwqgqLrhoOFf4PBwPhGdZ1Jp52H9tYAKaZn6Ckig5Ud/8hQU9vP+1bopyxWKcXtNLb0hSQzCrNrRlgO7TI9B+cfrMfPgeMGj+gfvams3Moba6LyzAbxQYhsH5j1b8vRf3CbX2XPpBvcRYBtefIUnXmzmWThYlS+1FRJpqXUSECw/kLoThPhU0izR/wiU1NjwVZ79ehjr3bNEO7LT3kEPJDLDw3aO1irUI7kfkr4uLGjEyEdGzi+XkzDOsGawkSwAMt9jSvZyVGlAJjDjMLRYsbfNJS8g9WVv0tDzLLzB3smRyhUWO0mXv837n40CVHknEdmGIuFiGcNvXplDgZzJEzn3Yr38Txpxwj+qvNIW2KiQPalgfoiF6PKMk+tJujHpv02bUAGuv7b9wGOacV3t2+CcoerLEUSQqZZlx9oEoDYqe3W8qt26n0qAtE9LRokccNrEc1Mt+3V8ieeWhNz8ak4JPLdTU5HkdBdDDjo4MrzpJr/tr7txplBOrumpIt/QSEEA3burT1KEChYwKxxLU9NR+DpTKdn0ycCJ+ks32Wy/Dy8ODHQ+aQygCSz7G8dI8e1zV3acL5/Wc8np7/4aKO7Dshaj/iYfRtl5MDY5S6opB2Nocz93w+2JKOVyPULqT8RNftxBjsbReCroHyMBbTMgqPKoE9/g0Pfpdx0VB22eW41xxz9Smc9jFsPvjrS+XAKQZ/Nis/KZBf3ennM4xBnTeTkI3rOnWSqzrh48iOTb1x0DecqkiDUueQvUdWaoOtH3rtVE7J36isOto/WUzwbvdHsXrPz/h/gMLZA5Xf/2V4vlwRzJL
 bX0e1OeZ
 5y3WB4jaIrpYqL05aGywa94fnJyhEd9kgv4HaXRx0+sFK7LpV5cy6Pkrx8a2lBv1XKK2EJREOn0GRPXpAyOkebogzqaKlazJFfpBdmG1NZiKIpvcB/0ABR/FGhtKE/Haad7MHXJs6r6Hr47LjOT4qvoMkeQZTHvSuS6CgNHLkT0AG1x2JT+QtpxsI+KeZDq2/R/XdwWAJhQan4hrQI6Dlq97AvWNCA4RnQWIZ6ZGJM6AUypJ4s2NGCB+gYxe3tHxSUfqUIB2wi/dwW+QZHY6CWo9afdRdx1EhvkM7petNZjiO6ibwW6HgIlKB729hdFgdb/diLJlFp06Ll9eHIOMDSUi/KA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before we enable percpu sheaves for kmalloc caches, we need to make sure
kmalloc_nolock() and kfree_nolock() will continue working properly and
not spin when not allowed to.

Percpu sheaves themselves use local_trylock() so they are already
compatible. We just need to be careful with the barn->lock spin_lock.
Pass a new allow_spin parameter where necessary to use
spin_trylock_irqsave().

In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
for now it will always fail until we enable sheaves for kmalloc caches
next. Similarly in kfree_nolock() we can attempt free_to_pcs().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 60 insertions(+), 22 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 41e1bf35707c..4ca6bd944854 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2889,7 +2889,8 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
-static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
+static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
+					       bool allow_spin)
 {
 	struct slab_sheaf *empty = NULL;
 	unsigned long flags;
@@ -2897,7 +2898,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
 	if (!data_race(barn->nr_empty))
 		return NULL;
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
 
 	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty,
@@ -2974,7 +2978,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
  * change.
  */
 static struct slab_sheaf *
-barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
+barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
+			 bool allow_spin)
 {
 	struct slab_sheaf *full = NULL;
 	unsigned long flags;
@@ -2982,7 +2987,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
 	if (!data_race(barn->nr_full))
 		return NULL;
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
 
 	if (likely(barn->nr_full)) {
 		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
@@ -3003,7 +3011,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
  * barn. But if there are too many full sheaves, reject this with -E2BIG.
  */
 static struct slab_sheaf *
-barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
+barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
+			bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	unsigned long flags;
@@ -3014,7 +3023,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
 	if (!data_race(barn->nr_empty))
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return ERR_PTR(-EBUSY);
 
 	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
@@ -5008,7 +5020,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main);
+	full = barn_replace_empty_sheaf(barn, pcs->main,
+					gfpflags_allow_spinning(gfp));
 
 	if (full) {
 		stat(s, BARN_GET);
@@ -5025,7 +5038,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			empty = pcs->spare;
 			pcs->spare = NULL;
 		} else {
-			empty = barn_get_empty_sheaf(barn);
+			empty = barn_get_empty_sheaf(barn, true);
 		}
 	}
 
@@ -5165,7 +5178,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 }
 
 static __fastpath_inline
-unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
+unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
+				 void **p)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *main;
@@ -5199,7 +5213,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			return allocated;
 		}
 
-		full = barn_replace_empty_sheaf(barn, pcs->main);
+		full = barn_replace_empty_sheaf(barn, pcs->main,
+						gfpflags_allow_spinning(gfp));
 
 		if (full) {
 			stat(s, BARN_GET);
@@ -5700,7 +5715,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	struct kmem_cache *s;
 	bool can_retry = true;
-	void *ret = ERR_PTR(-EBUSY);
+	void *ret;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 				      __GFP_NO_OBJ_EXT));
@@ -5731,6 +5746,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 		 */
 		return NULL;
 
+	ret = alloc_from_pcs(s, alloc_gfp, node);
+	if (ret)
+		goto success;
+
+	ret = ERR_PTR(-EBUSY);
+
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
@@ -5767,6 +5788,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 		ret = NULL;
 	}
 
+success:
 	maybe_wipe_obj_freeptr(s, ret);
 	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
 			     slab_want_init_on_alloc(alloc_gfp, s), size);
@@ -6087,7 +6109,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
+__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
+			bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	struct node_barn *barn;
@@ -6111,7 +6134,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 	put_fail = false;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 		if (empty) {
 			pcs->spare = pcs->main;
 			pcs->main = empty;
@@ -6125,7 +6148,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 		return pcs;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main);
+	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
 
 	if (!IS_ERR(empty)) {
 		stat(s, BARN_PUT);
@@ -6133,7 +6156,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 		return pcs;
 	}
 
-	if (PTR_ERR(empty) == -E2BIG) {
+	/* sheaf_flush_unused() doesn't support !allow_spin */
+	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
 		/* Since we got here, spare exists and is full */
 		struct slab_sheaf *to_flush = pcs->spare;
 
@@ -6158,6 +6182,14 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 alloc_empty:
 	local_unlock(&s->cpu_sheaves->lock);
 
+	/*
+	 * alloc_empty_sheaf() doesn't support !allow_spin and it's
+	 * easier to fall back to freeing directly without sheaves
+	 * than add the support (and to sheaf_flush_unused() above)
+	 */
+	if (!allow_spin)
+		return NULL;
+
 	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
 	if (empty)
 		goto got_empty;
@@ -6200,7 +6232,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
  * The object is expected to have passed slab_free_hook() already.
  */
 static __fastpath_inline
-bool free_to_pcs(struct kmem_cache *s, void *object)
+bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 
@@ -6211,7 +6243,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
 
 	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
 
-		pcs = __pcs_replace_full_main(s, pcs);
+		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
 		if (unlikely(!pcs))
 			return false;
 	}
@@ -6333,7 +6365,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, true);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6453,7 +6485,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto no_empty;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, true);
 		if (!empty)
 			goto no_empty;
 
@@ -6467,7 +6499,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto do_free;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main);
+	empty = barn_replace_full_sheaf(barn, pcs->main, true);
 	if (IS_ERR(empty)) {
 		stat(s, BARN_PUT_FAIL);
 		goto no_empty;
@@ -6719,7 +6751,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
 	    && likely(!slab_test_pfmemalloc(slab))) {
-		if (likely(free_to_pcs(s, object)))
+		if (likely(free_to_pcs(s, object, true)))
 			return;
 	}
 
@@ -6980,6 +7012,12 @@ void kfree_nolock(const void *object)
 	 * since kasan quarantine takes locks and not supported from NMI.
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
+
+	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())) {
+		if (likely(free_to_pcs(s, x, false)))
+			return;
+	}
+
 	do_slab_free(s, slab, x, x, 0, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
@@ -7532,7 +7570,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		size--;
 	}
 
-	i = alloc_from_pcs_bulk(s, size, p);
+	i = alloc_from_pcs_bulk(s, flags, size, p);
 
 	if (i < size) {
 		/*

-- 
2.52.0


