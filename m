Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209A4C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6266B009C; Wed, 23 Jul 2025 09:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DE76B00DC; Wed, 23 Jul 2025 09:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756046B00DE; Wed, 23 Jul 2025 09:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9416B009C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26B95140702
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:33 +0000 (UTC)
X-FDA: 83695626546.17.A0110B9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9C51620015
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wm2bChio;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zfUT3cTf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wm2bChio;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zfUT3cTf;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277731; a=rsa-sha256;
	cv=none;
	b=LwtPy5ab++M3e6yKm5+lMDAN6NTvIV66yyVymedzKn0g3whmswcRrS2c4PxojazsicQosF
	K9XYGvwtVptOAmRZ3LHsHnncKXqfjwZEdtyUjFJLvN+sxx4mONoB5L720lRln2/svQYhY2
	vwb3oib1TeB/9LHyUvRxFTFCJ9e+tA8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wm2bChio;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zfUT3cTf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=wm2bChio;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zfUT3cTf;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lIiUA/nm7dIiMOgxQASiMYQdEoYDUIn9A89qqQIi9s=;
	b=4V1dPOB/BRCXBxjmPCNKFXdv1n1iOqtWK8V2f+k2f/fHPAYv0OvOeI51V+0r5x5BtULzCs
	2oBdrpQGJ5+iiID6DLAFfECcT1EpawZAmbLZ3v4KcTuY9EY2dky6fU8wlUU8rEHVyUfN1q
	zcMQOG885GzUp/PO/AeAcFy0o/OipNI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C8CDC218F9;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lIiUA/nm7dIiMOgxQASiMYQdEoYDUIn9A89qqQIi9s=;
	b=wm2bChiohdlv3SvhGShGo1rR2nTHHa+GSV2g0YzoJoaDq/PRxSMOSrh54Milqgwv51NWoq
	NQ1AaugaQooRTejEb/tHksrOBGKL55jK/8iTE3C8kLLJmXPkqe53csx+gPzsNpKeKBCXD7
	5PmWdoDOPPFUBOucnIqJZ3+CyM8MB+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lIiUA/nm7dIiMOgxQASiMYQdEoYDUIn9A89qqQIi9s=;
	b=zfUT3cTfsm/48/z1m87pqMlDv0tEubs/v/e6V0DE9eiYsQc4JBBsDPUk9G9K93Tm16a32k
	gFfR7AFgGm/9aEBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lIiUA/nm7dIiMOgxQASiMYQdEoYDUIn9A89qqQIi9s=;
	b=wm2bChiohdlv3SvhGShGo1rR2nTHHa+GSV2g0YzoJoaDq/PRxSMOSrh54Milqgwv51NWoq
	NQ1AaugaQooRTejEb/tHksrOBGKL55jK/8iTE3C8kLLJmXPkqe53csx+gPzsNpKeKBCXD7
	5PmWdoDOPPFUBOucnIqJZ3+CyM8MB+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lIiUA/nm7dIiMOgxQASiMYQdEoYDUIn9A89qqQIi9s=;
	b=zfUT3cTfsm/48/z1m87pqMlDv0tEubs/v/e6V0DE9eiYsQc4JBBsDPUk9G9K93Tm16a32k
	gFfR7AFgGm/9aEBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B44DB13AFA;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OOHEKwjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:45 +0200
Subject: [PATCH v5 12/14] maple_tree: Sheaf conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-12-b792cd830f5d@suse.cz>
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
X-Stat-Signature: 4zzp3uyb7xqzpp31nkuwatcyr8put916
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C51620015
X-Rspamd-Server: rspam02
X-HE-Tag: 1753277730-626588
X-HE-Meta: U2FsdGVkX18eEu7nJt5fq9/5gRBKuFUoL8nI+7hk6JOin+ywC8zAd2z4FoNqnTptIvx30dHTPjsTjar29yxAY4FNYAJBs4y+9kNC3tpdXAMuBmHss6A4R9tQzqbVxTA+Bf/uHZqiHwErPMnGu2/Y42NXMVtMMib4+Gs8qRcn6shwJvApouxWqWzKzgeHBZE5TriElVhbGohDkWuJev6069JG//crIJG0ALKw9N4SaFjaJS8d2F+5Ld23Xk6SxSBgSyd8Mb/ngX1SIffakGsettwSNvV9TfoXorbICCs14rR69xEMHNoA6RWv1pgkSbPKTXAWkiRpRzUdUwedtvEZohW2nAg+9VRpjosPG3h/nWBDpxc8d0kge1uZ7aZhLTmmTwV1bvbAWwy1MN4dZSiDZtbiqDjbvhI0WaXvuLwY+7+xwjXzUBs93/MRhOc+PVUuZdLxeBY/oH4YvM3yjJhFslSTiOgkxbMNO/VPWjTkuM39R8kOc2OAOXFIyQuhlc/88nwB+0CF24ZpDb8vOEEs/69S0cE+ntcGxWPdlrWzgARKAeySTHhWtOKB7jJPu/+oJtDCRocUp8DEvkicR90Xrdtj7ljTZRcC7d86OeD9iR9L3oHW7VeKVgX3nS9t9OmrEF03ljG7Z1EWw6FoYTkvBpYtHiFCkGhuxiTdI21D1hTpVCMQLXI/S1wrCtAOf5fRRonipkahJGn/JtngfyXgwHcLkiPaszvoaAUb84r1sfU9Jp9dgfDFhsj110D8EKY1dZjtrIpAlUsWdX6aoomW/QmrxyOZJIhuAfGUveYrkEimPBDrHnjnCpu/RcNBKGCHt2RvppkPYGF+gSfRXft/KcXrCzH/87vgHCzzONbcy3dm8a+Jh5IuqypDFBVvDQjQHU1Wa9uJpO6Y8omfkZw28E2bn8ZsOYqQaUuOqSVe+QsvZjI7eT3BaPZyQpn1ZfSdHC3yRXg5Gm2w+TYElAt
 i0Sg6J7o
 MqR1yQ7NkFdB6cAQXLPAxmOVOpNOPYHT9o1/uMK/K57Y1cxsGhUgvQ7aTVsH9gYUuT6Rc8XYTY3Rr+zQNfjZUMsLuqIY7LCe5VFq4gkgtZonPF1kA3UMjbcBmtOVr2ahTWIBnPFAt1VCfqwVmnVMwAAshBfkVGmXCZvU96gQUEV6zaNTKZXpvydX3v3u7RvKoOhS7+F+u/ivmZbveZN6SPfzmF8Rg/GClbX15IpAJ4syTO72L+b1I0pzj45/tAfme26liHLsbGUUmLW3r7QMKXACPLC1qyRBXgMXFaqvmAHOZotDghg4PdeQ/XO6rDOoPB4u1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Use sheaves instead of bulk allocations.  This should speed up the
