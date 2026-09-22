Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB48C98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368606B00A6; Tue, 22 Sep 2026 11:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3403D6B00A7; Tue, 22 Sep 2026 11:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F4F6B00A9; Tue, 22 Sep 2026 11:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 020516B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:38:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 808A1A673B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:07 +0000 (UTC)
X-FDA: 85241804214.24.5E3959D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8865C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=baLVS6KH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091485;
	b=YOaarUAEk7st0IXgZXZSjNrn/VwZ3hEiYYD1KHBinl5wcIW0hKcKjiiU/0W0m7aPDZVMaf
	OZUKdvwcnDGgeLDGiLD4a/fdg58xEHCgbRwoxT8vFOvN/AYdcLtqQxFmeSrjqeem0xqagC
	gMX7TVc26esQu2hmcFaCwx558R1Zy18=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=baLVS6KH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qIS4A8O4N5dYDsCKKL4hiQNRSaqHHy/s6/A7yaKLWg=;
	b=6l8Z7fkrHtjM5CaOYWb+PFNIwLpG9i5tM2XDs2rfRseOsnxj7+dUdBpC0lv8cfAmrx3uKP
	o1cP2eH0NNXMamVe+omTXnlxyHx0LX4Jm5z7a+8WEFTJ/JfhtZw9xgd8cAlUMFbgv4QiEW
	UrDy1q2lGTWbCZ0zk3EROns3+OlN1fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C494541675;
	Tue, 22 Sep 2026 15:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1AD1F00893;
	Tue, 22 Sep 2026 15:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091484;
	bh=3qIS4A8O4N5dYDsCKKL4hiQNRSaqHHy/s6/A7yaKLWg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=baLVS6KH22XEePkcCK/XQL5WUTQhEfQO+oVeyTZCmHU5hvgW/sC6ri+yz+fZAEvUu
	 4AB4f9B49fUmMJLa00WCl/Lq29SV/3o2xefFCut0zjtkzvHJxT2gLbBl6t/7FWSah2
	 cSFBx9oSTs3cHExoGi7w0wc7bej6do9PXjbWtdyMa5VjjS6sF0POU26Vm/6/jtKgE2
	 NUet2CcbMqFq9W3zLDl2+ZbTlY14Hv3I9LNx4pdfIGzHNrM7J3UDOAF8heZnHAptmF
	 QbMCEdCV0Sqooq2HWiC0wBKEP4F5ZEAKre1J+LA0yZT213KYQ7ZAoYR+7OowJbWVy/
	 GA+TVgecxHh8Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:35 +0100
