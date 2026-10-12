Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E6C5CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 20:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7726B008C; Mon, 12 Oct 2026 16:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA79B6B0092; Mon, 12 Oct 2026 16:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95F16B0095; Mon, 12 Oct 2026 16:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9BB6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:25:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00559120AC6
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:25:56 +0000 (UTC)
X-FDA: 85315105554.20.8A5C4E4
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65BA940007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:25:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791836755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=wyujS2F1YPxobidRaUqN4+5AemFYgMf7oibXL5d98GI=;
	b=uYUOm1N78SjRG3RRIbuzgiWCLrDg6pciva0Q8D41SiPVFAB23dsyGNjKUALBZjRecTOSjp
	QVoBmX6mwwvtlS65xBRKfUqZdlMwW01hZCx31Ca45dibh0MaNlRaloJHoflhWRL4+R1VL2
	s1orRDaNFigKuHc5/ZFdagBfHWFXOK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791836755;
	b=kzRD5gERjVe/lS69ImP+EZSMGV+VG4oNn8y9UX5owbnPzngstlWJnPXxbJfY3mc/msysY/
	qWfXflEORLBtkCIxfZZYz3IEWqOxT+GqLZEUjghRBPKlFx+pNycgoW05govcK397LTkzIn
	K05MhnvSTeoOCGpzcrjFggYvIUq6mBA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGMaj-00Fxjz-RA;
	Mon, 12 Oct 2026 16:25:49 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] xarray: clear the new head's parent before freeing the old head
Date: Mon, 12 Oct 2026 16:25:49 -0400
Message-ID: <20261012202549.772887-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 65BA940007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4xtorbno8qys3w1qbgrozpfiqk4cfmzg
X-HE-Tag: 1791836755-914310
X-HE-Meta: U2FsdGVkX18TxcS7ufgDJXeh9ll6ybpPqsreodjl3c0HivB0G7L9elIu5Zq7mF8sYv0VXtq4ygH5lG8U3hQE9eHP92Ei8Elz9aGq6bdHmaXYTHz54OIql5WP6HVkhxowlkXphaDcIjb5K+6TMOY5RRZmin+Ff33l76HsfXB3PQpl8IWaf5Poj6+cIh+OxiwjC42Fv0M055lIIdMNguImjSuWVR4bLfLmWN7ZooeutAzc4CX81buFkP5ww+dvi6SfH+AOIwKT+7bJH05PmeBJuWn7m+cG30sv226ruIUL8RnUH+sIOP13RdZwp6LdJw6VqNIc6T0jQqR8o6VgeTWkDS/gTX70L7sTXxzJa20xayJPs1IUJF8+OfIHLDjcddU2LmysAc3FUQoxlyZLA3NDtuvOS6+KFh99GBzSejc5WcDK1WGxDjNkpCDUhK1XPmCVkLDofi4Of9P/bLRzeyjEMRr0sfUF6tZQCoyew4LpIkNm6nr95BDLM7i5X318ckbNN3yKklga15jnHjzLXKOebS6siYHVyyogNNgv9Wp4XmjYJH2G3XlHH8+Z7Nl2bcv96YyvcD8464odV9xdNKItXbWWrsv8UEg+ODeL8p6G28a0tTHpn4vfej433gKHUoIfvhIeAhR1n07AdAlxfTVnKJYiBPBXcuLsikR2RJeFykahxmKI6ZM+l3Wi+Bt1B85UMkhnE91Fb5H7aiLQaz8/3tx9zzlDp8VBTgC/B/DgooOuvcIEJ+zpMkEvZOL7iLBi6/xwk0kV9eSIySGmR6v1Mat0DkL+9RPrw9RayPehS3lD7MuUEu9sXU9wHZch5TlQvAkYotu651sGppTWcJSuQquQzhKc3x7DycpmHBZetJaCw22JeE920HiscyCDfL4VEwKXiBzFnStDCcvjloiNP8qjb1knQabQ7CKEtQZtuihygqOKD5vFQkio6u7WST67jLW338wk46mBz1Ix+Z7
 ddbAbZuY
 MomgfahSUMvbZ95j9vqqWACHfnWtdxMm1Ly0e8kCQScuLWFoSXSUUjFiqaT8VO5qUHHy7JAMQ9KI/ztZw2VF1rpeIAdLw7L2e7KyiBAMX5GbmKEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When xas_shrink() replaces the head node of an array with the node in its
slot 0, it stores the child in xa_head, passes the old head to
xa_node_free(), which queues it with call_rcu(), and only then clears the
child's ->parent pointer.  In between, a lockless walker can still reach
the old head, not from xa_head but upwards from the new head:
xas_find(), xas_find_marked(), xas_next() and xas_prev() climb through
xa_parent() when they step past the end of a node.  RCU does not protect
a walker that gets there: call_rcu() waits only for the read-side
critical sections that were running when the callback's grace period
started, and that grace period can start before the parent pointer is
cleared.

  CPU 0: xa_erase(), xa_lock held   CPU 1: RCU walker, e.g. xa_find()

  xas_shrink()
    xa->xa_head = child
    xa_node_free(old head)
      call_rcu()
                    <grace period starts>
                                     passes a quiescent state
                                     rcu_read_lock()
                                     xas_find(): loads xa_head (child),
                                     steps past its last slot,
                                     child->parent is still old head
    child->parent = NULL
  xa_unlock()
  quiescent state
                    <grace period ends>
  radix_tree_node_rcu_free(old head)
                                     reads old head's slots[], shift,
                                     offset and parent

