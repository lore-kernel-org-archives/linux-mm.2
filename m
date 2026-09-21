Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C6D1C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E066B00E7; Mon, 21 Sep 2026 05:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205A86B00E8; Mon, 21 Sep 2026 05:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B396B00EB; Mon, 21 Sep 2026 05:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3D846B00E7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:46:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F7C6C05C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:16 +0000 (UTC)
X-FDA: 85237288752.03.48DFB5D
Received: from mta1.migadu.com (out-192.mta1.migadu.com [95.215.58.192])
	by imf01.hostedemail.com (Postfix) with ESMTP id 127BD40004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duBSfOvH;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983974;
	b=lZA2fbEib3mp1V9wh0gGrVJAuOoWVSuXd1Z4syqkJGUZwFYEqBX/OAaoRzf9mRMiKpCUxc
	cXw7jxI4uVve4pwpqrm9Q2mvezsOeSlbtFlhUsGEX+1N9X0m8ViB8FIAyfDL6X9l+oFJns
	uKpIPV/tGtcVkDKSXfGuyjMX84DxrA8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=duBSfOvH;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.192 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XKt4KEwGdhrgSOygLGhED4kKfOTSxnGoaSQyxFjhAKg=;
	b=nOvlcJH4GeI6AdcpW9gGSV+qdUm8VpUy+Vqa1A1O0MWOtMl+FPCZMVOll8rFvljidPHC+q
	99mvSMCY5OVXp/dNO6/oMj/8YdSiTPEahavFTtnbeUnfI90MJa4f1zVlWNCN2s3lQ/GbD1
	8WzECNfkxf0XFvA+7cNYWWz27lraqPo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=40Pibx3H1OAa4munGp9Mhm2S6yy1ZLpGkJtdxAVMpi0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789983972; v=1; x=1790588772;
 b=duBSfOvHVNfoYWf8+BBkg+mkclj9nFTEnxk+FDIF3L5oOTr+nAWSP9WBJQ4wOkR8ReaOQvuL
 ww+74/zYFqmjtzevm8maeWsKaIfi14Pwnbru4al2MjI4/J851mP/brdrjr4d0jUsvAfmUe8GKo3
 GMxAeBv8+92y6hy9hE5jzVzM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e0b3a8a4092f7f84;
	Mon, 21 Sep 2026 09:46:12 +0000
X-Mizu-Trace-ID: e0b3a8a4092f7f84
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] mm/slub: refill prefilled sheaves from the barn
Date: Mon, 21 Sep 2026 17:41:13 +0800
Message-ID: <20260921094521.141665-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 127BD40004
X-Stat-Signature: uah3rpgewosx1g4s84sq94tzh1pgpq1d
X-HE-Tag: 1789983973-679136
X-HE-Meta: U2FsdGVkX1/CHmxu6cty09q1iu/M1LIzKbl9HQfPj38BgMnSUAQyEaUlyzF7aLkRMipJavwgyp+E+MxkHbf30z9ApqqNqLeducbDJzvOjA3BXuX/f+SN2thA0gT6RLR+P3FKP3PPLKnQutCO5kGrH7TaR7wJaw5AgG9YDWbMA1aqrHxh9yYrcQN1Tkg4l5MP1AvDNOi8GgvQxrnYxW7EVjXdmdsbrIYX73D/xH1ram49w/u+4teq2HGFZOTOly6qCoZdunAK/CkTBXKQVdJSycaNflYnmVjbwN9/F86slClu+hLuVPje86fxd42smMTroeEwoKG7m0+A85sLsvuqc5pvRNpzbp2AhzEQmShOtmVU/1T0T4PMgkaQZY3HLIlh0WE+pnhrhXcFzcJRav0VC1g5e5ymVrBy9sP+eW9jpbM+zHseI8fbkMAHhE6DugJwM++YwMG8DHtRGJaTg0bAxk8JoL8Ul9XVQP24/mucbI5oa8wBjjxHUNNf8vd6RoyAfTpCJicuzwqtif7+fzCNH6q5nhPnrRZR06z4IFJXz4nkmJar2Fiw03k9CpBq4s4KRA8PO70t0rbDrpzus2OmYoyToTbc3d6DJMr/BBQ9t8IXA7qi+NCP1Kg6qfeZTQ1Uunep6bl8GrUoCVHkkCYm2WsGjUdqA3SdqGrxgoNY/E4BAYqtWN0Da5c4VZng9z8tg10PH6knjhFWfT/XHyn3HCSOZOf1jtKzY5TDnwe2YtLRkJ+qHAejrMY1yjNh2q8Z1CQapNNrrgl1Mj3mkJWS63oNZxJHLZanvPy6HVYx5Loul3RgHXIjp2Z34mrfxpceG7p85Uz6ooUMPacsgOBf/PqMMPCrNSGRpNJQRKjbp0N1p0XGAgOVPSojfOP0Gm7gNxvOfGOmLPKdE7Z2NBYuqCvOx5u0iziw/BcIKbTo+8UvLy0AOMvbkt3impCUXdE3pzWVvfsUhFBaFjPWnNN
 3rxhq0/Q
 4JrYAbfkZ5rFdM2gZCZV9cMoIN/zOOIKrjkCAhuJdPFbS4hHGDCpnEqV5U/gL8aAgD25YuWCZyRytpiiO8oR+W0A67HTTtSLHXEQF4I0O9j6zXgQ3Qeut4Et2Ys38UVCvFQrslTkkpRtgGsvQvMmg+mD8I+iDfe6DLAfEGzLR92u5qYtXovZ8ma8A5QV2RF6lhuamAG8EyOOSpxsSYrN6UAaGADozoPg1RVWwCE9OKZ9k3LbJxiblSkMVCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when the prefill API refills a non-full sheaf, it takes the
