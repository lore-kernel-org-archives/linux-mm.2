Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4050D607DDED
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feyuTSRC
Received: by kanga.kvack.org (Postfix)
	id 5B2756B095C; Wed, 25 Nov 2026 04:35:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CB16B095E; Wed, 25 Nov 2026 04:35:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404536B095F; Wed, 25 Nov 2026 04:35:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15A546B095C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:35:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B36B120DB6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:35:07 +0000 (UTC)
X-FDA: 85473132654.28.F86D3F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6E7CA000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:35:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feyuTSRC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599305;
	b=4TFZ62dfAQoMKAij8mIXY26IZtcghV1Zl44RknQH24BVkz/YIYdeWIhpug814epFm6aYF5
	UDKoxW7DH1q8NZgflJ9bHD+vOBX1skMmxaBnjM785IdGir1fIl3K8MQvvnpYqqK9pCFsw9
	8JuWVJXZ7Q9dVK8Es7iUkW9gG3csztk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yCSqfAyZ77JuVMThAw7Ur0h8HFHWK4ACsCjE0QWCzwg=;
	b=3H5kYUvgRh7diGs4tH3/VUllfvhHONqWqxuzcMYJUvnPIP+RKnNTkOOSzp6xEyFEiVOjtL
	cpPPVrYDTfFFJbRSjaoZzw9wu4zgIVUUjeu/fZ/xxUBY1jrMJSXJnwCPpjkQYl4k/+Fn6y
	OG6do+XgEBqlpYpRCMKd0lAQ/YTiXx0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=feyuTSRC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFC6C626D9;
	Wed, 25 Nov 2026 09:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A345B1F0157A;
	Wed, 25 Nov 2026 09:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795599304;
	bh=yCSqfAyZ77JuVMThAw7Ur0h8HFHWK4ACsCjE0QWCzwg=;
	h=From:Date:Subject:To:Cc;
	b=feyuTSRCDIFwJfcvIyqA4WAGMf28HakKlbSbIUQcq6cfvVJYjJKNKtTdcDrgAzWCB
	 sDfo5hxKUHsyyGhQUvGBTS8OB+d1wv4KEk8bLRbHPf0teKL0aoyfffe0X+thSgIMrp
	 8LlwtdR+K8ncRYL2rPe9Y+t4id1KFW5Wtt+EJD1Lgi/d491msN30yBGGMoj1IxLhvv
	 I8Tsw1sJBfGXrF2Cden4kHFJtaYmGoTYebQjRuN7m76kfm8xe6W/BKrm/kg//0cJIm
	 cYu8x0gTw6fO8phOYqvjnLsjROqsxlGkfUsXuHQl6RmOi69Izd/x9s838k7h8fgcYP
	 UtLOPvWlU8++Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 10:34:46 +0100
Subject: [PATCH v2] mm/rmap: avoid reusing batched TLB flush generations
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAA/zWNyw6CMBBFf6WZNTW2VKxd+R+GRR8D1AeQKRIN6
 b8bIC5vcu45CySkiAkMW4BwjikOPRgmCwa+s32LPAYwDORRVkLIktPLjvzilFM+yEbrCgoGI2E
 TP5vmVu87vd0d/bR+V6KLaRrou3VmsXJ/pdqVs+CCYxm80la5kzxfH0g9Pg8DtVDnnH8CzE3pq
 wAAAA==
X-Change-ID: 20261123-rmap-9b4b4cd2f886
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Ying Huang <huang.ying.caritas@gmail.com>
Cc: linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
 linux-riscv@lists.infradead.org, stable@vger.kernel.org, 
 Kirk Swidowski <swidowski@google.com>, 
 Huang Ying <ying.huang@linux.alibaba.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9870; i=david@kernel.org;
 h=from:subject:message-id; bh=sApNn04IkF2jKBCWWGPIU/uCfVggM+RnRjuZROPKlQ0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZVu96VMz56tLPuyfWsXodiBXVibxde2V75HHDpbs1Z
 vBGi7Nf7ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiq1YzMvRJVWmnrEj+8yH/
 SczZpnotJTX5Ywn+n4rs/qwN4c6vyGJk+MKY0rvF82+qY8C+c3J3VTN0wkQutq3jYKxOXj1jS74
 6HwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: 8ujpqsnkehnzczfei5dume7acra4y9ok
