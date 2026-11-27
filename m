Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01B8606A326
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYhGSRjx
Received: by kanga.kvack.org (Postfix)
	id CB9EE6B05B1; Fri, 27 Nov 2026 03:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6AE16B05B5; Fri, 27 Nov 2026 03:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81396B05C5; Fri, 27 Nov 2026 03:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98B156B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:59:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2109516026F
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:59:37 +0000 (UTC)
X-FDA: 85480300794.26.3A1F933
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 786DF4000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:59:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYhGSRjx;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795769975;
	b=hujtUHnskgtn5CZZon4ZIAmbKwNSN1FxWh7cIwSFwr9a2WQcCrnmpFiSqprJ5nAQDjrfaZ
	jQ3HU7UWG5wMZIvow9c4W9r0nd9+XVsHPWP26I5SPm4lvod7FNvPqV4frfjWRWj/Of3nz/
	/S8fuwuYFctFNe8xU0A5/QSxq+sLKXI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795769975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7a5V8uJNEtSJUfbxlsSU81OveDHYXfQs+t4Z/0WLw0Q=;
	b=l28ZYE4N1EQhaozB0tfHi2U+T58iRyilrC/SLZR7a9i8zKRifFRSQ5L8M6RlFJ4mFL5gdJ
	d/JXigrf/ODenqlq1BSRa7gXif9rbXQNSApYVLjbGx770eEapU1S6J7ebklM07QDSEyWpO
	rnn/t9eK9UEJ09Mt0yNePBiDuT8JwRs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYhGSRjx;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA83744660;
	Fri, 27 Nov 2026 08:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61E11F00897;
	Fri, 27 Nov 2026 08:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795769974;
	bh=7a5V8uJNEtSJUfbxlsSU81OveDHYXfQs+t4Z/0WLw0Q=;
	h=From:To:Cc:Subject:Date;
	b=AYhGSRjxzoKEEqtT32tZm1a+8a42yP26NUpFjur0TnXe167qHDP6zH3IskrtTZ9cI
	 +HUM1GLIboc42+X2HH8g1rhP0KKkQQrX4Ezs0C9uHd+XZu/n1Pndhut2v/irjlyDtb
	 fJpYDeUeiwIMqmhRlQu/8ICbKZX2IOgeg8UJxcLL103MCpOZEE52Ua3ifNUAsiOiJ6
	 DO6dYyv6HdlxSii6rKf4JRD4jKrEOU1CqCG6FE1BK1/ZkFDZ+xD12uYX5IgklfFM+L
	 R4ZADKUaux7vzAH/rJhf58OIJEor97X9IJoNjVlEjVxrMpylWzYmzPJdv2A+k8AcpN
	 T1nubdwKcwCBg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [GIT PULL] Core MM fixes for 7.4-rc5
Date: Fri, 27 Nov 2026 09:59:25 +0100
Message-ID: <20261127085928.3630-1-david@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 786DF4000B
X-Stat-Signature: d83xjmawbwhe97se34uqzpfs454u9w8z
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-28.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795769975-604000
X-HE-Meta: U2FsdGVkX1+5mm9ubkCrXsNE3dnfaNMyXapkHEfv5RjuC9EoZsSfpUCIzagk+l3qdKVl3wc4GeWEc6TJn0oGXHAfCQ2dOUFPeIcvWC/4dlmjRYZ6lmFXwZMLr+Nj/TyBfEcZSDtY4wYoQUeHg7rwlcdc7muzZccTjG2Lxq83zmtjmbZKHnNruqt1ntCWi/OqZir+VV3+Ysl5TA31ykh3v9sj0rGUGg1uyK5IFNfr17VFJ3iT2XyX1yuevuUe6+uvvUNl2VTBdSqPJnlmELPdMjLOmUJ16tmS4OTr4VRT0L72hoqc7GWhMgOqVS/8AsFsfxhxYTTU2oA6BdCbxasIwb45F4RmCdOcGkxNWY5CREg6FqAy60vAO3blvlkZajw4gkots6aZK+lqFzdggE+ztMyc9BBK/oa7BcA40vWa04B5RPl1KafToYqV74OADyBxeJgEop7QUWQj0poJhYP7fedGeHlJPoYE8r9xvK16XTVkILHfHh1/SIwHmCeYiFXdnNyMHeS/QGfG1W88BW77YGs991o7y4Y74aGlBSmwqLGdxJuwK20W0JNay0BFCy1yRJyKgoeQtlsi4kCyuGq71KUN2XqTeKsep5O6CQxNXp7gae7+ONYldHjHUs+oZBMBR09kwlhFssYEfvBGchTKghtlcWojLwjOfCZ5hl7ZH+3L22ZjCuVm6HbFo/KqpKkT+h/xhnjSkXZ+GfFrAWuqM2E/6+qaX8lkwjMCHrgQw+A643jaNVZXo7Zq6OM1MQ4uggJFtrIhruF/B/RdU8ucLXO8/yvH0y4VHB6mwnQwK/qLflhGGUL0zOXCSY1Y42TJd7MmzLjIy23mw/++kDzN51y/ZSE1wvghpm6rwMYpNl3IeSPaJG/lOEHyC0umSLBbJ56xMCs4GmgzDJnQNN7P+GWB3PxdUySxcwumpbedYEPGXXYA33T0HFaqlJd7AHr5ms1KcRPt1s8jngrxNDf
 YrkPzV3j
 oEGttO1LuMLLeDtKMu8W8sGV1Vhk7eBSfZ6dgm94JaWpIBnI1gwD/LBInO8Z0XdfbqejbLrzjtYDb42qF0xsEhuZnQbT9cEzu0hEnVjQ224Ye3UM3Dwwatxpva1faUejOGdz71LYqsQlOzQStArrUR+rAf2f+3edK76t/OY8V5MDTtCsr91gcN/RtfqVhL8prD4v0LnPxH0MW0xsHS5rFL5lvUsGnzYeHjADvSnvgDN1PkUvP9IRxb4m71+jH96d5ufTtsSTih0CUtiIa8lna97/n/ht+tDlMFjOGK3lBD6feULfWx6dRJu0ohQAYJ/K3qmB8nX2myB/+Xe0T/Iexkp4FjRlms6/fWvlikf75DvWRZbapVwNr1TGdh5ARrfpSz4QUe7GCPsWe3R60V1IUj8y6s7HoVPN4DE6DSuyBBB5eyxuKy1M4vLQdRiOJxOBOf6+yU/f6VHMXVJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Linus,

