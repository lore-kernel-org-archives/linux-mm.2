Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B601CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8618E005B; Wed, 29 Oct 2025 06:10:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FF08E0045; Wed, 29 Oct 2025 06:10:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD1A8E005B; Wed, 29 Oct 2025 06:10:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6688E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE5D35B82E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:56 +0000 (UTC)
X-FDA: 84050733312.14.7E2F22D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4165E8000E
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSTNiBIzFf/HrkV1SFNB0DrJ0+NvHZ8+T6y0GlTjwWY=;
	b=pL/UnNpmCeRlj/r/i/mL365zicL8KyS6rqLDRu/cAYeLdZ/0BDYo3tc9BVgEyoXxNHeAJZ
	t3jDcqNjtnwLehUSI5ToSpxSrAqgWLcXRbNTfgULS7cWwZX/83eVR/E+IydVE3R1xRCKT/
	h1rocZDV5F3yM0o/xRR4L6MN9zgOpWY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732655; a=rsa-sha256;
	cv=none;
	b=ZNTXMbxktjPzg/DEURSjMQ5nbJu8ydEUTmY5OZ7viOwYksCFxiRIvpCLwI5ta2HFa3If7X
	6Zb8eWLcwW5KxifhEqIhEfo17MlXG+Hl6Mp3laqPWbWfBL/cN1wiurFbfiXO+HTtNvGmxu
	Ha773DjgYN8OSqfPLY0QrN1ClfH+sq0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9FBE32C1D;
	Wed, 29 Oct 2025 03:10:46 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A7ED3F66E;
	Wed, 29 Oct 2025 03:10:49 -0700 (PDT)
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
Subject: [PATCH v4 12/12] mm: bail out of lazy_mmu_mode_* in interrupt context
Date: Wed, 29 Oct 2025 10:09:09 +0000
Message-ID: <20251029100909.3381140-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4165E8000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xdedwo9uidagi4qcb8d3h6z1zp68st4h
X-HE-Tag: 1761732655-36707
X-HE-Meta: U2FsdGVkX199o8pSZexsa5N1TJHwfo66+nynlMRfm6BS3LBwgHDPDn39G7JurYLVY91rBt8SeKcWoQl+fUrgYe1nb9SVvjWwQq3UAPMcIkp73pjJlBL+3Jc7J+F3aFFx9EN4+DFHj8Qv47OkEHdHQLf2EecykaA3kSJ8urgtr9sZaUk/CoySDaUajeMg6r85NtQ+RAFYy7BYTVUog30seI91E0y9tb9sKE7QVvOuSJpbBgz9DRYLF03ssw4A3APkYDA0qc2E/IaOHeGVlUY5ixR1DccciDv/z+q0bmibU8N2LlPq6TGjHx3na0Yt5wkSFWzCbdmfBGkLMXncbbY0AtNA3uDzY92LvjtBCK3iAcCUFcTMtxPtlc9twStk1HRL+XHtBI0aee+oaMRZN5Oy+TyCs5jx9ql1KmYm7GL2PP6Oyn6wHj4JegoKnSA8Gz6mQFWWD33vPALu3QHAKsqgLc8lDQGI9u5abFx3FqmJ9eTOJ7kFDJkEUZrS8llxMZdRvuvRDY/aTKjcs+1DZLJJixHbbNa72YyS+9xgNyU9gI0m4QNqH4Y73LdXG4Tu6Hz6TA2Gsj4TemLd4Lurw0MzzzU8r/f2c2CH0fRg+UlcMbZaXqyWOUzy5K6KM+uCKZRAZ87nKa/l/EkDZCML1bPdMF1sgFiTVzGzv08jW0An4/M1aTqmNFotsJwOVwFPBOZKSuUxdy8eb5FljQ2DHnH0MD4g4PbS7e22diXNSyz0Ju55f5ICocG59IIh654xXOXbNL5vstHTjTYqIJdGAwIHc8AvNG7i2+CmLcAG41HGpWL9vw4AamhesWJ716dmKmloksmazYh69NAsk38x8GHAaPut9+c5Oxmx8srBpDpyn+8UqTaQnRUwT7iXLtE9ykDVfFbkoLSoWaUIJiGGQdTVKzdC6ZpSyxvUACWHBiqtNAFCZste/0Bja+cmbNl4pxRMq344oMn/E5YXVa5ipMn
 Uc98q/gg
 ox3UPC+KC36ne4XJQvi16KPDRr1KlZFu1epQAJKYIkuoXy9XLBn9rLVvjX0cA7IokoCaT2lsvbcETIW959yHRS1aW39r7FinUBafGsQwakmsttvadwuwim2wlApJTf4iI7wGWmw4qf1+LrwkyFsTbJfPWYbw4p1j7plN7D6n5DdoBpy32redxTrfrC7OVBvFLZEDNyfA4V/bsnYtzfhOQhGrLgGNflsrBmHucMbKzRUNOWaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy MMU mode cannot be used in interrupt context. This is
