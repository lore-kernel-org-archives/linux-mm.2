Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA867CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D8D66B009B; Fri, 15 May 2026 12:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2416B009D; Fri, 15 May 2026 12:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 277546B009E; Fri, 15 May 2026 12:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1631C6B009B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6E541A01B7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:57 +0000 (UTC)
X-FDA: 84770178234.27.01CA4EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 49712180012
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kJVtU4pi;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nZOddWDtg1Z1eG9xtJBB0O7j7SEr95s4z6+Wlsvy4LU=;
	b=ioG4cLPAe7MXkXr4FY9felJDChsn+cQX8DzPhAjQ6LTpppE2376ZwnA0WSSBh1uSB9Wbmb
	dJwV7jjAWckimpiuSAqJxZsilqjxXBJd51XiVd0C88lS9D3I9a4R4oGNTW+A9x+i9m2XfU
	2mff9lIGC5T9dV3AI5YaEj2A02Y380c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862296; a=rsa-sha256;
	cv=none;
	b=sodkXb7anX1RHhd91z9Cqf94TDAmseRdZzuGl/VJ9bXJ/8ulLjbQOeoLnow7BWrU6kWs1F
	p8DtWncnEVRFYBHDItURC2L2LhhexHXx0o3TiZ63ET/8JpCSdYX/X+TaXS80Q9xm6Ks0gp
	y8M5nz+uthhAKlK4Pu4uU28eh2An1FQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kJVtU4pi;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2C13601D6;
	Fri, 15 May 2026 16:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35013C2BCB0;
	Fri, 15 May 2026 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862295;
	bh=1Hbg57nzucmqI4BlrwpvXWXGzZTX2ByPVlWDsSZQJgo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kJVtU4piTNUdTCPHNEdhZhgAc+WwvlrtKm0hJLlZd8o+wftki5fasFOB/gjcHRavu
	 S1aduNjRMDWIlIr5GRD22SuQfPmQrRAhJW9NI88x4VMVC1mvxmFrnusPJlPB95maoQ
	 xOlwoc3R1Ys/4WeV1/A3UBzVJb2KqVkMjC1EQVPiQnhAdeyFfCi3VbZn7DGhM/myjo
	 OdoSzesDFPGjjPZjqFBLsetPJ+h1nBA6BhL6kF87sYWAxRtau/rKgUCMBzS4YWJ9yK
	 LUjFx8nXyLhLMb1dvDUzx3mM1+HD/EQ+Ync884RFSkjHj8DF481M3kP6ZuqUYrQht/
	 4Bd+FvsGYBTIQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:30 +0900
