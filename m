Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08E8FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F36476B00B4; Tue, 30 Jun 2026 15:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24566B00B6; Tue, 30 Jun 2026 15:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD756B00B4; Tue, 30 Jun 2026 15:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A33C26B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30C53168354
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:08 +0000 (UTC)
X-FDA: 84937516776.14.30DC842
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id AB47BC000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0ugGImTA;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846546;
	b=TX765fQZ7q1jfcdyCQcK/SknFm7614lPROOH1C9Yvq9SpjzHxNUNeqML8VXSj0/R9eyWNh
	PNj9ufKoHz3nscvcRA2XABYLI33pyiDWIMmXKtWFJsdLwiWp1yw/a3cu17Fg8W2mAaXC2V
	HMNXQosl78g1+RMl48V8N2w/pcqr1VM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RehuvfOSezc9zOkXVOdYQDokSzzkxVMF+i6Xa+KVxvU=;
	b=JUD2YtkWydSVJF7BzmbgU82yHcgFsSx9ii0ygzF9uRLLvJIYEUQBbn4PnNTklvYz0doImQ
	LIIRb0V7t2rmMB2ek4ZH5nPC25ZwFJWYMhrJZTM0NcTL1mi5UkjP3ywOJNjGH5BD4j98XU
	aqmwGqr2NOtEgvpOXDl5Ul40pSTBwl0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0ugGImTA;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RehuvfOSezc9zOkXVOdYQDokSzzkxVMF+i6Xa+KVxvU=; b=0ugGImTA4qN1dYQoeT8DvwkmMK
	HR6OclU65y7VwqohEjvFaHTQkkwCpIiti8Aa+vp5Bu+iZDA/71GsjCNw65rvzT6X8UaFgg0RBeN2R
	Fs2xQkR7oVhKBCtm40TLANcTx3P9aXMCKVBAZmblK9ioBXFHVXHmgJtt2z/F3sWMl3ZksGmfcgTd1
	s9WZzmTvwb2uFpeXv5h5Zong6/vtpQXgIv9Lx6J3H3t7L5A531XBdRz8QGhZWf6YcDYOQ4FqrR5+Z
	HiUkE70OkCa5hyYHDtYVdNOHpds/xeHGduT5j6LdExCP+RMku+Fize4zEZTIIQ+44Vr95TXZ4M6PK
	wrAozD/A==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpR-000000005wg-2WpM;
	Tue, 30 Jun 2026 19:09:05 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 11/19] maple_tree: Add bulk parent set helper
Date: Tue, 30 Jun 2026 15:08:35 -0400
Message-ID: <20260630190843.3563858-12-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AB47BC000B
X-Rspam-User: 
X-Stat-Signature: nkwhzghtkxtzgcrb6myf3ki9fem1jidm
X-HE-Tag: 1782846546-644116
X-HE-Meta: U2FsdGVkX19nF0JLba5um6njOm+U3Hvc1n7A1tGMle81mDj2Q/Kb0wLNXLexPaVv1S9RC9uLRBDm9gh1V1Q0ZV5PgOyd4dg7vi9EQ400cs1cMdeIruTg9qa8g4VvS4A/91oEGadDBMSChWuojlVX/rJrfhpUzsvN6SY10DdSXYxhrS4rdT2SujTMwB+o70wxWQSLNxVbw9Us8CjehGYJnxGh9gR1x5AYqsSdmir3n2s6E4DkEpwKTlFfpi/AKEiyf6Kssj8VXaj7NZSi9vSvI2QDot9QL7C0M9Dbalj6iNdo/mEZFy2tjDUhhfvIsA8EwJKp3iml706RX4S8zbCsqH7zYMiddaQFb1MXO+oNymsNxF2ZvrsMu4c4yAxZr0qz4/NKrt5JcZ6zC3mjCOc31Z89FzhSP9xdBH4/z3ZBfNdxU5WVN3uVUrm7+a26++W8UAcXb+iUjvvJM/0Nd4PmOlFvY6nr836VVovSQOOqh+fhF53eXEKIv5Qwb3yl/Ot3PT1W15U/+HDNGh/LKLaRxoPfW0oA5uElGB7/Bg0E05VQEWmBVmo0FdoaQzVVcPdlE2IYngK8ZQB1/NHIMxfAm4FSRHlZfSsyeqMcBIkRDirD/lFxMhSs6KneVIvKeVUgsjaH5Mz7llqT0+tiT4TUTJOqW5QxJE9koAgt23mITZ/PaSPvILBsZTYEJsQmxddGeacd3aT0nPTYN0ZgCc/s5KKUO9KxPiUDNhH2WdoG1hvYHFaYSHbvk32yX0OozOZjWVWxQeG6mz+K6Jmv0o7yi0cd2ZD4dVOx/mFMNfY5BtkY+I0EIi+rOh/sI6tsdcKc0S3+1bdUJzWz+LI06BGkFEJ6l0Uar8JJur6Z2BGQev6qooWKc8cWDblujz06Pvqo8nFcqXYvT5XV1jBJFmx7vu56rH0j5lqXq1w4NxMFpBZ/3/l12v+jc/bdQA0jk8FZdVXl6y8AgdAX/9wxHoA
 c9lB+8zM
 uzC/MmRkj7BERtVehq/HjiYbe6dwdURsDBxQ6Uz5uvBHJR7B0+eMcy/EhW5QRCYGlvOd/w7bgeN6DqWihTUJGJdQibPz4GXXKzQucElyAWw/hOSJyfej8HmciC7qfDT5/f14ualwiFE+srL1U0+xXYP20tnWWmZsb4sW9Qy4K+47p8aoDYPwojtsJglwTHMqTrTFzGuhtgv9S73iawJg7YtBLItJyUItNDPRfUD5zInDdgetdfJjfgWNdzBLRj4fPb8ys9MeNqTbm4747OELoZ38EI24I0IWid7mmXxaX/yzp/eE6Ct6pO1NaLtxTq4nKFWH4JjQ5nzHwDchnNzvn/0GvDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of calculating the parent pointer each time for a child,
