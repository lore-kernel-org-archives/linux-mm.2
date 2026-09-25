Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADB01C9832C
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0E736B00A5; Fri, 25 Sep 2026 16:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0206B00A6; Fri, 25 Sep 2026 16:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4F26B00A7; Fri, 25 Sep 2026 16:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F53F6B00A5
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:13:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1C9314077A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:13:39 +0000 (UTC)
X-FDA: 85253384958.10.9570411
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 83FDDC0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:13:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYY391F5;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1awR3oo1ZRmiDpsme3v+lmICU9zMkPXlWYBHt8+qVg=;
	b=UjCtbSSbUNs5myZ1Zd5tEj+KmXkk0R7PiGjGy0ujLCaGjJeftCL3Z0D4REvvESTuoSNxZb
	7rJIeep6mS2O2HfN6+1wfvWrNm6QhmcF5HsyIzyqqff2aKjMkHYe86snmW7MKktZRrNbcV
	GEyc+54APwQ05OiyI8qR4MRyzYxfcQE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYY391F5;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367217;
	b=EmVfOzEt+Zwtdx6RBwMvcSnxApL8q17YvGB9TU+lPE8KOo6/lWP6js+MCJMLYCuqAmBEC/
	MDQw7xqcdfhe1mXGbFqcYmvrtSL2VZlI3AAhGp8Ag8ZK9nT4vszr8UMfDZ1LEcZe5js4uU
	MkFz0ATAC+RIgGp5mz+HDUPKyfZQDlg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7DAD403A8;
	Fri, 25 Sep 2026 20:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165421F000FF;
	Fri, 25 Sep 2026 20:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367216;
	bh=A1awR3oo1ZRmiDpsme3v+lmICU9zMkPXlWYBHt8+qVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FYY391F5bC3StdjN+2QhxobfgjqdPziAzB99IcImBv4i0LLF8bs3CMV8sFdEDssxb
	 dKtL3jbIIDpuL1L/vbmPEifnqhcitD4crCEyisUB1hTnunD4SihJX/63TikQNRHjDa
	 d8xBn2d5gbBtvbJK+9K54kFWwFUfxjhFk4NC7Y4pxdpO2qk/Q/0Rqb5W7DZYrPnnLO
	 bddqOJmSmphY3OuIf84oeU2x1gkHEycrPwM6Pwd0BD4tpdCaqeevNnLHV+FoTIx897
	 tjpmIsvCzZ8R3yEzTkvW/BV38e48V5HiVyBUzDmWpokWNb7xAUulwEsvUvSv2TbNKa
	 ia3CGkXgXRvpA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:45 +0100
