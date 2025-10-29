Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4284ACCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8FC8E0057; Wed, 29 Oct 2025 06:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779CC8E0045; Wed, 29 Oct 2025 06:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6900E8E0057; Wed, 29 Oct 2025 06:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 51EDF8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 215AB13BB86
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:36 +0000 (UTC)
X-FDA: 84050732472.05.4CF3AF2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6046D180006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732634; a=rsa-sha256;
	cv=none;
	b=Sp3fbrvU4pbs9/4Od/ZMuQSFDH/0Dw7oK8owzpUBewv9JCePW/cD6Xjk/3gypIRL+6zq2/
	L9LrVq3P8JuCG3zSS1AbztQYzpfVfATzZO+Qss2u3VKqRoWXHcgmV/9b2014nRq4psoFdS
	7N2qxa/juiMx96QeJOVbw0Otf26kaPw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Oz9bK9va0e3cWWbhG2FVaoboM8OD5aI5ldZtnGq+94=;
	b=HxbYQNinXEPCsFNwe8/yaM3j22Wd/0eKazRzSWb++G5/SXv0PEPKQc0ztsvXb0GbDPwnZn
	21e1+GXDGcteya9fFsz3h4Rj06aL5rbvnJYw5MVHI57HMv6E4QVe2DsOSKn40ofWaL0bWd
	GJ8Or5UNOoNXG+XZTFLOs7UgcSQLGr0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B9DC51C2B;
	Wed, 29 Oct 2025 03:10:25 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A671B3F66E;
	Wed, 29 Oct 2025 03:10:28 -0700 (PDT)
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
Subject: [PATCH v4 08/12] arm64: mm: replace TIF_LAZY_MMU with in_lazy_mmu_mode()
Date: Wed, 29 Oct 2025 10:09:05 +0000
Message-ID: <20251029100909.3381140-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yofydoq6uyk5ty91uk18497nu8tmofpr
X-Rspamd-Queue-Id: 6046D180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761732634-500154
X-HE-Meta: U2FsdGVkX1+do9RJ2Nl5Kexjgp3HeU1xEhn8xEq7oJ9iBCw45HsoqxS5L7YEWAFi8EXkpuDfGBz0R6O27kZhI3KfuxshnEmpyQHmxJCty7K0pgvAERZU3JRpmcNjw/GuhYH9S+KsIk2kamfaco14lxRAh/hmLLThYuncwu3Uup4Ett8p8HrCAk/2ejp3QjmI/EGpVU5qmYDYsYP4K8BkNou6/Zcaa/99eOXmsF2AvHNH7TFwRypICWcvLoFJqt8rA4YvPSzF3OvMtkTp8zqq5ZAIYAEWi8qts88t9IIQNXGhpXPJGw8zABPFNaqL+N3XIwhl4HaIlIyvOp8fhT38qmz9Gb3dalolIjL0sDG5kYpA9FKU6k7Pqm0zaC+V2FtfaTnaQVw7glWlVzsR8zWRmFiBKzTkZ0lQwLD/diDcPltIYg91T7ojZO3WhShsvNQLkWO55kfYa9MktUJyM3yTAj2xXnIcdtZdIaAgLIjaZuV2pQeqQn7PUEYZISfC2sBIVQ3i2Jld5Gnlon/l3cm4+jcLt/zkqP9maYNtK4QUbYNHg3xL1pVcZ6ho5EQL+CRhr85o5YvjHZ/x8d93FLGVHv+FixahEbZHhAa8nwxqqgekHoyG2pY7bqzvKxn8HD1hg7JMme42nCno/ietvepa1EbIHtfhP7jqQEISdGXFEL8rMRFKx/aC9+V1McJpb3IH0v+aDrRJzYZEL/393OXnxKuIdXVOxWuIOH5/obxculATX07IkMHdtT2ws8aC336B+CsIF5weifwtX+kjRq+0q+jsChUg1A3eyVNDHwyw9SbpfA5AvpEl4mmubiuSoLeLKUaghMTUN6r7W6fxiq4s88IucSOrNRYOJOkfMnzq1tg8pYLK9b9BYaeSGENg1wJ7nakRofs/aYwj5gRnNyrMpFft1WaXf8HPYgoi6EHMRslDKRPzaD8BhSsLBKOgHW6D4Au7cKs8/JRrd+hNkUR
 b24TOf+K
 7FFrmBkETK7PNCZ3JXvcAmMn7SrQfrScQh/lIZcS/431ohlOxff2whnCz3W73+mKFsUA11JCz1CoXoRBvRGi9WDCD0Fzr3Rd8FJnV7jBKbG+B+hyQl6ZbJgtxrAgfMwcfoVp3RhfjFTMGDnmsqgRzsvRFqHrk1h0gxGHYQxhftYxL/UVwB5dw9QsGjqVFOFSPwV8FFRLw1hM9xFIkgVwUryLr07pwYXBs78dDTLcR8Seq1hw=
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
index 535435248923..61ca88f94551 100644
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