Subject: [PATCH v4 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-4-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1983; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DfBAaXdC7t7vNoXwDFH4KxY7MB20la/qqFRKCtU73zE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LcgWNO2ZyhxnUcn2yn+6ab7p3uPZ3pZnN3/ZwLHOx
 /+0md2JjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkeT7D/5S0tP6NOvsf9/jM
 NlwxdcVR6zZvveSOBtuop/zxvYaTGhn+KX384XMub+sLLqYbIeFdF9Ts3numFxt4mpcFR7aFZ6x
 gBgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: x9cu3xkjwpekzkutijdsk5tguekmkkej
X-Rspam-User: 
X-Rspamd-Queue-Id: A8865C0004
X-HE-Tag: 1790091485-690918
X-HE-Meta: U2FsdGVkX1+qdyEL5hBAFfHbkvcGMgppvdHpRctlR596P4+1Bsg2k8FNvqwAujCx82N5sFYhdJsqC8X1zrjLs782ALdy0cGKQ0jhyO/5Zf2BSiKSBzW0uRY/+dt+cdli0fPCskBFLP+0uIoi+4mtoBC5DiGy6ME9NBqCQdekeYCrnLwAIvTv4lvReIhf8Jgazp/qIKpcW9/9fqceJBBYuDB7L1waGXjCexwAMBCsD8kzTRNiB0VOKnVCIVAZ1lCKLaQvCrV7S2RLIaehtUYjm1Y4os2HjUFcOMcvbrIwrV/BQs63il/JRMBimlfB5Dz6lmDENlqD/D8ftwk4IkfEn9qLDVuXXO5gefZiy4OCPQa8hi/lyyGNIOOsQOtrGMTgciTnX6x6Xyv1A6q9osRmkpBYb5LG8P9Zi/bNaq8hdPx2ISP4Y4Y4xUTCai7CSe1DjPGj5dnlm66hIzXsJv0fZID4nKslHgcyK1ST/camBBvxlvJoKLAms4I46Y5iDsWLTCDhuD1Lj7YEKPjNrCxp3PN9QoaxZJD0snhvr6OjeBLqs0I4392Q3muhkGZptefBEJGia6xP0eyKVjXhJLZvWqxxk2+iaGebA+31AVEK1C8QohA8ltyxxoY3suHYjAitn4OVILymnyXShIf+ATWgsDMYVRgBfgjg8vO+LoYZSeFoLnRfE+E2y/KEsyXYztXIgru1ujaynbBj+s5pytSk77s9myld3qjIoGabctwfisK84K4rjKnu8mykHOmXeyjOdk+WxYzr1EiRFuWcN4xWoDzOWsEL8mD1D4TUkkJ0MaLcmP/NlnIepLdMxMok72wpNzIJ5090EbyYmdSP2Pn57HpLGkn+bydT/DaIbl0PUzTstUwaC1RfbqNu9gGxqDJEjIrPpBsn2dG+gM2yhoY/WosxEkYbZj9Y3+L0CUgRDttaILo1rrU+itQ2GIu3fSOp731GJNxpDAwyH9zh+qq
 bNT24pE7
 p3nSKLHuABPRSxhzCig9GeSU3GV9eXccr92D5ggexhxFCmEO18eb8KfBxKsU9Au2g8Ii7FvmlIuOmT/A6t0A6MtEWiJ5r9AA1RNf5ZJjb058DrmBp+zRKg0kJgFtsq7Jn6vGcbxsAHNZkrLJTT/s2fQGh040QgEhuUG9d+oHRTBVuqQABHnutYsoPDKNZyG7NvxJEayZjm8SJCWVXDoDLt3E7irdNg6q1nCTyvAtv+Jl0q9cTK+yrG/6yKtyVybiawKSSjvw3JYUFfOqGzjHbWZFtGV0r+9HtEaTFEmfGbqCcgBbTaymUzzTJN2CPDjDSWz3gUk4rsxeeu6r44rW5JPyt+kKO05c01mI1Ttpvv1hVgZPoA9DNHGt+CnuOVd5is1ljjDyFSI0PQ/os6EYhWEDRKt1IBD5wtRtNQLfWpiScw/0aHaAKLjeJ7uzgxCfX1rM6ihOX6gFPaE20nfeV5lcD3iLpLAmpM7p1OEOYPc1ADPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a0ad5496b2b3 ("arm: mm: enable HAVE_RCU_TABLE_FREE logic") enabled
CONFIG_MMU_GATHER_RCU_TABLE_FREE (then named HAVE_RCU_TABLE_FREE) for SMP
arm architectures with LPAE enabled.

Regardless of whether CONFIG_ARM_LPAE is enabled or not, the same page
table freeing functions __pte_free_tlb() and __pmd_free_tlb() are used.

Non-LPAE PMD page tables are folded into the PGD and freed by
pgd_free() (PGD freeing is not part of mmu_gather page table freeing in any
case), so this is a noop in this case.

Since commit 358d1c39c82a ("arm: convert various functions to use ptdescs")
both LPAE and non-LPAE PTE page table freeing uses tlb_remove_ptdesc().

Thus all page table freeing is performed under RCU with
CONFIG_MMU_GATHER_RCU_TABLE_FREE enabled for LPAE and non-LPAE and thus it
need not be gated on LPAE.

A UP arm system can set CONFIG_PREEMPT_RCU, so a future pure RCU page
table walker requires MMU_GATHER_RCU_TABLE_FREE to be enabled on UP as
well, even if concurrent GUP fast is not possible there.

Therefore, it is both safe and desirable to set
CONFIG_MMU_GATHER_RCU_TABLE_FREE for all MMU arm architectures (nommu does
not perform mmu_gather operations).

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 408aa58a2a5b..72b9afc6ae10 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -134,7 +134,7 @@ config ARM
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
 	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN

-- 
2.55.0


