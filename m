Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6011099B35
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1C16B013E; Fri, 20 Mar 2026 15:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9996C6B013F; Fri, 20 Mar 2026 15:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AF6D6B0140; Fri, 20 Mar 2026 15:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1246B013E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:38:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3601A1B720D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:49 +0000 (UTC)
X-FDA: 84567453978.11.D89E7BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B38F640008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:38:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKRO8hqR;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+3f5XI4eIbFsBK7jrK7QzMMd2Df7DuUJFLcTnZ8VtU8=;
	b=Jx1SPtaodpA9luefGzjt9cj/XGvnDdspuGiqyxOkda+0m0rR/mRYCwqIo1aCewcfNDTZd7
	jp7x14pRQggHUnFLfdn7pzzkP8gY6+Zl+nKDFUuOqeI3Ib7ACzxkazPUh4ZwuXQPHr+B27
	YmT6fkU0Y6sLw+L7gDT8tex5cAoetxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035527; a=rsa-sha256;
	cv=none;
	b=DouTEXxxOJ/JgVrfGPI2hFmzU4rRCwqdyqoWuuUJEYwyGlO6CB7jNBONDijBZM37GaBoaE
	mgtuHhRBKDmEvruEO90gXJK7dO5C+xxtMEygOreB3ixgMxi3urr9xr00cO45re5TZZnp12
	y5Z82zf0k7ebRUXIOpkylcjm1SnreRU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IKRO8hqR;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACDA360126;
	Fri, 20 Mar 2026 19:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10B5C4CEF7;
	Fri, 20 Mar 2026 19:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035526;
	bh=B5vWr9J4Eb+/vYtuFSntRP4/6BZCLXVQxRrN5ULo4B4=;
	h=From:To:Cc:Subject:Date:From;
	b=IKRO8hqRGgDmarX8cUyOaR2T+zTsf7Cybp33CEGm3VVjXoMge30Vth6pty2I0Gay6
	 h76wgYpecItl5t5LO8kQq/p1iswuoV/dg1q8ljRu+b2kb5HwxzDDiz2JqRRxk0uy2v
	 N2BEjQgcRvnW17+gIZz3euO48IiZO4Cm2umjVfzJLKQiRNxXmf47GCbJZKhjMd18kB
	 l4Ry8wj3OWjkngov6CwHR0wAckwXbLMO98fGfB+jkWTz+YyHhIKq67LTVRwldPdO5Y
	 /Xw/1yzFpF3lsJicAjPv+JOZt8JFT3BKiEXglHu5++uyKc/fr9S/nBYRa1QsLb4QRg
	 1eGNEXv2EHsfg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 00/25] mm/vma: convert vm_flags_t to vma_flags_t in vma code
