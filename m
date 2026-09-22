Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878CEC98309
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2C26B00AC; Tue, 22 Sep 2026 11:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AD56B00AD; Tue, 22 Sep 2026 11:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0BE6B00AE; Tue, 22 Sep 2026 11:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5B96B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:39:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C353C4051A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:34 +0000 (UTC)
X-FDA: 85241807868.01.1CC9603
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2345C80005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm22U7Fi;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZF+xTol/hcpNyDp5nDHTBbzlkakusmjcTTc5URGnJdE=;
	b=RZOwX8VO4CuGeLWsZ5Sb8wvRNljlNIYkvR/pgMseMA+3e0oqeqyPkZnYlGF+fX6qK9Qewz
	Wgc0SJK+rp0f8oDyknQSb9wnhxuVWjwDHCKcLiB7gMypcHiWqpuvrqG4WQSnlrFtrGrsZk
	oI9QmT5xR0XrlerGu5Bm5GM4IPUn+aM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bm22U7Fi;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091573;
	b=PWG8eeWciuXmyBEtT2y4G89E9wy1kfabdZuJPJcZtavjLNc2qQswxE0yWH7NDDB0oI2O3z
	Dj+BBAqBoIStU017s+QxhKGE1mkCWEf0m9DctIWUVHCmK1HeP9eig+P7M5lcmdo4IAIkcV
	9oOUdzR5YnHQpn3CYeJB2LhYujxrwwA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B35E360E39;
	Tue, 22 Sep 2026 15:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2761F00893;
	Tue, 22 Sep 2026 15:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091572;
	bh=ZF+xTol/hcpNyDp5nDHTBbzlkakusmjcTTc5URGnJdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bm22U7FiSQN+ggAF3r9V2Q0hTdDX+haEkgL46cvJgXYTzo9vM+dDmqmTp/9VihJx9
	 SAYWsTV+vy+dbQpZKb9sP8GwOF+y1UmnWNMyeMBUje5FYSeaC4hKYJ5rn1h1QVROYs
	 efwCayHiTBPyeuycqYp1H+zPMa928CepF/CWHc5i6rvbMd6bsdfXEJ/1JT/ma/gslH
	 9SxWv5o4OHw2VFBuo+ZThwnCN4O+Y0kIv9egppeagC7qOn9OEZjvPf/H2h8AtIeOgN
	 azEjXleHU0E17mzmNlt7cHeEN8qRySe/5AzeXWgm5MV/ZURMFf47PIrjLE+QUEhKvU
	 go/z03ESbnwtw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:39 +0100
Subject: [PATCH v4 08/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sh-X2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-8-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4177; i=ljs@kernel.org;
 h=from:subject:message-id; bh=vMbfUQkzgTSKIjU6KPYoUnxQRGxa3kcmbXWa6+LkIAs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LchJrVl3zeaaXwmbwql3cltt8pgMlDSuhvuk5AVm7
 6w8HqDaUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIn828LI8CH2f8W8VZv/XLr3
 dUp+cWMge9j7g/ffCDZ7Lv2fsPD4iu+MDM+t3WJETxq7bDm//Y1TqcBOTyNBzhqvo3VPjkyVn/d
 9Ig8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: jfx3kzer8qsszuu4ome3rzjiwcbicspg
X-Rspamd-Queue-Id: 2345C80005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790091572-324017
X-HE-Meta: U2FsdGVkX1/wvz1BF0Wo49QdQLrUJWbHKicAdxn1MTUoydxSMJfVTPoYbvI2sgAng6tU2eY/bgFeX4TMdP4hANNOphrRf8/04VkVXTCJmxL8B5o8OXlh6VFtR/YeQjormflmgsG9ujfNXRJvWlgi94XIFwi/9vYcYHR1+y3+MSFupt0IJwpToxAWmhDy3e4QIHc6XtFE8INSf8iAkqqHcAZzKTESYWJiwvZNBHIyvAVwVTxWEdZyX1ZXwNd06de/LqBqjPqokwY4nPxhr6nf2+tyirLQITwOQzy57urqEySQRpj9zD/qJZPLLULuhgcnWsh39b07H6wD4o1YXKlQ0oJgCYD5ow52mH06n1kXujQ3dkAK525H7e4QoJPQMq1UFWGhSdP7lRJi+0lpYnLz9cOoHBQzG0ackVVLxSoAWLIWCkZkjugLSLUXTR3/841zE1dlytAhPNiXO2vaX/0ZLLvb9BYMn10ovPhJjBfEGopRMU31ZMX0SXQuOihoPyUl2ijFUMbRvCeZn3BQ31H9Co2LGL0khgdgamC7WZ2lnvhvx/Yyho1/4d984p5+CrD2tfnPURp+UKILqB4UtUFZVNJgLFkPK4nEQJvIUHekQMeDs6CKDknE+4WMcS72yuYumkCxPH8G63BDBuTujQEQ8l7oVOtbOhWpAYVjRijVw7jUPgGwuIoCXZXl59OTamfZ77ZRnSv33LjUnUVe5926kMSiuV7kDctBrqMPggE6bGdw8tKUqLbosH38ZXD1xAb+lWxBEebAJyx6jseGtcw2qGbJu/GGKCJFkipX41priLC70QaUOMfFJGH4WppNitYfPbaH8gGQIW0wB/gxeuBwaqX8vXp5Yp6BUmtj6EDtNu+uHgCW1ATB0zLXjWe0azIJioFZePto26aX780v1gajUW6TXSpW5OkyU/Dqi+fgwdLjhJaku1esKUnQ+5MDIQxhjdWbXzK+g2jkOXJZ2bl
 8ieKxNUF
 G2RyH1ANs1Xwt6LUuZM3GZxVxpVDMFhmgpBlVRPDaFODkiunVux1NBBhXTSgu/7sPsPEWuH3mJGzi6yyDQwu3iFEdLJZQi2b8x0JtArv+1oCvgk9n3ohLawued5FicNrK6cvHugbvIEKtv0urlKblfxgPYd+KDhN0oYS4o0+5h5PcnNfondiZsR8ucHFgkl5iPyzxyVgep9pfCtfDUOXWO2Tn0wpfrLMDfSL3JwGTgAko2ja9MlskxYEZ7NEjIBuCifXckxEEKNQW7kkFBfIblSKU3LdDu1U46U+xQawUnbIt2VZr0l7q1JY9lapaxA4qJVG7IGEayPQAmTKWwfO+EE0eMWb0jUDsJWiYc9/oddWB9wHTpL9ds8C7fBreq/p0d1iSjoWiT+hhBeNlTTDxfIj3d8hyROYg9TK2CU2GuERxXTzEbk4Hg+CZy8D4VVwkBh9TvVGMSZ4iR07wsXIvOqUOiCK/LTfS0eOrRBnEqPuJa6Q=
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


