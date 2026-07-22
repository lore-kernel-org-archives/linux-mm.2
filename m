Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26A6C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D88D16B00A3; Wed, 22 Jul 2026 11:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A016B00A4; Wed, 22 Jul 2026 11:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4ECD6B00A5; Wed, 22 Jul 2026 11:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB786B00A3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:30:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19C38C024A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:44 +0000 (UTC)
X-FDA: 85016800008.29.CC588B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id D57D480016
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:30:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iMZDIMeN;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b4k729e7cpb9o+sFREsvXyF4eW3tMmgBedRsI0tsozk=;
	b=Zuw/PGtR3ICOOyA+u6XBgiQDnp8pjDwF3uDhHr66da6P6MKwHDDAfcP4U3HHP9FAS90gSS
	Hec+7i3+HkkBTcxvKI3KKM8fkrZwhFydIIjbNZZ4MQGy0O3k8XSaK695RBSUd7A2KnTDWj
	E+7DL3G+hXSxYWDees5mOTLQe6kroZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734242;
	b=ZD6uJ/lxhJKgu9PmBfKHxdya47m9jR/5H/7gG7eWU4LXTRiE62PSflOrr9yCmOzR0ztLwV
	T4Fu089iRhT3yFxcXtI4Xq8yJULO2Emjm0rolfvuVQA330Vl7dVJJHnyBNkt0nqr51ztm4
	rPnn2Zzgdn6yJhEJt06FaK40knTfZvM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iMZDIMeN;
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63CA51595;
	Wed, 22 Jul 2026 08:30:36 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BCA83F66F;
	Wed, 22 Jul 2026 08:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734240; bh=y9r6C8+qmxpZN2UriTf9GnZ7z+Z5djCU/+tffpW++Gs=;
	h=From:Subject:Date:To:Cc:From;
	b=iMZDIMeNT8qFLRIp9mZGMzTNdCLxPs+SbFGoNqqV7NhK9FC/O1Qd9fvZM9RhF4+jK
	 NkKYC3o+KWe4RMXbpZxziOHIvxV/17L5RnTcDfCKrGWx6MYCHNtI4kbJx4Bjx2YYT2
	 IsqTp15KkeDZurSwN14rAFyyajBrU4DIFIv8hR0A=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to
 ptep_get() and friends out
Date: Wed, 22 Jul 2026 16:30:08 +0100
Message-Id: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAHiYGoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyjHQUlJIzE
 vPSU3UzU4B8JSMDIzMDcyMj3ZTS3NzK+IKSigJjXWNzE8MUc4vkZHODNCWgjoKi1LTMCrBp0Up
 Bbs5KsbW1AF5jcBpiAAAA
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8345; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=y9r6C8+qmxpZN2UriTf9GnZ7z+Z5djCU/+tffpW++Gs=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIPXVkSrUGz6mKXI6y0yEWq3o4owe66Petn8
 nVDY4vdlKeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiDwAKCRBt1cPRWsUx
 M6JADADUr5G59lCYM0wOiw4e2HcD5OSYYLyafRctz8vNY6yo6bDPeo/0n6TxR2SqscwfZl0awE6
 8hMwJkf4/KbPw/TRaZWxT5b0H+U8Rvz+Ean8sjIqKsbxe+Wws/80SPkj4/51VEsYxHqrtYimCz0
 s6CL89gclwhq1maxc397Bsz2j9PeL4Ai4DwWQI+MMGhDT1ibZsMGZjhTz22Mub0Bjfg7FtDp0pz
 1MnX3FKqxBBo7Uz1al5+cu4UruXkkf6wXd7Ksxhx5hHUSrdhMqHSfYxtFyQd4Glf3JyO1PluA5c
 ABW8JArJI7O6GCYANLd+xOUk5TdU9NiBS9mnhvFM03eK+i8cZO6WP2fS8geXrdJBukKV0P/NBHN
 ClsFohnF95WHZfsmcM7pusk1JlST9nms2bR3jYGHvUYYdBAYD2nZ8WjK318BqY2PQQB4jh9wZ38
 5KYWiZ+o3Xs1I1a0X0Os55pPGTIY9/E9pKwQPGeB2VIJZ5ELMC1Xfb0ATvuBZ78cwqAS0=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D57D480016
