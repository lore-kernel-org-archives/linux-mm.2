Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D265D2629E
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 21:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65C4B6B0005; Tue, 20 Jan 2026 16:11:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A526B0088; Tue, 20 Jan 2026 16:11:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D0E6B0089; Tue, 20 Jan 2026 16:11:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 435356B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:11:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B94415A39C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:11:29 +0000 (UTC)
X-FDA: 84353588298.05.D78D66A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 08059160004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:11:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QXxXb6bD;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768943488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jqcp2WFzeRglkASTmBPU84SmR5rrVWYWxJNuMxabWWw=;
	b=b5iq3SDyggJ7GAUH244XJMNajtBQZE/2MOc+mTeYIZxJA6s/WapPLWyXT+melUoY6uIuok
	9unh/SumJqrEdsLVmfYBk14bX3aMTlGoJ0CVMF6mvKIBFU5N8NBRaj6tM0Yq3Ip7HgZ0gs
	4yuxftNvIc4wBsAKxV1EtmB5nYhegXM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768943488; a=rsa-sha256;
	cv=none;
	b=qk5+oOYQLbrfeJI4F5NFcagQcTzH5KGoeci26orqHwwIQhDnOAaWXUzjOGmAqWoSIWRHi/
	IMAMRUi+WEN7bNnJKI91+ivBqb3WUbIMhJh3O84b4ZeLQXwiI3KyeT7kax5oN08Pv+gflF
	ye5a71lO3oBx4/0ay86XXl7JBwksDis=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QXxXb6bD;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6564C60007;
	Tue, 20 Jan 2026 21:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E635EC19422;
	Tue, 20 Jan 2026 21:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768943487;
	bh=zO1+9fWdrUgZan1uwLv79ojapf4loed4yuRWdNTOGq8=;
	h=Date:From:To:Cc:Subject:From;
	b=QXxXb6bDImBF6DTrm9sNTs+s+aQF+2+6b/VXPCYb/Zj6PxsytHkfn7GPom4YN06Wc
	 KRjiDl9X1Cp/kqz4eqllhUFpJjavlym/6Xp7vyUUcSyLub88TsowVV4YqEUmDvfnBj
	 xNwnV8xIs5VpWQRlXLpbGzJGTxD+hhWGEIr3w/M4=
Date: Tue, 20 Jan 2026 13:11:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] hotfixes for 6.19-rc7
Message-Id: <20260120131126.fcd6df1111d067948a8244c4@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08059160004
X-Rspam-User: 
X-Stat-Signature: yzkzc3b6e3fxannxhpkw9q94qf66pcer
X-HE-Tag: 1768943487-348650
X-HE-Meta: U2FsdGVkX19pn6L5csja1LB45K92QDaMTvpfMW2uLB7Cth9HNoGyz9VziLtjgou46FQhOT8GpBb/h47ePWkSQduvKuKg7KW1bTZJ/gfgNNPNBh+IRf/uSW6kSMBarO9erHmWcGRQHR1N1GbCC+36tG2jrNC3EC8GiXNcJGErZtF1DxskrSXy/jrhMB536q9ICXAoLXc1KbKhicKJWw6wi2bnDmgj37COprEVVVjQgha3yrfSrR/alFhS7yAd5eClA0LDjvqB64TOZOlyDpQE2D80hjDCP4E7os08RVHpIof7QKhqOFB80O64IHb17GW3UyAX3EoBaAzc3RhsaSZlv020ICWnrk9ua0iocxuWS1utTpONHgCDvr3Evs1iyE2EDalAM0kzapaIvZz3UR7R1U5XW619LiULtU3gVUnpJyIs0jweH7F4J3RCu7bo/5BCPv0+y9DIW3rKB/yjep82uX23XHL7dE63Sp3g9FPemMmDpLmtZNtwaF44Us4t+8PrwUqVzgf9K++MYi79KXpkOv/t+bWe1HAAZjZk/x+QoyjIwlUYg0Alw+GVgtCe/uUhZMyRgTzvIWhkMWOeeCbsmJhp+H+gKEy8vmU1UnHHt25S0T9B6/9sdYbWlMt/WXJ5iRT5BXYnIK1Kj41ptR4W0fcTkHS64rFBL3Ejoq3LT8OiO3Jh0egnOPpyN1hwT+Z18v7BycGletH6fk2rSlLRsz27eqx8lz10L5dCPeQqO38nAbnmigLaAl46G8cZdANJcwB5lMy6t4t38Zul+0rCdPySKDONDuP4ycFP3W+1BLcvegwC3LMaY6czI+b9NhEFsukVIiTqFN6LW3uhYuku5bd6hIqlzyukVp+kLmU3vo10v19Y53kSSxs9WE00i7H36gaRxPyHVbsPThC/gw3Ded8AVmmUxq3Eh3649pet8WTVb3UCCD4IUbYXUGQUj0+SZSFKlOpF1JrK5aWcBV5
 i2AnBgCQ
 efQ7j7m7Jvp7dYSyRKn9Zeoxh5CDWhUM4kh1Hji6FgDDW1jJvn4zK5NW75LG7w4f9GHojH+7RZA4m1HiUF4HVrbx67WcRlMoF6quZTuqkKDorn77hgS03H7QoGKpSs3FJFzTQMea3YTnZgoD8IrNjHLiCaKFmKk5bqa3+076XQzbVDdQrcJ1vAlXNluS0cAN0fLWLqaYKF4+Ea9T9uubO/shNnmRCYTCqKpE/9GyGbHRMrR+3V+u3rVtl4BUGZQy0VxqUgwGGGNGvEKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this batch of hotfixes, thanks.


