Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604A2C624D0
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52BED6B0126; Tue,  1 Sep 2026 07:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503FC6B0128; Tue,  1 Sep 2026 07:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419C36B012D; Tue,  1 Sep 2026 07:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 219496B0126
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:05:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE5E2A031F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:44 +0000 (UTC)
X-FDA: 85164913008.27.349299E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D734810000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3y3kV7x;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hla1P//jUaEzl3P+0ure5xER+YPzVxn4O3sMhLZO6MY=;
	b=Il6Bwc0fo2PsUfbB1QQHLlPR04lJVo83uTWGRFb51TU1Se0pQY7Uw1DrBQ5AvFFTnHGaLn
	ZcbGKMyyrx0tUYsBBNRT99DHP0BawavgLtccy6K6j5RGixRG41DOU7QjrnHnQJQBJoPBaH
	06+YRfv94d+BMF3jLsy4j6GsnU1Youw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260742;
	b=FS85LhXY480zQ01wGxRBDlGa1Lzsqi3KmE1KWbYt8koTMXIqAdu7/hI6aXOwMkefuhbLeI
	jVVTrZte5D0NXmys+VBw2t2KtDAnH7sHPlwo/NuN5HOfdM/hLx/IJvXrAKL9OaYdgBVo/8
	5DIriLAhT+JsK4Ilfq3T9aglTKYgCxc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L3y3kV7x;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EFCC601DB;
	Tue,  1 Sep 2026 11:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2071F00A3E;
	Tue,  1 Sep 2026 11:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260742;
	bh=hla1P//jUaEzl3P+0ure5xER+YPzVxn4O3sMhLZO6MY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L3y3kV7xP4GUQ6JyAP1rkMfIJXYsMZuVy5QNWrVPBCCzYr1m/zRVW74DSR8ResTEo
	 WECSOQnrU2KwpiuxpnTE1UA4d0FuoyXQN0d9YE8EolumEfUnyTDwNtfcIDlVt7KloM
	 Stb30O4xGLB71yHukiz+OKGtLc6cEZomjcvLv5MGQtofBh9wawUjL0jBb3Msd7sAAZ
	 UQV3deK3RVrSb71bdlxmKN+UU8YmueQsNT1pLtnZXPue42MCyLg+NcShK8lTEjZWG1
	 n1ra/YYdx3fQ7xc+3cCJ2jrd3TuuBiCegbd5mwrOkD16uT7hXFpLqmM3fEm53lwmes
	 8rubg+iwF6wZw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:22 +0100
