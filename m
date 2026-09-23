Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228D3C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CA5B6B0095; Wed, 23 Sep 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378696B0096; Wed, 23 Sep 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28FCD6B0098; Wed, 23 Sep 2026 11:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F00DB6B0095
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 81A5AC03D5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:23 +0000 (UTC)
X-FDA: 85245451326.19.6930D71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BA5F220007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL4l3eVm;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jL6ru8W93/pghvOJZnQKUsqwn9YkJKVX7X7ctsoiqVk=;
	b=CUFGikxztp4PO8NArA6OFu9OHkEIx5wNkK0ZAI3CGmo15om5Bef7/1C/Ixkp05YbyXGet0
	gHHaM0bDqy1k1rVSR7E9Vk93jeVd3Lb1tR28emKDeYC6COjt3mgNnk/nWzZVo97D3RRLQY
	qeFyw74+o64pZFED1OC7thOZjgBhXD4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dL4l3eVm;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178321;
	b=UqZL4++cBuw50/tYGWF0GG6/Ccpb6UwhA0tnFCM3nbVJ4Ac3wTWsDRgYDISw5A7ZEGksY3
	3+XR4qe1/7eVEdHhIt/mjXb61TZl+ysz6tCud/uMFxqco6AmV14x+2sbjDm9NNAd4RLFrZ
	0Jd+R8rUYq57NX5wk6YL6sZ0cMVLtGQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 176914109B;
	Wed, 23 Sep 2026 15:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43B51F00893;
	Wed, 23 Sep 2026 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178321;
	bh=jL6ru8W93/pghvOJZnQKUsqwn9YkJKVX7X7ctsoiqVk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dL4l3eVmaLLT2WHb7zxzZL2hqT7vg3xDyvQA/wb23CpMlcc9AFZx0w8JGwwqTISCc
	 dmqx6m3zKNXzq3GzWqqMD870ysrlqJgLZWWEIb4DsMGf+gjym1JbjwKF55hzfWoPBF
	 22yCi0okFCzlAHYC72BD8utrXVHzTn6tDdRScJwG9J64xIlYz3P/5wG5+qSzLk6ERH
	 UvxV0+BiYdnwbCx0WM6db7P2tRgyyhxlfwdkd2xDy5Yz4c8SJj8cTh0GCz0UrTDRxL
	 zEE4gZYv/54MnlAomBBeyTMb0gmstI8jSPBpiBKcJaMDR/RHIQiF+ywe1sC17mglgw
	 Kz2oGSIZawwJw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:06 +0200
