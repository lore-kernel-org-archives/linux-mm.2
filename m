Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72103CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677DB6B009B; Fri,  2 Oct 2026 20:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628456B009D; Fri,  2 Oct 2026 20:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4816B009E; Fri,  2 Oct 2026 20:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFE76B009B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:21:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F526C08AC
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:37 +0000 (UTC)
X-FDA: 85279411434.04.97C3772
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id E1619140003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:21:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rm/qYx06";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3jkrAagoKCIEoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3jkrAagoKCIEoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790986895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aEnY79PEs1jEgbZjrd0k1UfShxduWLM8NQCT8pohIr0=;
	b=JBuxkk4JSF5rJKPNp7ZDgvFjNHlH6yP/CRFW3O++aAypcY7S4rEWQlqwsxnDVesnDsJue5
	hHbEgRm8LSsyih+BScSJmS+46weZkOTC3QzVZ9rCQmwfbUz0HZ2HTIhIi2TVocJIQdR43I
	eRkj76sFcwUXAPIH6UberubMV0E+t8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="rm/qYx06";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3jkrAagoKCIEoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3jkrAagoKCIEoymtzlmytslttlqj.htrqnsz2-rrp0fhp.twl@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790986895;
	b=xYiJmvJ9be6eHSyP377OybZm48h0zX/l9Aq6NSVfK4QHhDh9SjT+yILsRcy3XHLR0OG7wD
	iilXmL+7D+AOsmcO78J011b925l2qeG8+zTzvatGg4kHuC+ge9VmYUSKTI4VjumORWzlLg
	75HGbVkdckcMkcboki/YmB3X0gjkkdM=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-cc78c0402e7so440a12.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790986895; x=1791591695; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aEnY79PEs1jEgbZjrd0k1UfShxduWLM8NQCT8pohIr0=;
        b=rm/qYx06IZbUcsMxMkuM8WfLnVivHVOxb7+89jN4CfyXKM2e8MfKw6c20sfGVJqG6p
         Q0rFgMff3WXlIF9JAOsCOtq/0CKp28MaL5t6NkMN2Ife90srkt7xi66UqyABdY/maE7Z
         pty36TKRyqu0WMOiLc2iWnCAEPDZmiD90Z8Iaw4ZOol2DiPybNnjfkEVS1QNx44VFGjg
         GN3IZp7wLmMmCsxa9+8zA8OahCWhF0FX39TAUH4ab+PuKdaU4eAe0NAqNq+573Mull6d
         X2HhjuAOlJcax9ovKzXaivfEM8LKKxv1EknXte6KRVDtrWu51HVHVdsIiJ1WRhcOYoyf
         eDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790986895; x=1791591695;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aEnY79PEs1jEgbZjrd0k1UfShxduWLM8NQCT8pohIr0=;
        b=eA5QdNcbO/lOwbc0RpmJ3nGCndU9EvGQw+nCe183JK6WAS1s8g8Auhu7oCNega8/px
         ncTV/CVVcWElDmamzPjAytMm3F5flYU36CAm06mZuKS+TGkiChqABmpldpDaWDL7u6OL
         03yMCqTqjD4WXK/LC1IBwwKfkj+xbcDHXxl/3PNmwM1Jrj/ijmr+Ow+31ONVh2cEP00n
         Sx1l9g+YB7JH0W81k3YWpTIFSy6LmqW9mtw0pSd+oz6xQ/I9Mvo4nwPw3CpJ0lALf5Z6
         f6M0bk2SCZt02waHNARE+ZfAMK5hLxnU0KwhMEnPeGppkkLAEa96UtOuVWTz92sgqR3T
         p/Cw==
X-Forwarded-Encrypted: i=1; AKwUvBy55WBEwOVbSel3EY1dAVIu0GkGzaF1kN4u6jh2mE8oYJHyUnzXS50Cx9AOUbBhCnrRavaZybE3Sw==@kvack.org
X-Gm-Message-State: AFuF++naQuiRhaM/UYq9c/cOdqA05+d/ksJqPqG7rFywnom3QLokqGF4
	6yMIEDvDPaZU5GJipXJeBPQw6f5kxjl6Kw77/XM6YzwLx3IlvKoYSMUQzpDxrgfOsO6gC8JPg21
	W9zS8BOznx8JZES9Vfw+a/A==
