Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E178C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D276B0088; Wed, 26 Aug 2026 03:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34E476B008A; Wed, 26 Aug 2026 03:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266D26B0098; Wed, 26 Aug 2026 03:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEAD96B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:44:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D47CEC027A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:44:56 +0000 (UTC)
X-FDA: 85142634192.20.A66C51C
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DBDA1C0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:44:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a56kxO+8;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8edTRr/LDIfhWACvZtsMwFVGVskaqn29q3JpsnivJvE=;
	b=jYvaIG2i9KmBS+Jj/CxAgtQepTP0oaoWcoRxTaiwtV+uAW5Caae6jMq4iA+oNTSanhkBSc
	TPdWPQrhnBATiWQ3O7N5OsPRJ9z2l1yoUIcaQkkspeWRP9d3bg3zPlpyNY7o1+zJP3u4Iy
	msAL6M2dbh50fp5RJlZL2f0V4liLEzI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a56kxO+8;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.137 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730295;
	b=YP0QXHt4++HxTz6M3oe7zz2JO7tHKgszSXhFQ1ZUdp8TR0nAGSQkxXxIoMi8rvSf4w35kJ
	qoLHKqZZH1IEvK5aKWnpcMLKKiM5Vgup8ZabQc3IMbzssaTBdn+Vna5RAQPnUV5nGbTdFe
	22uJOaq7Ym3cuvN7pVcMvaAVVwip/+0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Nh3RJaVFyQNmRCC8iDkPo/WhTa3I/F2gkl/7Y/0J4a0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787730290; v=1; x=1788335090;
 b=a56kxO+8lF8RkkjXwjUpVttBfbuter1uJM0dNJHXS2spVbu8lyx1C1ezt7BoDp3KrvPSOeoC
 qjZ3JvgP6ZWg+Kp72lSUYUnN15sMrCvzvAk5xfeRHo4snue2xMsjgg3kjxy4/P2M5OIqGduHAtC
 4YGwbtaRIWeIb5W0ic0XZiIw=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id f784adc83c5cf2e2;
	Wed, 26 Aug 2026 07:44:49 +0000
X-Mizu-Trace-ID: f784adc83c5cf2e2
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] maple_tree: Annotate lockless pivot reads for KCSAN
Date: Wed, 26 Aug 2026 15:44:30 +0800
Message-ID: <20260826074430.1139325-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9cowfeuuhgymh6qk86wxid7cf7se6n1i
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DBDA1C0005
X-Rspam-User: 
X-HE-Tag: 1787730292-872816
X-HE-Meta: U2FsdGVkX19wOyzbcc0gu8NBVGiBhhEqd1M2ChZwUgc8DOWFCJmD5h4z0SctAT+FTJrxsNbMTBKuYJUm/3yDJ23tpBFG9K69PA15mgtYzQRVy1CHlUECvIe0luij2i3Csc5/F/Gx8h34d/3Qq0135xzprIRNEdQmQJM5Y4R9He2Sf/EWYTtJx/5E7TIJNlCHyarh+Jp9e8sI3t8hnW0RuJYsCJ5jN4zs7aIDeCmM00KSO2eTI7udTWDbqh6qk3NJScTn5Y50EqcrM3GfN+bYMG6bsdSHXdp7p662RN0lqOfKn3W4KfUWCmyxIpNFN7GQtB+OeOkJC9+DErb5MhX9ZMA+9Y3YYt3UBq0lft2W5Fwv+JLUqmFL5AvaCzN6MwxbgB7ork/6k/FZFITHddfUWUn7mwn3yKvCgmlnD2YWgM43svglfju6Q1nx5N71ZTrLeGAWQleS+1+PrC6GA7PTH1WfFGsigdQFOykwExqJAX+0POD6+tpCv51lBtIf4u0+6yU3oGpI4Og56m4pAlfAlWwQecgv/mtD28i1FQOJoPUJ+dpYIPrSGWRw0fYxuD0di25N9Rckd20L9FxQHe44jU1VgFp62FgvHgiQIBkIyj8nFq5r7+Jt3G4OSkEuNKAnAUIIvx4utVhU1I7qCkf1qGgmDgSkvKxN9+2DH0E5Ee3dSaiX/cPNOMWXHCLunAhLQU8oUa22tZsadcyBDBqWml0xzNySDZnu1ZJCiIH6d5RPvQe3+fYxafmmYzL9ArNe+j+bk1dXHooNTCgHP9b/P6my7vkojfriVGc/UMjxs3PSGW2nclSQvRupBOaovZsZlpKpgv35+U+RGLNitSYm42hbhaty19OQ1Cf7/cWq/7dxB42w1z7Q8Lm6dGLm2A3YOuf4H86mmceMtECiFgVRTneZ7YKfhzYkezSqNq4PayA2Hptl7ZMbLcul/qMyBXEFxTMsB3MRZiHwHIFsU62
 ndHk88z2
 eAFp/raQKiy8OlhMjWDyAVhk3Hv6M9Ah18NAeXZMd8TpoVSGaIv7nKOTrfyyIAtRogrCpS9Y340MWhIPc3TvhEZOm5W6QwPHRLehRvuYZdnON0pJabCH/qQYkbnC+XC7kJSfx/VncD3tSnKyCA/q4VzgqNYPS00kqe8WJJCzVDFAUgZbIavZ5/Xmik/iqzRxru/i701I1LyHQRT8XF9vn7YoQPTyYAzROoN7R6k3wlNf02L/bFKIAQxPqZqFFugUEXVU6S90tmtwgaOy6KAG0TX1XJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

