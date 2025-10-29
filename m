Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B3BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C838E00D1; Wed, 29 Oct 2025 15:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73DA8E00B2; Wed, 29 Oct 2025 15:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1048E00D1; Wed, 29 Oct 2025 15:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 988BD8E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:05:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4816888C72
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:05:47 +0000 (UTC)
X-FDA: 84052081134.28.8D90030
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf09.hostedemail.com (Postfix) with ESMTP id 641C414001B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:05:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=AOyiR+rx;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761764745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=B6CFw+JSCNGBsZMvctblIxAviwt5E/Cc+YlSpcKbM2E=;
	b=Vy6XZOcvs/x00ErYk2Roofp8N4hS1a67YyPOdv9LrgR0BprKL6O1wmyAgIExk9e59domuq
	DEAyZJsKx5aJTDAPnRBfbhJLTHyT2hiqYZa376f3787qzIPKuq0dhD4itIHcI0Ga4WjfAV
	wHDhnHCwabJZ3BO/aqPju70URHkgFQE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=AOyiR+rx;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761764745; a=rsa-sha256;
	cv=none;
	b=SmLx0i5jxuykPDKaiapFpjwPX7WwskpFCzzNzPZXaUleTPAayMXEAr4LqExZVvehqt1s7l
	xJBJZZ/oxO8HpTSFcDAJwVjAOAJ+L7bMl5QBZAJn2Tw0F6s7sbuVHa9YZnojvZKbJdgt29
	Ux97apTJ0SkijhxMPnJ47e6QiPz/wns=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1761764742; x=1762023942;
	bh=B6CFw+JSCNGBsZMvctblIxAviwt5E/Cc+YlSpcKbM2E=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=AOyiR+rxjPfuH7pfkccCI8rMLfkmxjFsngbdMFMpi0zT4M9D/FWZ0qEvVFsr1QqeG
	 aeZ2rEk2blvOc+RXJxXre8BTUUVbzPiTtUZ4eHKV9bHrVYAJlsoMd05Lslow36MqQ8
	 K1GqlN+S8D2tbrEFnke0JQzVh5/x0+dix/wvoZunNpTeIQfxlVbATxihUfV2eK9PjX
	 bABFBwRA4NtMKHqlPZVAPKUYV8KiyMUeMOTqMz/oiwTf4WOAPtgU3CPBKYhT/PbkYQ
	 FEroosHwGZzCM4S0jlQmRJf2mw83e0gfpA5QM23gVgTomBwocLeKV2LF5dkPZpAIJl
	 DKnDSNw2AvrHg==
