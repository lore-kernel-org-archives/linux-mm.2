Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53957CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1CEC8E0041; Mon,  1 Sep 2025 07:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF4738E003B; Mon,  1 Sep 2025 07:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A8F8E0041; Mon,  1 Sep 2025 07:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 903C18E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55422C0799
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:41 +0000 (UTC)
X-FDA: 83840410962.20.E0032DB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22D7440005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBn0jzYN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L0+y4jgm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBn0jzYN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L0+y4jgm;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Yl47dy68ehTR4F5YItfKWugcgsVIsFegWRdmZS6Qxw=;
	b=rOk73mmddvG+QXI5HVD+rAdeGnaNLzk2pa1UApc2QvrkgMOd5IrtgRVhvrqCWgR0Ol1cV3
	TDgz3blHs20uNrLPVC5DY4XC2mh/IOEq/un9EpGkovxE45J4iqJ+SV/kPTaJAst+I8pov+
	+Er/630e7UwqTIJBScNwrUa/X2KrGfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724979; a=rsa-sha256;
	cv=none;
	b=UDT+8kqo1qbn2T3Ry3prs1zWaJ6fuPinV8EZJ3mC/XvOOJupYA67BmfNzO1csCHb/gYsYG
	PppCsX77WDH+sWaP9J7dvOuBSkf4nbYm9tuQ8YiZsbOFJj75Pl+mmvxJ0MAHYmGi/5lc4s
	/zdFQXK++XpQPl3ylfVLpHFxzUSQe/0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBn0jzYN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L0+y4jgm;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xBn0jzYN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=L0+y4jgm;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 102C82117D;
	Mon,  1 Sep 2025 11:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Yl47dy68ehTR4F5YItfKWugcgsVIsFegWRdmZS6Qxw=;
	b=xBn0jzYNn+cWvKcxEb5yLy9T7DeTegxMy0R03jKU+MfoNbZl71MKg1m7TEDKA/fyS2+ewb
	3qw9mwf1avZJU/Uwf7afiMvcrYAk7K8TUbDaJMkrzWNZZj0Sg9vqZUFanYxMcn11qU4ItF
	lBmQIO/JaIJnTz3KV59IzOgusHOcvgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Yl47dy68ehTR4F5YItfKWugcgsVIsFegWRdmZS6Qxw=;
	b=L0+y4jgmKzcw6eFw93KihWmpq/qgGb6cdLN5yAiFn9CpX0iwJ97Bqa0iZ1w621WqRu86qA
	sXOYCLl6NGb93dCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724934; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Yl47dy68ehTR4F5YItfKWugcgsVIsFegWRdmZS6Qxw=;
	b=xBn0jzYNn+cWvKcxEb5yLy9T7DeTegxMy0R03jKU+MfoNbZl71MKg1m7TEDKA/fyS2+ewb
	3qw9mwf1avZJU/Uwf7afiMvcrYAk7K8TUbDaJMkrzWNZZj0Sg9vqZUFanYxMcn11qU4ItF
	lBmQIO/JaIJnTz3KV59IzOgusHOcvgM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724934;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Yl47dy68ehTR4F5YItfKWugcgsVIsFegWRdmZS6Qxw=;
	b=L0+y4jgmKzcw6eFw93KihWmpq/qgGb6cdLN5yAiFn9CpX0iwJ97Bqa0iZ1w621WqRu86qA
	sXOYCLl6NGb93dCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED9E613A3E;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AM+6OcV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:09:01 +0200
Subject: [PATCH 11/12] maple_tree: Add single node allocation support to
 maple state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-11-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22D7440005
X-Stat-Signature: 7b6yu6p3tz6u3bgjfa8hrd1z6fzx1b76
X-HE-Tag: 1756724978-193445
X-HE-Meta: U2FsdGVkX1/hqVXZHK4hx25D+zFLBoGpJnCcR3bZxUnC88FzEaowHKP/QC/mbcnQMe2Mx7ce+Ux+e9aOCufWqv/OAYesjqA36UNV6aNlONAX7VesOkTfvZEE+j7pupRs300ZNA5F87jEVGHrpXbrUTftAtLcYeJUSC/XFOjRlxNtV+1+8wWuedeWfztWn5VRzndHIKKAAx0a95Ldu2mlZUSHJ8x+p5abQi7TK5Zjd1PcYFDDZ/2/d0Z2IHHgvdRjLt4QN9ktR6aa+CSRrcGOdx1bC+BZ0EUgfWha560Z02OrLVgnIockXJiLYlnPvhLO8ul4yHt+8WAgmVsUAk9wKvcvvhfHUuVGItpaMz1gaP0ml0nDWXp8Cp9meL0S9PIGFJzRoSQ5JgzRfwc8MTZEWMe2Kfg99jvjC5DCgEKUVfVO5E/XI0UkMGco2Gn13aZR3NkEYKI3iOzT7AiX0ZkgO97PgcP1bD0MDyGdl2nPe9xx9+/fCJagP9GcdePzDxruWOuvKcUOuCsPr1ZKgXSP1YTAzjP51y67iVorFrqczr2dOzaXyn/spdJHmNbKITBNKyi00RICrCPPchbuMLhwMIOMSK/u+5ABfJhoVcKMvhV+bfE0RrP6dZ3xjB8VF2L8G830Gt/UGuERHOVHlLaTbbcMKKmjGdhDXQjxw+AwUxqt5ap4qNHZNpmXjPTYTZNokdsU5/DwWTslr55OioNrYBKlxNR7NtLUhg6uSUnAqLPaY1/i/oRd/9udm2DDGqu9uUMSzmSkilElnNSDQL4uT20FD9wOXsjVQDsApZiVB1tJz/lhzm02nNpuJXNz9WbaUHi+KmZz7qpX1tTnNsJI+wClR9ahHXcpXB+aNYusKFJu41BQyYi980X+AO0T+3Yiw6hriibd8yTpnc1R9K0FxJjp/Od7eB0ALdFdfy8+ZWAnCgZ0MU9ntyJoS0mqCn+w7YGhi9J3qTFiCICddds
 PtD+j5GI
 iaEsSoTMdPisHytul+XAFXOVBGE8s7iYuAKlApcCfQ376lwTdpr57I48rgCO+OOBzzIQ8kmxbp7wVu5LjyVugJW9WdgM/w5jCo2BeeO4LodMtEgeqQMjQNIP8jbnAf6CLyfMxmxFxV+Xj7bBouS1RUGJuOwzvkbgN+jS2CHaQN02MB5BdpZGYROXAqZU4EkPr3gAQ49upvFc85Ye3Yxsml7gDHCHSY9N1rPDMW43cLK1DieK81rU42FVL1nEhLbERbmw+q61GnKnTGrjiMFw0WlFXD1aChm7MRxIk89N/5+1C1ts7atahSrzOIZgNOn6WM9AG
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
index cfe80c50a97e3118eefc24275fbcd2eec5e6e6e8..61a322f945c28f5c3297c506923f00bcce5c7bca 100644
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