X-Rspamd-Queue-Id: B6E7CA000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795599305-738815
X-HE-Meta: U2FsdGVkX18UsU7KgGeR6DIJk3SzhiMiG8qTBTgkzi92MQHJ5MNBua9lN7S62PsM0aJd33UJlTYz1AYvriXIe97qEq318p2Y1DjqLITAttdtaZGTJBoHTsC3Qo/7eViZ0ReZwTSXq2iOeVHdDBk67aDZ6edCqtaYu5o02tXWP+aymzXjoZOoQQNGBn8yogua72Y8TEVQCzPAvp833tvRvLoKO6z06i1a2i+8isWbD+RwtT/diQAjkU8Dt8fNPZH/FxrOjTg+UaHCSwHuMjb3JFELObWasmPU8kPUoalWEG8ymXv5qPDb7TfWZToihWcOI7wSp32Vyr/owSf3XIZsdPNJ/hqBPBBd/WDThXxnnf1qPNnCVZPN1JCx8MDCUenPSTkKiaQDGPhNBroX20F/WFS4vMC4FiZY0ZScIJj2iPO3scvbFMm/9Oiiw+dIy5KGM6WQa8dmB0Hhij29oecWjxxcy57UB7ve8Ok5+4oLk7+iP++v+bvFJou8bUZfN3SsVJJC0qV0nGl9rV0Ee7X7OJ258zLsRqE0wIAuqdk3V870p/aw9YobXWd+oK10HFpogjkRKiWQtG5BBpdmGzO0/oQ0QpAnMJmkElavWl03yNOOOZxUG9TZSWxLSmV4EiPxY3CwjLiE6Qr5X+J49uyhoDUa+H5+sz1qmDAVdwShdQHazt0BFEQrCiepfz8TVKao33pncYWvff/cy6WW6Kcd/1SQ3zb1u1rMRd+A5r2EaFCRfyrlVVNAX7ZtoXc3X6X/XI6o57lHiUFqEfluWyNAdxOTbCdIxCGI3tvokiO9zP+kD2WVyUz2XMY/1whgivtqn2ZPpOy6dfXDka6HASwRO/gWtqwRkkEWHia3Z73xjSjc6ceEoC4Z7CAw95q8e8FegfeA9k1R4zpQvuV+xUtLy4reznOdUPw9QuHVDbqrRBCVn2S0D0wk87CMScsVxOB8GpT8szL+W9jPU4pVLEc
 j2zUd0+p
 2Xtt7eHKl5/PwTE09C3XRcNoQrZ+HLuosbF0PiXk6v4US891aYn96AP5B9+cSYUiZnjxunv8MAuNnQkd5Dc35gCxDAsl/mqAqGzVu1VWLlMbBr/xBmnvAklQEsLjgte65xEDbUaFOBh5gyZrYrifHPvG7sVQjUWQ0Pr2095CgPzA3WPprleinnrF4OMOrfp9saPI2rBLCCeFRgKJbodJdqFKG4dFEZyXmgcD5tRmnmbU3MwKukUp6jxGIA1wniKE7HXkYgsTXwCwQitlUA7KC86vjUXUOWeHFZ2+0AFp3hCk1H813Qz2AOVzzTi+q9OUECzBxB8qNznISb4r2w7e4HoQPCzU7YD7k0+IBheut1RpTzclgR/Udb2ONiAR5OsmhCJUVk+ICEYBTxeMBKZ9qBRkM8KUYRQE9k1YR+cuQ1CNys+EhqVwn6ILkjGtV6S5mqgPPk9K4BH2snJSmsFQoZ3za7m7b2s+pARc5pAhO0U+PiGeFsCZXdY+8NX1vOAkM/iIlactxgQuFlvd9P+GKyTRLA+PZq8Y1hymEhKD275AZnC8UXjLirYqbhpOfIggGQkXMgrA3ha8ymdeAkWG3t95aFmr8y7mqn9ZtW2wT8PqB8Mm1SVEyo6j0/ZuXNLdKcy665k2o5i0QBgL8odLxC0j+qLpsWp2TSVl8HUSXMzdmPXfugEkE+ASHZy8bHaXMTD//A4Vn8Mcthln2h4JMQThB/EVUS/4fJUfx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mm->tlb_flush_batched packs a 15-bit pending and a 15-bit flushed
counter into one atomic_t, and resets both once pending gets large.
flush_tlb_batched_pending() updates flushed with a cmpxchg() against the
value it read before flushing.

If the counters get reset and reach that same value again while
flush_tlb_mm() is running, the cmpxchg() succeeds and unmaps that
happened in the meantime are considered flushed. A later zap can then
skip the flush and leave stale writable TLB entries behind.

Use two separate counters, never reset pending, and let the flusher
simply store the pending value it read before flushing. To keep pending
from wrapping around to flushed, pull flushed to pending - 1 once
pending is more than INT_MAX ahead.

Preventing the wrapping is primarily required because
try_to_unmap_flush() as called from migration and reclaim code does
*not* go through flush_tlb_batched_pending(), as it does not iterate
MMs. So if nothing in the MM triggers flush_tlb_batched_pending(), there
would be a problem.

