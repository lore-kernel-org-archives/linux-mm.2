Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 907F0C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D66D6B0134; Tue,  1 Sep 2026 07:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADDB6B0136; Tue,  1 Sep 2026 07:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4276B0137; Tue,  1 Sep 2026 07:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56C996B0134
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:06:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2694A0224
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:06:17 +0000 (UTC)
X-FDA: 85164914394.15.EF0E9C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25505C000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:06:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiowDP1j;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKPgtCS/jb8sy+IgthnzqZkszffWbth2i2OdMiXJ3aY=;
	b=BJlbuBeLu0cV56juVognpaJRXtoddh7RZ5mnckwQ4V9duX87lZ7Z9p5CpoClc8CQ1YTNDN
	WvDPJ2FI0B1XdYmf1X/8qoUqfJxF87zBpqcKFT8YrWx5yxcTDpUHy8e1zW/aC6AmdjOlmQ
	2SneUzSX23AyrgFTeTTpBCx3oNmuaJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260776;
	b=FybmuwSxuJxlBSpBdwd2cJxcGjWQuVJl7t5Hx6nj/BSjllbUqTUgiLLX+jaN7GO2vCEdGF
	GkSjPWT/+WGviRwmRmajqfQBtpDGM1KTjjKmwzUA/vCO5xuv8aS+K33XiZUUxVVhp6rhIW
	3mT1ezE1oWMLRAFma//2MfsNMQOaQv4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiowDP1j;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DDA642A77;
	Tue,  1 Sep 2026 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F261F01562;
	Tue,  1 Sep 2026 11:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260773;
	bh=GKPgtCS/jb8sy+IgthnzqZkszffWbth2i2OdMiXJ3aY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DiowDP1j1n5XlCF8U1bsHtuzN012sie75SVdXyIWaQX437ODGamaG8+dyw2U9ubLP
	 ZQuORqY84alF4o7Xnb9l4E4w9MY0R9kv4cXPesYKeaO21X9V5t1J9jM6t8FOU6ikuy
	 rwHNDo3oeWAPjqIeVWVsIP66njOhb+rnrhF3SVDfAj2sWhOXfEfEEsQfd1FnSFpSUT
	 7uyG08SrjLIgMgvGh2sqL3JbG7jtin7/mj29pE9PwuRoAAnOkJ79fImd5f8RrCs6l7
	 tyJFWeHJO81hWqDF+lZHR5ixipFciKy/9qPugDinCxm3vBNAzeRoHStXE0TrxYkfq2
	 AJel7eEB7e32g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:24 +0100
Subject: [PATCH 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-4-5456a81c8212@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1932; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0gkFDBwGD1EYsdFXWdaAMN6hHbo1XQYIk0QvwnU2gCY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbXQPjFVa63kgYD1nwDd5n/U/J56e/Sds1bv1xqzfk
 k9/K/rI01HKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJyKUzMjyZJ/zbXOdUdfG3
 3lVZP8s03GYsefForppMeeA6s8AHPWsYGfYrl/n48ql+/h54kiNrev6UD/E3dxdvOxkQbW9aLfz
 amBcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25505C000C
X-Stat-Signature: jypqnxyyido6cam3u9wzeijceuxj1gc1
X-HE-Tag: 1788260775-849323
X-HE-Meta: U2FsdGVkX19yq+B+dAHe+MwNK+vq/WQvxXznhFGb7H+AqurB+JpwkYDotbdDjCqiT+caXGc7yXzmc/QuTNXnuXXZLxB/Me/keFFpsGBF/btFRTs9JTsZ2fsB7CbDvLPDCgeN3rIulJj2cIWhxoAgeGXDNzolRN+8RW+fyuTcLq7Kp1zmF6gidFkoRDO8FV/BAhMgkbQLmu8weGC6KA4hNud8DG9Nli6w082Mu/PuNha0NvNOIfvidBkX74X8sjOHPinWnAKxwIwTBttfGbWAN+PkN3cjkJDnLg1zUrhfQWIjLeJHHH+Lby9/E9JA9wEa9GRuWBWDVhMHCIk7pwpdSv3+OuXSJBke5b20nOmF+HGlQc6ZxAMYgR3ZG5vkRMGEcZwTNUMtQpjcxfC5b0lQs7X3mpp48hMNVR5sEEisTdemB2GoJ0/eWOcbkPqNe1faAcnpFwJ63g1XjmFkueKWBfd6p7GTyYevfPe2ODOg9Ea3PNDRiJVUYqjwq82L/YyfTq24DIsk2dx1ACboAMHhNxVKK/M/EZi+M90MVtOVyTnf8muZnPWsG2gpus6n9Va1fGv/nM87D7IZ0m/fIYued/1Jn/U7/3YBFg2AXqCPGJVpUj1q6VWFT8fCpPCyTiDb8HjzHkYBZLHy5vhHpHqsqouNJc156dIxLTlf4AzbtaQ0AsyyPJcQ2z9RbM4Z4dDfCX8F/DBs2/XiBmwn0myS1tauKvudDxOE2ISKSVyZLRHMeG/2j7TQUgGT/Fpdp3Yx2Ttn7Abga5KKjyJFqjcumYeKnr9JoQvzBm7P67U9I35m/E6qfY9feGPpvGwCh+2VwPJFwYxjv9qp5pwljU6Yy3+PavvLFfc6fkx2BJ6s74l17fzm1xg6SRgU3WhrDZeTh1GyX4C5E3ylHfgduWKNDfSzg+hGthMSGLUl0H862xm1aZc4He1vKoUexeoyYTgxB2cahT4dqhUzFXAgc9D
 PQTP7odL
 iC1c9Nta29s2l3140xgsWiLQSgrMn2C1f0jqkt/yNak+h3DOfP9I/9LgM8/QI1qtG0Gr1uVA3MBQA+pj7mkSGAhkdSZUnzem+3GrBVQVuwF4Lc+gXqBBYUqQjeVPDCTSdZML5a4nvlett6fumesS7QwveufZybKGJnDLodgkaaXX1c7vf7GBf/8SSZ5kEELyRAQOsnXJ2rtyuX3HX4vVt+r92OeGNSIPOeCEoLYk3hzB4rIu0PbxbGEgUJPAoF1qMLFpszlnhDfd146vJh+Qf0sfEs9rvXlHVew4WZgQ8ZRQD7x4s9cpBPUoFdoXHnJb0xr+1iPudAlaEzbEwn4wKAuvP26ZX4DMKNkEdnn7JJHOhxNc=
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


