Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C95EC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449356B00E4; Mon, 27 Jul 2026 08:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDCB6B00E5; Mon, 27 Jul 2026 08:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299796B00E6; Mon, 27 Jul 2026 08:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC42A6B00E4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 783838070A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:36 +0000 (UTC)
X-FDA: 85034550552.20.67DFE20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D1B9E1C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W73vUMpT;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpLA7OFU8RZEfIl2Ky2CyNJhgbcJGBk6hlXjRo9XjZ0=;
	b=WA8W35m4U3DZSIiwQ/j/cmaO1SQ8+jxLCX4IBiSEolW3+gMpaK5qFSwBtlHc2rslT9Wdtw
	BZiiViVBAD8esnblclyH4JkaCJTDTaL1V/x1mwy7+dGRfq8zRh8LgQM2WRd+oL1TXgh/V6
	SjgyFxJM4/0c/RzgieHTRoNSaXjoiCU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156874;
	b=F1sNNc13CKVCzkssV9qeEJp3MsZohvRCpx1WtLfx2yomoHQfE4igtvtDkblku5mKpUamQr
	XX9jgawVijTbOaPm9vpIzR1G+i3pIMWwTXdnnc/7a/mCpN/VXdA8Q/HhSXRrh6CqTaRYkf
	Rk8epzr53zbDAg1gc1likcOtl6uWgCk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W73vUMpT;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FA23600E1;
	Mon, 27 Jul 2026 12:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598B01F00A3A;
	Mon, 27 Jul 2026 12:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156874;
	bh=OpLA7OFU8RZEfIl2Ky2CyNJhgbcJGBk6hlXjRo9XjZ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W73vUMpTsx6e4HcrrjkMH7JYhlWN5/vB8deCMHSxhBd7cPPVPn4DbGt0CIbvJ7gSk
	 Hs4XYqP4bRyN7lP/skw7el2qVMMLQAXLHUEPJElda65D6bJeDGr9XMSkBThugwPKhT
	 GQR5OhabPfzeYxDp1kq0kaq9MJ6bAemO7zHuTnU9ufncNOzt8EtKhd1uzvZbZFgjTN
	 KmbkkJg+8P9DH0oaxPqCGVVoTxwImkcxjWooImQC0ZZeg3zcEJXpPX1JVX+krj5jsp
	 zsxcpGGgyii2toHfBScmgTIYjxMlPklFVpHmgeIzf1fAYSmCEXey+hpj8I/hAJ/Krj
	 7uEGs8/+E8VlQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:02 +0200
Subject: [PATCH v3 08/13] mm/slab: change struct slabobj_ext to a union
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-8-c29ef0f1f257@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D1B9E1C000A
X-Stat-Signature: 3d1njr8pigcrxjc96yr59feww3sz1j4o
X-Rspam-User: 
X-HE-Tag: 1785156874-569789
X-HE-Meta: U2FsdGVkX1/4IYySNkZoaKrEXE8fOCUbuLVUOVYdvxsIzRqFQ58ThKpvNlUSjoKtyW3dRcpQqXZWta42ATXnmJXxr94/RGKYthxHO+w24HVKJyibozhK7IH3HoyWO4bKSUP3jVcX7ZY+pU6Ugp7sTC/SeZhYRBNWoLs1/L2JVImYLb9mxFA9sYlpvtFABXUQ3oXbeGvM5hX6dL79wO2t6wk26AUjJGEuXeos/kI6FRMlUTmXy7ExUoyXLiQ1rCnNz4dylsh1F9TEaCNj39ySpZZTzO5BkVWcLjXFuiY9/wkK+SWCaVlj/MuQ2F0+2iqS34i2mcqcUhfPanQEQ7X0CUP0e1CmVIWLySddEOzKNVGEWkDS/VMpwcYgPugD5jTIqtV9jUw8Y8VGkFG/JzGHyGyT9t5xnYytYPswrYZJ4vBrWbnylkDotcJotkCC5D8Kn/U2KO0VH8kCs/6uHCCM15rXxU7IvUCRf96FjtDwUVavmRQgYMc6i86iixqrSll4XTmBAqBZQhndqH4xGGkgMKMS4Mf5KASNhDNQ/CjbQWSdo6bubI4iz8fyB/6JeN7H5Y0kabsjlRNlqNguk6Fae+bNf+xaWMXZHL0zBsbSa4M298vkx4T8vg6BuratTl/1XbEJXQOA5V57fth17qpcGaszA91Q3gVKQxhYOTthg5l5bK/HCNmlEq7QzIb6NfWX6ImgldlqGgNhuORk+jOSdJjlh3lDFjrIqJ4aiZM1vrc5n663r8nA4/Bgv1ybD/1wNrk+yYH6qSXEC/O2fHT28LXaRgM0v2oYK1dAqNG8aT4Z5uBhF2EuIC2DOzrtbSlwSsT3Z1BDdnk+qiytFcYW0d5RX4curbPJB9FhlZr4La92UuZb3Mgf+Ge0jcW7H8+gF2XhaRa+0V3Uae984uRSvM/VwqWAwSD3CoGWSz7u8yMQyvMnQvEbb5vWyDndMXPOFC8qHbeOCy33rQzR+us
 Rpy9Plih
 Zx2RBoGAbqamDwUkJUzMrtIMVCUlYNMueJBUPWDin03GjH+LpfYC5kWtWaIp4sim8qtT8zPKZ5dFS6bWQYtmctvjyJMJXoEq2igF0aWk3kDQV9IBGzDwtZltXnTIzfLDLsuj4PCz8s6frVT/WmN8T61AzI4zGcwlBWXz6BOx15Vq/1E3q5toyDjXDaGjZP4oAn9bmw8aeryZeBbdI4dplYIwMQYU4uQm3g96VQYxTbaD1sJDAkuuyT6ap/j/5n9+F/2iBdawBUKrAykUpGpR8g9+17q2iVAnX0ZsD/XrVeJXw2IZ/vYU3ECgDN+tL55P2MbU8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, struct slabobj_ext can hold both objcg pointer and
