Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42066CFC500
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0ED6B009E; Fri, 21 Nov 2025 13:55:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0BC6B00A0; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9D486B00A4; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1626B00A0
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:55:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13C041403C3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:48 +0000 (UTC)
X-FDA: 84135518376.23.BFA243D
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67A352000D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:55:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CjUe3wsY;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763751346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQZzRuzp2rqeyHytAr/IcYMzpnY2peqm60QAfO5FIAo=;
	b=8QpKt1nfATOVQC/BXTdiy9Qg00ZXTpyWpOcMz6lTD64PtWUv6N8mgEfnOQxjpbCWymt+tc
	v7gW+4FZTjt6vXrdnhFF4Z/cox3kQbhNdF+IIJcRNFrMSYhakutPzrlPWYwn+xAHkQ4vKX
	UvlI+WKllRT5sVXEF1pZXhFrN2j8H5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763751346; a=rsa-sha256;
	cv=none;
	b=k9+KA+K19/fUt7EO4/6oxggljOxT0VRyE8bX/HPoi+3MpARB7hyIDZjwJ9PX8SZGa8cx99
	5BAYRFwsHXbXWw9th28rSbaYovkRXyFhphJRTIr1DFLR90rg2n0aK3RzpKTw7j+mB1J9+9
	t5jiXWFWmFJA4lxjvIE7jq2yG0oIR4I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=CjUe3wsY;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=pQZzRuzp2rqeyHytAr/IcYMzpnY2peqm60QAfO5FIAo=; b=CjUe3wsYubQ/IT7lHtQR/KMU2W
	5wgorVgBgHODk6TWi20EoJkACRFt2UxXi5AzFnsB2gugG9sH2oyDDEKtXiON072rnFZDiDqkvDlMZ
	cieUc82Ta0ElhtrXnnh1EeL+H1puXRDdXhdcNiE7hDSEtUMJ1pcx9q0mFtIygTHvPmVZP3zpw6uio
	H9Izh26/FMQpICu4Nu8OXC3sXkm14k2N1zLecds5iSV2Tg/mDl4339mX2G/eH7iA5jjltRgZvtDf+
	90wQuwIxR2ZWYwI6tserpQBdozDsx2Lwp7UIh/79Oe2bgswSUSe6824rc4uGyo53CxB7ZU+z2P6sk
	HsOYoZ5g==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vMWI9-000000003i4-1qtA;
	Fri, 21 Nov 2025 13:55:34 -0500
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	x86@kernel.org,
	dave.hansen@linux.intel.com,
	peterz@infradead.org,
	kernel-team@meta.com,
	bp@alien8.de,
	Rik van Riel <riel@fb.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC v5 7/8] x86/mm: userspace & pageout flushing using Intel RAR
