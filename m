Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2917ECD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 09:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7061F6B0005; Wed, 13 May 2026 05:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDA56B008A; Wed, 13 May 2026 05:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AFB6B008C; Wed, 13 May 2026 05:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 517976B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:39:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECE9D4076D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:39:32 +0000 (UTC)
X-FDA: 84761898984.01.F865570
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D35720005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:39:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldhuKbdq;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778665171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEGFWKjOqhgzGH/MA0MNwle+lypf2nUBTYyQwRxwPQY=;
	b=05dvzGEaVYNNuiBMUZu8FPMX9j8DNkkw01RBQP0RIRHWfp+kOGYCh7VobdHgIs5eYPRntM
	mFNZn41qsJ/FFEhv3aHAKBkAuHllS+IWWrz0oVGqw7/KzAKXXV+l9g49IVYi3qGiX25CD1
	J4xkBswEUvTajXZA/GHWlAwxtU3bMmU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldhuKbdq;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778665171; a=rsa-sha256;
	cv=none;
	b=dJCGC5bdvdNajzXOpT1neom4Ib0fUYZJoYwVN8cRZ9T7qLctZVbWRNUm/mI9GfhUXANuDg
	HwiLN6Q2PWJtAmOwgDLCwquurlNlJxB486V0BDXBWaZY5I/FOppToeoTp9x36T+puYRA9C
	z81jtFJDRW6fn+85JCQcNqKVPL8VOJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E335E439CF;
	Wed, 13 May 2026 09:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6410EC2BCB7;
	Wed, 13 May 2026 09:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778665169;
	bh=TcFQKIO6/vF+a3AYUGgIu/LGO27K1VGQqQ73DvAzV+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ldhuKbdqCzllph7J2oBe1tFll52xEIvi/X5XGIsQ9jlPH3V0+5FbslEKFvpvKUiey
	 HSKP1mujb09J9IRarHFIY+IvP8fHk1kSV3cbnMYwTayb3UO0mgP9sfcdRQntIkGUTu
	 8hAczgPHMmt8pRtF4EuoQhgN7nQeAdY1hvBLLOt7mrjk4pQLM6V3UWowNDtbhyBRjw
	 YCW00YAQABZgtqpqyraWAbwmBydtOYzf1m+oxQGD9sgkosK/znBBNIdMFnhh1kZInm
	 UG/vKw205xcei0CUxLtGjz5m1s4IYeEFwqoa9JVp50Qxbmoc9fsBf4bBFGgLVI7PCo
	 //3toDnC0mkUw==