documented in <linux/pgtable.h>, but isn't consistently handled
across architectures.

arm64 ensures that calls to lazy_mmu_mode_* have no effect in
interrupt context, because such calls do occur in certain
configurations - see commit b81c688426a9 ("arm64/mm: Disable barrier
batching in interrupt contexts"). Other architectures do not check
this situation, most likely because it hasn't occurred so far.

Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
disabled while in interrupt mode (see queue_pte_barriers() and
xen_get_lazy_mode() respectively).

Let's handle this in the new generic lazy_mmu layer, in the same
fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt(), and
have in_lazy_mmu_mode() return false to disable any optimisation.
Also remove the arm64 handling that is now redundant; x86/Xen has
its own internal tracking so it is left unchanged.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 17 +----------------
 include/linux/pgtable.h          | 16 ++++++++++++++--
 include/linux/sched.h            |  3 +++
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 61ca88f94551..96987a49e83b 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -62,37 +62,22 @@ static inline void emit_pte_barriers(void)
 
 static inline void queue_pte_barriers(void)
 {
-	if (in_interrupt()) {
-		emit_pte_barriers();
-		return;
-	}
-
 	if (in_lazy_mmu_mode())
 		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);
 	else
 		emit_pte_barriers();
 }
 
-static inline void arch_enter_lazy_mmu_mode(void)
-{
-	if (in_interrupt())
-		return;
-}
+static inline void arch_enter_lazy_mmu_mode(void) {}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
-	if (in_interrupt())
-		return;
-
 	if (test_and_clear_thread_flag(TIF_LAZY_MMU_PENDING))
 		emit_pte_barriers();
 }
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	if (in_interrupt())
-		return;
-
 	arch_flush_lazy_mmu_mode();
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e6064e00b22d..e6069ce4ec83 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -228,8 +228,8 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). The mode cannot be used
- * in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode is disabled
+ * in interrupt context and calls to the lazy_mmu API have no effect.
  *
  * The lazy MMU mode is enabled for a given block of code using:
  *
@@ -265,6 +265,9 @@ static inline void lazy_mmu_mode_enable(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON_ONCE(state->nesting_level == U8_MAX);
 	/* enable() must not be called while paused */
 	VM_WARN_ON(state->nesting_level > 0 && !state->active);
@@ -279,6 +282,9 @@ static inline void lazy_mmu_mode_disable(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON_ONCE(state->nesting_level == 0);
 	VM_WARN_ON(!state->active);
 
@@ -295,6 +301,9 @@ static inline void lazy_mmu_mode_pause(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON(state->nesting_level == 0 || !state->active);
 
 	state->active = false;
@@ -305,6 +314,9 @@ static inline void lazy_mmu_mode_resume(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON(state->nesting_level == 0 || state->active);
 
 	state->active = true;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 11566d973f42..bb873016ffcf 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1731,6 +1731,9 @@ static inline char task_state_to_char(struct task_struct *tsk)
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline bool in_lazy_mmu_mode(void)
 {
+	if (in_interrupt())
+		return false;
+
 	return current->lazy_mmu_state.active;
 }
 #else
-- 
2.47.0


