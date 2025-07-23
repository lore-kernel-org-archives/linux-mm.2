Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2372C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8196D6B00D3; Wed, 23 Jul 2025 09:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA0E6B00D4; Wed, 23 Jul 2025 09:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 643D66B00D5; Wed, 23 Jul 2025 09:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFA76B00D3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D9258070F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:21 +0000 (UTC)
X-FDA: 83695626042.15.A67C315
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE5DE80008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QYZMjNEq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3a1IUzu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QYZMjNEq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3a1IUzu;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277719; a=rsa-sha256;
	cv=none;
	b=W2v8eUwr/ceDvTHEv/ga8DRVFpt/Xf8959dT1hH61x7Az1BJLIP04QVs5kGWi0Zq8Nsr5K
	PSPc5/aGmS4U0Km1pGEm2pZ170RpyqzprE2ngjsBXnhf8AeHAjZ9oshOT7mBGAKrPDU+/O
	0eb2sEd+f8ZVgCscCEbBTF0ccLzBXDw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QYZMjNEq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3a1IUzu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QYZMjNEq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s3a1IUzu;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5N50KpHrcbkWP+T2bNvlGjW2kxPjMJyMhhnC06rEb9Y=;
	b=fVFTFpK3DKWAg+QMGNjTxQnhIJ1iuE5Qjygzvs/SMjpwhGqN9VxfHuO0xL/A5hPDC6Fjhi
	qLPe/QmG9JyCyl9n9SXlQLmI6Ht9UMWyFcqanpw52FcCPzipdxh7lLFsi8sLgHW+pHEZIw
	RcsvnMVvzsKYmLDeYhLWBMBnFd/9YEY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A21A221233;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5N50KpHrcbkWP+T2bNvlGjW2kxPjMJyMhhnC06rEb9Y=;
	b=QYZMjNEq62hxR8jbfv4GYd+aORWzzXWl0FWZ+TyLv5dnH3/LPxYKrgmLbBjIEBU8FJ8EXN
	86CEJwGcJmvb5g8fL/twbUC7S8Kvlk66PmkH/6Mfct9w5ezlYWDzOT5NQkvcVjHNs7pCNF
	Jzr9PYGMagrLcutpZ0rSdz+u4KezpTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5N50KpHrcbkWP+T2bNvlGjW2kxPjMJyMhhnC06rEb9Y=;
	b=s3a1IUzu8NfcfpQ1qLFiuUtxB6p8xCWqjald55ZZcij9W14qXdYk+8diRIjofH4XgEFSe8
	zXEPzUPu2mV/SnAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5N50KpHrcbkWP+T2bNvlGjW2kxPjMJyMhhnC06rEb9Y=;
	b=QYZMjNEq62hxR8jbfv4GYd+aORWzzXWl0FWZ+TyLv5dnH3/LPxYKrgmLbBjIEBU8FJ8EXN
	86CEJwGcJmvb5g8fL/twbUC7S8Kvlk66PmkH/6Mfct9w5ezlYWDzOT5NQkvcVjHNs7pCNF
	Jzr9PYGMagrLcutpZ0rSdz+u4KezpTs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5N50KpHrcbkWP+T2bNvlGjW2kxPjMJyMhhnC06rEb9Y=;
	b=s3a1IUzu8NfcfpQ1qLFiuUtxB6p8xCWqjald55ZZcij9W14qXdYk+8diRIjofH4XgEFSe8
	zXEPzUPu2mV/SnAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DAFA13AF2;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8I9OIgjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:43 +0200
Subject: [PATCH v5 10/14] mm, slab: allow NUMA restricted allocations to
 use percpu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-10-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE5DE80008