Subject: [PATCH 02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most
 2-level architectures
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-2-5456a81c8212@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3562; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yQUOoL+4VfJjLW5MASkaQAQ+ZTfTJR7/6HJ0TBTi3s0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbXQPXtAV0qUlJhy9XffShy3TVrz3O6nqNue9t23Bu
 r/Of/03dJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiOzMZ/vBU++3nub25tjfv
 Qf2t/WUP0zW8N+9MaBTdWsl+irnghQEjw/S+adZz8t7f50p6sVxQLcWQN5PVj/VIc+/dA5+L/rS
 GsAIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D734810000A
X-Stat-Signature: aupbe31b3qm1a9n96ptdqmfr69zodg39
X-HE-Tag: 1788260742-657271
X-HE-Meta: U2FsdGVkX186MiigTgd9vBBadsIgCanA7UUjJpn4oLAeei1H8XeTD+YYfX2aE1SC3Sty4BQoVjKCTswy06Y9GijSsGyJrXE+skTHaV+SBVs+u7q2HYfkO88BTgmTKSDoUKOE1S2VLJRvohOZcR62HWJv9kay8ad8vBlUWWsVNRx5K9FBIdr5ySZtARwOB8HxDa7T9C1Dsxz1FURcXbfuwWowKULMLwlaMPPcZI8o+Unb4blaug66639NNoXRmvlPE1u3XF7wx1sQAKOZDGmJYQg9WYXCSW99jl84gN89qgtNhtmODoEnezrsAGit1w7lI1zGna6FxRtcMnrud7MSU15YaD/KJMZHKp690s1IV68hHN6MJYafYPo+heZJU0qO4JZCTDWDpjK4aas7FMrAEJvMjRT2oQznoHt/KJW3sN3az7a2T3X9goL7/X3FFpuvtAH1k8CWxhfue9EAlIxumNR4PfIFYeIViB7cnFraHQI7CvcF/qs7aqIO7fXquqxIw4Sm6KiIP14zWuZeFDXEvxxzyplFlApaJbKqwDBczqrJQTFedLO/JZsK9ej5HR7+GrXprUD1YnaCsU6By6aPi3cdOSNJz154/WLwGW1VRnOD6qpdz1GgaS3xyudos9XmA0JwO8ZyG6c2sMiH6CtvyfIPdgiCWQhBbo+NQkNt6/njvHWUs2l3FCcBlebbZNy4YpGssPs1tOWJrOLfu/N/4+d2R5nEphdN1ZWxedSyJi4CwHj+slOLOeomi2aX6MQN8B3gx2BQQwnqsvJFwPh/4HmYja7VUmiKbSyJXYlksI8CxLhxxnylk20c4NLLQcJOXw/Wv7M+PLz6OG6OvDk1nf/TE9amnfZ1CeBc5Zbd+GZhicPo9jIOmlWDWBiTxPTW6Und4NAbaBgTa8MT+Q7Gt+crrzuxdVBxygjyuE113tWKRLhSZL1YtVbw+QsTEAIkhI7n4dWETjCtKqxvJWN
 FuSPTBeL
 DQzAG9zE7XoBK/WxNmVzAggNuD4aWLpyaKzQtpiJFd4UHnZL0M9BEaf6U00wkoJGWezps9/skMEtLNcOLiT/0xrkEhVjTPtUCGcx4AlonfV60UYFCgoE/uqaLf8zuom69EUFru59FtGFKimzwsNtz5nU0pZMC9Hh8cN9c3IucZRBUWLw24RKQSWM1YZ0+JuclrisFHNIbppQ2+iOt+HpflSKKfuwlU4crsFwlGHVIeU7Ll53mXq7fcJM1LN9NhvYI16wG0xHNxzdWOvGTOPJOEl/0PI422X0yJp1fzebxvDuvqmZ3vGmqfOyXV/xyB7Nya11+v50gV+dhy1NVgL6OieX8YG/M6rCd2JbByA9XmuJ98SLGLx2mwYMz/PDq1vVvRR1SljfHlsZEAss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit e3ecf7c7d082 ("mm: pgtable: convert some architectures to use
tlb_remove_ptdesc()") updated a number of architectures from using
pagetable_dtor() + tlb_remove_page_ptdesc() to using tlb_remove_ptdesc() in
__pte_free_tlb().

This is meaningful as tlb_remove_ptdesc() allows for RCU page table
freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE is specified.

The csky, hexagon, nios2, openrisc, sh (except X2) and m68k-sun3
architectures all have 2 levels of page tables, so the only page tables
ever freed by mmu_gather are PTEs, so this update suffices to ensure that
every page table freed by the mmu_gather mechanism is freed under RCU.

Therefore, update all of these architectures to select
CONFIG_MMU_GATHER_RCU_TABLE_FREE.

This forms part of an overall effort to switch every architecture to this
mode.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/csky/Kconfig     | 1 +
 arch/hexagon/Kconfig  | 1 +
 arch/m68k/Kconfig     | 1 +
 arch/nios2/Kconfig    | 1 +
 arch/openrisc/Kconfig | 1 +
 arch/sh/Kconfig       | 1 +
 6 files changed, 6 insertions(+)

diff --git a/arch/csky/Kconfig b/arch/csky/Kconfig
index 4331313a42ff..80f89ef1d962 100644
--- a/arch/csky/Kconfig
+++ b/arch/csky/Kconfig
@@ -96,6 +96,7 @@ config CSKY
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HOTPLUG_CORE_SYNC_DEAD if HOTPLUG_CPU
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MAY_HAVE_SPARSE_IRQ
 	select MODULES_USE_ELF_RELA if MODULES
 	select OF
diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index b48491140013..d9b3fb86556b 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -23,6 +23,7 @@ config HEXAGON
 	# select HAVE_CLK
 	select GENERIC_ATOMIC64
 	select HAVE_PERF_EVENTS
+	select MMU_GATHER_RCU_TABLE_FREE
 	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
 	select GENERIC_ALLOCATOR
 	select GENERIC_IRQ_PROBE
diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 11835eb59d94..e29610fd1240 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -36,6 +36,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
+	select MMU_GATHER_RCU_TABLE_FREE if MMU && SUN3
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
index 9c0e6eaeb005..b0ccfc3b7a7e 100644
--- a/arch/nios2/Kconfig
+++ b/arch/nios2/Kconfig
@@ -19,6 +19,7 @@ config NIOS2
 	select HAVE_PAGE_SIZE_4KB
 	select IRQ_DOMAIN
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA
 	select OF
 	select OF_EARLY_FLATTREE
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 5eb995c13074..d90b24dd3bce 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -35,6 +35,7 @@ config OPENRISC
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_SMP_IDLE_THREAD
+	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA
 	select HAVE_DEBUG_STACKOVERFLOW
 	select OR1K_PIC
diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index d60f1d5a94c0..204f64912f0e 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -61,6 +61,7 @@ config SUPERH
 	select HAVE_SYSCALL_TRACEPOINTS
 	select IRQ_FORCED_THREADING
 	select LOCK_MM_AND_FIND_VMA
+	select MMU_GATHER_RCU_TABLE_FREE if MMU && !X2TLB
 	select MODULES_USE_ELF_RELA
 	select NEED_SG_DMA_LENGTH
 	select NO_DMA if !MMU && !DMA_COHERENT

-- 
2.55.0


