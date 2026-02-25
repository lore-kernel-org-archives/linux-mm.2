Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136E0F357D9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C186B0088; Wed, 25 Feb 2026 02:17:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D9146B008A; Wed, 25 Feb 2026 02:17:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523216B008C; Wed, 25 Feb 2026 02:17:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6B76B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:17:30 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D24EE1B6C3E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:17:29 +0000 (UTC)
X-FDA: 84482123418.30.649EF2D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A332120006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:17:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeZRIzmg;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772003848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rG+b8/+can7Q58VDOAAydD277OLHsbwrqz0TrhL3A8A=;
	b=KDHMVamgWmdMnoImA+yXmu8hv5UT0FG/N4lOjZW2Irs3BMx9qv5cjJ1Xk0AkRDk27/rwqK
	IGxGlhnLn/fNjBCWHW7uNBX3G+Jnp/zL/LTL5MqJ/+Ny2f+EU/AdfNqk0aJROezvAihzo0
	7g/noGL0j4NOjqwV/ZoHX4JrFzqCHRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772003848; a=rsa-sha256;
	cv=none;
	b=s24R1t4uu8uKYVdVYNiaVuojrM2wIYyAuEp90FQXmF2CO+D3vXJ0h3sPqPjUspEzcVF0zP
	9GDYERtMs3/Lmsy4TVLhaI0vnQOHLU7QdllM0rYbS0nNY2APwt0UdYJL+wtQmN56mBkJT0
	tayLIbOVnoEQ/GLIfMHHTap6rgP56lw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xeZRIzmg;
	spf=pass (imf29.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772003845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rG+b8/+can7Q58VDOAAydD277OLHsbwrqz0TrhL3A8A=;
	b=xeZRIzmgu6uoFXLEXLQ5cUpGo9+vHYhjPw+MJa7/Tvk0waDx83N8W1wSQoOwxWHq9mMjp3
	iPO/tJ20ahHiu56yOqX3DcVrHXEVkX2yJNw5N6Be4aYd4BdEvNPgISfP0CE+GrkMiUQLzr
	gfbHN0cpSv+iH1Hzyi64scd3pwqoIFs=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: willy@infradead.org
Cc: linux-mm@kvack.org,
	jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	syzbot+006987d1be3586e13555@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] radix-tree: fix memory leak of intermediate nodes on insert failure
Date: Wed, 25 Feb 2026 15:16:18 +0800
Message-ID: <20260225071623.41275-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: m1stuwf96bs1jka56rx91i83juorwed8
X-Rspamd-Queue-Id: 2A332120006
X-Rspam-User: 
X-HE-Tag: 1772003847-196824
X-HE-Meta: U2FsdGVkX19uwfKwowUa5osc+c5XtmDcXZI6fYvMyIqhVt9lPaBvv/fUznbgGrxGZgNYN8uBbzzajiM1MzNezx2UZIsdfDGNOOi010tKwuifztngvexYrMYNNd+1pa3ChJQp13hP7xAGYCxRJX90sDbJ1JBTcRid8Og6wkWC00OW5EnA8wqph+U9t8boeRSxTUsr4tHdwiEj8bdhLd5DFXgSUF6sxjVv6o+sXLnBBALLzBv2WB1ZHlxA2kg6RjKZfByhxeroOkMkV6yxi93NCBkcNtfYPAUaizRtjPjZ238OKgarKsnvXG3hmUELebGa7EeLYtwvlX0PbN3e7ouecCR52lFe0OK6cfSOs6J9Zm3anMmIz5dazFSmVb7d1P7cV//md9dO8sHCXFu6o6ESEcYpy7cfFOHuip91wS/ssvx1IzyGg9F6Iwu+If15rAmLJvu0XMrot5Xl728R6RXvfv38D7IcUAR0F4E0hkztnLixA6dCAGPUzKIJ1MRMD8Rp2iq/UQI0Rzsgx1bJSN+G7APMQtd+rXEViECJeHO1XUJ2YSDqnebeyOrKUWuBM7TShEwEy9dyji1snl24cQ9z8hYsLNUFWJhoKHAQpOy7WJDFZTzgbNvQkM1DNrSERISTd2/iJeN08ilFsDCU68fBEIQLC9KL3KEJFwltD/iMV7CPtD2L4sVfmsplM6Nn8RPP1ITlpYMqKO5nhjsm7SqfoWx4bqJndTRZX0pvTMqtxvgnb9FnpSbURuHnCmhCJ+AQ98KMrDbjiuWwGCS5igi6yu/PaXq4kKYV9DBH/p75ZI7WfQ1v1xf62KF4SaPeOlP54ICk3Nj9Y9wW1k0smqx4e3jruHV6Mmf3kH+UujNYOkwBcJ2SCG/m0aEIFHHJ+6P2Y0YdoreZwqnb+8ygSlkButTUZ3P2aGcnhb8ordetTHvgfODDxTCe1gtRj912YPbF16o/abL67dP7VPp8X72
 6FjghnsA
 ocM2wO95vH4qlTZSwD7XccRru7ru9kCAUeLw5gELl8va78+p++Gwq0uRm4ZRtgC4f2eNMn0qPPa3xOHzaFIHiFetz8ZaYzkBtDCL3AFTIsAnG7iPUeLkUO3EYKk3piX0LjeFfc8oPTchksw5oDNpL2ZKiuAvFZlqhIwamfWu31MB18vDGh5I21gTnQnTktTsQez1lL4eqN9uNjMrkq9gRfZQC65iiB7rgyuPpcykRhzdhvJJDUfY375Na61ZwdwqDUhoyFrifAex4UYUEZW6WFYCpQKcttE93Sr1iEX1ML3mTwIcqm+lI+o6BMu/UVee4dziAMU4JTcEJOpxDeBJxsVEq/fVq2rkKWPtozCigXH2qMhgFmxP7ddZ5RO4oLFu3RGa/7tb+p9lEWBAFyHwCGoxf5aLvqknQJl5qPmgvhnNGGVjIRfmlEQZogc2sNomMdVgsQwfNkDQiBZtzjYctR9idsAlCDJgWUpeJlxg6oiiFJmxxk+WhB5oW1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

