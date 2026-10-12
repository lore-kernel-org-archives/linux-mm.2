Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0EBCA9EDE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B456B0088; Mon, 12 Oct 2026 13:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E30F6B008A; Mon, 12 Oct 2026 13:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F99F6B008C; Mon, 12 Oct 2026 13:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 016F26B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:42:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FD0D1612A2
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:42:42 +0000 (UTC)
X-FDA: 85314694164.21.7CB3388
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf31.hostedemail.com (Postfix) with ESMTP id CF7D120003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:42:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791826961;
	b=Wcs9Uk2kDtiXLIxVMzRyPAisKFbNBifAyTShp1EPa15ffk4Bf2vWYoTn79aZu6ZfN/zJ6D
	J9KGT85LveSWBQt7mn3bOPbFhDZkzY9CGI2Osr/pstSPiRjy25hY+e74zP/CPOb2M2HXJC
	c98+B+zuGZCo8KOatOTmDDiTx2/F92k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791826961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jLZA+GVZa155jtHg+UBpzwzh598Q6JuJINGlB3QRwEI=;
	b=GuwPPNPiK/Bc5KMg5WcgMVZu+Id0LKxYW5fIRFqKp9pKVP1l/uj8JrHNMXDxpX8k3WcPsv
	h7DGa9LY3qTYRjVwG/Q3BGDlrH8SFmGieQNlpG8Ufgqd1ozS8Uk0V1G4AiGoDEXBaT/7sd
	CN8w5/Du1o6SjPkNEfk69eTzhbccjDI=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGK2g-00FScM-Dl;
	Mon, 12 Oct 2026 13:42:30 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] xarray: unlink a node before freeing it
Date: Mon, 12 Oct 2026 13:42:29 -0400
Message-ID: <20261012174230.772325-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF7D120003
X-Rspam-User: 
X-Stat-Signature: gxcmctmk5y3kakog1473t559h3mnxbi1
X-HE-Tag: 1791826960-241785
X-HE-Meta: U2FsdGVkX18WLrPZKApC6Eh4nA3Kwn8RNXzEU6fc5eaNKAAAdG6YODMkWTjEjNfzOj/4wegPHdgM4FJy0OJuRNvmTBxvSDvPz4t/5IM4hJsywrGhfbhXu7YXy7BTFrIge/YLgbCscXBLbzPkSCZbuNxRmsPdpxh33DLQ5fXL8tvBP7+CNaKUzBqEm0ueb45rdPbvyMF0gww9cu8EW0MClMPkQe5qoMcQVvRNwGjJAPjR+PLlmWYr6fxO+jHbYHS+slJYeQ3yuUVny6jJlmPoSX2Mb+1TiyYPJDdivbEa8kKeC6wzsjoGds/4s3TYDA6bvEZf8D7Avzcr/XOGW3oMxKdyLW8UG0vIKBXEqp2qk1FhIwckBVbCXXCraiHt/X96WRgc3jbDr2gNMJpfaWM3cghmZcrewN84upLtBt+22KHBe+RhKvsRO0GSkgoKWiipDu9PWoyLr2+NqXnNngJOCUta7M0A/b+2e0z+YZvZVDEwv2zgwGOEoIgWBdUJwqq2kmsWleNd6gGciXygPBvBWqyuY9u8LP14ut9yqR82jv36pn980Pnex99IwECvc5XMWAd6z5iy2Gzw2NYTR+/M7zVpFePSwFde3aJlQxscn/AJ6WTxoObOoLVp/9ftjJvaRwLG/IOh9RZOJCIUpoHqwh5PfR6dFMvjRxms581AMMWUu6otGxNJgWAGp2PxLWcIezO68C9uA9ROip81k1pjzMmVKwVNopFSTHmBkm1mL6yow0XQOHlKRTCvo+5U5qy3kxgip0ognygn2B2/BMArcn5b8RCUDcRI3SbCpvAewRyxQ25L9rFTms/omBh39B3IfrGfaJE1WP3+tRzwvX2BEuJeA6fuc2Hd89EDkMMFHWM/mNzWzc5hWmIbL1O8RGzyUc89fPxTVdLzGcO23pCkZzJvP/GXreSMpL//lBRN+gqPFW/Ho40jNwVwLOHNQhFAOpHiheL8qILGyz5yENe
 370S7M1U
 AVaoz5gydFy0AkvkmmM11Pnz3WnRbx+qhL+zsBDPFLnUYze7yNX9pX9WamVWvHEgEoH03Yj6nIhEBBShxI/oMpcU4TvIbld8YlkdBxjiavr8U5Wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xas_delete_node() passes an empty node to xa_node_free(), which queues it
with call_rcu(), and only then stores NULL over the pointer to the node,
in the parent's slot or in xa_head.  Between the two, a lockless walker
can still reach the node, and RCU does not protect it: call_rcu() waits
only for the read-side critical sections that were running when the
callback's grace period started, and that grace period can start before
the store that unlinks the node.  A walker that begins its RCU read-side
critical section after that point can load the old pointer and keep
using the node after it has been freed:

  CPU 0: xa_erase(), xa_lock held   CPU 1: RCU walker, e.g. xa_load()

  xas_delete_node()
    xa_node_free(node)
      call_rcu()
                    <grace period starts>
                                     passes a quiescent state
                                     rcu_read_lock()
                                     xas_load(): parent->slots[offset]
                                     is still node
    parent->slots[offset] = NULL
  xa_unlock()
  quiescent state
                    <grace period ends>
  radix_tree_node_rcu_free(node)
                                     reads node->shift, node->slots[]