Date: Wed, 13 May 2026 10:39:27 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC V2 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <agRF7FXwCvp4Ec3h@lucifer>
References: <20260513044547.4128549-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513044547.4128549-1-anshuman.khandual@arm.com>
X-Stat-Signature: xk9niyky9c5z7rjceoss8qaxdectebpi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0D35720005
X-Rspam-User: 
X-HE-Tag: 1778665170-250396
X-HE-Meta: U2FsdGVkX1/1ntLdumUK1HqhFc+J4xYC3RmgeHcTXe4MGaSdHLW/v2iLKjT4Xoy9Pi7o3dCalbfr0xGBOl8Fw8uU04eGWJ7uiYKXoR/CZQvi9uS6opmVOeyQTU3QRMWFVbmcZXKp7y6tf26EGCbzakWgeUXbahOy14YOF+GEZb5ycXzpleVrpphtVXj9L7dDqobKnxqBAn/fd8PFu4h1T+8C6vbBH8s7RqUsW9sWesJyKZ31tBnswX88DDT+u49SxaZStC3ktJ68F/o/lNPOZ0sKEcqOtyOt7iPZVfqADVEXEogt9uM1T62z3b0ZzRw7tm06M5+tQgLsrwVgWLIyu3XK6CBqnTYEZqCXBXItj0TgOWo4/j1o7CCOZvo9mVyLTkssZfotdiV2WKSN5PQA796lu0XWh0ZjLvmHFHpvMjyFhkbMZQrXI1JQmqopga5POmDNcmdwk2bIkV9J91UpcHFEjZglm4e6BzxPeYq4SEdBwgDS/Dqp4kWyiZ+/MedYkdwJM4FWq8M8+jUfp4Cm+qC0gIbgTHkdG4IvhJe/o4BkA4iHA8zZ7xNbWirxNIVfBI0jQVJ4yNVICiLe+b9txKnz+HSLokskh7AwWOJ6mUCgd9gBd7TU3xqmLPqLXs/eg6t/eGQnXuI1do0zrIRdrKcooyMbBrrukncJCzfqUsXqh2NFluvEPeQ2OR0QY/i+UH5qo1HN6ERAh+5sMsgcxkLLsQHu2fY9FC+UZ6AlakmHqgZY93aSEZL2edXJfC3tU7kxy5yIkeURSq6TRwHMA/c1aNhpfBpeEpwVoe+JJElAzfZzFjo1HplbSDTzFh7Ip7Ct+U8Q6nP55O7R+R3+DZdKVOLvQrFfHvNFg9C2Kk8eHlAwL4NzrnOs26cPR3YLUj0iy+jB9XpWNysqkJsSp5Hbg6l8blRc/1NmnrilGrx3V1Y5L4sOYp8V2gY5dx1SmrX1vBlV+3cg4yEI2ws
 m5s8RfIu
 hswgg8fRxwvOg02AmV0e4OLb1RLByD5tgXy2x3b60IWb20advY0lwGopky80qG9rFV/s8S1R4PNlVBzz0/moK2VXSbEYk88AadylZ5FTN1Ep0/50OojPSKSrv6NZeEs6wJwW3aPaeJZcs8b5BzY714OZF+H/4e0QPXO3bgOD8KX5upBnCncFb0GBxnms6syiEuMT5RFjtFBEMmqnOHN+J01WS1a4NMRO8Cx6K8uAbjAycJOS5rFeN7AnlPL9vgVszLjPOs2CX75N4JUOZi6H7jDd1AuNMaQc0Zdy5Iv0uIjN0iIdpPzrNRLPkT3+H4ELW3t6a61PSdHmvw07QZnBbmfkw9Dp8MA9fnyyc68K0onEkhjWxXPiTs1TVaeS3508WGUaAnxUynzTwxmkp79PC43kH/2koaZBGU7+u8jWFJBOjNyXZfoMcaRXMPs5rm2s1qf6KKjrMUMMqKWblXx/kIIQBAiBcwluVCSmk6wqBUJOO3Zetm3X4dzlSwD/8L3sI1OXFO8mtG1SqU0McABpkviZOjmGp4weXDYXT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc my previous kernel address

Hi Anshuman,

Sorry to be a pain, but I'm using ljs@kernel.org now for my kernel mail, so
I am at risk of missing stuff sent to my @oracle.com address (I changed
things around to make managing the... rather large quantities of mail I get
a bit easier :)

Hence I missed this previously, can you send future revisions to
ljs@kernel.org? Thanks!

Cheers, Lorenzo

