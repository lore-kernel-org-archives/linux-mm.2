Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 322F6606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FGGzPP+S
Received: by kanga.kvack.org (Postfix)
	id 22E0D6B00EF; Tue, 17 Nov 2026 22:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DF916B05B0; Tue, 17 Nov 2026 22:59:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CFAD6B05B1; Tue, 17 Nov 2026 22:59:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE8AE6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:59:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2FC421A065F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:59:39 +0000 (UTC)
X-FDA: 85446885678.02.37E86DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68E07C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:59:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FGGzPP+S;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794974377;
	b=iHz+7ZBZUmi0nYYwYRn7njj6un7fE6ogFFpLpf0llRjEcvRUhJvgV58Dm///k/vri4EseU
	CseJucJj7LLmd0l8qBcF1KY35oUaN+ft6pAQE0xbI753SXXFKm8Gm3pJnYSsLWeeNx3zGt
	4nWlK7I6k5URqOOTtbiPp3HhygWd5UM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FGGzPP+S;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794974377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XyHm8E6N2BxawANh+DTFxuHa3dV/Ky8ta/U+foCe5G0=;
	b=mx8jpNSZmJHgUwpnycBztwKJDK2dl0PXb2exNio77CDys2z0fvCcUPVfspX33E3WFfNLNp
	kDHPMSWsNCwmbgR+nN3mw63GcP4/b23L/a8GOyWGR9ZsNJINfHkVAXPOdNm8iayhh6dJC6
	O4y0sXXOO2neqEeqPqxt+iTU0Se2dPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6F2A609FF;
	Wed, 18 Nov 2026 03:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD361F000C9;
	Wed, 18 Nov 2026 03:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794974376;
	bh=XyHm8E6N2BxawANh+DTFxuHa3dV/Ky8ta/U+foCe5G0=;
	h=Date:From:To:Cc:Subject;
	b=FGGzPP+SEtRVhRTpBqGTZyW/9L7mrJiWNJ7j1osbATyqNtc/Z3sMU7PGu47jqM4NB
	 lA8uYRC31QY9Skm9aV4rS0caF32Q2NgVnHwij9RHIAWFM2GzHG+Nk78snqHZYfM6Dt
	 8UjvKLlWVrEK4Da8ZqaT5jjgIjb429jIwpaj3+qY=
Date: Tue, 17 Nov 2026 19:59:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@kernel.org>
Subject: [GIT PULL] MM hotfixes for 7.4-rc4
Message-Id: <20261117195935.25bd098c3a99c1331c6ffc01@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ebz79jwgdao7isscbhhkqgbqx5x4bcmn
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68E07C0005
X-HE-Tag: 1794974377-377422
X-HE-Meta: U2FsdGVkX1/sjopI6g9oacbM/DkdF8dFg1o6H9TcOq7UMS7N2oCV88wBuMsxrdIuoVobndG/DtjgtXua0Q/NiKNisM12kRWAP+k0lPHuneSHdhq6E9Wg5gYJMKTnsS52lD9FHjZCrxm1vsJUiKTvXC70nFBY/3gcq1OV1cJUDdNqxwNl2eRKkDeIzcOZzf/7wGFZNhaT549ux+IE7FCipX9QAGcfBjP8uvBrEE7ua5NB5FwHG6eeWTgziIwD37vaq0xzTc+R6Urs6ZniOuB1s+MYW1jyIua6Xmp8UrXql9jPy3nQ2y+ntiPJLkuZ3VuJ2LCDorLuBAQQSrfpg6JUKm3GXWE/dGpxNMU+13qptF8IOom1w0I6aXfjrgIz+4t2YoLBnyy5ZSiezQYaKjGZEIHR/HPKeUTUWpqn4pnF9zCvjhPHWqqpOXgEUJyXGNXQW7FIvq62i89aKu3XEsoNb3DWcNMVL0XwBJnrBLBVZxA5qONvEWTtML5e+2HDcKKpQYnSHKnMCYw1qIokF13lAIW2/JGd5+IKTOw5tvtQ1+mcbzIoDf+RZOBr6mGfDMcXUIp8p+9HE7Ysn0D5fNMo6lvPwbfqgnjoxEZNSw2zkyzfUHrR3KUlKr0bezRmsNh0uCL2qerhu/SlqSdwwpLS3FPr93xTWdlYwrlJa0vfZv1izGD7HOpUJ6kAj7v13JnPKb0EJ1cQDQsrvGNyckzVZJXzs2kAEkVwFTGqOp3u7MkdAm4S7ZBzz16UYRdq413F3KoUaUuZHVSzF3JZE2lzNDd2eK6isgedpx3MHNfuzMMqJG3kKUcayo2paLYxxDFcQad6WQAn2EEDn1DJ9ur+caxCreL8xMAug6C2enOHerlbDABBheHi++Lr8aBQlEHjEEVa9MJR2MLVcFrVskuuJufJHvje5yDYPCv0AxYHkIA03f4B/DJVwmQCA1DQi8LkyOHAjGwVPAIUYce5YbQ
 uvYSNRB+
 oE2hlnVe1HoAdcZuyjR1BXUtWN20gcDpIBvFhW2+DcXuj9cxpW+9Dfrm7nzThzx2jtAfqINdA/CFJyjjS3ECGIjU557YtMQ7037oFmUJ5OgKG7+1VYzhizI/YJr2ncK4AUa8EncJRfBH2//9VWv9Wz/J/APN6UevsSLpSQL4Xv873g3ifeKUFv8fmU2jdV0S2Pnsxpu5ju1ATdQbg6DT/yIR5K7WWETHjiWy3aVach0gBYbKrpqIxHnfe/TLPderJN8U9RZWKzMu6S5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Linus, please merge this batch of MM hotfixes, thanks.


