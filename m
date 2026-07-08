Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A2DC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C736B00AB; Tue,  7 Jul 2026 23:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26B46B00AC; Tue,  7 Jul 2026 23:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E153B6B00AD; Tue,  7 Jul 2026 23:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A46316B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 205CB1C3BA9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:37 +0000 (UTC)
X-FDA: 84964134234.13.FA2D0F1
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6FE1716000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JEtHLnyl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 35b9NagoKCPQfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35b9NagoKCPQfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w4fSGZZKxTAEm7QBmM/ifgE0KdTZsw8zslELXp4R22A=;
	b=ZauKQ3uJMZ5LM8vkCuAjjvpyAm+sxNbF9bV8DJep1LkUF5PZCyoo79xLKlW12JwqjXSlEc
	I6xBlhNwhckcgV/pD2SLXOMUOBAaEmpLXFgdpxSxJ7658QrtoOkrhWNtktWnehgS4gYUt2
	bbCoR8CiEB6mSHidOH0dX28Vm68KZUs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JEtHLnyl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 35b9NagoKCPQfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35b9NagoKCPQfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480295;
	b=BSldr5X1UNckDILt6J1wS6IG1zP58APX5a7+RAvjbJbD3x2G/gXjtLwLSvfiHtfbCI8bOE
	GgQn2+Nttt86CVDreTNE2xEyYovPylf9OirExplYhTomCs9GvhPXoBG2OaWXrsNNpYGIWk
	Hnwqyn1SPen3kux6GisRjdUAadynd14=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8478423e020so416274b3a.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480294; x=1784085094; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=w4fSGZZKxTAEm7QBmM/ifgE0KdTZsw8zslELXp4R22A=;
        b=JEtHLnyl+/OPQi7PIVYNnk+ebarbI2c7e8PRiUak2B5DJB/LMnxExhGxxW64cLhXsh
         EdBJuNzhQGLArsZ19C7jRqXaNEvOfpDc/2aMiExNUz+A2lml+TYAAW+4k2iLv2YSLiKe
         xuDcl6ulAvblyco9tKxcbPSi837czlZIJT6212xELCZ2mt0F/QUkAY8mDCeE1LNBP3/O
         6HdNtUhrDCqbbckYVAiwUWjzMSe8ayAS6oO3ypoqzibNTVH+TMwkwuD+tWF8vaAitkf7
         Ob6cQ841SkGPiwQzb693BnlHqIhKVhpM+tWJ2XOlNOXvFApYitetbm1LVHbf41lo8Lgx
         ML1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480294; x=1784085094;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w4fSGZZKxTAEm7QBmM/ifgE0KdTZsw8zslELXp4R22A=;
        b=ZAucoTCrGYqMJpUY0u9Hj9svpCsPLKWCRbZWx2BIk2SUCAixfmrXuhHtXxS8kThRgM
         rGCryLc3Ara8Cr1jK7BtswtRkaGDcX9H09EObQqzCbrNyjyj/87ZX6i8OrDvHNZAnli1
         z8IppjtTmgC4BXktzamXFysjoy5YYHU+5R2zIeIn4atnYoIkaJNTtFhP5mpfmcq6IRx5
         wopo9HXzwKsV0WR28Arwg4z9fPfa9lErNKSs4L/XDN9IKO2C0Xf0O/QnJUOJo4xc2df8
         A/1tR0a5ReTTvrk/1K72ExwdD7v9bTNjXPtlPPFeeC/BZxvbSqGO0Pxq0ryYKdPJXLzX
         07/w==
X-Forwarded-Encrypted: i=1; AHgh+RrJSVnp9wboh0RXt91yJgpufR5zeNEuKY4G3pBsJ61IJ7QWeEk8KlFkSwqntO1j5KYFNZ81MhGdKQ==@kvack.org
X-Gm-Message-State: AOJu0YwSzvNTgwPanLBiBo4bLsXCtvE2QpPIb/kuazFvkZDbZktyjQ8s
	lWhwej4RRd+0FLYCcnq7/JPOZaZ6DnKhajK8HQUdXFnBi95z2SQToz80NobHbM1gOCXTBB8xuJg
	7QL3Bgv6S6T2ZdaVBYRerYg==
