Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DE72CCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445E88E000E; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6448E0002; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEA18E000E; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15D7C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:41 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC1B61A025D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:40 +0000 (UTC)
X-FDA: 84075970440.27.912D103
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id B45401C0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g3fD4LL3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GzVO54J1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g3fD4LL3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GzVO54J1;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3xWBfAUG4JHWgNOrNA/S+tg/3AdmFzQs0YfUSio0A4=;
	b=UBujMQnFzNZbPkETrLwVwkyTUmNMbKjdTXuz28TRTV4lMqCD9lPGr1fs5p4+Ol1VHFTayV
	W6T9oN3aniwr7qlsLJ7KG4J5xQy266sbmCkeAU7Pd4E/2JILMRLhGUNCCP6jgz48sHNl1S
	3iA6Xy6QfkyrNuljOarIsbRs9TTAGqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333539; a=rsa-sha256;
	cv=none;
	b=cmJccM2kBbF4CeHbeivy31PwJeI66025owpvvHCJkJyB1H8irMog1v81kjvGVSU/RGg+lB
	jsezxxmggzGiocp7IrlNro3BFGDD5Tn1/hjLy3B2/c/9WCD3c42v5pfiiLgd+vMsznOk6P
	I69DbkxDe7lki9u4eUw4wGqWGnhN9/0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g3fD4LL3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GzVO54J1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=g3fD4LL3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GzVO54J1;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A05C21F452;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3xWBfAUG4JHWgNOrNA/S+tg/3AdmFzQs0YfUSio0A4=;
	b=g3fD4LL33ECWdz21ko4qzOiUHJYqrVoCocAlITeBCKRkeodmkYBy+qk2Cxoso1KqhqT6f0
	cqM/y4VAjl5bylqAaXXU+3gb6DxvIcBMqGAUdAnTFYIFroyBGDJDPn8l1VRTZKqKQy+Yxb
	tP7YIt8FRkr3OCjamXg4CaREc7KrJvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3xWBfAUG4JHWgNOrNA/S+tg/3AdmFzQs0YfUSio0A4=;
	b=GzVO54J16sRzISTwXLTNgiTawsg7vs94G7phWvyfnZ9EjrcwOqV98XFAb50pHfRSM9GUJa
	srNKAqDOmfudL8DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3xWBfAUG4JHWgNOrNA/S+tg/3AdmFzQs0YfUSio0A4=;
	b=g3fD4LL33ECWdz21ko4qzOiUHJYqrVoCocAlITeBCKRkeodmkYBy+qk2Cxoso1KqhqT6f0
	cqM/y4VAjl5bylqAaXXU+3gb6DxvIcBMqGAUdAnTFYIFroyBGDJDPn8l1VRTZKqKQy+Yxb
	tP7YIt8FRkr3OCjamXg4CaREc7KrJvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3xWBfAUG4JHWgNOrNA/S+tg/3AdmFzQs0YfUSio0A4=;
	b=GzVO54J16sRzISTwXLTNgiTawsg7vs94G7phWvyfnZ9EjrcwOqV98XFAb50pHfRSM9GUJa
	srNKAqDOmfudL8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8699513A88;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CAyZIFoTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 05 Nov 2025 10:05:29 +0100
Subject: [PATCH 1/5] slab: make __slab_free() more clear
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-sheaves-cleanups-v1-1-b8218e1ac7ef@suse.cz>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B45401C0002
X-Stat-Signature: 4rm71eo7it7w5k9xq36gboe5oi9bh714
X-Rspam-User: 
X-HE-Tag: 1762333538-782697
X-HE-Meta: U2FsdGVkX1+9xsk1bRxyEu/FGVb4f+NoMzZYl4EjUIc+0ezG6MsoFZ+AMismojKASTlrn14C7En8ml6zdajDDeWTkoyh/d0X0WofMMIzluaMLKKfJvtaCzTxV0BMVxzDr0VqWemptQWqiDqGd1DdXn7NxfhVYdkFGFG3koFsAZ78+FKHXYA9NDluKKXKCo5ThQBiom3AeC7feQ+JT5No1zJFsTd0V2qcdA3u0l1UrX/eSt7slh5sw6zFbMnU43tOm8SfIL4PWGLKnleFoxW869Cw9oTR7iDiY8SCC+4zoJVCm6Uy4K9NL/ccnEYbsQS6h7UalB1tErIEoCHytcFEY0ygtNPe30aDc67pjJHEVVmgrJMqmiEDQh5jDViVhwEQvbGGAM3P4hFd1xI8ju91PD6n1bL1MNW4YAElJW8iEIVhLOYPQuaXB6eAWmp4jMYNfUYdUchOvctnzd9WbI1CxPfo+wmD3KPYepNRf8UQXdAUTqwCI/dyMBQMiMaccyXcY9cbiMgalGqhIgbkuYbXAyuJnz/5dgJlnqmX15TNHfq6OLn1odIf0u/cIKn88w18V50YQw5NuHA+bWoV4pnjRpTZ1z5w3hEOW3/UR188cLtFK8VMWM2Q87bkFtfnqZaiJEavlqshpsfZ0hsXJHi5fKS+/011q0u5kZ4zd4moPWm/l1tww/WSwu+4Obh2gmRl4n8Dbkv4C9ws7p+yYGC9nTg3W59v9AnqH/QZZL82w585iH8IoHDtLfNW8faNhBWrDpIqXVKknOIHOvq8VmpoDEvCslSFaIYMJv/MEzgDiMZT5sFAowp4O5mXCTTzp5V0Lyc8rsxU4JAD8i2vf52kdjjeU91c0TYAtzrjKEiTvVGFNyNZ206M18+QjN8uM1c2KH74VGUX8zWCsUR3BkF8YaoMGqrWn3nB5Lc9p2xigO1z5YV9RSDEXrO6zp+e9WzLm0eMc6V4F3depacQDiO
 ctorG2e/
 UoBAZ0hKtuKZ/sid+B5d4pkjgByucSOUSFgg3Odl3DF2hMgFvNJAif5SFF0koonEzEBi0AQje+ZqBcw4skRzghVepisfp0oNNN6Pp4MlIrlZS0LBYQqXcsU8+MuWap7VTRIddiIUbR1ECQLHAjPdQgLbPuzGCg3qFMnQ4RIElBWREAH5aFoCzuf/uUlXfsOZXTR9qcvraUjPArd8gMsK6CuYEU0O3wHfRcOTU18tIsNsW1iXW6XExfGJJHQqaPAlWtz2iinFKzDCi2GIfAc14aw4PpfRCEokilNxql9dCcLfxxxs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is tricky and many of its tests are hard to understand. Try
