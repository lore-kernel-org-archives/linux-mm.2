Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C642C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 20:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8416B0095; Fri, 21 Aug 2026 16:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157FE6B009B; Fri, 21 Aug 2026 16:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071CB6B009D; Fri, 21 Aug 2026 16:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEDD26B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:11:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3734512018E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:11:34 +0000 (UTC)
X-FDA: 85126371708.01.D8A0915
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id B054E1C0006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 20:11:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ar4sqSP1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787343092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udDJnal3U0OEHVtLg9YU9KDptajuVWhrqXaSm/28e6Y=;
	b=lneoBFvHIp5Xl4Q1/Skx2iBR1rss0+MAywiLVGAO6hzdxQn8ST+u0q62ilKDBDpapJw25P
	9IC1l0CEWwihfuxkBoU3qFKAZajBe7eTAHJgbO4uq3UrdUo8VN+sUQ9P4lIe2CB00WArtF
	7/uw966nV5+buhLZtlx609z4F8trFLU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Ar4sqSP1;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787343092;
	b=o3F2p/ZldLpf3sFeFp/2GAuTHe+DP/vwj52EqzUMwKQ0d1d0W4R3fI810yobP4c2ZDD5VP
	qG7t54VHYG36xhWR48R7vJWnuXr80jbZrmpqdmK4SheoA1gQe8iUsdeUkFjBLUCElgy1+j
	JLYkd32j2VKgpM0uaREHWA0bXFBJlPk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=udDJnal3U0OEHVtLg9YU9KDptajuVWhrqXaSm/28e6Y=; b=Ar4sqSP1LYl+2U64zJFCmX26jZ
	5NSXlZCFDzRLlT2YnhZSShubjYh7TgaoC5TBNLxPBihkQvq9MkDWQvBszSSBU+PtrcRXb+MgjQYaZ
	gojD7o338BxnNsLOCsL0RMTyrRi19JNbMphRDja7FR1aCGGYnMpZLZnWhfITW8UBlK0NpBDquLKtX
	njfa8ckmw85Yk/Mps1b3jbrO5FBQjZ53IcCMrlv5irlJ9fOj+FyFLlywb0A7u465t7b9zdbYv9s5L
	0RF2mXXDBx8Zg5cM//zP0Nvs0fl2cmmCWKK87TPGzCEPv4KWnHYmww75pn/feNM6oXDCSvGazYeVw
	1103lbxw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtR-0000000E0s2-2qAP;
	Fri, 21 Aug 2026 19:27:09 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 18/19] maple_tree: Avoid extra gap calculation
Date: Fri, 21 Aug 2026 15:26:26 -0400
Message-ID: <20260821192627.4085470-19-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B054E1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 15kbtp58h4ebwfdro4ceiwbn4uipumza
X-HE-Tag: 1787343092-746200
X-HE-Meta: U2FsdGVkX1+4RQQ8XrDsTBXJtQXMMqTEibktTYsw1jnc8IabU4jnsV8W2GZk3OWEe8YpvcfERMZPEOXV5IP2Ktp0Ri2fXnonupjNYw3KaDWNselRwP0gs6kP57E3KI7qIH3DISrpp0R0SGy1vfgL3dzyapXwGJyWxJsmDeLj+zviDF6IOX9JVpTpoXqxFpWq6VhQJTwfhWkpWU+8/VBqbgXB8s68Wab8Uc8HA/90t4M001RneDLh3LMF2+mOs7Txt+S2QLPgcSrmS8h6OAAfgPeVl1KX2Vk46P7pP/nTShFVi2ex8cLMOQr6yj7QtGuZ5DBegISsdhjunM4a+/OlKjPu+XgpgDed+zzHew88CwmXtTrWFymSoDZQsUg3gTXiPZmzu8SX/HXCC7KQ3P4Th8h7sv1ZpWOZuejHif+mDgj4Vo4J9FSHhBJwq7RMC3jvaRsrqRUPkV+xFzmpPLOLG3BoUyO6QIIL+LxpARVBoSBvKBaM1XK/oUHBtW8sRLbUCodehqIgXGhGET20on7Qwj71bM2GMN5Puk7zkmDvsamxO+lyZTOcKJOE3o8D+ZIYIkqgvkQd5E6bWy9oDAvvlGG7IolonWr1iJy7REFGA1NTnq9hEROc+VudHmvcNSrLrcuH8tA2ojX0CVAy2zFfWJO8QiWb0zN6X0n1pp6mYbwnYi/j1tj+U/btLuapyZW18EEOuM6LVUQiV+rHZ+lrI0/GxLi+RuXu8CQ/4ffdOmpYqkBQNa+LXC4ux5FThXhj1X0AWoTB2qIJdyP7H7L8j7O+b81cdfzOxf00cwmEDPFpt+3IxpiJh0idp0HrXeUjqi0SKy8cdv07N/NttbrSyqV3GjkuIKarFkkH4l7wksgOeQdQh0faScL83Zpw+/yU2Z8JDeVANzR2rXgBSlkiAeZCBzZxvMQT2pnpm0qQM3pHGJbZ0Q/VKAIT0zaikT5Y5daH5TE9wbgamE+k2c5
 YomaPD6r
 S4i2gY8RVKTeqEUnn9ZCIyDPWLpUrXWMIFcT33mhHZTOvLDguBhZ+Io8GSGNXtvxQ8smrZsDq2UQkizdEPuR0VzXQk6Rxk/hrcxDslufGYkmw1bt68Bca9nQbYg3r3JeHeceeb0qA8I9FFRFM0oOqymfFUiUebQpIL3ZYSZEPVF1eWhNCsTFA7x0gEz1iWb0tjjA3/2/ow4YYgUYJl0tEevEYiv8c+h9m9jTlTq143CYfY7E26Xzv7+vfXiZZ7gnbh8CKja6C9kSvKxlB26svp3woI5w9mC7dnLq4CfJOwpdW+Mo2XrAlg0zd3nQAcZKN+WOl+BxmnyLmJGyFFyZOYt2hzw==
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
index d47d4304f781e..b43e2ce129b30 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1566,14 +1566,26 @@ static inline void mas_parent_gap(struct ma_state *mas, unsigned char offset,
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
@@ -1583,13 +1595,7 @@ static inline void mas_update_gap(struct ma_state *mas)
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
@@ -2137,8 +2143,8 @@ static inline void mas_wmb_replace(struct ma_state *mas, struct maple_copy *cp)
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


