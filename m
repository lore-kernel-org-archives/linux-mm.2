Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAACCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D8F6B0088; Tue, 26 May 2026 07:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE7C6B008A; Tue, 26 May 2026 07:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590106B008C; Tue, 26 May 2026 07:17:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34C286B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF2061C14F9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:00 +0000 (UTC)
X-FDA: 84809319000.07.3822FC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D2D691C000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:16:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vUMYZK2r;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BQBqeJh/vlchEJHXIhCtUGKFsFKPdFJR8D9Ssz1Chdo=;
	b=hEHmI01fxkPH1WRrCkCC5nfBG7nbOfUd99BOGGJ2VMCO4Meq43gnwyykiDjPtdCuIx+wvC
	kONDhuC0xM+aZvB3h4NFHFfwCFh1HKeW2q4bGwcdrzWbhc3rJ0eFqDtqkRjINWPlpNHWmt
	7DbENyGoG75TSPWEHvFjgvBzGFf/QvI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vUMYZK2r;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794219; a=rsa-sha256;
	cv=none;
	b=3Knf1Re95lGbWqr/Sn6SNQcte3dJZwma15VSICSjCUDWc1VROkuC2nBFpNJv84D1g8wCBi
	q8h5UQ38pYNX/UHuIf1YdfwsKQrvmxMxhs+cosE2Jy+CD33q/Wodg4oug+Cs+RdGLw5J27
	a5VVqbwlQXOjg+so6eyU8Ef9TOfQNmw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86956169C;
	Tue, 26 May 2026 04:16:52 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 934D73F7D8;
	Tue, 26 May 2026 04:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794217; bh=J94SapULb1Gjco4hTQtckV5y9vgnJP/O3cSrouvrLHM=;
	h=From:Subject:Date:To:Cc:From;
	b=vUMYZK2rqgg59XVZkpE8fFzyjcYtqEvftDaIQ5vO2BeaMsiX8bBybL1szP1w3eeAD
	 4A3XzHoqsTZ4kxxzC89rlPRbTDMsafc6udlCk84ZDq1wUuq6+UDNDD9l6K1tyygHPr
	 ea+6nVOOLHZlEgfU5Tw9jsH8NH3H6lm0YvRVpHgU=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH RFC v8 00/24] pkeys-based page table hardening
Date: Tue, 26 May 2026 12:15:49 +0100
Message-Id: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOaAFWoC/0WOQQ6CMBBFr2K6tqQdKQVXJiYewK1hAWWQ2kBJi
 0RCuLsFoy7/5P83byYenUZPjruZOBy117YLId3viGqK7o5UVyETYJCwGFJqeoOTp8gTkcSCAyh
 OQrl3WOvXBrqR6+VM8s/RP8sHqmFFrLXa2ZYOjcPiTwWQXArB0+ggIWVCUE5NUOmi0tnKm+lUu
 DZStl0BjfaDddPmO8rt2wYRTHzVRkkZBaZYWVWZ5Jn87fNlWd5gu+eV8gAAAA==
