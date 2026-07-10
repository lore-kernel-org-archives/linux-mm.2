Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3938FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 04:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3628A6B0088; Fri, 10 Jul 2026 00:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313776B008A; Fri, 10 Jul 2026 00:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203186B008C; Fri, 10 Jul 2026 00:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9FE46B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:59:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 519E8C1CEB
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:59:10 +0000 (UTC)
X-FDA: 84971662860.30.3CD67BB
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 29162A0009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:59:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kp7H8Dl+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783659548;
	b=q6Pi6OfeXV69alYX5KJngv1bxdBF68aYpJkKc1txkVGZdtlLLzLvSP1I/xWr/ub411+O7N
	UXJoBrCH4gwx2kl/2X4mbAUuIASefF+USzzMxWNJjupr/PNV692zMPik21i2HHkDvtImS6
	SbUBz+UwLn56mm4Er2iIKFQK29cTn3A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kp7H8Dl+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783659548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfhA5mObWV9xOlIalj51moctdPsSARKApcsKWsQw+V0=;
	b=H7Z0B6xqlhLvVl+a2fkFpHbm/RaBozbbaKNLa0y/Ffxv6+u9VOACLpT02DqVkVc9gYwKgP
	sV7qoQnZFEla4+uWdb1uPaIG+pWXVV1ggjF9EI9I+e65D84ATVuYiihFXJtcQFz/HKbvt1
	ATjzMMgnyDLzDo/l2AbUbTbXwJWFdOY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783659546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZfhA5mObWV9xOlIalj51moctdPsSARKApcsKWsQw+V0=;
	b=Kp7H8Dl+ealeNCHL7ogMvFDT+WmY8nDPRfjeyjOSLw3yReBkB/+76TRe1NwDfx/nVePhI2
	oakc1bzUZxywHnBqFyejgKB0A21Oc6aoDdo39Sc8R9pqpBt4fHOT6ZfTGkptPHQatCnNag
	x/jWC1sJnnE/SrVIEgXs/A2LeRlfcPo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Date: Fri, 10 Jul 2026 12:58:18 +0800
Cc: Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3B2B37B5-16DE-4DB0-8A78-4CB8636C1A86@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 29162A0009
X-Rspam-User: 
X-Stat-Signature: cibyqg9f5n5d8sg3t7i57kur5d1snype
X-Rspamd-Server: rspam03
X-HE-Tag: 1783659547-725961
X-HE-Meta: U2FsdGVkX19pemtwS0jWxT0v9PQKkoZVGBA9fKJYa/2xfozli6pzX3UjuYsJopumXLcq3qmGlP6C7kpFIbm3GCjG2oSuD4dPL4GH8Ls1vtysn3hk0fgEQLTWRaqWzbvfHqKRmGFD8+8HZIKguplI3ZDUF3x9jobzNJR1hgZg8IGuPTyStsh3mMaM3V+ZnYYRxqDEv+o6BbeKqGtRVYEWgSZFczTS8uHWuofW0GD4GdoV1ambG4rByMnEjWKla6AyQPdv5U9z7RgrFbUPeltf38hP01k0VEO72k1sU5BEAu0KiyRVwTNjQWXF7zGMYe8hy/KQ9In6OuHNCjf6ZtKgGnTa3/2/NwcvjPk2DWq8bKg5xbwNbWp4Ms5OF71Us2yH6Q3f8BjBgBoVyP0r2SS0KRSnCnfzM3O/KFXBvm2Krkbaub48imtX09WCY1FlCwtLoaTsMeVIYNjCdQALSSA2UpqxN0Pp7ajKFmneWFAzQXlDNM3iycC0C0ZVTAHlAMY3r9k3gSLHztkRE2YHiMsONrrxFbw9eeHZODlp3QXLhiB17AaYXhTL5pCGl8OzlMp1to5hhjVhd6B1msRKdjjNnzhYu5qvEErb20GCOWCGLxZuwqHlwWABjQrJGARQD4CwG7rmcf21O8Jez9T4e0nt5FnRDPeQLBaETlnVx+afXDIuW3eSmWuSvFqFfgzLJEtJNqf2TlUXUi9jcgiVfWQzHhxu5adil5Dz/5y1LiCRLmBzNzR7QcTUZt6SR7LjCNLU1bF+S2M/mI3/q4Pu/r9VZi1Wvav/QCrKbTrkkXr9d5bu3HmZILRC5ktIOZ58R9eUO3S9/7kzSTX2obExNRAJ1QTz/fkZloSfETlinvIpZxTSIMHNVXr4V+3oYdAv1bxEUdnSEabGgec2RXz5vXVqhbsT35UC795y5J7H5rcFZt0yQCpqvOtmb/Me6iaR1thqUFipQglIdnMhBBRi2QK
 ealtBKe+
 vS55QVnWTRwUnNz+DJO4rzaXyVEtrj0kFk8NCb1GNgv34gCGJwsQWyGXg1AhLxXXLwLAez+d3Joo4ZWpbdlMa1JSEfV/2LmMkcfK8mAoItnX/4Mnua3qQLgPQkwjmnZbyAfvQ9zzarlfpHx38cOjpg6WNaaf7mIza1/hqnOUwrsdpPhRo5hR/ol7iqplsgun5oeXZLmMd5dAUBuKvrZ8wtXr5+8gjD70LmsNL10vJT1FEMICbpBlcjAZ084HLTXNSgByGBvzM6XOUDXbwZe14J1ZTwgO+8fJiWxW8lR4x4aBWU2Sh0vUwAj5S/R3qhohDSvFhyk24xCA1Rmu/8DoZg3Z2agsWi1BJATJW2P9YY70wyQgYuoXEbYCtEoQ8W1BgZzV7z/QCU2L/qFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 8, 2026, at 11:11, James Houghton <jthoughton@google.com> =
