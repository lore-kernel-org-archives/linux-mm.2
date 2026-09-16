Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C923C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88CB6B0088; Wed, 16 Sep 2026 04:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A026B008C; Wed, 16 Sep 2026 04:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28716B0092; Wed, 16 Sep 2026 04:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0526B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:25:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB5431A0652
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:09 +0000 (UTC)
X-FDA: 85218940338.01.69DCF8A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id B38BF1C0008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:25:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JybzSzpK;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789547108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0/ExufXLQkM/VUrnZKcILBmaq2g7txcHCnODnQ0xzw=;
	b=11diy/epAoLoQ8lBG5xw5whtNVJVRT39MGLpBrrxZQL1xFrBBMS5cFO4jR3BaoedzwTFz2
	aK+GuMMSLNZ81ou0sry0SJ9bOF2i1hJyLV9hopRPYl+0bZXzpY5pkLXY4stbGHtEM7GI5o
	46jsS6ULTgiG1iC+sfra+0rGtRgAdLU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JybzSzpK;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789547108;
	b=0Sm4cEugmkN9h2Hm28Y+2FDQGOPqtCLlisBYSclq8ow7B5j9n3BYMHKy9ZmU+IiTYwXzca
	5ysUt80y3zRZOe/U4hUhg3NxtA99lk6sxKmC+hnzQ8S9gHCexVxF6fhPohEuPCKYCQMgXq
	2QiNr11mlq8/w4L4u+WVLcrstruJMdQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E6BC7176A;
	Wed, 16 Sep 2026 01:25:02 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CB9F3F882;
	Wed, 16 Sep 2026 01:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789547106; bh=/8itoCy2uuAdT2BRbZBqwKTAhTZbp5WyzRD+XEeprJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JybzSzpKsBXyl5ejDpbE5Lnvl5rgBgnIjwZqLVkpg80e2fZA0FHiqFmVFqCsHggez
	 D/2HtVhTxYvpa7MlJ137x509omi1Bd/DX1rZ/NzmDZOfKOhGAxp3hQgdQFFWlUD47k
	 F4i8xjR5OAGGBPPH7W2sg/6d2c3BHgDuGy75hXg4=
Date: Wed, 16 Sep 2026 09:24:56 +0100
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
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH RFC v3 00/21] mm: change behavior of
 pXdp_get()/pXd_page() in compile-time folded pgtable
