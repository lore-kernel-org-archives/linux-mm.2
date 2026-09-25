Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C56C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1116B0099; Fri, 25 Sep 2026 16:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8EF6B009B; Fri, 25 Sep 2026 16:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEB36B009D; Fri, 25 Sep 2026 16:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07E146B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:11:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92D09A077D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:53 +0000 (UTC)
X-FDA: 85253380506.19.26CF01F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA9CC40012
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQOHoRIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vckc5AVeFzmihzBIO72nuSyPVb2k1pHjs2iRz4sQTSY=;
	b=TQ/c1yyxczPXp4uztg8pP8CIZNkW/JF85sDlEYM50VJb8XKh3CPnw+7AMrNzn87MwndnyQ
	PvM7ROValsLzrbnuSGwzVeHKvdzx72z8qIGkfk4h7EGlGpgcE5tMA8KEirm2y/OwtduD65
	tmU0vP4eT/khvjZFukvUF8kBEKxD5GA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OQOHoRIz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367111;
	b=yf6PKWA+BvQPbDShKBs3ogANxKWyvq1kf6R704izFndF9PzrUeyZXomHpaDk7RDP7XeXwa
	uXcfRLm7hubRlexc6kONvZ7XR3znnFVGNUWTaGFVW6PahmA9QpGA8UXfXoplH/DMKP8gLW
	THf6oJ8e5w5bhj5UoAPNUlbTossbeA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72CFA60252;
	Fri, 25 Sep 2026 20:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF661F000FF;
	Fri, 25 Sep 2026 20:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367111;
	bh=vckc5AVeFzmihzBIO72nuSyPVb2k1pHjs2iRz4sQTSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OQOHoRIzyntJg8Xo1RYoRXHwhQ+bG4HZWBCCZl9hlnftUEiUYNoY5d1pSDl4gYrfS
	 svZv04MprgIiUsg7KeF2wq4xKxZxKSMLp8N/Po0td5LD4iFakSxkSfI3gxiXDAqrKi
	 0/ejXnHL9jHLN0dVsWV6/zOx/k25F9EeSeNCOEvLzoxu+r2JfWik27AXwvYpOo3LER
	 DIe5KLg7USm05Q9YJytmDLZ1Rz5lK20fJBKEx44W3txXO5P9Ro27szIwCFeeCDlXlt
	 WrD7dTZoLxlJZe99YLoaP1fGFZ436cZNHeOHrMT8w6Z3OxaKWkk2jNc29MjnWtzLJ8
	 TlD5ezH9STRVQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:40 +0100
