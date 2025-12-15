Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CD1D5B17D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBFB6B0007; Mon, 15 Dec 2025 10:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EC96B0008; Mon, 15 Dec 2025 10:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206EC6B000A; Mon, 15 Dec 2025 10:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0EE5B6B0007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:03:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B32CCB7C91
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:45 +0000 (UTC)
X-FDA: 84222024810.18.7FF33C4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF60020018
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:03:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7mK/uCHK11mhYrKKvONf8eUU7le0xxASoOuzxA4nD0=;
	b=lhT5Jynuw8YOxlmosiW3jZDtQpuwBKpqc4u/1cWh7C25TPzDV+8UZ0jhrnFDVHtVwFeXa+
	KHZdG7rO3MI9ZbyQejEhlFQeSN9dH5iAApPFJ0K1e9wsJfLjp3mw6NVSBbxIa9SQ1nIhO3
	wmzW4hQgMhq6YHCcbaJD9TvRstPNIzY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811024; a=rsa-sha256;
	cv=none;
	b=PCTa2nYEgYhHXnCa3P2XR5iH7vyn8OxsCyjelZqTCMhyvxYPD58q7cz/LnNHkTwMKSZrf/
	o0lBcWcPU9CQI0uJ1vB4Ab695L010JE8rgMc/yb6fprZbguHDvZT9Wo8Tk3pyJ2FLrq8Ts
	iNLEQI69AOLPnlIOfa6dP/guLOTf0j8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E12E5FEC;
	Mon, 15 Dec 2025 07:03:35 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C274B3F73B;
	Mon, 15 Dec 2025 07:03:37 -0800 (PST)
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
	x86@kernel.org
Subject: [PATCH v6 01/14] powerpc/64s: Do not re-activate batched TLB flush
Date: Mon, 15 Dec 2025 15:03:10 +0000
Message-ID: <20251215150323.2218608-2-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF60020018
X-Stat-Signature: 4ise7grjqxo5ejr8ci1dp9n4x9ssfkx3
X-HE-Tag: 1765811023-168088
X-HE-Meta: U2FsdGVkX1/bcstOXv+P4lw+xYicciHzGFs2P4e9wZIsyQ6IBoTPV2Xr8j1TBueBdzjFerg7IGFshxek+WAWPTqbnTiH7CA/sdLom54ASMJ+8olQirn7tL+oESHWqXUXlTgGnOT5A1PvpzCf83HO8Mu82xZQkwS8jRaNIqQWCdIwT2FfBGCPMmfD0bSJ3Wi271WxnRoneEa/NLA39KluKK+SA+227o1r/MQQUdz6W0/rv9VbiEO4mcRdm8wAf/BpdYYsW9Q/WiilI7oyp21AqIt7UouC7EDHDog++xyqrYJMQ4RklYpUt+QVJODdW9Dca1qB5etV/JZ62isi0ZQLt3x7pbp5DjxuLbBCEbgY/ptqrgNSBcAtdkpQYRJDBW1q1e1dBEleEbpbZVpp6NYkqowXwxX3DGugw4poeyeCmFm5HR5L041kBKmdZWeVrO8FSNgXSKrXFrwbbSt34d7T6yPLynril/2VpBSVtsQblhfaTbCkQ4ZRwboYvzvaULGDSUNAzYy87g5E2tAVEnP8hJpWv9mmMsKnzO1Bf/n21+0ThXl+09kLarKdcqtjHXrt+6dTtFrX3qlmyQxiO56KO2pyUXFQkW7zwgdoeoP+lB6Fy3Et+Y8kg/MqvGWYCFU9hIcPOm4Qub4RlJOFsg6lTnL7IHH2OQmfNKnnPjrWRMPXee7gB28Ajn6y8EAyA9ekTrrn/OHkb4Oj7iJZiMuPzgeW3HDt0gcKkgZ9IryyyNBMyohWMzsjPmINBtf1H+1KCsZomakPCeICH/BI0rwjBBLBqbQ7s8j4Vig0PnVagtL7Btynsoxv/OkrFUEjajrRAadxvXfUb/cVEpgzN9iaRBOeEhBUtgWzmUHqOXKOq+XTUpODzRPdQof82MsxsjnkDcpLAZMuPAi8eIb8hjjkoB908f2fJCyBrPF/+v/TLVuxC25ipCBLTxtQOcwPpdjOl1mU39eYrqUdS4uetfx
 nFuKigmB
 H+ICUAHd+H2ScxTfkwiyfAr+CBd9YQuoit9HFji3aDRnBnLV79rpeSlTSckI7cradv6k+RrJoiB/eEDHYBfaC2RuPEP5cldWQo3zy2HJdfTvDUL+oFZ5181hdK2TMATRL1LPftc5YhSQPLMUqk3nkuzLdLh1Fmme03Fq7KjjRQ0eY5Xu+6hTGjms074jzcEALM7rgW/OoLXnABZzEOfhnq6jc4C0y8+X0a5VaFzOR1sWT0CNYPEujIfRdyVdKHEaI0G2e4osRNF1+hb+trqQ79SJoJaRZ2T+Sc0k8
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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
index a45fe147868b..a15d0b619b1f 100644
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


