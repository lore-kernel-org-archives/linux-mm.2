Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D0ECCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C53B8E0015; Wed, 15 Oct 2025 04:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79CFB8E0002; Wed, 15 Oct 2025 04:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9938E0015; Wed, 15 Oct 2025 04:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 550D68E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C66AC0BA4
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:28 +0000 (UTC)
X-FDA: 83999671896.22.8355672
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 969A9100003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BoqT8JVDNqWVvMthzzZwbXmKgA1YpYNg2qRJn4eDvCM=;
	b=s8ALtCYzpDeZp3Yxfp/X/75FVzs+VT4QsZmKtZ6pRZfpvbj0xhmN0I3bjNkqII8teN7xwM
	h1/wYwrzs66qyr5fpCASYXfPoYNqr37bYGi/qJS117ytr0Co0VIgYxf83HZRWFdbCc+tbv
	FW+or5Ohp3FKq8nONjoVf/50C27Dyzc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516906; a=rsa-sha256;
	cv=none;
	b=RWa4//8Olid4pSPEHHvWzHLpJdyqyHK7ORIZa10ixwgqvvmsopCCeW5nR4vTld2BiJgwe9
	4FETotm7B0noZ9ZEQiADhoYM2Z5c6FXiax9/i2ZJb+xsCJWuOxKoG45qiIJWWALqUjjRlm
	ym/dE1w2PpX2ltv/FZ6u2uoR2GqHw+E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5B262308;
	Wed, 15 Oct 2025 01:28:17 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8ACDB3F66E;
	Wed, 15 Oct 2025 01:28:20 -0700 (PDT)
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
Subject: [PATCH v3 08/13] arm64: mm: replace TIF_LAZY_MMU with in_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:22 +0100
Message-ID: <20251015082727.2395128-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 969A9100003
X-Rspamd-Server: rspam03
X-Stat-Signature: isndu75ge9da7rzfsyz841p5bog7t74e
X-HE-Tag: 1760516906-184962
X-HE-Meta: U2FsdGVkX1+QmHPXD9auiST9I2WUpWXq3m5CVJ1rthn2q588COBNF+yyZH171o64yNfgrlo1l12lby1DwgZAZ6vYGfs3R9sSOpMydNbSwaW/zzmkuCrfOQaeSMQ3I1rEKW0R3vSrqJ4agS7nnoM6zuwscy8H0BZLepqCLkI5obgvwJ/XABe4ORVVf3AN9t5GvL04bnZjjC3+aTff0ClIeyUZHh8WU7SQQNjYgwtBzwb2GPUHC9LxBjmDGEY+ozqVzbiqZeKkeWNy3EemVTfgIOaxYdimCpn4zAOf9mY2bh61WopnuHVYsaJAhhtdHJMloxRqamO6Sy05CyrcZWRQSjvpHlVGL2QRk/eIPOO6kyuxapunAP2/Ngu8p8B5AR7dhaP2DUwlrSbw7p0NzR7YfBxhdDXpe6zmLJFO45OnyfRSe11119IvGq0m91AdvSci0ILeqwtgnJr/yCORi02E7u6n9Mohbs/nOv42hNz2ucqHc+MCoDWPG7K0xCVbogJoX7RXsveiTYgvMockBt+j2+et6rkMh9jf9Q6qoWRhB8/lW5Y83WMQS+8j9LxVFMTxDBWb+IhBfJo9QkYlTCrJBUA2hkmPkxdFy0DHlV8ngMVE2vu5cOFU9ivfgSXQw8O1NCx2otSAGWmpxuDYoWYp4/189JNX3IKRk4f4JzVe0WvAkk9LN3CAughXQnX9BGry/v1LJEB1ldZXalrul50dmmysqu+oWXNZFapZ8ETFc5jYoOwhc27M0HDfbxzNpG3s+YPqSfYmuvcu1vOo5hkLf0CkBhZlMxn81Q0+IhEMozgcQS2sukY0w14dWE9VRa7hTMYUb4y8vtiw7FMabxcmjLop6jJ8PgUM0yv/VQiuTUo9sxqJrH3vYqWTv5CZZlgbRaiq19JqX+98AxSeqFVIipWOcWy5PJv/Mfm4K0Tzoqg=
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

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable.h     | 16 +++-------------
 arch/arm64/include/asm/thread_info.h |  3 +--
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f15ca4d62f09..944e512767db 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -62,30 +62,21 @@ static inline void emit_pte_barriers(void)
 
 static inline void queue_pte_barriers(void)
 {
-	unsigned long flags;
-
 	if (in_interrupt()) {
 		emit_pte_barriers();
 		return;
 	}
 
-	flags = read_thread_flags();
-
-	if (flags & BIT(TIF_LAZY_MMU)) {
-		/* Avoid the atomic op if already set. */
-		if (!(flags & BIT(TIF_LAZY_MMU_PENDING)))
-			set_thread_flag(TIF_LAZY_MMU_PENDING);
-	} else {
+	if (in_lazy_mmu_mode())
+		test_and_set_thread_flag(TIF_LAZY_MMU_PENDING);
+	else
 		emit_pte_barriers();
-	}
 }
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
 	if (in_interrupt())
 		return;
-
-	set_thread_flag(TIF_LAZY_MMU);
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
@@ -103,7 +94,6 @@ static inline void arch_leave_lazy_mmu_mode(void)
 		return;
 
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
2.47.0


