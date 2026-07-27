Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA51DC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8466B00E1; Mon, 27 Jul 2026 08:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF016B00E2; Mon, 27 Jul 2026 08:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187266B00E3; Mon, 27 Jul 2026 08:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5C586B00E1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 65DED160676
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:23 +0000 (UTC)
X-FDA: 85034550006.03.04645D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C8FBA20009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O58oHHzI;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KVOFL+levc8or+V9XTYywFpS6wBhc+FTSX39UIbiwo=;
	b=GIk5vjYAyWq6swdLKW9BkXLKMtSYYnve3Hsam8V3J+BAVvh+vK08XD06IBG6XalEwBI1Bj
	vkYe82LKgEsPnIgGHDMvzN8sWxSeXwu00/MwgMZZ7dxoudee7Jf8GRfCoADk9c5bkiuJUX
	ZdFTWmATYMA9Sv+GNhZVRrxMtL8SPOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156861;
	b=H+HZM+EiI8kJO296rJy1P3lLf6ZkdSWLqwlBFdvA9AlsHuK5gkPIczYL+HABFIkOD2kz0X
	oYQW2M9zwhG5dbNfr5w5hFSmbJEWALc/810He/dD02udn320oO794jJ55fpXBw+boTbnhh
	Pp6yhTuO3dNP0bjtNbtyAuRNBp66C1E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O58oHHzI;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C03360254;
	Mon, 27 Jul 2026 12:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5834A1F00A3E;
	Mon, 27 Jul 2026 12:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156861;
	bh=+KVOFL+levc8or+V9XTYywFpS6wBhc+FTSX39UIbiwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O58oHHzIt43Rk4hBaYlwOlg3ogflYqy9kUAIyCPTLslbD/hCaUmEZfOJ6XvOvitel
	 IgZi+63qw21pzl+UiTyVMPcTAIEp/oJCN8dRSqEkqy2OB0s9FbdHHHNDacdvX4GiJt
	 4YTSrA1fsxUxU9j6d3rKXuioo0TKXnar/8HFRXeGEQCvVBndgJFypqbMyW04dJfAsN
	 l6r4xlBLMvPwpFSgyQVS3qomkWY9Af7z42Z6kGtS5f5o+W9XJeuW+j+jq2EePhjeKy
	 Sa6n1TYLYrg9xJLwv9g9Z5sg8LLFMTonlyzx//T/3Q+5Ba7+oEolFJ/gmZkndO9pHk
	 kROsvC169HicQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:58 +0200
Subject: [PATCH v3 04/13] mm/slab: make slab_obj_ext() determine object
 index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-4-c29ef0f1f257@kernel.org>
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
X-Stat-Signature: dunx6fs7iiy4yexxuc1nmo9bpzdpm8t7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8FBA20009
X-HE-Tag: 1785156861-938229
X-HE-Meta: U2FsdGVkX1+z8YAcPdPo+EE94s190Ub5zpQWNzFZ0TeadApO95f9pFFZEvn8nOgbZSsuNdi57q26Q5MHWI561CAxrrmPw3MSFfrxAwHKo7SkuVnGTGmpPeTgBVlGKZX+SJfuAGqw+1a7N2uROGSYiEaspBeWmRbgspWiqhmliILQNSIw/ZNNzJeHKbYNAbhmW5/E8rz7D9FuItls1PB9GJafS+037bg2Sp1SgoY99g/l0H9YC7wr7YAjQUw+1S389Z7hg9mLgoZHGQo/0dHMDJamOTWqa4sEF9ScI802PKALsgDHSAXQT6KE0kGUdZ0W7+KwOHgSJhu/iJB1M3kSIyKFiLQP1J4+heiTBNtk/VBUKChwmfnyUErWrS7/g/xXSN8ILYH1yThP+Q3fc2ybbZawzsMTHh9LAfxmlsTSFGcmogRuDsrUu+Yy6uo2dMuslnIj4Fo0ClyBsPT/KG3bLeP4TFuo0QKyYuCqXIRWayE+iCLCXL+NT/iN5Vt166pPGjhtQLvhkMiS3f846f3nUZQV4V5WuPEZKRGo60VcxfDR3lY2UzOnzorwOJkTWRK7aL/tBKOg01195R4e4+hdDkqkO7zhkphatfj8f8nAV4Km2ctpvvztLCz2Wch1Zpqf+jwfMKHokQQey8Noh1gUpqSExLU91Lfhp3mpimkkMBRdxRC2k/y5nlOTtoTtfgDP7WLxbS910SYGV5BFdG2N3CBtOMRFT+FCEK3Ur0boM2V6UHsW0BMMmm2lAQ35JwoT9fcD3HVATpd4Kkoh5mE8b0hIrbGN4gJzm/+BHq5/DD/IaUve5T/eWXaxcZeTOVEVp/qSYHAEFpkIXcmeIx7ECcWyFp0Kcs5tPd4Y4WGCjIG5OIp9pLOR4VCfCbGjYxG2tatq6GdkJTAzLAsKCmEP2B4mpEHsAlpx7dlzTz1vJtJo97IpiENOxKU0GLuQTpr1RAi7tAWyuZPEP9lb6Gs
 suAYOR/P
 Zvm0E3GwxocNiNivL5BLWfKSffs7B2ju7q4FqHfb4bLwx7m1S+Na2i/qkQ4uhBjsGTtLAWqf5krjX6QPHQbA5f7OPDo46RP/b/FPr4etl53ZVlXfHDcYjqlcM1ZuClhFsXRiYl7T92EVTxhTkFYgpGghdvWG955SuKLlyg1+R794wOUSHkEsMSLd64t+xWd08F8QDpv0R5syiPUfNqQbXOpq6UJi/5SRdT9eucfdfPX0VxtwT3rFnMcVyLBT3dbiN4CL5Nc1qQmiAYN67zKlcTiWATRlqcptCJ9Wlmpp123mc8P/31nWXwK0MtigRECY/wHEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers perform the same obj_to_index() calculation to pass the
