Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F9FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820BC6B0306; Mon,  1 Jun 2026 05:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1CB6B0307; Mon,  1 Jun 2026 05:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7616B0308; Mon,  1 Jun 2026 05:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAFB6B0306
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:57:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 046E6A05FA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:57:39 +0000 (UTC)
X-FDA: 84830891880.11.0F495BA
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A0D6100006
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V58lmzgU;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780307858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TUs+rCabK0QoZm/U6SN1B2Cuc1KTvjDd/Qyt/e5rZGA=;
	b=xqHfNR/esuNfZfI0hhAMTNrL/ieftrFIVFmnvfDoO3Cl8Yn5iAeB9uXjd4HpGIsxSF1MbQ
	dIjk5R985wunXMYLy9rn3P/06NW38lmC/rpJHBfOABptDiiACoW25MSyRrh/BgDP/E7sAE
	a2BNM3Vd9LaGbrSPajPrOZ47wFyHdoU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V58lmzgU;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780307858; a=rsa-sha256;
	cv=none;
	b=5lCeXmkeZH93sH6ItKJdzWUV8hIfkVT8Q7wCk9dX7yxo/ViTRJnXdcdyX2Unn1Dc/o6Gtf
	/faIarb56E78nMW61lnmpWgMPGkEsk6hUGsSEcIlaakJhBRd+nnne+SZSwdeBHqqt4/RCa
	/0wNoZOV/2odiXrEjSBo53LySBMnIcI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780307857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TUs+rCabK0QoZm/U6SN1B2Cuc1KTvjDd/Qyt/e5rZGA=;
	b=V58lmzgUtTBFOyaGfXipiyAVr59RZsUVgNNYJp3bqPPUEfN38LqAfFHR1rVyJwTfT0BFt5
	EXAv48XYm/bcAE/JRs6DWVxFoJZ5tlLtq5kPu6taQih7tDCMfkUbZtBJztmhwMzbAWIgxF
	IClN6JgqNK0bguRSkvlcnY7ObYmb9vg=
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
Subject: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
Date: Mon,  1 Jun 2026 17:56:21 +0800
Message-ID: <20260601095706.106551-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mtjg1pzp6dp163bmaoysh6yihpbebyti
X-Rspamd-Queue-Id: 7A0D6100006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780307858-702558
X-HE-Meta: U2FsdGVkX19ssCO6G0EPOAUkqQCRyJfSJt17Qghx0WOy0U6KkkfQTOn4kHKvmFtlUnFL2klqi4+dOk3h49KSSkUfEWTW/9tASALr7JCGxPIz+r6IAU7ChtgyBRG8QNHywt86K1JZeMrPPA6PrVSNOqFxxI3Z5/McWj6gcBf5GsEQkP9NDnWkmlJ+KCSGXv7ZM7Gj4ob3KAv/r9JDwp4Bl8kPXfwTiRpGl0V0ilXLA4hP8rqUY6KH9QZhYoLZCy8rKsda2iZdOccW+dfrr5eT/7Atd/C3K1DRY3N6eJ8nFrGrpUwfYEqlXRlBu+TDMjvPK3qOnbnRm/Xj6KXOT1AScZ0MCtPPC7zqa3dRQDAAcwLGejDDN0EUndpkNs4BV3daUORU0PIaZy9sDaY4DdRr7+B0QECjbj85WLsOj+UkM+mwffHxQTcVXBI2aIa0PgXOm4rb5nvE4xeZ5Y7Je9X3X+YYAueU5m2TiRypxYNy/KynDX1iQg2JqU2gq2WOfxo1G7ca7DnwLqApbgYR4+gEJmTWLyd1wvPyxJJ2ZzLWt9/ngNNKK9mDqgWq01VrUp/KyFERtRg0HSoosS/GtV+e91o5lz8Y0sVwIvlw9AgJK+A1OWTFO9j8aZ+An3vpMH3KRJFvxNgIVi3DVXG13ppaI80F9XPQIYojPUkE5hnWHypF5sP5uKD01ib1eb9AwELXuAf4mXjKLpGqtJT1smtnRDOkiool/iDBxb7GiPVxBJkRrhiMQGnseNcIg0x0eL1Vseyvm9ZLzxAvljOiBt8prkzUikBsXqlPot1DX9sIAqHObFl4TMfCGoe/fSE41w52SbIr927WrxXSRXyUDV/Ae6F+Myg+w/OuRHyBlJ8k5uH12tasTW9Vpm2Hq3aKGd9UKga3D4hcV3oSPE6knU1JtIUyHS95N99q8FH2c28FdtL3Ow3x2XXblJ0gu0lZeZfn3jQ0XE2HfpC+a5lcVwN
 sLD/zMgT
 XLV/MVrVeG55lHj9uYYbPthfpfsBrjPVfLpne78K/z5svEFVkMqIyjzMVQw1mtUZw7sBnldqnefn0QT+oeVL2r585/dRogw4pd+Bvximfcxf9hHy9E035aeuecbPkKA/5opMYy+mRAi+MytRGlfJunjJwIMMGguwLxhvpB6FAvVnLW5abLclJLh2ocxzIqlhD2jZ3rAzyJAW02VTaYFzIgW5THakaLe7QZS3p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sheaf structs are exchanged through node-local barns. Since barn structs