Subject: [PATCH RFC 1/8] mm, slab: refactor slab_min/max_order handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-1-a0e66d536eb5@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA5F220007
X-Rspam-User: 
X-Stat-Signature: kr46w314mj1kge8cai1u5d33ci9fswi1
X-HE-Tag: 1790178321-211832
X-HE-Meta: U2FsdGVkX1+MhuSRlFRax9V/1Eode50O4iNtjKxho320iLPsZBnxGwinYMPp5PMEI/iS5YdC16ztTfugkLO0J7ToVxZAU9PTjs00ICv12o+ez9QCyg03vsZQCdFYeGFZGAjR8R24NedRVBwFGpfvuiFIGE5apScbGQUOmO9x7XgMhfmNXl81Ju8VSqUdPH4lR++aQTXqHunWSMt5et5eM+CcSjnVn9tc7u9bVvXiUQvw9ErLKhtCpXUw4f10jMRRNvOdDZYlJlNmJPpQJjGSqCw3lcViXdfLcUEF8ZDfnWSC+lbjGRZjGvNfEEx57TjcfAdFZHy5aPvk+eDxgFupZw7bXlZnrYM/dagpIatTGZJPPGyHmzpQIDBmn7sM0nqEspS0cbs82ZCWd7GyYG3Jp2cQHYExtvDjeGEDHvwA1G65Xt8mMFcI8dvXr2M2d8YXdjXR52OVCxNpoE80dt8orSRAgAusJeLFT5RCCOoq+afL0raSfogeyjmjEby9tREyrEyUjILO7TzaCupS+MwAomnRrBpE6iPQIyTh3blUDXh08uigqon9DPIBUk1mShcrk/XYev/rwGlzUFrx8v/rxCteJLBjXs/CwFUhHrEM/JC0sFe66LxFvIZ+AjVSrrDFVy0e6Gw3C8T4KYk7aiL1IMNxv5K1my88XgfpGN0Ab8jCEQY1NgbvPmclnu3dhEp+aPOvCaLFZ/+C94wJamAW7xjDstHMFwDp/aWgMaiB06u+2M0uM1TU+ui5kfC1UKPE7KTYRIRd+f81v78Z/Mt0ipy/icSYPUM5DK5fTyR66sdkIAviZipUkk5fo/BfBW1y2d3vVem+VdOwm5YBqgvnmreGGQda+6IKTomuIpHgSM/aFKvtAmHZf+lltQMkV3bquZan7FM7f8NJLY3WI8pA47u/WfASbULN2yq/pHkGkfINNpw3mWjiv/A7AgxqxsfTzF1ATMqtVBU0sdshNzK
 tQFtFxAM
 LK+iK4RarX4Dz1O/FdzXpeDD+cGOZ2ENmrDzZIJ5zjwZWq9DLtLSJMWqAIGtSuI0+ZxyJv0EnyllYTo+cniescCstTkeMM3YvacubEm1mPyF9TdCK2ZXSoRXiC/QeQwK5V1uWd8mvGq9dU8OpsEfTbDA1X4ZlpMpzhoQ30BoklLi/EOnZgR4TOExncl/G2Yheniyn+jOqbpAomezAr2MXSurhi0QpHGGqwDcqXXqb6Q5flhUO6zbXnrHpNQfBNVuspy/51O1hvPSeTV7WynV9mNf2gVFAaQ5Lz6HG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setting slab_min_order and slab_max_order as boot-time parameters
currently has several not so great aspects:

- slab_min_order is not checked against MAX_PAGE_ORDER
- slab_min_order can raise slab_max_order
- processing requires custom callbacks, their execution order
  depends on the order of boot time parameters specified
- upcoming SLUB_TINY changes would be more complicated

Instead of custom callbacks, introduce __initdata variables that hold
the boot-time parameter values (if given). All inputs are then evaluated
deterministically in kmem_cache_init(). slab_min_order is always capped
at slab_max_order and cannot raise it.

debug_guardpage_minorder() still overrides any given boot time params,
but it could be changed if there's a use case.

While at it, rename the slub_min/max_order variables and
slub_min_objects to have a "slab_" prefix instead, as their values
determine the sizing of slabs, and the "slub_" prefix already became
deprecated also for the boot-time parameters.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 84 ++++++++++++++++++++++++---------------------------------------
 1 file changed, 32 insertions(+), 52 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 96dca4846b4e..a107a111c75e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7598,10 +7598,17 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
  * and increases the number of allocations possible without having to
  * take the list_lock.
  */
-static unsigned int slub_min_order;
-static unsigned int slub_max_order =
+static unsigned int slab_min_order;
+static unsigned int slab_max_order =
 	IS_ENABLED(CONFIG_SLUB_TINY) ? 1 : PAGE_ALLOC_COSTLY_ORDER;
-static unsigned int slub_min_objects;
+static unsigned int slab_min_objects;
+
+/*
+ * Store values set by boot-time parameters, to be evaluated in
+ * kmem_cache_init(). UINT_MAX means they were not set, as 0 is a valid value.
+ */
+static unsigned int slab_min_order_param __initdata = UINT_MAX;
+static unsigned int slab_max_order_param __initdata = UINT_MAX;
 
 /*
  * Calculate the order of allocation given an slab object size.
@@ -7655,7 +7662,7 @@ static inline int calculate_order(unsigned int size)
 	unsigned int max_objects;
 	unsigned int min_order;
 
-	min_objects = slub_min_objects;
+	min_objects = slab_min_objects;
 	if (!min_objects) {
 		/*
 		 * Some architectures will only update present cpus when
@@ -7672,10 +7679,10 @@ static inline int calculate_order(unsigned int size)
 		min_objects = 4 * (fls(nr_cpus) + 1);
 	}
 	/* min_objects can't be 0 because get_order(0) is undefined */
-	max_objects = max(order_objects(slub_max_order, size), 1U);
+	max_objects = max(order_objects(slab_max_order, size), 1U);
 	min_objects = min(min_objects, max_objects);
 
