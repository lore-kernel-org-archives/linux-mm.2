Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910C1606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O5dD2v5y
Received: by kanga.kvack.org (Postfix)
	id 622836B05BA; Mon, 16 Nov 2026 01:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA026B05BB; Mon, 16 Nov 2026 01:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5101C6B05BC; Mon, 16 Nov 2026 01:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B03C6B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A22E81C42B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:31 +0000 (UTC)
X-FDA: 85440051102.07.D8E84C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1359E20002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5dD2v5y;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811650;
	b=yuqoIsGYVmyJx+zrJUMB72bAzSBxPntPpxhN0Pgt46QcRsPFhOrILjqcEfMAjd3EcNIaCM
	HcSxpCk6W/XKfk+fDh1ubcA7gqxtIEy76n4em1Cn2OGn9PIrT1LaFLv7FcldRM6JSL/fzz
	2yhQ7iWQVAVs8R6YI1z2VZLHMvU8Dmc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O5dD2v5y;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gc5nVXFmpa2FYzNpiPky+TSsIO9QRIgf+0xNVO2950I=;
	b=3oivOh21SYZdw2BD68Ml8CiEh7yr0BJMNl28zIFgWEa00Jv/WruYFja5plc9pFvrunWxDr
	ETOEX79YATDSiA/fPcU8sUqzNAxkPBhwU+SN6xFFALG+L6FQA3o/GqaeHZ2yQLtiYbKWaA
	w4GLviFJDHpO/KRn0vgU17CJDWAN5A8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A712561ECC;
	Mon, 16 Nov 2026 06:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2637F1F000C5;
	Mon, 16 Nov 2026 06:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811649;
	bh=gc5nVXFmpa2FYzNpiPky+TSsIO9QRIgf+0xNVO2950I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O5dD2v5yu5J8xhy7sLPwd8o1ZenNXCLx3LgiAqlz+xblx0jU5kst8YgL1FzGksOMI
	 Cdmw+8t33N9Lr2RFsL7lc4pfxDksNxt/p+GEvfl1tdhkKJ1c6nUk3OBNbJ19E5cYLA
	 /EiT2QwT6tHdhFxSWoRSONfUznDnKd7SIl8H4vhCJyPHDjrloiq7/CLzTyBH8cpIIn
	 EW04UJZPD4cUPBJNk36PRasfzLGgs0UdabevdEy+Nt5SoALqKxqtkNryrDqwkPIXjt
	 qmQppbrnNfmObfSslu6C6MCui7Y8obF7XEWUGD+rkGdYUowoq5vXboe0GrhxtZvvoj
	 FyL24kkvR9HeQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:11 +0100
Subject: [PATCH v4 03/10] mm, slab: refactor slab_min/max_order handling
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-3-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
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
X-Stat-Signature: ctaqf4mcgu3i4bti6u9kqc9d1e3ummsq
X-Rspamd-Queue-Id: 1359E20002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811649-258390
X-HE-Meta: U2FsdGVkX18NemKOT/1Qk7M24EZuwF7zcAhHDZinv1LnHxhr67VtRRqz4RZ0uQsd/q4kefOIdGmpQx2sFeGeP6iV10pEKkLmWdOcYeCWqH8ZeVdxUbO+CnLoXTwJO0KHmNwrI/ivItEhOK+2uGS3nbBicIW97fnMgGy5ht59zKkPIC64H8E77fYnlE81lKxaMqDbzvQBcdKOkmM6G+O8ChOfQ4BNTIFnFReIJDwH7Qnb3gtJ7hcpj9ksi/VGgBs2kZtwgfFQPKLOrukW1a1eE+yuDcPFm/DuX41KK7YS637i54JeK/FyQhiLKXUUCvHekoxboUTLKpG5U+Be5lb2rV2ERhiI7aUEmZDCk1/gJpOlLuccA6Nemszwhou1REuZuZiPOKCCpkqlmwSkXlaOn7f0JTxSGvLKzXv6s2j3eCzzZRoDd4zCq1+QrZuPyxw/WxWAcyEXqSpHe2pqScGDexBeknSUyDdiVPDXxQeJlVmHBS0UnAtba7PRW2BijkX+ReFjO9EJcrAEC4C0vH5EDcvyNsWPv3EpVgRh03EBupgxqxAqfjhVpWzLl4evWAhkyjHzshIiSJ8MsSuxGvypyn1gLY0ef73WbGqcq3JjbsjIfTCdmx4ywiR2zaI5BCtG29hH/guT+rVi5E6MAGwIjjNt/I6BhW0mzEPNnaxpk1rSxkVxd7iZqLn/YW7TpplKeidm0hYv8LCqH0Du6vT5wK5SjE/G5SCMq7osueJV91bMmouTd9JnejaVInynKf/LWMLCVkSE5aq4yIXAco2c8T4QUnlBMwE81eVlO7VYlAyx7HR7qYCVo0EdN4BuoHWEote7C0Psj00Dhy9ziR3nR45nqa5w4seFyg5Ps6+FPWKP+E+SvhSNiHsQZJ9WrpAkA65cOynHRT/q9Xs3uKuXG0CCdHgVHgvvtmNxM2/hDSU1f4mgxeCDGpXwAKUJ7NuO7SOIk8fEeYl17J0tJwf
 2W/7Znns
 qoFcdfSvmF5Z667eIqq9mQEZd3kETkS9KE/QOp+yJw7ZAOtZ1UWVXsqMJzkyq+zO5VQJC9WdM+Cab9HLlAiAPnX26yt40uepH+D42xegzRBIvrAIGMpr7g6IcO3tQClr+ocAl9RZ6gebYd3qHnGpbz2hbqtw2AXxlkOwv8BC5VdABfgk+j6eV7P3AmbEcvuvK9IAEb9aBWMWDUhjds/uPz6M676QvWhldDNn9pR2gSg7CjLxHSLl6O2Nk3p8WVIO1k8oui94audNsd0HBL1833hNJCk5PY6hrF+v8ivYTygAzgAiiVJwl22UFBX0GEOItHTIEe4fAJtmUR3d6gfHqLicRLZbKcCCEFtXf7VcUA//vRW3Q6oWja8gi9A==
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

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
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


