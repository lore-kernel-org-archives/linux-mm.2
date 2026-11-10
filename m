Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61FE0606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=MYI1Q0Ut
Received: by kanga.kvack.org (Postfix)
	id 66DEA6B05B7; Mon,  9 Nov 2026 22:52:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644246B05B8; Mon,  9 Nov 2026 22:52:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B156B05B9; Mon,  9 Nov 2026 22:52:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A7876B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:52:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B006F1A089A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:13 +0000 (UTC)
X-FDA: 85417836546.17.AA84E82
Received: from out28-219.mail.aliyun.com (out28-219.mail.aliyun.com [115.124.28.219])
	by imf25.hostedemail.com (Postfix) with ESMTP id C26CEA0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:52:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=MYI1Q0Ut;
	spf=pass (imf25.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.219 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282732;
	b=u11V4Dpu1IjnpFE+ZWpXSnJlG7H1nHraKmgcwhnlEIA/Z6NyrhO+ixxNnaSuoNIJE06cPF
	Kr+JGGiaeJJYflUy+vFLhx5mi/sa6RYuIGgxGLQqpwA7kQi2czdgS7S6H3O5aEFr+Y/X+Q
	Y4ygRrEW1RCuY4u0LfiJCQL8c3Ku9S4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xiaopeng.com header.s=default header.b=MYI1Q0Ut;
	spf=pass (imf25.hostedemail.com: domain of fangxy@xiaopeng.com designates 115.124.28.219 as permitted sender) smtp.mailfrom=fangxy@xiaopeng.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TsUCZE14JUqzvoVn8cOy7N5poFYy2E8OQkr7wMhqiZY=;
	b=rSQscFZgmYNplh4SeO7LSgS472Lb6wWUDMh1naEeU1qoZ7OmiQgSfRCZxAb3wLGHIN/JQu
	8q7/QT21MVxaqYINkko+rUr0L1Lg0/CgocOdcCrsZ9PFtn75Lhl+l9M11sExrW2vDue7JE
	CNOSA7NMLe1O1lZUwm8MJCh8kWvd7mI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1794282728; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=TsUCZE14JUqzvoVn8cOy7N5poFYy2E8OQkr7wMhqiZY=;
	b=MYI1Q0UtqIAt2Q1fKScLEzhMj1O/rKYvHLaBWlGJ0YdnbiXpPtqkQZeAaCLjvSAyFmi+/8lPzcDXfPDS1EkfUTIJB+1qp26PaenEJ7m4JALkvIEE7AeJKKfZjJyqqotxW+qhadoDbJkFrHRwsj9BhNL5Xf7oFfdWb6XFMlyjymI=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.04436259|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0212176-0.000354597-0.978428;FP=14696213412212959218|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033023087102;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=27;RT=27;SR=0;TI=SMTPD_---.k-eCFj6_1794282725;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.k-eCFj6_1794282725 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:52:07 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Carlos Maiolino <cem@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/3] mm: enable filesystem page-cache large folios without THP
