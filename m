Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE75C88E59
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B6D6B0095; Fri, 11 Sep 2026 15:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043B86B0096; Fri, 11 Sep 2026 15:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B396B0098; Fri, 11 Sep 2026 15:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0FD76B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:38:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2632120187
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:38:41 +0000 (UTC)
X-FDA: 85202493642.23.575A96B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C9D6580002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:38:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScaQTg6L;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EytwztXVP9+HAqnBzZ3KHLRHej5X7gcr6/abe7XoyR8=;
	b=yoiOhbjOMtwgkZP9tjhU+VWubWQ9aRUQCEpPfPNf7cy0NYmr/Z5bTnT3HuUngWSYD2JHTG
	pzjaoWXIigjHNejRfA8NSHyARJNuFw7FM+50TLA43xrTNheHOXTDneFfqJd+W9pZHZrcUg
	foR0F2H1JWT3lP5rZf+HEPRYqTdjqFw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155519;
	b=vmHDNBURX9xRJKTj4otremgLliK2ZoE4E0zNRuZ3p6o7W1oexAIj7wnGC4o0iYMG1bFKoK
	uPOoq5KqjKU9kWepQbugHaJ6TFNefxJoZFqMwHB5sEcdFvEe5kdwzcRX4zwKwuYLM1Sebq
	zho4L9K9p6JFj0tBdww3QZqVpicxj1I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ScaQTg6L;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBB2041B3C;
	Fri, 11 Sep 2026 19:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7A31F000FF;
	Fri, 11 Sep 2026 19:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155518;
	bh=EytwztXVP9+HAqnBzZ3KHLRHej5X7gcr6/abe7XoyR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ScaQTg6LWHkLfDWTvgNiTGyWgG05bd35hGPejMTWEMUNobHR4gDQdgVXMK3xizzT4
	 Wqx+hhrZ3gMeNHbse7OmqImmqIiRn0jo9vtZMFEmdUqU8Y3oYlJr8upoXslpLoCsdD
	 DEBiMHcKjth9mOpJnnXc8YgW/JxKV7IGYA+nRGAzpMW5ANaimCLuosk/XI7hbUwyA/
	 wFFGmJKBa9MTxz5qGvtm5MOUMN6iE2F7lpBWydktKhBSuHbQQqg/TVbdZ/HtZicWbV
	 LL56b1u0DcWj0+aC6KWgiL/0CS1cx46/NLKorS07OP5G8hQ6uVBfbtellrCLHnLlIk
	 nNVnge1Nc5qhw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:49 +0100
Subject: [PATCH v3 02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most
 2-level architectures
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-2-7b8c86103821@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3613; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bwuaeHFGwuLQFcHN0hOhjdTFxvn+j0g8fIWNrCdz0hk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDRqXrZ8rz9bKy3gX57EijNZzLMyAt2Fzk5SXPMk4
 2XQGwexjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkXiMjw8Zi81dPuAKiNHg8
 JsyoZBXheOsRWVNu6hQWcdzdwKz8K8M/46Dkv8+CeXPLGQ4s1b+0mGelmXR26cTa00b1wqp3Dfe
 yAQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t78kyemiznew1fjacmsmcyrf8xjgdetw
X-Rspamd-Queue-Id: C9D6580002
X-HE-Tag: 1789155519-766554
X-HE-Meta: U2FsdGVkX19ZwNsxCrxprAB86D43ue3JaTUNcNKm3eYWXJGRtwLWaOdm7DhIdZU4a2Xe4g3IsDKHIycfsokpFGxPfzm05+jIYRuxwQhAovHqR6M24+S5n90kZH+fjDVQrsTUhg1Eqt6vnqeKIaP9Y/aVcjMLjvCEAt2k18YPy4R61/TmCVINbSZjl/StNMqKQZk4xZGN064eVm7uCJH4XNC1aKIFUv6aU42ZFKVvGJCAeV1cq0gHpiENwYjUP6l8geIApC1HwLl+cy4z71CfrzBsrNwMgbzddMjjWrUWQL4GqK2O61xE1ONrnXBM5lX245gbZ88mtZtCEUPYe6I/r/9hTQXqyPURvrJGwmoGR0gQ9457+zQlpUzacubg/C33mcQJTHhcIuDzJB8+grawrfwMmlyLXqNH1hkNTAqcRUWOGFsexVBjaIlXEoqRLMAswqvNWTceBpY+bJvXaKn9pAOFznLHzio4iMIx3gBOb7Vd5NlyJB17fG+/Me/hrNxJCUkohSWvKUs5JrpMTu2v5/TZGyiNaVTdaXrxztVJb1lH6NK6eW/+3zhyntWk4y+PEuIqD6l0GzQygdolBahYiCvttDDBmguH7C82EuDpDAqnqmRn0A2D6lZ9QHpfC/lr6aZ2mDS2+RnZ1gn3ZZKzTBh02BpydKYuW2iULRUjAJX4mIOiDJ0zMwUd+8H82zZGOgqyML2g2alsxTX2yEnYG729Aq7MQzqu/7KDJmBP8ik5bvL1D512sBmqzapRuGvmLRslXNfoq1nFBT0oQf98tgUZQSos8skjikkKqe+wBHioUuRm0+b5L23aZ9wrJK0t4yH2d19tc0It+mJsUNGoHcStxgAZC/AOJzQyWtgq0tJvDyPOb68q8QE26vjabCx8FdBFV0laSLTRXbrll7X8ntuP7LflLz8ms9c0ZRxN5NTfONpqzIgiUXtrYxHniuaB0SRN6+yhy0lj6wznQlG
 nJh4XqqI
 lJRKKA1g5T07yNe3ms/yCT/qHVnVM3ftgIChBItmh0UQO8ilWtrwwxC6IOk9Te8/UlSz6eBUXQAl7ObMlkZ5F6mb0u2KldFofw+STUmHamj4ckxIqE+NSV5ahaecWgqBDZqTv6A/TgsJoX3EkMYXnhS3D3kyGhhWr5ZVDEf2vdbJ+yn3TOt1QB0tCjPlSBXTx8XUf1zXHWXceZp3jt/ml1v8BxWM0AmWEow379ZX7iZhcmmV9YqczLydkyO0lA5inwUvKawzlXCogzL+BzKoOXm5d27m2MatQGirGrcDOSxgSNvgvUV2X2MM1FVf+yp6TnmLeDTMkL2hNSBkSzmR38im20zvsDVJnGAlb0eIJ3BiiYjvNutMEGIeue94n/gOcSdtzF6GeDx8xzNg=
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

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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


