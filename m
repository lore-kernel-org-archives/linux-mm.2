Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC41CC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:56:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEB36B0088; Wed,  2 Sep 2026 07:56:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 878B96B008A; Wed,  2 Sep 2026 07:56:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740FE6B008C; Wed,  2 Sep 2026 07:56:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2846B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:56:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC73F1C0860
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:38 +0000 (UTC)
X-FDA: 85168670076.20.C0A7B67
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id D43BC80007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:56:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xxjg4fJp;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350197;
	b=dobnA+QwxznSTxrcW0/IVujv3LvJ8dj0WKg6l/JFIzWMuw1/SinEo5i0ro6hfw4uMWhX6y
	8/snRKQVjVDeOv9oG3PqC5WxZogFrAVDEhSkYeuXg+1Ys7Mda+o0Xo6uqc62gvW2RRkhIX
	7hiMjc/KgHZXHfBsGXOBa4HjfGlJGxo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xxjg4fJp;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BNUXC83e/vjzs+qw7ZJxZhuls+achbQBYXPnbl8LL30=;
	b=usGnmYrMCx/81WSklZnP/K9mACbGr8m7/u2fCfhEYyVVgLXXGVhgsCAqkopPhQ/noM2+HD
	njYPvIfEsyPTQKE0t9w27o+aM+am42FZFSeoFjvx516gP/0FGGh+jklHMvbeLsmh+JKctn
	6CYamlQ7HqugTr2qn9C/3DkAlCk40sA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 386AF1596;
	Wed,  2 Sep 2026 04:56:32 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92A023F85F;
	Wed,  2 Sep 2026 04:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350196; bh=YuonSXf6Kv6A3r5/HpLRgNYFjXuTFjIeFymIciQQgIg=;
	h=From:Subject:Date:To:Cc:From;
	b=Xxjg4fJpRJ8F5G+7cbkqdkGJjWatdFv/Ov5DeTu8h9BJf2J2coeOwj/INJ5P+pVED
	 2qhO3ib5wRtEVRSDMIHofLwkFvhmcK5eq5jD/Ko+dLLqeQDW4AYHJ9BKS/3Cdbode0
	 ctD+ffUCqGOB6s28nyAPSM2ecQMkC8q3HpHlE+U0=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH RFC v3 00/21] mm: change behavior of pXdp_get()/pXd_page()
 in compile-time folded pgtable
Date: Wed, 02 Sep 2026 12:56:02 +0100
Message-Id: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANMOmGoC/23PwWrDMAwG4FcpPtdFthLb2Wkw2APsOkpxZGX1I
 U1wutBS8u4zgXYb7lES3y/pJiZOkSfxsrmJxHOc4nDKBW43go7+9MUyhlwLDdqA1VqG776/Hsb
 zZUSJtlLBOiILnchiTNzFy5r2KT7e38Q+N49xOg/pum6Y9Tp6GjZrCTI0XLU+oGLwrz71Oxr6N
 WXGv9L9l5hlSwbazmtmDA+5vR+OqhTOEzahck7VVAgHVSmsCQ0COAvclUI9EUz5nxqwDh5Koet
 SKLSGlGkc0u+O/bIsP/ddlCSrAQAA
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
 linux-openrisc@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9281; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=YuonSXf6Kv6A3r5/HpLRgNYFjXuTFjIeFymIciQQgIg=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7hF91UJH19ihMYiSFd6MmKb/oB8b00GDLAW
 UHYaZejF4qJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO4QAKCRBt1cPRWsUx
 M8ccDACIIBPnKxLvshr/NbigK+M7Y5yJaArlLvis3vTY8LkJ0KrOcOnQS1OGkruG3z3mRodyiOj
 UPC4AAl4piHxpr2RrAQjZROJkZfzhVXwn0ZGJ6fJ8rlzNJlQBNLK/GA4q1PNekyb6M7nbCDwQLC
 7YXNX07Mnv77V6qWHh+59365sNkoBwrdewd4Mz0hadHuAw0ys0cQNTCz9esxfWt73LzAOow/J3N
 SgJCM1Fuk4JEJkzl/AfS+/+NOAWdAn+y4CctwAsFbbLE5bWlzSpgqzBXfH3rXUQRBlBdT5MTNYQ
 xocI1UnUpikoZpck5Ie1JvlkArsSXc9+l7dedk/sUdyOt+vx4aXKYUgSSmx3AvEBZeOWmiSUX+r
 AImN2O7YeU3VwFPYsnqvD6FhJT+N5rCQrBHsnW1uhBJGgBFkxU9RcFsS3awOUoIGkCe5lbp2e8J
 hPeBnjqqsQdLL0SXOVaYPATlLVN1J781gwFBqhUoZRBDwhMecb8EXWZ5ydQjzSGZ3n4sw=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Stat-Signature: fsiih96kzgqqa7ei5ui49gt9xsucn4h5
