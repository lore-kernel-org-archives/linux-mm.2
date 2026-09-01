Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D05C624D1
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AC86B0138; Tue,  1 Sep 2026 07:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812536B013A; Tue,  1 Sep 2026 07:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729656B013B; Tue,  1 Sep 2026 07:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 538986B0138
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:06:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D715E120394
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:06:47 +0000 (UTC)
X-FDA: 85164915654.25.8672BEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9691380003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:06:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwoKGGKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2RQcemfGMYTiDH29zfMnTtdgj0bHtOblVlsFhLPlSxk=;
	b=Zp68EvCdKcrW+sfBis1ZpdFGJWasJ+AB8ebSPn000XWbbvD94nUyJVoKHbobvDDrIH6MIx
	QRbTmmxu+91zK9S5EDkneJdilhqZbQgwenXozyh6s5eeeTA9kWH+H6nQmVfPzXySau7jZA
	KawD7LX3WJSSNTF7T3bWOPtJyMDNKdI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwoKGGKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260806;
	b=GPsBPWPhHZv1DJqcPTq2gVXM/vs/l80UJuCQPEZinpXf01dfx3q+GdW+xqzWH8W3YHLfbH
	03V7sQuWXzU+wYm0HljLyziuQLy5L8+DA0ttiDbuTdLJLJ4cP3fEtMQaGOOcmwlPHGczr7
	Y3uDCc6g2fp8tWIdC2THLj7VfMNjyzo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 207B1407D1;
	Tue,  1 Sep 2026 11:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00931F00A3E;
	Tue,  1 Sep 2026 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260803;
	bh=2RQcemfGMYTiDH29zfMnTtdgj0bHtOblVlsFhLPlSxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NwoKGGKCOsRyUU+EwJ2no2OGs9bmyTM35H3K9gIGh3HV4K+WdFczJU/eOXXaqSq6H
	 k3HqUQSyYtmLNyQcKklEF3jOnimT477uPD5bPUrY3vzsO0q5rhBaHKvEzLmmOUoTeV
	 LS7qc1mFdDW4R+qFz8GqeMqUV2SRfwucYXHjjwfClPVzkfmWmA7H119MkFGrVSiy2M
	 2i+O/pQmB8Q7TQ4gyhr2LkP3WlwncZC4EvmV+llTIKpVYZ5j7ph1KajtR0mHJjWcp3
	 C3dGZ4dAndriF5N79xdeqD4sLGWw6jUMW2TMEdqkRBXSUrwPC8mBLnJDj1WCNUN1fk
	 Lsp1rzKfB8Lug==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:26 +0100
Subject: [PATCH 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-6-5456a81c8212@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+cl/mE+MMAULPxyBPFJXsNZLkn5nuULAZlZa1FGDhyY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbfRoWHu8+2WMGXd53Frn2Q/TfRbbcH08FO0d/tq/O
 1w/w3BqRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACYiZcjIcH3mqoOd6vvZeHat
 LZwryGV6VWy+UWngii1a17n6ItznP2H4Z1P/w3/OzVMba8P0LaVSbs6x8uGbP2Ph03esF2VqH2r
 JMQMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4b49eh9gjmyhp1xh89t9n4cc7umaf6oi
X-Rspamd-Queue-Id: 9691380003
X-HE-Tag: 1788260805-968903
X-HE-Meta: U2FsdGVkX1+Zb8P66jCxZI2eeXRe10+D3jFhpqWwY+rf1T6CwFV6X2eof9xhFMl1oHUztIlNwl1TQmScdAtIor49qEST5EtKOaixqJUBoU2qwn1XMarJcfLWjcdRMTWdmlejuSfKu5LN9l2WzQ/w/ydXXeouR/qz10vq8jT+CM2qrHco3xwhBY3DrCadVoom4CPyHzsVNYFUMrUlssUhT6nu6c1qrEOojL1sECnAYgySlH93HN6B5esKtFQ/8NrFZBvNkBTeCxekgxVulYY7FPPITrvyRfTakTKwfmwQWOtkJ6Vr0/zS1jDN7UR0OvTF8lyD8VmKxGL2ci5mhLV2ylpfX8IFMhBtIgQgij/TcHKRIC1P+n9iX/gLTMgYUkZBZVyuKiy8vSEfy2lHqzZs6jWAJvV/Bwc3zz+pNvHN9wLiQvY6Q+8klaWJoccW/FLtSxqBXMxxo+jNjlp8qEBNN/IPVR1H5eHpI3J4Ip2UycwQTi0pUBoCRDiRfBStZ6mJivqoFlI9DZDHrhTm0cjPMDXB4CzMNUDHNL5Z33UN1j3jwBjCnov1ue+YroOa+SXNLm/x6A1IcF2Hf/9olz8xRlGjRV7kD0JZpJBlGsOr18wnCGyuyKT9EYdph2kIDGauBQBWGcAs1AYF61aj07Mb3MD5W+kE+oR3j0CtL+KARyqTaLCq8mQCdvh8/tp2CMIlmNzML7sdeR3/XfATIJJ/PX80VzmIU/bc50rFCSZVp3aVSngAUn/Epmws/690fEiAYWrXh6kWEpe81DP7CyM9Y6TS9VEEyK8QKa/w01eurT09xgDE1ZiEagDDU6XPtCAfYA1Fea1qrGSxsL/gxpjOfUTr5FnGzxyefUrC2saRuVG0TBvJeghS/dbEFTS+EdBUYDJpu0y9dKIfurGL1R6gQuS+AzTedaD+DvudM56XGS690Oc2VUaYo+cnGv02YZgVkP/6vY8gsUrTmJd8WUP
 8xwaTuGJ
 JmwC6LXV9Twcg8UpjltheseIrzF3wqBrImKqwDr3ytegPrldjy2K7jJH3un0iwLYrgLPc4RoMXxi9RlMRiy1M8Ty2q0dydmtwaGcpciqryi71DExEQcL3O7D3OZ9KQrB1j28UyYB8LmD4UV8MXD5jp5RAwYz5iInuczbYUU2qae5sXqwrhB0h3rfjyGnNBPl9dgGb/r8KJWxXmouRxRBIZre+Ke4IwyZpOfAtZOW5AVcGu3N+pRJPYTT/Plm2yAYFvXiQ1GnTT5M08K6L34Ro/EmzBcKTRje4PjY/IRc6pjCx+x6w9mD6vGLZyjDu6yR7VWOazDbLZOLxMz/ms13J0kZ4LtzbOEsladiKdC57rG9nqTw=
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


