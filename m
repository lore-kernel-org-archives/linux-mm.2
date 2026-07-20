Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44DCEC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE6B6B009F; Mon, 20 Jul 2026 10:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510D66B00A0; Mon, 20 Jul 2026 10:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427126B00A1; Mon, 20 Jul 2026 10:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19C5D6B009F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DA01C01D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:52 +0000 (UTC)
X-FDA: 85009356264.02.CF55B82
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF6DD180011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeexIb05;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6r95VsQz7/bTPUaUrteE7bqXPatxg+Tzf2bzkDOfpus=;
	b=gytwcX79IZyquF4eYIH+pOUU5z3CHUrxb7APlezzn9Uba6RDCSZP+BHOFeJQkeiXn9GBsz
	no9/fQ1GafFf/xSEG59exKxszUW3+7XLx7BmhTEsDRj+SBb1kLRdKWM+5B32zmPaZiiwJU
	o5AQiV7tZxmocArsTONk4IVEapeoAkI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeexIb05;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557010;
	b=LsRXwpaKs07GNsJdu7VPKxjhWB4dJGNWMf6CkdnghNwZbyRAraFPlPJIWP9Up8BfAcRRQD
	7jBFrauQXYwggR4Cv2/br2TU8rIDN+Bo9wAThCZenlAQb+620B9Y1azTTMYRy13uEkjAV1
	qgBY2OUrQNqBYr0lLEHJukhOgY2CQfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88FFD60A99;
	Mon, 20 Jul 2026 14:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC431F000E9;
	Mon, 20 Jul 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557010;
	bh=6r95VsQz7/bTPUaUrteE7bqXPatxg+Tzf2bzkDOfpus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FeexIb05eHtmuOUiBfDtAWxk3PrPlHYamFu45sXhoPfPvLfZHK3B+P/3oLwfibj3F
	 2KM/AArbZ55tU1uwIesTVdWN2BsJV9KT2SqwUU2I3pTlWgAoC3yfkkTt3FnVETIfH6
	 8ETfJb47yFBxAdkpg3KmKOmKFV8jjB0KLX/geS+LghDHRmuPHWUcEJp8ntR8H8Xu5+
	 RxQ6aJZhttrV2b8/IcKp0pHMgDmq+GK/aKseQVharGFoYKdP7ntubaYo0UGSh8QE8d
	 6+M7ZI7lwH/Aq3mupNhevs/wzMenUWn5Xdbs3woHw5ZgEcr4G77yvJbbClkazgqFWL
	 +R692rxxO6N4Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:21 +0200
Subject: [PATCH v2 07/13] mm/slab: abstract slabobj_ext.ref access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF6DD180011
X-Stat-Signature: hkzgi76sjc71j6ys69i77bm5rpjmmeiq
X-HE-Tag: 1784557010-552392
X-HE-Meta: U2FsdGVkX19VUPUQJk0aA/sHlCx/Z08EJmvFf0KBh0xRCs0LYIhATSP+NYRc//ZeQbztqhCI1OkJTy4sId/0yR+cU3vPF6GNsxGNkj78b48FNewZPPEzRU1Mv9VnV4SEYuTSeB8sCbxNir4pZyAH94HjEs5woBY1V/ZMF/N7JgFu1dAFeq8e4u0yND3jb28M3LlmesuzlW3Q9FRoMfUCakaOBKz0uWBwsLLuuV/6U8gAKxRp4g+2GudgTkhUtyqvIOUI5QFRP5wDzg94MUnxjTstKBUOSjuNUvHz8D90Pd3JUyN3MvnLy4UOkUqTuZw9YSwECUzcss3Js7aIoyBQFp9eV2lajRXwHWXm3xLIL3Wc5fKQP4ZDzv1ih1vwWHz0iuVIPXPNKWSq17SAl04ox6QaFJ9NKRtrmM6B3ramD6iHUzFbKmA2WuvjRdTgJbSrEe8FGTqWqi9EnwpnpOquwz359ZWO3yBAoSbolYm73Z2oTFXZo2iiJ5B6f9rffEb6XnCvGhAYkqamZOAn7zu+E96pfQp/d1nCqMKB1sVYmzixLz5xGZP4Iz36BEJs94/A8f6lWp4JHjFvx6AtIOz8UFGlZfJgM6ez7zNFQHaCKFe3kgpyKMpFfSU6H2t+hlnBwG810ZVEmqs5egSoc0yzMLzOlwbfOHAyTeIyxCTtPVbg2KluKMmpiEXZU2mThvUVEiV4+VQMIaPhH8HWvt07xPUdjL97YyH5iApyh8v26Ca8gGumvXVg1SQy1hzedEHIXuAV+RMuB6iIyIu0vIxvBaHfSSEAm8k4WalMaNfXRDMbW2M+eQdVb1zvo9NTDB7376utHtVqTO3ukvcYtrIVL4s5vFBvyvgpmvL85Z0S+8nPkSzlVrIm6Tl/yjVaMU2L9qTOXkElb/zMmpmyJDjXedFXjZijq3RFrinz9O1AlMiSrzFzGtJfq7wlBYRQ9vHtddpeqjrkBsf8suC2zq2
 vYhv7ykp
 fO8Lhsy2xtUn5yOog4sqLtFyXagc+rW9vEhUdkw6dJJsLpstUcD02xSMYjgW0wYz921gHYVvDTm0IC3uC1rT9yDg6ZAFsXlk7zClHw6113GQOi/KxLN3K+C2Glho5Ts1e2xsGk4C4sGa64SbqNf+tOD/OgGDrZzab8up1PmOB7p73GNQ64Xh4Q9BHwieMXhh3EWW0hLy+9j64DjTOoP8SiOdeX3+XuEk7sINk1YN7WcB2+juXpNnVCsYgZswndgNpjL4373Wu5KbPomI5AsC8t4WqHUy8KLIDfI1lmOUq1TegtAJyD4YfwPbwIiUF63yCNSo0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for changes to the structure, abstract access to the ref
