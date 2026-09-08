Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC327C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C286B009F; Tue,  8 Sep 2026 08:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053DC6B00A0; Tue,  8 Sep 2026 08:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB826B00A1; Tue,  8 Sep 2026 08:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6E666B009F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:35:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6F38A48FB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:35:17 +0000 (UTC)
X-FDA: 85190540274.23.68714E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 084EA1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:35:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6LbB6ot;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aimUPxzYaTPXtJhtWkzW57/+8qeslpkAUz+f7GK8/Y=;
	b=w2DFkE2bP5L954Ns8rY1YqNlC3tEjOE+g0qqUyT1hH7k7qoP5zSWb90MA+AdYUScQpc3om
	AlDg68a+K7Ua2e3xvUZADLm1TpiR/fJzyZSx8M9tkD2tI9o8bC3Kpr2UBF9HWGfhkhFNEA
	PDBJYaFZCsN8gYfnwVo3HiNSYloD8qQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6LbB6ot;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870916;
	b=aJnlwpur7cOK56RfjSrDQ/SwqliCderMYH3Us1vvT4LdtePNc4V8GmCc0uoMWiwgzbBgK/
	F47IVnQe0Ttgyem94NOGt69AQXUA7fM0wi4PuEds4hpJSPxp59bZ47QJXYaTwvfnDQiTor
	jLVDXrsEvAA4Fyr7ycpem+kzUCS6N+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AB4D40530;
	Tue,  8 Sep 2026 12:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DD41F00A3D;
	Tue,  8 Sep 2026 12:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870914;
	bh=1aimUPxzYaTPXtJhtWkzW57/+8qeslpkAUz+f7GK8/Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I6LbB6otD80LMW/HuVyeFai8n3gqluSGM6nehyfWmXCOaKM9S/MshufQ7eogXVBve
	 jGJhJdROa12fEWl0nF797Az+hVJ4YH6cTsUg1NqCrRniOD2zT6Ij1hHwWMOgtfeyeS
	 +1W3fz2fQD7BodqOWfWqwSpNec0V4XaWpim5gsQCBR23UO0AfreXTja+JU/4rFktQT
	 rtP6P0A0mP2BFZogycCU1HTs+GpT5ypip7Xj4IgOJoM246zg/9rjh+Rwu8OlphRNKb
	 TXMHEQVxVqIjyqFrQPpF26lC+DykmXyZyhPwoXvyrFgCladk3EHATh4//upXLUuRne
	 6k8NGlX8J90Ug==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:16 +0100
Subject: [PATCH v2 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-7-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1842; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qTT+GrBJ7CN/0g7aihQa6c1ZdVlLMdQ0LNJ7aV+6CtQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMMR0eopeWPrQIGCh5x2PfWdLGLf/Y9jrMj2M6e9WQ
 ekZxp09HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIM2mGvzJJmxgnr7RJni1y
 2q9h1nNWtUfLc6ZWqM98vfvLDoarJg2MDNOljx+5rHTgyQ7Vu3bX6/hLLKNyMqbr2nwI4TF/HdY
 UwwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 5mnex8m3zxudmec58hwmrzdc1tzw51mu
X-Rspamd-Queue-Id: 084EA1C0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1788870915-165639
X-HE-Meta: U2FsdGVkX18FsgtyXpyO4B1KXn6EsygDPb6AsA8qkxqFYBBRSrTWDkYZNpsAswk5vOOURNn8zh67q4lLmt68vnpGqN7zBDK+ttvLaIkjwGFfsdc1yzwNCBsov2JUfILnqaHHn44lnguBUP5GU9QTzJsLVYcxQq9A3EZ5RKOw1gKuXwii1ZyQiRitgqbN7fjg3MZpQtPb9OKhiUj9G5tUCma5uzCnS7WLEqvkSuF4FDaR5QxMrIF5ROwCkoeDUBnwPVaenT9552WRp5nvBaliMuglRF2YuKFmPBK5r/PPAar1r5wECw/jp/I6s3LPJOGTnjvNzc8opk5yqcqmBFmObVNv2mWhqlKNvb3Jw9+QWs0XI9JSsiaEUOqmto/jitHMPqCSR/af0bBmp4t3TStbUhRyx9lC6QWe36sxcjlztYa6j3JGSiXi21y8ketPHMLdFRMbMnJj3i+kwoL2+CMZJastYwyr8qRl/vGCFlbiwiVO8guxET31AhDACfmA0g5TLy44SjraRb/NMIYAVNVOeGo3hTNxsgxg2kqJQqNzSDRhovKucoUCq7tZ9rT8cB227iACIAUtRryMzh9tY8kEFPZk0jNXuykGRu5L/Gb87LZf8OOaJ4k3SRslZ6/g6pIEdVuboAodDomVSjmFYVJFv6HJDapb/QZX08tqWKJPrt6hNumIlck9jTYNPz4HLiu0qRqWHbQLRRAeSb9ZOR25iwRxkf3uCbbHm0Iv9rqMTCFHCIyO09iFa4CMAJ3DzmK975+zCgG1+cnULzdOR9mZqy8czY++N7z4JPWrq4rKnp9GzqgvwFguf+2lm+zGyuDvsPlJvDhAQ7i8tFBwnHDbELMF+OAJMKBBKDdEtycW4a3bmVEApnfJSvCqdcPPvRwnXrRUBRW7cbw068qUwT9xZuKqAGoRzgdjFj3ekT+teh9uX6DXuauk6ExH+DGGFCpHvPf1by+07QZLc0PpliL
 lcvSeath
 Ri21gzh+TXlqENT3MSm54O19FgFAJtG2R7Kh5DQgE3VlmnqwbkiWRAjtEUArWxQk/hVQk/LnhFwdD2BhhSKrtE9FT+pa2c3rsxcky2tc+EjdbjMojniYYPyFFwvzDL9XqqPkG8Ln041h6/B9YCYhdsoej7Vrwf457UEMeXdpQ1UzBYrcpbUBL+e6vFQgePtEdmen7f7brpXwD4D0t8NngusXpQyn76Ykj6dTD2zbZqqWBnFTtOyAP+GhIyxuJ31ji/ol0YbjliUNDRlOkyi6HaOg7oNLUjrK1Ba7THmPaLuQRbm2RY+RHbVLL1PpojTK96TypgRX4dbEEIdXqbJlG2g8KyxskYJvW3jxfULymqpIgZT96THrUwWoonoK4n9P9L+dz5gn/UXkiUPPQ3+41bY5pn9SDZsdylS59lLLxCAIzBXTSsLKZivju9nooeVMGv4oqhXUcy20lqjdQz5F3MCfStFlnBS0tE9xb6CaiGb5xhUg=
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