In RCU mode, replaced maple nodes are marked dead and freed via RCU
after the new node has been published.  Arming the RCU free writes
node->rcu.next and node->rcu.func, which share storage with
pivot[0] and pivot[1] (see struct maple_node), while lockless
readers may still walk the dead node.  These stores therefore race
with the pivot loads performed by the walkers.

This is harmless: the writer marks the node dead with an smp_wmb()
before arming the rcu_head, and the walkers re-check ma_dead_node()
after reading the node and restart the walk when the node is dead,
so any pivot read that raced with the rcu_head stores is discarded.
KCSAN cannot see this protocol and reports the plain accesses, so
annotate the lockless pivot reads with data_race() through a new
ma_pivot_rcu() helper.

Found by fuzzing on a 6.6 kernel; the race still exists on
mainline.  No functional change intended.

BUG: KCSAN: data-race in __call_rcu_common.constprop.0 / mas_walk
write to 0xffff8db9bb7cde10 of 8 bytes by task 1065 on cpu 7:
__call_rcu_common.constprop.0+0x47/0x5d0
call_rcu+0x12/0x20
mas_wr_node_store+0x7a6/0x7d0
mas_wr_store_entry+0x3af/0x760
mas_store_prealloc+0x419/0x8a0
__mmap_region+0x7fa/0x1240
mmap_region+0x177/0x1c0
do_mmap+0x636/0x970
vm_mmap_pgoff+0x193/0x2e0
ksys_mmap_pgoff+0x276/0x2f0
__x64_sys_mmap+0x5b/0x80
x64_sys_call+0x1b9b/0x1ee0
do_syscall_64+0x5d/0x1b0
entry_SYSCALL_64_after_hwframe+0x76/0xe0
read to 0xffff8db9bb7cde10 of 8 bytes by task 1061 on cpu 4:
mas_walk+0x424/0x810
lock_vma_under_rcu+0x150/0x250
do_user_addr_fault+0x195/0x7d0
exc_page_fault+0x5d/0xd0
asm_exc_page_fault+0x26/0x30
Reported by Kernel Concurrency Sanitizer on:
CPU: 4 PID: 1061 Comm: syz-fuzzer Not tainted 6.6.127
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 lib/maple_tree.c | 57 ++++++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 14 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1aba6cced713..63dfc7edad81 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -546,6 +546,35 @@ static inline unsigned long *ma_pivots(struct maple_node *node,
 	return NULL;
 }
 