Date: Fri, 21 Nov 2025 13:54:28 -0500
Message-ID: <20251121185530.21876-8-riel@surriel.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121185530.21876-1-riel@surriel.com>
References: <20251121185530.21876-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7joihrqtez3szjr7j31mcndyg9nbtz9f
X-Rspam-User: 
X-Rspamd-Queue-Id: 67A352000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1763751346-278954
X-HE-Meta: U2FsdGVkX19DGOF61luMlA2ozy7pp7M07Emu+8Vy5bq0vrO6rGQFhylxd4LaxjGHYtAgxqECkkbCIEWRQcip8j3KMBOS0CFVWtY6tNoN5TZLIogV9mZtQeolXlFyL/S1CC5pL+7U/UTxQn0IcLe+70uTFDmAt01IwzSBFJncydDzH4iEM42RZt3PouRs8TBESSpDDHSIevTKyp68YPa+BUg3lQGDYK/aJYY0pEkRcQr+BwetzxF5WU3BvqdX2l1GOsmkG3jS8ttM5U4czCSFKmatlW3VbyLmB6m1eLSqWUHXi+M5xgv3lvNq6H3pZHXV5dck+vWMtPFZ/RPHt0k5GeUjWX78GTusz8V3/FDBnbe9APPTA4oaHPxc/k5gYHYXI0p4cjjsc2BB7QKZfSfkdJ9QGzWTlmzVmYS22wdNqItFtUyZyLpY8yOIdpaLyMNTmemyDs+vnC5rX9JWwYOF+ki9SJHtTG4OHTWXvZc8lTcVJ+K0zvpNRZU6yDFS0XC8lOV25vp8aPjMHQuMLo8jfuOfxBYOmxhcFfKrk7Mkg4CEKTWzCT2hQ6JAvrhgHj3ZX13mgxuy2FRr3jwolTetY2q+JhsnwR/DShXzDOTS1q8BheN5nITKRGwwHhlmi2ANrM+eTgpKzURVq3KGs3pOLOaWs7zEZrN8yfefJP1kppVFTtKvf0NTaoGbd2jIb0VniL7IyEs22Xr0rNdD/oUUKFtLAPAZGrjFy3R2ojmW3TJqF1cD+tT9VqbqkHl9zGwinY9QuTdJfeOFk8OuGJPdJo8010XSSCKNK6xbjvcE4BBvQsdY69JivOlMeQWEh4fmHcVPuPju4Z5quwaL2AA3G1OX1lRZ9GweIHE6JThjwTbER2co1mWAHuDmyFu2VOgJXYFUwnT4fTE+2UhCRXyMnrq0jel0JOqRAQVG+2/GJISzp35VwxJ1af9UiwgGm5SiVzQJxqTptMRRhSKRoNN
 KkoDbPPF
 bzWOa9QeIFoeSNhXne7XgPR/pje8YWsfdcnCyj85JJky+UD/eYIudgCXzgY21wImBFufBwekY9vPdaSFYF2Gfo7RVDPuApQ2g/wOw9OVOAI1uiVmN6yU2gU3jjkOVjqZT5MnRtZyajvPca1vIoLcokggjysrV/5MgpA6sOleLsmfh2R58dPWf8sHbnD2elIpjC51jNruY8vb6JNTrkMChxIikReNIuEaSq1YUxxOWo6Lo+bCDJe28kKMPZpuMqQS5xAWQrGb+AngY6wDzEV3ctFr3WaCbiY4iBCyHLuFcW4KX/7gDI5pCZTwaMRjZyi8oopP60QhFjKnNoyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@fb.com>

Use Intel RAR to flush userspace mappings.

Because RAR flushes are targeted using a cpu bitmap, the rules are
a little bit different than for true broadcast TLB invalidation.

For true broadcast TLB invalidation, like done with AMD INVLPGB,
a global ASID always has up to date TLB entries on every CPU.
The context switch code never has to flush the TLB when switching
to a global ASID on any CPU with INVLPGB.

For RAR, the TLB mappings for a global ASID are kept up to date
only on CPUs within the mm_cpumask, which lazily follows the
threads around the system. The context switch code does not
need to flush the TLB if the CPU is in the mm_cpumask, and
the PCID used stays the same.

However, a CPU that falls outside of the mm_cpumask can have
out of date TLB mappings for this task. When switching to
that task on a CPU not in the mm_cpumask, the TLB does need
to be flushed.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/x86/include/asm/tlbflush.h |   9 +-
 arch/x86/mm/tlb.c               | 216 ++++++++++++++++++++++++++------
 2 files changed, 181 insertions(+), 44 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 00daedfefc1b..561a38f90588 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -250,7 +250,8 @@ static inline u16 mm_global_asid(struct mm_struct *mm)
 {
 	u16 asid;
 
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    !cpu_feature_enabled(X86_FEATURE_RAR))
 		return 0;
 
 	asid = smp_load_acquire(&mm->context.global_asid);
@@ -263,7 +264,8 @@ static inline u16 mm_global_asid(struct mm_struct *mm)
 
 static inline void mm_init_global_asid(struct mm_struct *mm)
 {
-	if (cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB) ||
+	    cpu_feature_enabled(X86_FEATURE_RAR)) {
 		mm->context.global_asid = 0;
 		mm->context.asid_transition = false;
 	}
@@ -287,7 +289,8 @@ static inline void mm_clear_asid_transition(struct mm_struct *mm)
 
 static inline bool mm_in_asid_transition(struct mm_struct *mm)
 {
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    !cpu_feature_enabled(X86_FEATURE_RAR))
 		return false;
 
 	return mm && READ_ONCE(mm->context.asid_transition);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 19c28386d8de..f59140f87982 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -223,7 +223,8 @@ struct new_asid {
 	unsigned int need_flush : 1;
 };
 
