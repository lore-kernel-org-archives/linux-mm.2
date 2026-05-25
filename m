Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152A8CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE846B0088; Mon, 25 May 2026 04:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286466B008C; Mon, 25 May 2026 04:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3516B0093; Mon, 25 May 2026 04:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058F66B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:23:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9F71F9163E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:23:48 +0000 (UTC)
X-FDA: 84805253736.12.C23667A
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 168A0140008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:23:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wcq/tjVp";
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779697427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HFN1D7/+D81myf4e4MmmURImtWjMJ87+3r+yuGuUTwM=;
	b=MPclM5J6JohjIXA85RzzRj0YGynlLxruIJGoW4JcseP+xXUBVc02bTZ6rUz0TTbXSrSwhd
	GHBIiU+qUSKs/D8/9AjvLH2i/gknVsczrVQNz7vpZHU9Bvo6suwNSz7lRxObcZWOmBCZaR
	tlM6ieRBG4Gwx8FlK2opwuOXSz4dwa4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wcq/tjVp";
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779697427; a=rsa-sha256;
	cv=none;
	b=CJ/v0tdwZQEGfKdv3riOjZVWPUwDE3C3MMQIDl+SSDVU4SAk2nRnq1broR/R0OfPaB3Va1
	TVZalTp2S5Ip/6QF8FfHPuQTFq43WYOC5aUBMcsIacJFtVhEcCCaPlM9ZhmjPduPbhrIfy
	FKk8K+orCutwxe0UksvYNurDLTq0KTg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779697425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=HFN1D7/+D81myf4e4MmmURImtWjMJ87+3r+yuGuUTwM=;
	b=wcq/tjVpC7qyKukhUCzKmt24dmcGpCU2eHtWHhmC9lHTPX4W/9rVBHOZSbrsWmaV79yxie
	h+1iAoj1jkZ7Yrnr9TS+kLhgn+0TY9K1+F3/zFXf2nT6R0zqAebAOEcspRqoCjwYEPrRWk
	AmTsrax+o15N9nz65XiAr0V38z/JzWM=
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
Subject: [PATCH] mm/slub: allocate sheaves on local memory nodes
Date: Mon, 25 May 2026 16:13:47 +0800
Message-ID: <20260525082312.16012-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 168A0140008
X-Stat-Signature: ytgpabt5dpd5g5yebc6g1humiqip3zg1
X-HE-Tag: 1779697426-142087
X-HE-Meta: U2FsdGVkX18Ye+BP9PXs4Le2GYvEUMkL86h35F2aPKUwxratbsln6Jd5tuOcfY3euTjjmYjFj+qFQLq4b25zu7IH0x+gKHdxQ4Ieyk4CoWCXM4SnRFtqL810/BHxrpty1nrAcf0cDHcbqla7b5mAMng5On0XXZyDLtgz2oTUAKq/OOddmd8pus+ED3w/+YMUlIIA6176yEf4PH86ysk6iblsLy8hiDc5d6c1RV8Wuj2MpUg9eva1gyTWl+LXlKp5rnsZkkRWrP81IsSDla1hH/lyTgvuCyiyePONxsd058U0ZWNpyi4AgT1VqSwKj2pG+5evQUsBIPBxtS8cup8/GYYiQokvdtNs7NdexJuDuYEm8tKEopSZkRGgk0SumH5HtewVh8VLi6WE+wDOtjociTAIKQ81/KnvZ/AuTx8D7wqiDfu7EurlZaycX6Y3WqGh6IEYeP3gjds4L/rd5Z22C8cqmDgR6SAdYXV75evjr1CiqiqZDscg0qEvYT+Ktv5ELZYELUbzVEYZXFmt3uZUcR49SCFocfuuaAPVulow8FUlCJnYxvomUKeZkzJSVYmrHWy2FXMfbG1q3Jhz1Id4YiQ53rsY/fWsWpo46hcWkA8MfRKJ0KzNR+Cpu1F8wvE+pslaBmQJHwe8BVroar+Rqr02HdDB9cRwRCfNQuxO+539EdxeLucruYAVajgKYPifvShu8gcfQbnv0M2oIW6R4Wqll+wBZ0T7YsOJHpjHvMja4A0z8UWe6dZjcdsoMKeLPvWOMZLXkKBezEa2GxvtX6Xv/tFvGys7TCGJ/9gWCWZ9gTPC8LD2Og+f1wjhbDZA+6aY0Zrw+w6Y3djALcFYIfMIJ41yslfJTI9Mpt6+nEOdLt6FOrwwH4mBs5du/bA4Rnmy33CtBNfxCtQm2smWu+cS3z66YWWCeVFlI3rnGYQp6BTVY4ruqgfSWIiqkTpFE/JeGWmB9bK3AcUlHDS
 m7DNr5tZ
 Sao6SAUNEd2xKmF8Zgi7+JfsQbwub7GHUaMFomQsb+UGjN30qChnmslMfSQTGQVCPhIvxsdxFQfPLxWtdpbyEW9I2ASBT6VCG/goFAgAeKTtBIJpDGDyoNn0rcdSRBmi4fiZOpNNpmzTOY8sPFlQx10ibrovAW4eHreMYXdK9g9Rf0Kd5q056NpxeKHpZ7x69rchM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sheaves are per-CPU allocator metadata and their object arrays are accessed
from the local fast paths. Allocate them with a NUMA node hint instead of
using plain kzalloc(). While no measurable performance improvement was
observed, this approach is theoretically correct.

During bootstrap we allocate sheaves for all possible CPUs before every
possible CPU has an initialized cpu_to_mem() value, so compute the
memory node from local_memory_node(cpu_to_node(cpu)) just like
what __build_all_zonelists does.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
This patch might conflict with Shengming's patch. Let's review it first, and if
it looks good, I'll rebase afterwards. Thanks.

 mm/slub.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 180973a4a3d2..ff1b1e932719 100644
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
@@ -2776,7 +2776,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 		gfp |= __GFP_NO_OBJ_EXT;
 
 	sheaf_size = struct_size(sheaf, objects, capacity);
-	sheaf = kzalloc(sheaf_size, gfp);
+	sheaf = kzalloc_node(sheaf_size, gfp, node);
 
 	if (unlikely(!sheaf))
 		return NULL;
@@ -2791,7 +2791,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 						   gfp_t gfp)
 {
-	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity, numa_mem_id());
 }
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
@@ -8413,10 +8413,17 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
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