Subject: [PATCH RFC 6/8] mm/slab: allow changing sheaf_capacity at runtime
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-6-221aa3e1d829@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 49712180012
X-Stat-Signature: pnsm9wfyhu5f6apcrxszp5y5iz58gz8j
X-Rspam-User: 
X-HE-Tag: 1778862296-970972
X-HE-Meta: U2FsdGVkX1/EeFD4ejpqiEjV/QiorQCAoWPJh38jVHp2BajnDH6XK7kL/eMJOdf1TFstvY68n7inVHYQMlGKs1Vu5c2L5HlE8d1R7BsCLi7pJVE2Q/rOW5B+1BWupQiRkNOPSaV7RFQnf7sEFmiqeL0u/pTMQ1jLNV/8cP/Ur6F0U75K4WtBN/wmFbRXhBX+3QFETQMSdxuZZq7PQU+f8YDU64IBC0dtoM4bKxyOjgWtEpMqWedaYBQCVQcSFJ2mTDmJIqDn/pUzRqa6ytSbuHePSi1US2X9PtFYkHbL5qqGnvy5HXrkDoEeIpiwaa4bWyGTsbjeM9/fv2XqM6qsihNE+7XM84ptvCI5Sz5fFaSxe+fZyV4gdY9WV/G1hiy+0K7qLcyK45ZasEVh7NPXOHfUzI3i6vTQdUJqsssVdmRpOCSH+Wxq09sTRhlThID9A8Jl+4HqoY7/V8/EDXWe3mmoWNr2os9Dic09vjxY3A9PkgsZCnhtwWXEnBetQiq0YHRXsLz4hSPXkxgaFhTzsZEL5SKOqbPs9JBSuVReESx2wrewxyD8k23wYqJumatr+Fa8/JU01pWKzoz5Ii4OhyDcDuGP23Oyp/aKxM26Q4MpCk805lk/9MSWW942fGuCqmUpo6ECnhFfrQtF2wRDQPtuZhAJedYK3jkO/KZttdufL6le9WE1kZV6WZysu4Uy2o0kq/CpOYYH47F0pzwGxHTe653lxJ2v+4SIhWRRUlLxUsYMVZNAIruVht3ZBpcZxNcYBfuRIB6C5OZrO/Dbej91sJKr9JJizhIyMhdpKDocys+mnC1k5by8IChttGXpv2AkFphLZkTPGN0pB5AkwwjxPD3F85kzbImyyaSkalWzARldRAuIlt2DKImnLld9jvRrDKu1RQlHAR++7/CTlklcyT41tCwxNkTMb7y8fDIZJGbDzv/ezEru+FoyJll0Gm8PumtBp7K5rGjHQVX
 Sr3KFY+z
 lioHRyFXxFKVPr7jfFpoPr2fPv2lFyjRqEUgOSCdzR0b/0bfD4sMLVYapXJCwc7Yo57dWmWrhHORHQLBSBgG2S+vV+tL+mQNayXVv0Q0IRL+QRFdiLdd83vxQLXweYas3ivGrVXBuLxfz9wmE7Md5Mm6wO6C+/eIuCC3pBqWlB+nD5xfmN+AfrbrYpsi1/BuLWipzDKm1g3XgoUOSKIeYSHiV/cpp2FLtprV2B42MiO1n3WbY3USMUWVtTzofbLgjQuRed+tAX9Xfcncvuw7QmYRB9wxJ5BreUwS7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make the sheaf_capacity sysfs attribute writable so that the sheaf
capacity can be tuned at runtime per-cache.

The steps to change sheaf capacity:

  1. Disable sheaves: make all online CPUs replace their main sheaves
     with the bootstrap sheaf under local_lock and wait for completion.
     For offline CPUs, update their pcs directly under cpu_hotplug_lock.

  2. Wait for pre-existing RCU callbacks to complete so that RCU sheaves
     are returned to the barn.

  3. Shrink the cache to flush and free all existing sheaves.

  4. Re-enable sheaves with the new capacity by calling
     bootstrap_cache_sheaves(). If this fails, sheaves remain disabled
     for the cache.

Use slab_mutex to serialize sheaf capacity updates.

If sheaves of different capacities can coexist after several updates
to the sheaf_capacity, performance becomes hard to predict. It is
important to allow only a single capacity at any given point in time.

To achieve that, it is required to check whether the sheaf capacity is
stale. However, performing this check without an expensive
synchronization mechanism (SRCU, atomics, etc.) is inevitably racy.

Instead, a copy of sheaf capacity is stored in struct
slub_percpu_sheaves and each CPU has its own copy of the capacity.
With that, we can guarantee that this value remains stable under
local_lock.

If local_lock is acquired while the sheaf capacity update is in
progress, then either:

  1. Sheaves on the CPU have already been disabled (meaning pcs->main
     points at bootstrap_sheaf, falling back to slowpath), or

  2. After releasing local_lock, percpu sheaves will be flushed and
     disabled for the CPU, and all sheaves in the barn will be
     flushed and freed.

It is guaranteed that no sheaf with stale capacity remains
after the process is complete as long as certain rules are followed.

The new rules to avoid sheaves of a stale capacity:

  1. Hold local_lock when getting/putting sheaves from/to the barn.

  2. When allocating new sheaves, check whether pcs->capacity and
     sheaf->capacity match after re-acquiring local_lock.

  3. If local_trylock fails, flush and free the sheaf. This should be
     rare.

Per the above rules, rcu_free_sheaf() now tries to acquire the pcs lock
and check whether the capacities match before putting the sheaf back
to the barn.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 386 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 308 insertions(+), 78 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index c746c9b48728..7def24fdfae6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -425,6 +425,7 @@ struct slub_percpu_sheaves {
 	struct slab_sheaf *main; /* never NULL when unlocked */
 	struct slab_sheaf *spare; /* empty or full, may be NULL */
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
+	unsigned short capacity;
 };
 
 static struct slab_sheaf bootstrap_sheaf = {};
