Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 290D0C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319436B00A2; Tue, 22 Sep 2026 11:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2926B00A4; Tue, 22 Sep 2026 11:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9AC6B00A5; Tue, 22 Sep 2026 11:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECA456B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:37:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C07712050D
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:37:23 +0000 (UTC)
X-FDA: 85241802366.24.E7C91C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD87E4000E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:37:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8I7oZL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EytwztXVP9+HAqnBzZ3KHLRHej5X7gcr6/abe7XoyR8=;
	b=UHX4WjbuCzyEV1MH1AnEnkJ/Lvz1xomNjjynbyhND9OtTnOtPvOpbIStNqm1zQDegMQMAf
	LbP9JBoxU1PXd+goUpUrHKzbHiyAl2Y7+BWEr6b3qOEvCV8zH1/5k5erSnlDcWLSpgpxrk
	otclCwmgJRhnS+fqy/bpVIcvZ/V9yfw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8I7oZL7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091441;
	b=M30loxRuW4m927VAL0IiCvuf3TKUQUAF7adKGxcVLdH/gPYsmZuij6OdkYMbyazvsdu5wF
	vO8Cgd3wvFiskHm/UrsIGcdyEsZ8+AFi9W9IMiE1j3J6ur0BocOFpsmVe+b9NJiU1yCai9
	uK3LZ2MTtl7h8N3Dp5C/XKzFAS/qPrY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3891A60A82;
	Tue, 22 Sep 2026 15:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4FC1F00899;
	Tue, 22 Sep 2026 15:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091440;
	bh=EytwztXVP9+HAqnBzZ3KHLRHej5X7gcr6/abe7XoyR8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A8I7oZL76bgc/K4OnZ0JyOMCleMrv8FdbRx4ZImWL6TzUOPy27OJNysbdg4leGGta
	 Lx4vSFm7V5JKYxrVGD86zIiIioAiFtHv9yN3wsYYID68QpWVVMN3tQku4l98Qy4zgw
	 qF27kTj7WZm0/RooazviLjtxmwgEqpzuJcU5c7iIeBV8ngO+1ipt0+uSiSCb1hYR9b
	 FeqTZuRHz8OvBlBx/kNDAhn+A5qaMG/FK1Kz/HdRa6QnK91S6WhAahUdZR52ic+UQ6
	 m4kfJDCDMoP3ZT2i41bOmIUPh/ZPP4TnOLJOrrC+n/gp89K3MgMVpMT2NZUEDoQZj+
	 OSQ/pfkvGm+LQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:33 +0100
Subject: [PATCH v4 02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most
 2-level architectures
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-2-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3613; i=ljs@kernel.org;
 h=from:subject:message-id; bh=bwuaeHFGwuLQFcHN0hOhjdTFxvn+j0g8fIWNrCdz0hk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2Lch++epj9MNnHpEe9yYlHD30J+h8XF7vnb1CF/a1l
 1Vpn6xe2FHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJNO1n+J9tETupvXJjzarT
 rwX+hry6vcpP5urt1Q9MTtum66QcKIlk+B9bHRHH1mdsW7N44armiqcpC9oZ5195ZXdRTZPRdKv
 ybXYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 1wor8csu9d54bhgemazj3g41rry4j64a
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BD87E4000E
X-HE-Tag: 1790091441-701504
X-HE-Meta: U2FsdGVkX18efHKniSCjphtffsxeQROeScFp/Jm91zYL+rYiR/st3lz5QZTv0Bmz+uQ57AXPgXbRqB9emI9rFXWo6UrbKA8Qg4384MJsMkEk4e9VS5CSZZiFpdPLhEGV5ag9DjpkyfvNVoecnvyoAzNySfIzC00EZlpxc/xt8NWIgG+QBKwAXw05gJ5AD2dQxmwE4yMnRs4EW3s0kf/ggB9PHcVx6/Nz0WLdfqWWEf6PZtm34pncKc3bKVTa746XorW8HdblLo5hOLHr7/JEnjXXmJtFgIZ8/ONwLAwW17a/VZLMHQDbWC5oFsyWnW1pfx5dqbGt01n6GLrFxuX23H1s0Kdg5uFm1yeGNWlZ9Vm53WmK+TXIM566GQpIbIA/U9pQT/yqiAF2yI3pNUf2MX6uNWn/09fE9tTfTs9qmFoWlYV70ijYKGLD8huMwqbDKOyuwwqOef2PAtKRSfBhUPsWUn9BQf1vxLxx6ogmyja/8cNojzgikee78fCkKluO+bhal+2OruRGCH1XXIt3ZJYsyXPwrIde1MSoIHpgMuYb2bPc9WpJ/hNDuZP89d6HLSs4FeiwJK5sP33kYnKCc/jnR5ENa2cQAOd0cokilH0vURyh+SsRFpzmVEl00gsl+JDkMPv9WdCL6wxFnXgOAHTTQwirtU8XBlthLCmIOlZT5Z03Jl8VWoyhXuuzz5pNKz9a/4QZe6dVDmBVmTYSeSN+5az/olI+cFL0gxp8jNg5opUowRGiA8f/IPyLzydMbHM/Zs2P9zgg2Xbx92to4AYjx0u2iKJBhlPpwFtCrT+KlUddv/WIqITRnFl1XX5yqvznxUmEfC0NOdV8J3c87ov+CIv9tdXiduNXJY9slhoTs9YIUu+mOveUPEx8zpTZ5t0dwg478CdDWxvKak6UNH46kMgJjvdZ3CLlhXWlpWJNG8eCpO17J4Q4xZQN3lS0l9pbduwWztt2WLEe/vP
 E27cdOK+
 M6Vowq/wEVrqut4DkcyMb6bZW7ZRNQzBbCvwL0JmzYnNogDfM7V4/q3ZUMwgBMqRkLPxDvh+aGNq5Q8prdCRNq3xXTAnohMAUfgSdJqokH9+PRcxEGJyn5mzq2oqLMcwbO2NP++lW+AQcLdFx+MTNpNqbaWVkJvoh7uB2X0is4kseWwLXenBRRrU35cnuBWFsdFL5JXxLSqfEDFK3nL9KaMvvxwaYhxHb/23YYjiJL0aD7msZJOQ6qcOJQ/qYEAMMZEyT1gGkviRsedRcQV1SzNl5IbxEzJJWv9tJrZdDo7Y47y156nQl1Q5Ea87pPCx5d14Z9Mn5rNndSkBQ87ZdsuGmjhQ1vUwMIk+ScGhExSPCbnoB4iDydWsqgP398I+flTL77oOmo1THCkLHYDW/i7daNNtCpTJfuu5yVMZUe9BUIAjJhMnpevtAxjllIFo5dDLDBCdsp4B6exniBN7O0R7XT7WPDhGnQIcysXQDAxFHP1odCZlVLlY9C2N64JzIenkz
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


