Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85ECCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4734C8E0024; Wed,  3 Sep 2025 09:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4236C8E0022; Wed,  3 Sep 2025 09:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBE08E0024; Wed,  3 Sep 2025 09:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14E128E0022
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE3071DE9DF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:37 +0000 (UTC)
X-FDA: 83847950634.09.D62312E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 53E1B40011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pbjD0DBD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spr1fns8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fpMwkQEp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+0CfIevh;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904495; a=rsa-sha256;
	cv=none;
	b=Q4I18+ftKTPSf9w6U4SDTdrwRqdE9qgTD2u/bLUWnNtA01HgUG6WN9CAobpHfwgash0U1z
	k1XhtH/Ahy1e2Gu3rFjyU13J2LoL2+PrFx6UutoNCgg6MrDiFvpNJV06wVFMQhMjgiVEUE
	HStzGSaPoncBYZQih8X3BX71UC9771M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pbjD0DBD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spr1fns8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fpMwkQEp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+0CfIevh;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCcVGdp/KhsEZz39yl99PFemz0v+mJhBuOia0com5iU=;
	b=JqrVf0D2xHJefc7D65A/aFI7f/PchJYz/yoasiKNp+MKO7YkY+l9DNYo5hUOfw+5cqBmGp
	uh3T634hO3hekQYUG3iQRNGRUu5aKvuOVtTf3fsSY60bWjht4/REIa36FG/SmgkxkOQYzy
	ShD8lCeCZxImCGbQ+i27JuT6gxvJk0I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E7EF82122F;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yCcVGdp/KhsEZz39yl99PFemz0v+mJhBuOia0com5iU=;
	b=pbjD0DBDSP+X6y6paUUVdqmkZ5a/x6h4+HkbWuCEvuceCXV17FMqnuw+CrqYdLT8DlYZ7t
	pnRA1I/yBLqIe10G0C04ZxjSjyz9BLznFqlDeaL02MXVqGg/Uhbd5l7pXKwnO5I+3tb52W
	GBFgkB1ao0vNkTmb37ghR8xFB+u+mu4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yCcVGdp/KhsEZz39yl99PFemz0v+mJhBuOia0com5iU=;
	b=spr1fns8XDkY6mtDcaGBF4O2DIJ7W1U6L9nblQc757wCrYgwqQbDNWjIUCPKLAmf17YCK3
	e0fLSj/jKFuRftDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yCcVGdp/KhsEZz39yl99PFemz0v+mJhBuOia0com5iU=;
	b=fpMwkQEp4Fd1CSGGBS/ziHHoTHOVVj3/g3fvb0Mo8AkwPXq3cDTAUwhJKDkOZS6a4FJI3s
	y7hlEpOb4JGbB2rkpRHMbgYeuTpKY4bRn+VLlfigoj0132hVOhhectjhD/dIsoBXu8hxUB
	4M+VF9DJHWETBNTFrRJZO98NUsdkphc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yCcVGdp/KhsEZz39yl99PFemz0v+mJhBuOia0com5iU=;
	b=+0CfIevh4Oh3ByHQ4p+SULAyPIX5oVgNniHSh2O9xjQN5L0HW89rnkq1D8/lrWJuUUc9XY
	AyLDPdbVellDJiBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D009213ACF;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uESAMto7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 15:00:03 +0200
Subject: [PATCH v7 21/21] maple_tree: Convert forking to use the sheaf
 interface
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-21-71c114cdefef@suse.cz>
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
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 53E1B40011
X-Stat-Signature: tqudxjyrt3qhgbc4mb779xp7fawwqxme
X-HE-Tag: 1756904495-682128
X-HE-Meta: U2FsdGVkX18DyM0ko8+G/F9yxuDU3L4RuHD47fWN2QZEGM5iqZnh/OhZK5EsAEA4LAYytXICYwA+jCs1TH10yVZ3HMenHS83rdhaOu6CPXtZ7cR3RemzH4iH4kcf+SpEISmb5NJKlOW2cMNPECSGb5gh32Isj0HN2ZuYbuO+hNEUGbfaA1TpP+Q25wIqkSkHCCYQxP27DakceiVsZJdRZE6ZFCyUkq7OQN1/LBPHHe+wTFZIO9xOJE54Ud1OdVUjCNc0WpRBI6Iml+kB7bchlU942AlSc4El4qJ49llo50y+USj3nnuxRcLZRDZpJQv1PwxI8gk8o1Q0GTayQDlIS58PoK5HcODJow9R9oL6sC+avjWnw0y20uIHQLf4wq6xaAffts9m9EWzTvrF0z/pt6FAKxs64BQxbYigtXcnOEeesUF5YnEIgZP3o7fwUcZkraHFZFhoTPmX59RbMfxdR1EyRNGA7R/4AWnACNcje8OJrRqV/MRCx/v1D0lche5fCCWZhhgG+kLqd/usjOrBCICv3Whh3Icy3V+NNrixlklyEpScvEJ1PUGKAbGhoJds3/IzdT78kmSRJ5Y6xnMIqvEgX/FiwA3x865ritj8lofwLa1ilOlhJBVsHMT7wxuOOzvqDT5ryBOcWHt0M27tMuFRlTsLry1spMH1pQflG3NVfNMrRFiYudF6/3Ur4m2K8ytjNKTYbRJTAa3Y2aly7sHC8LhQP4kA7gcx0Q8VEnxxKni0w4aTW4YEH1rOIOgs+EFCvTcz1TM7oCn+5nyBYqFryvKdRRYEcjYAxZxxtsMSHYRmGIwjjKvk683uK0aZ4Dhi0/lFY0ef3erScDCkwxC4NM1kwGvre7RbDfokhMBbU/lO7rat7ombwrQIyNz14udQAoGwVNr/GRqIeqf6QXNmOfBNTHJ0GyPRb77X6teTvBn14eJbUjhALIMxauumvkGzR/Ay93gQPr6p69U
 rqyIDP4I
 6Y47E/TIMrzI2LdZzbBRT53ouaM9REQJJUIS3LsCl/1vx39YpR3vCwmeQYsfm8uppQjEVo4EDjDyY8OsgnTR4GeLIzhKJYNQjb0A5LskQdnq/xAUWyNz5uO4KhzpoF4FBAW5fOXYl3goCDaGccgRdm/LgZUCmiLzt9xOtVQSv3PPR2m1zJ7L664gsfLjVXpfVgrHvGjyUkWqTQ16MamW3mqZfY2kBwZQajvw1irNf485c1qXkb5kQWbpq3IaUzcAy1Hw6zAu4TQVAtdX9Eke4sYN32NbqNhCK8oacdtxneXzEm7IEfZ9LrhF9xPKyMCQTHIX0Q74VsicWjJR1jJEtaLKwlMo807UqXFSDRg1SbWd3sOcFA+Lvqoy/cnwgP/VXyGEH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

