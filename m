Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B952CC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8B56B009D; Fri, 11 Sep 2026 15:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0B16B009E; Fri, 11 Sep 2026 15:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6966B009F; Fri, 11 Sep 2026 15:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 949E36B009D
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:40:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52112160259
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:59 +0000 (UTC)
X-FDA: 85202496918.24.B4B1745
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 95784100002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yn2ETe/0";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88XZdMnGcr4EoxTKx6ho5XutcNaS7FDI1j17HitUiT4=;
	b=YZWgFEdm/QLeyrzb0g3tv9159ds1orcuH+kXouqwA2a/WTmlczTLvzaA82YcCykpFu14kN
	sVZUqJqeoClVN3OZR2xc+TXV8x5rzO4i3mZ04y6T/64jHhWP6PCQIKO77ILO3bYcdxXZoQ
	ROaLjeJzsQCv0Xd0QddTPkSevuA7SCg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yn2ETe/0";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155597;
	b=sZ1lMyyUCVDR0oPlmz0S9PKcSfKHjjdMbb58+gLdkFzvwcxEPYQPHvjdcuY6E7vE5md8d1
	zwrmgFD8BUz7c+4CzjhXj72p3A2X2UWi8dE/X1fNOoU7mUod6GROr1Wte43rjdJYttmNYM
	tAeRucm0O1n7dqUEQdfGr1dbp85Dznk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3323E600AA;
	Fri, 11 Sep 2026 19:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D143A1F00893;
	Fri, 11 Sep 2026 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155596;
	bh=88XZdMnGcr4EoxTKx6ho5XutcNaS7FDI1j17HitUiT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yn2ETe/0Rmfe/5ApbJQMqqjX3uO3+H0FqeNi93eab3JdBxIYuPDwKy+G9xVqQRi6f
	 KBSVXFRCLCn1pa1PRGVPW8sXBroHwnhJoYwY8/f0gOejCaoJ/IUPWxtk5iXn0sgONM
	 nzDhis3JJxu7U+TPS6MgupIQCix1BaqXc/5Og2tAXL7q4JZfQKqaA+D860siWWC7qR
	 +BSxccBUrFk4dHbxikHM5tHP/pvlSL8q5t1K7ie/1k6s7H29UoLoLTXQi5ikgwjcuS
	 YqolkO2BAKD2nxSxqUY5vGq9HaDdE/0R0XTXTAhXi1eVzEsQSCBtHFBG3ggPIkfSlh
	 tqQLTiOWOiasQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:53 +0100
