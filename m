Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A22C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:18:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A7296B00C1; Mon, 12 Jan 2026 10:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EB56B00C3; Mon, 12 Jan 2026 10:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4508A6B00C4; Mon, 12 Jan 2026 10:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301D26B00C1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:18:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 010095914C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:18:02 +0000 (UTC)
X-FDA: 84323667246.20.7A2B079
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8243D20008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:18:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3Ha3gYTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ijhgWGba;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3Ha3gYTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ijhgWGba;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcLFQc/ui+avkUrpYqgT4MBi/dIYNzGpd9WjmG235Uw=;
	b=skjff6mJxoWpF6iy3HA/XHQNyQv4TbO43JOGMCe+jZk4cjQLBf7v7Qy8TMSGNjlZ0yF4YK
	twNtfMoWIf+I+Mea3Q3GDrghO0kxTKA9tqLKGJeI6r+rFwSVYeSbCVFVyJj97iVVjj/Z9W
	R+jq3HXJO9pSZO4m203PVZ27fFggJQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3Ha3gYTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ijhgWGba;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3Ha3gYTY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ijhgWGba;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231080; a=rsa-sha256;
	cv=none;
	b=1w4q1mbUIofBI1yFQdsmA/2K/tmAksHHdWiLB8U5Fgpk7ErISb8R2Z4vntN529Q0cl2j6+
	X3VMnW5qSJO/asMYfq4SNyvU8eCRqHn4iZAX9Qf+XbGYDB82B+4czuMN6SAph+GucoWxKt
	/ESIn1Q5HRHzH0cS9/P7/LimuU3uUaY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A5813369E;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcLFQc/ui+avkUrpYqgT4MBi/dIYNzGpd9WjmG235Uw=;
	b=3Ha3gYTYMkAp0k2csUWBRgFMxZauK9hIstRMymCLWHmxQ9pbAphx03QfwprRLXDRTa0Tk4
	fLvkpgjOI9fxV1Zr87CSt7g3A1s5yunn5SJTQhZAOHn7lfSBelAjFMlmRBz4LDxPQQWOjW
	3RnQoYgG7QLlfNkp5diL8AbSs/CYn3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcLFQc/ui+avkUrpYqgT4MBi/dIYNzGpd9WjmG235Uw=;
	b=ijhgWGbaqGYDleqnHf6BsKhdCVAZkof16po9Trw4b9uUvSKEmJMiWyjv0/02kvop+Xjqnj
	v+ev4PX53iVe0WCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcLFQc/ui+avkUrpYqgT4MBi/dIYNzGpd9WjmG235Uw=;
	b=3Ha3gYTYMkAp0k2csUWBRgFMxZauK9hIstRMymCLWHmxQ9pbAphx03QfwprRLXDRTa0Tk4
	fLvkpgjOI9fxV1Zr87CSt7g3A1s5yunn5SJTQhZAOHn7lfSBelAjFMlmRBz4LDxPQQWOjW
	3RnQoYgG7QLlfNkp5diL8AbSs/CYn3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231019;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcLFQc/ui+avkUrpYqgT4MBi/dIYNzGpd9WjmG235Uw=;
	b=ijhgWGbaqGYDleqnHf6BsKhdCVAZkof16po9Trw4b9uUvSKEmJMiWyjv0/02kvop+Xjqnj
	v+ev4PX53iVe0WCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E0473EA63;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CHOXGmsQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:59 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:17:13 +0100
