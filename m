Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57BFFCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A888E0021; Wed,  3 Sep 2025 09:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2628E001A; Wed,  3 Sep 2025 09:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18AD8E0021; Wed,  3 Sep 2025 09:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 692EB8E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11354862C8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:20 +0000 (UTC)
X-FDA: 83847949920.09.F1170E7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id AF5CFC0017
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6+RAcBv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dfhViHJX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6+RAcBv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dfhViHJX;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904478; a=rsa-sha256;
	cv=none;
	b=3Du83cpt2hLq94irudXCub3ZQenuK2Byxml0AW+eTJGSSWmGhsNQ+A+r3i7Q/KFa4pzLFO
	PPjII/hxKkY2sXQ5AQXXrSujaedKiicPAHEXxcP7ge5Pw+2jBAq0zJ1dn9w7K5r5C6fTJs
	aWMZKkL+4OiP5BUrk3zF7PigDAz0CIs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6+RAcBv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dfhViHJX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y6+RAcBv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dfhViHJX;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrB03Yj54aC/gQ5+QvFtF4NcYsIp0gKGVOi118eDKlc=;
	b=fVNYeJfp7vISzbMaheVYJFg+vjUfSaeSCazlU4gz6IxIb3JHBSQ8SBiArG9JGGQHW11LI1
	n17faCUG3AWKz9TPPO2BCL0IrDLGM5MXFvI5rxFo6Y00aBIqn6V7q8gW+OYtLzXKnXpv/H
	946tJy3qUXL70n+4YglZZCWf14MN4/M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D87091F74A;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrB03Yj54aC/gQ5+QvFtF4NcYsIp0gKGVOi118eDKlc=;
	b=y6+RAcBveqgVH58KSQ/NMm/qDNxXyyc8ByT/YIBJStlUT3859sylN36mLujFWsuT6VwnqO
	1j+mIT1saneq/MLIH8wDiHJsxS3DodN27LY2/VNa9vRgmSyODWnN3A7nwI3ApiYk+iuXR7
	l7WvpVhznrxDvNWVLskJlc1ZHTg31iE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrB03Yj54aC/gQ5+QvFtF4NcYsIp0gKGVOi118eDKlc=;
	b=dfhViHJXsE8d4aJj5bRKt9+6Uq1SXGO8ZDilqubh83FqCht6xzqfFrQcrkIUxIY5PKtqjD
	updr/HW3IynRyBBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrB03Yj54aC/gQ5+QvFtF4NcYsIp0gKGVOi118eDKlc=;
	b=y6+RAcBveqgVH58KSQ/NMm/qDNxXyyc8ByT/YIBJStlUT3859sylN36mLujFWsuT6VwnqO
	1j+mIT1saneq/MLIH8wDiHJsxS3DodN27LY2/VNa9vRgmSyODWnN3A7nwI3ApiYk+iuXR7
	l7WvpVhznrxDvNWVLskJlc1ZHTg31iE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrB03Yj54aC/gQ5+QvFtF4NcYsIp0gKGVOi118eDKlc=;
	b=dfhViHJXsE8d4aJj5bRKt9+6Uq1SXGO8ZDilqubh83FqCht6xzqfFrQcrkIUxIY5PKtqjD
	updr/HW3IynRyBBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB78213B0A;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eOt9Ldo7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 15:00:02 +0200
Subject: [PATCH v7 20/21] maple_tree: Add single node allocation support to
 maple state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-20-71c114cdefef@suse.cz>
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
X-Rspamd-Queue-Id: AF5CFC0017
X-Stat-Signature: ybchpfpm94ydakoszsdiu5rz3c84p3td
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756904477-428550
X-HE-Meta: U2FsdGVkX1/U8OJPZ91/G6Nrp9uBQ62WE6Ypl5cVQ+zIDmjL94yp2Jf74kSQponkZqFvsr6/txjEHGUX+32OpGhoX3tC6pBbJuKDHAtChA+QiLic326Zbu9oGzzwgKUTe2d9Y9AfinGQgFwvadfFUnG7COi8i7aR30JHmUSgwecW6qeFAulEOuDKfgO/TB3EKvmV8OsGIFxp2GbqeoVKc3CZgz1kg+jmSwHs985ZR++UUBeFBOz8rK7iGe9Rql2PGmOt7AsKw3ZuWCTwM/1IfNccwhCR4hr1ukkENmBgcNTlxjYuTP1PMDKi0kO3I0gc7uG01ctrRewla98+c1VUrx3b9qKpmCxf0qddSjJwekbx1RvXxN+Lk7t/wWne/E3glREWzDX2t+Zz3B/nQsDv3hUCoiSczE+7DfG+d79/3RnwrGhVP6KAtJZVZ6IoOU4jV5LvQXC2HAqHqfC27ahbOqk7EcIFoFzmblivAD4rVJ1B9ww6ToRePl65xHD+udwbiT1c7NFS9bpL8udgxgCmyH5u17yH0Ykr9ScO4XvJo0rcU0YgGBUvDGay9ol0v2bxSpNPkL18p0J8nX1Kh6TvcTZCXhEBdkAFaQOAZpd2VL/h3Uq1Z+hOC8hOlLCiCX2uVKXjcZzegJup1GQwpw1bdZOJ3A/KXEJUY9Npymr30Jjg9YdvSM8nxhHruvs9DnlznlYkkHP6npg6nXEbqpCWDwTo+81c6ac7eW3IVgyvNR9yvQy9RAU3dzp+8w7eiMmgqQMIJpkZNwg0zTfWUZQQAGFzGhKK2G5aOWunwTdNXPD57vygsxaG4/GK1oZZEK4jN2gYMrxxZm5MQE7/TQqLC2h91u0DPNs5xGbZZyUg4KQTCkv2lvKkdRokpMw6yYDG6+frC6FWIiMjgkMOu7BrnZfF9II+NQVLZqIJtaRQXkJcaV2RQUO6WUKoXCV/Uq2K6ZXI+Z/5s0D1E/cmP5q
 H8R6BJ+E
 xWFofor5HwzOgVJ6OweEDcQAomVn50vlOTYzRPfLPmMd0t0EpnNwk3OeRHq6j1o7YzKFJadcRJUCGMW4GKrnzEYPSBA6EECyyHJeLXU0VApPaobzrQGSXJ1f16NATewn2GB9LGzxvyU8msZiZmPqTX+pXVhNmlG1SNYsfWnYuw3jjshJ/xqc/as2kU9K+OkQQwY2FzxvnsGBmkvE2DNJ8dNG7rB4vPVKOkXvkZiSB4d+MTigwUoh9cPUlapHv+p5ybcQCPodxybWzHRj7NvZffghTvBBoHm4bFylZbCfZC2stavTY5jasBNmBOS07l/0PEdsI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The fast path through a write will require replacing a single node in