Date: Wed, 29 Oct 2025 19:05:27 +0000
To: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com,
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v6 00/18] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <cover.1761763681.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: b23693d0cf530e4c8a53771e64b6fdea3be223c5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 641C414001B
X-Rspamd-Server: rspam03
X-Stat-Signature: yie7c4u5hnompqcpkbkf1zbw8n83aw8p
X-HE-Tag: 1761764745-183557
X-HE-Meta: U2FsdGVkX1+MI7A5LzNQYTr+Fxtw7LLQoUbp+N0OKXowWbZ/Yu4trF9BUE7JvUXxhNhNRrl3B5zyrwHu8CX9yCSPbDRYcV2zaR7oh6ZHCzU1VEroD7w2sYksNtLxCmJg0Jc/cBMOKs9RtzGX1YNIorFtoEIkeX/Pd8zSRsz4X9ZfwqLQ3FsIJRb/L3h6UyEY7yddmkKEPjNNGGicZOkmBfHn5XYRkIplLsWwfWPDBCqkP/TMYvkw7W52UFrxViuBauviWSdVY6VxE27pvnSN7hR0v6WsJj4LIbA6w0UyacKJ4zn3yr4nY6NzRyLM31dTTaYwOBSJZgIHD/93QDxD2aMrJaNNAnspgiRs1Y/jMQoLQ/Hke3a9AqhMp5OSZPIOwzrbrZJxy1xFxHsxl/aWraHEBtLiwRmj9z5B1zttZtcUL0stYoJfoJyjspeMSeLbeoWIV/VskFUj3nWh0SVp9w6iv55Jymn/BeAtqkXDUJQ+mExaCIqJyhvdmh1W9uiLi7+eUYWhIGYNhcLc5ofwX318ktDMPGqb93VYVDxjAVa9mn4T+ruVIW8P//pPJQOeMqt8wy/ZWML3vq3ny++St/+lkfUdS/QbeuZu8grgqzZk2CXRxtP6LpjxxQs+IER6iKTuMOQXAjOsu2pVJoW1jOq5vqca6Tyw2PGNsX6dWrmTWNYhJamhU1+0h6iFdowV00GPGlE0OHSqpn6nRxzx/Cu+rF5pDERqXFcYu8tqUx9k9n250XrLQ2RZ3YSe+rLmegcQxaJihCxLO/GtJgM1IzJKQn+a/b0Y+FjcSdiZydV9GrTCWHAdwWZp9pLHa7GzMzRZKvxEzuQS5NpGBhZLbJSQev12Z87DrVRytD71RN3zhd3h1EW95fS6rgVdA24SaoNw50hSPtNQo7jiSMvmcLyMJGG9GJB802aFJSJzZ9XvShTPPwcWLF28ZFdkdyPMYK2tpJl11n0RUm9w3AG
 GXzy2JF2
 wfAU1r8UjYJWyZ3sc7zAGeUtL7EE5sff9l30hEQ5nrutvu34bGWCkGIrnpvyMY2DRaSLncZ2s/h6/kbhgxR5P6CRUK11E+VvvTW/oYwYGSRxYudATw0elf8wnJEUDjBnHnOq8MxvAxiWudQYCzydkOpxGjiMDuOkHUuBp9VXap12p7cXQ5PMdIEnzTTQn4ng+rcpcsLeHcv7+/QgFfkNDREPuUmFMDgKnrCuVeaaQyglV9RvTArdG9dvTtJrYRyIwEqUldzbF8Qodj950Z9xG9Bcr7kkx7WvIW9bcYXUgZ18W+UOE+PWVE2ZJSA8yKObSF/lVtF7BFN3nbMRKq3TXaBnz9OoWAhQd68cD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=3D=3D=3D=3D=3D=3D=3D Introduction
The patchset aims to add a KASAN tag-based mode for the x86 architecture
with the help of the new CPU feature called Linear Address Masking
(LAM). Main improvement introduced by the series is 2x lower memory
usage compared to KASAN's generic mode, the only currently available
mode on x86. The tag based mode may also find errors that the generic
mode couldn't because of differences in how these modes operate.

=3D=3D=3D=3D=3D=3D=3D How does KASAN' tag-based mode work?
When enabled, memory accesses and allocations are augmented by the
compiler during kernel compilation. Instrumentation functions are added
to each memory allocation and each pointer dereference.

The allocation related functions generate a random tag and save it in
two places: in shadow memory that maps to the allocated memory, and in
the top bits of the pointer that points to the allocated memory. Storing
the tag in the top of the pointer is possible because of Top-Byte Ignore
(TBI) on arm64 architecture and LAM on x86.

The access related functions are performing a comparison between the tag
stored in the pointer and the one stored in shadow memory. If the tags
don't match an out of bounds error must have occurred and so an error
report is generated.

The general idea for the tag-based mode is very well explained in the
series with the original implementation [1].

[1] https://lore.kernel.org/all/cover.1544099024.git.andreyknvl@google.com/

=3D=3D=3D=3D=3D=3D=3D Differences summary compared to the arm64 tag-based m=
ode
- Tag width:
=09- Tag width influences the chance of a tag mismatch due to two
=09  tags from different allocations having the same value. The
=09  bigger the possible range of tag values the lower the chance
=09  of that happening.
=09- Shortening the tag width from 8 bits to 4, while it can help
=09  with memory usage, it also increases the chance of not
=09  reporting an error. 4 bit tags have a ~7% chance of a tag
=09  mismatch.

- Address masking mechanism
=09- TBI in arm64 allows for storing metadata in the top 8 bits of
=09  the virtual address.
=09- LAM in x86 allows storing tags in bits [62:57] of the pointer.
=09  To maximize memory savings the tag width is reduced to bits
=09  [60:57].

- Inline mode mismatch reporting
=09- Arm64 inserts a BRK instruction to pass metadata about a tag
=09  mismatch to the KASAN report.
=09- On x86 the INT3 instruction is used for the same purpose.

=3D=3D=3D=3D=3D=3D=3D Testing
Checked all the kunits for both software tags and generic KASAN after
making changes.

In generic mode the results were:

