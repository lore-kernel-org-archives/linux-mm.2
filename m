Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A03C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2CF6B00BF; Mon, 12 Jan 2026 10:17:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6860E6B00C1; Mon, 12 Jan 2026 10:17:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5338B6B00C2; Mon, 12 Jan 2026 10:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3DA6B00BF
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07C57C1E15
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:57 +0000 (UTC)
X-FDA: 84323666994.16.AC3E33F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id C0FBF40002
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rViawX+xj7FbNbHoLK3aJgUNTuEVqQrGyxgI1nDCQeQ=;
	b=uJ2+2zde0+18opY9gwDtwDp0rWdq0YL/JHs5Dc4DO0MB0/H2CVLyNhSh34fqfErX83u/gT
	zOcg1Hu9/V5S3G3PGnzsYQZlHKvb4qCtTCP2nlmy91COpmvj27hhb5gRWX2TEe/qJDcvYV
	gKsXoe7MZymHbbkcHuJflFq2gXJ7Aec=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231075; a=rsa-sha256;
	cv=none;
	b=bRsCbEWjzG6J144UVr23hrfXyljorwsyWx2QjlwvU9WoThLqpxGvAb/I7kXUfgoqh67hI3
	bp8Za8bZAfBqJo6LODnYtBt+ooPng9g826vqfEsxo0gIX3v4N6Xp45gXUOTzDS0rxrZROT
	XxZlPKpli5mvQSzyLqvrfYocZ/d1YvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6FDE03369C;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54D263EA65;
	Mon, 12 Jan 2026 15:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SHhsFGsQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:59 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:17:12 +0100
Subject: [PATCH RFC v2 18/20] slab: remove frozen slab checks from
 __slab_free()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-18-98225cfb50cf@suse.cz>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C0FBF40002
X-Stat-Signature: g7fpdomwbtym6bjkem9c1psqsou5ejsp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768231074-264701
X-HE-Meta: U2FsdGVkX18ULSRvaDublNGeYor2G4kuCaVQZ9/cmrESey4Y1KhnYtYPDIdKk6J8Xv0Hz/pReL87U8EE1Lw6njvwKjLHX+s+obz9W8BLlCwym3uR90LE6jNA7iZjjV54GjSQHUoor9+eHJmJMtj9wJzV48nDQjPRfZpLpiOHQupQOreHpGG6w2A/CZsJ82xM3A+MiPGNCi3aBi5kfPQmTNbe81g+dUOEs9Jy53RTXwJAP7zni+K9D0l3Zq0ezQD/gzcpnFx8Kp0LsqSf3FRYqYcUcf9EMPiqGtMdJ+1aF18tG/sX4Se9fucyARQwHz0LeGKIojP66WUxLO1VRSaACS7b5Y1HnzYs7xHyL9lUoweNqc9+YeQXw9hYDNJZZ9lAMs/xeLM5DDijxp84cFtTfc1/T50VTDtjMw0mywMlQ8AuKRbbgZpwWtc79eZoO7al7h3mLipXZyY8RvcCOPr5yoZCyqbrHKLsbDeALJlu6zVgTX1vjaNVLQ8qa1NpzjozN4JzdDJpdlTlIe+9xJn1qyAPOqHiqxyOZ5SWGPLQj3nJ+CxBhcmaNeoj3gWEwhsGQkG7vCmD1k7yEQFqvz8ZEIxt3DdRj/zt0J/6Ddu9xVdbOfceEqC3wSrz0qecMqahrDTvesoHM4D5BzTRISwZE23yRexilNzlrNt7r38V1WRfplARteVh+u1mNceveAnIXMR0s8yjQXzPANTw+sJndTCc1kdPxMLwL0qM6+NdpzsXKArMzKKzFrxM3TGykDB+qAB6Rv1MDnhu0o3VSnWT2lUFkTKsu14hBh4rPIxuNe80DGGldDBcBinaVPaCN4YsGI6Np8vg5JqPo7z5oCPZ/rlJJfebkiIOoADqPJ89Xe26EL/OfCdUMLzytkitcAdnxVGGi2w61hyPB2Krxjx2dijNnLnpnCupBIHRqSiY29TfDMoO3zqHoeRhz3DmCM9+OvqDpUxNieJs6SARego
 o5B983qu
 mfh2GbcLmWSMfuXSo+iOwXoDvTjRJGOVxibReJP6PO0SwKrBurm0E5gvI15d2pcTIo6zceQBVyMq85LTKeWEvjV3gc8Z31+oDoG5ubBfKsF98LSk0Q9MoYrtyhkF2EwH+Ig+BeiK11MQbZ9w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently slabs are only frozen after consistency checks failed. This
can happen only in caches with debugging enabled, and those use
free_to_partial_list() for freeing. The non-debug operation of
__slab_free() can thus stop considering the frozen field, and we can
remove the FREE_FROZEN stat.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 7f675659d93b..5b2d7c387646 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -333,7 +333,6 @@ enum stat_item {
 	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
 	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
-	FREE_FROZEN,		/* Freeing to frozen slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
 	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
 	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from node partial list */
@@ -5093,7 +5092,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	bool was_frozen, was_full;
+	bool was_full;
 	struct freelist_counters old, new;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
@@ -5116,7 +5115,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		old.counters = slab->counters;
 
 		was_full = (old.freelist == NULL);
-		was_frozen = old.frozen;
 
 		set_freepointer(s, tail, old.freelist);
 
@@ -5129,7 +5127,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		 * to (due to not being full anymore) the partial list.
 		 * Unless it's frozen.
 		 */
-		if ((!new.inuse || was_full) && !was_frozen) {
+		if (!new.inuse || was_full) {
 
 			n = get_node(s, slab_nid(slab));
 			/*
@@ -5148,20 +5146,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	} while (!slab_update_freelist(s, slab, &old, &new, "__slab_free"));
 
 	if (likely(!n)) {
-
-		if (likely(was_frozen)) {
-			/*
-			 * The list lock was not taken therefore no list
-			 * activity can be necessary.
-			 */
-			stat(s, FREE_FROZEN);
-		}
-
 		/*
-		 * In other cases we didn't take the list_lock because the slab
-		 * was already on the partial list and will remain there.
+		 * We didn't take the list_lock because the slab was already on
+		 * the partial list and will remain there.
 		 */
-
 		return;
 	}
 
@@ -8715,7 +8703,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
-STAT_ATTR(FREE_FROZEN, free_frozen);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
@@ -8820,7 +8807,6 @@ static struct attribute *slab_attrs[] = {
 	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
-	&free_frozen_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
 	&alloc_from_partial_attr.attr,

-- 
2.52.0


