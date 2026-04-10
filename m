Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D265F44840
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 11:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1966B0089; Fri, 10 Apr 2026 07:22:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9286B008A; Fri, 10 Apr 2026 07:22:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05FD6B0092; Fri, 10 Apr 2026 07:22:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3A406B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:22:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 519FB1A04ED
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:22:37 +0000 (UTC)
X-FDA: 84642408354.28.99C3356
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf01.hostedemail.com (Postfix) with ESMTP id 767C140010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:22:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s90fG734;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775820155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/FgmDbPdVKeTFmDflrD7GhFmg1r0p/Z0QkjNzZaoXas=;
	b=xzEKiE2PTjYhbhAkMQNwV83RmwQAiu96WZ/6kQLQsh8tWGfki/ysp2bO9GPkCUQgUSmEj5
	Aa9SyTMhd+vZUOlSBl6SgsQVT4lIiZDkp3U5gV6ffZhnZZvjvp4zYTxnjBulzU8IpLueBw
	pX0vajBSEW1dtCtzliNaI8JzPOh2OyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775820155; a=rsa-sha256;
	cv=none;
	b=bpWdUFlvsG0605rfIhlrz9v7jS1P5LNbNBvgp1j6UL5SJLU1S9O5lnVe0MUyL3Vg5dIY7L
	sotIb7+zxM0zq3QPXlTituC501Fv3+rZ9ENaRgXR2kBpae2jDbIkUbmtdUSuD9O6zSOhdG
	78KSYNnehIZ0BJmlzyVDJQzjwQjSGzE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s90fG734;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775820153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/FgmDbPdVKeTFmDflrD7GhFmg1r0p/Z0QkjNzZaoXas=;
	b=s90fG7347KOkTrLsFMypwJ3sk4ZKJadpaDexywNknA/dFcbsYhu45VQXmDXrRY+wH9BgwR
	AgpSjtItYoAtN120d5Jc1MBgPoO0sa4OLoTjf44KsJVYsGQILD2t4xXVEpiHEeWRzwzMZw
	NRW11qcau0cHbbtGVF7OXyaNhheAvZI=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.orgg,
	Hao Li <hao.li@linux.dev>
Subject: [RFC PATCH] slub: spill refill leftover objects into percpu sheaves
Date: Fri, 10 Apr 2026 19:16:57 +0800
Message-ID: <20260410112202.142597-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: 5qmpikq63ggy7w8od3zqj3icpjthpc35
X-Rspamd-Queue-Id: 767C140010
X-Rspam-User: 
X-HE-Tag: 1775820155-57618
X-HE-Meta: U2FsdGVkX1+J275YdkXkV8n7XIrIHxQN52f7dl/oYhhJF3slJI2v55cgysm51G6rVcrTvBZ0zDeJgdfBynE3enpkRTwO/cGlWELYILUJhdDoRWls4Eng/DaAMi0sjKu3arwHObbh5nxyl6wZnNutI9Nv3v/G0fJepRRhRhsjhf0lgFatP5zdTm55yuxYTPwgq3jq4TknppOxvA/ZgqRDjLhHU5EaxaJbRQLHQ3IsyAwstIZ7nCByi6rSDYIiB/KpqOHgiYk0/zpoDNAcj07PI5oKu51tpuFubjl6EdiI2l6VQr474eJO00XtDSBbodGghgVDTKczDODpbcckcoMQjQc3Zd9qa8I4o0WC00NWdSt5tifBEQt9lBWHAGKjVZu/qN3KurvtDNpejsv1isurAB9Aayn3p4PaAxhQNED5iIZpUR8B2OpcN4yQ043de2vVCQgj7SHg3bc9u6oW0PNzPN0vd4S3vbrCHqYbh3piZoiEw6K4HO/1EBGI2X2QDMummH+bnDmpydFwCtkk5hw5MmfrGm8who83HnJveiWc9t+E2P673ytdLA4g2F2Xvf3imxEtvXWDDi1S2x5XKvLlJeb7VEDdzAn6/jun1yg+7nfkxAj9Kypx/NfwbWnTPLBs/D55U5ykZTrclvL/dgeOrJtFPfpgqmHDuYk60ym85Cu/WUuU00H7EsNCIsUC0uqo/8ojf8dUQjtn/4bm6Gj45aeeZ5H018P2sLP53VtC2RH5nxGuazFgIXtdvO1HpyXtgCYBAQ/jWgNFE0F1HiCRnjlqjzUDebpKIe133QGbZWa+mpWcch6HJvKr+2aFAEgyBGZKC9IAodgpUGGLEvnLJ/+h2LR2RTMQID4VN0CTPJW2njeF0PTpepzHgvaZt5IFvPqVOQz4Ulc8B046pgw3WgUGVmj5zRB9g5cR+e0npdA7DhaXQCY8qECXC3AwB66fG1fMLTXyMvyK3PHRmgP
 viPtZCYE
 cx68OzmzYnqcFR/wDz1P0yTeMdamit1sFM3gj9JlN2K31wChGDH7J12vRdO+IUsL/lMV5KzLcZ8IRknbKA8ym4JgcP7nHUas0os09u0Fq+QFOmNBkz4RnEfSB33Kb0tutI6w4jpcyZC83OoXQT2KvDL/WDgj3Bsx6mftb/HstJq1Gligwa73P/Bhq2SBSxIxB8nnJ2GifxeltdOqjo9IzHxIZqcuDdYrToQ0G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When performing objects refill, we tend to optimistically assume that
