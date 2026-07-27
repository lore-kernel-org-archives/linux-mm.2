Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD046C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310586B00A2; Mon, 27 Jul 2026 08:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299C86B00E4; Mon, 27 Jul 2026 08:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187466B00E5; Mon, 27 Jul 2026 08:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC9C96B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AC051C0E81
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:33 +0000 (UTC)
X-FDA: 85034550426.03.3B53358
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AB54D180006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="moj/3mcd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mEr2xrihrmIHyvv5b6Ol63WMLWWStvd/qHnqRMGqBvM=;
	b=Paqgrw3hWJ5DWcXwI7MtOtcJZp8j+RcU2uP0igOZRHzlK3E6OK7Idd82y8lsdYFw8K5uBJ
	PifK1Dx5DA1/iCL84dKYx/2/IOTJFn9mHO6YOfScOXyy9M1pktXoiNeS02s4dZ6P8V0kcg
	uZJi7stu5cFu9eOBSE45HEt9yNBSqWY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="moj/3mcd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156871;
	b=2bZwp3k7o2ERhA9XEuDQBmTWRJvJCL8FJPjb0YH8ufFP/ddHmQ3BPQvIU5emCpLbUYXiPs
	EiCqONyfCJJ3eQLEIVseJuVsertjooUy7VMpoL7t2yAi4TgW+P5OFE8EiWkezjrNk2n+x0
	na3ZJ/uzVNON0L5zDclLuYUYHr0O9VA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04FE243384;
	Mon, 27 Jul 2026 12:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC181F000E9;
	Mon, 27 Jul 2026 12:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156870;
	bh=mEr2xrihrmIHyvv5b6Ol63WMLWWStvd/qHnqRMGqBvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=moj/3mcdClYuYHb8ivXm6DFUM43pMT/O65M5I2vnuNKQR8fHHg7A08fYjcUX4z96M
	 VYMzN7VC48LVCrVhURUluafL6eAfaQ4tAJciTM4b/9YZZ/5lVFtZJvh0CsFfFoo0K3
	 HeoP39R/XxLdlZVp3etTiFFNIP98tvKa9Fl7nU9wUtvvgOJeCUzkzr/RfN4rvyLdoV
	 H/0ClO5z7tL72zscmDSHZ7CSxZu0ZnaMBglEBHUVgSw4y+5l9oJc0uhHEMcgheUeEJ
	 +S9pRHMMZ/aRgs11cthqmt1MaqOaV+z41PRwjqz2+gZZtcivyZtSQspxVtgLtdsCu5
	 UEyMo90wBIz8w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:01 +0200
