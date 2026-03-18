Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41C17103E198
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7701A6B027C; Wed, 18 Mar 2026 11:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720F86B027E; Wed, 18 Mar 2026 11:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FBC6B027F; Wed, 18 Mar 2026 11:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48E426B027C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:50:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6DD71607D6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:42 +0000 (UTC)
X-FDA: 84559621524.11.445EECF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 68077160006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:50:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAFfqGYQ;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fgOUl/nTYsFlZlCglicvnRIJOYHEIfXsIVweRMwl46c=;
	b=45prnvJ6n3SPQHZCKzXevT7sYkWU7n9xN7/zGGhH46nvnVbk7Vh+sRHQVZjhrAEFT2QYB6
	GxOC2Gvlt4OP3NIpMw8gtZ991cxajc3cjVq4GUKl7b/Q0YKuapHwewhov3v6oK618+XkJ8
	VuP0iBpkVtJ4VU/SajfmrcNTpGnYxX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849041; a=rsa-sha256;
	cv=none;
	b=rAzBF/FnytNKjvo+7a3XEXXoSt+j4J3D7/uHxmkfvEETsQVv+81jcilDpjfVqDYg9Y2lGC
	MTxAc/4gI9dsHB/zOIGLUW6WA7dGfTcT5vSC5QqJFhN2rwVP5NFGE/5pRKJFwL5QLNAo6E
	2CHvkN6GEb1VP7orw0w6n7npugpGcXQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AAFfqGYQ;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4660942A25;
	Wed, 18 Mar 2026 15:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EED9C2BC87;
	Wed, 18 Mar 2026 15:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849040;
	bh=VbL3vAwO1cMuvFosJZiW6nFGpT2xBVdrJqX0D4K97+Y=;
	h=From:To:Cc:Subject:Date:From;
	b=AAFfqGYQjrNAaikG4d58f7LT11O0f7S5Nbf54jlY2cMK5jf5dEZJLAD13NoXMPC1F
	 vI9adgRokefNTjvg/a7A2EQRndqW1kl15xOJC8eIWSTPTzjKJkYxd7M+KOzeI9qelX
	 qCxQAgiRAKDyyyPqy2LwyNTX1MN/vbMCQQSSNfaQm4Amsz0CXjbCVbQVLMHpQkP/iU
	 xI4mrH9MWarFuuw4lqv/5of3VXlBMa5aK/Jpk6IVOUGlZzqx9UNdMcbL/kr2ZFn/+H
	 LezLJjFgzaMnWnuWNJFP/UqGvxok4yXnBI3n9D1eh1DkFckpRgieaDTJmwyznkcevS
	 R9Vmwjo1EyS/A==
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
Subject: [PATCH v3 00/23] mm/vma: convert vm_flags_t to vma_flags_t in vma code
Date: Wed, 18 Mar 2026 15:50:11 +0000
Message-ID: <cover.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kfnn48oihcpt4atmckztt6fd8buqkc71
X-Rspam-User: 
X-Rspamd-Queue-Id: 68077160006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773849041-404741
X-HE-Meta: U2FsdGVkX18zWH2lgf8ZRrccyPRFqp9wjP4ePcCyqTu9uc/4MYF3eut+Rt0dEjPKFsRsHnfE+v4OfFAVbwaH1TpepfXya7iiMrhtoSErN895mu4lXLUxhggSqiWXoikAfrc2xahtGXYicI/wV9GASqvwsC6xN6OeKX1a/8x9W78cBVtgBJmRkq8RU76TyOEw1v4FJNtx/R3k5gZtKxLZ0Qd0hDbrN8ZpyAzt2qEKLalvf0Fzdpg9innVVUcAOBvWdlPF+Af+aIIrD4TLqKEc36XJb4Ml3hyhghS4dYex0wj+Z637PHtvaYc7CNIJlxZ/OrpIdBN6Ndren5Fn4B0ohOuyc7ESw7E3uKYJ4PFg0IEfGW7QCuGR3+/h6wPLNtRJ9K4GCaFQxSOw7H1tiIXkPysTO6zRcg5R1cB6n9g0qdTbp6WL7eMYE43B9IG6qT7PXTUUpVwq0B7G3n+xwGzMO98KwKHeO0iXagZR2GvVtynF0bR/62OdR2oWy9wECF+W/+xyVDmAL6jRVSzbBnmSWB9+fiX0N+JhfCJhnHmPOHl7iiQWwjNirhVaWvK2OEgGKQUClYHWICzlaqhyRK2GCWub6kcUFRdg1caPhn0I1SaMw00+xu2isgFIgvz4gIZI+eGyaA3jmKbPf3YPzYyzma0M8ZfyHXyJ9sWL0eQDDkGrvuc2+fbKK2GWEyX7kXQhRrHvpssrdlqMWEx60jElaJh3cS64QCAPrT1GqtohQF4jfmYVOCkSfzbpK2TaSf7UKMg3st5z0R0B2+sq/bCkDlYTYCWJku/qVdbjMLE/tHZynOhNBk0iet3OjTKNEmOC5tiLQgWf6BeM/lmjNtVe0/XG/ZM0s5brfOZUm78YVDUdSLFBprBXx5TM/zwyZ4DJdHIGRzpdNeRTAHBQV9Cuvq30UdIOwKmw8Rg10kxkl5YIHDW95ID2LkLuOajnrFQwl5ZXrPYTdqEdDZTSE4K
 ThkjFd6W
 pdjAtoQv4mLZC+oqEsf1kHad9S6kDl1fKWnhgtIlq+iiQuoPfdpL6FV8U/0Mlgn3X0OgBlbsg8K4mzgg=
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


Lorenzo Stoakes (Oracle) (23):
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
  mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
  mm/vma: convert __mmap_region() to use vma_flags_t

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
 include/linux/mm.h                 | 328 ++++++++++++++++++++------
 include/linux/mm_types.h           |  52 ++++-
 include/linux/mman.h               |  49 ----
 include/linux/userfaultfd_k.h      |   3 +
 mm/internal.h                      |   7 +-
 mm/ksm.c                           |  43 ++--
 mm/madvise.c                       |  10 +-
 mm/mlock.c                         |  38 +--
 mm/mmap.c                          |  19 +-
 mm/mprotect.c                      |  53 +++--
 mm/mremap.c                        |   6 +-
 mm/mseal.c                         |  11 +-
 mm/userfaultfd.c                   |  21 +-
 mm/vma.c                           | 211 ++++++++++-------
 mm/vma.h                           |  86 ++++++-
 mm/vma_exec.c                      |   5 +-
 security/selinux/hooks.c           |   4 +-
 tools/include/linux/bitmap.h       |  13 ++
 tools/lib/bitmap.c                 |  10 +
 tools/testing/vma/include/custom.h |  25 --
 tools/testing/vma/include/dup.h    | 287 +++++++++++++++++------
 tools/testing/vma/include/stubs.h  |  11 +-
 tools/testing/vma/shared.c         |   8 +-
 tools/testing/vma/shared.h         |  22 +-
 tools/testing/vma/tests/merge.c    | 311 +++++++++++++------------
 tools/testing/vma/tests/mmap.c     |  18 +-
 tools/testing/vma/tests/vma.c      | 359 +++++++++++++++++++++++++----
 tools/testing/vma/vma_internal.h   |   6 +
 44 files changed, 1435 insertions(+), 641 deletions(-)

--
2.53.0