please pull these core-MM fixes for 7.4-rc5.

Two hotfixes and a bunch of fixes for other nasty issues we found that
I want to have fixed sooner rather than later. All got a couple of days
in -next after proper review, which is why I am rather late this week.

Cheers,

David

----------------------------------------------------------------

The following changes since commit b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f:

  Linux 7.4-rc4 (2026-11-22 14:57:40 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc5

for you to fetch changes up to 450bf6e1e7ece7ea8c0253886a01c663ea7bcc1b:

  Merge patch series "mm: fix deadlock on the folio lock when migrating and splitting folios" (2026-11-24 08:58:32 +0100)

----------------------------------------------------------------
Core memory management fixes for 7.4-rc5

This includes fixes to:

 - THP (Transparent Huge Pages)
 - MIGRATION
 - SHARED MEMORY
 - MADVISE
 - RECLAIM
 - Core MM

The main changes are:

 - Fix deadlocks on the folio lock when splitting folios and when
   migrating folios, triggerable by unprivileged users.

 - Fix lost writes and stale reads due to stale TLB entries with delayed
   rmap handling on UP, when zapping dirty file PMDs, when installing
   CoW'ed folios, and when reclaim does not write back a dirty folio.

 - Fix various MADV_FREE issues that can lead to data loss or exposure
   of stale swap content.

 - Fix various issues with device memory migration, including
   use-after-free of the anon rmap, out-of-bounds array accesses and
   oopses after migrating KSM folios.

 - Fix a use-after-free of the mm when copy_process() fails.

 - Fix a NULL pointer dereference in the shmem huge shrinker and data
   loss with failed swap writes in shmem.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

----------------------------------------------------------------
Chris Mason (3):
      fork: clear p->mm when copy_process() fails
      mm/migrate_device: fix ksmd oops on a migrated KSM page
      mm/shmem: don't use the memcg of an uncharged folio

Daniel Wade (1):
      mm/memory: mark unshare copies dirty to fix MADV_FREE data loss

David Hildenbrand (Arm) (9):
      mm/mmu_gather: delay rmap removal on UP as well
      mm/huge_memory: flush dirty file PMDs before removing rmap
      mm/khugepaged: mark ptes dirty and soft-dirty on mTHP collapse
      mm: flush stale TLB entries before installing a CoW'ed folio
      mm/vmscan: flush deferred writable TLB entries before unlocking the folio
      mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
      mm/huge_memory: use NOFS when allocating while splitting folios
      mm/migrate: allocate destination folios before locking a batch
      Merge patch series "mm: fix deadlock on the folio lock when migrating and splitting folios"

Josef Bacik (4):
      mm/migrate_device: allocate THP deferred split heads
      mm/migrate_device: don't collect a range twice
      mm/migrate_device: don't let go of the fault page
      mm/migrate_device: look up fault folio after a split

Lorenzo Stoakes (ARM) (1):
      mm/migrate_device: fix use-after-free of the anon rmap

Mani Tofigh (1):
      mm/shmem: don't drop a folio whose swap write failed

 include/asm-generic/tlb.h |  16 ++----
 include/linux/migrate.h   |   1 +
 kernel/fork.c             |  15 +++++-
 mm/huge_memory.c          |  68 ++++++++++++++++--------
 mm/internal.h             |   1 +
 mm/madvise.c              |  65 +++++++++++-----------
 mm/memory.c               |  14 +++--
 mm/migrate.c              | 133 +++++++++++++++++++++++++++++++++-------------
 mm/migrate_device.c       | 105 ++++++++++++++++++++++++------------
 mm/mmu_gather.c           |   4 +-
 mm/shmem.c                |  45 ++++++++++++----
 mm/vmscan.c               |  12 ++---
 12 files changed, 321 insertions(+), 158 deletions(-)

