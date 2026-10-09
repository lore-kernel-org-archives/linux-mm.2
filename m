Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E35CA9EBB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 21:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC996B008A; Fri,  9 Oct 2026 17:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3FA6B008C; Fri,  9 Oct 2026 17:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93466B0092; Fri,  9 Oct 2026 17:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB0356B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:46:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27F5FA8041
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:48 +0000 (UTC)
X-FDA: 85304422896.28.33CC0C2
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6303F140002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 21:46:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IMEfSqIg;
	spf=pass (imf23.hostedemail.com: domain of 3xGDJagYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3xGDJagYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791582406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7SX932DFxQl+q9e3enjijEP57mjh6GyMpzU86JEIxk=;
	b=aW0PMtLgpBRdNcAhtK215eHDAMgDk+rBS8dXI55ZlTDsfJrX3Lq0GeEdnbWIKqPbfrzwuV
	eqPlthhA5FhPE9EqhHghsSvNvMq0HzaBJeTVfzI2CpvC9tr0FDc2DkNIwP8WoiAbQkIPr6
	BiWT5WlotTxW2BFUH3JRkzjWsjenVvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791582406;
	b=HaAd3VO/Nca6ieV+9bsKVyJkv9A9Bbv48QFjX3M8lrFRtWutXOzgIhhU0h5VgW8ZY1nFdg
	+WVKReXA6LitWAGpsMDIoPtmpA5gpczBBcGX4bmtWuFIHmFCf1NtPEz6fiCf4H4FT/ehoE
	CUEk8NCf7pOrxy6d1YtWPnJI6P/XL+Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IMEfSqIg;
	spf=pass (imf23.hostedemail.com: domain of 3xGDJagYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3xGDJagYKCAkt3wr73pxxpun.lxvurw36-vvt4jlt.x0p@flex--kuniyu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e5cb9d39c0so1174955ad.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 14:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791582405; x=1792187205; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U7SX932DFxQl+q9e3enjijEP57mjh6GyMpzU86JEIxk=;
        b=IMEfSqIg2MJMthDlqYv7pwW6BkKYqceXfkt3T/c8qITY3/0dYFA4RG3cNtNEDBGJna
         mqF2sCftgD1b5aosp4GbzW5zdQKFeP/0AOy398+hefYVjsSx04geBF0A0diadcQReuQU
         vjPAg1R9XwhE2Jfv672HpLyEDyUMhsKG12/kjNm700pMzyFxqy28f7Rcc8BMrvrZIVD0
         d49VJatDmLST0oQtW3CgqV+xaa06DOb6soS/zI/Qo7Vs7fduii3fEVvXTtDf9xxj05z8
         vHL6yMFj0ouJD/tX/aM9Vq4WhlO79cJgiJB1pSik4yuqRDUNvIn3X/46bwF8kwu0+eSk
         L97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791582405; x=1792187205;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U7SX932DFxQl+q9e3enjijEP57mjh6GyMpzU86JEIxk=;
        b=wSyuFx9Fg3aKsctplS9nXmyDbQucf4vj2dGmNXEKHIFU7W+x7tWXUjlkKmL7tIGnrF
         vdt2KaRypdYRIIHZbBMugRRJnXkgZuIYol3QjNqbyCSRIFS2mN3XzdqyE6dMz9TofVFd
         B6LGqClSC1k3OKaoYIX1pxLnLXAgf6bhvP06DgjdmLOerLlsKWj6Q+gSXywcP/5i7t5Z
         TmJW0DwmfH4kLNk1kLvNCLxhsfrIz+qZUiKzX84taWvX416m7zUOV3HFBv0Esd/s5QcT
         16Nd1i+6preKYq/gQWEEZvDjc2KXggFAv+V8Dx4pSSrkd7TWGj5yoAlBY8fidnLjoMTp
         IWjA==
X-Forwarded-Encrypted: i=1; AKwUvBx+6xR9RLzCww+KqWGOvIFwWc6Acj5SqXNYsD82GiWMqdSLgWb+Rrq4i4FTERhzQA1+gJ8uofbziw==@kvack.org
X-Gm-Message-State: AFq9FYL1xwOFPEyUg3i4kXeCGx7WaLaWrvno8mwEXaHCBnGwSpG9nm+0
	xypRmQnjz+ZnyGcCppLUCYI43JsHjbqHMA0YElTdGexFS2IstE3e9HfnL+sDQlZhdoecNPWYBAP
	FyzVEKQ==
X-Received: from plhl12.prod.google.com ([2002:a17:903:120c:b0:2df:b611:4b15])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ebc9:b0:2dd:b52d:e83e
 with SMTP id d9443c01a7336-2e842aadf63mr27729175ad.19.1791582404959; Fri, 09
 Oct 2026 14:46:44 -0700 (PDT)
Date: Fri,  9 Oct 2026 21:46:25 +0000
In-Reply-To: <20261009214639.2878857-1-kuniyu@google.com>
Mime-Version: 1.0
References: <20261009214639.2878857-1-kuniyu@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261009214639.2878857-2-kuniyu@google.com>
Subject: [PATCH 1/2] mm/kasan: Detect double-free involving kfree_rcu_sheaf().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6303F140002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5noijfea5s5pizbcz1457hbpsrqbapii
X-HE-Tag: 1791582406-185555
X-HE-Meta: U2FsdGVkX1/MPGnofOTQiInuAWV2aQypNHZpbqIg5ae6equb/UO/bkmgX+bdgJpILQAYmmpDtszfQtZlsNSNp1Dq2riAG/AsFaKwteY4O3cPmGfqDFeOySGcWIhd0BbkidVW8cUJTNxnYoWdERcS4mjTeKjH17w7Xsz1voytI3FQGIEBIBe7oaSr4TGT7d82UCDHOmNp66m3ptgQlH6zpK8X8wXtCHgZX/kvSHlUekRylrUoeNK3HTZBh7P4w5/61Zzoyc0dQimcu8FQd10tpU/Cmjz55DjrqqoiVg2Ys/PZz55NGXWkE2u0rhJ1zgr/Sjabcpr66/C/V/axOiE3FocemovdaCjKqACXSCwrdrt5Mhb83i6nUIDsRytLhsfTXkaSzLlv/iAaHwne4oCma/MEv3TJESmrqGBKYuIuwBfS1jRuiv2uEOMgjkYdxImhUsKBNDUQCitv7ELxF8KBywbGNa5CMzNvqyvW29G0yeRwKlgsd6VFLFlFhn6Y3lA/fPI9ZPM5U+WYJ/5QLkbLzMTvRumRrjEWp+g2oDt8w516G81J8BHY2MQ3t40vYjKObeRK1hZQaMN0laCoBH/gVTYDvm45dKlPMmeQUYY2+tnutn2uF66Cd3/fAfXGXCaax5VsLCWTn6DSktwpG5TQTmNTTjvB3aO8HUOWLO27XVUbmRez3/WO0A5PKTCENhTGNvHC0z0HQayqt1oiP8EsiWUTHE8VtlOhuBIoe2x5FfNbVcYWEnJtf/z+gjFP30YL67Cwz0tQOoPk1mOfsRbJRlTCsbPwWFwSm0t/avq8a+45PSI6tjidZXXCXv3zOFw3SeWpZhm9hbVfdomnWVq904G6nZ1ExsDPmDX/Paelu2Jumzn2PVUZvvBCOFPKmutuT6qkWzq6gamsrNtZYj4CXqq+dzmisYZeXIZmfDJQmNrJ9cI1y/pDBklfFYSQe6Of068aaNoDwFlNY2GsuDm
 Kpi2k+MT
 H3UWRBIryTAH38dzGKW9a3kb8SQjhECEQEmStNRMre/31tn7PHsK7CWeQ6BSFJKoNWhAb2E0OyoWCfaLdAVCyWDM5ddshydxep51bR6tZleBZL7Qpt3n062DbC8pZQ5XllDHxGfLiPCqo8DKC7l7LAGk2nmmpjaMi0cIYradQaqYLzq5LJrq0aWWqF2mkRFTmVlZzzE2lcE34etNNw965xVEcJG6Z/G/0+RxHft6o/B5PBBt5toCpKUmTvX1A7nmzgfWShLrCJyn67umAAviYK6Vre3nur+e8S7MI43bsa1OuQadtx2nwKoa2hSbhWkwYClgY6KGzSUP7A8b8q/cAyKPeVvzyhLqczE0VlLpAUfEAckPfUZ8e1m/cQL5rLpQ/IPrmwNFvfkd9CsOF2o3qwmzcHLcVt+ryxKd8jaOFU1ouWgvsdVfxERa7MfRqmuPEF4GgKlg31oyy43La+yg1S1fTW0RLKm3O5vdksCIVmK/JBIkUJsjDRLTEATkDkSANp/w8wGGMaNOOD+594Fw8EPvWcUdnkadSK2EUbvdSPzktWoDDzV71CHLsyqYKdub5ItTCogubQAyVliZgoCioK7j67lAn4gQ05gHIR+FmMsctAaYau6xBKgDHuAB1KpEQ7AZw9bNK8rIvH+jRaO5peZ0wazHe/gndCgPXpuGKVK7/6ga5OGLETppNZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a weird use-after-free splat. [0]

In the report, an object in the kmalloc-64 cache was freed via
rcu_free_sheaf() while it was still in use, even though the
object should always be freed with kfree() (in xfrm_hash_free()),
implying that the object was a victim of a double-free involving
kfree_rcu() somewhere else.

When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
kasan_slab_pre_free(), kasan_record_aux_stack(),
debug_rcu_head_queue(), etc.

As a result, KASAN cannot detect the double-free at the call site.

If the object is still in the KASAN quarantine when the sheaf is
flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
with no trace of the suspect.

Worse yet, once the object is evicted from the quarantine and
reallocated before the sheaf is flushed, rcu_free_sheaf() silently
poisons the live object, resulting in a false-positive use-after-free
report on the new user.

If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
can detect the second kfree_rcu(), but only while the object is
poisoned in the KASAN quarantine after the first free:

  kfree()     --(poisoned)--------------------> kfree_rcu()
  kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()

An object queued in pcs->rcu_free remains unpoisoned until the
sheaf becomes full and rcu_free_sheaf() runs after the RCU
grace period, so a subsequent kfree_rcu() or kfree() before
rcu_free_sheaf() cannot be detected by shadow bytes alone:

  kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
  kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)

These cases can be detected if we call debug_rcu_head_queue()
before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
free.

To detect these cases with KASAN, we just need a 1-bit flag
to indicate the state, which can reuse an unused bit in struct
kasan_track.pid. (PID_MAX_LIMIT is 1<<22)

The bit is marked along with recording the stack trace when
deferring slab frees in kfree_rcu_sheaf() and checked in
check_slab_allocation() so that any double-free pattern above
can be detected immediately.

Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
---
 include/linux/kasan.h | 13 +++++++++----
 mm/kasan/common.c     | 13 ++++++++-----
 mm/kasan/generic.c    | 14 +++++++++++++-
 mm/kasan/kasan.h      | 34 +++++++++++++++++++++++++++++++++-
 mm/slub.c             | 13 ++++++++++---
 5 files changed, 73 insertions(+), 14 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..3a43e3d2658e 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -180,7 +180,7 @@ static __always_inline void * __must_check kasan_init_slab_obj(
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
-			unsigned long ip);
+			   unsigned long ip, bool after_rcu_delay);
 /**
  * kasan_slab_pre_free - Check whether freeing a slab object is safe.
  * @object: Object to be freed.
@@ -193,10 +193,12 @@ bool __kasan_slab_pre_free(struct kmem_cache *s, void *object,
  * @Return true if freeing the object is unsafe; false otherwise.
  */
 static __always_inline bool kasan_slab_pre_free(struct kmem_cache *s,
-						void *object)
+						void *object,
+						bool after_rcu_delay)
 {
 	if (kasan_enabled())
-		return __kasan_slab_pre_free(s, object, _RET_IP_);
+		return __kasan_slab_pre_free(s, object, _RET_IP_,
+					     after_rcu_delay);
 	return false;
 }
 