allocations and the return path of unused allocations.

Remove push/pop of nodes from maple state.
Remove unnecessary testing
ifdef out other testing that probably will be deleted
Fix testcase for testing race
Move some testing around in the same commit.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/maple_tree.h       |   6 +-
 lib/maple_tree.c                 | 331 ++++----------------
 lib/test_maple_tree.c            |   8 +
 tools/testing/radix-tree/maple.c | 632 +++++++--------------------------------
 tools/testing/shared/linux.c     |   8 +-
 5 files changed, 185 insertions(+), 800 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 9ef1290382249462d73ae72435dada7ce4b0622c..3cf1ae9dde7ce43fa20ae400c01fefad048c302e 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -442,7 +442,8 @@ struct ma_state {
 	struct maple_enode *node;	/* The node containing this entry */
 	unsigned long min;		/* The minimum index of this node - implied pivot min */
 	unsigned long max;		/* The maximum index of this node - implied pivot max */
-	struct maple_alloc *alloc;	/* Allocated nodes for this operation */
+	struct slab_sheaf *sheaf;	/* Allocated nodes for this operation */
+	unsigned long node_request;
 	enum maple_status status;	/* The status of the state (active, start, none, etc) */
 	unsigned char depth;		/* depth of tree descent during write */
 	unsigned char offset;
@@ -490,7 +491,8 @@ struct ma_wr_state {
 		.status = ma_start,					\
 		.min = 0,						\
 		.max = ULONG_MAX,					\
-		.alloc = NULL,						\
+		.node_request= 0,					\
+		.sheaf = NULL,						\
 		.mas_flags = 0,						\
 		.store_type = wr_invalid,				\
 	}
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 82f39fe29a462aa3c779789a28efdd6cdef64c79..3c3c14a76d98ded3b619c178d64099b464a2ca23 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -198,6 +198,22 @@ static void mt_free_rcu(struct rcu_head *head)
 	kmem_cache_free(maple_node_cache, node);
 }
 
+static void mt_return_sheaf(struct slab_sheaf *sheaf)
+{
+	kmem_cache_return_sheaf(maple_node_cache, GFP_KERNEL, sheaf);
+}
+
+static struct slab_sheaf *mt_get_sheaf(gfp_t gfp, int count)
+{
+	return kmem_cache_prefill_sheaf(maple_node_cache, gfp, count);
+}
+
+static int mt_refill_sheaf(gfp_t gfp, struct slab_sheaf **sheaf,
+		unsigned int size)
+{
+	return kmem_cache_refill_sheaf(maple_node_cache, gfp, sheaf, size);
+}
+
 /*
  * ma_free_rcu() - Use rcu callback to free a maple node
  * @node: The node to free
@@ -590,67 +606,6 @@ static __always_inline bool mte_dead_node(const struct maple_enode *enode)
 	return ma_dead_node(node);
 }
 
-/*
- * mas_allocated() - Get the number of nodes allocated in a maple state.
- * @mas: The maple state
- *
- * The ma_state alloc member is overloaded to hold a pointer to the first
- * allocated node or to the number of requested nodes to allocate.  If bit 0 is
- * set, then the alloc contains the number of requested nodes.  If there is an
- * allocated node, then the total allocated nodes is in that node.
- *
- * Return: The total number of nodes allocated
- */
-static inline unsigned long mas_allocated(const struct ma_state *mas)
-{
-	if (!mas->alloc || ((unsigned long)mas->alloc & 0x1))
-		return 0;
-
-	return mas->alloc->total;
-}
-
-/*
- * mas_set_alloc_req() - Set the requested number of allocations.
- * @mas: the maple state
- * @count: the number of allocations.
- *
- * The requested number of allocations is either in the first allocated node,
- * located in @mas->alloc->request_count, or directly in @mas->alloc if there is
- * no allocated node.  Set the request either in the node or do the necessary
- * encoding to store in @mas->alloc directly.
- */
-static inline void mas_set_alloc_req(struct ma_state *mas, unsigned long count)
-{
-	if (!mas->alloc || ((unsigned long)mas->alloc & 0x1)) {
-		if (!count)
-			mas->alloc = NULL;
-		else
-			mas->alloc = (struct maple_alloc *)(((count) << 1U) | 1U);
-		return;
-	}
-
-	mas->alloc->request_count = count;
-}
-
-/*
- * mas_alloc_req() - get the requested number of allocations.
- * @mas: The maple state
- *
- * The alloc count is either stored directly in @mas, or in
- * @mas->alloc->request_count if there is at least one node allocated.  Decode
- * the request count if it's stored directly in @mas->alloc.
- *
- * Return: The allocation request count.
- */
-static inline unsigned int mas_alloc_req(const struct ma_state *mas)
-{
-	if ((unsigned long)mas->alloc & 0x1)
-		return (unsigned long)(mas->alloc) >> 1;
-	else if (mas->alloc)
-		return mas->alloc->request_count;
-	return 0;
-}
-
 /*
  * ma_pivots() - Get a pointer to the maple node pivots.
  * @node: the maple node
@@ -1148,77 +1103,15 @@ static int mas_ascend(struct ma_state *mas)
  */
 static inline struct maple_node *mas_pop_node(struct ma_state *mas)
 {
-	struct maple_alloc *ret, *node = mas->alloc;
-	unsigned long total = mas_allocated(mas);
-	unsigned int req = mas_alloc_req(mas);
+	struct maple_node *ret;
 
-	/* nothing or a request pending. */
-	if (WARN_ON(!total))
+	if (WARN_ON_ONCE(!mas->sheaf))
 		return NULL;
 
-	if (total == 1) {
-		/* single allocation in this ma_state */
-		mas->alloc = NULL;
-		ret = node;
-		goto single_node;
-	}
-
-	if (node->node_count == 1) {
-		/* Single allocation in this node. */
-		mas->alloc = node->slot[0];
-		mas->alloc->total = node->total - 1;
-		ret = node;
-		goto new_head;
-	}
-	node->total--;
-	ret = node->slot[--node->node_count];
-	node->slot[node->node_count] = NULL;
-
-single_node:
-new_head:
-	if (req) {
-		req++;
-		mas_set_alloc_req(mas, req);
-	}
-
+	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
 	memset(ret, 0, sizeof(*ret));
-	return (struct maple_node *)ret;
-}
-
-/*
- * mas_push_node() - Push a node back on the maple state allocation.
- * @mas: The maple state
- * @used: The used maple node
- *
- * Stores the maple node back into @mas->alloc for reuse.  Updates allocated and
- * requested node count as necessary.
- */
-static inline void mas_push_node(struct ma_state *mas, struct maple_node *used)
-{
-	struct maple_alloc *reuse = (struct maple_alloc *)used;
-	struct maple_alloc *head = mas->alloc;
-	unsigned long count;
-	unsigned int requested = mas_alloc_req(mas);
-
-	count = mas_allocated(mas);
 
-	reuse->request_count = 0;
-	reuse->node_count = 0;
-	if (count) {
-		if (head->node_count < MAPLE_ALLOC_SLOTS) {
-			head->slot[head->node_count++] = reuse;
-			head->total++;
-			goto done;
-		}
-		reuse->slot[0] = head;
-		reuse->node_count = 1;
-	}
-
-	reuse->total = count + 1;
-	mas->alloc = reuse;
-done:
-	if (requested > 1)
-		mas_set_alloc_req(mas, requested - 1);
+	return ret;
 }
 
 /*
@@ -1228,75 +1121,32 @@ static inline void mas_push_node(struct ma_state *mas, struct maple_node *used)
  */
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
-	struct maple_alloc *node;
-	unsigned long allocated = mas_allocated(mas);
-	unsigned int requested = mas_alloc_req(mas);
-	unsigned int count;
-	void **slots = NULL;
-	unsigned int max_req = 0;
-
-	if (!requested)
-		return;
+	if (unlikely(mas->sheaf)) {
+		unsigned long refill = mas->node_request;
 
-	mas_set_alloc_req(mas, 0);
-	if (mas->mas_flags & MA_STATE_PREALLOC) {
-		if (allocated)
+		if(kmem_cache_sheaf_size(mas->sheaf) >= refill) {
+			mas->node_request = 0;
 			return;
-		WARN_ON(!allocated);
-	}
-
-	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS) {
-		node = (struct maple_alloc *)mt_alloc_one(gfp);
-		if (!node)
-			goto nomem_one;
-
-		if (allocated) {
-			node->slot[0] = mas->alloc;
-			node->node_count = 1;
-		} else {
-			node->node_count = 0;
 		}
 
-		mas->alloc = node;
-		node->total = ++allocated;
-		node->request_count = 0;
-		requested--;
-	}
+		if (mt_refill_sheaf(gfp, &mas->sheaf, refill))
+			goto error;
 
-	node = mas->alloc;
-	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
-		slots = (void **)&node->slot[node->node_count];
-		max_req = min(requested, max_req);
-		count = mt_alloc_bulk(gfp, max_req, slots);
-		if (!count)
-			goto nomem_bulk;
-
-		if (node->node_count == 0) {
-			node->slot[0]->node_count = 0;
-			node->slot[0]->request_count = 0;
-		}
+		mas->node_request = 0;
+		return;
+	}
 
