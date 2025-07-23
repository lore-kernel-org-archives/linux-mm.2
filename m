Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE2BC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65BA8E0002; Wed, 23 Jul 2025 06:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DED8E0001; Wed, 23 Jul 2025 06:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53668E0002; Wed, 23 Jul 2025 06:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B25CC8E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80192C064C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:18 +0000 (UTC)
X-FDA: 83695202556.13.786D873
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id B67D94000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C2NLODJa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3s72AaAUKCHwyfggflttlqj.htrqnsz2-rrp0fhp.twl@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3s72AaAUKCHwyfggflttlqj.htrqnsz2-rrp0fhp.twl@flex--tabba.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267636; a=rsa-sha256;
	cv=none;
	b=PBWPBomQL73dlHRQYtg/dRh1K4ICtMJ2twX7Cp5cU5yKu8WiSaDOtgyPSLjZ78D4M6c21l
	dQkdzylf2gER4150UlRZNZJGpdaqlViFFb4TYlZyD5UEOmecOFqdIWr0ylXiZiY6DHwzuy
	Cn4zGjI0DiexNdJHwXepQxl8AG06Ytg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C2NLODJa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3s72AaAUKCHwyfggflttlqj.htrqnsz2-rrp0fhp.twl@flex--tabba.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3s72AaAUKCHwyfggflttlqj.htrqnsz2-rrp0fhp.twl@flex--tabba.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=57m6jReu/89PVW3YULNXA1rx8Q7Z0K2J7QywXGEHimQ=;
	b=AiGNeqSN1f1ZHPndBHrWOI+RldyhD1HIxIPdPht7ACKueh5ljFVoYee2gq34S3I5LLPYfr
	3vE8uOJtlzV9sV2gUoQsaaBBAIF/QbWf4GS8rlKqXg3OgiI3cdcAVv0+AP6oPFxYjI1uCG
	B4ET0UtwPI7SGddWhZNmBkaStR4oLYk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45639e6a320so34650095e9.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267635; x=1753872435; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=57m6jReu/89PVW3YULNXA1rx8Q7Z0K2J7QywXGEHimQ=;
        b=C2NLODJaktNHEniU+MxzMMSLQXMEZ37PLzDisIIVfwXUIHZr22pMHLzJHh/TiHOkni
         jMauNSJuVLcBLkKZdPiN1X716oPAC37ARssKwlHQOr2BCVJ8OEpya42RuHqnWVuOimzT
         XGvEJAKv9vAGz+wN6I3ciB1tB7hKqJvofs9I1DmcporcOqDkyOr/4/99xd4K40ITI9IJ
         x5W2szn8pvMLgCMUln+x5P4M/6uklKbGeUd7rPlCO1G+wdqdHS8rrIxpZ7ZfQOf1pqiv
         5huIW34wXCOObki+pCYy+AkCff8dxlGz42McrCCFwzumdvBCLtzlx0ZVuJjvu5f5gX3M
         ZMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267635; x=1753872435;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57m6jReu/89PVW3YULNXA1rx8Q7Z0K2J7QywXGEHimQ=;
        b=TkUhuxzjjIfU1ajgpET8WXxTj7mzxcRvA36Fhyb7WTs7jiGEmcdC4ssnsuZ43KqS8W
         TYW8DYo9OHdzuBqnG7MVWHt2VvsKnM/lJ5cdnXDVEj2hfSG3EI//kLpP6acoz68lm2nK
         IaG8Aw2DcL1uYWRkmY586SPP/2bh3aFRV2WbdytBt6OjhoHJ0pBOzvSvAOrTpnoh9d5S
         J9uNPbeDR7UY/MHgbKO0bD1uEyvrCDbisUtWuOY/NPO0Z612o1K0YR5AMeEE7TBJS4yl
         rRwXEdce+mI94Sgq8EBp4bVda1SaFC2p8CG3+1g7mSEOR16GkfZHFCICo+bqkXdx24eb
         svfw==
