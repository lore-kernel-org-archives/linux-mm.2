Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E24CC982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC466B00BA; Fri, 16 Jan 2026 09:41:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7BD86B00BC; Fri, 16 Jan 2026 09:41:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95106B00BD; Fri, 16 Jan 2026 09:41:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 961CD6B00BA
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66FCF16017F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:52 +0000 (UTC)
X-FDA: 84338091264.29.43BB819
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3645CC000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XZ/eqAuB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=svAOfNPn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XZ/eqAuB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=svAOfNPn;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKwoNuW0XcCU6x7RZ8PJjscrQbHgYsoJBCDr/kRfhfw=;
	b=2wKy0BOmPMFVMHWvIY7aNlUu7XgPenTHzFdxVp7TKUUSA6NIdyHUc6emiU7D4rul2+U5Lj
	aGiwsK3AnFPhT4t5avTSrUAyN4ZhmuVHMhCMkm4Pdhe5VyQ+CEsyppIaTf/R+5S4FUuLl0
	TuQrPAjN2jS5nUz5GMMPAHrIx5B2mns=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XZ/eqAuB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=svAOfNPn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XZ/eqAuB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=svAOfNPn;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574510; a=rsa-sha256;
	cv=none;
	b=GjBrts66FRW5RtRos1CAs7GE1QVLXcFRDo90eAMga5S+eYKyNm76DLrLR126u+Bu5OTRsQ
	DnOHqTajywBTEn+dg5fCyYwJXPqJsJ5D1EqzL3WZQKA+4T+jDzxppDTBzjBFPnlNt2g9U8
	efzZki2eAYDKJhtKqaZp4zJwIk6nJow=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E35B9337FD;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKwoNuW0XcCU6x7RZ8PJjscrQbHgYsoJBCDr/kRfhfw=;
	b=XZ/eqAuBT7WuVhdJmN7eXywGl7+1eyE+etpinsBWT5k4S2KOKn2WVB4JQNmwSS7T4/fCUS
	/hyLQSemksIVTEcqfrE2zfzByuFKoReJeiAISwysywzne6e9IrZ6yGYnW9oYtz8clLmfR7
	GwERLirKCEvUNM9aicv6P+JnOD9vnek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKwoNuW0XcCU6x7RZ8PJjscrQbHgYsoJBCDr/kRfhfw=;
	b=svAOfNPn04sZZKaLeflwCVl7grXOPjQ9A9RtZrYa1aFi97LX/qDB2N3nSU7qqF6W5q6cKF
	3c40G3OsuUuWTBCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKwoNuW0XcCU6x7RZ8PJjscrQbHgYsoJBCDr/kRfhfw=;
	b=XZ/eqAuBT7WuVhdJmN7eXywGl7+1eyE+etpinsBWT5k4S2KOKn2WVB4JQNmwSS7T4/fCUS
	/hyLQSemksIVTEcqfrE2zfzByuFKoReJeiAISwysywzne6e9IrZ6yGYnW9oYtz8clLmfR7
	GwERLirKCEvUNM9aicv6P+JnOD9vnek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKwoNuW0XcCU6x7RZ8PJjscrQbHgYsoJBCDr/kRfhfw=;
	b=svAOfNPn04sZZKaLeflwCVl7grXOPjQ9A9RtZrYa1aFi97LX/qDB2N3nSU7qqF6W5q6cKF
	3c40G3OsuUuWTBCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7D313EA65;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SOyZLOZNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:38 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:40 +0100