-		node->node_count += count;
-		allocated += count;
-		/* find a non-full node*/
-		do {
-			node = node->slot[0];
-		} while (unlikely(node->node_count == MAPLE_ALLOC_SLOTS));
-		requested -= count;
+	mas->sheaf = mt_get_sheaf(gfp, mas->node_request);
+	if (likely(mas->sheaf)) {
+		mas->node_request = 0;
+		return;
 	}
-	mas->alloc->total = allocated;
-	return;
 
-nomem_bulk:
-	/* Clean up potential freed allocations on bulk failure */
-	memset(slots, 0, max_req * sizeof(unsigned long));
-	mas->alloc->total = allocated;
-nomem_one:
-	mas_set_alloc_req(mas, requested);
+error:  
 	mas_set_err(mas, -ENOMEM);
 }
 
+
 /*
  * mas_free() - Free an encoded maple node
  * @mas: The maple state
@@ -1307,42 +1157,7 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
  */
 static inline void mas_free(struct ma_state *mas, struct maple_enode *used)
 {
-	struct maple_node *tmp = mte_to_node(used);
-
-	if (mt_in_rcu(mas->tree))
-		ma_free_rcu(tmp);
-	else
-		mas_push_node(mas, tmp);
-}
-
-/*
- * mas_node_count_gfp() - Check if enough nodes are allocated and request more
- * if there is not enough nodes.
- * @mas: The maple state
- * @count: The number of nodes needed
- * @gfp: the gfp flags
- */
-static void mas_node_count_gfp(struct ma_state *mas, int count, gfp_t gfp)
-{
-	unsigned long allocated = mas_allocated(mas);
-
-	if (allocated < count) {
-		mas_set_alloc_req(mas, count - allocated);
-		mas_alloc_nodes(mas, gfp);
-	}
-}
-
-/*
- * mas_node_count() - Check if enough nodes are allocated and request more if
- * there is not enough nodes.
- * @mas: The maple state
- * @count: The number of nodes needed
- *
- * Note: Uses GFP_NOWAIT | __GFP_NOWARN for gfp flags.
- */
-static void mas_node_count(struct ma_state *mas, int count)
-{
-	return mas_node_count_gfp(mas, count, GFP_NOWAIT | __GFP_NOWARN);
+	ma_free_rcu(mte_to_node(used));
 }
 
 /*
@@ -2517,10 +2332,7 @@ static inline void mas_topiary_node(struct ma_state *mas,
 	enode = tmp_mas->node;
 	tmp = mte_to_node(enode);
 	mte_set_node_dead(enode);
-	if (in_rcu)
-		ma_free_rcu(tmp);
-	else
-		mas_push_node(mas, tmp);
+	ma_free_rcu(tmp);
 }
 
 /*
@@ -4168,7 +3980,7 @@ static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
  *
  * Return: Number of nodes required for preallocation.
  */
-static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
+static inline void mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char height = mas_mt_height(mas);
@@ -4214,7 +4026,7 @@ static inline int mas_prealloc_calc(struct ma_wr_state *wr_mas, void *entry)
 		WARN_ON_ONCE(1);
 	}
 