As the separate counters are no longer read atomically together, we must
read "flushed" before "pending" (acquire/release), so a reader can never
pair a just moved-forward "flushed" value with an older "pending" value.

We'll leave the barrier() between clearing the PTE and incrementing
"pending" alone for now: it should be a smp_mb__before_atomic(), but
existing arch code (x86: inc_mm_tlb_gen(), arm64: dsb(ishst) before the
TLBI, riscv: fully-ordered xchg() in ptep_get_and_clear()) implies a
barrier. This should be cleaned up or documented separately.

As dup_mm() copies the counters using memcpy() while they can get
updated concurrently, a newly forked child could end up with "flushed"
being "pending + 1" and we could skip a later flush in the child. In
theory, this might have been possible before (load tearing), but two
separate counters make that easier to trigger. So let's just reset them to
0 during fork(). Put it into the existing init_tlb_flush_pending() and
rename the function to make the name better match the wider scope.

Note: if a flusher stalls between reading "pending" and storing it,
while "pending" advances by an exact multiple of 2^32, the counters
could compare equal and we could miss a flush. The same applies to a
writer that stalls while moving "flushed" forward.

That is irrelevant in practice: both hold the PTL, so without PREEMPT_RT
they cannot get preempted, and wrapping within the ~20s soft lockup and
RCU stall timeouts would require more than 200 million batched unmaps
per second on a single mm, which is impossible in practice. Even with
PREEMPT_RT or long vCPU preemption, we would need minutes of unmap and
refault churn while the stalled task stays off the CPU, which is highly
unlikely and not a realistic attack vector.

This effectively adds 4 bytes to mm_struct. However, on common 64-bit
configs it fits into the existing padding, leaving the size unchanged.

[ david: use atomic_t instead of atomic64_t, reset counters during fork(),
         adjust description ]

