Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03ABC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698226B009E; Mon, 20 Jul 2026 10:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6226A6B009F; Mon, 20 Jul 2026 10:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EAB76B00A0; Mon, 20 Jul 2026 10:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28AB06B009E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2895C01CC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:49 +0000 (UTC)
X-FDA: 85009356138.13.7365360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 072D220006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6IlCXMd;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3U54YmCRY/GBvsj3bANv9/dOilD8BR4I8e1Q/zY4xQ=;
	b=4VcBlZoMPpf/Mr4NtqHOQZJT3h6VrhWYCIr41Ea37EsPUMeGHWe0GGP+wnATjL1wFeT/OD
	0Zbl8o0K4pUI52NkSqhM8lsc5qAHDKIAett8+y9UKC9hTaPvRWsnnjCqJ1t3YXAlghyaPW
	zFrRxhM6QcDddpiRqX+HkinI5nrBzB8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557008;
	b=ZDIYBrZSY3CpAzKQD783vYAm22jB0HtH7ZmM9a7+ziSszKUKIPVw2IAF6Yedbcq3+BA53i
	7teD2F45eN2RpZFfoKwZmx5rK05Jg2wDS1dWUYLai5hm9y0/RQqI7k2sP2hSkZOL/uy0kc
	lzJA80b6P/QX5uBGx+YZ7FmkPPpEDU4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6IlCXMd;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C3DC41FB1;
	Mon, 20 Jul 2026 14:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D66F1F00A3A;
	Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557007;
	bh=D3U54YmCRY/GBvsj3bANv9/dOilD8BR4I8e1Q/zY4xQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O6IlCXMdef44TD7zJDcvT/iuRPSZckHKHRWd2siui/LxQAjoo18KmQMbMT4tgXl1Q
	 1X5kY0W9M7JYIxRhNTGXKCEnC5UX2HkNMjlBvC6arD+edzA/ECMxxPXTLp8X49UX1X
	 9rG1xY2R069IV3CexOp8B1LPpZtquCZu49DQdp5FI72jor3t6olgYxL3klKFc+7Ivn
	 sJgOjcCx8hnR7a4ZBe+GPek4JDGE2hScWhpZKI6dU+iwzwoyU0aCcaxJf2q5uYwF62
	 cJ4jGLvHqKi94GnJMWMn19jujSokl6DzGH4mCi+hjXVb9Wyxydr1tXjstWaMdzyhJt
	 BbwufI9yG6TWA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:20 +0200
Subject: [PATCH v2 06/13] mm/slab: abstract slabobj_ext.objcg access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 072D220006
X-Stat-Signature: mynxjcuwghgs5srbcbpdqeizgcuobp6b
X-HE-Tag: 1784557007-20451
X-HE-Meta: U2FsdGVkX1+eL8/Dkh4CtMg6VuJowQXDzWUjcBYKCMZptOdKMmtxqNSll2nTmKijNFqwBU7oBdw5Wfe+N8Kw2Qg51WAzGZGrQqaPf7deI2irGzq9ZRA4AWv0WCjMbjieA4jZhAA4cjSv/uWJxJTrthz4B97wKfa9H9IzbC3KhMfKjXEWZ1FNbfkGkuSzZQo03spyPGsibdcQn6AAfAfjwXEhjL0x0zt6ks++hbeqeF7LKBKhYNM0266/HhfIaboDttciJhg/u7hqYgi0Z0ICOPEIbp7r5SUbFCZ/5sUOVdjPICp8oZfq1cSUM9cIr0rEgCxV+9rxRoJxpiEEMX5Y/Aioau5jub/nsEtD1RUFAoruR+V61EqeUyCl4cQppd9TmBpVaCqk5+KMdJi3Ocaky3+IZZFfpT6+42orp6xSLMkvcL55mhhXR2syUGKLVXKn4NjNCnRIXX8hfGS2eRN1y5/cmgqbasjsPnKxKmp2j0SrSJfDBHlkRjfhwd9seMyhhAZWF69CDcpuL/1E5Uc2TPY/WFU3BVIGOYVfdxwjmlUBfhPHIEMt0nDHKMtIbhj+Z85H8FPXQ7K8QJnvnF57LNDSQMFNCAyyLFNRlkXGGNgkw1Qky17hRC4rRenUDZEGIq/d6AhJHJC2q/CZLvBz3nyBJGt19a8mRn8FyCLP74CbhaxQAUAk1KESHG9CFK69uuUTlola2ANTFXMtYRvHQ6+aHGnmWOR8YIB/OUUFWfLg3oMkVmlaFVPEt5r+jgagzGAXnbqcUgrVHk9kemU/In2TsiDvbxZoIEegH6VUWF4n4uOLolmBAlx3C8coXAIRHiv0X4YZG/7zAwt25Rz7b1TalnreCrWngclbyfP26jZdA+PP9MyYW7140ABbtNVQyvDUowvEXNxOm40BbDIIDj7Z4X7v7Acg76iuU8AAjRq2pKNHvSzZPsL5rwlncOEY4O3sxlCVhJoF1i17knJ
 WeJZPU85
 Bv4MGwERhWZTpnX7n339MXCxWsrUoUyk3iOmXSSw+KXZf2Mj7qrfPpj+4xMC2SeJkbP1+csqCYfH/ZdLlf7dtW0/4NW3q7xs8PQpopbZ4sxwJKLAjuwUu4wa+S0g0vrysBaaLe6N1Y/CmExRWEZbeUToEaVuhPXmLgsf8/R7i9DGQ/brrG8NQfCqVPi1r7SUQB/YlFgeYVNo9px3KINgr3KRDoSvopmSDJ2VYTHtFzD0yq87Ry/PKjZL8fP2DkidV59Rb8+w8cQjBH0ceYWhoTaPjesvPsgUoubsuKWGOoohFpx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for changes to the structure, abstract getting and