wrote:
>=20
> Hi everyone,
>=20
> This patch series uses a trick with the Access Flag on CPUs that =
support
> hardware update of the AF to update vmemmap page table entries without
> introducing a time window where CPUs accessing the vmemmap might =
fault.

Hi James,

I was just looking into the Arm ARM specification regarding the TLB =
caching
behavior to better understand the "AF trick" used here, and came across =
a few
sections that got me a bit confused.

Specifically, Section D8.5.1 [1] states Rule RDWZCQ:

	"Descriptors with AF set to zero can never be cached in a TLB. =
For more
	 information about when translation table entries are permitted =
to be
	 cached in a TLB, see Translation Lookaside Buffers."

This indeed seems to support the core assumption of the AF trick. =
However, when
following the reference to Section D8.16 "Translation Lookaside Buffers" =
[2], it
defines the following rule for permitted caching (RSQBCS):

	"When address translation is enabled, a translation table entry =
for an
	 in-context translation regime that does not cause a Translation =
fault,
	 an Address size fault, or an Access flag fault is permitted to =
be cached
	 in a TLB or intermediate TLB caching structure as the result of =
an
	 explicit or speculative access."

This is exactly where my confusion lies, as these two descriptions in =
the spec
feel directly contradictory when FEAT_HAF(hardware management of the =
Access flag)
is enabled.

On one hand, Section D8.5.1 [1] explicitly uses the word "never" for =
AF=3D0
descriptors. On the other hand, under FEAT_HAF, an entry with AF=3D0 =
does not cause
an Access flag fault anymore, because the hardware is capable of =
updating the AF
automatically. This technically makes it eligible for speculative =
caching under
Rule RSQBCS in Section D8.16 [2].

My question is: which part of the spec reflects the actual architectural =
intent
when FEAT_HAF is enabled? Is an entry with AF=3D0 permitted to be =
speculatively
cached in the TLB by the hardware under FEAT_HAF, or does the "never" in =
RDWZCQ
still hold absolute priority?

Please let me know if I have misread the specification or missed some =
overriding
constraints here.

Best regards,
Muchun

References:
[1] =
https://developer.arm.com/documentation/ddi0487/mb/-Part-D-The-AArch64-Sys=
tem-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Archi=
tecture/-D8-5-Hardware-updates-to-the-translation-tables/-D8-5-1-The-Acces=
s-flag
[2] =
https://developer.arm.com/documentation/ddi0487/mb/-Part-D-The-AArch64-Sys=
tem-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Archi=
tecture/-D8-16-Translation-Lookaside-Buffers?lang=3Den#mdsec_translation_l=
ookaside_buffers