Subject: [PATCH v3 20/21] mm/slub: remove DEACTIVATE_TO_* stat items
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-20-5595cb000772@suse.cz>
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
X-Rspam-User: 
X-Stat-Signature: yb9e7fc7goi88mdx8aetkdfqhn7u9yss
X-Rspamd-Queue-Id: 3645CC000E
X-Rspamd-Server: rspam04
X-HE-Tag: 1768574509-525142
X-HE-Meta: U2FsdGVkX1/g/M7srf769vBJu5K846aixW8fps3tkNJGTl6vMhHvrVj0D7I/18p9TywVUXGL2lHoxAuDcDjfFgUoJqJHXzZnsrPsPMM/qmNyx0bJNKX9WkAiVW6tZeyhd988uwc+aGwVQZK+VV7wcdAiwAVHVVwRE8pGMz0HPoHPxhJ/xs09CRUzhTUw98xDVK0W99krWBIRo9TKmiODIwgYH6o6WnH2f6/TQVazCGJpR5olms/t47ebpnwpmJ6n8l47fC2XZr7RFtaiF3A7PVAsZtnwVgp9+NIDVmStRPCk+QCnNaFf6A+mgB1zw7B4qWQW8TBcbCesnPIebYCfkvarzE21YW/Xkb2iYC3Yi95We4ayEJzMm8ueZmzVvqMgL0UhjVHtjQzyrIL/1ppbJEHh1AhHjYygwStHTxc/Xa2i/bx64CavYrNCb00OooiATn/lF1G9ULksGlH50iq08pWHfJ2WfOySSp9ErmRo+he9+DH56GMlWsUSwSR0uz1BLWjjojo5nngES4p6osuiS5QNb8429nYhCiK097/oPd582cv5/oj1S/1ji/7upvLLF/4RBkRgquuEkEOwysjT/sOU5oigwtRw2I1Km/x9LjajJsg42JCmMBeTWs0kxSYdugT+YY2wzN1PBqff+vIDUAX//qLco3cN2ooTLREm/xu8AFz7TnyTs2eGWM6Yfxjhcq1vou4EEmasDpqaYdaBHBSsi+Rs5I7xOMqUY9lRLgbTJ+UMLNjwGifQsT11WylNlaa19JauG7N5o4Gyq82Co+X/O/CALXXiPD7YROyXkOIZDyPrVHf7GSJD/oxJ5mHejLnwN6uX74vBJPk/ngo5zpfxI/+Cb9r1Zq/KZXAUOs9t0YgqI09wGdpeQWAac0QcJ3K692wet5LVMcZBvEz+dI1/OtQd+9M0xrxHeIicULbrGzrTqIsFGYnt9wX+xLCLrM28HLsTVRRxeOwc5/u
 RtWu30yV
 fdylYExwBRHt/O9DPoxPFB6v2/HICHXLvtFvOb28nieNcn6D5DIWyUAwGyhzXqI31/LrDUHQeXIny/5oVNC6NLbQXm4pU8/VzLS1V9+Tf+PEEtwnZ5141Xzbq9thn+F6z7MEBmCfnk9YRLDW/babml5qNEXF/Uh9u3dOgB6j4LIlZtTizZvV16XEgtCrOBxQnkrZQCeBLvSUqSb+ZxP59RZKwr21QPLhoUEPh3lRj+LjX2ujaqQ6QYVCgzGJbIoq9H+W3k7ROquQod+7cxCSmF6i0Gqb8Sllt83y6NmjKPMU0sTe+A49fh6eEW3es/NFPWFXAH3akgxl1cGXshvPkLpVhalewXwZ1yhs5
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7ec7049c0ca5..c12e90cb2fca 100644
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
@@ -3268,10 +3271,10 @@ static inline void slab_clear_node_partial(struct slab *slab)
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
@@ -3279,10 +3282,10 @@ __add_partial(struct kmem_cache_node *n, struct slab *slab, int tail)
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
@@ -3375,7 +3378,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	if (slab->inuse == slab->objects)
 		add_full(s, n, slab);
 	else
-		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		add_partial(n, slab, ADD_TO_HEAD);
 
 	inc_slabs_node(s, nid, slab->objects);
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3996,7 +3999,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 			n = get_node(s, slab_nid(slab));
 			spin_lock_irqsave(&n->list_lock, flags);
 		}
-		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		add_partial(n, slab, ADD_TO_HEAD);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
@@ -5064,7 +5067,7 @@ static noinline void free_to_partial_list(
 			/* was on full list */
 			remove_full(s, n, slab);
 			if (!slab_free) {
-				add_partial(n, slab, DEACTIVATE_TO_TAIL);
+				add_partial(n, slab, ADD_TO_TAIL);
 				stat(s, FREE_ADD_PARTIAL);
 			}
 		} else if (slab_free) {
@@ -5184,7 +5187,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	 * then add it.
 	 */
 	if (unlikely(was_full)) {
-		add_partial(n, slab, DEACTIVATE_TO_TAIL);
+		add_partial(n, slab, ADD_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -6564,7 +6567,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 				continue;
 
 			list_del(&slab->slab_list);
-			add_partial(n, slab, DEACTIVATE_TO_HEAD);
+			add_partial(n, slab, ADD_TO_HEAD);
 		}
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
@@ -7031,7 +7034,7 @@ static void early_kmem_cache_node_alloc(int node)
 	 * No locks need to be taken here as it has just been
 	 * initialized and there is no concurrent access.
 	 */
-	__add_partial(n, slab, DEACTIVATE_TO_HEAD);
+	__add_partial(n, slab, ADD_TO_HEAD);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -8719,8 +8722,6 @@ STAT_ATTR(FREE_SLAB, free_slab);
 STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
 STAT_ATTR(DEACTIVATE_EMPTY, deactivate_empty);
-STAT_ATTR(DEACTIVATE_TO_HEAD, deactivate_to_head);
-STAT_ATTR(DEACTIVATE_TO_TAIL, deactivate_to_tail);
 STAT_ATTR(DEACTIVATE_REMOTE_FREES, deactivate_remote_frees);
 STAT_ATTR(DEACTIVATE_BYPASS, deactivate_bypass);
 STAT_ATTR(ORDER_FALLBACK, order_fallback);
@@ -8823,8 +8824,6 @@ static struct attribute *slab_attrs[] = {
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