X-Change-ID: 20260428-kpkeys-e165645122c1
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794211; l=27691;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=J94SapULb1Gjco4hTQtckV5y9vgnJP/O3cSrouvrLHM=;
 b=IQL6uYBri1xbN3EwGpqMbjDFn7HMMfLy6tLVfK/0qEGoqHrcvzupcIr8/MRhmquLx+qNMXmeP
 u29SeAWsR61CpLBPRoJWoQ9efBbOSI7+MW1yZerpw6mTyxhboC6Vaiw
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: ssxquaqhmo7tzgpbaum3mdkt8cwwjraj
X-Rspamd-Queue-Id: D2D691C000F
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779794218-898347
X-HE-Meta: U2FsdGVkX1+zQEBMKUloPPGo1ASmg5ZZlQpeRgUTkS63pknRgZDQQyzdJzpLZBmtTLwb9WcT508bNNC0644LsI/YTZV1LOg1mo/xJXfjFROkEa64MHPDJFEK4KWeG2gaA8RfA3r0T6ixuT1MRCWJP9aCs6wUPZyEaHR57Cr9mK9aODqvK80NPAo6nmo3cbpzzdQFZrEL/ZrbRnuqy8iTpUBXRyWTaWT/7Y16sc7JSnkXhs7cNmoTrG4QWRg/atushtexb7kNUFhnJbuZw3KqTxv3IvPMvSshfPXNmhOLUbUxnm1iqcEsmMU2Tva7UK15Y/4vEAMPBHMIb+yLeXudhV37RpGT8RGpSNbTI7AMeNGZPMq+ErNm6uv+el34aIKehw6ETej4AFqrDMDwZRyUcG8lJ4cik4ZZsqpIPiSqKnIM7qfEud16/EakKKO2hT85wLvAxi8u7QTGOlUeij2ilVOs5d6RtWE2+V+e8uLwPZkqOrnTVqFkxpbmdR0vdM/N0BJcBtjufNSS1IoUm/7TZ6rgc07hku1N8ZeSjatNVXLSJwZgcK47IH7tIwUETFMzitil59944Gs6sdc1akCugRMSbIEgjCF/ijN6U96cqyuv6pm29AeOcmMfrPDJcdPbTPFCjgteuGeSqMpvC9qnUEXxeqvF4WlZQgkqdenllAXATl8UG8KGHdUwrg8uB+ag3Icm6n4rslFFEcF85cFM9v8Y7zRCZ83MtHw921XnqwHDngkqY6ey2zD6jGm0l8H0TA2f/oYVGv0gtmroQICD+Y/4XvG+YTxcqHHP6FgkFmc9vxqzMet5kQ3KEnk+EdpY25q4GfQhvsxoi/H1Sr6PBnsYhuiHLnSCnhyJRve1YkbJ0w8Nlo0GQ1MawfuAd7MmqqzQnq4PMKSZFu2TLJ8l2Mo/XU7zoc5+H+KXnoDNzI7lt+/ruFgW7gWgeGz1tB4K3005LteRcVmQt9gj3fD
 VQLhOH1C
 VCJGAIK3/TCkOGIz7selj38mzmPS9TjNV429kX/r1uHRHhT8hJZyZ/H4rEiGAEG6/31LhWVHYyQ7/9b9d/rdZT/jA4TnbkEnuUhqy/SoW7SxAaf/4BmzTXro+W3HMQiS5qnkc08Lz6H4RcKddB3S3fFxY+TiCMoZLISE8qzuxCWdI531P/mOS9y51tjHaNPLdnGzaQ9/b0iivqqAWyMUrxGq74esr93VEH3DI9MmbOraTt0DxEKyGVs9IpvTyx+jbgKHG2cG1XpQLLaqWuBFRwpNlDbikRUBvMmqms6ebtr1wn/9KOMtOY+a/6BmetoZ4x5ozJf6QEDlrzMfl8DkeW+kk0272OlQa7Pxud2Bs7GpdgQkCpDxoQUq6uxFavY8YXy6FRNP/xejGTMmGLIZhlKjqj48HgnZAyPx7wUBkBinEFOcciZAQxAXWsQ5D9cHw8lsp66se+qFF+iJZOGC+bhtqbZas9r8u8FNTgI9+fLK+H1HS/VP9e+I0yOKtPW+6MpVzLMdSG86nCb5nPyclVTEtn6XHksx1bd68Ozo0gJA7zFdqVWRiNYBpVHFsIZ9VEJfxvm+HF0GOXKPxxKi+jDMcER176GgrYsrQEP9dUM4AX7t3jbdwXcAYmPn3JzRY1gu/0kLiOhtHvrQW0UsVhZmR7GIKyQjLRqpPJnD/dfiP/vMtI8MvltNyrKrMxa4Is2iAwwhcyI2WYP2Pf+W3qVBypbJb6I1CiNBAQ7wPwSHixDgepYuNS444cgzzp8qmc0L1agKTDk6npRhctpdxFGxRXNutqJYx89DNEroItnqD0JF1H3wPW9p6VoVYJ3Nhx+qLQSHVostNXC7y0Zw3bsq7vX7jk75RVUwGmd4oKryyXOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a proposal to leverage protection keys (pkeys) to harden
critical kernel data, by making it mostly read-only. The series includes
a simple framework called "kpkeys" to manipulate pkeys for in-kernel use,
as well as a page table hardening feature based on that framework,
"kpkeys_hardened_pgtables". Both are implemented on arm64 as a proof of
concept, but they are designed to be compatible with any architecture
that supports pkeys.