Subject: [PATCH v5 05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc,
 microblaze, xtensa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-5-31e91065fea4@kernel.org>
References: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
In-Reply-To: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4730; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1Jejfb7dSf6sKUtznm/4uolJpHou1we6g5SD/FgRlAo=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWVnYv7yOCTmHj+/+ULveT4NN7q0ay5z8/mZWzvNz
 m25Jfqqo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPhY2ZkePgzacGbRF3Pvq9X
 V06K6y07sD/TvPb09a6mfBaG2SqvDzEyvHcID2h0STSbcDmv1SFijnTGgbf3nrgveTK5w/tPQ64
 ZJwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: jyp8u8k9jer9d54w8e4x3curomutkxq7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA9CC40012
X-HE-Tag: 1790367111-594142
X-HE-Meta: U2FsdGVkX1+uo8sRquGewmCe9cepIclrTvkvuQPGkXJt04wBDDu1A8eX5nV4XqUXAOqB5U2OrH7aeD18bgawtPF3EEhXWg95pUCxWuGkAu7TXZmSHCPzUgcOTzjuVoePCi+xSw2IJeAp0j5LF9zx9wiRMAMRbXXVbQd21EIGmZUKaRyPEncV5dRRaeqjqjp3iwPa178gtwle2rUjmMiX/DUH0qWYCRRcI9pntuHNt+ABgRzwPDlRJZTUnDkjpwe1w0m39b+A3wxk1/dbso1/MdcZVyyKp4smyb0eFPp1jvsq0T1vSPi+U+lz4lYgpYoxyFBDdoQVDWlLKWUo/P0FlEFHDrx08QNkN38sJvZirrd+D1qu3e7SOkgS63PMIbZ+jgP6elhSWFnZ7u33tQ9JvMaNAvrr/drbRIcSfPu5tIrLZRcXioUdsJRr1K72FKmu+FZ55U8embS5tmbXaP0SjgFBzwSi1CWascRMb+4EFah4WPKbQszRORrspJ5qtpHaCxN43tNjorwRhS7WQcHj5cKrJ+Efwf4YB9wTMt8gA2kowK7epCOh3AArGlrasOLuAnPe4a7cdTLZzsb4B/9SHzkRMSz5MUktcC4Zx5mVRDnRU2toyRO1oa9F39PuyeDDsfK5QAUDji2cJdiHeKv7v4COD1YZo8FBlDS8ppa014yilIpkFe0XtrFrSWVJppP508Ib7JdxczK94aNnpQjBTF7t7BhSIH7GhI9mpzEUp9QKcp4Twvad8ypRii3r9bwHQYL+uTzeG/vaIHbM74Z5ImryotsOSVFhHQy5D1Fabn60Mvze0VInOWBCtuTyvIi0LY2XsL41c7f1NtqybsIlFEpP9yb54FlM/haSYSub/iiemGhGTukjZCkqRq6zApgn66uiD+/8Ltzk1t1sTP6WkjY+70zmN1poFaXo+5N/r/Fxd1TGz86HhkfJY72MISv/9lOXIHyVF/ZXv/uIisw
 4/kaRg+g
 pRuAVUrN1hYGUiFGhLJ+6miBMJmkQAZ8A15O32hELtafE2HjRtkfWy53KspUY/aWcbQQHz/KeXdr5DUzRbx8nFOsOMK1qylLL1PuETiZdjm1ea+/CMI0O6v1sEqiwy9wlLf6kaoTMFkUrsUM85pECFANW4GZQvuBvQgi5iVFfxkZNGvmlit40C4Zo54tWD0AnXfjIdiGsuELqwE9OK6vy+09LefoYZeNUq0f+df18uz1UoTrGZmH5IXpduLaHJ2GjeIQsqHBjEzc4ePxE8HfYzdrgt7jVyYpdMXYPKrLAFjTTBFtECJFH4y9rlJSVipaVnVw9AeaOMLxJuiqcVMheyGkwI/Cib24HIus+pkk7sOAwzH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each of these architectures directly free page tables without routing these
changes through tlb_remove_ptdesc().

The use of tlb_remove_ptdesc() is required for
CONFIG_MMU_GATHER_RCU_TABLE_FREE to correctly free page tables under RCU,
so simply update these architectures to use these functions.

Since none of the architectures share page tables or do anything unusual,
nothing complicated is required here.

Therefore this is simply a mechanical change - convert __pud_free_tlb(),
__pmd_free_tlb() and __pte_free_tlb() to use tlb_remove_ptdesc() as
required.

At the point this is in place, all mmu_gather page table freeing is
performed under RCU, and thus MMU_GATHER_RCU_TABLE_FREE is selected for
each architecture.

Note that CONFIG_MMU_GATHER_RCU_TABLE_FREE is dependent on CONFIG_MMU for
xtensa to reflect the fact that nommu does not implement page table
gathering.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arc/Kconfig                      | 1 +
 arch/arc/include/asm/pgalloc.h        | 6 +++---
 arch/microblaze/Kconfig               | 1 +
 arch/microblaze/include/asm/pgalloc.h | 2 +-
 arch/xtensa/Kconfig                   | 1 +
 arch/xtensa/include/asm/tlb.h         | 2 +-
 6 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
index 2ed7186c81c5..7a7542b61823 100644
--- a/arch/arc/Kconfig
+++ b/arch/arc/Kconfig
@@ -47,6 +47,7 @@ config ARC
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_DOMAIN
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA
 	select OF
 	select OF_EARLY_FLATTREE
diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgalloc.h
index dfae070fe8d5..9b6c37f92e97 100644
--- a/arch/arc/include/asm/pgalloc.h
+++ b/arch/arc/include/asm/pgalloc.h
@@ -72,7 +72,7 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
 	set_p4d(p4dp, __p4d((unsigned long)pudp));
 }
 
-#define __pud_free_tlb(tlb, pmd, addr)  pud_free((tlb)->mm, pmd)
+#define __pud_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #endif
 
@@ -83,10 +83,10 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 	set_pud(pudp, __pud((unsigned long)pmdp));
 }
 
-#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)  tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 
 #endif
 
-#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)  tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif /* _ASM_ARC_PGALLOC_H */
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 484ebb3baedf..af7e821e96c1 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -41,6 +41,7 @@ config MICROBLAZE
 	select PCI_SYSCALL if PCI
 	select CPU_NO_EFFICIENT_FFS
 	select MMU_GATHER_NO_RANGE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSE_IRQ
 	select ZONE_DMA
 	select TRACE_IRQFLAGS_SUPPORT
diff --git a/arch/microblaze/include/asm/pgalloc.h b/arch/microblaze/include/asm/pgalloc.h
index 084a8a0dc239..ffee6a009219 100644
--- a/arch/microblaze/include/asm/pgalloc.h
+++ b/arch/microblaze/include/asm/pgalloc.h
@@ -25,7 +25,7 @@ extern void __bad_pte(pmd_t *pmd);
 
 extern pte_t *pte_alloc_one_kernel(struct mm_struct *mm);
 
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, (pte))
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #define pmd_populate(mm, pmd, pte) \
 			(pmd_val(*(pmd)) = (unsigned long)page_address(pte))
diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
index f2f9cd9cde50..33c4caee30e2 100644
--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -55,6 +55,7 @@ config XTENSA
 	select HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select IRQ_DOMAIN
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA
 	select PERF_USE_VMALLOC
 	select TRACE_IRQFLAGS_SUPPORT
diff --git a/arch/xtensa/include/asm/tlb.h b/arch/xtensa/include/asm/tlb.h
index 8c3ceb427018..6fb7b78154f6 100644
--- a/arch/xtensa/include/asm/tlb.h
+++ b/arch/xtensa/include/asm/tlb.h
@@ -16,7 +16,7 @@
 
 #include <asm-generic/tlb.h>
 
-#define __pte_free_tlb(tlb, pte, address)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 void check_tlb_sanity(void);
 

-- 
2.55.0