field with a slab_obj_ext_codetag_ref() function. Rename the field to
_ctref to make an unexpected direct access a compile error.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 10 +++++++++-
 mm/slub.c | 42 +++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1d1771f97aca..62d6366d7d79 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -558,7 +558,7 @@ struct slabobj_ext {
 	struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref ref;
+	union codetag_ref _ctref;
 #endif
 } __aligned(8);
 
@@ -675,6 +675,14 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 }
 #endif
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+static inline union codetag_ref *
+slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
+{
+	return &obj_ext->_ctref;
+}
+#endif
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index f2ffadde879d..cf999cbe75d1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2071,23 +2071,25 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		get_slab_obj_exts(slab_exts);
 		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
+		ref = slab_obj_ext_codetag_ref(obj_slab, ext);
 
 		if (is_kfence_address(obj)) {
 			put_slab_obj_exts(slab_exts);
 			return;
 		}
 
-		if (unlikely(is_codetag_empty(&ext->ref))) {
+		if (unlikely(is_codetag_empty(ref))) {
 			put_slab_obj_exts(slab_exts);
 			return;
 		}
 
 		/* codetag should be NULL here */
-		WARN_ON(ext->ref.ct);
-		set_codetag_empty(&ext->ref);
+		WARN_ON(ref->ct);
+		set_codetag_empty(ref);
 		put_slab_obj_exts(slab_exts);
 	}
 }
@@ -2097,8 +2099,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects)
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec)
 {
 	if (!mem_alloc_profiling_enabled())
 		return;
@@ -2108,9 +2110,14 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		for (unsigned int i = 0; i < objects; i++)
-			set_codetag_empty(&vec[i].ref);
+	if (obj_exts != OBJEXTS_ALLOC_FAIL)
+		return;
+
+	for (unsigned int i = 0; i < slab->objects; i++) {
+		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
+
+		set_codetag_empty(ref);
+		vec++;
 	}
 }
 
@@ -2118,8 +2125,8 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 static inline void mark_obj_codetag_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects) {}
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
@@ -2187,7 +2194,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
+	handle_failed_objexts_alloc(slab, old_exts, vec);
 
 	if (new_slab) {
 		/*
@@ -2367,9 +2374,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	 * check should be added before alloc_tag_add().
 	 */
 	if (obj_exts) {
+		union codetag_ref *ref;
+
 		get_slab_obj_exts(obj_exts);
+
 		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
-		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
+		ref = slab_obj_ext_codetag_ref(slab, obj_ext);
+
+		alloc_tag_add(ref, current->alloc_tag, s->size);
+
 		put_slab_obj_exts(obj_exts);
 	} else {
 		alloc_tag_set_inaccurate(current->alloc_tag);
@@ -2401,10 +2414,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 
 	get_slab_obj_exts(obj_exts);
 	for (int i = 0; i < objects; i++) {
+		struct slabobj_ext *ext;
+
 		if (is_kfence_address(p[i]))
 			continue;
 
-		alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref, s->size);
+		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
+		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
 	}
 	put_slab_obj_exts(obj_exts);
 }

-- 
2.55.0


