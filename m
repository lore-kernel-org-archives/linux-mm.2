Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13A58CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB418E0017; Wed, 15 Oct 2025 04:28:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2E88E0002; Wed, 15 Oct 2025 04:28:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8EE8E0017; Wed, 15 Oct 2025 04:28:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9878E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 199CD889E5
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:39 +0000 (UTC)
X-FDA: 83999672358.01.6D1D19D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8313320008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yonosVKorvPfHjKG943kS+3aeQ7jqapDh6f5jDLbXPE=;
	b=zF+W1/chUSNqKwNEwRAiL+Loi2/VFQndyBSdGp2hmxKAHzoI2/gqlOSWkqN4GoaACkHFge
	oLDhXG8DWP+/jt3luO+z1l9S8V8ppEovy8haOPc758imRxC36Ip2V95dKtO6+VkCke9un5
	OOscyLkfMmgxV9sKru/rM5Zmh/p9PpQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516917; a=rsa-sha256;
	cv=none;
	b=L91/+ouFIJOWqVGet+sEImpzq2PC4qwzIdBJ+f6HiuSGqOptGmTRTBwF/Z69VufKEdlqAZ
	lWZvvScpJawZztPJ5MXnQD4SqnX4sQUzr6y7o6uPWVHDamFl6PPmlio2VVwOx7xmLlwp5V
	E7rINWIcoioLyKaLe8EEq9ZtrBXAIeQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D57AA2328;
	Wed, 15 Oct 2025 01:28:28 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8251F3F66E;
	Wed, 15 Oct 2025 01:28:31 -0700 (PDT)
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
Subject: [PATCH v3 10/13] sparc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:24 +0100
Message-ID: <20251015082727.2395128-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i57a3w55gdo4yrtcicd84ag4ey4uhwei
X-Rspamd-Queue-Id: 8313320008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760516917-569239
X-HE-Meta: U2FsdGVkX19RaCMJZtBZxOZfVeCUlr4cjVs36aE4P6RR4YuEdIoVmQCtwAb9KHCaj0FN02Voq9xL3vjcHaqvA7oWmIpyPByjEu5UWV9YITXW+os6TaX5w1grfj88BRXs2AxTzgdDJb9nriHDVipj/JCO7J8c+rzmgyvZE6hUNrUmmu+gBvVHQfQGjxmljcUliVsyXiMPy1gdAw9m2Dw2jMl+0pI4DpnoEcr2FEoGAotwMJ9zgPZB+7WD51K4Nu6J4uA4VBhXk3QWLhciUP7QVTgQ6zTtq1p9BI4/dBuCHvDJUeKd05PebY3oIh7WTXU8RMF1v2e1wpfc5+fuYmwv9ZQzGI5ISRwU0uAHyxsK6iNXPVgsS0FZ+E2X1v9vFWf7DjA9NrwPW6qFhRBrjQAgGBeNsRJfbohF2Xa7xJZmTosZpadhUbz6Z5SnUuoSazsg0z0u9OXcp3rSYV5+rdtx+2gZ5iiPVD8fc2oD1uiciYs9j+waadJ3QkdFZcARq7Dr+Bp7faDTTiPQII3P8zLbRdg9vZcdxu5BTHem102fqYR6fxSvfPaAGZlU2VKqXT7OtfDEr2+BD+UurDBN4lA/Jp66eiW9p1nEbkbIyz6JeegKEAxobPCBacrUQ6M9X+dlD5SEv0fJIcNGrj8+s3RV4vwbmivrO2S0LBBOHBprT4zEpUPj2vFf0d17NrfmiPmATYwRBv0VdJTxyX8el7Mmabx8O1C77cxnR2Xrz9SfLFQ6K7R09q3PYJX+hOFAf96z//uX2Q5qZQBNtmAR7blfiGNUDUXG5LlmkmocoLR3RKX5NQWkxav0b5Z3lHWiQx2imYjanlObDP0ICJjsYrpzKDdsPDezlg1g4gy8y3jbdisi+3gN0JWPqKFydA2zcKtvY5owPDjG1bwbK0n1jy//X7yyQwUg7iOmPzYGysNRb7y1SG5WlGRN2kuaLoMsMAMBd5V4hNCVh+KXatpLqo2
 9z464qhc
 dcm2gsQfPtod5aU3z5jagPZ+cnKovXYE6XNcYnydEanHgXmK/fx98Rj5Xs5jkzq610+FzyyK9pt9Nl0xrOdlTIeLQ6uI7VBaNcbernScOzE3+Fn8O0ffgvA6XBXeyLHt0JtbBvsPsEqBEdxSsAVHUlKUfBOJZf4HH6QyuvQgi0mLlFX6oDQrGaFiq2UeQhcGVZU7CMbAQF78MFS2MNo7GvkgH46/kReZ8ekgc8xPbRggRPdc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. As a result we no longer need to track whether the per-CPU TLB
batch struct is active - we know it is if in_lazy_mmu_mode() returns
true.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/tlbflush_64.h | 1 -
 arch/sparc/mm/tlb.c                  | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 4e1036728e2f..6133306ba59a 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -12,7 +12,6 @@ struct tlb_batch {
 	unsigned int hugepage_shift;
 	struct mm_struct *mm;
 	unsigned long tlb_nr;
-	unsigned long active;
 	unsigned long vaddrs[TLB_BATCH_NR];
 };
 
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 7b5dfcdb1243..879e22c86e5c 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -52,11 +52,7 @@ void flush_tlb_pending(void)
 
 void arch_enter_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb;
-
 	preempt_disable();
-	tb = this_cpu_ptr(&tlb_batch);
-	tb->active = 1;
 }
 
 void arch_flush_lazy_mmu_mode(void)
@@ -69,10 +65,7 @@ void arch_flush_lazy_mmu_mode(void)
 
 void arch_leave_lazy_mmu_mode(void)
 {
-	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
-
 	arch_flush_lazy_mmu_mode();
-	tb->active = 0;
 	preempt_enable();
 }
 
@@ -93,7 +86,7 @@ static void tlb_batch_add_one(struct mm_struct *mm, unsigned long vaddr,
 		nr = 0;
 	}
 
-	if (!tb->active) {
+	if (!in_lazy_mmu_mode()) {
 		flush_tsb_user_page(mm, vaddr, hugepage_shift);
 		global_flush_tlb_page(mm, vaddr);
 		goto out;
-- 
2.47.0


