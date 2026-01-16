Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4A30C982C7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D8C6B00B8; Fri, 16 Jan 2026 09:41:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EB446B00BA; Fri, 16 Jan 2026 09:41:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FA76B00BB; Fri, 16 Jan 2026 09:41:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4DB36B00B8
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1451B58F5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:46 +0000 (UTC)
X-FDA: 84338091012.23.89E5CF3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5121940015
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y+96g/mv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Qi7cu/J6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y+96g/mv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Qi7cu/J6";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574504; a=rsa-sha256;
	cv=none;
	b=qoeN1+No/0Br2AWE7ImAngpQRA5vXbf38bO2Hm3eFOG026I9gw4ekjfntMfpHCAvd1vdh7
	vr05503Re5YjTyU95VAzkshaiMXLBLL+aNh270vpRrGqON+ZRhs/x9KUDsQnuhRU/CpJwI
	JPkcQD+vAp4QZhepoxeEINUVrZzu7Ks=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y+96g/mv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Qi7cu/J6";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Y+96g/mv";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Qi7cu/J6";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xgZ9GBTAAzmeTyqJuDn20wm4Bud6VxP9e5RLLgZE5j8=;
	b=I6uErcxvvwkIhNH+GIXqdbwIvPwXGgmJOhbESLw5uEb3RgnQSzqvlwp96lL0DC3/Db1LEW
	YpTZAtp1VpSk4WccVSzdhqfgPRhO2zeVQDnenM/nPWw6mWAzS666Zae3K35dmcQghoSfk3
	TuScbv6cFqm3eGIZfYLZnad6xo8vLAk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BAABA337E2;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgZ9GBTAAzmeTyqJuDn20wm4Bud6VxP9e5RLLgZE5j8=;
	b=Y+96g/mvMMFdE69VCOG3hSYi7kEmxm/rn/aNzWWdIkSu7f7SK/awEcbBQKhrUwoLoBkhQn
	KbXRKwwtEtUqaNJyU1EtRd6ayLLB7rzIgn8Pql4/sQd1BAehHHFcMxSLtLJdElTNoe8FVZ
	wgAK3EjJLPtVMvI2rlZqGJSzmVbCL7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgZ9GBTAAzmeTyqJuDn20wm4Bud6VxP9e5RLLgZE5j8=;
	b=Qi7cu/J6AYnImXPQpCnrg0vDE7D6pmsBUpvQdWpWwUjT8rdF7pUdpwiRFxVAf7pWr3skTN
	RQXbC5eBGAijyKBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgZ9GBTAAzmeTyqJuDn20wm4Bud6VxP9e5RLLgZE5j8=;
	b=Y+96g/mvMMFdE69VCOG3hSYi7kEmxm/rn/aNzWWdIkSu7f7SK/awEcbBQKhrUwoLoBkhQn
	KbXRKwwtEtUqaNJyU1EtRd6ayLLB7rzIgn8Pql4/sQd1BAehHHFcMxSLtLJdElTNoe8FVZ
	wgAK3EjJLPtVMvI2rlZqGJSzmVbCL7o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xgZ9GBTAAzmeTyqJuDn20wm4Bud6VxP9e5RLLgZE5j8=;
	b=Qi7cu/J6AYnImXPQpCnrg0vDE7D6pmsBUpvQdWpWwUjT8rdF7pUdpwiRFxVAf7pWr3skTN
	RQXbC5eBGAijyKBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 99C753EA63;
	Fri, 16 Jan 2026 14:40:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eHNEJeZNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:38 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:39 +0100