On Wed, May 13, 2026 at 10:15:33AM +0530, Anshuman Khandual wrote:
> FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> So with this feature arm64 platforms could have two different translation
> systems, VMSAv8-64 and VMSAv9-128 could selectively be enabled.
>
> FEAT_D128 adds 128 bit page table entries, thus supporting larger physical
> and virtual address range while also expanding available room for more MMU
> management feature bits both for HW and SW.
>
> This series has been split into two parts. Generic MM changes followed by
> arm64 platform changes, finally enabling D128 with a new config ARM64_D128.
>
> READ_ONCE() on page table entries get routed via level specific pxdp_get()
> helpers which platforms could then override when required. These accessors
> on arm64 platform help in ensuring page table accesses are performed in an
> atomic manner while reading 128 bit page table entries.
>
> All ARM64_VA_BITS and ARM64_PA_BITS combinations for all page sizes are now
> supported both on D64 and D128 translation regimes. Although new 56 bits VA
> space is not yet supported. Similarly FEAT_D128 skip level is not supported
> currently.
>
> Basic page table geometry has also been changed with D128 as there are fewer
> entries per level. Please refer to the following table for leaf entry sizes.
>
>                     D64              D128
> ------------------------------------------------
> | PAGE_SIZE |   PMD  |  PUD  |   PMD  |   PUD  |
> -----------------------------|-----------------|
> |     4K    |    2M  |  1G   |    1M  |  256M  |
> |    16K    |   32M  | 64G   |   16M  |   16G  |
> |    64K    |  512M  |  4T   |  256M  |    1T  |
> ------------------------------------------------
>
>                          D64                        D128
> --------------------------------------------------------------------
> | PAGE_SIZE |   CONT_PTE  |  CONT_PMD  |   CONT_PTE  |   CONT_PMD  |
> --------------------------|------------|-------------|--------------
> |     4K    |     64K     |     32M    |     64K     |      16M    |
> |    16K    |      2M     |      1G    |      1M     |     256M    |
> |    64K    |      2M     |     16G    |      1M     |      16G    |
> --------------------------------------------------------------------
>
> From arm64 kernel features perspective KVM, KASAN and UNMAP_KERNEL_AT_EL0
> are currently not supported as well.
>
> This series applies on v7.1-rc3 and there are no apparent problems while
> running MM kselftests with and without CONFIG_ARM64_D128. Besides this has
> been built tested on other platform such as x86, powerpc, riscv, arm and
> s390 etc.
>
> Changes in RFC V2:
>
> - Dropped some patches that were merged upstream and rebased on v7.1-rc3
> - Moved pxdval_t definition inside generic page table header per Mike
> - Restored print format in __print_bad_page_map_pgtable() per Usama
> - Renamed __PRIpte as __PRIpxx per David
> - Dropped _once from pgprot_[read|write]() callbacks per Mike
> - Moved back all helpers back from arch/arm64/mm/mmu.c into the header
> - Renamed all ptdesc_ instances as pxxval_ instead
> - Moved arm64 pgtable header READ_ONCE() replacements later in the series
> - Updated commit message for the 5-level fixmap change per David
> - Updated ARM64_CONT_[PTE|PMD]_SHIFT both for 16K and 64K base pages
> - Added abstraction for tlbi_op
> - Adopted TLBIP implementation to recent TLB flush changes
> - Updated all commit messages as required and suggested
>
> Changes in RFC V1:
>
> https://lore.kernel.org/linux-arm-kernel/20260224051153.3150613-2-anshuman.khandual@arm.com/
>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Linu Cherian <linu.cherian@arm.com>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
>
> Anshuman Khandual (13):
>   mm: Abstract printing of pxd_val()
>   mm: Add read-write accessors for vm_page_prot
>   arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
>   arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
>   arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
>   arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
>   arm64/mm: Route all pgtable reads via pxxval_get()
>   arm64/mm: Route all pgtable writes via pxxval_set()
>   arm64/mm: Route all pgtable atomics to central helpers
>   arm64/mm: Abstract printing of pxd_val()
>   arm64/mm: Override read-write accessors for vm_page_prot
>   arm64/mm: Enable fixmap with 5 level page table
>   arm64/mm: Add initial support for FEAT_D128 page tables
>
> Linu Cherian (1):
>   arm64/mm: Add an abstraction level for tlbi_op
>
>  arch/arm64/Kconfig                     |  51 +++++++-
>  arch/arm64/Makefile                    |   4 +
>  arch/arm64/include/asm/assembler.h     |   4 +-
>  arch/arm64/include/asm/el2_setup.h     |   9 ++
>  arch/arm64/include/asm/pgtable-hwdef.h | 137 ++++++++++++++++++++
>  arch/arm64/include/asm/pgtable-prot.h  |  18 ++-
>  arch/arm64/include/asm/pgtable-types.h |  12 ++
>  arch/arm64/include/asm/pgtable.h       | 169 ++++++++++++++++++++-----
>  arch/arm64/include/asm/smp.h           |   1 +
>  arch/arm64/include/asm/tlbflush.h      | 138 ++++++++++++++------
>  arch/arm64/kernel/head.S               |  12 ++
>  arch/arm64/mm/fault.c                  |  20 +--
>  arch/arm64/mm/fixmap.c                 |  24 +++-
>  arch/arm64/mm/hugetlbpage.c            |  10 +-
>  arch/arm64/mm/kasan_init.c             |  14 +-
>  arch/arm64/mm/mmu.c                    |  65 +++++-----
>  arch/arm64/mm/pageattr.c               |   8 +-
>  arch/arm64/mm/proc.S                   |  25 +++-
>  arch/arm64/mm/trans_pgd.c              |  14 +-
>  include/linux/pgtable.h                |  25 ++++
>  mm/huge_memory.c                       |   4 +-
>  mm/memory.c                            |  25 ++--
>  mm/migrate.c                           |   2 +-
>  mm/mmap.c                              |   2 +-
>  24 files changed, 624 insertions(+), 169 deletions(-)
>
> --
> 2.43.0
>