-static struct new_asid choose_new_asid(struct mm_struct *next, u64 next_tlb_gen)
+static struct new_asid choose_new_asid(struct mm_struct *next, u64 next_tlb_gen,
+				       bool new_cpu)
 {
 	struct new_asid ns;
 	u16 asid;
@@ -236,14 +237,22 @@ static struct new_asid choose_new_asid(struct mm_struct *next, u64 next_tlb_gen)
 
 	/*
 	 * TLB consistency for global ASIDs is maintained with hardware assisted
-	 * remote TLB flushing. Global ASIDs are always up to date.
+	 * remote TLB flushing. Global ASIDs are always up to date with INVLPGB,
+	 * and up to date for CPUs in the mm_cpumask with RAR..
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_INVLPGB)) {
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB) ||
+	    cpu_feature_enabled(X86_FEATURE_RAR)) {
 		u16 global_asid = mm_global_asid(next);
 
 		if (global_asid) {
 			ns.asid = global_asid;
 			ns.need_flush = 0;
+			/*
+			 * If the CPU fell out of the cpumask, it can be
+			 * out of date with RAR, and should be flushed.
+			 */
+			if (cpu_feature_enabled(X86_FEATURE_RAR))
+				ns.need_flush = new_cpu;
 			return ns;
 		}
 	}
@@ -301,7 +310,14 @@ static void reset_global_asid_space(void)
 {
 	lockdep_assert_held(&global_asid_lock);
 
-	invlpgb_flush_all_nonglobals();
+	/*
+	 * The global flush ensures that a freshly allocated global ASID
+	 * has no entries in any TLB, and can be used immediately.
+	 * With Intel RAR, the TLB may still need to be flushed at context
+	 * switch time when dealing with a CPU that was not in the mm_cpumask
+	 * for the process, and may have missed flushes along the way.
+	 */
+	flush_tlb_all();
 
 	/*
 	 * The TLB flush above makes it safe to re-use the previously
@@ -378,7 +394,7 @@ static void use_global_asid(struct mm_struct *mm)
 {
 	u16 asid;
 
-	guard(raw_spinlock_irqsave)(&global_asid_lock);
+	guard(raw_spinlock)(&global_asid_lock);
 
 	/* This process is already using broadcast TLB invalidation. */
 	if (mm_global_asid(mm))
@@ -404,13 +420,14 @@ static void use_global_asid(struct mm_struct *mm)
 
 void mm_free_global_asid(struct mm_struct *mm)
 {
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    !cpu_feature_enabled(X86_FEATURE_RAR))
 		return;
 
 	if (!mm_global_asid(mm))
 		return;
 
-	guard(raw_spinlock_irqsave)(&global_asid_lock);
+	guard(raw_spinlock)(&global_asid_lock);
 
 	/* The global ASID can be re-used only after flush at wrap-around. */
 #ifdef CONFIG_BROADCAST_TLB_FLUSH
@@ -428,7 +445,8 @@ static bool mm_needs_global_asid(struct mm_struct *mm, u16 asid)
 {
 	u16 global_asid = mm_global_asid(mm);
 
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    !cpu_feature_enabled(X86_FEATURE_RAR))
 		return false;
 
 	/* Process is transitioning to a global ASID */
@@ -446,7 +464,8 @@ static bool mm_needs_global_asid(struct mm_struct *mm, u16 asid)
  */
 static void consider_global_asid(struct mm_struct *mm)
 {
-	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB))
+	if (!cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    !cpu_feature_enabled(X86_FEATURE_RAR))
 		return;
 
 	/* Check every once in a while. */
@@ -491,6 +510,7 @@ static void finish_asid_transition(struct flush_tlb_info *info)
 		 * that results in a (harmless) extra IPI.
 		 */
 		if (READ_ONCE(per_cpu(cpu_tlbstate.loaded_mm_asid, cpu)) != bc_asid) {
+			info->trim_cpumask = true;
 			flush_tlb_multi(mm_cpumask(info->mm), info);
 			return;
 		}
@@ -500,7 +520,7 @@ static void finish_asid_transition(struct flush_tlb_info *info)
 	mm_clear_asid_transition(mm);
 }
 
-static void broadcast_tlb_flush(struct flush_tlb_info *info)
+static void invlpgb_tlb_flush(struct flush_tlb_info *info)
 {
 	bool pmd = info->stride_shift == PMD_SHIFT;
 	unsigned long asid = mm_global_asid(info->mm);
@@ -531,8 +551,6 @@ static void broadcast_tlb_flush(struct flush_tlb_info *info)
 		addr += nr << info->stride_shift;
 	} while (addr < info->end);
 
