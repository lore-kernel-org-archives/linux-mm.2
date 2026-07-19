Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9C4C44512
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 18:55:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54B3E6B008A; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D69B6B009E; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214B56B008A; Sun, 19 Jul 2026 14:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1E466B0093
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 14:55:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08B571405DC
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:26 +0000 (UTC)
X-FDA: 85006429452.07.423EBE7
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8066F20007
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 18:55:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ti12zkcG;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784487324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FgZdTLPY7PuLb4yQ+exzFKyeCVLnL9WHdNDZ74r1sCI=;
	b=K+FUiPljt2fBDXDLnLQnN4cX7jWkvQzBicr64zZwX4fKFGRRFRM4j0aDtovv/fTPcZVdLg
	GAJETg87V0efTMb00fGCAoAIB1u8GYa6gYEchHTXGssZOoi9ZvE8wnIx+5TO7VapqxQt2D
	CjO2XWwAztFbK3NHbiGE3q6/xjYAvHc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ti12zkcG;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of adi.sharma@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=adi.sharma@zohomail.in
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784487324;
	b=BLYawyCZV6TwDNLMGilEWLrF0q3UN8vPJpaHoUgCrW0nfo2Mjt+VAKQZ9sZKCImamJuF2x
	p63S4eg65jAeOvDU4eHpWYZkOvNwNt9JylzVAp6sBAdvy9ALXHjxq8myI7XsbQCPMHz7xs
	FrsDhdPbjby2QJ+ylHVbPypBEzTL508=
ARC-Seal: i=1; a=rsa-sha256; t=1784487285; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=QGfoxSY0NHJRFFFk4MJ9D1OB/xRzPDpysy3mZGzokE97/lbhUbLF77gCFtqzOuZSBiXQteNIsxbM3iIM5hrSSi0Yp0ymhI9sv4scTaXI8I1vvW0kv0BZkRwg4ZAxVWVMa7AOccAPmy6z8T1FRCWBPBkHYOkbbRpxdd8LFO0Lvo4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1784487285; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FgZdTLPY7PuLb4yQ+exzFKyeCVLnL9WHdNDZ74r1sCI=; 
	b=A6yGeJKs8Gq7QoiYlYdtWwmum4OJEXYscvDJLkgU6br3+fb6XS2Tkkwc4aJWn+7pUvWuleZp+1nXKqn1ufZfHfncrHmToUEqJam4vyKAKxMIFR57LVa/ObVcYQVHvrzrHFzIa7JkfqiPRWfPR+5LeK7NafClE8e5NxM7TB14thE=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=adi.sharma@zohomail.in;
	dmarc=pass header.from=<adi.sharma@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784487285;
	s=zoho; d=zohomail.in; i=adi.sharma@zohomail.in;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=FgZdTLPY7PuLb4yQ+exzFKyeCVLnL9WHdNDZ74r1sCI=;
	b=ti12zkcGnBfLTBw9fHFNt9PB2IhRRcjLzCwdqRQEYBhvAlUGAO71teK3pE48YoGT
	qIfK5gTDP/uPH/+O9mqXHPD0yPt7ZL4KfWQ/syFSmtMUfHc5ZEWp8W5hHTE/DU07xAl
	ybvePEbyoPFa6kwl3iFBOoTaVc6PbMNrHZccOmy0=
