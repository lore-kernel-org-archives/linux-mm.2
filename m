Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292BACD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ABCE6B0095; Fri, 15 May 2026 12:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 584E26B0096; Fri, 15 May 2026 12:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AA86B0098; Fri, 15 May 2026 12:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2056B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 084E51C0220
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:49 +0000 (UTC)
X-FDA: 84770177898.09.B10333D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6415518000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eJWAZeyo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2ARnTGC8mWB0sZq6n33+615A3YBCNA81Bkxm8JmnZw=;
	b=rgRT7BWNHcAWHkwNjw8mFD+Us0Fs0Aq9gOlMA5E+V0MSmyH+6hXRunWJPCDXLn0vSxELPG
	laD2NKEYw5+JTAvLf/G2CYMKR4vuzb64Q8P2mKnwqoXMzp9G6/zKhgmw7aucTgZYxReOCj
	uZrRsqyO6aGJRYLCJwCR40nPraEvEmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862287; a=rsa-sha256;
	cv=none;
	b=7YlQdDpkwlSfQE3UHs4t3gHXTlDYdNW+1NRtcgoBS86VjeJ3ws1MSbgf3R8NTpJZFdrJ2h
	DISM4OLV3RKeyuZnVor8GiKLPIXg+TnX3eeCXEtaKGRfpfurXPam7inqGOwDDCqiDc12hX
	B5AUuOPTM8dTjN27tVpkkuZiQshxPJ8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eJWAZeyo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1BA1601E2;
	Fri, 15 May 2026 16:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8423DC2BCB0;
	Fri, 15 May 2026 16:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862286;
	bh=n8roWf7IiSB3Cp7Yv9UEETQTWbilYSL2KXuyP3eF33Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eJWAZeyo/z3+nAssoq1IiCClb1Yh4ZM4vmqc0mW1Gep3eYOUhL8PFm77TbOUlgeG1
	 BG8DVRvBDu0hnBjONljT94jzp9iWd2R+y7pTPYdR3NoDAck08rwJ6SxvSbk6I0YKaf
	 fiX7WKYgD3dVkOhyWqiCvnr9MbialyZydP2x67YjY+YX5bhJYGSCf726SKLN6AudvR
	 lDE8VIS5iPd/YQOnHjtHhVy88qsQXjBw2WoGcsiqYuVMkX7HSHmtL4HdeK0IVfbNOW
	 Ud+MfKejBmlxfwrGudKM+HAyLlgtqEgt/A7FQfOHePI+xnHbeDCkNP8XwlfBsIGCFX
	 rM5Snaz55NGJw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:27 +0900
Subject: [PATCH RFC 3/8] mm/slab: track capacity per sheaf
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-3-221aa3e1d829@kernel.org>
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
X-Rspamd-Queue-Id: 6415518000C
X-Rspamd-Server: rspam04
X-Stat-Signature: w3tqhjh1gjbdm16p8jnz38oskiyi5cxm
X-HE-Tag: 1778862287-368342
X-HE-Meta: U2FsdGVkX18AM3y8JPnRgubiVgYy/l01ugq1Wn1ou6V7GuzVp8641rFfxi5eNyk/OMULIzwzCneGwYEbp/2evCpOvo+Qu8FpDb/SbCkO6P3yb3IjKgd5T4YfmeVY4zxU+C9nTtzHEf7efVcG40vvWvjwwOD6CbhG1RLovH1LwLPVeROWBINXFHqfYE+EzwkV+M6lMTPv/lkuIK262zFVxoik1cuPQFfGTU7mXfbbm3nmQERUPn/AY8rwkCHa0+UfaLZZi+mak70OxD328RDWTXiTYhQc3ur9gncCCBOkTXRcZESrmCpW/+lbx2Xkbl1tQJ15eg0CbVAh4m6YOCJWJXpQSIokFXtV7WqmS/40ztTBcGpczn9ey9LfjSnQqGNFGq9BtVRnFNEmUK3IYjZvqpEt09Zga3zl2TObjFbDS4KDNCc30W+T1Z6FtUha8HMHE5irtWTWj3ueWxJ2xt1n3bhV+ieKlrTSucmPkJiLfYObGa4YPhmkPqu7udb7r/tMKlfVcexDONeWD9Yl+ksRDsmgdSegRIbAynTEBh/j48I5rfMrP3xlx3QHzbIoDzPPRg+bzZAwHhv1fbzyRkLxIG0q36weNz//DLUYxrAE9wRPgFIj4AyEE8YmE+Frl1EIHyUbX9uAm9J9o/+WMS0bOgg0UDwBj8TaHkXKf8HdqB/Cd95/gdyjUTl6oMlmPdgdrpsg3DBLQ//5+v/LGCQEeDiXbkG2+PGUTAiCgsYwrCbGtIEAa/BVNKvHyF29S6ibaup81YnuKWllIDRbmlB+E6dZkTod9HNL0aKmtF8P4xEzhuFNiqIDcFMC3OleCBBdFAC+gZqNe736QfNjpERcyY/WUpNwPRCcZX5XqH/CV5pegwN3vGbOnmV5HEyHfaLiFJJ5FsYk0F5E7gBhF7fj7jUkXp2LYMmYE++9/4RLv4z0++fTGsosc5ixn/bx1FlN+VGkT/PW4G5VVEDO916
 lqenfzii
 1a8eLkNxyUX5FjT6bVfLBu+h1fAY0OJyDiZbcNjs6oxN4H4Ag8CAQ/C4f5KiHlVqSITXzAjvBhyKGs1BDUvOi5UeyXQFE+ACoS1kJXUK+LllbQ40RnOYOW1+sWsW2qTqaADu7h38OXl8fjY2s3Sfy2xM/UQfn/EOy/xz/woXy92LWaf60FamabMOHtAIRD2S6CLL8L8jPXWNSpsheq03kPBDdJfRUwJZ48YSwQ2eoPVQsYylyX+woXr8bsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, only prefilled sheaves have a capacity field, used to