Date: Fri, 20 Mar 2026 19:38:17 +0000
Message-ID: <cover.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B38F640008
X-Stat-Signature: dkajd7ue7yi3zfj4d14nymjmh8wpkhxt
X-Rspam-User: 
X-HE-Tag: 1774035527-148869
X-HE-Meta: U2FsdGVkX1/92eBH9NfaNvSzBPKFWyy3BCnTPR/WJH8Ew9/UovDrsgDRRC4JW7ORwrEY7VJFS72rpnUPIIjXw0yNQSkzWk1j3YjxQrpcZsJnte5K23JASgozN5HzhZ0PriXm2clwGNRoThztPKSb4RsrkREsL5uelfCFJ4Sc2e2j1U7kuqL+0iVnICQ1uVb/NRMj7ex3Oupt7XaFGGZjx6rNzb7CGkIvp5ouXoV72gV1SYRHa0hJ1vm2euYFIeuFkjeZeaTUIEeKJdcl1Fg/AmkI5NONF4wNyfOHMgxA1cXJMD8ZmpFZRJV4AvmTMJlkF8m0QtUf2Jljq1SPkX0wmg4TZz/OLSTOkEnoI2nhQEn5+z3TOtuzi/t/uc1j+lYYCNF2w4DptM6aQ7HKmwxj7Y0eQOQaY68C2niPC9hr7cTSkqDS8TOSklv6wcFum0QNoM0BLFwaD60wQ2/LufKePxYexA4Z/iXm6E4q65TwdKG/Oq+568oXMaQVOmLeofAGfL7dq2D4ReLAVvi9iIjZFH0IbCbRMnbnFE9sGZ6Mx/ap953W4g/EO1MOWw/u0T84QEuUSKmxk5eGckVkchxZzUwHq2LrgMOc803cwbkbOzJoVOx1pFO5vnQGvLhc7GzRCixM8YaNhX0vprW5h44tdHaHDrdLyemF4uF1LibCgugejI1LXWjKo/ojVBkaJ/V50oDUxekBEFbDEs5++QbGxg5eTJThddjc4Ls5BsXPGlAEdXIk9NucmyYR86edF5OoBQk4SNbmsNdLFniquSDZFJ7aO16vdRXXjnOI4XEuQkeO2OvziIRVAOK0ObJC3PW3FDtpRjghFXeZDcNh2IIUWTkBFeRwhV50T3Q0dnet14RtynQx1bQJ07yZMfMcoXrQsgEslvCzDDp6Qj5KVj6M7X0X/3ysij2HkCVSVx+1C5svtzV/gp+IpgKB6Uqw3fWO0MmxCCyRuoYiK+NFEvi
 RKtLuYIU
 Jvi3klRY1OtnF1QY9e6bZD7Zg5/VrjHZlTgGbbC5gsGN818/sF6Yxtsug2xuelkGgPEFLsOI3K+XcAbVgOp9gHozYMn0BKhQSm44nFAk08fXiko+WPrW/iupPfmVeMxcNbNJodOn56k99L2f3kL5XtehdcFCOLjSHU4ktDOnXGtnheTQdHuGz84sMvM1LudMeXMH21/KF7NnImgGdk0WS4qjJ1+65/uMM6CgLSgBdLI1aCGv2H5mdmHIwrSn3i4S2EGFoL+LvGE3JOQ3JQq3Hty8exxp9Zq982YNobfVzzk1/l49kr/bG0rFJYLQaAIjC9sYN02UpPjoyvX3TUyvV2XGhBhcJwTNNd31ZBaCD5A75ksedHdNntImgQ9H9o6Yi6c1PwnK0S2ZtNeTr4Q3KCMTUNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series converts a lot of the existing use of the legacy vm_flags_t
data type to the new vma_flags_t type which replaces it.

In order to do so it adds a number of additional helpers:

* vma_flags_empty() - Determines whether a vma_flags_t value has no bits
  set.

* vma_flags_and() - Performs a bitwise AND between two vma_flags_t values.

* vma_flags_diff_pair() - Determines which flags are not shared between a
  pair of VMA flags (typically non-constant values)

* append_vma_flags() - Similar to mk_vma_flags(), but allows a vma_flags_t
  value to be specified (typically a constant value) which will be copied
  and appended to to create a new vma_flags_t value, with additional flags
  specified to append to it.

* vma_flags_same() - Determines if a vma_flags_t value is exactly equal to
  a set of VMA flags.

* vma_flags_same_mask() - Determines if a vma_flags_t value is eactly equal
  to another vma_flags_t value (typically constant).

* vma_flags_same_pair() - Determines if a pair of vma_flags_t values are
  exactly equal to one another (typically both non-constant).

* vma_flags_to_legacy() - Converts a vma_flags_t value to a vm_flags_t
  value, used to enable more iterative introduction of the use of
  vma_flags_t.

* legacy_to_vma_flags() - Converts a vm_flags_t value to a vma_flags-t
  value, for the same purpose.

* vma_flags_test_single_mask() - Tests whether a vma_flags_t value contain
  the single flag specified in an input vma_flags_t flag mask, or if that
  flag mask is empty, is defined to return false. Useful for
  config-predicated VMA flag mask defines.

* vma_test() - Tests whether a VMA's flags contain a specific singular VMA
  flag.

* vma_test_any() - Tests whether a VMA's flags contain any of a set of VMA
  flags.

* vma_test_any_mask() - Tests whether a VMA's flags contain any of the
  flags specified in another, typically constant, vma_flags_t value.

