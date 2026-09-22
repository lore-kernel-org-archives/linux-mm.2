Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBB85C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4F86B008C; Tue, 22 Sep 2026 11:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC446B00A0; Tue, 22 Sep 2026 11:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1D26B00AD; Tue, 22 Sep 2026 11:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A74EC6B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:39:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31243A0563
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:57 +0000 (UTC)
X-FDA: 85241808834.18.26618CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 507404000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhpAWdpD;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBG5/twDrSmSB3MHNHrdw9YcNjORS2eLnr9jQpeNRXk=;
	b=KgaLmCWPPgxHqzGSCCmyufFmjHwIiOSs1kD9pLjHMza1RKVTOH+bTfVNNmvnU/EXlFV2Oo
	9Omu0fjPPspAoeo8uP1cBrwCPPmURdGLGeUA1J/vVQldZvwPpObvRchLx8sKxXlYpJ4sXJ
	90/dV73Rk/r4sxhvLhYZRhkIKOK7yeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091595;
	b=Cnzke4SqRB7nJNSKzZyzgt/0Mr9x9LS0305E7dD/57Nr7n7dttTIBTM9uX5S64OTnkSTc4
	VM5B9GCchsVYF2xhgXLQozsgFTGo6jetnBHl42N9AlKoQEaeTpK5l/9Tl0FRzGMOYjOnyt
	4CVcNvgsN8koeGcKQhRIt4+LzpQCo04=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hhpAWdpD;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D22DC60A82;
	Tue, 22 Sep 2026 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77EE1F000FF;
	Tue, 22 Sep 2026 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091594;
	bh=rBG5/twDrSmSB3MHNHrdw9YcNjORS2eLnr9jQpeNRXk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hhpAWdpD0bvsD7jM4OC98q7pXiJr60RL902irU0pwWrUMQNgqCkrex1OAAWUhA7zb
	 QWSVQsz5dFD73V3wdjQffK6t5uwzud1jYGqled6O803NYgWk8LrnvJopfonxPmQCh+
	 s2hoTuZcFAHRcG8RlhB6T4SNNqcBW3/TvzUlXdFeKmcdZmd2sVihHXMayer6EMPoX1
	 u7teLNtM+miWVxsFbLnT6Z/DpxS9PGMhUt1K47heJPk/L7LHNrSgavildIKajWjNEg
	 AEd3DtJTM+9XeLYbviilSP63Rjfed5m4kxtMUkZlVdkkEqeIxYfKjM0uVqk3P9d70L
	 xv0InEHt6GXiA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:40 +0100