objects from partial slabs and never from the full sheaves in the barn,
so once the barn's full list becomes saturated, it stays saturated.

For objects freed via kfree_rcu(), every RCU sheaf then has to be
flushed to slabs because the barn's full list has no room.

To fix this, let the sheaf refill from the barn first, and introduce a
partial sheaf in the barn, which holds the leftover objects [1].

Only the prefill path needs the partial sheaf. The generic allocation
path (__pcs_replace_empty_main()) exchanges an empty sheaf for a full
one from the barn, so nothing is left over. The prefill path refills a
sheaf that is not necessarily empty, so taking objects from the barn
usually leaves leftovers, and the partial sheaf is where they are
kept. refill_sheaf() only takes objects from partial slabs and never
involves the partial sheaf.

The sheaf is refilled by copying objects from the partial sheaf, and
then from a full sheaf taken from the barn if it is still not full. A
sheaf that objects were copied from stays in the barn as the partial
sheaf if it still holds objects, or goes on the empty list if it is
empty. The sheaf being refilled is never replaced.

The gain comes from two sides: every full sheaf taken out makes room on
the barn's full list for a future RCU sheaf, and refilling from the
barn is cheaper than refilling from partial slabs under list_lock.

Note that putting the sheaf with the leftover objects on the full list
instead would not work: it would occupy room on the full list, so the
list would stay saturated and rcu_free_sheaf() would still keep
flushing.

An earlier version of this patch swapped sheaves instead, to minimize
the memcpy overhead. As Harry Yoo pointed out [2], replacing the
caller's sheaf loses cache affinity, filling it directly is more
straightforward, and testing showed no measurable difference between
the two approaches, so the approach he suggested is used.

Tested with will-it-scale mmap1 (192 processes, one-minute runs) on the
maple_node cache.

throughput: 27778727 -> 34500556 (+24.2%)

metric                       baseline           patched        change
=====================================================================
alloc_fastpath                 54,124            56,696        +4.75%
alloc_slab                  7,100,651           159,739       -97.75%
barn_get                          849       194,460,392    +22904539.81%
barn_get_fail                       2               217    +10750.00%
barn_put                          851       182,306,701    +21422544.07%
barn_put_fail             260,400,484       145,522,675       -44.12%
cmpxchg_double_fail         1,029,204           334,228       -67.53%
free_add_partial          326,694,687       181,935,790       -44.31%
free_fastpath                  13,297            15,611       +17.40%
free_rcu_sheaf          8,332,839,104    10,490,535,227       +25.89%
free_remove_partial         7,099,788           158,297       -97.77%
free_slab                   7,099,788           158,297       -97.77%
free_slowpath              10,969,156           782,851       -92.86%
objects                        15,295            14,849        -2.92%
objects_partial                15,295            14,849        -2.92%
partial                         1,604             2,336       +45.64%
sheaf_alloc               137,757,895       141,208,076        +2.50%
sheaf_flush             8,332,823,922     4,656,725,764       -44.12%
sheaf_free                137,757,883       141,208,072        +2.50%
sheaf_prefill_fast      3,337,502,163     4,196,506,116       +25.74%
sheaf_prefill_slow                685               400       -41.61%
sheaf_refill            8,343,794,364     4,657,509,724       -44.18%
sheaf_return_fast       3,337,502,411     4,196,506,382       +25.74%
sheaf_return_slow                 437               134       -69.34%
slabs                           1,604             2,336       +45.64%
total_objects                 102,656           149,504       +45.64%

Here is what the important metric changes mean.

barn_get and barn_put: refills now take full sheaves out of the barn,
and RCU sheaves are put into the barn again. Before, the barn's full
list was saturated once and hardly ever consumed.

barn_put_fail: more than half of the RCU sheaves are now put into the
barn instead of being flushed. The rest are still flushed because they
arrive while the barn's full list is at its limit.

sheaf_refill and free_add_partial: fewer objects are taken from partial
slabs to refill sheaves, and fewer slabs are added to the partial list,
by the same percentage.

alloc_slab and free_slab: the partial list is almost never empty when a
refill looks at it, so slabs are almost never allocated and freed again
only to serve refills.

