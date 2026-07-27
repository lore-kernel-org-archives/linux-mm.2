Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EF8C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B89A6B00E2; Mon, 27 Jul 2026 08:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690AB6B00E3; Mon, 27 Jul 2026 08:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3986B00E4; Mon, 27 Jul 2026 08:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29EE46B00E2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACBDFA074C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:26 +0000 (UTC)
X-FDA: 85034550132.05.389FC38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BB9C140012
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxBgK8Gb;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmX0mWqwjE6mQk0qp4/I2+NqibALg+g/HqN4lQN0w1I=;
	b=DyiyG3+zUPgK3IRR1XmvwKwrUtKKhJaMi5j/yEHT7k/0FOScHOSjLX6rUEUxxBTN+BQz/L
	Jp15WqPhdb04UqB6svT9SdvDO09d+nG8xSp46HAfgD99/5oz3StD6VnFVxdfpvN+k3Z7du
	dcZN1dzUug5xpIPIZk4ECPu53YhLIG0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QxBgK8Gb;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156865;
	b=qOhc/VTr83TAy1/UOIcidFVdhonzaw/ZjFJrsOUwRslhpk77oLauxXumBQRpQYkE7MnZxw
	8YJvEn5+8keG8fx70RYX0PvfWv3iwOmBKkvuOk7ZOw4vCNQn1gCVQlOm5QZYSRBxY42ipx
	lbGlBcBlyAWNMKpGiCiQGLaq3tSvv+k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9250601E0;
	Mon, 27 Jul 2026 12:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956881F000E9;
	Mon, 27 Jul 2026 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156864;
	bh=QmX0mWqwjE6mQk0qp4/I2+NqibALg+g/HqN4lQN0w1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QxBgK8GbUqZaVHVCV2DKsVNjj6JgnYwiAjt9RXZmSCubIqyBaW2eqWuJxmn1fL7ds
	 F67aSuh9uiwgDkis2QyTubCP/TWTC2MPzqYmUYtim0acfnb3pp4cPMdnK0ZL7W9YTQ
	 atouz1vrmm7y09ACKqd90S7JysK2Vpy9ASMAR0buEp94/RC+QQHYWDHtHftVzUXE4w
	 IlQIB34XMt7kGFa4dg0gLzREwezRW0JHgFprNyLZbTxQyTDl2oP/CgOoasQ/b3yAgd
	 rePiHPGiX5JSJTuO5gfF+hqMYuLj++Y1K8vb2+DZmy/c4WnSGW4BJzkCotNNwuBkVG
	 uqIDNWYHPBVIw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:59 +0200
Subject: [PATCH v3 05/13] mm/slab: abstract slabobj_ext.objcg access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
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
X-Rspamd-Queue-Id: 1BB9C140012
X-Rspamd-Server: rspam01
X-Stat-Signature: xruzmf7tgiwzjfpoehzhkos9m84dghwr
X-HE-Tag: 1785156864-934978
X-HE-Meta: U2FsdGVkX19ylXMM0cPD40UonQLqSdR2C/89NBol7/+WCG2DekA70eCoOo7KDeB1qFP5UtLiNjbxehU5qikVDaNPz83KeZEhh2CQPhh0rhZADPP4CvnxOBX9Xx8h5/GqM6z5mU12HQqeq0Z+gXg3nMGKUjsHRbJEj81NzDgv5vMYK5qfBDF4Scj7pJYJ/q6a8bqPkS780Igha/xB3S2CdYYLeyQQb8bhQi357Zpr2FpyU0VPV1JTGI1oPliy7/FLmgtI4snlB/f/uecsiZrG+pnatzkSH4klRw4o42FTX41vLyjdOl3FVs23AYMdcYerdD0v+ebeY0ShFlarRiXCn+Lfmjrw8pJr4zYbdhpt/tf8tmv8glwnxLdowJvzbCHa+FpevjZsHyhpoNHJnUiFB1fkr7SA9x5Kt3BWr7LpzW8lBUc4scUnDuLTWVOq0+4XTO3vX9Lfml1jFmqycAJ0G8+tMJ8K0uf8pPSi7NLfkq6LR0E64o9GSWmWLfe8B+VjsQrRjzg8nODEtGO8sNvNqIP2z8E5CiHSH/hjFiZSRyyeazrjBdDPQ59UHnSRaEjvZLgBQTM3RA8ue5n15pqPqRqHBKxZwBcnlj4l7oxa7I4JxRkZqADFYGGraI6Hra26pEPwVr51L6iz4UUnmyEu1nGUHutHQJ5jDl5DAqrO4OJHKwVKNdEBhmdFG4CsK+Pi4EPYA5l+eORVD4M7F/VVQoQhnR9xfZTc0jro7ZgeL75KgEb2/d3ml1Zve2jBex4NloHCdcYK6sEFZ9O7opJmioX2Uy2mO/EEfkKKJDEQqiQMwDdblX5MwW6Hm8JMgiuM+v5oMDR/bQdOAwvmHFq1eT3s75n8/sPVG6NvECuEibp7qUYf4ezKRlsrEtGvg/AFdF/EATyV99aybs6NWzyqNz+V1umIaWHiwyg67XRQYYJQJrfDaB8OIvakuhLXIkqyWjUCQZfDjmXPpQx/wKW
 wq1imtDt
 caNzfGoy57cH5gZnt0eCgL7pCAGIDoN+UjaZQ2PYE0obgbhRZAdGuvX7aw/x/Jbq/BdYCXJG8S4zQLKhXlMqPxjd8Cn+kEiUwRoWsoFULWNhLgTw0IujfGttVzikajp2tm8tdGubKXayi1BIJqI02MNUObAADyY+QZz6eXdlsx8FFCSqtNtDaW6lnYERxaCtcqdc/7OpYiYYwJ5i6cu0GZd988+GBr7GIpNET4NC0saIxBHlXSWjADHF+vVxGpYXcfW74IyDiUbEA+RNCiV375EiVK+tJddkDsQzrjObl5C7huUghhqI718WO2adx8A8Koo1z
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

Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
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
index 451b50b7f237..1e4f61607448 100644
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
index a74f1866c958..2bf38fb1a3f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2526,7 +2526,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
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


