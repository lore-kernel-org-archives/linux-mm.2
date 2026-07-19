Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95DECC44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60396B0096; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BB66B009B; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2AD6B0096; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55346B0095
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2CD85A0E30
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:26 +0000 (UTC)
X-FDA: 85006429452.15.B640F7A
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf16.hostedemail.com (Postfix) with ESMTP id 87EFF180008
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="K1//Kb3N";
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=CnfRdL4HX/R16TCtD5Fvht/matqHUHOBkbpC86AKGIaR7CdnH5IQZQKsVgQw37PUysoqS2
	WFMkycgx1F6TTRWzZe+rPy4B42XEKHaEgpdaKwaBnV06cBh8OyIR/VGKlyp8hnUWM/wq9j
	Hq7a+PUBbYfeV+gIQXofM3EV0Fq3UGY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b="K1//Kb3N";
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvpCD42RtrpG9qRaXZM07VjGfK7+/4ydMfeXZD1P/yA=;
	b=OSLyqElhDGgaYFDgex9CKZH1To1xfbHBTV+KXgfPkGbKxI9qplkklGBdlVN/flGXiAVEj0
	rdJu7FpjdrE0R309EYluY2gQsUz+PJesi87CcTIW/lTSXZzJJ6s/BVRj4K3KwyCiZgTz5t
	CbD3HQ7KcQWHz/B1nW17L3ID7Mg4KJg=
ARC-Seal: i=1; a=rsa-sha256; t=1784487283; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=YAoNz96vR2exNu7ryJumatDIvUlceHraaIe2VjWA1qn5AOm0SSW1L6zOEjjn+5x1ziMoy2mNV8xodHKvJP/vXRUsGuPxJ5sf774OYJIPWgGI+1GYyCLELWqVgmO6XdBVlr2LtWOTLIw+qyl/P0IQstdhCyBHj+R0uoYKJobwJvg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487283; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dvpCD42RtrpG9qRaXZM07VjGfK7+/4ydMfeXZD1P/yA=; 
	b=KmgtdkokWN+PeUA55Bn4lNzR81kn0pTxoAzDD+ItjstForqxmVIIFA/JS+BbtZTk7XbwcDfacr4FE+id4q/7Dv1fpsvOPu/Oc1dk7luKpzbCdtN3SN+HALogke5tVKKGBg/2yDxW9HVHdlyl27R5FX48QJEgJ/JzqVfVxrBC0ms=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487283;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=dvpCD42RtrpG9qRaXZM07VjGfK7+/4ydMfeXZD1P/yA=;
	b=K1//Kb3NX+WsfCNSoYvhbrab8aFMLVW4+UqIamzfwUvmbRjd2asQh4LC/IZ6O4Su
	HEgpLiuqlGhoSiOaraF4MebSm+LXFDr1CQzO2aQDtG8X0Hbx7pPMXx/Jj8UvoKWzLY8
	monoVJxYxvEDkIWKcAZrcAfG4Dm0tDpXQJ46795w=
Received: by mx.zoho.in with SMTPS id 1784487282148903.7584683853768;
	Mon, 20 Jul 2026 00:24:42 +0530 (IST)
From: Aditya Sharma <adi.sharma@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	imbrenda@linux.ibm.com,
	Aditya Sharma <adi.sharma@zohomail.in>
