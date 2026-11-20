Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A13606A6A3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cvq+iK6Q
Received: by kanga.kvack.org (Postfix)
	id E9CAB6B05BB; Fri, 20 Nov 2026 17:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4D566B05BC; Fri, 20 Nov 2026 17:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3D0B6B05BD; Fri, 20 Nov 2026 17:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD3086B05BB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:48:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 369961A0206
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:48:03 +0000 (UTC)
X-FDA: 85456986846.10.EB08AB0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8E6541C0006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:48:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvq+iK6Q;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795214881;
	b=RlCdv/oO0rzSdmFdbNFW3pbF2IhJGJH3X7OyOicDxhAPE3DF3/ieHlNMkdbn1xpmk6xPFe
	RemIFf0ZcFzzljExN0j751iEkQeg2P7uUl+yvR1gpUa8lFxkgr00g/kdk64Gfg9rrnLTPu
	FavHp60mSVN2kBhn6BfxpaqX5eBY3GE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795214881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2/DnoLd1laDsESHwuJ8oDndRsaqFJiYak80FH3k99hI=;
	b=3mjZlaE8oAwO3ENDvV3GSf7PzeVoxfSAIJIh/DWYfDh0iF6CaWgBOU3be7d2zXRC/+yeC0
	B5VHn0NZ3YeR5l/jLhFkFvUEpXC+XvU39CMdCI45Fy21YHY9WOKtwWF7jLDOtPlbiFg8o7
	JKkMa/6C5mUN4nH4yH3/jg231dBFOe4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cvq+iK6Q;
	spf=pass (imf21.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795214881; x=1826750881;
  h=subject:to:cc:from:date:message-id;
  bh=9bVzioXZw7USSiIfTjHk3w5r1BhOeDv0Es4/WoxyQTk=;
  b=cvq+iK6QWi/nUY/pc5SHOEZV+UUa7A9o1F/bM8zij0E/X4iD0QxC3PzD
   v+SycA8SKfndMMZf/ZnnIIuzFYCKHFh3nd+c8VnQ4Vgytmhcmc8sLEs1G
   SDA1VbzT+zbUfdSsSq0npGUyTKZ0qZDcx7sGRbP1oUQ9SSjJ2jpjQKw+o
   jcGi1yxSWlyhOAPHo0U17cQ9W1SVfUbq/ZvpZlUx6PuBtZPU3yZAxCbhT
   PjbZfzBlRYl+Yy8+fBPVvpwstYjwHpdH6YG4lJZrMH8zeFLj2pkwTGn1c
   pZ0nFX11GWyE/uWa7sCKGyGYNh0gLkalTa4pLLWBBwA0bbuhB/LafJim6
   A==;
X-CSE-ConnectionGUID: KNBhRdQHSky03/s/rwhdIg==
X-CSE-MsgGUID: 6dRdEgDATU6i7sN1wz1Ojg==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4093872"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="4093872"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 14:48:00 -0800
X-CSE-ConnectionGUID: 53pvTRDATiCws4Dlp6vfiQ==
X-CSE-MsgGUID: 6iMRYmjJQhGysHkWXSsGxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="11152071"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa009.fm.intel.com with ESMTP; 20 Nov 2026 14:47:59 -0800
Subject: [PATCH] smp: Add memory barrier before many-CPU IPIs
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, David Hildenbrand <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Liam R. Howlett" <liam@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@surriel.com>, Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, x86@kernel.org
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Fri, 20 Nov 2026 14:47:58 -0800
Message-Id: <20261120224758.04F70CD8@davehans-spike.ostc.intel.com>
X-Rspam-User:
X-Rspamd-Queue-Id: 8E6541C0006
X-Stat-Signature: u4wmdads97fttue43n6qjcz67kda61po
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795214880-844144
X-HE-Meta: U2FsdGVkX19Pt++kqrmF0mIMCuPQmV1ecD7Y3O2TkNCXdWfZIsr1JhBAbfSWyuovrxwfnihQXlVDksrH60NcRwCZAZpOqGnzmeBHKQyNMrvCTtuE/v/tdibEhh7Apbw0OeXwX04hbDXCNSxkThm37b4sW2SlYrpzOJs6LSVDvmm20Uoa4Z1HT8p+s23J6cZTBQjY2cq0IPd8Xj9oYmWbTCyAdTjuO3AmqzgCcw4fIdxKhWWHRHW+da1ksG9Pf6DETjBbs7SxjCODkTTp2I2vjwxCIdwGA9hrljr4wzEo/prYW3nt/3pXJNzFNTUJp2yEv6guoOlk8tQRzTRO0Mp3ddK5AbHFcGXKTW7An3+3BTM/Gj4pwofPjhXQPCIvRLnZod1V46uQWQ2SjY/iz9S44MQl5nZVKzuV9U5flgyK7n43oaT0V8MEZcOM/YbwIYroJQ99gvzTXEkbt/e4bVS20H476HsgruSLTJBvzPUsvjH2je/OQY8J+lDd4puAgq49YA7htYmTYb/+WYN62CqfGuI8fSxHIle5ct43akq19p81vSyqVOPLBN+KOItXXF31l2ybAhFIDk/hm9OpHDHIor3o1fcgNi8jYKaYmfFQk1jjfkiV3Xjr74dZopfi7A+9mVUpI/kiPPj2nC+g954P4AFroXpzdGMf/P6wN8ydeyklIcUgdzYYkkJhx1GQri0bNqUnzuxwf6FrEMuzj0zwTr8vQMDDFFb1paBGugLg/ztNMBPYf/pOrc3g8sAX1c1reiLp7Ka8LLVYxoyL+CPzQgXrRxxnMsG94R8BoyVeQHXSO/j67KIgXeGwSVHocKrHUS4/oEPvQ6hxRQNBZk+KIUEVttWT+lBMrhHEMswF3QICSF3IHKqqy4yCSPXnqvYurfGmUvx2chAnfqlka3bOdQRj+pzEee4dmFQq5GLu/xnBDMnQsg7bUnh2IPC8DJ5NRqfcqJp0rjVFVK+V1d7
 ItJxcXQk
 ZvwaAX4SGbHEi7TbHH9nYVDfy2TlH4BYnQgk/cu5f0rCqYI95FZyaiTVVykBwDKmjyDKb92Keg33htdJj4MbD6rmT9OJuwcJwQvT9bg/wV7oRN99V0mkML/BTdexpXJIdrpCXOE3so5a9Aw2qjVB9yMPV3mnAqcyLHclTjQ/ERAFIdJdPm/VABYM3Pz7JXlsqGgEfyA4eOWs54kyEb0zZXuqelCs9dPrrTJdTP/yq6zgqvHL1Ey3jZJsdTHsTbOVAglanRP4qsJtL8XkndGPfHknxxEKn6mNDnFw2bFQe8HHemEd3/ges4IyJJDjaOKxhOWSeJQcMtXN5mhlqF3zCT4o14xbIUTGHzVdlUwYCdy1MflYSH4/v4iw77JJKw8U+feQXBRV9DLywGSsdMb8DLhzv19LIV+NL7w54O88gqXSrWdXovWh3n+FdtYjbmehB5QOFVd6SLdX2EK6Q8ZeTgkS63UlNCcAyqBOPL5nDwDdZNBT12f5C92xFL5mk7WD63EiwVbF1DRiEdmZBoG1eOva4ISIK/OnWSSJyW8ctFrtYNCJcdUnS1phGspOh8o7ywF2iPkpzd1pnzNZFts13JZxXKlP7tu2qz7FKvktJL8U7n1r16cun0vrDWXTLs5XkGvQYje7gdP/wY14YDWYnmzxJJYY687BvNs/cNBxCerxe4aj0Sqp03iP/aL0CPX/UezJNRPpF/OCVfEf4s8NatCqfmiN3MlwhcQGBduLSRlVz1aTE/35LvhtEGS/UIVQ0BmWlCRxvS6yWnlq3EHC+eAIPWbE2YJQmSflCoLyPp6FBo/UCjP0prCuhtrKxBZduO8/ZKE9+JFHRL2jXHITBj/Z6xyAMuvXTzAe3dJ2zp5ov2iQwDzC3Z5eRmqY284KR3GgH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

This innocent-looking snippet:

	mm->foo = bar;
	on_each_cpu_mask(mm_cpumask(mm), ipi_func, ...);

is potentially buggy because the variable update is not ordered with
respect to the mm_cpumask() read. There were at least two examples of
this pattern on x86 that we think were real bugs. See commit
0dc2a4dac3d0 ("x86/mm: Ensure write visibility during LDT
installation") for one of them.

Add a barrier to the core IPI code to make this pattern more foolproof.

Other arch maintainers: You might want to take a look over your IPIs
and see if this pattern is biting you anywhere. Also, for those of
you that *do* have correct barriers in place for this pattern, they
may become redundant if this gets applied.

This specific idea came from Linus (and his LLM), with some tweaking
on top from me. I'm planning to send it up in the next merge window
via an x86 tree, barring any objections or performance issues that
surface. Please speak up if this causes you any heartburn.

Longer discussion follows.

== Background ==

There's a basic pattern in the kernel where some in-memory structure
is changed and then remote CPUs are notified via an IPI about the
change. TLB flushes are the canonical example but there are plenty
of others.

The IPI is generally sent to the CPUs using an mm found via
mm_cpumask(). CPUs set themselves in that mask when they context
switch to an mm.

So, there are two sides to this pattern. Both write some data and the
other side consumes it. Bugs happen if, for instance, the IPI-sending
CPU uses a stale mm_cpumask(). Or, if the IPI-receiving CPU happened
to read the data before setting its bit in mm_cpumask().

== Problem ==

There was a recent x86 bug where mm_cpumask() was read before the
newly-written data was visible to remote CPUs. This was the reverse of
program order, but allowed without a memory barrier.

But this case is not special. There are other examples on x86,
including one in the LAM code which is probably a real but largely
inconsequential bug today. There are a few other x86 cases which use
atomics (and have their own memory barriers), but they are probably
correct by accident more than design.

== Solution ==

Add a full smp_mb() in the core IPI code and documentation of the new
rules. Place the smp_mb() just before the cpumask is acted on.  This
will ensure that any data written before the IPI is visible to remote
CPUs.

This makes the smp_call_function() code a wee bit more expensive, but
substantially harder to get wrong.

Combined with the barriers in mm switching, this ensures that remote
CPUs either get the IPI or can see the write from the IPI sender.

Place the barrier so it covers every entry point that takes a cpumask:
on_each_cpu_mask(), on_each_cpu_cond_mask() and
smp_call_function_many(). Callers that sample mm_cpumask() themselves
to pick targets must still order the update against their own mask
read.

Remove the now-redundant smp_mb() in x86's install_ldt().

== Impact ==

Many IPI users already have working barriers in place. The new barrier
may make some of those redundant.

== Alternatives ==

My first thought was to add a barrier in mm_cpumask() itself. But it
only computes a pointer to the cpumask. A barrier there would be odd
because there is no actual data consumed.

Andy Lutomirski suggested adding a barrier to on_each_cpu_mm(). That
would work for the x86 cases, but might leave issues in code that does
not deal with mm's.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-arch@vger.kernel.org
---

 b/arch/x86/kernel/ldt.c    |   12 ++++--------
 b/arch/x86/mm/tlb.c        |    5 +++++
 b/include/linux/mm_types.h |   14 +++++++++++++-
 b/include/linux/smp.h      |    4 ++++
 b/kernel/smp.c             |   17 +++++++++++++++++
 5 files changed, 43 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/ldt.c~ipi-mb2-generic arch/x86/kernel/ldt.c
--- a/arch/x86/kernel/ldt.c~ipi-mb2-generic	2026-11-20 11:28:32.775743722 -0800
+++ b/arch/x86/kernel/ldt.c	2026-11-20 12:04:14.780113172 -0800
@@ -422,16 +422,12 @@ static void install_ldt(struct mm_struct
 {
 	mutex_lock(&mm->context.lock);
 
-	/*
-	 * Ensure that new mm user CPUs either see the new LDT value
-	 * or get an IPI. Make the store visible before reading
-	 * mm_cpumask(). New mm users make their mm_cpumask() writes
-	 * visible before reading mm->context.ldt.
-	 */
 	WRITE_ONCE(mm->context.ldt, ldt);
-	smp_mb();
 
-	/* Activate the LDT for all CPUs using currents mm. */
+	/*
+	 * Activate the LDT for all mm-user CPUs. New mm users either
+	 * see the new LDT or get the IPI, see mm_cpumask().
+	 */
 	on_each_cpu_mask(mm_cpumask(mm), flush_ldt, mm, true);
 
 	mutex_unlock(&mm->context.lock);
diff -puN arch/x86/mm/tlb.c~ipi-mb2-generic arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~ipi-mb2-generic	2026-11-20 11:28:32.777743889 -0800
+++ b/arch/x86/mm/tlb.c	2026-11-20 11:54:03.546906165 -0800
@@ -937,6 +937,11 @@ void switch_mm_irqs_off(struct mm_struct
 		 *
 		 * This way switch_mm() must see the new tlb_gen or
 		 * flush_tlb_mm_range() must see the new loaded_mm, or both.
+		 *
+		 * This also protects other per-mm state read below, like the
+		 * LDT. Changes to that state are followed by an IPI to the
+		 * CPUs in mm_cpumask(). Setting the bit first means this CPU
+		 * either reads the new value or gets the IPI.
 		 */
 		if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next)))
 			cpumask_set_cpu(cpu, mm_cpumask(next));
diff -puN include/linux/mm_types.h~ipi-mb2-generic include/linux/mm_types.h
--- a/include/linux/mm_types.h~ipi-mb2-generic	2026-11-20 11:28:32.779744056 -0800
+++ b/include/linux/mm_types.h	2026-11-20 11:28:32.785744556 -0800
@@ -1514,7 +1514,19 @@ static inline void mm_init_cpumask(struc
 	cpumask_clear((struct cpumask *)cpu_bitmap);
 }
 
-/* Future-safe accessor for struct mm_struct's cpu_vm_mask. */
+/*
+ * mm_cpumask() - CPUs that may hold state derived from @mm (TLB entries,
+ * cached per-mm context). Code that updates per-mm state and then notifies
+ * the CPUs in the mask relies on:
+ *
+ *  - A CPU sets its bit, then a full barrier, then reads that state or
+ *    loads @mm's page tables.
+ *  - The updater has a full barrier between the update and reading the
+ *    mask. on_each_cpu_mask() and smp_call_function_many() provide it;
+ *    open-coded mask tests (e.g. "only this CPU?") must do it themselves.
+ *  - An architecture that clears bits must revalidate that state when the
+ *    CPU sets its bit again.
+ */
 static inline cpumask_t *mm_cpumask(struct mm_struct *mm)
 {
 	return (struct cpumask *)&mm->flexible_array;
diff -puN kernel/smp.c~ipi-mb2-generic kernel/smp.c
--- a/kernel/smp.c~ipi-mb2-generic	2026-11-20 11:28:32.780744139 -0800
+++ b/kernel/smp.c	2026-11-20 11:48:27.863451170 -0800
@@ -950,6 +950,15 @@ static void smp_call_function_many_cond(
 	 */
 	WARN_ON_ONCE(!in_task());
 
+	/*
+	 * Callers update some state and then IPI the CPUs in @mask to act on
+	 * it. A CPU that sets its bit in @mask and then reads that state
+	 * must either see the update or get the IPI, so order the caller's
+	 * prior updates before reading @mask. Pairs with a full barrier
+	 * between setting the bit and reading the state, e.g. in switch_mm().
+	 */
+	smp_mb();
+
 	/* Check if we need remote execution, i.e., any CPU excluding this one. */
 	if (cpumask_any_and_but(mask, cpu_online_mask, this_cpu) < nr_cpu_ids) {
 		cpumask_and(cpumask, mask, cpu_online_mask);
@@ -1043,6 +1052,10 @@ static void smp_call_function_many_cond(
  *
  * @func is not called on the local CPU even if @mask contains it.  Consider
  * using on_each_cpu_cond_mask() instead if this is not desirable.
+ *
+ * Stores made by the caller before this call are ordered before the
+ * read of @mask, so a CPU that sets its bit in @mask and then reads
+ * that data will either see the stores or receive the IPI.
  */
 void smp_call_function_many(const struct cpumask *mask,
 			    smp_call_func_t func, void *info, bool wait)
@@ -1181,6 +1194,10 @@ void __init smp_init(void)
  * to be seen or sent an IPI. If @wait is true, the final wait for remote
  * completion happens after that preemption-disabled section.
  *
+ * Stores made by the caller before this call are ordered before the
+ * read of @mask, so a CPU that sets its bit in @mask and then reads
+ * that data will either see the stores or receive the IPI.
+ *
  * You must not call this function with disabled interrupts or
  * from a hardware interrupt handler or from a bottom half handler.
  */
diff -puN include/linux/smp.h~ipi-mb2-generic include/linux/smp.h
--- a/include/linux/smp.h~ipi-mb2-generic	2026-11-20 11:48:08.343859262 -0800
+++ b/include/linux/smp.h	2026-11-20 11:48:27.863451170 -0800
@@ -82,6 +82,10 @@ static inline void on_each_cpu(smp_call_
  *
  * If @wait is true, then returns once @func has returned.
  *
+ * Stores made by the caller before this call are ordered before the
+ * read of @mask, so a CPU that sets its bit in @mask and then reads
+ * that data will either see the stores or receive the IPI.
+ *
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.  The
  * exception is that it may be used during early boot while
_

