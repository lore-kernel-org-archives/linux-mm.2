Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED33C98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1F26B00A0; Fri, 25 Sep 2026 16:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9776B00A1; Fri, 25 Sep 2026 16:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACFB66B00A2; Fri, 25 Sep 2026 16:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 802706B00A0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:12:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F38BD80719
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:56 +0000 (UTC)
X-FDA: 85253383152.26.A6BAA1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D3C9140004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoSc9Jsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Kh9URTqx3+SlaadiKZbGWnbSyeyU9KtRJxdWpySnaw=;
	b=y10WESZ+DgdbrD3Bgtltrzz5tLQoe1/4AiOchZ7vUWyJjhGgNx/FmMWwLohpBUTTPd4fJT
	xyoJmzI4G5m+Q4F61nvZeLttgN1ubJT8Ko/riAtgunr5bzrzlv0YVPj/vUOkLo33+wUS+/
	A+CdxJH9toi8aFRRq38mzliKs5TfOuQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OoSc9Jsu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367175;
	b=ZVnJe06BVlxosn+snCGkccCNpQp/pxuAa0futvn8QvCEkrqCsmEsoIati4397Zu6yaPd6Q
	5559AhIqZsIXpkHTm1jxmmSBeBVG4EYjweGw6kHGv39v0kdeG7bXa8tXzmztl8F1smuUkB
	lk4B9LoMjQivYQGqeDNc1huEglluzKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4C9B6022F;
	Fri, 25 Sep 2026 20:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EF91F000FF;
	Fri, 25 Sep 2026 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367174;
	bh=7Kh9URTqx3+SlaadiKZbGWnbSyeyU9KtRJxdWpySnaw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OoSc9JsuQ2uTkvwn9PGDHAg0BSfeivccowW/zAEbpAuuGjhArzn2jeY6DAbDtBqFy
	 M+8PNmKNihk5b+id0y2HrE11QKfjN5DFALwqOipnOGhpoLcLZBA6VuTbYPsnb0eECq
	 rC9UhFugmC7Qc4cML/I72MdFz+tQYJXyLYDhzBHw0pyWqE7k6pblg0oQlLvvo7Rcu/
	 sZvd62HxV7TfZabMcVUHyl2Yr78eLGNkC5Phdsm/iTrwIzXKGM/aLHEsWBOQHNog/8
	 nA0s76Wdqaj+zZNR3iBYuo7+7OBYOWvB3FN4Z6T1rh6Mn3RrtIBI1qGe8ol98LaeAH
	 d7Q8ufRrdxV4A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:43 +0100
Subject: [PATCH v5 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-8-31e91065fea4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4222; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LIKVLPdgTvixCm5b1s0RnhQBz2rNn/VSLQ1UWZakBPA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWUPbXgfu0o/otjKzvnm58zd945J3V2yq07OsfO2p
 b++ieq0jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwkYRPDP6VrM6MLFZSq9szl
 6Lrmvv/zye0dzpOa/ru2eIuavmRkEWb4X3flY5mOQS7H0633PlTGMHT+qVsiZpV27NxNyX/Ofjw
 JfAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: pz3qif55dbdruqzwhjjfq5zsecarcx6c
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D3C9140004
X-HE-Tag: 1790367175-192790
X-HE-Meta: U2FsdGVkX1+2oDsQtdWRW82cW+Ae2qq+gCOP6Xn8U0Q8cx9dxPVHugc47okc3ozRJrjruP6f2FJlbJWj0X5mPzzQPX5xfMW2ioGQgJs/k3e/rKvL2kkn38+C52hky4Y+8V9x7vbvTAeceYmlUuOR3Ad78WCTBfnuAQWs6tM3qZiozrwRtX381KwseUjBoiyBgspj8mkOmsM4izoNe/ELjWfB92z0ZXSfMh2ySfLM8cDHeSp1RD+A7WtDqK2eZr38eIYra52NR+/EpfqWM378SD088uBndmbpBwPqMlG8sO3187VL+ERL3a+0qqVebcoiKd1wQJs5NH3G6vFt65tnkrRJ3udGfmaodp7H4FQeUjbK/v0kjlQeDNWMDIguHkchVXbu5ptnCWt9l9dimCPmisbTujo3j6z12tE/qeWDJmXKo2zgBQKc18i0LTD1IoTYgBIoceQwZrATXT6VVREpb1ruxn0tTwriXZG98p35pSo/SM3kE+q3o2s/X2vstVifQBs5copjiwZ+wTVAnFE/WOmoXRBGsWNVuPM0FKW7R8YF7TxJOzVpXIntpxEgPOaTUqnNiC4dUnjWjdcI7/JQ62rZN0mSP1eaVDArGopBHMKUHE9wiVSYx+6tzolTBUyzjG/61ENmJHBVc/VuZOfPHQyg8ZEQ1ZZ4o+3n7yUUg1raoVV5WE/b5tTUPjQXM4WdMzPRDYY0y6B1GK1+rHltsq3oDhMcr2lVLVRpiYFpJMo1YrTe4vnoLOn61BSMOb+Cm2BdmCIt42GkAmTM4XcjDMa9P2ZvAkNPrJD2mneOGttqmGXt2rSlhR5ZGEVm6CmmLsrq7q6oLPX8ZwcsdMmLkgI4cAVAJ31wdgW8ZkCgPXBjEN4BkubtWBXfFXSnzNwVo9JxQ31La3VZuIIAphI8NlsWiMwmKatpUvoFhewE+sdRWRZvxYKts9Ma+S1JJyXkktRl819owE1QlI0Q3mL
 Tj3CMGtz
 XhDuJPanX2PxtrbMwnPPCer8HJacx6n3T2iK6aj9d8UOGkuPShZMXSDV6Xu9uqXjvfjwBqCZ2MQysbhHDs+KqZyadSyX0gOH1q+1q8J0tveFVsCExkBkVHq0PLI4O0iZAkwyruiUdy8yv8OjtwyZsRCpZU67VcK3p3tK0SeA66Jg3p2WkxF50xtwfpBhxB8b43PcL5yAMOEg1YH5jVinrgF8DKVUZ5eS17ertZscC8L0Ga+3VAX/0aAw1Q/Vylf7vE+3+SMQWSUPkpeDSRxtY8YzSFsJCoSQUsIL31UydbyHVDEjSOwUvlSAG3Ai9GoBoZzF57d/g5rU59/hyIce8jn8NuDS2alVOCZumlZA0as+5AZM=
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
Acked-by: Lance Yang <lance.yang@linux.dev>
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