Subject: [RFC PATCH 3/7] mm/oom_kill: mark an OOM victim's mm with MMF_OOM_TARGETED
Date: Mon, 20 Jul 2026 00:24:05 +0530
Message-Id: <20260719185409.409685-4-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 87EFF180008
X-Rspam-User: 
X-Stat-Signature: tsxrbi1id6x6kzerk99hq3ixs1zqftp1
X-Rspamd-Server: rspam03
X-HE-Tag: 1784487323-822865
X-HE-Meta: U2FsdGVkX19/+wnC+HOAf/fbLiZEjt+astnuuXkN6L78TbuN2daK7XuhfU2C3FBmjsnajE42HjBMBA4wh/DujNBwf5A+p6sTfWcblzRxARyw/GA4HE1dusvPPFNwtV1b8v9kv1ECfUlv7Uyq2/saNEVgi7/TqGFYRbfnRd9zuHp5dlfmtg56ZtEoQoQB78v4ARVEjuJnn1RaV5oQWYZXl0G8PURRa/70UEhiAVMnN31sE3JaSyOjlDOhDEIFYPwEt60h54IY/YG/ihkE9DWps6dI3w/KAG7H3+5p3LUQ+1/OhMcdP1djHNbDDe8SvP+Kkc4CSko4J8Yli7luSOuZGiBE3Fa2rUDpK4EKz5ZuSdY/jnED0xoKsdeDG3OQ47JW/YWDtKecMJ32ErcG+9tXz12KnQbpr8DVUj3FtaaG0tOfJFoU+u7VbdYKlVtp5UmP45liR/wHHE2I3VxuP9G1JjeOh8DC5akhoFHI832M/agH78OvPcxaFzdQIkiv5rON82ojS81x7DOludytu5rlvu/d6I/18S69HfrEB3sQHnbWSBczfC93wG0AvUEiqCyX1W8h/S8scgRsaOMpfuMSoQ2gh+WNdL1dKenx3RkiREkvTzLTzKGl8LbmiM62eQLv1cAVQddd/wUEqKZOe6XNk5YIFlcr7aMd91rimAG8zA7HAh5ToA9zjYizsh5AnsPcdBX1xRqsCKMmPOTgiI/Pev5OgN2VVKjA41Zo9pwOn0/PRz7Y/dNhjvV0EQvF1qy/Lq75dJMMP1QBHF4/Gvcesz//L7/C0sjzXtez2qQIE7N3RwZnhdqwKLFfLsz0nCYI4Cwn416dAH98RFS3bbDN47HKSw9ppTiUT9FmSY+/aVcvX2eYPy3MeqwWzYDLof5T3CxccIwT0nmlr2aj6wtNuBgQ0idTe1fxWJv2hXo1bIxzuJAJI5qia4bA+vEOQIPpS0RNf31ZKOIydVSEbQM
 I4dvaa2U
 RBuYYsewBkIMEDJ5Jz8t4TbRctCPohDg/1JOytiOEe/rADWJJMKTiZ1Qk0uVDXgdn0swCLDYijnxx+ZIpPbIsmO1uiT4cfhQx8eW1LE3hctgYWu3PdfJ+WF48NfFYKGqpx0cvz+l8n0fWdWxtonH1dtvX64cdZG1iyu+24yYr6KTdeTIVYjWB2tDfaJ18b02Ufqf+V4cNUSgBuvQALyaAKrndYRpTFuXz34ql+zgLGi101LDe12gE9AeyLEMnxbO35XlACy9CRGH7LWJ6bwSOoxGdNx0yWAriOzDkvlHkWVlxibKxPw8i6fErYuFuqetxS+ClLy0kb9bBjMbETQi8yd4u2qnBWOsZWtOqKa7j+DY1gF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later part of this series defers the address-space teardown of large
exiting processes to a kernel thread (mm_reaper) instead of running it
inline on the exiting CPU. That deferral must never be applied to an
OOM victim: its memory has to be released promptly to relieve the
pressure that triggered the kill, and queuing it behind the
low-priority, housekeeping-CPU-confined mm_reaper would work directly
against the oom_reaper. The teardown path therefore needs a cheap
"is this mm an OOM victim?" test.

The eventual consumer runs from mmput_exit() on the exit path, after
exit_mm() has already cleared current->mm, so the only handle it has
is the mm pointer itself. Existing OOM state does not answer the
question well from an mm alone:

  - signal->oom_mm and TIF_MEMDIE are per-task / per-signal and are
    set only on the single task passed to mark_oom_victim(). A sibling
    thread, or a CLONE_VM-sharing process in another thread group
    (which __oom_kill_process() SIGKILLs but never marks), can be the
    task that drops the last mm_users reference and runs the teardown.
    A per-task check misses those.

  - MMF_OOM_SKIP is mm-scoped but does not mean "OOM victim".
    exit_mmap() sets it on every exiting mm once the memory is freed,
    and dup_mmap() sets it on the fork-failure cleanup path, so it
    produces false positives on ordinary exits. It is also not reliably
    early: on a real victim it is normally set only once exit_mmap() or
    oom_reap_task_mm() has already released the memory -- the exception
    being the mm-pinned-by-init case in __oom_kill_process(), which sets
    it at kill time with RSS fully intact. Wrong in both directions, so
    it cannot serve as the predicate this path needs.

Add MMF_OOM_TARGETED, an mm-scoped flag, and set it in two places:

  - in mark_oom_victim(), covering every caller uniformly (this is
    the only marking for the two task_will_free_mem() fast paths in
    oom_kill_process() and out_of_memory());

  - early in __oom_kill_process(), before any SIGKILL for the kill
    event is dispatched, to victim's own thread group or to other
    thread groups sharing the mm.

