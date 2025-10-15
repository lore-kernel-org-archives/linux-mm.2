Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A99B1CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134558E000D; Wed, 15 Oct 2025 04:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10BDB8E0002; Wed, 15 Oct 2025 04:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 021578E000D; Wed, 15 Oct 2025 04:27:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E45118E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:27:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E59B13BF57
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:27:50 +0000 (UTC)
X-FDA: 83999670300.05.E20AA5D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C2C7D1C0006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:27:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I83fbc1i6YBh9Tx5vcIae/Zyg2QUUX+f5uI4Ym14wuE=;
	b=AWKh/2LEdBiHKkrD7GRetulodwaOjbLjRBxNowiocq9hJYtFO5V0Ywrv0X+noIItVKyitE
	dRiH6a47YJZ2JWMIdJ/VaM9JXNWuVQljaptJIbUopV2J8228IhbEdNJ9MJEv168Ci6ixl6
	IDQGQhPyfoHqYCjrPH4ujtzSBTlR9BU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516869; a=rsa-sha256;
	cv=none;
	b=EJQomDMlkf8lYnTYax2nOYYDgmZG6n5HbQcylaDHh0Lq3gXcWUMciZXeIr9G8siIKFIB4X
	iemXP9HERJ4h4zFmxm+5CtlKzPSDFeh3MCdgG8MEi1b0LMmsv1NCVptC/Z+snUJX5eQg+X
	vHnK8RwM0Xkejv2nojBrImQ3BMwIbbo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE70F1A9A;
	Wed, 15 Oct 2025 01:27:39 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB26A3F66E;
	Wed, 15 Oct 2025 01:27:42 -0700 (PDT)
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
Subject: [PATCH v3 01/13] powerpc/64s: Do not re-activate batched TLB flush
Date: Wed, 15 Oct 2025 09:27:15 +0100
Message-ID: <20251015082727.2395128-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2C7D1C0006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4pz7kets8qeiqtk7asfj63h1dcjnt8zc
X-HE-Tag: 1760516868-436728
X-HE-Meta: U2FsdGVkX1/2dOzDbj7bYE9rUmstYlEfahdFAHZwtRDR2MxzirC1YxICsqPQjURzhUSidFQmju7NmOBo7NQwVOeIi7lFIrYC89ma45Y3Q0XAuReqmyUCHsPRqoB3+S5c6l5PZNntnAEqM8Dafhi6qeXTO70F4FoOIEcNLWYbCZBzb19vnpK3EHsh/fDoBN6Lp1a5AA430EHl/K3WGdx0CBTiZzWFKFwzMABlJamywojnsS2Ro4gPomleI+Z5VJjPA62FCCVoGQ16V7sgsxJyB0RGxzmuhmjOfm9sFrwIxU3ltAfWCisa6Nrt/JGjngViJDh2v5JEBbfhNG07HBZbbzI5nirdQKBGd5uCXrXRF3tvxBb0qBA/G00aPBZoW5ODhIG/lVLUkuGyvNmmr8fT6U2UGQvvJHBqA8r2jP3Z9u0s2iaF/S4f2YM6YUDWg/CFnxQdbHKP/iMVslwIWfLq0Bd4FPxhLLEb1Vt5YAbprJby0rLp0Z6qBsOtt+yDLbhQlnYAuJbBWHrU0YiNAhEN4iluyMf/stc97rRtKPtVX0T36nvF5Trplnmk4kv9OX8SDPJ9ruf/EsJxR6L8OqPsnVXSud/w9GrP9JwtmyHGOR1qFyU4lNbtuiAVWj7stTwjCoEndbDUww2j08gv5OYC3n7i86ZKthvWeiD8cwjhPFmWwLP5j5OKiVVywAYyO3yzXx4NoBpYdti3nXyGh8jLOEdJPft7bCgi0aWtR7+D/od8tXxVdjQ2JtfLzs+LnR95qhhIJoXmhCmXNeBS4FRfEdVPwg7hIwNpP+MWUigAAZX4ZZlSc8i96GABPp0ESh4U333j0gaXI0RzRFEwKY1q0awC6byQNaA2+u+HMJgKl08Ua8T1cht26V8d8JVVzaBpswMhDoXlElUWQjNdVGRP/i8C5WKyjadDGB/qssOegQ2a92KO477yqH1qHoA37tZUt0omDKXkMSePewvJ0a9
 FeK+99+u
 X4klfmkC3Jm6LUoi8BAXUlxldOFn5LeZ+MBjlAGaZxS9CBt4QD0lBYUZ21sw+AhqAWbSXV5f+8xF6u3skPdUoxnDp6pLcZ52ktmIMmz1PXrEwZqwrA2ChjCteVDxuAgnvCV+jDeEVKR/ix3UCIzHH316XU5v0cG3UQqom
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
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
This patch was originally posted as part of [1]; the series was not
taken but this patch remains relevant.

[1] https://lore.kernel.org/all/cover.1749747752.git.agordeev@linux.ibm.com/
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
2.47.0