Subject: [PATCH v5 10/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-10-31e91065fea4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7548; i=ljs@kernel.org;
 h=from:subject:message-id; bh=juZ/yujoqrVrS2+XOwuMn/RZEfnjHSMRhvkPIAQeNnk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWX3YNyq//GX0Wwm5QWHVvVcumkxIftiWVPZ5sCGj
 18CO803dpSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiuzYx/K+wmxf/3Ctl3TJN
 M29P/Xnaf+zzslwO9mZm3v1cmRP2RZfhf/7HoFcJJzhO/Y6IDlc/czD4Io+b2M+71+Z1tUoJbJx
 tzgAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: o75ofiqites7q7c8n51y6ahhatkyw4wz
X-Rspamd-Queue-Id: 83FDDC0008
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790367217-572114
X-HE-Meta: U2FsdGVkX1+yr1SWjSgmuGWEeBVAPVX3Tol43wNb03NK8N5o1j0Py8b5IuZZ5cBSHB44tsLbvo1Bu7Cmj344DMFk5+HayZQEupMFfUiW4ZjFA9g6BnrgtyHsJrawK5ykLkPRgFopwh9PtJRHXLLrf61/9H0vycWv3Q8BSTH3fYfoCrY6ba0wQK/VIc456BBlxwxbCcyPKNQwJAMsnR9+LG9XuR9qwkLspU/ZoivM9xYIY3iGoxPpaVttrfoX08o0AJV5n/C/0yXWkqRLXphqcpxVRANM1Mh/4JOx2saS015ccOfwpbFAzrVrsOPZbpKzR0MeTaRqRptE8Mb5LbDO11mR96I15vPHP7I/NAPjplXWSVSbiJzi9+GGSLpExlVuZ3IVaaHz4Hm85isMP+jv/tUcn9k4aolroIq8jcKCyaQ1VD7DWbhSpX0NIzLzS/IR12xnIw9NqTfZvSn6GopZCnAOs7HW4lQUwcIT/RIWumUlzdTmzuuUKCNERfXeEYKVsSqQMXace8GXF8bMcCShHxSc+YiswRmlu3iWqi3ITYkRz2PZbemH7qikkGAdSZILAabhMnELLI/4N0gDXbhcVyMtL3OwrZAIxR2C3DDM1gCHVMjkzPohsgzfZSTfF16LTj+0B9SXsPfovWjxovh2aAlVl/XKjZkIsv0Ha5IThpXEQhtsnO1jBdWIjrUiv9pBFCyLhnzDm3ZdXxl7D1TsnSHAtqG4wI2r2X4PXXKZeARSXdJy4ubNV8TDvGVSrmkMmDgvtv5h87OqiId76DEllNukhX5n435W6Yhd/v5CgIjKf56nWcDGFVgZ/IgUrYgFPN79+JgGo16SQTCf+Yy09OVlg4DS5z9SaUWg2WbX3cXEe71sRHNG7aFpvmgGYio7ufu9xDEW/RM1fF2OOUbCL33wVUtWfWkgSvqqsXboyc+MJD7TcseiUrneTHWZGDxkCOJnhSO7MF2yU+Mh2aK
 q7I4DFng
 Yt8ntu79TdXA8pV29VphEkmRDwFAbfHxlJqzedcpxA+tsK2OiRTqwiH/jVzPaJe2bJg1iRk5NtE57oaFxNoAH2aGz+rzeGkMSJzMV/dB3Yb+LgQsKLVhBMkm9p0wZbFkm5tO00YCoQrsQcYFw26OFU1kx+O4g2qvn15EYypTwZd8aG19V2Yv8AQu5a+wQZJ/YXoCauWIBAc3k8gmkHMR2+EWX16jSOhPveqdSOrvhkwRK0PNkc63rsqVkRt0iXTNqLMO3lXvD5r7M+9UZmhUQQJ5en6M5MZQEP5WENU2txzJa4r4dkfO12PGoE2osZthQMqm7WTplyg+ZaPr+jrV3mbbhfd+WuuvCT0g3n8yz9aH0LnkJWINwXeCvaRvk7tmJWAHj19Ost7rYx1ygcfdf1RHKSA==
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

As part of this change use this spin lock rather than mm->page_table_lock
for all shared page table exclusion, as RCU freeing means that page tables
can be freed from soft IRQ context so both don't have an mm and also
mm->page_table_lock is not IRQ-safe.

Note that the specification of CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE disables
CONFIG_PT_RECLAIM for sparc32, which mirrors sparc64.

This forms part of an overall effort to switch every architecture to this
mode, and with it complete, means every architecture now supports
CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sparc/Kconfig                  |  2 ++
 arch/sparc/include/asm/pgalloc_32.h |  7 +++++--
 arch/sparc/lib/bitext.c             | 14 +++++++-------
 arch/sparc/mm/srmmu.c               | 32 +++++++++++++++++++++++++++-----
 4 files changed, 41 insertions(+), 14 deletions(-)

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
index 9a74902ad181..1c277ab3cdb8 100644
--- a/arch/sparc/mm/srmmu.c
+++ b/arch/sparc/mm/srmmu.c
@@ -340,38 +340,60 @@ pgd_t *get_pgd_fast(void)
  * Alignments up to the page size are the same for physical and virtual
  * addresses of the nocache area.
  */
+
+static DEFINE_SPINLOCK(pte_page_lock);
+
 pgtable_t pte_alloc_one(struct mm_struct *mm)
 {
+	unsigned long flags;
 	pte_t *ptep;
 	struct page *page;
 
 	if (!(ptep = pte_alloc_one_kernel(mm)))
 		return NULL;
 	page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> PAGE_SHIFT);
-	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pte_page_lock, flags);
 	if (page_ref_inc_return(page) == 2 &&
 			!pagetable_pte_ctor(mm, page_ptdesc(page))) {
 		page_ref_dec(page);
 		ptep = NULL;
 	}
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock_irqrestore(&pte_page_lock, flags);
 
 	return ptep;
 }
 
-void pte_free(struct mm_struct *mm, pgtable_t ptep)
+static void __pte_free(pgtable_t ptep)
 {
 	struct page *page;
+	unsigned long flags;
 
 	page = pfn_to_page(__nocache_pa((unsigned long)ptep) >> PAGE_SHIFT);
-	spin_lock(&mm->page_table_lock);
+	spin_lock_irqsave(&pte_page_lock, flags);
 	if (page_ref_dec_return(page) == 1)
 		pagetable_dtor(page_ptdesc(page));
-	spin_unlock(&mm->page_table_lock);
+	spin_unlock_irqrestore(&pte_page_lock, flags);
 
 	srmmu_free_nocache(ptep, SRMMU_PTE_TABLE_SIZE);
 }
 
+void pte_free(struct mm_struct *mm, pgtable_t ptep)
+{
+	__pte_free(ptep);
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
+	else
+		__pte_free((pgtable_t)addr);
+}
+
 /* context handling - a dynamically sized pool is used */
 #define NO_CONTEXT	-1
 

-- 
2.55.0


