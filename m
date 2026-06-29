Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C611C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 276E06B00E3; Mon, 29 Jun 2026 10:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EA86B00E5; Mon, 29 Jun 2026 10:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163E16B00E8; Mon, 29 Jun 2026 10:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54736B00E3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42D6D1C4D0A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:49 +0000 (UTC)
X-FDA: 84933216858.12.93B9CB6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9F503100004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="y/yBz0Rc";
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744167;
	b=r4FZAzE9cVRNM9QtINIkUSViFrGPMOfK3COmbIk+oypgLKWKtsCHC7Tiq3bayp1UOKGHCv
	aRPyAjzdR8BYBibiGjgbhSlu76A6sTi+yDQJN0OBHcJOpvGABWHO+eF0LNBJdMEL+cHfEA
	VOKhWe/9axB67Vdv/eGtx7+EcC/s1g4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWtISXVTdaT95P9Ai8aXDGZfdrCS/RaIS8ba+R7GxKE=;
	b=K9TsUeHQhP7hxUUiz4oTdcOk/L7KgIOJ3JCWHThXRv3b2pLE/azUvgsEHfRaHO/UUV7AO+
	hc3udqBwBXIiuCk+9RbkxtJepPgOJkiCA2K2lXsFFVb7gAD1NdXr8I6O5FsrsZrqH4xzAe
	r3SbqKIZrNuagIwXhB73D/HaN5CZm4Q=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="y/yBz0Rc";
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kWtISXVTdaT95P9Ai8aXDGZfdrCS/RaIS8ba+R7GxKE=; b=y/yBz0RcdINQl7RTVz7XFdvO89
	7yyMIFSHWRWFFYGjqnZN3au9+qljknh6ry+52LTkfQFTmgFLzxsnTJUdjvVxBmwrQTR8NEInec1Cs
	831OOzkHxH/Hg019AWZjzoBvtUchGha5DcnXrj81SfXoGjuaNO7ZTgJNleqQjuXeEiPrCrsyMZOoq
	8nGUSg/s+RztOJ7SznMe47RunhIf3aL+JS4GokcokmKCWC4neh/pRXGeMjt0w1p/eB+8Rn7wPPdje
	lec0oVXoP2vbqsEReJ9VPbn9jQ02XevZTvSqoDIiLiTHq8UIbktaGq2/o6LGE/jKiSwrWQaQVo1OT
	3q0hexHg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCA-0000000Eub1-2snP;
	Mon, 29 Jun 2026 14:42:46 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 09/18] maple_tree: Optimise mas_wr_node_store() when not in rcu mode
