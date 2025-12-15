Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9517D5B175
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 15:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BBEC6B002F; Mon, 15 Dec 2025 10:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D326B0031; Mon, 15 Dec 2025 10:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B506B0032; Mon, 15 Dec 2025 10:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4CD06B002F
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 10:04:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 814D9894FF
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:47 +0000 (UTC)
X-FDA: 84222027414.06.E1330D3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0070C40024
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:04:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765811086; a=rsa-sha256;
	cv=none;
	b=46wEsm+L03EJlm0mXFvrnopg3Bc7CvZMbcoYFlG0n5KKKW0EsPskRYuKJ073b2F8awW6Ia
	ICpAB1fSeS2K6Fclh5RVBEw6ZpqVveY+hNa4n6uqZ49oF3TKkJo0klESuSDlCDyHin0C/v
	8cv/U5OohmWxBflYNebbH6qMP1A4ziU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765811086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SLPEXv7mtmdi56vN0nkCKjGhRHmiWM7WdSWIPpwfUw0=;
	b=UokeWBhMA93GzA3pZ1aYFOL0TP2MtPQAT9FlF0i0U8i9LN1LoU2ckAf8hPMF//X7h3YaX6
	XoZGI5wG+WHgHJPNBmW+c7/D2726Z6PmjFY5y6iphqDuYKIU6aoYqGbZO0g9RH4sjbUN6x
	QBhrKjKJXCdEjdZ6bj7M1Hqd9gyz5eE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 12E5216F2;
	Mon, 15 Dec 2025 07:04:38 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA2463F73B;
	Mon, 15 Dec 2025 07:04:39 -0800 (PST)
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
	x86@kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: [PATCH v6 12/14] sparc/mm: replace batch->active with is_lazy_mmu_mode_active()
Date: Mon, 15 Dec 2025 15:03:21 +0000
Message-ID: <20251215150323.2218608-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251215150323.2218608-1-kevin.brodsky@arm.com>
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0070C40024
X-Stat-Signature: b3iude1ktxgdjcbxu159szj788ashbna
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765811085-331428
X-HE-Meta: U2FsdGVkX1/vTOKvNYp0qhvro+kyDGGRTrvat++6dC5eK80VEMiuPGiKTLQqU8W0PVYzfYyrZlzO39ceGs22jtYR717mMifzkkDJ/GXapIdl3g1bDO2zRT55OlK3ynlPbZF3uEtli2mHlWUkCCyBITgRy0zmby7jiTVY2vRcE3HcXiEgjew3shSW+1XJFPt3XgXwq8ohlGv4zuD+Wl84KGsuZNF8x/qs+63w9bc2BZsCusDG/zi6rAQLswvaBgE8LwO0cAFEtKrfqURyYZOpmnY0xZIrKL9E7+J6R0KTVNtuBmsYzegcQ03gEczTBzkDi7B+JIlI3YN/v+8DBO7QGZlsPMuWCRsbbsK51GzrJkOJWKKS2zPK06PegX1upD/nyp+NX3nifx1K02M9Gv+wCcILZzVmPyd8x44xFNmPshp3451vITQEnR9RhRv3NcNYaIK0cSmF1k4vw9M46yj01CG5c3itA7sJPZLiqC1yCsLJoS2GY0WRgUmM3AYsjZd8g5e2saldPouBSrx325p5WLs7DO+0h10DeleoDzKfsM+Z95iD/MFafCvCNk1nxPRVzfPnAvo8quh4dbMmqRVqYwu9qj6yQ5I+dNdFsYE2m3BNXds4Y+7lPPkFPWGoaza5tMooiYcACgsrY7SmDJyEIAHY9wMHp9s5vrlhH6H9yvllZ+E9RVE2jo0AbnK6RGSrLTWCjRUtJl0mgYkEfjoSOVgZuA0+Eb0Pj+GZki7tV8Qbzu6g5hMavYXxey7n0SuF0Xi+ec50qfTR15gErImVdWs4zrzreIOHcU2RbHgwWFE/bdHPqMADdLI7E7Lp4qJLtVsDl6+HfCn1f3fRBZm0KKcOBJtD1EB4By2nzgEn3QPFPp17r2+bMxVuQBtJ57UsC0XHkCHZb960C4MH5OesdKodnQsifl57CQy+PVsYuRl9MnQGW7Xs6WoIHlzt39c4gQhjLGyXIPTq1a5ik29
 623MnWBW
 5NeTfy7ZL+xlWLuzLN94PBZkGaQ==
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
mode. We can therefore use the generic helper
is_lazy_mmu_mode_active() to tell whether a batch struct is active
instead of tracking it explicitly.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
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
index 7b5dfcdb1243..3a852071d260 100644
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
+	if (!is_lazy_mmu_mode_active()) {
 		flush_tsb_user_page(mm, vaddr, hugepage_shift);
 		global_flush_tlb_page(mm, vaddr);
 		goto out;
-- 
2.51.2


