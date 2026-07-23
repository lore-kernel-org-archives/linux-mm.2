Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 503F0C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 232886B014C; Thu, 23 Jul 2026 04:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3336B014D; Thu, 23 Jul 2026 04:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4D26B014E; Thu, 23 Jul 2026 04:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34C06B014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:41:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5198D1603FB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:41:40 +0000 (UTC)
X-FDA: 85019397960.17.A0F700F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C08A40003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:41:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jyYf5dBq;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796098;
	b=vys2/qPucJKMfw78qQnzqF0NCE1bA69iExLl2w2xcfdDbVNoDeVfElFCbFbgWyu4LXkdgb
	g3gbGfp4PFLzp1T2zWX6f0x2SwMYlqqhdSjTnpjN0gyR82a4FhleeEU+fUG7dyJIvnKZl1
	yk/XBR0MuZAe39XpAmxhwa7QJQSTF8g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jyYf5dBq;
	spf=pass (imf12.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vioNWeK72HlhKzaXdYjtTtx2h8Re/Idn8Y6kZLSjQKU=;
	b=NzESYUarb3gp3QuZQZRBBvRnxplUHJTRRH0qxAs4kmXlbzR6GNI/8uq7tVvCuFNMuWMYEe
	PIeUTI29aDcBuRNL1jRMAlsc1P79lGYgXs0Ul8nKu36wwymyGNGNdjbhrxlDjy1jH8LNuA
	i3Q+aP2Lu5Ov2Myn8gcC+Ze/3BzLu3A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EB931477;
	Thu, 23 Jul 2026 01:41:33 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5BC73F86F;
	Thu, 23 Jul 2026 01:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784796097; bh=tHu7RoxBrkiUeHKCDkL/iuN7wAUGu94jRhPQyIZkpMA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jyYf5dBqTJ1JCBs2GdetKtKebNTFujQgVNyM9FlYh+7WTSQ44Nzs8Y0U/Zcu3/0DZ
	 F8o/mRcYZmN03NpFHUsVhYRsCOYeSG6tNiL+HHlZLY027DY2RfvehP4Hk242KMbom8
	 Y5LydIRYAz0Vbe5p9VsHCQl+hb7z9+8dMD0K2N00=
Date: Thu, 23 Jul 2026 09:41:33 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: David.Hildenbrand@arm.com, david@kernel.rog
Cc: yeoruem.yun@arm.com, Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [INTERNAL REVIEW] [RFC PATCH v3 01/20] mm: change behavior of
 pXdp_get()/pXd_page() in compile-time folded pgtable
Message-ID: <amHTvacwPg6xljJZ@e129823.arm.com>
References: <20260723081036.1461495-1-yeoreum.yun@arm.com>
 <20260723081036.1461495-2-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723081036.1461495-2-yeoreum.yun@arm.com>
X-Stat-Signature: z1bd4qrphenbaieh58w3hurrai6ayiec
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6C08A40003
X-Rspam-User: 
X-HE-Tag: 1784796098-850074
X-HE-Meta: U2FsdGVkX19UliuhyTG20d4WzwTQkZ6xPB1hipNnwo8DKhhdFx1SbwHvz2ew4Q4bRqPu6JpZ71QZWKKO5scrhZuFTnwcCgbCosWxsXc3L05O1Ys/Grs/13fg30qj41SO0enU2ZbIZj8P3QMvGuP53T0xUNmwRC2Ei9SiUJqfBTlreugKnvrhpgR0tokclKluZ62e5C51m1IcgZ5+y05iJxtG4XkFwVQ+3JE7aIACd5R4VJIOh6TSL4GTJDHgBccH+FwiS3e2l1AJAeOmVZsMHAdDgK0re+JTgjT2BYkFOTDzSnxxRV4PIlBmeTy9mtPHwG/PDjbbNMEQB2x+KLKRv4l44hEIGHaFWVGYXyIWy08qbPRsDoHUb56AH5rHpfKQ0SkGCR+3uAMbJKTTl0+kSvHlZ9FKqvfX7QWwyPbiXSxHIga3NJkpo/fqW5qm7J4mVSslsQZbTMMEJv0TYdytbV87g2OQ9YsL76xvhuFkrEbM52IMZgonKCWktCWlyGATAmnh3sUIU0uJAtdnVG9li/Rgxm9ZEgFGoueNl9S/EzLni1Sf32HeLMBtwDEheF3vir1YPnlpvj0NwK3hLJ9NbC32X/Ud9j8bmPKIbBlTHjkvops0OiqZ130pWK8ig40jPoLAKt839j0hDZFAcT5yEMIQC2L0zvVwg0/3qr2EvV8tFc8iYogvI1DMO4lOoA5CjXAiAp/Ddku1kaMqp911LvEX+bBV7Erwpde/EQAM3UehqIj3wAaeSf1SZtEEb+f1EBNgvVVzUoYbkHBcq0YVWzL2NP0KZDMXwEZTWNFRtfyhG7mT03QRI1Xl0+ARFrXl+2Yz62OmNqwIyOTC5Wvk2vevJ5duCm5od+MTVRLlj+ltofLRXfTKlbEbKWEOWvdokNWcHr2kDt7pcG98+jJQ3fT+E7xmeXYyXh/Nwr3Hf2qPMKGjTOEt/LAM8fHXZgEQVKdS0P8wcBdUib/8+wc
 dRkqumI2
 XzkjouduFRP1ghWo+B9nlCCC1ayyzGxYLk5xbV7XJSWbEU8peBqHqAVJ8cuEpXGyl+05O2z1f05MApzjIjkSmWoyyCo0lrNCgSgR4WQ1S4A33HpDtGbv0UHytDKuBy09A3jJ0+8ZPJs1tVS34iiJWMad46/b2I+0bcT6uQ9BtUuQm5+AeESaZQSF5m9uoqfBv2VhslpKQPNX1f7RhfSZicjJj+O8Er0H0e/DGplFzGCfTDKBghNiNDmZcOQqgSS+VTGjVv3nh3kYFccDJv6kZB8lttRnb4cBSDFNUVxSbKHL1qngidevkXMmdMJtCN9g0LJGdB51Pj4JUogEn8XaEiH4/s++qeBOStMfRQIeuD6n06BcCMSGPRPVbvKVZknrwOgZUUdXQdsQSkKky35Cvzqfl/WvOS0XG7v4D/+rFDjIURW3t1IlzAsT9pYvnpaxA/mh0heCm/jYFBMjS0YYqX74Y2dTbylJxpwMWw0+PHnZE9NFxYxwn7pVrBNxJLpAr+CkeXNkBUeY1prg4YBTl63fG1A12qeOFoaYRYPXUrdqL5CV/pvvDZ9RnOhbqWCDQoAvpMdCsV2Mu+m+RG3vTi8QDyFhdoosQoOU/VUgw9pbzoY4hq+2mwDbhaBqnilZWR8xC/4Q+OSMt9PSqOm1H/+LNkIWsc+oHYM11et96XMZW4osXRJGJLa8L/a6GAcB4i26uIvGzdXcQu1eAq9ItZY2hiLr7FkdmIXzD4ua4APrBD3bUX0FyY6DeeEB75Ju8hKvAVDZi5WKviaNww7MJ9OpsAWg+RigXJzkgD7UTT3ZAk5BjvYRRidfm54sTqsaWzIeEaP+QymKvoQQBkas5La2xyris/0AF1aklh/YLavFr5WKavW/jNldYT/SOfU6SXVocnH/Ivw1QKnTW0oJ1sLzaA4T1687CPGHevLNWZC1phmDO6II61rxvb2+97cvqNu0SraUApnZ+bGiK9uBHZPpyLbXA
 c3SVgO9l
 QPovzsW7o0NnvpJ9fBJJuquyuklnawrEwk6iPmIxrAnF/EwDlxyvNFrS7VX1NXz5LQEXq9uy7MnjkE5CkMTHLHK8/WGc+eqjoHOfy9WJRYUMQ1KRJDeDoelHMra4z9ZnHTS5buha13tszj10l1eQyztHMi4GBnTMYeJsy0GusSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for making a noise. I've posted wrongly.

Please, ignore this. Thanks!


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
> entry for compile-time folded page tables and prohibit calls to
> pXd_page() in pgtable-nopXd.h.
> 
> Also make the helpers in pgtable-nopXd.h, such as pXd_offset_lockless(),
> validate dummy entries at compile time to catch the wrong usage.
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
> Therefore, convert this kind of problematic rare pattern properly.
> 
> Furthermore, passing the ptep_get() (or its counterparts) as argument
> directly to pte_present() and related helpers can generate suboptimal code,
> in arm64 as the current macro implementation may evaluate its argument
> more than once like:
> 
>   !pte_val(READ_ONCE(*pte) || pte_present_invalid(READ_ONCE(*pte))
> 
> resulting in redundant loads.
> 
> A typical example is pud_free_pmd_page(), where the expansion of
> pmd_present() generates:
>     ...
>     /* pmd_present() (x20 = pmdp) */
>     1b88: f9400288     ldr	x8, [x20]        // read pmdp.
>     1b8c: f9000fa8     str	x8, [x29, #0x18]
>     1b90: 3707fec8     tbnz	w8, #0x0, 0x1b68 <pud_free_pmd_page+0xd0>
>     1b94: f9400288     ldr	x8, [x20]        // redundant read of pmdp.
>     1b98: 8a170109     and	x9, x8, x23
>     1b9c: f9000fa8     str	x8, [x29, #0x18]
>     1ba0: f120013f     cmp	x9, #0x800
>     1ba4: 54fffe20     b.eq	0x1b68 <pud_free_pmd_page+0xd0>
>     1ba8: 17fffff4     b	0x1b78 <pud_free_pmd_page+0xe0>
>     ...
> 
> To address this in arm64, convert pte_present() macro and its friends
> to static inline function.
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
> Patch History
> =============
> from v2 to v3:
>   - repasre commit message
>   - move ptdump_pgtable_first_level() into pgalloc.h
>   - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is
>     disabled
>   - https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/
> 
> from v1 to v2:
>   - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
>     and add check whether they're called with dummy entry.
>   - Add some comment for returning first entry of pgd in arm with
>     2 pgtable-level
>   - https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/
> 
> To: Russell King <linux@armlinux.org.uk>
> To: Huacai Chen <chenhuacai@kernel.org>
> To: WANG Xuerui <kernel@xen0n.name>
> To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> To: Catalin Marinas <catalin.marinas@arm.com>
> To: Will Deacon <will@kernel.org>
> To: Arnd Bergmann <arnd@arndb.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Kairui Song <kasong@tencent.com>
> To: Qi Zheng <qi.zheng@linux.dev>
> To: Shakeel Butt <shakeel.butt@linux.dev>
> To: Barry Song <baohua@kernel.org>
> To: Axel Rasmussen <axelrasmussen@google.com>
> To: Yuanchu Xie <yuanchu@google.com>
> To: Wei Xu <weixugc@google.com>
> To: Johannes Weiner <hannes@cmpxchg.org>
> To: David Hildenbrand <david@kernel.org>
> To: Michal Hocko <mhocko@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: Tianrui Zhao <zhaotianrui@loongson.cn>
> To: Bibo Mao <maobibo@loongson.cn>
> To: Anup Patel <anup@brainfault.org>
> To: Atish Patra <atish.patra@linux.dev>
> To: Paul Walmsley <pjw@kernel.org>
> To: Palmer Dabbelt <palmer@dabbelt.com>
> To: Albert Ou <aou@eecs.berkeley.edu>
> To: Alexandre Ghiti <alex@ghiti.fr>
> To: Dave Hansen <dave.hansen@linux.intel.com>
> To: Andy Lutomirski <luto@kernel.org>
> To: Peter Zijlstra <peterz@infradead.org>
> To: Thomas Gleixner <tglx@kernel.org>
> To: Ingo Molnar <mingo@redhat.com>
> To: Borislav Petkov <bp@alien8.de>
> To: x86@kernel.org
> To: H. Peter Anvin <hpa@zytor.com>
> To: Liam R. Howlett <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Mike Rapoport <rppt@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Michal Hocko <mhocko@suse.com>
> To: Jonas Bonn <jonas@southpole.se>
> To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> To: Stafford Horne <shorne@gmail.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: linux-mips@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kvm@vger.kernel.org
> Cc: kvm-riscv@lists.infradead.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-openrisc@vger.kernel.org
> Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
> Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
> Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com
> 
> --- b4-submit-tracking ---
> # This section is used internally by b4 prep for tracking purposes.
> {
>   "series": {
>     "revision": 3,
>     "change-id": "20260722-dummy_ptxp3-3741d78cc70f",
>     "prefixes": [
>       "RFC"
>     ],
>     "history": {
>       "v2": [
>         "20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com"
>       ]
>     }
>   }
> }
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> -- 
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 

-- 
Sincerely,
Yeoreum Yun

