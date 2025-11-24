Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 561CFCFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 13:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14D66B0008; Mon, 24 Nov 2025 08:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D936B0093; Mon, 24 Nov 2025 08:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98CF76B0098; Mon, 24 Nov 2025 08:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81E246B0008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:23:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DA25C0394
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:40 +0000 (UTC)
X-FDA: 84145567800.02.5BEDA94
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 88BAA180008
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 13:23:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763990618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6neHqDqqmDp48WmbQozlyzAi+O+eJryJUIDYSpPhRuE=;
	b=ItPqSav62RUMua6042rXHbf7Ifc594EiCJ8nYmmxEctKUTYQNNnxTNf5nL/ZccWnFm/xjV
	5OpdvJAKsVdkwRql5SXWAKrYa5sCPMMWfMzS6XHQ8rqCVjqo5uj3zjEmH9a7dLAlDWW0vV
	L1RyeczSMarl80I0cdSIVkt8ypwkLA4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763990618; a=rsa-sha256;
	cv=none;
	b=PhcKT+DKmkINpRG+Ued+bDeQ1Xubp509I1dmsTehtOk0TvjVuKGozT0juhZftf3LSmxVPi
	A1J8bt3g4uVjfCiLRjJqG6cl337owD1mRxveBJrTzyyxvAJTWmjqnKp2yLoNXSXgsSRvgW
	mANQK7+KB8YbAOLrt6Krwi5JKn/qMZY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DBA81691;
	Mon, 24 Nov 2025 05:23:30 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6EF3F3F73B;
	Mon, 24 Nov 2025 05:23:32 -0800 (PST)
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
Subject: [PATCH v5 10/12] powerpc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Mon, 24 Nov 2025 13:22:26 +0000
Message-ID: <20251124132228.622678-11-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124132228.622678-1-kevin.brodsky@arm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88BAA180008
X-Stat-Signature: oretye3734ibengnsfuhha57iqx3pgzp
X-Rspam-User: 
X-HE-Tag: 1763990618-382904
X-HE-Meta: U2FsdGVkX1++P1BY7mSxUmhpLsP0t/yo3yb/XNqp27OAsa8mOSFcMCUcZocYHX93ljG6F4a2igawVxCLAMUky6f2q4NFx0dD0Pg0j2u8zgi++C7IzkQN2mquWYJLTWypie+dHU6bGxSc8LV0OWLUZy4VgXFhLyd9er5CCUSjImgqWPWlGe0mmJy2xSjUqzIEuleDL6FwPP4fexFEZTLtGIxIw2s4zxyqh0nH5aDYND5otrCXZ0nbfMVc8PUDmSdfjQRnlXc7eINqEGf8zZeQ6qENjLfp2B4o4XQFwh1pAk6EwoMkoYUaoTtOrO5AiTh/JBS5SFR7DzafAF0qhrOuu4B7zTEvsKU4qgc0ASL8TYyZKEyG2uf1PLOw5BdOEMtoN8msZxOdRRFpqbKhu1604j7ThxhayBeEbE9MlUkboS7UP1Dv01dGEh1HSr3Jpqt+Fn225WOU9zauzOVkE8zmgxH818P6byGo4CDgbTE5mok/y5tt6kJAIfJCVO9KxQrfMU9AR2t9i01c4SSVPi6v1g4DB9fWSGPuBNIWJ/g4yk5j92i0Jgm6AsuJCG2D+UMUij+bAsxNEF0zwwn2vLkrSFAgeXl9cJdMEfwQ28PtM0IfayGZFkzVcP9+QXG67oqu3MTfK16hDAE1pHgBZLdvrr0IIsFE4n8kVMcCDSv9A3TS3Ah/yyFJw+krn501cjTBsAHaVz6URz7pixi5qj8RJAVlEXsjCsHsPx39xNiJf7IKCa05LWukUJzJ7KRd5pvl1MuTkiUWFoxNv/ia7GQ8ovHln2sfHANh+u3+SAJQuZFhAqMkLShP/a7SRqMXQh2XZw1r+PdrmKlILZlX+Llnl5p8mCN41XAyFaTxS3baumW+HqrKPm7IxElGC31AHb1L80aYHmObA/r7l1jQQjf/H0eS9+TJdBLhQhWDRi+mYxDiohDvNXssFrXNafij21ELdNm17/yPJU/KdQGgnP/
 uXbFYvCM
 7TyUt7t3SBy/W4j2cclmIqAmuoUmknabKOcapGRMKkgW1/OXSfaBHFYxHD1RQslNDk0gYZG48CjoxObtgqmRprpuLIYnU7hD5cDxv2+9Wjw8cEXorQQzJYkO6wXJ2RCuAXyNqGi42HQ8iZNH91zo759qomX3ErzDF8z7g0U07/K6uFshZ13O7O/+rV4QJAPkryEXC/HDFp6hSs+/zPwOnJcPix449AWXTvNeSGshmVg9wPVryMMs72geFOTjdU5q4v7+2J12n2ESfPf11udFYau0hFyHOCMoMAZkGNfTGIYQ8qXQ394dgHqmxjWom4KFH9cYEzyb31hAGBSFSqELmHU5CAYYzuT5JYxw9
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

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 9 ---------
 arch/powerpc/mm/book3s64/hash_tlb.c                | 2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 565c1b7c3eae..6cc9abcd7b3d 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -12,7 +12,6 @@
 #define PPC64_TLB_BATCH_NR 192
 
 struct ppc64_tlb_batch {
-	int			active;
 	unsigned long		index;
 	struct mm_struct	*mm;
 	real_pte_t		pte[PPC64_TLB_BATCH_NR];
@@ -26,8 +25,6 @@ extern void __flush_tlb_pending(struct ppc64_tlb_batch *batch);
 
 static inline void arch_enter_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
 	/*
@@ -35,8 +32,6 @@ static inline void arch_enter_lazy_mmu_mode(void)
 	 * operating on kernel page tables.
 	 */
 	preempt_disable();
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
 }
 
 static inline void arch_flush_lazy_mmu_mode(void)
@@ -53,14 +48,10 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
 static inline void arch_leave_lazy_mmu_mode(void)
 {
-	struct ppc64_tlb_batch *batch;
-
 	if (radix_enabled())
 		return;
-	batch = this_cpu_ptr(&ppc64_tlb_batch);
 
 	arch_flush_lazy_mmu_mode();
-	batch->active = 0;
 	preempt_enable();
 }
 
diff --git a/arch/powerpc/mm/book3s64/hash_tlb.c b/arch/powerpc/mm/book3s64/hash_tlb.c
index 787f7a0e27f0..72b83f582b6d 100644
--- a/arch/powerpc/mm/book3s64/hash_tlb.c
+++ b/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -100,7 +100,7 @@ void hpte_need_flush(struct mm_struct *mm, unsigned long addr,
 	 * Check if we have an active batch on this CPU. If not, just
 	 * flush now and return.
 	 */
-	if (!batch->active) {
+	if (!in_lazy_mmu_mode()) {
 		flush_hash_page(vpn, rpte, psize, ssize, mm_is_thread_local(mm));
 		put_cpu_var(ppc64_tlb_batch);
 		return;
-- 
2.51.2


