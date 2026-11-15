Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 861E9606A332
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pz3Mq/WN
Received: by kanga.kvack.org (Postfix)
	id 4592F6B05B4; Sun, 15 Nov 2026 10:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430946B05B5; Sun, 15 Nov 2026 10:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 346616B05B6; Sun, 15 Nov 2026 10:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 064B26B05B4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:25 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75C35120783
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:25 +0000 (UTC)
X-FDA: 85437689610.19.E3F13C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE3A2180007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pz3Mq/WN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WO5dYOrdka6DIWC9KKEpVyr89KsTYkuKSnLMWU6DnVo=;
	b=KiHL0I5Skh2FWRzohUUexucsreDctRoMqvvx5M5sBP0I9FMcSj73S4PCf1O3920y/vxTSB
	A+6uB43WEEVHJ2to9rJoedUj3dhghdjGCXacwJiGY+YYYFCKOKl/I4nhavZ5xEojI/dxRw
	SVKAXCtqiBKi3eO7DlfDVzjYsed7kr4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755423;
	b=Tqx9nUjSDPgkumAaDLnGMszPUgyf1GHEcXkYNM/SAWluyD8MAqq+JwfLGdn+PsCHo8pfC0
	aPqM1CcfmaePFVCB9EtrWvjWkpiH5K81zpL170g32ai7v5X6UL0/L5IE6fmjsH8E+ei8Hi
	0kHRpHX4XpJ9z8LO9OGmLFxAtsSGfdQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pz3Mq/WN";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6732160D70;
	Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C461F000C4;
	Sun, 15 Nov 2026 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755423;
	bh=WO5dYOrdka6DIWC9KKEpVyr89KsTYkuKSnLMWU6DnVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pz3Mq/WN7xLi7ysp9JmjujQrSrHmU9huH6HMZ5HpsrPJ46v6WQMa2uOL6QdV5ECHC
	 CyHCqZXeRonR7n0k9jENAdyzQR18b57mFG8BjnVdVy27oiE+Lku0Zkldd1JPlY+JBS
	 GsdAL9XB8VSsq+0s0pSQ9f2K+ZekR40FkTktiJ2FF4fy3hnddyyKhWzhW/r1RccfZe
	 YG0WeT8EN3mhazdTKNVUV8hvD/KWfeLOYRNUmzxly8Tqc3VbdABmXQ3MJIW4009Rl4
	 6YeYROCh9sLyOTo9JFJGf2LNZIYjnFsElRm3s6kMDYfzz9Qmq0abkdAL/gkzFsI6Dg
	 YeE2duYy552xQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:37 +0000
Subject: [PATCH for-next v3 3/7] mm/slab: handle SLAB_FREE_NOLOCK in
 slab_free_hook() instead of open coding
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0
X-Stat-Signature: n19nsitus87aois8kq871fecky9ax66u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE3A2180007
X-HE-Tag: 1794755423-713918
X-HE-Meta: U2FsdGVkX19zibEIx78Ku14P1q4rTLuJIa5pYyoWzbvET8quNpTYlbNDI4AYuIyg8vuKZci6yi5i2Yorv5ve/QnNjMP7SXinyMyHbHPCu9QocdS2tT6aoE77BdqeyI/TIxdMWa1AMri3P4LVjqPmTBAisfG5QfL7y7mki4KarRhG2H0K/SaPsseGEcsUIXzyW2dKYBPvfgrRzpZwfu6Uoqz+YA/8034ZAlWmvd+P+9LOLizo8aWXWak6c/3jWXLjhLbGMqmiex6MlP6jUCkWyc5utKBB/eS18bbr+fYb/isI2ON7of3WLG9S2Jt0RdeqEcgRA5ztUPha4x40bQ7sO7h7GYBadkfSN9/tAKqdBlEs9a0VjBri8yAgmjOuZFsAdCHgnOBK88lPkTb7YGk0lnwqSYn1uEaiG/XbAeTJx9O4Yr8zv/4Idm7mRfWlxWiZKmBT7RyWlYZH+cEMZGfMfYZ7cby++sZZNtj1cG8feRleCmQN7JJE1raUWi2Ch39SHv04a66Y1IolMjiS/3IEZt8ENMMjFVeMcQf0Xto8Wwmmo+AuCSwOMjBd414TT7PwPxfx6Dt8beOMJLR159x8R/lSey3XlbnsF00smukYw6KhICeGFKx2/CTyBqMoIL0LFQ1i1qAZlgSlF4rdrHauQ/HxToFNq963zoA84aYKY0bOiqooCk04Ph2604zoHPvv/bF+m/D8Eph9bkFGsyAMY1HYasyBH5+NlGNEMRPrX1TZc8C8zQFVN3Mobz2Lo28dH448ITYs8IXAbbinzBqOLCyLZJJU45a9qz6bxwKwrczByVqUmgo0GV56xZ9a0hKGCgsSnGnRvxX/ZON/cdJac5J8uJh0KEjAJosyjM+XUpKPzvOJxFphXfO+aaufRWR7VYid6VkijleggC9pRaeUE6KuHn3W+Uh1TGOL8y3DQy3FaZH5fO44+0A6MK65iRfJILLs+EatOBXgOtEEsLx
 0QSb731K
 OIy0Tt8Vp2omEoFotEueGY2YQnCgDaBtM7kiXbc25fdcpVK9nMr+bgAYs47tbrTwbhM1IwXtPkw66687DqewsjFMkb6tR+WatCFVXI20BSX55Dgp1umWhN6NoO2eVoxgO05xs+ToAArGRAnhsITdsqx88KpuAUQRVo5T4g3N38Jj5rFkZ4vkYKde8M7r6Kj62f88kNlLVZKYM4egpbpJrz3nzY3Vcrtq+L/Ra3wZyfVwfbqEStgOSiXPiDh63k5XIHL149LMPA7n7XbHQ7bdLKxfzpgiY339OEaIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kfree_nolock() deliberately skips slab free hooks that should not be
