Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7075DCCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8EE8E0018; Wed, 15 Oct 2025 04:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C587D8E0002; Wed, 15 Oct 2025 04:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95A98E0018; Wed, 15 Oct 2025 04:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A95018E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7766C88B73
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:44 +0000 (UTC)
X-FDA: 83999672568.08.73F3D9B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id D571240005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYmPJ6r7KmFHWtiLUTbtWuCWMRTotHkS2m3cSns0zQ0=;
	b=0aimDHdI9w2pF21Xf97bEUlt8/iBHVhAUtwJQHe4s7qcbVxVI3uM/dsF5T97h/O0zVlfge
	ltG0GlKdq5i4nN4QHd+im19znHJQrkINRwrfvOjl8J725HhsHWJpIt8py/Cbu2PrTBKutP
	H5PsS3PXtaO5046JHNveT7N1NArF4qg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516923; a=rsa-sha256;
	cv=none;
	b=pl2Ovk/MA0CcgRT+Q+iTeEVHEPi40fGNV1ysGJbfp9Ogduat8eTwcMVnv9ACuwjPTVRpyg
	gd32hC93LtCmIUnFlOAMmXjFsdvKi0f0Ltp1slF9sOHF2gV1R8LDXyaXAHHUlS3TkTrE0W
	4c7IZ3U6T3lFCWp1gm5Rt+s5z8nJrJM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EB672364;
	Wed, 15 Oct 2025 01:28:34 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2ADB43F66E;
	Wed, 15 Oct 2025 01:28:37 -0700 (PDT)
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
Subject: [PATCH v3 11/13] x86/xen: use lazy_mmu_state when context-switching
Date: Wed, 15 Oct 2025 09:27:25 +0100
Message-ID: <20251015082727.2395128-12-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D571240005
X-Rspamd-Server: rspam02
X-Stat-Signature: hm47repfro5wchdxnmouz78tbm5z3d6g
X-HE-Tag: 1760516922-500922
X-HE-Meta: U2FsdGVkX1+rapJei1lt3c6vmpzyvfKLm3uo6+3cHTXwTgHZkV6t6CalWbWiNosZcCqqioAmNvOQigxN2ldJI25V9YiekcynxE/NS/03RoJu2WVcUNaZ7esiXWWk9BDyisWAa8VV1wcvH0erMknQEqmLyVVc15tirOXh3D6pETxhysKkmU51eqcPCv9Iy/SZwL5KUA5MgiuJkmNdd1lBmyL9U0dSPIKLhL70hTZBNH9xK7URxujpkh0n0fEhN/QHyTvHE3haG2+6SbHP2PBERMxvqmBzD4f8ul/f+32Fj4/K5+akci0quPJc7k/VZ9v7lvmUe2z3JpLkiRvgvZjVvBUvjpaYJnqNWkMR1i+w2X8w5qKiMD5Blw3xY5OmQWo4LMw+EdKPXHbT+DAEDDgKDed4sOhF1YpgdTEVMaHuzn4lh9y/hax0bAsLrSoz8WKvUY0govseZ7xI5roV0mtzSVRMQdWeXxqkCizxp+/gse5GOXuGIY6QDdbh+XIuiQGwVzfWe4AhbSk2Hw0HOnzIWm0PXM0gL6Z9YnU8qo7V9quPE73w58lGRXQYDauRX/o5xluQu9khdZt+kKoKKdqiEt9+q5u9/fWDuWMfkKQ8VkzNZEIUPqiaJliDx2SFkEELpp3W5j87WUgwvV1xc4SA9VGOfx42X3/hToAFm+Y5xTOw9ADI7xekqtj2QTk5M/KEv01kRslaM5diURw1YmWri11hY1qlWdjBEZjJpLeDSo1t4f7EEfMyshR4zahWgKrY7a5IJSRXSlPfWCsBOpQaBKBtDnvYH4/vO9E8xplesJb1AEY0gV74HzmGhWbiAMQJPWckIgQJeH0J2829EiAtFZ6T7QgWN72u4NF4pI4ZIsgEJYns9aTn3iBoyd1Q9+8+p1FNwl34hJWgYe7gXvneiQl8YMZbWQ+gW1o/5ZXvU7YFUngsyte4+e4k1zkVp8qCj1vUx/A9j6D9A6nvc/F
 Vis4X/4D
 MDA3ECBMoisslTPW0YMp5o9BIMI2eHTuUqhUmYbPS6NiCAG2lzBfDpwD/UYHvQJSdewYqiOKqaLLtxd+x8mJYzYJ5f7UyLsV0At1D6nEnqTUVLUz2KumrTMRuv/0ZvPAasfeZb39OiYlxjFbCkc+2v2a+zwum0pf1T0qXVsyMLdzjXWlrTR3Cn19B7L1Oqu33twa24775RAczecI=
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
index 4806cc28d7ca..9fabe83e7546 100644
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
+	if (next->lazy_mmu_state.enabled)
 		arch_enter_lazy_mmu_mode();
 }
 
-- 
2.47.0