X-Received: from pgjn6.prod.google.com ([2002:a63:e046:0:b0:cc7:e02e:9f0d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7d9d:b0:3de:a9f6:eb3e with SMTP id adf61e73a8af0-3deacc2843cmr5497314637.19.1790986894422;
 Fri, 02 Oct 2026 17:21:34 -0700 (PDT)
Date: Sat,  3 Oct 2026 00:21:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003002123.505555-1-jthoughton@google.com>
Subject: [PATCH v2 00/20] Another attempt at HVO support on arm64
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E1619140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dk5n3j7e9ww9ne3ys6wc4wf6nnp8qhxf
X-HE-Tag: 1790986895-864797
X-HE-Meta: U2FsdGVkX19XE6slhlEib7afRE/u+qB47hpi70hQEFn+Y+Fp8On6DbgDqHo/UDWpBoh5sJcUd30b11llFDbWeJcAbvGhy7eKnNxLgNe8z1SI7MRY1KDIlJz6HMeqC4bXJl6rWwW+SCNLfxMr6f4uRM6api6TZVrhvy/ItpH9opRMBGzG08HB6c6Vh3kloIGHDR/5QfJGPt192lqokwSRMW2ojCj0xxwOviGeTIbg1OPc3WzahKzVm3i51AFjEqncM5TPOBDgdz4vVIsDd3h89uTYpTDOAK7o19ISWy2q0CJBnAWpXrcOoFt0LwfyruntCPYzNwxscXZON4bH/mAjYdqI4yvE1/6p1sqv7B4l5iDlGyuxtnLoJkAM/PKto2ARwMb8IK+7lKMIsy0hCiAxhFooN5hLsh8TdnFzTn1IoCugA3F5i3g5zFKSi+zaV+ohIoZ3dwh/2jZlyyfS5BWH+8KZ4wzg5SW12DisrYnDwJHnjr7Gd7Go8Zo/ZdU80wnEI3H6r9TPtjd0zNGh0fWJWzAP9aLlTMcrsSiqRvv7fU1c4HY/k/FVWMCY36EKA6x57/1sF7FjEGeDObmGXI4Me1V5EDpm5T9jx/cIW0/ZE1Xqxd62CTlp/pBQHBozcdC/5BQs7qcwmHCw0WaSBvzDEhm+TtamcGAA/R2NxU0Ph6m62c8ZHm6cRIInTTEuiOtfFULMTTmZNa64+K9Hpn7c8h5ItjIP7yFPdBcx+OlSdbcFuEdP5wTGMdQx6la77gIfdFxp7+zdq2NK7nGXakKpcCC9y30g0OwirBYX6yP/h7kqcHMOVln4Ksq8vBGUez34AFYfbqc9HYODnk1IRVnrqeTt8SC19f5XE8pLuaS24foJXxdcfkq8xqA0nev8GYsgRTJJxryhxfTEtpp8c+mJdEP48U5lN7mcLSSEjmw9qpKaLGLmUo+cASDg7mo3xBDYHyjs7tTZoHkjpWJjnjD
 XO34I1Yf
 4+SM/9BEh8BBNeqgpriUZtn3i9PgJJryIfX+ISY4IeaatgoXlAiHhK0N3w8Av3D6OEjFzhp5qnO/waTARzzS2CY6vbccE5IFo3Cg/9DW8IuCA1uxTdMWgjViL1VSwyAOZw0JoszRBlNvOyiU7bGKHZd3DuCkjj5VMzQ6sDQd2BmWqagIZ2tRGvLf8xelRhKl8PZ2ARplTQPhZNI2P47hK56P2hsymc85sLH9oLoPv3XF9SQ0ntf8TI99Ay9HIsWSvOPGqOYiO1EM+66LcXBE0HX47hjYmuOdeS8kP1ZVk+/Qzdy3O4XcWLzikQ2uy9AU+7y+/+hxCDvjIQzL4LsKFjWzT2DBLagSvu/aB9pUFaglNcxD6yXuFhupHe4voehcH6VRDDQd/bBoUjKLJgao8cY8AnhXAGJ5Ir765FV9g/CaR1cfX4QL/9O7dJUGXGZr1OHNWaEjaCR/Isu36kx4gp9hW1bFjrAK/qfY4NBjS2ekjrFkOh09AXxekWjoeC0QhwWAGomMbkUCrjWqi/WrN+Su/AkIpzqXy655P5yHo6Am8GdKKBA0o0zHPPccI4g+4J7lRMR7ahOB2mVDNJMSxz/jIHqhidzqdm6HKEiYFk2mhwJ06+LoMa5LNmldVm28GOWnpDbT2lRsbmnEkatpCXFHpyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi everyone,

This is the v2 of the series to enable HVO on arm64. I'll start with the
changes since v1:

- Fixed a latent issue with HVO when bulk-restore fails.
- Added LDCLR patch (thanks Catalin, Will).
- De-duplicated the generic implementations of try_update_vmemmap_pte()
  (thanks Catalin).
- Rename the new CPU feature from "hvo_compatible" to "bbm_through_af".
- Added RO_AFTER_INIT for HVO, enabled by arm64. This replaces the
  late_cpu_enable() CPU feature callback that was added in v1.
  bbm_through_af() now must check whether or not HVO is enabled. (Thanks
  Catalin, I like this better. I hope you do too.)
- Add fault injection support and a stress test.
- Marked the BBML3-less patches as DO-NOT-MERGE.

And thanks to everyone who responded to the v1 with memory model
questions. :)

Despite being longer, this v2 is in fact simpler than v1. The most
complex piece (other than the AF trick itself) is how to manage the
system feature. To be clear, the way it works now is:

1. HVO checks if the user enabled it (cmdline or DEFAULT_ON=y).
2. cpufeature checks if HVO is "enabled".
3. cpufeature reports back to HVO if any early CPUs lack support, in
   which case HVO then disables HVO permanently.

v1: https://lore.kernel.org/linux-mm/20260708031129.3503195-1-jthoughton@google.com/

Thanks!

And now for the rest of the background of these patches, updated from
v1's cover letter:

-- Background and Structure --

This patch series uses a trick with the Access Flag on CPUs that support
hardware update of the AF to update vmemmap page table entries without
introducing a time window where CPUs accessing the vmemmap might fault.

By avoiding faults, the HugeTLB vmemmap optimization (HVO) can be
implemented correctly on arm64 in a much more straightforward way than
previously attempted, most recently here[1] (please see [1] for a
breakdown of the other approaches attempted before).

For large-memory systems that allocate most of their available memory to
HugeTLB, HVO saves a huge amount of memory (1.5% of system memory).

This series has a few parts:
  1. Fix a latent bug in HVO (patch 1).
  2. Use LDCLR to clear the AF for PTEs (patch 2).
  3. Some preliminary HVO changes to support HVO on Arm (patches 3-10).
  4. arm64 changes to enable HVO (patches 11-13).
  5. Fault injection and a stress test (patches 14-15).
  6. Drop the BBML3 requirement for HVO (patches 16-19).

Part 6 is optional, and whether or not the claims it makes about the Arm
memory model are accurate is not 100% clear.

This series is based on mm-unstable (40cdf2b57d6c), which has several
HVO changes that are not yet in mm-stable.

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

In part 4 of this series, I use the Access Flag trick to do the PTE
OA and permissions updates. We rely on BBML3 for the PMD block -> table
transition.

In part 6, I re-use the Access Flag trick to do the PMD block -> table
transition without needing BBML3. For systems that support BBML3, the
logic is unchanged.

-- Late-onlining of CPUs that do not support HW AF --

HVO support is modeled as a system feature (called "BBM through AF"). If
not all early CPUs support the feature, attempts to HVO pages will fail,
and the HVO sysctl will be hidden.

To avoid penalizing systems that have assymetric support for
BBM-through-AF (i.e., HW AF, as BBML3 cannot be mismatched),
BBM-through-AF will check that HVO is in fact enabled.

Because BBM-through-AF needs to know if HVO will be enabled when system
features are finalized, HVO cannot be dynmically enabled, hence the
patches that do this. (There are other ways to solve this, please see
v1).

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

  (* This test should not contain "Warning-BBM-expected". *)

-- Testing --

I've tested this series with the included selftest, which stresses
the optimization, unoptimizing, and failure cases.

[1] https://lore.kernel.org/linux-arm-kernel/20241107202033.2721681-1-yuzhao@google.com/
[2] https://lore.kernel.org/linux-mm/20260513130542.35604-1-songmuchun@bytedance.com/

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

James Houghton (20):
  hugetlb: Don't restore vmemmap of non-HVOed folios on bulk restore
    error
  arm64/pgtable: Clear AF with LDCLR on supported systems
  hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
  hugetlb_vmemmap: Leave pages partially HVOed upon restore failure
  hugetlb_vmemmap: Use try_update_vmemmap_pte to update in-use PTEs
  hugetlb_vmemmap: Allow architectures to dynamically disallow HVO
  hugetlb_vmemmap: Disable HVO sysctl if arch doesn't support HVO
  hugetlb: Fully initialize tail struct pages of non-pre-HVOed bootmem
    folios
  hugetlb_vmemmap: Allow architectures to make HVO enablement boot-time
    only
  hugetlb_vmemmap: Expose whether HVO is enabled to architecture code
  arm64: Add bbm_through_af capability
  arm64: Implement try_update_vmemmap_pte using the AF trick
  arm64: Support hugetlb vmemmap optimization
  hugetlb_vmemmap: Add fault injection for in-place vmemmap PTE updates
  selftests/mm: Add HugeTLB vmemmap optimization stress test
  hugetlb_vmemmap: Use try_populate_vmemmap_pmd for replacing in-use
    PMDs
  arm64: Implement try_populate_vmemmap_pmd using AF trick
  arm64: Drop BBML3 requirement for HVO
  hugetlb_vmemmap: Add fault injection for in-place vmemmap PMD splits
  selftests/mm: Add HVO pmd-split fault injection tests

 Documentation/admin-guide/sysctl/vm.rst       |   3 +
 .../fault-injection/fault-injection.rst       |   8 +
 arch/arm64/Kconfig                            |   2 +
 arch/arm64/include/asm/cpufeature.h           |   5 +
 arch/arm64/include/asm/hugetlb.h              |   7 +
 arch/arm64/include/asm/pgalloc.h              |  53 +++
 arch/arm64/include/asm/pgtable.h              |  68 +++-
 arch/arm64/kernel/cpufeature.c                |  25 ++
 arch/arm64/tools/cpucaps                      |   1 +
 arch/loongarch/include/asm/pgalloc.h          |   2 +
 arch/loongarch/include/asm/pgtable.h          |   2 +
 arch/riscv/include/asm/pgalloc.h              |   2 +
 arch/riscv/include/asm/pgtable.h              |   2 +
 arch/x86/include/asm/pgalloc.h                |   2 +
 arch/x86/include/asm/pgtable.h                |   2 +
 fs/Kconfig                                    |   3 +-
 include/asm-generic/hugetlb.h                 |   7 +
 include/linux/hugetlb.h                       |   9 +
 include/linux/pgalloc.h                       |  21 ++
 include/linux/pgtable.h                       |  22 ++
 lib/Kconfig.debug                             |   9 +
 mm/Kconfig                                    |   9 +
 mm/hugetlb.c                                  |  35 +-
 mm/hugetlb_vmemmap.c                          | 242 ++++++++++--
 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/hugetlb_vmemmap_stress.sh    | 351 ++++++++++++++++++
 .../selftests/mm/ksft_hugetlb_vmemmap.sh      |   4 +
 tools/testing/selftests/mm/run_vmtests.sh     |   4 +
 28 files changed, 837 insertions(+), 65 deletions(-)
 create mode 100755 tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
 create mode 100755 tools/testing/selftests/mm/ksft_hugetlb_vmemmap.sh


base-commit: 40cdf2b57d6c6914170fbbd006aff29febfb3382
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


