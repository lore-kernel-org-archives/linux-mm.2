Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A656BC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A422F6B00A3; Tue,  8 Sep 2026 08:36:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A194B6B00A4; Tue,  8 Sep 2026 08:36:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B9B6B00A5; Tue,  8 Sep 2026 08:36:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7009B6B00A3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:36:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 048901A0671
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:36:18 +0000 (UTC)
X-FDA: 85190542878.09.480E4E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15058160011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:36:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSEE3eLH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870977;
	b=tQwSxXxn+gvOlSLG+zQepAAj7oxO9ceJU8T2552pD5LCr/lrkRPTJG1RTeN7xKT7dcq4HV
	/vO/S7lqsNZo0k9OYJylazMOFPPNo5FP4L8CxizRi602hiHYHfGeNQpdcFoaXLmMVwD0bL
	6u1ZPlRNG3XMORrTUMWH1xAELKgpI04=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSEE3eLH;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Yn+fN4XsVpOM7QbS7dPPxzgR+QgYqe1aKcSqRsRi08=;
	b=sLZUhTQLR3biBNvGmLlwsziZMXnc82s3Q6bUztqHO1N/bpKuzX5WzYzC2SRA4jS16VEQba
	pQXhXYsQHMs1vsVlkPpIne7yMhVwzyjt9eIntJaZbquPeT3zqCKrx+9R8XrH7NscfTv+P+
	S+iS1MfcXvgPDAQuP6Wp7xQd0E0Jfkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3844340AF3;
	Tue,  8 Sep 2026 12:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A831F00A3A;
	Tue,  8 Sep 2026 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870976;
	bh=2Yn+fN4XsVpOM7QbS7dPPxzgR+QgYqe1aKcSqRsRi08=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fSEE3eLHGOreADMqTIpRBXDPW8kHs+J5YWpjb6hYguRtB+Vd0jKYl0g0I5pPsdQrY
	 3/HWsmMYm/CB+4uGXpSQSU+ROg2cc9c4t5tZNEwLgSJ0Cx+a2psMDNcOg4TGmksvbW
	 TEjcmghJU2LrRZp70WdDGeYzHR0mXMSXMONZcUFKwehCZYymCQj+6CMvgSFaZyL0TX
	 rEr3SVTUNHVPc2eTr6ZTt3fP9i/TyD7A58XUTLw+wXHCjySSe7Xebwm0EozW0fnH7y
	 ZAyQUtxhHzhGO/OhVJprTWfbm+H90tMFBOGQT6TVA5xsfA7hqL6lH4LlKPzVXhxcyB
	 Hj91DOv3HE/Pw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:19 +0100
Subject: [PATCH v2 10/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc32
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-10-1f60b64e878e@kernel.org>
References: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
In-Reply-To: <20260908-rcu-pagetable-freeing-v2-0-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7406; i=ljs@kernel.org;
 h=from:subject:message-id; bh=xRAtx33ggaHgqCgBnjU11lMi7S9z53z/52qjI/kL87I=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMMQ8YVGr+bRni3h5117Vn3fUZGZdeVP2o/mZuv/FY
 LPFnLzJHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhI1TSGf6rp0/bZXL1/vmWB
 hZP4hpAVHGZnClzv94Q3/J3lcT5x1QVGhuaIsAazqbzbCv05chaYtP7SLNZ6ePJMtOOc+zJ/tt6
 8xQYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15058160011
X-Stat-Signature: 4uxebetbo7y77x596q11x7dxa6dc9ndm
X-Rspam-User: 
X-HE-Tag: 1788870976-233716
X-HE-Meta: U2FsdGVkX1/Dh3JUIjO3+E6aztBcxeZCCpAgxVN3bG0HQibyBxFTjTEnC4LWvZhsm2CgQRd+qdHV9YPxY1DhtL7Nmj+JL2x1b/wxwhXmE2erFYNYa2aUt3sAMsMZ9Jigzp+XOZxLTEX5m2dJeBKH6hgPjNJ0eL88eRUznOpsOoOkYR4YTCdAnyuI/nwQffQTMuZfvrz769ma/rNS31WfH7e1npPPTIVT8+z99EnbqhHk+fqWzdriBMKTJ4Y2D7uxmFTJt33uJFrlPTL9cEn1l/byBAtoKXQRXK7F3ElQp5W4eWfH+9u/iJ/snsZtdcZvNV8uKLiOQQEMR6x9tFVw93utMs724wtB9NgLWNueLQz9hz+IiyyVbjjOnwZFC5qcbUh2VJYZUx2RV8fehuBXk7YOwpOli5uNIfqN5PerI336A1Ej9J2PMi7YUi1Jj6Ksb3ZRycUey4JZTNwIjRIJVLVvFFm1I7ui0Yth8lyc3mlhJSjQMGFCDqxYMEBB0nXnGk//Wm+FSGcD+aJFgRoSfN8p1DeaYBNL+h5w+OBZZqfSCEv8kTTw3bYNHCr/Hc0LatJdLzLsMffACPbVxd0viBcYMjbb1I8eDIk9VoDxxHo1qn1JoYz4zcgCqOzUA6XwJedEX7ABkJY3tGYXqBgLFjxYLT5bh2EtjKHFEwtqBBpIpEXiaygS/hCksSl67lkeuGoZl63uqT8mTuEk6TxrheCorhxzvr1Q9IAr9TcI3GMeppRBB/JWZBuj0p7K0/es8y9JVx4HgOtzJhDYo4Umc+vdktt0mmZASu7EZ08f1lP9jrBnqeXNn9tSn89JNCI9K0MYy3Xblu+Ep5HOQfTW4S7nUJdBYpNTWR5qfSqu/njb6Dy3lhtyCyrCpR/9/LE5BomaWstl1sxbzrn5g0uqY+hKnhyBZLN7ggQpKR5+ok5+c+bPIjEeQb4nMAhjX4JfyMTnCIplgrZXrAKg0Jq
 bUVYSOgy
 oGH5MrYN4iopIsxG/ywzULM+rnf1tU58rOtQrVF5qDF9/Or8CYiCcEKNBXLe0E460q+JLyz6nCE0Zobm8pFIEqFL9iAZiJhXArsByYsVP+X4JYnLk4vxswQS1fAnn3CYEBx5Wgeatx4jb4WYg+JQEWn7uo4pRZnUXXjCAR5dL2HTDzfVf7XRA7zZhZwqk+zJ5OIOMv7fUUUMkSyV9OPWA1rfJPSs3oe+zBd+aCnidhHt4EnFesaMazSrE5pwcOXlkaQ3jCU/WSN14y3xSPpl+qLzcvCDsy9/1H1k7sFtZ9/yWAm62IestdgROCmFc6tf2sbN3CIzGf5koVxzKjgPvWBazwqP1q5HeFo8ffZeNmT4OAbB2fxu4pWp7Da8iE7Y7jJOIaMt3zxS/tF0Sy/T0Wx3v1A==
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


