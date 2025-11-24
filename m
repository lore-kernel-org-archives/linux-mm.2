Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD499CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E6A6B0024; Mon, 24 Nov 2025 08:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31536B0027; Mon, 24 Nov 2025 08:22:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F226B0028; Mon, 24 Nov 2025 08:22:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CDF5C6B0024
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:22:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02C9F588CD
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:22:50 +0000 (UTC)
X-FDA: 84145565742.14.8435A44
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4FA5F100017
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:22:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990569; a=rsa-sha256;
	cv=none;
	b=luVDswsb/OTetb9msYWQWEhNyXauOOQ/PioFQnQN79hxZMsihqTIjKJi6+aZpPcyy/DwBD
	EYQMtP6co59fveqD7k5kvgT7YrSGvP1fQBhY1hSrrYnS+rQT8dFZKec6rO3Gh/tXeL5D90
	LErGjsqO/qDG+2peaKp+KtxsjCV/9rc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tlUmM8azucNOPukRL/xJOIAfeIfrDcQcwL0QSiE8v0E=;
	b=xy3UfyMAcMKsswDkeY5p9/qiBbcBT1UNstl0uhuxsU9b9/b2aFzode9V+Ae7kZ/Fu3W3ET
	SOhuKVGmG9HXap6Lxyw9NgasuE5sM23nIemJPPqRaQJO10OmC/CG9qgqHYWd6smTT42v7u
	QGeKw/TnehRnJbjzwaoXy00qPwjyNVg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5B121477;
	Mon, 24 Nov 2025 05:22:40 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 120A13F73B;
	Mon, 24 Nov 2025 05:22:42 -0800 (PST)
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
Subject: [PATCH v5 01/12] powerpc/64s: Do not re-activate batched TLB flush
Date: Mon, 24 Nov 2025 13:22:17 +0000
Message-ID: <20251124132228.622678-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4FA5F100017
X-Stat-Signature: bt5uxjisrr1ttisk9noz8dt6fmxihmxr
X-HE-Tag: 1763990569-869491
X-HE-Meta: U2FsdGVkX19OFWHoerPnz8mi4uYIBP3niPt8yUZBNUqa/BiDS+zG5pba+Lcgu25dAYx3joPkHjA0/SPX7v3YWpa7uKHNdh9XppYD50iXRemCMwfkfOqbAAYicBhuk6GMjvhVAferdUDiZH10pG3Kl75OIq3M8T7Bxs6LNPDjVz1Vs2+CD7ofGSB04jgftyLMjj/n75IQ4wH3BH77yLNODBRcIL/J+QyyFReRvh+ML+ANilbaMuQUq4QwzoBC/su/y5S035xIJ0U9Leb6CItgH1tulV36M2DPmXiFIuAqBG06UVE49AoD+wOGNiylL+b6TLxj4NDaMtZRVSWy5uO/gb885DOhOAUpfzAxLMXR4Iy/e90qz/mTyBZmxjS0RqKixRuW6f+q7qgIPOdWRhtZbZGpOP26u822nlJ+x9lZ5veO6BWGo3yP+RL2lwyu40N69dt1JvbB2rym07dPwXP0tt8pd5XhkBymDyMELcmmLH//0unpmSIobVprzj3IDMOlH0NbI4mqCmJ2T+HmAReyAS5Wi53Co1X74ZaMpKB+zcUWDFgv4mfmuW1gMJweZva7hcoSBVvjqGoqFkax2f4qD5pT4IuL0vlVMFsz08hJj4qWoLq2y+MMvAoHld1czi3mJ0Nfa0rqfF6dzlGMaegoopzN5d2bESatfYncTxd2RYJXiS0bdh8svyAsxe9x0gBOT9webqnityKFOopeGWU8t19DHxwN7anAx/1WE1UCb0t14dNRh2qkSdbpjCwDLO9MZKnqd92Ri6OYMZyThkwPApvF3V48nhFZgSirrKM3iIXM3fcqoaR7sUucsEeqYCA0SnNSTwDUH0HJfnwqrR/DNK+xfoiz/DPXdesKhnDjHtXhE+SR+nCqh6I6kp/MW2m7PpcJ0/y5RLBYUDXhNVMyPhw8OJ49QpypvepIddIS79l4+qFDvFxW25afLOS/RU2ldx9PaD+qU6SHLI359UD
 IMzVgTgY
 IZVEeg/rqd6aZGXcilcOmLoqNd3fBg17iuTv2BSypfrQSKoolFzt9rmVkOiVDMo4tclqB5PsRCPPm9yLKj7mTogkcC/mJ9UlUH/xBEjsHP51wkcBTA1p8RoSC1YVn1E75cbl+TkscSMHUHztl9lT2I6puLpWdMyO4QHp1gfNAlZeIh4va8nphlu7b+beBy6VSss7RELT3VmUz0FGwYyKQrnTfU+WeI2vo7W53eGfXFLlD0yIyoj5ydWxaNTyqc3Owz42S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexander Gordeev <agordeev@linux.ibm.com>

Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
lazy mmu mode") a task can not be preempted while in lazy MMU mode.
Therefore, the batch re-activation code is never called, so remove it.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/thread_info.h |  2 --
 arch/powerpc/kernel/process.c          | 25 -------------------------
 2 files changed, 27 deletions(-)

diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index b0f200aba2b3..97f35f9b1a96 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -154,12 +154,10 @@ void arch_setup_new_exec(void);
 /* Don't move TLF_NAPPING without adjusting the code in entry_32.S */
 #define TLF_NAPPING		0	/* idle thread enabled NAP mode */
 #define TLF_SLEEPING		1	/* suspend code enabled SLEEP mode */
-#define TLF_LAZY_MMU		3	/* tlb_batch is active */
 #define TLF_RUNLATCH		4	/* Is the runlatch enabled? */
 
 #define _TLF_NAPPING		(1 << TLF_NAPPING)
 #define _TLF_SLEEPING		(1 << TLF_SLEEPING)
-#define _TLF_LAZY_MMU		(1 << TLF_LAZY_MMU)
 #define _TLF_RUNLATCH		(1 << TLF_RUNLATCH)
 
 #ifndef __ASSEMBLER__
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index eb23966ac0a9..9237dcbeee4a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1281,9 +1281,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
 {
 	struct thread_struct *new_thread, *old_thread;
 	struct task_struct *last;
-#ifdef CONFIG_PPC_64S_HASH_MMU
-	struct ppc64_tlb_batch *batch;
-#endif
 
 	new_thread = &new->thread;
 	old_thread = &current->thread;
@@ -1291,14 +1288,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	WARN_ON(!irqs_disabled());
 
 #ifdef CONFIG_PPC_64S_HASH_MMU
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	if (batch->active) {
-		current_thread_info()->local_flags |= _TLF_LAZY_MMU;
-		if (batch->index)
-			__flush_tlb_pending(batch);
-		batch->active = 0;
-	}
-
 	/*
 	 * On POWER9 the copy-paste buffer can only paste into
 	 * foreign real addresses, so unprivileged processes can not
@@ -1369,20 +1358,6 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	 */
 
 #ifdef CONFIG_PPC_BOOK3S_64
-#ifdef CONFIG_PPC_64S_HASH_MMU
-	/*
-	 * This applies to a process that was context switched while inside
-	 * arch_enter_lazy_mmu_mode(), to re-activate the batch that was
-	 * deactivated above, before _switch(). This will never be the case
-	 * for new tasks.
-	 */
-	if (current_thread_info()->local_flags & _TLF_LAZY_MMU) {
-		current_thread_info()->local_flags &= ~_TLF_LAZY_MMU;
-		batch = this_cpu_ptr(&ppc64_tlb_batch);
-		batch->active = 1;
-	}
-#endif
-
 	/*
 	 * Math facilities are masked out of the child MSR in copy_thread.
 	 * A new task does not need to restore_math because it will
-- 
2.51.2


