Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B028ACA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70B298E0025; Wed,  3 Sep 2025 09:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF08E0022; Wed,  3 Sep 2025 09:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E71E8E0025; Wed,  3 Sep 2025 09:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33D4D8E0022
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F07321406AD
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:38 +0000 (UTC)
X-FDA: 83847950676.05.85CF93F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id AF5798000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JpX1EFHl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=boqME7eI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JpX1EFHl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=boqME7eI;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=TS5f+5j6A+RwKWtxeHb5lEpZQE/4Pil0X04H/8dOJE/sv22xhEsY5514EVDYxUucHK2DeV
	e4wouiCPN0gXDKdBJH/ilyFMKwCjcVUaSiR/Nglj/yomJSo2boXSWLDk4weG2E+cnjd0G/
	Db2kSG80j6SCHh+jYLRoW3rEpOVjAcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904497; a=rsa-sha256;
	cv=none;
	b=EbTkEiDx7EQf8ulSGtXTZdHDFUsFeb+PJwmIe1aBZ84WBUuXOhy9fIRFvxIvThDAis9WDO
	vKuTfNESteqYoKiPpquadFCCx3mlR2FCDWC+vCNxjGzQPrXXzMQ2Pp0mrFxwUHrQAJd9GV
	1qWsGdDhJ2DLA/D4Qjy6W28flh8vkfI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JpX1EFHl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=boqME7eI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JpX1EFHl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=boqME7eI;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D808D1F749;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=JpX1EFHlgY9lv/Jg9Np6YcccAcWwOH5vSSehOAl2iCisgztVji8k/m4iZWWDfF9G4MrMdT
	1no34TX1PZX+TkQBLMAwYVtWVMaHPFyVU8Lzoa22w0y5YHWzIoAyZhPf0NVON8mUbSGOtp
	KivRwn6uQo+9Em2sG9jItp9gTXDpBSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=boqME7eIeY8AGMTBsm7dwQZietZj8zprg+GhYZE9cE6XJPyNxjngG+iIitHglC+a4CF/48
	pkAYS3zSHpyz4yDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=JpX1EFHlgY9lv/Jg9Np6YcccAcWwOH5vSSehOAl2iCisgztVji8k/m4iZWWDfF9G4MrMdT
	1no34TX1PZX+TkQBLMAwYVtWVMaHPFyVU8Lzoa22w0y5YHWzIoAyZhPf0NVON8mUbSGOtp
	KivRwn6uQo+9Em2sG9jItp9gTXDpBSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=boqME7eIeY8AGMTBsm7dwQZietZj8zprg+GhYZE9cE6XJPyNxjngG+iIitHglC+a4CF/48
	pkAYS3zSHpyz4yDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 675B913B08;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sDzmGNo7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:58 +0200
Subject: [PATCH v7 16/21] maple_tree: Use kfree_rcu in ma_free_rcu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-16-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF5798000E
X-Stat-Signature: 4yt4puh8t5prewtkbswhnxzdq34ceesq
X-HE-Tag: 1756904496-275231
X-HE-Meta: U2FsdGVkX1+QjZdCmPMQmUv132cKZQwv13E016QJDO+Y3SzlQupBx8OtWmmcs/4nDh0JUByu6d49kxFw36qkMPKV+9lPRsvoJJLdM4yowYC4usFWvmE7w0TEe5TRx0/VAAlRyUa4XN3CJ8ukhUWRUS2H4a7s5z6YG3TTjZoUy1U++wmddbWh3L/G+4+bM3EfU+wC94yvGqVtkwF4HnCAEzH6i3wN0mjQrd6gHggsemeADWkPrq0ywaBjeg2vsNhuUoObiIe0PfzWP7xwCzsqGQE0Hqobv+2LUBPKEhuVLURejy+h+2V6jJ3p63q3teNV7wONbhNNz8NKVrsweXVzEdQ65NLwHQDK2sbEwPeTPsLTZBxBZ4K/c+9V9U9U7XyeJ4U2+woYjoAithjtTDD23dksblii9hAw/59OWHTyVbzWnnWBVEfra7Bcn6zLDnfpn/vTblIdAbimwhtuRVNTKOXsUpo7dBPDoaLGCQ4F5jotgFVh7hGAIGOPxMjb9uOd8v6QMB6ZI0NTbpZQ+S36I2w3PwSYSM61oHTwcOhmNT0UMOrUPA/4b8XTh+zKArKoR927GN1db5+2YJyZL0elZyYXe/IVFTwv7MjWqeD+8ev2heVVU2ybZDEFmChswxeb86pyQEjQ/4VvEv02YJs3GBC9B3FuYuVgz8NIVi8EAgdpDCLa/i9zb5ftKWYwpxJPBpBypUGK+Iep0jQ84FHUPwbdgXgDltCSAAk5uq4RxEpW3bXGT9xkC4cvViFJDqgWgc0ShgzsuS8eIssZEA6tph7luLsbYD32CeeFTx4PSPe+VQVgrfAEj5T9o4UfDgsYXA0TizvgDgy1DUITTTFRT/jv62gaUEPyTpGEL0/yQ+AnIJmmajS5IlDsoAY0PkzhX/LfIV9JWfmbd6zrtDPY6/rJNptnegOsK0pNF4gmoqQA5BqYdZqtj2hA1EWG1+VKT0z0ndqe+ttOBSlCIv2
 jmA6WkSw
 8uUwQVQffE18Gd8qLjjk1jACCO/kBTpaL4xLAQ7B9AqOLOeyoTkg1o2p6ut3p0x/+9tgCbcDYckq2lj9II8SJ9SoCCaCnudano4jM5QcCBJN3GxDHIVv35JgGg7hZuFW2FkEtyD2AjSLi2cHB6C02YjxONwSsyRRXR1PFgz51ZoomJHH4c/2ouDDfoETFK5FYM7kZU7P8eUTX13aVNSVkFgaIzsKWAh/KAlnKn4ugGySY0NHi/UVpi1/P32huiGueGDgA8qIh/QmqQXSKpyRZVpDVK6hz3Vd0N/qLcVjUX+y4ugY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

kfree_rcu is an optimized version of call_rcu + kfree. It used to not be
possible to call it on non-kmalloc objects, but this restriction was
lifted ever since SLOB was dropped from the kernel, and since commit
6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()").

Thus, replace call_rcu + mt_free_rcu with kfree_rcu.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a0db6bdc63793b8bbd544e246391d99e880dede3..d77e82362f03905040ac61630f92fe9af1e59f98 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -191,13 +191,6 @@ static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
 }
 
-static void mt_free_rcu(struct rcu_head *head)
-{
-	struct maple_node *node = container_of(head, struct maple_node, rcu);
-
-	kmem_cache_free(maple_node_cache, node);
-}
-
 /*
  * ma_free_rcu() - Use rcu callback to free a maple node
  * @node: The node to free
@@ -208,7 +201,7 @@ static void mt_free_rcu(struct rcu_head *head)
 static void ma_free_rcu(struct maple_node *node)
 {
 	WARN_ON(node->parent != ma_parent_ptr(node));
-	call_rcu(&node->rcu, mt_free_rcu);
+	kfree_rcu(node, rcu);
 }
 
 static void mt_set_height(struct maple_tree *mt, unsigned char height)
@@ -5281,7 +5274,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_rcu(&node->rcu);
+	mt_free_one(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5365,7 +5358,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_rcu(&node->rcu);
+		mt_free_one(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }

-- 
2.51.0


