Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9520EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EEF6B0098; Tue,  8 Sep 2026 08:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A154E6B0099; Tue,  8 Sep 2026 08:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C9C6B009B; Tue,  8 Sep 2026 08:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6565F6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:34:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 030381A0664
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:34:14 +0000 (UTC)
X-FDA: 85190537670.10.F84024F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2BBBDC0010
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:34:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuqqYtKR;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870853;
	b=7N9Y3fFI5kgpDUjfCdPPTd/9Fjf39ol+pQQFhto4WcOqOjWRSzBHnHJv4OYzRA0evB3Jl9
	i/6mYO7AGvuRk94TaRTupC7tV7ieGU3urJkPMiyyzIULe2REtx1My4vdvwZVPCeRQzSCZh
	VreF+yPSHUFpiszPEHGyJWrXZ7//pVQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuqqYtKR;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKPgtCS/jb8sy+IgthnzqZkszffWbth2i2OdMiXJ3aY=;
	b=oXmqFAljk7sKFuS8eZbqrlAgl5WFSUWw7RSHgeFgkB0BE9UYfC6E+J79wpf1+KfX9yWc2t
	w785Q1zcOAFYn1S0wkb97DtMqVrbn6BHcKAioknM5RDKvxqV+EXx6GqCtduhN0Nt9P2xwi
	w2T16gTwbj7dg6vdNCqiw5/geq0sloI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 744D2413BB;
	Tue,  8 Sep 2026 12:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3670E1F00A3A;
	Tue,  8 Sep 2026 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870852;
	bh=GKPgtCS/jb8sy+IgthnzqZkszffWbth2i2OdMiXJ3aY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DuqqYtKRdPkUbQ3eLpnItXmpl/72VGO8yGhYo744uTtDUn0nGYJRZapfPMEUVdfL+
	 YFEEtu10cYkLHxE7+T3K9S5ovSEx37Gd7dzfYUizdJ5E1L2ueuTFfaBJbMZlvapohh
	 QOe6TbYNem8upiIMMMqig/eplDM6abEOl/F7RmUK+ByCZpn1hsR9iuNyevNhiaN6P8
	 t2fJP4kb86eijV8rqQUqGnKX8JRCi6xMAxgaMoYzR2dBWXfSAGExXbVRWKzoeQLGqK
	 Qy6iKBzE5IpSqebmKX5sCtoCkNLAd/h0UshfsIVSlA5uA3slomiGV/qOi6N3YOqtB/
	 qCWVktRQFbhEQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 13:32:13 +0100
Subject: [PATCH v2 04/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU arm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-rcu-pagetable-freeing-v2-4-1f60b64e878e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1932; i=ljs@kernel.org;
 h=from:subject:message-id; bh=0gkFDBwGD1EYsdFXWdaAMN6hHbo1XQYIk0QvwnU2gCY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIWMETL7zpqoqQlfEtq6d99zG1V56Z3W8XPtDae8lz00
 yO9UhaFjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzkSSTD/2gvCyEPNz27AFV5
 l57E59WT72x9EJWqscNk/2EnrkWacQz/HYvuds+S7H/jHnKzKvv04Xu39pxfWpjCGbJhg4WfsGI
 ENwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BBBDC0010
X-Rspam-User: 
X-Stat-Signature: rg7uggctj4th8fj9hcwmw9fz63hx6yjx
X-HE-Tag: 1788870853-18404
X-HE-Meta: U2FsdGVkX187YQbawN0vu9iNzn2tGC4SfHuZSbDpimMTEFZ2x8SXSrT8jYw5PUdWUI/zAl77HBTdgoywHSzq+fwzSUbK/+gKzx1CgMgCqx39TjkOhpn8RpCofs1XhG8mcccQvxfiJJPw/VbwCQpBHQ8g89EpZLhxqQjcHxLYV8l6hKzRS7Z6j2xyMGbbkeIIiCfI4WZUPY3Bz43lAAtpCjCQ9q2ImgEGLUuspQtlcbOrsAIljds83AHQ/ALcaeKNfyzv1jqWqc9w8M86Lvlxe+5vfJ5C49Z7VhFQRI6KHN+qA/a8j60FSXiYKDZQkV/yKip1Gwv+w0GVxNW+nD8LWrVXs7B6tySKaEKou+f/iuU/H41I/H1KqW75N+x7IZD0qzqcv/xJvbHFSTTpyb02PsZycWKnKecI+xEXd3FNu8Tu6B8/gnlODQEU3z61OUh9ITMf/cOyF938ZOVI6+yhRhEnY9MV6S4NgZL7i2PFsyr5klV6+M3Yg/r+/PSl1HTibW/EykPFYWCKVroyo8I0ropBGlxuDIznIpTZVNUKF493p+RdntTdiTHpOJUB+s5jHeYZPOMgWZugQVZRKZdq+efR+Pdmft30bKtLIP2i3p5HWaszDUi0HqE5IiQQOYKfWNVSMlL6/9Z9IZL4OnXtpbyosqq2YcOChPZoxaI5DrSC4axN2KiUOcVcoKNNmz5zdbAEKkH7XdgkzSuMZ6KYq2F13+94jMjlsNVdbGKk7XJiaCQj3QWX8IKq/IegFhoeO62SwdaUSct9kIGXbhhr/pRpwNg67WRizGOJjC/rbZ0UN5gn3iDhbH7GQl8j1+fY9DHwZHexPFuBo492ATQ5Fgsfdpyhj25quVpxHFJc8qK9Myvmd84gx1DxmvEw96JCLZkdsa5g7TUHtgGGofhoZzoyiWMyBwPMacRk7gQlckNNA5owZ2NJp410cmdmdUc+37lVg/AImsntMbypPdk
 1EiAM9TX
 1vND56anmkdWZ0ChNhR+6TZLZt9fJz7r1FgVzNWIBDcq8CZXJFxACQTnM92/HB1Lf8ZfHk6QIx3DswUyxhtNJhJfznZEWlP1bbpGEnutMi5namNJ41nzIVPUY6ezOI6OVFAyrxl7/KpWl5LMWnH4xM7lDTHiZwpAG0aEFiAp5KEyWPrSHCAmHJdb/hMAME+mTAt0AT9AtZp+ymcDSToR450bjTHlCfB39vwM7c0FaF9UQbxRAUDeGiLaM0K/4KFRPwhSp9NbkIc1lkWsUaYyNTTLyVVxo5jr78dXxUP33LH/lgnVEnAgfa/qgnIQIdOVvR7+ZqFJRW+fDJShggp5upOjZyamB3eSOR+0fYeiQYyIqmvQolfDMWJFzT0iX870+afk3+DCVRRQR6bLoGm9NmC+qI5olefAv+8JaX8G2de1RowGErr9rLXw8MLHM/nyuDOP5sORiz5UYfI3zj52c5J+gcGZ7ipj3aeW1np59IY0YTNE=
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


