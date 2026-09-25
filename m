Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B070C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85C046B0093; Fri, 25 Sep 2026 16:11:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D7A6B0095; Fri, 25 Sep 2026 16:11:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723C46B0096; Fri, 25 Sep 2026 16:11:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8136B0093
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:11:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA8F5C01E4
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:12 +0000 (UTC)
X-FDA: 85253378784.26.351DD3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1AD0180007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:11:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8UJmm7p;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lsrlmf7v5nCsCp9lrKYfF9bdcfcXWf42nvaUj+XcLIg=;
	b=bBbo1s9rFuRvoAncwO4blFXF5xeLs27O5J4FN8IN5SIkNmyd/IZsiCKVrSiyuMBV+EGUN7
	4MQwhX+xUUTRcwBBE113nSjsdn8PFEhdIbp62kgoSY0ScHM1sOhYgIN6Fzxu/PEKCiDxxW
	0e8pjzL/c1uNJhB9FHofYddk5vhr3HQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367071;
	b=UP8EMinw4Qc3v0BPwSB9CobTor4Yc9GkpJzB6Qh6l0n0NhqtBVfylvnlwBqV3VXNHiUiSn
	Nj8sM/z2m2HwTSmNThzRjxyOE8uYXCf44fP2k3omChKSugzCGpbvMbMmq8WPtOA7jILOPR
	ydeu020ypcpI6utMxlLNArcnJDePpQU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U8UJmm7p;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E0E360252;
	Fri, 25 Sep 2026 20:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C481F0089A;
	Fri, 25 Sep 2026 20:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367069;
	bh=Lsrlmf7v5nCsCp9lrKYfF9bdcfcXWf42nvaUj+XcLIg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U8UJmm7pglQHzK2m7NYuzhD9H/YfDWIyUj0xlbhGFARAo8MWtDA0R1dpdXhIu+3Ig
	 xCJ7gJK/lZHNIvkG2zOwewDunu3otxOat+vkn9BPCyDViD/xlr5Qr4kWFj1vNEaNhL
	 /vXJle7OPMfWncLa286ZIkiR9bO/gH6J9YrPNkdLRA0WyNetz8tRM9CAjhp6ZqKBKj
	 /GONQcGMV6S6ol2Yct9gBPebiGkMz4y6Gu/XV7WLhq3lslZZ8IGEkmTqh21DfuH4PK
	 hTD7Yar0NxieT7fqrqh4nULWIUIYJOGQJ5d2VCdzVAeAJJxtpWEknK/STlBLjkJ62/
	 7f/pNVN72jzMw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:38 +0100
Subject: [PATCH v5 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-3-31e91065fea4@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1692; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p4MqFQ1gZwbbEnClOrxinYCiAn7T0hfTpb79XEVMHgU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWXTtM9RPrNVMeHyl7KoBJszDRrnnb+dUe6ZfvTkx
 gKH4IUiHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIawQjQ2/TpbeT7K+If9hb
 vSet9HBiU98CbiXG+Q9PVlkJ/D5+P4Lhr+jdwJ5Pzv8OXWb9e0JX8UzLD+fU0o3ef55decOtf8X
 wOy8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: o8km5wrjpqiqueras1spewrb5qfgh77p
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1AD0180007
X-HE-Tag: 1790367070-805080
X-HE-Meta: U2FsdGVkX18+RPu8Gr9da12BZ5KQ9y7G0+aPvKRI3UWuP5q3y+wxtYiPdu0lpk9ZGdSP43Z5KgBzYOIjvScgIvRhvdAcQi3DOri9GQI7MnKUcY58ndvExgiBKpXdcdrSXzww5vQxR4PRfdV0pZSKuqkRXHFUgi29nnhU1xouG5DfCF2K28LNbdtPcqEG5g1PDtMaLrW36Xvf8APBznKnOLwblQ803JCXHyUEnvREnxGDFapfxtEL6SMrbd0ClQ6duJPQaTyJBYcAEMBXj0a/tFix5KQU8Peo+XwIeIlNZkn7FUNRk4UIIkeYSGGPT6vowAlIPJ9DY+JXHeEez4u5F2PyoAf2Lcz+7nXUOcL2TZMzY4o4HZKax8U6LWeXJr4Z7cF3GK55tiLFMaX+FBqQb1hOaaKYvslrb1ooQntwcM1mvlB7vZJueYf4aJEQATQPGua8Aaesxstf5sgOlAp8m7O2kqtwpc5PY3j1pDJBSIfubSB1cNRBsg8Hg9B6btR8BbIHZynSrOFx76bFwMKYMkYlXtfpzT2/uWdn8wcfaeHY+d8Epc5IpduWHW7b3UoafiJzhGHb68x9rlY+59dH2AQHfzkgVzzlBXkZigBtA645R8Fm+qtviDRWPi0JDYT9aZMX7HP51Euy7VUCSsYbGWfA91/HZTLEWYyrof7NcM735DonmcUeM2eCrDgoh1fnH+edU9jm+awJnO7NMcUY404O8lkSGuCXDNJ+zxb8HIPURI2r8sSnOOeY1eoM/h3O/crx9ysd/bLF6QrJTz+rDKgqydz4Y78byNklzgmDoZ4bnYZvSvmuYiLgIDrB86T9GbUvV9GTIRuzDCAi5KD4Nfs14gWXM3QpC5f8i6aA785kQgaMvEx2KzSrpCvtQgS5mxmLty4fGJh1rOJVC9aks19thljk5jN8r0rPbvZSfnah9XlciKW+Egj0vaarp3Qm02gSZ7go7Krw2mDgMzZ
 vc2MGxA6
 oR01Vl9v8AYvhKWqOjcOto6LST0lyHdIF6D8hBAnfWCf3OUQKAo7dV0aGhpvBy3XKsO0bV04ZVPBsSFb4B7b8kj/ICbZWRc5LOmIoO+K5+hQemBEULmdBohbYkPmrqWHp2MOyJ6PxNKIx93icFveGrCSJVC7I2vi4GTReIj07HtJb2XJ3kcnxrR8gu7Vd1pKG34gWZZiShyhQdYMWMSvcvbt4PtK9t4M8pXPG2d+aOjXertdzWTzEcm9+uT/032CTrC6/fkL2s9dvJIv/bDaEKu1hNe0SAQuVH+if1uCEnlLYcVNFQq4xdSzH5I75/BHeq3COP9W+Q3mqZ6Mx5CcC2G+sOZPURVu1ZGfovdJGAjoevhDvvezqLkDypFUElKcwSZCnHu1aiQefdhDt0inOQQ/JPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
CONFIG_MMU.

Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
riscv builds.

This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
is enabled if CONFIG_MMU is enabled).

Naturally a single core system does not encounter issues with software page
table walkers being correctly synchronised across cores, as there is only a
single core.

However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
a future RCU-only page table walker, this guarantee is required to prevent
concurrent page table teardown.

All page table freeing is already done via tlb_remove_ptdesc() so the
conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 505eed4af932..3529ed1861ce 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -208,7 +208,7 @@ config RISCV
 	select IRQ_FORCED_THREADING
 	select KASAN_VMALLOC if KASAN
 	select LOCK_MM_AND_FIND_VMA
-	select MMU_GATHER_RCU_TABLE_FREE if SMP && MMU
+	select MMU_GATHER_RCU_TABLE_FREE if MMU
 	select MODULES_USE_ELF_RELA if MODULES
 	select OF
 	select OF_EARLY_FLATTREE

-- 
2.55.0


