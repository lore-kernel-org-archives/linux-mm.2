Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5AF8CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175EB6B0369; Wed, 27 Aug 2025 04:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14DD86B036B; Wed, 27 Aug 2025 04:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017AF6B036C; Wed, 27 Aug 2025 04:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA32B6B0369
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:26:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8712D11823C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:45 +0000 (UTC)
X-FDA: 83821856370.24.98046B2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66E0B100013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:26:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756283203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StGQyjLh8v5LXstxF3NvGpNpl34kQ9z6aLPxsZ+5j8o=;
	b=yOG7xDz2JNhitPKz6BcmKwAPmxSgD+IiVTLhP45P2I580jqd16PIFu0ISUgKbFIPERNiDk
	joqOr3eR3VuR+egu3ZkoYFNVyMIlVR0697SvHY9C2ujCE5mlKwMdAsjhbQnDawQ4cLjrKh
	S7OSY+IEnZPZPc0HfdcVDfZREbC2jwQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756283203; a=rsa-sha256;
	cv=none;
	b=EX5agAsSfJUO6CftByPkdq5yQxrl47QR2ZHVwUOxSg/7SWxUbeYjS0NVsix3KrQuH7Wasf
	Fui/cw0TXp29I1X9Nm5+1l1ypvqMrK01JUK028PDZLd9/eRyPTv80/o2RZchIY5ngrhvIu
	O9DuCEhO36WEdsfXp5HRiHdH5yy/aj8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 953222207C;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7F96A13A31;
	Wed, 27 Aug 2025 08:26:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2KXgHjvBrmhNfgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 27 Aug 2025 08:26:35 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 27 Aug 2025 10:26:39 +0200
Subject: [PATCH v6 07/10] slab: allow NUMA restricted allocations to use
 percpu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250827-slub-percpu-caches-v6-7-f0f775a3f73f@suse.cz>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
In-Reply-To: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66E0B100013
X-Stat-Signature: rza4p6jz55e1dw79opzxnoa35tr5o4x4
X-Rspam-User: 
X-HE-Tag: 1756283203-877953
X-HE-Meta: U2FsdGVkX194KiUZMVjf0De97JhwNiqi4qtqyF/rkJEIu/Oug9M6576ycZmKb4iY7t2wHA1HHrogtd39MwfZbgChWvtecrDhEC9VnUWCkAG2xCfqffUEU0XIPsYk4yPhrZJGFc9qZ4faNbgoPAps7ygnwtge2nAWjA8w05+0uccF1hDCG+ZaM84SlA2fLqMJ7NG2DqQzqSYuRcPTrdiY+v2Y4yR24o4my42PwxALz6PtAYiKt0nHBBuA7qQjjMdqFB764CU1Iw3hzEszTVR4VbzZMNvg6wXQWo4zgEVATtaXG/PLQNsN9CVeo5qGdYZqQXjV/8C1AMgdZ/qQH2P/o7Zo+ThuDO/05AfLpj26cpDAgPX31V8hgKzMaD7NsvnuGc329I3eS18c48ODKpUupWPDPp/oQ1RoaToPiwmCQ8CbYkihpN+VMIbK8wv5rdu39lr+3XRCivigzs3W++zFaG4jtfOmudRMI75dsRh0xyMJk0oEil5xaesJSCRUccLPU3qmRkI3G4nQaEzMyVwsQlRbuksqgBNDzz8Fu89d9Wgxw98OZhqUNDnkGPkiXUeLDdkg7QbOpffMLq1DuvyPZT4YFqywsnvefnhtboYlo/iSFN8EkqEEI8qY6/omVAcur28WMvTw0+rNvQ/XqmZ0HPdN+hEJcvp6Gf5dyFTwJqKMnorXdi7Rhh83uyxOuBaF7EUGOXj0G4XXr7ObEQeJFKaMTwVL5FOrQRInoRI4lTnieipXqyCeDE3x+TKL36P3L/8TNn1mxIZhrBWMqa2ut6QaaPsVCdHRdn0w5JrGDTzUOfPJsiSebr7lh4KYOjAcNCstmmLpGowhB1Vuv6/qzi513ElC+mVJqhqQpwwtwO9URMQ6H+roxlt6aixCoT7dXYjhpRUezEkhIqnTtmjVUUK5PoZPnOxhTwucpKgZky90uUWYv/XYIY1ZhkUIDqPnz/oxwwhwgQ7HcsxThHb
 LNqu+M33
 hWsmACq532JSNbpUS8TA+ubG8xFvEB92owAiZy1LkTn/rruomDCSgICuk/mEp+NmibiEZptWh9cFFq4lHvzRB6qF8uc8q8KWsqFE2CSZxwgQlpoc=
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

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b37e684457e7d14781466c0086d1b64df2fd8e9d..aeaffcbca49b3e50ef345c3a6f24d007b53ef24e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4808,18 +4808,43 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 {
 	struct slub_percpu_sheaves *pcs;
+	bool node_requested;
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
 
+	node_requested = IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE;
+
+	/*
+	 * We assume the percpu sheaves contain only local objects although it's
+	 * not completely guaranteed, so we verify later.
+	 */
+	if (unlikely(node_requested && node != numa_mem_id()))
+		return NULL;
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
@@ -4831,7 +4856,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
 			return NULL;
 	}
 
-	object = pcs->main->objects[--pcs->main->size];
+	object = pcs->main->objects[pcs->main->size - 1];
+
+	if (unlikely(node_requested)) {
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
 
@@ -4931,8 +4970,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves && node == NUMA_NO_NODE)
-		object = alloc_from_pcs(s, gfpflags);
+	if (s->cpu_sheaves)
+		object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);

-- 
2.51.0


