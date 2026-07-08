Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DFB5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071906B00A1; Wed,  8 Jul 2026 04:41:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049226B00A7; Wed,  8 Jul 2026 04:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0D36B00A9; Wed,  8 Jul 2026 04:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFAB26B00A1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:41:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 407061C8486
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:41:14 +0000 (UTC)
X-FDA: 84964964868.15.93E2BD3
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0A5AB140002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:41:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OvGk7kjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ay+9OguP1CPg4hxcwdLNZzQguCP70IcEDhADkyACGAk=;
	b=Pwp0gTB/iNtqxVPxLfgEQwBHNaooW/JxpbQg8qMSQReAkHjyihSONf3rm1XMk4PakVoTwM
	Q47GhYU6iO2spjxMfkL+7am6TDd8S6j+nLb6cRPXk1tF0A/Ob4UCnI7W4G8sgXjx4oY0OS
	g91utyeECvxtUy5LXvbMmZsNlE+zHQQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OvGk7kjb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500072;
	b=Wng2c9y2q7WrRHVAeat5VC6d3Fwj5xTOCwGrpxUd4iOT8UziClqYWmWBEghLMZEJU4krcx
	8+nyq54zNzxmvKzZCE+IDXFj9ZJjFHT+LKiFow3axAOz9o9MYi9pzMu4zf+CAfjPqA/wIZ
	u4UEVg9A2VsA8E7toaL2gL/csQlChzc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783500069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ay+9OguP1CPg4hxcwdLNZzQguCP70IcEDhADkyACGAk=;
	b=OvGk7kjb39KFWuxACeNMnS7v1JI+VETDHS84VGeCho8vtj13MVjNluWrOZeplrHioBIW/0
	Los52tU8eF3fjBVRHlv71jep751FjBXKQC6BGy0+eIvMbkjjkBJ2KkUGVIpG5zyY7eTYCf
	DcYiEISinnyTMInnxhLZlUKkaC9trDI=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH 00/18] Another attempt at HVO support on arm64
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Date: Wed, 8 Jul 2026 16:40:27 +0800
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
Message-Id: <FC9E78F0-8FF7-44AF-A848-8401B4702488@linux.dev>
References: <20260708031129.3503195-1-jthoughton@google.com>
To: James Houghton <jthoughton@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0A5AB140002
X-Stat-Signature: 6fnn7du8pkf86imxp6tzedkk6rkm43sf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783500071-18033
X-HE-Meta: U2FsdGVkX1/ywEYcF/l/H1SStecTQk2OzeKcsqmYmL1KvihGl0cNhr/VjiYEQQXg3aSdy0T28LWT/4KOeukZjhvmVZ6FuAYFvBVpL+35+wfMFeJVLDT7gOtHdGPHR/+WFOaijFCe7uW+Tex1TCkYSQ+09TnKQazvIt5XWb8XRFnkysLv9M3GBEq5hsRyZ0Ei6+ktQz9seDoJvtd2Kec1o2MDQfk3oxwjVjfSwDq6OWo/hoLm4sOZDVupY6R4IkT+uHn5wyM0w/bLfn6lrus5kWH13DK4r52flYxNxVWE7oJgyRtitFKIonpT+FzpqvfEGaLhxpCPaE8ePY86ZLh4yfQypaqzjFtoHRu2/h8l4k89Ea+6RdwioWkHFnluPHREJ30cIPl9gqN6TTAVv9q1yBwS0gsR5p3xeL7WSWMQ4wKXEyp/RZe69JxPW3gahLS4+e/UAv1M9rB0/X0OwX1CIJxJFV+PbwVv1Tm9sb5LHIxj0J8LBK15BznVzQyPou9WZzGgkvLrCIdN/vAAMhRhh+z9p94xlpW0jjuUrHhb0LDvzLlRtS3NV/nrjyKg6aTgHOi3aw/ohDlfhfLA/yO1tGdnegvmmt8TD8hzxsdDyy2l7WQML9ggFMD2ryMmqxTppEZrXmIjxofrGf9jtS5NRWN7q04L1zLcM3ww8g7uzJ5rPUEeTq5Bua7MrDHf+3rZKihmvai2TVf/me60DBKe1u4a8fzGTQMqwr3Tdc6oWJuEHQ1zSbPin3dWtkicIPYHMz7MZstGQLz5Loilm4c4KDSD1/PnHh9XxwMxpAyMDiH74/PaeojXLpFleoG8/6tyyG83SOt8F1kDjzaM7VAGbSIQsG8wPgAprXhHKxflZh0xiSsoQP4CLFZL5+2hm/XXrpcfxRqeIN+4O+ppQvSXo6w7tKJIcp1SDquE1hcs9rUZUkV+8Mqtle4LubNrMicK6XvWZydLQxwp1Uf9rUq
 2y9egj5S
 fQ1bsPS1ePYb2cgMpigLXav8pHpAZxWUJIWdXEv1jEpNMq78G+hM8ds5/aoSDFXSqLKFw5SjHBfM2WRLFDos3B1o3ZmZHVy1rEZiQm0s1ebkudmflDrT2XQgsjzH8w3TcAycZxwdge757G60Odqbz9+c2AQTJ+tTV//O/ORuOwYldvDZnrUAXjlW0lt4lNixfIGGOnEcB/FmhVjUVWAtE4uSg7NDK0eYFZdriNL0/IwuqqKHyp22sRMbrg2U3VcZSqaPTcgw2ELMmuPNgnezUkTy0FEwtkZQJ14VXRIqIvGOUyuGmeywI4x2zTSNcAo+XOiJoBAyvc0G7AdI=
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
>=20
> By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
> implemented correctly on arm64 in a much more straightforward way than
> previously attempted, most recently here[1] (please see [1] for a
> breakdown of the other approaches attempted before).