X-Stat-Signature: hxjircqn36sgowdqpgkdjwfpexdiq164
X-Rspam-User: 
X-HE-Tag: 1784734241-751892
X-HE-Meta: U2FsdGVkX19G4hxLoL8Z9Ouvf91LyTcn7QrVHftVawdADKY6OgNjYNgb9zdehFJdiNXJY9XJPLdMBR9SAeOLZPKR+p0hD8GYU9HutsdAnKqjPPmVse/Vpal0taQoMlR+LcTVcS+7LJguPcwk+9KxvK2Z3BgO+pVIZPGmyKMtNiPO67LRuXkvbPSVfY3XpyuQprGDXQPIVPrbcSKe3x1CYPewIzNioK1lr5xLcHcvzBfzX2pg/ep3eL5nfSBqkQcmWBLBTJuoxaFzSOQBF2rssCuzAsKily4RNOZXErim52FN4rrEyBOrPodd2gwvaR5lb2EAOt5cqxbbH6IV62ugXdOluilTAk0pA4XWEHV85ZTZ7Z5FJ/KlSVvMt/5PB+FI2V0WodeGnlyadGC1iuH4Jt0YTNGeIsiDWqV3RjZTKvnEhFGlQoZeY5dzQw8YsqRHtaoANoEJEHUyudNhjwNUIj4dkGdO5j/XXN9tTsRiaFIRZCu69w/+1+I25MfGbuxXf/5kiLJK1vu5UkdYBxsKjCpKOfHn7l9EAkzmwO/yeOaXUeXzUXlSex+KdUC6yWHO/2nuPR2uhHXyged2w37+B27PkSe0JHGHCzhgAVtIvUIKmrDi+fdQGr6cnOomJwMJ+2fFxR6KgCgcJKMVDKxQAQFt/dt2DKtMFslIJlwaqz5p1FTcm/w/WCbba6D+4tvKNNOQQKknMp2kgumojJj5bc0eQyQw0AxPrJPx3ulduUW2EU2Mj1cUZStlo2KK2RTuBLpN3p84XevlReLg+k4RKmSLew3qSi/UsEZOJCmOlBP6cs2wbouJdJ9ntFcbyGUjxWgp9eONF5ZmOXDyN52Niy4fGvVOx/wzAeJa3+474QCaEeUDdX+0FLHyShS/LZaPCyEZGcvAOlaJgrn9/ZPfCzNIq4QuXZdaPUIcXavlg7pwzThkzrfX34aPKmrcg+IasEyXeztkm/LRDcHsY8w
 XEvrCvI2
 VMuERTMVd7V05Sa5enPcdVELwXnlySiHs13UgtOc4iSoB4oor8Rfl+SPqjJCHjr+OLYFhnL/MO67CQC7roTBbGECkNvPOuFI91jvDGdDVLRzSJkJB1XbLhAasEh1DgpM/iC0mYut2x4GT14FEYdhquuTMwVb4WzeZKGsCjFwAK1DC24csHEMyUWcy3OwQmVlE7Vy7T/6Oj1VERpkTIX0i/UIVv7fWVO/+AY+ph1Ja5rLyhOLcQQOtSwrq5GIAfOIYeKJRDjQ/+iVNv/cHzpoUchHVPAryrE23RfAhUEGWdz1nVYeFwc/OSFQDW8msMn+uhSR0ilXKP8DdpxXhE7ibW4dweXnnlnGsJmJzm+v4rzvrxjvt+kC8Uk97FfzOuQtlgPQE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using ptep_get() and its counterparts in common code is suboptimal on
kernel configurations with generic compile-time folded page tables.
By default, ptep_get() and its friends expands to READ_ONCE(),
forcing the compiler to emit a load even when the value is not used afterwards.