The proposed approach is a typical use of pkeys: the data to protect is
mapped with a given pkey P, and the pkey register is initially
configured to grant read-only access to P. Where the protected data
needs to be written to, the pkey register is temporarily switched to
grant write access to P on the current CPU.

The key fact this approach relies on is that the target data is
only written to via a limited and well-defined API. This makes it
possible to explicitly switch the pkey register where needed, without
introducing excessively invasive changes, and only for a small amount of
trusted code.

Page tables are chosen as an initial target because of their especially
critical nature - a single write may result in arbitrary pages becoming
accessible to any context (including userspace). In order to keep the
series digestible for reviewers, this version focuses on functionality
rather than performance, making it most suitable as a debug feature. The
key trade-off is the requirement to PTE-map the linear map - see section
"Protected page table allocation" for details.

This series has similarities with the "PKS write protected page tables"
series posted by Rick Edgecombe a few years ago [1] but it is not
specific to x86/PKS - the approach is meant to be generic.

This proposal (as of RFC v5) was presented at Linux Security Summit
Europe 2025 [2].

[Table of contents]

* kpkeys
  - pkey register management

* kpkeys_hardened_pgtables
  - Protected page table allocation
  - kpkeys context switching
  - Performance
  - Limitations

* This series
  - Branches

* Threat model

* Further use-cases

* Open questions

kpkeys
======

The use of pkeys involves two separate mechanisms: assigning a pkey to
pages, and defining the pkeys -> permissions mapping via the pkey
register. This is implemented through the following interface:

- Pages are assigned a pkey in the linear map using set_memory_pkey().
  This is sufficient for this series, but it is also plausible for
  higher-level allocators to support marking allocations with a given
  pkey.

- The pkey register is configured based on a *kpkeys context*. kpkeys
  contexts are represented as simple integers that correspond to a given
  configuration, for instance:

  KPKEYS_CTX_DEFAULT:
        RW access to KPKEYS_PKEY_DEFAULT
        RO access to any other KPKEYS_PKEY_*

  KPKEYS_CTX_<FEAT>:
        RW access to KPKEYS_PKEY_DEFAULT
        RW access to KPKEYS_PKEY_<FEAT>
        RO access to any other KPKEYS_PKEY_*

  Only pkeys that are managed by the kpkeys framework are impacted;
  permissions for other pkeys are left unchanged (this allows for other
  schemes using pkeys to be used in parallel, and arch-specific use of
  certain pkeys).

  The kpkeys context is changed by calling kpkeys_set_context(), setting
  the pkey register accordingly and returning the original value. A
  subsequent call to kpkeys_restore_pkey_reg() restores the kpkeys
  context. The numeric value of KPKEYS_CTX_* (kpkeys context) is purely
  symbolic and thus generic, however each architecture is free to define
  KPKEYS_PKEY_* (pkey value).

pkey register management
------------------------

The kpkeys model relies on the kernel pkey register being set to a
specific value for the duration of a relatively small section of code,
and otherwise to the default value. Two aspects should be considered:

1. Exception entry/return

2. Thread context-switch

Ideally, an implementation would switch the pkey register in both
cases: 1. reset it to a fixed state on exception entry, and 2.
context-switch it along with the other thread registers.

In this series, the arm64 implementation only performs 2. i.e.
context-switching POR_EL1 per-thread. This ensures that each thread's
pkey register is preserved no matter how a thread is rescheduled
(voluntarily or not).

Resetting POR_EL1 on exception entry proved problematic for the
kpkeys_hardened_pgtables feature with the lazy MMU optimisation (see
next section), because page table setters may be used immediately when a
thread resumes after being rescheduled on irqexit, before exception
return. If POR_EL1 is reset on exception entry, we may end up in an
inconsistent state where lazy MMU mode may be enabled but POR_EL1 does
not allow writing to page tables until exception return. For more
details, see [3].

Having the entire exception handling inherit the interrupted POR_EL1 is
not ideal as it increases the amount of code run with a potentially
privileged kpkeys state. It may be possible to pause the lazy MMU mode
to avoid the issue described above, but it isn't clear whether this is
a general enough solution.