index. Simplify by passing object pointer instead and determining the
index by slab_obj_ext().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c | 12 +++---------
 mm/slab.h       | 19 +++++++++++--------
 mm/slub.c       | 22 +++++++---------------
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..4e427286a88a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,15 +2865,13 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
-	unsigned int off;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return NULL;
 
 	get_slab_obj_exts(obj_exts);
-	off = obj_to_index(slab->slab_cache, slab, p);
-	obj_ext = slab_obj_ext(slab, obj_exts, off);
+	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
 	if (obj_ext->objcg) {
 		struct obj_cgroup *objcg = obj_ext->objcg;
 
@@ -3541,7 +3539,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
-	unsigned long off;
 	size_t i;
 
 	/*
@@ -3616,8 +3613,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		obj_cgroup_get(objcg);
 		obj_ext->objcg = objcg;
 		put_slab_obj_exts(obj_exts);
@@ -3635,10 +3631,8 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_cgroup *objcg;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
-		unsigned int off;
 
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		objcg = obj_ext->objcg;
 		if (!objcg)
 			continue;
diff --git a/mm/slab.h b/mm/slab.h
index 7bd361447c54..451b50b7f237 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -579,7 +579,7 @@ struct slabobj_ext {
  * obj_exts = slab_obj_exts(slab);
  * if (obj_exts) {
  *         get_slab_obj_exts(obj_exts);
- *         obj_ext = slab_obj_ext(slab, obj_exts, obj_to_index(s, slab, obj));
+ *         obj_ext = slab_obj_ext(s, slab, obj_exts, obj);
  *         // do something with obj_ext
  *         put_slab_obj_exts(obj_exts);
  * }
@@ -639,21 +639,24 @@ static inline unsigned int slab_get_stride(struct slab *slab)
 /*
  * slab_obj_ext - get the pointer to the slab object extension metadata
  * associated with an object in a slab.
+ * @s: cache that the slab belongs to
  * @slab: a pointer to the slab struct
  * @obj_exts: a pointer to the object extension vector
- * @index: an index of the object
+ * @obj: a pointer to the object
  *
  * Returns a pointer to the object extension associated with the object.
  * Must be called within a section covered by get/put_slab_obj_exts().
  */
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	struct slabobj_ext *obj_ext;
+	unsigned int index;
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
+	index = obj_to_index(s, slab, obj);
 	obj_ext = (struct slabobj_ext *)(obj_exts +
 					 slab_get_stride(slab) * index);
 	return kasan_reset_tag(obj_ext);
@@ -669,9 +672,9 @@ static inline unsigned long slab_obj_exts(struct slab *slab)
 	return 0;
 }
 
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	return NULL;
 }
diff --git a/mm/slub.c b/mm/slub.c
index b94482830637..a74f1866c958 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2073,11 +2073,10 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
+		struct slabobj_ext *ext;
+
 		get_slab_obj_exts(slab_exts);
-		unsigned int offs = obj_to_index(obj_slab->slab_cache,
-						 obj_slab, obj);
-		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
-						       slab_exts, offs);
+		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
 
 		if (unlikely(is_codetag_empty(&ext->ref))) {
 			put_slab_obj_exts(slab_exts);
@@ -2365,10 +2364,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	 * check should be added before alloc_tag_add().
 	 */
 	if (obj_exts) {
-		unsigned int obj_idx = obj_to_index(s, slab, object);
-
 		get_slab_obj_exts(obj_exts);
-		obj_ext = slab_obj_ext(slab, obj_exts, obj_idx);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
 		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
 		put_slab_obj_exts(obj_exts);
 	} else {
@@ -2389,7 +2386,6 @@ static noinline void
 __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			       int objects)
 {
-	int i;
 	unsigned long obj_exts;
 
 	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
@@ -2401,13 +2397,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 		return;
 
 	get_slab_obj_exts(obj_exts);
-	for (i = 0; i < objects; i++) {
-		unsigned int off = obj_to_index(s, slab, p[i]);
-
+	for (int i = 0; i < objects; i++) {
 		if (is_kfence_address(p[i]))
 			continue;
 
-		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
+		alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref, s->size);
 	}
 	put_slab_obj_exts(obj_exts);
 }
@@ -2492,7 +2486,6 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	struct kmem_cache *s;
 	struct page *page;
 	struct slab *slab;
-	unsigned long off;
 
 	page = virt_to_page(p);
 	if (PageLargeKmalloc(page)) {
@@ -2532,8 +2525,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	obj_exts = slab_obj_exts(slab);
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
 		if (unlikely(obj_ext->objcg)) {
 			put_slab_obj_exts(obj_exts);
 			return true;

-- 
2.55.0