Date: Mon, 29 Jun 2026 10:41:36 -0400
Message-ID: <20260629144145.1572283-10-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4hbk974yuxyfuxa6d53znsdben5neni
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F503100004
X-HE-Tag: 1782744167-461122
X-HE-Meta: U2FsdGVkX19gVMGwT7SqsVLsPSkGC8tJE9eSQpLc0s6iPyMrNkO2CBONxzoDiSKRqEip4h8dpdWcnkJWPxEbqv6MtBx//iI3zgBdiLv86HJOZYFKjVPaCNnbsbUzeUmx2vZlzK/t9srlLLwA5Fso2txTNWILfLSpuy6mU5vyzbwbbaTwsu/mfMZiqYaqO1Una6C7OQh/cNALRSqll1/f3UOP7D0IeGX2zmco4lEritvY2nsQMCnyV2seTHBlQBGlY3oWpzJwcqwR8hUIvUETFbIKaKofS8SN7UssIdJm646GWUcWckvPVtsADQenPjqU7ZA8gx06KPBgfn0U1CUWCC+z4lznQHsUY1rQ2SPcbwhnjuxlaQ9wAaCeMvxH345G21Uf0h35XAcQBa2MTDUnV2h9e6/HxJazzFegcr/K3KGoZpUSCtuiWWbm6vxGG+3OPtnh8sB31wEIzu4pmoskIF63zH0c0HBFBl9D7mYm8cOhNubZfyI6Ev0fhoSSIk1WLawGh7B7F79XNF/VXHPO/T7+FqrFBzm0RGtcYCc5xd1z23qMPnf14U6mxzpsg/QSWXp7jzC2UkJkGihf3TaWi9syb+BC6Yv5SoBdXlSIfYTMXMrFoQP9xCBR0jtSn3Esvkhd4wHiw/AAI6ubDNKFFMJNFb8nUaP8cqajNvv1bX6R21qWXbaf9vdca0OgmYL285d2JwSDqfvnpCo7pMAaD+aXGXUEZBnxV29AFLwnDR3nvcARy4Uhva3nQP/LXHcWSpn6y4Q9iMoE5afTA8oAmTN5SWf8RPuW3kPNxASBoVbBB5iXkOjzhbmvzsXCzpY/Z/ctKpDOU+1Gxml5BgewF21BA6AeaFGUJZ05ovcJ9OJJRerZsM3eHk0onEg01UulpR7fbttfY66HYBSAHa+SG5s1NJAstMoZBDb7Y9LBHLCJ+P9dxUISJdTI01OpvJqwE9hk+FtnmlMNkP8Qz0e
 MTYfPlY+
 G8pOQiEYX7fAVWgoPWWqceFYxzAFFEAmbMX4dtlDfSjfXK/hF5B+WfnwNHxg1Ph3CqnRpbXbzKzFt7klOF5NvMhtZHYwg1DBsfakyqQzmTW4cMpF1p6CFEtJUsFhY+PZ6MjWshvU3u3bA3kGuwXYxM7pLzSgBPtA/IANO0Ff9r79MwGFOl76r3yT5hvlo1I0HbM0d6G1YjJtTzqFux6SZ8n8ONEmponw15hCpBrA0oj4x79xuQPOMO0C2zW/UuyNPdm2/K51MtgS/RAS3BaEA9F60o/rb2Z12wt/+rIluj9BBI5TGc35Og5L2KBDFhzklNBY1d3UrO64tws/u3G6Cq6Vr8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clearing the entire node on the stack is unnecessary since most of the
node will be overwritten anyways.  Just clear what isn't used after the
data is in place.

Benchmarking shows a speedup of 0.67% on a height 4 tree with 2048
entries.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fe10ff83e4937..a2b96ef05cb32 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3183,7 +3183,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
 	unsigned char dst_offset, offset_end;
-	unsigned char copy_size, node_pivots;
+	unsigned char copy_size, node_pivots, node_slots;
 	struct maple_node reuse, *newnode;
 	unsigned long *dst_pivots;
 	void __rcu **dst_slots;
@@ -3196,6 +3196,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	in_rcu = mt_in_rcu(mas->tree);
 	offset_end = wr_mas->offset_end;
 	node_pivots = mt_pivots[wr_mas->type];
+	node_slots = mt_slots[wr_mas->type];
 	/* Assume last adds an entry */
 	new_end = mas->end + 1 - offset_end + mas->offset;
 	if (mas->last == wr_mas->end_piv) {
@@ -3207,7 +3208,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	if (in_rcu) {
 		newnode = mas_pop_node(mas);
 	} else {
-		memset(&reuse, 0, sizeof(struct maple_node));
 		newnode = &reuse;
 	}
 
@@ -3251,7 +3251,17 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
+	if (!in_rcu && new_end + 2 < node_slots) {
+		unsigned char clear_from = new_end + 1;
+
+		memset(dst_slots + clear_from, 0,
+		       sizeof(void __rcu *) * (node_slots - clear_from));
+		if (clear_from < node_pivots)
+			memset(dst_pivots + clear_from, 0,
+			       sizeof(unsigned long) * (node_pivots - clear_from));
+	}
+
+	mas_leaf_set_meta(newnode, wr_mas->type, new_end);
 	if (in_rcu) {
 		struct maple_enode *old_enode = mas->node;
 
-- 
2.47.3


