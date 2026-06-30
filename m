Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE78C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50FC6B00BB; Tue, 30 Jun 2026 15:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAF26B00BD; Tue, 30 Jun 2026 15:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A545A6B00BE; Tue, 30 Jun 2026 15:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EEA26B00BB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF0B81205FD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:23 +0000 (UTC)
X-FDA: 84937517406.25.AE1BC68
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B7B440004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=axnD4nib;
	spf=pass (imf17.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846562;
	b=pLtIlfXHhapM0JpwHnd/iJslNuNfWARQzRIOgCpVFOWil4ulftXh8PaYyFjeF47bBNYbao
	fAXkQbSVPvRTCICc1rtBgIoxECEWzX9PNtAitieIwpsTZ12nxvEss/+f+OsY8XhFmkjQQU
	CQavOkBj549/zT8f/fdL7KIWscs1ak0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzlYIsdi92YMwmj1hZksyU4NuPw53o+SNfTZpxZAXJ4=;
	b=mhfuUBErDFjnuZhBJRl9VHngkxt8ljEm04fHBm+P47xpFrTJ1SPtFwebE1KBEMs69w+zFk
	h4IkDJkmmKwmqwY80NjHED+KubQnPdXC+u6wa5D60QlNcYVAYveUgKxGmW7EYQ63RVhwBb
	kVov3lgq42VI36U3OUslwpL+yHKCRHE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=axnD4nib;
	spf=pass (imf17.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xzlYIsdi92YMwmj1hZksyU4NuPw53o+SNfTZpxZAXJ4=; b=axnD4nibPwHejwd22BJ0u2lexi
	uAOchXXE2BSp6T1bEnxHPXtuB4f6FlbtZIwzxE6jsfyJh4JFn62GtISAnfX4VlwRS7M7p3kOQEyrz
	nN8smyb163+dRemFBe+GNfVSziuPksVIN5uGpMZSwfRZH8FAmaeJrR4QUqe0IGqrY6DtcQg4XDt8t
	+Rhet2HgAe9CWtpZgCwQjh9OFtMi/zmbYLwaKHILrxGGPXAUFF0NyAcxt2pZQW0GjbT1N9mvXkbPn
	aoxz2o8i21YgRcM31+NpOoB9Tdy4eE/h0VljlQNzpx7j/YoWy8D5GvidOwrPYdLFDGzeHcd0gP/mR
	LKNCzw6A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpf-0000000063S-1UYM;
	Tue, 30 Jun 2026 19:09:20 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 18/19] maple_tree: Avoid extra gap calculation
Date: Tue, 30 Jun 2026 15:08:42 -0400
Message-ID: <20260630190843.3563858-19-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ege9i7codzhfxc8wymdtomt88j4r1twc
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B7B440004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782846562-688895
X-HE-Meta: U2FsdGVkX18W3A2QF8zNEzho2lmeNuCrN55V19gXcx+bl658Ud3GjNdLCqGsPKTNrZYA2YvHVPmEwUgPPeSlSAvoYg2h2rm2R+f5V0r7qai+mbXEjC7GgTYAguQhLMMwwMFTmCcr4HYOoARSLrLg5PtwI5UgtcjaJ9Hd8yhQmAywNJ6oTQssEH+VboBlmPUUCki/D5hAUFWB3qlrxzNLLz91bqWeDDh/wDr1UziR4oOnlROfbmvTa4haEPo8+mLVnGd/vkro+kSuxhUh+4sphhi1mQ2KDm7X4b7Iyobvv3MwAzw8UHia7xJQlSSzO+tUAe2iUDbZMFYtkQI3WOTIoKOfGcR8vW4o8zHjfUDDC2z/lh5OlgDFZv+fxQPuz1Uz/Zm2meq/nPOcATStIdn/E9HVgQEEQCBLoi6rmz+4BL55xd6l1uvc9S4RAJQp0xL913nRndcCHN2Mz+YDeljNdDJdtI2KUvF1bN/CG28T6gAIyqemkQUkvCZM8hONlnfDghJOv79cRT2KAfElB3bY3k1cR0uXtMlHhJ4pp+w/tKHBs4O5nXkJTHjTquSPSV3VLRbevysFX11sy8UYzFV13tR5Pa6u9NY9+8IoeEOEoXK8I3Lvi9xZZc2IHJnqVZ3WUI18EkCKWlSzKBvnp2JJUm+dNSLdhyB7bB9I/m/ZDkQfr2wVZZfDLgRr8UDtENUWSqLm+gV/0Etyl/zdpvM9hTorpgHYwOWeILgOva30CUcPCmfipSmWBkCTRaDx32f71wO5tDgyGhzmC7nLlAeuj7tcFJzk1tQxATFdMePsuJXTjoggm9DhevZkts2X6EUShTwdZsJUT7dwBt2T1C+ab4dnR4AggxQe3ooscKM9kI/LYXYZxol526efuJ33cDbC6Uus3fEDXJipJYDAK+K0S+I9TfND+G3nQHyLNdq0+wYQRFYTdCI5cgv1HzFS15+kQni6ZNbJB+VEWQv32se
 6zTJgSvp
 bPPIl6H8q8TmuCZ4R/JKdAOQcx3iSaMJo66hqTWnR8jRFFUFXfBhvEGQS6oyp0AWCuBnboKG2Ru/BTCYeZHSCZwe1pHo385pKvrhS15PIsBcpGbaxjUtjcbqH1BjD2mL3aLY+NC/sMKz8VKPAXQTiRima4igp4up+Ngmhoh/CuyUD+nW35chDvkzrQO/ARI3yvrHAGvUlprRJaQB1Kc87QNiBqXlTd3MIZZAik2YtXiIw93xXh822iUUQi7ol7AoE+ZC9RJoqMzMMhG+e4gXDgV5DjWCo7luLf1ABRafbTEdkHo8Ai8dZBQOsgut7CxB6hPjV2/EmpLWZCoQOvYrh0SJr4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prior to ending the ascension loop of larger operations like split,
rebalance, and spanning store the gap in the node had been calculated.
Once the node is inserted into the tree, the gap is recalculated in
mas_update_gap().  This can be avoided by creating a helper for
mas_update_gap() that accepts the known gap value, which reduces the
operations required for gap updating path.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index afe65ff0f8a6f..4336a98763984 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1565,14 +1565,26 @@ static inline void mas_parent_gap(struct ma_state *mas, unsigned char offset,
 	goto ascend;
 }
 
+static __always_inline void mas_update_gap_known(struct ma_state *mas,
+		unsigned long gap)
+{
+	unsigned char pslot;
+	unsigned long p_gap;
+
+	pslot = mte_parent_slot(mas->node);
+	p_gap = ma_gaps(mte_parent(mas->node),
+			mas_parent_type(mas, mas->node))[pslot];
+
+	if (p_gap != gap)
+		mas_parent_gap(mas, pslot, gap);
+}
+
 /*
  * mas_update_gap() - Update a nodes gaps and propagate up if necessary.
  * @mas: the maple state.
  */
 static inline void mas_update_gap(struct ma_state *mas)
 {
-	unsigned char pslot;
-	unsigned long p_gap;
 	unsigned long max_gap;
 
 	if (!mt_is_alloc(mas->tree))
@@ -1582,13 +1594,7 @@ static inline void mas_update_gap(struct ma_state *mas)
 		return;
 
 	max_gap = mas_max_gap(mas);
-
-	pslot = mte_parent_slot(mas->node);
-	p_gap = ma_gaps(mte_parent(mas->node),
-			mas_parent_type(mas, mas->node))[pslot];
-
-	if (p_gap != max_gap)
-		mas_parent_gap(mas, pslot, max_gap);
+	mas_update_gap_known(mas, max_gap);
 }
 
 /*
@@ -2136,8 +2142,8 @@ static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
 	mas->node = mt_slot_locked(mas->tree, cp->slot, 0);
 	/* Insert the new data in the tree */
 	mas_topiary_replace(mas, old_enode, cp->height);
-	if (!mte_is_leaf(mas->node))
-		mas_update_gap(mas);
+	if (mt_is_alloc(mas->tree) && !mte_is_root(mas->node))
+		mas_update_gap_known(mas, cp->gap[0]);
 
 	mtree_range_walk(mas);
 }
-- 
2.47.3


