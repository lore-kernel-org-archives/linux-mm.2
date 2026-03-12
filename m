Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6328106ACD6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043EF6B0005; Thu, 12 Mar 2026 15:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BDA6B0088; Thu, 12 Mar 2026 15:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E62936B0089; Thu, 12 Mar 2026 15:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D89806B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80BAD1B7C5F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:36 +0000 (UTC)
X-FDA: 84538367592.29.E9C4D5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 038B31C0012
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJ/OeZwo";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773342995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/6k8x8igNBDi50i6h//dTyDCjeqphH2lzCigPKeeMeQ=;
	b=6OVZyI6fjl9C0yFyhp98AhCOkzwrBm8Klewiqf+BQb+r09I/a0/3BWyyISi2xAGXcTBmgI
	grR6Hf0/uRnIT69SCR+sDobfyXr/KIk7i/G+REQbGbwCGgiG5KxWf6xdrQQTziuf/yC0Ng
	yXQHAFCVSlbCCuDkrF33pMJnF8BAJSg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773342995; a=rsa-sha256;
	cv=none;
	b=PCCp2Sk9oPf2qPKbSp8brmV4n/rMP/bS12X6vJ1to5gx9rwcyjbjd7D9SlSJmQEuWRhf8X
	8cUBW7Fb+f23tgQ7gfTRW2KgQCi2zu3OEmzBtPnDKAKieaCofX5XgnFpHspQNQVjnd94ix
	YqWVF8A63HWQihLfmY4kSuH0KBm3W2I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJ/OeZwo";
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32C5160142;
	Thu, 12 Mar 2026 19:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB2FC4CEF7;
	Thu, 12 Mar 2026 19:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773342993;
	bh=TaSLkR5gPDfxujDC1zIc+PKZQMwo2SHfFpgA8heiCwA=;
	h=From:To:Cc:Subject:Date:From;
	b=RJ/OeZwo0EpMiWhb6/z0zIn+/lFIuIvP2BfzNEAj9LTqZfBCjv1o5hnt4plZA721a
	 ih6WVKNO5Z+PgABzP3qU9mNk3ZQdayMRlhZrsa3HWiVByCdZSFrFYLe0/7lxG7OMSg
	 FBYifP/bgQwr574bwudgfgyoHnB9f/hWGwgWe1FDPrtLRQXW3cutgrXsqn1yBfQyAO
	 cLyQ9H8N5cQhIxAeyK3PB3UNucYEayj8QTANEhh8lPSNLnt33n+V+48VghS2R7jej6
	 vxj7XgXAC6C2E/LkQ0c1rBr5o/kq+vJUK3tiAL3mfMap9fAXAJ1J2eEDtK0eEUhevE
	 WNctijuQVz9Nw==
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
Subject: [PATCH 00/20] mm/vma: convert vm_flags_t to vma_flags_t in vma code
Date: Thu, 12 Mar 2026 19:15:58 +0000
Message-ID: <cover.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y9if5zypfefwnair37sx8w461ywhyfnn
X-Rspam-User: 
X-Rspamd-Queue-Id: 038B31C0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773342994-416671
X-HE-Meta: U2FsdGVkX187emtrItQZDBaTCDPcwOaqcyzbxVlvNJ2N6JWgE4fBKXm61XnXZabw+cqZkJOpd2vfWPpBJcYuaxaxhYn051YwNZGI7caNLkBmFjvJKczoTkMS5RF5nPKSs014Qj3OKQZ7PhegQejC5dDHmkFWxo2KG/YmC/f5o5iUa4AX0F1XBRLz1+dNrZZgb31tNt4fGi5ybELHET1R9oxvmZX4qfMqPeFaqNKUysy/a8/aLFMu8jxSSJEvF/lQcNn5RzrSnYmNki4WYSEgCMoXbKlO0Qeq8GRxRzBayEmwD+39FWYMqoG6eJ893iLb8NRBmabfy3UCDEFyKIeZKl1wVSHSp6wRFm888SSdOI4vCYj89Sq1B/mkEejGYcXB9xlwH0sLeQQw5TgJjJu9U8oBT3ityVD/ZkxY/MsDZYrjYRBDfSgyIzYmKoeusMphrpzNjLtVL6e58hnc3KKEAx6twtXigRTT/x6PNlSnDhclGSa6+cyuYW1d0IKKC/MMu4tFOwIXQ9raPCZVCp4jpAGqJg2uG9JI6DaHf3NcrKFOqYhbf8kFxgR3fPSMFHLNb0hONkx5UXu9xi6EP10tpU87lWqb51KVzbQ+viKOD/S7CrkOnimghXwtRO7ZXhWh66jDC7x5xD+mgd3NY+50uXwdATtiL/m/8z0F9H0hmjyWSWj2ock3WisbGPIW/5YAvQEBaqTbJfbT6lqGELcwMG4QzeJa71rpv6GzwVzKpf0n54h7i0Igg0pRj9+A4gXGXBJYYG6HyyuQLyK77OOnwKt1w0d5W19T9At/DPHt4TXvM1AyJipisYfd27OhYW9puJVCgmn/2Yx257YvV2IpHZJIf17wmq+IDkkhBg+5elMJitlzMoL/MomStrz85kBJUviAHd1PDjYcyatpjtCUEwQZCsrbnWN8g1Ea+wpUiy+oef/SskZcRpLZBawng+hrl9+okHhjP/xd1Ir9FA6
 F/PPOQd8
 4Y0IV9TOqfo/9jNKuDEGzPzQWfEe+Mm1VL/agGYmT8JCsMiA4/EykvxQF2oOA6yfnfFJxPOB1vAqN4chK2r2Vp62A54xSeoF+Y58BhOnAtdDQe632rFGDIb+3e0uT0u2/wgW8cVy2aPtuhgdzmpRmo1cns4uE/dXDXqLNUrb4x+gF3qmYJyc7dHLtZ0Rs36hrfnj/PmpubpVK7KmeSbV+tiYXmcwDgO0J7IfJm/xqJHaB78QyDrED/efEQWY7mZNKjNdEK8bTnP3wvS17xLmaUWxcXISJ4BVIaTIYqOEJZ2ubN7HBAa3pb5tWO/4Pc2jF26+w
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