Received: by mx.zoho.in with SMTPS id 1784487283605355.28475880973383;
	Mon, 20 Jul 2026 00:24:43 +0530 (IST)
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
Subject: [RFC PATCH 4/7] mm: gate async teardown on RSS with pending-pages backpressure
Date: Mon, 20 Jul 2026 00:24:06 +0530
Message-Id: <20260719185409.409685-5-adi.sharma@zohomail.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8066F20007
X-Stat-Signature: ey7mn35a8jya8hcyrbmah6rb9qygfpfq
X-Rspam-User: 
X-HE-Tag: 1784487323-434835
X-HE-Meta: U2FsdGVkX1/XakkfKQOhbW+9n6eWTQNGgRHSri8vVvbKTHAyYoYjbNERoqqb9tFFQzQO5BM9OudF/ZZidLTVmfF/MZ3O2jnVQC/2Fj77Xz0XV34dmK566t5VHuZBNBtG25grT5Dvxsiy0TNnziOAF95ze4YCAqMrG85D0do71CrFQPKGGZOU1SOpOwiqw+5o4I+QePw92iThmIiK/jggB4jAg63CCo3UL4Mw6OmjRhXx3WaB0j27pmh0LC+hP6gisHGQIRVmXljYld1Xkr1QEHX7g1WD6a00NQJVFBO+Hz4ggAJMxu/S0MVWhTZCXJyBWIiVH0j311FNDQgOCwBeK9Tj9kyRb9lskWm9TQIIFzDCpbsnbLVZpdOre92+UxJ86HWlJmN0uJT8JLhAa1rsIZhCjZtXPsEoi4kKZX4O8n1h1jh3/xs3uh8NFih/Fyw/XarEa/Hv2afJfMz3oyVgMfAW4GyRtG/eeM1YxqlvCrzuenMNwKNrjiwySBPJ2E2uTMdl6KMKytwEQLKrUQ59Ecde0Mst9YBvSVBrAOTwfeKTt7WO7yPx11nv2Ixmc8ddC5VyCfuekXtKDhtepG4hSngQqSvsJuGTidLdAWX+AjzG0E7z2xWqXQNyNAkn/1T5HUkzAgwSpghFyLEp0/61xvKVq/aw4wbmjkF8GWNjKfD0vU4/V/VjlFIQ4pt5M2RkTumuDx0fDoRNwT5g/pqnecVtf7Hvw7p7m9xbFwJ7Yghm1rlraiamB75VUClKiIdtvrpoCbTf94hK+ZirTr5nv3oGXgJu41tNdtg6D/3CzeTBW0IInI6fUOIBmozv/cAJ/lxvpPNUpcHelSXliSaZBk+3I//ppLjBkBV4gVoIm7h02elIm8Eu3NpW8hqdkLwedWy+AtIbMdOEPejvUNua86blJU5wh2t2O8uKL4UsNr+bWODX0OoxIdgvCXHESHx4VWTKTiQq6DBcGzXp1aa
 3g2ob9El
 a1Mj0jPYIiYXiYvcr/GGKjoyGfkcD+2Lq9uB8haRYbeY7a5eriOdER+97tNwxU7zPkdKfmWEn/asEk3xmxvK439WRFL6ivjxaZwTyqEjrSKKUlyjakznSrEqbuPmWjr4dyZeU2EVMAmQgiDrdTCIiaonm+bhoqmSLeVEovVdBXP/qTGNtAn3h7G/8w5F8GPCGxhN/hJ8YBt+SYoS5nOT16wkLl8YmWSPLXQcyM8UHPDeY1+yRlk0M/YjluRZ2ozzU6pnv8HswNicxFPhOI9Dta5HcmxdnCd83X0B+qSefg2XbE5EM/RG5+m2NL+JD1jlyZwcg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Deferring every exit would churn small processes for no benefit and let
unreaped memory grow without bound. Split the defer decision into a
pure predicate and a budget reservation:

  - async_mm_teardown_eligible() (side-effect free): defer only when
    RSS >= async_mm_teardown_thresh_pages and both MMF_OOM_SKIP and
    MMF_OOM_TARGETED are clear:
      * MMF_OOM_SKIP -- the mm is hidden from the OOM killer and
        reaper. Usually that means it has already been reaped or run
        through exit_mmap() and has no RSS left worth deferring; in the
        mm-pinned-by-init case (__oom_kill_process()) the flag is set at
        kill time with RSS intact, and keeping such an mm synchronous is
        equally what we want;
      * MMF_OOM_TARGETED -- the mm is the target of an in-flight OOM
        kill (added in the preceding patch). Such a victim is torn
        down synchronously so its memory is released promptly rather
        than queued behind the low-priority, housekeeping-confined
        mm_reaper, which would work against the oom_reaper during the
        exact pressure that triggered the kill. The flag is set while
        some task still holds a live reference to the mm, and this
        check is reached only after mm_users has dropped to 0 -- which
        requires that task's own exit_mm() (or exec_mmap(), the other
        path that sheds ->mm) to have already cleared ->mm under that
        same task_lock() -- so marking and checking can never overlap in
        time. Whichever thread performs the final decrement is therefore
        guaranteed to observe the flag already set, per the preceding
        patch.

  - async_mm_teardown_reserve(): charge RSS against a pending-pages
    budget with atomic_long_add_return(); if the result exceeds
    async_mm_teardown_max_pending_pages it subtracts back and returns
    false, so the caller falls back to synchronous __mmput().

