Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5616ACC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513AC6B0098; Tue, 13 Oct 2026 05:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAF46B0099; Tue, 13 Oct 2026 05:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9E16B009B; Tue, 13 Oct 2026 05:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B71D6B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:31:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2E242A03D5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:31:38 +0000 (UTC)
X-FDA: 85317085476.15.54B5E25
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 63551140005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:31:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="KFN/Jucf";
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791883896;
	b=Z5RaLDkhaf54EruCo6s97H2CmnmZRKeLNn4Z6sypfE0W2hkJ/7Nexq+3bMYOk+wo/QVTDU
	Zz26zwtfYY0qq4eW+m43B3rysCD5N+PMgKOM6ra5wbKUThaPt8jXLFcL8xi5gf5/C6BqjQ
	hKvm5sqW6txoj4Cv0ZSiUtXGZZKaphI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="KFN/Jucf";
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791883896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JCBX1egC6bBw3oj1mVsLxqtwizUOE619jquw8vTJ5Z0=;
	b=NIjEA1peVWShK677urAF9pIXZyK7EY1kxjTCPtHzEJX0mEgHDqTq+fMSVWot8do7J0d2MD
	zBuaXxblNKBnKkqnILWy60/AAFat50Qb1u+S3o0ZbV65SmJvaSRUyyky1w10uqII5k94UX
	4AGpCFvoznry7hgt6cbTua/YUpbiwHM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2FC98169C;
	Tue, 13 Oct 2026 02:31:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0B4C3F7B4;
	Tue, 13 Oct 2026 02:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791883895; bh=OqA21yJGURWr+fHR8OGWuJePl6Or9B4i9mUbbo2HePw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KFN/JucfaG6tVijFPqugjqklOhToK3tk/lGovkOGhrU5S8A/hBH3mHfEusBBzJPzJ
	 UyD1cF2qpgw4gHADM2nbeK6S2v6bJ9y95xpv4BpMzEMhH6fCnxZBlMCDLZgKWgQOFe
	 V1OvHKS+j9QazwgOeLl4Usk+vA/oFiPbdqVmRQz4=
Date: Tue, 13 Oct 2026 10:31:25 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: Re: [PATCH 00/21] mm: change behavior of pXdp_get()/pXd_page() in
 compile-time folded pgtable