there will be more allocation requests coming next; this is the
fundamental assumption behind this optimization.

When __refill_objects_node() isolates a partial slab and satisfies a
bulk allocation from its freelist, the slab can still have a small tail
of free objects left over. Today those objects are freed back to the
slab immediately.

If the leftover tail is local and small enough to fit, keep it in the
current CPU's sheaves instead. This avoids pushing those objects back
through the __slab_free slowpath.

Add a helper to obtain both the freelist and its free-object count, and
then spill the remaining objects into a percpu sheaf when:
- the tail fits in a sheaf
- the slab is local to the current CPU
- the slab is not pfmemalloc
- the target sheaf has enough free space

Otherwise keep the existing fallback and free the tail back to the slab.

Also add a SHEAF_SPILL stat so the new path can be observed in SLUB
stats.

On the mmap2 case in the will-it-scale benchmark suite, this patch can
improve performance by about 2~5%.

Signed-off-by: Hao Li <hao.li@linux.dev>
---

This patch is an exploratory attempt to address the leftover objects and
partial slab issues in the refill path, and it is marked as RFC to warmly
welcome any feedback, suggestions, and discussion!

---
 mm/slub.c | 107 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 88 insertions(+), 19 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2b2d33cc735c..fe6351ba0e60 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -353,6 +353,7 @@ enum stat_item {
 	SHEAF_REFILL,		/* Objects refilled to a sheaf */
 	SHEAF_ALLOC,		/* Allocation of an empty sheaf */
 	SHEAF_FREE,		/* Freeing of an empty sheaf */
+	SHEAF_SPILL,
 	BARN_GET,		/* Got full sheaf from barn */
 	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
 	BARN_PUT,		/* Put full sheaf to barn */
@@ -4279,7 +4280,9 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
  * Assumes this is performed only for caches without debugging so we
  * don't need to worry about adding the slab to the full list.
  */
-static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+static inline void *__get_freelist_nofreeze(struct kmem_cache *s,
+					    struct slab *slab, int *freecount,
+					    const char *n)
 {
 	struct freelist_counters old, new;
 
@@ -4293,11 +4296,26 @@ static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *sla
 
 		new.inuse = old.objects;
 
-	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
+	} while (!slab_update_freelist(s, slab, &old, &new, n));
+
+	if (freecount)
+		*freecount = old.objects - old.inuse;
 
 	return old.freelist;
 }
 
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+{
+	return __get_freelist_nofreeze(s, slab, NULL, "get_freelist_nofreeze");
+}
+
+static inline void *get_freelist_and_freecount_nofreeze(struct kmem_cache *s,
+							struct slab *slab,
+							int *freecount)
+{
+	return __get_freelist_nofreeze(s, slab, freecount, "get_freelist_and_freecount_nofreeze");
+}
+
 /*
  * If the object has been wiped upon free, make sure it's fully initialized by
  * zeroing out freelist pointer.
@@ -7028,10 +7046,15 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 		return 0;
 
 	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+		void *head;
+		void *tail;
+		struct slub_percpu_sheaves *pcs;
+		int freecount, local_node, i, cnt = 0;
+		struct slab_sheaf *spill;
 
 		list_del(&slab->slab_list);
 
-		object = get_freelist_nofreeze(s, slab);
+		object = get_freelist_and_freecount_nofreeze(s, slab, &freecount);
 
 		while (object && refilled < max) {
 			p[refilled] = object;
@@ -7039,28 +7062,72 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			maybe_wipe_obj_freeptr(s, p[refilled]);
 
 			refilled++;
+			freecount--;
 		}
 
+		if (!freecount) {
+			if (refilled >= max)
+				break;
+			continue;
+		}
 		/*
-		 * Freelist had more objects than we can accommodate, we need to
-		 * free them back. We can treat it like a detached freelist, just
-		 * need to find the tail object.
+		 * Freelist had more objects than we can accommodate, we first
+		 * try to spill them into percpu sheaf.
 		 */