-	return ret;
+	mas->node_request = ret;
 }
 
 /*
@@ -4275,15 +4087,15 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
  */
 static inline void mas_wr_preallocate(struct ma_wr_state *wr_mas, void *entry)
 {
-	int request;
+	struct ma_state *mas = wr_mas->mas;
 
 	mas_wr_prealloc_setup(wr_mas);
-	wr_mas->mas->store_type = mas_wr_store_type(wr_mas);
-	request = mas_prealloc_calc(wr_mas, entry);
-	if (!request)
+	mas->store_type = mas_wr_store_type(wr_mas);
+	mas_prealloc_calc(wr_mas, entry);
+	if (!mas->node_request)
 		return;
 
-	mas_node_count(wr_mas->mas, request);
+	mas_alloc_nodes(mas, GFP_NOWAIT | __GFP_NOWARN);
 }
 
 /**
@@ -5398,7 +5210,6 @@ static inline void mte_destroy_walk(struct maple_enode *enode,
  */
 void *mas_store(struct ma_state *mas, void *entry)
 {
-	int request;
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	trace_ma_write(__func__, mas, 0, entry);
@@ -5428,11 +5239,11 @@ void *mas_store(struct ma_state *mas, void *entry)
 		return wr_mas.content;
 	}
 
-	request = mas_prealloc_calc(&wr_mas, entry);
-	if (!request)
+	mas_prealloc_calc(&wr_mas, entry);
+	if (!mas->node_request)
 		goto store;
 
-	mas_node_count(mas, request);
+	mas_alloc_nodes(mas, GFP_NOWAIT | __GFP_NOWARN);
 	if (mas_is_err(mas))
 		return NULL;
 
@@ -5520,26 +5331,25 @@ EXPORT_SYMBOL_GPL(mas_store_prealloc);
 int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 {
 	MA_WR_STATE(wr_mas, mas, entry);
-	int ret = 0;
-	int request;
 
 	mas_wr_prealloc_setup(&wr_mas);
 	mas->store_type = mas_wr_store_type(&wr_mas);
-	request = mas_prealloc_calc(&wr_mas, entry);
-	if (!request)
-		return ret;
+	mas_prealloc_calc(&wr_mas, entry);
+	if (!mas->node_request)
+		return 0;
 
-	mas_node_count_gfp(mas, request, gfp);
+	mas_alloc_nodes(mas, gfp);
 	if (mas_is_err(mas)) {
-		mas_set_alloc_req(mas, 0);
-		ret = xa_err(mas->node);
+		int ret = xa_err(mas->node);
+
+		mas->node_request = 0;
 		mas_destroy(mas);
 		mas_reset(mas);
 		return ret;
 	}
 
 	mas->mas_flags |= MA_STATE_PREALLOC;
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mas_preallocate);
 
@@ -5553,9 +5363,6 @@ EXPORT_SYMBOL_GPL(mas_preallocate);
  */
 void mas_destroy(struct ma_state *mas)
 {
-	struct maple_alloc *node;
-	unsigned long total;
-
 	/*
 	 * When using mas_for_each() to insert an expected number of elements,
 	 * it is possible that the number inserted is less than the expected
@@ -5576,21 +5383,11 @@ void mas_destroy(struct ma_state *mas)
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
 
-	total = mas_allocated(mas);
-	while (total) {
-		node = mas->alloc;
-		mas->alloc = node->slot[0];
-		if (node->node_count > 1) {
-			size_t count = node->node_count - 1;
-
-			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
-			total -= count;
-		}
-		mt_free_one(ma_mnode_ptr(node));
-		total--;
-	}
+	mas->node_request = 0;
+	if (mas->sheaf)
+		mt_return_sheaf(mas->sheaf);
 
-	mas->alloc = NULL;
+	mas->sheaf = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -5640,7 +5437,8 @@ int mas_expected_entries(struct ma_state *mas, unsigned long nr_entries)
 	/* Internal nodes */
 	nr_nodes += DIV_ROUND_UP(nr_nodes, nonleaf_cap);
 	/* Add working room for split (2 nodes) + new parents */
-	mas_node_count_gfp(mas, nr_nodes + 3, GFP_KERNEL);
+	mas->node_request = nr_nodes + 3;
+	mas_alloc_nodes(mas, GFP_KERNEL);
 
 	/* Detect if allocations run out */
 	mas->mas_flags |= MA_STATE_PREALLOC;
@@ -6276,7 +6074,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
-	if (!mas_allocated(mas))
+	if (!mas->sheaf)
 		return false;
 
 	mas->status = ma_start;
@@ -7671,8 +7469,9 @@ void mas_dump(const struct ma_state *mas)
 
 	pr_err("[%u/%u] index=%lx last=%lx\n", mas->offset, mas->end,
 	       mas->index, mas->last);
-	pr_err("     min=%lx max=%lx alloc=" PTR_FMT ", depth=%u, flags=%x\n",
-	       mas->min, mas->max, mas->alloc, mas->depth, mas->mas_flags);
+	pr_err("     min=%lx max=%lx sheaf=" PTR_FMT ", request %lu depth=%u, flags=%x\n",
+	       mas->min, mas->max, mas->sheaf, mas->node_request, mas->depth,
+	       mas->mas_flags);
 	if (mas->index > mas->last)
 		pr_err("Check index & last\n");
 }
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 13e2a10d7554d6b1de5ffbda59f3a5bc4039a8c8..5549eb4200c7974e3bb457e0fd054c434e4b85da 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2746,6 +2746,7 @@ static noinline void __init check_fuzzer(struct maple_tree *mt)
 	mtree_test_erase(mt, ULONG_MAX - 10);
 }
 