Message-ID: <as36bbrMVHOESsLd@e129823.arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
X-Stat-Signature: gfbaw3kct6zpxx6q4w3xadran5aap5np
X-Rspamd-Queue-Id: 63551140005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791883896-307176
X-HE-Meta: U2FsdGVkX1/lvwaDnZgscEQgXPzAjx5wm7aHng5tz3I8i69jL3z2Ck7OHAHCVWLw7q5y7NEAAZDSTKGDlOrXUm2c0EC6iBX6jz3iR9Iz0m/X/lxcJR1l5bqa8wcuNekB97xWkMP+pDwK5a/IRnlc+0uuOf/Xo0Id4PepFxksQMrP5B9+WkVGNfPm3d0p6Foy68vGqgJKm+beLQIaUAEND1boi+Vkn/5UDeCCnpFbZc9PPGQPMBAbL+oixGUfDnRMdsPfvmbv8l3OfICwG8cL/ZzyUhnUGEyHFvuYW9FzhDwSoyMLP4vMaLF/hZoBQzRkhxT8Mz6Wrk4XjxubtZmr3Lxrvaau8dDlGpZjlgwdZFlvYI3qHbY3jhEU4MPKWADo4AAQwoewPeoH6YB8KQ5kFmuHBrwJZY4uQOtcKJhTiVu7WOoNz91aCQxlpEmXWUr/KLbrg8fLBeh1H0y/Kpb5jaAoOyp3SlViipK7pzYykqVs4lZ9+2UoQ2Stf1snH5UcjvXSK0W51r98MDVqXQpg7vunjyK2+OlVUUZ8e7kpdHK8sujZ19/twGTlC6FnAGZ1OWMD8lBPV9D9vy4UXGsBcdx+EY0rMC+eBTLQTDEoBsghOr99EbWHOCGM6ui7qx8BEiWo9j9eEe+NgytM5Xdv5JNv6gOL4CTTuknfnNIlKty9vkPXdFL6nHPAztI6cjGAijgaN6wKjAg+AfSkfZQnd+I4iwdacWuScqJH7Navsmt/KORBjzRifsawjRKTY05vHOT1JB/thRdqfecYr8KRaUbiZMdnxemP8B0BZTxw2Z8nfImLaRtgbopnro5fKTyvvRwutD5oRhfibl/c9N9QGomOUoRIyiA7Y2Zf4sRfJ1qchaG1O8nRob+/hzjF7v3P1EHgqIBnTck92CRlr9BBsQey2HJo5FaoKJbmokRF+IeuVGx4mqp1in4ChppBhLfllk4NDrqXaPJ2UJ0hnPA
 pjU2WuK5
 WiBOqOk1M+aZ7cBhhYhV29mc4Jaf4P8+pJoM4kH3Jawrrdl8WSVhwT863iSYxGlrn4WII0Vs0qnKpcuocwlFYI3Pbb9mtTsZcsD61SQmVMg3Mut92JQYi2BYQXcWK4Kz0K1HQrcY2AtYhyGUk2MW10eAnUC+osKTQ58cmhGR54DWO7YdRJIi63ephJOsJUR+Ve8SQfEKSBY7D/eNnrsKIg1IJg88wAflCUYyHmnVIaCQHh8CX1mp4Y8B15JcdK1T7LeQ9/0Y7b6o7Q8skXJeac2YMrx07JMMnUog8xGI8a+4rcokus1JGOHby8F7TJTnFBB022wK+shsjObJsuOdSe+SqwXmRa3bFyB6gHh0XMEvEfDhQh+J52VoB/p++iCPFlH7OB7bf/npmybEotNNuIWBF4MICpKp4kquDAIxb9wl+U7pAkGIL7+Ic5vTqHZ6vfMQU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

May I ask there are any further comments on this series?

Thanks!