@@ -492,6 +493,30 @@ static inline struct node_barn *get_barn(struct kmem_cache *s)
  */
 static nodemask_t slab_nodes;
 
+
+static inline
+unsigned short get_pcs_capacity(struct kmem_cache *s,
+				struct slub_percpu_sheaves *pcs)
+{
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	return pcs->capacity;
+}
+
+static inline void set_pcs_capacity(struct kmem_cache *s,
+				    struct slub_percpu_sheaves *pcs,
+				    unsigned short capacity)
+{
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
+	pcs->capacity = capacity;
+}
+
+static inline bool pcs_capacity_match(struct kmem_cache *s,
+				      struct slub_percpu_sheaves *pcs,
+				      struct slab_sheaf *sheaf)
+{
+	return get_pcs_capacity(s, pcs) == sheaf->capacity;
+}
+
 /*
  * Similar to slab_nodes but for where we have node_barn allocated.
  * Corresponds to N_ONLINE nodes.
@@ -507,6 +532,11 @@ struct slub_flush_work {
 	struct work_struct work;
 	struct kmem_cache *s;
 	bool skip;
+	/* for flushing sheaves */
+	bool disable_sheaves;
+	/* for enabling sheaves */
+	void **sheaves;
+	unsigned short capacity;
 };
 
 static DEFINE_MUTEX(flush_lock);
@@ -2774,6 +2804,10 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 	if (gfp & __GFP_NO_OBJ_EXT)
 		return NULL;
 
+	/* Sheaves have been disabled */
+	if (!capacity)
+		return NULL;
+
 	gfp &= ~OBJCGS_CLEAR_MASK;
 
 	/*
@@ -2800,7 +2834,7 @@ static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
 static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
 						   gfp_t gfp)
 {
-	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
+	return __alloc_empty_sheaf(s, gfp, data_race(s->sheaf_capacity));
 }
 
 static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
@@ -2999,10 +3033,10 @@ static void rcu_free_sheaf_nobarn(struct rcu_head *head)
  * flushing operations are rare so let's keep it simple and flush to slabs
  * directly, skipping the barn
  */
-static void pcs_flush_all(struct kmem_cache *s)
+static void pcs_flush_all(struct kmem_cache *s, bool disable_sheaves)
 {
 	struct slub_percpu_sheaves *pcs;
-	struct slab_sheaf *spare, *rcu_free;
+	struct slab_sheaf *spare, *rcu_free, *main;
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -3013,8 +3047,23 @@ static void pcs_flush_all(struct kmem_cache *s)
 	rcu_free = pcs->rcu_free;
 	pcs->rcu_free = NULL;
 
+	if (disable_sheaves && pcs_has_sheaves(pcs)) {
+		main = pcs->main;
+		pcs->main = &bootstrap_sheaf;
+		set_pcs_capacity(s, pcs, 0);
+	} else {
+		main = NULL;
+	}
+
 	local_unlock(&s->cpu_sheaves->lock);
 
+	if (main) {
+		sheaf_flush_unused(s, main);
+		free_empty_sheaf(s, main);
+	} else {
+		sheaf_flush_main(s);
+	}
+
 	if (spare) {
 		sheaf_flush_unused(s, spare);
 		free_empty_sheaf(s, spare);
@@ -3022,8 +3071,6 @@ static void pcs_flush_all(struct kmem_cache *s)
 
 	if (rcu_free)
 		call_rcu(&rcu_free->rcu_head, rcu_free_sheaf_nobarn);
-
-	sheaf_flush_main(s);
 }
 
 static void __pcs_flush_all_cpu(struct kmem_cache *s, unsigned int cpu)
@@ -3986,10 +4033,34 @@ static void flush_cpu_sheaves(struct work_struct *w)
 	s = sfw->s;
 
 	if (cache_supports_sheaves(s))
-		pcs_flush_all(s);
+		pcs_flush_all(s, sfw->disable_sheaves);
+}
+
+static void enable_cpu_sheaves(struct work_struct *w)
+{
+	struct kmem_cache *s;
+	struct slub_flush_work *sfw;
+	struct slab_sheaf *sheaf;
+	struct slub_percpu_sheaves *pcs;
+
+	sfw = container_of(w, struct slub_flush_work, work);
+
+	s = sfw->s;
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+	sheaf = sfw->sheaves[smp_processor_id()];
+
+	VM_WARN_ON_ONCE(pcs->rcu_free);
+	VM_WARN_ON_ONCE(pcs->spare);
+	VM_WARN_ON_ONCE(pcs->main != &bootstrap_sheaf);
+
+	pcs->main = sheaf;
+	set_pcs_capacity(s, pcs, sfw->capacity);
+	local_unlock(&s->cpu_sheaves->lock);
 }
 
