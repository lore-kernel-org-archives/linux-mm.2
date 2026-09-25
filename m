Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FD3C98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:12:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502EE6B009D; Fri, 25 Sep 2026 16:12:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA016B009E; Fri, 25 Sep 2026 16:12:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0E66B009F; Fri, 25 Sep 2026 16:12:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6DC6B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:12:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A458BA6E06
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:14 +0000 (UTC)
X-FDA: 85253381388.03.FA69AC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E6B72C000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gKh/gqLZ";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/RwvDc+Yn6qQyxIlipbe7ZS0nZ7PlvA6+VjYxgRBPE=;
	b=Rk8Sk1mKEv3Ud8mdeWRrtsnm5ZxtgVPIdUknzPNnJ/cVLVjNaZe4AQkJbbLmlnG2Atx6/Q
	e2FRdK1qC1mzCkNzWTy0RxSb57fUNaEQgaVX80d8PLEik8xsX3Pl52L70oxBnX0Hw/nOaN
	BjqTWx/Z/VCLtfEhCBDm6elvw5aSdM0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gKh/gqLZ";
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367132;
	b=g5Z2Eiwc+4LJLmMy92NC6FUzaIYZTDV2Dm/XQoR2vDDGdUfkv85p33TpfXn+YqLmPf21fY
	Pb1UnfWluuvpv2JTn21z4xB12FFwqklwfrvMK2LQiYLYAul/eV+fGEGOs6gClkFWHppqlE
	Lt3SpTJrYv38mY9x7T95uRYTTR1oL4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 775A960136;
	Fri, 25 Sep 2026 20:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DBF1F00893;
	Fri, 25 Sep 2026 20:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367132;
	bh=0/RwvDc+Yn6qQyxIlipbe7ZS0nZ7PlvA6+VjYxgRBPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gKh/gqLZ6tuLTMtMolwZ0R1z1pkLXe1CHwiE0D9GHHPFGtRxoVceWHxaxOOHwCjMU
	 SSgWnP6WPc7OgBWvdah+8+s+y77sVEVsh+CU9JRyYmPD6Pbx8Vf+acsnxrR7dTdMSC
	 jSKkFayThIUdZ+rkcCk++LpkI2mYEdliqnGUkvuUt9w+l/+KUwA/SoIM1lWVcJnj3T
	 bKBw27PYXRqzRB/NLanfe7hFILrPCnNNQIxaNY8U6Un/Y/FOBiDXf/4VTrKQndkLoZ
	 J7yLnY4Xal0/44DqVhGwq19g6cw9R6l1o/4ZWhTGvvzpFXJGNOl8ShkEZibRSUgYR/
	 1+cjtQGpV3/xw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:41 +0100
Subject: [PATCH v5 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-6-31e91065fea4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2563; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7tmFad46Ay6V6b5/mmZvG/hiVDuSFgYhQDgYlo78TeM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWW/YFoQrqOUEZLpL3zwHfvHV+1zGe5zBj351OHcx
 crT/3Z1RykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZi68jIcHrDLoNNgikXeHUa
 1+2/x5K/fEvyqyxb7m6H93+NspK3yjD8U/ZucWJc7HzE0fPCP8Mer73FC6ZeTq3deSvhoqnm48e
 TuQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: p7m16dg766n75bzmwajq4bquk1b7rbp4
X-Rspamd-Queue-Id: E6B72C000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790367132-283174
X-HE-Meta: U2FsdGVkX19Y2LlL3XRrJItp10HPoqC6fRltFEZJqRP7PZMKBJWEg2G49oM/Thk+6RWXMmAVL/kf8XUJLQVB3kvmm1vGki+DHFYIZPnKNZrbSdeUECaIurknirFcDnUxewBMHulb0KmWBjYjvklUZbNrEZ1OrkVF5KdRsVPIrgCK/yKEBuPJ8cpJYa4c5TfNmdKTpa2rV1+u+lbXW+vJJyhF1FQd50hy3hcAD3YEkLZzcw2fZamECP1pfGTHFBS5LWpnRschj7UthyBvOmgWYQ7XdeELejvxsFKrxffRckJEFUz6YoC+UxT5Tcy+jCY82oUvfOUfmBw1ElvXGxkKb5F1ex6S43oXgqCfkWkDNOn0by3r05Ac5+37Rno/85YNWckoY60kQY8D/lvcTk/bkD3KTAqXepxEDQpV/oUjHNaaOpJcpBgmIFi4531jaJYMAIXMHqI0vTW0GbwQJBHV72zLMDzyk9nVe4IpXO0d+cpoC/9R+9/HX4SCKVl72soCDaWPL9wx29Gj8MCjt5zGfq+mkbaHc6Pc4yKuhgfsY4X9CcPazeir3JL/riPrvs0yM6xA0TW6s14equ+neg82XrY4fXmdq7oIvJ2iMjDkCyAkYUI5I4BZ/M8/fLOBhq67G0eO9V47JTG+xGPv5D8PQX5J4o+TbMM5mS1dehFgBT+Thcv4ArPOGMxVFO6Gv3q+x3PXuQYHUlPboWXOxGfjq04QGi/63BpSpETw7kGllYGRWB3dWGp7G7Yb0r0PgSZfKbtg4xfx+3rHGv0RDRgHdcVS8vCCw4jGzpJGPCvjYylCMKHVPuS5TyvAozKfdrnj+yYYvH4BENeM99un4wPWJEe6VwnsoMrgXFixKWEMqBqC6dKgT1Vc4/HGsvHpXTqMIHxHBmisbUFNJGbONE1gME8SHoGnPZRVBk+vpf+IKeTsbwLwanejnejSgfQjjmRlc1BppMdTVHJ4uiXBZXb
 UT5+hTmx
 KYz0/V0Xu9UP97RrK4kJkmYehtrVCH6Nb6V9QShhBk4PT+aP0n/jfcXMRYjsv/O6zbVZs5+CmDIS9TEQWzCzNk84yp+O60TviwzUI3yn52CxzgM3Cz/3Q9umy/2oxd3vwpAdADotj/AiS3H8TIRx3fidKFro6F+4YSboSZXRdZtaFwtGkaivBxA3T4xU7uf0CljvT+3Bgu4H2VIz1G6s7QLUZZ94m+B9SAlIE46BSEIJyxMPYwtLavLUJSLltSFyfUGMwqsU27F8loh4cCxPAuX6JGEB+X0klryQBXGh4aF9IOQrzBgIMnHYAKO+6kULtwxzHq1+D1fnhkFaBEaQIKiO5rn4rpn5goaMGPzbwDiywamQncJaTI2s9Te5fI9pc2ibCgkOPwFFIDqezynOSYNqWfQ==
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
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Lance Yang <lance.yang@linux.dev>
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


