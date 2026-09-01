Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284C3C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493A06B013E; Tue,  1 Sep 2026 07:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B0B6B013F; Tue,  1 Sep 2026 07:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381AB6B0140; Tue,  1 Sep 2026 07:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 111A16B013E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:07:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A9B8160385
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:49 +0000 (UTC)
X-FDA: 85164918258.13.6DFB215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB52E40004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibERjQL4;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260867;
	b=kNEwH3cjNqOcsUErLJQypmktu/TAS1C11ovpycsXd27z3b0+dXJHxDELw0KRymdPo2ymh1
	lmiApScFAyKHCGgYxOB1nLCVkhhstuo+ORcqOsfCF6i8UXvWlodPozvAdTub5rgqpYdrXN
	Zhjkcgw/vUZQS1seWjGQ86DaKr1WRnM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ibERjQL4;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UzmfMP0eW0QWk8u/JUsvHFB9sPVEd1pOiiGI1COzZqo=;
	b=OjDXLH46yWE6/k52nJpzHTDZnYoXOctJ7BEVu1kX/3zQlcWsmGzjEu9VMfMJbK+Ck8EYRM
	NpYlphOOm8WzLuTXhFcIXOBsSKe70cTdxNSl9tG37QO+iC4aoQRVsgLYLpl/iftqkuT9hv
	IApFbudA0EQcNpxEg06jxHGa9UNRzOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF1A340786;
	Tue,  1 Sep 2026 11:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890D11F00A3E;
	Tue,  1 Sep 2026 11:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260865;
	bh=UzmfMP0eW0QWk8u/JUsvHFB9sPVEd1pOiiGI1COzZqo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ibERjQL4ebquAOt5buU64F486oqWBbfA2RuIUoKFTjhNX1tV+wd/vlzXzB2ChZkHv
	 l81wOM2a96hacFPMbPkyXXoBNm2Hzxv/W4WdF2hM2MLHWeDUUI22Hgh/Uo2UP3EmsH
	 6u1tLsmWjj175oxrugx4dQMXcTyodnPkdmSqOUnAv5k4zRONX/wRi1k1UeQuFDk4c9
	 TOGuMPYZqERpof+Ma0CoF75P9Vb9bB8N/xhQG1X3/ETHZGTwbbnr8eP5HjxNvuOWvr
	 /232U2NeMflD6ulot7zvWwwBLRdnsYSIvu9ACtq65I/v7n2wSL/1Kx7ZypCDDNaPUx
	 Gislm4zUwKcZg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:30 +0100
