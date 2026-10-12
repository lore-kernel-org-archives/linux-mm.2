Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBDCBCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 18:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E034A6B0088; Mon, 12 Oct 2026 14:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB50A6B008A; Mon, 12 Oct 2026 14:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA5D6B0092; Mon, 12 Oct 2026 14:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2BCF6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F81081253
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:11:13 +0000 (UTC)
X-FDA: 85314766026.18.030240A
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E03240005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:11:11 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791828671;
	b=CsU5vMMvd/al5qCNpuWas1V2oqxwwE1lD5kowfZyHBtjlDvybVl3n2IEtadTQXIpIWhzbD
	IGPLc1xZnmIsrtEEYlExwTqTbePVsq8csVwgRMjJjSYfZUFrhbraT6EzdoNSvUSJX/5kPj
	A/UvPpZYoBMCDKqZleIbzpQD3JMdyrg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791828671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=aZvyOlYwTpL/Y85vdLNJuzdDbPFtCMj94Q/Va76tVbs=;
	b=3u2ZDhmiQYlG14rEB6U0jMscQJDzhoe56m4AlTlr5imgwNf3blbxAExBelZhThGh6uyOFE
	sMIPcPj9BGMG2m8c4fi3yur6t7xAc5tWACqSs+IwBpUsYI7OSBU2DpjaAPUYgCTjl44aQZ
	9h8qYTsLm6S7KqRiNbhkntqu54lxS20=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGKUN-00FXn8-Ab;
	Mon, 12 Oct 2026 14:11:07 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] xarray: initialise the offset of a new root node
Date: Mon, 12 Oct 2026 14:11:07 -0400
Message-ID: <20261012181107.772545-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E03240005
X-Rspam-User: 
X-Stat-Signature: e3xwe76qezi9a74h8ubtmxrudb4ypf39
X-HE-Tag: 1791828671-905337
X-HE-Meta: U2FsdGVkX1/DG1G3aVqgma4q8q3d4ABxuK7j+e6ltYLMIcTZpmZrm0AWUJoZAKZGWQt2ogqgkU2DZvCD6Htz4p4LJzcNUCIO+fiV74tfs4yo1XLJT9ctDvzx7hCOfYIC7pWc5K5/Adlgye//mGw0uV4BUjmN2PjTJtLbBSROJHGoyzaBkcGDp0RBrWLWyLpxtIz+/K+lkC8HR3S5vgWbfDXSiNzZsk192zQUh4QmiMgUwP2o2eT941V2RimELlpe/6qQKRJ5buKWvtGz4LLBwbL6ULFC+SKsCCk8RiCc6GidCeCGbbHObcU6vIA3ehB2OWT3/NFfC/FiaIU+RAobmMCSJNtizH6vSxAx3j1jvsdv8mGoPpWwH/JJB5jKANcSijYat3GINNH8fAchqfeYT+OTz643YSX7YbEOEfOTLKLOWYW6QMoDEHD+sM96IjpPqwrhxHKzAsNeZMH+Ts46FUp/xh0kRSCnexJblVgExStgfLwM6XejcKKAy9NMBFBV7m8duQfJz51dcRViXqTijcnBtZkXmPEVl/z/vCJByZeAT/km11WmgLnOb/5WgCY0SJhctgdpToCoOBNz35Nh2/+ylvMczWGypPLgKE/vmjfVl/hwWTt1K9vL7msZQie2+vHSBxqR2rCGQIuLkw79ia05H7RMFW2pxXcU8dWlnjOcF3dfepAPwjN3KABxz4lbRnlTGCrmkJCGDyLvdYJD642eqhwGgQj4z2o6zcnxzbm+PSpANjbd3rU41qc4EoDbc19PvefPUUjRtUkqck3zdr/jaBrHMSaN+hTYDqeuehCGwOioyAh6xvkVHsn7pxKROI+FKyG74yhyEukfz28jKDvi9leJGLZC6VhMVrAMeFvEkd0E5sMmKvp2EfLIJ5OY2iaVyruAbxAdds9mFzn7Nr7VLbKKfA2y4RgA681tnRYGHWtI0Pqp7ooOhc1FeY4oFX3FvQvEIlTGRjxMANZ
 iqysm4j6
 zHDM/ZxGqxncZ7TWTvOWlaPlDXPEeJyJKGN++9IHJjuHX0Nd16rn2zJfxXfVxN4eOvC16jAIAxjJGADqnrFxFaEX8a6EYmM8qrYQXQJ0GpJhm5Z8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xas_alloc() sets node->offset only when the new node has a parent.  A
root node, allocated by xas_create() for an empty array or by
xas_expand() when the tree grows, keeps the offset its slab object had
before: radix_tree_node_cachep has a constructor, so the slab does not
clear the object, and radix_tree_node_rcu_free() only clears the slots
and marks.  A node freed from slot N of its parent comes back as a root
with offset N.

xas_expand() stores 0 to the old root's offset just before publishing it
as slot 0 of the new root, so the value is right once the expansion is
visible, but an RCU walker can see the old value.  The iterators climb
out of a node with

	xas->xa_offset = xas->xa_node->offset + 1;
	xas->xa_node = xa_parent(xas->xa, xas->xa_node);

