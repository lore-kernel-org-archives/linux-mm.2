Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E606B606A335
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cyn4o4st
Received: by kanga.kvack.org (Postfix)
	id 55F206B05BF; Mon, 16 Nov 2026 01:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5384F6B05C0; Mon, 16 Nov 2026 01:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425F96B05C1; Mon, 16 Nov 2026 01:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 237256B05BF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A5871C42B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:42 +0000 (UTC)
X-FDA: 85440051564.03.561ABE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id F382E20008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cyn4o4st;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811661;
	b=BSiFygJgGfyGOyA2vWZluWVbhaqRwh8ZpXrtaKTwXW41zunYJV96bv5Aa1HpqSp75PYfWg
	DQeHICoDVOlNMqf0xHl9VIi3z060QWae2dB3rOzEfEZ95PEo93kE8xCKWfp1HmEKeVUyLw
	LaKOAmc8/dG60/o7OOfK3zO8HngEJPo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cyn4o4st;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGcbtCE0xSbWljRHzHfVhj7R0LXVbJXAi8zHRTVvrTw=;
	b=5tNNWygETB4GB/nVGLPT1z9oAdqZNY2uMzhgUOEB/y8VYAq8NhWBKP5M9BqI+Q3sOPZIrO
	7Lx7YkDOnTaK/QBdACPDxWSF9eth3K01LyxCjDKhWi7RJgHdc9cqh7/50GS0h5Jgl0O0E+
	15twfFHYcITLRrRuFzqoyAFU2jCh3T4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97A7361ED0;
	Mon, 16 Nov 2026 06:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330521F000C5;
	Mon, 16 Nov 2026 06:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811660;
	bh=hGcbtCE0xSbWljRHzHfVhj7R0LXVbJXAi8zHRTVvrTw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cyn4o4st0NP3iNx6tZjGKRw+K1yhHhaTSMrFJWUJhGFgTd6RPkeWQKeLQnElLISxm
	 oTfOG6thGik3y4hZOXKxDPYiD2K2wv2QQj7Hkc6vOPpPZrxHx/2XOe6hStDE7txWLU
	 UWssoLgEqdPqPbMIZYXNqnNyq9qgU++/+Advx2tIz1vaLN8PvWcnecu35eJzv5FmIf
	 LktidM7wpyUR+TjsYbiQmyJXXEpGBb1KRpqHkNqGvmQMIoX79l7DzT4ovTCwm6i1dC
	 hh27gKzP6ElV/lviQ318aW9Wx65U2ACr3JNJb/0R9iBSpUkczYrHesbv7LW97UPyq2
	 k24mdAeLMuxzg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:14 +0100
Subject: [PATCH v4 06/10] mm, slab: make SLUB_TINY handling dynamic for
 sizing decisions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-6-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: fmyn68jsyuzr6yrj9bomhpdw7y4es4gj