called in unknown context. However, there is one more place that
needs the same thing: memcg_alloc_abort_single().

Instead of open coding slab_free_hook(), let it handle
SLAB_FREE_NOLOCK. This is required to correctly handle allocation
failures due to memcg charging.

kfree_nolock() now respects init_on_free which has been ignored.
Besides that, no functional change intended.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 76 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 761dc2affea2..7c0adc104988 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2684,11 +2684,14 @@ struct rcu_delayed_free {
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
+ * Free hooks that have no alloc hook counterpart:
  * - debug_check_no_locks_freed()
  * - debug_check_no_obj_freed()
  * - __kcsan_check_access()
@@ -2698,28 +2701,39 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 {
 	bool init = free_flags & SLAB_FREE_INIT;
 	bool after_rcu_delay = free_flags & SLAB_FREE_AFTER_RCU_DELAY;
+	bool allow_spin = free_flags_allow_spinning(free_flags);
 	/* Are the object contents still accessible? */
 	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
 
-	kmemleak_free_recursive(x, s->flags);
 	kmsan_slab_free(s, x);
 
-	debug_check_no_locks_freed(x, s->object_size);
+	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
+	if (likely(allow_spin)) {
+		kmemleak_free_recursive(x, s->flags);
+		debug_check_no_locks_freed(x, s->object_size);
 
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(x, s->object_size);
+		if (!(s->flags & SLAB_DEBUG_OBJECTS))
+			debug_check_no_obj_freed(x, s->object_size);
 
-	/* Use KCSAN to help debug racy use-after-free. */
-	if (!still_accessible)
-		__kcsan_check_access(x, s->object_size,
-				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+		/* Use KCSAN to help debug racy use-after-free. */
+		if (!still_accessible)
+			__kcsan_check_access(x, s->object_size,
+					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 
-	if (kfence_free(x))
-		return false;
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
@@ -2728,6 +2742,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 	if (still_accessible) {
 		struct rcu_delayed_free *delayed_free;
 
+		VM_WARN_ON_ONCE(!allow_spin);
 		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
 		if (delayed_free) {
 			/*
@@ -2775,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
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
@@ -6935,6 +6953,7 @@ void kfree_nolock(const void *object)
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
+	unsigned int free_flags = SLAB_FREE_NOLOCK;
 
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
@@ -6949,33 +6968,12 @@ void kfree_nolock(const void *object)
 
 	memcg_slab_free_hook(s, slab, &x, 1);
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
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
+	if (unlikely(!slab_free_hook(s, x, free_flags)))
 		return;
-	/*
-	 * memcg, kasan_slab_pre_free are done for 'x'.
-	 * The only thing left is kasan_poison without quarantine,
-	 * since kasan quarantine takes locks and not supported from NMI.
-	 */
-	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
 		return;

-- 
2.54.0


