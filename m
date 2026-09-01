Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9BAC624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E8AD6B013C; Tue,  1 Sep 2026 07:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFFE6B013D; Tue,  1 Sep 2026 07:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F192E6B013E; Tue,  1 Sep 2026 07:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6C966B013C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:07:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6AD4F1C1F68
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:17 +0000 (UTC)
X-FDA: 85164916914.14.90D5012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9F8528000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKcC35If;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpWdcIey4xCI1AAiZQP3vw2H/6eRNpO9q4dcacOYsLQ=;
	b=rAaAFFW7Uivg2fCnFyeR+eccYkvA3IltLBgqiL0bJxOANr23hhnyO6fM8eYcw1cZNcbvli
	/mtjs7iDTMBzwEXMxlfVWfKFkF9dy2FV/csCZWylMCh7SsTgz1CujQl59yJWGl4c5OQeIM
	RpVEW6NedeplsGgXorLjKwNnPss1k6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260835;
	b=LThUkmf/ngxrQwP3MRgpZc4aA0WB/PscwE/GgXJEolWrazaySBxppTc2OqCh8thoUv5Iao
	1qq9p0nhFlrwECqVO2nrnYEh9+cE3HLi6F4RM+LXrDVwfLiWNioQ3A+GHpGHoWEEBTEM2S
	A/S+25fIWOtXb50D+dIRllsEPIfuLMo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fKcC35If;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A83B60204;
	Tue,  1 Sep 2026 11:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3661F00A3E;
	Tue,  1 Sep 2026 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260834;
	bh=NpWdcIey4xCI1AAiZQP3vw2H/6eRNpO9q4dcacOYsLQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fKcC35If/CtvKChvqt5gUvqvorcc35uBsHqFaoGPqLbiuylQdAEfGO/G5E+6idRQN
	 34UBrVl0XrBauS51NgMCTWbZU0DLB7faiJbbqAB7l0KmaZOMIY7Ulwpk3r5RuNtz0N
	 eCm7a/Rk3wqb5TFyn0BlOEXPprS22p9u9qa5KPK9ow489ArtoKwNG0RygpFPB5fdjD
	 xE2TDdfkkTxWDpZ5LX4CSAN6qksgUVkiaekknySbV4Bxdpm7H7bkGacdSps6MCu8mN
	 1S20jBBhqJlJA+jIArUyFc7z8VBwFYgsNH5bZv/ggaKXNYDy32b9Z5G6IbLpu2LLtH
	 pUdonUJS5p+6g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:28 +0100
