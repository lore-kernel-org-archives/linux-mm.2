Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BFF606A327
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 01:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60116B00D4; Fri, 23 Oct 2026 21:43:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D119F6B0848; Fri, 23 Oct 2026 21:43:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A686B0BBA; Fri, 23 Oct 2026 21:43:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E9B46B00D4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 21:43:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6C5AEA0261
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:43:57 +0000 (UTC)
X-FDA: 85355823714.23.42B138F
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3334C0002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 01:43:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792806235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wyVREYXOxjrzUhwVsdrv5z52bG4LokTjT1gazbHkJ+o=;
	b=aZgM2e1EowpbRHh6TQze49hiL/MjMVKDLYfj0okFLMjBApWj/yEE9+OATc/4YiN1dFoxfN
	1z+9LHtg1Daky6r+QwZnKRxzteKWUGj9elRjGxGPBtafqYEiBVIgU/6dGWkfeduwWRahcL
	OFZOWoU45Yf8CqAWPDUTRScwkWd8R+0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf22.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792806235;
	b=dJI0gHU9O6GMPU8BK0j2beb+UNy30Ir9Cd+aD4+WtDPXYocjeUoiTKafRav7f/dAZY2nIQ
	878RjRd5WHmCJRkpJR1FYS/mXZf+NGrWFOnKQ3U36vz8qR81q9FjcCPHeK243Pw/qHOq8R
	8WMBoEIZ4Pv7tQwLAMeMVA5RYZiAeR0=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xKQnR-00DwZT-3H;
	Fri, 23 Oct 2026 21:43:45 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baoli Zhang <baoli.zhang@intel.com>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v2] xarray: initialise the offset of a new root node
Date: Fri, 23 Oct 2026 21:43:44 -0400
Message-ID: <20261024014344.830116-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261012181107.772545-1-nickolai@csail.mit.edu>
References: <20261012181107.772545-1-nickolai@csail.mit.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3334C0002
X-Rspam-User: 
X-Stat-Signature: 1em3y6wp5hchdtfi7rjf41dsogd38h8j
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792806235-138136
X-HE-Meta: U2FsdGVkX1+O/xp/1euqyXtul7UnlnmDP72wD+riqI6elLBzf2KN9/OSixyvWMjAQEQ5lTscwmw7HY+zz+W/LnHktG/GrHKtUZCN4QEzwGmGe3AyJZubSDG8/ylhw6BFlc3Q/akyD87+UAR1yzsQndPAV/609bor5I06ZJhm7kOlrO9LLN5GnkOXTaZzhRDnAEuS0sWOJFr7lxXzFttDWHVmuDCs/uNJUk1ufHq+ccgk+zlFCFDu5/vaYd1lUkiwe6vEyj3xmLv+WYXIdTuB1Xa+BniYgL7aV6Iak5T8jpPmx1VB6LhECj58TaLitbOyhGtUUlky8WgEGFemyv2tmR977wtloda/fcxY3Om5zW8u8deZcmXhTjAg4G/IgzCESKZBUyY4Wny0ULDmh636hwrnxeHNcec09PWL6BELzVh0gS2EXK84Zg1JgIK/YtAT1fPiyDEwce8uZaumwg5vkzBRz0dYvcC8b/59H/LowsEHfRygPuRxS9/oWrKMq6XCuOvzKTz7M8rMdY5S5EKYGJkvr143ddpfU0h8qreb3Rei8q1dXbe9SOInU/NT5S3aHwidDeaCt6QYj2Qi3qKnI8xFvTulL5Yz4lo98A9qfOPpSzpaj16dR0/m8D+U9AtN0mHdGuork0J0ZGLCiTtWPIdLCE/nJrbo4++eKbO3IR0Rzmap5rSHXxnYHUa+fNbzD/YslbEq+06sgdZs3P/l9rZJdl2ejpBNMNMnS4LbH2Zm+LZUwolkQg/0G0haRl6GH6OXnCh7aCr/Z+o7XCtHzoEyUlHuSCATt8j3hXed5ZBMLaJwAN6WuDqbUhzcQYvTBveYpEQB7kkOAfEVPUNRLFM7RTDN9uNc8V6frfpotudfg/cnmhZYYkCivaWMLArySCKIyDLFRBWbydglrssyO6Idn5PPMqhwjibSW/ZESlqVU/r5iLWpz3+p5lg/xoQ2QfhHtjzJByP7Iy5UQMH
 4IO7fBpm
 nLC9lwo/Ed4OdDxKg1e7xzQx1fkW+MfUo1jku9RaSp7QrW7HQSLLINTCAtAvV2FpDo4IYxGUiJaNC98PM7uC78BM50Sv3QDst6+YujQLkOp1uCT/rObZRy5nGdaGCrumynXPyCsnPQsI3p6YVHn73DoVpJYIstEOQ41pwoY25nsai0R9eJoY/xNnCJgSZe18hkOlMmLGZVNoo14QBPoRNgg9Ts0PB9xmNvBq4UOs2R1sulukBe/TxdEXWfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An RCU walker such as xas_find() that climbs out of the root while
xas_expand() adds a level above it can resume in the new root at the
wrong slot and return an entry with the wrong index.

xas_alloc() sets node->offset only for a node with a parent, so a new
root keeps the offset its slab object had before.  xas_expand() stores
0 to the old root's offset just before linking it below the new root,
and a walker can load the stale offset before that store and the new
parent pointer after it.

Set the offset of a node allocated without a parent to 0.  The store in
xas_expand() then writes the value the old root already has, so remove
it.

