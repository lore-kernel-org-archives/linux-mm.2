Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F8E1C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D7C6B008A; Fri, 18 Sep 2026 07:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EEC6B008C; Fri, 18 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E965F6B0092; Fri, 18 Sep 2026 07:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF1636B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:44:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31CD080683
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:44:09 +0000 (UTC)
X-FDA: 85226699418.12.6C1D113
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf19.hostedemail.com (Postfix) with ESMTP id D3FD01A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:44:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q57NOsFk;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789731847;
	b=5acz3RmgMAq6Llct/wby7ERTThom11ZUHJrmyiKycefoXJTiThxgLeimE0+SRGVvoT2MpT
	deiS44oLn4Gc7HefFetxwzMCXCH7FnJDatUq7NaDNKna5tTT8jGPb/FiotHpH8nD+wgitK
	pUXsISp8FAxivVMhUWqTSxltqyKLrs0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q57NOsFk;
	spf=pass (imf19.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789731847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mEOM7ug8xNlv0jxhza4tHTbllWxG/iqoTtAQ1rRcTyk=;
	b=41aOuZObWQxaR5X8mLJ3k57+HG7s3ra/JXd74gS+rq9sBXRvPn84TcKuIZxEb0BhGuQBgR
	i9/rFMum+AuFr+GBfqb5DR847Pd5l0q2TX+7bAYE0JnigIPB57Mqey+ucOz1MV0y6mS6xt
	G/Vu49kVi6aOXgmumhJLXEJu8VPJaeA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z18ua7KJj8NUH51GZr7B30RkX10das6Mm9xYywfDXH8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789731845; v=1; x=1790336645;
 b=q57NOsFkxHDhvPX55FXWnYc8XrVYmI+qR3k0vCCyIrI9t1k+wXptceunfeIGKo/6p5wZFTY/
 9jg9Fa/lxuyvNBQQAzQb2GxJRxWimn2U/KHDF+GykooFqLRZniwIkYl4jYgnG5rz0Oa1MxUGQdo
 YUxwT6Dqou+S1Ixz/XxFAgMQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 03a9aeceba392b53;
	Fri, 18 Sep 2026 11:44:05 +0000
X-Mizu-Trace-ID: 03a9aeceba392b53
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
Subject: [PATCH] mm/slub: refill prefilled sheaves from the barn
Date: Fri, 18 Sep 2026 19:41:56 +0800
Message-ID: <20260918114318.124346-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D3FD01A0002
X-Stat-Signature: txojsh9x4inekaeur8d3695dg6qgqhn8
X-HE-Tag: 1789731846-686230
X-HE-Meta: U2FsdGVkX1+/S9NzER2TMNdXu1it7lE6rg3ZIoUWQEvdnx81tgxwE4wzJgY4if/kZLSCu616jsaORrahllv3DfSkYadD9A6LkQKqtxUQGDcrgBryp8oD1u16gY6UryJM2ejUGKJch5jvX+7qrI+NToZ6vFyn2jva1K1+iaxT1DKd8fPQbaHAMeYGTC+9xmjGdfr0z2MBVrTH9JhqdGFyz1/CCqAwf37GX+/ekCu6RkSM2OP9ovrsOILf65iq1esRrWYZieQRDcP2HRm2lgf3utCwHNueUCiM04XVy7vM6MsdMC41NO8fF5uUQlXM0ecPIIVQkERud13BWp4/Wh2O9FxXs8bZ5MefyTULHds15S6gsxGw9iO+R0iJHqljD1pkbKy4YFoupfA1KZo6I6QPJ1OzoRS++17QpU4mziLash1fLSB5iLhfh1jFGe/82Ugs7rPr7ZACf9caOF3iGMdp4TjT80VHXkhNK1v7EJ2rJ1nHCptTIuUb75conP2LM5m+aZdTb4GRMwk603X92/WyOaFEJCNr7JyMzYNHDhXhfLZot5Vjb5UFNWB6a/nMzl4mNF5cX7sCIY6Jp0jikIIEopTs1kFCQ8ikHjYOefcE0rKs2sdAyGTeSBnO6lLlt7fPpT9idSGr0g0fR3O8YChY7Js9U22pQolIDesNU9OqbCVpZUgW8RZdc9L4fAUjrz8P1aR52efB0HOgqB/v1htM2REyJ8LmGsFi94reXh/1xuaquMYqltqvXJQzTwvqJtEXEUsEobnBhBZn2yHX2lnY6j9L9meG1FMbIMI4vT83DCqytZXUa7YJg9PyYczJIz+2fPcHYUWrV/zCGf8z6yGP6JtLd2rS2cREYWrrNhfffMJcZop4UPH9FC1XreWQdG60AA5GgFVOwhp3i3EJndhzWDIvQRRZQgBd/y5AfbOijkvv9KsBMnrxTBnqyQfT1lK2g7yGBPArdcpOHCqfOal
 wEfIHlZE
 bb4nR58klRoybzF7M0bB2tnGwaOqMTX7j5MCJIwf57XX/ECDGqn1XCIMvYqAVwAq5Cmg7yQzrVprUMV489YYfFO8WtS8uRdjSZcpn8iEJKtf55kLt6sgs/+lpS0+pR6oXLj17LBI8LvUx0WUUXN7mBcRj+bwJgxzDtQF6WHok6SNCiHxBvRao6neT3xk4OXAGkbWL0KiYTh2hrtbZurTzc/qlcH97Gwi9RxW3mN/6cCKXPsKJPzdzOhuvdQ==
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
partial sheaf in the barn, which holds the leftover objects.

If no partial sheaf exists, take a full sheaf from the barn and return
it to the caller; the non-full sheaf becomes the partial sheaf, or is
put on the barn's empty list if it holds no objects.

If a partial sheaf exists and the non-full sheaf and the partial sheaf
together reach capacity, the one holding more objects is filled up from
the other and handed out instead, so no full sheaf needs to be taken
from the barn.

If a partial sheaf exists but the two together do not reach capacity,
take a full sheaf from the barn for the caller; the objects of the
non-full sheaf are absorbed into the partial sheaf, and the non-full
sheaf, now empty, is put on the barn's empty list.

The gain comes from two sides: every full sheaf taken out makes room on
the barn's full list for a future RCU sheaf, and refilling from the
barn is cheaper than refilling from partial slabs under list_lock.

Note that putting the non-full sheaf on the full list instead would not
work: it would occupy room on the full list, so the list would stay
saturated and rcu_free_sheaf() would still keep flushing.

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

Link: https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/
Signed-off-by: Hao Li <hao.li@linux.dev>
---
This patch emerged from the discussion here:
https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/
Thanks everyone for joining the discussion!

Below are the full metrics for the current patch:

throughput: 27778727 -> 34500556   (+24.2%)

metric                            baseline           patched             delta      change
==========================================================================================
alloc_fastpath                      54,124            56,696             2,572      +4.75%
alloc_node_mismatch                      0                 0                 0      +0.00%
alloc_slab                       7,100,651           159,739        -6,940,912     -97.75%
alloc_slowpath                           0                 0                 0      +0.00%
barn_get                               849       194,460,392       194,459,543  +22904539.81%
barn_get_fail                            2               217               215  +10750.00%
barn_put                               851       182,306,701       182,305,850  +21422544.07%
barn_put_fail                  260,400,484       145,522,675      -114,877,809     -44.12%
cmpxchg_double_fail              1,029,204           334,228          -694,976     -67.53%
free_add_partial               326,694,687       181,935,790      -144,758,897     -44.31%
free_fastpath                       13,297            15,611             2,314     +17.40%
free_rcu_sheaf               8,332,839,104    10,490,535,227     2,157,696,123     +25.89%
free_rcu_sheaf_fail                      0                 0                 0      +0.00%
free_remove_partial              7,099,788           158,297        -6,941,491     -97.77%
free_slab                        7,099,788           158,297        -6,941,491     -97.77%
free_slowpath                   10,969,156           782,851       -10,186,305     -92.86%
object_size                            256               256                 0      +0.00%
objects                             15,295            14,849              -446      -2.92%
objects_partial                     15,295            14,849              -446      -2.92%
objs_per_slab                           64                64                 0      +0.00%
order                                    2                 2                 0      +0.00%
partial                              1,604             2,336               732     +45.64%
sheaf_alloc                    137,757,895       141,208,076         3,450,181      +2.50%
sheaf_capacity                          32                32                 0      +0.00%
sheaf_flush                  8,332,823,922     4,656,725,764    -3,676,098,158     -44.12%
sheaf_free                     137,757,883       141,208,072         3,450,189      +2.50%
sheaf_prefill_fast           3,337,502,163     4,196,506,116       859,003,953     +25.74%
sheaf_prefill_oversize                   0                 0                 0      +0.00%
sheaf_prefill_slow                     685               400              -285     -41.61%
sheaf_refill                 8,343,794,364     4,657,509,724    -3,686,284,640     -44.18%
sheaf_return_fast            3,337,502,411     4,196,506,382       859,003,971     +25.74%
sheaf_return_slow                      437               134              -303     -69.34%
slab_size                              256               256                 0      +0.00%
slabs                                1,604             2,336               732     +45.64%
total_objects                      102,656           149,504            46,848     +45.64%

derived                                                baseline           patched      change
=============================================================================================
page allocator churn (alloc_slab + free_slab)        14,200,439           318,036     -97.76%

---
 mm/slub.c | 142 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 134 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 54ec12503357..0b1de6b42b61 100644
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
@@ -3164,6 +3165,89 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 	return empty;
 }
 
