Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 454C5CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29BA6B0089; Mon, 24 Nov 2025 08:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA4B6B008A; Mon, 24 Nov 2025 08:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C8F06B008C; Mon, 24 Nov 2025 08:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76DCA6B0089
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E27558B33
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:29 +0000 (UTC)
X-FDA: 84145567338.11.069CC11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B4D880009
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990607; a=rsa-sha256;
	cv=none;
	b=JilMqDm1nUss14nZN996DRDNz/8khDeFMDi+WXeHhPc2c95u7z9AOyWDCxKugsfOZ21LZV
	Xm9gaJyGo3kLEejZ6fn/89lJDf6jNJZEVAs2Exz6gt1Q9bod4BQbDf3DYDvDfkOiJ8OV2H
	qdjg7kPOxCZjua+fpSIgBTjmFyPUr/M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gj4iFN3ZQ6JLJ3lvMpJahEbnH4amdNlDjqaEep+jSnc=;
	b=gvQawris7BLRm/EAK4o869uqzCM4hEGs9mSuzYMjUZNv2tklohceOizqzDZf51T/43m+xb
	lQ2n8D15qFf8CmPKgC4EgODONNF1P9bOjzhegduqw6qY0SxW/GKm+6z12er/SoIw70tHxf
	8s951TacUk4ytOpOlTl4sgCrhgr5na4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C3A11655;
	Mon, 24 Nov 2025 05:23:19 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D3443F73B;
	Mon, 24 Nov 2025 05:23:21 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Woodhouse <dwmw2@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
Date: Mon, 24 Nov 2025 13:22:24 +0000
Message-ID: <20251124132228.622678-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B4D880009
X-Stat-Signature: uqzn3a1ktjtj7bfjdn3aqe6p8kgpfzwg
X-HE-Tag: 1763990607-510396
X-HE-Meta: U2FsdGVkX191DvXrQdsnfFm2JFlimx//9HgfbJ5gb3irKWZbf5RSkGxHRPM3BVwLldefrN0I5wZ7AA1+elV1JzmWsP2CiOj82Uqw8p3UQ3aDuppsrHDCbDckAPCzsBUcHCtGLkHeQ8H2o+n7g91q/BhZE4eu9eGPjt3uzQyYS4+YaAmL2SBVcferM6ol1L1wTUevgsd6mFh6YNNsB4zy4AXrufl4rrxyycCMMsgxoo5rbRbQsVOU9b3BgdO5BRwuYaBRlk6VFjdd/EzoJZVT/LRziO0b/nCd5/6/Xr0uOCEnqIY8bmUgTfB4KUSv66ZRUiEZ8nuu8Z6LMHZ7Y8m5xLKhDim4LMAMnruHXQyx6j/tLJsM6eeERI4aT85joOOje6ZVxNktfk7Jz7r3nTnxBD3RQC3Z4DygLTBG4QBFZp+/vSVbZoCk5r/Z6W0VekUROh8uagGZFivUsXG4FX+BRbo5QR9Ok54IPZn3FIxziX30I+O5MIe56KwdwdkMRbnATMHho8gadq+JP3VvZIu9JsHVkAA6nzC2ccCFhaDgWYT5vB6IGAy0QqZl2nbqBkmEfkOfMKnf8f+pA32PBScVRWWzKD8KPgGA4Y0xIe55XANNPddd1qIOBVXZ9NL+FVvBEt1IsIiqDmlc65f9lB0d2do25f5J7EfU9vM3vc6b6App9w1QwAwaahlBUkStYXDGIRva/WZOIKUx6XulBl5neUk3gQ6w6zCib3XKZIMAZJL6j+NFnM3k6jpXWnrexnSB0v0YEaXzJUxnHUCK916D7CRONsSgF96aJ8tfpSdrgWb8CLex0cnDCCOPxpnT5Au0Pvf3Su3mmG+SsosE8vJ7enhzn/r4QOUcqR8XARwfxobSzFxFSiZYp4BBGud1lVI69g5dLaYZvzY3GcDzybuCKvk3sjW5RlHtf7J6VCkeIkKmjQWwNPZ9mA5EtH1f+RmLOAo60SREBvFsyOuRvx5
 iwQUMUwM
 w9xS/uZ0LClvOYqYiFsgGSs6G+96H7QnR3tw9vewdpFS3oocDOC2++4/tpj8fa5SYWDu6hkn3icg86Ack/GZQZCrDwPVPKJZg2RSM46vEQv6rFg+8p/hhhWU/ezdY6U5gM90DHM1X/L4wqVEKMmjYndYq3jvP4eYqmQjXjQg/Nld7S8Z+UpQmr8wDLYVGmXgFqDIuJhfBPyLM9zsf1Vse7/pkOf/jEEeX1fA52Zujn0dy158MKRU47zcfiNCI5hTNitipgHe+TMd8YhQh7AbTIu0PkE6inegiPKBDKNAYWSoiEj3OE8kLHHN+3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Despite recent efforts to prevent lazy_mmu sections from nesting, it