X-Received: from pfbik4.prod.google.com ([2002:a05:6a00:8d04:b0:848:3cf3:73fa])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:6f4b:b0:848:4754:28e4 with SMTP id d2e1a72fcca58-84847542d78mr152108b3a.15.1783480293882;
 Tue, 07 Jul 2026 20:11:33 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-1-jthoughton@google.com>
Subject: [PATCH 00/18] Another attempt at HVO support on arm64
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6FE1716000A
X-Stat-Signature: xfz6e8ezrub1p7wjxsasdqq57tc5ff1p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783480295-628380
X-HE-Meta: U2FsdGVkX1+VpRCdW90XMnfW3jWlHwaD+KgZ+kaxHc9knx//2wnFc5HCGeHhBVLveffRzZ+N6vtjwi9aCugrRdCU7UR6ylMyY8zkdxV1azG6HFgzgCaD7TTO0IEHfcH2Stbw+qOvuPXHTP2sm8PGSP5pjLYfOpB9NSKEVzW2oa2sBmilKx5mmgCtqxpG2tbYLR4o7s+c0eJffSfYkU0z2YIDaIzMgjcC+7fdZ36bHa6SXKrcDJaoRAANM8lUEvMJ4Sv3MKOXkemOdtATSLjNqyzfuZ4PtiTmvTTOIqKKAnr6cGTf3IiQ1XiBdNrFxktLOrG1oRoMTOeX3NdIZ/UDBGDrwduxqD8tMtCO9e63FsLT+gv0ekj4rQMma9rO9Bhtl9IzpElygQA50oQHCgKfs6rfXCTWG2sKuyJusXlb2/bMVT12tYp0wTGKG70lYZlgEqq5dSedjvjQlsvHAHnSPnHWJmukKamlFCJNp+fIgyEqUM+JA6UbqYYHdbS41+WJ7fsfF2UgN1/pdy/wPci+VMryvHaTGidm/zmxQIR6ev9eguhg7HxD8B++Huv8LqvhO5Tr3KDXKAJm+uq/twf+xWcnddX57/PKyqV4I3GC+aa9Q+mRoPKEM05a2p/PgHBWyhiFArxJGb5mpEN4efY4W+NBRMj9iEEyqcO2N7ORRubpt1LRnv4EsrkCWB6HC12aiMJLKUIL8x2H/Wi9VCm4TAPakNlWmvE6o93iKs0ck6chwm07LEfktHoXazUySc4cUAiMGuqlCIgn1Kj+Yb1MlM9++kJ7hhRWksW4jpGleS//z+7NqZ1ujiioXtdEIXWPh04iR7MmhCd5F5nGcg/sbivATPGwzalgWYf41e3J/lfCGwBJs2eWTjiAXLgxe3r7BgMjOmN7zW7gpH1ImKaSbAzHSx2op3IMFLWhvvMI0HbHFjFerT517UbtSctPiM0bQaigl8ySdr/u6ykAuzN
 Yq25kqq9
 CCqsRvZnYOvnIsQ72t8bHIgmshnsYi+q/ZevrhSWcPjRtaWMTJijGjxbsjSKU2QK4eElURArp3blmNuSalS/hW8U1ah7m57ezYyruKmObC6FTzDJgeHhAkTarnQ0MoQSpTBgO+lJX8BEHu8c+R/VPx1t8cfR+/OEIR8Y8/pklttzjzcqlmmgAKwQUuAFsdvtpU1EablTF2zcPvkxBwsfK6Xqclr8OzZgEuQiCMfKEN7pYKKJs40vZWaXrGT84AFwS4Ul8RpeucqWuyjr7b2Tmr33+tBoWU1PSovUJbxWLvWVmzDuoR4OQw/4gj+gsKQ5C9tDuvOl6WGULwZQdeCfEJPX7W3c8nBFhcrOXSKR7HIVKWbdc3q5zH9kJXeHXU6vPLkw7fWKloPkbYYfGZYhWK/xCgctp4IqYwJUVuKq5WNXKCjHmDBJvYMCmOetYR1GmGm8gF/Vwi5oy+T//R1nanEKph0W5UXz3ny0hG+zW0BlmFed3oKZnCZnbrEcbCaI6M68gcE1XfIm2C2bYu0sGkYRDPmw4NjhLEX93cXQAifIRMfm1lmepZgfNagw+H62STLwT5/v86yQA02SWhq9o0PDYBJgAu0A/rdBOPen1wUntK/POLLUo3pGj/8E6vJYQ3xf7bsXSQKYLbPIzgs6/ziEQbqu4DffA2i/g6tqoOOR+iOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

