Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B428C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CC96B008A; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3AF86B008C; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEEB76B0092; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD8AD6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:40:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F635138162
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:46 +0000 (UTC)
X-FDA: 84338088492.08.5F5A909
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F81E180002
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:40:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRo74MpM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hEzddLx6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRo74MpM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hEzddLx6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574444; a=rsa-sha256;
	cv=none;
	b=ceHWAH4gqWS0RApdJxYRrExrEcj62wptGXRqQmASBlLjeDvIaVE96LJ6kqZPU5oysbcNLM
	3Y8YtDoQmQsGiZ4klTjxXEGwFL4SKDL3unkbwN4f9eVyy3XN4GqfQxV1Ysu+ohpK2gMWvb
	WDaxS+48A6oDYeLE8Ta9Xz8yZxCWjPU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRo74MpM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hEzddLx6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aRo74MpM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hEzddLx6;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dPdlHB0y/PWoX5RbcXdAl7xKUlthHXOgepwL2HcwIA=;
	b=fWulkcy6paIcGDaHrC6Qby3kyj1IhEkVxKPJsCbMyE4ijMJNsKXeMx5/k9MSFMpEkOL7A/
	pLu6kgd6SbBhFi8DyTB6MPCWpwz6mJsek7AYJaB9nDGFCJp9RmSVHndJNe85IxfqJ6hduM
	g1HXt2niFs8sy00EP/aKb7GeuchUhKI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 297EC5BE82;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dPdlHB0y/PWoX5RbcXdAl7xKUlthHXOgepwL2HcwIA=;
	b=aRo74MpMfcd9aLH4cVykKbIVhBByECipJIR57z5EmBYurFGsHRFcktRHuMSQ3dgtNIVC9K
	Wy69u7+Aai4yc4b52wmyQEJqcKrkhSo0Nl7attGNKnhPyJSmJRnc7ddgCB5gMGQb6+y85l
	6ILK8lmX4wJCs+7kh6SPikMBrAu8csc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dPdlHB0y/PWoX5RbcXdAl7xKUlthHXOgepwL2HcwIA=;
	b=hEzddLx6Iruq7VnDtxgNjizw8bnMeT2JSrbXUEdxaSzMUx42QdhM2mJK23gnXml/ThNk3B
	XVwGzrVo8ckoJdCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dPdlHB0y/PWoX5RbcXdAl7xKUlthHXOgepwL2HcwIA=;
	b=aRo74MpMfcd9aLH4cVykKbIVhBByECipJIR57z5EmBYurFGsHRFcktRHuMSQ3dgtNIVC9K
	Wy69u7+Aai4yc4b52wmyQEJqcKrkhSo0Nl7attGNKnhPyJSmJRnc7ddgCB5gMGQb6+y85l
	6ILK8lmX4wJCs+7kh6SPikMBrAu8csc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8dPdlHB0y/PWoX5RbcXdAl7xKUlthHXOgepwL2HcwIA=;
	b=hEzddLx6Iruq7VnDtxgNjizw8bnMeT2JSrbXUEdxaSzMUx42QdhM2mJK23gnXml/ThNk3B
	XVwGzrVo8ckoJdCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B5F43EA65;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OOSBAuVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:25 +0100
Subject: [PATCH v3 05/21] slab: add sheaves to most caches
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-5-5595cb000772@suse.cz>
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
X-Stat-Signature: tfrk363y9y8zex9dez3mr9mfzn4yn3s5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3F81E180002
X-HE-Tag: 1768574444-747074
X-HE-Meta: U2FsdGVkX1+Fr1iYZoEHYpHZl0h/2zd+Q+oKd/vpfDbDn7irw+egrKnlVi6adUjDYBR/hpgWM3qMWw5YDjMXAfyZsTtPaqccrtAPid6pXNAypFpDf7cS/a+QBr+o0sHlQ1+5W9dIh2ykPKsKm1EAIocE8wzgOGEazN8PoFYB9t7HcXqx8rHefn7OwaB8MsrmE68FAN04SVA/GMoE1WrWnKya3nfMsREiXHACE6AfILUoNHuxBo9AzuWodlglocFyIDcqFblzg8kzpItC5pFRtZw5GZ663wGsg8kVajIOLKucaqiRrLrF1pVd39G9wEe+dRw1ADhpV+TR8Tr1JiDjYQ25xjFprepX7R7f/MUtameIzNijQlUBb7ERy4kuWmQPPRiue7d1Vhj29Fh1nPbhkSbCAc/lJ663WMQRamlV8hQwrl2IC2LsjwXC07YE1wUoVPOLkuhj1RwSH/r3tF64LsrEspQjVsyLB2Y7Rr74LcRLlSl/zRA3fKxR54c8cKYD3RqRrmUTteGnbGRPrVKchFrBfiAuv2mxoxEBkq64WdZDjkIoAtXNX/1piOLHuY9QMxJDi2WHo7d60TEXklS9e/u1TlfXHpuKwbegFrCQ7dSIa5f68AVmQVmmguERL7g1C0+J41ojSwv2PoqTmvft+ttsoGQl4QBHUn9uHNfPDzgW+1p49wgqI48jGBIOnt3V8xPTMKOBPMGJxMaKI0Blp6jV3fIitHARtPjHRAZIrkuEA3P78kX2PQl7BCU689G1kmKHuwGCS8XUJjuLZrFAvRzxUEG0pWAlBvQEFOaolZhZ91Z4qZi115XmySXVgqVi9+nbV5wlNz4TrgWfLf31jTFyYoj5qUdBuaf0UMOHUxW7iLkHmtWkK7e34fFjhOEKjTHkS9CowfCUwxN7WfAp0FeqeFW8eOTYI4nUNDGCZ49xhLFFmEpmkz3nIqvVRXWPFKiU7tlgLOUQpGSy2M2
 zxhMFlTH
 E+lpi/ld6DlUxeD3VLuF/WHjxM2fpUe5nb1FhCZAMKtjNXN6FmNfK8EKzztwjecVpMjQlq/wu324QPdyg/MgLeNRetE9azU3zCzKb3pbH6ktmkJEwR6+fpbgKqOCo00kQJ8GpK0lpWU/XGGPnmNIXYquQWqeJdTJgPK14LmdsvrruPs8QC0FQgre4uCR/qVhKu6qRr4EdSLxMKldyLNKnkVhTEOcBB3FIsTVXp0wbOY7UYgGXfJ3I7VmVTgXQUyTZ4RaY
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
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
index 2dda2fc57ced..edf341c87e20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7863,6 +7863,48 @@ static void set_cpu_partial(struct kmem_cache *s)
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
@@ -7997,6 +8039,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
+	/* kmalloc caches need extra care to support sheaves */
+	if (!is_kmalloc_cache(s))
+		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
+
 	/*
 	 * Determine the number of objects per slab
 	 */
@@ -8601,15 +8647,12 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 
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