-	finish_asid_transition(info);
-
 	/* Wait for the INVLPGBs kicked off above to finish. */
 	__tlbsync();
 }
@@ -863,7 +881,7 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 		/* Check if the current mm is transitioning to a global ASID */
 		if (mm_needs_global_asid(next, prev_asid)) {
 			next_tlb_gen = atomic64_read(&next->context.tlb_gen);
-			ns = choose_new_asid(next, next_tlb_gen);
+			ns = choose_new_asid(next, next_tlb_gen, true);
 			goto reload_tlb;
 		}
 
@@ -901,6 +919,7 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 		ns.asid = prev_asid;
 		ns.need_flush = true;
 	} else {
+		bool new_cpu = false;
 		/*
 		 * Apply process to process speculation vulnerability
 		 * mitigations if applicable.
@@ -933,22 +952,26 @@ void switch_mm_irqs_off(struct mm_struct *unused, struct mm_struct *next,
 		 * This way switch_mm() must see the new tlb_gen or
 		 * flush_tlb_mm_range() must see the new loaded_mm, or both.
 		 */
-		if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next)))
+		if (next != &init_mm && !cpumask_test_cpu(cpu, mm_cpumask(next))) {
 			cpumask_set_cpu(cpu, mm_cpumask(next));
-		else
+			if (cpu_feature_enabled(X86_FEATURE_RAR))
+				new_cpu = true;
+		} else {
 			smp_mb();
+		}
 
 		next_tlb_gen = atomic64_read(&next->context.tlb_gen);
 
-		ns = choose_new_asid(next, next_tlb_gen);
+		ns = choose_new_asid(next, next_tlb_gen, new_cpu);
 	}
 
 reload_tlb:
 	new_lam = mm_lam_cr3_mask(next);
 	if (ns.need_flush) {
-		VM_WARN_ON_ONCE(is_global_asid(ns.asid));
-		this_cpu_write(cpu_tlbstate.ctxs[ns.asid].ctx_id, next->context.ctx_id);
-		this_cpu_write(cpu_tlbstate.ctxs[ns.asid].tlb_gen, next_tlb_gen);
+		if (is_dyn_asid(ns.asid)) {
+			this_cpu_write(cpu_tlbstate.ctxs[ns.asid].ctx_id, next->context.ctx_id);
+			this_cpu_write(cpu_tlbstate.ctxs[ns.asid].tlb_gen, next_tlb_gen);
+		}
 		load_new_mm_cr3(next->pgd, ns.asid, new_lam, true);
 
 		trace_tlb_flush(TLB_FLUSH_ON_TASK_SWITCH, TLB_FLUSH_ALL);
@@ -1136,7 +1159,7 @@ static void flush_tlb_func(void *info)
 	const struct flush_tlb_info *f = info;
 	struct mm_struct *loaded_mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	u32 loaded_mm_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
-	u64 local_tlb_gen;
+	u64 local_tlb_gen = 0;
 	bool local = smp_processor_id() == f->initiating_cpu;
 	unsigned long nr_invalidate = 0;
 	u64 mm_tlb_gen;
@@ -1159,19 +1182,6 @@ static void flush_tlb_func(void *info)
 	if (unlikely(loaded_mm == &init_mm))
 		return;
 
-	/* Reload the ASID if transitioning into or out of a global ASID */
-	if (mm_needs_global_asid(loaded_mm, loaded_mm_asid)) {
-		switch_mm_irqs_off(NULL, loaded_mm, NULL);
-		loaded_mm_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
-	}
-
-	/* Broadcast ASIDs are always kept up to date with INVLPGB. */
-	if (is_global_asid(loaded_mm_asid))
-		return;
-
-	VM_WARN_ON(this_cpu_read(cpu_tlbstate.ctxs[loaded_mm_asid].ctx_id) !=
-		   loaded_mm->context.ctx_id);
-
 	if (this_cpu_read(cpu_tlbstate_shared.is_lazy)) {
 		/*
 		 * We're in lazy mode.  We need to at least flush our
@@ -1182,11 +1192,31 @@ static void flush_tlb_func(void *info)
 		 * This should be rare, with native_flush_tlb_multi() skipping
 		 * IPIs to lazy TLB mode CPUs.
 		 */
+		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(loaded_mm));
 		switch_mm_irqs_off(NULL, &init_mm, NULL);
 		return;
 	}
 
