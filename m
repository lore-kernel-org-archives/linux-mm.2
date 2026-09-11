Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A63C88E5A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7626B009F; Fri, 11 Sep 2026 15:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A584B6B00A0; Fri, 11 Sep 2026 15:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948766B00A1; Fri, 11 Sep 2026 15:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F30F6B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:40:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08875A4540
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:40:19 +0000 (UTC)
X-FDA: 85202497758.19.28EEFC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49F3C40003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:40:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4xxBZld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAMKCdWX5FPiRKf/xR0S9vZ7DBMPzl1KsARK3tocs/E=;
	b=rdTF2f/hgp2eWRoUHPlwXnsz7VZL/rTf5hSm7ZSXV/orOfsd2PFHJ4pYal7YZiwHuRZeq5
	1leZNKR4tItRD+vLGklYDhJbEJM3IgpdqByuIrC2UXA9BfcDSw/9OhcLc5/wEjIIe5kFZx
	wRTe04/cfzvVnq4AoRdclAGzj5TgfLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155617;
	b=hfJ5hEa5NW+D8EP7DjWRTirDp4m+jRx0sZJEizVUIOVQwm22Q/uytV3YB31x5N4G/RcrCI
	PhTIbdtvrJYmzCCanQR/Ersh3hyzvozlJoyd/4Cy1Zt6mX2AjOnBlOLc5pHMrYegNAKnCV
	NPTNDe2/6MbN+cWSiFKENBCkPC0qAzo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4xxBZld;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C586860202;
	Fri, 11 Sep 2026 19:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0C81F00898;
	Fri, 11 Sep 2026 19:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155616;
	bh=AAMKCdWX5FPiRKf/xR0S9vZ7DBMPzl1KsARK3tocs/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O4xxBZld+SvGvVkkf4deWTVMWnxPzOcP6ImLdjTW/FNyMpK99+HqRj4exMFfqErD7
	 GBRImxnWOGwwKKa7jnafs+uetJavVL727WPmWlok+PyeBUYuQsH350TZu9cOozKPhz
	 0fgAiXlvemQJAGFqxJuFvb6PHuGieiIcQgdi6a+7vZAYqYZARajTh9z+HonDuvoEA6
	 gOxI/Jdg6ogMLeHs6frXn2Zsn7O3hCdbXng48u2CsukweoU3zU2bhNZorm/sF+B9yl
	 SJGgQvQF37B0ZKcfEOAEaJwqBL7pzLtZOF3cFyNwIBX9u7OytDhbXDpyVPhbvhQlj0
	 gA6I25G2i50xw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:54 +0100
Subject: [PATCH v3 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-7-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1893; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BvcyYBL/6DvMpTsf26rSU6vpsqM4Qkuzt9TqOJJPzlE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDTd8wriL3x1aNpEyx0ME5fM3n9qpUyPloV78fsWh
 nKv+1MWd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiF1wZ/llyx18xeN515vYH
 Db9LJ+2XVIe+Srxx5FyAr2gi44KwexMYGe4Ub/G5vn/6mosL7eU2KydPEZJkd7mSGXU/cPP2t9s
 tDzIDAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49F3C40003
X-Stat-Signature: g3877kxwhqzqost3y9mq7ajq3oyiniox
X-HE-Tag: 1789155617-693181
X-HE-Meta: U2FsdGVkX18yvB1Fr9C2tShR/k37nScMUiBc+PbZVlqVs0+RyLg4+K+ihNISM9xuZxUUr6u9XYo/JlNaDznqbfbgO37xyGOt0CWRvTf8WrkwABdr5+2kp1SYcwOG+V3Pr+mTtn2vabUL7Y/1kTBXJ35qc0maCvQAD3A63digzyY3PXdHUsb5nR+EgQvizU4luRJrqtbgikcAi12TAMDz3qYAA+iM7qrdG0cmzqY7RnArh1WWJn0hvHS8QkWzbqhLrmGy2eOnOwGDgHjTceW4yMz2FMIQZxlFqrkC5B3Skfok7i++cN6UjRiIloyCIdIIMjnAVHjqw/e2+piQXfWRdMRt1Q+6Aa0lEbN09+TWmFJQret/sXMJXSNkUVf8/z3N0/aHUNMLmFPDpoSi4ikbvIfFc/ZAczIgQsbGezof5UHMwlP2lzJQdUwmwt60/NVD17tbzqhTPuI6Zxwoiy/fSnwmHg+zHbBaOM+9dOUDs5esSccdwGi/ZZVosuEuiw1+D0jjS0xODFXQVE4FHLuV2oFujSXPNloGPoIkcdpx8RJODXvKslXNajkS4pFZTvmfcyf7F5xhwXjJET37i8ZxY7E6i2YuldzVHiGfIJ4b2yPvMBYmef4PzAzQQZ7jy4CrqF1BPQGfwuHqjbCy1qaMcELB/m8a1mZJiXRD9aN2ZoVWHTJixvyn4WQ/4QSdUdL3mRHOVvtIiyb/dp3EBf9gYenjjzGQwnagZKDrzlms017ip9HFnE3PpUpanZFIedeKLZzl5YnO0WKodKpcSvhPT7N9JoNpWbyzru0d+r3MIrvgMJtNEg8MLQT1DYVM6+8u/xL3yjpspYxHilog05hS7pVtAZMDUQvYc+wdXGhUeGEaPiZgtEuH6qYDqyMPZj+9pdYW4HwKxeBP3SqNOo2BiA+BsvUfWdJIuYXAVf2frFyyeYLUQOhGwY/KRcrszWklZRkmPLuaVByNFAZgxu+
 qEO56SEx
 NFce0p3xjRI/QwkH6kj12JGc+gmqi2Wy7hIOSX20RnFTVbzUIy+5aaWx0EJlE3EhU7ytR82QWMZY/9tuO34qRgTn5+NNY5YExsD6p/wqUzyc+0iXyGX85hvMLR2WDlvaSoCnZb4bjOMRNUhdXagfJ2HSDvekAnSiG9WFWgpuf7c7JEGRAWAwIbgTVTvFCrJUs/aKlWToRhHrwtwRB+uCsXAzSsEteVoDqjkfNCl7mk2aM6jJsAEh0t4zeCqQdu71gQNKv0Iztn1/V3SXeHwQX1dTUjX6RjQ35bnTQqxNtpz7grQobzXMnA0di42Xr+TqslrAutrOZ8J4Qo/H89mHhHlBbgMDqUpFJz0hedqTh3yuU61g=
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

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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


