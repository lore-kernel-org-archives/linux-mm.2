Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9548ACA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 23:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC6F6B0088; Mon, 12 Oct 2026 19:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADA96B008A; Mon, 12 Oct 2026 19:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDE016B008C; Mon, 12 Oct 2026 19:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B86746B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:59:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 216E512071F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:29 +0000 (UTC)
X-FDA: 85315643658.02.B76E76E
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6BC3A1C0003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791849567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BEfA1jtF8b4Xa9xrycbJDZeRG942Cgh9pDTVR8o+us4=;
	b=q+4C9zvZLQzs7/gN/Hvj5SmMNqwz28LehAkrsCKWYLTBzbHiXcKCMtGvmwbSWXsUyvCFgv
	DCADmWYVma9gspgfy/hGu5VoWOMQC18ky9NLddMnync5qQQmEbqaML4L3jbMr5ZYcbDf8r
	kxEsppoR9CBfcZcpOqpJY4QNNw8N3v8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791849567;
	b=ql4npvxt9CSa31te48i7LXRZx9ldoRp2DlsdF+aNQlnAf4Y6drI1zy34RraIAI44cDPiGz
	1Bc6CdZPDlpiIngrfDemUOiJaRV2wcSBBpzAIEi7MVy/pr3jbtPfk8YeNtMyRRNOghCA5J
	qMjdMjAWeuJsgb6xZZUxCMtMgi7u5fU=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGPvK-00GbRU-K5;
	Mon, 12 Oct 2026 19:59:18 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: "Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 1/2] maple_tree: restore per-node metadata clearing in mte_destroy_descend()
Date: Mon, 12 Oct 2026 19:59:17 -0400
Message-ID: <20261012235918.773421-2-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261012235918.773421-1-nickolai@csail.mit.edu>
References: <20261012235918.773421-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BC3A1C0003
X-Rspam-User: 
X-Stat-Signature: zugy1w9rqz989uuy7zsyoaoge6kdzqp5
X-HE-Tag: 1791849567-770412
X-HE-Meta: U2FsdGVkX1+eNLhS2AN7xYz0GLWr0t7PMw+aJPp+kUuNmP3AXYnkLs/CiprIUDKR7HAnJIx0/TuIKReGQ1WkSSN2Vp7Gs8ELqHzxPKNMRhmuMEpus/AaNBHrxPLOLb4ZHOzr/gTQF6kxEFRYHDgp4zYBcwTLS40ZzbATD/W28MWhxdq6mzydhCKv16gpXY/70kLfmANJBNk8gPQCwfbQFa9qw/MVSu8Wu7ICQ0SkLfnxxKDGfCvhmefx8dr1JvN1/VBa1vl2EQDxoBypZO5m9SesK12b/o661POQpIIwA5oVvhzTIduccZ55D21cW9Zukfl+9uYCnVZJ2/wDfQloE1zB3JxUr0JQBKdQvYtJGiLZNweOeBIdK16Zgfl12Rk8hnVb9gdCS9kY/4+pGLx0KZaX3scGN388ZEJHAYmFTAJ+tB/oY7T5UOZtDOnD2INQDQVNdBZAs1zB19LFZjZlCOEAGSsxvN+asUfoYFn1IRO9tzWjqADoUJC1eLvmEguRPKmHIKSaD6oHSOYfIxhHJpQ6AOyREr2ZlqSTKQXiM24v+3peWXj5Kl/G8CZr+BBSMOvazgW44mrZgWb4H0Bhw1VsvdPQ5YiZ/2+yhCp4M5qeyH1kV9QF9pnRPnKw0DJu8NccdsuJYWNh/Gj4m92/t6dqs7sTJs8g1uNAe2ESMygc2taE04ApAJ3hwopPAIP7JE8MoBLW6jvkEcMgt6XMiB5sf+qJlRv0pNvw8Li/HMobYJTVCeS9kcUb/pdw041mePKxkzbJQHuO1hNCUUooZ7V5/YCNlXmot3bgJXBYCDF9pWLSdAM9TFI0UhiKaDS8Ekvjw3lk4g00CQtWwSlp9hwDPfRNhtirVdLrBQUfCpvXWNF9aqXki9fbC6cKs7OHKkS9tL9QOhbumAmtKSmNZDvgglDQ2cfbVrjYxvGBjpZFsh5xcv+sWSRe2o3Q3asCLzxtlTPvuzDIydscBDe
 sGVltfxw
 A+y2bKLj/JkxaO86B3Pe05Mjn3tKEly7KrutCgqts/NHbsMx5fwck868piGs1osiNPKbJPfp2HdptRTbISVpd+1HNa6HVBEte0349/013tbg0MmHErjJra8wofWgNVSUTFLaa1niXMMrZ2rliPwJruMSz0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The internal nodes of a tree without MT_FLAGS_ALLOC_RANGE are
maple_range_64 nodes, which keep their metadata (end, gap) in the bytes
of the last slot when that slot is unused.  A node with 15 children
therefore holds the metadata {end = 14, gap = 0} in slot 15.

When such a tree is in RCU mode, mte_destroy_walk() only marks the nodes
dead with mt_destroy_walk(..., false) and leaves the freeing to the RCU
callback mt_free_walk().  After freeing the children of a node,
mt_free_walk() climbs to the parent and walks down the parent's next
slot if that slot is not NULL:

	if ((offset < mt_slots[type]) &&
	    rcu_dereference_protected(slots[offset], ...))
		slots = mte_dead_walk(&enode, offset);