Fixes: 5ee2fa2f0636 ("mm/rmap: fix potential batched TLB flush race")
Cc: stable@vger.kernel.org
Reported-by: Kirk Swidowski <swidowski@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Changes in v2:
- Reset counters during fork()
- Adjust description
- Pick up tags (thanks!)
- Link to v1: https://patch.msgid.link/20261124-rmap-v1-1-e3dc48a4b527@kernel.org
---
 include/linux/mm_inline.h |  6 +++-
 include/linux/mm_types.h  |  3 +-
 kernel/fork.c             |  2 +-
 mm/rmap.c                 | 70 +++++++++++++++++++++--------------------------
 4 files changed, 39 insertions(+), 42 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893f..71fa0596ff6f7 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -551,9 +551,13 @@ static inline bool anon_vma_name_eq(struct anon_vma_name *anon_name1,
 
 void pfnmap_track_ctx_release(struct kref *ref);
 
-static inline void init_tlb_flush_pending(struct mm_struct *mm)
+static inline void mm_init_tlb_flush(struct mm_struct *mm)
 {
 	atomic_set(&mm->tlb_flush_pending, 0);
+#ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
+	atomic_set(&mm->tlb_flush_batch_pending, 0);
+	atomic_set(&mm->tlb_flush_batch_flushed, 0);
+#endif
 }
 
 static inline void inc_tlb_flush_pending(struct mm_struct *mm)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e3..9f51a0ec67451 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1407,7 +1407,8 @@ struct mm_struct {
 		atomic_t tlb_flush_pending;
 #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 		/* See flush_tlb_batched_pending() */
-		atomic_t tlb_flush_batched;
+		atomic_t tlb_flush_batch_pending;
+		atomic_t tlb_flush_batch_flushed;
 #endif
 		struct uprobes_state uprobes_state;
 #ifdef CONFIG_PREEMPT_RT
diff --git a/kernel/fork.c b/kernel/fork.c
index 77d6c8fc38c66..63014f5fef42f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1109,7 +1109,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 	mm_pasid_init(mm);
 	RCU_INIT_POINTER(mm->exe_file, NULL);
 	mmu_notifier_subscriptions_init(mm);
-	init_tlb_flush_pending(mm);
+	mm_init_tlb_flush(mm);
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !defined(CONFIG_SPLIT_PMD_PTLOCKS)
 	mm->pmd_huge_pte = NULL;
 #endif
diff --git a/mm/rmap.c b/mm/rmap.c
index 65646ed6fc453..038435994b99a 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -731,22 +731,12 @@ void try_to_unmap_flush_dirty(void)
 		try_to_unmap_flush();
 }
 
-/*
- * Bits 0-14 of mm->tlb_flush_batched record pending generations.
- * Bits 16-30 of mm->tlb_flush_batched bit record flushed generations.
- */
-#define TLB_FLUSH_BATCH_FLUSHED_SHIFT	16
-#define TLB_FLUSH_BATCH_PENDING_MASK			\
-	((1 << (TLB_FLUSH_BATCH_FLUSHED_SHIFT - 1)) - 1)
-#define TLB_FLUSH_BATCH_PENDING_LARGE			\
-	(TLB_FLUSH_BATCH_PENDING_MASK / 2)
-
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
 		unsigned long start, unsigned long end)
 {
 	struct tlbflush_unmap_batch *tlb_ubc = &current->tlb_ubc;
-	int batch;
 	bool writable = pte_dirty(pteval);
+	unsigned int pending, flushed;
 
 	if (!pte_accessible(mm, pteval))
 		return;
@@ -755,23 +745,21 @@ static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,
 	tlb_ubc->flush_required = true;
 
 	/*
-	 * Ensure compiler does not re-order the setting of tlb_flush_batched
+	 * Ensure compiler does not re-order the pending count update
 	 * before the PTE is cleared.
 	 */
 	barrier();
-	batch = atomic_read(&mm->tlb_flush_batched);
-retry:
-	if ((batch & TLB_FLUSH_BATCH_PENDING_MASK) > TLB_FLUSH_BATCH_PENDING_LARGE) {
-		/*
-		 * Prevent `pending' from catching up with `flushed' because of
-		 * overflow.  Reset `pending' and `flushed' to be 1 and 0 if
-		 * `pending' becomes large.
-		 */
-		if (!atomic_try_cmpxchg(&mm->tlb_flush_batched, &batch, 1))
-			goto retry;
-	} else {
-		atomic_inc(&mm->tlb_flush_batched);
-	}
+	atomic_inc(&mm->tlb_flush_batch_pending);
+
+	/*
+	 * If no flusher ran for a long time, "pending" could wrap around and
+	 * catch up with "flushed". Move "flushed" forward to prevent that.
+	 */
+	pending = atomic_read(&mm->tlb_flush_batch_pending);
+	flushed = atomic_read(&mm->tlb_flush_batch_flushed);
+	if (unlikely(pending - flushed > INT_MAX))
+		/* Pairs with atomic_read_acquire() in flush_tlb_batched_pending() */
+		atomic_set_release(&mm->tlb_flush_batch_flushed, pending - 1);
 
 	/*
 	 * If the PTE was dirty then it's best to assume it's writable. The
@@ -805,25 +793,29 @@ static bool should_defer_flush(struct mm_struct *mm, enum ttu_flags flags)
  * if required. This will cost one additional flush per reclaim cycle paid
  * by the first operation at risk such as mprotect and mumap.
  *
- * This must be called under the PTL so that an access to tlb_flush_batched
- * that is potentially a "reclaim vs mprotect/munmap/etc" race will synchronise
+ * This must be called under the PTL so that an access to the batch counters
+ * that is potentially a "reclaim vs mprotect/munmap/etc" race will synchronize
  * via the PTL.
  */
 void flush_tlb_batched_pending(struct mm_struct *mm)
 {
-	int batch = atomic_read(&mm->tlb_flush_batched);
-	int pending = batch & TLB_FLUSH_BATCH_PENDING_MASK;
-	int flushed = batch >> TLB_FLUSH_BATCH_FLUSHED_SHIFT;
+	/*
+	 * Read flushed before pending. Pairs with atomic_set_release() in
+	 * set_tlb_ubc_flush_pending(), which updates flushed without a flush.
+	 */
+	const int flushed = atomic_read_acquire(&mm->tlb_flush_batch_flushed);
+	const int pending = atomic_read(&mm->tlb_flush_batch_pending);
 
-	if (pending != flushed) {
-		flush_tlb_mm(mm);
-		/*
-		 * If the new TLB flushing is pending during flushing, leave
-		 * mm->tlb_flush_batched as is, to avoid losing flushing.
-		 */
-		atomic_cmpxchg(&mm->tlb_flush_batched, batch,
-			       pending | (pending << TLB_FLUSH_BATCH_FLUSHED_SHIFT));
-	}
+	if (pending == flushed)
+		return;
+
+	flush_tlb_mm(mm);
+	/*
+	 * Only set "flushed" equal to "pending" after flushing the TLB.
+	 * Racing flushers that store an older value can only cause an extra
+	 * flush.
+	 */
+	atomic_set(&mm->tlb_flush_batch_flushed, pending);
 }
 #else
 static void set_tlb_ubc_flush_pending(struct mm_struct *mm, pte_t pteval,

---
base-commit: 1c1815d259fc11f14cfd80f8cc37fc067bf6c69e
change-id: 20261123-rmap-9b4b4cd2f886

Best regards,
--  
David Hildenbrand (Arm) <david@kernel.org>


