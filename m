Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A25C44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42966B0132; Thu, 23 Jul 2026 04:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A136B0133; Thu, 23 Jul 2026 04:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2FEB6B0134; Thu, 23 Jul 2026 04:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 928F86B0132
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:10:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2631F1403C2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:10:46 +0000 (UTC)
X-FDA: 85019320092.13.F8499C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FF041C0009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:10:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZsKSCke4;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784794244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKBbYlt3EN97r5LlW1yjw1Ct3m+qXd+vSTLqclgmzVI=;
	b=dwhpl++s8zoX182PrU8UdH8h7fk+9mi3CiGw00viCpiNY7bOstpTijynLfnAr6oTfftzFh
	3YGozkC+cbgLWG49z+1MFaI2ymUzldJxL99nkP7SgywHRTpYc4qKVmY0O8B0sL5Wsis2fn
	Mpag4oRgEYTcchNGBGUGYD7DkmpiI54=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZsKSCke4;
	spf=pass (imf21.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784794244;
	b=26fNLo3xFvacmy5hK4IMIhRAfSrFgePR3oDQMfLufHYDMwqpwuRBM2zhd5BQS8Aynv4+Tw
	47A8F/xS7GgtJmfGyiEDyC5UpHDgA8DCcO0fYGTRLTnou47ZWTrs3QgNXbeBNNg5PFGvVn
	mTLGsFYM9GONfZJNqHBU/gWp6rq3u/w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BD4851477;
	Thu, 23 Jul 2026 01:10:38 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E3A113F86F;
	Thu, 23 Jul 2026 01:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784794242; bh=VwswH8JhWrZQe5Rh/s4NWY+0YHgxDEZK0fxwcE3tmC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsKSCke41l+piIezCdsjVMCTycpwyBxBfv7cVpgUUcClGAM9ujUfUEk2EpanfRxZJ
	 acXhRw1TtHmQygGi/rOp++vlaGKB/odW5HbrUODJQ29zMZJuEBsamNuoJFYZmPvDIo
	 2Cs26OmAVBZMccc0uflFY2F7f+U0rPR2u2lp9iGQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: David.Hildenbrand@arm.com,
	david@kernel.rog
Cc: yeoruem.yun@arm.com,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: [INTERNAL REVIEW] [RFC PATCH v3 01/20] mm: change behavior of pXdp_get()/pXd_page() in compile-time folded pgtable
Date: Thu, 23 Jul 2026 09:10:16 +0100
Message-ID: <20260723081036.1461495-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723081036.1461495-1-yeoreum.yun@arm.com>
References: <20260723081036.1461495-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FF041C0009
X-Rspam-User: 
X-Stat-Signature: 8cgwpi4oi3zb9n7acmzq7z69oufpi9oa
X-Rspamd-Server: rspam04
X-HE-Tag: 1784794243-614721
X-HE-Meta: U2FsdGVkX1/YXXRJWHQp81cYvxuOsWa6WNKrzLbHdIDVv/VR/3pn1jcBL7GoYXUqmM/5ynQBICwXCT/bXnW2ocRaWowH1Z4ap5sexonuKlkoq6tl19fHpfoRiDvK4RvOXtORhHuK7n0gaFa7GGx7e0esugWKuJA6EqoE6ZGXaII7AcjVcDfHwStk4P5qltToTO6b9g5uJdaM99SRH2qmaVjVEVLlMSnBoxEVkP9duwQaF8eaKIjClZypfFTnFI7//9sPtq/UaNC7Upb3KU+hia3mUfj/j1d++WcyTICQPKUx6wRt5F/9hR9ZOago3ORGXLbQZdd0MLXAM/N0svzZY1HkL2xz+6ON9aFtoqrk7fyA/Wq3kRm7GcMfSdbD6FVUsvgNa97XYpQcrpe8iZ/WOdQczswZQ1Y+5676evO96K2wRk9B7ON491p64TjLOs3V/8IHgiqyqFBRQmn8xFmgI+0WHAXu6R/1weYCwU7tT1J12o2IacYIDU5DRLrDm0JKmvnNpeznn0+s/pfBre2/NrvFZFj0nGQx7sgjmHM9vc/MGDKRqdS+yiV+fmgCgKrWYSQ6rMOk+uMINUOydpu3h+OXNavBVQbTWHkvc1uF1qxnCubn4g3iKpWZcIiALV6sK20qso4b6N6LO78UNjWYVW6l66HNZwBw4sx6yaNaQ8GsXsFRKaHz2pejCZLms96qtsm1jiMsXxVJl4CtSTryE+pPtxthAtsV6aBJbhzJ5nY0f5S7j+bFHOh8XYYbCFZPGBN4tnWYIL8kCd6BfzzCC4HhC0rET7xdbfqgd8fuNt4Cl37PdmipIUff4Z/P+tD+rwTQrwiEmY5MitIp+OMcprdIsuCyKb2cckm3VBtk60ZbivGKIMAqoWXam3GEIqQri8E6MQXYVJYStq13bg+nhtTamepeXF8qkFE3Os5Zw8qfrIpopGY9kPZYcRIVG1KfiE9f6Afdba2KX6Z12VD
 fzEOToeO
 S7NOujsatL2kJB4j1qA4CmJbAJ+pGyjZ4Efzy2URIJdnJldDzBqPm/N9T6FGd17EHXUfm89hBFCyvbAePIzu7I74HTXgxjzcY1Nf1E16UTsztUH1TO3IBpkM5PA+6BR+609Q/WyqXZ2NXkNObLPIJ10sXA4WDRBXusfgAY4NfshHpLyKUuIBJBurqWHBTxlOVex06l8d11J0cEfDppxSC1NJ/pONRNfB+/gs7lpAhG5s8rMBnIGUInECJFZlefZNOK48NLgydN5wSqlRuWQVDVl6OurYXF3LOYJob4Ixwb2bYXdnUo5QbriOKbwy//go5iaonTcK6UJXUsJ1YZh5z/UUbG5nZ9mT1rG//pxTajRZwypwSfQBgkejcZyyRP893z2NXgncafx3PYvBkWoIek7rhGzCbiPBYQrmYyJZz41GHfbs/VJE5gRVcWLHUITlO5J/Iq6kjjW6Y9lP7KwXrWLTifOCnILBAKSGGCDqW7GhP5oQA5k51IcRYbnw4vDk1bC7j02/CxwseDVumZ5uYkijmVv/fcZB7H5idx50Rrv3kEt9ZNqZeba+f77JsCPt8+qq7ZPXXIfEtO5BboHVUEt1hM1v1QbGkrmbww69mb4Ne/vdtHT54ltTBtBZns6NxGWuhb+fpy2Zn84mNuQQBehkMTzHTS7fcXfZCc2ymwItqHLmGHEYM0IP/VBUSRWBfxRmfM3p9KCmXlYTHwecj0udghCqX+A8ivCZkZpLtuxs7kjBOY7s9i03ASifTSvKBN1LGonpPlNSLDsjH0hfScM0sa5m1+KLWGWeNtQZla9OfKLh3JP+PLEZhAFOxBnJQfAiNrUlIXKn6OzHygunOSfDyQkYtl/EXr47XcsEpe65ShgqfM573IpEg4si77g3zQPB2ts56lgEjHxN+P/1bVDPHCY+hZdn/YmOb6YiPLQBTGqgn/vqgI3MR7NYU13hpUg0ruWdgIMra2eqp7L6IGRPBV+h1
 W8cRzWWe
 TbVEONeOg7sR3JSYa+NdsSKLOdepMSqBN0vRQsUTjXb3dNmp5qMVqigCMdwkvfZ3JzglkShE3Omrh2T1h3g8eUCLlep2ObV0nln2mPfoADMxh7Yp/5J3Tg==
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
entry for compile-time folded page tables and prohibit calls to
pXd_page() in pgtable-nopXd.h.

Also make the helpers in pgtable-nopXd.h, such as pXd_offset_lockless(),
validate dummy entries at compile time to catch the wrong usage.

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
from v2 to v3:
  - repasre commit message
  - move ptdump_pgtable_first_level() into pgalloc.h
  - skip the huge pud operation when CONFIG_X86_DIRECT_GBPAGES is
    disabled
  - https://lore.kernel.org/all/20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com/

from v1 to v2:
  - Restore slient fallback to next pXd in set_pXd() and pXd_pgtable()
    and add check whether they're called with dummy entry.
  - Add some comment for returning first entry of pgd in arm with
    2 pgtable-level
  - https://lore.kernel.org/all/20260713135614.1618183-1-yeoreum.yun@arm.com/

To: Russell King <linux@armlinux.org.uk>
To: Huacai Chen <chenhuacai@kernel.org>
To: WANG Xuerui <kernel@xen0n.name>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <kasong@tencent.com>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@kernel.org>
To: Michal Hocko <mhocko@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Tianrui Zhao <zhaotianrui@loongson.cn>
To: Bibo Mao <maobibo@loongson.cn>
To: Anup Patel <anup@brainfault.org>
To: Atish Patra <atish.patra@linux.dev>
To: Paul Walmsley <pjw@kernel.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Albert Ou <aou@eecs.berkeley.edu>
To: Alexandre Ghiti <alex@ghiti.fr>
To: Dave Hansen <dave.hansen@linux.intel.com>
To: Andy Lutomirski <luto@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
To: Borislav Petkov <bp@alien8.de>
To: x86@kernel.org
To: H. Peter Anvin <hpa@zytor.com>
To: Liam R. Howlett <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jonas Bonn <jonas@southpole.se>
To: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linux-mips@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: kvm@vger.kernel.org
Cc: kvm-riscv@lists.infradead.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-openrisc@vger.kernel.org
Link: [1] https://lore.kernel.org/all/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org/
Link: [2] https://lore.kernel.org/all/20251113014656.2605447-1-samuel.holland@sifive.com/
Link: [3] https://lore.kernel.org/r/74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com

--- b4-submit-tracking ---
# This section is used internally by b4 prep for tracking purposes.
{
  "series": {
    "revision": 3,
    "change-id": "20260722-dummy_ptxp3-3741d78cc70f",
    "prefixes": [
      "RFC"
    ],
    "history": {
      "v2": [
        "20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com"
      ]
    }
  }
}

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