-	local_tlb_gen = this_cpu_read(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen);
+	/* Reload the ASID if transitioning into or out of a global ASID */
+	if (mm_needs_global_asid(loaded_mm, loaded_mm_asid)) {
+		switch_mm_irqs_off(NULL, loaded_mm, NULL);
+		loaded_mm_asid = this_cpu_read(cpu_tlbstate.loaded_mm_asid);
+	}
+
+	/*
+	 * Broadcast ASIDs are always kept up to date with INVLPGB; with
+	 * Intel RAR IPI based flushes are used periodically to trim the
+	 * mm_cpumask, and flushes that get here should be processed.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB) &&
+	    is_global_asid(loaded_mm_asid))
+		return;
+
+	VM_WARN_ON(is_dyn_asid(loaded_mm_asid) && loaded_mm->context.ctx_id !=
+		   this_cpu_read(cpu_tlbstate.ctxs[loaded_mm_asid].ctx_id));
+
+	if (is_dyn_asid(loaded_mm_asid))
+		local_tlb_gen = this_cpu_read(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen);
 
 	if (unlikely(f->new_tlb_gen != TLB_GENERATION_INVALID &&
 		     f->new_tlb_gen <= local_tlb_gen)) {
@@ -1285,7 +1315,8 @@ static void flush_tlb_func(void *info)
 	}
 
 	/* Both paths above update our state to mm_tlb_gen. */
-	this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb_gen);
+	if (is_dyn_asid(loaded_mm_asid))
+		this_cpu_write(cpu_tlbstate.ctxs[loaded_mm_asid].tlb_gen, mm_tlb_gen);
 
 	/* Tracing is done in a unified manner to reduce the code size */
 done:
@@ -1326,15 +1357,15 @@ static bool should_flush_tlb(int cpu, void *data)
 	if (loaded_mm == info->mm)
 		return true;
 