Subject: [PATCH v3 07/13] mm/slab: replace slab.stride with
 obj_exts_in_object
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-7-c29ef0f1f257@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB54D180006
X-Rspam-User: 
X-Stat-Signature: xfy6qdkhbrocuy1qxt5wxaxgjcyy7izu
X-HE-Tag: 1785156871-992924
X-HE-Meta: U2FsdGVkX18Syj09RhOc/p/s4G/97z/p5Gf2gfrHe+dqFdhCillS6/9+ZKgrVrxwFd4Wl2eKF2jO77yYBX7oCPAdXjFAdhFKg2Aprqwk9xiyrL+uhzVtiS+lAbRCZHr5nncs8gcrK0HEtXYnWaQMDjUD9Za+d1DKq8ZmYclWMHq/B9F62a24HQD4AGtquet+TmSVaWbXPFaaWhtLEgYREdPf1Y65brCIcvmGtjle9yv9H5+yyrTbuQ7ZGVa4jrcCI9a/sTKz7HzhU0eP9HH9ubZig1whFWe8g2vu0IWesbtNaGlr0PCICS3ADTc4+7RC4NP4EmBVaQvoe4egS2oaRwCSJEnDYHZfubIYb3d8Ehirr/AfaQAbxBszNqo4UNAOvKAGE5FQiCWx+iNQQZrBAlg7bubqUdoJfg/pskiPiiHXkgCfRrBK0fbme4UC2nVF5VQQcqbxYFBC4+y9pJ3EdHj4rNqUaqct2WqTci0cBgpT1jNIwNe7HEpT3clcEgv4C+RMnH2PWG4N+/YSItlx0PutOB3LhHGy63d42/sv+UZ3NIDfXmsRrkZFiPLEni6iRVvl1swwFdrnDlkwoklZdv90sbzKbLxHa1HNOl4EVz/sfuOnFAViUAR+wgkPAf7QTyz6/sT5GUB/TJAzcQBURXcG3f99WZdBqzK5NJyGDxQjvz3x6eMt0u+zU+bzQ7uqRfZm4C0wpP4GSNNv1iZw5Sovim9AXbI/uzRMJ2d2W09SFRDSjCZC2plrE8khqe8zHIDrD2mp2NaQWtfBXCarnKbzpPIOT1jc0pQn2uluyAlUcjWvTjEkUJO9o23xrvQsIido4gPELgGheBSxGoUO0VOKLI3h15Vf5fmiH43nwaIS9yVfsNbjLIj6jqLDh6nhgIxp14GcKsVf8Drj98XVAfhQXVRUJYKbrNb2IjtcCrMHYvYwB9hLV2OUnCVz2ErT2bwa+YjjwHibO186Jz6
 g1wKqN+3
 gj9Ku8lCBZhs8u1JZUevV/OhF2F/ScCQybi3gcXaSxWZ27w/oMwz6l0hbZicv1WxKBiN/pB8tds4aSVnzwDSyqILu1wn++kjOzVt8O9cCSqwGqZuyZ1O69Y+nJhYZYesdaCZPz1+B3IHSDW4NOp6r4x0DGyfz00wWGRFmEFckOIx+82y3gjGR2y0ousPANWUWp83lNzoRWFJXkxQDamwC/u+04bw17ZsEj+xGtRJNjJEa6OobSkMKjgyqNIbc+ieDWDaF4k+PtZKCS348+sM2EXoCIHswELFQM7AqW5I1KK2quICW8MtApyQoqv0pIRlaBkct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stride field is used to convert object index to an slabobj_ext so
both compact arrays (kmalloc() or in-slab-leftover) and spread
in-object-padding obj_ext layouts are supported.

In practice thus the stride is always sizeof(slabobj_ext) or s->size.

This simplifies the calculations, but with the upcoming slabobj_ext
handling changes, it will be easier to stop storing the stride and
instead just have a flag whether obj_ext is in the object padding.
obj_exts_in_object() can then rely on this flag and slab_obj_ext()
can use that to determine the stride.

No functional change intended. Performance impact TBD, hopefully
in the noise.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 44 +++++++++++++++++++++++++-------------------
 mm/slub.c | 42 ++++++++++++++++--------------------------
 2 files changed, 41 insertions(+), 45 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 562b62802561..79c758001f98 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -81,10 +81,10 @@ struct freelist_counters {
 #ifdef CONFIG_64BIT
 					/*
 					 * Some optimizations use free bits in 'counters' field
-					 * to save memory. In case ->stride field is not available,
+					 * to save memory. If these free bits are not available,
 					 * such optimizations are disabled.
 					 */
-					unsigned int stride;
+					unsigned obj_exts_in_object:1;
 #endif
 				};
 			};
@@ -617,22 +617,20 @@ static inline void put_slab_obj_exts(unsigned long obj_exts)
 }
 
 #ifdef CONFIG_64BIT
-static inline void slab_set_stride(struct slab *slab, unsigned int stride)
+static inline bool obj_exts_in_object(struct slab *slab)
 {
-	slab->stride = stride;
-}
-static inline unsigned int slab_get_stride(struct slab *slab)
-{
-	return slab->stride;
+	/*
+	 * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and need to
+	 * check the per-slab bit. A cache can have SLAB_OBJ_EXT_IN_OBJ set, but
+	 * allocations within_slab_leftover are preferred. And those may be
+	 * possible or not depending on the particular slab's size.
+	 */
+	return slab->obj_exts_in_object;
 }
 #else
-static inline void slab_set_stride(struct slab *slab, unsigned int stride)
+static inline bool obj_exts_in_object(struct slab *slab)
 {
-	VM_WARN_ON_ONCE(stride != sizeof(struct slabobj_ext));
-}
-static inline unsigned int slab_get_stride(struct slab *slab)
-{
-	return sizeof(struct slabobj_ext);
+	return false;
 }
 #endif
 
@@ -657,8 +655,15 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
 	index = obj_to_index(s, slab, obj);
