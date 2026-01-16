Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B81C982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA356B0096; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E80296B0098; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D610C6B0099; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF68A6B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DFDB87BF1
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:59 +0000 (UTC)
X-FDA: 84338089038.23.E96136F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5735010000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eBUInVZl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AcF4CfXc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eBUInVZl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AcF4CfXc;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yl3tYq1zkCSfFGXX17TFoPzKLhUlXL9wcLcMPsj5qcU=;
	b=4wmlCJdfeFSgZ+4jSwKKPAC7nHoyeSlAbRsSvVV20rSiE2wAmZ+52U6z9ljQu8CFR3FLeM
	6MFcAeNuPIrq0nz2T0WrQRMbmG/9YMs7ZVBnC2RxgSk5IBNAutko9w1DRB0CtAr+jPV44O
	LU8ssCBCgVOTzmiOAMU/k89S/e+5SSw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eBUInVZl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AcF4CfXc;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eBUInVZl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AcF4CfXc;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574457; a=rsa-sha256;
	cv=none;
	b=uGkWeig04TeBLGwrZkjMfXiRhVSc4bRdqZ/kveDJZZ78uxmP96rHOYz2Gq5bffM1Xc5Jbb
	8UMuQvYN78aYtQO9VYWf6Ln7OjKkGZjEHorfnE9BP5TyfhUK50apsu5r+DBldGfJhRYDVn
	zTVSU6VNKMjBvdfZ5DuBHg/mx3XmMrA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 608FB5BE8E;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yl3tYq1zkCSfFGXX17TFoPzKLhUlXL9wcLcMPsj5qcU=;
	b=eBUInVZlsfM62xCRi9PSa9SInSqzDim8TMFErvNwdWwrb7uIzrIzbRZN7GRRRH5acoDITK
	++BIwcbj3SNh7gdhEAwL9l1AsB7OMB4wmdslYgxzt6lNjnhDXRbzQT5AVAVmAGl+Mvujzu
	HXey/nl7IBmN+4eNAwjRSD7guXQgAsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yl3tYq1zkCSfFGXX17TFoPzKLhUlXL9wcLcMPsj5qcU=;
	b=AcF4CfXcDC9UBWca5o7wS/UAZmw26++7J4KQXT9ZIpgfthYaEyHTFzNEHh0ZU8qHMVJ9PG
	UNz3IvoKmg/DFoDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yl3tYq1zkCSfFGXX17TFoPzKLhUlXL9wcLcMPsj5qcU=;
	b=eBUInVZlsfM62xCRi9PSa9SInSqzDim8TMFErvNwdWwrb7uIzrIzbRZN7GRRRH5acoDITK
	++BIwcbj3SNh7gdhEAwL9l1AsB7OMB4wmdslYgxzt6lNjnhDXRbzQT5AVAVmAGl+Mvujzu
	HXey/nl7IBmN+4eNAwjRSD7guXQgAsw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yl3tYq1zkCSfFGXX17TFoPzKLhUlXL9wcLcMPsj5qcU=;
	b=AcF4CfXcDC9UBWca5o7wS/UAZmw26++7J4KQXT9ZIpgfthYaEyHTFzNEHh0ZU8qHMVJ9PG
	UNz3IvoKmg/DFoDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44C6A3EA63;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oBFwEOVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:27 +0100
