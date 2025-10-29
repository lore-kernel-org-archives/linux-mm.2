Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73B1CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AEB88E0056; Wed, 29 Oct 2025 06:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1860E8E0045; Wed, 29 Oct 2025 06:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C9B8E0056; Wed, 29 Oct 2025 06:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC5728E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5D7588F54
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:30 +0000 (UTC)
X-FDA: 84050732220.14.8602AE7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0B1A6C000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732629; a=rsa-sha256;
	cv=none;
	b=y6Zw9YA+MkCJCa7bkvsL3GGl4qjB2NsAUUUxyFBRPMbPAteU0aoH5LE7B8lAr8zTrDJrOd
	RmWwKEHCVt68l+U7xjH/BgI+jjYCvlTd9ZWOnx5PiMn2nkt0JPOZC2oZir2kIKDM2gsi+M
	ef514SFi9jHGx4NK/K5dSvzpA2/+iVA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+AU7H3Y7kBOsElJkv6VNrmfGdcBEVGJ+3XWubfNSqus=;
	b=rGdUQqNllKJMIMomhAhFnL2HTwzaDPMI7X69VcDGaMjY27eRpASbnMEGrXhuDtUIPp4ko8
	VTjHckr9BcZThjclEoy/z/2gJUOhzfMXQ3Rpe4upk2IIC8/S1mdlrvTuJfDBHHAsIYfOao
	zwq6ZTD9imhzT8378/fZGCzwUMtzEz4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 856C31AC1;
	Wed, 29 Oct 2025 03:10:20 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 70AF73F66E;
	Wed, 29 Oct 2025 03:10:23 -0700 (PDT)
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
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	x86@kernel.org
Subject: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
Date: Wed, 29 Oct 2025 10:09:04 +0000
Message-ID: <20251029100909.3381140-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7xtbqqm4stidbrnuocn5j5w3ikdpz94n
X-Rspamd-Queue-Id: 0B1A6C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761732628-935644
X-HE-Meta: U2FsdGVkX1+keUg1jtnhXd04dFfUUPntdasPVv37KeZA4AHHNr3ejEIO2ppm7VgoZ5X35wzIUFg4OANVVG7/d9MfNaQydygQx/YFwZB8D73bA7uwEUv4ZGTOvB17aBUFerGYjylIxuQnuTgxn+rPOF04eDa2qJydpja1BgjsPZKRXHsbhaRfB1c7CrvDGLPPstl1Zc+A92xYEVT4etC8n6th3za/r8f4k7rJR0q2JY87p5CxCW5jJDkidrgmeIoI1Uvl4MmpIo5naMPdj2nF1cZLGB0Ujlt0djfXUTkg9dDPpQFTo3TOCqcFBv1cJO5MUQ21HxQFMmXoQsd3dfl5EN/+9M0prXrX5eTcQDfMBGmU8LYyWR2jEqjvz7Y0SNAThng/+B+9DliN4z89kLUJE0wrHR8Us1p5RNctOvpIDHOxhpzsDfoJb226/1GSl7JdGlVHQm4rO4Q+PmFeugDVhwkKOl0n3a2UZLvfFOzrmDhcwPRGpXpFATygo9dOfc96Y0WorUzNlKPEkRRld8bHfe769Ym3GDBJkKjV6aFgMuiVcil+si33XcoFJdWPcsp0QxDoqYchBpwrG3JaPXs1f8aEKGrgX8t58d7Ywkw8mLW+NRN7ic5vnJUr1R/60TrQNNCO8cjwZEA4xNUB6RUI5kvJXMCexRH4SK1IV6wScs7HHJGdMn7bEQzrk+cY8ycALAtjtc2/+wFGr8Ax/epGsQdcFt5HnHBdktg+APcdX7/hf79ZeYWoLL+44P3qpoh4O3nFUzjCz2GuWOni0Nhwoz0cDAHHc3obxyyJDf4K4M2E3P068oMbld51d9btF2L0Q1DjsIFrJjcqJFFsII8k6m4nF2xnieD3TTyoB54xsqAlrMfZnyCqIILH+6ontPKUnuLWNN0cVrdr7VSWKtyfE7r759j8ZknyiyvuALrx+LCok7c86+0bY3ZXovRjKe6X+wxi0JhjhGH/Ws29pDi
 AZiOsfnU
 EziJqmvqL/PHuOf5Kl0kaEnMsnCviiSP3PixoGvYmagOzsGLOd4MFBuC/ElpPdHG+VNfooZyspVXT5fp0voR30BCPVnw8HgEKTm5uUD7s+b3ULl2UaQK5bePtobGF882g2+jzsKNHbI7/jfcz/IZ5tlwxTGV1mTdB2TnchRhcu92Let4n3AxUEMGR4Z4C738iqni/QaAzUjE/DyZfAhnBxGy+zLmf3KqoA6AOQJffmolMRPnJxI3JaASW2aCEurNQfowkTTLGmWgbClMX3ETJbVVFdXj4itM5EL8dNyR2VgHwrkWlZiGEHxSr0A==
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

