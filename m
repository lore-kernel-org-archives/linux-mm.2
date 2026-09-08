Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969F8C79FAE
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756F56B0093; Tue,  8 Sep 2026 08:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72EBC6B0095; Tue,  8 Sep 2026 08:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644776B0096; Tue,  8 Sep 2026 08:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34BE76B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:33:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4A43A0675
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:33 +0000 (UTC)
X-FDA: 85190535906.02.2638694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB7844000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:33:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AevVC2vY;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hla1P//jUaEzl3P+0ure5xER+YPzVxn4O3sMhLZO6MY=;
	b=tSTd3O1aDXPald1u2ELVL1kEHcK2c/3RdkpS5FMccHqL44EScGrAVcFmQxlfcIZFO1Nknf
	YXIUzbWawFSAvmvUwQ9HqsoIcjul7jNz0xCXTkeyRGsxWyljBzIvwmY6JxN/iljNCfCyPU
	bCm62x7WMQBw4MHfnbdro2d3qy04dHY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AevVC2vY;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870812;
	b=Gsp/ZGUSZFh80l0ZYK/qQcBCQfHUdI1GPJ9QJTOJm5hkLAnNSXMVyAkD967ZdNAH/u6WiQ
	43AqZ76CEIXckZT28rG2n6oBNIScNUCE/9oam25uq7xdcWSJf6z4gVPegtlTxzNOQhr7jZ
	YYgWizSkPAR2/R91r/uhWeziOD+loqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 06515438E9;
	Tue,  8 Sep 2026 12:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA241F00A3E;
	Tue,  8 Sep 2026 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870810;
	bh=hla1P//jUaEzl3P+0ure5xER+YPzVxn4O3sMhLZO6MY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AevVC2vYlqeRlF6cI83qCWkkb/Xk+kt5DmpSYrlH2PtyWv3kClN/OkprMkq+HxD4W
	 DWXgxoSIm5BPAL//UdnIcj1P+nXmTsMNN+pQasd/G35uXjUnfdAxuTWEEqoc8lwbof
	 hVmPASre9In84kjcYFxAxom6kv8du7k02y8EzZFlgYobvnhAi5IF9CxlSiBtRP6Nk2
	 VIKeY0KydcPcpdHzsun2wCZM/FkybMpkTYsvwAD8gD254EhesuSgTo0pnORxmCjTbU
	 aWZ9ZpqdVR9ZjpSnAufX8KWXqpedY0x0cvueEAb5SX9RSDaZTSfYXGGEy88mV+3crj
	 SVZjp4RervkPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:11 +0100
Subject: [PATCH v2 02/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for most
 2-level architectures
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-2-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3562; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yQUOoL+4VfJjLW5MASkaQAQ+ZTfTJR7/6HJ0TBTi3s0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMETHLdPWOXJvzTKnYGmeBBnn0JXXlNLZGvQulOtYK
 eQdLk/sKGVhEONikBVTZHn+RXx/kEjYvM4L/m4wc1iZQIYwcHEKwERCVRn+aRepr2zf1bl754HV
 sb7Vrp3xcxVu/Yt/0fHGJP5JFYe3LsMfvolJJiuvnTzwzqZ4Jof8rGW85kXdYZJv7PxzQrUOZ7r
 zAwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DB7844000A
X-Stat-Signature: wsuom1iep16ce3r673khyuye5m7pwzzs
X-Rspam-User: 
X-HE-Tag: 1788870811-739594
X-HE-Meta: U2FsdGVkX1+0bqTJxRV+ZYA7eWZamwTrQYnzjqsFslRTLe1Sg2smjqFNYcT8PhN7+oQSPyTGUgXmV/ZNhJ8of2o1EzP/eh3EfGWUdZCrgwi6k6LFp0NDEzp+yWiplJIhP/WCzDtVVm0WqKkn7GS+yvrPeTgz6gnk0wIG+EU9D1I4EFJ9Jj4TlCCiaJw8We3qkqkRyBgr/Jxj1uxkGk3ZGm2Q6k5ww/4CThi5auhredo7uHdPk/D3U3JljF0naK4b/lL7W3vDSBOu+B00Jm1XUydDmz6nqOSQG77JCgZRy0T0faztXSB+SN33iM8suYDcGbizYU9/Jl4Ud40D+prj9Sckn/VcvlppFhyMpYmbm7JJO7sEne8/3+zHD91zxcibw+4j9EeykBUM8i/nI4ATaqP+fWH46ccSg/Vmy5i6ZNU7obUJilXgsdE/fkX+bmHMyXYb7tkNlrBrNIJ/Jk8KxkblQjJ46icsgD96l8FZWjilPopZM8DvV8lQqWobYPTpj0nLm2AVo6qHkAKChzqpF1DDCotk8yUpl63ijFXCf4fHN+scYK9itzrVvP/5rmySUuILrtANKdQiNzkgo+a4EIEA1aVk8jIaQDt7AeW6Dn3ikNdFuKHyAyeeQBoB/75c+MFtSQryFeqQcjZ8Z6sRXiFReCN9ztKXKqrGP44Qfp+ZumrnLYcVphtTUfxIH9Fa1vTNuG2psbYI9CExurM/oM/7F0hS+dANMQvBjeNl3atQpkel46IG3Rns0CGWD1Kht5PeSH5pNTm/k6HjW1NTyqsJ1xuDsjVTB7JOCtCAEZX+FemXf7FydsxZmeIzl9VLAIGd/QEODSKuujqMjrNmTAzf1kgMHekaTXsTB4Vy6nTyanR0viPh/yEsULULFYEJX3eAsADNd4977LsrwE1Cp1eusV42W2LenXwm11R8kjyCzkrBES/I47BmGlWjgcjBrRWuhKHuRTlaHUQCTO8
 bhCev+b6
 Kjcq4YehDbT88Ej4m1HN7hoa2T2TbT15dMAcb+HpJzPlGnIqXIpBEXU9yOONsutBrhhabjCeX6PMovx2Wky6IuL3ANme+7AoD4kRcv/h9A7RFBBEj5sR+vYCEuOHcJv/Cd5EmVOSsWlG8QXk3eA3uyfmuVwNE/1r6+DY6CPnya755Mbk+gN7sN+kvBmemWxZ5ScAomxxx7dFXPDuYxtLomgeKzGTYPQqKeXXPjvEq97qpyvIITbmkSD8UaM5XcSeHEuVLhFX2Ixz6RcfdX2x95RZL02Rf792llZ1rHQOxvbpxoFzGqvhmtaQOrPZHWL/AcpZGWAUamwrmWAgj/SNp3spJMrTPhlkTVUNigZcs7SCLElr/ZVrN8e5DqEzR0qV+oVdPovfATAFlSsYCfrEbXIBenW6Pm0sD8KXLiWXtmiG4M9qU5ailuVpIu4NkdNkAXmxxwTmo+/xPJh2TLNegh5ia4xPpNUMNJAr91P4wT0HglaYeZe0NdGMslrcAKCt98ON4c8stmiWCuJE=
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


