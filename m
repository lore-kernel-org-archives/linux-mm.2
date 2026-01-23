Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7CED625E5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ACFA6B041A; Fri, 23 Jan 2026 01:54:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17F1B6B041C; Fri, 23 Jan 2026 01:54:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077C06B041D; Fri, 23 Jan 2026 01:54:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE3716B041A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:54:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A807C16036E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:15 +0000 (UTC)
X-FDA: 84362314470.29.4B874B1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 79F0F1C0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:54:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27Uk3vvZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtJZs1kb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27Uk3vvZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtJZs1kb;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769151253; a=rsa-sha256;
	cv=none;
	b=ezj/oMppx2S6XnlxvcFo1qbEuRbjKdDRcBq9vI+FhePgez41JYmRytXtG+mWzEaF9NHn8w
	GaEnOtdmzbvpczImKoWABrQWccTh/m73WmZ3jo55j2fc/C6petTNE9tp93nXzOjloAoHA/
	udizs/47OLYfJq5mYeaIggtrVqNF3BE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27Uk3vvZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtJZs1kb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=27Uk3vvZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JtJZs1kb;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769151253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSBhOPdL5sebK+aDhtX6/iV+qHkNH9ah4WZSL6is/IE=;
	b=oixd4quAUqdjE3gywth1EV6OT4vmxPsRbPY874oswWi8AFrwwgyQk5aomhaso+NE7iQVjQ
	3qRnoyaSCQGNul9AtD7AaPrczNBZKswCbOd65fxjPsLh1MIG+vBiUeIOT+HRS8QNJlGdnl
	loDS35hhf9ujPmAFb9QszjnNmOl4k4Q=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 600B95BCD7;
	Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSBhOPdL5sebK+aDhtX6/iV+qHkNH9ah4WZSL6is/IE=;
	b=27Uk3vvZIfiU/vSZ3nJW8pVCR0fwz18zznV7LcWuQYal1NmYlXiuIfjC981V6w04AS+ZKo
	3RFrrcR1KfnAiENMeYDFuX2JeFwX5/8uLt7JZbcaoRAb5oILHpCAIffRy75R72JX2hzlBU
	phrUxg732baj/ER2XQSIo1in2EjJMn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSBhOPdL5sebK+aDhtX6/iV+qHkNH9ah4WZSL6is/IE=;
	b=JtJZs1kbHObd8fveITzrAnKn7NAI6Um7nVyW5cvUinKDkh+dIor6PZNDiltOxli1IrMjqX
	R2dWEhOl/JyrKBCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769151191; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSBhOPdL5sebK+aDhtX6/iV+qHkNH9ah4WZSL6is/IE=;
	b=27Uk3vvZIfiU/vSZ3nJW8pVCR0fwz18zznV7LcWuQYal1NmYlXiuIfjC981V6w04AS+ZKo
	3RFrrcR1KfnAiENMeYDFuX2JeFwX5/8uLt7JZbcaoRAb5oILHpCAIffRy75R72JX2hzlBU
	phrUxg732baj/ER2XQSIo1in2EjJMn8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769151191;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSBhOPdL5sebK+aDhtX6/iV+qHkNH9ah4WZSL6is/IE=;
	b=JtJZs1kbHObd8fveITzrAnKn7NAI6Um7nVyW5cvUinKDkh+dIor6PZNDiltOxli1IrMjqX
	R2dWEhOl/JyrKBCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38A441395E;
	Fri, 23 Jan 2026 06:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wC+KDdcac2k4YgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 06:53:11 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 23 Jan 2026 07:52:58 +0100
Subject: [PATCH v4 20/22] slab: remove frozen slab checks from
 __slab_free()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260123-sheaves-for-all-v4-20-041323d506f7@suse.cz>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 79F0F1C0007