setting the objcg field with slab_obj_ext_objcg() and
slab_obj_ext_set_objcg().
Rename the field to _objcg to make an unexpected direct access a compile
error.

No functional change intended.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  2 +-
 mm/memcontrol.c  | 14 ++++++++------
 mm/slab.h        | 15 ++++++++++++++-
 mm/slub.c        |  2 +-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6577bd76954e..05b5482c8150 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1249,7 +1249,7 @@ void __kfence_free(void *addr)
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
 #ifdef CONFIG_MEMCG
-	KFENCE_WARN_ON(meta->obj_exts.objcg);
+	KFENCE_WARN_ON(slab_obj_ext_objcg(&meta->obj_exts));
 #endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e427286a88a..cb1e97b4edc1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
+	struct obj_cgroup *objcg;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
@@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 
 	get_slab_obj_exts(obj_exts);
 	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
-	if (obj_ext->objcg) {
-		struct obj_cgroup *objcg = obj_ext->objcg;
-
+	objcg = slab_obj_ext_objcg(obj_ext);
+	if (objcg) {
 		put_slab_obj_exts(obj_exts);
 		return obj_cgroup_memcg(objcg);
 	}
@@ -3614,8 +3614,10 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
+
 		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
+		slab_obj_ext_set_objcg(obj_ext, objcg);
+
 		put_slab_obj_exts(obj_exts);
 	}
 
@@ -3633,11 +3635,11 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_stock_pcp *stock;
 
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
-		objcg = obj_ext->objcg;
+		objcg = slab_obj_ext_objcg(obj_ext);
 		if (!objcg)
 			continue;
 
-		obj_ext->objcg = NULL;
+		slab_obj_ext_set_objcg(obj_ext, NULL);
 
 		stock = trylock_stock();
 		__refill_obj_stock(objcg, stock, obj_size, true);
diff --git a/mm/slab.h b/mm/slab.h
index 64cec02b5016..1d1771f97aca 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
  */
 struct slabobj_ext {
 #ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	union codetag_ref ref;
@@ -662,6 +662,19 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	return kasan_reset_tag(obj_ext);
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
+{
+	return obj_ext->_objcg;
+}
+
+static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
+					  struct obj_cgroup *objcg)
+{
+	obj_ext->_objcg = objcg;
+}
+#endif
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index aa99d7eb6a4d..f2ffadde879d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2529,7 +2529,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
-		if (unlikely(obj_ext->objcg)) {
+		if (unlikely(slab_obj_ext_objcg(obj_ext))) {
 			put_slab_obj_exts(obj_exts);
 			return true;
 		}

-- 
2.55.0


