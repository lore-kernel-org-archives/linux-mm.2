Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188C6D5B17D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5A96B0028; Mon, 15 Dec 2025 10:04:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737B06B0029; Mon, 15 Dec 2025 10:04:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627256B002A; Mon, 15 Dec 2025 10:04:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4840A6B0028
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:25 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B5D013558A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:25 +0000 (UTC)
X-FDA: 84222026490.12.A8DFEBC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A4D618000B
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811063; a=rsa-sha256;
	cv=none;
	b=ZGFylyGeQtQ90aAbxX+/CQ4WJCV5DIh4oHjTPWEj57u/HvqQiqmsZDNidGT1+mazlp1tsL
	XIT5E86m4qy/xxiPSM3ZouPqiIoyiv3RE1wuxJkGZU7/VFVQzS6lvwTdBuYSNAs4cT0NQc
	YPQaTarJfpvPPij0xJTpXKmH94rAZ/A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwPCDeKwwbwQlMyHR9dxpUzK/M4F6kWCHoFMIjV0Jb0=;
	b=u8lDZhq1ilJP55AzVx+jEqpkc++eaP1k+72HrCsBE2tRZB/8/xa5a6HEyVmiPFKRolkMj0
	VhBB1j1KbEboDgf3ggVmktMpWyGhvOH+QfdW8q/HpDiKmn5pqEF/KKbobRTLZDcc20pvbb
	yzviMM3qVCnjbj/EUfPZ/JVbP6RGK/U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52004497;
	Mon, 15 Dec 2025 07:04:15 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 134D63F73B;
	Mon, 15 Dec 2025 07:04:16 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
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
	x86@kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v6 08/14] mm: bail out of lazy_mmu_mode_* in interrupt context
Date: Mon, 15 Dec 2025 15:03:17 +0000
Message-ID: <20251215150323.2218608-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4A4D618000B
X-Stat-Signature: s6xtbks34cxb56roa86jan3wayugps88
X-Rspam-User: 
X-HE-Tag: 1765811063-549867
X-HE-Meta: U2FsdGVkX19Wc+KRE1ggq2xiO1lST5wQ5naaElniPn/LIznw0h7lx3aXZYCeSz3WwJVWxfX/QqpmPZeB4E/N4SPR6FcTk8MtpUwvuUDJUNpp/BSAvTF4azIiaz5PR/R0IVJcNnBTeOMMxsGoHXYpHzC6PSkGOKfnVJOCnPhZQqyN+42RbhowHSXJ4p6dkn6aRVkiNOxelGR0+pGstcffHDAxxJsEvhBo6+9idJy0B3UD8otp2R5CDUfOGcYQC+PwxPx1TXHQf7vclAKp7He7lKHFv9daQnn/HpynSpJ583G0MudhFdttZQgWIjGpGD+kI61ojOvT64tXT5FsHuoDV94R8IrXRCKKCgJqSNpjZBQ4qt/ahkJYvazO/riaIxuRzmbfIV7DY8RM+kqk+Wbtcp8HC3syTquxKMm6H738G7Bp87P9z16jIM6AfV17x46BTXX1URYd187+TQfSJAk3i94l2aBWqIWQyxRhvQwSfinTVjkvctv+umW2fMi+H31TpoE58DOBj/KwopI+U77wNbigAvN5lPST73S7PdrFpliqmZkBE7taTcHRzRjPD1HsGaLDQvPVfMkWj9FMmZQYCn0LPXj8yxRmop3XMpmIEX+EStyIArHAngJFPPsoW4kdbIOTv67V9TlmB3by9V2qUFPjfqJb3A9aECdjXqXQVgBCemVRl91yclhUg+qRNHgABnDeeccVvouqTPExB3yV+xwi8eZA/VFwtfwDWI981QHiEZXLXruCYepVPndjBuVecUOFmr83NvAddA121oe0UK6wetOsaNy2Sau73CTu+UWOO02k+VaFL+K/UOYx9rAtC6LhPz/OzvI6XKsSG4atRiO7NtE7Q6byb6EOwQTe6DRUyS6dHNAzLnt8+WM2mNlJtNV4sD7iIU5TwoCXsLWxgw14/mRCh0ArHv5Sym89IKVuxM583pJsqw0+68R2DUpZ090u0ecrr+SwNHD0Zaw
 yIQ6HUfo
 QgNiITVf6LJiEaZCHCJLCZzVxqGG5CnfgeUe9migWOQIg/PvFwFTwm9kQ9S2ACbiZnIg2Qrs2GrZU4iHQ03Z3TgVUys37wd8YR3QM78/R6A9AChG1pq7dhhgrU96mab5YRctbrxysro+um3tvKHBHW28zGcX8P/Z3Lui9SSqUgEHn11VzEr4cVo3+pQqWV47JebsWqd2HaS84gLfVlBLppM4i6Cp/e3LA5BHryM0S1EvJvFCVmqHF1ueEC8gJq8QjEYzaZD7Zp2/2G6Lsb0IzlEsI/qDSc+uBVJE6wOTlSPB63OkqfSvLYzjkXQ8s9AM1VZPWFtQZ79iUtsY=
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

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h |  9 ---------
 include/linux/pgtable.h          | 17 ++++++++++++++++-
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f7d66c261347..bf9178902bdb 100644
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
index 116a18b7916c..dddde6873d1e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -233,26 +233,41 @@ static inline int pmd_dirty(pmd_t pmd)
  * preemption, as a consequence generic code may not sleep while the lazy MMU
  * mode is active.
  *
- * Nesting is not permitted and the mode cannot be used in interrupt context.
+ * The mode is disabled in interrupt context and calls to the lazy_mmu API have
+ * no effect.
+ *
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


