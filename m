Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9D9C4452B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2CF56B00A1; Mon, 20 Jul 2026 10:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B050E6B00A2; Mon, 20 Jul 2026 10:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6086B00A3; Mon, 20 Jul 2026 10:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E91B6B00A1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA07EA0301
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:58 +0000 (UTC)
X-FDA: 85009356516.01.143867C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F0844000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+9vjh6s;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557017;
	b=Tm2d1IiUYcqB9ba27Lg56DL/ike1NbwyA3SfVFi9H2Tx2UsdhOf+RVnT9CAU+5lZvADxOA
	BR29jSOxeyrbJCHlVh4f8GbxtJ4Y8po2v7WzdDZ77ixBhSmhDYSjcbhP++Y/+W/4wDaRJ5
	xFtpLpo9Ey1QGDsitZmoLLEvAi/KC+I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a+9vjh6s;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjoSP6iddXq5PqiuJFnR36EEih/xwOGHSb79nndRhpk=;
	b=Kc2CQ3MBrpZVXIuvNwRU7My3sxtbujf8ZVkcJ1GMJkXrSdDVsYgGOX3ft3o0gVLfwoEAB4
	BK/SqUlm3taO93O7ldxdvrG+G2W8JJq2U98+cRtR6sUBJSeqFmL+O9ITPWEAPKY3DD8cre
	Pfunu+Eg7YGUkQmev8fOd3pKYGie6KQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A819C60A84;
	Mon, 20 Jul 2026 14:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1B01F000E9;
	Mon, 20 Jul 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557016;
	bh=bjoSP6iddXq5PqiuJFnR36EEih/xwOGHSb79nndRhpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a+9vjh6s3qu0BOkJaj3suWW2z1csNZFV0BtPZnhUHEIoGJBS5KSiGcwnk1Iks8gjB
	 m2TT14Rmb2TkuX4tC/0hR2o6oKdj+ECei+hB7/v0JUFfK1a1Bjif5cRzPKzpArgJnB
	 F/Eu9SyTDosipKO0glkdRQVWnKQVr2ph8jvPAHP2snGsgqAljhAESwJZm3oLK5zMjg
	 1lkq4VUhebyhhtNHmqRVKC50zawjTgscX15PrKG877KXQdPKJeIGLdfM+lr4FvoQZI
	 7hmvIQUmidozfjtyzthbhwlvNw/QHs4E8wumY8mGcwpUuEKUmDCUDc8iBPPFocVtJA
	 uVTPgzFqJtSaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:23 +0200
Subject: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
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
X-Stat-Signature: byijdo7faqfxg7pjzezhnqxf37453h7u
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0F0844000D
X-Rspam-User: 
X-HE-Tag: 1784557016-436092
X-HE-Meta: U2FsdGVkX1+bXEoR9SMNpC+Z7clHEsAee6VAvDq84Kxw6w80g7xc/HLhmjxFX9hJ30NLMmFGlSXYe/2Ed8xvLOqm3bRdEkjuyRT59h4ORw3r/FQ6JbZ5uWfcKinJ2OZUMc+0OJnUX4bb6HKoxEbybRms3SYkGdJy9hZc5cBHkMHwM4/RotKo4RbbYP6QIkOB7d5Cie3jUggMq3HHk+/yNk0umf7MeEfsZ2t1rlLZw82AwHutlpZhH+WXw7z2jFVR63UemV9eSsWvkEd/UxR6WJQHZipHCbb43JB2kqxnAb7L8c1WxdS1kn/Jc2V2ZMdENYcXJD+RKkoGSeaoQi2IJZJ72jai/glh6LYabZjinCG/2Tv4BGdDEsphezPOBbBKCSerOuBzZai4wxEgo3FsxAUuN+X2OfU11f9dRkpGPlJqM0NMMoZy7TVvSN/spYqyz0n4O372RS8XPZyjv0CuUF2PR5Bhbz2vg/k/v9dNYh8CHOf9k+0BAs+efqGpjotVQ0vO4je4V5YeKwO97r/VVux21XvT3j5w40Oi4dS2lYV8vRQeQEKzFbP13SRTClZu2peccepS9+j5LrZEPSJviuz9jeUzOHCJp9PkvNXyonrir+idzHUEjcB6Bvqkoerzxj06YiVzE5ferOIamr8yVrn0QEbXkO3RW4NnlGN5Bjv/es4EHIvUkHpfagiVl6SKrPl1e+yytI82EW+GtQnlQspFPe3KK80oe5H29r4qhcbIA6HXRsohwUVLVW+c3+dSAAFVvQ8z+EXE2qOVjXs3HBKk89yVLJPhdQXouTk/InqGk1ZTl2i8AtNKpPvpgoPzbX3t59GgZo3jOXZNPUnxzErjX5oOvc9l6tkYcj9IZ8mFrTH3JkJ9Av/Dw0vaFvpjr+FdvoCoOWxQpbGo9eP+j96Opxp4ruNHU4w4YbUQoDAPKUKMHQTB690C/9wW8M/Jt8d80edBySRXNDN97Ay
 hhDbrKMa
 fWUQtB7syEzZxvLJLi9BftDpiOCrlgZQn4qG2e8pf1xnV0z97Ge3d34cP7po05dkidwN9rTecFo4n2PjZhoXZF/es4ZU7GwU4bB7+nkS6994CgQiA6F5S0v4HRgsDTGU73RwXduxW4eZR/Dv1wEGE+egiZedDCX/QGYW6Zd1KalMB5ZXOalAjEtbEoEGgC7xN0CQH7KwLQTHlPSsMzCbEFlTpjTU/Ic2RxFz10BZdJh91ulBlqlRj4SCRoXfT47i6eF846kTNRj6x/jMp9g8Y/k6ULJyJNnxh7I2LombwVWsziz0PY1Y9EexXWPJWEVfYfykh
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
index e586798e4f16..f8446167e175 100644
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
index f5b3eb44cb8a..287cbf3eddcc 100644
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
@@ -2094,6 +2094,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 static inline void handle_failed_objexts_alloc(struct slab *slab,
 		unsigned long obj_exts, struct slabobj_ext *vec)
 {
+	unsigned int stride;
+
 	if (!mem_alloc_profiling_enabled())
 		return;
 
@@ -2105,11 +2107,13 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
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
 
@@ -2135,7 +2139,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	size_t sz = slab_obj_ext_size(slab) * slab->objects;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/*
@@ -2278,8 +2282,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 
 		get_slab_obj_exts(obj_exts);
 		for_each_object(addr, s, slab_address(slab), slab->objects)
-			memset(kasan_reset_tag(addr) + offset, 0,
-			       sizeof(struct slabobj_ext));
+			memset(kasan_reset_tag(addr) + offset, 0, slab_obj_ext_size(slab));
 		put_slab_obj_exts(obj_exts);
 
 #ifdef CONFIG_MEMCG
@@ -7938,7 +7941,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
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