Date: Tue, 10 Nov 2026 11:52:02 +0800
Message-ID: <20261110035205.3036-1-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqqts7u9xwqg4t93be1hra79wpia3nad
X-Rspamd-Queue-Id: C26CEA0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794282730-686118
X-HE-Meta: U2FsdGVkX1/WKlHkvO4ry9/gJRAcI+5kOP72WPqvT2TNj/ec20wNL/ugo0uXbH24q/puoqkgF2WysmW2qG8zCrMYQ3EscwF6rPXeVkl+dx5ZknKC1C2hAmNgk+l49xutjBxzLmNeo+qiRA9D0HqKnGBn5ISAdNUHilDh2YScrlu1fPMfS9l9Fn9q9u9iJ2pQEkpeq310I8lUW5Bt5ftBKY0id2YNXKl4CsXtW9IAzzjfQs6u6G5A+05hRqFEhQzZUIngInu/ZJor9TsDtdMKKobbOqwWgpaALhEWPlsYKX/+YEJ6zd5W7zA6N5/zcX40pJdQJfXVVdGzUwGgTyxWEphkYQhsgbc3WgPFUaMfxehZ5R7P/VEubBK6S7ab35wRNvbS79swDOAXUV0rD1qPj81RuO0BUUoKbrvnzvPdVQ+vIMzrng7usgxBvdv80flMONBqwEny981ymYqpEFV+8VFVfANncUBPv7vkM6ZJH+LGRkeTu4UnBpA1ZXtdbNhQM8+1o1uHQygqeOo0KRy4sTjLQAOemZcUcWCzBrROF/RmsAwm/3+3V8BPxu/3D566oflMbHFo/tN9nt6J1geMLCFFlmTOO9Fva3p0WhWS+hgXFlgdeYOT0+ozPhAKF14EU1GIsnaqeurG+X7KhDlaRVgyBFYg9RGl46twGEhfAxJtXObKDhGjaqiIcT9K4KY26Mo/OEeK6mLhujxYIEntfk3NDet4kMFK+CBMkP/8Qlc03QZSE10LQtl+W+aWj4243RPMxM3OyQ7umm3RuIokrHP1oud5HClDaQYgLFd8Gp4JNFZ82M9mgk9Ndab9laML6OP6wuWT/aDBV+kPKFMbbzkeaXHWGZuHyQuLZPKzn0e4DIEIMvGhTg+FfD96rc0n0BSYupG/ALNVT+HhoQjZ3MouLmJI3ZKVtZCdwka5WrX4u6x3RneDSvn5cB09LehdBJ47u+aq7ez71ufiDXC
 ebWcQk8m
 ykcgPK+ha3umDI+LZAW4I874uUspbRt9+bDoCeBY4ZY2YgXNGQfaeaEiT0hAQoky6rJVzG1NMGFa66X/aNk0EGl2Q/cIGTE2PpD79gcJmliKF9qhwwjynFGLqoGbda5W1EaWq7b0lzv36YjyRQCeBlhbjM/vNBzdO1WntnP0rSIQWOAnUL2ZrvcOgxJYev2uUeh1E2GWaf/WuvF29oMux6kedIqowFJ3KsLVG1RuHVxmtUPG/vgxyo41OulKodhw81qeki79gV0ByS8Ci7TAwzrqLKbZHmoDwJJ6i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series makes filesystem page-cache large folios work on kernels
built with CONFIG_TRANSPARENT_HUGEPAGE=n, and keeps them splittable
there.

1. Why this is needed

TRANSPARENT_HUGEPAGE depends on !PREEMPT_RT (mm/Kconfig), so a
PREEMPT_RT kernel always has THP off.  Today that also removes
file-backed large folios entirely: the helpers that split them live in
mm/huge_memory.c under CONFIG_TRANSPARENT_HUGEPAGE, and the order
accessors in include/linux/pagemap.h short-circuit to "no large
folios" when THP is off, so every filesystem that opts in silently
ends up with order-0 folios.

The consequence is not only throughput.  XFS allows block sizes up to
64K and fs/xfs/xfs_super.c refuses to mount anything larger than
mapping_max_folio_size_supported().  With THP=n that helper reports
PAGE_SIZE, so a 64K-block filesystem cannot be mounted at all:

    XFS (vda): block size (65536 bytes) not supported; Only block size (4096) or less is supported

There is no degraded mode to fall back to, because a block has to fit
in a single page-cache folio - which is why
fs/xfs/libxfs/xfs_ialloc.c derives min_folio_order from
sb_blocklog - PAGE_SHIFT.  Either page-cache large folios work without
THP, or the filesystem is unusable.

2. What the series does

The anon and file split helpers were already separated by Kairui
Song's "mm/huge_memory: clean up and decouple the anon and file split
helpers" (v6 04/17, in mm-unstable); that is the base this series
starts from.

1/3 moves the folio-splitting implementation out of mm/huge_memory.c
into mm/folio_split.c without changing any behaviour.  The new object
is still built by CONFIG_TRANSPARENT_HUGEPAGE, so a THP build keeps
exactly the code it had before; a pure move is also the easiest thing
to rebase on top of further churn in this area.

2/3 builds that object for CONFIG_LARGE_FOLIO instead, and drops the
anon, PMD and khugepaged dependencies a file-only build cannot have.
The symbol comes from Matthew Wilcox's "[PATCH v9 12/15]"; if that
series is in first, this patch shrinks to its Kconfig default and the
accessors it already rewrites.

3/3 enables filesystem page-cache large folios when THP is off.  It
lifts the compile-time short circuits in pagemap.h for
mapping_max_folio_size_supported(), mapping_set_folio_order_range(),
mapping_max_folio_order() and mapping_min_folio_order().
PREFERRED_MAX_PAGECACHE_ORDER is left alone: an LF-only build keeps
the existing cap of order 8 instead of following HPAGE_PMD_ORDER.
Without THP such folios cannot be PMD-mapped, so raising the ceiling
would mainly increase the maximum page-cache allocation size.  The
changelog has the arm64 64K-page arithmetic, which is a calculation
and not a measurement.