remains difficult to ensure that it never occurs - and in fact it
does occur on arm64 in certain situations (CONFIG_DEBUG_PAGEALLOC).
Commit 1ef3095b1405 ("arm64/mm: Permit lazy_mmu_mode to be nested")
made nesting tolerable on arm64, but without truly supporting it:
the inner call to leave() disables the batching optimisation before
the outer section ends.

This patch actually enables lazy_mmu sections to nest by tracking
the nesting level in task_struct, in a similar fashion to e.g.
pagefault_{enable,disable}(). This is fully handled by the generic
lazy_mmu helpers that were recently introduced.

lazy_mmu sections were not initially intended to nest, so we need to
clarify the semantics w.r.t. the arch_*_lazy_mmu_mode() callbacks.
This patch takes the following approach:

* The outermost calls to lazy_mmu_mode_{enable,disable}() trigger
  calls to arch_{enter,leave}_lazy_mmu_mode() - this is unchanged.

* Nested calls to lazy_mmu_mode_{enable,disable}() are not forwarded
  to the arch via arch_{enter,leave} - lazy MMU remains enabled so
  the assumption is that these callbacks are not relevant. However,
  existing code may rely on a call to disable() to flush any batched
  state, regardless of nesting. arch_flush_lazy_mmu_mode() is
  therefore called in that situation.

A separate interface was recently introduced to temporarily pause
the lazy MMU mode: lazy_mmu_mode_{pause,resume}(). pause() fully
exits the mode *regardless of the nesting level*, and resume()
restores the mode at the same nesting level.

pause()/resume() are themselves allowed to nest, so we actually
store two nesting levels in task_struct: enable_count and
pause_count. A new helper in_lazy_mmu_mode() is introduced to
determine whether we are currently in lazy MMU mode; this will be
used in subsequent patches to replace the various ways arch's
currently track whether the mode is enabled.

In summary (enable/pause represent the values *after* the call):

lazy_mmu_mode_enable()		-> arch_enter()	    enable=1 pause=0
    lazy_mmu_mode_enable()	-> ø		    enable=2 pause=0
	lazy_mmu_mode_pause()	-> arch_leave()     enable=2 pause=1
	lazy_mmu_mode_resume()	-> arch_enter()     enable=2 pause=0
    lazy_mmu_mode_disable()	-> arch_flush()     enable=1 pause=0