__radix_tree_create() builds a path by allocating and immediately
linking intermediate nodes into the tree one by one.  If an allocation
fails partway through, the already-linked nodes remain in the tree
with no corresponding leaf entry.  These nodes are never reclaimed
because radix_tree_for_each_slot() only visits slots containing leaf
values and there is no radix_tree_destroy() to walk all structural
nodes.

The natural alternative—migrating callers to xarray and relying on
xa_destroy()—does not cover global or long-lived trees whose lifetime
is tied to the system.  xa_destroy() is never called for such trees,
so orphaned nodes would persist until reboot.

Fix this directly in __radix_tree_create() by tracking the first newly
linked slot.  On allocation failure, sever the partial path with
rcu_assign_pointer() and free the orphaned nodes via call_rcu() to
maintain RCU safety for concurrent readers.

Reported-by: syzbot+006987d1be3586e13555@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000bfba3a060bf4ffcf@google.com/T/
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 lib/radix-tree.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 976b9bd02a1b..2bdf2be71b95 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -600,6 +600,11 @@ static int __radix_tree_create(struct radix_tree_root *root,
 		void __rcu ***slotp)
 {
 	struct radix_tree_node *node = NULL, *child;
+	/* Track newly allocated nodes for rollback on failure */
+	struct radix_tree_node *new_nodes[RADIX_TREE_MAX_PATH];
+	void __rcu **first_new_slot = NULL;
+	struct radix_tree_node *first_new_parent = NULL;
+	int new_count = 0, i;
 	void __rcu **slot = (void __rcu **)&root->xa_head;
 	unsigned long maxindex;
 	unsigned int shift, offset = 0;
@@ -623,8 +628,23 @@ static int __radix_tree_create(struct radix_tree_root *root,
 			/* Have to add a child node.  */
 			child = radix_tree_node_alloc(gfp, node, root, shift,
 							offset, 0, 0);
-			if (!child)
+			if (!child) {
+				/* Rollback: sever and free all newly allocated nodes */
+				if (first_new_slot) {
+					rcu_assign_pointer(*first_new_slot, NULL);
+					if (first_new_parent)
+						first_new_parent->count--;
+					for (i = 0; i < new_count; i++)
+						radix_tree_node_free(new_nodes[i]);
+				}
 				return -ENOMEM;
+			}
+			/* Record first new slot and parent for potential rollback */
+			if (!first_new_slot) {
+				first_new_slot = slot;
+				first_new_parent = node;
+			}
+			new_nodes[new_count++] = child;
 			rcu_assign_pointer(*slot, node_to_entry(child));
 			if (node)
 				node->count++;
-- 
2.43.0