The split side is not rewritten: truncate, migration and memory-failure
already call the helpers outside any THP ifdef, so with 2/3 in place
they simply stop resolving to the -EINVAL stubs once 3/3 turns
allocation on.  madvise is inside a THP ifdef and does not take part.

3/3 also makes the XFS mount failure above say why it failed: when
CONFIG_LARGE_FOLIO is not set, the warning now names the missing
option instead of only reporting the block size as unsupported.  With
LF=y the added warning is compiled out completely.

3. Testing

Six configurations build clean as full kernels, bzImage and the
vmlinux link included, with no new warnings: A (THP=y), B (THP=n,
LF=y), C (B plus HUGETLBFS), D (THP=n, LF=n), and RT-B and RT-C with
PREEMPT_RT=y.  The PREEMPT_RT configurations were build-tested only.
No runtime PREEMPT_RT stress test or livelock validation was
performed.

THP=y is unchanged: the .text sections of mm/filemap.o,
mm/readahead.o and mm/shmem.o are byte-identical before and after the
series (md5 equal, 45896, 7139 and 35314 bytes).  With THP=n and LF=n
mm/filemap.o and mm/readahead.o stay identical (44584 and 6259 bytes)
and every function in mm/shmem.o keeps its size; the only difference
there is one dead argument load that the folded-out
mapping_set_large_folios() call leaves behind, so the section keeps
its 29778 bytes while its md5 does not match.

In the new LF=y, THP=n configuration mm/shmem.o keeps its size as well,
48 bytes shorter at 29730.  That difference is not from 3/3: 40 of the
bytes are shmem_writeout(), which shrinks because 2/3 turns
split_folio_to_list() from an inline -EINVAL stub into a real call, and
the other 8 are the padding in front of the following function; the
same 29730 bytes appear with 2/3 alone, and 3/3's own shmem hunk
changes no function size.  The new call is unreachable in this
configuration anyway, since shmem_alloc_and_add_folio() still forces
order 0 without THP.

Where the generated code really changes is the allocation policy:
mm/readahead.o grows by 880 bytes of .text (6259 to 7139) and
mm/filemap.o by 134 (44584 to 44718).  nm -u mm/folio_split.o lists no
anon, pmd or khugepaged symbols.

Runtime, x86_64, 4K pages, THP=n, QEMU/KVM, on a 64K-block XFS image
(mkfs.xfs -b size=64k -s size=4k), with kprobes on
filemap_alloc_folio, filemap_add_folio and __folio_split:

  - writing 64M: 84 allocations - 59 at order-8, 5 at order-7, 5 at
    order-6, 5 at order-5, 10 at order-4, i.e. exactly 64M;
  - reading the same 64M back after drop_caches: 72 allocations,
    62 at order-8, 1 at order-7, 5 at order-6, 4 at order-4;
  - truncating 1M to 700K: one __folio_split, landing at order-4,
    which is the min_folio_order XFS asked for; order-0 never appears
    in any of the three phases;
  - tmpfs writing 32M: 8192 shmem_alloc_folio calls, all order-0;
  - shmem write vs F_SEAL_GROW, reproducible as: memfd_create(),
    ftruncate() to exactly 4096 bytes, F_ADD_SEALS with F_SEAL_GROW,
    then a single pwrite() of 8192 bytes at offset 0, comparing the
    syscall's return value.  It returns 4096, the same as the
    pre-series THP=n kernel.  A THP=y kernel returns -EPERM here, and
    so did the LF-only build before shmem's mapping was put back
    behind THP; that -EPERM is pre-existing behaviour of THP kernels,
    this series neither introduces it nor extends it to other
    configurations.

Same image on the pre-series kernel, for reference: it fails to mount
with -ENOSYS before any of the above can run.  The whole probe was
re-run on the final revision of the series with identical numbers.

4. What this turns on for existing filesystems

LF=y makes the existing opt-in take effect for every filesystem that
already asks for large folios, and that list is not ext4 only: ext4,
xfs, btrfs, f2fs, fuse, afs, erofs, nfs, cifs and zonefs all call
mapping_set_folio_order_range() or mapping_set_large_folios() from
their inode or superblock setup, unconditionally, today.  Those paths
run on any THP=y kernel; the new configuration is only THP=n with
LF=y.  With THP off the ceiling is PREFERRED_MAX_PAGECACHE_ORDER,
which stays at order 8.