-	obj_ext = (struct slabobj_ext *)(obj_exts +
-					 slab_get_stride(slab) * index);
+
+	if (!obj_exts_in_object(slab)) {
+		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
+	} else {
+		unsigned int stride = s->size;
+
+		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
+	}
+
 	return kasan_reset_tag(obj_ext);
 }
 
@@ -700,9 +705,10 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	return NULL;
 }
 
-static inline void slab_set_stride(struct slab *slab, unsigned int stride) { }
-static inline unsigned int slab_get_stride(struct slab *slab) { return 0; }
-
+static inline bool obj_exts_in_object(struct slab *slab)
+{
+	return false;
+}
 
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
diff --git a/mm/slub.c b/mm/slub.c
index 7812a7c097c9..f6ec3618dd1c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -870,18 +870,6 @@ static inline bool obj_exts_in_slab(struct kmem_cache *s, struct slab *slab)
 #endif
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
-static bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
-{
-	/*
-	 * Note we cannot rely on the SLAB_OBJ_EXT_IN_OBJ flag here and need to
-	 * check the stride. A cache can have SLAB_OBJ_EXT_IN_OBJ set, but
-	 * allocations within_slab_leftover are preferred. And those may be
-	 * possible or not depending on the particular slab's size.
-	 */
-	return obj_exts_in_slab(s, slab) &&
-	       (slab_get_stride(slab) == s->size);
-}
-
 static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 {
 	unsigned int offset = get_info_end(s);
@@ -896,16 +884,20 @@ static unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 
 	return offset;
 }
-#else
-static inline bool obj_exts_in_object(struct kmem_cache *s, struct slab *slab)
+
+static inline void slab_set_obj_exts_in_object(struct slab *slab)
 {
-	return false;
+	slab->obj_exts_in_object = 1;
 }
-
+#else
 static inline unsigned int obj_exts_offset_in_object(struct kmem_cache *s)
 {
 	return 0;
 }
+
+static inline void slab_set_obj_exts_in_object(struct slab *slab)
+{
+}
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -1206,7 +1198,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
-	if (obj_exts_in_object(s, slab))
+	if (obj_exts_in_object(slab))
 		off += sizeof(struct slabobj_ext);
 
 	if (off != size_from_object(s))
@@ -1411,7 +1403,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 
 	off += kasan_metadata_size(s, false);
 
-	if (obj_exts_in_object(s, slab))
+	if (obj_exts_in_object(slab))
 		off += sizeof(struct slabobj_ext);
 
 	if (size_from_object(s) == off)
@@ -1439,7 +1431,7 @@ slab_pad_check(struct kmem_cache *s, struct slab *slab)
 	length = slab_size(slab);
 	end = start + length;
 
-	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
+	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(slab)) {
 		remainder = length;
 		remainder -= obj_exts_offset_in_slab(s, slab);
 		remainder -= obj_exts_size_in_slab(slab);
@@ -2256,9 +2248,6 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 	void *addr;
 	unsigned long obj_exts;
 
-	/* Initialize stride early to avoid memory ordering issues */
-	slab_set_stride(slab, sizeof(struct slabobj_ext));
-
 	if (!need_slab_obj_exts(s))
 		return;
 
@@ -2292,7 +2281,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 		obj_exts |= MEMCG_DATA_OBJEXTS;
 #endif
 		slab->obj_exts = obj_exts;
-		slab_set_stride(slab, s->size);
+		slab_set_obj_exts_in_object(slab);
 	}
 }
 
@@ -3405,9 +3394,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 		stat(s, ORDER_FALLBACK);
 	}
 
+	/* Initializes frozen, inuse, and any extra 64bit-only flags */
+	slab->counters = 0;
+
 	slab->objects = oo_objects(oo);
-	slab->inuse = 0;
-	slab->frozen = 0;
 
 	slab->slab_cache = s;
 
@@ -6540,7 +6530,7 @@ static inline size_t slab_ksize(struct slab *slab)
 	 */
 	if (s->flags & (SLAB_TYPESAFE_BY_RCU | SLAB_STORE_USER))
 		return s->inuse;
-	else if (obj_exts_in_object(s, slab))
+	else if (obj_exts_in_object(slab))
 		return s->inuse;
 	/*
 	 * Else we can use all the padding etc for the allocation

-- 
2.55.0