Subject: [PATCH v3 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-6-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2472; i=ljs@kernel.org;
 h=from:subject:message-id; bh=56BKeeSS+gh75h2n7cGmrCDtrwD4bozOQj93IG348BU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDQJ3bg8/2dR5YHsoJ3cj7/sLv6T3+TjUC/z54GMu
 9eUWVOVO0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRF2sY/pfNbBNl9t0pdGll
 deLS6b9edlocNlp52ydS3y+odKGjzmlGhp//syykv6WlaKVtNYuYv9PHchX/+tvqZl8eXnT5yvi
 gkQ0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95784100002
X-Stat-Signature: 7kq5xdw4uydri3cwstaz731wjdt9ppc9
X-Rspam-User: 
X-HE-Tag: 1789155597-543902
X-HE-Meta: U2FsdGVkX193hdnTLLCI8vbKZP0Xc7zYwg69+ATnbKid7BfOHPYHVzQLhgr9X+/SQYHDmKpIHweaUiPFFw50Z7g2dWca9GKDSC1TmPwbqKLuIRsw6UTlfOjvn0wOcivcD4bLX9EOBAvdXtFnwtewVGbf3qqUgyxSAhnEjA3OHhcAbOlkh6Sx4aKcQEpyUNbGGm3J+FzsbBwB6/y+RdluLLfa0gsJqNTDws8fl/6MBGbyW1kO7EdtZqTFmy1NYcaWX0oLGhJLu3KjFKgbCZuJQle3IiJzkezqqiQr6Z7w/4pbAgondTN4w5PF8ux+bwDNs0XmdM7Ut0RfJfNSBd56/9AKF9WIwRx/SHozF7gYX9fdik4oiwryDJbXgYfL8sD3Sxh4Fe6Z4d8NtGxbtvI03IbNsPhl004+OcjkwOLYVo2P0vLAqeIdt4VJHKLuI29ha/quY7Ema6v0Y4NpOgZhtVhVGBNNsoJ+GZ4qNuSNrblRheagowOXzWP6VYAvxsq2Kc4OQCwuo5hopwmQBM6qyRCRZ5vb/85Z03H/5ljwLSfqZLkZ95AS0hk7fRS+TOtf70Ozw2P0BQZtTxrav/82kJWZ2L1WYzfHivy2yHYWpog6I1VYwlEfXXr8Glt9qDYLH/D58s5foOtY6GGzx/Cm3jClJa/SR4AO9easik0Uj66a8uru+0saflE4bjIZ0kB9K3nl5O6V1eMZWSY184E3gxvl9g8VsHSLdsMSIZROHf9cdY3mSPGMx9nE/o/bPLWge0VIwmzAmrOtRPsw0/YJIGmwD3X28ivYQOUprrz8wbC7SfYhJF/UJfKi5DjpE4vL9fgrCJENBDxR68X6sARGaL1sFqMFrCKdzPkhPycIr7EYuxnpJKbD9jcxegpZGYdgBU97mA2PO48NHhzuYT6dxwpp+UaE0D7ivStAkJX7GTtmAQ4oqmK4uHekNBawxs2efHPn+7D1926Ejzaufec
 5wjajO5D
 aVqJfAO6RLYxx+0UDn37TmV2W6MFYzae8lO1pzrfk/ER0pKgMYh+KxAiVX52t3B0d5EWJ4kCRzYnaMH4XGJevlOOUrP/67QiBEA5bbKbN/5/9rjbEwj6XnWnwdhx+kxRszNLVjkkwo+Fk6OhHJh/xj0FsGJa4zeynct3aQG3DVm7/exwJrPKLU5vwsnCdO4AQ+wrU029JVaJBAWS7m7pJGTZ/XNH2jGHeSH32I2tRdLckhxo9Yi3bT+nW+wHfDA1pGCog5B0NAoe1MeJ2V+wpPPRTe2U3OIUHeRSJ7WpPyVheGCK4r/gFLcAwiUNJBNN4GzEYMQlesSMOIwBSxYZNwo3GSp978aykWQOlIDEoO5nUv1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4a0100f7546f ("sparc64: use RCU page table freeing") enabled
CONFIG_MMU_GATHER_RCU_TABLE_FREE for SMP sparc64 architectures, expressly
for GUP-fast page table walkers.

Naturally, UP systems do not have to worry about concurrent GUP fast
operations.

However, CONFIG_PREEMPT_RCU is also available even on a UP system, so a
future pure-RCU page table walker requires MMU_GATHER_RCU_TABLE_FREE to be
enabled on UP, even if concurrent GUP fast is not possible there.

To enable future pure-RCU page table walkers, enable
MMU_GATHER_RCU_TABLE_FREE unconditionally.

With this change, it is no longer necessary to have !CONFIG_SMP
pgtable_free_tlb(), so also remove this now dead code.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sparc/Kconfig                  | 4 ++--
 arch/sparc/include/asm/pgalloc_64.h | 8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index ab77d3f2536e..8d42ebc6d302 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -75,8 +75,8 @@ config SPARC64
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select MMU_GATHER_RCU_TABLE_FREE if SMP
-	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
+	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_FLUSH_CACHE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index caa7632be4c2..b5055d259b74 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -74,8 +74,6 @@ void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
 
 void pgtable_free(void *table, bool is_page);
 
-#ifdef CONFIG_SMP
-
 struct mmu_gather;
 void tlb_remove_table(struct mmu_gather *, void *);
 
@@ -96,12 +94,6 @@ static inline void __tlb_remove_table(void *_table)
 		is_page = true;
 	pgtable_free(table, is_page);
 }
-#else /* CONFIG_SMP */
-static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
-{
-	pgtable_free(table, is_page);
-}
-#endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pte_t *pte,
 				  unsigned long address)

-- 
2.55.0