lazy_mmu_mode_disable()		-> arch_leave()     enable=0 pause=0

Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
headers included by <linux/pgtable.h> to use it.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  12 ----
 include/linux/mm_types_task.h    |   5 ++
 include/linux/pgtable.h          | 115 +++++++++++++++++++++++++++++--
 include/linux/sched.h            |  45 ++++++++++++
 4 files changed, 158 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e596899f4029..a7d99dee3dc4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -82,18 +82,6 @@ static inline void queue_pte_barriers(void)
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	/*
-	 * lazy_mmu_mode is not supposed to permit nesting. But in practice this
-	 * does happen with CONFIG_DEBUG_PAGEALLOC, where a page allocation
-	 * inside a lazy_mmu_mode section (such as zap_pte_range()) will change
-	 * permissions on the linear map with apply_to_page_range(), which
-	 * re-enters lazy_mmu_mode. So we tolerate nesting in our
-	 * implementation. The first call to arch_leave_lazy_mmu_mode() will
-	 * flush and clear the flag such that the remainder of the work in the
-	 * outer nest behaves as if outside of lazy mmu mode. This is safe and
-	 * keeps tracking simple.
-	 */
-
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
diff --git a/include/linux/mm_types_task.h b/include/linux/mm_types_task.h
index a82aa80c0ba4..11bf319d78ec 100644
--- a/include/linux/mm_types_task.h
+++ b/include/linux/mm_types_task.h
@@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
 #endif
 };
 
+struct lazy_mmu_state {
+	u8 enable_count;
+	u8 pause_count;
+};
+
 #endif /* _LINUX_MM_TYPES_TASK_H */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8ff6fdb4b13d..24fdb6f5c2e1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -230,39 +230,140 @@ static inline int pmd_dirty(pmd_t pmd)
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
  * held, but for kernel PTE updates, no lock is held). The mode is disabled in
  * interrupt context and calls to the lazy_mmu API have no effect.
- * Nesting is not permitted.
+ *
+ * The lazy MMU mode is enabled for a given block of code using:
+ *
+ *   lazy_mmu_mode_enable();
+ *   <code>
+ *   lazy_mmu_mode_disable();
+ *
+ * Nesting is permitted: <code> may itself use an enable()/disable() pair.
+ * A nested call to enable() has no functional effect; however disable() causes
+ * any batched architectural state to be flushed regardless of nesting. After a
+ * call to disable(), the caller can therefore rely on all previous page table
+ * modifications to have taken effect, but the lazy MMU mode may still be
+ * enabled.
+ *
+ * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
+ * This can be done using:
+ *
+ *   lazy_mmu_mode_pause();
+ *   <code>
+ *   lazy_mmu_mode_resume();
+ *
+ * pause() ensures that the mode is exited regardless of the nesting level;
+ * resume() re-enters the mode at the same nesting level. Any call to the
+ * lazy_mmu_mode_* API between those two calls has no effect. In particular,
+ * this means that pause()/resume() pairs may nest.
+ *
+ * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
+ * currently enabled.
  */
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+/**
+ * lazy_mmu_mode_enable() - Enable the lazy MMU mode.
+ *
+ * Enters a new lazy MMU mode section; if the mode was not already enabled,
+ * enables it and calls arch_enter_lazy_mmu_mode().
+ *
+ * Must be paired with a call to lazy_mmu_mode_disable().
+ *
+ * Has no effect if called:
+ * - While paused - see lazy_mmu_mode_pause()
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_enable(void)
 {
-	if (in_interrupt())
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
 		return;
 
-	arch_enter_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
+
+	if (state->enable_count++ == 0)
+		arch_enter_lazy_mmu_mode();
 }
 
+/**
+ * lazy_mmu_mode_disable() - Disable the lazy MMU mode.
+ *
+ * Exits the current lazy MMU mode section. If it is the outermost section,
+ * disables the mode and calls arch_leave_lazy_mmu_mode(). Otherwise (nested
+ * section), calls arch_flush_lazy_mmu_mode().
+ *
+ * Must match a call to lazy_mmu_mode_enable().
+ *
+ * Has no effect if called:
+ * - While paused - see lazy_mmu_mode_pause()
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_disable(void)
 {
-	if (in_interrupt())
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	if (in_interrupt() || state->pause_count > 0)
 		return;
 
-	arch_leave_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->enable_count == 0);
+
+	if (--state->enable_count == 0)
+		arch_leave_lazy_mmu_mode();
+	else /* Exiting a nested section */
+		arch_flush_lazy_mmu_mode();
+
 }
 