The grace period does not wait for CPU 1, which reported its quiescent
state before its critical section began; holding xa_lock delays the end
of the grace period, not its start.  The start can fall inside the
window when an interrupt arrives in it (interrupts are enabled under
xa_lock(), and RCU core processing may run on interrupt exit), when
callbacks are offloaded (rcu_nocbs=) and the rcuog kthread on another CPU
handles the callback, when many callbacks are queued, or while the
writer is preempted under PREEMPT_RT.  Interrupts, and in a guest a
preempted vCPU, also stretch the window.

After the climb, xas_find(), xas_find_marked() and xas_next() resume in
the old head at the slot after the child and read its slots[] and shift
(xas_find_marked() also its mark bitmaps); xas_prev(), for which the
child is the first slot, steps past the old head at once and reads its
offset and parent, as the others do when they reach its end.  Nothing in
the walk notices that the node is gone.  The climb takes ->parent as it
is, no lockless path looks at node->array (XA_RCU_FREE), and
xas_shrink() stores XA_RETRY_ENTRY in slot 0 of the old head only when
the head shrinks to a single entry, not to a node; the walker does not
look at slot 0 anyway.  radix_tree_node_cachep is not
SLAB_TYPESAFE_BY_RCU, so the walker reads freed memory.  Once the object
is reused for a node of another array, the walker returns that array's
entries or descends and climbs into its nodes.

The order dates from the introduction of xas_shrink() in the commit
below, which reimplemented radix_tree_shrink().  radix_tree_shrink()
clears the child's parent pointer before it replaces the head and frees
the old node, and still does in lib/radix-tree.c.  The commit gives no
reason for the different order and nothing depends on it: xas_update()
and xa_node_free() only touch the old head.

Clear the child's parent pointer before freeing the old head, as
radix_tree_shrink() does.  The stores are the same, the tree and the
xa_state the caller sees are the same, and a walker that starts after
the callback's grace period has begun sees the cleared pointer, like
every store before call_rcu(), and ends its walk at the new head, which
covers every index that the old head had an entry for.

A check in the radix-tree test harness that no node passed to
xa_node_free() is still the parent of a node reachable from xa_head
fails in xas_shrink() 4731 times in the XArray tests without this patch
and never with it.  No test is added: the race is not deterministic and
the check needs a hook on xa_node_free().  A harness race test (readers
walking the whole array with the four climbing walkers while a writer
stores and erases an entry that adds three levels above the leaf) did
not hit the window in 20 runs of 200000 erases; with a 1 ms sleep
injected after xa_node_free() in xas_shrink(), every one of 20 runs
reported a heap-use-after-free in __xas_next() or __xas_prev() under
AddressSanitizer, and none did with this patch and the same sleep.  On a
kernel (x86_64 defconfig + KASAN, QEMU), with a 100 ms delay injected at
the same place, a walk that starts on another CPU 20 ms into the window
climbs to the old head in each of 20 rounds, and KASAN reports a
slab-use-after-free of the radix_tree_node freed from rcu_core() when
the walk takes its next step; with this patch, the walk ends at the new
head.  The XArray and IDA self-tests pass on x86_64 and riscv64.

Found while formally verifying xas_store() against the kernel binary.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproduction details: the ordering check wraps each xa_node_free(node)
    call in a copy of lib/xarray.c with a function that walks the tree from
    xa_head and reports the node if it is still reachable or still the
    ->parent of a reachable node.  The harness race test links a copy of
    lib/xarray.c with a hook right after the xa_node_free() in xas_shrink()
    that sleeps 1 ms in the writer; 32 threads, liburcu-registered readers.
    Without that sleep, this patch alone still showed a use-after-free in 3
    of 20 runs; those come from the xas_delete_node() bug (the race test
    also erases nodes), and with both patches 20 of 20 runs were clean.
    With only the xas_delete_node() fix, the sleep still gives 20 of 20
    failures.  The kernel demonstration is a test build with mdelay(100)
    after xa_node_free() in xas_shrink() for one test array, a writer
    kthread on CPU 0 doing xa_store()/xa_erase() and a reader kthread on
    CPU 1 doing xas_load()/xas_next() under rcu_read_lock().  The window
    has not been hit on an unmodified kernel.  I can send any of these if
    useful.

 lib/xarray.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34..ae9d7fc68861 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -471,11 +471,12 @@ static void xas_shrink(struct xa_state *xas)
 		if (!xa_is_node(entry))
 			RCU_INIT_POINTER(node->slots[0], XA_RETRY_ENTRY);
 		xas_update(xas, node);
+		if (xa_is_node(entry))
+			xa_to_node(entry)->parent = NULL;
 		xa_node_free(node);
 		if (!xa_is_node(entry))
 			break;
 		node = xa_to_node(entry);
-		node->parent = NULL;
 	}
 }
 

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.53.0