* vma_test() - Tests whether a VMA's flags contain s specific singular VMA
  flag.

* vma_test_any() - Tests whether a VMA's flags contain any of a set of VMA
  flags.

* vma_test_any_mask() - Tests whether a VMA's flags contain any of the
  flags specified in another, typically constant, vma_flags_t value.

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

Lorenzo Stoakes (Oracle) (20):
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
  mm: convert do_brk_flags() to use vma_flags_t
  mm/vma: introduce vma_test[_any[_mask]](), and make inlining
    consistent
  tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()
  mm/vma: introduce vma_clear_flags[_mask]()
  tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()
  mm/vma: convert as much as we can in mm/vma.c to vma_flags_t
  mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
  mm/vma: convert __mmap_region() to use vma_flags_t

 arch/arc/include/asm/page.h        |   2 +-
 arch/arm/include/asm/page.h        |   2 +-
 arch/arm64/include/asm/page.h      |   3 +-
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
 include/linux/mm.h                 | 282 ++++++++++++++++++++------
 include/linux/mm_types.h           |  52 ++++-
 include/linux/mman.h               |  49 -----
 include/linux/userfaultfd_k.h      |   3 +
 mm/internal.h                      |   3 +
 mm/ksm.c                           |  43 ++--
 mm/madvise.c                       |  10 +-
 mm/mlock.c                         |  42 ++--
 mm/mmap.c                          |  19 +-
 mm/mprotect.c                      |  53 +++--
 mm/mremap.c                        |   6 +-
 mm/mseal.c                         |  10 +-
 mm/userfaultfd.c                   |  21 +-
 mm/vma.c                           | 216 ++++++++++++--------
 mm/vma.h                           |  86 ++++++--
 mm/vma_exec.c                      |   5 +-
 security/selinux/hooks.c           |   4 +-
 tools/include/linux/bitmap.h       |  13 ++
 tools/lib/bitmap.c                 |  10 +
 tools/testing/vma/include/custom.h |  19 --
 tools/testing/vma/include/dup.h    | 262 +++++++++++++++++-------
 tools/testing/vma/include/stubs.h  |  11 +-
 tools/testing/vma/shared.c         |   8 +-
 tools/testing/vma/shared.h         |  22 +-
 tools/testing/vma/tests/merge.c    | 311 +++++++++++++++--------------
 tools/testing/vma/tests/mmap.c     |  18 +-
 tools/testing/vma/tests/vma.c      | 303 +++++++++++++++++++++++++---
 43 files changed, 1307 insertions(+), 630 deletions(-)

--
2.53.0