The following changes since commit fa4ad798f6f681031775266044ba1b0cf3c670bd:

  Merge tag 'for-7.4-rc1-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux (2026-11-07 13:52:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-17-19-55

for you to fetch changes up to a4e667346a8d91e629a2ca9affc70dc28978f4a1:

  xarray: fix index jumping backwards in xas_find() (2026-11-09 22:44:31 -0800)

----------------------------------------------------------------
mm.git review status for linus..mm-hotfixes-stable

Everything:

Total patches:       27
Fixes: tags:         26
cc:stable patches:   23
Reviews/patch:       1.63
Reviewed rate:       81%

Summary of patch series in this merge:

- "maple_tree fixes for 7.3" (Liam R. Howlett):

  Fix an RCU reader NULL dereference when the tree is emptied during
  a walk, including /proc/PID/maps racing with munmap(). Add tests
  and make debug WARN and BUG checks report failures properly.

- "mm/kasan: Detect double-free involving kfree_rcu_sheaf()."
  (Kuniyuki Iwashima):

  Detect double-free when an object enters an RCU sheaf. KASAN could
  previously miss it until the object was reused, leading to a later
  free of a live object. Add KUnit tests for the different free orders.

- "mm: Fix page-table teardown during memory hot-remove"
  (Muchun Song):

  Balance page-table constructors and destructors when hot-remove
  frees tables on x86-64, RISC-V and arm64. This fixes NR_PAGETABLE
  accounting for tables with and without constructors.

- "mm/damon: fix watermark state, kunit pid leak and selftest fake pass"
  (SJ Park):

  Recompute watermark wait state when DAMON schemes are removed, so
  kdamond resumes monitoring. Fix a pid reference leak in KUnit and
  a selftest that reports a skipped run as a pass.

Summary of the 15 singletons in this merge:

An XArray iterator could step backwards when a large page-cache entry
was split, sending filemap_map_pages() outside the PTE page it locked.
The XArray correction and a filemap bound check prevent out-of-bounds
accesses and use-after-free. Another XArray fix prevents lockless
walkers from following a parent pointer into a freed node.

Userfaultfd now validates the whole write-protection range before
changing any VMA, avoiding partial unprotect without waking blocked
faults. Failed unmaps now abort queued UFFD_EVENT_UNMAPs; previously
they could report a nonexistent unmap, leak the userfaultfd context
and leave later operations returning -EAGAIN. A fork fix clears stale
uffd PTE bits if the new context is released before its event is read.

Moving the hugetlbfs inode trace event before RCU freeing avoids a
use-after-free of its superblock. Shmem swapin no longer retries
forever on reused swap slots containing a mismatched large swap-cache
folio. Swapoff also avoids a cluster-list loop that can soft-lock
reclaim and leave swapoff hung.

Weighted interleave recalculation now uses one node set throughout,
avoiding a divide-by-zero during memory hotplug. Hwpoison holds the
folio lock when inspecting its mapping and no longer leaks a folio
reference; it also updates poison statistics before notifying
rasdaemon through a trace event.

Cross-node migration now moves NR_FILE_THPS and NR_KERNEL_FILE_PAGES
with page-cache folios, preventing per-node and memcg-node accounting
from retaining stale counts or underflowing after the folios are freed.

