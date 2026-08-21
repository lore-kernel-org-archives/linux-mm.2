Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DFC4C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1416B00A6; Fri, 21 Aug 2026 15:26:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78E76B00A7; Fri, 21 Aug 2026 15:26:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F406B00A9; Fri, 21 Aug 2026 15:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68C016B00A6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA25E140252
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:56 +0000 (UTC)
X-FDA: 85126259232.27.E938B82
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DA6440003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KPbl5FfP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2d28P310C6D2ve/ZJPwUucplUmheyc9XSDUTHvPY7I8=;
	b=Gtt6aYxQbHfyhidjHU1m3V4iRV4iwPSwcVYRxhk/nSTSU3tdE6gFBiicFa4XiNRFWfZ/ab
	oMZ7krHXLvitrM5ePyDLvANRD99uO1/KsDj5VoI5HNiRCsKnPPWF+GY7djjqStqwrdfRJZ
	n6G77QXMvQtrjMkoP3htiJQpmEr2BMs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=KPbl5FfP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf01.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340415;
	b=LwyQdW0cOY373Te198MfIkNkldFE2/0EZ6kogVxYu+UutdZStGGg1auK/E3z5RihnNXZA3
	6oeFivoChOdb1kJG9f1eC7IqtAi/lBNnXIPGyiBJG9gFpVqqtK8LAT7dD8jz3Jg5kUmzdm
	Pmmz1w8/wIlayTxwLGbMF0ZYNfMiA5c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=2d28P310C6D2ve/ZJPwUucplUmheyc9XSDUTHvPY7I8=; b=KPbl5FfPeocKsYvWyv2koCPuyg
	tacL0UmdP8tjY56HjfHcF3gC+SQ9c55m+HgJQczv0P1EwY1A5JY+1FIjzu5RecY5/xk2q9bTaT/Fc
	xBSQaFez1eZwtir/2isFXS5EIK+Dy9qOw/kQW7MlLK8E8R9akTuM5C24yBbMbCpF6/+bgsVja4l1O
	2AKFzXek5fP/dXSBgncG7RKf8eTU/MfqEssHwGWwnx1RCQ5xbNXaYsVKxsQWSCANsKJzD/n4esw3E
	4/5Au13QzHukDFWLr1lcRwDEXkvnKrwGi3b3MH8SMcjy4Ra2OwJXi8lNnDYlbFCmHsnu9x+AIhfx8
	tHkj/YYw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtC-0000000E0l2-1Zqs;
	Fri, 21 Aug 2026 19:26:54 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 09/19] maple_tree: Optimise mas_wr_node_store() when not in rcu mode
Date: Fri, 21 Aug 2026 15:26:17 -0400
Message-ID: <20260821192627.4085470-10-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hf8jifif5zzshsnmkn59fcqi3mq9z6ix
X-Rspamd-Queue-Id: 6DA6440003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787340415-920303
X-HE-Meta: U2FsdGVkX19tPjw6YaQJElYkHTSFUva2asXWEffpA2FQMu/gg+FDx/xo1c/6rHyalCLFLwtJstRsBQKRi11wi5VB9WYNKGqnZUNDQJQZmpzdBdVwvIHhPIwkl6wu5VxZldDIc/6IDRaRBdhFGfoppn7EZ+ZX4bP8NlROlAb7KxXUp579Lyp6+lhrQKodDX2frlOw4ocGRJiexlJfiCGlMUNQ8hRjSfiLbkc/zjvvb/R5ufhdKPdwJMGHKMNq93Jwrc6Znq0ggvD96iHuyYdiU5jU9cXTK99PXprJjzW/vszyAIJA//BibetwUTlVtGpTihlSIRsc/KKDqxCcggMG74e4DnDJVpSssSlevouuXSVtewu0ZWJjj+29XbaFEsYxFIhqOq0yK34/Cm/ivqeXXlkvIWOscW+Pc5Kpj4rUiMM3WQ+Yjctkz/fOiSGY2cjunZFprcV0KsvSUJLs8J+pEt62h+zX+uOWjzGKO/4ATbRp1iGRNwLMSEF9SKYtCA1JY3Y9uDwh0rbhmftX3i0H8H/cnOwUhMlirvd3z/KjIVJGWTGKGWL8VjruiBnsK+CG9mZXWXSI2sGbpT4tdw+yiWGSvPM28LOxfaDVWQvFw3qj5k7M74L42yRsgyBfHb0GGiYW4KhfPngzcLC5YTUisrXIq/DsLRGw11RFjAgGTQRgyQ/azgYN5MRaYfZcw2HsJnBySuhsy0suabsuad13XY2wpx3Myuq9/ahey+7g7ywv7S7WtiYpD3bb32nFqiRGjjRXlzK9xLl7pPvP7KgRir09krsmXadqoIWmDBHzv8Kuj1UtroIigFsAXYmg7m/ZkjqIbk2fBAshbFfmA5zTVwqbJLBgEut43YmLUAkiEnQVIgzyeEKZ27YbUXWDj9YdUJaxu8lVepgj17Zp0MV9+ukCAJefOEqjuiXhg0f3KFY0CyhmgElDJRKasvo+LxmQRn6fH7RER+MoQbHbGGN
 MbuiBE8G
 aQhH9mt82wW40BXGRpmB7as+fClk19Qe5Y54fNgFUrr9TLKa/RCbcXgY61N/LJwfMnK+U/LwgUFhoF546c8eVjhUK6Me/nr0aO10i6UcGzDhA9jzv7Z9/RPn4Zq4DJi3wYQVBTA20uJnb1DKiQrXdsqcA1QZX2o1FTiZLHhJF+epgEdeIBQP03f0no67QRSIiKIkKFCUMNX5QXsywq8egwpCWRaOVJSERsypRnd4u2/gwHn4+YV2sQfMYQDAnOUyPHnsoR0LD/QHzwyO1heuKOd0qXYlr8lMGk3TnhHDTE3JUKzpGzRTLBTdpazTP+nZeLq8dTT1BsowLJECVwkKPSCOJfg==
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
 lib/maple_tree.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d5fa85bc7aab0..56812db8b0efe 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3187,7 +3187,7 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 {
 	unsigned char dst_offset, offset_end;
-	unsigned char copy_size, node_pivots;
+	unsigned char copy_size, node_pivots, node_slots;
 	struct maple_node reuse, *newnode;
 	unsigned long *dst_pivots;
 	void __rcu **dst_slots;
@@ -3200,6 +3200,7 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	in_rcu = mt_in_rcu(mas->tree);
 	offset_end = wr_mas->offset_end;
 	node_pivots = mt_pivots[wr_mas->type];
+	node_slots = mt_slots[wr_mas->type];
 	/* Assume last adds an entry */
 	new_end = mas->end + 1 - offset_end + mas->offset;
 	if (mas->last == wr_mas->end_piv) {
@@ -3211,7 +3212,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 	if (in_rcu) {
 		newnode = mas_pop_node(mas);
 	} else {
-		memset(&reuse, 0, sizeof(struct maple_node));
 		newnode = &reuse;
 	}
 
@@ -3255,7 +3255,21 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas)
 		dst_pivots[new_end] = mas->max;
 
 done:
-	mas_leaf_set_meta(newnode, maple_leaf_64, new_end);
+	if (!in_rcu && new_end + 2 < node_slots) {
+		unsigned char clear_from = new_end + 1;
+
+		/*
+		 * Note that the last slot is never cleared, since the metadata
+		 * will be stored there or it has a value.
+		 */
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