X-Stat-Signature: uozhyxpubgm59enhna1ikjg3r868xqsr
X-HE-Tag: 1753277718-136622
X-HE-Meta: U2FsdGVkX18Jk47NUcqh0snxb7Rsa6lf3/9H381zSOks2r7Ej0J5Cv5j3HHadclihugMjnvBmS+P5feEn0X+fgzVif0OSn4oMv8F20d14V/tf5JhMtJQxWzB0P7nOl+NwtUYMsMPrMwsba2sHKwoY9uIo+3R6AeIdOrTRMAnuK9OPHQd6RiQcA6R62dCX7ar7wrdOye+Ub7C2ehCQh9U3F1NJuz5s+9M2m66qNLqLTLwUYJfSiuCHDwvjn+3bSPtH58YeYthXB3MAy6AsHe+q1uHPSNcBNRL+o39zlD3bZjItMXQg3ZFUA56oV9da0HkqZDG/Ku45/e96u7PPCCD5wKI5aoXFLhdTKGGZs6PApyDCvg5NO1aXWBOsOE0aB6TzZMCC1yOz0wi0hPlMR2PqDQzh7U6PLJmPAu0mUBUr5Y9cGKY2NlRlr2/9LT7Im1Yns2tyBqtGtIopKlRMcRkaTD/c8BShELj/mQMV1sBrM8mb4c1qaktSFuL8lftPBtOzc+TBZu2O0DIPCUA669EzkXL6MxL3+rn0LeFwIY6mwn7Art3GGUYWnwMDbS8vIzALno7+FAPeoEZ8XGi2FkVCsDPxothW7ZlA/or3sCgYPN2c67mY7ptYsvcekijElxUp5IhgEtK3OiI+m3qsmN/9qmGkQsi+WH1ZRh5eLjandV5hY/zHRljmOupMw7RyOlPdSQMUSe1xxC6tFwTzuNPV4YZsMPVDeG3X2RKjSfs5qUh2OJBX6jakmFAm1xL0jQ2R8bssp7oXZe7QeqsXkdvq2sY5kVBBiX6+anOzROr0D7Ctd2CW/7lENCIhO9i2cgwmaHI0lew91UHfuOHDkUCYroaV9I5qllHQjHRCusWNa8WYrimt3f+d4g1jvzv80gN/zNwGdAiNFs1L9nxF0fgOa10xFyTBRq1VKvlG6vw9LhTUHAgwOi2USGyt7wWycRI40o0bAGEQr3la8M5NhQ
 e309jAAk
 9IuE6/3iaGoH60INgzexYTYHvgVufGOphSPF+6Fy3yKajdgMOjRnFhOvITSaNlyU4GjgE4OKtlGRkf0wACgzSVVK4vD7Acd4AgseJjbdB6084EsjlGi5MsU3ee79hZtc4SoLvLXb5yRaQZCNNuPXZAeIjAZg6FNDEEd2uaELbcLRWeTrAVNOd6MHnQA1Lk+05IykfMmMeCKArw/2qSZmJ0Wir8hQssq2k/LI7LYG71zNg9SI4WKYuW4E3pA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently allocations asking for a specific node explicitly or via
mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
contain mostly local objects, we can try allocating from them if the
local node happens to be the requested node or allowed by the mempolicy.
If we find the object from percpu sheaves is not from the expected node,
we skip the sheaves - this should be rare.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 52 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 45 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 50fc35b8fc9b3101821c338e9469c134677ded51..b98983b8d2e3e04ea256d91efcf0215ff0ae7e38 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4765,18 +4765,42 @@ __pcs_handle_empty(struct kmem_cache *s, struct slub_percpu_sheaves *pcs, gfp_t
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 {
 	struct slub_percpu_sheaves *pcs;
 	void *object;
 
 #ifdef CONFIG_NUMA
-	if (static_branch_unlikely(&strict_numa)) {
-		if (current->mempolicy)
-			return NULL;
+	if (static_branch_unlikely(&strict_numa) &&
+			 node == NUMA_NO_NODE) {
+
+		struct mempolicy *mpol = current->mempolicy;
+
+		if (mpol) {
+			/*
+			 * Special BIND rule support. If the local node
+			 * is in permitted set then do not redirect
+			 * to a particular node.
+			 * Otherwise we apply the memory policy to get
+			 * the node we need to allocate on.
+			 */
+			if (mpol->mode != MPOL_BIND ||
+					!node_isset(numa_mem_id(), mpol->nodes))
+
+				node = mempolicy_slab_node();
+		}
 	}
 #endif
 
+	if (unlikely(node != NUMA_NO_NODE)) {
+		/*
+		 * We assume the percpu sheaves contain only local objects
+		 * although it's not completely guaranteed, so we verify later.
+		 */
+		if (node != numa_mem_id())
+			return NULL;
+	}
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
@@ -4788,7 +4812,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
 			return NULL;
 	}
 
-	object = pcs->main->objects[--pcs->main->size];
+	object = pcs->main->objects[pcs->main->size - 1];
+
+	if (unlikely(node != NUMA_NO_NODE)) {
+		/*
+		 * Verify that the object was from the node we want. This could
+		 * be false because of cpu migration during an unlocked part of
+		 * the current allocation or previous freeing process.
+		 */
+		if (folio_nid(virt_to_folio(object)) != node) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return NULL;
+		}
+	}
+
+	pcs->main->size--;
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -4888,8 +4926,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves && node == NUMA_NO_NODE)
-		object = alloc_from_pcs(s, gfpflags);
+	if (s->cpu_sheaves)
+		object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);

-- 
2.50.1


