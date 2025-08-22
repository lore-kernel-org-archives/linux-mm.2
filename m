Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2480BCA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 01:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E77A280003; Thu, 21 Aug 2025 21:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFCE8E0056; Thu, 21 Aug 2025 21:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D6D1280003; Thu, 21 Aug 2025 21:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 181D28E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:21:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7A3159C33
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:21:25 +0000 (UTC)
X-FDA: 83802640530.28.65C9693
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15EA4140009
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 01:21:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VmRuWpWJ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755825684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vnORHGlz03Wk6RfleqHIIxWcloS3qF5km1DubhdHtnw=;
	b=B68qgzVn9qtqeufYo2aq2WJfhDiu/t8rCDFbc+yYiMgLl86ZGb7UNeU9hgoZkma/J3aqik
	/YnnA3bO3jeuFls6NVAfLbstoD3BqZqVmlMVBqxZRpRtD4uPOu3m9CxEVFoajIZZqTc8z4
	iNpxhta9v3coZ7BoO6d20f0ruB/mV/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755825684; a=rsa-sha256;
	cv=none;
	b=8J83bCf+bUvSoHOsl198A1ZVjwS+wWcx9uDlVQ31NztSmU8Xr4NM89M+MW6mJQ2L5Y90yX
	gQkuy3ITEH1tcGWoIlPEeFlku7D1HPDLfVP6B2IebCFBYpsLuj0Kzxskk8B05pk0T4W89o
	g4I7s8GNkVBuQMu8Ne0jauntpVfFI/w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VmRuWpWJ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48C6B6020A;
	Fri, 22 Aug 2025 01:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7DCC4CEEB;
	Fri, 22 Aug 2025 01:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755825683;
	bh=tVhsYHxxFfX7gGzpp6/1LpcEhJi77iuO99nxuLjq6VE=;
	h=Date:From:To:Cc:Subject:From;
	b=VmRuWpWJNQvSp2Yp6FHRGVB4G0XYU6yBwuR9Ey439kdy0gKxIPav8VKcWWeG4FGoV
	 sEX1+CDT1U/YivRO40cVHX1BZEd3SOcRIejgpo3+zRTbetfu+lfNvQlGUBuzoAs04+
	 WICZ4EUJJ9tgfCVPCdSjzDxiWpAsmP621V3ogmzc=
Date: Thu, 21 Aug 2025 18:21:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.17-rc3
Message-Id: <20250821182122.eb19072cafdbc6612e76ac8f@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 15EA4140009
X-Stat-Signature: 839qmzrrg96re6y5j3weakikqgfzpfen
X-Rspam-User: 
X-HE-Tag: 1755825683-126817
X-HE-Meta: U2FsdGVkX1/4B7otq38CqZa9ek8tXDrHdCP1VxhbK+k7SeWT+9A/GJKwxWr7QW4I7kQB7FrAK53ThGgkBaVZq0kBzFuOno3ragAR9WDaXIyCa9F0HhxS+v6CfmkF7aO2TV6Y8ZD48/m+fRaHXTyb6gwtvOjAsuL3B1LLJQRfbJjEW3aRrzI2mOXXCq055ZiJTqR/6l4BQ6ZU18fV3ii5XVoPteO5ypxVlva9rlO1JB0O1k7R/MO9gy5N7IDENW5C7Ro5N+4bPWUsbtNoqbke/uHix6OzfBkIc2oKdRAdJZZQOrDNl+f2V8GiKrDavLgkl6ifWKaz0Er+p6GwLNEsRf16l2jKu+ezPMknyFxtn6s6Cm6PLdCFYcLWevH58annNJwT9bBsZPjQ/h13YqCaxoX5XafeIoLuC6xB3D6BJ9byR/R4g1rFz4ImdIT8IG+mBIA7RYU6xmwOyikZpclhgpXASrThPeD81Qb9GOPagjxXyBE180ZBwYWKLWtUcSHN7wYyFScACUroj11ZHFHSqWkcbZnMq9QrP2H+eFzKIyZfff4zeS7MiP87r5I5w4pWP0+zBz2+WEMQEWsBOdgGyKLMNEQQDuKAdYTsLe7H9X2dUa+aieXjHMDN0/qtmIgDcmQckd6gIqGHsJCNof3nt/YSxfDeErFYrkwepBz7tIdQcLhjy/SyH74wda5iWuztXGtDoZ/E0c6MFTF7MV9YHgqiYuNzHEa54uSQgI2PRhEaRRT09tWwZm2F0gwOVqKjjMgHrdNgk0BEmGEUbBImvvW+GBF6x0fXJF2+VcujkHy9ahQfbMxeOp8VUjbS2JLFPkIZWBbcvSIubAELiHgBUM2n4i5rbeXflZDRv+eMau7woy3q09myUPtYwWwUf77kNIJ7xJ6UNu48rr4d3yPFJVpfURs/rFHa/MzN7/J3rr2n4Bc1tItyxTCQMFvCkfm1oWYoCcpDfbvgeYEue/P
 saXC0tYB
 5gXits9Hf5lKcodm6pfBdJfih6I9nV5n/J6cIB1qanLm0y4N7wAbSlN+Z/lQnHewCpSz0yp7MEUhNb4N5Gb/shFmwp0QM6vyK/wJmwr6hnKFAJ0ITNjOgu4QArr73lboT3YsDit5a782BXWad3/5tpRQpo902Esz59ENM16/n3nZRmGgKxZrFyO8pqda6UcIOgXRqkkSeqXluKGcd3ul2Pc3UsRauWZEWPOE6bT4TgUPrIDTw2/06900eTZmJ/q6VCr2hF4Cqog5XmKY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this week's bunch of mainly-MM hotfixes, thanks.