* vma_test_single_mask() - Tests whether a VMA's flags contain the single
  flag specified in an input vma_flags_t flag mask, or if that flag mask is
  empty, is defined to return false. Useful for config-predicated VMA flag
  mask defines.

* vma_clear_flags() - Clears a specific set of VMA flags from a vma_flags_t
  value.

* vma_clear_flags_mask() - Clears those flag set in a vma_flags_t value
  (typically constant) from a (typically not constant) vma_flags_t value.

The series mostly focuses on the the VMA specific code, especially that
contained in mm/vma.c and mm/vma.h.

It updates both brk() and mmap() logic to utils vma_flags_t values as much
as is practiaclly possible at this point, changing surrounding logic to be
able to do so.

It also updates the vma_modify_xxx() functions where they interact with VMA
flags directly to use vm_flags_t values where possible.

There is extensive testing added in the VMA userland tests to assert that
all of these new VMA flag functions work correctly.


v4:
* Propagated tags, thanks Vlasta!
* Removed superfluous parens around vma_test_any_mask() as per Vlasta.
* Converted masked functions into more understandable equivalent form as
  per Vlasta in 24/25.
* Redefined VM_SPECIAL using vma_flags_to_legacy() as per Vlasta.
* Fixed whitespace as per Vlasta.
* Added vma_flags_reset_once() as per Vlasta.
* Expanded 22/23 commit message to describe why I'm replacing things as
  per Vlasta.
* Added bitmap_copy() to test headers in order to implement
  vma_flags_reset_once().

v3:
* Folded in tags, thanks Paul, Vlastimil!
* Respun to apply the correct suggestions/reports from
  https://sashiko.dev/#/patchset/cover.1773665966.git.ljs%40kernel.org
  (note there is also quite a lot of noise, that is ignored).
* Const-ified vma_flags_t * param for vma_flags_empty() as per Sashiko.
* Obtained sticky flag masks after VMA write lock acquired on merge and
  update vma_expand() similarly. This is meaningful, as the maybe guard
  flag is set atomically which might race outside of a VMA write lock, as
  per Sashiko.
* Dropped comment about 'VM_NONE convenience' from 5/23 commit message as
  the VMA_xxx form flags can now provide that.
* Updated legacy_to_vma_flags() to ensure upper bits are cleared for
  NUM_VMA_FLAG_BITS > 64 as per Sashiko.
* Updated legacy_to_vma_flags() to use vma_flags_overwrite_word() for
  consistency.
* Refreshed vma_flags_overwrite_word(), vma_flag_overwrite_word_once(),
  vma_flags_set_word() and vma_flags_clear_word() in the VMA test dup.h
  header to keep them consistent with the kernel.
* Updated VMA_DATA_DEFAULT_FLAGS declaration on arm64 to be predicated on
  CONFIG_ARM64_MTE as to whether VMA_MTE_ALLOWED_BIT is set, as per
  Sashiko.
* Fixed bug where the VMA did not have VMA_SOFTDIRTY_BIT set if
  pgtable_supports_soft_dirty(), but rather the stack variable vma_flags,
  as per Sashiko.
* Corrected vmag -> vma typo in VMA test code as per Sashiko.
* Fixed typo in 20/23 commit message 'correctly' -> 'correct' as per
  Sashiko.
* Fixed VMA flag clear tests to consistently do vma_clear_flags_mask(&vma,
  mask) rather than vma_flags_clear_mask(&vma.flags, mask) as per Sashiko.
* Added missing vma_start_write() in mseal_apply() as per Sahiko.
https://lore.kernel.org/all/cover.1773846935.git.ljs@kernel.org/

v2:
* Rebased on mm-unstable.
* Added vma_flags_count() and vma[_flags]_test_single_mask() for testing
  whether flags have a single flag set depending on an input flag mask,
  returning false if the flag mask is empty.
* Added tests for vma_flags_count() and vma[_flags]_test_single_mask().
* Updated the KSM VMA_DROPPABLE test to use vma_flags_test_single_mask().
* Updated the newly-introduced-since-rebase vma_supports_mlock() to use
  vma_flags_t.
https://lore.kernel.org/linux-mm/cover.1773665966.git.ljs@kernel.org/