-	min_order = max_t(unsigned int, slub_min_order,
+	min_order = max_t(unsigned int, slab_min_order,
 			  get_order(min_objects * size));
 	if (order_objects(min_order, size) > MAX_OBJS_PER_PAGE)
 		return get_order(size * MAX_OBJS_PER_PAGE) - 1;
@@ -7696,9 +7703,9 @@ static inline int calculate_order(unsigned int size)
 	 * long as at least single object fits within slab_max_order.
 	 */
 	for (unsigned int fraction = 16; fraction > 1; fraction /= 2) {
-		order = calc_slab_order(size, min_order, slub_max_order,
+		order = calc_slab_order(size, min_order, slab_max_order,
 					fraction);
-		if (order <= slub_max_order)
+		if (order <= slab_max_order)
 			return order;
 	}
 
@@ -8268,50 +8275,14 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
  *		Kmalloc subsystem
  *******************************************************************/
 
-static int __init setup_slub_min_order(const char *str, const struct kernel_param *kp)
-{
-	int ret;
-
-	ret = kstrtouint(str, 0, &slub_min_order);
-	if (ret)
-		return ret;
+core_param(slab_min_order, slab_min_order_param, uint, 0);
+core_param(slub_min_order, slab_min_order_param, uint, 0);
 
-	if (slub_min_order > slub_max_order)
-		slub_max_order = slub_min_order;
+core_param(slab_max_order, slab_max_order_param, uint, 0);
+core_param(slub_max_order, slab_max_order_param, uint, 0);
 
-	return 0;
-}
-
-static const struct kernel_param_ops param_ops_slab_min_order __initconst = {
-	.set = setup_slub_min_order,
-};
-__core_param_cb(slab_min_order, &param_ops_slab_min_order, &slub_min_order, 0);
-__core_param_cb(slub_min_order, &param_ops_slab_min_order, &slub_min_order, 0);
-
-static int __init setup_slub_max_order(const char *str, const struct kernel_param *kp)
-{
-	int ret;
-
-	ret = kstrtouint(str, 0, &slub_max_order);
-	if (ret)
-		return ret;
-
-	slub_max_order = min_t(unsigned int, slub_max_order, MAX_PAGE_ORDER);
-
-	if (slub_min_order > slub_max_order)
-		slub_min_order = slub_max_order;
-
-	return 0;
-}
-
-static const struct kernel_param_ops param_ops_slab_max_order __initconst = {
-	.set = setup_slub_max_order,
-};
-__core_param_cb(slab_max_order, &param_ops_slab_max_order, &slub_max_order, 0);
-__core_param_cb(slub_max_order, &param_ops_slab_max_order, &slub_max_order, 0);
-
-core_param(slab_min_objects, slub_min_objects, uint, 0);
-core_param(slub_min_objects, slub_min_objects, uint, 0);
+core_param(slab_min_objects, slab_min_objects, uint, 0);
+core_param(slub_min_objects, slab_min_objects, uint, 0);
 
 #ifdef CONFIG_NUMA
 static int __init setup_slab_strict_numa(const char *str, const struct kernel_param *kp)
@@ -8684,8 +8655,17 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
+	if (slab_max_order_param <= MAX_PAGE_ORDER)
+		slab_max_order = slab_max_order_param;
+
+	if (slab_min_order_param <= MAX_PAGE_ORDER)
+		slab_min_order = slab_min_order_param;
+
 	if (debug_guardpage_minorder())
-		slub_max_order = 0;
+		slab_max_order = 0;
+
+	if (slab_min_order > slab_max_order)
+		slab_min_order = slab_max_order;
 
 	/* Inform pointer hashing choice about slub debugging state. */
 	hash_pointers_finalize(__slub_debug_enabled());
@@ -8736,7 +8716,7 @@ void __init kmem_cache_init(void)
 
 	pr_info("SLUB: HWalign=%d, Order=%u-%u, MinObjects=%u, CPUs=%u, Nodes=%u\n",
 		cache_line_size(),
-		slub_min_order, slub_max_order, slub_min_objects,
+		slab_min_order, slab_max_order, slab_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
 

-- 
2.55.0