The following changes since commit c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-08-21-18-17

for you to fetch changes up to 772e5b4a5e8360743645b9a466842d16092c4f94:

  mm/mremap: fix WARN with uffd that has remap events disabled (2025-08-19 16:35:57 -0700)

----------------------------------------------------------------
20 hotfixes.  10 are cc:stable and the remainder address post-6.16 issues
or aren't considered necessary for -stable kernels.  17 of these fixes are
for MM.

As usual, singletons all over the place, apart from a three-patch series
of KHO followup work from Pasha which is actually also a bunch of
singletons.

----------------------------------------------------------------
Alice Ryhl (1):
      mm: rust: add page.rs to MEMORY MANAGEMENT - RUST

Axel Rasmussen (1):
      MAINTAINERS: mark MGLRU as maintained

David Hildenbrand (1):
      mm/mremap: fix WARN with uffd that has remap events disabled

Dominique Martinet (1):
      iov_iter: iterate_folioq: fix handling of offset >= folio size

Easwar Hariharan (1):
      .mailmap: add entry for Easwar Hariharan

Herton R. Krzesinski (1):
      mm/debug_vm_pgtable: clear page table entries at destroy_args()

Huacai Chen (1):
      mm/migrate: fix NULL movable_ops if CONFIG_ZSMALLOC=m

Jinjiang Tu (1):
      mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn

Lorenzo Stoakes (4):
      tools/testing: add linux/args.h header and fix radix, VMA tests
      mm/mremap: allow multi-VMA move when filesystem uses thp_get_unmapped_area
      mm/mremap: catch invalid multi VMA moves earlier
      selftests/mm: add test for invalid multi VMA operations

Pasha Tatashin (3):
      kho: init new_physxa->phys_bits to fix lockdep
      kho: mm: don't allow deferred struct page with KHO
      kho: warn if KHO is disabled due to an error

Phillip Lougher (1):
      squashfs: fix memory leak in squashfs_fill_super

Sang-Heon Jeon (3):
      mm/damon/core: fix commit_ops_filters by using correct nth function
      selftests/damon: fix selftests by installing drgn related script
      mm/damon/core: fix damos_commit_filter not changing allow

SeongJae Park (1):
      mm/damon/sysfs-schemes: put damos dests dir after removing its files

 .mailmap                                 |   2 +
 MAINTAINERS                              |  19 +++
 fs/squashfs/super.c                      |  14 +-
 include/linux/iov_iter.h                 |  20 +--
 include/linux/migrate.h                  |   5 +
 kernel/Kconfig.kexec                     |   1 +
 kernel/kexec_handover.c                  |  29 +++-
 mm/balloon_compaction.c                  |   6 +
 mm/damon/core.c                          |  15 +-
 mm/damon/sysfs-schemes.c                 |   2 +-
 mm/debug_vm_pgtable.c                    |   9 +-
 mm/memory-failure.c                      |   8 +
 mm/migrate.c                             |  38 ++++-
 mm/mremap.c                              |  82 ++++++----
 mm/zsmalloc.c                            |  10 ++
 tools/include/linux/args.h               |  28 ++++
 tools/testing/selftests/damon/Makefile   |   1 +
 tools/testing/selftests/mm/mremap_test.c | 264 ++++++++++++++++++++++++++++++-
 tools/testing/shared/linux/idr.h         |   4 +
 19 files changed, 487 insertions(+), 70 deletions(-)
 create mode 100644 tools/include/linux/args.h