-static void flush_all_cpus_locked(struct kmem_cache *s)
+static void flush_all_cpus_locked(struct kmem_cache *s, bool disable_sheaves)
 {
 	struct slub_flush_work *sfw;
 	unsigned int cpu;
@@ -3997,16 +4068,32 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
 	lockdep_assert_cpus_held();
 	mutex_lock(&flush_lock);
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		sfw = &per_cpu(slub_flush, cpu);
-		if (!has_pcs_used(cpu, s)) {
+
+		if (cpu_online(cpu)) {
+			/* Do not skip empty sheaves when disabling them */
+			if (!disable_sheaves && !has_pcs_used(cpu, s)) {
+				sfw->skip = true;
+				continue;
+			}
+			INIT_WORK(&sfw->work, flush_cpu_sheaves);
+			sfw->skip = false;
+			sfw->s = s;
+			sfw->disable_sheaves = disable_sheaves;
+			queue_work_on(cpu, flushwq, &sfw->work);
+		} else if (disable_sheaves) {
+			struct slub_percpu_sheaves *pcs;
+
 			sfw->skip = true;
-			continue;
+			pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
+			if (pcs->main != &bootstrap_sheaf) {
+				sheaf_flush_unused(s, pcs->main);
+				free_empty_sheaf(s, pcs->main);
+				pcs->main = &bootstrap_sheaf;
+				pcs->capacity = 0;
+			}
 		}
-		INIT_WORK(&sfw->work, flush_cpu_sheaves);
-		sfw->skip = false;
-		sfw->s = s;
-		queue_work_on(cpu, flushwq, &sfw->work);
 	}
 
 	for_each_online_cpu(cpu) {
@@ -4019,10 +4106,10 @@ static void flush_all_cpus_locked(struct kmem_cache *s)
 	mutex_unlock(&flush_lock);
 }
 
-static void flush_all(struct kmem_cache *s)
+static void flush_all(struct kmem_cache *s, bool disable_sheaves)
 {
 	cpus_read_lock();
-	flush_all_cpus_locked(s);
+	flush_all_cpus_locked(s, disable_sheaves);
 	cpus_read_unlock();
 }
 
@@ -4690,10 +4777,21 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	full = empty;
 	empty = NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
-		goto barn_put;
+	if (!local_trylock(&s->cpu_sheaves->lock)) {
+		sheaf_flush_unused(s, full);
+		free_empty_sheaf(s, full);
+		return NULL;
+	}
+
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
+	if (unlikely(!pcs_capacity_match(s, pcs, full))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		sheaf_flush_unused(s, full);
+		free_empty_sheaf(s, full);
+		return NULL;
+	}
+
 	/*
 	 * If we put any empty or full sheaf to the barn below, it's due to
 	 * racing or being migrated to a different cpu. Breaching the barn's
@@ -4721,7 +4819,6 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 		return pcs;
 	}
 
-barn_put:
 	barn_put_full_sheaf(barn, full);
 	stat(s, BARN_PUT);
 
@@ -5027,29 +5124,8 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 	if (unlikely(!size))
 		return NULL;
 
-	if (unlikely(size > s->sheaf_capacity)) {
-
-		sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
-		if (!sheaf)
-			return NULL;
-
-		stat(s, SHEAF_PREFILL_OVERSIZE);
-		sheaf->capacity = size;
-
-		/*
-		 * we do not need to care about pfmemalloc here because oversize
-		 * sheaves area always flushed and freed when returned
-		 */
-		if (!__kmem_cache_alloc_bulk(s, gfp, size,
-					     &sheaf->objects[0])) {
-			kfree(sheaf);
-			return NULL;
-		}
-
-		sheaf->size = size;
-
-		return sheaf;
-	}
+	if (unlikely(size > data_race(s->sheaf_capacity)))
+		goto oversized;
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5072,11 +5148,16 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 
 	local_unlock(&s->cpu_sheaves->lock);
 
