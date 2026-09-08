Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E63C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFA566B009D; Tue,  8 Sep 2026 08:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1786B009E; Tue,  8 Sep 2026 08:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEB356B009F; Tue,  8 Sep 2026 08:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACB8B6B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:34:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17183C0639
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:34:56 +0000 (UTC)
X-FDA: 85190539392.03.1AB79D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 55E4A140013
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:34:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkBhZQWM;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2RQcemfGMYTiDH29zfMnTtdgj0bHtOblVlsFhLPlSxk=;
	b=k3DW6XLeze2hi+hCOu4zyE2yX7PljtL+ACBS4quXhEHJvAypO5HY3hS7w1SlWelfNTPbrS
	Zq1ZLB8DnwwM8ofOkRo4dk+x9omk2rIl8BRpATQPPojHTWoiXjgzjpBNsH3MWdZ9U4s3m4
	QY0YTGZheRdli5BtwdXmEIkTf6iTKbA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BkBhZQWM;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870894;
	b=ujZy4VVzuka5rPtYXZS7KQ5WnuQ2LrywfEnOpYCiWIgKw4BYlSGNMpOm6zhngKxcQiRVgX
	Wv5RdkXxNd6jxUv9BI4vduwqkEOyZWGJfb0/X9s9UlJR5iYwRcV1Wlmwng1raY1UY1uHwg
	utSEjFkhxwB1lA4FITeaSPgChB5ah8M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC22B601DB;
	Tue,  8 Sep 2026 12:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1661F00A3A;
	Tue,  8 Sep 2026 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870893;
	bh=2RQcemfGMYTiDH29zfMnTtdgj0bHtOblVlsFhLPlSxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BkBhZQWMJaKKK3kWxqiV0sRE5ApAZKRcLKBomVjsdDgfY+tP7URW39FuystAZN++H
	 HQ7wqjHB/37EVGJIuwiSGmfTp7Vp8T/jU0DMjRS4P9klDLrGCj2Qgu+A6lGKXNczH1
	 KJk4+Exs2cODA1A1Lu3ZQULVnsj0o5ldTr8gRlTAs6WV4+Eopslz62zHBRXBjdEVtW
	 hZ/N9yTzYdMknuV+LXXwqefUBW5vIRH3y297e01EmAEhvvwopzgh/oDKM8BVvAv5W7
	 0dJYrcsCtLdY8mL+iq+uQniVYRfzb5b9GZPzOV4w5hpwmFRg+SIxYSL8Mq+929rq4+
	 Ys06pk+5Bfl3g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:15 +0100
Subject: [PATCH v2 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-6-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2421; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+cl/mE+MMAULPxyBPFJXsNZLkn5nuULAZlZa1FGDhyY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMESv2xKd48fI8mtTui4Ta/hp+d28Xu9rvA5wmH5vi
 71/9fG/jhIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExEtYzhx96CQv0jOvtW8Zx5
 zXvjpdqkgMTXKRbHTaKeac+Ii+z4y8jQsigg8NunuC3bHPzfFqmkzHQ20pkho1xRW8x8/Nbx329
 ZAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: 1ssprwzxi9f3rq1upkhrxk573ezqih1o
X-Rspamd-Queue-Id: 55E4A140013
X-Rspamd-Server: rspam07
X-HE-Tag: 1788870894-96064
X-HE-Meta: U2FsdGVkX19gfHxZx/L2UpryuowNu75l7xa5BfuoUOzC7h6YubtPSS8B2UXcf59C5K+0J8FEIir7EUB5vsbuLir3ToRiSiWO3Rn35m9bg+VVLhjkZ1AZtBesjOBRGPbeiVUKDU1p85tRdIPyIWLWdph5x9xGdZlX3GD2280Zy0XyPFauuks6d1KqDFOi4CBUMeZVI3DKMdOhDmXWgj/urjgaQd61P3PcP6wqunTahDZ+6Cx/WJn/R2eEIN4qfjYbqWXlOZtoUmHPtK6GRs2vMoZcWJSviFaITgTpmV6izqGxtPeJjwfQtQbsgqN2tDXLTcY0Ry1Z87AMKThkCwnlrmEmXGPKjHwEXFUMsM5NbN5OB/ab/Tb39GDul/yC0dHFTDrnXx4azUMdbLj+9KGJXu4yqmN8znAVSVXqxLZufsO6kOhfaYvty563f/3z0d3bEeMVjyYsJcBmt9HlGYdNGxrj79A2fAua/a/Aqp0Bldo2A4OnTd9/ZiJzQ8ecFMiWdc8imK9VBWQ6UZl4M6Cw3SUtv88it4mxwbT0rb+ZJual8lexh1tjv224fQ2k5j9roFcpheZCovlvYAX9taahRm5E/Etg4l6KD4/PyxPdT2nZsmUh80gBAGD/DQb9dQW2iutgDdZxr/sgPCX3I5TNJ3C2D+tLNK9AYbASL2Jg2SLByCdbdK0T42HcUuuvl0I4NfdrBgUcdiGP5KX/h+ltjcXk7NrnI742MScbvr+OYCoCptXtDstpGLqiOAs/Bl1y9ljCWC+jzULSB2m9ahG3uBsEeIP2TAOSaJ+r+WRLkM4u75HWaAZLVqG19XNXvr1soZPgnit96zzaWCRUNsCj9FA9jOAL1G4S3w8l+5bYx7UgHqgxUle8+mlhRzPBMDGJhAXu5kJqruOYhMeBy0SIv7XWdL0A6vj4kHkORnoUcHvlclXxLSwZFJGnQFzyRZZtoQK+R1smvrdZF00JSus
 qPnBcwNx
 z1hz3KC4mNAeR+1aUjlMMEsceFcNR4k8uEzvCF+QRPCoeTlwrTz/T8mOdeJqJ0Pjp+NTx6BhD1BfTu4O4LNpmOeUdZC4Zm85MsqK16heSSPA2XP49uGxvVPWOJeA5Xq/Z8fDIOLn5k6QSMn1X3rim8A9NoKgMqBShAPKq3JjcdfmmS/B5VQ0zolmCbgRUpnNH3BWjsrHO7+5awvdqgFXBFQnUiCpa2qJ032jxP6cwO5DmVSMq+AnLxQ9rsu6X5zpj/hcaBH5zJWjDozMLRsCk4NZkJ5fiUgSwl58L2Q2lVbUuKhko2ZJ7lSs5rHV+1uCGq5VImxgO7qFDvKrWGq8PyfCbneSOiRGMnvVXHf/GGLYLp1dUc1LcevmcCjqFo79/rgwnDENhOJCoHAnmgnPBk2sQeMyKgwvo/3ucPdA0Up/N5TGCNiR7D5jbnqSDAt7mHuroULS4XMXubI5rzck8FupTzEyubZXC2DhuROE+ZSIkJJ4=
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