record the requested (possibly oversized) capacity. To allow
changing sheaf capacity at runtime, track the capacity for each
sheaf so that checking if a sheaf is full would work even when
changing cache capacity concurrently.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a1974523bba9..44f36ae32570 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -417,11 +417,9 @@ struct slab_sheaf {
 		struct rcu_head rcu_head;
 		struct list_head barn_list;
 		/* only used for prefilled sheafs */
-		struct {
-			unsigned short capacity;
-			bool pfmemalloc;
-		};
+		bool pfmemalloc;
 	};
+	unsigned short capacity;
 	unsigned short size;
 	int node; /* only used for rcu_sheaf */
 	void *objects[];
@@ -2780,6 +2778,8 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (unlikely(!sheaf))
 		return NULL;
 
+	sheaf->capacity = capacity;
+
 	stat(s, SHEAF_ALLOC);
 
 	return sheaf;
@@ -2816,7 +2816,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 			 gfp_t gfp)
 {
-	int to_fill = s->sheaf_capacity - sheaf->size;
+	int to_fill = sheaf->capacity - sheaf->size;
 	int filled;
 
 	if (!to_fill)
@@ -5063,7 +5063,6 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 		sheaf = alloc_empty_sheaf(s, gfp);
 
 	if (sheaf) {
-		sheaf->capacity = s->sheaf_capacity;
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
@@ -5688,13 +5687,13 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
 	 * Unlikely because if the main sheaf had space, we would have just
 	 * freed to it. Get rid of our empty sheaf.
 	 */
-	if (pcs->main->size < s->sheaf_capacity) {
+	if (pcs->main->size < pcs->main->capacity) {
 		barn_put_empty_sheaf(barn, empty);
 		return;
 	}
 
 	/* Also unlikely for the same reason */
-	if (pcs->spare->size < s->sheaf_capacity) {
+	if (pcs->spare->size < pcs->spare->capacity) {
 		swap(pcs->main, pcs->spare);
 		barn_put_empty_sheaf(barn, empty);
 		return;
@@ -5752,7 +5751,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		goto alloc_empty;
 	}
 
-	if (pcs->spare->size < s->sheaf_capacity) {
+	if (pcs->spare->size < pcs->spare->capacity) {
 		swap(pcs->main, pcs->spare);
 		return pcs;
 	}
@@ -5819,7 +5818,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	 * but in case we got preempted or migrated, we need to
 	 * check again
 	 */
-	if (pcs->main->size == s->sheaf_capacity)
+	if (pcs->main->size == pcs->main->capacity)
 		goto restart;
 
 	return pcs;
@@ -5850,7 +5849,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
-	if (unlikely(pcs->main->size == s->sheaf_capacity)) {
+	if (unlikely(pcs->main->size == pcs->main->capacity)) {
 
 		pcs = __pcs_replace_full_main(s, pcs, allow_spin);
 		if (unlikely(!pcs))
@@ -6015,7 +6014,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 	 */
 	rcu_sheaf->objects[rcu_sheaf->size++] = obj;
 
-	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
+	if (likely(rcu_sheaf->size < rcu_sheaf->capacity)) {
 		rcu_sheaf = NULL;
 	} else {
 		pcs->rcu_free = NULL;
@@ -6139,7 +6138,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
-	if (likely(pcs->main->size < s->sheaf_capacity))
+	if (likely(pcs->main->size < pcs->main->capacity))
 		goto do_free;
 
 	barn = get_barn(s);
@@ -6156,7 +6155,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		goto do_free;
 	}
 
-	if (pcs->spare->size < s->sheaf_capacity) {
+	if (pcs->spare->size < pcs->spare->capacity) {
 		swap(pcs->main, pcs->spare);
 		goto do_free;
 	}
@@ -6172,7 +6171,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 do_free:
 	main = pcs->main;
-	batch = min_t(size_t, size, s->sheaf_capacity - main->size);
+	batch = min_t(size_t, size, main->capacity - main->size);
 
 	memcpy(main->objects + main->size, p, batch * sizeof(void *));
 	main->size += batch;
@@ -7613,7 +7612,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 		/*
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.
-		 * It has also size == s->sheaf_capacity, so fast-path free
+		 * It has also size == sheaf->capacity, so fast-path free
 		 * fails. In the slow paths we recognize the situation by
 		 * checking s->sheaf_capacity. This allows fast paths to assume
 		 * s->cpu_sheaves and pcs->main always exists and are valid.

-- 
2.43.0


