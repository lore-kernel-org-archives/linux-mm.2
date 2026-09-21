Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AD2C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E0D6B00E2; Mon, 21 Sep 2026 06:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F11866B00E3; Mon, 21 Sep 2026 06:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00416B00E4; Mon, 21 Sep 2026 06:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8E906B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:56:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53B42140110
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:32 +0000 (UTC)
X-FDA: 85237465824.10.65E25EF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4E3621C0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:56:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bhv3Dhtu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fc1ZQI0wntwywl09IBCNncJjZ7nijCa0XbvCKfOrb3E=;
	b=Iqzt07OqIhkiU2kO8iBSYsD4dk3TCul1NfwhHTfuVhaFSkvz//2Lqpu/QuaVCLs31hsCzg
	kkyRy0YtkOE3qaRBz4IXu2+Ki2E0ilZ2MTu/s/d08vpOjdSIx/YVICuJkWLbkOc0x+WJNX
	bOvg1LjZ4bBt5ouQQPDzdkGnJhyqxAo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988190;
	b=paEQ8syTGeFqZMYNpwbfWTbnKc05beMzT/PZB/kQdWUxDv4JS0CXRkWM7nkvJxS52TPyto
	/hbYrmGENz8QqJxwLOAMVSuBuycmSqierULvCZlcvy9bd67+Tm7zLVr5Fw0S8Y5xlKwYLr
	ouKOXvZNTeI+U8YMyothGtxoTkdjYFY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Bhv3Dhtu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BB301570;
	Mon, 21 Sep 2026 03:56:25 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B5A33F86C;
	Mon, 21 Sep 2026 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988189; bh=+i8NbpdYfXEvFu0AxrNhp/lyU11LX+xOPtpkodZuoZc=;
	h=From:Subject:Date:To:Cc:From;
	b=Bhv3DhtuD6Cc8rwixG2H8y2y5nevldUQEJ99eSoyfMk4qBO2ab0cToeT2cXbSDP1w
	 5B9PvkL5BTasymCaQ5TeMYR9YHvDUR7NMqo9NIWozjErm7RSi1y6nW7vnof/bEQ1HK
	 jQ+R2xJUOx4CXO2rJCd6zgJruSt0PxXkpmhjZxz8=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 00/21] mm: change behavior of pXdp_get()/pXd_page() in
 compile-time folded pgtable
