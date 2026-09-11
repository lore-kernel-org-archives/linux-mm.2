Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7271C88E5A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D64726B009B; Fri, 11 Sep 2026 15:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CEE6B009D; Fri, 11 Sep 2026 15:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C05DA6B009E; Fri, 11 Sep 2026 15:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C91F6B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:39:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E03F01C1F0E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:39 +0000 (UTC)
X-FDA: 85202496078.25.AA652EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 33C68100007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BJAVqof/";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155578;
	b=HozLNY04/OhCCXfbvJaT12nIuh9Jt/yCVM9UZyCuR7TclRmD4ES4Z7czjw/VNmAhLhXwbJ
	aB9GV38avr+RA3W/vto80FSLuIRtEXPB75nEDLXPwupfwC/6bXmLtGP62T0S5LowgJxisp
	aZI/I5VASBw5gbx+mBWJ++/MeRZF21k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BJAVqof/";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BckCZCGc4vzG9wqcN+JQhNHkdFRqc5QwTzQVV8XEoLM=;
	b=lj357Op3xmm2q94C2zWoItj3fKvHrRXyvQc31EvPudSgaACW/pfVc8MTkQbfqeExJwEPKt
	ZI5jUfeZ0AFQfWu+yzO11nHH9+j+9wbySlDzlasQFKdJhzgWzkmoJ0uM5PqlLusYM+bvyG
	rMfvN3AFCZeov8hPqM7zq4zk7VqGIco=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A486860008;
	Fri, 11 Sep 2026 19:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D6C1F000FF;
	Fri, 11 Sep 2026 19:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155577;
	bh=BckCZCGc4vzG9wqcN+JQhNHkdFRqc5QwTzQVV8XEoLM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BJAVqof/u/c7FIQI+5GzXn0KRuBxmgx8LDVa6WdBTPdDoifqdZXYU3fm6FWLhq6Qu
	 p2UsfJ3gwHrWEIuKPcrixgQ53ybvhteksMpqWrDWuEn+bJw6SIktwWSfMeowmW2D/D
	 i96BHR/dCFivr9bHt21UMZc25tYenv7qpiuo52Hbw0iLWfcze7ZSE4qr4YYFaii1bd
	 TW+Xgkk3Vm8xiEMP4MQfICKAaMGvOqUIrBf8yUu+aDD5JTq3JeBTWN+Gp1CL4MFQoV
	 elR+MHxTcQu+bW1lVd3L+Qc7BDrvTWPKsaFHAH4Nim99M0KIodLPGu+HjPE0ETgO0w
	 a/3KIwLmuYhRg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:52 +0100
Subject: [PATCH v3 05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc,
 microblaze, xtensa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-5-7b8c86103821@kernel.org>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
In-Reply-To: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
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
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
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
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4685; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uQXm1gV0hImCHIW2c39SJsX9YEkAV3QIf8B4ruAyqy0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDTFd3T1rHzcr3inrOyDlm2bXeqvHQ6dM9fbHReL2
 bpTwPh/RwkLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACayfSsjQ+MG9ob0eY/W3FiS
 w7fNxajzofBG+8p/OXYsiSd3uTLMTWP48Y4j9R93F6PPoVc9QfNszu3oXP5WTH1yXM2CV94vU5s
 ZAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 33C68100007
X-Stat-Signature: cm1f4nhm4uubkcz1wwc4ksk97hqbx5dy
X-Rspam-User: 
X-HE-Tag: 1789155578-652044
X-HE-Meta: U2FsdGVkX1/vAbMZaaCa9t4FR5VoKqk0i+MpZho8gWyQbNX6wSn0dq75JxQ3WwgpuYZeetn2FVyUWbiKOzGmoADSb8k8qcc9pSNWNluPmdRjibLHvV6XYnlIE1z3t0zJUqH74NhuL1R8rDv+oh2xRX81QEnui30YwzAaN1eIayaeZT3Fbbu+3JLuNcyYS5n0G2msBmQxJVDm3gIdpZ/+YqlvMry6hXUZvpB8B8rWz57XMycsv/ZxAXL5p+bbGs+k3ZMHHF63aIk2nNcaV6QbA45Cgnmo2g5EgXOh5ivq/hTWKU9Iu8E+X7tIdzV6Nq4gau/7wjUv5g4EJUHyxml9bTWQGkOHNfjAt+xOg6vJPdQ6yQulsFaZNMqBySs6FeoX/ohl7g3AsV/vz1ZsBzbHOOGGSkikYYYAIReae3uu6euSOITsGNKjEx17Wfz/TNXYjyV4xRW3p0V3RVUcAbKjzRe175pGMJw1aUx4A3kqmnNA6ItN/jnUtESUJjTyBNKXooBuLkWwMP4MaQXYoR1rElTlZNEYKf+fnsiP15FppWQX4g+grOlTkRWZOnF+aEafGL7r6n+eR4lc3cyVyHy0WH4YgUpza6cTWE64aKA+0FIUDV4lf4ruS6bYlDUdCey0OWBIsviX/JLWjQOn/sHKFz1JKgtZUMI/Sc+d3gb+nh8BNw4Y20bez+Kw/WmHTBZw60wSXqn7zvgRzqFKsZ6kOxuwPRI4Lf0B8zv8cfTr2qcH9OCICq8/eLVilS4WYDyvU64pJhxJCMrtqjwhPZe/Xo8fTt7L9llmkUtlS33c+pA61+vQqHljczajIB7QAAnqiV3m6rgolzf9KXMf3uiNL1jDsIWfM4xifWG3fPqWSzcAKCaCBRvwAtlmg/eG/lpXKwsuMTS2IlGUxFOnQbS4VayMolK+0cgg5+jxGQUght0xX38I8I4vRdLz80mdbfv8MXMZ2yBjfGQQcfZMRPo
 HzZdl0Zb
 Yp9+vC0LTyx21WiLrO6u2a/vK+Ream7EMnkd3uPcbYT1bDJm1Q3futjiipXPtoWxP/jDoEYPxONKkmK+VWitK+ILf5ovv6N99alS2eXHl9rkXinaD7gOjDYkhXIb9ETavwMpvPEal6HO2GXNumEefP1HlNpvp3QOSKmiAbOHVzzIV5dFmny6eBTOS141UFOM5zSK94uaIWTjlXtAyvDFPUVV/KMFMFP+swd4kWMp3DwawDuEAsa0mM3oUmmaMLLLadeyUmK/teGyPr5ELWxwI8ltkBHBYLXso8e+r/79Q493tq3cEKiWYJrodOqCEfDEBL8cmRCizGdavVeSQzxY3hl9RFeNTFnQvzpPGmdTR40rnYVg=
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