X-Rspamd-Queue-Id: D43BC80007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788350196-547871
X-HE-Meta: U2FsdGVkX1/CROhKyRmZrmCMEo25wI2pQBBU0SbAU3olYdVEMDXZLw4BymEXj2p7DuhytwHmwb5ANKzYDBeuBjPT83C6XvDFNKcXQCQ0m8y+J2iukDPt4TyncRaHl/KhKwrvW2VyIbKzkL1b1lRtzmzwo07rJEfWnXt4DBVOdMWVWwCMS3nDbFHdKm6W+3UiWCC5jv6ie36AqLVEy8ZXHe7c4gLiPqIirpYXgOdeecl9bwn/Q0c7aQe6KmOJRocCqqVwSyXYOqmTqZwkltA62BCY+c6bHAmOZmCP+ZtOb4fblMMPNRNN4cUEftMs2eSvYGNHt66+0m7GRLlImtQC/uXfpyp8sJCTlFgLKzlnPng/tnb+Fgdoxyw88g3kzcQp9xojQRwWRBC4P6e3a7X/pjgeI9DA3KleGqTX65y/gwmS7bu+WzTzvdQIsEzGoqTUVLEELNwDP4JUCCrJsfpickq9tTDLG2DhP2zoD1v7IMBNf1ZFauVHzatSxZWRDzjWqqIOWJ+TtimEtOtF4gfyxOlUdTuwS62s8vRrp6EenMeHGTw1obxR2eBU8wQIwH4RPPSMwO84Y9P6STKYhfM8pdRzV9xUrx7EBGd1bPQ0N5D2x0tIYdG78zLBO5WF2Df+2fJaPhO3kfCcoxlPsmMtR7HcvwExIndFNDuCUJeTthRmCdimy2dbue4kV65qUJBBqmqjt1YCPpJHsJsIFs3g/yUNubibdZmp6FnOmTVwwESk6+I7OYKCxJWo6hRxkRWGawnb1lrrTw7dRsmK6CO/jLDo1b3AyjzG3mLizYJfdV/4Yz9USG4CgYFQ74k7SMD20eCQ2+nmbU4vipPaZYJ0PLNdkQYvsJBH8yHCM9tGn6hKHnnorBjXmHGI5zJQ4QB+dTu4T/lRV2jAs2ezfczCNG/L7Ge9O9nA2WnJdbR1C2+6BJY8k/OMjS+OJqJih0ACpTWZT/XfOK8fNJE4bWT
 tKf/h/vt
 HqsEwC6KolJ2sjirQkjd97++aJQ7X1sa3WzFEjv9YzYEC7J64FhQtjD+cMc7HN1H0/42QMmn1XDy2f6s9fFd9b1xxPBjWYR43hdqgKcHA2cmWwM4jvTR83RBexNyD6vD3Q+BvM7gh4eAUr7HgyoP2buAK6Kmbd00CNJJyT/u3nz0a91lxrJA1QA0TnCQ2Q0na/bkxSetkgEy7NwFfU+L0Ipzm/0Qj8iWDjfzda/3+IA84nghCh4HAjZ9PoVpksNJi0pah5VQqc5ahbGd7ZY5Vyaqj8NlTxxzQ/RpkK6lN19tXa4V4Q9fchjv4JpcgCMO8PJQg6vobBxmkWUfjHTVz6vW4uFF9hsiTpxJ//w18Q1t+cyCf+p8YQNV05SlghR7+sJti
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

To prevent generating suboptimal code, make pXdp_get() return a dummy
entry for compile-time folded page tables, make the helpers such as
pXd_offset()/pXd_offset_lockless(), set_pXd() validate dummy entries
at compile time to catch the wrong usage and prohibit calls to
pXd_page() in pgtable-nopXd.h.

This series does not change the behaviour of existing code that directly
manipulates folded page-table levels using set_pgd(), pgd_page_vaddr(), and
related helpers. Those helpers continue to behave as before.