-		if (unlikely(object)) {
-			void *head = object;
-			void *tail;
-			int cnt = 0;
-
-			do {
-				tail = object;
-				cnt++;
-				object = get_freepointer(s, object);
-			} while (object);
-			__slab_free(s, slab, head, tail, cnt, _RET_IP_);
+		if (freecount > s->sheaf_capacity)
+			goto skip_spill;
+		if (slab_test_pfmemalloc(slab))
+			goto skip_spill;
+
+		if (!local_trylock(&s->cpu_sheaves->lock))
+			goto skip_spill;
+
+		local_node = numa_mem_id();
+		if (slab_nid(slab) != local_node) {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto skip_spill;
 		}
 
-		if (refilled >= max)
-			break;
+		pcs = this_cpu_ptr(s->cpu_sheaves);
+		if (pcs->spare &&
+		    (freecount <= (s->sheaf_capacity - pcs->spare->size)))
+			spill = pcs->spare;
+		else if (freecount <= (s->sheaf_capacity - pcs->main->size))
+			spill = pcs->main;
+		else {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto skip_spill;
+		}
+
+		if (freecount > (s->sheaf_capacity - spill->size)) {
+			local_unlock(&s->cpu_sheaves->lock);
+			goto skip_spill;
+		}
+
+		for (i = 0; i < freecount; i++) {
+			spill->objects[spill->size] = object;
+			object = get_freepointer(s, object);
+			maybe_wipe_obj_freeptr(s, spill->objects[spill->size]);
+			spill->size++;
+		}
+
+		local_unlock(&s->cpu_sheaves->lock);
+		stat(s, SHEAF_SPILL);
+		break;
+skip_spill:
+		/*
+		 * Freelist had more objects than we can accommodate or spill,
+		 * we need to free them back. We can treat it like a detached freelist,
+		 * just need to find the tail object.
+		 */
+		head = object;
+		do {
+			tail = object;
+			cnt++;
+			object = get_freepointer(s, object);
+		} while (object);
+		__slab_free(s, slab, head, tail, cnt, _RET_IP_);
+		break;
 	}
 
 	if (unlikely(!list_empty(&pc.slabs))) {
@@ -9247,6 +9314,7 @@ STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
 STAT_ATTR(SHEAF_REFILL, sheaf_refill);
 STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
 STAT_ATTR(SHEAF_FREE, sheaf_free);
+STAT_ATTR(SHEAF_SPILL, sheaf_spill);
 STAT_ATTR(BARN_GET, barn_get);
 STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
 STAT_ATTR(BARN_PUT, barn_put);
@@ -9335,6 +9403,7 @@ static struct attribute *slab_attrs[] = {
 	&sheaf_refill_attr.attr,
 	&sheaf_alloc_attr.attr,
 	&sheaf_free_attr.attr,
+	&sheaf_spill_attr.attr,
 	&barn_get_attr.attr,
 	&barn_get_fail_attr.attr,
 	&barn_put_attr.attr,
-- 
2.50.1