cache the majority of the parent pointer and only change the slot per
child.

Drop the mas_set_parent() function since the last user has been removed.

Testing on a tree containing 2048 entries of height 4 had an increased
gain of 3.51% on nodes tracking gaps.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 97 +++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 55 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 999a1d095e369..768193406c3db 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -455,46 +455,6 @@ enum maple_type mas_parent_type(struct ma_state *mas, struct maple_enode *enode)
 	return 0;
 }
 
-/*
- * mas_set_parent() - Set the parent node and encode the slot
- * @mas: The maple state
- * @enode: The encoded maple node.
- * @parent: The encoded maple node that is the parent of @enode.
- * @slot: The slot that @enode resides in @parent.
- *
- * Slot number is encoded in the enode->parent bit 3-6 or 2-6, depending on the
- * parent type.
- */
-static inline
-void mas_set_parent(struct ma_state *mas, struct maple_enode *enode,
-		    const struct maple_enode *parent, unsigned char slot)
-{
-	unsigned long val = (unsigned long)parent;
-	unsigned long shift;
-	unsigned long type;
-	enum maple_type p_type = mte_node_type(parent);
-
-	MAS_BUG_ON(mas, p_type == maple_dense);
-	MAS_BUG_ON(mas, p_type == maple_leaf_64);
-
-	switch (p_type) {
-	case maple_range_64:
-	case maple_arange_64:
-		shift = MAPLE_PARENT_SLOT_SHIFT;
-		type = MAPLE_PARENT_RANGE64;
-		break;
-	default:
-	case maple_dense:
-	case maple_leaf_64:
-		shift = type = 0;
-		break;
-	}
-
-	val &= ~MAPLE_NODE_MASK; /* Clear all node metadata in parent */
-	val |= (slot << shift) | type;
-	mte_to_node(enode)->parent = ma_parent_ptr(val);
-}
-
 /*
  * mte_parent_slot() - get the parent slot of @enode.
  * @enode: The encoded maple node.
@@ -876,6 +836,42 @@ static inline void ma_set_meta_gap(struct maple_node *mn, enum maple_type mt,
 	meta->gap = offset;
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
+		struct maple_enode *child;
+
+		child = mt_slot_locked(mas->tree, slots, i);
+		mte_to_node(child)->parent = ma_parent_ptr(pval);
+	}
+}
+
 /*
  * mat_add() - Add a @dead_enode to the ma_topiary of a list of dead nodes.
  * @mat: the ma_topiary, a linked list of dead nodes.
@@ -1608,14 +1604,10 @@ static inline void mas_adopt_children(struct ma_state *mas,
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
@@ -1997,15 +1989,10 @@ unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
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


