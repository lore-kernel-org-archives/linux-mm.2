Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED05C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7126B00A0; Fri, 11 Sep 2026 15:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17E736B00A1; Fri, 11 Sep 2026 15:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 096946B00A2; Fri, 11 Sep 2026 15:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D79296B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:40:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7397B1C1B12
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:40:38 +0000 (UTC)
X-FDA: 85202498556.21.DB15F87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B8B2C4000D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:40:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyltT7GR;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155636;
	b=7w6L6IFKESI/gvEvAeZP4IAmzlcxf733zAKpFcmLLOL+k9QleW7+lgLv+wwee/pXRlhV0J
	jYKF7VvFmWoILuNQR+wSxzR6rg4bGwU6ITaVh57UlAnM4jUNGykGagYSuUj92VvFlK75KY
	3GpjrM2BkGYjcdqYcqpE0VVWKYUoC4E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyltT7GR;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZF+xTol/hcpNyDp5nDHTBbzlkakusmjcTTc5URGnJdE=;
	b=1sXYolviGcydTHH4Kbgte5Xi/gZVTeoN0PwDQ/q73F932JDChNNwJWzzJCjTSFzRXZ3ioa
	/ct4Xv9hS8OEYZGuh25AcV6IaWpF4fQun3G4/EcGBn3mOO98T2/Q6k+TDKpecTpa1kETcd
	2YKb2hltt6oFLYEKLBuuKHpw5iMRtzM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 543FA600AA;
	Fri, 11 Sep 2026 19:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1E6A1F000FF;
	Fri, 11 Sep 2026 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155636;
	bh=ZF+xTol/hcpNyDp5nDHTBbzlkakusmjcTTc5URGnJdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SyltT7GRf8Lkt9TcySnXYxbXIhTIldgr+WSEmx0DTpEApwnUkY6ZDur69pnhP3+Qh
	 HIdySxWQCzr04aSCvKmHiWFUyN5hl+c2pDyeNUjbVo2E0gPhQlJf4eKXMuT604hu13
	 ifcUK6HxNuvN3BaLKF2bWkWrdihKmkiEo28WU4l1CD5JrgBBV3yrPJIYQE4BgGe7D0
	 qEbVL9A/ICFaO+oZM83gqafydpwhgNq4NykHcgfyZbNZl8IjnOWXTsi2SrSPQw6Beo
	 wqpc7ZUZHoZGecP//Jv/1AG46/MoMx0lMoIrW/baTIUmAnAqxhq82ur9vRHQUKozqd
	 /F2KwuoN+0mMg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:55 +0100
Subject: [PATCH v3 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-8-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4177; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vMbfUQkzgTSKIjU6KPYoUnxQRGxa3kcmbXWa6+LkIAs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDRpTKnx9FC9sXWPT+bLlgkTRU1cLz3x6mNbeKZGL
 erLPKXIjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzk+QxGhhu2yj5nv3rwmK05
 /yjZZv/PQN/mRyFtL744MhkLujQp8DH8FQ1k2aaw/f6nP25LGbnaQzY358u/YLl4b+85uyyeK1v
 dWAE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8B2C4000D
X-Rspam-User: 
X-Stat-Signature: ucomawgutoe4sfbeyamc5bwt6us3uaep
X-HE-Tag: 1789155636-611053
X-HE-Meta: U2FsdGVkX19ysYitWKUwUiR5tb386tm3ergqCgkXNZxh8qUXAsZlkJQ2tN/V6naX2eKyGMGkm10L0SCLpY+Jlgs2hVGG7cHYGgn4MOKbOL3Kgkj0zvogHxKzvtSYyy+Hzxx9rIskGMPR67aXEkYgmeQjF5ncIxOr2RPOAtqsnfC+CVBFaLeA+mGcaCyI1Yir7PZzgITKWP757MMg4b6WnwI5/krKWXMtT6my+WkLKMyDTJfeMIyjdUAhtiL/K38ir/NaX5JiT6KMgmRcAupHcd/kwq/boTZtA6/bEqDG7+O9cr8DDqhljAX7r5n3jL3i8BraxGpjNvWMe9lJN7Q0KmhlFauXz0ZUUssPPtKGeDsd7H3FBdXNsYiSNsTovsjVAz25O5dMWMAHTChdoFsuOO9bmkliG8CoE49Ex/2ZXXA+Z51QjDmoDmeGdK8oInfdcx6eX68fTvjSv3docGZ9Bk27BnxU1OQ/0pXIwigzBzsT2vn2uoCOMSsFoCj+XjyMcrMb21JcnifuROfNtCR7DGAfWxK8nz5mXUPUSszX2yoCwwadiBRwGSkMafR/0RYQXy/w/Wg/VbSVSrCn8Fl/41j8QR1vcX0C6Z+3LcazS5Ub/2SHfJJ3r/uB6z/agUfYjYPYJsUYiZBUp/z/udocJnggmnluIM5zBjwYYcJeJS0U6ptrRgZhUxY3lHyodhVc7E6hb6WRpvngxF7Kll4lQQTfVWZN5JDRnzuhkD0HwXgp6SH7TJxI0kjqxApTZQUy7U0nfY67K9pYYRtcsj1LpPkh1lBkQAeqTRn+4LSW+OfL30h2DOhaKlFsKYFaEb0zzBtdQL5ZPsNzWSKgTpiDVY1kC8gKmCAdaeMDuFWWAYo77YF1ODYac2rM/ueYitU7S4h+tz9MZCLBJ0vY0U7NIC/85pPPWR22WllQMJskI1Khabn05AQa3t64mxVIDHmABX7s17gStnb/KTxmB0U
 H67L/9kU
 +cqOpB0wmcbJLECm7M1w7h5tf8wpdaSKbLtcxvYLcwroa5Gn8ljOKSQtZZnHrId8AUSIeEOz2O8CI7Y3UUiAWERW7IdUjeRnvQ0Sz/aAyfmoNTP60wf/otJTHdqbaSVyvJReaxiIN3NGrmRmrkurZVqj8XfMQW5+OxVJgod5ZndJWK/EoJJd4otSXjV2BJkHOaiQsxK2BSFtDcow9IQyYoHpXPu36BFvP+SEBdJcnr4bZS2XGeMAz3nPmlrh5abVoKPcDrent9a48ydIsN59509E9hn2ykEvobFy+aFHyLS7rUV94f3zzHZgbzzR+zOHnjTqeoyK5q8b5aRuIVaTh1OYbBCe5AfZFRz/nKZYYQQaKnNM=
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

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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