-
 	if (!sheaf)
 		sheaf = alloc_empty_sheaf(s, gfp);
 
 	if (sheaf) {
+		if (size > sheaf->capacity) {
+			sheaf_flush_unused(s, sheaf);
+			free_empty_sheaf(s, sheaf);
+			sheaf = NULL;
+			goto oversized;
+		}
 		sheaf->pfmemalloc = false;
 
 		if (sheaf->size < size &&
@@ -5087,6 +5168,28 @@ kmem_cache_prefill_sheaf(struct kmem_cache *s, gfp_t gfp, unsigned short size)
 		}
 	}
 
+	return sheaf;
+
+oversized:
+	sheaf = kzalloc_flex(*sheaf, objects, size, gfp);
+	if (!sheaf)
+		return NULL;
+
+	stat(s, SHEAF_PREFILL_OVERSIZE);
+	sheaf->capacity = size;
+
+	/*
+	 * we do not need to care about pfmemalloc here because oversize
+	 * sheaves area always flushed and freed when returned
+	 */
+	if (!__kmem_cache_alloc_bulk(s, gfp, size,
+				     &sheaf->objects[0])) {
+		kfree(sheaf);
+		return NULL;
+	}
+
+	sheaf->size = size;
+
 	return sheaf;
 }
 
@@ -5106,27 +5209,25 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	struct slub_percpu_sheaves *pcs;
 	struct node_barn *barn;
 
-	if (unlikely((sheaf->capacity != s->sheaf_capacity)
-		     || sheaf->pfmemalloc)) {
-		sheaf_flush_unused(s, sheaf);
-		kfree(sheaf);
-		return;
-	}
+	if (unlikely((sheaf->capacity != data_race(s->sheaf_capacity))
+		     || sheaf->pfmemalloc))
+		goto free_sheaf;
 
 	local_lock(&s->cpu_sheaves->lock);
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	barn = get_barn(s);
 
+	if (!pcs_capacity_match(s, pcs, sheaf)) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto free_sheaf;
+	}
+
 	if (!pcs->spare) {
 		pcs->spare = sheaf;
-		sheaf = NULL;
 		stat(s, SHEAF_RETURN_FAST);
-	}
-
-	local_unlock(&s->cpu_sheaves->lock);
-
-	if (!sheaf)
+		local_unlock(&s->cpu_sheaves->lock);
 		return;
+	}
 
 	stat(s, SHEAF_RETURN_SLOW);
 
@@ -5134,15 +5235,32 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 	 * If the barn has too many full sheaves or we fail to refill the sheaf,
 	 * simply flush and free it.
 	 */
-	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES ||
-	    refill_sheaf(s, sheaf, gfp)) {
-		sheaf_flush_unused(s, sheaf);
-		free_empty_sheaf(s, sheaf);
-		return;
+	if (!barn || data_race(barn->nr_full) >= MAX_FULL_SHEAVES) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto free_sheaf;
+	}
+
+	local_unlock(&s->cpu_sheaves->lock);
+
+	if (refill_sheaf(s, sheaf, gfp))
+		goto free_sheaf;
+
+	local_lock(&s->cpu_sheaves->lock);
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (!pcs_capacity_match(s, pcs, sheaf)) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto free_sheaf;
 	}
 
 	barn_put_full_sheaf(barn, sheaf);
+	local_unlock(&s->cpu_sheaves->lock);
 	stat(s, BARN_PUT);
+	return;
+
+free_sheaf:
+	sheaf_flush_unused(s, sheaf);
+	free_empty_sheaf(s, sheaf);
 }
 
 /*
@@ -5839,11 +5957,18 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 got_empty:
 	if (!local_trylock(&s->cpu_sheaves->lock)) {
-		barn_put_empty_sheaf(barn, empty);
+		free_empty_sheaf(s, empty);
 		return NULL;
 	}
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
+
+	if (unlikely(!pcs_capacity_match(s, pcs, empty))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		free_empty_sheaf(s, empty);
+		return NULL;
+	}
+
 	__pcs_install_empty_sheaf(s, pcs, empty, barn);
 
 	return pcs;
@@ -5884,6 +6009,7 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	struct slab_sheaf *sheaf;
 	struct node_barn *barn = NULL;
 	struct kmem_cache *s;
+	struct slub_percpu_sheaves *pcs;
 
 	sheaf = container_of(head, struct slab_sheaf, rcu_head);
 	if (WARN_ON_ONCE(!sheaf->size)) {
@@ -5905,11 +6031,20 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	 * slab so simply flush everything.
 	 */
 	if (__rcu_free_sheaf_prepare(s, sheaf))