Subject: [PATCH RFC v2 19/20] mm/slub: remove DEACTIVATE_TO_* stat items
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-19-98225cfb50cf@suse.cz>
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
X-Stat-Signature: wm7shsgte8jx7qcoqw4819m7jd6j98bf
X-Rspam-User: 
X-Rspamd-Queue-Id: 8243D20008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768231080-938466
X-HE-Meta: U2FsdGVkX18ykVz6MW9ooSfbJUxoiQM8223sACLJquS52TpNSZNZPsBSuPLNZcnFsGqeSWOSwKqLJj5fXB4xz/RPvonrG9ZiFyUwwbsuuPqHUh/1zwLu4SovLaQulFolAygwkE0F4HCyIyfsiQxuMTCEd7ELeqM7CV/OpyeVYstD0BbQVBXdXXAnkpsR8zpBrdkyHiSV+ZuYwJpS13KICA/2Vd31UiqNGybSeXu0n3F8JopmxeOSWcuzJ8z12FwYASkcA3vQDd6SeaWj5Bff+N0sFMquVeQiQ7fnykCpYRElAmt1AEwltqdTEkjn+sNxAjnlbJDST9YHFTG5GGQaP0yUDkCc9tNzAS/ze1F3QSo3zcffZxyttXHJYXYIG3+C+hPNusoMPnYV++3Hi0ulmL9vIAwtAzb8TRPOmE2leI2vBQVY6KJa4v5wu270Ig5pw6WXJotMYFFnj9Gl7X/y2AI8nCaDl1wYlXJniRRxbiI1t0oNmkv6UZFufnl5ZekBIdyvydXvKvEgoDlY4cTCq5w6mnuStNHIYvayjZf8fQj16PxS2Hzn3aP3vQzTZFaaEecm4aTezByqGFpkw9CJNAIJ6nJQeVP8TZz+ev/8AafBzbfnKsPOhig+IFDOgunmkjJv+okSewj7o9RPD45NwAfY8asggRs7RoSxAtydvhTc4mUUsDoSPgIokiaZotFhzw1U4A/55HAo1bsXbikb4X0nrjm0vTHxHhecmg6qB34zB9iOxcg7oktGJWppKLRc8JAKo9Z+DxVv2aEJm8/RC4+rgX06FudYJkruHoavxqZzdjQK7ZZJ2tVB/Kta9WvqSZ91y6DjBmb02VxMOH09Hjg5JZHb69JfsE71i1Vrae0+QGo47GuEqMztSaMbWpAcLDBk1GrLLUT/Ldgbt90IJlW1iAcXLtiDg9T5sgHBsm9IRvzZf6pejCQMCZZZAeD12V28XDfdfNYVJ2WatpZ
 RX3djgQw
 jja3zIYPRFF6MElViqC16SxC8FQEB5/yayTBwa6rIn0Map8/u+owl4ODr4D1F9YpQFkAxpPZ1KE+Yot/8QQq9htnFQHV8iMz2YDksJwSVnj3Sy4TkNQ99Y7NFn21kOeVeoqSo4CbVlNNB4laLqBRkcEf4cVt+NBcR4/7yg7RqWpA1RFIwZ1ybc3L/GNlavm1Uq5uJxGpE/WEJy6E9Jm4zO8KNNodBmo34bceR1ldKEwlOX+rhgtFiH0ZVOFJSDoezu4nfvVmqqOX/U6sP9zB9Amk2X1qhey8uqnhBKWiTH7occ+q/xsjOvuNTa5UJ3Lm6eJJAw83rvmeFjiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cpu slabs and their deactivations were removed, so remove the unused
stat items. Weirdly enough the values were also used to control
__add_partial() adding to head or tail of the list, so replace that with
a new enum add_mode, which is cleaner.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 5b2d7c387646..a473fa29a905 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -324,6 +324,11 @@ static void debugfs_slab_add(struct kmem_cache *);
 static inline void debugfs_slab_add(struct kmem_cache *s) { }
 #endif
 
