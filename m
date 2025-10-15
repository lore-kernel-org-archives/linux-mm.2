Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0075CCCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616698E0010; Wed, 15 Oct 2025 04:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDE58E0002; Wed, 15 Oct 2025 04:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B5D8E0010; Wed, 15 Oct 2025 04:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409DA8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:28:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C740E160B79
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:06 +0000 (UTC)
X-FDA: 83999670972.26.4EA55A3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AEB34000D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:28:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760516885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U1KJWxkttRktG4lw48Z8HifwxXCgZe80BxWPdftCaJ8=;
	b=i6OieQF/C87Zo3FaWMOXZW5sRK7KJ3t2ngX9VW5ihW7ArOmDTxhGfzEKY/oe+5xX5Chv7H
	VnEjhExt0oCSGJka482G4j6cp4ygIzdBhgDOAZKmHSxYRVE4bIWVLZlFTlVDO0Cv8NgeH7
	xtIB9aY6BStaHxflNRfPun5IAJxErf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760516885; a=rsa-sha256;
	cv=none;
	b=5Ovvr5zAeFjXCAVvK7diC2IVCLhmBFTUAMQ3rvPJfcGKBjkwq65ix/jZDGXiZxvB94mCEW
	Im7cZKeiYxfCNuvPZl4eJlz+IP5aIo9YvG1is9cy3CulwMxRGBb9OhZn78d1xGItuVzq6z
	Q4Uj+OI+Dfi+IojuTLBqmH94nKw/RV8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36B1D22F8;
	Wed, 15 Oct 2025 01:27:56 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 361C63F66E;
	Wed, 15 Oct 2025 01:27:59 -0700 (PDT)
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
Subject: [PATCH v3 04/13] sparc/mm: implement arch_flush_lazy_mmu_mode()
Date: Wed, 15 Oct 2025 09:27:18 +0100
Message-ID: <20251015082727.2395128-5-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20251015082727.2395128-1-kevin.brodsky@arm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: d7cowsp7mm73iw1rb4g57dpbken5w7z9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AEB34000D
X-HE-Tag: 1760516884-350898
X-HE-Meta: U2FsdGVkX1/cnu8MXRR3/BxgZr9Ebdnc2oqHNv96vgqDbLJFEJ70SutZkseXxebI4Ue4LFMKV0Nte45etsOilDuBmKXPeVZteSOvW+6GiLefjpviUlbnlLPDJokuevdxREt9uCrDbFcsKYYef0rXTiG7xu9zVOyaJswnm2Q8Qr1wfSVABa21dGa+Oygtf7EHnhEnl15r0Kl9pk0HwN104AdcpwK3X0Yrqbs9EwrudD5rLq0wCkIUqlW8ShArV5Yyj3Bg5OQvTm3dK6nMUL3UIcBubvUe36xkDx7tuiueKIOPi1mXNcZKtRNHnmP+94GwX0cDWHCTILbZQ/hDxttIBPobYEHqVziBOeAs3Dd6hf+6iHMePyFZskzORTfzxCmsCMr0O2Lys4KsQ1tWpC2/65MTBSNgt6FSocqGG3O8hgFRlYwru21NHy6aQPA4gDK7luxxb6kE/0zL6iXO/JmucnSlcKaEu7AX/ZF7xvv70clL0/XBs6NaIb2dWpZgqXsURG2ZbtSHsK2nRdiROZ4ILb0IvK4ZRi9KHs/Tqq3xb1IQqGLklm6ZdcRoNIP4whGXjt562BlRcomaqAoVQDkiargaeoUt009i1MY4Z6LXJLQ15C5IpVJV52mStN360ydummDDfpahGQI33Uj1op/thuJjSaTrrXJqNAfBoHE/RvziXA4gKGIzO843wBSKsR6Ea05bszI7TrfPhtNaNBUuZ9CJ7ZgGhdLt5RBbxmfcWUxxCF3AfLl0xkNx8O7Eomh+u1MIWOcugYEYrJU4lrn8GajJs7YK6hfNNGAXOE/BfZjUt0N84smXdjQF0N+SAmG1fH25i6kpBfTinHDvkVnI7ch49CmhK6F3rkFlp/hcaWek5o/jpoAOaGN719E+3DDfXWFgojKEVmv71doT6329RwSivnf+EVGvcvHQmcwGaWJcaB5lMNxtJtJblQIb1A8mIX2gAeQ2zGO50tE0p7+
 cJqj3eMG
 3H1IV0p8z1bp6hp7dljaADZo5nrLrKvJVesA622CF9BMjIcYi6nlFNVkl5r1iqsf20rjnJJLxXtsnq4+jDFnnqxrJgJOlSgVgvni3o5DUo7DY/GfhtGwrv73B1BA3Zcivfyr5NKHuAcjx27Tn9ezRTTSAqAVVuNpSbwjVwFLLWTem6JkU3EtB+YIkz3XUlVw2mYEF7+2QxynL02w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming changes to the lazy_mmu API will cause
arch_flush_lazy_mmu_mode() to be called when leaving a nested
lazy_mmu section.

Move the relevant logic from arch_leave_lazy_mmu_mode() to
arch_flush_lazy_mmu_mode() and have the former call the latter.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/tlbflush_64.h | 2 +-
 arch/sparc/mm/tlb.c                  | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index 8b8cdaa69272..925bb5d7a4e1 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -43,8 +43,8 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 void flush_tlb_pending(void);
 void arch_enter_lazy_mmu_mode(void);
+void arch_flush_lazy_mmu_mode(void);
 void arch_leave_lazy_mmu_mode(void);
-#define arch_flush_lazy_mmu_mode()      do {} while (0)
 
 /* Local cpu only.  */
 void __flush_tlb_all(void);
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index a35ddcca5e76..7b5dfcdb1243 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -59,12 +59,19 @@ void arch_enter_lazy_mmu_mode(void)
 	tb->active = 1;
 }
 
-void arch_leave_lazy_mmu_mode(void)
+void arch_flush_lazy_mmu_mode(void)
 {
 	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
 
 	if (tb->tlb_nr)
 		flush_tlb_pending();
+}
+
+void arch_leave_lazy_mmu_mode(void)
+{
+	struct tlb_batch *tb = this_cpu_ptr(&tlb_batch);
+
+	arch_flush_lazy_mmu_mode();
 	tb->active = 0;
 	preempt_enable();
 }
-- 
2.47.0