mmput_exit() reads RSS once and checks eligibility before reservation,
so the budget is only touched for processes that pass the cheap
checks. On success it stores the charged amount in mm->async_reap_node's
companion field async_reap_rss before enqueueing, and the reaper
releases exactly that stored charge after __mmput(). The charge cannot
be re-derived at reap time: RSS keeps shrinking after mm_users reaches
zero -- rmap-based reclaim can still swap out anon pages and truncation
can still unmap file pages, neither of which requires mm_users -- and
get_mm_rss() is an approximate per-CPU counter read besides. Two
independent reads at enqueue and reap would systematically
under-release, drifting the pending counter upward until the cap
permanently forces synchronous fallback.

An eligible mm would otherwise have its entire __mmput() -- including
exit_aio() -- deferred onto the single mm_reaper kthread.
exit_aio() can block indefinitely waiting for in-flight AIO to drain,
so mmput_exit() calls it eagerly, on the exiting task's own context,
before reservation: a stuck AIO context then only stalls this task,
same as a synchronous mmput() would, instead of blocking mm_reaper and
stranding every other mm already queued behind it. exit_aio() is
idempotent -- it is a no-op once mm->ioctx_table has been torn down --
so __mmput() calling it again unconditionally is harmless, whether that
second call lands on the reaper or -- when the reservation fails --
back on the exiting task itself.

Because reservation is add-then-check rather than read-then-add,
committed pending never stays above the cap: an exit that would exceed
it tears down synchronously instead. Under concurrent exits a failing
reservation can transiently inflate the counter between its add and
roll-back, which may cause another exiter to fall back to sync
conservatively -- it can over-reject but never over-admit.

The cap is a coarse safety bound on unreaped memory, not a reclaim
mechanism: pages queued here are invisible to reclaim until the reaper
frees them. Integrating the queue with reclaim (unmap-first draining,
a shrinker) is future work; see the cover letter.

The RSS threshold defaults to a fixed 64MB at init; the pending cap
defaults to totalram_pages() / 4 as a placeholder pending tuning. Both
are static module variables here and not yet user-tunable. The static
key that gates the whole path, and sysctl registration, follow in the
next patch.