X-Forwarded-Encrypted: i=1; AJvYcCVlTDSNVvUyXJ79WhPzxjSy/xCwsPElE6OCuVqlVwbUL2ksDjn0iFNorz4uCh3ZdmpZTi2Lq7QRfg==@kvack.org
X-Gm-Message-State: AOJu0YznljDf+bZ6KJTJXWuJ/PulIUacKE0WGsVrRO4FfAVsc3AbzYzh
	W+KCRLlFnnydTGzQTqqjtkm8S1idFncA9cIXmAJycnuIqe7BkPuE6FgPTgqxuY2py69m6PrwdD5
	lVg==
X-Google-Smtp-Source: AGHT+IG8guHep8zGOe2nsK6QLt0Shc7PDC8FbYnWdhDsCUpgn83x1Mq6gF7ZIdM6iSjg+GCiMUXCi3Qg1A==
X-Received: from wmbeq10.prod.google.com ([2002:a05:600c:848a:b0:456:257a:e323])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3585:b0:456:8eb:a35c
 with SMTP id 5b1f17b1804b1-45868d6b6d3mr19171885e9.31.1753267635103; Wed, 23
 Jul 2025 03:47:15 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:46:52 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-1-tabba@google.com>
Subject: [PATCH v16 00/22] KVM: Enable host userspace mapping for
 guest_memfd-backed memory for non-CoCo VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B67D94000D
X-Stat-Signature: 5835nrb5w6cxnfrgg171r1w7687jzbpt
X-HE-Tag: 1753267636-413321
X-HE-Meta: U2FsdGVkX18HqCW+bvmmqCgJFRfTmU9UBBbPr+8yMDzddaimPilG/hrJI8DYEgYXcw1ahfEpofM229W7dX8C30bzzFXW6C21mRzXaJAX6Mr86H+h/RAwYoLsF4XNxgGAb9GOSnTs0rEge/yzEz+nOvJ94i+EDrU8IYi9oxfZb/HS5xfkC3CXzGw56NVOLTjpksUlHu2CIMxxb8fscdWfV308pxIGybJuvkPs94trfCyNwhlfKxSw8vj2SHdmlRRlZu+1h91khfatYHf/syCAeeO9uspp8MB24ztvHb1rsVsOqBJRIRuawKSD+TQArI8CsipK/PEXMHKLUT1v379CpPUPjv7pF7f31tHuGF4F31D5rLenUfn7dtup3+PHJ+gtE7qEcadTmiiJjC4ptcnQg921OqU6u0/RECVUNDxxjo0AO86xFewsoTfwmuwQeZ01/gO5nPV2Nwm/T3u+OsLUFC8Wi5TbjSYpmlrF+2qh6ZnPZG7Whj+aViGrbg+rME85Giy55SwDpPTUs6gNeorpr4kHDnHFglqs/7KajoYqZLCYP+ZcAYar7mgGgSO59KbTM9FH8nmHpV/iHzUfY87ZhqwcIk7bO75rP4nc4PIHmn85bCjbPra0qbO7A17/57Rz+u9l1fnKSVP9MzTFNVVaSMa/kyPDSGdrpsPaeLtyh/Vig6xXllPdmA33qczjMeU5QMh4EY2NHxcXH7y4Ev10zsCRs1HwxJXejN1Jc0CXQ4YS98tqASar3+OtN8yzbSCQN/iVUxtSlBi7tMxzgm8mdgP1XGbCyE4HWv2BbRLxjluxt3nzTbYa29HGixc4WwA4yst6lI57pNDeJjn/KIq+TBA2CUMbVTNs+cXfyH7MBVBlsv3ar1QiKU+yT5irLQ2vhriRQn3sIBX/e29Wixdy/4+jxjL4k0+hVW19TtU0Ck1q6TWjHowgG07g5DtQcbxT2s0lIX43xhT/diDIMjt
 AGveVo65
 qdtIXpGiOreKRz7HX7iwJaDyYXy6a+D+JLCopB9Z7Axv2NWjjZQP9sFGgeezj5nsp2H21ibDhT35bFA5LGjSMRxkNtKqjWCTY1Er0uxsYgiuANoV4TEUQFR38eMpD/tKHiPXaTVBYPuxLukeKPlEZ08kntEzkPMEhHp5CYHY7XIio+I5dzxi0h7bfxeUTCWRwbP6Wft+1xZQ7YrHRgPxMOLG0rw5pO616yHgpbGhe0SspMuAdiJSnn5xWZF1Gr58OOH4vCbSVz/bERs54TsH3TBajfvJWA6AGDWHtzB2MIqz5Pd8fy5hyz+nSy29NH8aAKzh72HgW6KvLdPFeWeB0WaWLh6loY86Nl2vr5DugKk6My4zmNJDBFZ677e91FZ9QkZaBwvVtS6aWsy3La7O6hTOjK618OGFEZID+D2ERrr+PODcYj1y8YUeilOND8YqjO4Hj7Y75Er8+o4qLYlx6hf0MkWzoQhKgRDFIakHDJwlczQ4iakcXzY9Q1XSJIh4TYFWVDsvMC+XpbwbBs7hBtySKKNsufQesqYOgTj4PVD9khqEkV4S0JA6erZVtXi5gNFB3qtFbiDYRt7lPSnrXsjO0cUKxqtcnMYYzpIZ5ZoBmWHXW/Tj/stiwzDGttxPbhLONGRvBRmVo2BZtuAbsC5XN9IbkkNiQK3h93WWeJE86RTbFTHchdkV9cRSZ5HjjFIr1xR0/z+faax+4h85CYHqdtKZDGgT8C1bY8rBKdmxVl5tNk/zMNXDdqHuKoL2mvfgxzhLmsskHmO74Q2LicwXjWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Main changes since v15 [1]:

