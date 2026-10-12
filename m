Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCB7CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 23:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89D1D6B008C; Mon, 12 Oct 2026 19:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D646B0092; Mon, 12 Oct 2026 19:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763466B0095; Mon, 12 Oct 2026 19:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7456B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:59:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25F8CA0BD1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:29 +0000 (UTC)
X-FDA: 85315643658.04.FE89F1B
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6DE171C0007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:59:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791849567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dj1hbJqvSWakz+BZpqYMLuV/1yagpDmOSIsy4UWm/Cg=;
	b=O8HrYUA+C4M2lsARfEfjZjVvP+SlRtDJF6WS7DlewVi2l6ZJONhuOph9wYKS0pAUkV+1WO
	1oC/rRi1gcVzPmi4b+2LV/3WPJu3GLmV8Ryc1jdgCfRjnqk8ZoB1Du19a40GU5ATLYkhvG
	g9mMpAtEf6DXGmzTPItzrMW7o/xeQDY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791849567;
	b=5VWRGoqzxxkdnYwub4w0w+woWdrqgBovO9oTmbwXaG32ieDvTVySOA1/kEatQLMTj6CWPs
	BGTVoCw2pxb9yPkdKC2p6IeCYNJZqD74tzDwNlDGRzcZYUJbhNbYQ18g9oDRnOnA+JREpG
	6blHXkIK7dw4rAG5tc0yTPkeslJSW9s=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGPvK-00GbRU-N7;
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
Subject: [PATCH v1 2/2] maple_tree: remove the late metadata clearing from mt_destroy_walk()
Date: Mon, 12 Oct 2026 19:59:18 -0400
Message-ID: <20261012235918.773421-3-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261012235918.773421-1-nickolai@csail.mit.edu>
References: <20261012235918.773421-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DE171C0007
X-Stat-Signature: rgfjbqowpb4bauo54zybjsux3e763h1q
X-HE-Tag: 1791849567-997224
X-HE-Meta: U2FsdGVkX18nhJNMDGynq0MjlDveeV3XEkKsfhY8xjRYS/lxPrqI/vz/6PPalxVPhbGSJTizskKqBEGhET2UXD0JEUNlMOQ/R//M3tq+fBiI9EFS87xEjpBO7tzLesKjiix0QVXEwF6Z1iF3e97rvFhJaoK4gDxlZhqd7WsnEpC1ElyPthE8fXmL5NqXimuuzOM+fFVMpH6Qitf60EX5AeIsnvmulMIlOcL225PgK37w3WYkB0pef9fK/Qnx13nNU3bDy8UigTfOo9R4Q/NoLw54jZJ0zAI1SQuA0ntOF1XNLc5YK3RYDQjX/9HbJSP13RhdF/EMWSljVpK1RU6K32J4s3w3AxefJHFvrHHT8Cye3DS0F5fD5MrKPqdeauD97sijRneDvkr9qTVIvs0POp81ZtBfvrVp48v0TmeHpIA0Lka6TLhFDuiipX2XFvcIDczr7BGi1REPCwGfA0FbLAeVccYjog7LHoVzAM6puwyi1T230VxGpcTiGO0CATE24LLTjpPKhNS0Wt6mFoTe7pljjwuHIushgidMaSAvCoSVESvUWwN7RtSFOiY//thoAMsHzKU0E/D8M//AXhRUfISYc1jW1AqQSjAqTjETSuD/ga1+v8HqfycaMDhq7TNpk2VzgMB825SyPUgKXBKgygR1YFjxUfnqH/ELfk4k30WLP2v52YwNkQ98qb7fbFI3Oc3AM35uBjvEvrVxYE1sy8nukufK9F9/yefl3OHdfCwjtB7WhNshHFMRCQLGakcJANh2qlu4Sf0Pl4bs8iha2Ja9Aukp3wpwk/Z4FpNn8SipoK2rrCFWN1S6YswBTU//a+FhuHsf9BoEtn8TqTwHoKRQGVTpE49zxEvu3fnwbBvSBR/8Xq2g0Ezjvzrl91PHUntWHNLBvsWr5NkCSkprFutD4YIGdjw3NUOChVt4KnTsM6Qc3gBnarLgxDJJabOYsADOHz0OLxuVWdrHmd8
 VizaX16M
 QjBZG+uYSdud0laj7zSzTPlANI5wjku7O8DlNCgcvxeCT4q+HGnSrycr3py3I3GorMRe8CVbagyTk/XBvM8M/4SSp1B7xDn7KRArXouWPa98r83wq0/7J16rasF4nItkTtVKiXyPDYXvqARV5Yky7ZtEx6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of mt_destroy_walk(..., false), mt_clear_meta() clears the