@@ -424,7 +426,8 @@ static inline void *kasan_init_slab_obj(struct kmem_cache *cache,
 	return (void *)object;
 }
 
-static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object)
+static inline bool kasan_slab_pre_free(struct kmem_cache *s, void *object,
+				       bool after_rcu_delay)
 {
 	return false;
 }
@@ -495,6 +498,7 @@ void kasan_cache_create(struct kmem_cache *cache, unsigned int *size,
 void kasan_cache_shrink(struct kmem_cache *cache);
 void kasan_cache_shutdown(struct kmem_cache *cache);
 void kasan_record_aux_stack(void *ptr);
+void kasan_record_aux_stack_rcu(void *ptr);
 
 #else /* CONFIG_KASAN_GENERIC */
 
@@ -512,6 +516,7 @@ static inline void kasan_cache_create(struct kmem_cache *cache,
 static inline void kasan_cache_shrink(struct kmem_cache *cache) {}
 static inline void kasan_cache_shutdown(struct kmem_cache *cache) {}
 static inline void kasan_record_aux_stack(void *ptr) {}
+static inline void kasan_record_aux_stack_rcu(void *ptr) {}
 
 #endif /* CONFIG_KASAN_GENERIC */
 
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 7d21c4db68d2..4187606a88cf 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -68,6 +68,7 @@ void kasan_set_track(struct kasan_track *track, depot_stack_handle_t stack)
 	track->timestamp = ts_nsec >> 9;
 #endif /* CONFIG_KASAN_EXTRA_INFO */
 	track->pid = current->pid;
+	track->rcu_free = 0;
 	track->stack = stack;
 }
 
@@ -231,7 +232,7 @@ void * __must_check __kasan_init_slab_obj(struct kmem_cache *cache,
 
 /* Returns true when freeing the object is not safe. */
 static bool check_slab_allocation(struct kmem_cache *cache, void *object,
-				  unsigned long ip)
+				  unsigned long ip, bool after_rcu_delay)
 {
 	void *tagged_object = object;
 
@@ -242,7 +243,8 @@ static bool check_slab_allocation(struct kmem_cache *cache, void *object,
 		return true;
 	}
 
-	if (!kasan_byte_accessible(tagged_object)) {
+	if (!kasan_byte_accessible(tagged_object) ||
+	    kasan_check_rcu_free(cache, object, after_rcu_delay)) {
 		kasan_report_invalid_free(tagged_object, ip, KASAN_REPORT_DOUBLE_FREE);
 		return true;
 	}
@@ -259,17 +261,18 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
 
 	kasan_poison(object, round_up(cache->object_size, KASAN_GRANULE_SIZE),
 			KASAN_SLAB_FREE, init);
+	kasan_clear_rcu_free(cache, object);
 
 	if (kasan_stack_collection_enabled())
 		kasan_save_free_info(cache, tagged_object);
 }
 
 bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
-				unsigned long ip)
+			   unsigned long ip, bool after_rcu_delay)
 {
 	if (is_kfence_address(object))
 		return false;
-	return check_slab_allocation(cache, object, ip);
+	return check_slab_allocation(cache, object, ip, after_rcu_delay);
 }
 
 bool __kasan_slab_free(struct kmem_cache *cache, void *object, bool init,
@@ -544,7 +547,7 @@ bool __kasan_mempool_poison_object(void *ptr, unsigned long ip)
 
 	slab = page_slab(page);
 
-	if (check_slab_allocation(slab->slab_cache, ptr, ip))
+	if (check_slab_allocation(slab->slab_cache, ptr, ip, false))
 		return false;
 
 	poison_slab_object(slab->slab_cache, ptr, false);
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 2b8e73f5f6a7..07636ffe1626 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -536,7 +536,7 @@ size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
  * This function avoids dynamic memory allocations and thus can be called from
  * contexts that do not allow allocating memory.
  */
-void kasan_record_aux_stack(void *addr)
+static void __kasan_record_aux_stack(void *addr, bool rcu_free)
 {
 	struct slab *slab = kasan_addr_to_slab(addr);
 	struct kmem_cache *cache;
@@ -552,10 +552,22 @@ void kasan_record_aux_stack(void *addr)
 	if (!alloc_meta)
 		return;
 
+	if (rcu_free)
+		alloc_meta->alloc_track.rcu_free = 1;
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(0, 0);
 }
 
+void kasan_record_aux_stack(void *addr)
+{
+	__kasan_record_aux_stack(addr, false);
+}
+
+void kasan_record_aux_stack_rcu(void *addr)
+{
+	__kasan_record_aux_stack(addr, true);
+}
+
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
 {
 	struct kasan_alloc_meta *alloc_meta;
diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
index fc9169a54766..43d608899544 100644
--- a/mm/kasan/kasan.h
+++ b/mm/kasan/kasan.h
@@ -191,7 +191,10 @@ static inline bool kasan_requires_meta(void)
 #define KASAN_STACK_DEPTH 64
 
 struct kasan_track {
-	u32 pid;
+#define KASAN_PID_BITS const_ilog2(PID_MAX_LIMIT)
+	u32 pid:KASAN_PID_BITS;
+	u32 rcu_free:1;
+	u32 unused:32 - (KASAN_PID_BITS + 1);
 	depot_stack_handle_t stack;
 #ifdef CONFIG_KASAN_EXTRA_INFO
 	u64 cpu:20;
@@ -390,8 +393,37 @@ struct kasan_alloc_meta *kasan_get_alloc_meta(struct kmem_cache *cache,
 struct kasan_free_meta *kasan_get_free_meta(struct kmem_cache *cache,
 						const void *object);
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object);
+
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache,
+					const void *object,
+					bool after_rcu_delay)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (!alloc_meta)
+		return false;
+
+	return alloc_meta->alloc_track.rcu_free != after_rcu_delay;
+}
+
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache,
+					const void *object)
+{
+	struct kasan_alloc_meta *alloc_meta;
+
+	alloc_meta = kasan_get_alloc_meta(cache, object);
+	if (alloc_meta)
+		alloc_meta->alloc_track.rcu_free = 0;
+}
 #else
 static inline void kasan_init_object_meta(struct kmem_cache *cache, const void *object) { }
