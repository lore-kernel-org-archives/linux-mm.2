Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAC8CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399E16B0030; Mon, 24 Nov 2025 08:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC0D6B0031; Mon, 24 Nov 2025 08:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB346B0032; Mon, 24 Nov 2025 08:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6F86B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3E7D86984
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:23 +0000 (UTC)
X-FDA: 84145567086.25.AFB19D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D5D4140011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990602; a=rsa-sha256;
	cv=none;
	b=xRpSUe10dsissd49bhcpvp1ZeXWeU2oeTgnmzkaHUIJ3WVD4rCM5XwdxeLrVPyIkoCFN2t
	Zj6sWTtTLgzLVgXm4Chj8TpA71jAlQ1dTDpxYuR+GHniL0jjPS0v9TEGhpW8llGbi2CATf
	3uABykhLkBgDZiMfEj5wgZqnEL9ZMQk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SujO66NMAh4FvpryErSRWX2LVHVIqym4Euvy8RRIts8=;
	b=LZjcv2idInpfHu3464m6b1lZqFttHxyeSw7kgI3csGT/4n1piGJbNk5YeJ1GtfTb4RTxP/
	InNicB1VSXYpDuPo2nyS3W374qgjniiBy8Ek4XeR3T2ptWe6W4pqa/JYyrVh+VgW8547Tz
	bHlljpfzhaji3zEGFPSkn0dPSnduLh8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD6DE497;
	Mon, 24 Nov 2025 05:23:13 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09DCF3F73B;
	Mon, 24 Nov 2025 05:23:15 -0800 (PST)
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
Subject: [PATCH v5 07/12] mm: bail out of lazy_mmu_mode_* in interrupt context
Date: Mon, 24 Nov 2025 13:22:23 +0000
Message-ID: <20251124132228.622678-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1D5D4140011
X-Rspamd-Server: rspam07
X-Stat-Signature: xujh5xa9mo39wojzs957bj8keujm6unt
X-Rspam-User: 
X-HE-Tag: 1763990601-363503
X-HE-Meta: U2FsdGVkX1/m7itB6ehsVzW5PnjkLGpRUMxxNwPK1+EGIyR6swcFCx5d7ZsyKpk8mvgnSqscGUlxJERB1kZxAccp7MXzeriD3nPmMCo8DR9YpqlKJVXY/ihRYR5zky/E1WHsGuLN11dGjWv4bWcO6R1iHje0FrC92ovXl66nJ4Jmt1ghXLrQYpKL2podeiuOTRbXaGuHsAbtfT0jUndJ2KepHINdRq3S/sdDveVv9DOV6I8gniGx6mt3sxR+MORG/E+6zEEzDvffDwFF4oWCI4U72lKST+0t4dHs9mYanLegOg2RHiS+pWTK95CMGiwDrfCwNHVoT9beqshBNvkCft5sz6dw3WcP9PKR2+/NQdyusI/kPPRgffsOHVdYOSev+opLnzAVUxqTDwPJO9t0vUPdy67+ZQcvY5O1CherTtZu9VN/e8yMY7Qu8fVLpM9dURQzN4DwsSYfP5zQlDb4AQjOUdgb1aR0JDhv1Hag4jKuZpOqSEm5g8CsJXEbS9/wjnK1jUMq6xO5FYh+HB8pB6+LYJZ2pbcvVF3bjdmcyDMNhz5KcNQ2BFmck7y5RIYxAbDeTUFSEQcLQNvsER8UkAbkIadewKZIYo4veOhELHy5cJ4wQz3CtLKycS1l1MEGJm5sRnnmotUa2XjmniPYY6Ly1fPNEl2wc11OhpRAotSCbU6E3pV7/zbZAOvx1HmtAWWxzZypy64O43VlJSQ3vu9LPREGFxkf2C6Wt215kDnVd4+w2NQdRixPPWntwTuewSXcU7oie+tweVUEpFTq1xpT58RsWULSIBlh4nWx/JprG0LOZDRhNiglsieEHmvBuKoJNAFTd2+ZwTw0Vmi5XxVuNdlbuVc5JutvHEv5OjKH2i1gKyaQdtx6IapdD+nr1E0IucKvQPEuS/zPCIU+ogKMS8W3ct8CRhxPLrGeKKlq7skAkaW0UTpHTPOX8c/UoZqtJuxfeHMdD2qWs10
 ZJVfQuB2
 OOMthmwf0J5qa0L1maxqCQ5E/yYJSEmR18z6yBZkcXgw7kP5fKm4cONyjf6ldKaT4jCQZM677sl8OAmyz/N1Bw9b7EWdiMFqjGpd5dVxP9gsSv4MQ1e0chqRcLYAz33uJESxMfJpgjUglviUnWXg+nWl7Rx9sbovQA4LK1pV/rHuQFbmIvR526ucI1gwTgO2t+2E7tI1jFiMa6MnanSv+reCWKj9IAxO5aXYDyVMBe6Sr0wfduOZ1jA5NXE7mofhXiJyDsOpDHub/cK1VM6Qp5hg0/vLmDNXYi6Pp+d3nrKdSBNdFTRdwBQeQqw==
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

Let's handle this in the new generic lazy_mmu layer, in the same
fashion as arm64: bail out of lazy_mmu_mode_* if in_interrupt().
Also remove the arm64 handling that is now redundant.

Both arm64 and x86/Xen also ensure that any lazy MMU optimisation is
disabled while in interrupt (see queue_pte_barriers() and
xen_get_lazy_mode() respectively). This will be handled in the
generic layer in a subsequent patch.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  9 ---------
 include/linux/pgtable.h          | 17 +++++++++++++++--
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 54f8d6bb6f22..e596899f4029 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -94,26 +94,17 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	 * keeps tracking simple.
 	 */
 
-	if (in_interrupt())
-		return;
-
 	set_thread_flag(TIF_LAZY_MMU);
 }
 
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
 	clear_thread_flag(TIF_LAZY_MMU);
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index c121358dba15..8ff6fdb4b13d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -228,27 +228,40 @@ static inline int pmd_dirty(pmd_t pmd)
  * of the lazy mode. So the implementation must assume preemption may be enabled
  * and cpu migration is possible; it must take steps to be robust against this.
  * (In practice, for user PTE updates, the appropriate page table lock(s) are
- * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
- * and the mode cannot be used in interrupt context.
+ * held, but for kernel PTE updates, no lock is held). The mode is disabled in
+ * interrupt context and calls to the lazy_mmu API have no effect.
+ * Nesting is not permitted.
  */
 #ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
 static inline void lazy_mmu_mode_enable(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_enter_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_disable(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_leave_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_pause(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_leave_lazy_mmu_mode();
 }
 
 static inline void lazy_mmu_mode_resume(void)
 {
+	if (in_interrupt())
+		return;
+
 	arch_enter_lazy_mmu_mode();
 }
 #else
-- 
2.51.2


