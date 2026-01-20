Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C4DD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 14:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B7DC6B0428; Tue, 20 Jan 2026 09:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8859D6B042A; Tue, 20 Jan 2026 09:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6146B042B; Tue, 20 Jan 2026 09:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6688E6B0428
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:40:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15A411AF4F9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:40:30 +0000 (UTC)
X-FDA: 84352603020.23.DC233C2
Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40EE71C000D
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 14:40:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GyWAu6jQ;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768920028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SYwR7mzcRNmkDkZFtWt3FaqD6GeRNp89lD+pp3qVLF0=;
	b=6wqj9AQRQbtb44E91syVEYqFmEXPc6fRfJgabpkT5UdcTQ0RVllOLwr6JbbcRUwPjFkqdc
	8nWqf4aCJWC4PK/aay0VYEXaP0rpCCG3vus89OQ7wHTsFNJA9fE39VZoy4W5+Fdxc/jhg6
	94iTdYjta2bmOObSVYiVO4OE0AliZag=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=GyWAu6jQ;
	spf=pass (imf20.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.17 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768920028; a=rsa-sha256;
	cv=none;
	b=iKyyWjqb3J6xuZrcwBUdhdmGqNxh5AVi6k1wvK+AMh17RNfw9cY/q2+k48K5t2Cn1aaCm4
	X61S4rCjfDJYu6BcJm88jdqkcUn5kxVavBoRSwvK+/x+P2YccbVBGItvJCXIzrQcgzLcPj
	hxp2L0Aqb5pLT6vbWalqt1frenCwEFE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768920025; x=1769179225;
	bh=SYwR7mzcRNmkDkZFtWt3FaqD6GeRNp89lD+pp3qVLF0=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=GyWAu6jQ4eDP0ee6dhl6c0QtYGx/LcggVo7KU5MH3yWzl7frHDoklW3IwQD8MZPdY
	 Svu+3I02rjijfdJ8y/1q0o5/g3jTPlTFZnArTtJ5i0STJPsu5Mj84iXE5WEEbkB5ov
	 BOtb02GpzPfV/mecBquJINRR8cPpFYqXk2cFyWjXIjPpQeofT7LpmGuAkVRb2OPj8x
	 72/7vQv+sMDzFOPBlMxucK/Kc3X/+qeaorWf6ZBRpGLB3g+N3JZrdh7dGInOSHGPsM
	 TTkSGoLe7xVf1z4NJLoT9PH7jPdQJOgjD6bj+gvAh5rWNLYFsrcz58dq0J8tcHZaJk
	 W9U6lXitlcDJA==
Date: Tue, 20 Jan 2026 14:40:15 +0000
To: chleroy@kernel.org, surenb@google.com, justinstitt@google.com, nsc@kernel.org, jan.kiszka@siemens.com, trintaeoitogc@gmail.com, dave.hansen@linux.intel.com, ryabinin.a.a@gmail.com, kees@kernel.org, maciej.wieczor-retman@intel.com, urezki@gmail.com, will@kernel.org, nick.desaulniers+lkml@gmail.com, brgerst@gmail.com, ubizjak@gmail.com, rppt@kernel.org, samitolvanen@google.com, thuth@redhat.com, mhocko@suse.com, nathan@kernel.org, osandov@fb.com, thomas.lendacky@amd.com, yeoreum.yun@arm.com, akpm@linux-foundation.org, catalin.marinas@arm.com, morbo@google.com, andreyknvl@gmail.com, jackmanb@google.com, mingo@redhat.com, jpoimboe@kernel.org, vbabka@suse.cz, corbet@lwn.net, lorenzo.stoakes@oracle.com, vincenzo.frascino@arm.com, luto@kernel.org, glider@google.com, weixugc@google.com, axelrasmussen@google.com, samuel.holland@sifive.com, kbingham@kernel.org, jeremy.linton@arm.com, kas@kernel.org, tglx@kernel.org, ardb@kernel.org, peterz@infradead.org, hpa@zytor.com, dvyukov@goog
 le.com,
	yuanchu@google.com, leitao@debian.org, david@kernel.org, anshuman.khandual@arm.com, bp@alien8.de, Liam.Howlett@oracle.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: kasan-dev@googlegroups.com, linux-kbuild@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, m.wieczorretman@pm.me
Subject: [PATCH v9 00/13] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <cover.1768845098.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 73a30de0b93895cc80a2f788f03a5bd41b564548
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r55z7swzwu3bp5rsiz5pswts6jio5xb3
X-Rspam-User: 
X-Rspamd-Queue-Id: 40EE71C000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768920028-720436
X-HE-Meta: U2FsdGVkX190SfMFbD9rEgr3jsMgAzNmQQGu6rBH8j9/uEz7c7Ku8SaeDlIQveUMfE+bkgg54LMVVg3M0M+/RayIl9HwMzqyYhoa/Ufb+MnYhArVqdGqY+9m4btNcmlrezFyDTO5F9YAR4GeQbPEYtoN8BocTxd6wgjPZXVZSLAI6YqPoTWOgnu+I2ZbyTWNGaQKyG+pNxA0oTn67sUhNN5NC3y+pAeDHSd3UahTScrEs30eCSPsSZjkP+5VRyMJMq6WiXXSxhC3Cl/ygq94qxjv7KfMOBWCcmrjVt+DEn9CCG/Bv6lH1Q66Od623VV7y4/vW1CKCIckdDYgeZtwxvJccMo09NDHmVuV2AV/xhSgTCbsiIIL7QSnq8FOwU9BpfpYV2G1cCqDQtP8Qq7v5GfLmMhj2BiaVe0aT/OOn6xd02GjjjHhTJI4JccXu3l5cAVlzjg7s1Vg8p31CLlZjfKB+xgOO1PAdO/UKOI5AFOgEjGXFB44b6AVauApfZ5H5G2mLynYRgPI8Kde+r4FjcOZ1lvbtqaf4hyfJQYJbAvZmBfxNTa36PsRASfiV1zCQW9tTlIq/WX0iV2e3AfSgnAMPXh6Cr5v6a4hi1p4/MPpAx/k6NyX4nuqr/rBDpgRAyZGr3oI9SsoRjs+OyB36XQ+faxTgMDHBYOmNyZ0G3GRe0BA/wudhKVC01o7WjoxFRnlt+IqX8M+neZ77/HvdQEj/y6FD35Hq+xdEmiDMsq9QT+xm0/0xruHVZclbj/1Ma4JQv5oSgg3Gg0VitTNP89LbP6y0rqeshOopIusB8RCxXNzjmpEgqM0TBDtIpR8tW8lGAW79haHIT16Ee5eeTGb0Urz7Q1ze8WxOOBhx5Rj40UlSUF5Nb+F6K8L6aUcQD3cMkCwEP5XNj/VxiMcBdpv3PFhYu+X
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
=09  purpose. The attempt to move it over to use UD1 is already
=09  implemented and tested but relies on another series that needs
=09  merging first. Therefore this patch will be posted separately
=09  once the dependency is satisfied by being merged upstream.

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
x86. Patchset does seem to compile with gcc without an issue but doesn't
boot afterwards.

=3D=3D=3D=3D=3D=3D=3D Dependencies
The series is based on 6.19-rc6.

=3D=3D=3D=3D=3D=3D=3D Previous versions
v8: https://lore.kernel.org/all/cover.1768233085.git.m.wieczorretman@pm.me/
v7: https://lore.kernel.org/all/cover.1765386422.git.m.wieczorretman@pm.me/
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

Changes v9:
- Lock HAVE_ARCH_KASAN_SW_TAGS behind CC_IS_CLANG due to gcc not working
  in practice.
- Remove pr_info() from KASAN initialization.
- Add paragraph to mm.rst explaining the alternative KASAN memory
  ranges.
- Move out arch based code from kasan_non_canonical_hook() into arch
  subdirectories. arm64 and non-arch changes in patch 1, x86 changes in
  patch 12.
- Reset tag bits on arm64's non-canonical hook to allow inline mode to
  work.
- Revert modifying __is_canonical_address() since it can break KVM. Just
  untag address in copy_from_kernel_no_fault_allowed().
- Add a bunch of reviewed-by tags.

Changes v8:
- Detached the UD1/INT3 inline patch from the series so the whole
  patchset can be merged without waiting on other dependency series. For
  now with lack of compiler support for the inline mode that patch
  didn't work anyway so this delay is not an issue.
- Rebased patches onto 6.19-rc5.
- Added acked-by tag to "kasan: arm64: x86: Make special tags arch
  specific".

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

Maciej Wieczor-Retman (11):
  kasan: Fix inline mode for x86 tag-based mode
  x86/kasan: Add arch specific kasan functions
  x86/mm: Reset tag for virtual to physical address conversions
  mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
  x86/mm: Use physical address comparisons in fill_p*d/pte
  x86/kasan: Initialize KASAN raw shadow memory
  x86/mm: Reset tags in a canonical address helper call
  x86/mm: Initialize LAM_SUP
  x86: Increase minimal SLAB alignment for KASAN
  x86/kasan: Use a logical bit shift for kasan_mem_to_shadow
  x86/kasan: Make software tag-based kasan available

Samuel Holland (2):
  kasan: sw_tags: Use arithmetic shift for shadow computation
  kasan: arm64: x86: Make special tags arch specific

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
 Documentation/arch/x86/x86_64/mm.rst      | 10 ++-
 MAINTAINERS                               |  4 +-
 arch/arm64/Kconfig                        | 10 +--
 arch/arm64/include/asm/kasan-tags.h       | 14 ++++
 arch/arm64/include/asm/kasan.h            |  7 +-
 arch/arm64/include/asm/memory.h           | 14 +++-
 arch/arm64/include/asm/uaccess.h          |  1 +
 arch/arm64/mm/Makefile                    |  2 +
 arch/arm64/mm/kasan_init.c                |  7 +-
 arch/arm64/mm/kasan_sw_tags.c             | 35 ++++++++++
 arch/x86/Kconfig                          |  4 ++
 arch/x86/boot/compressed/misc.h           |  1 +
 arch/x86/include/asm/cache.h              |  4 ++
 arch/x86/include/asm/kasan-tags.h         |  9 +++
 arch/x86/include/asm/kasan.h              | 79 ++++++++++++++++++++++-
 arch/x86/include/asm/page.h               |  8 +++
 arch/x86/include/asm/page_64.h            |  1 +
 arch/x86/kernel/head_64.S                 |  3 +
 arch/x86/mm/init.c                        |  3 +
 arch/x86/mm/init_64.c                     | 11 ++--
 arch/x86/mm/kasan_init_64.c               | 24 ++++++-
 arch/x86/mm/maccess.c                     |  2 +-
 arch/x86/mm/physaddr.c                    |  2 +
 include/linux/kasan-tags.h                | 21 ++++--
 include/linux/kasan.h                     | 13 ++--
 include/linux/mm.h                        |  6 +-
 include/linux/mmzone.h                    |  2 +-
 include/linux/page-flags-layout.h         |  9 +--
 lib/Kconfig.kasan                         |  3 +-
 mm/execmem.c                              |  9 ++-
 mm/kasan/kasan.h                          |  7 ++
 mm/kasan/report.c                         | 15 ++++-
 mm/vmalloc.c                              |  7 +-
 scripts/Makefile.kasan                    |  3 +
 scripts/gdb/linux/kasan.py                |  5 +-
 scripts/gdb/linux/mm.py                   |  5 +-
 37 files changed, 312 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/arm64/mm/kasan_sw_tags.c
 create mode 100644 arch/x86/include/asm/kasan-tags.h

--=20
2.52.0



