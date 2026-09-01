Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2DA3C624D2
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:07:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9566B013B; Tue,  1 Sep 2026 07:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1FC6B013C; Tue,  1 Sep 2026 07:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E79C6B013D; Tue,  1 Sep 2026 07:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4EDF6B013B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:07:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7108CC03B8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:04 +0000 (UTC)
X-FDA: 85164916368.03.AA72465
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9CFBE1C0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:07:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XD3oyzIY;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aimUPxzYaTPXtJhtWkzW57/+8qeslpkAUz+f7GK8/Y=;
	b=K81XATnszNJbAuCfkrMlejpM+WGSONyYlt+3UofCycViG2ahMIKdseuy/HSaafhhL47ER3
	YxFNe4pLsUroZ4x0VBBTy4k2Dpu1dcfC0Lt6xWc6mVYnp2LtxdyEpBV3Aty1tyBIdqaKkd
	i2GFvNEk31OSlgoNUNjfCl5HHvZE5/U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260822;
	b=ZDoNobPs6VxV9xsGuZ5tyC+etv1s2anyp2h39a+TuaFiI3BPnuqJxSWnNYngjgQW+1nSC8
	v2RwTEDq4j4PQffWvuFPpAsa2MHVtRZdoyqiVmMMNIdwifbv5crVwNloC5G5uJpBv/9dQf
	+OA0EE4VgXbO9RsejNM3PjdFAJVfWI4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XD3oyzIY;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E781403FE;
	Tue,  1 Sep 2026 11:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FFE1F000E9;
	Tue,  1 Sep 2026 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260819;
	bh=1aimUPxzYaTPXtJhtWkzW57/+8qeslpkAUz+f7GK8/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XD3oyzIY4msLPQ772JhwLo0AmvI8pJiExLU3e3acDjohAHfqAlS9rlSLlt64WVSfM
	 r3kRTCUYRFXtwdrLXLd4zIwibTfWMnW/NDIIYUE6lAId+LAAlnedVWBr2YfRCEVFnh
	 NaU4l0p6UGv9r8gy6ABLmcwKqZFw1aYx2Pz8fy8/zPMOSd7woDX9/45BsOq29uxCFH
	 t67glyPsR7yypFVn1RgslLR+rEAEHQj1J/iNjz4RcFE6+mZcsM+M0zD52vr+Us6TCk
	 T4FBgX6sN7RoaCrUvJ6hGpa6JR9artGVasWEmFWwFE4AH8UoYRgRo/FGT9ifPsbukd
	 aB6GG57pdUC3g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:27 +0100
Subject: [PATCH 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-7-5456a81c8212@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1842; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qTT+GrBJ7CN/0g7aihQa6c1ZdVlLMdQ0LNJ7aV+6CtQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbfQIULyUGXJvk7x6z/RM7Xe7feOXy31ul/W6IvyVo
 XSrazZ/RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbSGsnw33vZ/N1+HBlPyg4d
 Z9inYfllvWvq5p/7s6qbX3+3iw4rCWRkmG8v0yi5/9js5G+fUmMi34cp/96XPWefUlWg8e7Pkmm
 cjAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9CFBE1C0006
X-Stat-Signature: hz5pdcxmdmyhg3f4yqay171aa3wuqmmu
X-HE-Tag: 1788260822-495407
X-HE-Meta: U2FsdGVkX1/nzcNPQc2bknPAZp4DbiqqfearF9h2sfHQAZrBeS4BQ7NUSMaGbo78/QBNlVY7zrgQfAEljvUYPsRXphoW0kLZpjui7ipAVeW61k0Qs4/JS0DyOooJ93cr22Kc6cK0O2b6ifatfIcGyrzhB2WB7FFYcCLQl8INirwCh+ZE+4v5Cn5ncCy/VaCcTZCLYDL9TZBlm7H5tDE6cxzgl+qRe+o/nx8uiiAFGo33lQg/ryE1D6sfgyyGINRbMXjeSqDwt2EW0XesCvbKKZEdxoOFObgr88c/aNIIlC3fCxgwYPClfSLS3TGPiFAdBlSP5zn3jHdLLHDnxtGJj51E8YrzL98Ps6tCGcpdBXwtMJWdm9tEi8MFNFqetgBfh5HdCMdYLvDFPMi5p+lk7fGrrG7YW2TW03N7hAk0SlDTf+4yIsWLrjGKPyTi+qaHlTJHqEtPQWSgxpLXba1v+AU476X+JlNk0e7KcucSmMc/t+Ae/aJJ/oWIUa27ShuC5qSXCK44jV2M2L1zG6QwqW1lGqBS+JtbAeY4+n5wsS+PPkJGKO1wQ+Eo/KnGcHM5QJEXIDW2lA94cDKZpWRh2On3nafGgk6HvGdqjew0zBT/fuFx/y2kb0JLzhudyoDxEGh4klTbjgnQsCEdFAhG9G4LMXBzoIqjDuNSeub5MKwF6xdHzVEeGSsedsk1coRx/l8tyUBs4/t5geH3I+9MQ6M4uT7k56WyYkWAloCTc/4bJDNCztQ2p5sVx5WZPqBImoQzBNklH74jLVyWJL8Gdkn/76Mjw2/7cGXg+nm0n5f92mYe+rsIbNRraNi7PIILKJYaNbVdmIayz0k0cKZdSTuL/gtqCNOQHkekwg9ETTS5hXLV9PNBcelSqHb8MrELMJtjkCDIev2qO1fOgehGA+sagJO9SKhaxBnPI4i/fCugu2GUZBXKRoX0d4yJY/yE6ux3iOZbFWVoDNMk+9Q
 EIVLwaUl
 Kii9l4FrpvfXKd7Qe4VA9YBal3zBUkTZi+swqxVlyFcXkYIEANlx4eCiMv6223svFidrzaxAR/tNjSUhp3957KBD8KlG+5nhoM8HwSo6xnL0CJlzLYM+ZM6AVaYc8/GGozF39bn+5LPlGg9VCix5ESleRkptXeCs6N9McPLduNitTlONdy4igsVYNSUd0Nnz+I2JG2k4ilD0Px2+aXdlttan02IYYcTeeroC5y6YPIfPY/Ni27Vs8iKjuKPaJ0dGqi/C+N0soHhhBzhqX6afwQErTKzE9KP3Vv/2V8hiUb2LF9bhsSnjka5sN+oKmAsmwBdVPIhNCLmgNf9bHHX+dOheFrUEJ/bWEh5xNDhkaoT7MUrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to sun3, the coldfire variant of m68k uses 2-level page tables.

Update its __pte_free_tlb() function to use tlb_remove_ptdesc() in order
that, with CONFIG_MMU_GATHER_RCU_TABLE_FREE, page tables are freed under
RCU.

The page tables occupy a page each and have no odd semantics, so this
change suffices to allow enabling of CONFIG_MMU_GATHER_RCU_TABLE_FREE for
m68k-coldfire, so do so.

This forms part of an overall effort to switch every architecture to this
mode.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/m68k/Kconfig                   | 2 +-
 arch/m68k/include/asm/mcf_pgalloc.h | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index e29610fd1240..6b8ec67c86fd 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -36,7 +36,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && SUN3
+	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
index fc5454d37da3..b53ff0950db2 100644
--- a/arch/m68k/include/asm/mcf_pgalloc.h
+++ b/arch/m68k/include/asm/mcf_pgalloc.h
@@ -39,10 +39,7 @@ extern inline pmd_t *pmd_alloc_kernel(pgd_t *pgd, unsigned long address)
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pgtable));
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)

-- 
2.55.0


