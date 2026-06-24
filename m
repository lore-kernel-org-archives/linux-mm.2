Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5D0CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 13:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87F2C6B008C; Wed, 24 Jun 2026 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82FC46B0092; Wed, 24 Jun 2026 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F77B6B0093; Wed, 24 Jun 2026 09:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 447A86B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:12:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7C85A0308
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:15 +0000 (UTC)
X-FDA: 84914844630.14.D33FE7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id F195840014
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 13:12:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlcUi3ha;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782306734;
	b=A3uVT+kxZy/C9YOwz6GiVmauhtKSKYt3WlJMXCKGWitkM1ZwHuU3NgXLzsZoRymRJHe1lf
	gtKC1Tzpjp9ZtNmA6+9VORKzIOaElpQIlaJgmg20YnP2u3UiNXIkjRTTNBssBkT8RRfvgK
	L8O/b+86b0bQ4J6QPUA99vyKCvL7lLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782306734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSfCNoOHA4MMj4vfov5LjVgdAFVWxiZap6xazmrZ5TI=;
	b=0PWtRM5bwhxHlJ9IXdMz2Qofhu40wwS8psIGAuYn1jh8GEnFgrHrkoTZiYMVVrBr7m087k
	e16Ag152E+xICNB9H9to8UncCSJ3lhlmbjvkD/VmN+USzCVI1vJRWtVOErHbO0iMAe4vs/
	asWWph/NSP6seCUdBwlZfZ7kSJifLSU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlcUi3ha;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AAAA60018;
	Wed, 24 Jun 2026 13:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB471F000E9;
	Wed, 24 Jun 2026 13:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306733;
	bh=aSfCNoOHA4MMj4vfov5LjVgdAFVWxiZap6xazmrZ5TI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KlcUi3ha8THBZBaxRlkaw4IHC8/8+yagYeJXTxwtrNo82QHgjrci1MgjRIaPalwQ1
	 lqx4+ivcOwoC88q2iH56N9MKrtDPLroQhrv5lKYW0ic9siXsMT4SOAKuzo3wcfjKx9
	 l5zmB8B7++/9SSyv8UW7EousOsINWJSYCLZ4leLiyLgIun8qzpDvSCCWzTxxwk4Yh0
	 RxnZLg4D0O/8aY/BcoK4gr/rC39ySO/OauBj36v/ILp5Vq9K5fXGVeJtpojDhFR3ii
	 y/n3UupI//rjsFoY1pgkjJX36ncIht4pyNl/yUps7blp9sgX6MRCA42DB36dXrhNt0
	 NSImtg6ZgDrIA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 24 Jun 2026 22:11:39 +0900
Subject: [PATCH RFC 2/4] mm/slab: handle allow_spin in slab_free_hook()
 instead of open coding
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-kmalloc-nolock-fixes-v1-2-fdf4d17351dd@kernel.org>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F195840014
X-Stat-Signature: ftgc5okwbhsde1xpr43wy3crydd7mcek
X-HE-Tag: 1782306733-578649
X-HE-Meta: U2FsdGVkX19sMBakka3FMNZ/1e9fz7JuVcKzXiqAOq7hKhK8qgUmOfUwZuxHq/OU2gG6E+ghFPgGnaTrIEFEnVHKz//otL6Bqikqp6AQYvYPXfYaUA0pO7HI33y92B6NxlgrKcfV0S6JLdTePqZodC3dtUUDZTsVZ39ELNJkRdb6EFMEUxzAjbAPF4k/miv5KOZjOI/N1ybosvv75Bz9C+dxuQa3QJFDo1gv2IUUZtNuDFvRMuRMJ2aFf5ZZqGmAELvDwpLnZLFCWI4ZZTy3rmVQcN57S72SmRlaSHO5l9/TbEcey/B0JZp01m11gS+IuptXulTUpRzSNyJhrcDblJ8mc/J4ztaKPr/nR7BoysfstybGmefC/UqbBh1wZqYGVBcVdfXVY1YX3hyvFSsvVtxNYgF3+dWiZ3FoCuBeFWavTQNlliioC4Uw7OvqoPYH2ezTbT6TfvzPy4p4XozJXXxEueQaMIxmb6bwMG+DfKiD74tbm8KO+VWbYFsALvjuLZ72PLDzSjPazXHI3xXMSI93+VpSPRxJkoxFKSkiKMFZzLJagmC2RlKNnITxndo4gz15PLu8LnGUiuNePRItqel2usI1gRAbpyYoNljz4hyLVDYjAa+PPlWi1LVMR14CGYB/PUCCi/xFOelbdsTxLNaDY0XqTpSbrq1CpkJlvxEl0f2wwP1jqKLuRRvCqR0OGraEUTadM1fBNcpXO1hdFsAnT2V3RXzVSoQ3V92toJ6+oheHiyXxiNOs14i/Zg6lTzezClc/VSKXG+8sGEqyY9I8Kf6CauzZN16Pzw6Z547ptO+Hnrv2OjMmpQ/aQpwIEqCrnPoJnaKNBz+xJ2rQGaOutkDi/AsN+7LYCDV1vxcXGYTIJlBL8taZF1ihHd0/sCMrJuwSc+SIlrHyWlhyNSWypKHQYA8CQiAqIqnWryAmihvRiUAkE6xWR5Tkqm57qgBqjV6XhRbenPD8GF2
 WmSzYIWW
 T9hKjWaXEK6Tu2ZtjbbTgu3slDjvu8OuXiRtyiQJJkxL4WTqsVT5ULFiNwYEP4xraSlh/Wg2hWDkKaeVxYCH8r8Ga790vO8O2Lv5NBNuS3U8Aa5GsdCxERdFqdE4JgYBK2HBw/hZx4Z1Fn+FFQqvQPN27pzoGMugtXogvltTs2w/cGiYoLwV5CM8jNC1jjchErUYy6QiJ1f+Tf8jcGfYlPp6bvCm9bbwW4uPO/jPEODQvDUyE7ckoMi7qre1MpMC1O5i5s79Luj0dgox4+tfFOcGyU5CNrHgM0zG0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kfree_nolock() deliberately skips slab free hooks that should not be
