Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98F9BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 050188E005A; Wed, 29 Oct 2025 06:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0002D8E0045; Wed, 29 Oct 2025 06:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FB08E005A; Wed, 29 Oct 2025 06:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2BD98E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA9FF49E1F
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:51 +0000 (UTC)
X-FDA: 84050733102.21.EC00004
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0A0C68000A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732650; a=rsa-sha256;
	cv=none;
	b=rh+Oz2DLTt6IY2p7XYAUj6D7/iN48KTVKxWSZpNRrWQImjDFgTK2408SujLUU7gaIg3hYc
	5u+OzWDLGPKFXLSjv0H9uFRC9Pn7v5LYzR2faQTp49JCVcbAYXgDiHS77L8kCVDV63/sr4
	nKnpthBzewhGn5Zz3wVW4pN6CLdoK+Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqHWQKh8fSo1EOdm7+rkOzH3g4Kxqn/5utktqElJNns=;
	b=tkHeFedW7yhZn63s4hKxWP+A9cCY72sq9/4H3xg/V8ZLjsNkgWH08j4gtv+y1QP3oAO8KX
	AQLCA7mUN7gYB+/79da4fL+r6r49roKaLNDb8hW9nhC93Cm2G0bIh52n9fnMYCwyydcCf3
	L1rWEYWl842Wbq6TaD972PJ9PQ8Qmpo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66BA32C1C;
	Wed, 29 Oct 2025 03:10:41 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5459E3F66E;
	Wed, 29 Oct 2025 03:10:44 -0700 (PDT)
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
Subject: [PATCH v4 11/12] x86/xen: use lazy_mmu_state when context-switching
Date: Wed, 29 Oct 2025 10:09:08 +0000
Message-ID: <20251029100909.3381140-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A0C68000A
X-Stat-Signature: pp161gkyh1fkbnjpe7fp99hcs3948cfp
X-HE-Tag: 1761732649-48357
X-HE-Meta: U2FsdGVkX18tcbzY38QC/o14G0HPrEE7WbATmR6jwSE27odeqQ4JEL7rdebr80B6NTShLgzFFxqvpwVR6BJD4Sxb2GJ77fEsiV8VfjnAapXsJadSP+zmUgX10Y3UmI5KUoGDZf4yhM5bcNlJYpaYyAk4lC7Vm++gWLpWkWtFH1MycbojnuhMESD53nNow7KWAswByZ3wpE4DdReRgzYdcCbeEgnZQTKVEjKqY3RmZLsXf961qom6ujJxBTt8xWpTI39gN7K4RhXBhi4b9bAEBPLJdLc4u4v5fEdfaMUw+r4FP2GG4x07viLaVggk70zB+0uxrBn9wBMci1vR5drwCEF3lb0lMuxJ9rzv6uW2+n5S2rfBgRCV/kLjQ3ubFIoM1V59Utvg6sBHDjWdJFcNvgdtdTuvvsNqkl1zjmymi6WgfJ4xfnPq6FxjDxa8V1/oHmL0M/nV9uV/mUM5oOSBtkoV1zEj5TLM96huh5JZO6Ys5Dc+16vGZUGZNTHiAyxiM/hejd1dGW/blhFIL2AEvUYnLyCGgUebRTbNqWKEvPfI/J8uYG3tUN3OnW3f6427bDmpYkVVg9EbN3ZcVA+hx7s2XUBXZGs8lKelxZ9gt9b4Guxc2V1gReVp8kt0rmS7tpi6wy8Ze6/Jzy6P9oaZl4XY0D/AZlgtGu9o5shYovFS42yuIoWdjm5jb9uNoqMVPEr7214tQV5JNPSU27NxuZulgg2ZoUzKwDTzXoSrf4QeYOfZY8UBJG7Bk/sLQU92yuTP1vXEc1EeQn3jcrPqTqV7OOhldqMbaLdhiWZc2OzMI/TI6OnhhF1sEBp61/FhzHEjj4zPFvEw5Yl9ry1tgzVWMUDEGl5EK09qnTfOgmECb/a2bdxHNIg3UtCuecqxxjXLxugBXH/laSKFdcf7pDzU5SDNVMNSY2SyORl/EGj6sBeMmNPDKRt0YKHuqB0TTM7iZh+oehHZkqV3Ue4
 YyOB0vyj
 NPaFNe+L0ipfvLy5Vt4iXNiWI9wpFzsL5FnfQGHUx7Qcg7JD1w6na45/YSdNe3VXEciToy8aEnBHuXgE6TwrI3UnEmfaF/PrIh5gfQ0Nu+gFOoBBMN0Jl8QFsduL5DCirmQE7nFwqfIt9p0TzIm8NbX2bppyWm5HhlflGmxEw5qX+ANjB427qoYabfehM1jtN2qEM3VRbVFV8fDQ=
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
index 4806cc28d7ca..f40f5999352e 100644
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
+	if (next->lazy_mmu_state.active)
 		arch_enter_lazy_mmu_mode();
 }
 
-- 
2.47.0