Subject: [PATCH 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-8-5456a81c8212@kernel.org>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4126; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wpROf24w3fAQ7cNDxi2SGsbF1TZYrv0Ll+LdZO5C4PE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbfTY3rBju4Bd4BKvOA7GJCfm9T3b5ft/f1wYWJjuG
 z0p5uuyjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExE/jDDf4+p69lmSPrUvtu7
 JHk1e3DdtdYCzhnb7DJOt1oujv9/u53hD39LvqLvpsWJzapJ87dcr3/goHf2zLSK0s+T9P21Vjz
 bwwwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: udfbc3z3bt4nhmurimtn6zus4itd1p5j
X-Rspamd-Queue-Id: 9F8528000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788260835-84434
X-HE-Meta: U2FsdGVkX1+OjeHilrdb8Edic/zoR66fVCrFECjl1suPPn69Ewu+51Pf+ikS1c+kVtEK9oVuBisLqemJIVxxrG84pR/vYSe9SF7E/INSBL+OgzBjTIadcinhobdD5vZJ2OT8g5rsv2XMx42XLGqedPJJmrAad6gueh8u56W+2dNHc9ewS3sgU/5yyT4m1NTYRDfk77D16coWQAUFZjP5RniK4Ikzr24OFJmzXC+SyNfTTt5fNuj2/a3hxnPLoJUPNdYoHIH6KfsNOdYajym2Wsah2YlNIUZLVXZ/jEvJrWIOjMNnq0PwajQs4vVZQhYPb1SU6C0O84Xd9czOXB/Lz/++GcAKET+BLpPqkdJCEa+KUhPBaEnc+Gm0ltKpuhcUK6aJW/LhYgY+cAvJJJTeBmCGehLehLkUgbnPA3P3qL0stuuo0uBMAYP3bWEP6knUX8pye5ZZp1u0xJiU31QtYTJmiCO068R0BKnyWQgP1uVGx8nJ+FR9x6T0rCzKwKlCsuY9OOAYVvKU/MLN+RMqpXgfPfVeO1Q8FzxeUTl9MN6PufDs5BP9lgbOdkr1Lb+YKY/xlhPboYw3f9hRHi4Sg1QuxrAdb295V07SmWcDxRP+lvU+Q431DX1OeESnSLVaMHqudX7OPZhzZDxQcT2KhYKrQEHwcjq22PFPeqNUzMcRrcnFjma6TV3C+gi4YSSBTTHDkPu3tO4SlyrbV8RNtFqL6qQ0VK5Sm6EFZhIhHEGM8KT5y+aEUnpE2v7izGpsk1dQMgn13JlXOA7RPKbjfSNxNjP3co/25nIdKFK0vjTBj2Ieso1Je07HBgAmBRIxkgeVCugPAE6staRnj3kPpUMtApuViei6FSfBnq4JvGmp8xFcpFs801VxGQAJLcqJHndpT9W9g616Lj3qI8/yC15x81RqowzLP6OHyKLgi9HVhWtpG2TabJT0ToTEJC6lRfr4jxVYaenqjDJmN9I
 03Uyv9gL
 uYC9Ywpc3XpPJsyR4c7n6EHek9ZiCXlRV3oXhxYI24DY/jT0U5riFd0GAahepMcRvC/ec1FD2wqyjfHgjPmy1gfeYK2HgtlcaHJYIppEFRRsHMUODXNxRQTcsfdzzZyJw4riylR7101eaKmi1/aYS1Rt26e///QLL9UpRCuTSPiUVOTRdywgIq7nn8ouUcpgP8BjuAhx9HVjFYw0jGwxjSLGQT0y4mo/nUbWOhVM2B8DceJGXoJPBTccBvrumF3AjwNCRJwuytmnqqgfX/HAFFdygFLY+KD+45MhByv9Ecuas4KcGfJJm7duV6sfTkXRjCzz3I1gCxvaKbkPmngF8wApgy6qfy4WqL2aD8tIEfmkklVE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, non-x2 sh specifies CONFIG_MMU_GATHER_RCU_TABLE_FREE allowing
RCU page table freeing.

sh-X2 is problematic because it utilises slab-allocated PMD page tables,
and thus tlb_remove_ptdesc() cannot be used in these cases.

All other sh variants are fine as commit e3ecf7c7d082 ("mm: pgtable:
convert some architectures to use tlb_remove_ptdesc()") already converted
page table freeing to use tlb_remove_ptdesc(), which does so after an RCU
grace period when CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.

Resolve this issue by firstly specifying CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE
for sh-X2, so the arch can provide its own __tlb_remove_table()
implementation (called after the RCU grace period).

Then, convert __pmd_free_tlb() to tag the pointer to the PMD, and have
__tlb_remove_table() check this tag to determine whether to free via the
slab or to use pagetable_dtor_free().

This follows the pattern used by sparc64 as implemented in commit
4a0100f7546f ("sparc64: use RCU page table freeing").

Previously __pmd_free_tlb() freed PMD page tables immediately, before any
TLB flush IPI. This seems to be a pre-existing bug, which this change also
resolves.

CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is only specified for sh-X2, as setting
it disables CONFIG_PT_RECLAIM and causes __tlb_remove_table_one() to call
tlb_remove_table_sync_rcu() and synchronize_rcu() in turn, and this is not
necessary for other sh variants.

This forms part of an overall effort to switch every architecture to this
mode.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sh/Kconfig               |  3 ++-
 arch/sh/include/asm/pgalloc.h |  6 +++++-
 arch/sh/mm/pgtable.c          | 20 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 204f64912f0e..75236bef6f16 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -33,6 +33,7 @@ config SUPERH
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_TLB_REMOVE_TABLE if X2TLB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
@@ -61,7 +62,7 @@ config SUPERH
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && !X2TLB
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA
 	select NEED_SG_DMA_LENGTH
 	select NO_DMA if !MMU && !DMA_COHERENT
diff --git a/arch/sh/include/asm/pgalloc.h b/arch/sh/include/asm/pgalloc.h
index 6fe7123d38fa..67ce7fa23fa1 100644
--- a/arch/sh/include/asm/pgalloc.h
+++ b/arch/sh/include/asm/pgalloc.h
@@ -17,7 +17,11 @@ extern void pgd_free(struct mm_struct *mm, pgd_t *pgd);
 extern void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd);
 extern pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address);
 extern void pmd_free(struct mm_struct *mm, pmd_t *pmd);
-#define __pmd_free_tlb(tlb, pmdp, addr)		pmd_free((tlb)->mm, (pmdp))
+extern void __tlb_remove_table(void *table);
+
+/* PMDs are slab-allocated, tag so they are freed correctly. */
+#define __pmd_free_tlb(tlb, pmdp, addr)					\
+	tlb_remove_table((tlb), (void *)((unsigned long)(pmdp) | 1))
 #endif
 
 static inline void pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd,
diff --git a/arch/sh/mm/pgtable.c b/arch/sh/mm/pgtable.c
index 3a4085ea0161..f6184b86b89c 100644
--- a/arch/sh/mm/pgtable.c
+++ b/arch/sh/mm/pgtable.c
@@ -56,4 +56,24 @@ void pmd_free(struct mm_struct *mm, pmd_t *pmd)
 {
 	kmem_cache_free(pmd_cachep, pmd);
 }
+
+static void __tlb_remove_table_slab(void *table)
+{
+	kmem_cache_free(pmd_cachep, table);
+}
+
+static void __tlb_remove_table_pgtable(void *table)
+{
+	pagetable_dtor_free(table);
+}
+
+void __tlb_remove_table(void *table)
+{
+	const unsigned long addr = (unsigned long)table;
+
+	if (addr & 1)
+		__tlb_remove_table_slab((void *)(addr & ~1UL));
+	else
+		__tlb_remove_table_pgtable(table);
+}
 #endif /* PAGETABLE_LEVELS > 2 */

-- 
2.55.0


