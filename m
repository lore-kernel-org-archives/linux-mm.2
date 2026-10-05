Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8BECA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 12:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2C16B0088; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CC46B008C; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323E46B0092; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0794B6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 08:48:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C193A66B2
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:48:05 +0000 (UTC)
X-FDA: 85288550130.22.0B872E6
Received: from danaos.cslab.ece.ntua.gr (danaos.cslab.ece.ntua.gr [147.102.3.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 82440180002
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 12:48:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=A7ls1Sud;
	spf=pass (imf24.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791204484;
	b=EQmWWksYBY7EdmsMhNxQavjw+TtxyVeS36Dz3fE91UzO+JQDsyjBldrdurwx2grrMzRndg
	zadVUhF9cguc8P2WAQByON5Pmkp5RZ8U2w6BzfYwax4+/2fl0nBVR6F2zpdWooRMnSewNv
	qPv3HIuUDXziyRMJ7Ljd0/zeZQeEAN8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=cslab.ece.ntua.gr header.s=smtp-cslab header.b=A7ls1Sud;
	spf=pass (imf24.hostedemail.com: domain of dchar@cslab.ece.ntua.gr designates 147.102.3.1 as permitted sender) smtp.mailfrom=dchar@cslab.ece.ntua.gr;
	dmarc=pass (policy=none) header.from=cslab.ece.ntua.gr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791204484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+4j+2Y8EMDQkEbNTWfPTT/aEWlmRsgNZQpahLYccWY=;
	b=S8oDssA5SOOPFQJCYVmJHMq/sU9xA9IMtSoqHDGoxzwuhr6UTsIBgGwk2ousTXFAlo6KyG
	qJyvjH+zfibeW52N1L9yar1/Q6LSYzj20SbrlSiW9JUxnnQ7oxIjOtK2TnfQPcF0m2HShl
	Ch7gdiWzbeVNzaCphliDja/eN3rT1FI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cslab.ece.ntua.gr;
	s=smtp-cslab; t=1791204479;
	bh=RT0cvZhZuYfunz+KKV/LNA7VnNO4f0qqJFRrlvkn7RE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=A7ls1SudXyt2eIr/ey819WhfOElxRY+itA9X5ICt39FFvjh32z04x01RS0n3gHwze
	 uwfej74RVhDDx19sPz406tzbJiK4/pVhHS+oSzK9HxK7qvbVUDURbh51PNGzoRJN2a
	 j+lcrfC/vSU7pk0k9Vyl4reDhJqO3SSB9RDjXTeA=
Received: from [127.0.0.1] (armor.cslab.ece.ntua.gr [147.102.4.33])
	by danaos.cslab.ece.ntua.gr (Postfix) with ESMTPSA id 95FC3120A09;
	Mon,  5 Oct 2026 15:47:59 +0300 (EEST)
From: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Date: Mon, 05 Oct 2026 12:47:27 +0000
Subject: [PATCH v3 1/2] maple_tree: fix maple_range_64 crashes in RCU mode
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261005-fix-maple-tree-range64-rcu-v3-1-ebe7fb278e20@cslab.ece.ntua.gr>
References: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
In-Reply-To: <20261005-fix-maple-tree-range64-rcu-v3-0-ebe7fb278e20@cslab.ece.ntua.gr>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Dimitris Charisis <dchar@cslab.ece.ntua.gr>
X-Mailer: b4 0.14.2
X-Stat-Signature: 95uzcxgxteaje9srui998ccrpe9j5m5n
X-Rspamd-Queue-Id: 82440180002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791204483-138503
X-HE-Meta: U2FsdGVkX18YerXj0Dpe7khevG9SC1RsiNwwKupyqG6upqDLyiHND9sJ2U8ZiycvcGZkGn7XQF9kRH9NqfD3S3oUA3p9uM5+u0pIqBIrbiPt3nXfbNOrifEIlsPELaeVx82Pi4367auSwOnm4G95ClO7kZIHUoHg9g7dIHRupnEayABah3jh69rq0pW7BKVwoFYHo3SqQ3qi04HUXkFC9b+JvEQVrfV7kOMHkEWdZchD4C0RS73xLzo66XzXdwhXA4oWRdbW+PQ1VNJM//d1LdzXa4S/KKdA2CEAoXSXK96QfF29idyLZnEMKzfzrXNtr6dDPBD9+rS9ACZI5LtmeVqoP4+/l8Z5UZQW8pb/Bk2ji2dC02qf6HWLdSDlLVm+q3ybIECbmNAS7icrj9JL8ycGR6R2CT/H3O6ShFMwj8hwY0Iq59Lgd+uY+70KXtiCL4hSdjXrEw+ORqMuAKuWNEmYbmR7JeT6S2sO93zdGqMIfASjW3YlS/HeLkvkBRyYGxLxY7S325gOFNokKKnE73vkbqYD0fVARX6MK9NiQ4vsEHFYnTKHTPc8tFEyp62ZbboiFfe4DKbOyn4PwlMfAL/7rzR6twWrGA05JjzVN4zlJQthu/eOab6qglxeAQQhQ134v2va2IzIya17r1/QP7SAM0GoGVfKdyWbz4ZPG0iegOee7iKOsl67iqx2Q6rdA5vU5ethOtdsOM9Ognhbqaop1YwOivNusH1VCgOSdsgjUv10YYT5c327TMFnnGY4NzmTSa9uxfFWtHl9GU9lEWQ5y7+re/GlYTcIRKdQz1fbMzbrYukQ/TBwLJdsj6foK8cmhqZBvMSwCfcm0kCm1JJfJRNfe+X1DlOEtNHe406kNYFN8wc/dnBEqg1CA8Oi38eTkH5Vh1AMXcVCVJ8UU6TIKn/JQTH6G1bnXslz+hFbzfYd3ZABe6g9rw7GnQyeNFXyZfV+dz/8lgKPxhE
 p2eh4ioS
 J18qcVC2AlsGIBU3Cwn8CytFSIySXQ9Sp7gRj4AN/eZngV9yQoZbD8pSaqUzUYuUIbmiHvGvETxn4hTazYyzCkNTP2GsQC0nRZagT7R5Y7RXCbjIsv4WjVlcEJz4b3eU1FFIR9J+JU3BEfro2yguDQc8TFmEXpw2yUmjg5f2/CbPWE4Z/kgMBseQ/h8ginx/A0Hyf+IibpbIYU0Ciy36UBEHk5RQx7NqVI/jIaZVxYhjFk0kZX75jWkWTmUm8ZhhT+uOwMBCEMBHx5RRG5lGkWDw7vE1IBjEo8bTzV7LxJ3CE/6VWcvWj0VrnY1ZLHTk+owE43HAZgM9y0CKK5AqwmitfMQ/CzQRLHqbDc43/awBxAc1efBQMaN3EDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This commit fixes two issues in maple_range_64 nodes under RCU mode. A
maple_range_64 node repurposes its last slot to hold metadata whenever
the node is not full. Both issues arise from mishandling that last slot.

More specifically the two fixes are:

1. Remove mt_clear_meta() function. mt_clear_meta() decides whether the
   last slot of a maple_range_64 node holds a child pointer or a
   struct maple_metadata with the check

        if (unlikely((mte_to_node(next) &&
                      mte_node_type(next))))
                return; /* no metadata, could be node */

   The check expects the pointer to be encoded.  But the only callsite
   of mt_clear_meta() is mt_destroy_walk() on the RCU destroy path, and
   by the time it runs, mte_dead_leaves() has overwritten every slot on
   a full node with a raw pointer, stripping the type information. Thus,
   the check above never returns early for a full node as it should. It
   falls through and then:
           meta->gap = 0;
           meta->end = 0;
   zeroes two bytes of a valid child pointer. Later, mt_free_walk()
   dereferences the corrupted pointer.

  Fix this by removing mt_clear_meta() along with its only callsite.
  mt_clear_meta() is only called for the root of each sub-tree destroyed
  under RCU. Descendant nodes retain their metadata until they are
  freed. RCU readers may use the metadata while traversing a node, but
  do not use cleared metadata to detect that a node has been removed.
  They detect a dead node via ma_dead_node().

2. Fix invalid memory access in mt_free_walk().  mt_free_walk() descends
   to the left-most unvisited "parent-of-a-leaf" node by checking the
   condition:

        if ((offset < mt_slots[type]) &&
            rcu_dereference_protected(slots[offset],
                                      lock_is_held(&rcu_callback_map)))
                slots = mte_dead_walk(&enode, offset);

   On a maple_range_64 node with MAPLE_RANGE64_SLOTS-1 children *all*
   slots are non-NULL. The first MAPLE_RANGE64_SLOTS-1  hold valid
   pointers to child nodes, and the last slot contains metadata. The
   above check therefore passes for all offsets, and mte_dead_walk()
   dereferences the metadata as if it were a node.

   To trigger this, a node at least two levels above the leaves has to
   have exactly MAPLE_RANGE64_SLOTS-1 valid pointers to other nodes.
   maple_arange_64 nodes cannot hit this since they store the metadata
   in a separate field.

   Fix this by bounding the descent with slot_len which holds the number
   of children of a dead node.

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Fixes: 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
---
 lib/maple_tree.c | 43 +------------------------------------------
 1 file changed, 1 insertion(+), 42 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1aba6cced71307245cbbca26986e14e74b35a14f..0b0036c9f848929a7c9a26650ccd935c44aa1376 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -763,43 +763,6 @@ static inline void ma_set_meta(struct maple_node *mn, enum maple_type mt,
 	meta->end = end;
 }
 
-/*
- * mt_clear_meta() - clear the metadata information of a node, if it exists
- * @mt: The maple tree
- * @mn: The maple node
- * @type: The maple node type
- */
-static inline void mt_clear_meta(struct maple_tree *mt, struct maple_node *mn,
-				  enum maple_type type)
-{
-	struct maple_metadata *meta;
-	unsigned long *pivots;
-	void __rcu **slots;
-	void *next;
-
-	switch (type) {
-	case maple_range_64:
-		pivots = mn->mr64.pivot;
-		if (unlikely(pivots[MAPLE_RANGE64_SLOTS - 2])) {
-			slots = mn->mr64.slot;
-			next = mt_slot_locked(mt, slots,
-					      MAPLE_RANGE64_SLOTS - 1);
-			if (unlikely((mte_to_node(next) &&
-				      mte_node_type(next))))
-				return; /* no metadata, could be node */
-		}
-		fallthrough;
-	case maple_arange_64:
-		meta = ma_meta(mn, type);
-		break;
-	default:
-		return;
-	}
-
-	meta->gap = 0;
-	meta->end = 0;
-}
-
 /*
  * ma_meta_end() - Get the data end of a node from the metadata
  * @mn: The maple node
@@ -4789,9 +4752,7 @@ static void mt_free_walk(struct rcu_head *head)
 
 		type = mte_node_type(enode);
 		slots = ma_slots(mte_to_node(enode), type);
-		if ((offset < mt_slots[type]) &&
-		    rcu_dereference_protected(slots[offset],
-					      lock_is_held(&rcu_callback_map)))
+		if (offset < mte_to_node(enode)->slot_len)
 			slots = mte_dead_walk(&enode, offset);
 		node = mte_to_node(enode);
 	} while ((node != start) || (node->slot_len < offset));
@@ -4885,8 +4846,6 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 free_leaf:
 	if (free)
 		kfree(node);
-	else
-		mt_clear_meta(mt, node, node->type);
 }
 
 /*

-- 
2.47.3


