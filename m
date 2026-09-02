Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25A6BC624D5
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E506B00A4; Wed,  2 Sep 2026 07:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D361A6B00A5; Wed,  2 Sep 2026 07:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CD36B00A6; Wed,  2 Sep 2026 07:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 932A56B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:57:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BF58401A9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:46 +0000 (UTC)
X-FDA: 85168672932.14.E897E97
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 471EC1C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vq+BgO/b";
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350264;
	b=r5rtPplFeHwtwuRJ8zDRipbWKHacuzsx5RgjEVSPKQRzH65/TqRljXYpRQAS+at3NouAai
	OaOmnnA68msJGYf+XP/lj0Yx/EVTE0v1IXKckm2Q7w5KcPyQ9VlhEZSfNK1KAAYVYskAJz
	0ZFGuPG1wyBcI0mi1hSpbLaJEAmtfA8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Vq+BgO/b";
	spf=pass (imf20.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ja9vS1zyX5lOQ7MqnAcgWic5BN5b3aNx9enNPX89F2k=;
	b=SWSuHPoEsMpkdlluzpvRxleS9EY8/GiTCi7GqhiLMnVqD4FjU9F59RDjQoYADCThUxNg/A
	Kn/N8jZBcuQQ6RoixFb+WwZ/dL3p/4HjI9y2KsOYscNyVkZlyLfMQPz8jBDD3gyBZ9hV7M
	NOW/qdSkGOR2QVpI4KkfDvEBdFUu2sI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA2151682;
	Wed,  2 Sep 2026 04:57:39 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4280E3F85F;
	Wed,  2 Sep 2026 04:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350263; bh=0PR5oXIOKKN44EvqTmmgCdRAk0g+3zRMhCuigLr45iw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Vq+BgO/b9aFK8A71JXNvBNBhfYac165FZEWsOyfDio4LQR5ETa+QDbn0KiaPLujHS
	 uLoEkmt86nlYEJy4d97XbCJa5a/RrJAqeUxW3ZxGdtC9wL7x8/PwJ1wvuq/GRns9N7
	 Th6snsDoMGFDvih9v1FYFDzHDNdr4HPtcJY6+7u4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:11 +0100
Subject: [PATCH RFC v3 09/21] loongarch: kvm: remove stack copy address of
 pXd in pXd_offset()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-9-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2050; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=0PR5oXIOKKN44EvqTmmgCdRAk0g+3zRMhCuigLr45iw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7mEvNM+bOE9I/iEnGFs4yU/Cp4f0fN/0Ksu
 pte4JObv3SJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5gAKCRBt1cPRWsUx
 MyqUDACMb1+lsAjXkT07U7jCymAJfazCLi+GO5DlCm+D+flCqcZOXldliTBCwRmzRj4Jqg7Lg38
 AJyICWYXb6otlnlJHMXfPDwZu9oriA6Q74Im7EbN1oi2lrxIO9QuzLqZq9nopqL5fdnCkTBhLrY
 LFbHTE9MMndjLMFADqfDsab4Esti4VfIpOU4zi3bRjfsrOW/Jo38w74rDrf6jIb6m06O5nKgY26
 HUTG0A4hPkfkb16/8WvbC8Vx6of/7JJcOrFXcWSLZyFse+khfKtKwgfYvv0+thlQW4xRckUBLOQ
 pCH/6ZzZ187+fClXG1Fd5ju+Cgwx8GJCKMzTd6LZHMDPjzeYPM/QGHiTnBdi1v7i7Go1hTjtNtS
 8xasNcaQ1mXrOPnuCYwf7yA4NDpzHk9ZqcO7oLb0fPGbHL+wRNcJglW9vAmoSFXEhlaV5BIFfOC
 gqUa2a8dnHBQjWCVTTuiYqmSxJ6hfeym+A4VgyETaZD+WU4xI6McKP5byVyCs1DTCNe6Y=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: o4cn5jgsxzk8adgotd7wnr3orutiy9nx
X-Rspamd-Queue-Id: 471EC1C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788350264-85316
X-HE-Meta: U2FsdGVkX1+2zAavALV7lYRm9mO/htnTfpSyIPVxW5e1r9502KZrJIUFlRTFDFTzGYgspY12F1OCMDu4cylBO4ihG0zCLk64FZY3JSREeQjcjn/67O2J0taeYv1nitf9K71JL0mjYXcT0V7apyVCOHIpc1sRMPtGRN2Upk5qmyssFHfv/0DkUqa0DBJGakU0tSgHtDFKHZRbNn3gFCkaiIpQuF/q429XozicqHiCafyEA81HhsxjQaTkjCjC6Aa2v6EMg+kOBfTsWCrsffAkTD58wDunA2aDGtNcShVoXZEwxM8ISwGWCCYc7b7azT5DPt73khmaYQJOU3xr576B+iGAK9vR6/wenvqw+yVE1eBkXZVrw7Rjn2b66w+0QkqCUdDT6wbTbqslLNTwpounk9zgyHaqTMyPgCTkrArzblszayAvi7RS80wMO21OJGB1Ox3vj0CHYwiiRLx1tmq6762CMRhp1MYFyIDQCMcLDttBZ1fIM/0Bzf3cTph/qLJTuzQlgOACwLgtfj/NUxUP9Qt1Wkjzbg3A17ifP8aU9qnjwpTFjT0Ik2WjL/NKYJ1HuHnvDR/jfHQR44XcS+vyRVYBlbIdBpPCMDqloa6+0pDfQiqsh77qBD80D1A4XwqL8gMUn8hqQZN5uJT6kUAoSGqTEKlccOVCCFbJIaeYLL1ajtsUM0bumrGin5T3YknsnxILfbV8QOcy8MuMYveK/pKLI/EIOk50Jn3qdMgtCvd6AdtMnAlGbMnps5L2aBYxA1r9ZWNWGeadGLsbLsVDMpQw54vVssVmAymzX28iKFtaHXVFn+/j+K4Og/NjX5cEG2P6HGIqbvSPVnvlOosTWuaBktS3z4X5EXHfpURZJJ3omKOvDOB0/tnvqjgFjoxa+ZZvFxO3Roeq8UuL4P0xVOQd4aTnT5lim7+5bDExeP+omf9sxd28KYkLqx3wgHBzs7pde4JXiDLArjzVbrx
 7SlDFSvT
 TXn3j/9sZ9THZJXmBoaV3GTqaZPF7emCkJCg26S/vCErgO+sGQLeoqDvJXU65WTAcVIALeTmgtr26SfWJYaDDVkReSC+yp8mHhmPU+ojK9ilUVh1iHBPH9cq5JCVM8zKehdD3B7bzrkSpcDpSQssiaDkPJ/kSYUVZCqKbH9K5WRPJanqxPPRa/TVH7DNDNiAt4+x2FD6lJ1yg4orxvBL+GsCEiNIEM6G4qdTdEInPgTy567lWpYc1xWSBPN0dxiOXK27hoVKONrXmL3VmJ2QRCGsGS95Z54D/UGmi/z5f40tdSee++dTvPffUTMKsk86ghQ6nPIQf8sNwtLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that,  rework host_pfn_mapping_level() to avoid
use of a stack copy of a pXd and pass it as argument to pXd_offset() so that
the folded entries value is ignored.

Replace direct uses of stack-based pXd values with pXd_offset_lockless().
And there should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/loongarch/kvm/mmu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index e104897aa532..837b40bb694f 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -669,10 +669,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	int level = 0;
 	unsigned long hva;
 	unsigned long flags;
-	pgd_t pgd;
-	p4d_t p4d;
-	pud_t pud;
-	pmd_t pmd;
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	/*
 	 * Note, using the already-retrieved memslot and __gfn_to_hva_memslot()
@@ -698,19 +698,23 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
 	 * value) and then p*d_offset() walks into the target huge page instead
 	 * of the old page table (sees the new value).
 	 */
-	pgd = pgdp_get(pgd_offset(kvm->mm, hva));
+	pgdp = pgd_offset(kvm->mm, hva);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		goto out;
 
-	p4d = p4dp_get(p4d_offset(&pgd, hva));
+	p4dp = p4d_offset_lockless(pgdp, pgd, hva);
+	p4d = p4dp_get(p4dp);
 	if (p4d_none(p4d) || !p4d_present(p4d))
 		goto out;
 
-	pud = pudp_get(pud_offset(&p4d, hva));
+	pudp = pud_offset_lockless(p4dp, p4d, hva);
+	pud = pudp_get(pudp);
 	if (pud_none(pud) || !pud_present(pud))
 		goto out;
 
-	pmd = pmdp_get(pmd_offset(&pud, hva));
+	pmdp = pmd_offset_lockless(pudp, pud, hva);
+	pmd = pmdp_get(pmdp);
 	if (pmd_none(pmd) || !pmd_present(pmd))
 		goto out;
 

-- 
2.43.0


