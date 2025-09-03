Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10163CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D359900002; Wed,  3 Sep 2025 09:01:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584418E0022; Wed,  3 Sep 2025 09:01:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47573900002; Wed,  3 Sep 2025 09:01:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 305D98E0022
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDE2B1A064D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:47 +0000 (UTC)
X-FDA: 83847951054.25.61B721A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D77F140019
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LOjoGn2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tlcfQmu9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LOjoGn2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tlcfQmu9;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=j5THVYLRoRPBt8VCOyIy4w9W+q6o+BwKH1PkEXBF+80kEl8ZLJZIMNp738F8jwezoexdxy
	NSfSo30YDSaHwdYDg8cY6wg+Ia//CfikBExsiSUv9O5ZZSaEjKd2DIU1hqZhpPJubScqKb
	2wPPKTafEIa9sjAkrSiMVEarRM3z3zI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LOjoGn2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tlcfQmu9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LOjoGn2N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tlcfQmu9;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904505; a=rsa-sha256;
	cv=none;
	b=6XCQJ3/2+6Tvp/6Pdc8ZuFMgl5ODjJVwdUdYQoFjBBoSgzsJDIQ7OzRwgNR5J+44I0At+L
	kriv7JBS20mduWQGxdiyalu+/iuoXOsWlZbPPX6QIi+jqEwCUk4Q+18ZrEbz5am2EJWlWN
	wJpACiI58KKwgFBRgRcxYbqY6ZaqSeg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8BE81F74C;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=LOjoGn2NpQu0Skj44il6BTjGJzIstckK0pVvMsVotT3/OhaZGyHYwxQD8uT70gohtQNyAo
	XbSbSqC2twvWHgV9hJ7n8Ibm3dpue2uZrvecX09kBgtU//+j0BWZEBf1HLGz9m0mnzx6Nl
	1OoK9JUReCORUdrabgNQtp8gqouT0P8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=tlcfQmu9oBUZKp9gtiDFF3bLmdLERdTGZkoGbluYQxKKJck+WvjQZvVK/VOdD92MAqsmTv
	Bhj3OwnoUG4h0LAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=LOjoGn2NpQu0Skj44il6BTjGJzIstckK0pVvMsVotT3/OhaZGyHYwxQD8uT70gohtQNyAo
	XbSbSqC2twvWHgV9hJ7n8Ibm3dpue2uZrvecX09kBgtU//+j0BWZEBf1HLGz9m0mnzx6Nl
	1OoK9JUReCORUdrabgNQtp8gqouT0P8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=tlcfQmu9oBUZKp9gtiDFF3bLmdLERdTGZkoGbluYQxKKJck+WvjQZvVK/VOdD92MAqsmTv
	Bhj3OwnoUG4h0LAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C9D313A94;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0N8iHto7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:59 +0200
Subject: [PATCH v7 17/21] maple_tree: Replace mt_free_one() with kfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-17-71c114cdefef@suse.cz>
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
X-Stat-Signature: hqb3xkk338kihg84kt7yf5whmw88jugp
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D77F140019
X-Rspamd-Server: rspam01
X-HE-Tag: 1756904505-6590
X-HE-Meta: U2FsdGVkX19NoH31RiXyMcxOHODtCpdjoLzZOHYmacWXfMZ9kwdZ7dShxGAJ47+ot1OmSO4E4XInFf1+YPUp8LP+hhu0HB/Wq1vHwvTbpD4T6hJo1ZlPfNun4c7TI59FlOOFSeWvrJotfxfemU4umQeEN57XQiD8J+5/kQYywjZIATDsNwLOUNVAC/B4IYYkkwgvY30TIwHCIhoQwId9BsC8o0PwvS5Jzpyei1Rl6T45D4smn2iYEMDoRhqHRaQDDwcnMJM9uYfeD9KavA9fdqo9SgNnWVdhdVr9iiNl5J4CaVDXsZMcQjMAELyctwGW/pWvz9686ao+vqED8vjn1vABV8Zw1XW78eRq7WACqonr+42eU/6+qlyccsTVhJh7v6FuSkQg7MQQ4UuJjzWwttsWZgAu3JGep5u3g9YrNfZbgeW6XPDoVxH8VLy+d+YvIdU59mM+dlt5LXMbyDAWfRxKn9axqupVo/tLMOcRRJ4csIBmXTfKTfvjwNSLFGe4cBIHyQ025e4UzEHCqClVgABK2wdsT7nvlp/oZDpvdM4WSWR9H6IehQaWdhzMQV78Lm3LL/97Ch/Rh9UYKH4tlcFYZdAJhEVRIugWrN2HGWL+8Jn/Ne/ND22bwc9LyK1UK7kZz1/YsV4SA0J+eOVyjvfKFGLR+mFVm8w8ijrGxU5qvGa376VB5O8UgGySnoh9JYa35eTLhd9qpHKrwk75/uif9Rf+dTK7DuK52c6tASVXPs5SkKkFFFr5n6pE6RzWZNl+Q26q1hbkZl32ha2YqkdBXibtH/wzA6KIPe6PqxaUGuR/mC0HLFxNkrzcWm0KG944W/g/G3MXw5Yq1VqtjBRnhIOpDQdk1kDjohU/uBVevWXjZApP5lEIRJQb2zGka6GR6x8qHwwfvPNUWY3erUIsAsxiiuM0/eq46nsrZILP4PcRmqSVeCmDnFEcAumINayPkcnkN85/vWXTnt6
 +xKTVksH
 Fv83iWZeAr52NdpEro0pQV6FRW3iJcnaFfjzk7XQRoN/audsZn4tk187cAkKCFJUrTVtspeQLehvZtCD7kxTZoBNi8EhLgngdScA3EUlgXOPuqEsP6fyw1S0GSlkRlv9f3HHmS3oBaGdVJwbXC6QgvhKjmtg52pPO4fNeynUs4dyG7Sq3qT5/5quR/AwV2xnlibQ4oxgusgvhKx+nE7urf1UcEQY7Qhx6VsheEknZ7NDZKbq3Edfif8eEhNqvBR5JXBYD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

kfree() is a little shorter and works with kmem_cache_alloc'd pointers
too. Also lets us remove one more helper.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d77e82362f03905040ac61630f92fe9af1e59f98..b361b484cfcaacd99472dd4c2b8de9260b307425 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -181,11 +181,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
-static inline void mt_free_one(struct maple_node *node)
-{
-	kmem_cache_free(maple_node_cache, node);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -5274,7 +5269,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_one(node);
+	kfree(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5358,7 +5353,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_one(node);
+		kfree(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
@@ -5585,7 +5580,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		mt_free_one(ma_mnode_ptr(node));
+		kfree(ma_mnode_ptr(node));
 		total--;
 	}
 
@@ -6635,7 +6630,7 @@ static void mas_dup_free(struct ma_state *mas)
 	}
 
 	node = mte_to_node(mas->node);
-	mt_free_one(node);
+	kfree(node);
 }
 
 /*

-- 
2.51.0