+/**
+ * lazy_mmu_mode_pause() - Pause the lazy MMU mode.
+ *
+ * Pauses the lazy MMU mode; if it is currently active, disables it and calls
+ * arch_leave_lazy_mmu_mode().
+ *
+ * Must be paired with a call to lazy_mmu_mode_resume(). Calls to the
+ * lazy_mmu_mode_* API have no effect until the matching resume() call.
+ *
+ * Has no effect if called:
+ * - While paused (inside another pause()/resume() pair)
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_pause(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
 	if (in_interrupt())
 		return;
 
-	arch_leave_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
+
+	if (state->pause_count++ == 0 && state->enable_count > 0)
+		arch_leave_lazy_mmu_mode();
 }
 
+/**
+ * lazy_mmu_mode_pause() - Resume the lazy MMU mode.
+ *
+ * Resumes the lazy MMU mode; if it was active at the point where the matching
+ * call to lazy_mmu_mode_pause() was made, re-enables it and calls
+ * arch_enter_lazy_mmu_mode().
+ *
+ * Must match a call to lazy_mmu_mode_pause().
+ *
+ * Has no effect if called:
+ * - While paused (inside another pause()/resume() pair)
+ * - In interrupt context
+ */
 static inline void lazy_mmu_mode_resume(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
 	if (in_interrupt())
 		return;
 
-	arch_enter_lazy_mmu_mode();
+	VM_WARN_ON_ONCE(state->pause_count == 0);
+
+	if (--state->pause_count == 0 && state->enable_count > 0)
+		arch_enter_lazy_mmu_mode();
 }
 #else
 static inline void lazy_mmu_mode_enable(void) {}
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b469878de25c..847e242376db 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1441,6 +1441,10 @@ struct task_struct {
 
 	struct page_frag		task_frag;
 
+#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+	struct lazy_mmu_state		lazy_mmu_state;
+#endif
+
 #ifdef CONFIG_TASK_DELAY_ACCT
 	struct task_delay_info		*delays;
 #endif
@@ -1724,6 +1728,47 @@ static inline char task_state_to_char(struct task_struct *tsk)
 	return task_index_to_char(task_state_index(tsk));
 }
 
+#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+/**
+ * __task_lazy_mmu_mode_active() - Test the lazy MMU mode state for a task.
+ * @tsk: The task to check.
+ *
+ * Test whether @tsk has its lazy MMU mode state set to active (i.e. enabled
+ * and not paused).
+ *
+ * This function only considers the state saved in task_struct; to test whether
+ * current actually is in lazy MMU mode, in_lazy_mmu_mode() should be used
+ * instead.
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline bool __task_lazy_mmu_mode_active(struct task_struct *tsk)
+{
+	struct lazy_mmu_state *state = &tsk->lazy_mmu_state;
+
+	return state->enable_count > 0 && state->pause_count == 0;
+}
+
+/**
+ * in_lazy_mmu_mode() - Test whether we are currently in lazy MMU mode.
+ *
+ * Test whether the current context is in lazy MMU mode. This is true if both:
+ * 1. We are not in interrupt context
+ * 2. Lazy MMU mode is active for the current task
+ *
+ * This function is intended for architectures that implement the lazy MMU
+ * mode; it must not be called from generic code.
+ */
+static inline bool in_lazy_mmu_mode(void)
+{
+	if (in_interrupt())
+		return false;
+
+	return __task_lazy_mmu_mode_active(current);
+}
+#endif
+
 extern struct pid *cad_pid;
 
 /*
-- 
2.51.2


