Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFB1CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AEB98E001B; Wed, 10 Sep 2025 04:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537588E001A; Wed, 10 Sep 2025 04:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFAD8E001B; Wed, 10 Sep 2025 04:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 247648E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8B801607CF
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:54 +0000 (UTC)
X-FDA: 83872596948.16.547DF81
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEB9B40016
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=io7YEaN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVOZcPyd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=io7YEaN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVOZcPyd;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7f5rvf5fiuDnTXDrW5D1lkLwPQ7P+BbSXdEN380kRB4=;
	b=lM0k3M3vYK9om+4WAA18wUt4y+0iVsIa0oXtB+qLlBuReNgTsJl0GFpRiNLmnf0PoqqWm8
	yxLGrc3wfa5GJFzhr1gVTFR3INK1Q+in7P13gT0y3zwRbBu6RBAtuK6Olt+4NOBxis7eZW
	ROAA3JovJTKxaoPuS0+/C0YXJrWeJ+s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=io7YEaN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVOZcPyd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=io7YEaN7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PVOZcPyd;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491313; a=rsa-sha256;
	cv=none;
	b=qn+CQw3GvbaM9OKA0LdyJUz9HH4+7XTrMcJ1L8EBOowngpUXBuxvYx4Kmg5QLJeuLimFCI
	Gtq25VooQmThhaz/Sq/NZ8qw4k1tz/aUzc/G4dWVd2PqvHHdJGasOW+GyEh079N41PoFWn
	RuIYIZ+aVlMd3kOmpYbXwtwSMXL0KM4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5789034C8E;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7f5rvf5fiuDnTXDrW5D1lkLwPQ7P+BbSXdEN380kRB4=;
	b=io7YEaN7JfCJ1wu/yUuk2NAxP9Ebp6nAU9lmg28Sm4KjjDMVgh799CMRWcT2yS9Lc5n3k1
	98EsPw1qk2B9hiea2Ui4sIxXyvKuS4hQBSixxqf8tuQqLa4z4InXrFV8QtBooKpQL4K0z3
	nRr+iuU0nGFBgrdULLbOWVlzeKGLI+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7f5rvf5fiuDnTXDrW5D1lkLwPQ7P+BbSXdEN380kRB4=;
	b=PVOZcPydeVLCQhR20WGg2D7fJbtC0/8gpIAw07BzvaQ+xA2G4nKfu//a/0QOOBklIm+0QA
	6WD9nVCajNnGg0Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7f5rvf5fiuDnTXDrW5D1lkLwPQ7P+BbSXdEN380kRB4=;
	b=io7YEaN7JfCJ1wu/yUuk2NAxP9Ebp6nAU9lmg28Sm4KjjDMVgh799CMRWcT2yS9Lc5n3k1
	98EsPw1qk2B9hiea2Ui4sIxXyvKuS4hQBSixxqf8tuQqLa4z4InXrFV8QtBooKpQL4K0z3
	nRr+iuU0nGFBgrdULLbOWVlzeKGLI+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7f5rvf5fiuDnTXDrW5D1lkLwPQ7P+BbSXdEN380kRB4=;
	b=PVOZcPydeVLCQhR20WGg2D7fJbtC0/8gpIAw07BzvaQ+xA2G4nKfu//a/0QOOBklIm+0QA
	6WD9nVCajNnGg0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A7B213ABD;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sMf8DUMwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:20 +0200
Subject: [PATCH v8 18/23] maple_tree: Use kfree_rcu in ma_free_rcu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-18-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
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
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AEB9B40016
X-Stat-Signature: pyc8jnxsnstkizoqykuijsrm7nto4y75
X-HE-Tag: 1757491312-130220
X-HE-Meta: U2FsdGVkX1/md0ew4plCaixkpcs1iDHODTyrgn05Vddrjkwx30aZZ3vtLQtCd2ylcIIQLlKumSz9L23rani1XureqriA+fEYrMjCRpuYYtZfkv+MppBBTd7kWOqY32QSOZa7Fgq2IynGqYTsHmsgyoTZdK5MMf4HoXSHBUj+DIlKIYS4B2GaZ3enWrTztKfi4ZasgTlVKRVfwlbVPIPMSzB850qSUr0mt6pwXxRyrbgpMqeA4AG52TwEwjVQTfXea2IC5JzlEslUKnEp5Br5+8HW+F5BtJSALqEi3SYcJeMRa4hyAlN1z6UbNINd5tFr/DabAljfcwZik/9Yv1XAs4EgR6vh2XUhdCIvmx2dh0DzYwypXCyyZ1du+VxSCq2zI4C7ty3+itkzQgkL+1HaVk12HSKsswm0zfkkYKZ7VCl7EROaql6X4G+eyDQFPbTpiiaQpl222jkGT0gIdWYYHjwr/acoTEmOXbDU2cawKRBDcuXyPH/wRwhNE/FGmvP76f8GSPxHkU2aA7i+eoOS8+rqA7WOBngCMx8u4h0QKzv4FEMBrkNP7zWgKACfs8cuqpverWOUMFIOk7U/EqVzjpVLRzmyJZnk36AMSm6i4NfyaIm08m8uhqsPXpeW+fmb/kBQFSp7z3fju2Dq145wO5ZOvF0xsI5d7/FusCw7VeN55UH895CutWRjmfxTqWb7ZhTFS9FKhNehxjDqOvmV1sYuFrCMnr0m/R+7nFshmCtIHNTBX38aHzA/b1Znlf9QtNtED4jkMIXlYw1xT9nG+4lZShzKOV7a34yIAiEYbgjzDisVqde3+o1lDfUnwS5Y9BSq+mRzW8DKRWinila6Bb8SKc253WLHrnQnPOHRPz0LXCIQSJuvWMB6Fnz4Du0fR4oWHvO1CnEqy38AIz3vLRpuselFj66pAQOI2HDdHUpqVplMjiPKdM4RypeL07BFZwlfSqVQ89oudBX/0b3
 9/z+oSSt
 LQc/YhaX9eitrXYtmMCgxphdBDwu5Hjmim59rJ2H/hskjkZk/ZJtxLqPtc9BSc4BwtIvGnPRDzLYLgMu1Eb6ej3KKU/1MoD204k+bqu5qWwqfXKCd98hlntR95hoqn11vyyY/7LVQkTAvwq2l1cCPQiVK5gcBOSXfo6txHKaMyR4azGgivBPqkXPR5VqlLcvDgiHqHvPHv5d6g/vjbRb14Yh9U3MZf/cQkwnRZR8PtZtV9KuHamt30nKfvWVEAoGExDt1
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
index d034f170ac897341b40cfd050b6aee86b6d2cf60..c706e2e48f884fd156e25be2b17eb5e154774db7 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -187,13 +187,6 @@ static inline void mt_free_bulk(size_t size, void __rcu **nodes)
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
@@ -204,7 +197,7 @@ static void mt_free_rcu(struct rcu_head *head)
 static void ma_free_rcu(struct maple_node *node)
 {
 	WARN_ON(node->parent != ma_parent_ptr(node));
-	call_rcu(&node->rcu, mt_free_rcu);
+	kfree_rcu(node, rcu);
 }
 
 static void mt_set_height(struct maple_tree *mt, unsigned char height)
@@ -5099,7 +5092,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_rcu(&node->rcu);
+	mt_free_one(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5183,7 +5176,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_rcu(&node->rcu);
+		mt_free_one(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }

-- 
2.51.0