-		goto flush;
+		goto flush_unlocked;
 
 	barn = get_barn_node(s, sheaf->node);
 	if (!barn)
-		goto flush;
+		goto flush_unlocked;
+
+	if (!local_trylock(&s->cpu_sheaves->lock))
+		goto flush_unlocked;
+
+	pcs = this_cpu_ptr(s->cpu_sheaves);
+	if (!pcs_capacity_match(s, pcs, sheaf)) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto flush_unlocked;
+	}
 
 	/* due to slab_free_hook() */
 	if (unlikely(sheaf->size == 0))
@@ -5924,19 +6059,27 @@ static void rcu_free_sheaf(struct rcu_head *head)
 	if (data_race(barn->nr_full) < MAX_FULL_SHEAVES) {
 		stat(s, BARN_PUT);
 		barn_put_full_sheaf(barn, sheaf);
+		local_unlock(&s->cpu_sheaves->lock);
 		return;
 	}
 
-flush:
 	stat(s, BARN_PUT_FAIL);
 	sheaf_flush_unused(s, sheaf);
 
 empty:
 	if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES) {
 		barn_put_empty_sheaf(barn, sheaf);
+		local_unlock(&s->cpu_sheaves->lock);
 		return;
 	}
 
+	local_unlock(&s->cpu_sheaves->lock);
+	free_empty_sheaf(s, sheaf);
+	return;
+
+flush_unlocked:
+	stat(s, BARN_PUT_FAIL);
+	sheaf_flush_unused(s, sheaf);
 	free_empty_sheaf(s, sheaf);
 }
 
@@ -6006,12 +6149,18 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 			goto fail;
 
 		if (!local_trylock(&s->cpu_sheaves->lock)) {
-			barn_put_empty_sheaf(barn, empty);
+			free_empty_sheaf(s, empty);
 			goto fail;
 		}
 
 		pcs = this_cpu_ptr(s->cpu_sheaves);
 
+		if (unlikely(!pcs_capacity_match(s, pcs, empty))) {
+			local_unlock(&s->cpu_sheaves->lock);
+			free_empty_sheaf(s, empty);
+			goto fail;
+		}
+
 		if (unlikely(pcs->rcu_free))
 			barn_put_empty_sheaf(barn, empty);
 		else
@@ -7650,6 +7799,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		if (!pcs->main)
 			return -ENOMEM;
 
+		pcs->capacity = s->sheaf_capacity;
 	}
 
 	return 0;
@@ -8050,7 +8200,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	int node;
 	struct kmem_cache_node *n;
 
-	flush_all_cpus_locked(s);
+	flush_all_cpus_locked(s, /* disable_sheaves = */false);
 
 	/* we might have rcu sheaves in flight */
 	if (cache_supports_sheaves(s))
@@ -8334,7 +8484,7 @@ static int __kmem_cache_do_shrink(struct kmem_cache *s)
 
 int __kmem_cache_shrink(struct kmem_cache *s)
 {
-	flush_all(s);
+	flush_all(s, /* disable_sheaves = */false);
 	return __kmem_cache_do_shrink(s);
 }
 
@@ -8344,7 +8494,7 @@ static int slab_mem_going_offline_callback(void)
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
-		flush_all_cpus_locked(s);
+		flush_all_cpus_locked(s, /* disable_sheaves = */false);
 		__kmem_cache_do_shrink(s);
 	}
 	mutex_unlock(&slab_mutex);