codetag_ref (when both are compile-enabled) and there is an array of as
many slabobj_ext instances as there are objects in a slab.

This makes the layout fixed so even if codetag_ref is unused (because
memory allocation profiling is disabled), the space for them is
allocated and wasted. Similarly, some caches (currently kmalloc_normal)
do not ever need objcg pointers, leading to wasted memory with memory
allocation profiling enabled.

To make this more flexible, change the layout so that struct slabobj_ext
becomes a union of objcg pointer and codetag_ref (to ensure uniform
size; in practice both are the same size anyway). The slabobj_ext array
then can have twice as many elements as before. For cache locality
purposes, the effective memory layout is unchanged, so objcg and codetag
ref for a given object are still adjacent.

cache_obj_ext_size() returns the effective size of (0-2) struct
slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
both return a constant value derived from the config options, but will
be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.

No functional change intended, the layout is still effectively static.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
 mm/slub.c | 19 +++++++++++--------
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 79c758001f98..3f8144b9b9d8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
 }
 
 /*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
+ * Extended information for slab objects stored as a pointer to an array in
+ * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+	/*
+	 * All elements of the union should be pointer-sized to avoid memory
+	 * waste
+	 */
+	union {
 #ifdef CONFIG_MEMCG
-	struct obj_cgroup *_objcg;
+		struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref _ctref;
+		union codetag_ref _ctref;
 #endif
+	};
 } __aligned(8);
 
+static inline size_t cache_obj_ext_size(struct kmem_cache *s)
+{
+	size_t sz = 0;
+
+	if (IS_ENABLED(CONFIG_MEMCG))
+		sz += 1;
+
+	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+		sz += 1;
+
+	return sizeof(struct slabobj_ext) * sz;
+}
+
+static inline size_t slab_obj_ext_size(struct slab *slab)
+{
+	return cache_obj_ext_size(slab->slab_cache);
+}
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*
@@ -651,18 +675,18 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 {
 	struct slabobj_ext *obj_ext;
 	unsigned int index;
+	unsigned int stride;
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
 	index = obj_to_index(s, slab, obj);
 
-	if (!obj_exts_in_object(slab)) {
-		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
-	} else {
-		unsigned int stride = s->size;
+	if (!obj_exts_in_object(slab))
+		stride = slab_obj_ext_size(slab);
+	else
+		stride = s->size;
 
-		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
-	}
+	obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
 
 	return kasan_reset_tag(obj_ext);
 }
@@ -670,12 +694,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 #ifdef CONFIG_MEMCG
 static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
 {
+	/* if objcg exists, it comes first, so we don't need to do anything */
 	return obj_ext->_objcg;
 }
 
 static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 					  struct obj_cgroup *objcg)
 {
+	/* if objcg exists, it comes first, so we don't need to do anything */
 	obj_ext->_objcg = objcg;
 }
 #endif
@@ -684,6 +710,9 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
+	if (IS_ENABLED(CONFIG_MEMCG))
+		obj_ext += 1;
+
 	return &obj_ext->_ctref;
 }
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index f6ec3618dd1c..9079aaab3235 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -803,7 +803,7 @@ static inline bool need_slab_obj_exts(struct kmem_cache *s)
 
 static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
 {
-	return sizeof(struct slabobj_ext) * slab->objects;
+	return slab_obj_ext_size(slab) * slab->objects;
 }
 
 static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
@@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 	off += kasan_metadata_size(s, false);
 
 	if (obj_exts_in_object(slab))
-		off += sizeof(struct slabobj_ext);
+		off += slab_obj_ext_size(slab);
 
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
@@ -1404,7 +1404,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 	off += kasan_metadata_size(s, false);
 
 	if (obj_exts_in_object(slab))
-		off += sizeof(struct slabobj_ext);
+		off += slab_obj_ext_size(slab);
 
 	if (size_from_object(s) == off)
 		return 1;
@@ -2092,6 +2092,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 static inline void handle_failed_objexts_alloc(struct slab *slab,
 		unsigned long obj_exts, struct slabobj_ext *vec)
 {
+	unsigned int stride;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
@@ -2100,11 +2102,13 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
 	if (obj_exts != OBJEXTS_ALLOC_FAIL)
 		return;
 
+	stride = slab_obj_ext_size(slab) / sizeof(*vec);
+
 	for (unsigned int i = 0; i < slab->objects; i++) {
 		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
 
 		set_codetag_empty(ref);
-		vec++;
+		vec += stride;
 	}
 }
 
@@ -2130,7 +2134,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	size_t sz = slab_obj_ext_size(slab) * slab->objects;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/*
@@ -2273,8 +2277,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 
 		get_slab_obj_exts(obj_exts);
 		for_each_object(addr, s, slab_address(slab), slab->objects)
-			memset(kasan_reset_tag(addr) + offset, 0,
-			       sizeof(struct slabobj_ext));
+			memset(kasan_reset_tag(addr) + offset, 0, slab_obj_ext_size(slab));
 		put_slab_obj_exts(obj_exts);
 
 #ifdef CONFIG_MEMCG
@@ -7933,7 +7936,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	aligned_size = ALIGN(size, s->align);
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 	if (slab_args_unmergeable(args, s->flags) &&
-			(aligned_size - size >= sizeof(struct slabobj_ext)))
+			(aligned_size - size >= cache_obj_ext_size(s)))
 		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
 #endif
 	size = aligned_size;

-- 
2.55.0