An important assumption is that all kpkeys contexts allow RW access to the
default pkey (0). Context-switching and saving/restoring POR_EL1 on
exception entry/return becomes significantly more complex otherwise.

kpkeys_hardened_pgtables
========================

The kpkeys_hardened_pgtables feature uses the interface above to make
the (kernel and user) page tables read-only by default, enabling write
access only in helpers such as set_pte().

Protected page table allocation
-------------------------------

Kernel page tables are required as soon as the MMU is turned on, i.e.
extremely early. Different allocators are therefore used to obtain
page table pages (PTPs), depending on where we are in the boot sequence.
In chronological order:

1. Static pools (in the kernel image itself). Typically used to map the
   kernel image. By definition these pools have a fixed size.

2. memblock. Mainly used to create the linear map and sparse-vmemmap
   page tables.

3. Buddy allocator, via pagetable_alloc(). Used for everything else,
   including user page tables, once available.

No matter which allocator is used, this feature relies on the linear map
being modified to map PTPs with KPKEYS_PKEY_PGTABLES. If large block
mappings are used to create the linear map, blocks may need to be split
when setting the pkey for individual PTPs, which in turn requires a new
PTP to be allocated. RFC v6 introduced a PTP allocator that both handles
splitting and minimises it. This fairly complex component was removed in
RFC v7 so that reviewers can focus on the core logic of the feature,
which is otherwise fairly straightforward.

The present series therefore requires the linear map to be fully
PTE-mapped, so that PTPs can be individually protected without worrying
about block splitting.

The different sources of PTPs listed above are protected as follows:

1. Static pools: an arch hook is introduced to set the pkey of those
   PTPs once the linear map is set up.

2. Early page tables: a very simple memblock-based allocator is
   introduced. The linear map may not be ready yet when these PTPs are
   allocated, so this allocator tracks all allocated pages so that their
   pkey can be set later.

3. Regular page tables: directly obtained from the buddy allocator and
   their pkey set right away.

All this infrastructure is generic. This series only includes the
required plumbing for arm64, but it is meant to be plumbed into x86 in a
similar manner.

kpkeys context switching
------------------------

Page tables are only supposed to be written via a fairly small set of
helpers, so only a few switches to a privileged kpkeys context need to be
introduced.

However, a naive implementation is very inefficient when many PTEs are
changed at once, as the kpkeys context is switched twice for every PTE.
On arm64, this means two barriers (ISBs) per PTE. This is optimised by
making use of the lazy MMU mode to batch those switches: 1. switch to
KPKEYS_CTX_PGTABLES on arch_enter_lazy_mmu_mode(), 2. skip any kpkeys
switch while in that section, and 3. restore the kpkeys context on
arch_leave_lazy_mmu_mode(). When that last function already issues an
ISB (when updating kernel page tables), we get a further optimisation as
we can skip the ISB when restoring the kpkeys context.

The lazy MMU mode may be enabled/disabled in a nested manner. This is
handled thanks to [5] - if nesting occurs, only the outer section will
switch kpkeys context.

Performance
-----------

No arm64 hardware currently implements POE. Benchmarking has however
been performed on a mock implementation, which should be fairly
representative. On a "real-world" and fork-heavy workload like
kernbench, the estimated overhead is around 2% in system time, while the
real time overhead is negligible. Microbenchmarks focused on
creating/destroying mappings yield overheads up to 15%, but typically
much smaller once batching kicks in (when modifying many PTEs at once).

For more details, see this section in RFC v5 and v6 (linked in the
changelog).

This series
===========

The series is composed of two parts:

- The kpkeys framework (patch 1-9). The main API is introduced in
  <linux/kpkeys.h>, and it is implemented on arm64 using the POE
  (Permission Overlay Extension) feature.

- The kpkeys_hardened_pgtables feature (patch 10-24). <linux/kpkeys.h>
  is extended with an API to protect page table pages and a guard object
  to switch kpkeys context accordingly, both gated on a static key. This
  is then used in generic and arm64 pgtable handling code as needed.
  Finally a simple KUnit-based test suite is added to demonstrate the
  page table protection.

Branches
--------

To make reviewing and testing easier, this series is available here:

  https://gitlab.arm.com/linux-arm/linux-kb

The following branches are available:

