Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB6F8CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:26:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7034E8E0129; Tue, 12 Aug 2025 09:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAA28E00E5; Tue, 12 Aug 2025 09:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9198E0129; Tue, 12 Aug 2025 09:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46B0A8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:26:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 19D741602FC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:26:51 +0000 (UTC)
X-FDA: 83768180622.27.BCC53C5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 46803A0002
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:26:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QjPMH/oc";
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755005209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2lO1JVCFxL3U/ib6c/wvRKRlvNz5jZEUGFdS/ayOyBI=;
	b=zUG+I7oFx1L20xuyflLY9SIFizv7EHmZiJqsIzK+sgBoSkl1QC8M3WtyWu4IlawVgGCjyB
	AZ0cuMOw5YtBaHgw3hmnhJRSZrSM/SfjiL0FtGjAXX+IDQe+IydNTEcJmcpXfA8GnPYhrL
	m6L6csTwc0Cy3nE8YXNRz6/xYSQShMI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="QjPMH/oc";
	spf=pass (imf25.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755005209; a=rsa-sha256;
	cv=none;
	b=QTnf3b5ya8qCbN9S32vZQ/o+jinZFZMpog5zPBh2mCpa1A9lwhZgKeY02u6SgmhwWnlNsW
	nUhfrlmOG3MAgh3dEbZH5DH1PgVxe3e9ADLGWeB1UF32KrM3973cCjBj/Gb6s5l2/AkVBl
	TVHdPc+M/FCBSgum5dd9M3eekt+5AHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755005209; x=1786541209;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3vjNsBiRH4qTtxkXlQjP9ZJdLJ+PMfRGcHXqnMgrRUE=;
  b=QjPMH/ocYsoQHGGe1FSnCo42J8PAuLvgUvM62xMhbiAXst9758mEKpEp
   2XLVpLH23rgeQ3+gHah5naA8vN3QkMmmJMdujMKkRYhxBwr6fCXw3hVso
   0FRXV9OE+4lG3qp/tGLvvjx9yEPbACB3ESKJ6fdxW09Q/WSJ5kriGbSz7
   dqWIntavRZiU5SaiOHySt19Tifa9hkCaomGoMVKHYk8SLE8a2eI9U3tYE
   1EjS1YZB8eZjcwK8DRiZwws6c10F+YXa2AoQ1/yVfp1DS65P1Nq8Q6uZA
   MVuy2blzOHjyawwGwtIvh9pn1VMyt+P7zcx2XOwMOqklNXEECy9jdC3tg
   A==;
X-CSE-ConnectionGUID: 2FxgArvYT1WYv0wCvnS0Kg==
X-CSE-MsgGUID: HL9ZRw9LR826lCmXCpfVvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="60903130"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="60903130"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:24:59 -0700
X-CSE-ConnectionGUID: kayhpomIS0akEcqtG//q8Q==
X-CSE-MsgGUID: VWXG4HKqROyugDxAls9HoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="165831255"
Received: from vpanait-mobl.ger.corp.intel.com (HELO wieczorr-mobl1.intel.com) ([10.245.245.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2025 06:24:35 -0700
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: nathan@kernel.org,
	arnd@arndb.de,
	broonie@kernel.org,
	Liam.Howlett@oracle.com,
	urezki@gmail.com,
	will@kernel.org,
	kaleshsingh@google.com,
	rppt@kernel.org,
	leitao@debian.org,
	coxu@redhat.com,
	surenb@google.com,
	akpm@linux-foundation.org,
	luto@kernel.org,
	jpoimboe@kernel.org,
	changyuanl@google.com,
	hpa@zytor.com,
	dvyukov@google.com,
	kas@kernel.org,
	corbet@lwn.net,
	vincenzo.frascino@arm.com,
	smostafa@google.com,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	andreyknvl@gmail.com,
	alexander.shishkin@linux.intel.com,
	thiago.bauermann@linaro.org,
	catalin.marinas@arm.com,
	ryabinin.a.a@gmail.com,
	jan.kiszka@siemens.com,
	jbohac@suse.cz,
	dan.j.williams@intel.com,
	joel.granados@kernel.org,
	baohua@kernel.org,
	kevin.brodsky@arm.com,
	nicolas.schier@linux.dev,
	pcc@google.com,
	andriy.shevchenko@linux.intel.com,
	wei.liu@kernel.org,
	bp@alien8.de,
	ada.coupriediaz@arm.com,
	xin@zytor.com,
	pankaj.gupta@amd.com,
	vbabka@suse.cz,
	glider@google.com,
	jgross@suse.com,
	kees@kernel.org,
	jhubbard@nvidia.com,
	joey.gouly@arm.com,
	ardb@kernel.org,
	thuth@redhat.com,
	pasha.tatashin@soleen.com,
	kristina.martsenko@arm.com,
	bigeasy@linutronix.de,
	maciej.wieczor-retman@intel.com,
	lorenzo.stoakes@oracle.com,
	jason.andryuk@amd.com,
	david@redhat.com,
	graf@amazon.com,
	wangkefeng.wang@huawei.com,
	ziy@nvidia.com,
	mark.rutland@arm.com,
	dave.hansen@linux.intel.com,
	samuel.holland@sifive.com,
	kbingham@kernel.org,
	trintaeoitogc@gmail.com,
	scott@os.amperecomputing.com,
	justinstitt@google.com,
	kuan-ying.lee@canonical.com,
	maz@kernel.org,
	tglx@linutronix.de,
	samitolvanen@google.com,
	mhocko@suse.com,
	nunodasneves@linux.microsoft.com,
	brgerst@gmail.com,
	willy@infradead.org,
	ubizjak@gmail.com,
	peterz@infradead.org,
	mingo@redhat.com,
	sohil.mehta@intel.com
Cc: linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	llvm@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 00/18] kasan: x86: arm64: KASAN tag-based mode for x86
Date: Tue, 12 Aug 2025 15:23:36 +0200
Message-ID: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: py38ehek1enrr4apbacodi5zycc5kixe
X-Rspam-User: 
X-Rspamd-Queue-Id: 46803A0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755005208-471977
X-HE-Meta: U2FsdGVkX1+XPS69R2jigA+LOrLWv8lJtczc+ESjeLF5FPFKf/TFzZNjWcMOyjHCkuO0Jt0At+Thzgivh6eSZeMiL9MVshD9edu+sY6S5e52nm/qEwTjxliUCp39K1RR8xairjvtfvyoEBMrxywHRCwvMqTw4VvRrvTJ+u8TKzuAE2lpiVEHrJQgnUskpvQu86z3BpZPfFGb3RDA4zdrg8ErKlSLA2cuTGMr5W1qoGvJMbD5kXV/7GPuZ32IZlA3ekE2SVedn86XOHheMheMcyVYAOj15MSf4hxk0BuVi2hhgLRcKppDXvKd2vzeo/Nb7FlaokRmCNCPiSTGoLhc9oT64ZGld+NohxcpBwHHosF90+FDFLa9zA8Y/8cFt1mYP0PALzELSmK02ZB1JpK7cLZNEfLCoPWRgo+oJC+8GU4E0qSjrmC2B5G3mUmXbCBjgE3DXIZaG42RK5q3krD8CW9OTsJiz8dhR9QVZLiDWVnpxvymkCh8jFdhzphcWANCT75fiESlJ2gWTbvxm7M4OcLeHz5Kc2qninlKeYg8/OiK4NcxQXJRmszR59d/t4/DarENypUr5MZK45ilvq9etc8Mqr7+HC+kgWGdA8BzKdEoqCWiicFQjOxVzlSMhWVJP7zF96z5QaRhK/wvtiGhuxxeGvz+eBorxz5gB++981FBO/2VgwZkcIj1uf62vF3tevbxoEaVGadwqyydW5lqnHIXfb6y/PEOHFBhYaBu/v35b3i1xDv3bZzZ6sTpXGslj0wQM/zWZ/kHQGDczZPhkkqA9+X7V76X/6/n4Ydv27saJpIuQ0PkJ0B+jGxAgIkX7HTgmJBdrfCuLdry2iVOzSvCXrw0Grfch1gIpasucNwcYuH1sv4Lb0NQJeQZsvV3H4xWeP1xKd/vwK8bqZ4dLsD2BMdSszVJPe67BU3HDdvITVuOSqlJv6R9hCQW6FkOQr+mlcTN9YDVZsSLnyv
 eax7Erci
 +CJa/pjmoyca/qonaSmlkJSBNsYCRPPDseAjWObkXizJP6BkJoXSVfEZYRnZoqt6Nl6OFQU+Cyhq7yvNBM0H+YUvFMn0CQXeg2w6nDd7OlwlIwcoL+a4Wv8s4LItMDg1RbKLysEE5rXoVCBeg7J8dPkBA7oD7fvsxQDe5mQhrFsWy4Ba7s3q0WDE7/QbfYdCxESyaiQy25GwmD/Fcp7Xjm2G4Hvg8RjMQdq3e5J5nIRxgF59QptFsbLXk4Rbf/fL3XZ1MuqqtnT/+9jKvqW15WaZRlgOGG0IhpQfY+YhqTkrExxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

======= Introduction
The patchset aims to add a KASAN tag-based mode for the x86 architecture
with the help of the new CPU feature called Linear Address Masking
(LAM). Main improvement introduced by the series is 2x lower memory
usage compared to KASAN's generic mode, the only currently available
mode on x86. The tag based mode may also find errors that the generic
mode couldn't because of differences in how these modes operate.

======= How does KASAN' tag-based mode work?
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

======= Differences summary compared to the arm64 tag-based mode
- Tag width:
	- Tag width influences the chance of a tag mismatch due to two
	  tags from different allocations having the same value. The
	  bigger the possible range of tag values the lower the chance
	  of that happening.
	- Shortening the tag width from 8 bits to 4, while it can help
	  with memory usage, it also increases the chance of not
	  reporting an error. 4 bit tags have a ~7% chance of a tag
	  mismatch.

- Address masking mechanism
	- TBI in arm64 allows for storing metadata in the top 8 bits of
	  the virtual address.
	- LAM in x86 allows storing tags in bits [62:57] of the pointer.
	  To maximize memory savings the tag width is reduced to bits
	  [60:57].

- Inline mode mismatch reporting
	- Arm64 inserts a BRK instruction to pass metadata about a tag
	  mismatch to the KASAN report.
	- On x86 the INT3 instruction is used for the same purpose.

======= Testing
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

======= Benchmarks [1]
All tests were ran on a Sierra Forest server platform. The only
differences between the tests were kernel options:
	- CONFIG_KASAN
	- CONFIG_KASAN_GENERIC
	- CONFIG_KASAN_SW_TAGS
	- CONFIG_KASAN_INLINE [1]
	- CONFIG_KASAN_OUTLINE

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

Compilation time comparison (10 cores):
* 7:27 for clean kernel
* 8:21/7:44 for generic KASAN (inline/outline)
* 8:20/7:41 for tag-based KASAN (inline/outline)

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

======= Compilation
Clang was used to compile the series (make LLVM=1) since gcc doesn't
seem to have support for KASAN tag-based compiler instrumentation on
x86.

======= Dependencies
The base branch for the series is the mainline kernel, tag 6.17-rc1.

======= Enabling LAM for testing
Since LASS is needed for LAM and it can't be compiled without it I
applied the LASS series [1] first, then applied my patches.

[1] https://lore.kernel.org/all/20250707080317.3791624-1-kirill.shutemov@linux.intel.com/

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
  kasan: Fix inline mode for x86 tag-based mode
  x86: Add arch specific kasan functions
  kasan: arm64: x86: Make special tags arch specific
  x86: Reset tag for virtual to physical address conversions
  mm: x86: Untag addresses in EXECMEM_ROX related pointer arithmetic
  x86: Physical address comparisons in fill_p*d/pte
  x86: KASAN raw shadow memory PTE init
  x86: LAM compatible non-canonical definition
  x86: LAM initialization
  x86: Minimal SLAB alignment
  kasan: arm64: x86: Handle int3 for inline KASAN reports
  kasan: x86: Apply multishot to the inline report handler
  kasan: x86: Logical bit shift for kasan_mem_to_shadow
  mm: Unpoison pcpu chunks with base address tag
  mm: Unpoison vms[area] addresses with a common tag
  x86: Make software tag-based kasan available

Samuel Holland (2):
  kasan: sw_tags: Use arithmetic shift for shadow computation
  kasan: sw_tags: Support tag widths less than 8 bits

 Documentation/arch/arm64/kasan-offsets.sh |  8 ++-
 Documentation/arch/x86/x86_64/mm.rst      |  6 +-
 MAINTAINERS                               |  4 +-
 arch/arm64/Kconfig                        | 10 ++--
 arch/arm64/include/asm/kasan-tags.h       |  9 +++
 arch/arm64/include/asm/kasan.h            |  6 +-
 arch/arm64/include/asm/memory.h           | 14 ++++-
 arch/arm64/include/asm/uaccess.h          |  1 +
 arch/arm64/kernel/traps.c                 | 17 +-----
 arch/arm64/mm/kasan_init.c                |  7 ++-
 arch/x86/Kconfig                          |  4 +-
 arch/x86/boot/compressed/misc.h           |  1 +
 arch/x86/include/asm/cache.h              |  4 ++
 arch/x86/include/asm/kasan-tags.h         |  9 +++
 arch/x86/include/asm/kasan.h              | 71 ++++++++++++++++++++++-
 arch/x86/include/asm/page.h               | 24 +++++++-
 arch/x86/include/asm/page_64.h            |  2 +-
 arch/x86/kernel/alternative.c             |  4 +-
 arch/x86/kernel/head_64.S                 |  3 +
 arch/x86/kernel/setup.c                   |  2 +
 arch/x86/kernel/traps.c                   |  4 ++
 arch/x86/mm/Makefile                      |  2 +
 arch/x86/mm/init.c                        |  3 +
 arch/x86/mm/init_64.c                     | 11 ++--
 arch/x86/mm/kasan_init_64.c               | 19 +++++-
 arch/x86/mm/kasan_inline.c                | 26 +++++++++
 arch/x86/mm/pat/set_memory.c              |  1 +
 arch/x86/mm/physaddr.c                    |  1 +
 include/linux/kasan-tags.h                | 21 +++++--
 include/linux/kasan.h                     | 51 +++++++++++++++-
 include/linux/mm.h                        |  6 +-
 include/linux/mmzone.h                    |  1 -
 include/linux/page-flags-layout.h         |  9 +--
 lib/Kconfig.kasan                         |  3 +-
 mm/execmem.c                              |  4 +-
 mm/kasan/hw_tags.c                        | 11 ++++
 mm/kasan/report.c                         | 45 ++++++++++++--
 mm/kasan/shadow.c                         | 18 ++++++
 mm/vmalloc.c                              |  8 +--
 scripts/Makefile.kasan                    |  3 +
 scripts/gdb/linux/kasan.py                |  5 +-
 scripts/gdb/linux/mm.py                   |  5 +-
 42 files changed, 381 insertions(+), 82 deletions(-)
 mode change 100644 => 100755 Documentation/arch/arm64/kasan-offsets.sh
 create mode 100644 arch/arm64/include/asm/kasan-tags.h
 create mode 100644 arch/x86/include/asm/kasan-tags.h
 create mode 100644 arch/x86/mm/kasan_inline.c

-- 
2.50.1