kasan: pass:59 fail:0 skip:13 total:72
Totals: pass:59 fail:0 skip:13 total:72
ok 1 kasan

and for software tags:

kasan: pass:63 fail:0 skip:9 total:72
Totals: pass:63 fail:0 skip:9 total:72
ok 1 kasan

=3D=3D=3D=3D=3D=3D=3D Benchmarks [1]
All tests were ran on a Sierra Forest server platform. The only
differences between the tests were kernel options:
=09- CONFIG_KASAN
=09- CONFIG_KASAN_GENERIC
=09- CONFIG_KASAN_SW_TAGS
=09- CONFIG_KASAN_INLINE [1]
=09- CONFIG_KASAN_OUTLINE

Boot time (until login prompt):
* 02:55 for clean kernel
* 05:42 / 06:32 for generic KASAN (inline/outline)
* 05:58 for tag-based KASAN (outline) [2]

Total memory usage (512GB present on the system - MemAvailable just
after boot):
* 12.56 GB for clean kernel
* 81.74 GB for generic KASAN
* 44.39 GB for tag-based KASAN

Kernel size:
* 14 MB for clean kernel
* 24.7 MB / 19.5 MB for generic KASAN (inline/outline)
* 27.1 MB / 18.1 MB for tag-based KASAN (inline/outline)

Work under load time comparison (compiling the mainline kernel) (200 cores)=
:
*  62s for clean kernel
* 171s / 125s for generic KASAN (outline/inline)
* 145s for tag-based KASAN (outline) [2]

[1] Currently inline mode doesn't work on x86 due to things missing in
the compiler. I have written a patch for clang that seems to fix the
inline mode and I was able to boot and check that all patches regarding
the inline mode work as expected. My hope is to post the patch to LLVM
once this series is completed, and then make inline mode available in
the kernel config.

[2] While I was able to boot the inline tag-based kernel with my
compiler changes in a simulated environment, due to toolchain
difficulties I couldn't get it to boot on the machine I had access to.
Also boot time results from the simulation seem too good to be true, and
they're much too worse for the generic case to be believable. Therefore
I'm posting only results from the physical server platform.

=3D=3D=3D=3D=3D=3D=3D Compilation
Clang was used to compile the series (make LLVM=3D1) since gcc doesn't
seem to have support for KASAN tag-based compiler instrumentation on
x86.

=3D=3D=3D=3D=3D=3D=3D Dependencies
The base branch for the series is the mainline kernel, tag 6.18-rc3.

=3D=3D=3D=3D=3D=3D=3D Previous versions
v5: https://lore.kernel.org/all/cover.1756151769.git.maciej.wieczor-retman@=
intel.com/
v4: https://lore.kernel.org/all/cover.1755004923.git.maciej.wieczor-retman@=
intel.com/
v3: https://lore.kernel.org/all/cover.1743772053.git.maciej.wieczor-retman@=
intel.com/
v2: https://lore.kernel.org/all/cover.1739866028.git.maciej.wieczor-retman@=
intel.com/
v1: https://lore.kernel.org/all/cover.1738686764.git.maciej.wieczor-retman@=
intel.com/

Changes v6:
- Initialize sw-tags only when LAM is available.
- Move inline mode to use UD1 instead of INT3
- Remove inline multishot patch.
- Fix the canonical check to work for user addresses too.
- Revise patch names and messages to align to tip tree rules.
- Fix vdso compilation issue.

Changes v5:
- Fix a bunch of arm64 compilation errors I didn't catch earlier.
  Thank You Ada for testing the series!
- Simplify the usage of the tag handling x86 functions (virt_to_page,
  phys_addr etc.).
- Remove within() and within_range() from the EXECMEM_ROX patch.

Changes v4:
- Revert x86 kasan_mem_to_shadow() scheme to the same on used in generic
  KASAN. Keep the arithmetic shift idea for the KASAN in general since
  it makes more sense for arm64 and in risc-v.
- Fix inline mode but leave it unavailable until a complementary
  compiler patch can be merged.
- Apply Dave Hansen's comments on series formatting, patch style and
  code simplifications.

Changes v3:
- Remove the runtime_const patch and setup a unified offset for both 5
  and 4 paging levels.
- Add a fix for inline mode on x86 tag-based KASAN. Add a handler for
  int3 that is generated on inline tag mismatches.
- Fix scripts/gdb/linux/kasan.py so the new signed mem_to_shadow() is
  reflected there.
