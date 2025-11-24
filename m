Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BAB7CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8E56B0092; Mon, 24 Nov 2025 08:23:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B887F6B0093; Mon, 24 Nov 2025 08:23:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77276B0095; Mon, 24 Nov 2025 08:23:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91AA96B0092
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:37 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BE11A1403C6
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:34 +0000 (UTC)
X-FDA: 84145567548.30.02E7EC9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B7D61C000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dSyxRnhYlcdu1xBdpSSZm2FOOGLwAL5f1r1w6ewElg0=;
	b=OhE3gmQLZWCjQbIS5YkYyiMdTljz6IbIKFFyGracjkS0JP0vN5kMshbHOzz/g3ZQZwdB3W
	6txS9AxipHg3KY+hinB/m9nHunD2wOOCDwuVSziXnAzkZe0AzhOpZSQhpqZ3KM+JpcgI4p
	LfaLQbtpP0PI9BxR71ig8E8Nso70mAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990613; a=rsa-sha256;
	cv=none;
	b=sMQNOyMukG/ziyKZMo73iltwPZ6r8qj4EL9t31NeG4KFzKtZuhbuzxcwo6S7xTkL9YZyQn
	QFbVAYdA2F62szdgwli+mCMBtmTDAfqjsq9jJnEeu45Qff2QMZiV859Ayu3DEiiIZhWXY9
	be7O8ZmUjDkuKa1ZAxvz/RUTbdBtYRM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1C19168F;
	Mon, 24 Nov 2025 05:23:24 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F00C93F73B;
	Mon, 24 Nov 2025 05:23:26 -0800 (PST)
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
Subject: [PATCH v5 09/12] arm64: mm: replace TIF_LAZY_MMU with in_lazy_mmu_mode()
Date: Mon, 24 Nov 2025 13:22:25 +0000
Message-ID: <20251124132228.622678-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B7D61C000D
X-Stat-Signature: 19n1ao7wjouakq5twxowedk3eksau55z
X-HE-Tag: 1763990612-688006
X-HE-Meta: U2FsdGVkX1/Ga25Haajm2y8tga/jpTj6kWJUAlVhzQtHfNGqu1kmQRGh0Qiwfl4s5UkSMUwqaCgEOUA4JyqKxbtzpZ4OpC9OIOZJJLHC1v6bcuHWegYt1v1/8J2CwtL01qFIZlGZKyuGfqS55lbH7JRR8yoB0eGqT4c8h9zCjDdPN5iZ4/R6of7AMh305LxvFlEYRjiQ1Yu9jSOmFqZlGsm1IFu1ChMNukhrMk7o1m3rONusH8p+rpdkSZemRAlwCHj1krfJoJVg8MK+pyIVMtbyKW9SN01mS2Dmw0UL71RxwGzgWp/hV/Fo5RuDD8/lmxuvxRnWoTRZIHqDg2005P4PY3inCDmvfZwfUuoqGn9FS7LT4ZZPbNdkQp67PIlc4F8tK0Z44QHd0NNPs4VXrf2iY9BBl1C3FhmmWP+FailU4SETd6G/R2e3xu8KYJXB6y6jy0uTTd8AupyuhIH2FwRPiUDKdJi4IqXT6oAoScqtXrci49UqnSVkx5Zqkq5lXpkCOUIsJbjcsP1oooJVFX945HnZZMiM/uRT1BwLb7DBX3Ou+wVLX4ufya1sfM7u13kbmM65JIWAV0IDtmd2Au77puFL0sdP0dc4EPCPxLj2AXUuDJJQed97QXJ8hEqeEH2pLnyJ32Je1f6rJeHorAV3hZ3TMHwPde8l7e2M9MATAKxTJ4OMoXr5+roYBVFOIQoxF1g1lvvO4iHfXDskmX/qzi1VYO2LID/gpsl0oPMRrAnGmk255eI5JFMqDc/Gv8evo8rfBrB7FXemM3tfx/IrcAA60S0L31uKFNgsPAXOB2eqc52nHPn0k3ffpEs4nXmS74YLAutu0H7C7JuJqJ04bhA2pU3DGB1zkJvJn7KrQHFRQPE2ryKhsZh3B77TSWTyVhBWavLR2jb1Nkyr/l3oiClBcHDEYDcRSlfjJ9yqTTpMr5CZXYHu5U3KYI+mzVO7YovWe9jM+Rpd8wb
 vjNubH64
 uwq1LL0yQyAAF5SE0jrSO9Fm5ven8UEeRkXDNYuEZtevh08AxGah9EJBY/tDwrLpbaGQCM62Fsg10rPJ9nM4aSUyj5qFvd23iCTsddcAd/5aoYzkGdxALSfxrpyg+M8UrbAevRNfnC49sRTOrtAk9d7QYZcjL364UV6F4ClPhHtyb0nKhQekNjwzF6ONsQzZlQtOW03Y8ml1YiJDC9bl+Qe3cpt3zsfC33CG5tVSoDae0y4ll+Z8v3CjOC4BwRIm52UWbID8xMYpfBgXQ6LEzPpqIkd0SrXu87L1SZp82uPHhJ2/7UqbU1+Qlmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. As a result we no longer need a TIF flag for that purpose -
let's use the new in_lazy_mmu_mode() helper instead.

The explicit check for in_interrupt() is no longer necessary either
as in_lazy_mmu_mode() always returns false in interrupt context.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h     | 19 +++----------------
 arch/arm64/include/asm/thread_info.h |  3 +--
 2 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a7d99dee3dc4..dd7ed653a20d 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -62,28 +62,16 @@ static inline void emit_pte_barriers(void)
 
 static inline void queue_pte_barriers(void)
 {
-	unsigned long flags;
-
-	if (in_interrupt()) {
-		emit_pte_barriers();
-		return;
-	}
-
-	flags = read_thread_flags();
-
-	if (flags & BIT(TIF_LAZY_MMU)) {
+	if (in_lazy_mmu_mode()) {
 		/* Avoid the atomic op if already set. */
-		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
+		if (!test_thread_flag(TIF_LAZY_MMU_PENDING))
 			set_thread_flag(TIF_LAZY_MMU_PENDING);
 	} else {
 		emit_pte_barriers();
 	}
 }
 
-static inline void arch_enter_lazy_mmu_mode(void)
-{
-	set_thread_flag(TIF_LAZY_MMU);
-}
+static inline void arch_enter_lazy_mmu_mode(void) {}
 
 static inline void arch_flush_lazy_mmu_mode(void)
 {
@@ -94,7 +82,6 @@ static inline void arch_flush_lazy_mmu_mode(void)
 static inline void arch_leave_lazy_mmu_mode(void)
 {
 	arch_flush_lazy_mmu_mode();
-	clear_thread_flag(TIF_LAZY_MMU);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index f241b8601ebd..4ff8da0767d9 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -84,8 +84,7 @@ void arch_setup_new_exec(void);
 #define TIF_SME_VL_INHERIT	28	/* Inherit SME vl_onexec across exec */
 #define TIF_KERNEL_FPSTATE	29	/* Task is in a kernel mode FPSIMD section */
 #define TIF_TSC_SIGSEGV		30	/* SIGSEGV on counter-timer access */
-#define TIF_LAZY_MMU		31	/* Task in lazy mmu mode */
-#define TIF_LAZY_MMU_PENDING	32	/* Ops pending for lazy mmu mode exit */
+#define TIF_LAZY_MMU_PENDING	31	/* Ops pending for lazy mmu mode exit */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
-- 
2.51.2


