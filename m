Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00200606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QjvgL409
Received: by kanga.kvack.org (Postfix)
	id 123F46B05B1; Sat, 24 Oct 2026 15:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC5E6B05B2; Sat, 24 Oct 2026 15:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039616B05B3; Sat, 24 Oct 2026 15:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA23A6B05B1
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D7981204EA
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:41 +0000 (UTC)
X-FDA: 85358453922.17.C3659D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8470D100003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjvgL409;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dscSOc4wXv4rqjBBHRKQ1lpGGhTgMmohkttLGkLRrYc=;
	b=zxtMfJZg3Epgc8CI8Oz23fYbC64TE6Ho69XRgQAwWrEinupJ2ytl55ZI9Tc7bUl16M2I+9
	t8FxgDyQP/xCrvmMNPrOOF9entaOvYGZTp3lI5gtn+ZALxfGN5GS3V6Qaisg+r9vX4uWee
	jihx1k6Hkha7VkZRLV/qok2pc/NZmo8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjvgL409;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868859;
	b=CNU3Yx9ljdC+HnsMdiqAFVMw3A10FBuilaOTKfdmeMaC4lpOXyU28kWO2kQLnRHi55T/pF
	ySlAr+Uop1gLQj6M+CXxd3PPUHuCzigSKY/T9Y5z1gedhcbPpMfixBbdZ5c6T8qCfCJRYi
	yCg9b0s6W3Ab/8zqNXvEdrJ5A0s2PGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9BBB601DB;
	Sat, 24 Oct 2026 19:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCF31F01828;
	Sat, 24 Oct 2026 19:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868858;
	bh=dscSOc4wXv4rqjBBHRKQ1lpGGhTgMmohkttLGkLRrYc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QjvgL409U++4546oq4u2khWxMjwP4nVSl578yOHefIw0n8w7rvouTst69VWHN5niE
	 tWiWKtBYrN8EZ64eHoPvq1VbruRDIC2jUrKzY8HdgI0ZETQ9/FEADVQq4dRZ0VL+S6
	 Itcdmqaaq2pa0th6qP/SIGGHiCjLUaAO16fILn2gr9QvCNRjPvMkpi3NKpgFr9SWET
	 +nh+UwA/ZaCzgA5Ebe+jGkJx6uL0wKqH97qxsFlEfXauR4EOlpVKDDbYnYD/0HPhHC
	 JJ5FWFEvV9JfUkdIRA6rpqGzbtJfg545JpTzbNsFk+muOGPI+9deNsuw7xGj5k/CQt
	 VIIizZfTtaWuA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Sat, 24 Oct 2026 21:07:23 +0200
Subject: [PATCH RFC v2 1/8] mm, slab: refactor slab_min/max_order handling
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261024-slub_tiny_rework-v2-1-bf1419ab5ffd@kernel.org>
References: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
In-Reply-To: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8470D100003
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dr1aprajn79romf138wcncd16rsnmj83
X-HE-Tag: 1792868859-627782
X-HE-Meta: U2FsdGVkX19PqAuxAjUHN+CJL2nJwp/rHmtyT+5VtlKy3pFxJi7BYMd1RBUcGS5JlA6CrvekTu06JSTj3AvGZI8g2voFvNNWzjH+aEh/V/unRa6UgLCOXezTHobYF4FYQv0ScCCyRvDYJNUXKA/s3MEmwUTAkfTj5Pk5icNgt6rekSHmTo7SQy6aohZzeOtkArXBtRl2MI/R3VmhQ/3yju5+8fFPy1NsxGiNGfIJWiQIusIqQ5k4/QFsjD690D7QiAdupWxkSgXVbYJq0wgkyHaVzE8OdCzDU100d6dqm9Bn7o1K4877mXBIsnlWq915o8LRyJ0aw3233VR5u5xriRN8u4bWuzDVRxumtJhIR1GrntBVIlEcOiAuiz3HO8h0wrisdtf1neUeHg+fOPoWJ0th85OiDcXWXaxUk4LXqfN0u3DlmWVr2I48VKvzMH9CAoeP+GfLGOQat3uVn90lzTqx0y80ZtuHdzjtfSoeVJFoITONbxk14a93fMwqFctsXFU5Bfo21B6xpvib3oh1pBv1G1TQ+d2+H42lT61QNB7PXjYegLEQH65soVqx05cpG3XTjnkbWtqUV4MX95HyJ1E5z6e5qx0XDv0ygN4/KZlduyI3QBNf4s8sV8L2ziZmsjMN9Xj0455Ja/LEtJLnFTbiecFbXk2AfaKCcnSwlEemIOoVuFVNUxK/UGCPEBByi69AJ8ZcvC55921EOTrs1xxCL2sKQfeCEAeVqCLqqwzlRV7VDR9tBQ1gyTNaxVDaqvMFkCgfCiSH+nqR2mrYJ4lNOBgylxCvrsrgvFuY22GnLBqVkWHxgYBwQQRCI67qdPTA6JJqi2Ho8dD9L49272c0qN008uhrYtKpFEMJi/Y1hz9ppTHD+MrVSxAqT5+QmaEVfZfFZY8+Cnso1YxLwYH6ub1GcbGFXHb1H/xDtTLQnWgWDSAGdMSeZPxb8R4pfnS1QTQtniRuvP5MSNq
 AouxKt3R
 hDwy93+jy6Z4ucMB1ECR+Jm7RRNPr8kZahg8jQRWsdscemWsIWkmTCvDFfoMpb6hyhJmf8WDJlbn/0FD6kLzMZAJ/1wfXxtGzucDcv1vDr0+po8bNMap4wd9k3syxMw9/5Z6LyKKR1gP9/Y2OWmiqQClcmyYesl39V2AyaK5sLXh3tpPYt2SARK0Asv8cwcvBXYSyjybJGH5X72bimTJF4Ol46LRy/B8UbRrYhn+ykpj130h7mf+Bw7kAKM2aVbymMDK6lQ0bqKNvu6EHu80oWIHxyk1QLBqGCr5i
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