- Fix Documentation/arch/arm64/kasan-offsets.sh to take new offsets into
  account.
- Made changes to the kasan_non_canonical_hook() according to upstream
  discussion.
- Remove patches 2 and 3 since they related to risc-v and this series
  adds only x86 related things.
- Reorder __tag_*() functions so they're before arch_kasan_*(). Remove
  CONFIG_KASAN condition from __tag_set().

Changes v2:
- Split the series into one adding KASAN tag-based mode (this one) and
  another one that adds the dense mode to KASAN (will post later).
- Removed exporting kasan_poison() and used a wrapper instead in
  kasan_init_64.c
- Prepended series with 4 patches from the risc-v series and applied
  review comments to the first patch as the rest already are reviewed.

Maciej Wieczor-Retman (16):
  kasan: Unpoison pcpu chunks with base address tag
  kasan: Unpoison vms[area] addresses with a common tag
  kasan: Fix inline mode for x86 tag-based mode
  x86/kasan: Add arch specific kasan functions
  kasan: arm64: x86: Make special tags arch specific
  x86/mm: Reset tag for virtual to physical address conversions
  mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
  x86/mm: Physical address comparisons in fill_p*d/pte
  x86/kasan: KASAN raw shadow memory PTE init
  x86/mm: LAM compatible non-canonical definition
  x86/mm: LAM initialization
  x86: Minimal SLAB alignment
  x86/kasan: Handle UD1 for inline KASAN reports
  arm64: Unify software tag-based KASAN inline recovery path
  x86/kasan: Logical bit shift for kasan_mem_to_shadow
  x86/kasan: Make software tag-based kasan available

Samuel Holland (2):
  kasan: sw_tags: Use arithmetic shift for shadow computation
  kasan: sw_tags: Support tag widths less than 8 bits

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
 Documentation/arch/x86/x86_64/mm.rst      |  6 +-
 MAINTAINERS                               |  4 +-
 arch/arm64/Kconfig                        | 10 ++--
 arch/arm64/include/asm/kasan-tags.h       | 14 +++++
 arch/arm64/include/asm/kasan.h            |  2 -
 arch/arm64/include/asm/memory.h           | 14 ++++-
 arch/arm64/include/asm/uaccess.h          |  1 +
 arch/arm64/kernel/traps.c                 | 17 +-----
 arch/arm64/mm/kasan_init.c                |  7 ++-
 arch/x86/Kconfig                          |  4 ++
 arch/x86/boot/compressed/misc.h           |  1 +
 arch/x86/include/asm/bug.h                |  1 +
 arch/x86/include/asm/cache.h              |  4 ++
 arch/x86/include/asm/kasan-tags.h         |  9 +++
 arch/x86/include/asm/kasan.h              | 73 ++++++++++++++++++++++-
 arch/x86/include/asm/page.h               | 33 +++++++++-
 arch/x86/include/asm/page_64.h            |  1 +
 arch/x86/kernel/head_64.S                 |  3 +
 arch/x86/kernel/traps.c                   |  8 +++
 arch/x86/mm/Makefile                      |  2 +
 arch/x86/mm/init.c                        |  3 +
 arch/x86/mm/init_64.c                     | 11 ++--
 arch/x86/mm/kasan_init_64.c               | 24 +++++++-
 arch/x86/mm/kasan_inline.c                | 21 +++++++
 arch/x86/mm/physaddr.c                    |  2 +
 include/linux/kasan-tags.h                | 21 +++++--
 include/linux/kasan.h                     | 46 ++++++++++++--
 include/linux/mm.h                        |  6 +-
 include/linux/page-flags-layout.h         |  9 +--
 lib/Kconfig.kasan                         |  3 +-
 mm/execmem.c                              |  2 +-
 mm/kasan/report.c                         | 37 ++++++++++--
 mm/kasan/tags.c                           | 19 ++++++
 mm/vmalloc.c                              |  6 +-
 scripts/Makefile.kasan                    |  3 +
 scripts/gdb/linux/kasan.py                |  5 +-
 scripts/gdb/linux/mm.py                   |  5 +-
 38 files changed, 370 insertions(+), 75 deletions(-)
 mode change 100644 =3D> 100755 Documentation/arch/arm64/kasan-offsets.sh
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h
 create mode 100644 arch/x86/mm/kasan_inline.c

--=20
2.51.0