(xas_find(), xas_find_marked() and __xas_next(); __xas_prev() uses
"- 1").  A walker under rcu_read_lock() that reaches the end of the root
while another thread expands the tree can load the stale offset before
xas_expand() clears it and the parent pointer after xas_expand() sets
it.  No reordering is needed: the two loads only have to straddle the
two stores.  The walker then continues in the new root at slot
(stale offset + 1) while xa_index is the first index of slot 1.  If that
slot is populated by then (for example by the store that caused the
expansion), the walker returns its entry with the wrong index.  With a
root covering 0-63 and a stale offset of 5, xa_for_each() that runs
concurrently with xa_store(xa, 384, p) can report p at index 64, and
then again at 384; xa_find() stores the wrong index in *indexp.  Any
entries in slots 1..5 of the new root are skipped.

The radix tree's radix_tree_node_alloc() always sets the offset, and
radix_tree_extend() passes 0 for a new root.  xas_alloc() dropped this
for root nodes when the XArray was introduced.

Set the offset of a node allocated without a parent to 0.  A node's
offset then never changes while readers can see it: a child's offset is
set before the node is published, xas_expand()'s store to the old root
writes the value it already has, and the root that xas_shrink() leaves
behind was the child in slot 0.  A walker climbing out of a root
continues at slot 1 whichever parent pointer it loads.

The new test frees two nodes with non-zero offsets and checks that the
roots created by xas_create() and xas_expand() have offset 0.  Its
checks use a new XA_WARN_ON(), which warns and carries on, counted like
XA_BUG_ON().  The test relies on the slab handing the freed nodes back;
without this patch both checks fail in the userspace harness and in the
self-test booted on x86_64 and riscv64 under QEMU.  The race itself has
no deterministic test.

Found while formally verifying the lockless XArray iterators against the
kernel binary.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    - The patch and its analysis were drafted with an LLM coding assistant
      and then reviewed and tested as described here and in the commit
      message.
    
    - Reproduction of the race (test build only, not part of this patch): in
      tools/testing/radix-tree (XA_CHUNK_SHIFT 3), a hook between the two
      loads of the climb in xas_find() runs the expanding store, i.e. the
      writer runs after the walker loaded the root's offset and before it
      loaded the parent.  The root was reallocated from a leaf freed at
      offset 5.  Without this patch xa_for_each() prints "index 8 entry 48",
      then "index 48 entry 48"; with it, only "index 48 entry 48".  Nothing
      was reproduced without the injected hook: the window is two loads wide.
    
 lib/test_xarray.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |  2 ++
 2 files changed, 52 insertions(+)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa..27988441e71c 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -32,6 +32,22 @@ void xa_dump(const struct xarray *xa) { }
 } while (0)
 #endif
 
+/*
+ * Warn if @x holds and return whether it did, so that the caller can skip
+ * checks which would not terminate or would not mean anything on the
+ * broken state.  Counted with tests_run and tests_passed like the rest.
+ */
+#define XA_WARN_ON(xa, x) ({					\
+	bool __failed = WARN_ON(x);				\
+								\
+	tests_run++;						\
+	if (__failed)						\
+		xa_dump(xa);					\
+	else							\
+		tests_passed++;					\
+	__failed;						\
+})
+
 static void *xa_mk_index(unsigned long index)
 {
 	return xa_mk_value(index & LONG_MAX);
@@ -370,6 +386,39 @@ static noinline void check_xa_shrink(struct xarray *xa)
 	}
 }
 
+static noinline void check_xa_root_offset(struct xarray *xa)
+{
+	DEFINE_XARRAY(tmp);
+	struct xa_node *node;
+
+	/* Free two nodes with non-zero offsets so the slab can reuse them */
+	xa_store_index(&tmp, 0, GFP_KERNEL);
+	xa_store_index(&tmp, 5UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&tmp, 6UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_store_index(&tmp, 7UL << XA_CHUNK_SHIFT, GFP_KERNEL);
+	xa_erase_index(&tmp, 5UL << XA_CHUNK_SHIFT);
+	xa_erase_index(&tmp, 6UL << XA_CHUNK_SHIFT);
+	rcu_barrier();
+
+	/* A root created by xas_create() must have offset 0 */
+	XA_WARN_ON(xa, xa_store_index(xa, 0, GFP_KERNEL));
+	XA_WARN_ON(xa, xa_store_index(xa, 1, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_WARN_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	/* And so must a root created by xas_expand() */
+	XA_WARN_ON(xa, xa_store_index(xa, XA_CHUNK_SIZE, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_WARN_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	xa_destroy(&tmp);
+}
+
 static noinline void check_insert(struct xarray *xa)
 {
 	unsigned long i;
@@ -2235,6 +2284,7 @@ static int xarray_checks(void)
 	check_xa_load(&array);
 	check_xa_mark(&array);
 	check_xa_shrink(&array);
+	check_xa_root_offset(&array);
 	check_xas_erase(&array);
 	check_insert(&array);
 	check_cmpxchg(&array);
diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..720d46e8b14a 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -387,6 +387,8 @@ static void *xas_alloc(struct xa_state *xas, unsigned int shift)
 		parent->count++;
 		XA_NODE_BUG_ON(node, parent->count > XA_CHUNK_SIZE);
 		xas_update(xas, parent);
+	} else {
+		node->offset = 0;
 	}
 	XA_NODE_BUG_ON(node, shift > BITS_PER_LONG);
 	XA_NODE_BUG_ON(node, !list_empty(&node->private_list));

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


