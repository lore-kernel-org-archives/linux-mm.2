Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32943606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nCFTpsce
Received: by kanga.kvack.org (Postfix)
	id 2D1346B05B4; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A97A6B05B5; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7196B05B6; Sat, 24 Oct 2026 15:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EE99D6B05B4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3975C03F9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:48 +0000 (UTC)
X-FDA: 85358454216.04.C14B2E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3DE6440005
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCFTpsce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaNkuK+CuZCH16Zfn9adKcMMnVfFDERJiwr1XCFoM7M=;
	b=PFkEwbS9FU8vZHxTmO7SLg+gYRmov5QlofvkP4+YufrRElf/QnsegY1ttgTcb2ei9vBAX8
	N0ZPfT6VsGmn3Fjc7RvnnPuHGtTRHJcbmu5DAPJ/8bZKXOoFdVKx3R0nDZ94n1T/KhxdTl
	v5Jx+RBfQRw2gmECA/mi9W8SPdV1BL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nCFTpsce;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868867;
	b=8nq/gccP+PA4xNZCC0YX+QF/gdEf4NuvAA6YSqOFd9QroBRqPtYAVl206dtmjab3dh3Lto
	yYWBLxjYLymcDltHZyI3XC1BaWQ0YrCkNWj8imXSCmZ9imxZtMtv/zLq372cW9WzNX6Ovz
	YS+rsbkV2ysFIB7OXD+rC2w/PqlVvQk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7110A43632;
	Sat, 24 Oct 2026 19:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DFC1F01828;
	Sat, 24 Oct 2026 19:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868866;
	bh=ZaNkuK+CuZCH16Zfn9adKcMMnVfFDERJiwr1XCFoM7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=nCFTpscefOvN4FKKY7J0TU5WfZFfA6iuEGxsM111Fql15KylIOsDkfLQ9nH5GG+pp
	 nd4E2l6bWYfd6ufS0f0H6ntIDMZUpEieUAk1saZcqn1mDN/GUYR8YIgWHO6pwB7L+I
	 coFfoYAu0LJVHlVmSvs1Swoxv/9hcXy1Pe0WQwTyqxv/7W2nrXUNB+iTE7WjUg14qO
	 Vpl3LcfVIlwwkr0IDG1Atsm42i3OlbuclaSrV6HzwRkjtgOvorXZUx0HMFsPv91nTA
	 kRGsd+6bvZGgtotoasQkQTvta1qePw4y2iFBGmGdmYcDqoaVvP3+tGlZciEBHik/sM
	 ZUEfyr8g6Eyng==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:26 +0200
Subject: [PATCH RFC v2 4/8] mm, slab: make SLUB_TINY handling dynamic for
 sizing decisions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-4-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 3DE6440005
X-Stat-Signature: wsu6diacaxj6zqke4wkaqx1xhwrixybj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792868867-961141
X-HE-Meta: U2FsdGVkX1+XeczUxvRJiUrs+LzulYYrizhdEqTJ9KLOry4o67P+nMV6rGioIlFqwsrE2GFfr4myvQ818ziNmFruNv6S0yCwubyyqsP6HoSU3Gd8J+gQxj5re7BkRwXeXgST4ikN9nOitF0fZ8pzzVx/H+7s3Llpq3KenKbL7tb/ItI0PeCk8TKnwlZidhyd84ExjGo+IzY+BbULH3nceuh9k0W6MFNYigy/eybWHaaFwFN4eZA5gSfLZ2cTyQ92Rl6oscX6FKS59+iVJiRX7XKZSf+5r+kQQlTfFLSV/54tdPFlcyzqd1zLexFOANuprQogIpDT4X+gM4EsGjKG93QuSx23SZA5LtH7zYdvwX62QI1HNQQdPOH8gHuXMUJTgQ/5M+hp7WvIGhuEA+xAJFwXyfmcFQDRb+lGBsRn3rL1xB7XE6KTO2Y/eHFEWE/3/FmNZBQ7c5z4EwFtMUhkh7zn75Nb5GK3USe9aFzNOJxrv5gwJnF12YJ3Igha5FRsltCexRZJvF7dPho+FbPockWf+yuvkDAQ8/v05YDae9TpcrRIKC8pEyPUK/UEaVs7x6tZTM9NrBY5Fnv6b+bCI8+BqwAEW081UxvY4zTIP4JLVFxexJchTgPDxikCtN/1mr9pDNGj9Afk7F5W2+YkDUqyzgpKisZOuMFDvOSW0JidEjo8yrCaPzyOjv6ydhc1QOTwivOclSxoid0GoaJIq6woCwtsRQwa3dQwz8l3cL32+fNGLEnbZyCpmXLeDpIw/a81Y9riDnFqtNmbs6461Ys1d7YhvDiE00d+NI1Ph/Phl+PCec3N9rrw0icLXTi+bXzOMTkzm/jDqseQ5gKbGio6HJXF6lBqsGqQlo5cPRPiRjHIExvLezo0R28m8dkZqkm/t32jk2qzdeFUPejHVR5anvqFjsU9BcgqA8bR5+oVZ04Z9d5AwcxO4Z65YAbeeWKNvSI8jOu+soOYLcq
 gDBAr5HH
 LlegHT4E7V/YhWdzWLSjxzLOk1TBpLryDkAgQwzsGjLyyH6uTEAeo1VMDOUWh6me6E+SVXQBOPw21DN/OPyj2OiKQG76AW+HTTxQny2aOsfilFnZkCgwJi7y+VQ3uZVycyQNM5q3rroztO4/TqcTe1YnO1rwsz0PbesSavweQ9cw+KFYFeXaZiwvty5n7SAP+rOZAaMvtK50QBz2dhGfBzi8Ejs1ky7ixp0FPrWH9m02iei7e2MIkiMNnVrkSYQoy2DefJADlVp6S/pTzDx9xwkdMLO9D1zQ0rOjC5gbConaW82V6BA787RH3uE1RAqnRDnKn8j1yo1W+kRc=
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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a3ee1bdf0eb3..be4e1f193295 100644
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


