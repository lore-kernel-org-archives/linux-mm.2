Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74166CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1018E003D; Mon,  1 Sep 2025 07:09:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0BA8E003B; Mon,  1 Sep 2025 07:09:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69148E003D; Mon,  1 Sep 2025 07:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9468E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66BA614080B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:22 +0000 (UTC)
X-FDA: 83840410164.23.0D4E228
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 284E140016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S0BrW2dO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=80l0mWms;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S0BrW2dO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=80l0mWms;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=phLJU1hPCTfdMU1c2eRqXemUcRIXqIFA0Z1slFi3RYa8/oPoDc9eYb+IcIDCswJ2O8zSqU
	GX3hb6WCXgmxR9nE+oocBu7dLHhVtkCLK9zHLs2N8dHmU5hUx3+fMpvdxt74fggi+OeRKT
	vH+iV0z5nqu0jt4xs3O35Cy1xm+stJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724960; a=rsa-sha256;
	cv=none;
	b=z6B/aN2AmKUp2SHEULoW3fDyY+8Oyd3IjsM+p2BeK8CZZIZMh1flJLNQ4AbrMMLqrENX7H
	DHiARF+cvPA/uPCp0GL6X/e9jV/jMMN/BCA20utLyBfJJzOmN4eaJSkhm0eJWnk2Eji//i
	c1m+ROzPQQMRkiUSJ9uIWWIOATndeOg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S0BrW2dO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=80l0mWms;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S0BrW2dO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=80l0mWms;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AE99821179;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=S0BrW2dOwi0z04Wj3WboKaP8vSfpyJifHoyHj866eCywFn5ijYNZ0vaeOwjBE2J3qLBbw+
	qz+BOxH5ouaguFBsCkcr6fVR4S7ROOOXNMteW/Xvgzh1f0BMVaMgNbcTU3OuKfwceRRVT0
	69pdz8U4KZtb+qf8IHL06oF6EuwcRM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=80l0mWmsnyMbEJ1/ElIfu3/n/y/ayVlDq6CjlfcCEDHZ6PPp9HlzPKAOV1w65VxnWdihjM
	j+7OpTNfqp/viPCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=S0BrW2dOwi0z04Wj3WboKaP8vSfpyJifHoyHj866eCywFn5ijYNZ0vaeOwjBE2J3qLBbw+
	qz+BOxH5ouaguFBsCkcr6fVR4S7ROOOXNMteW/Xvgzh1f0BMVaMgNbcTU3OuKfwceRRVT0
	69pdz8U4KZtb+qf8IHL06oF6EuwcRM0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4DoczhIJm/QIxVWZ7D37eQBiOD25npSD9wVr63TFoHc=;
	b=80l0mWmsnyMbEJ1/ElIfu3/n/y/ayVlDq6CjlfcCEDHZ6PPp9HlzPKAOV1w65VxnWdihjM
	j+7OpTNfqp/viPCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 98E0413A3E;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EBALJcV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:57 +0200
Subject: [PATCH 07/12] maple_tree: Use kfree_rcu in ma_free_rcu
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-7-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 284E140016
X-Stat-Signature: 9wk1xast6n5woxjc19bfy43fikcapxrw
X-HE-Tag: 1756724959-94864
X-HE-Meta: U2FsdGVkX191Teywvq0qwJ+iVd2uUZY0C8+sz33SuGQBE6V+5NmhIQjbGQCR8SLhRFh2kVLAvS87yrMoR45JRpAF40RfzCroEO2JmkH8AAW16Diz3D7GjUBHumhTWRrTS23lCTjDQg7hhvndSUZjjjOWnZK+3G0dMnGREp4ehVHzQ6ifmjj24SZsIAytzL+7C3RsH8c4qmbdes2Q8k0zi+LKZCG3G0bZ2PIzElp9kOnrquTreXqd4sW/nq0q+/D2skU9BfOBDIctZsGBlyWTGhdV9CZkT+iRgU3oYnlFi6xK6SHy+4zHLD4rQ+CMgt8/J1kGxWTQHPY+UZWV7w4nDWef/9WSlxefOyPWQ1n3PCv39LXc3N0oQQYnG94c/EW+0PyDKSLv3yTD59xkAI7jHJDKnbANuM7ONoZEYWPIBSlI2HRCC1DAzbkJsiBDZrTBoJ/wgtH62zsWH5dh3+mXqfnj3yDv0R8fetgtPIX9SEJDTTYwjvwdNmyUpze9RmDWKhHYtv01TWCxHuSYKYtkGjPm2pgDxp/vlqH70lC9wCG3DR4VX4TaxYSQTKKPkftYaNVrXKHZrJcYCipEH9UEPo887mJwoPsGW/d2MTlAGOPY1UrdgYplZW5xtKSi5lT+fPR5H+l/cLDlx2TU0apF+PbMnDo/omPcQ4e0fq/r3dje7TpSnGzFGM0/d8FXEVF/E6bmplkdb40KV3LRdfPyt/PDlNsrfjTwB/3iMphfu2/rBkETvOCKjS00wTlUVeUAP2WGLeBQP9dbORM3XwdhUhR2G5UXy+rl7aBpzorW5U3uviI3p9k5s7mEhK0LmnIkaGP1/a1XBB9Ds+jlDEpCB8tqs3Xirl5eOmU7/AR1rCJ/MA4DNw/XxXRgK2LY4J9f+d3gvd+jBs5U7BUWMyrCujTTOd4yIlupNirldIj8JhfsgxLCSz4588MRM4knNcspqIP/iQGFBtJf7cVPOJa
 DHblPwez
 v450POjnLfRmd28bVjg0ZTGnu8Pb24M58FxGeLm4q/UhDuMlYNFtM+J6o7W0hnk/aInHE6BlGf4bIjInULl9oy4+pfIyUDj4qKuyfMsKvN6xnDv+3Pl8FY1ZsD7LpDsx8vfL07vv5JF0i7eIBEoWF84prJrt+rvB0tk+OHVTLNM13zW41H2VuhVO4t3qeeeYZYak9LgY2kckdMwVpUqPXD4WKZQeDKBw8qm/ucAwWmkdksM10Bv61O8l1Sg8ELSVhw4bM
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


