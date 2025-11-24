Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B66BCFD31F
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807CD6B009D; Mon, 24 Nov 2025 08:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791D96B009E; Mon, 24 Nov 2025 08:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 631CC6B009F; Mon, 24 Nov 2025 08:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4B96B009D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17CAF14037E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:51 +0000 (UTC)
X-FDA: 84145568262.08.44B46B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E32218000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7d4Hx+/jSNJzFIDxPMp3ANPnah/DpPc1NXVsMX3uNvo=;
	b=416Dh3iMzxCF6DszH4ezXwf194bawh6LJMGvnZZLnmJj709Y6WeSb52gy0eF1t4Z2dNcyd
	Yb/MfQC0MoZYKAyPGRWXUl0MnhfQcRq77MYq6+0+j7fJdX/sPhZSuhXh/MNcICsBBNQS4t
	USG2fdE9yRQPe8NalN6MMR5OMUpZJRI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990629; a=rsa-sha256;
	cv=none;
	b=ZFDluyGRLHv1P5rZRHlFyCAm2rjqWzV/rSPV+1yFY0TSZaplEVYykaqBkJzH75Q/sXJOw1
	xbQ5RnlT3UsKVP3vqFkw5l+ATdK5uahFdjQK5eLNoHP55dhqUZV4xy6RJAHAeUtdJFURp1
	M+XYSnBTcE9DSiGYZZR97T8n1zNazfM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32E20169E;
	Mon, 24 Nov 2025 05:23:41 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80E893F73B;
	Mon, 24 Nov 2025 05:23:43 -0800 (PST)
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
Subject: [PATCH v5 12/12] x86/xen: use lazy_mmu_state when context-switching
Date: Mon, 24 Nov 2025 13:22:28 +0000
Message-ID: <20251124132228.622678-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E32218000C
X-Stat-Signature: jsde9qzmpgfnbjhn4hm3hgtk54zo5nuj
X-Rspam-User: 
X-HE-Tag: 1763990629-893421
X-HE-Meta: U2FsdGVkX18UnABa4z2DP1V9omdhiHlspaxijzahpqynoXrl3dx3c+C3M3T5waGERBaYCZ4spVH+GrquU/g8/lLagM05ndwJdyPKMDRsUzJTtf9Q93jwF2W9DxTnGlQ2dzIg1O98YBTzAivsjrNSLIGvh+SmVhmV8BX239osRXJ307LiHVpP/9UCymYUGDGlJC3LgLFb1jPAMEehrq+i/I6qijyEuFDEuHyv6dFLVJBv2QdCalqcasxo9yDqQMmQEJ81ukHrKz/JAryI7PRZR/jqJRvVU5SWSF/FCiS6RQLKA5IcLnLnC2Xea63mak7IzZgZ1k6uXwvKmHO9XB8PKYdZlRA4dgbQPHgwEe2z0YoWWFlnovXThPQGmbYnRy/LH1YgFNlfHOe5t13PNEZlvVGNgkwn6VFwb1MpGGm3QJtGzXP2uqCuZ1Z7gtBWNlyiBbgNIk4JRw1+LtdtTX6VTx+C9t+uBVeHDu1ZxxchfIhoVzv1O2i04t13iUVdYIGBBacrafTVtMyzzbQNA8bPiTIhsvw7WYl5RvbriwVw/qahQLsAk1RbMow3UOgWGoeYjaHP1tu6zG0oNEx6uJDWbL13FxHjyb6ausAVhcw7iwQ33TJhG5VPwyqIr8nmZEWQgudCskCMBlQqo7xMfiCzXJriumB76fnN/2+1j0+VRHNuAMjLj3/ZRJy3Dpvq8uAvlPrA268C0aunnOeJwFX4sx8ezzwNxmLM6Mp1uYke/tlb17VJgOOUBVRprCg7xyRQ1lreZIQ+sUXvrzmu4v5BYVtE3h76paOct6izuMJNGMRuEnIK1nwkSwAj6F0+iMIsP/srQJCLns3ZRWjcrbrnH3UeTjbYoCAz8Khxq61u69Q1OJrHn2Z5n9Y2GNDTH06hByM7ZURUzO+Cv1eHzy4ptuzTYPrXWzMSIwFPrwBdQatyBquhyNSxZDiNHWDdade90X424iDEtt636HYr4/Y
 YC5XIPS+
 vSkQtDlQF77qr30WffJaf4veLrc1DP6d4tRTr3Oz0ZLMLLpebRm2blVnhA/iU2ytIUgjUOwWO65fVV2W+v36FfwiAF9AiGncNoYcBpf3N9Hmy/NzfD+T+qYAFtIY6uo47x1WoEWK6i8mkWKLpYRHcbiBiWjju2iDg26bK9zdwFpZkYSeuxitUR/O2X+L0QYNDSgngqfkb9+9SqdEgcGIPohvQGcjB+czDiYvDxhAyzr/QWavJa8pnFJ2huSSxzF49f/zJkBNX9DHpEas5m1wWndkwvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently set a TIF flag when scheduling out a task that is in
lazy MMU mode, in order to restore it when the task is scheduled
again.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode in task_struct::lazy_mmu_state. We can therefore check that
state when switching to the new task, instead of using a separate
TIF flag.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/x86/include/asm/thread_info.h | 4 +---
 arch/x86/xen/enlighten_pv.c        | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index e71e0e8362ed..0067684afb5b 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -100,8 +100,7 @@ struct thread_info {
 #define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
 #define TIF_SINGLESTEP		25	/* reenable singlestep on user return*/
 #define TIF_BLOCKSTEP		26	/* set when we want DEBUGCTLMSR_BTF */
-#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_ADDR32		28	/* 32-bit address space on 64 bits */
+#define TIF_ADDR32		27	/* 32-bit address space on 64 bits */
 
 #define _TIF_SSBD		BIT(TIF_SSBD)
 #define _TIF_SPEC_IB		BIT(TIF_SPEC_IB)
@@ -114,7 +113,6 @@ struct thread_info {
 #define _TIF_FORCED_TF		BIT(TIF_FORCED_TF)
 #define _TIF_BLOCKSTEP		BIT(TIF_BLOCKSTEP)
 #define _TIF_SINGLESTEP		BIT(TIF_SINGLESTEP)
-#define _TIF_LAZY_MMU_UPDATES	BIT(TIF_LAZY_MMU_UPDATES)
 #define _TIF_ADDR32		BIT(TIF_ADDR32)
 
 /* flags to check in __switch_to() */
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4806cc28d7ca..98dbb6a61087 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -426,7 +426,6 @@ static void xen_start_context_switch(struct task_struct *prev)
 
 	if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
 		arch_leave_lazy_mmu_mode();
-		set_ti_thread_flag(task_thread_info(prev), TIF_LAZY_MMU_UPDATES);
 	}
 	enter_lazy(XEN_LAZY_CPU);
 }
@@ -437,7 +436,7 @@ static void xen_end_context_switch(struct task_struct *next)
 
 	xen_mc_flush();
 	leave_lazy(XEN_LAZY_CPU);
-	if (test_and_clear_ti_thread_flag(task_thread_info(next), TIF_LAZY_MMU_UPDATES))
+	if (__task_lazy_mmu_mode_active(next))
 		arch_enter_lazy_mmu_mode();
 }
 
-- 
2.51.2


