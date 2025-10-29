Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC82CCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BC948E0059; Wed, 29 Oct 2025 06:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493C58E0045; Wed, 29 Oct 2025 06:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1128E0059; Wed, 29 Oct 2025 06:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 294C98E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E54E1A0693
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:46 +0000 (UTC)
X-FDA: 84050732892.26.04958E2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD09A40002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwEra26/A0yijkE7baZGrCpY+n3zbLof6zuXP73UfSY=;
	b=vmt/lxmEEdz2pbi7RYs5gCuSOCGuZDgjBG9S0BeWiO9Omr2LPUcpAUYnBPpRwira5RJauc
	vxrEiOh4GqWiPNFeHQOqAF1Y7YlHq6qUQRxjcOVW5Xcy9j4PjQ6BunqbDsPAtojdfLV/EI
	mAnHwtEWV9fCBYs5sr8o7JTq/6nmhVo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732645; a=rsa-sha256;
	cv=none;
	b=qk8TblquAQjB54jNONpZH6pIJw9YxAYcAE2Ofpc3FXdTJbeaq5AJXqujKbe3V6i8lO5D4u
	Pc1eDRVEF3ax78n4TpgJP3Z6shYZfhxq/L8oklKzOJ3u/xbTzFJlDxe+WA/ACA0kFTFrIt
	2adEt79jGr8uQiRu2ryhSKLtoyVc+j8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 310A22BF7;
	Wed, 29 Oct 2025 03:10:36 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CBC73F66E;
	Wed, 29 Oct 2025 03:10:38 -0700 (PDT)
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
Subject: [PATCH v4 10/12] sparc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Wed, 29 Oct 2025 10:09:07 +0000
Message-ID: <20251029100909.3381140-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CD09A40002
X-Rspamd-Server: rspam03
X-Stat-Signature: 9qdurj994zrut5tw6z4qtgj7i5smegt6
X-HE-Tag: 1761732644-660449
X-HE-Meta: U2FsdGVkX18nQmv6wMPra137FVMbRUhYVKNuiDaAd09PVcc7Ddl0EwdFoBKOsYrVJtmgKJngz0JhHiavz6MQ6M9cCYGsS7x01rMz6NjNJkXs4tXGPHf/+B2mFFBoCc24MH5g6oNipBTJE91/dp+nLI6yID/t4CvkLIJEFq66oNy5X/BpPe14LPpUcEszHvvJdMwrbge08RZ4NM3oKqYE5t+d4yW8xBg1mOv8n2R+36qhBu5T/+0+3lNW0Zf5DCOmvvKkR2qiZV6BtJh11wzmq6iNsxlUchRF6mYa22AwaXZ2F6Qevx+srXYjIbuJA3k5Z8GjzquDQh4gcj+X2SQxzMeWMZA1f/X5uA9bW/lspM3xyFGw/wufM+Rio+aVtp5buxEUZAHk3BzeYsgZkrhz/FrpI42Z/IKlftuXL85lZ6IOjHiN9IrMXL5ORY0u/88HdlmNqiZ4MXtdKuPDaI6r9mH0DzvWL9KQuEqqdzs0Mj+0bgqjEtcuiVA1LrHT8WI+06euTUVem/5Pk5259IdyVR+yPBgeoR1MYK4BchqdEJ8ZeKiogdXAEEnLuwnKeOl+MoiDHUYKVi9UJnltWe7mSLNGPGHHP4iBoEXBotmNP9yMLAKyOJ40YaUEgi57wNql1KN/z/jb66F6etPmfD0hqnyPIE0JhiRTceoh00fygAjHhYlDxEOB4k7PII/PmkayNIgL/H7Ij4QzjJKbkNJyz9Tj2cXJwYppQAeu3XW44x1vIId9Nbg+i6Oa7MxjF7mv7eCzJiGfl9ItZ2nJYdaEAr6X1GB3mtR0PYi6I5tVqcWfS3QspmEG1YJNV+X0z5K9ecj/n+lHDnDBfYza0ooEqDJytHRW3FGCXmTnDhUDezRmIa/0ZQQqs6JxhUSoLJdfe1IykH5I+ZIC9LPnmVh+PFPBZGTL1sFPuNujFUaYcgNBdE/QDQgp2pcf02c7ev6A35TvdpC2qfct6geNB6a
 dWaFxg9v
 /DvmRgBEphPqjUnhFjue8q0tkOlnBCbhG4GiJld1t7ShuGL5U0aO42IGP6/VawA94ox8aTz7+3kTvO455l0GJV2HRo9Wj3GEBRLaIT7XIpajUHkYLgaY/6jqgnXK5HIQ0iDEe5qeE7ERs981XCxC+V+WRtXbaJn8nsXTZhrR89R5j89NY8GNrN/xABnIezGyyu8EBGwamA+TQfRoErWXJv1ieQhvuvRpHh/s/mpBKAnesGQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-CPU batch struct is activated when entering lazy MMU mode; its
lifetime is the same as the lazy MMU section (it is deactivated when
leaving the mode). Preemption is disabled in that interval to ensure
that the per-CPU reference remains valid.

The generic lazy_mmu layer now tracks whether a task is in lazy MMU
mode. We can therefore use the generic helper in_lazy_mmu_mode()
to tell whether a batch struct is active instead of tracking it
explicitly.

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


