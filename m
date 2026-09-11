Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1280C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:39:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12F3D6B0099; Fri, 11 Sep 2026 15:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107EF6B009B; Fri, 11 Sep 2026 15:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39A26B009D; Fri, 11 Sep 2026 15:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D37B46B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:39:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E83E12031B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:20 +0000 (UTC)
X-FDA: 85202495280.10.ED52727
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8DD93120006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:39:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDcMFjyH;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qIS4A8O4N5dYDsCKKL4hiQNRSaqHHy/s6/A7yaKLWg=;
	b=3s+L2bCZXWHtT1CzfuCOGzQlmd/HZw2hYf48rlD3sK+hMceyW5bWl0RHtqRKV9DCxaLq9m
	lPnH1SUPj+n3zXczUIU4xGZ2XJdI3l1YUKq7sSMA6u/eIbMuH5jh7ZlQQRDQ1+DNiUEnhL
	B2gYLQgj9rviSb/yUyYa7oHjeCEbM3o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDcMFjyH;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155558;
	b=hrzcIZfEChtQs+6hKyha6HWe+7gFUFXcPcNInnV1QTitLMjMWPl4PstYZVu95gwl5mQdbZ
	eg17A6JF2FxFCZ2fdiUd8q0ULjS2V9p2hqII9zL4LqAkCCPdV9SK7VY/sx2AAbEskFXg8h
	Y62woTQxK9JkhS0Mr9EQLaCB2nsceU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AE2D60008;
	Fri, 11 Sep 2026 19:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAE41F00898;
	Fri, 11 Sep 2026 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155557;
	bh=3qIS4A8O4N5dYDsCKKL4hiQNRSaqHHy/s6/A7yaKLWg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eDcMFjyHG+gLxqSsyyvUgFjMTquM0bUYib7h1HdpzEuYyPG+fAG6Rsxx8uhHJPyxt
	 lDjDTfjfzYbZu3ilnt6I0zLCAymeoL2Y7MchBwgvmGYk5GKfBwoHbWD3ld0JelIEBx
	 vJRlNInx2qRVJoTvwZW6br9Y8NnHFGXxrBOlPSUwb/vfPQZGF05RIv7eTeVawSQH+f
	 m1fjCB0255/uyysZGBXQ7UYrGAwPRYhBIJxnFTKRmJCArjFkZnx5q//766cwvqy6kL
	 Bp+O7Kthb5cnhTzdNnG5qQTmSIsEWdq/zLuH9ghx3uLJXEqUgvuyaoQl/2ML4JdarQ
	 2YHR3NaPvTm7g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:51 +0100
Subject: [PATCH v3 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-4-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1983; i=ljs@kernel.org;
 h=from:subject:message-id; bh=DfBAaXdC7t7vNoXwDFH4KxY7MB20la/qqFRKCtU73zE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDQ+9bvN+Eh/mtvi4Fv/Jd5UxLdv+9C7oOZ+15JFp
 3aw7Xh4r6OUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQAT6ZFj+Gf0X0jKunPX9zVH
 Xkftt2gvjj40fb9Z7d0Zym2z88p3/xRiZHg6tX7np69zPwUd3rdPPszCJ+W796ODAULHri6svPC
 C7xkXAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DD93120006
X-Stat-Signature: agokahc8njho79kgtm94ypfgqngiw9eo
X-Rspam-User: 
X-HE-Tag: 1789155558-353522
X-HE-Meta: U2FsdGVkX1//DoDOzFjAhGDNuqbisaGnYDGAERWvUDS2IP/ATgc3vFz0F7j0zlKemVm9vrzFaA+OV/I49rfcX8VHcaqa0Kx6ooiB4GFCR8vqp+rGkqFgwQlF5rVb/syjZpVi4krc37tiKefjdECDL5YZqMgZdkt+12VAFmMxA4+GdwVhpgeDe5ZmYM+bEqkHjDVK7dF+nJoocGrTOzM4QCSBfF7qY0CKwXhe9MJFxc8DZGxgjkQ7VSpJ24WTmMai53elZ5pcPoCS3hcVypXQ86ZoBKR9W1gynWjp5BldrRl5kYFm76YkzwxGRQDJzAVxH0Bkm7x+gANKN839jZf+XVB1K9I8qrGDKV1dVMF8SpLI7Dke7AQLUO4WRCFy2is0uaw8yLTT95R7ADpGRkPA8zo+xiqO09d1cBJBHqTJb8T0b1Gxbe1v+mLuSpvAfMpciy1WvnH2nJajrz3NDOzubC3yzkvLIBzPF+G9IopvFyYgkXX1QR5rFvCYtmGN0Q/UEVELtzU3LVfGah8vVHV0dyU3kfD86ZR1LNiSCzUmGg6BvIF7pZ0VM6xdTi7vGnDx8Bj4eRHAW+ZzEFLV9C6vH+1M/WjH1C4BfSkBVqaHij3FSuRBggnoS9xqaLCTLvzyvTKqhf9w6Jld2WDs48WuzeyQEP7TVepZNBIAtvqKpArh+9Rkg8Zkttv9ctv6BQdXFZVMTVD56Ix5w6RCHilCiOz/RDsWnkHBiCMYJaAfB3ZNcHsiJ7oFFbWM796CygsyDlSO7CnZ+g1iJvNGm/40UifpD0E++MGV/at05dvGkS5AQIwRbsxqU4MRi/MOrmu/0FBxSyHAb7iY6CZB3PwL3WMGd8IXGQPbS21C/qUoGO9mBa84S6oeOkmWtQJozZAvFT+7Sx+qZcUwjXb+yaGaEDnOKEqTlZaJQ8kRzrtnzt0toNfhumWuKS4vKlnC9oiwN2BC2grzGM6/+NGxoF6
 cbzzHLeK
 I2xTK1tUU3DBXSx7ygCBej6EAoXD1EbZEdeGNJyJ+3jChc524WqU3QiB+JCAdf4vpmaqf9FJzGYR2ylKAHinuB2NFU9Y1kCt/W04+e/2CLHjoIFTATcf1w+BtOZgN1gzcWDZp4fTuQyd4hIAjJQtBFjN1/ei/60dPbC0db0/p83IKQ1rHUwA/rvNmPXYjg+rHOj8eyCjNtcL3SbKlfD9Ye52bCK2pMOl1BLnK8Ncuokjobx85z/oh8ReRGOl3rjE/PAn+JZ9Q4+4/J0b5u1WfeQqD/7qJyBi8dWKURUtjwtzAr/WI2MNQBlmT8z9hVaQCXJ9B46yfAmmaG4VSg088kp/EIYklXtQbwRprj84WTIQHadY=
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