to improve that by using more descriptively named variables and added
comments.

- rename 'prior' to 'old_head' to match the head and tail parameters
- introduce a 'bool was_full' to make it more obvious what we are
  testing instead of the !prior and prior tests
- add or improve comments in various places to explain what we're doing

Also replace kmem_cache_has_cpu_partial() tests with
IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) which are compile-time constants.
We can do that because the kmem_cache_debug(s) case is handled upfront
via free_to_partial_list().

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 62 +++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 17 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f1a5373eee7b..074abe8e79f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5859,8 +5859,8 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	void *prior;
-	int was_frozen;
+	void *old_head;
+	bool was_frozen, was_full;
 	struct slab new;
 	unsigned long counters;
 	struct kmem_cache_node *n = NULL;
@@ -5874,20 +5874,37 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		return;
 	}
 
+	/*
+	 * It is enough to test IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) below
+	 * instead of kmem_cache_has_cpu_partial(s), because kmem_cache_debug(s)
+	 * is the only other reason it can be false, and it is already handled
+	 * above.
+	 */
+
 	do {
 		if (unlikely(n)) {
 			spin_unlock_irqrestore(&n->list_lock, flags);
 			n = NULL;
 		}
-		prior = slab->freelist;
+		old_head = slab->freelist;
 		counters = slab->counters;
-		set_freepointer(s, tail, prior);
+		set_freepointer(s, tail, old_head);
 		new.counters = counters;
-		was_frozen = new.frozen;
+		was_frozen = !!new.frozen;
+		was_full = (old_head == NULL);
 		new.inuse -= cnt;
-		if ((!new.inuse || !prior) && !was_frozen) {
-			/* Needs to be taken off a list */
-			if (!kmem_cache_has_cpu_partial(s) || prior) {
+		/*
+		 * Might need to be taken off (due to becoming empty) or added
+		 * to (due to not being full anymore) the partial list.
+		 * Unless it's frozen.
+		 */
+		if ((!new.inuse || was_full) && !was_frozen) {
+			/*
+			 * If slab becomes non-full and we have cpu partial
+			 * lists, we put it there unconditionally to avoid
+			 * taking the list_lock. Otherwise we need it.
+			 */
+			if (!(IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && was_full)) {
 
 				n = get_node(s, slab_nid(slab));
 				/*
@@ -5905,7 +5922,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		}
 
 	} while (!slab_update_freelist(s, slab,
-		prior, counters,
+		old_head, counters,
 		head, new.counters,
 		"__slab_free"));
 
@@ -5917,7 +5934,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			 * activity can be necessary.
 			 */
 			stat(s, FREE_FROZEN);
-		} else if (kmem_cache_has_cpu_partial(s) && !prior) {
+		} else if (IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && was_full) {
 			/*
 			 * If we started with a full slab then put it onto the
 			 * per cpu partial list.
@@ -5926,6 +5943,11 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			stat(s, CPU_PARTIAL_FREE);
 		}
 
+		/*
+		 * In other cases we didn't take the list_lock because the slab
+		 * was already on the partial list and will remain there.
+		 */
+
 		return;
 	}
 
@@ -5933,19 +5955,24 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	 * This slab was partially empty but not on the per-node partial list,
 	 * in which case we shouldn't manipulate its list, just return.
 	 */
-	if (prior && !on_node_partial) {
+	if (!was_full && !on_node_partial) {
 		spin_unlock_irqrestore(&n->list_lock, flags);
 		return;
 	}
 
+	/*
+	 * If slab became empty, should we add/keep it on the partial list or we
+	 * have enough?
+	 */
 	if (unlikely(!new.inuse && n->nr_partial >= s->min_partial))
 		goto slab_empty;
 
 	/*
 	 * Objects left in the slab. If it was not on the partial list before
-	 * then add it.
+	 * then add it. This can only happen when cache has no per cpu partial
+	 * list otherwise we would have put it there.
 	 */
-	if (!kmem_cache_has_cpu_partial(s) && unlikely(!prior)) {
+	if (!IS_ENABLED(CONFIG_SLUB_CPU_PARTIAL) && unlikely(was_full)) {
 		add_partial(n, slab, DEACTIVATE_TO_TAIL);
 		stat(s, FREE_ADD_PARTIAL);
 	}
@@ -5953,10 +5980,11 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	return;
 
 slab_empty:
-	if (prior) {
-		/*
-		 * Slab on the partial list.
-		 */
+	/*
+	 * The slab could have a single object and thus go from full to empty in
+	 * a single free, but more likely it was on the partial list. Remove it.
+	 */
+	if (likely(!was_full)) {
 		remove_partial(n, slab);
 		stat(s, FREE_REMOVE_PARTIAL);
 	}

-- 
2.51.1


