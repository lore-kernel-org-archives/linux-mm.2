Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 217D6C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FA76B00A7; Tue, 22 Sep 2026 11:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7866B00A9; Tue, 22 Sep 2026 11:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28B86B00AA; Tue, 22 Sep 2026 11:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA7936B00A7
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:38:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62EEC1A0505
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:29 +0000 (UTC)
X-FDA: 85241805138.04.2349564
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9680A180002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hczF2y71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091507;
	b=IDnNL5mKG6Ocm8XisO7pBMPUz/GWDPbvxfXw4lP7MoRvJXccSWAJo5ICa/OB+3YdtyUnsT
	Bo63p+xVItY6dcMu4WnbbIpUikDvzreyOLr2sxOKpLB+1oVlvBSs5SV7zgu03vH1ZHfMhR
	sjV9zwjvC9ATVnewTxozYTQOR/U3g9A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hczF2y71;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BckCZCGc4vzG9wqcN+JQhNHkdFRqc5QwTzQVV8XEoLM=;
	b=Eg1ZT56j7qyHJvzjKBoICvTxWGwcAizAfceGLiEFYbEIsd8DDI4I4jdtI5SAOWjghPbUL0
	8+Xt1Rj+RTDapPZ9Yi9k4nZneLnH7/cpVkDjtNRG6xwBuJWVV34S3XNbqkGbZvhsQY8h0p
	j4mWRd5B20XFqJEKMATYFBlUfH8BbYM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D048941675;
	Tue, 22 Sep 2026 15:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E801F000FF;
	Tue, 22 Sep 2026 15:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091506;
	bh=BckCZCGc4vzG9wqcN+JQhNHkdFRqc5QwTzQVV8XEoLM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hczF2y71AlJMYpu4N67vVKHZULkCEsC1jdewMZf7zTZ68jmEJbkuYDjvGHkzAlrru
	 VVTdGRic7q6bI25hOgzKaKwMw1bldXcdOufOkY/y9kjsEE31UuSkp1gvLn2NcaKv3/
	 6JD+BuUCvN7AGim/QrSZ2leQdE8ROIUA54ZaSPB0+pmV/wH6SN54d4ek6/0IDIuLN5
	 OQ8VIEYaHaNBcfKUBUIJ4RnRmH+5ZkL1rbIqcZqm3fTH42Wba2SJklOLkUaC+5ffP0
	 2NWVTmu21ufgyXLytMnKYyfbzPaGAjDW1X9n1/hKR8g84+eML9mer0DECeMEkjiACf
	 VOOKF2njdqfCA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:36 +0100
Subject: [PATCH v4 05/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for arc,
 microblaze, xtensa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-5-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4685; i=ljs@kernel.org;
 h=from:subject:message-id; bh=uQXm1gV0hImCHIW2c39SJsX9YEkAV3QIf8B4ruAyqy0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LcjeUX3q7EYBFY/bNxY03exr0ZGNiVeaKWfIdXDJF
 m4n8YynHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjILjuGf9pveG59W2cgdnDr
 3ZkaK3JCSw2vTI6ZuPlekWtIEVtr8wRGhslfOw5PWHx2+0o25qi9LnzJ5S9mv1t6/i+7ibx3QKn
 fCVYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: snq1wk3haxrhrhqss7rhbrc4fgn3ngac
X-Rspam-User: 
X-Rspamd-Queue-Id: 9680A180002
X-HE-Tag: 1790091507-449584
X-HE-Meta: U2FsdGVkX19gIiOqeCyj8m3xx2gGX9K32eQYACjqMhXEeP/O6eO6Bu6AaODle9RFrZVVFCrNXXaLwtflxa3xMhgnGKEA9ZixOJ6Fe4u6ovxUERpWh8C08c9xmckoAdqrUSxh9u6dV7/3EfoGDsljqD8xuoILOPo74v58ela7gYMtu17LRiTmZ4i6vZVEr3plUzkjfDKdQ7gHR6QhwO5AzyHjdbMXaTTYT+ke1Wix795Bwf8witW3QtrHKn4xx50RM1I110f3F8DUpFkqWB8g5oFhk244IAsI/7iVpxeFzP+o0LPJTEAhlVZEh56f3VVVxVN5IaJSCr2eSf5MjjQkthMX8JIshJc9seHGQjSvg4cvbT2V0+2WSJhbZH2LMdfPOaE9ksMLr5yiFva2rz+vTAXLNOK0n9XfWtgkbJnulnZAvkcqzhCmsI5Ql/4AOdhx8S/PQUbDchIO+mm3wP9l7tF1KeSA833jsOJHoW/aDnkPCVYbksC/rzgia3sdK+0+kJnOg56XCdJIoztMh0ejz/zIH1zUCgCtawC2TX/tghTLi8xG40qeOZT8vSFYhF3LvZhR2W+FhXX/ewaDPahTHxsQAt8XE7O3t0/qqgcJFHdab+7sfU/POc0LHyHKzv9pw2Y7ZsezbfhxBp+TNH0TEr6IiZDsYXwWzF6Vl0Ql5GNfp3j+yyWdP33idfvGm1V5KWx9q4MdwAH/kVNvSIM79OGy3Y6uk4C7noMoJNSnWliKVQahxQL9plwwbVZNhQUUs1d7tN5AjPiqu9SM+1+2eyRCahWgrCqq9LdUMAk7D4HcKx43ucswq5xTihuB/6iIoM+aX4/bQ0m7bvs03WHci/fWetBtqX+P9eC+QpQySx8OVINpooe1Sfq2rh6ljG9mbp+h0hHTWzCeYWQqi25/xa8UnD7SRV1qyEinY+bSgrKwi2fIGxS83R/G/+yeBQJbU3iJ3BjEEOBNTMnD4Kz
 KWaGGePB
 mEkL8G9e3IiLPGlch7bDwjl81Oxth8eQMKS8yB7C867fX2Ml2X2AajbcPePnTD5W5m4esWRjzGPvZSCTX1JzM/ou/7XcSGPxnk04+pnXOxc9eddiu8ao+Hl1ideBb0aG2asUvJlVy9sCN494l/w4jHtiqslxMBclEBiIy1IB3h9WxqNt3r2HG6q4EgcATP8u2tT2vVeNw37BE2RDnOaGGKZVW8LYfgwS1iUiWcdITKNBJu7mpsmyFGkkrbAP/wzETyJ9PDJp7O8QPeOb8PbdjmqS+mMPsAbDVO0tQgip8xP7bbIt5ym5WrVz8cmTNG4JnTt7BCmaktqxmAcm/hHpD5emggAQQ2h52Xac2aG4aMOqW1w96Gp+Hf0wA5ZniynvSYcUKBMkU+E+/8H6A04u0zQoW9ZJewtQmjm6t99FcW4dJUpYYdz21vu6oLe3WMkoQoahB53g6VgIp9WHjKFw9biwyzNLuWqdAhmpzChorQo9yOGA=
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