The new restrictions only apply to code that adopts the pXdp_get()-based
access model for compile-time folded page tables.

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

Therefore, properly handle this uncommon and problematic pattern, and
document the current design of compile-time folded page tables.

This patch is based on mm-unstable.

Future work
===========
 - print_bad_page_map() and show_pte() still prints dummy values
   instead of printing the same content for all generic compile-time
   folded page tables. We might want to skip printing dummy values later.

 - We currently catch abuse of dummy values on the stack at compile-time by
   relying on constant propagation by the compiler. Usama's work [3] on using
   distinct types for sw vs. hw PTEs could help here as well."

 - Clean up vmalloc fault handling by synchronizing the vmalloc entry on
   32-bit architectures. This code is almost identical across architectures.

 - Unfortunately, the current design of compile-time folded page tables appears
   to be internally consistent but confusing. For example,
   when CONFIG_PGTABLE_LEVELS is 2, p4d, pud, and pmd are expected to
   be folded into pgd. However, the architecture code uses set_pmd()
   to update the top-level page-table entry, even though it includes pgtable-nopmd.h.

   In the future, it would be good to eliminate this source of confusion,
   possibly by treating all folded upper levels consistently as dummy wrappers
   around the highest real page-table level:

         NOPGD
   --> +------+           P4D
       | ptr0 |-------> +------+           PUD
       +------+         | ptr0 |-------> +-----+
                        | ptr1 |-        | ptr | -------> ...
                        | ptr2 | \       | ptr |
                        | ptr3 |  \        ...
                          ...      \
                                    \        PUD
                                     +----> +-----+
                                            | ptr | -------> ...
                                            | ptr |
                                              ...

Patch History
=============
from v2 to v3:
  - repasre commit message
  - move ptdump_pgtable_first_level() into pgalloc.h
  - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is disabled
  - docuemtns compile-time folded page table
  - drop the applied patch.
  - https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/

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
      openrisc/pgtable: drop __pmd_offset()
      mm/pgtable: optimize pmdp_get() and friends for folded pagetable levels
      mm/pgtable: catch abuse of folded dummy pgd_t/p4d_t/pud_t
      mm/pgtable: disallow calling (pgd|p4d|pud)_page, pgd_page_vaddr() and (p4d|pud)_pgtable with dummy
      mm/pgtable: disallow calling folded set_pgd/set_p4d/set_pud with dummy
      Documentation: mm: clarify behaviour of compile-time folded page tables

Yeoreum Yun (8):
      mm: vmscan: remove stack copy address of pud/pmd pass in walk_pud/pmd_range()
      loongarch: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
      mm/pgtable: redefine PGTABLE_LEVEL enum with ascend order from PGD
      x86: mm: use pgtable_level enum in effective_prot_pXd()
      x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()
      x86: mm: skip collapse_pud_page() when CONFIG_X86_DIRECT_GBPAGES disabled

 Documentation/mm/page_tables.rst            | 84 +++++++++++++++++++++++++----
 arch/arm/include/asm/page-nommu.h           |  4 +-
 arch/arm/include/asm/pgtable-2level-types.h | 20 +++++--
 arch/arm/include/asm/pgtable.h              |  2 -
 arch/arm64/include/asm/pgtable.h            | 23 --------
 arch/loongarch/include/asm/pgtable.h        |  2 +
 arch/loongarch/kvm/mmu.c                    | 20 ++++---
 arch/mips/include/asm/pgtable.h             |  2 +
 arch/openrisc/include/asm/pgtable.h         |  3 --
 arch/riscv/kvm/mmu.c                        | 20 ++++---
 arch/riscv/mm/fault.c                       | 52 +++++++++++-------
 arch/x86/mm/dump_pagetables.c               | 18 ++++---
 arch/x86/mm/pat/set_memory.c                |  2 +-
 include/asm-generic/pgtable-nop4d.h         | 54 +++++++++++++++----
 include/asm-generic/pgtable-nopmd.h         | 54 +++++++++++++++----
 include/asm-generic/pgtable-nopud.h         | 56 +++++++++++++++----
 include/linux/pgtable.h                     | 69 +++++++++++++++++-------
 mm/vmscan.c                                 |  4 +-
 18 files changed, 352 insertions(+), 137 deletions(-)
---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260722-dummy_ptxp3-3741d78cc70f

Best regards,
-- 
Sincerely,
Yeoreum Yun