Observing this flag is not load-bearing for correctness. Should it
ever be missed, the consequence is bounded: the victim's mm is queued
to mm_reaper instead of being torn down inline, i.e. a latency and
priority-inversion regression against the oom_reaper -- not
corruption, use-after-free or a leak. The mm is still fully torn down
and the oom_reaper still reaps the victim independently. The
visibility argument below is therefore belt-and-suspenders.

Ordering and coverage: this flag is reliably visible to whichever
thread ends up dropping the last reference in mmput_exit(), because
marking and queuing for async teardown can never overlap in time.
Every mark site runs while some task's ->mm still points at this mm --
either tsk is current, marking itself in program order (the
task_will_free_mem() fast paths), or tsk is task_lock()ed by the
caller (oom_kill_process()'s fast path, and __oom_kill_process() via
find_lock_task_mm()) -- while mmput_exit(), the only path that queues
for teardown, is reached only after mm_users hits 0, which requires
that same task's own exit_mm() (or exec_mmap(), the other path that
sheds ->mm) to have already cleared ->mm under that same task_lock().
Program order, or task_lock() release/acquire, therefore orders the
flag store before that task's own eventual mmput_exit(). This is stated
for userspace tasks: any userspace task's ->mm holds an mm_users
reference, whereas kthread_use_mm() borrows an mm under mmgrab() alone
-- kthreads are not signal-killable and are never OOM victims, so the
borrowed-mm case does not arise here.

If a different CLONE_VM sharer in another thread group performs the
actual final decrement instead -- a task mark_oom_victim() never marks
directly -- the ordering still carries, though not from the flag store
itself. mm_flags_set() is set_bit(), a non-value-returning RMW, so it
is unordered and contributes nothing on its own. The ordering comes
from the marking task's own atomic_dec_and_test(), a value-returning
RMW and therefore fully ordered (Documentation/atomic_t.txt: an
smp_mb() before and after). Decrements are totally ordered in
mm_users' modification order with the zeroing one last, so the general
barriers on both sides make the flag store visible to whichever thread
performs it.

The redundant set in mark_oom_victim() on the __oom_kill_process()
path is harmless and keeps the invariant "mark_oom_victim() implies
MMF_OOM_TARGETED" independent of future code motion.

The flag is intentionally sticky: it is never cleared. That is fine
because a marked mm is dying: __oom_kill_process() SIGKILLs every
process sharing the victim's mm -- only global init (whose mm also
gets MMF_OOM_SKIP set on the spot, keeping it off the async path
anyway) and kthreads are exempt from the sweep, and a kthread's
kthread_unuse_mm() drop is a plain mmput(), never mmput_exit(). So
no task that could reach the async path survives owning a marked mm.
Should some future path leave a survivor, the consequence is only
conservative: that mm keeps tearing down synchronously. The flag is
structurally outside legacy-mask inheritance: mm_init() clears the
whole flags bitmap and re-seeds only word 0 from
MMF_INIT_LEGACY_MASK, so flags above bit 31 are never copied on
fork(). NUM_MM_FLAG_BITS is a fixed 64 on all architectures, so bit 32
exists on 32-bit builds as well.

This commit only defines and sets the flag; nothing reads it yet. The
write is gated by IS_ENABLED(CONFIG_ASYNC_MM_TEARDOWN) and compiles
out entirely on kernels that will not consume it. The reader
(async_mm_teardown_eligible()) is added in the next patch, and the
deferred teardown is not routed onto the exit path until later in the
series, so this change is inert on its own.

Note: a bit named MMF_OOM_VICTIM existed until 2022 and was removed
as dead state once exit_mmap()'s special-case reap-before-teardown
was replaced by mmap_lock/MMF_OOM_SKIP-based concurrency between
exit_mmap() and oom_reap_task_mm(). MMF_OOM_TARGETED is a
deliberately distinct name for a new consumer -- deferred exit-path
teardown -- and does not revive the old exit_mmap() behaviour.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 include/linux/mm_types.h | 10 +++++++
 mm/oom_kill.c            | 61 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index fffa285ef..3240c029f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1989,6 +1989,16 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+/*
+ * mm is the target of an in-flight OOM kill. Only written under
+ * CONFIG_ASYNC_MM_TEARDOWN today. Sticky: never cleared -- the mm is
+ * dying (__oom_kill_process() kills every process sharing it), and a
+ * hypothetical surviving sharer would merely keep tearing down
+ * synchronously. Above bit 31, so it is outside MMF_INIT_LEGACY_MASK's
+ * domain entirely and is never inherited on fork.
+ */
+#define MMF_OOM_TARGETED	32
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e2..b5490d1b1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -754,6 +754,40 @@ static void mark_oom_victim(struct task_struct *tsk)
 	struct mm_struct *mm = tsk->mm;
 
 	WARN_ON(oom_killer_disabled);