This patch is dormant: nothing calls mmput_exit() yet (exit_mm() is
routed to it later in the series), so no teardown is deferred.

Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>
---
 include/linux/mm_types.h |  1 +
 kernel/fork.c            | 79 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3240c029f..ee6c0ac84 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1370,6 +1370,7 @@ struct mm_struct {
 		struct work_struct async_put_work;
 #ifdef CONFIG_ASYNC_MM_TEARDOWN
 		struct llist_node async_reap_node;
+		unsigned long async_reap_rss;
 #endif /* CONFIG_ASYNC_MM_TEARDOWN */
 
 #ifdef CONFIG_IOMMU_MM_DATA
diff --git a/kernel/fork.c b/kernel/fork.c
index 884e4e767..d45418e66 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -113,6 +113,7 @@
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
 #include <linux/sched/isolation.h>
+#include <linux/sizes.h>
 
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
@@ -3412,6 +3413,48 @@ subsys_initcall(init_fork_sysctl);
 #ifdef CONFIG_ASYNC_MM_TEARDOWN
 static LLIST_HEAD(mm_reaper_list);
 static DECLARE_WAIT_QUEUE_HEAD(mm_reaper_wait);
+static atomic_long_t mm_reaper_pending_pages;
+static unsigned long sysctl_async_mm_teardown_thresh_pages;
+static unsigned long sysctl_async_mm_teardown_max_pending_pages;
+
+static bool async_mm_teardown_eligible(struct mm_struct *mm, unsigned long rss)
+{
+	if (rss < READ_ONCE(sysctl_async_mm_teardown_thresh_pages))
+		return false;
+	if (mm_flags_test(MMF_OOM_SKIP, mm))	/* reaped, or hidden from the reaper */
+		return false;
+	/*
+	 * MMF_OOM_TARGETED is set by the OOM killer while some task still
+	 * holds a live reference to this mm (see mark_oom_victim() and
+	 * __oom_kill_process()), and this eligibility check is reached only
+	 * from mmput_exit(), after mm_users has dropped to 0 -- so marking
+	 * and this check can never overlap in time. Whichever thread
+	 * performs the final decrement is therefore guaranteed to observe
+	 * the flag already set, regardless of whether that thread was
+	 * itself ever passed to mark_oom_victim() (a CLONE_VM-sharing
+	 * process in another thread group never is, but still observes
+	 * this flag on the shared mm).
+	 */
+	if (mm_flags_test(MMF_OOM_TARGETED, mm))
+		return false;
+	return true;
+}
+
+/*
+ * Charge rss against the pending-teardown budget.  Returns true if it fits
+ * under the cap, in which case the caller enqueues and the reaper releases
+ * the same rss after __mmput().  On overshoot nothing stays charged and the
+ * caller must tear down synchronously.
+ */
+static bool async_mm_teardown_reserve(unsigned long rss)
+{
+	if (atomic_long_add_return(rss, &mm_reaper_pending_pages) >
+	    READ_ONCE(sysctl_async_mm_teardown_max_pending_pages)) {
+		atomic_long_sub(rss, &mm_reaper_pending_pages);
+		return false;
+	}
+	return true;
+}
 
 static void async_mm_teardown_queue(struct mm_struct *mm)
 {
@@ -3429,7 +3472,10 @@ static int mm_reaper(void *unused)
 		wait_event_freezable(mm_reaper_wait, !llist_empty(&mm_reaper_list));
 		batch = llist_del_all(&mm_reaper_list);
 		llist_for_each_entry_safe(mm, n, batch, async_reap_node) {
+			unsigned long pages = mm->async_reap_rss;
+
 			__mmput(mm); /* may free mm via mmdrop */
+			atomic_long_sub(pages, &mm_reaper_pending_pages);
 			cond_resched();
 			try_to_freeze();
 		}
@@ -3439,10 +3485,38 @@ static int mm_reaper(void *unused)
 
 void mmput_exit(struct mm_struct *mm)
 {
+	unsigned long rss;
+
 	might_sleep();
+	/*
+	 * Fully ordered RMW: combined with exit_mm() (or exec_mmap(), the
+	 * other path that sheds ->mm) clearing ->mm under task_lock() before
+	 * this call, it guarantees MMF_OOM_TARGETED set at any mark site is
+	 * visible here -- see mark_oom_victim(). Any new caller of
+	 * mmput_exit() outside exit_mm() must re-verify that argument.
+	 */
 	if (!atomic_dec_and_test(&mm->mm_users))
 		return;
-	async_mm_teardown_queue(mm);
+
+	rss = get_mm_rss(mm);
+
+	if (async_mm_teardown_eligible(mm, rss)) {
+		/*
+		 * exit_aio() can block indefinitely. Run it here so a stuck
+		 * AIO only hangs this task (same as how it would happen in
+		 * case of synchronous mmput()) instead of stranding every
+		 * teardown queued behind this mm
+		 */
+		exit_aio(mm);
+
+		if (async_mm_teardown_reserve(rss)) {
+			mm->async_reap_rss = rss;
+			async_mm_teardown_queue(mm);
+			return;
+		}
+	}
+
+	__mmput(mm);
 }
 
 static int __init mm_reaper_init(void)
@@ -3456,7 +3530,10 @@ static int __init mm_reaper_init(void)
 	}
 	set_user_nice(th, 19); /* minimize competition with other fair class tasks */
 	kthread_affine_preferred(th, housekeeping_cpumask(HK_TYPE_KTHREAD));
+	sysctl_async_mm_teardown_thresh_pages      = SZ_64M >> PAGE_SHIFT;
+	sysctl_async_mm_teardown_max_pending_pages = totalram_pages() / 4;  /* TODO: placeholder */
 	wake_up_process(th);
+
 	return 0;
 }
 subsys_initcall(mm_reaper_init);
-- 
2.34.1