Subject: [PATCH 10/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-10-5456a81c8212@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7123; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xq+2kEjitK8SahcerAyiHbVRI8AjRac23jnTjhfS/aE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbfT4euup8O4LE9bU9LjsfrJFU1mER6vr92f+zX6eX
 qX5n58u6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBElvUwMjybUD2LVcBQ48G7
 BZN/xmmFneuLef1v1fMzj2ztbS0rVYIY/pd9TjZcoH2Mr77xm173C4uZ32aLBbl5TK7+IBjx9UG
 yKTcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB52E40004
X-Stat-Signature: w5cm7bb3fanmr5z5ocsam5j75aiygjn5
X-Rspam-User: 
X-HE-Tag: 1788260867-433965
X-HE-Meta: U2FsdGVkX19iWd3M1+MZM0bZW+gY5ySojYkTZCXX14JRxaFnzkLh92SiqwuZ7roXBoa5iMJsZ98uaPVq1COeYSEWo3ixEInopP3vEXXLdeVllu6+TxSr8k+SPc/5msHc8O6BZ+QDg3bDvhQo7PS85+LDK/TzFIMg1SjpfAEd8yPv/X/8kIN9iA9kvZmVIvGgkZnxxK3hd8bvJaZekVJ7kMcnTGGFpio9F4nSXuGIj5lHHKey1/KiL1nk8Zm2dBf+kx/EDEDH+5k5SNinOsHrDSLFePJL9Xzt5bCtIso9R7HUO8mx//2+RhBH6lb3+UVi4aQRRm/rD1TrKoTg7OsLHXZh2F/j9J6ZAyy3GAGOR82krvQ9EuD8ZhuEClapk/q2+4TUrLePwY6bKI/+pEWMUVaRBd290MZpuvFcmEaTkrv+DGXJ15p8u5hTEF/kAoXd58ElgLMD2N19rXCG3f7vsSFb/PtrdJQOyLxyrDrK3hcUxAIamv4jG2BJn676Lkt43xPa1e6XCyDxqhGWgNpw4ptvINiB6H3tXGAVFr/mq32f/xZGqaV3P7B629VA21yosp72UpxE4W22jRHpIPrGsd7E00GSXwzxZFzopdr+rvUODeSq79FJgl3JL3jAuy74b/jy5bTLS2IZqyLtkDIhaNwFnewiN8RPCyr3YkZ7Uey9VrDLAd+GGaKL3bA4L4LKalckF1jg31OtMpr/WzTxm3EfFkt+bzfj/ytal6PcQAobrsYXvE7lszQsiffnd4Vt7PcYxL7F8UfC7LFPkO9gwGQp8bj4sDXSxd38tkpC2neUAZWCSKVh1+EEF4RD+l4c8FHz6gKK9Fc4LPKZ/fE9l59pUeIWfjhTl0dygCr6cvdFtZoZVQOJragPAVEx3aXxAiCcEDQ5BpIJ59vLRx9jUYiVPMzhw8x2ZYE1SCFJ6jvTCesa6ImlLa7Vad8DQ31GjJKAMMmwY8oBgAiHnBa
 gzg4j2l7
 +kC1ZIXkjArPt4yyTkpfTKZNbKpYjlgT8qY8htzSX206bkL5KADobxrwVttHCO0URNnJhgPKMsX8hjIwoM9uUIe2KyPPGSqLiMOdphQV0tRKLqpbWe7NRUJdj0OhBo5ZRfcEtWRWdTYPZv7CmuuOjVGo7d7nKSSzpyadW8SPDHqIEJh3yHwBET+yLTfS3ZLfRK7bCoKQWhFjzOauBJPYWdgzoEKJUWszzN3zc9Ipk9xoZlBQttxfhyEF8GRo8kdYfjEKJi9uKNnRYNDvgZSiVPwwv2h9aZ38zL+wLF/H9iPxeQ6edCMEaGMnZw0AOVchBJw5EPpBdMK1K51JePMKp719lOoyXLavaM78boACeYdlaqxC9H/cyMxxjbdJLOikyZVdFQRiU9rAikxU3A5L976E6bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Careful handling is required for sparc32 which implements page tables as
part of a shared backing page.

To support this, a custom __tlb_remove_table() function is required, as
specified by CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE.

This allows __pte_free_tlb() and __pmd_free_tlb() to specify which page
table level is being freed, which is transmitted to __tlb_remove_table()
through setting the lowest bit of the page table to 1 for a PMD and 0 for a
PTE (the page tables are 256-byte aligned so this is safe to do).

Next, since the page table freeing is done via RCU callback, and thus might
be executed in softirq context, update the spin locks to IRQ save/restore.

Then, in __tlb_remove_table(), figure out whether to free a PMD page table
via free_pmd_fast() or a PTE via the newly introduced __pte_free()
function, using the lower bit encoded in __pte_free_tlb() or
__pmd_free_tlb() to determine which to call.

__pte_free() is identical to preexisting pte_free(), except that it
optionally allows a NULL mm pointer to be provided, in which case there is
no mm whose mm->page_table_lock can be taken.

This lock doesn't appear to have been doing quite as much as it intended,
as backing pages can contain page tables for multiple mm's, which are not
serialised by it.

But more importantly - the reference count increment in pte_alloc_one() and
decrement in __pte_free() are atomic with full ordering, so it simply isn't
possible for there to be a meaningful race here.

Note that the specification of CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE disables
CONFIG_PT_RECLAIM for sparc32, which mirrors sparc64.

This forms part of an overall effort to switch every architecture to this
mode, and with it complete, means every architecture now supports
CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sparc/Kconfig                  |  2 ++
 arch/sparc/include/asm/pgalloc_32.h |  7 +++++--
 arch/sparc/lib/bitext.c             | 14 +++++++-------
 arch/sparc/mm/srmmu.c               | 26 +++++++++++++++++++++++---
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 8d42ebc6d302..79c09d6ee466 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -64,6 +64,8 @@ config SPARC32
 	select HAVE_UID16
 	select HAVE_PAGE_SIZE_4KB
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select OLD_SIGACTION
 	select ZONE_DMA
 
diff --git a/arch/sparc/include/asm/pgalloc_32.h b/arch/sparc/include/asm/pgalloc_32.h
index 4f73e87b22a3..36010852ba0c 100644
--- a/arch/sparc/include/asm/pgalloc_32.h
+++ b/arch/sparc/include/asm/pgalloc_32.h
@@ -48,7 +48,9 @@ static inline void free_pmd_fast(pmd_t * pmd)
 }
 
 #define pmd_free(mm, pmd)		free_pmd_fast(pmd)
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+
+#define __pmd_free_tlb(tlb, pmd, addr)					\
+	tlb_remove_table((tlb), (void *)((unsigned long)(pmd) | 1UL))
 
 #define pmd_populate(mm, pmd, pte)	pmd_set(pmd, pte)
 