The following changes since commit 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-20-13-09

for you to fetch changes up to 16aca2c98a6fdf071e5a1a765a295995d7c7e346:

  mm: restore per-memcg proactive reclaim with !CONFIG_NUMA (2026-01-20 09:34:27 -0800)

----------------------------------------------------------------
17 hotfixes.  12 are cc:stable, 16 are for MM.

- A 4 patch series from David Hildenbrand which fixes a few things
  realted to hugetlb PMD sharing

- The remainder are singletons, please see their changelogs for details.

----------------------------------------------------------------
Andrew Cooper (1):
      x86/kfence: avoid writing L1TF-vulnerable PTEs

Breno Leitao (1):
      mm/kfence: fix potential deadlock in reboot notifier

David Hildenbrand (Red Hat) (4):
      mm/hugetlb: fix hugetlb_pmd_shared()
      mm/hugetlb: fix two comments related to huge_pmd_unshare()
      mm/rmap: fix two comments related to huge_pmd_unshare()
      mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather

Gal Pressman (1):
      panic: only warn about deprecated panic_print on write access

Joanne Koong (1):
      fs/writeback: skip AS_NO_DATA_INTEGRITY mappings in wait_sb_inodes()

Lorenzo Stoakes (3):
      mm/vma: do not leak memory when .mmap_prepare swaps the file
      mm: remove unnecessary and incorrect mmap lock assert
      mm: do not copy page tables unnecessarily for VM_UFFD_WP

Mathieu Desnoyers (3):
      mm: add missing static initializer for init_mm::mm_cid.lock
      mm: rename cpu_bitmap field to flexible_array
      mm: take into account mm_cid size for mm_struct static definitions

Matthew Wilcox (Oracle) (1):
      migrate: correct lock ordering for hugetlb file folios

Suren Baghdasaryan (1):
      Docs/mm/allocation-profiling: describe sysctrl limitations in debug mode

Yosry Ahmed (1):
      mm: restore per-memcg proactive reclaim with !CONFIG_NUMA

 Documentation/admin-guide/sysctl/vm.rst   |   4 +
 Documentation/mm/allocation-profiling.rst |  10 +++
 arch/x86/include/asm/kfence.h             |  29 +++++--
 drivers/firmware/efi/efi.c                |   2 +-
 fs/fs-writeback.c                         |   7 +-
 fs/fuse/file.c                            |   4 +-
 include/asm-generic/tlb.h                 |  77 +++++++++++++++++-
 include/linux/hugetlb.h                   |  17 ++--
 include/linux/mm.h                        |   6 +-
 include/linux/mm_types.h                  |  19 +++--
 include/linux/pagemap.h                   |  11 +++
 kernel/panic.c                            |   4 +-
 mm/hugetlb.c                              | 131 ++++++++++++++++--------------
 mm/init-mm.c                              |   5 +-
 mm/internal.h                             |   8 --
 mm/kfence/core.c                          |  17 ++--
 mm/memory.c                               |  11 ++-
 mm/migrate.c                              |  12 +--
 mm/mmu_gather.c                           |  33 ++++++++
 mm/rmap.c                                 |  45 +++++-----
 mm/vma.c                                  |  11 ++-
 mm/vmscan.c                               |  13 ++-
 22 files changed, 341 insertions(+), 135 deletions(-)