Subject: [PATCH v4 09/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-motorola
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-9-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9564; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p817yyNbZ4NhaQkL3kSpCEKgVmtWbKpmnpJsqVcbxII=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2Lcip3tumej7jIp+UTvbmZoGMBZV5JuG/VW2rWM7dL
 GyPYbnUUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgImknWJkOHJ21naDb5WmR9O8
 Lps/arzI6LI47GdwbnjJMrHCu5vLbzL8j/Yw8DBQKnbIfX2/uX9PrILm2U8Tp8WeF1975vTB1xP
 3sQAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 507404000B
X-Stat-Signature: 64uzgdwu8porffwsqbbpwo7e7cqj138j
X-Rspam-User: 
X-HE-Tag: 1790091595-840188
X-HE-Meta: U2FsdGVkX1/eOKoiKCGvUen2Vlpo88HfJz0Chku2/o0VsExLvlLgStYkqbAEeW1gqrup7iMEsG+OPS/VI+Wxb6gCoapsaQy7OFbWp1zZQZhpTZyvV+UJO0k/2mj1yx7OsDCJfl9Rc4HmNKE4+GTCkg7xPgwzle40jljo6qfZwav9zkVWP1ddGFV6aw92FeYgmRGC0CV4hQMCPMygZl9IEzXe9N0kmHt9mAwviY/sdaRY2n5xpkoEGYvKRRpmexYsRGs60QKTsi0WLspevv1rmDnk5UhJCI9r5RH+QivCfY+KPbVg/PTJy6RL1JFAs+aGDNSsinZarO3LNsUqeNHO6lgHQlVyINfM4XnsnRuthukBKISxhprYz+Wu5Fno7mq/fSIKL/WhWQJ8dYUnwbP5zT+rNIHHHXVpmJ01sOE9279LtqZcNjy3JAbJacVEtYtiwxINSf9B1MkyeacULcsfb1yM+iGIRHnm4e+dBjhgF7FO/MHF/aFRQUnfnAoexNJ5vsJajzAS3ctX7fAoMFvOAQYd4eXzNXOhKU6760WkYOQMN4RHG1BbDlr38+xTjFbLFkrxB2oBlCMkjFh9DtaBeNSssniQ/BJoOyCGiUtNxgUIlAJMweJoObpsypNhKv6lh2tYKGOUh2xqRyIka09JcizkZZbV15NLocOhsW9zN4JzNmb2+lc8XQYNByN2isDXXOyWrTKSCnOU9AfGfmWLkRcu18P/zkjjYCH20JCTjv4j6WCktnIWL5nzKODXcIkR0z+pHkZZ/11Lo+JS78JmLyfI6p0uLgExoTwxFSnOopxELTHG+eXoYzviLIfRQqHSdx4z9u1+mITceP6I5KSxCQ4rVdWdLISesWtlnkO29eYwem90PPvshloRThUgXDWMg/NU6yws/LqUBqFFipGfJ06xo6WBnlrBuPQBEaKeRlU60q22CnklhRVf0jeUl971kE2YvU7tTxxwilPVJQz
 +PNPvPId
 jrK4Z205L7DANt1pFwGVewNI+vs5cxImxx4KbtRegjzN5A2BxH4FqpnMPe1UbSyB/VbXp8u0xUiou9r4ojrRgzLepnI1tkVreqaPNdWbdywTHS3nsMf5/wqI6OouzshsvcXcDq0WTxPT0cWBE6i/TJbi4BLrOI6YlpmGZcEFagBbYuhQI2UG8eqWlxj/dSRp3MqlCcGNeYGZB7DvstcYL2wxxL0T8JGV4HqqIUv/Oiw4Mhw8iQPZhsEIEpmEFQBVPm3Cu64197ozvgT1x8/nFSbLBDJBq+PskcCav3NygHCcVAznGNOPj9MLXEXBD0Ed4FIwMBxvVwk0uM6catDGqYFBgqpj51m3v0syWN2oGsHep84EuFIIgpCjIum9duNL9v/ZVMFKEQA5Cp32MuIzG8tamOyuXSIaQD+1j4suJRU+scuvHIRxt7puyzgtAcn41wGKcT8Qp4nHzLy99RWAR1RtOZUr/VUWXpgfbuuPtEYbf8zLSJyefnaJRH1eXFBi+k0iW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sun3 and coldfire are already supported, however motorola requires a little
more care.

Here, custom table removal logic is required, so
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE is enabled for m68k-motorola.

Firstly as part of this change, the page table level must be communicated
to the underlying __tlb_remove_table() implementation.

Take advantage of the fact that page tables are aligned by more than enough
to permit setting TABLE_PTE or TABLE_PMD in the low bits of the pointer,
and store this there.

Then update __pte_free_tlb() and __pmd_free_tlb() to pass this through,
then have __tlb_remove_table() decode this and pass it to
free_pointer_table().

The page table freeing is performed via call_rcu(), so free_pointer_table()
now will be invoked from softirq context, and as such may be re-entrant.

Introduce an irq save/restore spinlock to handle this, and hold it over the
time a given ptable entry is being referenced in both get_pointer_table()
and free_pointer_table().

In order to make things a little easier in this respect, separate out the
logic for adding a new ptable entry into add_pointer_table() and only hold
the lock during ptable entry insertion in this case.

Note that original list_add_tail(new, dp) added new prior to dp, which is
ptable_list[type].next, i.e. after ptable_list[type].

The equivalent therefore is list_add(new, &ptable_list[type]), which adds
new after ptable_list[type], only without needing to make reference to dp.

Note that, as m68k-motorola specifies CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE, it
does not enable CONFIG_PT_RECLAIM. This isn't meaningfully impactful.

With this applied, all of m68k implements CONFIG_MMU_GATHER_RCU_TABLE_FREE.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/m68k/Kconfig                        |   3 +-
 arch/m68k/include/asm/motorola_pgalloc.h |   9 ++-
 arch/m68k/mm/motorola.c                  | 121 ++++++++++++++++++++-----------
 3 files changed, 86 insertions(+), 47 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 6b8ec67c86fd..fa5d39549da9 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -29,6 +29,7 @@ config M68K
 	select HAVE_ARCH_LIBGCC_H
 	select HAVE_ARCH_SECCOMP
 	select HAVE_ARCH_SECCOMP_FILTER
+	select HAVE_ARCH_TLB_REMOVE_TABLE if MMU_MOTOROLA
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !CPU_HAS_NO_UNALIGNED
@@ -36,7 +37,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
index 1091fb0affbe..dcde40e8b5c6 100644
--- a/arch/m68k/include/asm/motorola_pgalloc.h
+++ b/arch/m68k/include/asm/motorola_pgalloc.h
@@ -17,6 +17,7 @@ enum m68k_table_types {
 extern void init_pointer_table(void *table, int type);
 extern void *get_pointer_table(struct mm_struct *mm, int type);
 extern int free_pointer_table(void *table, int type);
+extern void __tlb_remove_table(void *table);
 
 /*
  * Allocate and free page tables. The xxx_kernel() versions are
@@ -47,7 +48,7 @@ static inline void pte_free(struct mm_struct *mm, pgtable_t pgtable)
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
-	free_pointer_table(pgtable, TABLE_PTE);
+	tlb_remove_table(tlb, (void *)((unsigned long)pgtable | TABLE_PTE));
 }
 
 
@@ -61,10 +62,10 @@ static inline int pmd_free(struct mm_struct *mm, pmd_t *pmd)
 	return free_pointer_table(pmd, TABLE_PMD);
 }
 
-static inline int __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
-				 unsigned long address)
+static inline void __pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd,
+				  unsigned long address)
 {
-	return free_pointer_table(pmd, TABLE_PMD);
+	tlb_remove_table(tlb, (void *)((unsigned long)pmd | TABLE_PMD));
 }
 
 
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index b30aa69a73a6..ffc80483440b 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/gfp.h>
+#include <linux/cleanup.h>
 
 #include <asm/setup.h>
 #include <linux/uaccess.h>
@@ -103,6 +104,8 @@ static struct list_head ptable_list[3] = {
 	LIST_HEAD_INIT(ptable_list[2]),
 };
 
+static DEFINE_SPINLOCK(ptable_lock);
+
 #define PD_PTABLE(ptdesc) ((ptable_desc *)&(virt_to_ptdesc((void *)(ptdesc))->pt_list))
 #define PD_PTDESC(ptable) (list_entry(ptable, struct ptdesc, pt_list))
 #define PD_MARKBITS(dp) (*(unsigned int *)&PD_PTDESC(dp)->pt_index)
@@ -139,52 +142,66 @@ void __init init_pointer_table(void *table, int type)
 	return;
 }
 
-void *get_pointer_table(struct mm_struct *mm, int type)
+/*
+ * For a pointer table for a user process address space, a
+ * table is taken from a ptdesc allocated for the purpose.  Each
+ * ptdesc can hold 8 pointer tables.  The ptdesc is remapped in
+ * virtual address space to be noncacheable.
+ */
+static void *add_pointer_table(struct mm_struct *mm, int type)
 {
-	ptable_desc *dp = ptable_list[type].next;
-	unsigned int mask = list_empty(&ptable_list[type]) ? 0 : PD_MARKBITS(dp);
-	unsigned int tmp, off;
+	struct ptdesc *ptdesc;
+	ptable_desc *new;
+	void *pt_addr;
 
-	/*
-	 * For a pointer table for a user process address space, a
-	 * table is taken from a ptdesc allocated for the purpose.  Each
-	 * ptdesc can hold 8 pointer tables.  The ptdesc is remapped in
-	 * virtual address space to be noncacheable.
-	 */
-	if (mask == 0) {
-		struct ptdesc *ptdesc;
-		ptable_desc *new;
-		void *pt_addr;
-
-		ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
-		if (!ptdesc)
-			return NULL;
-
-		pt_addr = ptdesc_address(ptdesc);
-
-		switch (type) {
-		case TABLE_PTE:
-			/*
-			 * m68k doesn't have SPLIT_PTE_PTLOCKS for not having
-			 * SMP.
-			 */
-			pagetable_pte_ctor(mm, ptdesc);
-			break;
-		case TABLE_PMD:
-			pagetable_pmd_ctor(mm, ptdesc);
-			break;
-		case TABLE_PGD:
-			pagetable_pgd_ctor(ptdesc);
-			break;
-		}
+	ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!ptdesc)
+		return NULL;
+
+	pt_addr = ptdesc_address(ptdesc);
+
+	switch (type) {
+	case TABLE_PTE:
+		/*
+		 * m68k doesn't have SPLIT_PTE_PTLOCKS for not having
+		 * SMP.
+		 */
+		pagetable_pte_ctor(mm, ptdesc);
+		break;
+	case TABLE_PMD:
+		pagetable_pmd_ctor(mm, ptdesc);
+		break;
+	case TABLE_PGD:
+		pagetable_pgd_ctor(ptdesc);
+		break;
+	}
+
+	mmu_page_ctor(pt_addr);
+
+	new = PD_PTABLE(pt_addr);
 
-		mmu_page_ctor(pt_addr);
+	PD_MARKBITS(new) = ptable_mask(type) - 1;
+	scoped_guard(spinlock_irqsave, &ptable_lock)
+		list_add(new, &ptable_list[type]);
 
-		new = PD_PTABLE(pt_addr);
-		PD_MARKBITS(new) = ptable_mask(type) - 1;
-		list_add_tail(new, dp);
+	return (pmd_t *)pt_addr;
+}
+
+void *get_pointer_table(struct mm_struct *mm, int type)
+{
+	unsigned int tmp, off;
+	unsigned long mask;
+	unsigned long flags;
+	ptable_desc *dp;
+	void *ret;
 
-		return (pmd_t *)pt_addr;
+	spin_lock_irqsave(&ptable_lock, flags);
+	dp = ptable_list[type].next;
+	mask = list_empty(&ptable_list[type]) ? 0 : PD_MARKBITS(dp);
+
+	if (mask == 0) {
+		spin_unlock_irqrestore(&ptable_lock, flags);
+		return add_pointer_table(mm, type);
 	}
 
 	for (tmp = 1, off = 0; (mask & tmp) == 0; tmp <<= 1, off += ptable_size(type))
@@ -194,7 +211,10 @@ void *get_pointer_table(struct mm_struct *mm, int type)
 		/* move to end of list */
 		list_move_tail(dp, &ptable_list[type]);
 	}
-	return ptdesc_address(PD_PTDESC(dp)) + off;
+
+	ret = ptdesc_address(PD_PTDESC(dp)) + off;
+	spin_unlock_irqrestore(&ptable_lock, flags);
+	return ret;
 }
 
 int free_pointer_table(void *table, int type)
@@ -203,6 +223,9 @@ int free_pointer_table(void *table, int type)
 	unsigned long ptable = (unsigned long)table;
 	unsigned long pt_addr = ptable & PAGE_MASK;
 	unsigned int mask = 1U << ((ptable - pt_addr)/ptable_size(type));
+	unsigned long flags;
+
+	spin_lock_irqsave(&ptable_lock, flags);
 
 	dp = PD_PTABLE(pt_addr);
 	if (PD_MARKBITS (dp) & mask)
@@ -213,6 +236,8 @@ int free_pointer_table(void *table, int type)
 	if (PD_MARKBITS(dp) == ptable_mask(type)) {
 		/* all tables in ptdesc are free, free ptdesc */
 		list_del(dp);
+		spin_unlock_irqrestore(&ptable_lock, flags);
+
 		mmu_page_dtor((void *)pt_addr);
 		pagetable_dtor_free(virt_to_ptdesc((void *)pt_addr));
 		return 1;
@@ -223,9 +248,21 @@ int free_pointer_table(void *table, int type)
 		 */
 		list_move(dp, &ptable_list[type]);
 	}
+
+	spin_unlock_irqrestore(&ptable_lock, flags);
 	return 0;
 }
 
+void __tlb_remove_table(void *table)
+{
+	/* The bottom 2 bits are used to encode page table type. */
+	const unsigned long encoded = (unsigned long)table;
+	void *addr = (void *)(encoded & ~3UL);
+	const int type = encoded & 3;
+
+	free_pointer_table(addr, type);
+}
+
 /* size of memory already mapped in head.S */
 extern __initdata unsigned long m68k_init_mapped_size;
 

-- 
2.55.0