@@ -72,6 +74,7 @@ static inline void free_pte_fast(pte_t *pte)
 #define pte_free_kernel(mm, pte)	free_pte_fast(pte)
 
 void pte_free(struct mm_struct * mm, pgtable_t pte);
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+void __tlb_remove_table(void *table);
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_table((tlb), (void *)(pte))
 
 #endif /* _SPARC_PGALLOC_H */
diff --git a/arch/sparc/lib/bitext.c b/arch/sparc/lib/bitext.c
index 32a5c1d9459c..c309e27973ce 100644
--- a/arch/sparc/lib/bitext.c
+++ b/arch/sparc/lib/bitext.c
@@ -22,8 +22,6 @@
  * @align: requested alignment
  *
  * Returns offset in the map or -1 if out of space.
- *
- * Not safe to call from an interrupt (uses spin_lock).
  */
 int bit_map_string_get(struct bit_map *t, int len, int align)
 {
@@ -31,6 +29,7 @@ int bit_map_string_get(struct bit_map *t, int len, int align)
 	int off_new;
 	int align1;
 	int i, color;
+	unsigned long flags;
 
 	if (t->num_colors) {
 		/* align is overloaded to be the page color */
@@ -50,7 +49,7 @@ int bit_map_string_get(struct bit_map *t, int len, int align)
 		BUG();
 	color &= align1;
 
-	spin_lock(&t->lock);
+	spin_lock_irqsave(&t->lock, flags);
 	if (len < t->last_size)
 		offset = t->first_free;
 	else
@@ -64,7 +63,7 @@ int bit_map_string_get(struct bit_map *t, int len, int align)
 		if (offset >= t->size)
 			offset = 0;
 		if (count + len > t->size) {
-			spin_unlock(&t->lock);
+			spin_unlock_irqrestore(&t->lock, flags);
 /* P3 */ printk(KERN_ERR
   "bitmap out: size %d used %d off %d len %d align %d count %d\n",
   t->size, t->used, offset, len, align, count);
@@ -90,7 +89,7 @@ int bit_map_string_get(struct bit_map *t, int len, int align)
 					t->last_off = 0;
 				t->used += len;
 				t->last_size = len;
-				spin_unlock(&t->lock);
+				spin_unlock_irqrestore(&t->lock, flags);
 				return offset;
 			}
 		}
@@ -103,10 +102,11 @@ int bit_map_string_get(struct bit_map *t, int len, int align)
 void bit_map_clear(struct bit_map *t, int offset, int len)
 {
 	int i;
+	unsigned long flags;
 
 	if (t->used < len)
 		BUG();		/* Much too late to do any good, but alas... */
-	spin_lock(&t->lock);
+	spin_lock_irqsave(&t->lock, flags);
 	for (i = 0; i < len; i++) {
 		if (test_bit(offset + i, t->map) == 0)
 			BUG();
@@ -115,7 +115,7 @@ void bit_map_clear(struct bit_map *t, int offset, int len)
 	if (offset < t->first_free)
 		t->first_free = offset;
 	t->used -= len;
-	spin_unlock(&t->lock);
+	spin_unlock_irqrestore(&t->lock, flags);
 }
 
 void bit_map_init(struct bit_map *t, unsigned long *map, int size)
diff --git a/arch/sparc/mm/srmmu.c b/arch/sparc/mm/srmmu.c
index 9a74902ad181..2a2c7bd21011 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -359,19 +359,39 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 	return ptep;
 }
 
-void pte_free(struct mm_struct *mm, pgtable_t ptep)
+static void __pte_free(struct mm_struct *mm, pgtable_t ptep)
 {
+	const bool process_context = mm;
 	struct page *page;
 
 	page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> PAGE_SHIFT);
-	spin_lock(&mm->page_table_lock);
+	if (process_context)
+		spin_lock(&mm->page_table_lock);
 	if (page_ref_dec_return(page) == 1)
 		pagetable_dtor(page_ptdesc(page));
-	spin_unlock(&mm->page_table_lock);
+	if (process_context)
+		spin_unlock(&mm->page_table_lock);
 
 	srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
 }
 
+void pte_free(struct mm_struct *mm, pgtable_t ptep)
+{
+	__pte_free(mm, ptep);
+}
+
+void __tlb_remove_table(void *table)
+{
+	const unsigned long encoded = (unsigned long)table;
+	const unsigned long addr = encoded & ~1UL;
+	const bool is_pmd = encoded & 1;
+
+	if (is_pmd)
+		free_pmd_fast((pmd_t *)addr);
+	else /* Called from softirq context, no mm. */
+		__pte_free(NULL, (pgtable_t)addr);
+}
+
 /* context handling - a dynamically sized pool is used */
 #define NO_CONTEXT	-1
 

-- 
2.55.0