v1:
https://lore.kernel.org/linux-mm/cover.1773342102.git.ljs@kernel.org/

Lorenzo Stoakes (Oracle) (25):
  mm/vma: add vma_flags_empty(), vma_flags_and(), vma_flags_diff_pair()
  tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]
  mm/vma: add further vma_flags_t unions
  tools/testing/vma: convert bulk of test code to vma_flags_t
  mm/vma: use new VMA flags for sticky flags logic
  tools/testing/vma: fix VMA flag tests
  mm/vma: add append_vma_flags() helper
  tools/testing/vma: add simple test for append_vma_flags()
  mm: unexport vm_brk_flags() and eliminate vm_flags parameter
  mm/vma: introduce vma_flags_same[_mask/_pair]()
  mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
  tools/testing/vma: test that legacy flag helpers work correctly
  mm/vma: introduce vma_test[_any[_mask]](), and make inlining
    consistent
  tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
  mm: introduce vma_flags_count() and vma[_flags]_test_single_mask()
  tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask
  mm: convert do_brk_flags() to use vma_flags_t
  mm: update vma_supports_mlock() to use new VMA flags
  mm/vma: introduce vma_clear_flags[_mask]()
  tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
  mm/vma: convert as much as we can in mm/vma.c to vma_flags_t
  tools: bitmap: add missing bitmap_copy() implementation
  mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
  mm/vma: convert __mmap_region() to use vma_flags_t
  mm: simplify VMA flag tests of excluded flags

 arch/arc/include/asm/page.h        |   2 +-
 arch/arm/include/asm/page.h        |   2 +-
 arch/arm64/include/asm/page.h      |   7 +-
 arch/hexagon/include/asm/page.h    |   2 +-
 arch/loongarch/include/asm/page.h  |   2 +-
 arch/mips/include/asm/page.h       |   2 +-
 arch/nios2/include/asm/page.h      |   2 +-
 arch/powerpc/include/asm/page.h    |   4 +-
 arch/powerpc/include/asm/page_32.h |   2 +-
 arch/powerpc/include/asm/page_64.h |  12 +-
 arch/riscv/include/asm/page.h      |   2 +-
 arch/s390/include/asm/page.h       |   2 +-
 arch/x86/include/asm/page_types.h  |   2 +-
 arch/x86/um/asm/vm-flags.h         |   4 +-
 fs/binfmt_elf.c                    |   3 +-
 include/linux/ksm.h                |  10 +-
 include/linux/mm.h                 | 352 +++++++++++++++++++++-------
 include/linux/mm_types.h           |  52 ++++-
 include/linux/mman.h               |  49 ----
 include/linux/userfaultfd_k.h      |   3 +
 mm/internal.h                      |   7 +-
 mm/ksm.c                           |  43 ++--
 mm/madvise.c                       |  10 +-
 mm/mlock.c                         |  38 +--
 mm/mmap.c                          |  19 +-
 mm/mprotect.c                      |  49 ++--
 mm/mremap.c                        |   6 +-
 mm/mseal.c                         |  11 +-
 mm/userfaultfd.c                   |  21 +-
 mm/vma.c                           | 210 ++++++++++-------
 mm/vma.h                           |  84 ++++++-
 mm/vma_exec.c                      |   5 +-
 security/selinux/hooks.c           |   4 +-
 tools/include/linux/bitmap.h       |  24 ++
 tools/lib/bitmap.c                 |  10 +
 tools/testing/vma/include/custom.h |  25 --
 tools/testing/vma/include/dup.h    | 309 ++++++++++++++++++-------
 tools/testing/vma/include/stubs.h  |  11 +-
 tools/testing/vma/shared.c         |   8 +-
 tools/testing/vma/shared.h         |  22 +-
 tools/testing/vma/tests/merge.c    | 311 +++++++++++++------------
 tools/testing/vma/tests/mmap.c     |  18 +-
 tools/testing/vma/tests/vma.c      | 359 +++++++++++++++++++++++++----
 tools/testing/vma/vma_internal.h   |   6 +
 44 files changed, 1463 insertions(+), 663 deletions(-)

--
2.53.0