+#if 0
 /* duplicate the tree with a specific gap */
 static noinline void __init check_dup_gaps(struct maple_tree *mt,
 				    unsigned long nr_entries, bool zero_start,
@@ -2770,6 +2771,7 @@ static noinline void __init check_dup_gaps(struct maple_tree *mt,
 		mtree_store_range(mt, i*10, (i+1)*10 - gap,
 				  xa_mk_value(i), GFP_KERNEL);
 
+	mt_dump(mt, mt_dump_dec);
 	mt_init_flags(&newmt, MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN);
 	mt_set_non_kernel(99999);
 	down_write(&newmt_lock);
@@ -2779,9 +2781,12 @@ static noinline void __init check_dup_gaps(struct maple_tree *mt,
 
 	rcu_read_lock();
 	mas_for_each(&mas, tmp, ULONG_MAX) {
+		printk("%lu nodes %lu\n", mas.index,
+		       kmem_cache_sheaf_count(newmas.sheaf));
 		newmas.index = mas.index;
 		newmas.last = mas.last;
 		mas_store(&newmas, tmp);
+		mt_dump(&newmt, mt_dump_dec);
 	}
 	rcu_read_unlock();
 	mas_destroy(&newmas);
@@ -2878,6 +2883,7 @@ static noinline void __init check_dup(struct maple_tree *mt)
 		cond_resched();
 	}
 }
+#endif
 
 static noinline void __init check_bnode_min_spanning(struct maple_tree *mt)
 {
@@ -4045,9 +4051,11 @@ static int __init maple_tree_seed(void)
 	check_fuzzer(&tree);
 	mtree_destroy(&tree);
 
+#if 0
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_dup(&tree);
 	mtree_destroy(&tree);
+#endif
 
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_bnode_min_spanning(&tree);
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index f6f923c9dc1039997953a94ec184c560b225c2d4..1bd789191f232385d69f2dd3e900bac99d8919ff 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -63,430 +63,6 @@ struct rcu_reader_struct {
 	struct rcu_test_struct2 *test;
 };
 
-static int get_alloc_node_count(struct ma_state *mas)
-{
-	int count = 1;
-	struct maple_alloc *node = mas->alloc;
-
-	if (!node || ((unsigned long)node & 0x1))
-		return 0;
-	while (node->node_count) {
-		count += node->node_count;
-		node = node->slot[0];
-	}
-	return count;
-}
-
-static void check_mas_alloc_node_count(struct ma_state *mas)
-{
-	mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 1, GFP_KERNEL);
-	mas_node_count_gfp(mas, MAPLE_ALLOC_SLOTS + 3, GFP_KERNEL);
-	MT_BUG_ON(mas->tree, get_alloc_node_count(mas) != mas->alloc->total);
-	mas_destroy(mas);
-}
-
-/*
- * check_new_node() - Check the creation of new nodes and error path
- * verification.
- */
-static noinline void __init check_new_node(struct maple_tree *mt)
-{
-
-	struct maple_node *mn, *mn2, *mn3;
-	struct maple_alloc *smn;
-	struct maple_node *nodes[100];
-	int i, j, total;
-
-	MA_STATE(mas, mt, 0, 0);
-
-	check_mas_alloc_node_count(&mas);
-
-	/* Try allocating 3 nodes */
-	mtree_lock(mt);
-	mt_set_non_kernel(0);
-	/* request 3 nodes to be allocated. */
-	mas_node_count(&mas, 3);
-	/* Allocation request of 3. */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 3);
-	/* Allocate failed. */
-	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-
-	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, not_empty(mn));
-	MT_BUG_ON(mt, mn == NULL);
-	MT_BUG_ON(mt, mas.alloc == NULL);
-	MT_BUG_ON(mt, mas.alloc->slot[0] == NULL);
-	mas_push_node(&mas, mn);
-	mas_reset(&mas);
-	mas_destroy(&mas);
-	mtree_unlock(mt);
-
-
-	/* Try allocating 1 node, then 2 more */
-	mtree_lock(mt);
-	/* Set allocation request to 1. */
-	mas_set_alloc_req(&mas, 1);
-	/* Check Allocation request of 1. */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 1);
-	mas_set_err(&mas, -ENOMEM);
-	/* Validate allocation request. */
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	/* Eat the requested node. */
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, not_empty(mn));
-	MT_BUG_ON(mt, mn == NULL);
-	MT_BUG_ON(mt, mn->slot[0] != NULL);
-	MT_BUG_ON(mt, mn->slot[1] != NULL);
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-
-	mn->parent = ma_parent_ptr(mn);
-	ma_free_rcu(mn);
-	mas.status = ma_start;
-	mas_destroy(&mas);
-	/* Allocate 3 nodes, will fail. */
-	mas_node_count(&mas, 3);
-	/* Drop the lock and allocate 3 nodes. */
-	mas_nomem(&mas, GFP_KERNEL);
-	/* Ensure 3 are allocated. */
-	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
-	/* Allocation request of 0. */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 0);
-
-	MT_BUG_ON(mt, mas.alloc == NULL);
-	MT_BUG_ON(mt, mas.alloc->slot[0] == NULL);
-	MT_BUG_ON(mt, mas.alloc->slot[1] == NULL);
-	/* Ensure we counted 3. */
-	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
-	/* Free. */
-	mas_reset(&mas);
-	mas_destroy(&mas);
-
-	/* Set allocation request to 1. */
-	mas_set_alloc_req(&mas, 1);
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 1);
-	mas_set_err(&mas, -ENOMEM);
-	/* Validate allocation request. */
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	MT_BUG_ON(mt, mas_allocated(&mas) != 1);
-	/* Check the node is only one node. */
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, not_empty(mn));
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	MT_BUG_ON(mt, mn == NULL);
-	MT_BUG_ON(mt, mn->slot[0] != NULL);
-	MT_BUG_ON(mt, mn->slot[1] != NULL);
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas_allocated(&mas) != 1);
-	MT_BUG_ON(mt, mas.alloc->node_count);
-
-	mas_set_alloc_req(&mas, 2); /* request 2 more. */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 2);
-	mas_set_err(&mas, -ENOMEM);
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	MT_BUG_ON(mt, mas_allocated(&mas) != 3);
-	MT_BUG_ON(mt, mas.alloc == NULL);
-	MT_BUG_ON(mt, mas.alloc->slot[0] == NULL);
-	MT_BUG_ON(mt, mas.alloc->slot[1] == NULL);
-	for (i = 2; i >= 0; i--) {
-		mn = mas_pop_node(&mas);
-		MT_BUG_ON(mt, mas_allocated(&mas) != i);
-		MT_BUG_ON(mt, !mn);
-		MT_BUG_ON(mt, not_empty(mn));
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-	}
-
-	total = 64;
-	mas_set_alloc_req(&mas, total); /* request 2 more. */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != total);
-	mas_set_err(&mas, -ENOMEM);
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	for (i = total; i > 0; i--) {
-		unsigned int e = 0; /* expected node_count */
-
-		if (!MAPLE_32BIT) {
-			if (i >= 35)
-				e = i - 34;
-			else if (i >= 5)
-				e = i - 4;
-			else if (i >= 2)
-				e = i - 1;
-		} else {
-			if (i >= 4)
-				e = i - 3;
-			else if (i >= 1)
-				e = i - 1;
-			else
-				e = 0;
-		}
-
-		MT_BUG_ON(mt, mas.alloc->node_count != e);
-		mn = mas_pop_node(&mas);
-		MT_BUG_ON(mt, not_empty(mn));
-		MT_BUG_ON(mt, mas_allocated(&mas) != i - 1);
-		MT_BUG_ON(mt, !mn);
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-	}
-
-	total = 100;
-	for (i = 1; i < total; i++) {
-		mas_set_alloc_req(&mas, i);
-		mas_set_err(&mas, -ENOMEM);
-		MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-		for (j = i; j > 0; j--) {
-			mn = mas_pop_node(&mas);
-			MT_BUG_ON(mt, mas_allocated(&mas) != j - 1);
-			MT_BUG_ON(mt, !mn);
-			MT_BUG_ON(mt, not_empty(mn));
-			mas_push_node(&mas, mn);
-			MT_BUG_ON(mt, mas_allocated(&mas) != j);
-			mn = mas_pop_node(&mas);
-			MT_BUG_ON(mt, not_empty(mn));
-			MT_BUG_ON(mt, mas_allocated(&mas) != j - 1);
-			mn->parent = ma_parent_ptr(mn);
-			ma_free_rcu(mn);
-		}
-		MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-
-		mas_set_alloc_req(&mas, i);
-		mas_set_err(&mas, -ENOMEM);
-		MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-		for (j = 0; j <= i/2; j++) {
-			MT_BUG_ON(mt, mas_allocated(&mas) != i - j);
-			nodes[j] = mas_pop_node(&mas);
-			MT_BUG_ON(mt, mas_allocated(&mas) != i - j - 1);
-		}
-
-		while (j) {
-			j--;
-			mas_push_node(&mas, nodes[j]);
-			MT_BUG_ON(mt, mas_allocated(&mas) != i - j);
-		}
-		MT_BUG_ON(mt, mas_allocated(&mas) != i);
-		for (j = 0; j <= i/2; j++) {
-			MT_BUG_ON(mt, mas_allocated(&mas) != i - j);
-			mn = mas_pop_node(&mas);
-			MT_BUG_ON(mt, not_empty(mn));
-			mn->parent = ma_parent_ptr(mn);
-			ma_free_rcu(mn);
-			MT_BUG_ON(mt, mas_allocated(&mas) != i - j - 1);
-		}
-		mas_reset(&mas);
-		MT_BUG_ON(mt, mas_nomem(&mas, GFP_KERNEL));
-		mas_destroy(&mas);
-
-	}
-
-	/* Set allocation request. */
-	total = 500;
-	mas_node_count(&mas, total);
-	/* Drop the lock and allocate the nodes. */
-	mas_nomem(&mas, GFP_KERNEL);
-	MT_BUG_ON(mt, !mas.alloc);
-	i = 1;
-	smn = mas.alloc;
-	while (i < total) {
-		for (j = 0; j < MAPLE_ALLOC_SLOTS; j++) {
-			i++;
-			MT_BUG_ON(mt, !smn->slot[j]);
-			if (i == total)
-				break;
-		}
-		smn = smn->slot[0]; /* next. */
-	}
-	MT_BUG_ON(mt, mas_allocated(&mas) != total);
-	mas_reset(&mas);
-	mas_destroy(&mas); /* Free. */
-
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	for (i = 1; i < 128; i++) {
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		MT_BUG_ON(mt, mas_allocated(&mas) != i); /* check request filled */
-		for (j = i; j > 0; j--) { /*Free the requests */
-			mn = mas_pop_node(&mas); /* get the next node. */
-			MT_BUG_ON(mt, mn == NULL);
-			MT_BUG_ON(mt, not_empty(mn));
-			mn->parent = ma_parent_ptr(mn);
-			ma_free_rcu(mn);
-		}
-		MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	}
-
-	for (i = 1; i < MAPLE_NODE_MASK + 1; i++) {
-		MA_STATE(mas2, mt, 0, 0);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		MT_BUG_ON(mt, mas_allocated(&mas) != i); /* check request filled */
-		for (j = 1; j <= i; j++) { /* Move the allocations to mas2 */
-			mn = mas_pop_node(&mas); /* get the next node. */
-			MT_BUG_ON(mt, mn == NULL);
-			MT_BUG_ON(mt, not_empty(mn));
-			mas_push_node(&mas2, mn);
-			MT_BUG_ON(mt, mas_allocated(&mas2) != j);
-		}
-		MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-		MT_BUG_ON(mt, mas_allocated(&mas2) != i);
-
-		for (j = i; j > 0; j--) { /*Free the requests */
-			MT_BUG_ON(mt, mas_allocated(&mas2) != j);
-			mn = mas_pop_node(&mas2); /* get the next node. */
-			MT_BUG_ON(mt, mn == NULL);
-			MT_BUG_ON(mt, not_empty(mn));
-			mn->parent = ma_parent_ptr(mn);
-			ma_free_rcu(mn);
-		}
-		MT_BUG_ON(mt, mas_allocated(&mas2) != 0);
-	}
-
-
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 1); /* Request */
-	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
-
-	mn = mas_pop_node(&mas); /* get the next node. */
-	MT_BUG_ON(mt, mn == NULL);
-	MT_BUG_ON(mt, not_empty(mn));
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
-
-	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
-
-	/* Check the limit of pop/push/pop */
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 2); /* Request */
-	MT_BUG_ON(mt, mas_alloc_req(&mas) != 1);
-	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
-	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
-	MT_BUG_ON(mt, mas_alloc_req(&mas));
-	MT_BUG_ON(mt, mas.alloc->node_count != 1);
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, not_empty(mn));
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS);
-	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas.alloc->node_count != 1);
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, not_empty(mn));
-	mn->parent = ma_parent_ptr(mn);
-	ma_free_rcu(mn);
-	for (i = 1; i <= MAPLE_ALLOC_SLOTS + 1; i++) {
-		mn = mas_pop_node(&mas);
-		MT_BUG_ON(mt, not_empty(mn));
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-	}
-	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
-
-
-	for (i = 3; i < MAPLE_NODE_MASK * 3; i++) {
-		mas.node = MA_ERROR(-ENOMEM);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mas_push_node(&mas, mn); /* put it back */
-		mas_destroy(&mas);
-
-		mas.node = MA_ERROR(-ENOMEM);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn2 = mas_pop_node(&mas); /* get the next node. */
-		mas_push_node(&mas, mn); /* put them back */
-		mas_push_node(&mas, mn2);
-		mas_destroy(&mas);
-
-		mas.node = MA_ERROR(-ENOMEM);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn2 = mas_pop_node(&mas); /* get the next node. */
-		mn3 = mas_pop_node(&mas); /* get the next node. */
-		mas_push_node(&mas, mn); /* put them back */
-		mas_push_node(&mas, mn2);
-		mas_push_node(&mas, mn3);
-		mas_destroy(&mas);
-
-		mas.node = MA_ERROR(-ENOMEM);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-		mas_destroy(&mas);
-
-		mas.node = MA_ERROR(-ENOMEM);
-		mas_node_count(&mas, i); /* Request */
-		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-		mn = mas_pop_node(&mas); /* get the next node. */
-		mn->parent = ma_parent_ptr(mn);
-		ma_free_rcu(mn);
-		mas_destroy(&mas);
-	}
-
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, 5); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	MT_BUG_ON(mt, mas_allocated(&mas) != 5);
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, 10); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	mas.status = ma_start;
-	MT_BUG_ON(mt, mas_allocated(&mas) != 10);
-	mas_destroy(&mas);
-
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS - 1); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS - 1);
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, 10 + MAPLE_ALLOC_SLOTS - 1); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	mas.status = ma_start;
-	MT_BUG_ON(mt, mas_allocated(&mas) != 10 + MAPLE_ALLOC_SLOTS - 1);
-	mas_destroy(&mas);
-
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 1); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 2); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	mas.status = ma_start;
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 2 + 2);
-	mas_destroy(&mas);
-
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 2 + 1); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 2 + 1);
-	mas.node = MA_ERROR(-ENOMEM);
-	mas_node_count(&mas, MAPLE_ALLOC_SLOTS * 3 + 2); /* Request */
-	mas_nomem(&mas, GFP_KERNEL); /* Fill request */
-	mas.status = ma_start;
-	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS * 3 + 2);
-	mas_destroy(&mas);
-
-	mtree_unlock(mt);
-}
-
 /*
  * Check erasing including RCU.
  */
