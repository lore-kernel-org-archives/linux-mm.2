Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E618C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00F36B00A9; Fri, 21 Aug 2026 15:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A1F6B00AA; Fri, 21 Aug 2026 15:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA03C6B00AB; Fri, 21 Aug 2026 15:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 804566B00A9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:27:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2163812025A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:27:00 +0000 (UTC)
X-FDA: 85126259400.01.3E33F74
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8F30F20006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dZ2bksNC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqdYYgN8ZpCZL9nerQOBM+1M3s8bu34Pe4LUXUsonbM=;
	b=ybW6TzU3QdeDNSvJEhWrnjcAfL1dGBcCyjje6xzCcxnFFhMGnxxaY7IMeIHditg2JiiTT9
	pmsnpbXl5H3O04ZrjqlxaZKdSDwgotM9nR0KueBNuXZ7+xroaIrAclrzRnC/T7RyxNh2Y6
	yrVz4dB7wlMKTkb9eXvF1icatPaX7Rs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dZ2bksNC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf13.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340418;
	b=qOQgyrKgv1RSGNqJPUHCqeFj+ArbyzUV2nnwBzVeiKeAudWsLGi0m5TyKecjW0M5HI7jL4
	0J7LACrH3nYuGRM/RHa43do/6WVZwlAqqQ9WpcQRm7KH09+je843KnFkdlrCOSpAzJoXHn
	RbYC+5l/UwCKo2weZvxvqOSJsv8zmvQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xqdYYgN8ZpCZL9nerQOBM+1M3s8bu34Pe4LUXUsonbM=; b=dZ2bksNCqTdqfXzxPsB6Gw3BkW
	INaq2fsW61sNS5rhzWEi4XfH0XXomvq1KSjWQWjoBCpslU7PQmHM8o1mj9La7OQ+jtqRQgDTiG4EJ
	j2WpwIiCZUjn1pY1azwvhSrZNmLMlFLuFYOT8vRxUw9JNvZp4ZcqFn7qKb3ILp2/v/4WQXJ63xxY6
	wrQjYMLXdIJMCwqYW2aiy5pE+dbuhWyGP8wNM8L5IIcwLS+FnKuR1J8EsoKS7kTCi39V2BAjp1nwo
	fX8uLuIchbH9twcKWLOdfGyWBIPJjL/zoY/Ev5kgEbR26AcKj/9/2bizr2ypRchTtbIpCdNQ01JHL
	z1sHuGFg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUtF-0000000E0mS-2CyS;
	Fri, 21 Aug 2026 19:26:57 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 11/19] maple_tree: Add bulk parent set helper
Date: Fri, 21 Aug 2026 15:26:19 -0400
Message-ID: <20260821192627.4085470-12-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F30F20006
X-Rspamd-Server: rspam07
X-Stat-Signature: x5ru55ej8h6sfj4s8auw95pnh6cwmrsw
X-HE-Tag: 1787340418-851528
X-HE-Meta: U2FsdGVkX18B3uF6epxIqbBivlyPwGxE8YUSsFFFoqd7XRX7wdU9EoH3LvuJ5coTS8IeyrIV3vyBfWvKaBJE7+G/JHqvXp9PGf2uUy8X8Q2PCH5uET5xbkLbxy7F9KZBqAhgjqlW7wI6SLrTKzJcgtDWln14yCFZ9wHXgKo8wopKonT+qv96LuhJFbMs76mSJ8wVeyoBePd2kTqus6IfPIjFn9Bb672UjV6nljTwQFJyguxBDRUxXjtFnapKrci7xlQOle6HPS9hIBuzeCfClLyxAgn72bH+ssS3h0oCpiQxIuWFx1P4rWQ9aCLH4SEJgzBHlUTppxUQ/ug45co43pfbsBvYwoM9a7CTcqnewnk8WK6HGHTk8G71ziiuWwGKwpR/nUdsWxErHEfYUhoPHvr0aIlOhhPVP/BLSPVFvuRY9EjERrJZeDUDvk1qIzaxl8veDFAghuCDYrwIFthxnLWP2//8rofODcqZ/VfsAtxUbdmKVgmNoJRHouavWfBicLUw5T6VxtHDORAYZcYbuRg0A1mH0KKeqn9Nfk5Toqm4rgvqGV/8qxWEjfz52SLhip8u8gKbc1lZxBo+sJW3/U1vVCzCs2l4RbhoGqnoOKqmERq3we0SasIMV+VxAZfT+jTqWb/5q2qs4s3agomEEkBDdZdGOEX29oFD8gCbu/XajnI6LfhxfLLVYGQa6W2VXgO42NIqRolfYs53EhxQktDXkSJ+HJf0mY1h2fhzACr6hHuKfCmXgMDRuMtPTFLpjKkpl05hoPrOXMAOC0xZdzXA72Y0XeQ94xjOA6jeWlb9wAzCy0sdyDn7EknMn8NgBU7EQ1OKh0/jJtPf4oCZMUIX784iFzSSN6dOr3Zl2+p6ghdJrlt/i5vbXqMwq3c1o1luUkYkE9LBnUcR/HVqDBug5MF9RuBxvHGjthG5/o9mFP2UisI+YEZcpG7W1GY74MFmMOX7s5RXSBG8LmJ
 npTf6URh
 g2twVo098Wntlhk3jtIxXa1wg12pketdDVfWzrS1J3Vqm2SshmpWmIFn8Mk4syo2aST7PHM0pjLDfON+A6T3yfr11iyEaOiyfMWcDijnyOVfo4YUq4YL/qt1tpn3diNGqSMOFJdiIW0aFybBaeYZKOF5hKtadtMbriQWn2AGHT8HGuGmbsVZfZ3ukkchUKTibj+2j0OsnAxyW7qiGqErr7sK38NUzyGQ4C2Sifz5ZjXJ/2bDFvIppTQ6OiLMN6r/+Oy5o4Tmp/4nq6Z6vdYZKOkjOIMB1dVbSJ2gUsV3Vcsa9uyR/n/9ugCd/cwv0sPhkJLyCbAee64EqC/1fQSXlvPcHLQ==
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
index e2c780a64c9c1..c968e25bea0ae 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -450,46 +450,6 @@ enum maple_type mas_parent_type(struct ma_state *mas, struct maple_enode *enode)
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
@@ -871,6 +831,42 @@ static inline void ma_set_meta_gap(struct maple_node *mn, enum maple_type mt,
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
@@ -1609,14 +1605,10 @@ static inline void mas_adopt_children(struct ma_state *mas,
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
@@ -1998,15 +1990,10 @@ unsigned long node_copy(struct ma_state *mas, struct maple_node *src,
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


