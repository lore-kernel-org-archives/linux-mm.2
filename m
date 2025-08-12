Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030F7C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 16:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A2018E00B0; Tue, 12 Aug 2025 12:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552CA8E0168; Tue, 12 Aug 2025 12:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441A28E00B0; Tue, 12 Aug 2025 12:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD5D8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:21:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4D931403B1
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:36 +0000 (UTC)
X-FDA: 83768620992.09.D2A9CA3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 815BDA0019
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 16:21:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q14A6BCi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9yK/YkiX";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q14A6BCi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9yK/YkiX";
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755015694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ned1pgNlWGdntOMM16NdhHs5e042zHyl9sNCiue17Po=;
	b=gZjPypsbMhP3yqlioONujMMzgT+kwI9erxm8+WCLLPmE8vFWNINsLoSJvOb6yCQM0Zwkez
	a4GgniuHIFV9PiSQEm19PCNE5PKhjeUT1Pfjug24gT9/gK56bLo4IMb3lyxnHr78Fbts7R
	c+8Vcrg+2wFrL8UXCOzzUZWi0Fwxt2Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q14A6BCi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9yK/YkiX";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=q14A6BCi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="9yK/YkiX";
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755015694; a=rsa-sha256;
	cv=none;
	b=2BcLrmivsNYQjw6WqKMCh0Gf18EGd55BLbvhXUxWnEP5DW03Fnr1Ftqia5mKRXk9iLryNy
	WqmhbPqbgfPauTaEuUhNUvb7hKSiW/lK4znsXw7iNF6DD0ExKxGiBcUlFukqj+Kz0vg754
	Urp0/qjKy8QLa73npXNKXFRXGDHqPtM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1EA8521B15;
	Tue, 12 Aug 2025 16:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ned1pgNlWGdntOMM16NdhHs5e042zHyl9sNCiue17Po=;
	b=q14A6BCiNLhsD4V0qTIk8cM2gzbsVRQGDBTz3KA9uRqFHhdVUetyyzqpNAtTncccSK0NrA
	pjH3QE4HDTinQdwkO8D11p4jIwpFZn6YHCAnHGHENEESVftcgX0KXahbqi+O+yWC5l1kMs
	Xf655AfZkdk2dIst/agawZWN/GDVRZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015693;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ned1pgNlWGdntOMM16NdhHs5e042zHyl9sNCiue17Po=;
	b=9yK/YkiXr+f4tKbvTRp2rVAekN5hQ3AKy2YzjivhZlqNry3ogzgVdoWiDIyGCRlG8Tt6au
	LYXxd6EMw6mog6Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1755015693; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ned1pgNlWGdntOMM16NdhHs5e042zHyl9sNCiue17Po=;
	b=q14A6BCiNLhsD4V0qTIk8cM2gzbsVRQGDBTz3KA9uRqFHhdVUetyyzqpNAtTncccSK0NrA
	pjH3QE4HDTinQdwkO8D11p4jIwpFZn6YHCAnHGHENEESVftcgX0KXahbqi+O+yWC5l1kMs
	Xf655AfZkdk2dIst/agawZWN/GDVRZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1755015693;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ned1pgNlWGdntOMM16NdhHs5e042zHyl9sNCiue17Po=;
	b=9yK/YkiXr+f4tKbvTRp2rVAekN5hQ3AKy2YzjivhZlqNry3ogzgVdoWiDIyGCRlG8Tt6au
	LYXxd6EMw6mog6Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 871871351A;
	Tue, 12 Aug 2025 16:21:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2FPKHQxqm2iCbgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 12 Aug 2025 16:21:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>
Cc: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 2/3] maple_tree: Use kfree_rcu in ma_free_rcu
Date: Tue, 12 Aug 2025 17:21:23 +0100
Message-ID: <20250812162124.59417-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812162124.59417-1-pfalcato@suse.de>
References: <20250812162124.59417-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 815BDA0019
X-Stat-Signature: 3tndksrb3k4i5fp57s6muid9gnxkjetw
X-Rspam-User: 
X-HE-Tag: 1755015694-819562
X-HE-Meta: U2FsdGVkX19vpnkzYoQgkP6BdhIfJZy9D0/tZGgi4t5BaQM49r8KxdDcPYhIYUSKqdoRFOVPuRYu4Kkyu4pXnNRX7xgntTludDoRyekAVVekpcifVsz/QSc6A0Fr7bOcmMhqJ37sZ0+LEaP/1H082GlnBpcUTBMa1nbZwKrlU6g8yz0yfGA6hKS33DABkOsRcO7WwIsP57A0olG3lwni7SFNpZE8QFkHu/Ez7JWmWfNxqzujqfhs7vRoLz+mHkY3sqdGyWu5FG7Jv0UcIHd07JtoStKIEtVpIlXq/qcMizccA2UIJiQErkkEc/14vErZTbV1bkU9OosQadbuQ2TStMGPJ03wD6kP7b2fZ7J+NiRiVRReS7oWAxz3A7wne6HVp4Ptld7F7brc0M9/aW3ox80mlcdKMu12D/ZOSAmLd4iUIKx7gbO+urA4Tcbpyal/t1GQp9mfGljMG9zyYo8x6dswrKC+qm8jYwJ/iVc1HZr+bEuVjbu5EiXmPqLfC0k7vONqshFiYjuq9EV42IvFiDUQ3FhdcZAERasV0k7YOGIkkiEW6pbIWVFkDBnvBQC///OXighowKHgn4BytoOOkPtUhm/As28DFtotT9U/BTdudnkjmQL9Xdu/IHRjHC6cK9uN//QMHr7q1IV+5LavCJBxN6L4Yv0O68q5iT2T/XIUG6TQk96jUlLueM4A+ptkA4+tg0w0F1ApB10vYhRWCFhrrKZOyZJTL1OaSuKVqQOBFgDIlEQakzWWI0MYi5s/Nqrg6oxgocYH67NajOLysNLSHNYNN/KCh5Ztce8eynvQxoewDjNU/rkNgPUrN4xtnRNWFTAwWLIk9N69EbZMTAFdC9unjpTZn7NUP8rtcfVmfO41RQ1Ngpwe7HNZ+IGyGHB9xcyE5TyMMvrh8/cT7VTkmiQQzY0gYG5jYrDvva6W5BloELNkgY/3xMznrNmxROrhr4eAATaqDAWkcTr
 rkzy+gta
 g2SWL2vEwdStCCHiUCDimzmhZmVEo6aHnkM+W63TvG4XpT3zxD8JvOsrkc4CH3aIL3mehizVHQt0BI23tAuq+w1rsHDekC5Q3BjdlpWkjWb1BQrSYwLFMyzL6dpXs1ZiS8jwG+iw+edJrti9S470wifxUKUzNy4YVKVB88bobJ2XkJ2EIRTnI0XZFV+tUtVP0j9SY8UGBehwzzrNokonbf3LY6Hqnja7/hNBMJsneiZhJMp+6QBJBhMxc//P8bafWmH2DB5jv+RjwciKCEnLOerWjQhfc2rhVHZm6RbOO+vUbO9D7nYmqnL0Olg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kfree_rcu is an optimized version of call_rcu + kfree. It used to not be
possible to call it on non-kmalloc objects, but this restriction was
lifted ever since SLOB was dropped from the kernel, and since commit
6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()").

Thus, replace call_rcu + mt_free_rcu with kfree_rcu.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 lib/maple_tree.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a9..91da2d9d00c3 100644
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
2.50.1