+/*
+ * ma_pivot_rcu() - Read a pivot from a node that may be concurrently
+ * freed via RCU.
+ * @pivots: The pointer to the maple node pivots
+ * @offset: The offset into the pivot array
+ *
+ * Lockless readers may walk a node that the writer has already marked
+ * dead and queued for RCU freeing.  The rcu_head used to queue the
+ * node for freeing shares storage with pivot[0] and pivot[1] (see
+ * struct maple_node), so arming the rcu_head races with reads of
+ * those pivots.
+ *
+ * Such reads are safe: the writer marks the node dead with an
+ * smp_wmb() before arming the rcu_head (see mte_set_node_dead()) and
+ * the walkers re-check ma_dead_node() with an smp_rmb() after reading
+ * the node, restarting the walk when the node is dead.  Any pivot
+ * read that raced with the rcu_head stores is discarded.
+ *
+ * Annotate the read so that KCSAN does not report this race.
+ *
+ * Return: The pivot at @offset.
+ */
+static inline unsigned long ma_pivot_rcu(unsigned long *pivots,
+					 unsigned char offset)
+{
+	/* Data race with rcu_head arming of a dying node, see above. */
+	return data_race(pivots[offset]);
+}
+
 /*
  * ma_gaps() - Get a pointer to the maple node gaps.
  * @node: the maple node
@@ -1019,12 +1048,12 @@ static int mas_ascend(struct ma_state *mas)
 
 		if (!set_min && a_slot) {
 			set_min = true;
-			min = pivots[a_slot - 1] + 1;
+			min = ma_pivot_rcu(pivots, a_slot - 1) + 1;
 		}
 
 		if (!set_max && a_slot < mt_pivots[a_type]) {
 			set_max = true;
-			max = pivots[a_slot];
+			max = ma_pivot_rcu(pivots, a_slot);
 		}
 
 		if (unlikely(ma_dead_node(a_node)))
@@ -2097,22 +2126,22 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 		end = ma_data_end(node, type, pivots, max);
 		prev_min = min;
 		prev_max = max;
-		if (pivots[0] >= mas->index) {
+		if (ma_pivot_rcu(pivots, 0) >= mas->index) {
 			offset = 0;
-			max = pivots[0];
+			max = ma_pivot_rcu(pivots, 0);
 			goto next;
 		}
 
 		offset = 1;
 		while (offset < end) {
-			if (pivots[offset] >= mas->index) {
-				max = pivots[offset];
+			if (ma_pivot_rcu(pivots, offset) >= mas->index) {
+				max = ma_pivot_rcu(pivots, offset);
 				break;
 			}
 			offset++;
 		}
 
-		min = pivots[offset - 1] + 1;
+		min = ma_pivot_rcu(pivots, offset - 1) + 1;
 next:
 		slots = ma_slots(node, type);
 		next = mt_slot(mas->tree, slots, offset);
@@ -3040,7 +3069,7 @@ static inline void *mtree_lookup_walk(struct ma_state *mas)
 		end = mt_pivots[type];
 		offset = 0;
 		do {
-			if (pivots[offset] >= mas->index)
+			if (ma_pivot_rcu(pivots, offset) >= mas->index)
 				break;
 		} while (++offset < end);
 
@@ -4003,7 +4032,7 @@ static int mas_prev_node(struct ma_state *mas, unsigned long min)
 		return 1;
 
 	if (likely(offset))
-		mas->min = pivots[offset - 1] + 1;
+		mas->min = ma_pivot_rcu(pivots, offset - 1) + 1;
 	mas->max = max;
 	mas->offset = mas_data_end(mas);
 	if (unlikely(mte_dead_node(mas->node)))
@@ -4077,7 +4106,7 @@ static void *mas_prev_slot(struct ma_state *mas, unsigned long min, bool empty)
 		node = mas_mn(mas);
 		type = mte_node_type(mas->node);
 		pivots = ma_pivots(node, type);
-		mas->index = pivots[mas->offset - 1] + 1;
+		mas->index = ma_pivot_rcu(pivots, mas->offset - 1) + 1;
 	}
 
 	slots = ma_slots(node, type);
@@ -4218,7 +4247,7 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 
 	if (mas->max >= max) {
 		if (likely(mas->offset < mas->end))
-			pivot = pivots[mas->offset];
+			pivot = ma_pivot_rcu(pivots, mas->offset);
 		else
 			pivot = mas->max;
 
@@ -4232,11 +4261,11 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 	}
 
 	if (likely(mas->offset < mas->end)) {
-		mas->index = pivots[mas->offset] + 1;
+		mas->index = ma_pivot_rcu(pivots, mas->offset) + 1;
 again:
 		mas->offset++;
 		if (likely(mas->offset < mas->end))
-			mas->last = pivots[mas->offset];
+			mas->last = ma_pivot_rcu(pivots, mas->offset);
 		else
 			mas->last = mas->max;
 	} else  {
@@ -4258,7 +4287,7 @@ static void *mas_next_slot(struct ma_state *mas, unsigned long max, bool empty)
 		node = mas_mn(mas);
 		type = mte_node_type(mas->node);
 		pivots = ma_pivots(node, type);
-		mas->last = pivots[0];
+		mas->last = ma_pivot_rcu(pivots, 0);
 	}
 
 	slots = ma_slots(node, type);
-- 
2.53.0