+static inline bool kasan_check_rcu_free(struct kmem_cache *cache, const void *object,
+					bool after_rcu_delay)
+{
+	return false;
+}
+static inline void kasan_clear_rcu_free(struct kmem_cache *cache, const void *object) { }
 #endif
 
 depot_stack_handle_t kasan_save_stack(gfp_t flags, depot_flags_t depot_flags);
diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c..8a08ca73d76b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2690,7 +2690,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, after_rcu_delay))
 		return false;
 
 #ifdef CONFIG_SLUB_RCU_DEBUG
@@ -2706,7 +2706,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 			 * We have to do this manually because the rcu_head is
 			 * not located inside the object.
 			 */
-			kasan_record_aux_stack(x);
+			kasan_record_aux_stack_rcu(x);
 
 			delayed_free->object = x;
 			call_rcu(&delayed_free->head, slab_free_after_rcu_debug);
@@ -6177,6 +6177,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	}
 
 do_free:
+	if (unlikely(kasan_slab_pre_free(s, obj, false))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto out;
+	}
+
+	kasan_record_aux_stack_rcu(obj);
 
 	rcu_sheaf = pcs->rcu_free;
 
@@ -6217,6 +6223,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	local_unlock(&s->cpu_sheaves->lock);
 
 	stat(s, FREE_RCU_SHEAF);
+out:
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lock_map_release(&kfree_rcu_sheaf_map);
 	return true;
@@ -6850,7 +6857,7 @@ void kfree_nolock(const void *object)
 	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
 	 * is double buggy and deserves to deadlock.
 	 */
-	if (kasan_slab_pre_free(s, x))
+	if (kasan_slab_pre_free(s, x, false))
 		return;
 	/*
 	 * memcg, kasan_slab_pre_free are done for 'x'.
-- 
2.56.0.385.gd3acb90ef8-goog


