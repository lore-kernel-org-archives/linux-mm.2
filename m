Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B03C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447BA6B00E3; Mon, 27 Jul 2026 08:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4201B6B00E4; Mon, 27 Jul 2026 08:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335E26B00E5; Mon, 27 Jul 2026 08:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05FD66B00E3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 86F551A0714
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:30 +0000 (UTC)
X-FDA: 85034550300.21.070941E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id D021CA0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fkmC1z8U;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gW8C7PtNJ+J/PwD5PEcFchCBIkGoW7Qb4a15wmFBizw=;
	b=YCxbTa25hawk60uozwi1jW6KgGRV1pdOI2NdmpZK83twof08uf1MRFMMzvBdDcN5fQbPtl
	NP0mAIGtCKl/EkkXgJQE/4ev9K+zV5RiaXKlz5GsF+jnE7lr2enSL71ADGVbz1Whr4fYF2
	I31JjUCaIDM+rEGg5J2JnhbAo7gGBDs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fkmC1z8U;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156868;
	b=UdPTdoVIFolWjgDbwpYKMLPIqPMq1hZYGA3WrB8I6K+FwlCuyAa7l+GH3K/k0i/VEplA5A
	+9UKOo4pGNtGw7jB79iL8BYkdRYguqC5htMoeuatJT6TD7TFaJP4yqHlhDJoa68NPuiuq5
	3ymAnsRs6nIYi0yTEUj62SIraSeTNT8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9B5B43612;
	Mon, 27 Jul 2026 12:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29401F00A3A;
	Mon, 27 Jul 2026 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156867;
	bh=gW8C7PtNJ+J/PwD5PEcFchCBIkGoW7Qb4a15wmFBizw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fkmC1z8Uo+Zrb9IsjCAIGPDivm4rLDxbZ3NzWOLqdv2tENqp54VHYp/nhcCyfo2IL
	 +wwzgZ6d8ql4m30hLTOx66HujzWnxtLR1VprKkXmqn5hEX/HCHzfg1RUnrwJfuvRRM
	 PV4kD005UmkY/x5pZgebArEPDnEYYDLPk7+hnaX2BgI32VPen1LiANtg1ZRABEgbb0
	 DgurkN8U7yH/ZHWNIZ39cDQK1N16gsz/A48tTPbsl12Jxj2qsV7hKl3GWZewM4Fg+M
	 Wssdh3euiVVXpUAAs0NOtJSvsrVslXxLzM4LdWh6x7ZLeJkEPsjP2X6nTzzFdZKX4F
	 GzK+MrbR845Fw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:00 +0200
Subject: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D021CA0006
X-Stat-Signature: wxexfnokft1mfjj8mfcii437hyp9ii4w
X-HE-Tag: 1785156868-433230
X-HE-Meta: U2FsdGVkX19XvE7l8wDzKDTLvDVG6r/v42ZJgnDeJcJCapEyF8KZCANw+o7ab0isfJOx/Rm0lf1UqZMqCc3k9EqFqoChagM2kSmRDJr0d01GeBowJLOKRsjuXkYr1NtKYqNSwA49QG0GB2puh2BYxxXOYwk16xkg0dPr4PxWWLtRXhSG8noCjAmgDKZvAs63YzKTbcjX9fN2AhLtL5vtsnDXEcdCApFlU1QC3p8WTbNb3XI1F7lbiSJb6F2gQjgO6TDloMhUQRnDMtT9MrUJqiyBp1j6fiAh5whJmdL3v/lwvFT7P5hiHaCJcjz2zVJlrgDD0VJf9eul3ux3VvCK7ClFf6Gd81L+uRQSuyqeSuSPv9MlfSXtZfp9BABiJDYIeIPnI6p1y7WjplROahTCEMc5KE6dVMqivsYV+5RM6vVjyVX7WxfTMrhU67PoDvuwE77rvEgGX14p58zCFPKvqEO4Td31EddWzkraYWufFMrSXNff/bzTo2PlYQz7nMVrK5mp8LXcHk5fB0Gn07ulEaPuVm9pvF0sg2O1mNzOIJefoXyG7xJzvNOpjnx2L+/e2jOipIRurJsbMZYe5B10vHYIcDxgLkgLUQ1MQiCwcfO7UYPrqUxhJHUDpD81PeG9c+LhOU3PKecLWlY3zC1+0sSA2RPs29MCrnhietHe/CsAJ/Y8i0A0LbEMBfrEFiu3431OqzVhgb3U+7SqGLDmvhGUqTjPxemqzgBic+Yrbki86+FcsiHayFakz4AGC3nVs89OSuQZ26B5oZJPMbDTORFQ8LEDD4vD2b1afEc6X3QCOtvw2/von64voVgXvhoHozLLEXlwrmToC3oYuYrxBr+6TmYI+53Amz3ByCXTxbGPP1vBiVVPb0tOmCHCkAsPthfhhVTv548fGy2qa4QjnDddo6BNGzM58KpudOfCHmW7PqzfGf9+e5/yOefaZrEWC1KxP312zcQGlCH7Yxa
 tDKpvgd6
 XPa+JEZd9pnnoeLKkpWsz/4y923wTL7LPrfD6kUps3Ckf1VoHKwWPvXRxFqyTm8ER+GdrL5dmSHFwivmfVzdQbfrkrWRhUAND1Jo8kKCafdspiTjmwqwLVaf2GlLQMU3A8LBiBE9YuliuF1BrWN1JegH5LZOKVHd3+0/8ESp8YOUAHRYrdVNnalJmMOg2ApempbPJOtUG7CguNEu1eEQXhN0cbUfp/miq5ssMPeMeUYvrc2i8AY+v7btrrkJBcx4cDJ9qaIDH4KKkJfCnShic2Gs9JLsccoHc9rSRi7/QqGk+QvFB8hk+kZ+Qi7rgqVF3nNmh
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
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 10 +++++++++-
 mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1e4f61607448..562b62802561 100644
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
index 2bf38fb1a3f0..7812a7c097c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2074,18 +2074,20 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		get_slab_obj_exts(slab_exts);
 		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
+		ref = slab_obj_ext_codetag_ref(obj_slab, ext);
 
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
@@ -2095,19 +2097,22 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects)
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec)
 {
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		unsigned int i;
+	if (obj_exts != OBJEXTS_ALLOC_FAIL)
+		return;
+
+	for (unsigned int i = 0; i < slab->objects; i++) {
+		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
 
-		for (i = 0; i < objects; i++)
-			set_codetag_empty(&vec[i].ref);
+		set_codetag_empty(ref);
+		vec++;
 	}
 }
 
@@ -2115,8 +2120,8 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 static inline void mark_obj_codetag_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects) {}
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
@@ -2184,7 +2189,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
+	handle_failed_objexts_alloc(slab, old_exts, vec);
 
 	if (new_slab) {
 		/*
@@ -2364,9 +2369,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
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
@@ -2398,10 +2409,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 
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


