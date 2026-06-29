Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49756C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117256B00E8; Mon, 29 Jun 2026 10:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7C56B00E9; Mon, 29 Jun 2026 10:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004C06B00EA; Mon, 29 Jun 2026 10:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C296C6B00E8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 481BA40155
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:52 +0000 (UTC)
X-FDA: 84933216984.03.A954DEA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id BE0D0120007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OYjRcMVT;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744170;
	b=aAay5ahXYnUP+fqLgwth1dDswQcfAIZAa4iYnfF+b67+RVRhVD2Eh9MU7qSh2J/jIeD/6w
	TTQlgSC2d83EtqxE3KQ5r5gLrg9m+bWnEpupX4MP7Ht8FAG4D7Y1fp2i2Cv7nXYEsBUHyS
	Pv6DOtvRmaEKaCp2gv99B+eYX1RqqKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SDtINFsEXgJAYq83PFKVlhRpnIRfNfxztGiIGve8N6Y=;
	b=fkRQ1npKy4LR1EbZrlPxsbcu6C9o8dE7I37l+8LnP8kLniEvOA+qE0vJkf8SJHOzgzIt33
	e/sro7klYRI/Jqv11o7yQxEyTy0VkiR9T7S5Sp8oqdXqO3H+EHmwhC625DJW9R0/iYNfyn
	C2iPG0mTs3e2/V6hkOVfdYGxfMXxOS0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OYjRcMVT;
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SDtINFsEXgJAYq83PFKVlhRpnIRfNfxztGiIGve8N6Y=; b=OYjRcMVTO52rjDgaELicVF/KGw
	w1xNsFR62AWXMxz+Bs6C4YXCzXiYuqEcd0I/DfywbfZH9Xffy6Xx3dMtDz9LCSIILXA6C6Q/RFQHc
	1cQ4HVPSkcKwT9IvsbpeTk1Ix+kwCk+ugukSmMefpkSKPwgInnBxhPXUWl9l/gPZ4rLSDKL63vsLV
	V5UaRibJVQtbfLNLK2dvFiRzF1xKsHceP3kSbk10c4/9dSrpC2Nnnmfu2HQXRcBFM3ucAC9qepP7d
	/StE6i07N6JVfJ7yAydKYQQXeTSKl6wnecZG5wRqdNI7MSvAVdtzPlLl5uL3tNz0XmoYwEdLHHw2e
	/FpFaKLQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCD-0000000Euch-39QC;
	Mon, 29 Jun 2026 14:42:49 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 11/18] maple_tree: Add bulk parent set helper
Date: Mon, 29 Jun 2026 10:41:38 -0400
Message-ID: <20260629144145.1572283-12-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a7zth5crur1r1g6a11senrqeg8hgr6jk
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE0D0120007
X-HE-Tag: 1782744170-289653
X-HE-Meta: U2FsdGVkX19+7/d2yeCRNAASuuxKzmcA2B2ejJzd4G6UzsNvOaC7dNAPIiLtv+syeQmJzedezmxv2Qosys6zvbfYsM+QsXPq/zrVjNa1boy1xBrjBK/+JbUuxi8THN0zPSfcUzu22NMlGrP4q2FCIEcGv0uUAuSQOn5HXiut5qMLXYm0FpbSC5q4rcDp8X0LthwmSU7JdOruBXLgdjSc+J9l7Oe4LKQzteJPnrs2IzGR610oG3esUldtNsG1EKZGLV67cCEgWxF20PlNE2ncFu44ATF2gAH+ximYGEBQTzMEH9uiGQO1aVVAiwlYJwlSGzqW9hYjQ/5OUYinRVN1rh6A9jP/vf8lNMoskgiB6xFG7tPeEN22iRaneOBm+3TUGuexoguoASvA0Eq9JAdt1LNk65H7HS1jaxmwY3YB8RQ40BiyNiMe2wqncx+r1nLifh4I6aLHxMPWPOJ15uYDc32m6mLVZUWifxkjQXVsEfNsvz3983p8t5fLNw1r8JOYPb13XqnyeZ0kpHKGxx8SkGESIFy0e7d7WdjQQ0wqT7GhmgybTGH3j0OT1dxyvz8ABFPBNdG8ZaFIkW8oeKzwKLut6Y7Nq9tFgRTUFCtdx/DCmoxzsYEWCbZnVoHN0426xv8wgjE77GH6Hbbv/FM+STIzP/2Ik4ayQ5RNcAY0MJCIP5US299hLlFgwDXoLdkn/KnYdj6mM1/gqkSj+M9mpe4GEMx4ZqNsSyTbfURC9RPxPgldJB0i6R065Lkyx1iIzbV/qC2xr/itYRnb9E7cYdYb2L0NWthZPb9OccjMUHDEKwHNjBUkSqm6ryoqOopgV3tsqFTc3BKhpBYOgE9M513+mdh8mYjkHWkq7L5y2KrS6Hc7hor4xg4ZptpobWjH16XB8kVw4VbdOKhffoDwxAhT+FSfcGdgRWvtjRmShta1TWQlGU4cJXWKHROXnecR418oz+0dx36QLkb8kA6
 GTcCLUeG
 acmyIqmAp0TOTZ50OQLgB0dERalrRnCcqt/SQ4ZOAPSTw+JdRZERcxm6PrzUe4QFogFFicp8/mf1D6uvCrIWhzzW9YrL63iHEtyEaQZ9R40Z9AFnWK/fEVWD7lwp4BXyjkPgOusUANpGEtBwqRn7DONXu/iHZFAh8ljriv9cY7CeMJm0/JO8B1erJa2sUf4pareWWJDpQfKMhxXHOdnRSI3IX2ZD/Smk2ze04TWfsNoDFgm+aBFVoICk8WpRUk9HBErFTKlgqwCX94oe3Q9bovvznU14H55xdVKKFnBm/dv8HUG42cYZiJ3CYicEgUhsSema29zAsiTXHltrn1yzrVEQPog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of calculating the parent pointer each time for a child,