- kpkeys/rfc-v8 - this series, as posted

Threat model
============

The proposed scheme aims at mitigating data-only attacks (e.g.
use-after-free/cross-cache attacks). In other words, it is assumed that
control flow is not corrupted, and that the attacker does not achieve
arbitrary code execution. Nothing prevents the pkey register from being
set to its most permissive state - the assumption is that the register
is only modified on legitimate code paths.

A few related notes:

- Functions that set the pkey register are all implemented inline.
  Besides performance considerations, this is meant to avoid creating
  a function that can be used as a straightforward gadget to set the
  pkey register to an arbitrary value.

- kpkeys_set_context() only accepts a compile-time constant as argument,
  as a variable could be manipulated by an attacker. This could be
  relaxed but it seems unlikely that a variable kpkeys context would be
  needed in practice.

Further use-cases
=================

It should be possible to harden various targets using kpkeys, including:

- struct cred - proposal posted as a separate series [6]

- eBPF programs (preventing direct W/X to core kernel code/data) -
  work in progress [7]

- fixmap

- SELinux state (e.g. struct selinux_state::initialized)

... and many others.

kpkeys could also be used to strengthen the confidentiality of secret
data by making it completely inaccessible by default, and granting
read-only or read-write access as needed. This requires such data to be
rarely accessed (or via a limited interface only). One example on arm64
is the pointer authentication keys in thread_struct, whose leakage to
userspace would lead to pointer authentication being easily defeated.

Open questions
==============

A few aspects in this RFC that are debatable and/or worth discussing:

- There is currently no restriction on how kpkeys contexts map to pkeys
  permissions. A typical approach is to allocate one pkey per context and
  make it writable in that context only. As the number of contexts
  increases, we may however run out of pkeys, especially on arm64 (just
  8 pkeys with POE). Depending on the use-cases, it may be acceptable to
  use the same pkey for the data associated to multiple contexts.

- kpkeys_set_context() and kpkeys_restore_pkey_reg() are not symmetric:
  the former takes a kpkeys context and returns a pkey register value,
  to be consumed by the latter. It would be more intuitive to manipulate
  kpkeys contexts only. However this assumes that there is a 1:1 mapping
  between kpkeys contexts and pkey register values, while in principle
  the mapping is 1:n (certain pkeys may be used outside the kpkeys
  framework).

Any comment or feedback is highly appreciated, be it on the high-level
approach or implementation choices!

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
Changelog

RFC v7..v8:

[Changes below are addressing issues reported by Sashiko [13]]

- Patch 3: do not enable overlays for user memory types in POR_EL1 -
  this breaks the atomic futex uaccess operations. Added some
  comment and test in a separate series [14] to clarify this.

- Patch 5: fix return type of arch_kpkeys_set_context()

- Patch 7: reset POR_EL1 to POR_EL1_INIT when cloning a thread. The
  pkey register value is tied to the context of the original thread
  (e.g. being in lazy MMU mode) and should not be inherited by the
  new thread in the general case.

- Patch 11: make ARCH_HAS_KPKEYS_HARDENED_PGTABLES explicitly depend
  on ARCH_HAS_KPKEYS (not sure why I didn't do that to start with...)

- Patch 14:
  * GFP_PGTABLE_KERNEL is not defined on all arch's, use
    GFP_KERNEL | __GFP_ZERO instead [reported by kernel CI]
  * Amend the arm64 hotplug code to use pagetable_free(), ensuring
    that the pkey is reset when vmemmap page tables are freed (this
    may belong to a separate patch, surprisingly x86 already uses
    pagetable_free() for this purpose)
  * Fix new caller of vmemmap_alloc_block_zero(), call memset()
    directly since that's the only caller left [also reported by
    kernel CI]
  * Added a note to the commit message explaining why
    __GFP_RETRY_MAYFAIL is not used

- Patch 21: reduced scope of guard in __ptep_set_access_flags_anysz()

- Patch 24: write to P4D/PUD if not folded in write_direct_map_pggtables()

- Other minor improvements

RFC v7: https://lore.kernel.org/all/20260505-kpkeys-v7-0-20c0bdd97197@arm.com/

RFC v6..v7:

- Rebased on v7.1-rc2