Subject: [PATCH v3 07/21] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-7-5595cb000772@suse.cz>
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
X-Stat-Signature: yy4mk47yh9hukdic5qdic17fyoxxb85o
X-Rspam-User: 
X-Rspamd-Queue-Id: 5735010000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768574457-64031
X-HE-Meta: U2FsdGVkX18ijxJYfOmMYyHe3/I5ZUGoaxXTsGQxly5ZTg2FvWGDoN400OF5pOpyJnnTRruAMuLHMyeOBVe/M/baQY7JKzOWXdXAegwg1LQK7RO/jlI81PIQEGPa4sgWzGDLO2gJ2cZxOMU5gGhXW7tpMpPQRlkwB0eq3GrCcvISJebPY6NnVqiwrrb/gE+fGH3wwnlpFKa76KfgebTToOKu1BGqo7K2wMS4yRUXsJeaNQiDDvDA4dOcsZS6rhB8nVqLvxuU6sYuw6JuZpLcSv+mqe1zdJy2MHeJh41Yu+vK3FfIFY0tHoGokV1XE5xZZIKaCMcDL5MhvojfqOqAQXKXMZKdPhcY6cw6sS8ZROcgKisX2Gfb8+GBQjzfNSYU+wQJZD/PCU8FK7Wop+wZ5Uos2zYzJOot5utirDJR2TVAH31kdxHj/4ukZ0B0BaEIu5IlxWE6kymnxLINxiV0oUyWXk++hkGvqgh8mfx9ug+KpfBwbYrSGxwr4MC1iobjEYTR39deEctE1xb8MaQPB5rxfEWewcW0TOvkKAXKexO7HmginqRZm9lfSjlbE4wO21O3GU6l6uVkuDy9v/jyp4ORGEQ/M3TVZM7sUAsRFKiPQxZ0VhGqhcDAhxnBtmcaL74JkqwATWIA2D9jOukydn0raAx0jk52NU7VE8F2VtxV3LuQyebTAdmOxQIK9dhgQO3Ec7cb6+bm7PYQmLjQVa5h7XQoGWbul0cBWTvu44PqMq95V042yoGuwGHTv8gWBcrrzSACVU+O2lxlY0MzD91z8ufTR0mmMzbWweO8C937598lXRIJTQxgJ20QV5CqBTXZ15zFCpPdmCUVLAgi9PurCQkbi1fTgRJA1AR05zlVdfEimW1bK4mf81QwYw9x8hozUrKZhfod9HW86P+NA+tfYnNs+/kN+OeTqhLXCf0rUL3c4mqnrW0KKG74X7cVuq70QYqX+UZVD4wGkFH
 5ZZRcgTv
 XfVgDW5wk3L61N67sNrl9iw/SLZsaIXP+cj5Y0+I8ZBgTCZ/25XwzDGCpFU+WEQa+DG7Q9RGDgxP8yA7vdbrKqdVijYaQLc8jP5KaHzlNS4ZLFvdoS4dBhSa+xzqqMFb6CBR2HPmYvnyrosoKARUbdAO1lJQE6ef5utAV5Lz/Pnag13agPcRrktHe5Bp4GOL/Z0Tn0E/+00+c2PS59A3vrLl+8YbgjUomewrv0Gp5qtffnMNiowBc7fWTSlTO3Yn6tw4vXQGm2dDF+xskw76kH56fXtT5oDRr0fP3ekvphPZUCVA=
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

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 706cb6398f05..b385247c219f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2893,7 +2893,8 @@ static void pcs_destroy(struct kmem_cache *s)
 	s->cpu_sheaves = NULL;
 }
 
-static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
+static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
+					       bool allow_spin)
 {
 	struct slab_sheaf *empty = NULL;
 	unsigned long flags;
@@ -2901,7 +2902,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
 	if (!data_race(barn->nr_empty))
 		return NULL;
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
 
 	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty,
@@ -2978,7 +2982,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sheaf(struct node_barn *barn)
  * change.
  */
 static struct slab_sheaf *
-barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
+barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
+			 bool allow_spin)
 {
 	struct slab_sheaf *full = NULL;
 	unsigned long flags;
@@ -2986,7 +2991,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
 	if (!data_race(barn->nr_full))
 		return NULL;
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return NULL;
 
 	if (likely(barn->nr_full)) {
 		full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
@@ -3007,7 +3015,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
  * barn. But if there are too many full sheaves, reject this with -E2BIG.
  */
 static struct slab_sheaf *
-barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
+barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
+			bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	unsigned long flags;
@@ -3018,7 +3027,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
 	if (!data_race(barn->nr_empty))
 		return ERR_PTR(-ENOMEM);
 
-	spin_lock_irqsave(&barn->lock, flags);
+	if (likely(allow_spin))
+		spin_lock_irqsave(&barn->lock, flags);
+	else if (!spin_trylock_irqsave(&barn->lock, flags))
+		return ERR_PTR(-EBUSY);
 
 	if (likely(barn->nr_empty)) {
 		empty = list_first_entry(&barn->sheaves_empty, struct slab_sheaf,
@@ -5012,7 +5024,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return NULL;
 	}
 
-	full = barn_replace_empty_sheaf(barn, pcs->main);
+	full = barn_replace_empty_sheaf(barn, pcs->main,
+					gfpflags_allow_spinning(gfp));
 
 	if (full) {
 		stat(s, BARN_GET);
@@ -5029,7 +5042,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 			empty = pcs->spare;
 			pcs->spare = NULL;
 		} else {
-			empty = barn_get_empty_sheaf(barn);
+			empty = barn_get_empty_sheaf(barn, true);
 		}
 	}
 
@@ -5169,7 +5182,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 }
 
 static __fastpath_inline
-unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
+unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
+				 void **p)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *main;
@@ -5203,7 +5217,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 			return allocated;
 		}
 
