Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD9A606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYcRZS+I
Received: by kanga.kvack.org (Postfix)
	id E95876B05B4; Thu,  5 Nov 2026 03:44:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF8946B05B5; Thu,  5 Nov 2026 03:44:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6F36B05B6; Thu,  5 Nov 2026 03:44:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A60F86B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36974C097C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:09 +0000 (UTC)
X-FDA: 85400428218.28.43DA84A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F9B780005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HYcRZS+I;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dscSOc4wXv4rqjBBHRKQ1lpGGhTgMmohkttLGkLRrYc=;
	b=pMW4WTeEErfui9pQWKFKHsr8rEDpCIWuF83sk7/ESn5rpdibrMu536huNawYplo4nnFsRF
	3+xeqa7bbA2iPvAhoRtxRvscimY17tb1tNz0YaEhlwI6PaRLI457j2uRkLo5KSuJ9356Mv
	P6gmYcwo7WyzSmA5HvATy7kTnzeiqoU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HYcRZS+I;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868247;
	b=4+/FKqgYA+DIFEaY0k6GiLMNYJyVPoezQQknKWEefH6l2ttFkEX8NOyc8wrfeE0UvQIw0m
	3Jk2s2Pzj3n5ig9rPt0GKOGU8xV0BF8jlrpLSTCl/G6haVhQwmkfhT+YDKbHS7x3ekOTJI
	5KivE1spg+Cl5uR3+SH7BPvjeBMnmdo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF2641E50;
	Thu,  5 Nov 2026 08:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690C31F00919;
	Thu,  5 Nov 2026 08:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868246;
	bh=dscSOc4wXv4rqjBBHRKQ1lpGGhTgMmohkttLGkLRrYc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HYcRZS+IH3NA53qeNR1t7lz4cXGIw4wPZytndllh1xX6BjFxk9xVu4MPj/0y0gppx
	 gBxQ6+IiDvZN/iylabx+QlIM1/ycdY/WT4U+cs2pvu0qxXkh04JeCdNOlPT4rTFtvc
	 SgawymG4EUTOYuvcf9jvhDQx7pjxknUspHVXufIEsWImiPvkEXCt4zpTy/O8q0IVnz
	 JVcRHdr26gEy40ao3MlF7s0vI/8uElGcFnpatYKBtsA9bhFT/QC3zBXlBNNrGoU54m
	 N0iVrfinCnOX/CtJhnjbQST0TIBgxySs5zENnP5qZCIg55WwEOo5S96fxE3o46Z07K
	 pcDv353D0v5NQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:52 +0100
Subject: [PATCH v3 03/10] mm, slab: refactor slab_min/max_order handling
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-3-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: 8g37ks569nogwd1grxcwinimm75skizx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7F9B780005
X-HE-Tag: 1793868247-346653
X-HE-Meta: U2FsdGVkX18ZhDoF9pKoZUlBZXsHsB7j+cw9CfuUS0udbS/1PiIHrQ6d/Ez//FcGwDqy8fg0rgkf/b2cCNOyS2t+k4aFTWZu4VdKGBcRbgA3c/XTd2j/aNJ1KSGh4UWMefPy3vYhjlVHcO6/yeMKAO+RhtXyGQtuBAcBzpNFRJPRTaCHLU/vOkwU7aMTuE/CfRMxvTsxVSoppNowwVPs6Em/gyNYX0TkWH/rRJIaq5iTCeneYnCfpMshz91WITE/Op3BVupE2QDiPKfMXKaGdWe7zAmG93FG8xlws4JIaiWjdHo/+9cywUixlX7vNwWRnco5RYZUitTAyTMOWMEanOCEEFwJRu0VybYocWGthY2fPWg8OVaXDUB6/pfwDl3iK3l3+SeNyah6TjkRmKgkqbO9EFSArb9B51y4cYJTHwIJY9fpZCb1oNjEnb534UlswHSjHwfklv3gkg3kkHsube1fh7UFudOx2qyHEQiLeabHtCvcxnIzOJCxFQo/CaDrhbCESIZgyM3Gl5xj6GO9+ERDNe1p+3XtsLXwT32TdJDdtY/6xpY7EFiRt5FD5zxHUScKP1W/mgjuagl40zass4mJwFnOHsNxYQv5TXXSdYQpvhSELnAZLeZOVYxYsdt51RA/Oy+jHEunbI6fN39rwsuKzp5hHLjmhmZ+CSRmzmvQALtcI4f5qE1S/7SVFI9lKveh0yLGYz8Wr7T0e1+bMy9CrY+KDUkbYYribd++vPwBqj5xtUltuIf+rlkhgBk55zc+TgVJAl62mfCGNZ+mcT6GBlERD/2hED/ir4UNF3oYlLnY3E/MUDzIPYYW2v+zb+n9adyvCvWs0UbsP55DGWk6EofQLNiM452dWbZh/kQh10zpsyFfye1aa5jecNncgtaw+cAOm3YsAuYqoCJdeYqOxaaiXFmaSiIhrn/UTFW2w6Ic1I53GSlkKec+yUOaFBU7eR6mSj/HA4IN5k5
 m47GcDlz
 2ftTyxbEcC0dvjPycIr0/e5H2Q1KMJMEr0dFUhDOil+QrgV/WYAaTy/NczXoXRFXlyTYP5HXVLEcg57i/K/eeCZML4sJjnLuW5/nUz2EwM7vOu4b7KibGUAWJlZ8d0Y0gJqCD1rGqnrTKqGVMlTCZjl0wkh1+pEannhosPgXZB2wwOv81+gDWzTvEDFHq52w4MssKsMV8B92wRVN9WWB4vD83Iu20XjSSGHhfzxQ4VfvvN64UxR0ILJ/zedeEXFf6V9cffhB8cft06b9M5IXKMwDgrjwdIWIusmf6/ocP+gsyhlU+XFe2lgSL8B7WSxn3/h7j9mhmT2CljnE9jAKPE6HHhJqhAKg7vaROpJM1c0Ic9W8i4xj1WuXLqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 45e077c7526c..30714557306d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7684,10 +7684,17 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
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
@@ -7741,7 +7748,7 @@ static inline int calculate_order(unsigned int size)
 	unsigned int max_objects;
 	unsigned int min_order;
 
-	min_objects = slub_min_objects;
+	min_objects = slab_min_objects;
 	if (!min_objects) {
 		/*
 		 * Some architectures will only update present cpus when
@@ -7758,10 +7765,10 @@ static inline int calculate_order(unsigned int size)
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
@@ -7782,9 +7789,9 @@ static inline int calculate_order(unsigned int size)
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
 
@@ -8355,50 +8362,14 @@ void __kmem_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab)
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
@@ -8771,8 +8742,17 @@ void __init kmem_cache_init(void)
 
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
@@ -8823,7 +8803,7 @@ void __init kmem_cache_init(void)
 
 	pr_info("SLUB: HWalign=%d, Order=%u-%u, MinObjects=%u, CPUs=%u, Nodes=%u\n",
 		cache_line_size(),
-		slub_min_order, slub_max_order, slub_min_objects,
+		slab_min_order, slab_max_order, slab_min_objects,
 		nr_cpu_ids, nr_node_ids);
 }
 

-- 
2.56.0