called in unknown context. However, there is one more place that
needs the same thing: memcg_alloc_abort_single().

Instead of open coding slab_free_hook(), let it handle the allow_spin
parameter. This is required to correctly handle allocation failures due
to memcg.

There are two functional changes from this.

First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
calls free hooks that acquire spinlocks if !allow_spin.

Second, kfree_nolock() now follows init_on_free which has been ignored.

Besides that, no functional change intended.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 100 +++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 32672a92581b..85760c8ff2e2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2611,41 +2611,52 @@ struct rcu_delayed_free {
  * - memcg_slab_post_alloc_hook()
  * - alloc_tagging_slab_alloc_hook()
  *
+ * slab_free_hook() assumes that memcg_slab_free_hook() and
+ * alloc_tagging_slab_free_hook() are already invoked.
+ *
  * Free hooks that must handle missing corresponding alloc hooks:
  * - kmemleak_free_recursive()
  * - kfence_free()
  *
- * Free hooks that have no alloc hook counterpart, and thus safe to call:
+ * Free hooks that have no alloc hook counterpart, and thus safe to call
+ * when spinning is allowed:
  * - debug_check_no_locks_freed()
  * - debug_check_no_obj_freed()
  * - __kcsan_check_access()
  */
 static __always_inline
 bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
-		    bool after_rcu_delay)
+		    bool after_rcu_delay, bool allow_spin)
 {
 	/* Are the object contents still accessible? */
 	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
 
-	kmemleak_free_recursive(x, s->flags);
 	kmsan_slab_free(s, x);
 
-	debug_check_no_locks_freed(x, s->object_size);
-
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(x, s->object_size);
-
-	/* Use KCSAN to help debug racy use-after-free. */
-	if (!still_accessible)
-		__kcsan_check_access(x, s->object_size,
-				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
-
-	if (kfence_free(x))
-		return false;
+	if (likely(allow_spin)) {
+		/* These hooks acquire spinlocks */
+		kmemleak_free_recursive(x, s->flags);
+		debug_check_no_locks_freed(x, s->object_size);
+		if (!(s->flags & SLAB_DEBUG_OBJECTS))
+			debug_check_no_obj_freed(x, s->object_size);
+		/* Use KCSAN to help debug racy use-after-free. */
+		if (!still_accessible)
+			__kcsan_check_access(x, s->object_size,
+					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+		if (kfence_free(x))
+			return false;
+	}
 
 	/*
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
+	 *
+	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
+	 * will call raw_spin_lock_irqsave() which is technically unsafe from
+	 * NMI, but take chance and report kernel bug. The sequence of
+	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
+	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
+	 *  is double buggy and deserves to deadlock.
 	 */
 	if (kasan_slab_pre_free(s, x))
 		return false;
@@ -2654,6 +2665,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	if (still_accessible) {
 		struct rcu_delayed_free *delayed_free;
 
+		VM_WARN_ON_ONCE(!allow_spin);
 		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
 		if (delayed_free) {
 			/*
@@ -2701,8 +2713,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 		set_orig_size(s, x, orig_size);
 
 	}
-	/* KASAN might put x into memory quarantine, delaying its reuse. */
-	return !kasan_slab_free(s, x, init, still_accessible, false);
+	/*
+	 * KASAN might put x into memory quarantine, delaying its reuse.
+	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
+	 */
+	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
 }
 
 static __fastpath_inline
@@ -2714,9 +2729,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	void *next = *head;
 	void *old_tail = *tail;
 	bool init;
+	bool allow_spin = true;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next, false, false);
+		slab_free_hook(s, next, false, false, allow_spin);
 		return false;
 	}
 
@@ -2731,7 +2747,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 		next = get_freepointer(s, object);
 
 		/* If object's reuse doesn't have to be delayed */
-		if (likely(slab_free_hook(s, object, init, false))) {
+		if (likely(slab_free_hook(s, object, init, false, allow_spin))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -2954,7 +2970,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+		if (unlikely(!slab_free_hook(s, p[i], init, true, allow_spin))) {
 			p[i] = p[--sheaf->size];
 			continue;
 		}
@@ -6225,7 +6241,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		memcg_slab_free_hook(s, slab, p + i, 1, allow_spin);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
+		if (unlikely(!slab_free_hook(s, p[i], init, false, allow_spin))) {
 			p[i] = p[--size];
 			continue;
 		}
@@ -6401,11 +6417,12 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
 {
 	bool allow_spin = true;
+	bool init = slab_want_init_on_free(s);
 
 	memcg_slab_free_hook(s, slab, &object, 1, allow_spin);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
 		return;
 
 	if (likely(can_free_to_pcs(slab)) &&
@@ -6422,10 +6439,12 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	struct slab *slab = virt_to_slab(object);
+	bool init = slab_want_init_on_free(s);
+	bool allow_spin = true;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 }
 #endif
@@ -6456,6 +6475,8 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	void *object = delayed_free->object;
 	struct slab *slab = virt_to_slab(object);
 	struct kmem_cache *s;
+	bool allow_spin = true;
+	bool init;
 
 	kfree(delayed_free);
 
@@ -6469,8 +6490,9 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
 		return;
 
+	init = slab_want_init_on_free(s);
 	/* resume freeing */
-	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
+	if (slab_free_hook(s, object, init, true, allow_spin)) {
 		__slab_free(s, slab, object, object, 1, _THIS_IP_);
 		stat(s, FREE_SLOWPATH);
 	}
@@ -6742,6 +6764,7 @@ void kfree_nolock(const void *object)
 	struct kmem_cache *s;
 	void *x = (void *)object;
 	bool allow_spin = false;
+	bool init;
 
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
@@ -6756,33 +6779,10 @@ void kfree_nolock(const void *object)
 
 	memcg_slab_free_hook(s, slab, &x, 1, allow_spin);
 	alloc_tagging_slab_free_hook(s, slab, &x, 1);
-	/*
-	 * Unlike slab_free() do NOT call the following:
-	 * kmemleak_free_recursive(x, s->flags);
-	 * debug_check_no_locks_freed(x, s->object_size);
-	 * debug_check_no_obj_freed(x, s->object_size);
-	 * __kcsan_check_access(x, s->object_size, ..);
-	 * kfence_free(x);
-	 * since they take spinlocks or not safe from any context.
-	 */
-	kmsan_slab_free(s, x);
-	/*
-	 * If KASAN finds a kernel bug it will do kasan_report_invalid_free()
-	 * which will call raw_spin_lock_irqsave() which is technically
-	 * unsafe from NMI, but take chance and report kernel bug.
-	 * The sequence of
-	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
-	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
-	 * is double buggy and deserves to deadlock.
-	 */
-	if (kasan_slab_pre_free(s, x))
+
+	init = slab_want_init_on_free(s);
+	if (!slab_free_hook(s, x, init, false, allow_spin))
 		return;
-	/*
-	 * memcg, kasan_slab_pre_free are done for 'x'.
-	 * The only thing left is kasan_poison without quarantine,
-	 * since kasan quarantine takes locks and not supported from NMI.
-	 */
-	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
 	if (likely(can_free_to_pcs(slab)) &&
 			likely(free_to_pcs(s, x, allow_spin)))

-- 
2.53.0