This issue was recently reported by Christophe Leroy [1] for ppc32
preventing futher code conversion to ptep_get()/pmdp_get()/... helper
and the same behavior can also be observed on arm64 when built with
2- or 3-level page tables

e.g) perf_get_page_size() in arm64 with CONFIG_PGTABLE_LEVEL=3:

00000000000052a0 <perf_get_page_size>:
    ...
    52dc: d53b4234     	mrs	x20, DAIF
    52e0: d50343df     	msr	DAIFSet, #0x3
    ...
    52fc: d35e9a69     	ubfx	x9, x19, #30, #9        /* pud_offset_lockless() */
    5300: f9403508     	ldr	x8, [x8, #0x68]
    5304: f869790a     	ldr	x10, [x8, x9, lsl #3]   /* pudp_get() */
    5308: f90007ea     	str	x10, [sp, #0x8]
    530c: f8697908     	ldr	x8, [x8, x9, lsl #3]    /* pudp_get() */
    ...
    5360: 90000009     	adrp	x9, 0x5000 <perf_prepare_sample+0x548>
    5364: 92746908     	and	x8, x8, #0x7ffffff000
    5368: d3557675     	ubfx	x21, x19, #21, #9       /* pmd_offset_lockless() */
    ...
    5394: f8757ac8     	ldr	x8, [x22, x21, lsl #3]  /* pmdp_get() */

Though PGTABLE_LEVEL=3, since the pudp_get() still remain with
READ_ONCE(), there's redundant load for the pud which is folded.

To prevent generating suboptimal code, define dummy pXdp_get() and
pXd_offset_lockless() in the pgtable-nopXd.h to handle folded page tables
properly.

As the pXdp_get() can return *dummy* entry, some of code using
the stack value where saves the pXdp_get() could be a problematic:

  1. Passing address of stack value where saves the pXdp_get() result
     to pXd_offset() for example:

       pud_t *pudp, pud;
       pmd_t *pmdp;

       pud = pudp_get(pudp, address);
       pmdp = pmd_offset(&pud, pud, address);

     (e.g. host_pfn_mapping_level() in loongarch).

  2. Using the pXdp_get() result to use as argument of pXd_val() and
     to check prot without checking pgtable is folded.
     for example, x86's effective_prot().

  3. Using set_pXd() with pXdp_get() will set problematic dummy entry
     in folded page table like:

       set_pXd(pxdp, pXdp_get(pxdp_k));

     To prevent this, Let set_pXd() triggers the compile error
     to catch the wrong usage with folded dummy entry of set_pXd() in
     the generic compile-time folded pgtable.

  4. Using pgd_page_vaddr() to get the first-level pgtable.
     passing dummy pxdp_get() for pgd_page_vaddr() will return wrong
     address. Therefore, make pgd_page_vaddr() and pXd_pgtable() to
     trigger the error for improper usage with folded dummy entry in the
     generic compile-time folded pgtable.

Thanksfully, above cases are rare since (1) most of usage using
pXd_offset() with result of upper pXd_offset(), (2) it's extreamely
rare to use pXd_val() for non-leaf entry in the kernel,
(3) is to handle the vmalloc_fault or set the first level of page table
and (4) to setup early page table and etc.

Therefore, convert this kind of problematic rare pattern properly.

Furthermore, passing the ptep_get() (or its counterparts) as argument
directly to pte_present() and related helpers can generate suboptimal code,
in arm64 as the current macro implementation may evaluate its argument
more than once like:

  !pte_val(READ_ONCE(*pte) || pte_present_invalid(READ_ONCE(*pte))

resulting in redundant loads.

A typical example is pud_free_pmd_page(), where the expansion of
pmd_present() generates:
    ...
    /* pmd_present() (x20 = pmdp) */
    1b88: f9400288     ldr	x8, [x20]        // read pmdp.
    1b8c: f9000fa8     str	x8, [x29, #0x18]
    1b90: 3707fec8     tbnz	w8, #0x0, 0x1b68 <pud_free_pmd_page+0xd0>
    1b94: f9400288     ldr	x8, [x20]        // redundant read of pmdp.
    1b98: 8a170109     and	x9, x8, x23
    1b9c: f9000fa8     str	x8, [x29, #0x18]
    1ba0: f120013f     cmp	x9, #0x800
    1ba4: 54fffe20     b.eq	0x1b68 <pud_free_pmd_page+0xd0>
    1ba8: 17fffff4     b	0x1b78 <pud_free_pmd_page+0xe0>
    ...

To address this in arm64, convert pte_present() macro and its friends
to static inline function.

This patch is based on mm-unstable.

Future work
===========
 - print_bad_page_map() and show_pte() still prints dummy values
   instead of printing the same content for all generic compile-time
   folded page tables. We might want to skip printing dummy values later.

 - We currently catch abuse of dummy values on the stack at compile-time by
   relying on constant propagation by the compiler. Usama's work [3] on using
   distinct types for sw vs. hw PTEs could help here as well."

Patch History
=============
from v1 to v2:
  - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
    and add check whether they're called with dummy entry.

  - Add some comment for returning first entry of pgd in arm with
    2 pgtable-level

  - https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/

Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com
---
David Hildenbrand (Arm) (13):
      ARM: mm: make nommu pgd_t a scalar
      ARM: mm: make 2-level pgd_t a scalar
      ARM: mm: remove custom pgdp_get()
      LoongArch: mm: define pud_leaf() only when PUD exists
      MIPS: mm: define pud_leaf() only when PUD exists
      mm/pgtable: define (pgd|p4d|pud)_leaf() for folded page tables
      mm/pgtable: define (pgd|p4d|pud)_offset_lockless() for folded page tables
      x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
      mm/pgtable: optimize pmdp_get() and friends for folded pagetable levels
      mm/pgtable: catch abuse of folded dummy pgd_t/p4d_t/pud_t
      mm/pgtable: disallow calling (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
      mm/pgtable: disallow calling folded set_pgd/set_p4d/set_pud with dummy
      openrisc/pgtable: drop __pmd_offset()

Yeoreum Yun (7):
      mm: vmscan: remove stack copy address of pud pass in wallk_pud_range()
      loongarch: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
      x86: mm: define pudp_set_access_flags() when CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD is enabled only.
      x86: mm: skip pud setup when using generic compile-time folded pagetable
      arm64: pgtable: convert pte_present() from macro to static inline

 arch/arm/include/asm/page-nommu.h           |  4 +--
 arch/arm/include/asm/pgtable-2level-types.h | 24 +++++++++++--
 arch/arm/include/asm/pgtable.h              |  2 --
 arch/arm64/include/asm/pgtable.h            | 35 +++++-------------
 arch/loongarch/include/asm/pgtable.h        |  2 ++
 arch/loongarch/kvm/mmu.c                    | 20 ++++++-----
 arch/mips/include/asm/pgtable.h             |  2 ++
 arch/openrisc/include/asm/pgtable.h         |  3 --
 arch/riscv/kvm/mmu.c                        | 20 ++++++-----
 arch/riscv/mm/fault.c                       | 52 +++++++++++++++++----------
 arch/x86/mm/dump_pagetables.c               |  5 ++-
 arch/x86/mm/pat/set_memory.c                |  5 +--
 arch/x86/mm/pgtable.c                       |  2 ++
 include/asm-generic/pgtable-nop4d.h         | 53 ++++++++++++++++++++++-----
 include/asm-generic/pgtable-nopmd.h         | 54 ++++++++++++++++++++++------
 include/asm-generic/pgtable-nopud.h         | 55 +++++++++++++++++++++++------
 include/linux/ptdump.h                      |  1 +
 mm/ptdump.c                                 | 11 ++++++
 mm/vmscan.c                                 |  2 +-
 19 files changed, 246 insertions(+), 106 deletions(-)
---
base-commit: 7368ccdeff50c27809d3a8276c85bae7e402c96c
change-id: 20260722-dummy_ptxp3-3741d78cc70f

Best regards,
-- 
Sincerely,
Yeoreum Yun