-		full = barn_replace_empty_sheaf(barn, pcs->main);
+		full = barn_replace_empty_sheaf(barn, pcs->main,
+						gfpflags_allow_spinning(gfp));
 
 		if (full) {
 			stat(s, BARN_GET);
@@ -5701,7 +5716,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
 	struct kmem_cache *s;
 	bool can_retry = true;
-	void *ret = ERR_PTR(-EBUSY);
+	void *ret;
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 				      __GFP_NO_OBJ_EXT));
@@ -5732,6 +5747,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
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
@@ -5768,6 +5789,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 		ret = NULL;
 	}
 
+success:
 	maybe_wipe_obj_freeptr(s, ret);
 	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
 			     slab_want_init_on_alloc(alloc_gfp, s), size);
@@ -6088,7 +6110,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
  * unlocked.
  */
 static struct slub_percpu_sheaves *
-__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
+__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
+			bool allow_spin)
 {
 	struct slab_sheaf *empty;
 	struct node_barn *barn;
@@ -6112,7 +6135,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 	put_fail = false;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, allow_spin);
 		if (empty) {
 			pcs->spare = pcs->main;
 			pcs->main = empty;
@@ -6126,7 +6149,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 		return pcs;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main);
+	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
 
 	if (!IS_ERR(empty)) {
 		stat(s, BARN_PUT);
@@ -6134,7 +6157,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
 		return pcs;
 	}
 
-	if (PTR_ERR(empty) == -E2BIG) {
+	/* sheaf_flush_unused() doesn't support !allow_spin */
+	if (PTR_ERR(empty) == -E2BIG && allow_spin) {
 		/* Since we got here, spare exists and is full */
 		struct slab_sheaf *to_flush = pcs->spare;
 
@@ -6159,6 +6183,14 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
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
@@ -6201,7 +6233,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
  * The object is expected to have passed slab_free_hook() already.
  */
 static __fastpath_inline
-bool free_to_pcs(struct kmem_cache *s, void *object)
+bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 
@@ -6212,7 +6244,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object)
 
 	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
 
-		pcs = __pcs_replace_full_main(s, pcs);
+		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
 		if (unlikely(!pcs))
 			return false;
 	}
@@ -6319,7 +6351,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 		}
 
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, true);
 
 		if (empty) {
 			pcs->rcu_free = empty;
@@ -6437,7 +6469,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto no_empty;
 
 	if (!pcs->spare) {
-		empty = barn_get_empty_sheaf(barn);
+		empty = barn_get_empty_sheaf(barn, true);
 		if (!empty)
 			goto no_empty;
 
@@ -6451,7 +6483,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto do_free;
 	}
 
-	empty = barn_replace_full_sheaf(barn, pcs->main);
+	empty = barn_replace_full_sheaf(barn, pcs->main, true);
 	if (IS_ERR(empty)) {
 		stat(s, BARN_PUT_FAIL);
 		goto no_empty;
@@ -6703,7 +6735,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 
 	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
 	    && likely(!slab_test_pfmemalloc(slab))) {
-		if (likely(free_to_pcs(s, object)))
+		if (likely(free_to_pcs(s, object, true)))
 			return;
 	}
 
@@ -6964,7 +6996,8 @@ void kfree_nolock(const void *object)
 	 * since kasan quarantine takes locks and not supported from NMI.
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
-	do_slab_free(s, slab, x, x, 0, _RET_IP_);
+	if (!free_to_pcs(s, x, false))
+		do_slab_free(s, slab, x, x, 0, _RET_IP_);
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
 
@@ -7516,7 +7549,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
 		size--;
 	}
 
-	i = alloc_from_pcs_bulk(s, size, p);
+	i = alloc_from_pcs_bulk(s, flags, size, p);
 
 	if (i < size) {
 		/*

-- 
2.52.0