+/*
+ * Exchange @sheaf, which holds fewer objects than requested, for a full one,
+ * keeping the leftover objects in the barn's partial sheaf instead of
+ * flushing them.
+ *
+ * Returns a full sheaf, or NULL if the barn cannot make one.
+ * The returned sheaf might be @sheaf itself or a new one.
+ */
+static struct slab_sheaf *barn_replace_partial_sheaf(struct kmem_cache *s,
+						     struct node_barn *barn,
+						     struct slab_sheaf *sheaf)
+{
+	struct slab_sheaf *full = NULL, *partial;
+	unsigned int to_move;
+	unsigned long flags;
+
+	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
+		return NULL;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	partial = barn->sheaf_partial;
+	if (partial && partial->size + sheaf->size >= s->sheaf_capacity) {
+		/* Fill the larger one to capacity from the smaller */
+		if (partial->size > sheaf->size)
+			swap(partial, sheaf);
+
+		to_move = s->sheaf_capacity - sheaf->size;
+		partial->size -= to_move;
+		memcpy(&sheaf->objects[sheaf->size],
+		       &partial->objects[partial->size],
+		       to_move * sizeof(void *));
+		sheaf->size = s->sheaf_capacity;
+
+		if (partial->size) {
+			barn->sheaf_partial = partial;
+		} else {
+			/*
+			 * No empty-limit check here or below: the sheaf put on the
+			 * empty list is either the barn's own partial sheaf, or the
+			 * caller's sheaf taken in exchange for a full one, so the
+			 * barn holds no more sheaves than before.
+			 * barn_replace_empty_sheaf() skips the check for the same
+			 * reason.
+			 */
+			list_add(&partial->barn_list, &barn->sheaves_empty);
+			barn->nr_empty++;
+			barn->sheaf_partial = NULL;
+		}
+
+		full = sheaf;
+		goto done;
+	}
+
+	if (!barn->nr_full)
+		goto done;
+
+	full = list_first_entry(&barn->sheaves_full, struct slab_sheaf,
+				barn_list);
+	list_del(&full->barn_list);
+	barn->nr_full--;
+
+	if (partial) {
+		/* The two do not reach capacity: the partial sheaf absorbs all of @sheaf */
+		memcpy(&partial->objects[partial->size], sheaf->objects,
+		       sheaf->size * sizeof(void *));
+		partial->size += sheaf->size;
+		sheaf->size = 0;
+	}
+
+	if (sheaf->size) {
+		barn->sheaf_partial = sheaf;
+	} else {
+		list_add(&sheaf->barn_list, &barn->sheaves_empty);
+		barn->nr_empty++;
+	}
+
+done:
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	return full;
+}
+
 /*
  * The following two functions are used mainly in cases where we have to undo an
  * intended action due to a race or cpu migration. Thus they do not check the
@@ -3298,6 +3382,7 @@ static void barn_init(struct node_barn *barn)
 	spin_lock_init(&barn->lock);
 	INIT_LIST_HEAD(&barn->sheaves_full);
 	INIT_LIST_HEAD(&barn->sheaves_empty);
+	barn->sheaf_partial = NULL;
 	barn->nr_full = 0;
 	barn->nr_empty = 0;
 }
@@ -3315,6 +3400,10 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 	barn->nr_full = 0;
 	list_splice_init(&barn->sheaves_empty, &empty_list);
 	barn->nr_empty = 0;
+	if (barn->sheaf_partial) {
+		list_add(&barn->sheaf_partial->barn_list, &full_list);
+		barn->sheaf_partial = NULL;
+	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);
 
@@ -5073,12 +5162,51 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * Refill *@sheafp from the barn; *@sheafp may be replaced.
+ *
+ * Returns true if the sheaf is now full, at s->sheaf_capacity.
+ * Returns false if the sheaf is still not full.
+ */
+static bool refill_sheaf_from_barn(struct kmem_cache *s,
+				   struct slab_sheaf **sheafp)
+{
+	struct node_barn *barn = get_barn(s);
+	struct slab_sheaf *sheaf = *sheafp;
+	struct slab_sheaf *full;
+
+	/* Objects from pfmemalloc slabs must not enter the barn */
+	if (!barn || sheaf->pfmemalloc)
+		return false;
+
+	full = barn_replace_partial_sheaf(s, barn, sheaf);
+	if (!full)
+		return false;
+
+	stat(s, BARN_GET);
+	full->capacity = s->sheaf_capacity;
+	full->pfmemalloc = false;
+	*sheafp = full;
+
+	/*
+	 * A sheaf taken from the barn's full list may hold fewer than capacity
+	 * objects, see rcu_free_sheaf().
+	 */
+	return full->size == s->sheaf_capacity;
+}
+
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
-				      struct slab_sheaf *sheaf, gfp_t gfp)
+				      struct slab_sheaf **sheafp, gfp_t gfp)
 {
+	struct slab_sheaf *sheaf;
 	gfp_t gfp_nomemalloc;
 	int ret;
 
+	if (refill_sheaf_from_barn(s, sheafp))
+		return 0;
+
+	sheaf = *sheafp;
+
 	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
 	if (gfp_pfmemalloc_allowed(gfp))
 		gfp_nomemalloc |= __GFP_NOWARN;
@@ -5171,7 +5299,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
-		    __prefill_sheaf_pfmemalloc(s, sheaf, gfp)) {
+		    __prefill_sheaf_pfmemalloc(s, &sheaf, gfp)) {
 			sheaf_flush_unused(s, sheaf);
 			free_empty_sheaf(s, sheaf);
 			sheaf = NULL;
@@ -5238,14 +5366,12 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 /*
  * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
- * the given size.
+ * the given size. The sheaf might have been replaced with a new one, whether
+ * the refill succeeds or not.
  *
  * Return: 0 on success. The sheaf will contain at least @size objects.
- * The sheaf might have been replaced with a new one if more than
- * sheaf->capacity objects are requested.
  *
- * Return: -ENOMEM on failure. Some objects might have been added to the sheaf
- * but the sheaf will not be replaced.
+ * Return: -ENOMEM on failure. Some objects might have been added to the sheaf.
  *
  * In practice we always refill to full sheaf's capacity.
  */
@@ -5267,7 +5393,7 @@ int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 
 	if (likely(sheaf->capacity >= size)) {
 		if (likely(sheaf->capacity == s->sheaf_capacity))
-			return __prefill_sheaf_pfmemalloc(s, sheaf, gfp);
+			return __prefill_sheaf_pfmemalloc(s, sheafp, gfp);
 
 		if (!__kmem_cache_alloc_bulk(s, gfp, sheaf->capacity - sheaf->size,
 					     &sheaf->objects[sheaf->size]))
-- 
2.55.0