On the tested 4K-page configuration, 4K-block ext4 gets min order 0
and max order 8, while 64K-block XFS gets min order 4.  Btrfs derives
both ends from the mkfs sectorsize and nodesize.  A THP=y kernel keeps
the order-9 ceiling (HPAGE_PMD_ORDER) it has today on 4K pages.

shmem keeps its THP dependency: its mapping is only marked large-folio
capable when THP is enabled, because shmem_alloc_and_add_folio() still
forces orders to zero without it.  This matters beyond cosmetics.
generic_perform_write() sizes its write chunk from
mapping_max_folio_size() and passes that length to ->write_begin()
before clamping it to folio_size(), and shmem_write_begin() rejects
pos + len > i_size for F_SEAL_GROW.  On a 4K memfd sealed with
F_SEAL_GROW, an 8K write at offset 0 returns 4096 on the pre-series
THP=n kernel and -EPERM on a THP=y kernel; advertising order 8 while
allocating order 0 reproduced the -EPERM on an LF-only build.  Tying
shmem's policy to LARGE_FOLIO means the allocation, swap and split
sides together, which is a separate series.

5. What is not covered

Since PREEMPT_RT is the motivation, the RT side needs to be explicit.
The freeze-to-xarray-update window in __folio_freeze_split_file() is
the fourth freeze site named by Matthew Wilcox in the RT livelock
thread started by Dong Hui
(<c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>):

    There's also __folio_freeze_split_file().  I know PREEMPT_RT
    disables TRANSPARENT_HUGEPAGE at the moment, but hopefully that
    restriction will be lifted.

This series does not fix that problem and does not claim to be
RT-safe.  It only makes a code path that already exists on THP kernels
reachable in a configuration that has no THP, which is the same
exposure Kairui described in 06/17 as "should be fixed generically".
One detail that may matter if a reader-side fix is chosen: the
function already holds the xarray lock until the folio is no longer
frozen and visible, since folio_ref_unfreeze() happens before
xas_unlock_irq(), so a generic fix of that shape would cover this path
without touching it.

Also not tested here: the migration, memory-failure and madvise split
entries at runtime (only truncate was exercised end to end), arm64
with 64K pages, nommu, KASAN and lockdep, xfstests, and the btrfs
order range.

6. Questions

(a) Non-THP split accounting.  count_mthp_stat() is a no-op without
THP, so in an LF-only build a file split updates no counter at all and
THP_SPLIT_PAGE does not even appear in /proc/vmstat.  I have a
follow-up patch that gives the file path its own counter.  Would you
rather see a new vmstat item, an existing one reused, or nothing?

(b) Should XFS select LARGE_FOLIO itself?  Three lines of
"select LARGE_FOLIO if MMU" in fs/xfs/Kconfig make 64K-block XFS
mountable on a THP=n kernel with no manual configuration; I built such
a kernel and mounted the 64K image.  The cost is mm/folio_split.o: 3.2K
of .text in a THP=n build, code that every THP=y build already carries,
paid also by XFS builds that will never use a block size above the page
size.  Kconfig cannot express "only when a 64K filesystem is mounted".
I left it out because it changes default coverage for a decision XFS
maintainers should make, but I can add it as 4/4 if that is preferred.

Comments welcome.

Fang Xieyan (3):
  mm: move folio split code into mm/folio_split.c
  mm: build file-backed folio splitting with CONFIG_LARGE_FOLIO
  mm: enable filesystem page-cache large folios without THP

 MAINTAINERS                |   1 +
 fs/xfs/xfs_super.c         |   2 +
 include/linux/huge_mm.h    |  60 ++-
 include/linux/page-flags.h |   5 +-
 include/linux/pagemap.h    |  17 +-
 mm/Kconfig                 |  19 +
 mm/Makefile                |   1 +
 mm/folio_split.c           | 969 +++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c           | 920 -----------------------------------
 mm/internal.h              |   1 +
 mm/shmem.c                 |  11 +-
 11 files changed, 1054 insertions(+), 952 deletions(-)
 create mode 100644 mm/folio_split.c


base-commit: b024a51b0184b1efb6f55b11aaf7b15a490a6307
-- 
2.50.1