+enum add_mode {
+	ADD_TO_HEAD,
+	ADD_TO_TAIL,
+};
+
 enum stat_item {
 	ALLOC_PCS,		/* Allocation from percpu sheaf */
 	ALLOC_FASTPATH,		/* Allocation from cpu slab */
@@ -343,8 +348,6 @@ enum stat_item {
 	CPUSLAB_FLUSH,		/* Abandoning of the cpu slab */
 	DEACTIVATE_FULL,	/* Cpu slab was full when deactivated */
 	DEACTIVATE_EMPTY,	/* Cpu slab was empty when deactivated */
-	DEACTIVATE_TO_HEAD,	/* Cpu slab was moved to the head of partials */
-	DEACTIVATE_TO_TAIL,	/* Cpu slab was moved to the tail of partials */
 	DEACTIVATE_REMOTE_FREES,/* Slab contained remotely freed objects */
 	DEACTIVATE_BYPASS,	/* Implicit deactivation */
 	ORDER_FALLBACK,		/* Number of times fallback was necessary */
@@ -3253,10 +3256,10 @@ static inline void slab_clear_node_partial(struct slab *slab)
  * Management of partially allocated slabs.
  */
 static inline void
-__add_partial(struct kmem_cache_node *n, struct slab *slab, int tail)
+__add_partial(struct kmem_cache_node *n, struct slab *slab, enum add_mode mode)
 {
 	n->nr_partial++;
-	if (tail == DEACTIVATE_TO_TAIL)
+	if (mode == ADD_TO_TAIL)
 		list_add_tail(&slab->slab_list, &n->partial);
 	else
 		list_add(&slab->slab_list, &n->partial);
@@ -3264,10 +3267,10 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, int tail)
 }
 
 static inline void add_partial(struct kmem_cache_node *n,
-				struct slab *slab, int tail)
+				struct slab *slab, enum add_mode mode)
 {
 	lockdep_assert_held(&n->list_lock);
-	__add_partial(n, slab, tail);
+	__add_partial(n, slab, mode);
 }
 
 static inline void remove_partial(struct kmem_cache_node *n,
@@ -3360,7 +3363,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	if (slab->inuse == slab->objects)
 		add_full(s, n, slab);
 	else
-		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		add_partial(n, slab, ADD_TO_HEAD);
 
 	inc_slabs_node(s, nid, slab->objects);
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3979,7 +3982,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 			n = get_node(s, slab_nid(slab));
 			spin_lock_irqsave(&n->list_lock, flags);
 		}
-		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		add_partial(n, slab, ADD_TO_HEAD);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
@@ -5054,7 +5057,7 @@ static noinline void free_to_partial_list(
 			/* was on full list */
 			remove_full(s, n, slab);
 			if (!slab_free) {
-				add_partial(n, slab, DEACTIVATE_TO_TAIL);
+				add_partial(n, slab, ADD_TO_TAIL);
 				stat(s, FREE_ADD_PARTIAL);
 			}
 		} else if (slab_free) {
@@ -5174,7 +5177,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	 * then add it.
 	 */
 	if (unlikely(was_full)) {
-		add_partial(n, slab, DEACTIVATE_TO_TAIL);
+		add_partial(n, slab, ADD_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -6557,7 +6560,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 				continue;
 
 			list_del(&slab->slab_list);
-			add_partial(n, slab, DEACTIVATE_TO_HEAD);
+			add_partial(n, slab, ADD_TO_HEAD);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
@@ -7025,7 +7028,7 @@ static void early_kmem_cache_node_alloc(int node)
 	 * No locks need to be taken here as it has just been
 	 * initialized and there is no concurrent access.
 	 */
-	__add_partial(n, slab, DEACTIVATE_TO_HEAD);
+	__add_partial(n, slab, ADD_TO_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -8713,8 +8716,6 @@ STAT_ATTR(FREE_SLAB, free_slab);
 STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
 STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
-STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
-STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
@@ -8817,8 +8818,6 @@ static struct attribute *slab_attrs[] = {
 	&cpuslab_flush_attr.attr,
 	&deactivate_full_attr.attr,
 	&deactivate_empty_attr.attr,
-	&deactivate_to_head_attr.attr,
-	&deactivate_to_tail_attr.attr,
 	&deactivate_remote_frees_attr.attr,
 	&deactivate_bypass_attr.attr,
 	&order_fallback_attr.attr,

-- 
2.52.0