After the test, the maple_node cache holds 1604 slabs without the patch
and 2336 with it. After a manual shrink
(echo 1 > /sys/kernel/slab/maple_node/shrink), it holds 485 without
the patch and 563 with it. So most of the extra slabs are held only by
objects sitting in sheaves and are returned by a shrink, and what
remains is a small difference, because objects handed out from the barn
come from many more slabs than a refill from partial slabs would use.

Link: https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/ [1]
Link: https://lore.kernel.org/linux-mm/aq0ylDidEHa2kg4X@thinkstation/ [2]
Signed-off-by: Hao Li <hao.li@linux.dev>
---
v2:
- Refill the caller's sheaf in place, copying from the partial sheaf
  and then from a full sheaf, instead of exchanging it for a barn
  sheaf, as suggested by Harry Yoo. The sheaf is no longer passed by
  reference, and the pfmemalloc guard and the capacity fixup of the
  exchanged sheaf go away with the exchange. Thanks Harry!
v1: https://lore.kernel.org/linux-mm/20260918114318.124346-1-hao.li@linux.dev/
---
 mm/slub.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec12503357..db83b1257440 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -422,6 +422,7 @@ struct node_barn {
 	spinlock_t lock;
 	struct list_head sheaves_full;
 	struct list_head sheaves_empty;
+	struct slab_sheaf *sheaf_partial;
 	unsigned int nr_full;
 	unsigned int nr_empty;
 };
@@ -3298,6 +3299,7 @@ static void barn_init(struct node_barn *barn)
 	spin_lock_init(&barn->lock);
 	INIT_LIST_HEAD(&barn->sheaves_full);
 	INIT_LIST_HEAD(&barn->sheaves_empty);
+	barn->sheaf_partial = NULL;
 	barn->nr_full = 0;
 	barn->nr_empty = 0;
 }
@@ -3315,6 +3317,10 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 	barn->nr_full = 0;
 	list_splice_init(&barn->sheaves_empty, &empty_list);
 	barn->nr_empty = 0;
+	if (barn->sheaf_partial) {
+		list_add(&barn->sheaf_partial->barn_list, &full_list);
+		barn->sheaf_partial = NULL;
+	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);
 
@@ -5073,12 +5079,87 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * Refill @sheaf from the barn: from its partial sheaf first, then from its full
+ * sheaves. A sheaf that objects were copied from stays in the barn as the
+ * partial sheaf if it still holds objects, or goes on the empty list if it is
+ * empty.
+ *
+ * Returns true if the sheaf is now full, at s->sheaf_capacity.
+ * Returns false if the sheaf is still not full.
+ */
+static bool refill_sheaf_from_barn(struct kmem_cache *s,
+				   struct slab_sheaf *sheaf)
+{
+	struct node_barn *barn = get_barn(s);
+	struct slab_sheaf *src;
+	unsigned int to_move;
+	unsigned long flags;
+
+	if (!barn)
+		return false;
+
+	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
+		return false;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	/*
+	 * The partial sheaf can hold fewer objects than @sheaf needs to
+	 * reach capacity, and a sheaf on the full list is not necessarily
+	 * full (see the comment in rcu_free_sheaf()), so keep taking from
+	 * the barn until @sheaf is full or nothing is left.
+	 */
+	while (sheaf->size < s->sheaf_capacity) {
+		src = barn->sheaf_partial;
+		barn->sheaf_partial = NULL;
+		if (!src) {
+			if (!barn->nr_full)
+				break;
+			src = list_first_entry(&barn->sheaves_full,
+					       struct slab_sheaf, barn_list);
+			list_del(&src->barn_list);
+			barn->nr_full--;
+		}
+
+		to_move = min(s->sheaf_capacity - sheaf->size, src->size);
+		src->size -= to_move;
+		memcpy(&sheaf->objects[sheaf->size], &src->objects[src->size],
+		       to_move * sizeof(void *));
+		sheaf->size += to_move;
+
+		if (src->size) {
+			barn->sheaf_partial = src;
+		} else {
+			/*
+			 * No empty-limit check: the sheaf put on the empty list
+			 * was already in the barn, so the barn holds no more
+			 * sheaves than before. barn_replace_empty_sheaf() skips
+			 * the check for the same reason.
+			 */
+			list_add(&src->barn_list, &barn->sheaves_empty);
+			barn->nr_empty++;
+		}
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	if (sheaf->size < s->sheaf_capacity)
+		return false;
+
+	stat(s, BARN_GET);
+	return true;
+}
+
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 				      struct slab_sheaf *sheaf, gfp_t gfp)
 {
 	gfp_t gfp_nomemalloc;
 	int ret;
 
+	if (refill_sheaf_from_barn(s, sheaf))
+		return 0;
+
 	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
 	if (gfp_pfmemalloc_allowed(gfp))
 		gfp_nomemalloc |= __GFP_NOWARN;
-- 
2.55.0