----------------------------------------------------------------
Andrew Morton (1):
      mm/mempolicy: use one node set for interleave weights

Aveline Noir (1):
      mm/damon/core: reset watermark wait state on each iteration

David Hildenbrand (Arm) (1):
      mm/memory-failure: fix folio refcount leak and min_order_for_split() locking

Joas Antonio dos Santos (1):
      hugetlbfs: move hugetlbfs_free_inode tracepoint to ->destroy_inode()

Jose Fernandez (Anthropic) (1):
      mm/filemap: stop fault-around when the walk steps back

Krystian Kaniewski (1):
      xarray: fix index jumping backwards in xas_find()

Kuniyuki Iwashima (2):
      mm/kasan: detect double-free involving kfree_rcu_sheaf()
      mm/kasan/kunit: add double-free tests involving kfree_rcu_sheaf()

Liam R. Howlett (Google) (3):
      maple_tree: fix rcu reader NULL dereference after the tree is emptied
      maple_tree: test emptying tree while RCU reading
      maple_tree: update internal warning and bug_on code

Lorenzo Stoakes (ARM) (1):
      mm/vma: read anon_vma carefully in validate_mm()

Mani Tofigh (2):
      mm, swap: stop cluster list scans once swapoff clears SWP_WRITEOK
      mm/shmem: fix swapin livelock on a mismatched large swap cache folio

Mauro Carvalho Chehab (1):
      mm: memory-failure: update statistics before emitting the trace event

Mike Rapoport (Microsoft) (2):
      userfaultfd: clear uffd state in child PTEs if uffd is released during fork
      mm/vma: undo userfaultfd unmap preparation when unmapping fails

Muchun Song (4):
      mm: fix missing page-table destructor in pagetable_free()
      riscv/mm: fix hotplug page-table destructor handling
      riscv/mm: fix missing destructor for hotplug PUD tables
      arm64/mm: fix destructor for unconstructed hotplug page tables

Nickolai Zeldovich (1):
      xarray: clear the new head's parent before freeing the old head

Ridong Chen (2):
      mm/migrate: move NR_FILE_THPS on cross-node migration
      mm/migrate: move NR_KERNEL_FILE_PAGES on cross-node migration

SJ Park (1):
      selftests/damon/sysfs_memcg_path_leak: define ksft_skip

Umang Pokhriyal (1):
      userfaultfd: validate the whole range before changing write protection

Wang Xiaolei (1):
      mm/damon/tests/sysfs-kunit: fix leaked pid reference in add_targets test

 arch/arm64/mm/mmu.c                                |   3 +-
 arch/riscv/mm/init.c                               |  32 ++--
 fs/hugetlbfs/inode.c                               |   2 +-
 include/linux/kasan.h                              |  15 +-
 include/linux/maple_tree.h                         |  48 +++---
 include/linux/mm.h                                 |  39 ++---
 include/linux/userfaultfd_k.h                      |   5 +
 include/trace/events/hugetlbfs.h                   |   2 +-
 lib/maple_tree.c                                   | 120 +++++++++++----
 lib/test_maple_tree.c                              | 165 +++++++++++++++++++++
 lib/test_xarray.c                                  |  70 +++++++++
 lib/xarray.c                                       |  11 +-
 mm/damon/core.c                                    |   5 +-
 mm/damon/tests/sysfs-kunit.h                       |   9 ++
 mm/filemap.c                                       |   7 +
 mm/huge_memory.c                                   |   4 +
 mm/kasan/common.c                                  |  13 +-
 mm/kasan/generic.c                                 |  17 ++-
 mm/kasan/kasan.h                                   |  34 ++++-
 mm/kasan/kasan_test_c.c                            | 139 +++++++++++++++++
 mm/memory-failure.c                                |  67 +++------
 mm/mempolicy.c                                     |  13 +-
 mm/migrate.c                                       |  10 ++
 mm/shmem.c                                         |  16 +-
 mm/slub.c                                          |  13 +-
 mm/swapfile.c                                      |   5 +
 mm/userfaultfd.c                                   |  87 +++++++----
 mm/vma.c                                           |  62 +++++---
 tools/testing/radix-tree/maple.c                   |  13 +-
 .../selftests/damon/sysfs_memcg_path_leak.sh       |   3 +
 tools/testing/shared/maple-shared.h                |  33 +++++
 tools/testing/vma/include/stubs.h                  |   4 +
 32 files changed, 858 insertions(+), 208 deletions(-)