+
+	/*
+	 * Mark the mm itself, not just this task/signal, as an OOM target,
+	 * so the deferred-teardown path can test it from the mm alone. Set
+	 * ahead of the TIF_MEMDIE test-and-set below so that every call
+	 * marks the mm, including a repeat mark on a task that is already
+	 * TIF_MEMDIE.
+	 *
+	 * This is reliably visible to whichever thread ends up dropping the
+	 * last reference in mmput_exit(): marking and queuing for async
+	 * teardown can never overlap in time. Every caller reaches this with
+	 * tsk->mm still set -- either tsk is current, marking itself in
+	 * program order, or tsk is task_lock()ed by the caller (the
+	 * task_will_free_mem() fast path in oom_kill_process()) -- while
+	 * mmput_exit(), the only path that queues for teardown, is reached
+	 * only after mm_users hits 0, which requires tsk's own exit_mm() (or
+	 * exec_mmap(), the other path that sheds ->mm) to have already
+	 * cleared ->mm under that same task_lock(). Program order or
+	 * task_lock() release/acquire therefore orders this store before
+	 * tsk's own eventual mmput_exit().
+	 *
+	 * If a different CLONE_VM sharer performs the actual final decrement
+	 * instead, the ordering does not come from this store:
+	 * mm_flags_set() is set_bit(), a non-value-returning RMW, so it is
+	 * unordered and contributes nothing on its own. It comes from the
+	 * marking task's own atomic_dec_and_test(), a value-returning RMW
+	 * and therefore fully ordered (an smp_mb() before and after).
+	 * Decrements are totally ordered in mm_users' modification order
+	 * with the zeroing one last, so the general barriers on both sides
+	 * make this store visible to whichever thread performs it.
+	 */
+	if (IS_ENABLED(CONFIG_ASYNC_MM_TEARDOWN))
+		mm_flags_set(MMF_OOM_TARGETED, mm);
+
 	/* OOM killer might race with memcg OOM */
 	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
 		return;
@@ -931,6 +965,33 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	mm = victim->mm;
 	mmgrab(mm);
 
+	/*
+	 * Set this before any SIGKILL for this kill event goes out below,
+	 * while task_lock(victim) (held since find_lock_task_mm() above) is
+	 * still held. This is reliably visible to whichever thread ends up
+	 * running mmput_exit() and dropping the last reference to this mm --
+	 * victim itself, a sibling, or a CLONE_VM sharer in another thread
+	 * group (which mark_oom_victim() never marks, but which still
+	 * observes this store on the shared mm). Marking and queuing for
+	 * async teardown can never overlap: mmput_exit() is reached only
+	 * after mm_users hits 0, and that requires victim's own exit_mm()
+	 * (or exec_mmap(), the other path that sheds ->mm) to have cleared
+	 * ->mm under this same task_lock() first, which release/acquire
+	 * orders after the store above.
+	 *
+	 * If some other sharer performs the actual final decrement instead,
+	 * the ordering does not come from this store: mm_flags_set() is
+	 * set_bit(), a non-value-returning RMW, so it is unordered and
+	 * contributes nothing on its own. It comes from the marking task's
+	 * own atomic_dec_and_test(), a value-returning RMW and therefore
+	 * fully ordered (an smp_mb() before and after). Decrements are
+	 * totally ordered in mm_users' modification order with the zeroing
+	 * one last, so the general barriers on both sides make this store
+	 * visible to whichever thread performs it.
+	 */
+	if (IS_ENABLED(CONFIG_ASYNC_MM_TEARDOWN))
+		mm_flags_set(MMF_OOM_TARGETED, mm);
+
 	/* Raise event before sending signal: task reaper must see this */
 	count_vm_event(OOM_KILL);
 	memcg_memory_event_mm(mm, MEMCG_OOM_KILL);
-- 
2.34.1


