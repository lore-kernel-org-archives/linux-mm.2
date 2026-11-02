Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA80560A2600
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=V7VvM+lW
Received: by kanga.kvack.org (Postfix)
	id 0B55D6B05B4; Mon,  2 Nov 2026 06:21:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0660F6B05B7; Mon,  2 Nov 2026 06:21:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98B06B05B8; Mon,  2 Nov 2026 06:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80E76B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:21:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44A0F140B7F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:39 +0000 (UTC)
X-FDA: 85389938718.28.704DB5A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F8EFC0006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V7VvM+lW;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cVUAn3Erh6GVaXy4+Ny9Vsau+0XQpUr/dkWQ56dYm2c=;
	b=7quvVb3tQqV/TSSv96VM9g4Awz9bgTXLl5VotIJuzAKHOhSypiO96cT+EBznbALZJ/umfF
	Qro1iL50dSD0BnYCIJG+qVLMluaj99BO7QxiVFfc3udm+lnV8XOQA1vdADBik4F5DzBHjq
	HpoAqDsW2B1D+COaUXPhH9Y+JYka56I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=V7VvM+lW;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618497;
	b=a/N3EWxuDi1jQaoHoGwzvYhlRuBjD0J1xqnSGW/Dkw0domlAK3616sAmzTUBKidrsf3+C2
	h0HZ008+soSX3a+n7br/yO2NCH+JNDuIYCbxfa6n5Uc+DbXKuOLy4hDHPD1LbHfAiLKa/T
	Ijy9XMy1obC9aUI7JXrDh5EzPrrWLRg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0834F1691;
	Mon,  2 Nov 2026 03:21:33 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ED443F632;
	Mon,  2 Nov 2026 03:21:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618496; bh=/ruFYOoOTay1qEU1I9vLoOZvo4kBoLe4bydBgAUldIM=;
	h=From:Subject:Date:To:Cc:From;
	b=V7VvM+lWDJekSuT/hkgXofb9gun7LFwcNGEYS37jK1NqeJtv8R48/P7bPp7Ar0Coo
	 I1UBkdVSh0gbZAonjF7NLsmikGhfOqvpNeUInVXZAIF3YAdtMttuR2fHAEXfJNOFIr
	 UfRZl0BVyhYGHjWllmIqZTcqHdC7vJ+opOCIygrA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH RESEND v2 00/21] mm: change behavior of
 pXdp_get()/pXd_page() in compile-time folded pgtable
Date: Mon, 02 Nov 2026 11:21:13 +0000
Message-Id: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACly6GoC/23QTU/DMAwG4L8y5bwix/nmxIFdOcARIZQ6yZZD1
 6od1aZp/52oEmyQHe3oeR37zKY45jixx9WZjXHOU+73pcD1itHO77exyaHUDAE1GMQmfHXd6XM
 4HAfRCCN5MJbIQGJFDGNM+bikvbPXzdvm5Zl9lP4uT4d+PC1DZlxe7+bN2EATXJStD4JH8E9+7
 B6o75aUWdxK+1eKIlvS0CaPMYrwK9c/fxe8FtaTcEFayxVVwoKshdHBCQBrIKZa8DsiUtlHgVD
 BQy1Q1YILo4lrZwXVMxxgLVSwSbXcEN7ssdyMX2/m8N8FeJEUJFDSFiXGq7xcLt+3EQ0LGgIAA
 A==
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
 Yeoreum Yun <yeoreum.yun@arm.com>, Sohil Mehta <sohil.mehta@intel.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9979; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=/ruFYOoOTay1qEU1I9vLoOZvo4kBoLe4bydBgAUldIM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIu8iIogGpWNmbGycs83LrN4wqYzMOwUWq+P
 2GNvhAAinSJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyLgAKCRBt1cPRWsUx
 M1ByC/kBIkBwShwNjoaNGzcdmLl/xxFhoSzIJmefzm5Xe9CleW6f41U4wOe9hbpWNEXEsWUnyav
 k+4T8+9Ege+ooH+lUXgpiNSpKtlBXTbp+s532UaXDc33iJZ+9hLCTdQOy64HeSdiusYTT0qnwGT
 nRrutkljrlVQv7aFrt1tUuBI9zItCbGE+LhqbLyY96YmJ59W4SYX4qQrUQKK7+Vheqw6fnrxMEf
 ObkxQMS2sWd+xrLrlsFUMd+uUWcfv1SKBWr/R5KmAGiM1FEmxa3r8oP/1xq1QVaeOFeNxoSkrbT
 +Fj1YTNWK2OojSmkKy0ZgpqilzPW12eT15OGR37rpHDAswe6QuPvkVYmYxu4R3DRtrkcO38Pa9L
 oy70CHn/JrUxCWyI729qJ0uhWYdk9FD2hHEKMuAwWOqrAnIafmQC4/6VtFTEy9rM6LoBXthH4GW
 qvmtkBwX145zHNkac+J9tIDyKxaUjPX3+YyKA0wedux8BSYWYZCzwWLDXf5v7U0VTAlLE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F8EFC0006