The grace period does not wait for CPU 1: CPU 1 reported its quiescent
state before its critical section began.  Holding xa_lock does not help
either.  It makes CPU 0 an RCU reader, which delays the end of the grace
period until after the unlinking store, but not its start.  The start can
fall inside the window whenever the callback is assigned to a grace
period before the unlink: from call_rcu() itself when many callbacks are
queued, from an interrupt that arrives in the window (interrupts are
enabled under xa_lock(), and RCU core processing and the other softirqs
may run on interrupt exit for milliseconds), from the rcuog kthread on
another CPU when callbacks are offloaded (rcu_nocbs=), or while the
writer is preempted under PREEMPT_RT.  Interrupts, and in a guest a
preempted vCPU, also stretch the window.

Setting node->array to XA_RCU_FREE does not make walkers retry: no
lockless path looks at node->array.  xas_load() and xas_descend() look
only at the entries and at node->shift, and the marker is overwritten
when the slab reuses the object.  The XA_RETRY_ENTRY markers that
xas_shrink() and xas_free_nodes() store only help walkers that reached
a node before it was unlinked; the grace period waits for those because
both functions unlink before they free.

radix_tree_node_cachep is not SLAB_TYPESAFE_BY_RCU, so the walker reads
freed memory.  Once the object is reused for a node of another array,
the walker can descend through the wrong node and return an entry of
the other array.  In a page cache lookup, the xas_reload() recheck in
filemap_get_entry() reads the same reused slot and accepts the result,
so in the worst case the lookup returns a folio of another file.

The order dates from the introduction of xas_delete_node() in the
commit below, which reimplemented the radix tree's delete_node().
delete_node() unlinks first and frees after, and still does in
lib/radix-tree.c, as do xas_shrink() and xas_free_nodes(), the other two
paths that free nodes in lib/xarray.c.  The commit gives no reason for
the different order and nothing depends on it: xa_node_free() only marks
the node and queues the callback, node->offset is read before the free,
and the stores and xas_update() on the parent do not involve the node.

Move xa_node_free() after the store that unlinks the node, in both
branches.  The stores and their order are unchanged, nothing reads the
node after it is freed, and every caller sees the same tree and the
same xa_state.

The radix-tree test suite already runs into this.  Its multiorder test
(multiorder_iteration_race(): one thread inserts and deletes an entry at
index 0 while the others walk the array under rcu_read_lock(), with
liburcu's call_rcu()) reported a heap-use-after-free in xas_start(),
reading the shift of a head node freed through call_rcu(), in 10 of 200
unpatched runs under AddressSanitizer on a 160-CPU machine, and in none
of 200 runs with this patch.  A harness check that no node passed to
xa_node_free() is still reachable from xa_head fails 556941 times in the
XArray tests without this patch (all in xas_delete_node(), both
branches) and never with it.  No test is added: the race is not
deterministic and the check needs a hook on xa_node_free().  On a
kernel, the window is too short to hit on demand.  With a 100 ms delay
injected between call_rcu() and the unlink in a test build, a lookup
that starts on another CPU 20 ms into the window reaches the node, and
KASAN reports a slab-use-after-free of the radix_tree_node freed from
rcu_core() when the lookup reads it again.  With this patch and the
same delay between the unlink and the free, no lookup reaches the node.
The XArray and IDA self-tests pass on x86_64 and riscv64.

Found while formally verifying xas_store() against the kernel binary.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproduction details: the harness numbers come from
    tools/testing/radix-tree built as is (AddressSanitizer is on by
    default), running ./multiorder 200 times on master and on master plus
    this patch.  The ordering check wraps each xa_node_free(node) call in a
    copy of lib/xarray.c with a function that walks the tree from xa_head
    and reports the node if it is still reachable; it is not part of this
    patch.  The kernel demonstration is a test build (x86_64 defconfig +
    KASAN, QEMU -smp 4) with mdelay(100) after xa_node_free() in
    xas_delete_node() for one test array, a writer kthread on CPU 0 doing
    xa_store()/xa_erase() and a reader kthread on CPU 1 doing
    xas_load()/xas_next() under rcu_read_lock().  I can send any of these
    if useful.
    
    The patch and its analysis were drafted with an LLM coding assistant
    and then reviewed and tested as described in the commit message.

 lib/xarray.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..d48754c5f8b8 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -500,17 +500,18 @@ static void xas_delete_node(struct xa_state *xas)
 		parent = xa_parent_locked(xas->xa, node);
 		xas->xa_node = parent;
 		xas->xa_offset = node->offset;
-		xa_node_free(node);
 
 		if (!parent) {
 			xas->xa->xa_head = NULL;
 			xas->xa_node = XAS_BOUNDS;
+			xa_node_free(node);
 			return;
 		}
 
 		parent->slots[xas->xa_offset] = NULL;
 		parent->count--;
 		XA_NODE_BUG_ON(parent, parent->count > XA_CHUNK_SIZE);
+		xa_node_free(node);
 		node = parent;
 		xas_update(xas, node);
 	}

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