cache the majority of the parent pointer and only change the slot per
child.

Testing on a tree containing 2048 entries of height 4 had an increased
gain of 3.51% on nodes tracking gaps.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 59 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index dd679ba2b8bfa..6531a2af338cd 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -469,7 +469,7 @@ static inline
 void mas_set_parent(struct ma_state *mas, struct maple_enode *enode,
 		    const struct maple_enode *parent, unsigned char slot)
 {
-	unsigned long val = (unsigned long)parent;
+	unsigned long val;
 	unsigned long shift;
 	unsigned long type;
 	enum maple_type p_type = mte_node_type(parent);
@@ -490,11 +490,47 @@ void mas_set_parent(struct ma_state *mas, struct maple_enode *enode,
 		break;
 	}
 
+	val = (unsigned long)parent;
 	val &= ~MAPLE_NODE_MASK; /* Clear all node metadata in parent */
 	val |= (slot << shift) | type;
 	mte_to_node(enode)->parent = ma_parent_ptr(val);
 }
 
+/*
+ * mas_set_parent_slots() - Bulk operation to set many slot parent pointers
+ * @mas: The maple state
+ * @parent: The encoded maple node that is the parent of @enode.
+ * @slot: The slot that of the @enode.
+ * @start_slot: The offset into @slot
+ * @count: The number of slots to set (eg: exclusive)
+ */
+static inline
+void mas_set_parent_slots(struct ma_state *mas, struct maple_enode *parent,
+	void __rcu **slots, unsigned char start_slot, unsigned char count)
+{
+	unsigned long val;
+	unsigned long shift;
+	unsigned long type;
+	enum maple_type p_type = mte_node_type(parent);
+	unsigned char i;
+
+	MAS_BUG_ON(mas, p_type != maple_range_64 &&
+			p_type != maple_arange_64);
+
+	shift = MAPLE_PARENT_SLOT_SHIFT;
+	type = MAPLE_PARENT_RANGE64;
+
+	val = (unsigned long)parent;
+	val &= ~MAPLE_NODE_MASK;
+
+	for (i = 0; i < count; i++) {
+		unsigned long pval = val | ((start_slot + i) << shift) | type;
+		struct maple_enode *child = (struct maple_enode *)slots[i];
+
+		mte_to_node(child)->parent = ma_parent_ptr(pval);
+	}
+}
+
 /*
  * mte_parent_slot() - get the parent slot of @enode.
  * @enode: The encoded maple node.
@@ -1605,14 +1641,10 @@ static inline void mas_adopt_children(struct ma_state *mas,
 	struct maple_node *node = mte_to_node(parent);
 	void __rcu **slots = ma_slots(node, type);
 	unsigned long *pivots = ma_pivots(node, type);
-	struct maple_enode *child;
-	unsigned char offset;
+	unsigned char end;
 
-	offset = ma_data_end(node, type, pivots, mas->max);
-	do {
-		child = mas_slot_locked(mas, slots, offset);
-		mas_set_parent(mas, child, parent, offset);
-	} while (offset--);
+	end = ma_data_end(node, type, pivots, mas->max);
+	mas_set_parent_slots(mas, parent, slots, 0, end + 1);
 }
 
 /*
@@ -1994,15 +2026,10 @@ unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
 	s_slots = ma_slots(src, s_mt) + start;
 	s_pivots = ma_pivots(src, s_mt) + start;
 	memcpy(d_slots, s_slots, size * sizeof(void __rcu *));
-	if (!ma_is_leaf(d_mt) && s_mt == maple_copy) {
-		struct maple_enode *edst = mt_mk_node(dst, d_mt);
-
 
-		for (int i = 0; i < size; i++)
-			mas_set_parent(mas,
-				       mt_slot_locked(mas->tree, d_slots, i),
-				       edst, d_start + i);
-	}
+	if (!ma_is_leaf(d_mt) && s_mt == maple_copy)
+		mas_set_parent_slots(mas, mt_mk_node(dst, d_mt),
+				     d_slots, d_start, size);
 
 	d_gaps = ma_gaps(dst, d_mt);
 	if (d_gaps) {
-- 
2.47.3