Subject: [PATCH v3 19/21] slab: remove frozen slab checks from
 __slab_free()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-19-5595cb000772@suse.cz>
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
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5121940015
X-Rspamd-Server: rspam06
X-Stat-Signature: 4xdx1mgcrxbkmo85u3amxgenk68bo434
X-Rspam-User: 
X-HE-Tag: 1768574504-330333
X-HE-Meta: U2FsdGVkX19d2P5uksoMbswqWtxtWBusWwJ6Sj7/Kf7a2c11eMKznCwokk2M1wNTUfkf0xgxWnNHkZKuhhx3OSD0oSexo4FcFltdc+VAUFb79ewgm/sIMvS11n8FGvxuD1K9xaYCmkpqgm+Wsf8+amcBxMx095PVvvT7abOt/bXtsbS2R0Vl8a2fp3ES+IQh/HHo134QyZ09oNCK8e6PuevdcrU9BNSIFEUXNNf2Ta8zLBlOrK+bBnXvwC0rL0SHmtQirIah93HHexrWZG8F0Oj+PFcNw0+reKMRgRE5+ERYJ84tKRXjK8SSjy5gZw5AHRQHWmRTyXbw8HwLZxSqirRuMVnEywC+KhBzApySo+ifKG/CQaDYJZfMjGeuUj/5KqFcOqAc8aPS7tXVqZPJJgsF0YlUXQ2QEXvBj4M30ffJDmbYQbdykraaXjvPckD/wJvZJH4+E7buvuenrL5C+JofnJoYdsqBpiardcKVA9+PpSmAOPWsx3G63Cgc+V11aI+bYGjPDJdgF6bDmJ2LbYf5eq3uWYwZ/5YgCt13m0QbsgfwM4ufCJo3I1+ZS0a4o+ews5fqWCXp6I0MxHh4NrDZ8R+A6Kh0UMKBELB2r0OFNANpJzBdGH46WuXTdu4P+RVHbkQOxuKlzQJeCoocq3+dUGUevV92AcEG0iBAuuIIbaAYXM4dk/CQkg35X0OmLWneeRYSDei9I+AMFXLpwdgaGC2J3+ocYybqmn4GqQ5JU7mTbbpHaIDdeBJvlyL91KHGoZueBSlDr3X8PP+AGR4j7fMWXlBByqtRItThlfRIkENY9rIYIgoVs8dN0ErT9ddKbSc94BN3oiEB13k1SgT6boH4CTBwlP/nWEL2y8nL85LrQ1hHFnPlzpYHVP1Zpqw51yNYAVu+LQcWSsJztT/2AFYcfdM+s4UecCbQcbg7wReTF3mIj0Lm2Nrko2VP0UMsFR0ersbUdNuKHx3
 U+wegCjF
 /TB9ASGmOJhQ84mMoHG226zEwLJsgqdQNkoviaCVn4sp/8rNsMOCazmSMKNOgeB8FEgbLJugjmGLA2n+zvUdS0XVaNC+K2LLBMTGzMgXlVheJA0mJLwN6iAjMExjFC/FCCiliTa6KNIP4R6uSndju46lzO4uBOsoZT1BEfa8tvuQ3jZukUZ/1Ie0ku32y7pVet3C0ABaaH57/CR14iyCWWtpdL459Vw1gvvCEucWMOq4+wqvE+cGNfI6OUZuBLo4NFGqa2SA75E1ISVBuL9nUWvtc+8VcEJDIUQfMDszfppk/Swd7tu7eSJ7348QPv/2O6yoL
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

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 476a279f1a94..7ec7049c0ca5 100644
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
@@ -5103,7 +5102,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	bool was_frozen, was_full;
+	bool was_full;
 	struct freelist_counters old, new;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
@@ -5126,7 +5125,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		old.counters = slab->counters;
 
 		was_full = (old.freelist == NULL);
-		was_frozen = old.frozen;
 
 		set_freepointer(s, tail, old.freelist);
 
@@ -5139,7 +5137,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		 * to (due to not being full anymore) the partial list.
 		 * Unless it's frozen.
 		 */
-		if ((!new.inuse || was_full) && !was_frozen) {
+		if (!new.inuse || was_full) {
 
 			n = get_node(s, slab_nid(slab));
 			/*
@@ -5158,20 +5156,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
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
 
@@ -8721,7 +8709,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
-STAT_ATTR(FREE_FROZEN, free_frozen);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
@@ -8826,7 +8813,6 @@ static struct attribute *slab_attrs[] = {
 	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
-	&free_frozen_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
 	&alloc_from_partial_attr.attr,

-- 
2.52.0