-	/* In cpumask, but not the loaded mm? Periodically remove by flushing. */
-	if (info->trim_cpumask)
-		return true;
-
 	return false;
 }
 
 static bool should_trim_cpumask(struct mm_struct *mm)
 {
+	/* INVLPGB always goes to all CPUs. No need to trim the mask. */
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB) && mm_global_asid(mm))
+		return false;
+
 	if (time_after(jiffies, READ_ONCE(mm->context.next_trim_cpumask))) {
 		WRITE_ONCE(mm->context.next_trim_cpumask, jiffies + HZ);
 		return true;
@@ -1345,6 +1376,27 @@ static bool should_trim_cpumask(struct mm_struct *mm)
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
 EXPORT_PER_CPU_SYMBOL(cpu_tlbstate_shared);
 
+static bool should_flush_all(const struct flush_tlb_info *info)
+{
+	if (info->freed_tables)
+		return true;
+
+	if (info->trim_cpumask)
+		return true;
+
+	/*
+	 * INVLPGB and RAR do not use this code path normally.
+	 * This call cleans up the cpumask or ASID transition.
+	 */
+	if (mm_global_asid(info->mm))
+		return true;
+
+	if (mm_in_asid_transition(info->mm))
+		return true;
+
+	return false;
+}
+
 STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 					 const struct flush_tlb_info *info)
 {
@@ -1370,7 +1422,7 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 	 * up on the new contents of what used to be page tables, while
 	 * doing a speculative memory access.
 	 */
-	if (info->freed_tables || mm_in_asid_transition(info->mm))
+	if (should_flush_all(info))
 		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
 	else
 		on_each_cpu_cond_mask(should_flush_tlb, flush_tlb_func,
@@ -1401,6 +1453,74 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(struct flush_tlb_info, flush_tlb_info);
 static DEFINE_PER_CPU(unsigned int, flush_tlb_info_idx);
 #endif
 
+static void trim_cpumask_func(void *data)
+{
+	struct mm_struct *loaded_mm = this_cpu_read(cpu_tlbstate.loaded_mm);
+	const struct flush_tlb_info *f = data;
+
+	/*
+	 * Clearing this bit from an IRQ handler synchronizes against
+	 * the bit being set in switch_mm_irqs_off, with IRQs disabled.
+	 */
+	if (f->mm != loaded_mm)
+		cpumask_clear_cpu(raw_smp_processor_id(), mm_cpumask(f->mm));
+}
+
+static bool should_remove_cpu_from_mask(int cpu, void *data)
+{
+	struct mm_struct *loaded_mm = per_cpu(cpu_tlbstate.loaded_mm, cpu);
+	struct flush_tlb_info *info = data;
+
+	if (loaded_mm != info->mm)
+		return true;
+
+	return false;
+}
+
+/* Remove CPUs from the mm_cpumask that are running another mm. */
+static void trim_cpumask(struct flush_tlb_info *info)
+{
+	cpumask_t *cpumask = mm_cpumask(info->mm);
+	on_each_cpu_cond_mask(should_remove_cpu_from_mask, trim_cpumask_func,
+				(void *)info, 1, cpumask);
+}
+
+static void rar_tlb_flush(struct flush_tlb_info *info)
+{
+	unsigned long asid = mm_global_asid(info->mm);
+	cpumask_t *cpumask = mm_cpumask(info->mm);
+	u16 pcid = kern_pcid(asid);
+
+	if (info->trim_cpumask)
+		trim_cpumask(info);
+
+	/* Only the local CPU needs to be flushed? */
+	if (cpumask_equal(cpumask, cpumask_of(raw_smp_processor_id()))) {
+		lockdep_assert_irqs_enabled();
+		local_irq_disable();
+		flush_tlb_func(info);
+		local_irq_enable();
+		return;
+	}
+
+	/* Flush all the CPUs at once with RAR. */
+	if (cpumask_weight(cpumask)) {
+		smp_call_rar_many(mm_cpumask(info->mm), pcid, info->start, info->end);
+		if (cpu_feature_enabled(X86_FEATURE_PTI))
+			smp_call_rar_many(mm_cpumask(info->mm), user_pcid(asid), info->start, info->end);
+	}
+}
+
+static void broadcast_tlb_flush(struct flush_tlb_info *info)
+{
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		invlpgb_tlb_flush(info);
+	else /* Intel RAR */
+		rar_tlb_flush(info);
+
+	finish_asid_transition(info);
+}
+
 static struct flush_tlb_info *get_flush_tlb_info(struct mm_struct *mm,
 			unsigned long start, unsigned long end,
 			unsigned int stride_shift, bool freed_tables,
@@ -1461,6 +1581,13 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	info = get_flush_tlb_info(mm, start, end, stride_shift, freed_tables,
 				  new_tlb_gen);
 
+	/*
+	 * IPIs and RAR can be targeted to a cpumask. Periodically trim that
+	 * mm_cpumask by sending TLB flush IPIs, even when most TLB flushes
+	 * are done with RAR.
+	 */
+	info->trim_cpumask = should_trim_cpumask(mm);
+
 	/*
 	 * flush_tlb_multi() is not optimized for the common case in which only
 	 * a local TLB flush is needed. Optimize this use-case by calling
@@ -1469,7 +1596,6 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	if (mm_global_asid(mm)) {
 		broadcast_tlb_flush(info);
 	} else if (cpumask_any_but(mm_cpumask(mm), cpu) < nr_cpu_ids) {
-		info->trim_cpumask = should_trim_cpumask(mm);
 		flush_tlb_multi(mm_cpumask(mm), info);
 		consider_global_asid(mm);
 	} else if (mm == this_cpu_read(cpu_tlbstate.loaded_mm)) {
@@ -1778,6 +1904,14 @@ void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
 	if (cpu_feature_enabled(X86_FEATURE_INVLPGB) && batch->unmapped_pages) {
 		invlpgb_flush_all_nonglobals();
 		batch->unmapped_pages = false;
+	} else if (cpu_feature_enabled(X86_FEATURE_RAR) && cpumask_any(&batch->cpumask) < nr_cpu_ids) {
+		rar_full_flush(&batch->cpumask);
+		if (cpumask_test_cpu(cpu, &batch->cpumask)) {
+			lockdep_assert_irqs_enabled();
+			local_irq_disable();
+			invpcid_flush_all_nonglobals();
+			local_irq_enable();
+		}
 	} else if (cpumask_any_but(&batch->cpumask, cpu) < nr_cpu_ids) {
 		flush_tlb_multi(&batch->cpumask, info);
 	} else if (cpumask_test_cpu(cpu, &batch->cpumask)) {
-- 
2.51.1