> Using ptep_get() and its counterparts in common code is suboptimal on
> kernel configurations with generic compile-time folded page tables.
> By default, ptep_get() and its friends expands to READ_ONCE(),
> forcing the compiler to emit a load even when the value is not used afterwards.
> 
> This issue was recently reported by Christophe Leroy [1] for ppc32
> preventing futher code conversion to ptep_get()/pmdp_get()/... helper
> and the same behavior can also be observed on arm64 when built with
> 2- or 3-level page tables
> 
> e.g) perf_get_page_size() in arm64 with CONFIG_PGTABLE_LEVEL=3:
> 
> 00000000000052a0 <perf_get_page_size>:
>     ...
>     52dc: d53b4234     	mrs	x20, DAIF
>     52e0: d50343df     	msr	DAIFSet, #0x3
>     ...
>     52fc: d35e9a69     	ubfx	x9, x19, #30, #9        /* pud_offset_lockless() */
>     5300: f9403508     	ldr	x8, [x8, #0x68]
>     5304: f869790a     	ldr	x10, [x8, x9, lsl #3]   /* pudp_get() */
>     5308: f90007ea     	str	x10, [sp, #0x8]
>     530c: f8697908     	ldr	x8, [x8, x9, lsl #3]    /* pudp_get() */
>     ...
>     5360: 90000009     	adrp	x9, 0x5000 <perf_prepare_sample+0x548>
>     5364: 92746908     	and	x8, x8, #0x7ffffff000
>     5368: d3557675     	ubfx	x21, x19, #21, #9       /* pmd_offset_lockless() */
>     ...
>     5394: f8757ac8     	ldr	x8, [x22, x21, lsl #3]  /* pmdp_get() */
> 
> Though PGTABLE_LEVEL=3, since the pudp_get() still remain with
> READ_ONCE(), there's redundant load for the pud which is folded.
> 
> To prevent generating suboptimal code, make pXdp_get() return a dummy
> entry for compile-time folded page tables, make the helpers such as
> pXd_offset()/pXd_offset_lockless(), set_pXd() validate dummy entries
> at compile time to catch the wrong usage and prohibit calls to
> pXd_page() in pgtable-nopXd.h.
> 
> This series does not change the behaviour of existing code that directly
> manipulates folded page-table levels using set_pgd(), pgd_page_vaddr(), and
> related helpers. Those helpers continue to behave as before.
> 
> The new restrictions only apply to code that adopts the pXdp_get()-based
> access model for compile-time folded page tables.
> 
> As the pXdp_get() can return *dummy* entry, some of code using
> the stack value where saves the pXdp_get() could be a problematic:
> 
>   1. Passing address of stack value where saves the pXdp_get() result
>      to pXd_offset() for example:
> 
>        pud_t *pudp, pud;
>        pmd_t *pmdp;
> 
>        pud = pudp_get(pudp, address);
>        pmdp = pmd_offset(&pud, pud, address);
> 
>      (e.g. host_pfn_mapping_level() in loongarch).
> 
>   2. Using the pXdp_get() result to use as argument of pXd_val() and
>      to check prot without checking pgtable is folded.
>      for example, x86's effective_prot().
> 
>   3. Using set_pXd() with pXdp_get() will set problematic dummy entry
>      in folded page table like:
> 
>        set_pXd(pxdp, pXdp_get(pxdp_k));
> 
>   4. Using pgd_page_vaddr() to get the first-level pgtable.
>      passing dummy pxdp_get() for pgd_page_vaddr() will return wrong
>      address. Therefore, make pgd_page_vaddr() and pXd_pgtable() to
>      trigger the error for improper usage with folded dummy entry in the
>      generic compile-time folded pgtable.
> 
> Thanksfully, above cases are rare since (1) most of usage using
> pXd_offset() with result of upper pXd_offset(), (2) it's extreamely
> rare to use pXd_val() for non-leaf entry in the kernel,
> (3) is to handle the vmalloc_fault or set the first level of page table
> and (4) to setup early page table and etc.
> 
> Therefore, properly handle this uncommon and problematic pattern, and
> document the current design of compile-time folded page tables.
> 
> This patch is based on mm-unstable.
> 
> Future work
> ===========
>  - print_bad_page_map() and show_pte() still prints dummy values
>    instead of printing the same content for all generic compile-time
>    folded page tables. We might want to skip printing dummy values later.
> 
>  - We currently catch abuse of dummy values on the stack at compile-time by
>    relying on constant propagation by the compiler. Usama's work [3] on using
>    distinct types for sw vs. hw PTEs could help here as well."
> 
>  - Clean up vmalloc fault handling by synchronizing the vmalloc entry on
>    32-bit architectures. This code is almost identical across architectures.
> 
>  - Unfortunately, the current design of compile-time folded page tables appears
>    to be internally consistent but confusing. For example,
>    when CONFIG_PGTABLE_LEVELS is 2, p4d, pud, and pmd are expected to
>    be folded into pgd. However, the architecture code uses set_pmd()
>    to update the top-level page-table entry, even though it includes pgtable-nopmd.h.
> 
>    In the future, it would be good to eliminate this source of confusion,
>    possibly by treating all folded upper levels consistently as dummy wrappers
>    around the highest real page-table level:
> 
>          NOPGD
>    --> +------+           P4D
>        | ptr0 |-------> +------+           PUD
>        +------+         | ptr0 |-------> +-----+
>                         | ptr1 |-        | ptr | -------> ...
>                         | ptr2 | \       | ptr |
>                         | ptr3 |  \        ...
>                           ...      \
>                                     \        PUD
>                                      +----> +-----+
>                                             | ptr | -------> ...
>                                             | ptr |
>                                               ...
> 
> Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
> Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
> Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com
> 
> Patch History
> =============
> from RFC v3 to v1:
>   - Drop and rebase for CONFIG_X86_DIRECT_GBPAGES and use the Dave's
>     patch (https://lore.kernel.org/all/20260902194718.E1FF3041@davehans-spike.ostc.intel.com/)
>   - Link to RFC v3: https://lore.kernel.org/r/20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com
> 
> from RFC v2 to RFC v3:
>   - repasre commit message
>   - move ptdump_pgtable_first_level() into pgalloc.h
>   - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is disabled
>   - docuemtns compile-time folded page table
>   - drop the applied patch.
>   - Link to RFC v2: https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/
> 
> from RFC v1 to RFC v2:
>   - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
>     and add check whether they're called with dummy entry.
>   - Add some comment for returning first entry of pgd in arm with
>     2 pgtable-level
>   - Link to RFC v1: https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/
> 
> ---
> Dave Hansen (1):
>       x86/mm: Introduce helper for checking direct map 1G page support
> 
> David Hildenbrand (Arm) (13):
>       ARM: mm: make nommu pgd_t a scalar
>       ARM: mm: make 2-level pgd_t a scalar
>       ARM: mm: remove custom pgdp_get()
>       LoongArch: mm: define pud_leaf() only when PUD exists
>       MIPS: mm: define pud_leaf() only when PUD exists
>       mm/pgtable: define (pgd|p4d|pud)_leaf() for folded page tables
>       mm/pgtable: define (pgd|p4d|pud)_offset_lockless() for folded page tables
>       openrisc/pgtable: drop __pmd_offset()
>       mm/pgtable: optimize pmdp_get() and friends for folded pagetable levels
>       mm/pgtable: catch abuse of folded dummy pgd_t/p4d_t/pud_t
>       mm/pgtable: disallow calling (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
>       mm/pgtable: disallow calling folded set_pgd/set_p4d/set_pud with dummy
>       Documentation: mm: clarify behaviour of compile-time folded page tables
> 
> Yeoreum Yun (7):
>       mm: vmscan: remove stack copy address of pud/pmd pass in walk_pud/pmd_range()
>       loongarch: kvm: remove stack copy address of pXd in pXd_offset()
>       riscv: kvm: remove stack copy address of pXd in pXd_offset()
>       riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
>       mm/pgtable: redefine PGTABLE_LEVEL enum with ascend order from PGD
>       x86: mm: use pgtable_level enum in effective_prot_pXd()
>       x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
> 
>  Documentation/mm/page_tables.rst            | 84 +++++++++++++++++++++++++----
>  arch/arm/include/asm/page-nommu.h           |  4 +-
>  arch/arm/include/asm/pgtable-2level-types.h | 20 +++++--
>  arch/arm/include/asm/pgtable.h              |  2 -
>  arch/arm64/include/asm/pgtable.h            | 23 --------
>  arch/loongarch/include/asm/pgtable.h        |  2 +
>  arch/loongarch/kvm/mmu.c                    | 20 ++++---
>  arch/mips/include/asm/pgtable.h             |  2 +
>  arch/openrisc/include/asm/pgtable.h         |  3 --
>  arch/riscv/kvm/mmu.c                        | 20 ++++---
>  arch/riscv/mm/fault.c                       | 52 +++++++++++-------
>  arch/x86/include/asm/pgtable.h              | 14 +++++
>  arch/x86/kernel/cpu/common.c                |  2 +-
>  arch/x86/kernel/machine_kexec_64.c          |  2 +-
>  arch/x86/mm/dump_pagetables.c               | 18 ++++---
>  arch/x86/mm/init.c                          |  2 +-
>  arch/x86/mm/pat/set_memory.c                |  6 +--
>  include/asm-generic/pgtable-nop4d.h         | 54 +++++++++++++++----
>  include/asm-generic/pgtable-nopmd.h         | 54 +++++++++++++++----
>  include/asm-generic/pgtable-nopud.h         | 56 +++++++++++++++----
>  include/linux/pgtable.h                     | 69 +++++++++++++++++-------
>  mm/vmscan.c                                 |  4 +-
>  22 files changed, 371 insertions(+), 142 deletions(-)
> ---
> base-commit: 8d61431ed2607386b427752505379536eb634ce8
> change-id: 20260722-dummy_ptxp3-3741d78cc70f
> 
> Best regards,
> -- 
> Sincerely,
> Yeoreum Yun

-- 
Sincerely,
Yeoreum Yun