Use the generic interface which should result in less bulk allocations
during a forking.

A part of this is to abstract the freeing of the sheaf or maple state
allocations into its own function so mas_destroy() and the tree
duplication code can use the same functionality to return any unused
resources.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index f2b81a8d840b219819dd10104cd25120ba913ec7..c185dbc90007a0046a37f194e73e261caa1848c0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1172,6 +1172,19 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 	mas_set_err(mas, -ENOMEM);
 }
 
+static inline void mas_empty_nodes(struct ma_state *mas)
+{
+	mas->node_request = 0;
+	if (mas->sheaf) {
+		mt_return_sheaf(mas->sheaf);
+		mas->sheaf = NULL;
+	}
+
+	if (mas->alloc) {
+		kfree(mas->alloc);
+		mas->alloc = NULL;
+	}
+}
 
 /*
  * mas_free() - Free an encoded maple node
@@ -5408,15 +5421,7 @@ void mas_destroy(struct ma_state *mas)
 		mas->mas_flags &= ~MA_STATE_REBALANCE;
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
-
-	mas->node_request = 0;
-	if (mas->sheaf)
-		mt_return_sheaf(mas->sheaf);
-	mas->sheaf = NULL;
-
-	if (mas->alloc)
-		kfree(mas->alloc);
-	mas->alloc = NULL;
+	mas_empty_nodes(mas);
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6504,7 +6509,7 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	struct maple_node *node = mte_to_node(mas->node);
 	struct maple_node *new_node = mte_to_node(new_mas->node);
 	enum maple_type type;
-	unsigned char request, count, i;
+	unsigned char count, i;
 	void __rcu **slots;
 	void __rcu **new_slots;
 	unsigned long val;
@@ -6512,20 +6517,17 @@ static inline void mas_dup_alloc(struct ma_state *mas, struct ma_state *new_mas,
 	/* Allocate memory for child nodes. */
 	type = mte_node_type(mas->node);
 	new_slots = ma_slots(new_node, type);
-	request = mas_data_end(mas) + 1;
-	count = mt_alloc_bulk(gfp, request, (void **)new_slots);
-	if (unlikely(count < request)) {
-		memset(new_slots, 0, request * sizeof(void *));
-		mas_set_err(mas, -ENOMEM);
+	count = mas->node_request = mas_data_end(mas) + 1;
+	mas_alloc_nodes(mas, gfp);
+	if (unlikely(mas_is_err(mas)))
 		return;
-	}
 
-	/* Restore node type information in slots. */
 	slots = ma_slots(node, type);
 	for (i = 0; i < count; i++) {
 		val = (unsigned long)mt_slot_locked(mas->tree, slots, i);
 		val &= MAPLE_NODE_MASK;
-		((unsigned long *)new_slots)[i] |= val;
+		new_slots[i] = ma_mnode_ptr((unsigned long)mas_pop_node(mas) |
+					    val);
 	}
 }
 
@@ -6579,7 +6581,7 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 			/* Only allocate child nodes for non-leaf nodes. */
 			mas_dup_alloc(mas, new_mas, gfp);
 			if (unlikely(mas_is_err(mas)))
-				return;
+				goto empty_mas;
 		} else {
 			/*
 			 * This is the last leaf node and duplication is
@@ -6612,6 +6614,8 @@ static inline void mas_dup_build(struct ma_state *mas, struct ma_state *new_mas,
 	/* Make them the same height */
 	new_mas->tree->ma_flags = mas->tree->ma_flags;
 	rcu_assign_pointer(new_mas->tree->ma_root, root);
+empty_mas:
+	mas_empty_nodes(mas);
 }
 
 /**

-- 
2.51.0


