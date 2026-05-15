Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2F3CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8B86B0093; Fri, 15 May 2026 12:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A476B0095; Fri, 15 May 2026 12:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389B66B0096; Fri, 15 May 2026 12:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FEFA6B0093
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4BA4C0586
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:46 +0000 (UTC)
X-FDA: 84770177772.08.B078DD1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1AA3840005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wx/YP4Wt";
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEmy/1QCqsZvU55L3RNbLf0C0Fr5kT8EIZKRiemgp+k=;
	b=goKEL0B/8oF9vT9EhO7qloNwXqKDE9ZM6f0b7x+7eZeRyX9gNN6KqNds/gKb2IXmUbxiYi
	wCusYvfOdUaKVMqtAb/p0zbIwnwv94TtktUv2PlWLv5ztrzs8Plp4F0e0nm6fmJeV+TH7K
	/uSza4ikNoc+GJz6EYIPOpJ1lRFdBCc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Wx/YP4Wt";
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862285; a=rsa-sha256;
	cv=none;
	b=xw7cDF1vPTE2SoqWcPan9wgB2kt/7qmNzM+deKbwKsOFwMULP2uXXoqiBwgsyPbJubZdGg
	jxvs3bQ/uAGwMtRlX77jewBPkV+Hwk5G5AKuOPgQsLAF/l5vgE+o8HDBHeSLAPCw4lIy4D
	rAgal2lf+cQU1h8PZi9aFKMDly5SiOs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62B3D601DD;
	Fri, 15 May 2026 16:24:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218F8C2BCB0;
	Fri, 15 May 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862284;
	bh=mY8sogTT47E6WZnzv6R2mVXWjFcYPBLJkIVpwMtmkQE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Wx/YP4WtDdwRnvDlY399gmxLFZiDLoRGb/plBPW4wK5meiZ3U2FmWXf/1l302m3yl
	 41NDa29HVdmjV0DrZqnijBjdtLPkddwjXNeQeVcHYOc6HmNrWJYohoBELzDNfijtN6
	 zi8d/I27IaLcPG8sDhGZK4AvsKb1MtzPErOn67V8LKUQYkebeMWfISSkeaQ6/0SMMe
	 wKIXJTA0vs6EqslcxBh0grtD3olCa1sMm5dDNcP1u3tRDiIJoVanqLWBZWwGS1DZEa
	 dkzwTyupqSuiZ859K4uG90/zJ61fEVjO0ZGrSwwSklJa+cuW5ckXarf7pYApvO8baP
	 W+MzbE81x+YIA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:26 +0900
Subject: [PATCH RFC 2/8] mm/slab: change sheaf_capacity type to unsigned
 short
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-2-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AA3840005
X-Rspamd-Server: rspam06
X-Stat-Signature: gxcbbbo89p3txcoahbpkedwezqeczkos
X-HE-Tag: 1778862284-848501
X-HE-Meta: U2FsdGVkX185kNaYqvWCsL3MaxLCUUOo+FfvnKRYbNZiu8GE78dJcmem5C2QFg6Q2QdvJCt07c1ov/Nts+WGkhia8fIv646ysim7402u3/xQZGnFsCy/B00p+3/9NQCHqluGHD7fYtXneVAnf3nNLFFlBj9xpKpdm55B2p4CefG/qU4QlxTWPAagsheCap7hhuvidsbFd/G8RDvT4olDP1BOAexyGLWxfBs0bSHUyd3luVQwKqrvIgkHXgF3MxEm5h9X86xGeE8O0ynt4vnUUQSh9A9e4bvRrVr2CLXvmo27+shCFIRPT9Arbl2mBv7kg61PMYrZhWuC+O/KFLZeHb7ybvD9sWa55XaPhpeL2XTLP+FttuCrS0jzoilodk0f5vigohyZzB80phNMDBHhWZ9poqOFDOaZAHYkA1vwDya9FFHJQY9Vq5WzVzCrvCgF+ys26XZ432ajdCQnzY5r5lbR4U6hQG+We2IVtejfJKMytgjjYXA+XobHI6GjcIK25G+M3t826m/odHwsY63FRoDUZVC/k5FgJuDVv1EFbdg1esjbHRPbYOQYTX487OBxUNrhFJ05AxiuR7+DhqZ9ORNpsBa8agk7HVcovQIBV2fwI4IYZurIsawNZP83eAg58NzQ3itAOs+c62iSf7/9w0/DtHmZ5NIqCD4cbzb9jcxX5iZaJ2PVmJCc6QoE5+JpAqVfmu/A33ckt67EowH9hWx4+F0aN6kCZV3Z73k+aOgjt5NKCWc/NHvZl9WwEWRYfuBEVICDy2hrm//aQ3rVPVGb6mISaSqhEoQGXDEMRZ6YilBGptgRETxyKr6qxYrlQ6JwCwwWfZ05pGmw1AZBP27PfrHiXfozEACgR1YiGZc5yTu67/sy7WyWyL92Ua0Y22T5lDTtX/exHyos2iz/nSeH9W51henlCIQkThiFSz4cuT9kzsa2fgRIABshXZTwldQB1I42EYmgOmUEp3G
 H1DdculD
 ZFvwhkI6MzdUS8BUXMU7kxtEMlOuReFxW6ajRGpR1xiJs15vJi7DnL4z9LmmmF9bNtNTnAfFqQcNgVTv76ERHIRhnUjfGuu7V8RM64itCmycBi2Pzpfw8BxT3OZJqFQH8nRwvrj66XR4GgqIMBlqNGa9/WoAeM5vnhFgH+zVT7+v0xhuEb/0nI9LP7VyxFiUn76bvX3Xh0U8Y9FBsXtMMsDN2E/ldumcfKxq2l8AOQYV0HSRx2mupD7dCkZCn5T0gqjaqAK3Kxfi36H3Txvb963QvKEuC0hthq8C3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change struct kmem_cache.sheaf_capacity and the matching