Hi,

Thanks for your ongoing efforts on supporting HVO on arm64. This is =
truly
one of the most useful features that arm64 has been missing for a while.

>=20
> For large-memory systems that allocate most of their available memory =
to
> HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).
>=20
> This series has four parts:
>  1. Some preparatory changes (patches 1-3)
>  1. Bare minimum HVO support (patches 4-10)

It looks like there is a typo in the number here.

>  2. Drop BBML2_NOABORT requirement for HVO (patches 11-13)
>  3. Drop the user-configurable Kconfig for HVO (patches 14-18)
>=20
> Parts 3 and 4 are technically optional. More details below.
>=20
> The main functional caveat with this series is that bootmem HugeTLB
> pages are not "pre-HVOed". They will be HVOed, but because at pre-HVO
> time SMP CPUs have not been enabled, we cannot query for full system
> support.

Do you mean that the support for AF might vary across different CPUs?
I'm not that familiar with arm64, so it seems a bit strange to me that
such basic hardware features can differ so much from one CPU to another.

>=20
> This series is based on 7.2-rc2 (0e35b9b6ec0f).
>=20
> This series almost 100% cleanly applies to mm-new, which has some of
> Muchun's HVO patches, with one trivial conflict. I imagine this series
> will conflict pretty heavily with some of Muchun's other patches[2].

You know, as we iterate on HVO, the codebase is becoming increasingly
complex and difficult to maintain. Aside from the work in [2] that you
mentioned, I actually have some local patches aimed at refactoring
hugetlb_vmemmap.c as well to reduce this maintenance complexity. I =
really
want to avoid piling more code on top of it right now, as that would
only make things worse.

Therefore, my personal suggestion is that if this approach is
theoretically validated on arm64, it it better to wait until the HVO
refactoring is complete, and then review your work based on the clean
codebase. For now, what we need to focus on is evaluating the =
feasibility
and soundness of the approach itself. What do you think?

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

Sorry, I am not familiar with arm64, so I will leave it to the arm64
maintainers (or experts) to verify the feasibility here. Once the =
viability
of the approach is confirmed, I will look into the HVO-related =
implementation
details and consider how to support this feature on top of the =
refactored
code in the future.

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

Just to clarify, does OA mean Output Address? Please spell it out for
readers who are less familiar with this context.

Muchun,
Thanks.

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