@@ -35458,8 +35034,7 @@ static void check_dfs_preorder(struct maple_tree *mt)
 	mt_init_flags(mt, MT_FLAGS_ALLOC_RANGE);
 	mas_reset(&mas);
 	mt_zero_nr_tallocated();
-	mt_set_non_kernel(200);
-	mas_expected_entries(&mas, max);
+	mt_set_non_kernel(1000);
 	for (count = 0; count <= max; count++) {
 		mas.index = mas.last = count;
 		mas_store(&mas, xa_mk_value(count));
@@ -35524,6 +35099,13 @@ static unsigned char get_vacant_height(struct ma_wr_state *wr_mas, void *entry)
 	return vacant_height;
 }
 
+static int mas_allocated(struct ma_state *mas)
+{
+	if (mas->sheaf)
+		return kmem_cache_sheaf_size(mas->sheaf);
+
+	return 0;
+}
 /* Preallocation testing */
 static noinline void __init check_prealloc(struct maple_tree *mt)
 {
@@ -35533,8 +35115,8 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	unsigned char vacant_height;
 	struct maple_node *mn;
 	void *ptr = check_prealloc;
+	struct ma_wr_state wr_mas;
 	MA_STATE(mas, mt, 10, 20);
-	MA_WR_STATE(wr_mas, &mas, ptr);
 
 	mt_set_non_kernel(1000);
 	for (i = 0; i <= max; i++)
@@ -35542,7 +35124,11 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 
 	/* Spanning store */
 	mas_set_range(&mas, 470, 500);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
+	wr_mas.mas = &mas;
+
+	mas_wr_preallocate(&wr_mas, ptr);
+	MT_BUG_ON(mt, mas.store_type != wr_spanning_store);
+	MT_BUG_ON(mt, mas_is_err(&mas));
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
 	vacant_height = get_vacant_height(&wr_mas, ptr);
@@ -35552,6 +35138,7 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
 
+	mas_wr_preallocate(&wr_mas, ptr);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
@@ -35592,20 +35179,6 @@ static noinline void __init check_prealloc(struct maple_tree *mt)
 	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
-	allocated = mas_allocated(&mas);
-	height = mas_mt_height(&mas);
-	vacant_height = get_vacant_height(&wr_mas, ptr);
-	MT_BUG_ON(mt, allocated != 1 + (height - vacant_height) * 3);
-	mn = mas_pop_node(&mas);
-	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
-	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas_allocated(&mas) != allocated);
-	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
-	mas_destroy(&mas);
-	allocated = mas_allocated(&mas);
-	MT_BUG_ON(mt, allocated != 0);
-
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	allocated = mas_allocated(&mas);
 	height = mas_mt_height(&mas);