are already allocated from their local NUMA node, this patch aims to
allocate sheaf structs from their local memory nodes as well.

To achieve this, the obvious choice would be using cpu_to_mem().
However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
through possible CPUs, whereas cpu_to_mem() is only initialized for
online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
use local_memory_node(cpu_to_node(cpu)), similar to what
__build_all_zonelists() does.

The primary goal of this patch is to improve NUMA node locality.
Although the actual performance impact is minor, it still yields a ~1%
improvement on a 192-core, 8-NUMA-node system when testing with the
will-it-scale mmap test case.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
Changes in v2:
- Make init_percpu_sheaves() use a NUMA-aware sheaf struct allocation too.
  (Thanks Harry)
- Rebase on latest code.

v1: https://lore.kernel.org/linux-mm/20260525082312.16012-1-hao.li@linux.dev/

---
 mm/slub.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index cbf6636a3dad..7d36e09ae216 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2757,7 +2757,7 @@ static inline void *setup_object(struct kmem_cache *s, void *object)
 }
 
 static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
-					      unsigned int capacity)
+					      unsigned int capacity, int node)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2771,7 +2771,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 		gfp |= __GFP_NO_OBJ_EXT;
 
 	sheaf_size = struct_size(sheaf, objects, capacity);
-	sheaf = kzalloc(sheaf_size, gfp);
+	sheaf = kzalloc_node(sheaf_size, gfp, node);
 
 	if (unlikely(!sheaf))
 		return NULL;
@@ -2791,7 +2791,7 @@ static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 
-	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity, numa_mem_id());
 }
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
@@ -5014,7 +5014,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 
 	if (unlikely(size > s->sheaf_capacity)) {
 
-		sheaf = __alloc_empty_sheaf(s, gfp, size);
+		sheaf = __alloc_empty_sheaf(s, gfp, size, numa_mem_id());
 		if (!sheaf)
 			return NULL;
 
@@ -7575,6 +7575,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
+		int mem_node;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
@@ -7598,10 +7599,13 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * For kmalloc caches it's used temporarily during the initial
 		 * bootstrap.
 		 */
-		if (!s->sheaf_capacity)
+		if (!s->sheaf_capacity) {
 			pcs->main = &bootstrap_sheaf;
-		else
-			pcs->main = alloc_empty_sheaf(s, GFP_KERNEL);
+		} else {
+			mem_node = local_memory_node(cpu_to_node(cpu));
+			pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL,
+					s->sheaf_capacity, mem_node);
+		}
 
 		if (!pcs->main)
 			return -ENOMEM;
@@ -8465,10 +8469,17 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
+		int mem_node;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
 
-		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+		/*
+		 * Cannot use cpu_to_mem() here because it's only initialized
+		 * for online CPUs at this point (see __build_all_zonelists),
+		 * while we need to allocate sheaves for all possible CPUs.
+		 */
+		mem_node = local_memory_node(cpu_to_node(cpu));
+		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity, mem_node);
 
 		if (!pcs->main) {
 			failed = true;
-- 
2.54.0