>=20
> By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
> implemented correctly on arm64 in a much more straightforward way than
> previously attempted, most recently here[1] (please see [1] for a
> breakdown of the other approaches attempted before).
>=20
> For large-memory systems that allocate most of their available memory =
to
> HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).
>=20
> This series has four parts:
>  1. Some preparatory changes (patches 1-3)
>  1. Bare minimum HVO support (patches 4-10)
>  2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
>  3. Drop the user-configurable Kconfig for HVO (patches 14-18)
>=20
> Parts 3 and 4 are technically optional. More details below.
>=20
> The main functional caveat with this series is that bootmem HugeTLB
> pages are not "pre-HVOed". They will be HVOed, but because at pre-HVO
> time SMP CPUs have not been enabled, we cannot query for full system
> support.
>=20
> This series is based on 7.2-rc2 (0e35b9b6ec0f).
>=20
> This series almost 100% cleanly applies to mm-new, which has some of
> Muchun's HVO patches, with one trivial conflict. I imagine this series
> will conflict pretty heavily with some of Muchun's other patches[2].
>=20
> -- The AF trick --
>=20
> The trick is that translations with the AF unset cannot be cached in =
the
> TLB (see Rule R_DWZCQ in the Arm ARM), so they can be atomically =
updated
> without needing a full break-before-make sequence.
>=20
> So the PTE update sequence becomes:
>  1. Atomically clear the AF on the existing PTE.
>  2. Invalidate the TLB.
>  3. cmpxchg the AF=3D0 PTE with the new PTE. If this fails, goto 1.
>=20
> If there is a CPU on the system that does not support hardware access
> flag updates, clearing the AF is problematic, as those CPUs might =
fault
> on the vmemmap usage. Therefore, HVO compatbility checks all CPUs for =
HW
> AF updates.
>=20
> -- Application to HVO --
>=20
> HVO relies on the following page table transitions:
>  - When enabling HVO for a page, PMD block entries in the vmemmap are
>    shattered into PMD table entries. The first PTE remains mapped
>    normally (RW mapping to a real page of struct pages), but the
>    remaining PTEs in the vmemmap are mapped read-only to a shared
>    page of struct pages (that is, there is an OA change and a
>    permissions change).
>  - When disabling HVO for a page, the RO PTEs are remapped back to RW
>    PTEs that point to newly reallocated pages of struct pages. The
>    PMD block -> table transition is not undone.
>=20
> In patches 4-10 of this series, I use the Access Flag trick to do the =
PTE
> OA and permissions updates. We rely on BBML2_NOABORT for the PMD block
> -> table transition.
>=20
> In patches 11-13, I re-use the Access Flag trick to do the PMD block =
->
> table transition without needing BBML2_NOABORT. For systems that =
support
> BBML2_NOABORT, the logic is unchanged.
>=20
> I am aware of Linu's BBML3 patches; I've opted not to rebase onto them
> for now, but I am happy to do so later.
>=20
> -- Late-onlining of CPUs that do not support HW AF --
>=20
> One of the complications with this series is how to handle =
late-onlining
> of CPUs that do not have HW AF when HVO is in use. Naively, if HVO (HW
> AF) is supported on all boot CPUs and the kernel is compiled with HVO
> support, late CPUs that do not support HVO will not be onlined. This =
is
> a regression.
>=20
> This series provides two ways of dealing with this. First, add a
> default-off Kconfig for users to enable HVO support, avoiding the
> regression. This is not ideal.
>=20
> Patches 14-18 get rid of the new Kconfig by allowing onlining of
> HVO-incompatible late CPUs as long as HVO is not actively in use.
>=20
> -- Litmus test --
>=20
> The following Herd litmus test demonstrates the PTE update routine:
>=20
>  AArch64 TTDFaultlessUpdate
>  Variant=3Dvmsa
>  TTHM=3DHA
>  {
>   uint64_t x=3D1;
>   uint64_t y=3D2;
>   [PTE(x)]=3D(oa:PA(x), af:1);
>   0:X0=3DPTE(x); 1:X0=3DPTE(x);
>   0:X1=3Dx; 1:X1=3Dx;
>   pteval_t 0:X2=3D(oa:PA(x), af:0);
>   pteval_t 0:X3=3D(oa:PA(y), af:1);
>  }
>   P0                | P1             ;
>   LDR X4,[X0]       | L0:            ;
>   MOV X5,X4         | LDR X2,[X1]    ;
>   CAS X4,X2,[X0]    |                ;
>   DSB ISHST         |                ;
>   LSR X9,X1,#12     |                ;
>   TLBI VAALE1IS,X9  |                ;
>   DSB ISH           |                ;
>   ISB               |                ;
>   CAS X2,X3,[X0]    |                ;
>  exists
>    0:X5=3D0:X4 /\ (* First CAS must succeed *)
>    (fault(P1:L0) \/ ~(1:X2=3D2 \/ 1:X2=3D1))
>=20
>  (* This test should not violate BBM requirements. *)
>=20
> This test must be run with herdtools with Nikos's changes[3] to more
> accurately model BBM requirements. When tried, the output will notably
> *not* contain the "Warning-BBM-expected" flag.
>=20
> -- Testing --
>=20
> I haven't yet done extensive testing of this series. HVO is correctly
> freeing pages on my system, and the hugetlb-vmemmap test passes. =
Freeing
> HVOed HugeTLB pages also seems to function normally.
>=20
> [1] =
https://lore.kernel.org/linux-arm-kernel/20241107202033.2721681-1-yuzhao@g=
oogle.com/
> [2] =
https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedan=
ce.com/
> [3] https://github.com/herd/herdtools7/pull/1864
>=20
> James Houghton (18):
>  hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
>  hugetlb_vmemmap: Move vmemmap_get_tail up
>  hugetlb_vmemmap: Leave pages partially HVOed upon restore failure
>  hugetlb_vmemmap: Use try_update_vmemmap_pte to update in-use PTEs
>  hugetlb_vmemmap: Allow architectures not to allow HVO at runtime
>  arm64: Rename cpu_has_hw_af to system_has_hw_af
>  arm64: Add system_supports_hvo
>  arm64: Implement try_update_vmemmap_pte using the AF trick
>  arm64: Prevent HVO if the HVO system feature is not enabled
>  arm64: Support hugetlb vmemmap optimization
>  hugetlb_vmemmap: Use try_populate_vmemmap_pmd for replacing in-use
>    PMDs
>  arm64: Implement try_populate_vmemmap_pmd using AF trick
>  arm64: Drop BBML2_NOABORT requirement for HVO
>  hugetlb_vmemmap: Rename mm/hugetlb_vmemmap.h to
>    mm/hugetlb_vmemmap_internal.h
>  hugetlb_vmemmap: Add a way to permanently disable HVO when needed
>  arm64: Allow "optional" CPU features to be required sometimes
>  arm64: Permit onlining of HVO-incompatible late CPUs if HVO is not in
>    use
>  arm64: Remove user-selectable HVO Kconfig
>=20
> MAINTAINERS                                   |   3 +-
> arch/arm64/Kconfig                            |   1 +
> arch/arm64/include/asm/cpucaps.h              |   2 +
> arch/arm64/include/asm/cpufeature.h           |  39 ++-
> arch/arm64/include/asm/hugetlb.h              |   7 +
> arch/arm64/include/asm/pgalloc.h              |  54 ++++
> arch/arm64/include/asm/pgtable.h              |  57 ++++-
> arch/arm64/kernel/cpufeature.c                |  43 ++++
> arch/arm64/tools/cpucaps                      |   1 +
> arch/loongarch/include/asm/pgalloc.h          |   8 +
> arch/loongarch/include/asm/pgtable.h          |   8 +
> arch/riscv/include/asm/pgalloc.h              |   8 +
> arch/riscv/include/asm/pgtable.h              |   8 +
> arch/x86/include/asm/pgalloc.h                |   8 +
> arch/x86/include/asm/pgtable.h                |   8 +
> include/asm-generic/hugetlb.h                 |   7 +
> include/linux/hugetlb_vmemmap.h               |  20 ++
> include/linux/pgalloc.h                       |  20 ++
> include/linux/pgtable.h                       |  21 ++
> mm/hugetlb.c                                  |   2 +-
> mm/hugetlb_sysfs.c                            |   2 +-
> mm/hugetlb_vmemmap.c                          | 237 +++++++++++++-----
> ...b_vmemmap.h =3D> hugetlb_vmemmap_internal.h} |   6 +-
> mm/sparse-vmemmap.c                           |   2 +-
> 24 files changed, 489 insertions(+), 83 deletions(-)
> create mode 100644 include/linux/hugetlb_vmemmap.h
> rename mm/{hugetlb_vmemmap.h =3D> hugetlb_vmemmap_internal.h} (95%)
>=20
>=20
> base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
> --=20
> 2.55.0.795.g602f6c329a-goog
>=20