@@ -36394,11 +35967,17 @@ static void check_nomem_writer_race(struct maple_tree *mt)
 	check_load(mt, 6, xa_mk_value(0xC));
 	mtree_unlock(mt);
 
+	mt_set_non_kernel(0);
 	/* test for the same race but with mas_store_gfp() */
 	mtree_store_range(mt, 0, 5, xa_mk_value(0xA), GFP_KERNEL);
 	mtree_store_range(mt, 6, 10, NULL, GFP_KERNEL);
 
 	mas_set_range(&mas, 0, 5);
+
+	/* setup writer 2 that will trigger the race condition */
+	mt_set_private(mt);
+	mt_set_callback(writer2);
+
 	mtree_lock(mt);
 	mas_store_gfp(&mas, NULL, GFP_KERNEL);
 
@@ -36435,7 +36014,6 @@ static inline int check_vma_modification(struct maple_tree *mt)
 	__mas_set_range(&mas, 0x7ffde4ca2000, 0x7ffffffff000 - 1);
 	mas_preallocate(&mas, NULL, GFP_KERNEL);
 	mas_store_prealloc(&mas, NULL);
-	mt_dump(mt, mt_dump_hex);
 
 	mas_destroy(&mas);
 	mtree_unlock(mt);
@@ -36453,6 +36031,8 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 
 	build_full_tree(mt, 0, 2);
 
+
+	mtree_lock(mt);
 	/* erase every entry in the tree */
 	do {
 		/* set up bulk store mode */
@@ -36462,6 +36042,85 @@ static inline void check_bulk_rebalance(struct maple_tree *mt)
 	} while (mas_prev(&mas, 0) != NULL);
 
 	mas_destroy(&mas);
