Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D18CF45B4
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3F796B0005; Mon, 12 Jan 2026 12:26:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED406B0088; Mon, 12 Jan 2026 12:26:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB9D6B0089; Mon, 12 Jan 2026 12:26:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDD196B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:26:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F1A613BC84
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:26:42 +0000 (UTC)
X-FDA: 84323991444.29.8F0D232
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5E74A1C0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:26:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kply4xUI;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768238800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MZLHOnEOyMbQ1BnCPqw/Rl/jRpv2IPlwroWlod1BlMw=;
	b=664cVjA/zgvyOMkCWkbC4i/+4cxA+E8aUwajMazZhuGGzb4FamlnOGS6FKRQnPnt8H/2xt
	MP4uQFIhzsrd3POwlu2sM+fWaoFPuvbDY3XusFd+e37iEd0eh86dhWmOYuPsisgkjBm/FZ
	+wY/1QkTytBv+WHP0rCX+K37odqvzTo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=kply4xUI;
	spf=pass (imf18.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768238800; a=rsa-sha256;
	cv=none;
	b=ezLc4k+P997yIPHl7MjSr95rA2kXNJuR/azcWTL5nrILlMvYI4uwcuoQXl2tOUSvA9WbN1
	vwqYXXFCqABMASIJSK4luj2HRmwqjVC2qBUTc1OMfJBIQGA9Z8mqdDdyKyu7Ao3zPYXOpb
	2JuBZSaIUmnCridFbjAYunsmMWZ34CY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1768238796; x=1768497996;
	bh=MZLHOnEOyMbQ1BnCPqw/Rl/jRpv2IPlwroWlod1BlMw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=kply4xUIWIJKE9qKLZzPiVBWr6K5CwxcMYvGpYmG6ThhF8F1rSlzHpj6tRIbdsWY3
	 JAxCgzWDC+YtpHsZ40KxgqHb8dzrfNLMVSMA7xcR2uq2see9+MhLel0NiOn/OYWOwf
	 3y1Inb3vddque1SSXqiO/Shu+CgQ9/uv/1hYsqhAsPWxpBfgYFDZ3hZ7vcXvyaOyhF
	 P98qIYLYZdBt0+TX+gftyVoAsfnZaaO6Dhks4I7e6MsxOy7KcLlPADfvqOU/qmeS59
	 4+9c3jYB0blRAH6qRi7guvNH7ykkLpGbQZhS9+V/jLMljmeD9jLYOBDLi9jCaAo4/4
	 0emtNXymLoimw==
Date: Mon, 12 Jan 2026 17:26:29 +0000
To: corbet@lwn.net, morbo@google.com, rppt@kernel.org, lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com, thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com, axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com, bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com, urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com, andreyknvl@gmail.com, weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, nathan@kernel.org, trintaeoitogc@gmail.com, samitolvanen@google.com, tglx@kernel.org, thuth@redhat.com, surenb@google.com, anshuman.khandual@arm.com,
	smostafa@google.com, yuanchu@google.com, ada.coupriediaz@arm.com, dave.hansen@linux.intel.com, kas@kernel.org, nick.desaulniers+lkml@gmail.com, david@kernel.org, bp@alien8.de, ardb@kernel.org, justinstitt@google.com
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org, m.wieczorretman@pm.me
Subject: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <cover.1768233085.git.m.wieczorretman@pm.me>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 30fd795ba3d87d5fa5bf659d16f56b67634e08f5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 46kxf8napkq5ihncgtddufbyxfh4948z
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E74A1C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768238800-395329
X-HE-Meta: U2FsdGVkX19UMcwsff48ht1DpD3+QAiyPHVrOgtVKS4jpkBOV0tCWEiE9mq0BSuj5M+yqoy6ieUypdj4AgNVw8PR+Ing0UWxX0uWi3QpnYzBKspLmDcGGonTxdI3pL4q3TL5EIflnk4AYRRAcPiSFp3OBZVKjoGpp25MPBxFdFuczEhNIj0tzDBS34fakOsP832JAcr0/BlyJWBN5wkwpdQBrJAFC92Nlsk8egxInzlQU3+EXO345vgZJ/1mROyOtnkkWbmoxb6fYkTw/65BmDoWf/Umx4rnyEj7nIH8v9Wls7ZADBGQMovis1PuBY1vJlrx0+00mGyDmkQhXeYFRnH5+EpF6WATebGKjyCeAyQIF6yiH4BOuqYsDyLHQk/30I1G9XOtrttf9Yc6TqODrVp8ummePBcOQN98dVFCu8eNAPVSvBgHM57nICXTDD7savM9jMxlp8ilVMtymBKSnMwxeOLqTmv3Aiw2QZZbZhyel8c2imWJYRWkjgmsUJ7svL6ty8+mr17EufObEWf1pXOO1mQPpQuXvEZbs0CpQtyRTj1Qn/Z4KYyFoo1ABIAy4Mo1BxswvWVWkRdMDL213+8ZLkQLxuF7Dtn6aHEpUk9lxOOakh10ahRcsPid5OyMvsum5nkCTU+0OY06SwnbjpmDZ9RmqwWqiCADNYDJvk8HtB1Ny2q2JpD0/gl47aSGS1FTsD/y84UPnYxTlzDutswEnK8Jphw8tZZptXTk0acRdkvrMtFkTPu3Nut+s5ovLN8+VCSvKoIXXRyMn4tMAeY+k44dfvQZe221Qr1iN6MIE9i39szUYfa5dYXXlq+KdfjO4phsvYVU8grGIZ3fmUdaB9gUO2rkaKr2WvZ0yWDFexSYmgtQi2Rqn59/0mnolbbemrb8MJcjer9KfevXCXoZobiFi0UBcqwCaXw5ksNGqOIS8wt2Z+5tgZ9uUiY8JjY+CuyzrH425aIBWiq
 88tTyv6j
 znalsuMv0eu7OTmACUB4m+j0SdDM7sokPVHFZM+bJdfBySniUYBaTHiBPPTJEpxgTfTAV1F5E3XI9OHLttb310vwWajftV4aCRe9+LKW53TD7tWNyBIxGpNx6vYJPp5jklwM30vNdo8t0de3R4y0u9CI8OBNDRPgMwogzQLW2A9GpbRbkMWurKm6ubhUyldyTE3L0ifuE//gQiDwKDM0Ec75TyYmc3nh9KsY2GEX0bJo3CiJRYz8F6upaRn6uO3sdifDFJ0NC2lJhP7hd9bq2hiFY3NoHU23/yzPyQpHs9DFh5Ac3Lnuws39GQCQRm/BgttL2OeoO5aeSaVrKFsz394KGLxOpfLQnJlBjC449h2hhmnU=
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
x86.

=3D=3D=3D=3D=3D=3D=3D Dependencies
The series is based on 6.19-rc5.

=3D=3D=3D=3D=3D=3D=3D Previous versions
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

Maciej Wieczor-Retman (12):
  kasan: Fix inline mode for x86 tag-based mode
  x86/kasan: Add arch specific kasan functions
  x86/mm: Reset tag for virtual to physical address conversions
  mm/execmem: Untag addresses in EXECMEM_ROX related pointer arithmetic
  x86/mm: Physical address comparisons in fill_p*d/pte
  x86/kasan: KASAN raw shadow memory PTE init
  x86/mm: LAM compatible non-canonical definition
  x86/mm: LAM initialization
  x86: Minimal SLAB alignment
  arm64: Unify software tag-based KASAN inline recovery path
  x86/kasan: Logical bit shift for kasan_mem_to_shadow
  x86/kasan: Make software tag-based kasan available

Samuel Holland (2):
  kasan: sw_tags: Use arithmetic shift for shadow computation
  kasan: arm64: x86: Make special tags arch specific

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
 Documentation/arch/x86/x86_64/mm.rst      |  6 ++-
 MAINTAINERS                               |  2 +-
 arch/arm64/Kconfig                        | 10 ++--
 arch/arm64/include/asm/kasan-tags.h       | 14 +++++
 arch/arm64/include/asm/kasan.h            |  2 -
 arch/arm64/include/asm/memory.h           | 14 ++++-
 arch/arm64/include/asm/uaccess.h          |  1 +
 arch/arm64/kernel/traps.c                 | 17 +------
 arch/arm64/mm/kasan_init.c                |  7 ++-
 arch/x86/Kconfig                          |  4 ++
 arch/x86/boot/compressed/misc.h           |  1 +
 arch/x86/include/asm/cache.h              |  4 ++
 arch/x86/include/asm/kasan-tags.h         |  9 ++++
 arch/x86/include/asm/kasan.h              | 62 ++++++++++++++++++++++-
 arch/x86/include/asm/page.h               | 23 ++++++++-
 arch/x86/include/asm/page_64.h            |  1 +
 arch/x86/kernel/head_64.S                 |  3 ++
 arch/x86/mm/init.c                        |  3 ++
 arch/x86/mm/init_64.c                     | 11 ++--
 arch/x86/mm/kasan_init_64.c               | 25 +++++++--
 arch/x86/mm/physaddr.c                    |  2 +
 include/linux/kasan-tags.h                | 21 ++++++--
 include/linux/kasan.h                     | 13 +++--
 include/linux/mm.h                        |  6 +--
 include/linux/mmzone.h                    |  2 +-
 include/linux/page-flags-layout.h         |  9 +---
 lib/Kconfig.kasan                         |  3 +-
 mm/execmem.c                              |  9 +++-
 mm/kasan/report.c                         | 37 ++++++++++++--
 mm/vmalloc.c                              |  7 ++-
 scripts/Makefile.kasan                    |  3 ++
 scripts/gdb/linux/kasan.py                |  5 +-
 scripts/gdb/linux/mm.py                   |  5 +-
 34 files changed, 277 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h

--=20
2.52.0