metadata of the node the walk started from.  By then mte_dead_leaves()
has replaced each child pointer in that node with the plain node
address, without the type bits.  mt_clear_meta() decides whether slot 15
of a maple_range_64 node holds a child or metadata by looking for an
encoded node there, so for a node with 16 children it decides wrongly
and writes end = 0, gap = 0 over the first two bytes of the 16th child
pointer.  On little-endian that clears bits 8-15 of the address (bits
0-7 are already zero, nodes being 256-byte aligned); on big-endian it
clears the top 16 bits.

mt_free_walk() then frees, or walks down, the corrupted address.  On
little-endian that is a 256-byte aligned address up to 64KiB below the
real child: usually some other maple node, free or in use, possibly in
another tree, so the result is a double free or the freeing of a live
node, and the real child is leaked.  It takes a tree without
MT_FLAGS_ALLOC_RANGE in RCU mode whose destroy starts at a full node:
any such tree whose root has 16 children, for example a tree of 127
ranges on 64-bit, when it is destroyed.  No race is needed.

The clearing was added by commit 2e5b4921f8ef ("maple_tree: fix freeing
of nodes in rcu mode") together with the clearing of every node in
mte_destroy_descend(), which also covers the start node while its slots
are still encoded.  With the previous patch restoring that, the late
call has nothing left to do except the damage above, so remove it.  For
a leaf start node it was a no-op.

This depends on the previous patch: without it, nothing clears the
metadata of the start node and mt_free_walk() could take it for a child.

As with the previous patch, no in-tree user hits this today, since all
trees used in RCU mode have MT_FLAGS_ALLOC_RANGE, but the API allows it.

The new test destroys an RCU-mode tree of 127 ranges without
MT_FLAGS_ALLOC_RANGE, whose root is full on 64-bit.  Without this patch
AddressSanitizer in the userspace test suite reports the bad free from
mt_free_walk(), as does KASAN in an x86_64 kernel with
CONFIG_TEST_MAPLE_TREE=y; with it both pass.

Found while formally verifying mt_destroy_walk() against the kernel
binary.

Fixes: 2e5b4921f8ef ("maple_tree: fix freeing of nodes in rcu mode")
Cc: stable@vger.kernel.org # 6.1.x
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    With the first patch alone, the reproducer still shows the damage: for
    a tree of 120 ranges (root full, height 2), slot 15 of the root reads
    ...c04000 before mt_destroy_walk(root, false) and ...c00000 after it,
    and AddressSanitizer then reports the free of ...c00000 from
    mt_free_bulk() in mt_free_walk().  With both patches slot 15 is intact
    and the free is clean.  The 127 in the test is the largest such tree
    before the root splits (64-bit).
    
    If a version without the dependency on the first patch is wanted, for
    instance for a separate backport, skipping the call when
    node->slot_len == mt_slots[node->type] also fixes this, but the call is
    redundant once the first patch is in, so removing it seemed simpler.
    Both patches apply unchanged to mm-unstable and linux-next of
    2026-10-12.

 lib/maple_tree.c      | 2 --
 lib/test_maple_tree.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fd7c3d20394c..870ab3281051 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4886,8 +4886,6 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 free_leaf:
 	if (free)
 		kfree(node);
-	else
-		mt_clear_meta(mt, node, node->type);
 }
 
 /*
diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 5d940bcfae34..9d25b31e9b3c 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -4015,6 +4015,8 @@ static int __init maple_tree_seed(void)
 
 	/* 64-bit: a 15-child non-root node two levels above the leaves */
 	check_rcu_destroy(&tree, 2768);
+	/* 64-bit: a full root */
+	check_rcu_destroy(&tree, 127);
 
 
 #if defined(BENCH)
-- 
2.53.0