Whether the mode is actually enabled or not at any point is tracked
by a separate "active" field in task_struct; this makes it possible
to check invariants in the generic API, and to expose a new
in_lazy_mmu_mode() helper to replace the various ways arch's
currently track whether the mode is enabled (this will be done in
later patches).

In summary (nesting/active represent the values *after* the call):

lazy_mmu_mode_enable()		-> arch_enter()	    nesting=1 active=1
    lazy_mmu_mode_enable()	-> ø		    nesting=2 active=1
	lazy_mmu_mode_pause()	-> arch_leave()     nesting=2 active=0
	lazy_mmu_mode_resume()	-> arch_enter()     nesting=2 active=1
    lazy_mmu_mode_disable()	-> arch_flush()     nesting=1 active=1
lazy_mmu_mode_disable()		-> arch_leave()     nesting=0 active=0

Note: in_lazy_mmu_mode() is added to <linux/sched.h> to allow arch
headers included by <linux/pgtable.h> to use it.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 12 ------
 include/linux/mm_types_task.h    |  5 +++
 include/linux/pgtable.h          | 67 ++++++++++++++++++++++++++++++--
 include/linux/sched.h            | 16 ++++++++
 4 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 54f8d6bb6f22..535435248923 100644
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
 	if (in_interrupt())
 		return;
 
diff --git a/include/linux/mm_types_task.h b/include/linux/mm_types_task.h
index a82aa80c0ba4..632d404f8191 100644
--- a/include/linux/mm_types_task.h
+++ b/include/linux/mm_types_task.h
@@ -88,4 +88,9 @@ struct tlbflush_unmap_batch {
 #endif
 };
 
+struct lazy_mmu_state {
+	u8 nesting_level;
+	bool active;
+};
+
 #endif /* _LINUX_MM_TYPES_TASK_H */
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b5fdf32c437f..e6064e00b22d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -228,27 +228,86 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode cannot be used
+ * in interrupt context.
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
+ * This sequence must only be used if the lazy MMU mode is already enabled.
+ * pause() ensures that the mode is exited regardless of the nesting level;
+ * resume() re-enters the mode at the same nesting level. <code> must not modify
+ * the lazy MMU state (i.e. it must not call any of the lazy_mmu_mode_*
+ * helpers).
+ *
+ * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
+ * currently enabled.
  */
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline void lazy_mmu_mode_enable(void)
 {
-	arch_enter_lazy_mmu_mode();
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
+	/* enable() must not be called while paused */
+	VM_WARN_ON(state->nesting_level > 0 && !state->active);
+
+	if (state->nesting_level++ == 0) {
+		state->active = true;
+		arch_enter_lazy_mmu_mode();
+	}
 }
 
 static inline void lazy_mmu_mode_disable(void)
 {
-	arch_leave_lazy_mmu_mode();
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	VM_WARN_ON_ONCE(state->nesting_level == 0);
+	VM_WARN_ON(!state->active);
+
+	if (--state->nesting_level == 0) {
+		state->active = false;
+		arch_leave_lazy_mmu_mode();
+	} else {
+		/* Exiting a nested section */
+		arch_flush_lazy_mmu_mode();
+	}
 }
 
 static inline void lazy_mmu_mode_pause(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	VM_WARN_ON(state->nesting_level == 0 || !state->active);
+
+	state->active = false;
 	arch_leave_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_resume(void)
 {
+	struct lazy_mmu_state *state = &current->lazy_mmu_state;
+
+	VM_WARN_ON(state->nesting_level == 0 || state->active);
+
+	state->active = true;
 	arch_enter_lazy_mmu_mode();
 }
 #else
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cbb7340c5866..11566d973f42 100644
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
@@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_struct *tsk)
 	return task_index_to_char(task_state_index(tsk));
 }
 
+#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
+static inline bool in_lazy_mmu_mode(void)
+{
+	return current->lazy_mmu_state.active;
+}
+#else
+static inline bool in_lazy_mmu_mode(void)
+{
+	return false;
+}
+#endif
+
 extern struct pid *cad_pid;
 
 /*
-- 
2.47.0


