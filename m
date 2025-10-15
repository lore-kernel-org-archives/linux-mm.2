Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D567ECCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7358E0019; Wed, 15 Oct 2025 04:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EAA8E0002; Wed, 15 Oct 2025 04:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBD18E0019; Wed, 15 Oct 2025 04:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BDC58E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA38711B32A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:49 +0000 (UTC)
X-FDA: 83999672778.13.0E60E9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 226B34000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gxy2WR9jIOFdN7YJmtvFh7KSjx/WBbD3EHjVYsBnWoI=;
	b=yANeeOumEr/vBCUhogG50r5U4PQAVnUomjFrQf1VbRDaNDKbC+49Lw97/d98JVMSDh+tBr
	2EjoQRYoieYAD8m02HafRfPVjq2u+lq2PI63NAL5V7v1A+YeHu6cLHr6YizhO/stnCeR83
	cRdKy56+OXEBdDRKFvBgCpHC5WeUq84=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516928; a=rsa-sha256;
	cv=none;
	b=JJZ2czhWSKrnKw55Q95FbnmMUjTYPdEL9E/gArX656eZQ+ifynrj5J3p2/Nmf2vlwwhFi5
	NFBw1kCBk+btVLi0S02fni/uhzMPC94NVQUsdcDJiB9KMBe+HJ81axWDY6KrJOeCI6d9P8
	B5tZEq9efUlDBClslVQNYVJ+cI6t26Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78DF9236D;
	Wed, 15 Oct 2025 01:28:39 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 754613F66E;
	Wed, 15 Oct 2025 01:28:42 -0700 (PDT)
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
Subject: [PATCH v3 12/13] mm: bail out of lazy_mmu_mode_* in interrupt context
Date: Wed, 15 Oct 2025 09:27:26 +0100
Message-ID: <20251015082727.2395128-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 226B34000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: niibiqbkt3gjwg5icwjucjn8omsafyjs
X-HE-Tag: 1760516927-174467
X-HE-Meta: U2FsdGVkX1/VBfkGMUan1wAkdMjgBxa71bTATEVVsG+cdVRe7bAgI55SktNaeRwcfK+hOiUvtHIDR+lkK3pUbg2P+s+5VGWPlBdX92RMi6lAEOdlojwJGliqyBzhwfw5OXxyoiSICwYhkSKiWScHsgUj4hJOrc2VYVjUtwSwfrJ4dXCE+rSW1cpWvR8CG2GGR3by/OvNfSxb5760WRLT4TgUUXz+7RGkkRup4/NbPpIinbpCw/Qlo6TIB8/6tw8ODRsbuNgGOusQm7VxBF1fnJ5H7djh6lvbdv7wzJt+9FfrF2iQtCrP8eok6+3U6T7D55M1hmuHu2BYY7hi2tGO4IXViO1Lwnsi4t3rzyHgeTi6eHc4o6e4Rx63ovP5fwllfdEkiBqnv8Kd3v9nSs79mNtqI2RPknfo6sdrQQTBelWNIuHLbdisq+KVg69SgUFElmRXDgY4z/0qOvMF3R1aYTmbv+7dKtUyLij2LiNmsVCaelCYhnw2ksJ1w1blopmWuRufsvcjFs/HB0epGVOdmmAyXRJNm5LwVmz4Iw0L4/L490yc6qIWHonKAknsoshHacb02qR0q7l0QsYLopHBM79LS/Jt7aPGz8tT6OJ5JbjlIYhTyAfD3bXYFe221y3dGPNXooLAuEu86+0QBJi0c4R039O4HrBBsKgjcb9DgrJtWgQuPg+ZAHTE/jMDxzP3EhwU/UPCfC3vmtyBaVTJ5maCwztxknNbqk9k5/UDwNGVDA7zdpGviXMpfeoQTeJ6+4xCwH1/ZlPONK3G3oQ0euonWcC0xeEnGct2P69BhI/Rx+sGjWQOcnOZLzoYvPAURhC+uhhryG9nnZhoWDiKKh8klJ52kKvUDacU7AYaJLqRFTtOeKBf2Qnlu0GE/6kP8JzXfqE3o7tqcWT2EGLceSNOfvOgzlAIdt0il2TYJjrG6ltXPztBa2dE8aQGMeIGH30RnaQs3/48I0oCcmJ
 xPaHUCbx
 knpxGd22AJ/MrVKIg1NqSPCEipSpIDL1Ws5z/wzPJfIs7QAHQQHPZVdJvTKA4HsEr0Pfj9GSTYWPkl34PlzbE9lFmyU9uKz9UUloiG68mJ1OzSh5NdjEUyznqJOPtAw8rV1dKEwTcgxduIRr41q0J+q1GWv3B1fV4AT4VXHFHUM/jydNXsq2edpv81InVGL9lPcnhrJ4gj9EqfmszFh9uena1yOUe66blSPSMhhpZ8B6/WMQ=
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
index 944e512767db..a37f417c30be 100644
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
index 269225a733de..718c9c788114 100644
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
 	VM_BUG_ON(state->count == U8_MAX);
 	/* enable() must not be called while paused */
 	VM_WARN_ON(state->count > 0 && !state->enabled);
@@ -280,6 +283,9 @@ static inline void lazy_mmu_mode_disable(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_BUG_ON(state->count == 0);
 	VM_WARN_ON(!state->enabled);
 
@@ -297,6 +303,9 @@ static inline void lazy_mmu_mode_pause(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON(state->count == 0 || !state->enabled);
 
 	state->enabled = false;
@@ -307,6 +316,9 @@ static inline void lazy_mmu_mode_resume(void)
 {
 	struct lazy_mmu_state *state = &current->lazy_mmu_state;
 
+	if (in_interrupt())
+		return;
+
 	VM_WARN_ON(state->count == 0 || state->enabled);
 
 	arch_enter_lazy_mmu_mode();
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2862d8bf2160..beb3e6cfddd9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1731,6 +1731,9 @@ static inline char task_state_to_char(struct task_struct *tsk)
 #ifdef CONFIG_ARCH_LAZY_MMU
 static inline bool in_lazy_mmu_mode(void)
 {
+	if (in_interrupt())
+		return false;
+
 	return current->lazy_mmu_state.enabled;
 }
 #else
-- 
2.47.0


