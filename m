Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87F8ECCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 10:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA718E0058; Wed, 29 Oct 2025 06:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1468E0045; Wed, 29 Oct 2025 06:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE7498E0058; Wed, 29 Oct 2025 06:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADE298E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:10:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44B8613B991
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:41 +0000 (UTC)
X-FDA: 84050732682.28.64743DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 945FB160011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761732639; a=rsa-sha256;
	cv=none;
	b=nFJdnJ06XX6p9wsnKNpHVbuJqtBph368NEH+Qwc/5MNH94f3lcB/qry8HoY7MC0ESkcrg2
	CBaoQ9hdnP2zdb15phoyw0oBm+sEqVJMq8mHRixy6fh4mJKQoVDn97l5+DLuM6gmpt6TY2
	PBihdkRb5SXMFbP++Ru6bdSfQo+yxk4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761732639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N1WYke7yUdTWbw26Vtz0uNRFVp3PKYDfCjn5IuHDAks=;
	b=nxNegisSyjYNEKi9hn9TjaHarm7OyJi4tb63UfmIZDDo/8M3I80gzi6HALb7liGnL0MRcr
	DfvXtqZYLOGn1m2VPTOJq0yn2nQxZo2JvSQVWLDARRJ56pOgjo6XtEqMac3dST5Fl+ISxx
	oOwHML3p9ccNImhvAB9UZDsZ943X0HE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ECC152BCC;
	Wed, 29 Oct 2025 03:10:30 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DACF93F66E;
	Wed, 29 Oct 2025 03:10:33 -0700 (PDT)
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
Subject: [PATCH v4 09/12] powerpc/mm: replace batch->active with in_lazy_mmu_mode()
Date: Wed, 29 Oct 2025 10:09:06 +0000
Message-ID: <20251029100909.3381140-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251029100909.3381140-1-kevin.brodsky@arm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 945FB160011
X-Stat-Signature: h6qkdc6fmfnomw8ynsibfyw9ue3sgtep
X-HE-Tag: 1761732639-523453
X-HE-Meta: U2FsdGVkX18YxABhXqUPNDvb/4eu7Y8j2nr1yN24Bne4TRvELcm3XUz0qwrYzd34OG/U4gjmYuDs+Os9pS/qWSo06vT7hTPDTdRBvc0AoBqwpfA3QNeF4qMqq3ye1Y4YETle+TmwhUFBKQTqfQLHaXTIkq5qoB2CE42QxWw5qp5iEXDyzofArLxYgWSDLCjx5cD8WhIKmw/4bLnOoGif870t/n7mxe4aP336Q8u1i7lWh18+C10xzH/MH7Vkiyt0lxf+kEx1iSJAADPTMD3UhX+zT6B8Cd0BPufcw47sjWfbJptEAvQnt3WRHOI49cORmO/mZ8AcvmZrdDeGs3kzTwTlkFrdRZ08mlQr/RvErQfKl/XvNcjQIbO9EoE0djcSLC+C7w+qL3gRo36X01YcER0E0Y2YUZgVsppz1YtLeuvYm8BqrEHGHHCN35MKX1aBeL8xDN8G604dt8epg/H7fydCybZAXJCttp3stRUNqiNdTsaOiyPu4D8pOMnKtMqkz0Uz8p2oHlWyCiLvDuCUUKMKaGMoXa/21jNXhJxWcdGrTi7bOIPqQ3AyIIFD+1oRQFBvdnbz0/W3h+YWJylDXFkqK0bxkDrpfnrzj+g5jirDSunAYvVe/BZnIoXPoDqb+X85gua3W6k7kdQbiiNh/onk23JE8qFz3hXjHd9F/HCUEbGJMYzDCn2Zlaqpr1yO9GT/8JDktgguYAmMoOjSe1UEhWMTcCrVGFD13Pbcx332rFw/W2TBqJ8XGhJ3wdErME3rKtmETn+7DlSz21/HFNVUHj8VK/Ec6ogqgKFz7BgQ+uU4A2fsdy+bwcpov1nuTyfyX9XFmCLYNajK5zo2mD7B+BTuk+9qMhAJn4njiAI0Y304DtDz+fQyiasL0nDZcRWmcsi9W+vyXa0/vcu6QUvUKEPjjUFu3d5VgweWpTlnMH+vjerbt9ZZwS11M2wEz9y63tL5dCgEeszR2Qw
 ErgdZuCx
 M1q3qz9yAvLYygQ/CLT6uAIq0vho7hJyoJFhR0iaMn9xO0zW4RxzJWbizhrD2xrzJHCA9Ela5EuUQwhFcAr9FfpXi9rW6mcTXPHo4X/JL4+Q3k45NvvWAeC4HaC4X5gRibV+5cDikbUBTtl5nmZX1z3aYE8gEBSTEFaVzyNDHsZniKzR5L4FvsZz+jQUxYCGS7G1hazWXFA11OuRHfeloMCy1jrMZHaK093i2tmK5fQOscWY=
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
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 9 ---------
 arch/powerpc/mm/book3s64/hash_tlb.c                | 2 +-
 2 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index 623a8a8b2d0e..bbc54690d374 100644
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
@@ -51,14 +46,10 @@ static inline void arch_flush_lazy_mmu_mode(void)
 
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
2.47.0


