Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 332A2CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DEB6B0092; Thu, 18 Jun 2026 08:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34ED06B0093; Thu, 18 Jun 2026 08:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28DFE6B0095; Thu, 18 Jun 2026 08:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02FE26B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:36:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26E2190AD5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:10:20 +0000 (UTC)
X-FDA: 84892613400.18.90CD73A
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06A9B1C000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:10:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYtY25+h;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781777418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=l+HD+s8JWgfwWWOKKHpxeLeLnAP3UnMEfrdGWQ0SBAo=;
	b=zW4W32e0vJAoWFJu5R+thkXM9Kc4JK2doReRKw3FtkP9kHBOMR+TMbpOYrIc3ALHkeiDy2
	Oj0bRKlGESXEFC1MVm4MFf8mOq+QpphdxXWP3gKIpL/HaN/Uz4kjResEp0qcxQZoqf4eJE
	9gxbnt8veuMr1A4H0MZb2/lg4B09+ms=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781777418;
	b=c6DzkrMVfkdBo7/YC/E+M0mfOcaouc+Vy7tjvxy/LcczgfqnUSzje8fTJjV2d57grrPdsV
	MonC9LgNk0NCCOc4Z2mfFcwPtOEMrIY5N2wTQywyzGKLU+x7Scm32ho8Lx9M3e92rTTomg
	98XnaRUIErxyVNg0MUoTcT9ELS90W00=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYtY25+h;
	spf=pass (imf18.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781777416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=l+HD+s8JWgfwWWOKKHpxeLeLnAP3UnMEfrdGWQ0SBAo=;
	b=JYtY25+hFIyt/k7UgYp+cbAS50ZBAiQWvZAI5iGFiNLn3NbSYmZ918QHKw0Y90jnhceWOG
	5FuccA6vHyheCbfuBqi81src8GikA+9gi8LJA6LAAGbgTUAT200FHI7cD1uVtMZjDKrlK8
	hMSWXalEasZbkpM/bDlmzUwPOfyYvs4=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm/slub: deduplicate NUMA policy calculation in allocation paths
Date: Thu, 18 Jun 2026 18:08:52 +0800
Message-ID: <20260618100913.346636-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06A9B1C000C
X-Stat-Signature: cdzpjbrhk7g7yhgeghsmsddjp1hkes44
X-HE-Tag: 1781777417-259847
X-HE-Meta: U2FsdGVkX18cFFeu3FuE2XSyMH3TjJAU/GxF/UG21iKRTVMqcpHfdPyyPOQ2JVCWBG7jCmU8/rCKTqF8v9VxMsQetUZppt0rTI3/m5LpN1osLKeniYOzfo4hRuvZl9OCZPEXVIs3gRVy8l6aNCKv6jwNpaGyWpdBCcw3/KvQ8Bfamh8lyeeoVCYYgA7qLIa1AB4wSzfrFFeHA95EQqyFYExPMObjjzpwZF5vqLoglXTjaPslnlODp1RegAVvtKdrX1saElT972rIUkzISZGlwUqMuDo+CIQEykK4Zz/zl46y+5PsN31YYOz7SrGe2FidSw5sF5ePgKnJFit7f8dNop2F01Xq4jDQMCAPil6suFtZ/c3kQJGUOQODQvNmUH62Zu3Uc0Q9a4NB44qituiHRzjnnzbw8V2OYaCKUOce56G1RmcMqcwy1cHH0WbEWlPglUWZWXDN8bNbWBmJ636E4gLXs8kvjA58ckmRIuPtKJ5caS9z2c1729T7Ndo1+xTEX/C89FxEDI+wa6hpDGr6ZvAStizI0ejvhWDzHhVKTBX56l1ty9JgYKWZpuLxlottZarranLs4TuUT5RH9zeHV+QXmVVh6sfqvq2Drz+16SbE4DAho/+eer7Vs7TG3YIDNL7QHUjQY05quKaSdXXqufLwj7BcbHdCE0HtRDZYy2FRCQEfC1yhygp3B5fJw1qr7S1RPPCNFu25O8abBk43OQh1ZkbEwDRg78QSJypbgtCsKIpALdKRnoaxV/IBXGDV2ewjq9x3aO3/kn8M86IWgaXJ+ubJ4q6p+tr1hzjjSQeWgDFk5sd0Zeui2negWIZlDZeIvO5sj8l5AHAzFWFfSm2gLNwGD9UNbwCbbYi2YPOSDYm68AQ6kxJ7Vo+inEfdaJXMVt4L1S1O7mNte7Q1CGR/0HgtRyKgf3eLpcNeJ6DlYRlO49gz1P2m0685+/0EUa6zsbtEOD/CeAFbcN2
 o2E1Gh2I
 KkbdpdFl73C0Chp78z8AVwYswIO+cuQUggogaR1tnGwQr/Yg+uBZml0v5ooknSROmUs1WzjhcyDY7HA+d2C9SYyDuFCOW4yaCk5vk8Z7weGGtkShBsHYsfICdzjGY9cDFST+fkPhVSzwGhO7S6dMEilHFPnVkWdgqpx6v9T1m48TqAa2SlLbyU7H2Nko5WUzbVLi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
NUMA policy independently. Since they are called consecutively in paths
like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
redundant computations.

Introduce a helper function to resolve the NUMA policy once, eliminating
the duplicated code and reducing execution overhead.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 72 ++++++++++++++++++++++---------------------------------
 1 file changed, 29 insertions(+), 43 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 62e9cd46916f..45e9f379b7da 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4523,32 +4523,36 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
+static __always_inline int apply_numa_policy(int node)
+{
+#ifdef CONFIG_NUMA
+	if (static_branch_unlikely(&strict_numa) &&
+			node == NUMA_NO_NODE) {
+
+		struct mempolicy *mpol = current->mempolicy;
+
+		if (mpol) {
+			/*
+			 * Special BIND rule support. If the local node
+			 * is in permitted set then do not redirect
+			 * to a particular node.
+			 * Otherwise we apply the memory policy to get
+			 * the node we need to allocate on.
+			 */
+			if (mpol->mode != MPOL_BIND ||
+					!node_isset(numa_mem_id(), mpol->nodes))
+				node = mempolicy_slab_node();
+		}
+	}
+#endif
+	return node;
+}
+
 static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
 			       const struct slab_alloc_context *ac)
 {
 	void *object;
 
-#ifdef CONFIG_NUMA
-	if (static_branch_unlikely(&strict_numa) &&
-			node == NUMA_NO_NODE) {
-
-		struct mempolicy *mpol = current->mempolicy;
-
-		if (mpol) {
-			/*
-			 * Special BIND rule support. If the local node
-			 * is in permitted set then do not redirect
-			 * to a particular node.
-			 * Otherwise we apply the memory policy to get
-			 * the node we need to allocate on.
-			 */
-			if (mpol->mode != MPOL_BIND ||
-					!node_isset(numa_mem_id(), mpol->nodes))
-				node = mempolicy_slab_node();
-		}
-	}
-#endif
-
 	object = ___slab_alloc(s, gfpflags, node, ac);
 
 	return object;
@@ -4756,28 +4760,6 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags,
 	bool node_requested;
 	void *object;
 
-#ifdef CONFIG_NUMA
-	if (static_branch_unlikely(&strict_numa) &&
-			 node == NUMA_NO_NODE) {
-
-		struct mempolicy *mpol = current->mempolicy;
-
-		if (mpol) {
-			/*
-			 * Special BIND rule support. If the local node
-			 * is in permitted set then do not redirect
-			 * to a particular node.
-			 * Otherwise we apply the memory policy to get
-			 * the node we need to allocate on.
-			 */
-			if (mpol->mode != MPOL_BIND ||
-					!node_isset(numa_mem_id(), mpol->nodes))
-
-				node = mempolicy_slab_node();
-		}
-	}
-#endif
-
 	node_requested = IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE;
 
 	/*
@@ -4927,6 +4909,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
 	if (unlikely(object))
 		goto out;
 
+	node = apply_numa_policy(node);
+
 	object = alloc_from_pcs(s, gfpflags, ac->alloc_flags, node);
 
 	if (unlikely(!object))
@@ -5430,6 +5414,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 		 */
 		return NULL;
 
+	node = apply_numa_policy(node);
+
 	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
 	if (ret)
 		goto success;
-- 
2.54.0