- Removed large block mapping support to ease reviewing and focus on the
  core changes. [David Hildenbrand] Accordingly, patched 19 was modified
  to force PTE mappings if kpkeys_hardened_pgtables is enabled.

- Added patch 14 to protect the sparse-vmemmap page tables.

- Dropped patch "arm64: Reset POR_EL1 on exception entry" as it may
  cause a crash when a thread with lazy MMU mode enabled is resumed on
  the irqexit path. See [3] and section "pkey register management" for
  details. The POR_EL1_INIT bits were squashed into patch 5 (they are
  still needed for patch 8).

- Renamed "kpkeys level" to "kpkeys context" as there is no longer a
  notion of ordering - each "context" may be given access to any set of
  pkeys. [David H]

- Re-organised *_enabled() functions [partially suggested by David H].
  The interface is now fully generic and defined in <linux/kpkeys.h>:

    - kpkeys_enabled() -> arch_supports_kpkeys()
    - kpkeys_hardened_pgtables_enabled() -> static key
    - kpkeys_hardened_pgtables_early_enabled() -> arch_supports_kpkeys_early()

  Each arch then implements (without #ifdef'ing required):

    - arch_supports_kpkeys()
    - arch_supports_kpkeys_early()

  See patch 1, 5, 11, 16 for details.

- Patch 2: remove KASAN tag when checking if the address falls in the
  linear map [reported by Yeoreum Yun, thanks!]

- Patch 11: export symbol for the lazy MMU KUnit tests (reported by
  build CI)

- Patch 24: added test for the sparse-vmemmap page tables

RFC v6: https://lore.kernel.org/linux-hardening/20260227175518.3728055-1-kevin.brodsky@arm.com/

RFC v5..v6:

- Rebased on v7.0-rc1 (includes support for splitting large block
  mappings with BBML2-noabort [4] and nested lazy MMU sections [5])

- Completely new approach for allocating protected page tables, see
  section "Protected page table allocation". Patch 11-26 are mostly new.

- Patch 6: check arch_kpkeys_enabled() to make sure that page table
  attributes are still changed when using the mock implementation

- Patch 9: new patch (thank you Yeoreum!)

- Patch 28: minor changes following the merging of the nested lazy MMU
  series [5]

- Patch 30:
    * Many tests added to provide better coverage of the various page
      table allocation paths
    * Require that the tests are built-in (many referenced symbols are
      not exported)
    * Some refactoring to reduce duplication and add logging

RFC v5: https://lore.kernel.org/linux-hardening/20250815085512.2182322-1-kevin.brodsky@arm.com/

RFC v4..v5:

- Rebased on v6.17-rc1.

- Cover letter: re-ran benchmarks on top of v6.17-rc1, made various
  small improvements especially to the "Performance" section.

- Patch 18: disable batching while in interrupt, since POR_EL1 is reset
  on exception entry, making the TIF_LAZY_MMU flag meaningless. This
  fixes a crash that may occur when a page table page is freed while in
  interrupt context.

- Patch 17: ensure that the target kernel address is actually
  PTE-mapped. Certain mappings (e.g. code) may be PMD-mapped instead -
  this explains why the change made in v4 was required.

RFC v4: https://lore.kernel.org/linux-mm/20250411091631.954228-1-kevin.brodsky@arm.com/

RFC v3..v4:

- Added appropriate handling of the arm64 pkey register (POR_EL1):
  context-switching between threads and resetting on exception entry
  (patch 7 and 8). See section "pkey register management" above for more
  details. A new POR_EL1_INIT macro is introduced to make the default
  value available to assembly (where POR_EL1 is reset on exception
  entry); it is updated in each patch allocating new keys.

- Added patch 18 making use of the lazy_mmu mode to batch switches to
  KPKEYS_LVL_PGTABLES - just once per lazy_mmu section rather than on
  every pgtable write. See section "Performance" for details.

- Rebased on top of [8]. No direct impact on the patches, but it ensures that
  the ctor/dtor is always called for kernel pgtables. This is an
  important fix as kernel PTEs allocated after boot were not protected
  by kpkeys_hardened_pgtables in v3 - a new test was added to patch 17
  to ensure that pgtables created by vmalloc are protected too.

- Rebased on top of [9]. The batching of kpkeys level switches in patch
  18 relies on the last patch in [9].

- Moved kpkeys guard definitions out of <linux/kpkeys.h> and to a relevant
  header for each subsystem (e.g. <asm/pgtable.h> for the
  kpkeys_hardened_pgtables guard).

- Patch 1,5: marked kpkeys_{set_level,restore_pkey_reg} as
  __always_inline to ensure that no callable gadget is created.
  [Maxwell Bland's suggestion]

- Patch 5: added helper __kpkeys_set_pkey_reg_nosync().

- Patch 10: marked kernel_pgtables_set_pkey() and related helpers as
  __init. [Linus Walleij's suggestion]

- Patch 11: added helper kpkeys_hardened_pgtables_enabled(), renamed the
  static key to kpkeys_hardened_pgtables_key.

- Patch 17: followed the KUnit conventions more closely. [Kees Cook's
  suggestion]

- Patch 17: changed the address used in the write_linear_map_pte()
  test. It seems that the PTEs that map some functions are allocated in
  ZONE_DMA and read-only (unclear why exactly). This doesn't seem to
  occur for global variables.

- Various minor fixes/improvements.

- Rebased on v6.15-rc1. This includes [10], which renames a few POE
  symbols: s/POE_RXW/POE_RWX/ and
  s/por_set_pkey_perms/por_elx_set_pkey_perms/

RFC v3: https://lore.kernel.org/linux-hardening/20250203101839.1223008-1-kevin.brodsky@arm.com/

RFC v2..v3:

- Patch 1: kpkeys_set_level() may now return KPKEYS_PKEY_REG_INVAL to indicate
  that the pkey register wasn't written to, and as a result that
  kpkeys_restore_pkey_reg() should do nothing. This simplifies the conditional
  guard macro and also allows architectures to skip writes to the pkey
  register if the target value is the same as the current one.

- Patch 1: introduced additional KPKEYS_GUARD* macros to cover more use-cases
  and reduce duplication.

- Patch 6: reject pkey value above arch_max_pkey().

- Patch 13: added missing guard(kpkeys_hardened_pgtables) in
  __clear_young_dirty_pte().

- Rebased on v6.14-rc1.

RFC v2: https://lore.kernel.org/linux-hardening/20250108103250.3188419-1-kevin.brodsky@arm.com/

RFC v1..v2:

- A new approach is used to set the pkey of page table pages. Thanks to
  Qi Zheng's and my own series [11][12], pagetable_*_ctor is
  systematically called when a PTP is allocated at any level (PTE to
  PGD), and pagetable_*_dtor when it is freed, on all architectures.
  Patch 11 makes use of this to call kpkeys_{,un}protect_pgtable_memory
  from the common ctor/dtor helper. The arm64 patches from v1 (patch 12
  and 13) are dropped as they are no longer needed. Patch 10 is
  introduced to allow pagetable_*_ctor to fail at all levels, since
  kpkeys_protect_pgtable_memory may itself fail.
  [Original suggestion by Peter Zijlstra]

- Changed the prototype of kpkeys_{,un}protect_pgtable_memory in patch 9
  to take a struct folio * for more convenience, and implemented them
  out-of-line to avoid a circular dependency with <linux/mm.h>.

- Rebased on next-20250107, which includes [11] and [12].

- Added locking in patch 8. [Peter Zijlstra's suggestion]

RFC v1: https://lore.kernel.org/linux-hardening/20241206101110.1646108-1-kevin.brodsky@arm.com/

---
References

[1] https://lore.kernel.org/all/20210830235927.6443-1-rick.p.edgecombe@intel.com/
[2] https://lsseu2025.sched.com/event/25GEE/kernel-hardening-with-protection-keys-kevin-brodsky-arm
[3] https://lore.kernel.org/linux-hardening/7dc9485d-a822-494d-9384-4a973c782c11@arm.com/
[4] https://lore.kernel.org/all/20250917190323.3828347-1-yang@os.amperecomputing.com/
[5] https://lore.kernel.org/all/20251215150323.2218608-1-kevin.brodsky@arm.com/
[6] https://lore.kernel.org/linux-mm/20250815090000.2182450-1-kevin.brodsky@arm.com/
[7] https://lore.kernel.org/all/aY3+Raf8eZqipCd6@e129823.arm.com/
[8] https://lore.kernel.org/linux-mm/20250408095222.860601-1-kevin.brodsky@arm.com/
[9] https://lore.kernel.org/linux-mm/20250304150444.3788920-1-ryan.roberts@arm.com/
[10] https://lore.kernel.org/linux-arm-kernel/20250219164029.2309119-1-kevin.brodsky@arm.com/
[11] https://lore.kernel.org/linux-mm/cover.1736317725.git.zhengqi.arch@bytedance.com/
[12] https://lore.kernel.org/linux-mm/20250103184415.2744423-1-kevin.brodsky@arm.com/
[13] https://sashiko.dev/#/patchset/20260505-kpkeys-v7-0-20c0bdd97197%40arm.com
[14] https://lore.kernel.org/all/20260521-poe_futex-v1-0-1da286b8f9b2@arm.com/

---
To: linux-hardening@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Linus Walleij <linusw@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Maxwell Bland <mbland@motorola.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pierre Langlois <pierre.langlois@arm.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: x86@kernel.org

---
Kevin Brodsky (23):
      mm: Introduce kpkeys
      set_memory: Introduce set_memory_pkey() stub
      arm64: mm: Enable overlays for all EL1 indirect permissions
      arm64: Introduce por_elx_set_pkey_perms() helper
      arm64: Implement asm/kpkeys.h using POE
      arm64: set_memory: Implement set_memory_pkey()
      arm64: Context-switch POR_EL1
      arm64: Enable kpkeys
      memblock: Move INIT_MEMBLOCK_* macros to header
      mm: kpkeys: Introduce kpkeys_hardened_pgtables feature
      mm: kpkeys: Protect regular page tables
      mm: kpkeys: Introduce early page table allocator
      mm: kpkeys: Protect vmemmap page tables
      mm: kpkeys: Introduce hook for protecting static page tables
      arm64: kpkeys: Implement arch_supports_kpkeys_early()
      arm64: kpkeys: Support KPKEYS_CTX_PGTABLES
      arm64: kpkeys: Ensure the linear map can be modified
      arm64: kpkeys: Protect early page tables
      arm64: kpkeys: Protect init_pg_dir
      arm64: kpkeys: Guard page table writes
      arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches
      arm64: kpkeys: Enable kpkeys_hardened_pgtables support
      mm: Add basic tests for kpkeys_hardened_pgtables

Yeoreum Yun (1):
      arm64: Initialize POR_EL1 register on cpu_resume()

 arch/arm64/Kconfig                        |   2 +
 arch/arm64/include/asm/cpufeature.h       |  12 ++
 arch/arm64/include/asm/kpkeys.h           |  76 ++++++++++++
 arch/arm64/include/asm/pgtable-prot.h     |   8 +-
 arch/arm64/include/asm/pgtable.h          |  66 +++++++++-
 arch/arm64/include/asm/por.h              |  11 ++
 arch/arm64/include/asm/processor.h        |   2 +
 arch/arm64/include/asm/set_memory.h       |   4 +
 arch/arm64/kernel/cpufeature.c            |   5 +-
 arch/arm64/kernel/process.c               |  10 ++
 arch/arm64/kernel/sleep.S                 |  12 ++
 arch/arm64/mm/fault.c                     |  17 +--
 arch/arm64/mm/init.c                      |   1 +
 arch/arm64/mm/mmu.c                       |  50 +++++---
 arch/arm64/mm/pageattr.c                  |  29 ++++-
 include/asm-generic/kpkeys.h              |  21 ++++
 include/linux/kpkeys.h                    | 181 +++++++++++++++++++++++++++
 include/linux/memblock.h                  |  11 ++
 include/linux/mm.h                        |  14 ++-
 include/linux/set_memory.h                |   7 ++
 mm/Kconfig                                |   5 +
 mm/Makefile                               |   2 +
 mm/kpkeys_hardened_pgtables.c             | 179 ++++++++++++++++++++++++++
 mm/memblock.c                             |  11 --
 mm/sparse-vmemmap.c                       |  33 +++--
 mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
 security/Kconfig.hardening                |  24 ++++
 27 files changed, 937 insertions(+), 56 deletions(-)
---
base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
change-id: 20260428-kpkeys-e165645122c1