@@ -8479,7 +8629,11 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
 				   unsigned short capacity)
 {
 	struct kmem_cache_args empty_args = {};
+	struct slub_flush_work *sfw;
 	int node, cpu, err = 0;
+	void **sheaves = NULL;
+
+	lockdep_assert_cpus_held();
 
 	if (!capacity)
 		capacity = calculate_sheaf_capacity(s, &empty_args);
@@ -8491,6 +8645,9 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
 	for_each_node_mask(node, slab_barn_nodes) {
 		struct node_barn *barn;
 
+		if (s->per_node[node].barn)
+			continue;
+
 		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
 
 		if (!barn) {
@@ -8502,23 +8659,62 @@ static int bootstrap_cache_sheaves(struct kmem_cache *s,
 		s->per_node[node].barn = barn;
 	}
 
+	sheaves = kmalloc_array(nr_cpu_ids, sizeof(*sheaves),
+				GFP_KERNEL | __GFP_ZERO);
+	if (!sheaves) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	/* Do not queue the work if any of the allocations fails */
+	for_each_possible_cpu(cpu) {
+		sheaves[cpu] = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
+
+		if (!sheaves[cpu]) {
+			err = -ENOMEM;
+			goto out_free_sheaves;
+		}
+	}
+
+	mutex_lock(&flush_lock);
 	for_each_possible_cpu(cpu) {
 		struct slub_percpu_sheaves *pcs;
 
 		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
+		sfw = &per_cpu(slub_flush, cpu);
 
-		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
-
-		if (!pcs->main) {
-			err = -ENOMEM;
-			break;
+		if (!cpu_online(cpu) || slab_state == UP) {
+			pcs->main = sheaves[cpu];
+			pcs->capacity = capacity;
+			sfw->skip = true;
+		} else {
+			INIT_WORK(&sfw->work, enable_cpu_sheaves);
+			sfw->s = s;
+			sfw->sheaves = sheaves;
+			sfw->capacity = capacity;
+			sfw->skip = false;
+			queue_work_on(cpu, flushwq, &sfw->work);
 		}
 	}
 
-out:
-	if (!err)
-		s->sheaf_capacity = capacity;
+	for_each_online_cpu(cpu) {
+		sfw = &per_cpu(slub_flush, cpu);
+		if (sfw->skip)
+			continue;
+		flush_work(&sfw->work);
+	}
+	mutex_unlock(&flush_lock);
 
+	kfree(sheaves);
+	s->sheaf_capacity = capacity;
+	return 0;
+
+out_free_sheaves:
+	for_each_possible_cpu(cpu)
+		if (sheaves[cpu])
+			free_empty_sheaf(s, sheaves[cpu]);
+	kfree(sheaves);
+out:
 	return err;
 }
 
@@ -8533,6 +8729,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
 	struct kmem_cache *s;
 	int idx;
 
+	cpus_read_lock();
 	for_each_normal_kmalloc_cache(s, type, idx) {
 		/*
 		 * It's still early in boot so treat this as a failure to
@@ -8542,6 +8739,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
 			panic("Out of memory when creating kmem_cache %s\n",
 			      s->name);
 	}
+	cpus_read_unlock();
 }
 
 void __init kmem_cache_init(void)
@@ -8799,7 +8997,7 @@ long validate_slab_cache(struct kmem_cache *s)
 	if (!obj_map)
 		return -ENOMEM;
 
-	flush_all(s);
+	flush_all(s, /* disable_sheaves = */false);
 	for_each_kmem_cache_node(s, node, n)
 		count += validate_slab_node(s, n, obj_map);
 
@@ -9111,7 +9309,39 @@ static ssize_t sheaf_capacity_show(struct kmem_cache *s, char *buf)
 {
 	return sysfs_emit(buf, "%hu\n", s->sheaf_capacity);
 }
-SLAB_ATTR_RO(sheaf_capacity);
+static ssize_t sheaf_capacity_store(struct kmem_cache *s,
+				    const char *buf, size_t length)
+{
+	unsigned short capacity;
+	int err;
+
+	err = kstrtou16(buf, 10, &capacity);
+	if (err)
+		return err;
+
+	if (!cache_supports_sheaves(s))
+		return -EOPNOTSUPP;
+
+	cpus_read_lock();
+	mutex_lock(&slab_mutex);
+	flush_all_cpus_locked(s, /* disable_sheaves = */true);
+	rcu_barrier();
+	__kmem_cache_do_shrink(s);
+	s->sheaf_capacity = 0;
+	if (capacity) {
+		err = bootstrap_cache_sheaves(s, capacity);
+		if (err) {
+			mutex_unlock(&slab_mutex);
+			cpus_read_unlock();
+			return err;
+		}
+	}
+	mutex_unlock(&slab_mutex);
+	cpus_read_unlock();
+
+	return length;
+}
+SLAB_ATTR(sheaf_capacity);
 
 static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
 {

-- 
2.43.0