kmem_cache_args field from unsigned int to unsigned short, so that
we can add a new field later without growing the struct size.
unsigned short is a reasonable size for any realistic configurations.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 include/linux/slab.h         |  8 ++++----
 mm/slab.h                    |  2 +-
 mm/slub.c                    | 34 +++++++++++++++++-----------------
 tools/include/linux/slab.h   | 14 +++++++-------
 tools/testing/shared/linux.c |  4 ++--
 5 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 2b5ab488e96b..6f023f04763a 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -371,7 +371,7 @@ struct kmem_cache_args {
 	 *
 	 * %0 means no sheaves will be created.
 	 */
-	unsigned int sheaf_capacity;
+	unsigned short sheaf_capacity;
 };
 
 struct kmem_cache *__kmem_cache_create_args(const char *name,
@@ -828,10 +828,10 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t flags,
 #define kmem_cache_alloc_node(...)	alloc_hooks(kmem_cache_alloc_node_noprof(__VA_ARGS__))
 
 struct slab_sheaf *
-kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size);
 
 int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
-		struct slab_sheaf **sheafp, unsigned int size);
+		struct slab_sheaf **sheafp, unsigned short size);
 
 void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 				       struct slab_sheaf *sheaf);
@@ -841,7 +841,7 @@ void *kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *cachep, gfp_t gfp,
 #define kmem_cache_alloc_from_sheaf(...)	\
 			alloc_hooks(kmem_cache_alloc_from_sheaf_noprof(__VA_ARGS__))
 
-unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
+unsigned short kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
 
 /*
  * These macros allow declaring a kmem_buckets * parameter alongside size, which
diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..dfbe73011cb8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -204,7 +204,7 @@ struct kmem_cache {
 	unsigned int object_size;	/* Object size without metadata */
 	struct reciprocal_value reciprocal_size;
 	unsigned int offset;		/* Free pointer offset */
-	unsigned int sheaf_capacity;
+	unsigned short sheaf_capacity;
 	struct kmem_cache_order_objects oo;
 
 	/* Allocation and freeing of slabs */
diff --git a/mm/slub.c b/mm/slub.c
index 75281eb802de..a1974523bba9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -418,11 +418,11 @@ struct slab_sheaf {
 		struct list_head barn_list;
 		/* only used for prefilled sheafs */
 		struct {
-			unsigned int capacity;
+			unsigned short capacity;
 			bool pfmemalloc;
 		};
 	};
-	unsigned int size;
+	unsigned short size;
 	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
@@ -2756,7 +2756,7 @@ static inline void *setup_object(struct kmem_cache *s, void *object)
 }
 
 static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