X-Rspamd-Queue-Id: F382E20008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811660-159560
X-HE-Meta: U2FsdGVkX1925bmIILA+ptjTtstiTrpUCsi1gvClCjASGnTcqwluoW4mmcxg3P5QLEV2n/5zMcgWk0LPTukfY8TzXbDP6i9ALsp+nuYz8db3FPjSNXABzq5eZb8NVjQ854Otp4pqKY/dXAC5ksBxRQlLlNeWILB8hVcprRUvNlPmqhosdcD913Oacb/uJGBU6ebJIY6GcRwZsqXqtaALP3Aj3ZGyo6rxNlILm2kJsKlDg2Lobb2wIXTcY/PRpc45p2zD+X+DFtxdzR5P2WZDZ5snoj6TLwQvExRL6a2j79u09YcirE4ey7vABKX0UBU9OhHZBDZq57f0YWqOmLRg6Q1gZI3v6Eqjpyg59uDRQxhNk/xF5VH0H8jMqN/N6TCpQ02McuuBVvWlQdHlKX2QXWIVUSgP3JM2UFKDOVNvVV1BsyPCsl5U+pqL5QJ4X3jdG8NZC+XsezyPfdLYBq2OnjSmqre5DIN9sXAjIazwIsdZN8FL9fi4/lsmE48czM/J2yzpLSkvjy7bhI4mLUZ+PrhfMqAnfR3Doj5tlRiB0PC05ZIaF72ujz9zf6zjAbT8e7U3IPcE8jgYqoFrtJvbbBlAXPFRV2JFwC2aIYVSVyGeKMVscyaAYbgPAjbhxf5M/dVzo5mA4HN/rfrSE+P7lRvp5VsK6lywMj1QF1QGKZR+aTYh5CKLbnyLvQEgtmfh+RpyRKOslw3/tdF2hq2qRSMLWrQKjggWXxVNYM3J/mHKmC0jDw2wBI63+9yH/TmCX1asee3oi/waHbtpxIgmqg9MHakkiY9isRTLhPdQB2s04hQGJVPpehG0EHWFdzRjuvR6qyr07gH6O8aLXlE5e1VEvMVzVbg0suI/J05AoUE8b6I2cm83ia1yG8UVi2stzbySmsGWDAS03vvvbAL6KCctCq3ibmOBGHkVFpAGM9MXzuqEND1qHGXr+dMbTKj2JyUUfBh1ludBmlErZLt
 ekjo25t+
 2OnS9+KqX0/9ukbvuqmr4HMZc4opQttVw+zQY+HmLqpJVZtntRgq9QB9xQ029a3xhoPcL1Da9aSehuByVX8NOIZvBh66fHNzuSLDSDMLOweBvBM7SfQ97Tm3FAWjmaPQ9IFwftAClDz7aR3guyqtSsMl6ImbMfOftg6IQcP27yXz8jLeHcbByc4lrO5QG8SOmHg93KrFLRa2NeT7rC+cvU89jhtvxusWKoq0cUtKuFNdsCvgAUgDRrOtJc4PPPelLpaw5VBLlTDCmMUODpkjXH1f7wgRArSyno5/dv2E0Lmuut2tqUk58beP8d710fLc37B+9x7Nvr+r6m6B8ACM33zI4Z5xK+dZ3WMAMud9MmP0rHwMI4tMji2K2q9zW0NQc6DQPr6axMKUKmBoTWGyQhQtZmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enabling CONFIG_SLUB_TINY results in the caches' min partial slabs
threshold to be zero, thus every slab where all objects become free is
freed immediately. It also sets the default slab_max_order to 1, with
the goal of reducing the potential of internal slab fragmentation.

Rework both of these decisions to be based on the newly introduced
slab_tiny_enabled flag instead of #ifdefs. It's still possible to
override the reduced slab_max_order with the boot parameter, as before.

Also adjust the same way the check in calculate_sheaf_capacity() that
sets sheaf capacity to 0 with slab_tiny.

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0238c990351c..9bd16e04ea24 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -272,7 +272,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
 /* Enable to log cmpxchg failures */
 #undef SLUB_DEBUG_CMPXCHG
 
-#ifndef CONFIG_SLUB_TINY
 /*
  * Minimum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -285,10 +284,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
  * sort the partial list by the number of objects in use.
  */
 #define MAX_PARTIAL 10
-#else
-#define MIN_PARTIAL 0
-#define MAX_PARTIAL 0
-#endif
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
@@ -7706,8 +7701,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
  * take the list_lock.
  */
 static unsigned int slab_min_order;
-static unsigned int slab_max_order =
-	IS_ENABLED(CONFIG_SLUB_TINY) ? 1 : PAGE_ALLOC_COSTLY_ORDER;
+static unsigned int slab_max_order = PAGE_ALLOC_COSTLY_ORDER;
 static unsigned int slab_min_objects;
 
 /*
@@ -8027,7 +8021,7 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 	size_t size;
 
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
+	if (slab_tiny_enabled || s->flags & SLAB_DEBUG_FLAGS)
 		return 0;
 
 	/*
@@ -8763,6 +8757,9 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
+	if (slab_tiny_enabled)
+		slab_max_order = 1;
+
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;
 
@@ -8886,6 +8883,8 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	 */
 	s->min_partial = min_t(unsigned long, MAX_PARTIAL, ilog2(s->size) / 2);
 	s->min_partial = max_t(unsigned long, MIN_PARTIAL, s->min_partial);
+	if (slab_tiny_enabled)
+		s->min_partial = 0;
 
 	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
 	if (!s->cpu_sheaves) {

-- 
2.56.0


