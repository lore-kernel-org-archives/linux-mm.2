Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1BDD3B9BE
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 17:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006A66B0005; Wed, 10 Dec 2025 12:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9F16B0006; Wed, 10 Dec 2025 12:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F636B0008; Wed, 10 Dec 2025 12:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D17516B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:14:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7307016062C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:14:33 +0000 (UTC)
X-FDA: 84204210426.06.81F0E4B
Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65F9EA0010
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:14:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="e/uy32js";
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765386871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tQBUlk5fifS6yOJJqQb8R9OP8yHw0CO86r6/5oBtm8g=;
	b=KErRyiq1yPYKyHcXA1r2dZfDD0QEhr3+jVJEQ+ZgbNLAOmHLYqDF756pN4grcfUg9eFEHJ
	dWlmz7+KbFVpYfB0QMUcxUwjBkJwbIflqAKz8RKcoxZIspQaCxModDtCD2Kq2G8oxMq9KS
	RxzihXxK+uIRudqlWu6J1VHqQPM1rvQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b="e/uy32js";
	spf=pass (imf25.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.121 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765386871; a=rsa-sha256;
	cv=none;
	b=F6yh1mZxr01+RrPrC0H9UIo225B/aQRxTZuRbrDgbGRQjA4e/Cxk4nEPEEMROj1KVBbGGr
	m+NgbY6N1yCc6No9WchwdMdMpRW626KQy+j52KcAwj//ueeErbDIMgLGjapo1MD7gEEhtP
	erQYHgSPs1FndHaH6FSrdKDOAAuAIOk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1765386867; x=1765646067;
	bh=tQBUlk5fifS6yOJJqQb8R9OP8yHw0CO86r6/5oBtm8g=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=e/uy32jsIdRDL3KhQK0nCYKX26WYD8DuBJfF4u5uwyD807OSKskwjhpwHOsyqqLLT
	 dBsSIx7a7bV/SZUUEzPyoPxDx3k9rRZfgVaQNpV3ar51zBDv2GwdlJQweR3YuFbUIJ
	 gYq19sNk/9xdOl4btyFGzrEUKYa9eiBadET7DAEnLpHGhyybcJBRHNE/3puwDw7kVL
	 UGJY1If6ohT61ZQsIHNkqoPbyHlhv6iGy28tH6IHtiKwMRd1x4OXv38F2kNQ3dp0fO
	 SHEcKQA4oNeSiehRIQpFezRbiY63Tmy5yX/75/iR5wm9uv0D5LWDyL3GYZG8JGWnGX
	 nTDpPV9ln7VDw==
Date: Wed, 10 Dec 2025 17:14:14 +0000
To: weixugc@google.com, kas@kernel.org, lorenzo.stoakes@oracle.com, nicolas.schier@linux.dev, nathan@kernel.org, kbingham@kernel.org, bigeasy@linutronix.de, jackmanb@google.com, jeremy.linton@arm.com, andreyknvl@gmail.com, surenb@google.com, glider@google.com, kaleshsingh@google.com, dave.hansen@linux.intel.com, will@kernel.org, thuth@redhat.com, kees@kernel.org, fujita.tomonori@gmail.com, tglx@linutronix.de, jpoimboe@kernel.org, samuel.holland@sifive.com, maciej.wieczor-retman@intel.com, luto@kernel.org, vbabka@suse.cz, ardb@kernel.org, justinstitt@google.com, mhocko@suse.com, axelrasmussen@google.com, maz@kernel.org, xin@zytor.com, akpm@linux-foundation.org, rppt@kernel.org, brgerst@gmail.com, urezki@gmail.com, nick.desaulniers+lkml@gmail.com, leitao@debian.org, samitolvanen@google.com, trintaeoitogc@gmail.com, morbo@google.com, yeoreum.yun@arm.com, smostafa@google.com, dvyukov@google.com, corbet@lwn.net, peterz@infradead.org, jan.kiszka@siemens.com, yuanchu@google.com,
	ada.coupriediaz@arm.com, Liam.Howlett@oracle.com, hpa@zytor.com, mingo@redhat.com, mark.rutland@arm.com, ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, ubizjak@gmail.com, catalin.marinas@arm.com, david@redhat.com, bp@alien8.de
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, x86@kernel.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, m.wieczorretman@pm.me
Subject: [PATCH v7 00/15] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <cover.1765386422.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 50301002b2cc10e908f03a29606438935e19d835
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z3c5zx8i65az1i4rkx54kbb9mio5r3mq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65F9EA0010
X-HE-Tag: 1765386871-468149
X-HE-Meta: U2FsdGVkX1976Q25FnQ+y3jafDQs8Oaj6f1CmoEnqg9BhAmf8NrJwhl6VNzRMBLrFgcsJ3zT4k63VR5AGduwFq9D0PKq3uJEuUbLwM4C8z78rwO6Tir10TimoxhLTGXFWfhnI/oAXM1l+vEmHT+9jxQ4NX8SrAJU2A8LFx87Pg2aAqhLDAvUC9hZ+YSJ06HkN/VWI6gGZg7SXqbWO/Knnv4sc2wcDgMPMxQ73Z3OXmGE7fl2dR8fJzE0NsS6TYn4nQUd/71UgJpqfZDvUb7v1V+30UDnO8/7yKWVOUD2giTDUOdJRjND+Vjyvg+lhggr1qlFfRr7KuJlXVVMhfgNUN4ty1WpE24Sha1/gCMKnNNyqkYPRxrceBGgOl+1F9gHR8JiUauhDO2P8xNeRh0huj2YMWJzIytUm/XNnUzd/trRw0DJJkc6GhjgwC77riVv7S22n0A86HUjvp9+b7qSqVQEXkQGiLEVJQU8tvi51Erz+RCfn3Gcin5S5OrhpK0fwEQxBf3kPJyZmg8ixdNGULNzfLuIpljEu6VE/ouQNo8VxczBxOaIWb6Q3Hk5GznHQuGdVgobg11xuVcSJyhXetfLZCFP+PViFKGKQ9rVCkx6+s4GcKRa0O9m9r+NY2t4DYlKxQOwb/6Qe4njf7et92dfZDqVFXU0GFSe0O74rb0QhAaasMc7wYQQf0Dy+Q3XKAVGLfiQ1M0SjMl3K+e0Zsb4PmggQtzbkZx/OOZZIdilg/e/Ov2uDADHE5Aux/BaNrdD+Szi3oXYiuy1AaabN99Sg7YmQfy1sElgbFXWURwmktbEOSZZGubzAVbuNFnkobbdCKgjmfzOFWL/s56n3ZcYTmxi5dKRXhK8D7KUl091x9yM+CtfUOCOpNEHTyWERRcnG9p6j5tgsdn2OumepSd/mCK6Fkhzzb/DDBxwKI8EircjeiCturOo8QVkpmnjTn2EbCfoWFzDu/zu5uL
 UsygXsbl
 SfRXroH2onQVo5U3agKFp7imN8/iscWDWTmVt65W64tmTeMS+VRX1hNPJuvVXFeGD5BILeYC0bJwXwYXpqEDvluHaUUc687owoWFvf1OxBz5JxxC3ITatMFHrCv+hzyl0MXWg239b8oeTWzUq1tScTqgdih1fCikBcuxsjsbnZvcOfL26ulz2UIYhkXgfW4tBZjO4s8y+nMCUYySp5oiUUU4EYQpQjz4IIpOm0PRKLKwyIKJizMh9+Dqoiyi8xhThy8oXmzOowtLnP0YPzK2tb9VVxFwTKsWRM/Te2elO5zTyxXXMkHUxzMGXaZPKr065BKiDlgG7dbJEyirP4V+uyThzseFfzTj4LMBkRTZbtrHwr2M/iPOFf9PwBr4vbFwnVjqgxdUKRchZCj8KsKGbbZnpDfo6FYng2DoC
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
=09- Right now on x86 the INT3 instruction is used for the same
=09  purpose. This series attempts to move it over to use UD1 in
=09  the future so it's consistent with UBSan. Also using INT3 in
=09  on the kernel side causes other issues that need to be patched
=09  over.

=3D=3D=3D=3D=3D=3D=3D Testing
Checked all the kunits for both software tags and generic KASAN after
making changes.

In generic mode (both with these patches and without) the results were:

kasan: pass:61 fail:1 skip:14 total:76
Totals: pass:61 fail:1 skip:14 total:76
not ok 1 kasan

and for software tags:

kasan: pass:65 fail:1 skip:10 total:76
Totals: pass:65 fail:1 skip:10 total:76
not ok 1 kasan

At the time of testing the one failing case is also present on generic
mode without this patchset applied. This seems to point to something
else being at fault for the one case not passing. The test case in
question concerns strscpy() out of bounds error not getting caught.

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
The series is based on this series [1] by Peter Zijlstra. Also for the
series to work on bigger systems (with more than 1 NUMA node and more
than 128 cores from my experience) the vmalloc fix patchset [2] is
needed. If you don't want vmalloc support it should run without it.

[1] https://lore.kernel.org/all/20251110114633.202485143@infradead.org/
[2] https://lore.kernel.org/all/cover.1764945396.git.m.wieczorretman@pm.me/

=3D=3D=3D=3D=3D=3D=3D Previous versions
v6: https://lore.kernel.org/all/cover.1761763681.git.m.wieczorretman@pm.me/
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

=3D=3D=3D (two fixes patches were split off after v6) (merged into mm-unsta=
ble)
v1: https://lore.kernel.org/all/cover.1762267022.git.m.wieczorretman@pm.me/
v2: https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@pm.me/
v3: https://lore.kernel.org/all/cover.1764874575.git.m.wieczorretman@pm.me/
v4: https://lore.kernel.org/all/cover.1764945396.git.m.wieczorretman@pm.me/

Changes v7:
- Rebased the series onto Peter Zijlstra's "WARN() hackery" v2 patchset.
- Fix flipped memset arguments in "x86/kasan: KASAN raw shadow memory
  PTE init".
- Reorder tag width defines on arm64 to avoid redefinition warnings.
- Split off the pcpu unpoison patches into a separate fix oriented
  series.
- Redid the canonicality checks so it works for KVM too (didn't change
  the __canonical_address() function previously).
- A lot of fixes pointed out by Alexander in his great review:
=09- Fixed "x86/mm: Physical address comparisons in fill_p*d/pte"
=09- Merged "Support tag widths less than 8 bits" and "Make special
=09  tags arch specific".
=09- Added comments and extended patch messages for patches
=09  "x86/kasan: Make software tag-based kasan available" and
=09  "mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic=
",
=09- Fixed KASAN_TAG_MASK definition order so all patches compile
=09  individually.
=09- Renamed kasan_inline.c to kasan_sw_tags.c.

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

Maciej Wieczor-Retman (13):
  kasan: Fix inline mode for x86 tag-based mode
  x86/kasan: Add arch specific kasan functions
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
  kasan: arm64: x86: Make special tags arch specific

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
 Documentation/arch/x86/x86_64/mm.rst      |  6 +-
 MAINTAINERS                               |  4 +-
 arch/arm64/Kconfig                        | 10 +--
 arch/arm64/include/asm/kasan-tags.h       | 14 ++++
 arch/arm64/include/asm/kasan.h            |  2 -
 arch/arm64/include/asm/memory.h           | 14 +++-
 arch/arm64/include/asm/uaccess.h          |  1 +
 arch/arm64/kernel/traps.c                 | 17 +----
 arch/arm64/mm/kasan_init.c                |  7 +-
 arch/x86/Kconfig                          |  4 ++
 arch/x86/boot/compressed/misc.h           |  1 +
 arch/x86/include/asm/bug.h                |  1 +
 arch/x86/include/asm/cache.h              |  4 ++
 arch/x86/include/asm/kasan-tags.h         |  9 +++
 arch/x86/include/asm/kasan.h              | 81 ++++++++++++++++++++++-
 arch/x86/include/asm/page.h               | 23 ++++++-
 arch/x86/include/asm/page_64.h            |  1 +
 arch/x86/kernel/head_64.S                 |  3 +
 arch/x86/kernel/traps.c                   | 13 +++-
 arch/x86/mm/Makefile                      |  2 +
 arch/x86/mm/init.c                        |  3 +
 arch/x86/mm/init_64.c                     | 11 +--
 arch/x86/mm/kasan_init_64.c               | 25 ++++++-
 arch/x86/mm/kasan_sw_tags.c               | 19 ++++++
 arch/x86/mm/physaddr.c                    |  2 +
 include/linux/kasan-tags.h                | 21 ++++--
 include/linux/kasan.h                     | 36 ++++++++--
 include/linux/mm.h                        |  6 +-
 include/linux/mmzone.h                    |  2 +-
 include/linux/page-flags-layout.h         |  9 +--
 lib/Kconfig.kasan                         |  3 +-
 mm/execmem.c                              |  9 ++-
 mm/kasan/report.c                         | 37 +++++++++--
 mm/vmalloc.c                              |  7 +-
 scripts/Makefile.kasan                    |  3 +
 scripts/gdb/linux/kasan.py                |  5 +-
 scripts/gdb/linux/mm.py                   |  5 +-
 38 files changed, 354 insertions(+), 74 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h
 create mode 100644 arch/x86/mm/kasan_sw_tags.c

--=20
2.52.0