* Rework and simplify Kconfig selection and dependencies.
* Always enable guest_memfd for KVM x86 (64-bit) and arm64, which
  simplifies the enablement checks.
* Based on kvm-x86/next: commit 33f843444e28 ("Merge branch 'vmx'").

This patch series enables host userspace mapping of guest_memfd-backed
memory for non-CoCo VMs. This is required for several evolving KVM use
cases:

* Allows VMMs like Firecracker to run guests entirely backed by
  guest_memfd [2]. This provides a unified memory management model for
  both confidential and non-confidential guests, simplifying VMM design.

* Enhanced Security via direct map removal: When combined with Patrick's
  series for direct map removal [3], this provides additional hardening
  against Spectre-like transient execution attacks by eliminating the
  need for host kernel direct maps of guest memory.

* Lays the groundwork for *restricted* mmap() support for
  guest_memfd-backed memory on CoCo platforms [4] that permit in-place
  sharing of guest memory with the host.

Patch breakdown:

* Patches 1-9: Primarily infrastructure refactoring, Kconfig cleaning,
  and renames to decouple guest_memfd from the concept of "private"
  memory.

* Patches 10-11: Add support for the host to map guest_memfd backed
  memory for non-CoCo VMs, which includes support for mmap() and fault
  handling. This is gated by a new configuration option, toggled by a
  new flag, and advertised to userspace by a new capability (introduced
  in patch 20).

* Patches 12-15: Implement x86 guest_memfd mmap support.

* Patches 16-19: Implement arm64 guest_memfd mmap support.

* Patch 20: Introduce the new capability to advertise this support and
  update the documentation.

* Patches 21-22: Update and expand selftests for guest_memfd to include
  mmap functionality and improve portability.

To test this patch series and boot a guest utilizing the new features,
please refer to the instructions in v8 of the series [5]. Note that
kvmtool for Linux 6.16 (available at [6]) is required, as the
KVM_CAP_GMEM_MMAP capability number has changed, additionally, drop the
--sw_protected kvmtool parameter to test with the default VM type.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250717162731.446579-1-tabba@google.com/
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
[3] https://lore.kernel.org/all/20250221160728.1584559-1-roypat@amazon.co.uk/
[4] https://lore.kernel.org/all/20250328153133.3504118-1-tabba@google.com/
[5] https://lore.kernel.org/all/20250430165655.605595-1-tabba@google.com/
[6] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-basic-6.16