-					      unsigned int capacity)
+					      unsigned short capacity)
 {
 	struct slab_sheaf *sheaf;
 	size_t sheaf_size;
@@ -2854,10 +2854,10 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
  *
  * Returns how many objects are remaining to be flushed
  */
-static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
+static unsigned short __sheaf_flush_main_batch(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
-	unsigned int batch, remaining;
+	unsigned short batch, remaining;
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
 
@@ -2884,7 +2884,7 @@ static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 
 static void sheaf_flush_main(struct kmem_cache *s)
 {
-	unsigned int remaining;
+	unsigned short remaining;
 
 	do {
 		local_lock(&s->cpu_sheaves->lock);
@@ -2899,7 +2899,7 @@ static void sheaf_flush_main(struct kmem_cache *s)
  */
 static bool sheaf_try_flush_main(struct kmem_cache *s)
 {
-	unsigned int remaining;
+	unsigned short remaining;
 	bool ret = false;
 
 	do {
@@ -4849,7 +4849,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 do_alloc:
 
 	main = pcs->main;
-	batch = min(size, main->size);
+	batch = min_t(size_t, size, main->size);
 
 	main->size -= batch;
 	memcpy(p, main->objects + main->size, batch * sizeof(void *));
@@ -5004,7 +5004,7 @@ static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
  * return NULL if sheaf allocation or prefilling failed
  */
 struct slab_sheaf *
-kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 {
 	struct slub_percpu_sheaves *pcs;
 	struct slab_sheaf *sheaf = NULL;
@@ -5146,7 +5146,7 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
  * In practice we always refill to full sheaf's capacity.
  */
 int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
-			    struct slab_sheaf **sheafp, unsigned int size)
+			    struct slab_sheaf **sheafp, unsigned short size)
 {
 	struct slab_sheaf *sheaf;
 
@@ -5225,7 +5225,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 	return ret;
 }
 
-unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
+unsigned short kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
 	return sheaf->size;
 }
@@ -6172,7 +6172,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 do_free:
 	main = pcs->main;
-	batch = min(size, s->sheaf_capacity - main->size);
+	batch = min_t(size_t, size, s->sheaf_capacity - main->size);
 
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
@@ -7759,11 +7759,11 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 	return 1;
 }
 
-static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
-					     struct kmem_cache_args *args)
+static unsigned short calculate_sheaf_capacity(struct kmem_cache *s,
+					       struct kmem_cache_args *args)
 
 {
-	unsigned int capacity;
+	unsigned short capacity;
 	size_t size;
 
 
@@ -8466,7 +8466,7 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 {
 	struct kmem_cache_args empty_args = {};
-	unsigned int capacity;
+	unsigned short capacity;
 	bool failed = false;
 	int node, cpu;
 
@@ -9091,7 +9091,7 @@ SLAB_ATTR_RO(order);
 
 static ssize_t sheaf_capacity_show(struct kmem_cache *s, char *buf)
 {
-	return sysfs_emit(buf, "%u\n", s->sheaf_capacity);
+	return sysfs_emit(buf, "%hu\n", s->sheaf_capacity);
 }
 SLAB_ATTR_RO(sheaf_capacity);
 
diff --git a/tools/include/linux/slab.h b/tools/include/linux/slab.h
index 6d8e9413d5a4..76d0b9da6cfe 100644
--- a/tools/include/linux/slab.h
+++ b/tools/include/linux/slab.h
@@ -47,7 +47,7 @@ struct kmem_cache {
 	pthread_mutex_t lock;
 	unsigned int size;
 	unsigned int align;
-	unsigned int sheaf_capacity;
+	unsigned short sheaf_capacity;
 	int nr_objs;
 	void *objs;
 	void (*ctor)(void *);
@@ -70,7 +70,7 @@ struct kmem_cache_args {
 	/**
 	 * @sheaf_capacity: The maximum size of the sheaf.
 	 */
-	unsigned int sheaf_capacity;
+	unsigned short sheaf_capacity;
 	/**
 	 * @useroffset: Usercopy region offset.
 	 *
@@ -127,10 +127,10 @@ struct slab_sheaf {
 	union {
 		struct list_head barn_list;
 		/* only used for prefilled sheafs */
-		unsigned int capacity;
+		unsigned short capacity;
 	};
 	struct kmem_cache *cache;
-	unsigned int size;
+	unsigned short size;
 	int node; /* only used for rcu_sheaf */
 	void *objects[];
 };
@@ -186,7 +186,7 @@ void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list);
 int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 			  void **list);
 struct slab_sheaf *
-kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size);
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size);
 
 void *
 kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
@@ -195,9 +195,9 @@ kmem_cache_alloc_from_sheaf(struct kmem_cache *s, gfp_t gfp,
 void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 		struct slab_sheaf *sheaf);
 int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
-		struct slab_sheaf **sheafp, unsigned int size);
+		struct slab_sheaf **sheafp, unsigned short size);
 
-static inline unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
+static inline unsigned short kmem_cache_sheaf_size(struct slab_sheaf *sheaf)
 {
 	return sheaf->size;
 }
diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 8c7257155958..2da3a6617d87 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -252,7 +252,7 @@ __kmem_cache_create_args(const char *name, unsigned int size,
 }
 
 struct slab_sheaf *
-kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
+kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 {
 	struct slab_sheaf *sheaf;
 	unsigned int capacity;
@@ -281,7 +281,7 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned int size)
 }
 
 int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
-		 struct slab_sheaf **sheafp, unsigned int size)
+		 struct slab_sheaf **sheafp, unsigned short size)
 {
 	struct slab_sheaf *sheaf = *sheafp;
 	int refill;

-- 
2.43.0