In a 15-child parent it takes the metadata in slot 15 for a 16th child,
and mte_dead_walk() reads the node type at address 0x0e + 0x24.  This
runs from the RCU softirq, so the kernel oopses on the zero page and
panics ("Fatal exception in interrupt"); the subtrees not yet freed are
leaked.  It takes a 15-child node, other than the one the walk starts
from, at least two levels above the leaves, so a tree of height 4 or
more destroyed by mtree_destroy(), or a large subtree discarded by a
store (mas_new_root(), mas_mat_destroy()).  No race is needed.

Commit 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
fixed this by clearing the metadata of each node as
mte_destroy_descend() marks it dead, while the slots still hold encoded
pointers and mt_clear_meta() can tell metadata from a 16th child.
Commit 790e1fa86b34 ("maple_tree: add RCU lock checking to rcu callback
functions"), from the same series, converted mte_destroy_descend() from
the maple state to the tree and dropped that call, leaving only the
clearing of the start node at the end of mt_destroy_walk().  Since then
only the start node is covered.

Put the call back where the first of these commits had it, after the
node is marked dead.  The RCU lock checking added by the second one is
kept.

No in-tree user hits this today: every tree used in RCU mode (the VMA
tree, sparse_irqs, the interval tree test, the DAMON KUnit test) has
MT_FLAGS_ALLOC_RANGE, whose maple_arange_64 nodes keep the metadata
outside the slots.  The API allows RCU mode for any tree, though
(mt_init_flags(mt, MT_FLAGS_USE_RCU) or mt_set_in_rcu()).

The new test destroys an RCU-mode tree of 2768 ranges without
MT_FLAGS_ALLOC_RANGE, which on 64-bit has such a node.  Without this
patch the userspace test suite (tools/testing/radix-tree/maple) crashes
in mte_dead_walk() called from mt_free_walk(), and an x86_64 or riscv64
kernel with CONFIG_TEST_MAPLE_TREE=y oopses at boot; with it both pass.

Found while formally verifying mt_free_walk() against the kernel binary.

Fixes: 790e1fa86b34 ("maple_tree: add RCU lock checking to rcu callback functions")
Cc: stable@vger.kernel.org # 6.1.x
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Outside the test suite, the reproducer links lib/maple_tree.c into
    tools/testing/radix-tree and stores [10i, 10i+5] ranges into a tree
    created with only MT_FLAGS_USE_RCU until a node of the bad shape exists:
    a maple_range_64 node below the root, two levels above the leaves, whose
    slot 15 holds the metadata word 0xe.  The first one appears after 2768
    stores (height 4), which is where the count in the test comes from; the
    count is specific to 64-bit, and on 32-bit the test is harmless.  On
    master, mtree_destroy() plus rcu_barrier() on that tree gives UBSan
    "member access within misaligned address 0x00000000000e" in
    mte_dead_walk() and a SIGSEGV in the RCU callback thread
    (mt_free_walk() -> mte_dead_walk(offset = 15)); with this patch it
    passes.  With the new test but without the fix, a riscv64 defconfig kernel
    with CONFIG_TEST_MAPLE_TREE=y oopses during boot with "Unable to handle
    kernel NULL pointer dereference at virtual address 0000000000000032" in
    mt_free_walk() (mte_dead_walk() inlined) and panics with "Fatal
    exception in interrupt"; an x86_64 KASAN kernel reports a null-ptr-deref
    in the range 0x30-0x37 at the same place.
    
    A leak check that destroys trees of 1 to 5000 ranges with each
    combination of MT_FLAGS_ALLOC_RANGE and MT_FLAGS_USE_RCU shows the same
    allocation count before and after the series.
    
    Another way to fix this is to have mt_free_walk() compare the offset
    with the parent's slot_len, which mte_dead_leaves() sets on every dead
    internal node, instead of testing the slot for NULL.  I went with
    restoring the clearing from 2e5b4921f8ef because the callback was
    written around it and this keeps the callback unchanged; I can send the
    other version if you prefer it.

 lib/maple_tree.c      |  1 +
 lib/test_maple_tree.c | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1aba6cced713..fd7c3d20394c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4823,6 +4823,7 @@ static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
 
 		mte_set_node_dead(*enode);
 		node->type = type;
+		mt_clear_meta(mt, node, type);
 		node->piv_parent = prev;
 		node->parent_slot = offset;
 		offset = next_offset;
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index b9367c61e8b5..5d940bcfae34 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -3710,6 +3710,20 @@ static noinline void __init alloc_cyclic_testing(struct maple_tree *mt)
 	MT_BUG_ON(mt, ret != 1);
 }
 
+/* Destroy a non-alloc tree of @nr ranges in RCU mode. */
+static noinline void __init check_rcu_destroy(struct maple_tree *mt,
+					      unsigned long nr)
+{
+	unsigned long i;
+
+	mt_init_flags(mt, MT_FLAGS_USE_RCU);
+	for (i = 0; i < nr; i++)
+		MT_BUG_ON(mt, mtree_store_range(mt, i * 10, i * 10 + 5,
+						xa_mk_value(i), GFP_KERNEL));
+	mtree_destroy(mt);
+	rcu_barrier();
+}
+
 static DEFINE_MTREE(tree);
 static int __init maple_tree_seed(void)
 {
@@ -3999,6 +4013,9 @@ static int __init maple_tree_seed(void)
 	alloc_cyclic_testing(&tree);
 	mtree_destroy(&tree);
 
+	/* 64-bit: a 15-child non-root node two levels above the leaves */
+	check_rcu_destroy(&tree, 2768);
+
 
 #if defined(BENCH)
 skip:
-- 
2.53.0