Ackerley Tng (1):
  KVM: x86/mmu: Rename .private_max_mapping_level() to
    .gmem_max_mapping_level()

Fuad Tabba (15):
  KVM: Rename CONFIG_KVM_PRIVATE_MEM to CONFIG_KVM_GUEST_MEMFD
  KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
    CONFIG_HAVE_KVM_ARCH_GMEM_POPULATE
  KVM: Rename kvm_slot_can_be_private() to kvm_slot_has_gmem()
  KVM: Fix comments that refer to slots_lock
  KVM: Fix comment that refers to kvm uapi header path
  KVM: x86: Enable KVM_GUEST_MEMFD for all 64-bit builds
  KVM: guest_memfd: Add plumbing to host to map guest_memfd pages
  KVM: guest_memfd: Track guest_memfd mmap support in memslot
  KVM: arm64: Refactor user_mem_abort()
  KVM: arm64: Handle guest_memfd-backed guest page faults
  KVM: arm64: nv: Handle VNCR_EL2-triggered faults backed by guest_memfd
  KVM: arm64: Enable support for guest_memfd backed memory
  KVM: Allow and advertise support for host mmap() on guest_memfd files
  KVM: selftests: Do not use hardcoded page sizes in guest_memfd test
  KVM: selftests: guest_memfd mmap() test when mmap is supported

Sean Christopherson (6):
  KVM: x86: Have all vendor neutral sub-configs depend on KVM_X86, not
    just KVM
  KVM: x86: Select KVM_GENERIC_PRIVATE_MEM directly from
    KVM_SW_PROTECTED_VM
  KVM: x86: Select TDX's KVM_GENERIC_xxx dependencies iff
    CONFIG_KVM_INTEL_TDX=y
  KVM: x86/mmu: Hoist guest_memfd max level/order helpers "up" in mmu.c
  KVM: x86/mmu: Enforce guest_memfd's max order when recovering
    hugepages
  KVM: x86/mmu: Extend guest_memfd's max mapping level to shared
    mappings

 Documentation/virt/kvm/api.rst                |   9 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 203 ++++++++++++-----
 arch/arm64/kvm/nested.c                       |  41 +++-
 arch/x86/include/asm/kvm-x86-ops.h            |   2 +-
 arch/x86/include/asm/kvm_host.h               |   6 +-
 arch/x86/kvm/Kconfig                          |  26 ++-
 arch/x86/kvm/mmu/mmu.c                        | 143 +++++++-----
 arch/x86/kvm/mmu/mmu_internal.h               |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c                    |   2 +-
 arch/x86/kvm/svm/sev.c                        |   6 +-
 arch/x86/kvm/svm/svm.c                        |   2 +-
 arch/x86/kvm/svm/svm.h                        |   4 +-
 arch/x86/kvm/vmx/main.c                       |   7 +-
 arch/x86/kvm/vmx/tdx.c                        |   5 +-
 arch/x86/kvm/vmx/x86_ops.h                    |   2 +-
 arch/x86/kvm/x86.c                            |  11 +
 include/linux/kvm_host.h                      |  38 ++--
 include/uapi/linux/kvm.h                      |   2 +
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 205 +++++++++++++++---
 virt/kvm/Kconfig                              |  15 +-
 virt/kvm/Makefile.kvm                         |   2 +-
 virt/kvm/guest_memfd.c                        |  81 ++++++-
 virt/kvm/kvm_main.c                           |  12 +-
 virt/kvm/kvm_mm.h                             |   4 +-
 26 files changed, 623 insertions(+), 209 deletions(-)


base-commit: 33f843444e28920d6e624c6c24637b4bb5d3c8de
-- 
2.50.1.470.g6ba607880d-goog