This patch series uses a trick with the Access Flag on CPUs that support
hardware update of the AF to update vmemmap page table entries without
introducing a time window where CPUs accessing the vmemmap might fault.

By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
implemented correctly on arm64 in a much more straightforward way than
previously attempted, most recently here[1] (please see [1] for a
breakdown of the other approaches attempted before).

For large-memory systems that allocate most of their available memory to
HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).

This series has four parts:
  1. Some preparatory changes (patches 1-3)
  1. Bare minimum HVO support (patches 4-10)
  2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
  3. Drop the user-configurable Kconfig for HVO (patches 14-18)

Parts 3 and 4 are technically optional. More details below.

The main functional caveat with this series is that bootmem HugeTLB
pages are not "pre-HVOed". They will be HVOed, but because at pre-HVO
time SMP CPUs have not been enabled, we cannot query for full system
support.

This series is based on 7.2-rc2 (0e35b9b6ec0f).

This series almost 100% cleanly applies to mm-new, which has some of
Muchun's HVO patches, with one trivial conflict. I imagine this series
will conflict pretty heavily with some of Muchun's other patches[2].

-- The AF trick --

The trick is that translations with the AF unset cannot be cached in the
TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically updated
without needing a full break-before-make sequence.

So the PTE update sequence becomes:
  1. Atomically clear the AF on the existing PTE.
  2. Invalidate the TLB.
  3. cmpxchg the AF=0 PTE with the new PTE. If this fails, goto 1.

If there is a CPU on the system that does not support hardware access
flag updates, clearing the AF is problematic, as those CPUs might fault
on the vmemmap usage. Therefore, HVO compatbility checks all CPUs for HW
AF updates.

-- Application to HVO --

HVO relies on the following page table transitions:
  - When enabling HVO for a page, PMD block entries in the vmemmap are
    shattered into PMD table entries. The first PTE remains mapped
    normally (RW mapping to a real page of struct pages), but the
    remaining PTEs in the vmemmap are mapped read-only to a shared
    page of struct pages (that is, there is an OA change and a
    permissions change).
  - When disabling HVO for a page, the RO PTEs are remapped back to RW
    PTEs that point to newly reallocated pages of struct pages. The
    PMD block -> table transition is not undone.

In patches 4-10 of this series, I use the Access Flag trick to do the PTE
OA and permissions updates. We rely on BBML2_NOABORT for the PMD block
-> table transition.

In patches 11-13, I re-use the Access Flag trick to do the PMD block ->
table transition without needing BBML2_NOABORT. For systems that support
BBML2_NOABORT, the logic is unchanged.

I am aware of Linu's BBML3 patches; I've opted not to rebase onto them
for now, but I am happy to do so later.

-- Late-onlining of CPUs that do not support HW AF --

One of the complications with this series is how to handle late-onlining
of CPUs that do not have HW AF when HVO is in use. Naively, if HVO (HW
AF) is supported on all boot CPUs and the kernel is compiled with HVO
support, late CPUs that do not support HVO will not be onlined. This is
a regression.

This series provides two ways of dealing with this. First, add a
default-off Kconfig for users to enable HVO support, avoiding the
regression. This is not ideal.

Patches 14-18 get rid of the new Kconfig by allowing onlining of
HVO-incompatible late CPUs as long as HVO is not actively in use.

-- Litmus test --