Fixes: 58d6ea3085f2 ("xarray: Add XArray unconditional store operations")
Reported-by: syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=73641b60a3bc11dfca8c
Tested-by: Baoli Zhang <baoli.zhang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Changes in v2:
    - The test uses XA_BUG_ON() instead of a new XA_WARN_ON() (Matthew Wilcox).
    - Remove the store to the old root's offset in xas_expand(), which now
      writes the value already there (Baoli Zhang).
    - The first root in the test now comes from xas_create(); in v1 both
      came from xas_expand().
    v1: https://lore.kernel.org/all/20261012181107.772545-1-nickolai@csail.mit.edu/
    
    Setting node->offset = xas->xa_offset for a root too does not work:
    xas_set() keeps xa_offset, so a loop like the one in check_xas_erase()
    (xas_set(&xas, j); xas_store(&xas, ...)) grows the tree with the offset
    of the previous index.  In the XArray tests 2929 of 104963 allocations
    without a parent see a non-zero xa_offset, and with that variant
    check_xas_erase() fails.
    
    The syzbot report is this race seen by KCSAN: xas_expand() changes the
    old root's offset from 3 to 0 while xas_find() reads it.  After this
    patch xas_expand() no longer writes it.
    
    Reproducer (tools/testing/radix-tree with a hook in xas_find() between
    "xas->xa_offset = xas->xa_node->offset + 1;" and the xa_parent() load:
    "if (xa_climb_hook) xa_climb_hook();"; add "rootoff: rootoff.o
    $(CORE_OFILES)" to the Makefile):
    
    #include <stdio.h>
    #include <linux/xarray.h>
    #include "test.h"
    
    extern void (*xa_climb_hook)(void);
    static DEFINE_XARRAY(tmp);
    static DEFINE_XARRAY(xa);
    
    static void expand(void)
    {
    	xa_climb_hook = NULL;
    	xa_store(&xa, 6UL << XA_CHUNK_SHIFT, xa_mk_value(48), GFP_KERNEL);
    }
    
    int main(void)
    {
    	unsigned long index;
    	void *entry;
    
    	rcu_register_thread();
    	radix_tree_init();
    
    	/* free a leaf that sat in slot 5 of its parent */
    	xa_store(&tmp, 0, xa_mk_value(0), GFP_KERNEL);
    	xa_store(&tmp, 5UL << XA_CHUNK_SHIFT, xa_mk_value(0), GFP_KERNEL);
    	xa_store(&tmp, 7UL << XA_CHUNK_SHIFT, xa_mk_value(0), GFP_KERNEL);
    	xa_erase(&tmp, 5UL << XA_CHUNK_SHIFT);
    	rcu_barrier();
    
    	/* the new root of xa reuses it */
    	xa_store(&xa, 1, xa_mk_value(1), GFP_KERNEL);
    	printf("root offset %u\n", xa_to_node(xa.xa_head)->offset);
    
    	xa_climb_hook = expand;
    	xa_for_each(&xa, index, entry)
    		printf("index %lu entry %lu\n", index, xa_to_value(entry));
    	return 0;
    }
    
    $ make rootoff && ./rootoff
    Without this patch:       With it:
    root offset 5             root offset 0
    index 1 entry 1           index 1 entry 1
    index 8 entry 48          index 48 entry 48
    index 48 entry 48
    
    Tested with tools/testing/radix-tree and with test_xarray built in on
    x86_64 and riscv64 under QEMU; without the lib/xarray.c change both new
    checks fail.
    
    The analysis, the patch and the tests were done with the help of an AI
    coding assistant.

 lib/test_xarray.c | 33 +++++++++++++++++++++++++++++++++
 lib/xarray.c      |  6 +++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 5ca0aefee9aa5..046abad609648 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -370,6 +370,38 @@ static noinline void check_xa_shrink(struct xarray *xa)
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
+	XA_BUG_ON(xa, xa_store_index(xa, 1, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_BUG_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	/* And so must a root created by xas_expand() */
+	XA_BUG_ON(xa, xa_store_index(xa, XA_CHUNK_SIZE, GFP_KERNEL));
+	rcu_read_lock();
+	node = xa_to_node(xa_head(xa));
+	XA_BUG_ON(xa, node->offset != 0);
+	rcu_read_unlock();
+
+	xa_destroy(xa);
+	xa_destroy(&tmp);
+}
+
 static noinline void check_insert(struct xarray *xa)
 {
 	unsigned long i;
@@ -2235,6 +2267,7 @@ static int xarray_checks(void)
 	check_xa_load(&array);
 	check_xa_mark(&array);
 	check_xa_shrink(&array);
+	check_xa_root_offset(&array);
 	check_xas_erase(&array);
 	check_insert(&array);
 	check_cmpxchg(&array);
diff --git a/lib/xarray.c b/lib/xarray.c
index bfe7bef80f34e..1e2380e3194d6 100644
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
@@ -616,10 +618,8 @@ static int xas_expand(struct xa_state *xas, void *head)
 		 * Now that the new node is fully initialised, we can add
 		 * it to the tree
 		 */
-		if (xa_is_node(head)) {
-			xa_to_node(head)->offset = 0;
+		if (xa_is_node(head))
 			rcu_assign_pointer(xa_to_node(head)->parent, node);
-		}
 		head = xa_mk_node(node);
 		rcu_assign_pointer(xa->xa_head, head);
 		xas_update(xas, node);

base-commit: 26344c0dd32af8790d8474d233619db825441138
-- 
2.53.0


