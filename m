Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BABDC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3784D6B00BF; Tue, 14 Jul 2026 10:06:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FD86B00C1; Tue, 14 Jul 2026 10:06:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266496B00C2; Tue, 14 Jul 2026 10:06:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1D4B6B00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A44640400
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:22 +0000 (UTC)
X-FDA: 84987557004.12.E4DCBCC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 91B0E2000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g68p8jn2;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEPAEMG15c2gH/O6ihAUxmO/06ck6asqsv3XqqkfCYY=;
	b=FTy/6PfknwUj1tZ1ejoRGna5LiYeSTXEk6E5iQLUcyMUGWA4g7XpgY129nr3iO5AJk5R9K
	omeafE114Y78v93tDwmSQZbz3Hr8Q8eqcafX5tJgoUHL1Hjd69v079agUoHh8Iokatc2VE
	/nVxLlinQ2bklfeN4fxfn41+SornUeY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g68p8jn2;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037980;
	b=KRa7bsyB5bpwVKeDDf8F4TFNDXbuNvSU3syNpIKMx4u0V7AzXnuyJr7Z7CP+OCaoncc1KS
	VN0Hg9kP+Dypp0PtDATRmjWk2SGWqu57R5BwzdVAOVbKiKH1CuS/RnfPmVC8WOWrivdWHF
	aWNp6yDZxgWI63f4Vn8tIClB+LZ5H5U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79F011BB2;
	Tue, 14 Jul 2026 07:06:15 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FE263F7B4;
	Tue, 14 Jul 2026 07:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037979; bh=NDusZRNCWoEozZsjG5aWosyCUDI8Y1KKdd/tV+nqCY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g68p8jn2r/BRs15OVDSJM5PC0vX+xZEjL9qs6O4bNrlLAmFr23nxaTMwPJrtgFVSe
	 PO42BSv3F1n/0/KY29fSo68pViH3svUbemsg+2g8ZALHR7Gb34DvnaAe4yB7K0yUyn
	 X1Qg4PRgk23qfvxdXOP4RJxy06FeoAcjmt/U8Rmo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:58 +0100
Subject: [PATCH 09/22] s390: mm: use mm_is_kernel() for kernel mm checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-9-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2701;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=NDusZRNCWoEozZsjG5aWosyCUDI8Y1KKdd/tV+nqCY0=;
 b=EN7VJwlPWQ2mLOV0RQXIAGmFgLbZqozbS12jiAz8t5flCb4LBC8CQLf9qAbAsIdiWxuJ/h34z
 +bgdLqbZMrPAgQeOceVSuzYyrvq4LTVvYRTcF4wG9fcsRmwk6IO2SXA
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: d87fi149yz1s8y6gayjnmgwbnxx8ztkx
X-Rspamd-Queue-Id: 91B0E2000E
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784037980-664332
X-HE-Meta: U2FsdGVkX18w/yxXqmZpoMZjrsZKscx/x4/izayrpBTwgTSIuvlWz8EC02OpdYYyfhbw8S3pGfUAH6/qxYx1ZeTbmxiGbaJGTBn6Gj9MExFMPFKtyD75MwCdyjML+wxRoq15sBr24KwxLYTArjtsrwy6Emgn4px8y/+Yq0PBPAHLHRJdebRIhQTuaxty6FhZG4/EvBj2mvTTRJ6ZYJyB8/M1lZ6281HVIDgE5Lb1fQmpsfv5jBCuAKE0txhLSP59NLdJWQLWqdOXdjHhXyx+52XquESb/+khoQSjdhRbHHcS15iwvP/LOoSKdZEOwkHgVlYcOpoVosCPpZ6DQ/CYEDMbFmsQcHjvS4JhZgxkkXhot3CJRzUHhGiH4I7Y6GsCVW2fXycfcgn1YBORXJ2qZtcr8in8NOoH/2BsMPcMQRNw5+dEL9QFVoyliSldJb5Sg1t7Bqm9gOvNQ9I1Q84kcP+r/LpEg7mtmL0nT7zIbQXBdQVC7I0MDiofhJDsrmhRpTBGBGqs8YvldxCQgX9T5wzMimXKqJEsmzceL/lUrkUiKFdMKIsIzjUyze/HkC9xM99wM9f+vg7aQC03MUHC7cfNGhzhEWk2YqUmGnXyg0QLZeZmAmO2kdzJyr4ubNHk0/1OYGh4+wFunVT4vWh5LDMRxXHSaWRNgHSj5WcrvJ1EllmbTsDtjfbXpaJzyF5WHwv+w5EliK4sOeVdTmddcKCChZWx+y+K+kDX1DMFIRykrqYq+BhYY7wMv2ReoC3bZW6sQIqhqXglT0ZsxlmM4mCjtG7hDSHsjqw8OArQPq/XeK3XKdtm0LsZG+k93vhIdbFbWnvUzDW6dAUYU8uvGrhiXVp8WLtg7se4UqTHV1vynocdy8zg40EVJJ9KwsMq7fLEhUvE3+H/0+zCNGB4hjReZEu/vK1W35pS0ptZSVDT8nXd7EEs6YVsMe2iC9qCIc0f5fGn5SbBAFSKtcI
 Z/M+6PCD
 4arvaCEsX/N2z1Fc3IAAwDDKLqtMbrEJD/NcZ+TA+wOoJry6mRTx9TDQcrvoxAi5U8sidY+XK551tviNiPbj8edqsQDAcrat5VBE8DsFP/4n3JZtLE+lSdK6UBGxVTDBzaljuzCsVBjzLr/KWrTrsCzD3LQ7rl8cTjE69N0yaCm6jGxuVeFi+SAInSC41N6cyFt04Ve7tF0sUhlDiD7X0I18VdrhBp+8wGwo/UP5iXZr692uLwsnz2zE25SF1acwqd6OeIiunBuwCILMLt2jjwC+VYQ4mhPtePs48rdRecFOmYxzr54jrxdmoj/kmEdtmk+MsIUL2T5KNkOYGHJEaVdcsmwINuuZxGVchrPzo/gvf1eTIFK+bvziuUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/s390/include/asm/mmu_context.h | 2 +-
 arch/s390/include/asm/pgtable.h     | 6 +++---
 arch/s390/mm/pgalloc.c              | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index bd1ef5e2d2eb..675f270d0b70 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -69,7 +69,7 @@ static inline void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *
 {
 	int cpu = smp_processor_id();
 
-	if (next == &init_mm)
+	if (mm_is_kernel(next))
 		get_lowcore()->user_asce = s390_invalid_asce;
 	else
 		get_lowcore()->user_asce.val = next->context.asce;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e882663a58e7..f7741e6b417e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1836,21 +1836,21 @@ static inline int has_transparent_hugepage(void)
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pte_present(pte);
 }
 
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
 
 static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long addr, pud_t pud)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pud_leaf(pud);
 }
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 7ac44543e051..d0456b7e73d4 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -20,7 +20,7 @@ unsigned long *crst_table_alloc_noprof(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp &= ~__GFP_ACCOUNT;
 	ptdesc = pagetable_alloc_noprof(gfp, CRST_ALLOC_ORDER);
 	if (!ptdesc)
@@ -120,7 +120,7 @@ unsigned long *page_table_alloc_noprof(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp &= ~__GFP_ACCOUNT;
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)

-- 
2.51.2