X-Stat-Signature: xjcnfax18ctc493syfheoafyzndaasrj
X-HE-Tag: 1769151253-42628
X-HE-Meta: U2FsdGVkX18dr4Tu2F99W5G3J8m7td9TXtDAj2PniLbx8Q0QB5xxdc7zs2uVplpXr/dfCELktboJBtQgoLHT7+9/7iAbC5EkUEgD21eODoowsa+XSolZvc6J2tA3UTLlY/KQ3wIh+e2PatFWbamN7y991iQwcQzBNjckyuKAwqfDUDrrW6O0IrP3YIRAZd+R9ii+L1OiUUibI3LzGKuPFRPxxvgzTQQbHGkC2JFP82gKZsnvuUqGXkj0izoSzJ8HKKP5Y+bCR1WqK3iip/3Hdt45Oc1cJqNI5kzxg3bhlo8sVD0s+gQ6SIm/oalowDmBfaqNoM8ryzgLmC35MeyPnX2R64v/16cGtKktQjvMSSRg9hNrCm0H/d59b4VGeWQLBbTlpt21T2sGy0Yq2pMcgKcI6EfAacQJVt9APxmo3L+q6FQ/ULwpg+pTbywVRuCvL+rY2pKujpw/IsKa4bwNALT2kWI8jNUspK7YKiLqnYgnoygOvxq7bihLdwihkR/cMMKYdcU65bfz/O4/MOXP9+8tiP/Mq/TTUTOZv+s55rYQXpcmiwaR/VIpq8kWXx7pBRR3nm9hElBFoa/m7ntfzBzr47Xkzy+4SnqrZnP2t8Lb5PVSEWbhGj42cBnp+VN520z6EUkzIyq8I8ev8c5+/W6Yg/gkEluya1rBvMr4eZ/Fl+oF/t9P/iSLhj9nx0u4A1EzsWrRkoah5j5QPVM90Ek9NN2K8qKZdCoTnd+VlnmYPiIrhLb+qiT4C3akxJglQ8RuPxbKvSh5AIEvKVnNaEUWU7Q5p0t+jKlR4kRns9mIYkHvOKLGJkv+g6zj8Yit1I4vxI1aa7xrYEvOsNiJooxzToXGDmLgafzFKyHGBQn3VPYEq4QRN302ExBaWTp+MBRFkWbgWiBrCvVLdqdUqM9kS99/V6Bx/ybPwVYPgUZY7JE624Lhvtt+Fv3dj2RFyG2rf5VZlZ6nGiDwbth
 /v84UguH
 6vyvcCetPSxkxWgLLgS7bWVB0HhDgXUDUyQIm+tvNYIlFSkIbEpXTVvZ2hzFph7yzdpMA5yvR1wrU9ji4FHqKFfVVxO5xF6kDGqJTknvlSoUjtsHQvZWPCQuQ9LsZVTGsVqcYDn3j8OaZPbJlIh3xM9cBauTQq+DXk679SX7hP3gLpq1AFmAWhyhvL3vG7j1wf1RJ+DFI8xjU1dZqiIEoanss2sauA9nTAPsaKlAyd47Kpwr0DTLbxmlY5QtaeAY0Nzy04Zj77z9zTsM6og49wBfvIAqrPxxQeg5TbGgYEgEt5UOgKbIGcMspg65sRYGPbiOt
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
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d9fc56122975..3009eb7bd8d2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -338,7 +338,6 @@ enum stat_item {
 	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
 	FREE_FASTPATH,		/* Free to cpu slab */
 	FREE_SLOWPATH,		/* Freeing not to cpu slab */
-	FREE_FROZEN,		/* Freeing to frozen slab */
 	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
 	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
 	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from node partial list */
@@ -5109,7 +5108,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 			unsigned long addr)
 
 {
-	bool was_frozen, was_full;
+	bool was_full;
 	struct freelist_counters old, new;
 	struct kmem_cache_node *n = NULL;
 	unsigned long flags;
@@ -5132,7 +5131,6 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		old.counters = slab->counters;
 
 		was_full = (old.freelist == NULL);
-		was_frozen = old.frozen;
 
 		set_freepointer(s, tail, old.freelist);
 
@@ -5145,7 +5143,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 		 * to (due to not being full anymore) the partial list.
 		 * Unless it's frozen.
 		 */
-		if ((!new.inuse || was_full) && !was_frozen) {
+		if (!new.inuse || was_full) {
 
 			n = get_node(s, slab_nid(slab));
 			/*
@@ -5164,20 +5162,10 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
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
 
@@ -8753,7 +8741,6 @@ STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
 STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
 STAT_ATTR(FREE_FASTPATH, free_fastpath);
 STAT_ATTR(FREE_SLOWPATH, free_slowpath);
-STAT_ATTR(FREE_FROZEN, free_frozen);
 STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
 STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
@@ -8858,7 +8845,6 @@ static struct attribute *slab_attrs[] = {
 	&free_rcu_sheaf_fail_attr.attr,
 	&free_fastpath_attr.attr,
 	&free_slowpath_attr.attr,
-	&free_frozen_attr.attr,
 	&free_add_partial_attr.attr,
 	&free_remove_partial_attr.attr,
 	&alloc_from_partial_attr.attr,

-- 
2.52.0