Date: Mon, 21 Sep 2026 11:55:22 +0100
Message-Id: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABoNsWoC/23P3W7CMAwF4FdBuSaTEzc/5WrvgRBKHXfkorRKW
 QVCffcFpE1M4fJY+o7tu5g5J57FbnMXmZc0p/FcgtpuBJ3C+YtliiULDdqC01rG72G4HafLdUK
 JrlHReSIHvShiytyn67Ntfyj5lObLmG/P8kU/pu97Fi1BxpabLkRUDOEz5OGDxkE8WhZ8lf6/x
 CI7stD1QTNj/JPb35tR1cIHwjY23itDlfDQ1MLZ2CKAd8B9LdQbwVT+MYAmBqiFNrVQ6Cwp23q
 kekcLuhYm+t50ypF++eOwrusPwv8YutgBAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=9844; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=+i8NbpdYfXEvFu0AxrNhp/lyU11LX+xOPtpkodZuoZc=;
 b=owEB7AET/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1KCbJJAqHkpHjl4ozK2NXp7qf/cafPN5Gsm
 +gxHtcAZRCJAbIEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENSgAKCRBt1cPRWsUx
 M+6AC/iJXNspes5rnQWu8wvadRPsdMNjF1lkZkrvJR3XjCh++EMLT2t10G/96ThPJv1v5gudtBJ
 wlETudZZqHVDDaWl8iuv4U9wk7WbgdaOFBa1UBfPa1PeulkrDL6nDPzqXPi8osXF7i3R2vbvdJg
 IF+tCtEMy4u9DQbrEoJ9ESuzSzVxhob+Gp6+Fhs0dQhuEMQC15auP87Fbmw4AYVhYudLSzhzOt9
 bNm0oDqDg5tIA2mbbLeiLgftFe1AxtIOyEHTtFZbZKbpwMliY5L9mYbbwr8UVLUMi1pi1vDo1R7
 tQYmfPoyqgGZEevfxxri09zTop97HbHrhQBlUvdICPJD79ASKUhR5VlSYf444UwlyaZ5CArG4u7
 IkCnlcTdm3AKMrK6uK/kADc4i1VSWiCF2O1j5hQVk2Vk3m2VH0asj1iA7O+iwV856nWBXdpA6vo
 ZrN09/yEVvkZA8rhUEmyeetMXNcvxN7nCNWUOZL6wF0fqvoskNUFimzkkBvsXTShde8g==
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4E3621C0006
X-Stat-Signature: c6udff637r5fqdipxfzhnxznbdnwc1ph
X-HE-Tag: 1789988190-765063
X-HE-Meta: U2FsdGVkX19HJ957hfxdNcavGJCFYe7tg53oFGwUjLvCPFfhq6TVD8GsWPzh7YQy8mM+fx1uCSc6gmzGZ76MGMoOZUSLeIHZw7ZJhMiSW585rDmBK0RipyFeQlFzkWCmspE++u7kezZASzlcG4Ic8kjOetRstsJDVjJi1QcKOPQke8JB5ve3LZzScWR5ELStxOclVQIfKQLCZhwGc1aW4V1q6800suj7uzPbWqjn+fh9+w0a6bWtg1WwC9MT7WjrzcISAHDWG+B+HE3vBnCgmY6VspZulW1gG89Au9mktADnpMex+wEhxUvJ4f4qm2X2Gx7lhkJ0GWhZ5NCzXzzqqEIm6N60zH7ASVmESQ8yKNffpAMIzSI0atp4UhxW3/Iva4SDj8klTe++MBqbubpLX/nhm62k+QITFr1HZc9qcEDBKeBbkAnnZ/BhSgVBP69CA0khLVMyICVC7z2bcj55kXG8sJkS8XVMroEuiWvjmREoSaTDwgaStQzkAqVUL1XLDRR4ff/GLqEhXr3n6PashAej1NCP+/RiyfCgr3RolvVj57lS/Ku8qmZAJEoDfZDeRYPmijjiSkrv0R1xuht5GM/i0WE8zT3Bz//RCNhd2fdFNTpzXAUJZldzm7gElPFhoGHrVA8ImEShvdWybBymvpvwJYTy8H5AjWwFQTIKypnGqKpo1XBoXaQNklnaIpod+b4RLSM1p3dVsu3w0bTg7NOEIBYZSqlY7I+BcoKivUZC7R0m4vmZ6cmEiC5C4Qg4R4kqJwHEac/19fP9CIPg7iDIPEmRfksqoAT5yW0QX2opBiiT83H0KQ4QlaRQ3JMs35hIVj4yPy7XqwSTVrb4CMxTAEDhyGDWxTb8NdE6rRD3MpHvUXiWRjaKrlxu75oL/kOWIEryteQrDsxhRiJGHU1P3D8h92ywiUxy5bzZRbhk13YGiltj1ZR5GA2wHu6uxF6NozE20FV4ag1dzIn
 ddjq8vYs
 1/LGeRiTbHsIzUIrdDtPEdRdHNIaHn/46sCM7aYu7cggLX0bsfEaru+Esd8Zm1aX4v+Ig+Ddon2L1xnm5BYUfYRJ6s/1iFCMRm86CtcNb5DmItPIQTb5TkPZUg9iw7AYxwvvmyF/tZc8dbWnt/wo8WOBlA5d+Z6QYKtON5HsogAcgyiBJxKxFBY1jn9GHIZW5PXoflsEhR6q+ZzcYGwj59o/FXGcqNA5J3Tux2TtCdcMXnSgl+l/rFHueK55Nw4pGz5PGK07plqoRjl3BPVG9sfarBjhyeqJsmGB86ULTabnyoqZwHsEvKi+eBkD4QbBzStrEDei2EpiN1lW/RL2Zr1nMHR1kYnvVKe2HsUidcFKktEoI+dk+l9U4M5qZgB/mSD+agXpKTBgUooJ3ZJLGvB8dwA==
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

Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com

Patch History
=============
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
base-commit: 8d61431ed2607386b427752505379536eb634ce8
change-id: 20260722-dummy_ptxp3-3741d78cc70f

Best regards,
-- 
Sincerely,
Yeoreum Yun