+	mtree_unlock(mt);
+}
+
+static unsigned long get_last_index(struct ma_state *mas)
+{
+	struct maple_node *node = mas_mn(mas);
+	enum maple_type mt = mte_node_type(mas->node);
+	unsigned long *pivots = ma_pivots(node, mt);
+	unsigned long last_index = mas_data_end(mas);
+
+	BUG_ON(last_index == 0);
+
+	return pivots[last_index - 1] + 1;
+}
+
+/*
+ * Assert that we handle spanning stores that consume the entirety of the right
+ * leaf node correctly.
+ */
+static void test_spanning_store_regression(void)
+{
+	unsigned long from = 0, to = 0;
+	DEFINE_MTREE(tree);
+	MA_STATE(mas, &tree, 0, 0);
+
+	/*
+	 * Build a 3-level tree. We require a parent node below the root node
+	 * and 2 leaf nodes under it, so we can span the entirety of the right
+	 * hand node.
+	 */
+	build_full_tree(&tree, 0, 3);
+
+	/* Descend into position at depth 2. */
+	mas_reset(&mas);
+	mas_start(&mas);
+	mas_descend(&mas);
+	mas_descend(&mas);
+
+	/*
+	 * We need to establish a tree like the below.
+	 *
+	 * Then we can try a store in [from, to] which results in a spanned
+	 * store across nodes B and C, with the maple state at the time of the
+	 * write being such that only the subtree at A and below is considered.
+	 *
+	 * Height
+	 *  0                              Root Node
+	 *                                  /      \
+	 *                    pivot = to   /        \ pivot = ULONG_MAX
+	 *                                /          \
+	 *   1                       A [-----]       ...
+	 *                              /   \
+	 *                pivot = from /     \ pivot = to
+	 *                            /       \
+	 *   2 (LEAVES)          B [-----]  [-----] C
+	 *                                       ^--- Last pivot to.
+	 */
+	while (true) {
+		unsigned long tmp = get_last_index(&mas);
+
+		if (mas_next_sibling(&mas)) {
+			from = tmp;
+			to = mas.max;
+		} else {
+			break;
+		}
+	}
+
+	BUG_ON(from == 0 && to == 0);
+
+	/* Perform the store. */
+	mas_set_range(&mas, from, to);
+	mas_store_gfp(&mas, xa_mk_value(0xdead), GFP_KERNEL);
+
+	/* If the regression occurs, the validation will fail. */
+	mt_validate(&tree);
+
+	/* Cleanup. */
+	__mt_destroy(&tree);
 }
 
 void farmer_tests(void)
@@ -36525,6 +36184,7 @@ void farmer_tests(void)
 	check_collapsing_rebalance(&tree);
 	mtree_destroy(&tree);
 
+
 	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 	check_null_expand(&tree);
 	mtree_destroy(&tree);
@@ -36538,10 +36198,6 @@ void farmer_tests(void)
 	check_erase_testset(&tree);
 	mtree_destroy(&tree);
 
-	mt_init_flags(&tree, 0);
-	check_new_node(&tree);
-	mtree_destroy(&tree);
-
 	if (!MAPLE_32BIT) {
 		mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
 		check_rcu_simulated(&tree);
@@ -36563,95 +36219,13 @@ void farmer_tests(void)
 
 	/* No memory handling */
 	check_nomem(&tree);
-}
-
-static unsigned long get_last_index(struct ma_state *mas)
-{
-	struct maple_node *node = mas_mn(mas);
-	enum maple_type mt = mte_node_type(mas->node);
-	unsigned long *pivots = ma_pivots(node, mt);
-	unsigned long last_index = mas_data_end(mas);
-
-	BUG_ON(last_index == 0);
 
-	return pivots[last_index - 1] + 1;
-}
-
-/*
- * Assert that we handle spanning stores that consume the entirety of the right
- * leaf node correctly.
- */
-static void test_spanning_store_regression(void)
-{
-	unsigned long from = 0, to = 0;
-	DEFINE_MTREE(tree);
-	MA_STATE(mas, &tree, 0, 0);
-
-	/*
-	 * Build a 3-level tree. We require a parent node below the root node
-	 * and 2 leaf nodes under it, so we can span the entirety of the right
-	 * hand node.
-	 */
-	build_full_tree(&tree, 0, 3);
-
-	/* Descend into position at depth 2. */
-	mas_reset(&mas);
-	mas_start(&mas);
-	mas_descend(&mas);
-	mas_descend(&mas);
-
-	/*
-	 * We need to establish a tree like the below.
-	 *
-	 * Then we can try a store in [from, to] which results in a spanned
-	 * store across nodes B and C, with the maple state at the time of the
-	 * write being such that only the subtree at A and below is considered.
-	 *
-	 * Height
-	 *  0                              Root Node
-	 *                                  /      \
-	 *                    pivot = to   /        \ pivot = ULONG_MAX
-	 *                                /          \
-	 *   1                       A [-----]       ...
-	 *                              /   \
-	 *                pivot = from /     \ pivot = to
-	 *                            /       \
-	 *   2 (LEAVES)          B [-----]  [-----] C
-	 *                                       ^--- Last pivot to.
-	 */
-	while (true) {
-		unsigned long tmp = get_last_index(&mas);
-
-		if (mas_next_sibling(&mas)) {
-			from = tmp;
-			to = mas.max;
-		} else {
-			break;
-		}
-	}
-
-	BUG_ON(from == 0 && to == 0);
-
-	/* Perform the store. */
-	mas_set_range(&mas, from, to);
-	mas_store_gfp(&mas, xa_mk_value(0xdead), GFP_KERNEL);
-
-	/* If the regression occurs, the validation will fail. */
-	mt_validate(&tree);
-
-	/* Cleanup. */
-	__mt_destroy(&tree);
-}
-
-static void regression_tests(void)
-{
 	test_spanning_store_regression();
 }
 
 void maple_tree_tests(void)
 {
 #if !defined(BENCH)
-	regression_tests();
 	farmer_tests();
 #endif
 	maple_tree_seed();
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index e0255f53159bd3a1325d49192283dd6790a5e3b8..6a15665fc8315168c718e6810c7deaeed13a3a6a 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -82,7 +82,8 @@ void *kmem_cache_alloc_lru(struct kmem_cache *cachep, struct list_lru *lru,
 
 	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
 		if (!cachep->non_kernel) {
-			cachep->exec_callback = true;
+			if (cachep->callback)
+				cachep->exec_callback = true;
 			return NULL;
 		}
 
@@ -236,6 +237,8 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 		for (i = 0; i < size; i++)
 			__kmem_cache_free_locked(cachep, p[i]);
 		pthread_mutex_unlock(&cachep->lock);
+		if (cachep->callback)
+			cachep->exec_callback = true;
 		return 0;
 	}
 
@@ -288,9 +291,8 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		capacity = s->sheaf_capacity;
 
 	sheaf = malloc(sizeof(*sheaf) + sizeof(void *) * s->sheaf_capacity * capacity);
-	if (!sheaf) {
+	if (!sheaf)
 		return NULL;
-	}
 
 	memset(sheaf, 0, size);
 	sheaf->cache = s;

-- 
2.50.1