X-Stat-Signature: q41dnho4wh4iu7kxe6uzp9cd39bprzeq
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793618497-907987
X-HE-Meta: U2FsdGVkX19e0Rqiz/DE7MTpmw2filX/WazDrKmaxc0vFrzgnFbvZccpCgCuojDDVYyX6yzM2LyKcQqRh5liEnMJtHAXhiIXrow9cdhvrcu4oq3r2kew8UVxUanNwTSoueQoe3PLAl1P6/9hY1ndgAb8vEFyeFCSWMx+LiMHIEyTXpL95xnFhm6T2swgdrPVZBl5sWveqQmTLYVrWH21v6n5EX2ApxLUx/x2C8+Si90JIkMpD/2FoqqZcGcswk4UKhPQAHRQTrhKq+mSvAuGjiStboy8627nHGLxzNGxoNxTrKRRNHXPucv3Oq2L7ZshTeuJQCeF+bnHxvV2Len0qDZm/yYROteIQQpVlOonr5mqTTIS1j65Fu/NQ0hU1mcTWI7EKccSxszJpxilSvM9mwOohF0BCSJJS5ZUNAZZmjKXFOXohZ1V17/9gZjg5b+UZO9O5EwJs1qlT9S6s9kT4IMgAedyEBC0JIEbyQ0vf2sVafNb0fLyySwrkeO7lNUnfmKst3nz0qLYtawVwkAdZxEUhHx6+BErXR60FSsd56kp6Swl886QxUYQM4JUieB0AREMdcUw3vLLThR/dAVXfe0qDuC2uQln4Cepanep2OGIOc7SFW/XVYOTIEMB0eD8DvCk82cHjQyB7a8t5v0Uh2egM1vrMdXOTdMat+XJRWtAJH2hMC6gLt2ZjBly8V/eFcF0lf8GKLb5fhJNQNRIhp367IYyKOosVXkbs6uJBQcJmehp6YVHGEslAx19DFTM85px7px5jKnLwcGMmculQFC7dGtvATDcJhoggt8agzYGwg47a6q2DbiqSPcvxN6+q/BBCsuQ9xY4x0HwRL2IUj3Ouq8LhJmZOVjXFy3yJD6ADFgaCaXs4KuxSsncpHBEWY38B8Y6VcoOrsTrlJesLuLjCSkbF9G4spI9qTel57AiCl0XxF/j44IZSJDdS8BeIsoqlAi1Pj1Ki7pB+05
 OlXwujTY
 GlWBHBt+VuTj3DeZqg5f+/LPaJ9CruuQYI9wdvcLzMfQseIShpsswAAKZr7jy4c/hsGOxTD4kAuEl8KxAZg1Sh6JoSOwNy8IbMhkv9KDbr56VdWlKthSJhsNbub2zqBujwFGaX/37NGe0jqRaTCZ15QoHOXhnJkJqXYh1Oc5RbBoTIWjb+FPBN7oDNd/loJtrs9cwPF6q1Oa84QlWFfR5TyFxgJTv6cusectaGShhcBBzduGO/mh9ClyrNA94YKFp60eoalIQyaEUQ62VNeMP0oVB+l40ygZ2GYe5Y3RBTTIqyMjvIxciCOjdheFnCUpJ5hY/GBOmEQqTPds5D+30KQzQBRcKDAW+WQ8DNP5OmTLYTNj65DXu4hX9oAg3Te9IBtuv4lTElnuoFzPEVz9lOfVzjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com

Patch History
=============
from v1 to v2:
  - fix docutils warning.
  - Link to v1: https://lore.kernel.org/r/20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com

from RFC v3 to v1:
  - Drop and rebase for CONFIG_X86_DIRECT_GBPAGES and use the Dave's
    patch (https://lore.kernel.org/all/20260902194718.E1FF3041@davehans-spike.ostc.intel.com/)
  - Link to RFC v3: https://lore.kernel.org/r/20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com

from RFC v2 to RFC v3:
  - repasre commit message
  - move ptdump_pgtable_first_level() into pgalloc.h
  - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is disabled
  - docuemtns compile-time folded page table
  - drop the applied patch.
  - Link to RFC v2: https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/

from RFC v1 to RFC v2:
  - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
    and add check whether they're called with dummy entry.
  - Add some comment for returning first entry of pgd in arm with
    2 pgtable-level
  - Link to RFC v1: https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/

---
Dave Hansen (1):
      x86/mm: Introduce helper for checking direct map 1G page support

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

Yeoreum Yun (7):
      mm: vmscan: remove stack copy address of pud/pmd pass in walk_pud/pmd_range()
      loongarch: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: kvm: remove stack copy address of pXd in pXd_offset()
      riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
      mm/pgtable: redefine PGTABLE_LEVEL enum with ascend order from PGD
      x86: mm: use pgtable_level enum in effective_prot_pXd()
      x86: mm: carve out the generic compile-time folded pgtable case in effective_prot()

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
 arch/x86/include/asm/pgtable.h              | 14 +++++
 arch/x86/kernel/cpu/common.c                |  2 +-
 arch/x86/kernel/machine_kexec_64.c          |  2 +-
 arch/x86/mm/dump_pagetables.c               | 18 ++++---
 arch/x86/mm/init.c                          |  2 +-
 arch/x86/mm/pat/set_memory.c                |  6 +--
 include/asm-generic/pgtable-nop4d.h         | 54 +++++++++++++++----
 include/asm-generic/pgtable-nopmd.h         | 54 +++++++++++++++----
 include/asm-generic/pgtable-nopud.h         | 56 +++++++++++++++----
 include/linux/pgtable.h                     | 69 +++++++++++++++++-------
 mm/vmscan.c                                 |  4 +-
 22 files changed, 371 insertions(+), 142 deletions(-)
---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20260722-dummy_ptxp3-3741d78cc70f

Best regards,
-- 
Sincerely,
Yeoreum Yun