The following Herd litmus test demonstrates the PTE update routine:

  AArch64 TTDFaultlessUpdate
  Variant=vmsa
  TTHM=HA
  {
   uint64_t x=1;
   uint64_t y=2;
   [PTE(x)]=(oa:PA(x), af:1);
   0:X0=PTE(x); 1:X0=PTE(x);
   0:X1=x; 1:X1=x;
   pteval_t 0:X2=(oa:PA(x), af:0);
   pteval_t 0:X3=(oa:PA(y), af:1);
  }
   P0                | P1             ;
   LDR X4,[X0]       | L0:            ;
   MOV X5,X4         | LDR X2,[X1]    ;
   CAS X4,X2,[X0]    |                ;
   DSB ISHST         |                ;
   LSR X9,X1,#12     |                ;
   TLBI VAALE1IS,X9  |                ;
   DSB ISH           |                ;
   ISB               |                ;
   CAS X2,X3,[X0]    |                ;
  exists
    0:X5=0:X4 /\ (* First CAS must succeed *)
    (fault(P1:L0) \/ ~(1:X2=2 \/ 1:X2=1))

  (* This test should not violate BBM requirements. *)

This test must be run with herdtools with Nikos's changes[3] to more
accurately model BBM requirements. When tried, the output will notably
*not* contain the "Warning-BBM-expected" flag.

-- Testing --

I haven't yet done extensive testing of this series. HVO is correctly
freeing pages on my system, and the hugetlb-vmemmap test passes. Freeing
HVOed HugeTLB pages also seems to function normally.

[1] https://lore.kernel.org/linux-arm-kernel/20241107202033.2721681-1-yuzhao@google.com/
[2] https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedance.com/
[3] https://github.com/herd/herdtools7/pull/1864

James Houghton (18):
  hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
  hugetlb_vmemmap: Move vmemmap_get_tail up
  hugetlb_vmemmap: Leave pages partially HVOed upon restore failure
  hugetlb_vmemmap: Use try_update_vmemmap_pte to update in-use PTEs
  hugetlb_vmemmap: Allow architectures not to allow HVO at runtime
  arm64: Rename cpu_has_hw_af to system_has_hw_af
  arm64: Add system_supports_hvo
  arm64: Implement try_update_vmemmap_pte using the AF trick
  arm64: Prevent HVO if the HVO system feature is not enabled
  arm64: Support hugetlb vmemmap optimization
  hugetlb_vmemmap: Use try_populate_vmemmap_pmd for replacing in-use
    PMDs
  arm64: Implement try_populate_vmemmap_pmd using AF trick
  arm64: Drop BBML2_NOABORT requirement for HVO
  hugetlb_vmemmap: Rename mm/hugetlb_vmemmap.h to
    mm/hugetlb_vmemmap_internal.h
  hugetlb_vmemmap: Add a way to permanently disable HVO when needed
  arm64: Allow "optional" CPU features to be required sometimes
  arm64: Permit onlining of HVO-incompatible late CPUs if HVO is not in
    use
  arm64: Remove user-selectable HVO Kconfig

 MAINTAINERS                                   |   3 +-
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/cpucaps.h              |   2 +
 arch/arm64/include/asm/cpufeature.h           |  39 ++-
 arch/arm64/include/asm/hugetlb.h              |   7 +
 arch/arm64/include/asm/pgalloc.h              |  54 ++++
 arch/arm64/include/asm/pgtable.h              |  57 ++++-
 arch/arm64/kernel/cpufeature.c                |  43 ++++
 arch/arm64/tools/cpucaps                      |   1 +
 arch/loongarch/include/asm/pgalloc.h          |   8 +
 arch/loongarch/include/asm/pgtable.h          |   8 +
 arch/riscv/include/asm/pgalloc.h              |   8 +
 arch/riscv/include/asm/pgtable.h              |   8 +
 arch/x86/include/asm/pgalloc.h                |   8 +
 arch/x86/include/asm/pgtable.h                |   8 +
 include/asm-generic/hugetlb.h                 |   7 +
 include/linux/hugetlb_vmemmap.h               |  20 ++
 include/linux/pgalloc.h                       |  20 ++
 include/linux/pgtable.h                       |  21 ++
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_sysfs.c                            |   2 +-
 mm/hugetlb_vmemmap.c                          | 237 +++++++++++++-----
 ...b_vmemmap.h => hugetlb_vmemmap_internal.h} |   6 +-
 mm/sparse-vmemmap.c                           |   2 +-
 24 files changed, 489 insertions(+), 83 deletions(-)
 create mode 100644 include/linux/hugetlb_vmemmap.h
 rename mm/{hugetlb_vmemmap.h => hugetlb_vmemmap_internal.h} (95%)


base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
-- 
2.55.0.795.g602f6c329a-goog