the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
special case the node store operation by just allocating one node in the
maple state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/maple_tree.h       |  4 +++-
 lib/maple_tree.c                 | 47 +++++++++++++++++++++++++++++++++++-----
 tools/testing/radix-tree/maple.c |  9 ++++++--
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 166fd67e00d882b1e6de1f80c1b590bba7497cd3..562a1e9e5132b5b1fa8f8402a7cadd8abb65e323 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -443,6 +443,7 @@ struct ma_state {
 	unsigned long min;		/* The minimum index of this node - implied pivot min */
 	unsigned long max;		/* The maximum index of this node - implied pivot max */
 	struct slab_sheaf *sheaf;	/* Allocated nodes for this operation */
+	struct maple_node *alloc;	/* allocated nodes */
 	unsigned long node_request;
 	enum maple_status status;	/* The status of the state (active, start, none, etc) */
 	unsigned char depth;		/* depth of tree descent during write */
@@ -491,8 +492,9 @@ struct ma_wr_state {
 		.status = ma_start,					\
 		.min = 0,						\
 		.max = ULONG_MAX,					\
-		.node_request= 0,					\
 		.sheaf = NULL,						\
+		.alloc = NULL,						\
+		.node_request= 0,					\
 		.mas_flags = 0,						\
 		.store_type = wr_invalid,				\
 	}
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 3f14bfa7fe1c20aac3e127f0defd268c3dbca6aa..f2b81a8d840b219819dd10104cd25120ba913ec7 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1095,16 +1095,23 @@ static int mas_ascend(struct ma_state *mas)
  *
  * Return: A pointer to a maple node.
  */
-static inline struct maple_node *mas_pop_node(struct ma_state *mas)
+static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
 {
 	struct maple_node *ret;
 
+	if (mas->alloc) {
+		ret = mas->alloc;
+		mas->alloc = NULL;
+		goto out;
+	}
+
 	if (WARN_ON_ONCE(!mas->sheaf))
 		return NULL;
 
 	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
-	memset(ret, 0, sizeof(*ret));
 
+out:
+	memset(ret, 0, sizeof(*ret));
 	return ret;
 }
 
@@ -1115,9 +1122,34 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
  */
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
-	if (unlikely(mas->sheaf)) {
-		unsigned long refill = mas->node_request;
+	if (!mas->node_request)
+		return;
+
+	if (mas->node_request == 1) {
+		if (mas->sheaf)
+			goto use_sheaf;
+
+		if (mas->alloc)
+			return;
 
+		mas->alloc = mt_alloc_one(gfp);
+		if (!mas->alloc)
+			goto error;
+
+		mas->node_request = 0;
+		return;
+	}
+
+use_sheaf:
+	if (unlikely(mas->alloc)) {
+		kfree(mas->alloc);
+		mas->alloc = NULL;
+	}
+
+	if (mas->sheaf) {
+		unsigned long refill;
+
+		refill = mas->node_request;
 		if(kmem_cache_sheaf_size(mas->sheaf) >= refill) {
 			mas->node_request = 0;
 			return;
@@ -5380,8 +5412,11 @@ void mas_destroy(struct ma_state *mas)
 	mas->node_request = 0;
 	if (mas->sheaf)
 		mt_return_sheaf(mas->sheaf);
-
 	mas->sheaf = NULL;
+
+	if (mas->alloc)
+		kfree(mas->alloc);
+	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6079,7 +6114,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
-	if (!mas->sheaf)
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas->status = ma_start;
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index da3e03d73b52162dab6fa5c368ad7b71b9e58521..89da991e12cd97e44971757ddc105ef46c68ea4c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -35095,10 +35095,15 @@ static unsigned char get_vacant_height(struct ma_wr_state *wr_mas, void *entry)
 
 static int mas_allocated(struct ma_state *mas)
 {
+	int total = 0;
+
+	if (mas->alloc)
+		total++;
+
 	if (mas->sheaf)
-		return kmem_cache_sheaf_size(mas->sheaf);
+		total += kmem_cache_sheaf_size(mas->sheaf);
 
-	return 0;
+	return total;
 }
 /* Preallocation testing */
 static noinline void __init check_prealloc(struct maple_tree *mt)

-- 
2.51.0


