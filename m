Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A9A60A260A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cuvL/oB1
Received: by kanga.kvack.org (Postfix)
	id 588F86B05B1; Fri, 20 Nov 2026 06:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538C26B05B2; Fri, 20 Nov 2026 06:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4285D6B05B3; Fri, 20 Nov 2026 06:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9E36B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:50:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A497680EEC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:50:09 +0000 (UTC)
X-FDA: 85455328938.22.8698D35
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id A21CC100003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:50:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cuvL/oB1";
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795175408;
	b=7cj3D/kTikghGnZo4y6sYZMjedxQ7XNtNfLC2GvOSD+msBVY4ZXZDAKtomZA6qml4Jt+3e
	54zmSETuV+lE5iU/dtztMskJwp3nXLJRi9Tucf23HgS7VANW8OY5wwDm/kS7yve76TiTVc
	j9qm2pXR4zXkd8AYiQFKpMME0hDDVa0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795175408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFk5eznRZq7/AJ5Jj6TSnaF46M7WBKrQitEuh1eIf2M=;
	b=Ig76KSvjCg9vTbMWI1hy9FrLzHGQcmnb75E+C96JJ68aij2g2be56+lgComfgHjJ6YQkja
	r/j7O6a36oE6tWJ1gOx7EF3Ht/cSOMRn6Q1UWffZRKt3Dk1YAyAyLcLt/LWzQ0bov0Kjal
	3/ql6ei6aSpLMRUwaToc5dkTx8YRe2w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="cuvL/oB1";
	spf=pass (imf05.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80ABA1575;
	Fri, 20 Nov 2026 03:50:03 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1387F3F882;
	Fri, 20 Nov 2026 03:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795175406; bh=Ig7LJX3a+UkFR/7wjk9zeIV/7tzEcwoCqXxyrMDkhnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cuvL/oB1VjOpyD4zi/RcAx8YEy1FcSXbPjhK8DPls4WYh5/RLr9cjgozXdcn2ciTI
	 kjkvkdynnztLpeUmXPkh37VuryHY7RgJRDZpfXb/4jdathQYVun9qNdjxIGmB5nUHu
	 4dJq1tZPBfSmJerCN/EDrTDKQykDuE4xZZgBV42o=
Date: Fri, 20 Nov 2026 11:49:57 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
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
	Stafford Horne <shorne@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Sohil Mehta <sohil.mehta@intel.com>
Subject: Re: [PATCH RESEND v2 00/21] mm: change behavior of
 pXdp_get()/pXd_page() in compile-time folded pgtable
Message-ID: <awAz5W6daF5HQFPS@e129823.arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
 <64b74093-541c-4f32-8ea4-c8007067eeea@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64b74093-541c-4f32-8ea4-c8007067eeea@kernel.org>
X-Stat-Signature: rc45ptbzbue35ztf465sx57t4x6jxi89
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A21CC100003
X-HE-Tag: 1795175407-457501
X-HE-Meta: U2FsdGVkX1+iY1BOj/ZmNL2x5mC+8jvqopA1qe84FgdU0h6KK7pqVE+eP3UANCwuX8Uw7Va3ef0rjQgIWw4CgeGYHI2JdbcNzRTtkcYWU0Aa5UvoPYp6z2fvxX2nUg1TgmcZKrz3ue84Dg361KccULPmH882gmzK+CLeGsERzakh8zG2+4rgBrnuvrDNiHYjeb7x1gDwXH15WpBoq6L0dHlHmPKlT+LophLEhYk6da1FaNolCjaLyKXp1ucje+UIxfUvmvm9T6nN5cJTLO+ccXtWPcWY/r0UH0xZC73A+ClmYM6qFBBGOsT4HTxz6PlYdfH2v5ZSIDdsYMH+nWIrPYIIGLhodEIJBy8mYpmHRfDHAwaOq0XcztSldrR5y513DT8JhxJVoEArxEiVCAM8OPQvYrCW3cZoiZwI5En5qqpJLNri/76ueZvu2uMdknoMfyTdB9nDXxqBoHTZKjP6ajj5fIpy0E5u0vrBHEhixyudzDREAUx0MsxhxNEwPkAZvrG/IS/aUt50BXnZGcx4ij5AUV56wSSx3dQihlCcWfrECPxT0mJ7TPTo6Nk91B5mVBY4TMUoYWKFQFhWyi6WJ2kxCEivPypPOKGlvSlvaXM7VgiMfmSqH5ojX7N4BZfoAX2LVOvd/OZ7hXDBF/cfHvKt4TU2To+xFvoN9DzX+H/wCD6gR7c85FTF+NJy0xZ3IJhNsGzZXsPXAkfNCrQNN19U0GPVXFjRv5ci/D60/3xaTU8iIJr12qtjUbXduulYwR4pKqoJc71iDnSdlhumVPqrrXJ+MKdSD1fLt8HcUj2kkTCi1U5rqUmEan+BpQU158bkNoH6OaKOQ964fMbW1f6lduxvwmFVgz0ogUPWwIFrckiq2476ysypsuWDvPU1O9ThP9qK0OlLjDmBgSRv0bU5fr/gW9E1VQgAxzuEccf1Hl7wklIJ16479JIAJ/9HQpJOdZiH0zYanBU2AKg
 AKIV6V7d
 n16tPByCvzen/o0ib4OCWxMZbv9DRy6rKBzsx0z+ac1rW8Llm3f7piWI2FpyLSsEdXqesVl2SBUsVlMtnftSwFfwwudOKmlcy0sQrAV7ewORqARJjg0NXDZdiXUwYb352rnyF7Rcw9//fWU+eQQugRahYedS+zVM55601N0ZgJ3vlSE1+EBYz8Qq3WPH940vvU5TeRurs8CSOedu/AI+CtnMk+thlyCqx3rXDDDnU0icu3h016/sHZ9v0h3p4sJK2AYVJLPi9VQnWorNbSh9fVwABhXJaUyXvjJXSmT1+fX+oUEOE6XRh2eAJCcslPr20CfnT2y8+rDCgUyOTfEQ3GHGgiClP+FNTbk/lt4UxHLAT/rLdMpOtKDPQhmPPW0X3ATGV2lNaGky+w6bE4pfNimsN9sbCXH7w8yB/osaXRBexPa4OTlwth3EMPYKUftm5X4/2TSNsJdS8Y2G788vSZyWTB/VGThC5/CHwj8HDy7KwNtHIrcQ1kEicex8HfmBqoLbdGXHqHs++UumhVOZCl3ZV7RvN+rzUrybbszLYFKSxkHpVEYY0rYDL1+4SLtUPIslZeZiJbT87UOFnYr82B0nhQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 03:07:16PM +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 12:21, Yeoreum Yun wrote:
> > Using ptep_get() and its counterparts in common code is suboptimal on
> > kernel configurations with generic compile-time folded page tables.
> > By default, ptep_get() and its friends expands to READ_ONCE(),
> > forcing the compiler to emit a load even when the value is not used afterwards.
> > 
> > This issue was recently reported by Christophe Leroy [1] for ppc32
> > preventing futher code conversion to ptep_get()/pmdp_get()/... helper
> > and the same behavior can also be observed on arm64 when built with
> > 2- or 3-level page tables
> > 
> > e.g) perf_get_page_size() in arm64 with CONFIG_PGTABLE_LEVEL=3:
> > 
> > 00000000000052a0 <perf_get_page_size>:
> >     ...
> >     52dc: d53b4234     	mrs	x20, DAIF
> >     52e0: d50343df     	msr	DAIFSet, #0x3
> >     ...
> >     52fc: d35e9a69     	ubfx	x9, x19, #30, #9        /* pud_offset_lockless() */
> >     5300: f9403508     	ldr	x8, [x8, #0x68]
> >     5304: f869790a     	ldr	x10, [x8, x9, lsl #3]   /* pudp_get() */
> >     5308: f90007ea     	str	x10, [sp, #0x8]
> >     530c: f8697908     	ldr	x8, [x8, x9, lsl #3]    /* pudp_get() */
> >     ...
> >     5360: 90000009     	adrp	x9, 0x5000 <perf_prepare_sample+0x548>
> >     5364: 92746908     	and	x8, x8, #0x7ffffff000
> >     5368: d3557675     	ubfx	x21, x19, #21, #9       /* pmd_offset_lockless() */
> >     ...
> >     5394: f8757ac8     	ldr	x8, [x22, x21, lsl #3]  /* pmdp_get() */
> > 
> > Though PGTABLE_LEVEL=3, since the pudp_get() still remain with
> > READ_ONCE(), there's redundant load for the pud which is folded.
> > 
> > To prevent generating suboptimal code, make pXdp_get() return a dummy
> > entry for compile-time folded page tables, make the helpers such as
> > pXd_offset()/pXd_offset_lockless(), set_pXd() validate dummy entries
> > at compile time to catch the wrong usage and prohibit calls to
> > pXd_page() in pgtable-nopXd.h.
> > 
> > This series does not change the behaviour of existing code that directly
> > manipulates folded page-table levels using set_pgd(), pgd_page_vaddr(), and
> > related helpers. Those helpers continue to behave as before.
> > 
> > The new restrictions only apply to code that adopts the pXdp_get()-based
> > access model for compile-time folded page tables.
> > 
> > As the pXdp_get() can return *dummy* entry, some of code using
> > the stack value where saves the pXdp_get() could be a problematic:
> > 
> >   1. Passing address of stack value where saves the pXdp_get() result
> >      to pXd_offset() for example:
> > 
> >        pud_t *pudp, pud;
> >        pmd_t *pmdp;
> > 
> >        pud = pudp_get(pudp, address);
> >        pmdp = pmd_offset(&pud, pud, address);
> > 
> >      (e.g. host_pfn_mapping_level() in loongarch).
> > 
> >   2. Using the pXdp_get() result to use as argument of pXd_val() and
> >      to check prot without checking pgtable is folded.
> >      for example, x86's effective_prot().
> > 
> >   3. Using set_pXd() with pXdp_get() will set problematic dummy entry
> >      in folded page table like:
> > 
> >        set_pXd(pxdp, pXdp_get(pxdp_k));
> > 
> >   4. Using pgd_page_vaddr() to get the first-level pgtable.
> >      passing dummy pxdp_get() for pgd_page_vaddr() will return wrong
> >      address. Therefore, make pgd_page_vaddr() and pXd_pgtable() to
> >      trigger the error for improper usage with folded dummy entry in the
> >      generic compile-time folded pgtable.
> > 
> > Thanksfully, above cases are rare since (1) most of usage using
> > pXd_offset() with result of upper pXd_offset(), (2) it's extreamely
> > rare to use pXd_val() for non-leaf entry in the kernel,
> > (3) is to handle the vmalloc_fault or set the first level of page table
> > and (4) to setup early page table and etc.
> > 
> > Therefore, properly handle this uncommon and problematic pattern, and
> > document the current design of compile-time folded page tables.
> > 
> > This patch is based on mm-unstable.
> > 
> > Future work
> > ===========
> >  - print_bad_page_map() and show_pte() still prints dummy values
> >    instead of printing the same content for all generic compile-time
> >    folded page tables. We might want to skip printing dummy values later.
> > 
> >  - We currently catch abuse of dummy values on the stack at compile-time by
> >    relying on constant propagation by the compiler. Usama's work [3] on using
> >    distinct types for sw vs. hw PTEs could help here as well."
> > 
> >  - Clean up vmalloc fault handling by synchronizing the vmalloc entry on
> >    32-bit architectures. This code is almost identical across architectures.
> > 
> >  - Unfortunately, the current design of compile-time folded page tables appears
> >    to be internally consistent but confusing. For example,
> >    when CONFIG_PGTABLE_LEVELS is 2, p4d, pud, and pmd are expected to
> >    be folded into pgd. However, the architecture code uses set_pmd()
> >    to update the top-level page-table entry, even though it includes pgtable-nopmd.h.
> > 
> >    In the future, it would be good to eliminate this source of confusion,
> >    possibly by treating all folded upper levels consistently as dummy wrappers
> >    around the highest real page-table level:
> > 
> >          NOPGD
> >    --> +------+           P4D
> >        | ptr0 |-------> +------+           PUD
> >        +------+         | ptr0 |-------> +-----+
> >                         | ptr1 |-        | ptr | -------> ...
> >                         | ptr2 | \       | ptr |
> >                         | ptr3 |  \        ...
> >                           ...      \
> >                                     \        PUD
> >                                      +----> +-----+
> >                                             | ptr | -------> ...
> >                                             | ptr |
> >                                               ...
> > 
> > Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
> > Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
> > Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com
> > 
> > Patch History
> > =============
> > from v1 to v2:
> >   - fix docutils warning.
> >   - Link to v1: https://lore.kernel.org/r/20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com
> > 
> > from RFC v3 to v1:
> >   - Drop and rebase for CONFIG_X86_DIRECT_GBPAGES and use the Dave's
> >     patch (https://lore.kernel.org/all/20260902194718.E1FF3041@davehans-spike.ostc.intel.com/)
> >   - Link to RFC v3: https://lore.kernel.org/r/20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com
> > 
> > from RFC v2 to RFC v3:
> >   - repasre commit message
> >   - move ptdump_pgtable_first_level() into pgalloc.h
> >   - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is disabled
> >   - docuemtns compile-time folded page table
> >   - drop the applied patch.
> >   - Link to RFC v2: https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/
> > 
> > from RFC v1 to RFC v2:
> >   - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
> >     and add check whether they're called with dummy entry.
> >   - Add some comment for returning first entry of pgd in arm with
> >     2 pgtable-level
> >   - Link to RFC v1: https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/
> > 
> > ---
> > Dave Hansen (1):
> >       x86/mm: Introduce helper for checking direct map 1G page support
> > 
> > David Hildenbrand (Arm) (13):
> >       ARM: mm: make nommu pgd_t a scalar
> >       ARM: mm: make 2-level pgd_t a scalar
> >       ARM: mm: remove custom pgdp_get()
> >       LoongArch: mm: define pud_leaf() only when PUD exists
> >       MIPS: mm: define pud_leaf() only when PUD exists
> >       mm/pgtable: define (pgd|p4d|pud)_leaf() for folded page tables
> >       mm/pgtable: define (pgd|p4d|pud)_offset_lockless() for folded page tables
> >       openrisc/pgtable: drop __pmd_offset()
> >       mm/pgtable: optimize pmdp_get() and friends for folded pagetable levels
> >       mm/pgtable: catch abuse of folded dummy pgd_t/p4d_t/pud_t
> >       mm/pgtable: disallow calling (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
> >       mm/pgtable: disallow calling folded set_pgd/set_p4d/set_pud with dummy
> >       Documentation: mm: clarify behaviour of compile-time folded page tables
> > 
> > Yeoreum Yun (7):
> >       mm: vmscan: remove stack copy address of pud/pmd pass in walk_pud/pmd_range()
> >       loongarch: kvm: remove stack copy address of pXd in pXd_offset()
> >       riscv: kvm: remove stack copy address of pXd in pXd_offset()
> >       riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
> >       mm/pgtable: redefine PGTABLE_LEVEL enum with ascend order from PGD
> >       x86: mm: use pgtable_level enum in effective_prot_pXd()
> >       x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
> > 
> >  Documentation/mm/page_tables.rst            | 84 +++++++++++++++++++++++++----
> >  arch/arm/include/asm/page-nommu.h           |  4 +-
> >  arch/arm/include/asm/pgtable-2level-types.h | 20 +++++--
> >  arch/arm/include/asm/pgtable.h              |  2 -
> >  arch/arm64/include/asm/pgtable.h            | 23 --------
> >  arch/loongarch/include/asm/pgtable.h        |  2 +
> >  arch/loongarch/kvm/mmu.c                    | 20 ++++---
> >  arch/mips/include/asm/pgtable.h             |  2 +
> >  arch/openrisc/include/asm/pgtable.h         |  3 --
> >  arch/riscv/kvm/mmu.c                        | 20 ++++---
> >  arch/riscv/mm/fault.c                       | 52 +++++++++++-------
> 
> To move forward with this we need an ACK from riscv folks. All other arch
> changes are fairly trivial.
> 
> @Riscv people, any comments?

Gentle ping for @risc-v people...

Thanks!

-- 
Sincerely,
Yeoreum Yun

