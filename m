Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB7DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6828E0017; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDF58E0015; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C86648E0017; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7BCF8E0015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:00:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70C5F1DEAC0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:33 +0000 (UTC)
X-FDA: 83847947946.26.4806B17
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id E425D14001C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:00:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d815Ru4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q4+GHUrg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d815Ru4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q4+GHUrg;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oWCjHlWJr99JqLNVmSxndIbZ+8rS7a9vseEqgaq/bM=;
	b=3K98G2q31iYkGbOrw/oYPas2P6GyEAKh+FtBShYvnuumSZMII3zhMgEssgi++CW5W1Ax88
	2l9DtPrXs6xia+bMTV87IlrtAFz1D7Y358Sm04zOwpfYBttkJkvdhv4IRDX8aQ+pey9AZM
	2PnM5Fnt/MIWNYL8FDVV91s2+k06IY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904431; a=rsa-sha256;
	cv=none;
	b=m9TDaoh85KNn3QOg+BwsEn9K1/KLYkRSF3kUfe2TSfkeMDG8W2G1UeNmUfH+SQ0JyS6HTN
	lkshuwna8RLfRMgP20Wtejg7mak4jSCBqTYtKkVNirZ/OfCbCnD4yYQt+xkAH3ZiRcCJp3
	gWSY6VKjLLGnT4o7kFVh8fzr5dgPCF4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d815Ru4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q4+GHUrg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=d815Ru4u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Q4+GHUrg;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7DF6C21228;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0oWCjHlWJr99JqLNVmSxndIbZ+8rS7a9vseEqgaq/bM=;
	b=d815Ru4uv7FMVwbMjJB4RuhsWaLaTIIsXS/Enetu1ehbGaUOZHzOEk5zOBUWdiHqESNPAi
	IshDv4hWYz+IXGtkMQmmUFmy32avX5EjUoim4CR+byOlCeRa1Em2yAWaM3pUCcw84d1g6J
	igpy1jGPjXru50OKpo2wnapy3YyjZ5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0oWCjHlWJr99JqLNVmSxndIbZ+8rS7a9vseEqgaq/bM=;
	b=Q4+GHUrgEiS5Zd6Q5xYp5H5wgz+ryOTaUM26qiCw7XbrlIXvK97mQmHS7/ulCABCLSR1Bj
	ijrJ8InGr+ML3NCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0oWCjHlWJr99JqLNVmSxndIbZ+8rS7a9vseEqgaq/bM=;
	b=d815Ru4uv7FMVwbMjJB4RuhsWaLaTIIsXS/Enetu1ehbGaUOZHzOEk5zOBUWdiHqESNPAi
	IshDv4hWYz+IXGtkMQmmUFmy32avX5EjUoim4CR+byOlCeRa1Em2yAWaM3pUCcw84d1g6J
	igpy1jGPjXru50OKpo2wnapy3YyjZ5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0oWCjHlWJr99JqLNVmSxndIbZ+8rS7a9vseEqgaq/bM=;
	b=Q4+GHUrgEiS5Zd6Q5xYp5H5wgz+ryOTaUM26qiCw7XbrlIXvK97mQmHS7/ulCABCLSR1Bj
	ijrJ8InGr+ML3NCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B2EDC13B01;
	Wed,  3 Sep 2025 13:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4KBiK9k7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:09 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:50 +0200
Subject: [PATCH v7 08/21] slab: allow NUMA restricted allocations to use
 percpu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-8-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E425D14001C
X-Stat-Signature: qiydjnwuqyobyx87g3fi3e5donub3d76
X-Rspam-User: 
X-HE-Tag: 1756904430-751266
X-HE-Meta: U2FsdGVkX1/d+7ppgTuwToEhrhnuW1DLJemsJD+p+u2sVBsmJt4qPCXFg2dEw3qxHv0k6C8HJGugWswNZVDvVhWMqpEu2JfvhZbnvkHPrRv2rhw4mda20SwCPI6xkPZGOhQtsj1WoB5SGJF+PSTcZU+AQ/ivilZ9/l/YniGlcEAQ6xjxHrqLNFKnFD/g9bvqpuTfCtarKd4oQ7DPlK97NJ5np1+7TBicZ/PBSvznjn3Lojat5PFUc8Jo16bdo9E7fIggGPnRWmOQOg3bP+tAP0ygPu29zNtXA9izouRWm3+OgVnlMZn6qsxaH8e5IhXXSJFDA6C3K1pB6SxN3O/r4bmAFAO6fa0Gk/phpKYnmVhNGIQXhWm6LEAxyfNp+t3QTH4TKrNz255bzMH8WpcCcHO+2sypsAXPkUwBSMB0e5wDfAog9YCCkZ4wwxvBDmlQVtfYNYLRH+IyjSkOtVs5wocqDrFnA24H7R2P8Y3qfDCAs1YU5PtwnYZEwArLAO0potTJL/3aasQ+H56WnovR6RTE7UxiszLb4fn1Fwg4AhdBKsVDzMIprvPM1Bd8z/RnrRZH2sPejNnZ3qCmgZl4D0MZpEzERvTj9jFZ7U0BFhWJ6YhCKkgqCGBJmMEwrE12kIm/IqY2hkUYPeaErqrER+VfQfbk2ZCao55ZHA27Rg76SVKfabrmfpWIvuCFdWfiFOxHVRHh5xquTLMNY0iXhxX1QTPIckztlJRc63CE7q8Bcz1YqfxqHuEN2j3DvvjNQ4ONYoGLmiPo8LWBWbnB6uNVzfg5+AWeiEyKR7RJ7HT5PsOxBy6G7NZI69kqh8NJdEQU2RlDmKg8sXYDYsTn8biyCHIKpyBriCfGaRMfilwe6z9swWxIVyP+Xl2b7tlQTDIrPDF1NiYuxh+87ZL9TVjgw26M8iUqI6wVMF4q0Qmj+Lb5cIlnqGAjLEa0tyXhHzC6XvC17bJ/pF6xB7w
 JXTT6hlR
 FYJICPGh1nzB8qz1MI1VxMWSjdbet7XXiQoqEhvgDZRc1SywGBosPt/kCWMBd+AkN4794ckGYo9yGYkaryPCpuePpTN33FtAW4qvFG0bSc6xemHc4I4s1IRanxCGECjbihySdCSeM0+T8vcluPjBslYO071oALBLRTBiljoSkA1QDS3G8WlLWjUNjysChyYux16JX+NRcbCITY74vkoT/QIas0Zj6dzLmbEkXC2ZPlXK3fjbtMYYiub2m2MS1ywwqbB0zMLzVLXxwyPY=
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
index 8e34d6afccf41efad0c6620126e09f874bdcb663..d3d054579a8af710a0cbf68fe9688565c84d3609 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4816,18 +4816,43 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
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
 
@@ -4839,7 +4864,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
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
 
@@ -4939,8 +4978,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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