Message-ID: <aqpSWIp_YrLPKBBp@e129823.arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B38BF1C0008
X-Stat-Signature: nqzr7zswkzxb5a9un5oq8eh8464biioa
X-Rspam-User: 
X-HE-Tag: 1789547107-300618
X-HE-Meta: U2FsdGVkX19AAJx1j+mbz03zChe5h0wjmtw3PyT3AvI123VOV9c/IU8i2GxR1/w72xbTNJ/yPSgW4Yf4xLiNIZFJIH/6dGEm80cmIlgXRFYV7JIRg6M8ITat5PGthwsdoKALUSVUzDTYzi+LrViFVi5J2R8AifbLEnZowJFgu3jSyenInZbNpyUkmDhD5m/ywo+R6xEHDxjonLnFLjXdzf4VdgtS/KOkuWvrb3ELYaZQXEN9fHS7vjkM2VCK2UsmUuaes13tT8OPLF8I4YZRjF5kdkbWFj31ia5aq5TmevlKAA+3mUbJW3BnUJhwQyWKo2IFr97iP0MKkXZT6v5AusWmQWaha17W7t0V7ZYYrDtI7L69rjGaQQgn8OagOspSE9JM9JJ8dDRfLAYoraNrKP2WXs7sSG/PNW7sZaaYw4GdH+eNZGDS5+/lZ2D68qYULs8bRYuQ1LAkLGAUjk9ksLigpiYkPEeLLeANq51HXwN8XXv22tFoW8vZ6Um0i79QUKzb9ZQZfMzszKpLHsXqXHdlihehsduBIRULevIMkTJH/gS7XZMz2WL79wnpk1XYsXua4DzQCM3bYWt6pNhlIwyXZm9TxOEb31qfys3SsMIk8q3tdUo5R+nmzZ6Rid689lmC27ZhsN/lkMNOfLg1Jqs4cMl9sne6vNCYlhcqvKWacuJjvkAstynWLrBmnBUGrxKGQHoxJAocnoFKgL08HD1Vi9xTSMXb7lpiC/WGoPVHIYPuLrixn1ZGhWi5C+NJqqzbrjWBOrz7XIZKhIDmTNf+iWFv6JMIx6xTSgyPDpcAbynl+NTx5lGA+2oW78e9O+n0RLJNGsY2rItC67bkjPXH9cSmDnHxQH70C/1basW2S5121jkTKKbF9ZJMa0bMajs+FVxDb2Y4Hslhb6cxWwPgADSu1b7aeiCiZSrAwGA4DjNRq2jXUx2IQBH/zNwq+qHY16yCVxOgYcQL2cd
 V5qto89U
 QiJcDpsOogdvw7fNbOj1SMfVkFsFkBp/bVVhxdUQNjw8dbk5HxYecNJqyE8CYGHtNi+uAnts3MAfAHjYIgtAJau11pnGVx9YovL/nn9ASMPq3IUy4Ff7ekzvI99JhpGQ1vB+I6RaKb8dX+pxZVbqvpnyu+zo0TUI26CtSjI2vv7UGKiLhXggrzGTawovK3eR58NnmSigRLt4/Ll906Q7tmvPMmY4zIl6KLQTSN0r3NQ2iicDtAa/THw935HgKoQeu1SWUO+Lw39lZVGpWVefWq72YUsLw1RZkXx1HZyKM1JMbK3mOSMNg2CkxBjroYQD2zSvDQOAeyiZSs5pIFcGWgiH3gOFaMjsYS3pj4ReagHHur4d1wEJ9O32bhJp1/9xGdUCCjEOFrRaLuZg5e4yNyy2WXI3TuZ1T8J05dZrMD9lpO4jFS0Oj5zrR7KrmVOsVyltf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Are there any further comments on this series?
If not, I’ll post the series without the RFC tag sometime next week :)

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
> Patch History
> =============
> from v2 to v3:
>   - repasre commit message
>   - move ptdump_pgtable_first_level() into pgalloc.h
>   - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is disabled
>   - docuemtns compile-time folded page table
>   - drop the applied patch.
>   - https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/
> 
> from v1 to v2:
>   - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
>     and add check whether they're called with dummy entry.
>   - Add some comment for returning first entry of pgd in arm with
>     2 pgtable-level
>   - https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/
> 
> Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
> Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
> Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com
> ---
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
> Yeoreum Yun (8):
>       mm: vmscan: remove stack copy address of pud/pmd pass in walk_pud/pmd_range()
>       loongarch: kvm: remove stack copy address of pXd in pXd_offset()
>       riscv: kvm: remove stack copy address of pXd in pXd_offset()
>       riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
>       mm/pgtable: redefine PGTABLE_LEVEL enum with ascend order from PGD
>       x86: mm: use pgtable_level enum in effective_prot_pXd()
>       x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
>       x86: mm: skip collapse_pud_page() when CONFIG_X86_DIRECT_GBPAGES disabled
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
>  arch/x86/mm/dump_pagetables.c               | 18 ++++---
>  arch/x86/mm/pat/set_memory.c                |  2 +-
>  include/asm-generic/pgtable-nop4d.h         | 54 +++++++++++++++----
>  include/asm-generic/pgtable-nopmd.h         | 54 +++++++++++++++----
>  include/asm-generic/pgtable-nopud.h         | 56 +++++++++++++++----
>  include/linux/pgtable.h                     | 69 +++++++++++++++++-------
>  mm/vmscan.c                                 |  4 +-
>  18 files changed, 352 insertions(+), 137 deletions(-)
> ---
> base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
> change-id: 20260722-dummy_ptxp3-3741d78cc70f
> 
> Best regards,
> -- 
> Sincerely,
> Yeoreum Yun
> 

-- 
Sincerely,
Yeoreum Yun

